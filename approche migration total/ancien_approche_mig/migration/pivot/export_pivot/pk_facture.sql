 create or replace package body PCK_MIG_FACTURE_new is

  -- Private type declarations
  --********************************************
   procedure MIWT_FACTURE_AS400  is
  --********************************************
    err_code         varchar2(200);
    err_msg          varchar2(200);
    V_TRAIN_FACT     varchar2(200);
    V_REF_ABN        varchar2(200);
    v_mrel_ref       varchar2(20);
    v_ID_FACTURE     varchar2(20);
    tiers_           varchar2(1);
    six_             varchar2(1);
    anneereel_       varchar2(4);
    V_FAC_NUM        number;
    V_FAC_RESTANTDU  number;
    V_FAC_ABN_NUM    number(20);
    v_TVA            number;
    nbr_trt          number := 0;
    periode_         number;
    version          number(1):= 0;
    V_FAC_DATECALCUL date;
    V_FAC_DATELIM    date;
    date_            date;
  
  begin
    execute immediate 'alter session set nls_date_format = ''dd/mm/yyyy''';
    execute immediate 'alter session set NLS_NUMERIC_CHARACTERS = '',.''';
    --**************************************************
    delete prob_migration where
    nom_table in
    ('miwtfacture','SEQ_RELEVE','miwtfactureligne');
    insert into prob_migration (nom_table)values(SYSTIMESTAMP||'   START MIWT_FACTURE_AS400');
    COMMIT;
    V_FAC_NUM        := 0;
    /*select max(to_number(MFAE_REF))  
    into V_FAC_NUM 
    from miwtfactureentete ;
    COMMIT;*/
        for facture_ in (select * from facture_as400 ) 
        loop
            --V_FAC_NUM        := nvl(V_FAC_NUM,0) + 1;
              select SEQ_miwtfactureentete.Nextval into V_FAC_NUM from dual;
              
            -- reception de date Facturation
            select last_day(to_date('01'||lpad(facture_.refc03,2,'0')||facture_.refc04,'ddmmyy')) 
            into date_
            from dual;
            begin
                --Calcul de l'année réel (exercice réel)
                if(to_number(facture_.refc01)<to_number(facture_.refc03))then
                anneereel_ := '20'||facture_.refc04;
                else
                anneereel_ := '20'||to_char((to_number(facture_.refc04)-1));
                end if;
                select TRIM,tier,six
                into periode_,tiers_,six_
                from param_tournee p
                where p.DISTRICT=facture_.dist
                And p.m1 = facture_.refc01
                And p.m2 = facture_.refc02
                And p.m3 = facture_.refc03
                And (p.TIER,p.SIX) in (select t.NTIERS,t.NSIXIEME
                                       from tourne t
                                       where trim(t.code)=lpad(facture_.tou,3,'0')
                                       and trim(t.district)=trim(p.DISTRICT)
                                       and trim(t.district)=facture_.dist);
            exception
            when others then
                err_code := SQLCODE;
                err_msg  := SUBSTR(SQLERRM, 1, 200);
                insert into prob_migration
                (nom_table, val_ref, sql_err, date_pro,type_problem)
                values
                ('miwtfacture','Tourne '||facture_.tou||'M1 :'||facture_.refc01||'M2 :'||facture_.refc02||'M3:'||facture_.refc03,
                err_msg ||'-- periode ',sysdate,'erreur recuperation de periode -- tiers--six');
                periode_ := 1;
            end;

            V_FAC_RESTANTDU  := null;
            V_FAC_DATECALCUL := null;
            V_FAC_DATELIM    :=null;
            V_FAC_ABN_NUM    := null;
            
            begin
              --hkh 17/07/2017: Modification et ajout index
                select to_date(lpad(trim(DATEXP),8,'0'),'ddmmyyyy'),
                to_date(lpad(trim(DATL),8,'0'),'ddmmyyyy')   
                into V_FAC_DATECALCUL,V_FAC_DATELIM
                from role_trim
                where trim(facture_.Dist)= DISTR
                and to_number(facture_.pol)=POLICE
                and to_number(facture_.tou )=TOUR
                and to_number(facture_.ord)=ORDR
                and to_number(tiers_)= tier
                and to_number(periode_)= trim
                and to_number(six_)= six
                and annee = anneereel_
                and rownum = 1;
            exception
            when others then
                V_FAC_DATECALCUL := '01/01/2016';
            V_FAC_DATELIM := '01/01/2016';
                err_code := SQLCODE;
                err_msg  := SUBSTR(SQLERRM, 1, 200);
                insert into prob_migration
                (nom_table, val_ref, sql_err, date_pro,type_problem )
                values
                ('miwtfacture','Date facture  pol:'||facture_.pol||' tour:'||facture_.tou||' M1 :'
                ||facture_.refc01||' M2 :'||facture_.refc02||' M3:'||facture_.refc03||'A:'||anneereel_||
                ' ord :'||facture_.ord||' tier:'||tiers_||' trim:'||periode_||' sim:'||six_,
                err_msg ||'-- periode ',sysdate,'erreur de recuperation date de facture dans la table role_trim');
            end;
          

            if V_FAC_DATECALCUL is null then
              BEGIN
                 select (r.mrel_date + 7)
                  INTO  V_FAC_DATECALCUL
                       from  miwtreleve r
                       where r.mrel_refpdl =
                       lpad(facture_.DIST,2,'0')||
                       lpad(facture_.tou,3,'0')||
                       lpad(facture_.ORD,3,'0')||
                       lpad(facture_.POL,5,'0')
                       and mrel_refpdl is not null
                       and   r.annee = anneereel_
                       and   r.periode = periode_
                       And rownum=1;
               Exception  when others then
                       V_FAC_DATECALCUL := date_;
               end;
             V_FAC_DATELIM := '01/01/2000';--V_FAC_DATECALCUL;
            end if;
                -- reception de l'identfiant de l'abonnement
            V_REF_ABN := lpad(trim(facture_.DIST),2,'0') ||
                          lpad(to_char(facture_.pol),5,'0') ||
                          lpad(trim(facture_.tou),3,'0') ||
                          lpad(trim(facture_.ORD),3,'0');
            
            V_TRAIN_FACT :=  'ANNEE:'||trim(anneereel_) ||
            ' TRIM:'||trim(periode_) ||
            ' TIER:'||trim(tiers_)||
            ' SIX:'||trim(six_ );
            
            v_ID_FACTURE:=lpad(trim(facture_.DIST),2,'0') ||
            lpad(trim(facture_.tou),3,'0') ||
            lpad(trim(facture_.ORD),3,'0')||
            to_char(anneereel_) ||
            lpad(to_char(periode_),2,'0')||to_char(version);
            if nbr_trt=1 then goto xx;  end if;
            --hkh : 17/07/2018 : unitil 
            /*
            for ref_abn_ in (select *
                              from miwabn a
                              where substr(a.abn_refsite,1,13) = lpad(facture_.dist,2,'0') ||
                              lpad(facture_.tou,3,'0') ||
                              lpad(facture_.ord,3,'0') ||
                              lpad(to_char(facture_.pol),5,'0')
                             ) 
             loop
               V_FAC_ABN_NUM := ref_abn_.abn_ref;
            end loop; */

            --if V_FAC_ABN_NUM  is null then
            V_FAC_ABN_NUM := lpad(facture_.dist,2,'0') ||
                            lpad(facture_.tou,3,'0') ||
                            lpad(facture_.ord,3,'0') ||
                            lpad(facture_.pol,5,'0');
             --end if;
            -- Insertion de la facture
           /* if facture_.ctarif='21' then 
            facture_.tva:='0';    
            facture_.taxe:='0';  
            end if;  */         
            v_mrel_ref:=null;
            
            /* --hkh + mma : 09/07/2018 : post migration
            begin
            select r.mrel_ref into v_mrel_ref
            from miwtreleve r
            where substr(r.mrel_refpdl,1,8)=substr(v_ID_FACTURE,1,8)
            and  TO_CHAR(r.annee)=substr(v_ID_FACTURE,9,4)
            and lpad(TO_CHAR(r.periode),2,'0')=substr(v_ID_FACTURE,13,2);
            exception when others then
            begin
            select t.mrel_ref into v_mrel_ref
            from miwtrelevet t
            where substr(t.mrel_refpdl,1,8)=substr(v_ID_FACTURE,1,8)
            and  TO_CHAR(t.annee)=substr(v_ID_FACTURE,9,4)
            and lpad(TO_CHAR(t.periode),2,'0')=substr(v_ID_FACTURE,13,2);
            exception when others then
            v_mrel_ref:=null;
            end ;
            end;*/
          
           v_TVA:=(facture_.tva_ff+facture_.tva_capit+facture_.tva_pfin+facture_.tvacons+facture_.tva_preav+ facture_.tvaferm+facture_.tvadeplac+facture_.tvadepose_dem+facture_.tvadepose_def);
            begin

                insert into miwtfactureentete
                (
                MFAE_SOURCE      ,--1   VARCHAR2(100)  N      Code source/origine de la facture [OBL]
                MFAE_REF         ,--2   VARCHAR2(100)  N      Identifiant unique de la facture pour la source [OBL]
                MFAE_REFTRF      ,--3   VARCHAR2(100)  Y      Identifiant du train de la facture
                MFAE_NUME        ,--4   NUMBER(10)     Y      Numero de la facture [OBL]
                MFAE_RDET        ,--5   VARCHAR2(15)   Y      RDET de la facture
                MFAE_CCMO        ,--6   VARCHAR2(1)    Y      Cle controle RDET de la facture
                MFAE_DEDI        ,--7   DATE           N      Date d edition de la facture [OBL]
                MFAE_DLPAI       ,--8   DATE           Y      Date limite de paiement de la facture [OBL]
                MFAE_DPREL       ,--9   DATE           Y      Date de prelevement de la facture [OBL]
                MFAE_TOTHTE      ,--10  NUMBER(10,2)   N      Total HT EAU de la facture [OBL]
                MFAE_TOTTVAE     ,--11  NUMBER(10,2)   N      Total TVA EAU de la facture [OBL]
                MFAE_TOTHTA      ,--12  NUMBER(10,2)   N      Total HT ASS de la facture [OBL]
                MFAE_TOTTVAA     ,--13  NUMBER(10,2)   N      Total TVA ASS de la facture [OBL]
                MFAE_SOLDE       ,--14  NUMBER(10,2)   Y      Solde TTC de la facture
                MFAE_TYPE        ,--15  VARCHAR2(2)    N  'R'
                MFAE_REFFAEDEDU  ,--16  VARCHAR2(100)  Y
                MFAE_REFABN      ,--17  VARCHAR2(100)  N      Identifiant du contrat de la facture [OBL]
                MFAE_REF_CODNIV_RELANCE,--18 VARCHAR2(100)  Y Reference Code niveau de chainde relance
                MFAE_RIB_REF     ,--19  VARCHAR2(100)  Y      Reference Rib
                MFAE_RIB_ETAT    ,--20  NUMBER(1)      Y      Mode de payement (pr?l?vement 1 ou tip 2)
                MFAE_COMPTEAUX   ,--21  VARCHAR2(100)  Y      Compte auxilaire GENACCOUNT associe a la facture
                MFAE_REF_ORIGINE ,--22  VARCHAR2(100)  Y      Facture origine
                MFAE_COMMENT     ,--23  VARCHAR2(4000) Y      Commentaire libre Facture
                MFAE_AMOUNTTTCDEC,--24  NUMBER(17,10)  Y      Montant TTC a deduire
                VOC_MODEFACT     ,--25  VARCHAR2(10)   Y
                MFAE_REF_DEDUC   ,--26  VARCHAR2(100)  Y
                MFAE_REFORGA     ,--27  VARCHAR2(100)  Y
                MFAE_EXERCICE    ,--28  NUMBER(4)      Y      Exercice du role de la facture
                MFAE_NUMEROROLE  ,--29  NUMBER(4)      Y      Numero du role pour l exercice
                MFAE_PREL        ,--30  NUMBER         Y
                MREL_REF          --31
                )
                values
                (
                'DIST'||lpad(trim(facture_.dist),2,'0'),--1
                V_FAC_NUM            ,--2
                V_TRAIN_FACT         ,--3
                V_FAC_NUM            ,--4
                v_ID_FACTURE         ,--5
                NULL                 ,--6
                V_FAC_DATECALCUL     ,--7
                V_FAC_DATELIM        ,--8
                V_FAC_DATECALCUL     ,--9
                (facture_.net-(v_tva+facture_.arriere))/1000,--10
                v_tva/1000,--11
                0                    ,--12
                0                    , --13
                (facture_.net-facture_.arriere)/1000,--14
                'FC'                 ,--15
                NULL                 ,--16
                V_FAC_ABN_NUM        ,--17
                'INCONNUE'           ,--18
                null                 ,--19
                4                    ,--20
                'IMP_MIG'            ,--21
                null                 ,--22
                V_REF_ABN            ,--23
                NULL                 ,--24
                4                    ,--25
                NULL                 ,--26
                lpad(trim(facture_.dist),2,'0'),--27
                anneereel_           ,--28
                periode_             ,--29
                1                    ,--30
                v_mrel_ref            --31
                );
            exception
            when others then
                err_code := SQLCODE;
                err_msg  := SUBSTR(SQLERRM, 1, 200);
                insert into prob_migration
                (nom_table, val_ref, sql_err, date_pro,type_problem )
                values
                ('miwtfacture',
                lpad(facture_.dist,2,'0') ||
                lpad(facture_.tou,3,'0') ||
                lpad(facture_.ord,3,'0') ||
                lpad(facture_.pol,5,'0'),
                err_code || '--' || err_msg,
                sysdate,'erreur de confomité de type colonne');
            end;
--------------------------------------------------------------------------------------
--------------------------------------------------- LIGNE FACTURE CONSOMMATION SONNEDE
            if to_number(facture_.montt1) <> 0 then
                begin
                 insert into miwtfactureligne
                      (
                        MFAL_SOURCE    ,--1   VARCHAR2(100) N      Code source/origine de la ligne [OBL]
                        MFAL_REFFAE    ,--2   VARCHAR2(100) N      Identifiant de la facture de la ligne [OBL]
                        MFAL_REFTAP    ,--3   VARCHAR2(100) N      Identifiant de la periode de tarif de la ligne [OBL]
                        MFAL_REFART    ,--4   VARCHAR2(100) Y
                        MFAL_LIBE      ,--5   VARCHAR2(200) Y
                        MFAL_NUM       ,--6   NUMBER(4)     N
                        MFAL_TRAN      ,--7   NUMBER(1)     N  1   Tranche de la ligne [OBL]
                        MFAL_EXER      ,--8   NUMBER(4)     N      Annee exercice de la ligne [OBL]
                        MFAL_VOLU      ,--9   NUMBER(15,3)  N      Volume facture de la ligne [OBL]
                        MFAL_PU        ,--10  NUMBER(12,6)  N      P.U. facture de la ligne [OBL]
                        MFAL_MTHT      ,--11  NUMBER(15,2)  N      Montant HT de la ligne [OBL]
                        MFAL_MTVA      ,--12  NUMBER(15,2)  N      Montant TVA de la ligne [OBL]
                        MFAL_TTVA      ,--13  NUMBER(15,2)  N      Taux de TVA de la ligne [OBL]
                        MFAL_MTTC      ,--14  NUMBER(15,2)  N
                        MFAL_DDEBPERFAC,--15  DATE          Y      Date de debut de la periode facturee de la ligne
                        MFAL_DFINPERFAC,--16  DATE          Y      Date de fin de la periode facturee de la ligne
                        MFAL_DETAIL     --17  NUMBER        Y
                       )
                        values
                      (
                       'DIST'||lpad(trim(facture_.dist),2,'0') ,--1
                        V_FAC_NUM        ,--2
                        1                ,--3
                        'CSM_STD'        ,--4
                        'consommation sonede 1ere Tranche',--5
                        1                ,--6
                        1                ,--7
                        anneereel_       ,--8
                        facture_.const1  ,--9
                        facture_.tauxt1/1000,--10
                        facture_.montt1/1000,--11
                        facture_.TVACONS/1000,--12
                        18               ,--13
                        facture_.montt1/1000+(facture_.TVACONS/1000),--14
                        null             ,--15
                        DATE_            ,--16
                        null              --17
                       );
                exception
                when others then
                      err_code := SQLCODE;
                      err_msg  := SUBSTR(SQLERRM, 1, 200);
                      insert into prob_migration
                      (nom_table, val_ref, sql_err, date_pro,type_problem)
                      values
                      ('miwtfactureligne',
                      V_FAC_NUM,
                      err_code || '--' || err_msg,
                      sysdate,'erreur de confomité de type colonne');
                end;
            end if;

            if to_number(facture_.montt2) <> 0 then
                begin
                 insert into miwtfactureligne
                      (
                        MFAL_SOURCE,--1  VARCHAR2(100)  N      Code source/origine de la ligne [OBL]
                        MFAL_REFFAE,--2  VARCHAR2(100)  N      Identifiant de la facture de la ligne [OBL]
                        MFAL_REFTAP,--3  VARCHAR2(100)  N      Identifiant de la periode de tarif de la ligne [OBL]
                        MFAL_REFART,--4  VARCHAR2(100)  Y
                        MFAL_LIBE  ,--5  VARCHAR2(200)  Y
                        MFAL_NUM   ,--6  NUMBER(4)      N
                        MFAL_TRAN  ,--7  NUMBER(1)      N  1   Tranche de la ligne [OBL]
                        MFAL_EXER  ,--8  NUMBER(4)      N      Annee exercice de la ligne [OBL]
                        MFAL_VOLU  ,--9  NUMBER(15,3)   N      Volume facture de la ligne [OBL]
                        MFAL_PU    ,--10 NUMBER(12,6)   N      P.U. facture de la ligne [OBL]
                        MFAL_MTHT  ,--11 NUMBER(15,2)   N      Montant HT de la ligne [OBL]
                        MFAL_MTVA  ,--12 NUMBER(15,2)   N      Montant TVA de la ligne [OBL]
                        MFAL_TTVA  ,--13 NUMBER(15,2)   N      Taux de TVA de la ligne [OBL]
                        MFAL_MTTC  ,--14 NUMBER(15,2)   N
                        MFAL_DDEBPERFAC,--15  DATE      Y      Date de debut de la periode facturee de la ligne
                        MFAL_DFINPERFAC,--16  DATE      Y      Date de fin de la periode facturee de la ligne
                        MFAL_DETAIL --17 NUMBER         Y
                       )
                        values
                       (
                       'DIST'||lpad(trim(facture_.dist),2,'0'),--1
                        V_FAC_NUM         ,--2
                        1                 ,--3
                        'CSM_STD'         ,--4
                        'consommation sonede 2eme Tranche',--5
                        2                 ,--6
                        2                 ,--7
                        anneereel_        ,--8
                        facture_.const2   ,--9
                        facture_.tauxt2/1000,--10
                        facture_.montt2/1000,--11
                        facture_.TVACONS/1000,--12
                        18                ,--13
                        facture_.montt2/1000+(facture_.TVACONS/1000),--14
                        null              ,--15
                        DATE_             ,--16
                        null               --17
                        );
                EXCEPTION when others then
                      err_code := SQLCODE;
                      err_msg  := SUBSTR(SQLERRM, 1, 200);
                      insert into prob_migration
                      (nom_table, val_ref, sql_err, date_pro,type_problem)
                      values
                      ('miwtfactureligne',
                      V_FAC_NUM,
                      err_code || '--' || err_msg,sysdate,'erreur de confomité de type colonne');
              end;
            end if;

           if to_number(facture_.montt3) <> 0 then
                begin
                      insert into miwtfactureligne
                      (
                      MFAL_SOURCE    ,--1  VARCHAR2(100)  N      Code source/origine de la ligne [OBL]
                      MFAL_REFFAE    ,--2 VARCHAR2(100)   N      Identifiant de la facture de la ligne [OBL]
                      MFAL_REFTAP    ,--3  VARCHAR2(100)  N      Identifiant de la periode de tarif de la ligne [OBL]
                      MFAL_REFART    ,--4  VARCHAR2(100)  Y
                      MFAL_LIBE      ,--5  VARCHAR2(200)  Y
                      MFAL_NUM       ,--6  NUMBER(4)      N
                      MFAL_TRAN      ,--7  NUMBER(1)      N  1   Tranche de la ligne [OBL]
                      MFAL_EXER      ,--8  NUMBER(4)      N      Annee exercice de la ligne [OBL]
                      MFAL_VOLU      ,--9  NUMBER(15,3)   N      Volume facture de la ligne [OBL]
                      MFAL_PU        ,--10  NUMBER(12,6)  N      P.U. facture de la ligne [OBL]
                      MFAL_MTHT      ,--11  NUMBER(15,2)  N      Montant HT de la ligne [OBL]
                      MFAL_MTVA      ,--12  NUMBER(15,2)  N      Montant TVA de la ligne [OBL]
                      MFAL_TTVA      ,--13  NUMBER(15,2)  N      Taux de TVA de la ligne [OBL]
                      MFAL_MTTC      ,--14  NUMBER(15,2)  N
                      MFAL_DDEBPERFAC,--15  DATE          Y      Date de debut de la periode facturee de la ligne
                      MFAL_DFINPERFAC,--16  DATE          Y      Date de fin de la periode facturee de la ligne
                      MFAL_DETAIL     --17  NUMBER        Y
                      )
                      values
                     (
                     'DIST'||lpad(trim(facture_.dist),2,'0'),--1
                      V_FAC_NUM        ,--2
                      1                ,--3
                      'CSM_STD'        ,--4
                      'consommation sonede 3eme Tranche',--5
                      3                ,--6
                      3                ,--7
                      anneereel_       ,--8
                      facture_.const3  ,--9
                      facture_.tauxt3/1000,--10
                      facture_.montt3/1000,--11
                      facture_.TVACONS/1000,--12
                      18                ,--13
                      facture_.montt3/1000+(facture_.TVACONS/1000),--14
                      null              ,--15
                      DATE_             ,--16
                      null               --17
                      );
                exception
                when others then
                      err_code := SQLCODE;
                      err_msg  := SUBSTR(SQLERRM, 1, 200);
                      insert into prob_migration
                      (nom_table, val_ref, sql_err, date_pro,type_problem)
                      values
                      ('miwtfactureligne',
                      V_FAC_NUM,
                      err_code || '--' || err_msg,sysdate,'erreur de confomité de type colonne');
                end;
            end if;
    --------------------------------------------------- LIGNE FACTURE CONSOMMATION ONAS
            if to_number(facture_.mon1) <> 0 then
                begin
                      insert into miwtfactureligne
                      (
                      MFAL_SOURCE    ,--1  VARCHAR2(100)  N     Code source/origine de la ligne [OBL]
                      MFAL_REFFAE    ,--2  VARCHAR2(100)  N     Identifiant de la facture de la ligne [OBL]
                      MFAL_REFTAP    ,--3  VARCHAR2(100)  N     Identifiant de la periode de tarif de la ligne [OBL]
                      MFAL_REFART    ,--4  VARCHAR2(100)  Y
                      MFAL_LIBE      ,--5  VARCHAR2(200)  Y
                      MFAL_NUM       ,--6  NUMBER(4)      N
                      MFAL_TRAN      ,--7  NUMBER(1)      N  1  Tranche de la ligne [OBL]
                      MFAL_EXER      ,--8  NUMBER(4)      N     Annee exercice de la ligne [OBL]
                      MFAL_VOLU      ,--9  NUMBER(15,3)   N     Volume facture de la ligne [OBL]
                      MFAL_PU        ,--10 NUMBER(12,6)   N     P.U. facture de la ligne [OBL]
                      MFAL_MTHT      ,--11 NUMBER(15,2)   N     Montant HT de la ligne [OBL]
                      MFAL_MTVA      ,--12 NUMBER(15,2)   N     Montant TVA de la ligne [OBL]
                      MFAL_TTVA      ,--13 NUMBER(15,2)   N     Taux de TVA de la ligne [OBL]
                      MFAL_MTTC      ,--14 NUMBER(15,2)   N
                      MFAL_DDEBPERFAC,--15 DATE           Y     Date de debut de la periode facturee de la ligne
                      MFAL_DFINPERFAC,--16 DATE           Y     Date de fin de la periode facturee de la ligne
                      MFAL_DETAIL     --17 NUMBER         Y
                      )
                      values
                     (
                     'DIST'||lpad(trim(facture_.dist),2,'0') ,--1
                      V_FAC_NUM         ,--2
                      2                 ,--3
                      'VAR_ONAS_1'      ,--4
                      'Redevance onas 1ere Tranche',--5
                      4                 ,--6
                      1                 ,--7
                      anneereel_        ,--8
                      facture_.volon1   ,--9
                      facture_.tauon1/1000,--10
                      facture_.mon1/1000,--11
                      0                 ,--12
                      0                 ,--13
                      facture_.mon1/1000,--14
                      null              ,--15
                      DATE_             ,--16
                      null               --17
                      );
                exception
                when others then
                      err_code := SQLCODE;
                      err_msg  := SUBSTR(SQLERRM, 1, 200);
                      insert into prob_migration
                      (nom_table, val_ref, sql_err, date_pro,type_problem)
                      values
                      ('miwtfactureligne',
                      V_FAC_NUM,
                      err_code || '--' || err_msg,sysdate,'erreur de confomité de type colonne');
                      end;
            end if;

            if to_number(facture_.mon2) <> 0 then
                begin
                      insert into miwtfactureligne
                      (
                      MFAL_SOURCE,--1  VARCHAR2(100)  N      Code source/origine de la ligne [OBL]
                      MFAL_REFFAE,--2  VARCHAR2(100)  N      Identifiant de la facture de la ligne [OBL]
                      MFAL_REFTAP,--3  VARCHAR2(100)  N      Identifiant de la periode de tarif de la ligne [OBL]
                      MFAL_REFART,--4  VARCHAR2(100)  Y
                      MFAL_LIBE  ,--5  VARCHAR2(200)  Y
                      MFAL_NUM   ,--6  NUMBER(4)      N
                      MFAL_TRAN  ,--7  NUMBER(1)      N  1   Tranche de la ligne [OBL]
                      MFAL_EXER  ,--8  NUMBER(4)      N      Annee exercice de la ligne [OBL]
                      MFAL_VOLU  ,--9  NUMBER(15,3)   N      Volume facture de la ligne [OBL]
                      MFAL_PU    ,--10  NUMBER(12,6)  N      P.U. facture de la ligne [OBL]
                      MFAL_MTHT  ,--11  NUMBER(15,2)  N      Montant HT de la ligne [OBL]
                      MFAL_MTVA  ,--12  NUMBER(15,2)  N      Montant TVA de la ligne [OBL]
                      MFAL_TTVA  ,--13  NUMBER(15,2)  N      Taux de TVA de la ligne [OBL]
                      MFAL_MTTC  ,--14  NUMBER(15,2)  N
                      MFAL_DDEBPERFAC,--15  DATE      Y      Date de debut de la periode facturee de la ligne
                      MFAL_DFINPERFAC,--16  DATE      Y      Date de fin de la periode facturee de la ligne
                      MFAL_DETAIL --17  NUMBER        Y
                     )
                      values
                     (
                      'DIST'||lpad(trim(facture_.dist),2,'0'),--1
                      V_FAC_NUM         ,--2
                      2                 ,--3
                      'VAR_ONAS_1'      ,--4
                      'Redevance onas 2eme Tranche',--5
                      5                 ,--6
                      2                 ,--7
                      anneereel_        ,--8
                      facture_.volon2   ,--9
                      facture_.tauon2/1000,--10
                      facture_.mon2/1000,--11
                      0                 ,--12
                      0                 ,--13
                      facture_.mon2/1000,--14
                      null              ,--15
                      DATE_             ,--16
                      null               --17
                       );
                exception
               when others then
                      err_code := SQLCODE;
                      err_msg  := SUBSTR(SQLERRM, 1, 200);
                      insert into prob_migration
                      (nom_table, val_ref, sql_err, date_pro,type_problem)
                      values
                      ('miwtfactureligne',
                      V_FAC_NUM,
                      err_code || '--' || err_msg,sysdate,'erreur de confomité de type colonne');
                end;
            end if;

            if to_number(facture_.mon3) <> 0 then
                begin
                     insert into miwtfactureligne
                     (
                      MFAL_SOURCE,--1  VARCHAR2(100)  N      Code source/origine de la ligne [OBL]
                      MFAL_REFFAE,--2  VARCHAR2(100)  N      Identifiant de la facture de la ligne [OBL]
                      MFAL_REFTAP,--3  VARCHAR2(100)  N      Identifiant de la periode de tarif de la ligne [OBL]
                      MFAL_REFART,--4  VARCHAR2(100)  Y
                      MFAL_LIBE  ,--5  VARCHAR2(200)  Y
                      MFAL_NUM   ,--6  NUMBER(4)      N
                      MFAL_TRAN  ,--7  NUMBER(1)      N  1   Tranche de la ligne [OBL]
                      MFAL_EXER  ,--8  NUMBER(4)      N      Annee exercice de la ligne [OBL]
                      MFAL_VOLU  ,--9  NUMBER(15,3)   N      Volume facture de la ligne [OBL]
                      MFAL_PU    ,--10  NUMBER(12,6)  N      P.U. facture de la ligne [OBL]
                      MFAL_MTHT  ,--11  NUMBER(15,2)  N      Montant HT de la ligne [OBL]
                      MFAL_MTVA  ,--12  NUMBER(15,2)  N      Montant TVA de la ligne [OBL]
                      MFAL_TTVA  ,--13  NUMBER(15,2)  N      Taux de TVA de la ligne [OBL]
                      MFAL_MTTC  ,--14  NUMBER(15,2)  N
                      MFAL_DDEBPERFAC,--15  DATE      Y      Date de debut de la periode facturee de la ligne
                      MFAL_DFINPERFAC,--16  DATE      Y      Date de fin de la periode facturee de la ligne
                      MFAL_DETAIL --17  NUMBER        Y
                      )
                      values
                     (
                     'DIST'||lpad(trim(facture_.dist),2,'0')  ,--1
                      V_FAC_NUM         ,--2
                      2                 ,--3
                      'VAR_ONAS_1'      ,--4
                      'Redevance onas 3eme Tranche',--5
                      6                 ,--6
                      3                 ,--7
                      anneereel_        ,--8
                      facture_.volon3   ,--9
                      facture_.tauon3/1000,--10
                      facture_.mon3/1000,--11
                      0                 ,--12
                      0                 ,--13
                      facture_.mon3/1000,--14
                      null              ,--15
                      DATE_             ,--16
                      null               --17
                      );
                exception
                when others then
                err_code := SQLCODE;
                err_msg  := SUBSTR(SQLERRM, 1, 200);
                insert into prob_migration
                (nom_table, val_ref, sql_err, date_pro,type_problem)
                values
                ('miwtfactureligne',
                V_FAC_NUM,
                err_code || '--' || err_msg,sysdate,'erreur de confomité de type colonne');
               end;
            end if;

            if to_number(facture_.fixonas) <> 0 then
                begin
                    insert into miwtfactureligne
                    (
                    MFAL_SOURCE,--1  VARCHAR2(100)  N      Code source/origine de la ligne [OBL]
                    MFAL_REFFAE,--2  VARCHAR2(100)  N      Identifiant de la facture de la ligne [OBL]
                    MFAL_REFTAP,--3  VARCHAR2(100)  N      Identifiant de la periode de tarif de la ligne [OBL]
                    MFAL_REFART,--4  VARCHAR2(100)  Y
                    MFAL_LIBE  ,--5  VARCHAR2(200)  Y
                    MFAL_NUM   ,--6  NUMBER(4)      N
                    MFAL_TRAN  ,--7  NUMBER(1)      N  1   Tranche de la ligne [OBL]
                    MFAL_EXER  ,--8  NUMBER(4)      N      Annee exercice de la ligne [OBL]
                    MFAL_VOLU  ,--9  NUMBER(15,3)   N      Volume facture de la ligne [OBL]
                    MFAL_PU    ,--10  NUMBER(12,6)  N      P.U. facture de la ligne [OBL]
                    MFAL_MTHT  ,--11  NUMBER(15,2)  N      Montant HT de la ligne [OBL]
                    MFAL_MTVA  ,--12  NUMBER(15,2)  N      Montant TVA de la ligne [OBL]
                    MFAL_TTVA  ,--13  NUMBER(15,2)  N      Taux de TVA de la ligne [OBL]
                    MFAL_MTTC  ,--14  NUMBER(15,2)  N
                    MFAL_DDEBPERFAC,--15  DATE      Y      Date de debut de la periode facturee de la ligne
                    MFAL_DFINPERFAC,--16  DATE      Y      Date de fin de la periode facturee de la ligne
                    MFAL_DETAIL --17  NUMBER        Y
                    )
                    values
                   (
                   'DIST'||lpad(trim(facture_.dist),2,'0')  ,--1
                    V_FAC_NUM         ,--2
                    2                 ,--3
                    'FIXE_ONAS_1'     ,--4
                    'Frais fixe onas' ,--5
                    7                 ,--6
                    1                 ,--7
                    anneereel_        ,--8
                    1                 ,--9
                    facture_.fixonas/1000,--10
                    facture_.fixonas/1000,--11
                    0                 ,--12
                    0                 ,--13
                    facture_.fixonas/1000,--14
                    null              ,--15
                    DATE_             ,--16
                    null               --17
                    );
            exception
            when others then
                    err_code := SQLCODE;
                    err_msg  := SUBSTR(SQLERRM, 1, 200);
                    insert into prob_migration
                    (nom_table, val_ref, sql_err, date_pro,type_problem)
                    values
                    ('miwtfactureligne',
                    V_FAC_NUM,
                    err_code || '--' || err_msg,sysdate,'erreur de confomité de type colonne');
            end;
            end if;

           /* ---A Revoir
           if to_number(facture_.FRLETTRE) <> 0 then
                begin
                      insert into miwtfactureligne
                     (
                      MFAL_SOURCE    ,--1   VARCHAR2(100)  N      Code source/origine de la ligne [OBL]
                      MFAL_REFFAE    ,--2   VARCHAR2(100)  N      Identifiant de la facture de la ligne [OBL]
                      MFAL_REFTAP    ,--3   VARCHAR2(100)  N      Identifiant de la periode de tarif de la ligne [OBL]
                      MFAL_REFART    ,--4   VARCHAR2(100)  Y
                      MFAL_LIBE      ,--5   VARCHAR2(200)  Y
                      MFAL_NUM       ,--6   NUMBER(4)      N
                      MFAL_TRAN      ,--7   NUMBER(1)      N  1   Tranche de la ligne [OBL]
                      MFAL_EXER      ,--8   NUMBER(4)      N      Annee exercice de la ligne [OBL]
                      MFAL_VOLU      ,--9   NUMBER(15,3)   N      Volume facture de la ligne [OBL]
                      MFAL_PU        ,--10  NUMBER(12,6)   N      P.U. facture de la ligne [OBL]
                      MFAL_MTHT      ,--11  NUMBER(15,2)   N      Montant HT de la ligne [OBL]
                      MFAL_MTVA      ,--12  NUMBER(15,2)   N      Montant TVA de la ligne [OBL]
                      MFAL_TTVA      ,--13  NUMBER(15,2)   N      Taux de TVA de la ligne [OBL]
                      MFAL_MTTC      ,--14  NUMBER(15,2)   N
                      MFAL_DDEBPERFAC,--15  DATE           Y      Date de debut de la periode facturee de la ligne
                      MFAL_DFINPERFAC,--16  DATE           Y      Date de fin de la periode facturee de la ligne
                      MFAL_DETAIL     --17  NUMBER         Y
                      )
                      values
                     (
                     'DIST'||v_district ,--1
                      V_FAC_NUM         ,--2
                      1                 ,--3
                      'FRS_R_C_NN_PAY'  ,--4
                      'Frais lettre '   ,--5
                      8                 ,--6
                      1                 ,--7
                      anneereel_        ,--8
                      1                 ,--9
                      1.900             ,--10
                      1.900             ,--11
                      0                 ,--12
                      0                 ,--13
                      1.900             ,--14
                      null              ,--15
                      DATE_             ,--16
                      null               --17
                      );
                exception
                when others then
                      err_code := SQLCODE;
                      err_msg  := SUBSTR(SQLERRM, 1, 200);
                      insert into prob_migration
                        (nom_table, val_ref, sql_err, date_pro,type_problem)
                      values
                        ('miwtfactureligne',
                         V_FAC_NUM,
                         err_code || '--' || err_msg,sysdate,'erreur de confomité de type colonne');
                end;
            end if;*/

            if to_number(facture_.fraisctr) <> 0 then
                begin
                      insert into miwtfactureligne
                      (
                      MFAL_SOURCE     ,--1  VARCHAR2(100)  N      Code source/origine de la ligne [OBL]
                      MFAL_REFFAE     ,--2  VARCHAR2(100)  N      Identifiant de la facture de la ligne [OBL]
                      MFAL_REFTAP     ,--3  VARCHAR2(100)  N      Identifiant de la periode de tarif de la ligne [OBL]
                      MFAL_REFART     ,--4  VARCHAR2(100)  Y
                      MFAL_LIBE       ,--5  VARCHAR2(200)  Y
                      MFAL_NUM        ,--6  NUMBER(4)      N
                      MFAL_TRAN       ,--7  NUMBER(1)      N  1    Tranche de la ligne [OBL]
                      MFAL_EXER       ,--8  NUMBER(4)      N      Annee exercice de la ligne [OBL]
                      MFAL_VOLU       ,--9  NUMBER(15,3)   N      Volume facture de la ligne [OBL]
                      MFAL_PU         ,--10 NUMBER(12,6)   N      P.U. facture de la ligne [OBL]
                      MFAL_MTHT       ,--11 NUMBER(15,2)   N      Montant HT de la ligne [OBL]
                      MFAL_MTVA       ,--12 NUMBER(15,2)   N      Montant TVA de la ligne [OBL]
                      MFAL_TTVA       ,--13 NUMBER(15,2)   N      Taux de TVA de la ligne [OBL]
                      MFAL_MTTC       ,--14 NUMBER(15,2)   N
                      MFAL_DDEBPERFAC ,--15 DATE           Y      Date de debut de la periode facturee de la ligne
                      MFAL_DFINPERFAC ,--16 DATE           Y      Date de fin de la periode facturee de la ligne
                      MFAL_DETAIL      --17 NUMBER         Y
                      )
                      values
                     (
                     'DIST'||lpad(trim(facture_.dist),2,'0'),--1
                      V_FAC_NUM        ,--2
                      1                ,--3
                      'FRS_FIX_CSM'    ,--4
                      'Frais fixe sonede',--5
                      9                ,--6
                      1                ,--7
                      anneereel_       ,--8
                      1                ,--9
                      facture_.fraisctr/1000,--10
                      facture_.fraisctr/1000,--11
                      facture_.TVA_ff/1000,--12
                      18               ,--13
                      facture_.fraisctr/1000+(facture_.tva_ff/1000),--14
                      null             ,--15
                      DATE_            ,--16
                      null              --17
                     );
                exception
                when others then
                      err_code := SQLCODE;
                      err_msg  := SUBSTR(SQLERRM, 1, 200);
                      insert into prob_migration
                      (nom_table, val_ref, sql_err, date_pro,type_problem)
                      values
                      ('miwtfactureligne',
                      V_FAC_NUM,
                      err_code || '--' || err_msg,sysdate,'erreur de confomité de type colonne');
                end;
            end if;

            if to_number(facture_.fermeture) <> 0 then
                begin
                      insert into miwtfactureligne
                      (
                        MFAL_SOURCE    ,--1  VARCHAR2(100)  N    Code source/origine de la ligne [OBL]
                        MFAL_REFFAE    ,--2  VARCHAR2(100)  N    Identifiant de la facture de la ligne [OBL]
                        MFAL_REFTAP    ,--3  VARCHAR2(100)  N    Identifiant de la periode de tarif de la ligne [OBL]
                        MFAL_REFART    ,--4  VARCHAR2(100)  Y
                        MFAL_LIBE      ,--5  VARCHAR2(200)  Y
                        MFAL_NUM       ,--6  NUMBER(4)      N
                        MFAL_TRAN      ,--7  NUMBER(1)      N  1  Tranche de la ligne [OBL]
                        MFAL_EXER      ,--8  NUMBER(4)      N     Annee exercice de la ligne [OBL]
                        MFAL_VOLU      ,--9  NUMBER(15,3)   N     Volume facture de la ligne [OBL]
                        MFAL_PU        ,--10 NUMBER(12,6)   N     P.U. facture de la ligne [OBL]
                        MFAL_MTHT      ,--11 NUMBER(15,2)   N     Montant HT de la ligne [OBL]
                        MFAL_MTVA      ,--12 NUMBER(15,2)   N     Montant TVA de la ligne [OBL]
                        MFAL_TTVA      ,--13 NUMBER(15,2)   N     Taux de TVA de la ligne [OBL]
                        MFAL_MTTC      ,--14 NUMBER(15,2)   N
                        MFAL_DDEBPERFAC,--15 DATE           Y     Date de debut de la periode facturee de la ligne
                        MFAL_DFINPERFAC,--16 DATE           Y     Date de fin de la periode facturee de la ligne
                        MFAL_DETAIL     --17 NUMBER         Y
                        )
                        values
                       (
                        'DIST'||lpad(trim(facture_.dist),2,'0'),--1
                        V_FAC_NUM         ,--2
                        1                 ,--3
                        'FRS_FIX_PAVI_CPR',--4
                        'Frais FERMETURE' ,--5
                        10                ,--6
                        1                 ,--7
                        anneereel_        ,--8
                        1                 ,--9
                        facture_.fermeture/1000,--10
                        facture_.fermeture/1000,--11
                        facture_.tvaferm/1000 ,--12
                        18                 ,--13
                        facture_.fermeture/1000 + (facture_.tvaferm/1000) ,--14
                        null              ,--15
                        DATE_             ,--16
                        null               --17
                         );
                exception
                when others then
                      err_code := SQLCODE;
                      err_msg  := SUBSTR(SQLERRM, 1, 200);
                      insert into prob_migration
                      (nom_table, val_ref, sql_err, date_pro,type_problem)
                      values
                      ('miwtfactureligne',
                      V_FAC_NUM,
                      err_code || '--' || err_msg,sysdate,'erreur de confomité de type colonne');
                      end;
            end if;
            
            --hkh:17/07/2018 : Ajouter les ligne des nouveaux frais : deplacement, depose demande client et dépose non paiement
            if to_number(facture_.deplacement) <> 0 then -- frais de deplacement
              begin
                insert into miwtfactureligne
                      (
                        MFAL_SOURCE    ,--1  VARCHAR2(100)  N    Code source/origine de la ligne [OBL]
                        MFAL_REFFAE    ,--2  VARCHAR2(100)  N    Identifiant de la facture de la ligne [OBL]
                        MFAL_REFTAP    ,--3  VARCHAR2(100)  N    Identifiant de la periode de tarif de la ligne [OBL]
                        MFAL_REFART    ,--4  VARCHAR2(100)  Y
                        MFAL_LIBE      ,--5  VARCHAR2(200)  Y
                        MFAL_NUM       ,--6  NUMBER(4)      N
                        MFAL_TRAN      ,--7  NUMBER(1)      N  1  Tranche de la ligne [OBL]
                        MFAL_EXER      ,--8  NUMBER(4)      N     Annee exercice de la ligne [OBL]
                        MFAL_VOLU      ,--9  NUMBER(15,3)   N     Volume facture de la ligne [OBL]
                        MFAL_PU        ,--10 NUMBER(12,6)   N     P.U. facture de la ligne [OBL]
                        MFAL_MTHT      ,--11 NUMBER(15,2)   N     Montant HT de la ligne [OBL]
                        MFAL_MTVA      ,--12 NUMBER(15,2)   N     Montant TVA de la ligne [OBL]
                        MFAL_TTVA      ,--13 NUMBER(15,2)   N     Taux de TVA de la ligne [OBL]
                        MFAL_MTTC      ,--14 NUMBER(15,2)   N
                        MFAL_DDEBPERFAC,--15 DATE           Y     Date de debut de la periode facturee de la ligne
                        MFAL_DFINPERFAC,--16 DATE           Y     Date de fin de la periode facturee de la ligne
                        MFAL_DETAIL     --17 NUMBER         Y
                        )
                        values
                       (
                        'DIST'||lpad(trim(facture_.dist),2,'0'),--1
                        V_FAC_NUM         ,--2
                        1                 ,--3
                        'F_DEPLACEMNT',--4
                        'Frais de déplacement' ,--5
                        20                ,--6
                        1                 ,--7
                        anneereel_        ,--8
                        1                 ,--9
                        facture_.deplacement/1000,--10
                        facture_.deplacement/1000,--11
                        facture_.tvadeplac/1000 ,--12
                        18                 ,--13
                        facture_.deplacement/1000 + (facture_.tvadeplac/1000),--14
                        null              ,--15
                        DATE_             ,--16
                        null               --17
                         );
              exception
                when others then
                    err_code := SQLCODE;
                    err_msg  := SUBSTR(SQLERRM, 1, 200);
                    insert into prob_migration
                    (nom_table, val_ref, sql_err, date_pro,type_problem)
                    values
                    ('miwtfactureligne',
                    V_FAC_NUM,
                    err_code || '--' || err_msg,sysdate,'erreur de confomité de type colonne');  
              end;
            end if;
            
            if to_number(facture_.depose_dem) <> 0 then -- frais de depose demande client
              begin
                insert into miwtfactureligne
                      (
                        MFAL_SOURCE    ,--1  VARCHAR2(100)  N    Code source/origine de la ligne [OBL]
                        MFAL_REFFAE    ,--2  VARCHAR2(100)  N    Identifiant de la facture de la ligne [OBL]
                        MFAL_REFTAP    ,--3  VARCHAR2(100)  N    Identifiant de la periode de tarif de la ligne [OBL]
                        MFAL_REFART    ,--4  VARCHAR2(100)  Y
                        MFAL_LIBE      ,--5  VARCHAR2(200)  Y
                        MFAL_NUM       ,--6  NUMBER(4)      N
                        MFAL_TRAN      ,--7  NUMBER(1)      N  1  Tranche de la ligne [OBL]
                        MFAL_EXER      ,--8  NUMBER(4)      N     Annee exercice de la ligne [OBL]
                        MFAL_VOLU      ,--9  NUMBER(15,3)   N     Volume facture de la ligne [OBL]
                        MFAL_PU        ,--10 NUMBER(12,6)   N     P.U. facture de la ligne [OBL]
                        MFAL_MTHT      ,--11 NUMBER(15,2)   N     Montant HT de la ligne [OBL]
                        MFAL_MTVA      ,--12 NUMBER(15,2)   N     Montant TVA de la ligne [OBL]
                        MFAL_TTVA      ,--13 NUMBER(15,2)   N     Taux de TVA de la ligne [OBL]
                        MFAL_MTTC      ,--14 NUMBER(15,2)   N
                        MFAL_DDEBPERFAC,--15 DATE           Y     Date de debut de la periode facturee de la ligne
                        MFAL_DFINPERFAC,--16 DATE           Y     Date de fin de la periode facturee de la ligne
                        MFAL_DETAIL     --17 NUMBER         Y
                        )
                        values
                       (
                        'DIST'||lpad(trim(facture_.dist),2,'0'),--1
                        V_FAC_NUM         ,--2
                        1                 ,--3
                        'FRAIS_FRM_DEP',--4
                        'Frais de dépose suite à la demande du client' ,--5
                        21                ,--6
                        1                 ,--7
                        anneereel_        ,--8
                        1                 ,--9
                        facture_.depose_dem/1000,--10
                        facture_.depose_dem/1000,--11
                        facture_.tvadepose_dem/1000 ,--12
                        18                 ,--13
                        facture_.depose_dem/1000 + (facture_.tvadepose_dem/1000),--14
                        null              ,--15
                        DATE_             ,--16
                        null               --17
                         );
              exception
                when others then
                    err_code := SQLCODE;
                    err_msg  := SUBSTR(SQLERRM, 1, 200);
                    insert into prob_migration
                    (nom_table, val_ref, sql_err, date_pro,type_problem)
                    values
                    ('miwtfactureligne',
                    V_FAC_NUM,
                    err_code || '--' || err_msg,sysdate,'erreur de confomité de type colonne');  
              end;
            end if;
            
            if to_number(facture_.depose_def) <> 0 then -- frais de depose suite defaut de paiement
              begin
                insert into miwtfactureligne
                      (
                        MFAL_SOURCE    ,--1  VARCHAR2(100)  N    Code source/origine de la ligne [OBL]
                        MFAL_REFFAE    ,--2  VARCHAR2(100)  N    Identifiant de la facture de la ligne [OBL]
                        MFAL_REFTAP    ,--3  VARCHAR2(100)  N    Identifiant de la periode de tarif de la ligne [OBL]
                        MFAL_REFART    ,--4  VARCHAR2(100)  Y
                        MFAL_LIBE      ,--5  VARCHAR2(200)  Y
                        MFAL_NUM       ,--6  NUMBER(4)      N
                        MFAL_TRAN      ,--7  NUMBER(1)      N  1  Tranche de la ligne [OBL]
                        MFAL_EXER      ,--8  NUMBER(4)      N     Annee exercice de la ligne [OBL]
                        MFAL_VOLU      ,--9  NUMBER(15,3)   N     Volume facture de la ligne [OBL]
                        MFAL_PU        ,--10 NUMBER(12,6)   N     P.U. facture de la ligne [OBL]
                        MFAL_MTHT      ,--11 NUMBER(15,2)   N     Montant HT de la ligne [OBL]
                        MFAL_MTVA      ,--12 NUMBER(15,2)   N     Montant TVA de la ligne [OBL]
                        MFAL_TTVA      ,--13 NUMBER(15,2)   N     Taux de TVA de la ligne [OBL]
                        MFAL_MTTC      ,--14 NUMBER(15,2)   N
                        MFAL_DDEBPERFAC,--15 DATE           Y     Date de debut de la periode facturee de la ligne
                        MFAL_DFINPERFAC,--16 DATE           Y     Date de fin de la periode facturee de la ligne
                        MFAL_DETAIL     --17 NUMBER         Y
                        )
                        values
                       (
                        'DIST'||lpad(trim(facture_.dist),2,'0'),--1
                        V_FAC_NUM         ,--2
                        1                 ,--3
                        'FRS_DPOZ_RPOZ',--4
                        'Frais de dépose suite au non paiement' ,--5
                        22                ,--6
                        1                 ,--7
                        anneereel_        ,--8
                        1                 ,--9
                        facture_.depose_def/1000,--10
                        facture_.depose_def/1000,--11
                        facture_.tvadepose_def/1000 ,--12
                        18                 ,--13
                        facture_.depose_def/1000 + (facture_.tvadepose_def/1000),--14
                        null              ,--15
                        DATE_             ,--16
                        null               --17
                         );
              exception
                when others then
                    err_code := SQLCODE;
                    err_msg  := SUBSTR(SQLERRM, 1, 200);
                    insert into prob_migration
                    (nom_table, val_ref, sql_err, date_pro,type_problem)
                    values
                    ('miwtfactureligne',
                    V_FAC_NUM,
                    err_code || '--' || err_msg,sysdate,'erreur de confomité de type colonne');  
              end;
            end if;
            
            ---------------------------------------------------------

            if to_number(facture_.CAPIT) <> 0 then
                begin
                      insert into miwtfactureligne
                      (
                        MFAL_SOURCE     ,--1  VARCHAR2(100)  N      Code source/origine de la ligne [OBL]
                        MFAL_REFFAE     ,--2  VARCHAR2(100)  N      Identifiant de la facture de la ligne [OBL]
                        MFAL_REFTAP     ,--3  VARCHAR2(100)  N      Identifiant de la periode de tarif de la ligne [OBL]
                        MFAL_REFART     ,--4  VARCHAR2(100)  Y
                        MFAL_LIBE       ,--5  VARCHAR2(200)  Y
                        MFAL_NUM        ,--6  NUMBER(4)      N
                        MFAL_TRAN       ,--7  NUMBER(1)      N  1   Tranche de la ligne [OBL]
                        MFAL_EXER       ,--8  NUMBER(4)      N      Annee exercice de la ligne [OBL]
                        MFAL_VOLU       ,--9  NUMBER(15,3)   N      Volume facture de la ligne [OBL]
                        MFAL_PU         ,--10 NUMBER(12,6)   N      P.U. facture de la ligne [OBL]
                        MFAL_MTHT       ,--11 NUMBER(15,2)   N      Montant HT de la ligne [OBL]
                        MFAL_MTVA       ,--12 NUMBER(15,2)   N      Montant TVA de la ligne [OBL]
                        MFAL_TTVA       ,--13 NUMBER(15,2)   N      Taux de TVA de la ligne [OBL]
                        MFAL_MTTC       ,--14 NUMBER(15,2)   N
                        MFAL_DDEBPERFAC ,--15 DATE           Y      Date de debut de la periode facturee de la ligne
                        MFAL_DFINPERFAC ,--16 DATE           Y      Date de fin de la periode facturee de la ligne
                        MFAL_DETAIL      --17 NUMBER         Y
                        )
                        values
                       (
                       'DIST'||lpad(trim(facture_.dist),2,'0'),--1
                        V_FAC_NUM        ,--2
                        2                ,--3
                        'CAPITAL'        ,--4
                        'Montant capital',--5
                        11               ,--6
                        1                ,--7
                        anneereel_       ,--8
                        1                ,--9
                        facture_.CAPIT/1000,--10
                        facture_.CAPIT/1000,--11
                        facture_.tva_capit/1000 ,--12
                        0                ,--13
                        facture_.CAPIT/1000,--14
                        null             ,--15
                        DATE_            ,--16
                        null              --17
                         );
                exception
                when others then
                        err_code := SQLCODE;
                        err_msg  := SUBSTR(SQLERRM, 1, 200);
                        insert into prob_migration
                        (nom_table, val_ref, sql_err, date_pro,type_problem)
                        values
                        ('miwtfactureligne',
                        V_FAC_NUM,
                        err_code || '--' || err_msg,sysdate,'erreur de confomité de type colonne');
                end;
            end if;

            if to_number(facture_.INTER) <> 0 then
                begin
                      insert into miwtfactureligne
                      (
                        MFAL_SOURCE     ,--1  VARCHAR2(100)  N      Code source/origine de la ligne [OBL]
                        MFAL_REFFAE     ,--2  VARCHAR2(100)  N      Identifiant de la facture de la ligne [OBL]
                        MFAL_REFTAP     ,--3  VARCHAR2(100)  N      Identifiant de la periode de tarif de la ligne [OBL]
                        MFAL_REFART     ,--4  VARCHAR2(100)  Y
                        MFAL_LIBE       ,--5  VARCHAR2(200)  Y
                        MFAL_NUM        ,--6  NUMBER(4)      N
                        MFAL_TRAN       ,--7  NUMBER(1)      N  1   Tranche de la ligne [OBL]
                        MFAL_EXER       ,--8  NUMBER(4)      N      Annee exercice de la ligne [OBL]
                        MFAL_VOLU       ,--9  NUMBER(15,3)   N      Volume facture de la ligne [OBL]
                        MFAL_PU         ,--10 NUMBER(12,6)   N      P.U. facture de la ligne [OBL]
                        MFAL_MTHT       ,--11 NUMBER(15,2)   N      Montant HT de la ligne [OBL]
                        MFAL_MTVA       ,--12 NUMBER(15,2)   N      Montant TVA de la ligne [OBL]
                        MFAL_TTVA       ,--13 NUMBER(15,2)   N      Taux de TVA de la ligne [OBL]
                        MFAL_MTTC       ,--14 NUMBER(15,2)   N
                        MFAL_DDEBPERFAC ,--15 DATE           Y      Date de debut de la periode facturee de la ligne
                        MFAL_DFINPERFAC ,--16 DATE           Y      Date de fin de la periode facturee de la ligne
                        MFAL_DETAIL      --17 NUMBER         Y
                        )
                        values
                       (
                       'DIST'||lpad(trim(facture_.dist),2,'0') ,--1
                        V_FAC_NUM        ,--2
                        2                ,--3
                        'INTERET'        ,--4
                        'Montant Interet',--5
                        12               ,--6
                        1                ,--7
                        anneereel_       ,--8
                        1                ,--9
                        facture_.INTER/1000,--10
                        facture_.INTER/1000,--11
                        0                  ,--12
                        0                  ,--13
                        facture_.INTER/1000,--14
                        null             ,--15
                        DATE_            ,--16
                        null              --17
                        );
                exception
                when others then
                        err_code := SQLCODE;
                        err_msg  := SUBSTR(SQLERRM, 1, 200);
                        insert into prob_migration
                        (nom_table, val_ref, sql_err, date_pro,type_problem)
                        values
                        ('miwtfactureligne',
                        V_FAC_NUM,
                        err_code || '--' || err_msg,sysdate,'erreur de confomité de type colonne');
                end;
            end if;

            if to_number(facture_.RBRANCHE) <> 0 then
                begin
                      insert into miwtfactureligne
                      (
                        MFAL_SOURCE    ,--1  VARCHAR2(100)  N      Code source/origine de la ligne [OBL]
                        MFAL_REFFAE    ,--2  VARCHAR2(100)  N      Identifiant de la facture de la ligne [OBL]
                        MFAL_REFTAP    ,--3  VARCHAR2(100)  N      Identifiant de la periode de tarif de la ligne [OBL]
                        MFAL_REFART    ,--4  VARCHAR2(100)  Y
                        MFAL_LIBE      ,--5  VARCHAR2(200)  Y
                        MFAL_NUM       ,--6  NUMBER(4)      N
                        MFAL_TRAN      ,--7  NUMBER(1)      N  1   Tranche de la ligne [OBL]
                        MFAL_EXER      ,--8  NUMBER(4)      N      Annee exercice de la ligne [OBL]
                        MFAL_VOLU      ,--9  NUMBER(15,3)   N      Volume facture de la ligne [OBL]
                        MFAL_PU        ,--10 NUMBER(12,6)   N      P.U. facture de la ligne [OBL]
                        MFAL_MTHT      ,--11 NUMBER(15,2)   N      Montant HT de la ligne [OBL]
                        MFAL_MTVA      ,--12 NUMBER(15,2)   N      Montant TVA de la ligne [OBL]
                        MFAL_TTVA      ,--13 NUMBER(15,2)   N      Taux de TVA de la ligne [OBL]
                        MFAL_MTTC      ,--14 NUMBER(15,2)   N
                        MFAL_DDEBPERFAC,--15 DATE           Y      Date de debut de la periode facturee de la ligne
                        MFAL_DFINPERFAC,--16 DATE           Y      Date de fin de la periode facturee de la ligne
                        MFAL_DETAIL     --17 NUMBER         Y
                        )
                        values
                       (
                       'DIST'||lpad(trim(facture_.dist),2,'0') ,--1
                        V_FAC_NUM        ,--2
                        1                ,--3
                        'COURETABBR'     ,--4
                        'Montant branchement',--5
                        13               ,--6
                        1                ,--7
                        anneereel_       ,--8
                        1                ,--9
                        facture_.RBRANCHE/1000,--10
                        facture_.RBRANCHE/1000,--11
                        0                ,--12
                        0                ,--13
                        facture_.RBRANCHE/1000,--14
                        null             ,--15
                        DATE_            ,--16
                        null              --17
                        );
                exception
                when others then
                err_code := SQLCODE;
                err_msg  := SUBSTR(SQLERRM, 1, 200);
                insert into prob_migration
                (nom_table, val_ref, sql_err, date_pro,type_problem)
                values
                ('miwtfactureligne',
                V_FAC_NUM,
                err_code || '--' || err_msg,sysdate,'erreur de confomité de type colonne');
                end;
            end if;
            /*
            
            -----------A Revoir absance de champ RFACADE
            if to_number(facture_.RFACADE) <> 0 then
            begin
            insert into miwtfactureligne
            (
            MFAL_SOURCE    ,--1  VARCHAR2(100)  N      Code source/origine de la ligne [OBL]
            MFAL_REFFAE    ,--2  VARCHAR2(100)  N      Identifiant de la facture de la ligne [OBL]
            MFAL_REFTAP    ,--3  VARCHAR2(100)  N      Identifiant de la periode de tarif de la ligne [OBL]
            MFAL_REFART    ,--4  VARCHAR2(100)  Y
            MFAL_LIBE      ,--5  VARCHAR2(200)  Y
            MFAL_NUM       ,--6  NUMBER(4)      N
            MFAL_TRAN      ,--7  NUMBER(1)      N  1   Tranche de la ligne [OBL]
            MFAL_EXER      ,--8  NUMBER(4)      N      Annee exercice de la ligne [OBL]
            MFAL_VOLU      ,--9  NUMBER(15,3)   N      Volume facture de la ligne [OBL]
            MFAL_PU        ,--10 NUMBER(12,6)   N      P.U. facture de la ligne [OBL]
            MFAL_MTHT      ,--11 NUMBER(15,2)   N      Montant HT de la ligne [OBL]
            MFAL_MTVA      ,--12 NUMBER(15,2)   N      Montant TVA de la ligne [OBL]
            MFAL_TTVA      ,--13 NUMBER(15,2)   N      Taux de TVA de la ligne [OBL]
            MFAL_MTTC      ,--14 NUMBER(15,2)   N
            MFAL_DDEBPERFAC,--15 DATE           Y      Date de debut de la periode facturee de la ligne
            MFAL_DFINPERFAC,--16 DATE           Y      Date de fin de la periode facturee de la ligne
            MFAL_DETAIL     --17 NUMBER         Y
            )
            values
            (
            'DIST'||lpad(trim(facture_.dist),2,'0'),--1
            V_FAC_NUM        ,--2
            1                ,--3
            'FACADE'         ,--4
            'Montant facade' ,--5
            14               ,--6
            1                ,--7
            anneereel_       ,--8
            1                ,--9
            facture_.RFACADE/1000,--10
            facture_.RFACADE/1000,--11
            0                ,--12
            0                ,--13
            facture_.RFACADE/1000,--14
            null             ,--15
            DATE_            ,--16
            null              --17
            );
            exception
            when others then
            err_code := SQLCODE;
            err_msg  := SUBSTR(SQLERRM, 1, 200);
            insert into prob_migration
            (nom_table, val_ref, sql_err, date_pro,type_problem)
            values
            ('miwtfactureligne',
            V_FAC_NUM,
            err_code || '--' || err_msg,sysdate,'erreur de confomité de type colonne');
            end;
            end if;
            */
            /*
             -----------A Revoir absance de champ REXTENSION
             if to_number(facture_.REXTENSION) <> 0 then
                begin
                     insert into miwtfactureligne
                      (
                        MFAL_SOURCE    ,--1  VARCHAR2(100)  N      Code source/origine de la ligne [OBL]
                        MFAL_REFFAE    ,--2  VARCHAR2(100)  N      Identifiant de la facture de la ligne [OBL]
                        MFAL_REFTAP    ,--3  VARCHAR2(100)  N      Identifiant de la periode de tarif de la ligne [OBL]
                        MFAL_REFART    ,--4  VARCHAR2(100)  Y
                        MFAL_LIBE      ,--5  VARCHAR2(200)  Y
                        MFAL_NUM       ,--6  NUMBER(4)      N
                        MFAL_TRAN      ,--7  NUMBER(1)      N  1   Tranche de la ligne [OBL]
                        MFAL_EXER      ,--8  NUMBER(4)      N      Annee exercice de la ligne [OBL]
                        MFAL_VOLU      ,--9  NUMBER(15,3)   N      Volume facture de la ligne [OBL]
                        MFAL_PU        ,--10 NUMBER(12,6)   N      P.U. facture de la ligne [OBL]
                        MFAL_MTHT      ,--11 NUMBER(15,2)   N      Montant HT de la ligne [OBL]
                        MFAL_MTVA      ,--12 NUMBER(15,2)   N      Montant TVA de la ligne [OBL]
                        MFAL_TTVA      ,--13 NUMBER(15,2)   N      Taux de TVA de la ligne [OBL]
                        MFAL_MTTC      ,--14 NUMBER(15,2)   N
                        MFAL_DDEBPERFAC,--15 DATE           Y      Date de debut de la periode facturee de la ligne
                        MFAL_DFINPERFAC,--16 DATE           Y      Date de fin de la periode facturee de la ligne
                        MFAL_DETAIL     --17 NUMBER         Y
                        )
                        values
                       (
                       'DIST'||lpad(trim(facture_.dist),2,'0'),--1
                        V_FAC_NUM        ,--2
                        1                ,--3
                        'REXTENSION'     ,--4
                        'Montant extension',--5
                        15               ,--6
                        1                ,--7
                        anneereel_       ,--8
                        1                ,--9
                        facture_.REXTENSION/1000,--10
                        facture_.REXTENSION/1000,--11
                        0                ,--12
                        0                ,--13
                        facture_.REXTENSION/1000,--14
                        null             ,--15
                        DATE_            ,--16
                        null              --17
                         );
                exception
                when others then
                      err_code := SQLCODE;
                      err_msg  := SUBSTR(SQLERRM, 1, 200);
                      insert into prob_migration
                      (nom_table, val_ref, sql_err, date_pro,type_problem)
                      values
                      ('miwtfactureligne',
                      V_FAC_NUM,
                      err_code || '--' || err_msg,sysdate,'erreur de confomité de type colonne');
                end;
            end if;
            --*****************************************
            */
                         
            if to_number(facture_.PFINANCIER) <> 0 then
            begin
            insert into miwtfactureligne
            (
            MFAL_SOURCE    ,--1  VARCHAR2(100)  N      Code source/origine de la ligne [OBL]
            MFAL_REFFAE    ,--2  VARCHAR2(100)  N      Identifiant de la facture de la ligne [OBL]
            MFAL_REFTAP    ,--3  VARCHAR2(100)  N      Identifiant de la periode de tarif de la ligne [OBL]
            MFAL_REFART    ,--4  VARCHAR2(100)  Y
            MFAL_LIBE      ,--5  VARCHAR2(200)  Y
            MFAL_NUM       ,--6  NUMBER(4)      N
            MFAL_TRAN      ,--7  NUMBER(1)      N  1   Tranche de la ligne [OBL]
            MFAL_EXER      ,--8  NUMBER(4)      N      Annee exercice de la ligne [OBL]
            MFAL_VOLU      ,--9  NUMBER(15,3)   N      Volume facture de la ligne [OBL]
            MFAL_PU        ,--10 NUMBER(12,6)   N      P.U. facture de la ligne [OBL]
            MFAL_MTHT      ,--11 NUMBER(15,2)   N      Montant HT de la ligne [OBL]
            MFAL_MTVA      ,--12 NUMBER(15,2)   N      Montant TVA de la ligne [OBL]
            MFAL_TTVA      ,--13 NUMBER(15,2)   N      Taux de TVA de la ligne [OBL]
            MFAL_MTTC      ,--14 NUMBER(15,2)   N
            MFAL_DDEBPERFAC,--15 DATE           Y      Date de debut de la periode facturee de la ligne
            MFAL_DFINPERFAC,--16 DATE           Y      Date de fin de la periode facturee de la ligne
            MFAL_DETAIL     --17 NUMBER         Y
            )
            values
            (
            'DIST'||lpad(trim(facture_.dist),2,'0')  ,--1
            V_FAC_NUM          ,--2
            1                  ,--3
            'PFINANCIER'       ,--4
            'PRODUIT FINANCIER',--5
            16                 ,--6
            1                  ,--7
            anneereel_         ,--8
            1                  ,--9
            facture_.PFINANCIER/1000,--10
            facture_.PFINANCIER/1000,--11
            facture_.tva_pfin/1000  ,--12
            0                  ,--13
            facture_.PFINANCIER/1000,--14
            null               ,--15
            DATE_              ,--16
            null                --17
            );
            exception
            when others then
            err_code := SQLCODE;
            err_msg  := SUBSTR(SQLERRM, 1, 200);
            insert into prob_migration
            (nom_table, val_ref, sql_err, date_pro,type_problem)
            values
            ('miwtfactureligne',
            V_FAC_NUM,
            err_code || '--' || err_msg,sysdate,'erreur de confomité de type colonne');
            end;
            end if;
---------------
            if to_number(facture_.AREPOR) <> 0 then
                begin
               insert into miwtfactureligne
                    (
                      MFAL_SOURCE    ,--1  VARCHAR2(100)  N      Code source/origine de la ligne [OBL]
                      MFAL_REFFAE    ,--2  VARCHAR2(100)  N      Identifiant de la facture de la ligne [OBL]
                      MFAL_REFTAP    ,--3  VARCHAR2(100)  N      Identifiant de la periode de tarif de la ligne [OBL]
                      MFAL_REFART    ,--4  VARCHAR2(100)  Y
                      MFAL_LIBE      ,--5  VARCHAR2(200)  Y
                      MFAL_NUM       ,--6  NUMBER(4)      N
                      MFAL_TRAN      ,--7  NUMBER(1)      N  1   Tranche de la ligne [OBL]
                      MFAL_EXER      ,--8  NUMBER(4)      N      Annee exercice de la ligne [OBL]
                      MFAL_VOLU      ,--9  NUMBER(15,3)   N      Volume facture de la ligne [OBL]
                      MFAL_PU        ,--10  NUMBER(12,6)   N      P.U. facture de la ligne [OBL]
                      MFAL_MTHT      ,--11  NUMBER(15,2)   N      Montant HT de la ligne [OBL]
                      MFAL_MTVA      ,--12  NUMBER(15,2)   N      Montant TVA de la ligne [OBL]
                      MFAL_TTVA      ,--13  NUMBER(15,2)   N      Taux de TVA de la ligne [OBL]
                      MFAL_MTTC      ,--14  NUMBER(15,2)   N
                      MFAL_DDEBPERFAC,--15  DATE           Y      Date de debut de la periode facturee de la ligne
                      MFAL_DFINPERFAC,--16  DATE           Y      Date de fin de la periode facturee de la ligne
                      MFAL_DETAIL     --17  NUMBER         Y
                      )
                      values
                     (
                     'DIST'||lpad(trim(facture_.dist),2,'0'),--1
                      V_FAC_NUM        ,--2
                      1                ,--3
                      'AREPOR'         ,--4
                      'Montant report' ,--5
                      17               ,--6
                      1                ,--7
                      anneereel_       ,--8
                      1                ,--9
                      decode(facture_.caron,'1',1,-1)* (facture_.AREPOR/1000),--10
                      decode(facture_.caron,'1',1,-1)* (facture_.AREPOR/1000),--11
                      0                ,--12
                      0                ,--13
                      decode(facture_.caron,'1',1,-1)* (facture_.AREPOR/1000),--14
                      null             ,--15
                      DATE_            ,--16
                      null              --17
                      );
                exception
                when others then
                      err_code := SQLCODE;
                      err_msg  := SUBSTR(SQLERRM, 1, 200);
                      insert into prob_migration
                      (nom_table, val_ref, sql_err, date_pro,type_problem)
                      values
                      ('miwtfactureligne',
                      V_FAC_NUM,
                      err_code || '--' || err_msg,sysdate,'erreur de confomité de type colonne');
                      end;
            end if;

            if to_number(facture_.NAROND) <> 0 then
                begin
                      insert into miwtfactureligne
                      (
                        MFAL_SOURCE    ,--1  VARCHAR2(100)  N      Code source/origine de la ligne [OBL]
                        MFAL_REFFAE    ,--2  VARCHAR2(100)  N      Identifiant de la facture de la ligne [OBL]
                        MFAL_REFTAP    ,--3  VARCHAR2(100)  N      Identifiant de la periode de tarif de la ligne [OBL]
                        MFAL_REFART    ,--4  VARCHAR2(100)  Y
                        MFAL_LIBE      ,--5  VARCHAR2(200)  Y
                        MFAL_NUM       ,--6  NUMBER(4)      N
                        MFAL_TRAN      ,--7  NUMBER(1)      N  1   Tranche de la ligne [OBL]
                        MFAL_EXER      ,--8  NUMBER(4)      N      Annee exercice de la ligne [OBL]
                        MFAL_VOLU      ,--9  NUMBER(15,3)   N      Volume facture de la ligne [OBL]
                        MFAL_PU        ,--10 NUMBER(12,6)   N      P.U. facture de la ligne [OBL]
                        MFAL_MTHT      ,--11 NUMBER(15,2)   N      Montant HT de la ligne [OBL]
                        MFAL_MTVA      ,--12 NUMBER(15,2)   N      Montant TVA de la ligne [OBL]
                        MFAL_TTVA      ,--13 NUMBER(15,2)   N      Taux de TVA de la ligne [OBL]
                        MFAL_MTTC      ,--14 NUMBER(15,2)   N
                        MFAL_DDEBPERFAC,--15 DATE           Y      Date de debut de la periode facturee de la ligne
                        MFAL_DFINPERFAC,--16 DATE           Y      Date de fin de la periode facturee de la ligne
                        MFAL_DETAIL     --17 NUMBER         Y
                        )
                        values
                       (
                       'DIST'||lpad(trim(facture_.dist),2,'0'),--1
                        V_FAC_NUM        ,--2
                        1                ,--3
                        'NAROND'         ,--4
                        'Arrondissement' ,--5
                        18               ,--6
                        1                ,--7
                        anneereel_       ,--8
                        1                ,--9
                        decode(facture_.caron,'1',-1,1)*(facture_.NAROND/1000),--10
                        decode(facture_.caron,'1',-1,1)*(facture_.NAROND/1000),--11
                        0                ,--12
                        0                ,--13
                        decode(facture_.caron,'1',-1,1)*(facture_.NAROND/1000),--14
                        null             ,--15
                        DATE_            ,--16
                        null              --17
                        );
                exception
                when others then
                        err_code := SQLCODE;
                        err_msg  := SUBSTR(SQLERRM, 1, 200);
                        insert into prob_migration
                        (nom_table, val_ref, sql_err, date_pro,type_problem)
                        values
                        ('miwtfactureligne',
                        V_FAC_NUM,
                        err_code || '--' || err_msg,sysdate,'erreur de confomité de type colonne');
                end;
            end if;
            /* ----A Revoir absance de champ DIVERS
            if to_number(facture_.DIVERS) <> 0 then
                begin
                 insert into miwtfactureligne
                      (
                        MFAL_SOURCE    ,--1  VARCHAR2(100)  N      Code source/origine de la ligne [OBL]
                        MFAL_REFFAE    ,--2  VARCHAR2(100)  N      Identifiant de la facture de la ligne [OBL]
                        MFAL_REFTAP    ,--3  VARCHAR2(100)  N      Identifiant de la periode de tarif de la ligne [OBL]
                        MFAL_REFART    ,--4  VARCHAR2(100)  Y
                        MFAL_LIBE      ,--5  VARCHAR2(200)  Y
                        MFAL_NUM       ,--6  NUMBER(4)      N
                        MFAL_TRAN      ,--7  NUMBER(1)      N  1   Tranche de la ligne [OBL]
                        MFAL_EXER      ,--8  NUMBER(4)      N      Annee exercice de la ligne [OBL]
                        MFAL_VOLU      ,--9  NUMBER(15,3)   N      Volume facture de la ligne [OBL]
                        MFAL_PU        ,--10  NUMBER(12,6)   N      P.U. facture de la ligne [OBL]
                        MFAL_MTHT      ,--11  NUMBER(15,2)   N      Montant HT de la ligne [OBL]
                        MFAL_MTVA      ,--12  NUMBER(15,2)   N      Montant TVA de la ligne [OBL]
                        MFAL_TTVA      ,--13  NUMBER(15,2)   N      Taux de TVA de la ligne [OBL]
                        MFAL_MTTC      ,--14  NUMBER(15,2)   N
                        MFAL_DDEBPERFAC,--15  DATE           Y      Date de debut de la periode facturee de la ligne
                        MFAL_DFINPERFAC,--16  DATE           Y      Date de fin de la periode facturee de la ligne
                        MFAL_DETAIL     --17  NUMBER         Y
                        )
                        values
                       (
                       'DIST'||lpad(trim(facture_.dist),2,'0'),--1
                        V_FAC_NUM        ,--2
                        1                ,--3
                        'AUTREFRAIS'     ,--4
                        'Frais Divers '  ,--5
                        20               ,--6
                        1                ,--7
                        anneereel_       ,--8
                        1                ,--9
                        (facture_.DIVERS)/1000,--10
                        (facture_.DIVERS)/1000,--11
                        0                ,--12
                        0                ,--13
                        (facture_.DIVERS)/1000,--14
                        null             ,--15
                        DATE_            ,--16
                        null              --17
                        );
                exception
                when others then
                      err_code := SQLCODE;
                      err_msg  := SUBSTR(SQLERRM, 1, 200);
                      insert into prob_migration
                      (nom_table, val_ref, sql_err, date_pro,type_problem)
                      values
                      ('miwtfactureligne',
                      V_FAC_NUM,
                      err_code || '--' || err_msg,sysdate,'erreur de confomité de type colonne');
                end;
            end if;*/
            <<XX>>
           commit;
        end loop;
/*
        delete xx;
       insert into xx  select  substr(s.mfae_rdet,1,2) distirct,substr(s.mfae_rdet,3,3) tourne,substr(s.mfae_rdet,6,3) ordre ,substr(s.mfae_rdet,9,4)annee,
        substr(s.mfae_rdet,13,2) periode,t.mfal_reffae,sum(t.mfal_mttc) net_calc,s.mfae_solde net,sum(t.mfal_mttc)-s.mfae_solde diff,
        sum(decode(t.mfal_refart,'CAPITAL',t.mfal_mttc,'INTERET',t.mfal_mttc,0)) capit
         from miwtfactureligne t,miwtfactureentete s
         where t.mfal_reffae=s.mfae_ref
         group by t.mfal_reffae,s.mfae_solde,substr(s.mfae_rdet,1,2),substr(s.mfae_rdet,3,3),substr(s.mfae_rdet,6,3),substr(s.mfae_rdet,9,4),substr(s.mfae_rdet,13,2)
         having ((abs(sum(t.mfal_mttc)-s.mfae_solde) <>0)) ;
        commit;

         for c in (select t.*, t.rowid from xx t where diff = capit)
          loop
             delete miwtfactureligne s where s.mfal_source = 'DIST'||c.distirct and c.mfal_reffae=s.mfal_reffae
                                   And s.mfal_refart in('CAPITAL','INTERET');
              delete xx where c.distirct=distirct and c.mfal_reffae=mfal_reffae;
          end loop;
          commit;

            for c in (select t.*, t.rowid,diff-capit from xx t where capit <> 0 and diff-(diff-capit) =capit and (diff-capit) > 0.001)
            loop
            delete miwtfactureligne s where s.mfal_source = 'DIST'||c.distirct and c.mfal_reffae=s.mfal_reffae
                                   And s.mfal_refart in('CAPITAL','INTERET');
            end loop;
          commit;
       delete xx;
       insert into xx  select  substr(s.mfae_rdet,1,2) distirct,substr(s.mfae_rdet,3,3) tourne,substr(s.mfae_rdet,6,3) ordre ,substr(s.mfae_rdet,9,4)annee,
        substr(s.mfae_rdet,13,2) periode,t.mfal_reffae,sum(t.mfal_mttc) net_calc,s.mfae_solde net,sum(t.mfal_mttc)-s.mfae_solde diff,
        sum(decode(t.mfal_refart,'CAPITAL',t.mfal_mttc,'INTERET',t.mfal_mttc,0)) capit
         from miwtfactureligne t,miwtfactureentete s
         where t.mfal_reffae=s.mfae_ref
         group by t.mfal_reffae,s.mfae_solde,substr(s.mfae_rdet,1,2),substr(s.mfae_rdet,3,3),substr(s.mfae_rdet,6,3),substr(s.mfae_rdet,9,4),substr(s.mfae_rdet,13,2)
         having ((abs(sum(t.mfal_mttc)-s.mfae_solde) <>0)) ;
       commit;


for c in (select t.*, t.rowid from XX t WHERE diff >= 0.001)
   loop
   select count(*) into x from miwtfactureligne s where s.mfal_reffae=c.mfal_reffae and s.mfal_refart='NAROND'
                                                      And 'DIST'||c.distirct=s.mfal_source;
  if x = 0 then
       insert into miwtfactureligne
              (
                MFAL_SOURCE     ,--  VARCHAR2(100)  N      Code source/origine de la ligne [OBL]
                MFAL_REFFAE     ,--  VARCHAR2(100)  N      Identifiant de la facture de la ligne [OBL]
                MFAL_REFTAP     ,--  VARCHAR2(100)  N      Identifiant de la periode de tarif de la ligne [OBL]
                MFAL_REFART     ,--  VARCHAR2(100)  Y
                MFAL_LIBE       ,--  VARCHAR2(200)  Y
                MFAL_NUM        ,--  NUMBER(4)      N
                MFAL_TRAN       ,--  NUMBER(1)      N  1   Tranche de la ligne [OBL]
                MFAL_EXER       ,--  NUMBER(4)      N      Annee exercice de la ligne [OBL]
                MFAL_VOLU       ,--  NUMBER(15,3)   N      Volume facture de la ligne [OBL]
                MFAL_PU         ,--  NUMBER(12,6)   N      P.U. facture de la ligne [OBL]
                MFAL_MTHT       ,--  NUMBER(15,2)   N      Montant HT de la ligne [OBL]
                MFAL_MTVA       ,--  NUMBER(15,2)   N      Montant TVA de la ligne [OBL]
                MFAL_TTVA       ,--  NUMBER(15,2)   N      Taux de TVA de la ligne [OBL]
                MFAL_MTTC       ,--  NUMBER(15,2)   N
                MFAL_DDEBPERFAC ,--  DATE           Y      Date de debut de la periode facturee de la ligne
                MFAL_DFINPERFAC ,--  DATE           Y      Date de fin de la periode facturee de la ligne
                MFAL_DETAIL      --  NUMBER         Y
                )
                values
               (
               'DIST'||c.distirct,
                c.mfal_reffae    ,
                1                ,
                'NAROND'         ,
                'Arrondissement' ,
                18               ,
                1                ,
                c.annee          ,
                1                ,
                (-1)*(c.diff)    ,
                (-1)*(c.diff)    ,
                0                ,
                0                ,
                (-1)*(c.diff)    ,
                null             ,
                null             ,
                null
                );
             else
               update miwtfactureligne set MFAL_PU=MFAL_PU-c.diff,
                                           MFAL_MTHT=MFAL_MTHT-c.diff,
                                           MFAL_MTTC=MFAL_MTTC-c.diff
                                           where
                                           mfal_reffae=c.mfal_reffae and mfal_refart='NAROND'
                                            And 'DIST'||c.distirct=mfal_source;
    end if;


end loop;
   commit;

        delete xx;
       insert into xx  select  substr(s.mfae_rdet,1,2) distirct,substr(s.mfae_rdet,3,3) tourne,substr(s.mfae_rdet,6,3) ordre ,substr(s.mfae_rdet,9,4)annee,
        substr(s.mfae_rdet,13,2) periode,t.mfal_reffae,sum(t.mfal_mttc) net_calc,s.mfae_solde net,sum(t.mfal_mttc)-s.mfae_solde diff,
        sum(decode(t.mfal_refart,'CAPITAL',t.mfal_mttc,'INTERET',t.mfal_mttc,0)) capit
         from miwtfactureligne t,miwtfactureentete s
         where t.mfal_reffae=s.mfae_ref
         group by t.mfal_reffae,s.mfae_solde,substr(s.mfae_rdet,1,2),substr(s.mfae_rdet,3,3),substr(s.mfae_rdet,6,3),substr(s.mfae_rdet,9,4),substr(s.mfae_rdet,13,2)
         having ((abs(sum(t.mfal_mttc)-s.mfae_solde) <>0)) ;
       commit;
         delete  miwtfactureligne t where MFAL_REFFAE in (select MFAL_REFFAE from xx  where abs(diff)=abs(t.mfal_mttc)) and t.mfal_refart='NAROND';
          commit;
         delete xx;
       insert into xx  select  substr(s.mfae_rdet,1,2) distirct,substr(s.mfae_rdet,3,3) tourne,substr(s.mfae_rdet,6,3) ordre ,substr(s.mfae_rdet,9,4)annee,
        substr(s.mfae_rdet,13,2) periode,t.mfal_reffae,sum(t.mfal_mttc) net_calc,s.mfae_solde net,sum(t.mfal_mttc)-s.mfae_solde diff,
        sum(decode(t.mfal_refart,'CAPITAL',t.mfal_mttc,'INTERET',t.mfal_mttc,0)) capit
         from miwtfactureligne t,miwtfactureentete s
         where t.mfal_reffae=s.mfae_ref
         group by t.mfal_reffae,s.mfae_solde,substr(s.mfae_rdet,1,2),substr(s.mfae_rdet,3,3),substr(s.mfae_rdet,6,3),substr(s.mfae_rdet,9,4),substr(s.mfae_rdet,13,2)
         having ((abs(sum(t.mfal_mttc)-s.mfae_solde) <>0)) ;
         commit;
       -----
        for c in (select t.*, t.rowid,trunc(diff/capit) nbr ,capit*trunc(diff/capit) from xx t where capit <> 0)
         loop
          update miwtfactureligne  set MFAL_VOLU=MFAL_VOLU+(c.nbr*-1) where MFAL_REFART in ('INTERET','CAPITAL') and MFAL_REFFAE=c.mfal_reffae;
         end loop;
         update miwtfactureligne set MFAL_MTHT=MFAL_VOLU*mfal_pu,
                                  MFAL_MTTC=MFAL_VOLU*mfal_pu
                                  where MFAL_REFART in ('INTERET','CAPITAL');
            commit;
         delete xx;
       insert into xx  select  substr(s.mfae_rdet,1,2) distirct,substr(s.mfae_rdet,3,3) tourne,substr(s.mfae_rdet,6,3) ordre ,substr(s.mfae_rdet,9,4)annee,
        substr(s.mfae_rdet,13,2) periode,t.mfal_reffae,sum(t.mfal_mttc) net_calc,s.mfae_solde net,sum(t.mfal_mttc)-s.mfae_solde diff,
        sum(decode(t.mfal_refart,'CAPITAL',t.mfal_mttc,'INTERET',t.mfal_mttc,0)) capit
         from miwtfactureligne t,miwtfactureentete s
         where t.mfal_reffae=s.mfae_ref
         group by t.mfal_reffae,s.mfae_solde,substr(s.mfae_rdet,1,2),substr(s.mfae_rdet,3,3),substr(s.mfae_rdet,6,3),substr(s.mfae_rdet,9,4),substr(s.mfae_rdet,13,2)
         having ((abs(sum(t.mfal_mttc)-s.mfae_solde) <>0)) ;
*/
insert into prob_migration (nom_table)values(SYSTIMESTAMP||'   END MIWT_FACTURE_AS400');
commit;
end;

--********************************************
 procedure MIWT_FACTURE_AS400GC  is
--********************************************
        err_code         varchar2(200);
        err_msg          varchar2(200);
        V_FAC_NUM        number;
        V_FAC_RESTANTDU  number;
        V_FAC_DATECALCUL date;
        V_FAC_DATELIM    date;
        V_FAC_ABN_NUM    number(20);
        v_ref_releve     number;
        V_TRAIN_FACT     varchar2(200);
        V_REF_ABN        varchar2(200);
        v_mrel_ref       varchar2(200);
        nbr_trt          number := 0;
        nbr_trt_rt       number := 0;
        x                number;
        v_ID_FACTURE     varchar2(20);
        annee_           number(4);
        periode_         number;
        version          number(1) := 0;
        date_            date;
        v_tva number;
        begin
        execute immediate 'alter session set nls_date_format = ''dd/mm/yyyy''';
        execute immediate 'alter session set NLS_NUMERIC_CHARACTERS = '',.''';
    --**************************************************
        delete prob_migration 
        where nom_table in('miwtfacture-gc','SEQ_RELEVE','miwtfactureligne-gc');
        insert into prob_migration (nom_table)values(SYSTIMESTAMP||'   START MIWT_FACTURE_AS400GC');
        V_FAC_NUM        := 0;
        select max(to_number(MFAE_REF))  into V_FAC_NUM from miwtfactureentete ;
        --select max(to_number(MREL_REF)) into v_ref_releve FROM miwtreleve ;
        COMMIT;

        for facture_ in (select * from facture_as400gc ) loop
            V_FAC_NUM        := nvl(V_FAC_NUM,0) +1;
      --**************************************************
            select last_day(to_date('01'||lpad(facture_.refc01,2,'0')||facture_.refc02,'ddmmyy')) 
            into date_
            from dual;
            periode_ := facture_.refc01;
            annee_   := to_char(date_,'yyyy');
            V_FAC_RESTANTDU  := null;
            V_FAC_DATECALCUL := null;
            V_FAC_ABN_NUM    := null;
            begin
              --hkh 17/07/2018 : modification et ajout index
               select to_date(lpad(trim(DATEXP),8,'0'),'ddmmyyyy'),
                 to_date(lpad(trim(DATL),8,'0'),'ddmmyyyy')    
                 into  V_FAC_DATECALCUL,V_FAC_DATELIM 
                 from role_mens
                 where to_number(facture_.pol)=POLICE
                 AND to_number(facture_.Dist) = DISTR
                 And to_number(facture_.refc01) = MOIS
                 AND rownum = 1;
            exception
            when others then
                 err_code := SQLCODE;
                 err_msg  := SUBSTR(SQLERRM, 1, 200);
                 insert into prob_migration
                 (nom_table, val_ref, sql_err,date_pro,type_problem )
                 values
                 ('miwtfacture-gc','Date facture pol '||facture_.pol||'M1 :'||facture_.refc01||'M2 :'||facture_.refc02,
                 err_msg ||'-- periode-',sysdate,'ce pas anomalie :erreur recuperation de date a partire la table role_mens');

            end;
            if V_FAC_DATECALCUL is null then
            BEGIN
               select (r.mrel_date+1) 
               INTO  V_FAC_DATECALCUL 
               from  miwtreleve_gc r
               where r.mrel_refpdl =
               lpad(facture_.DIST,2,'0')||
               lpad(facture_.tou,3,'0')||
               lpad(facture_.ORD,3,'0')||
               lpad(facture_.POL,5,'0')
               and mrel_refpdl is not null
               and  r.annee = annee_
               and  r.periode = periode_
               and rownum=1;
             Exception  when others then
                 begin
                   select (r.mrel_date+1) 
                   INTO  V_FAC_DATECALCUL 
                   from  miwtreleve_gc_1 r
                   where r.mrel_refpdl =
                    lpad(facture_.DIST,2,'0')||
                    lpad(facture_.tou,3,'0')||
                    lpad(facture_.ORD,3,'0')||
                    lpad(facture_.POL,5,'0')
                    and mrel_refpdl is not null
                    and   r.annee = annee_
                    and   r.periode = periode_
                    and rownum=1;
                 Exception  when others then
                         V_FAC_DATECALCUL := date_;
                         V_FAC_DATELIM :=date_;
                 end;
            end;
        end if;
        -- reception de l'identfiant de l'abonnement
        V_REF_ABN := lpad(trim(facture_.DIST),2,'0')||
                     lpad(to_char(facture_.pol),5,'0') ||
                     lpad(trim(facture_.tou),3,'0') ||
                     lpad(trim(facture_.ORD),3,'0');
                     
        V_TRAIN_FACT :=  'ANNEE:'||trim(annee_) ||' MOIS:'||trim(periode_);
      
        v_ID_FACTURE:=lpad(trim(facture_.DIST),2,'0')||
                    lpad(trim(facture_.tou),3,'0') ||
                     lpad(trim(facture_.ORD),3,'0')||
                     to_char(annee_)||lpad(to_char(periode_),2,0)||to_char(version);

      /*   select count(*) into nbr_trt 
         from miwtfactureentete where MFAE_RDET = v_ID_FACTURE
         and MFAE_SOURCE = 'DIST'||v_district;
         if nbr_trt=1 then goto xx;  end if;*/
        --hkh : 17/07/2018 : inutil
        /*
        for ref_abn_ in (select *
                           from miwabn a
                          where substr(a.abn_refsite,1,13) = lpad(facture_.dist,2,'0') ||
                        lpad(facture_.tou,3,'0') ||
                        lpad(facture_.ord,3,'0') ||
                        lpad(to_char(facture_.pol),5,'0')) loop
          V_FAC_ABN_NUM := ref_abn_.abn_ref;
        end loop;*/
        --if V_FAC_ABN_NUM  is null then
        V_FAC_ABN_NUM := lpad(trim(facture_.dist),2,'0') ||
                        lpad(trim(facture_.tou),3,'0') ||
                        lpad(trim(facture_.ord),3,'0') ||
                        lpad(trim(facture_.pol),5,'0');
        -- end if;

      v_mrel_ref:=null;
 
v_TVA:=(facture_.tva_ff+facture_.tva_capit+facture_.tva_pfin+facture_.tvacons+facture_.tva_preav+ facture_.tvaferm+facture_.tvadeplac+facture_.tvadepose_dem+facture_.tvadepose_def);
        -- Insertion de la facture
        begin
        insert into miwtfactureentete
        (
        MFAE_SOURCE            ,--1  VARCHAR2(100)  N      Code source/origine de la facture [OBL]
        MFAE_REF               ,--2  VARCHAR2(100)  N      Identifiant unique de la facture pour la source [OBL]
        MFAE_REFTRF            ,--3  VARCHAR2(100)  Y      Identifiant du train de la facture
        MFAE_NUME              ,--4  NUMBER(10)     Y      Numero de la facture [OBL]
        MFAE_RDET              ,--5  VARCHAR2(15)   Y      RDET de la facture
        MFAE_CCMO              ,--6  VARCHAR2(1)    Y      Cle controle RDET de la facture
        MFAE_DEDI              ,--7  DATE           N      Date d edition de la facture [OBL]
        MFAE_DLPAI             ,--8  DATE           Y      Date limite de paiement de la facture [OBL]
        MFAE_DPREL             ,--9  DATE           Y      Date de prelevement de la facture [OBL]
        MFAE_TOTHTE            ,--10 NUMBER(10,2)   N      Total HT EAU de la facture [OBL]
        MFAE_TOTTVAE           ,--11 NUMBER(10,2)   N      Total TVA EAU de la facture [OBL]
        MFAE_TOTHTA            ,--12 NUMBER(10,2)   N      Total HT ASS de la facture [OBL]
        MFAE_TOTTVAA           ,--13 NUMBER(10,2)   N      Total TVA ASS de la facture [OBL]
        MFAE_SOLDE             ,--14 NUMBER(10,2)   Y      Solde TTC de la facture
        MFAE_TYPE              ,--15 VARCHAR2(2)    N  'R'
        MFAE_REFFAEDEDU        ,--16 VARCHAR2(100)  Y
        MFAE_REFABN            ,--17 VARCHAR2(100)  N      Identifiant du contrat de la facture [OBL]
        MFAE_REF_CODNIV_RELANCE,--18 VARCHAR2(100)  Y      Reference Code niveau de chainde relance
        MFAE_RIB_REF           ,--19 VARCHAR2(100)  Y      Reference Rib
        MFAE_RIB_ETAT          ,--20 NUMBER(1)      Y      Mode de payement (pr?l?vement 1 ou tip 2)
        MFAE_COMPTEAUX         ,--21 VARCHAR2(100)  Y      Compte auxilaire GENACCOUNT associe a la facture
        MFAE_REF_ORIGINE       ,--22 VARCHAR2(100)  Y      Facture origine
        MFAE_COMMENT           ,--23 VARCHAR2(4000) Y      Commentaire libre Facture
        MFAE_AMOUNTTTCDEC      ,--24 NUMBER(17,10)  Y      Montant TTC a deduire
        VOC_MODEFACT           ,--25 VARCHAR2(10)   Y
        MFAE_REF_DEDUC         ,--26 VARCHAR2(100)  Y
        MFAE_REFORGA           ,--27 VARCHAR2(100)  Y
        MFAE_EXERCICE          ,--28 NUMBER(4)      Y      Exercice du role de la facture
        MFAE_NUMEROROLE        ,--29 NUMBER(4)      Y      Numero du role pour l exercice
        MFAE_PREL              ,--30 NUMBER         Y
        MREL_REF                --31
        )
       values
       (
        'DIST'||lpad(trim(facture_.dist),2,'0'),--1
        V_FAC_NUM         ,--2
        V_TRAIN_FACT      ,--3
        V_FAC_NUM         ,--4
        v_ID_FACTURE      ,--5
        NULL              ,--6
        V_FAC_DATECALCUL  ,--7
        V_FAC_DATELIM     ,--8
        V_FAC_DATECALCUL  ,--9
        (facture_.monttrim-(v_tva))/1000,--10
        (v_tva)/1000,--11
        0                 ,--12
        0                 ,--13
        facture_.monttrim/1000,--14
        'FC'              ,--15
        NULL              ,--16
        V_FAC_ABN_NUM     ,--17
        'INCONNUE'        ,--18
         null             ,--19
        4                 ,--20
        'IMP_MIG'         ,--21
        null              ,--22
        V_REF_ABN         ,--23
        NULL              ,--24
        4                 ,--25
        NULL              ,--26
        lpad(trim(facture_.dist),2,'0'),--27
        annee_            ,--28
        periode_          ,--29
        1                 ,--30
        v_mrel_ref         --31
        );
        exception
          when others then
            err_code := SQLCODE;
            err_msg  := SUBSTR(SQLERRM, 1, 200);
            insert into prob_migration
              (nom_table, val_ref, sql_err, date_pro,type_problem)
            values
              ('miwtfacture-gc',
               lpad(facture_.dist,2,'0') ||
               lpad(facture_.tou,3,'0') ||
               lpad(facture_.ord,3,'0') ||
               lpad(facture_.pol,5,'0'),
               err_code || '--' || err_msg,
               sysdate,'erreur de confomité de type colonne'
               );
        end;
-------------------------------------------------------------------------------
--------------------------------------------------- LIGNE FACTURE CONSOMMATION SONNEDE
if to_number(facture_.montt1) <> 0 then
         begin
         insert into miwtfactureligne
             (
                MFAL_SOURCE    ,--  VARCHAR2(100)  N      Code source/origine de la ligne [OBL]
                MFAL_REFFAE    ,--  VARCHAR2(100)  N      Identifiant de la facture de la ligne [OBL]
                MFAL_REFTAP    ,--  VARCHAR2(100)  N      Identifiant de la periode de tarif de la ligne [OBL]
                MFAL_REFART    ,--  VARCHAR2(100)  Y
                MFAL_LIBE      ,--  VARCHAR2(200)  Y
                MFAL_NUM       ,--  NUMBER(4)      N
                MFAL_TRAN      ,--  NUMBER(1)      N  1   Tranche de la ligne [OBL]
                MFAL_EXER      ,--  NUMBER(4)      N      Annee exercice de la ligne [OBL]
                MFAL_VOLU      ,--  NUMBER(15,3)   N      Volume facture de la ligne [OBL]
                MFAL_PU        ,--  NUMBER(12,6)   N      P.U. facture de la ligne [OBL]
                MFAL_MTHT      ,--  NUMBER(15,2)   N      Montant HT de la ligne [OBL]
                MFAL_MTVA      ,--  NUMBER(15,2)   N      Montant TVA de la ligne [OBL]
                MFAL_TTVA      ,--  NUMBER(15,2)   N      Taux de TVA de la ligne [OBL]
                MFAL_MTTC      ,--  NUMBER(15,2)   N
                MFAL_DDEBPERFAC,--  DATE           Y      Date de debut de la periode facturee de la ligne
                MFAL_DFINPERFAC,--  DATE           Y      Date de fin de la periode facturee de la ligne
                MFAL_DETAIL     --  NUMBER         Y
                )
                values
               (
               'DIST'||lpad(facture_.dist,2,'0'),
                V_FAC_NUM        ,
                1                ,
                'CSM_STD'        ,
                'consommation sonede 1ere Tranche',
                1                ,
                1                ,
                annee_           ,
                facture_.const1  ,
                facture_.tauxt1/1000,
                facture_.montt1/1000,
                facture_.tvacons/1000,
                18                ,
                facture_.montt1/1000+(facture_.tvacons/1000),
                null              ,
                DATE_             ,
                null
                );
           exception
          when others then
            err_code := SQLCODE;
            err_msg  := SUBSTR(SQLERRM, 1, 200);
            insert into prob_migration
              (nom_table, val_ref, sql_err, date_pro,type_problem)
            values
              ('miwtfactureligne-gc',
               V_FAC_NUM,
               err_code || '--' || err_msg,
               sysdate,
               'erreur de confomité de type colonne');
        end;
end if;

if to_number(facture_.montt2) <> 0 then
         begin
         insert into miwtfactureligne
               (
                MFAL_SOURCE     ,--  VARCHAR2(100)  N  Code source/origine de la ligne [OBL]
                MFAL_REFFAE     ,--  VARCHAR2(100)  N  Identifiant de la facture de la ligne [OBL]
                MFAL_REFTAP     ,--  VARCHAR2(100)  N  Identifiant de la periode de tarif de la ligne [OBL]
                MFAL_REFART     ,--  VARCHAR2(100)  Y
                MFAL_LIBE       ,--  VARCHAR2(200)  Y
                MFAL_NUM        ,--  NUMBER(4)      N
                MFAL_TRAN       ,--  NUMBER(1)      N 1 Tranche de la ligne [OBL]
                MFAL_EXER       ,--  NUMBER(4)      N   Annee exercice de la ligne [OBL]
                MFAL_VOLU       ,--  NUMBER(15,3)   N   Volume facture de la ligne [OBL]
                MFAL_PU         ,--  NUMBER(12,6)   N   P.U. facture de la ligne [OBL]
                MFAL_MTHT       ,--  NUMBER(15,2)   N   Montant HT de la ligne [OBL]
                MFAL_MTVA       ,--  NUMBER(15,2)   N   Montant TVA de la ligne [OBL]
                MFAL_TTVA       ,--  NUMBER(15,2)   N   Taux de TVA de la ligne [OBL]
                MFAL_MTTC       ,--  NUMBER(15,2)   N
                MFAL_DDEBPERFAC ,--  DATE           Y   Date de debut de la periode facturee de la ligne
                MFAL_DFINPERFAC ,--  DATE           Y   Date de fin de la periode facturee de la ligne
                MFAL_DETAIL      --  NUMBER         Y
                )
                values
               (
               'DIST'||lpad(facture_.dist,2,'0'),
                V_FAC_NUM        ,
                1                ,
                'CSM_STD'        ,
                'consommation sonede 2eme Tranche',
                2                ,
                2                ,
                annee_           ,
                facture_.const2  ,
                facture_.tauxt2/1000,
                facture_.montt2/1000,
                facture_.tvacons/1000,
                18               ,
                facture_.montt2/1000+(facture_.tvacons/1000),
                null             ,
                DATE_            ,
                null
                );
           exception
          when others then
            err_code := SQLCODE;
            err_msg  := SUBSTR(SQLERRM, 1, 200);
            insert into prob_migration
              (nom_table, val_ref, sql_err, date_pro,type_problem)
            values
              ('miwtfactureligne-gc',
               V_FAC_NUM,
               err_code || '--' || err_msg,
               sysdate,
               'erreur de confomité de type colonne');
        end;
end if;

if to_number(facture_.montt3) <> 0 then
         begin
         insert into miwtfactureligne
             (
                MFAL_SOURCE    ,--  VARCHAR2(100)  N  Code source/origine de la ligne [OBL]
                MFAL_REFFAE    ,--  VARCHAR2(100)  N  Identifiant de la facture de la ligne [OBL]
                MFAL_REFTAP    ,--  VARCHAR2(100)  N  Identifiant de la periode de tarif de la ligne [OBL]
                MFAL_REFART    ,--  VARCHAR2(100)  Y
                MFAL_LIBE      ,--  VARCHAR2(200)  Y
                MFAL_NUM       ,--  NUMBER(4)      N
                MFAL_TRAN      ,--  NUMBER(1)      N 1 Tranche de la ligne [OBL]
                MFAL_EXER      ,--  NUMBER(4)      N   Annee exercice de la ligne [OBL]
                MFAL_VOLU      ,--  NUMBER(15,3)   N   Volume facture de la ligne [OBL]
                MFAL_PU        ,--  NUMBER(12,6)   N   P.U. facture de la ligne [OBL]
                MFAL_MTHT      ,--  NUMBER(15,2)   N   Montant HT de la ligne [OBL]
                MFAL_MTVA      ,--  NUMBER(15,2)   N   Montant TVA de la ligne [OBL]
                MFAL_TTVA      ,--  NUMBER(15,2)   N   Taux de TVA de la ligne [OBL]
                MFAL_MTTC      ,--  NUMBER(15,2)   N
                MFAL_DDEBPERFAC,--  DATE           Y   Date de debut de la periode facturee de la ligne
                MFAL_DFINPERFAC,--  DATE           Y   Date de fin de la periode facturee de la ligne
                MFAL_DETAIL     --  NUMBER         Y
                )
                values
               (
               'DIST'||lpad(facture_.dist,2,'0'),
                V_FAC_NUM        ,
                1                ,
                'CSM_STD'        ,
                'consommation sonede 3eme Tranche',
                3                ,
                3                ,
                annee_           ,
                facture_.const3  ,
                facture_.tauxt3/1000,
                facture_.montt3/1000,
                facture_.tvacons/1000,
                18               ,
                facture_.montt3/1000+(facture_.tvacons/1000),
                null             ,
                DATE_            ,
                null
                );
           exception
          when others then
            err_code := SQLCODE;
            err_msg  := SUBSTR(SQLERRM, 1, 200);
            insert into prob_migration
              (nom_table, val_ref, sql_err, date_pro,type_problem)
            values
              ('miwtfactureligne-gc',
               V_FAC_NUM,
               err_code || '--' || err_msg,
               sysdate,
               'erreur de confomité de type colonne');
        end;
end if;

    --------------------------------------------------- LIGNE FACTURE CONSOMMATION ONAS
if to_number(facture_.mon1) <> 0 then
         begin
         insert into miwtfactureligne
              (
                MFAL_SOURCE    ,--  VARCHAR2(100)  N   Code source/origine de la ligne [OBL]
                MFAL_REFFAE    ,--  VARCHAR2(100)  N   Identifiant de la facture de la ligne [OBL]
                MFAL_REFTAP    ,--  VARCHAR2(100)  N   Identifiant de la periode de tarif de la ligne [OBL]
                MFAL_REFART    ,--  VARCHAR2(100)  Y
                MFAL_LIBE      ,--  VARCHAR2(200)  Y
                MFAL_NUM       ,--  NUMBER(4)      N
                MFAL_TRAN      ,--  NUMBER(1)      N 1  Tranche de la ligne [OBL]
                MFAL_EXER      ,--  NUMBER(4)      N    Annee exercice de la ligne [OBL]
                MFAL_VOLU      ,--  NUMBER(15,3)   N    Volume facture de la ligne [OBL]
                MFAL_PU        ,--  NUMBER(12,6)   N    P.U. facture de la ligne [OBL]
                MFAL_MTHT      ,--  NUMBER(15,2)   N    Montant HT de la ligne [OBL]
                MFAL_MTVA      ,--  NUMBER(15,2)   N    Montant TVA de la ligne [OBL]
                MFAL_TTVA      ,--  NUMBER(15,2)   N    Taux de TVA de la ligne [OBL]
                MFAL_MTTC      ,--  NUMBER(15,2)   N
                MFAL_DDEBPERFAC,--  DATE           Y    Date de debut de la periode facturee de la ligne
                MFAL_DFINPERFAC,--  DATE           Y    Date de fin de la periode facturee de la ligne
                MFAL_DETAIL     --  NUMBER         Y
                )
                values
               (
               'DIST'||lpad(facture_.dist,2,'0'),
                V_FAC_NUM        ,
                2                ,
                'VAR_ONAS_1'     ,
                'Redevance onas 1ere Tranche',
                4                ,
                1                ,
                annee_           ,
                facture_.volon1  ,
                facture_.tauon1/1000,
                facture_.mon1/1000,
                0                ,
                0                ,
                facture_.mon1/1000,
                null             ,
                DATE_            ,
                null
                );
           exception
          when others then
            err_code := SQLCODE;
            err_msg  := SUBSTR(SQLERRM, 1, 200);
            insert into prob_migration
              (nom_table, val_ref, sql_err, date_pro,type_problem)
            values
              ('miwtfactureligne-gc',
               V_FAC_NUM,
               err_code || '--' || err_msg,
               sysdate,
               'erreur de confomité de type colonne');
        end;
end if;

if to_number(facture_.mon2) <> 0 then
         begin
         insert into miwtfactureligne
              (
                MFAL_SOURCE    ,--  VARCHAR2(100)  N  Code source/origine de la ligne [OBL]
                MFAL_REFFAE    ,--  VARCHAR2(100)  N  Identifiant de la facture de la ligne [OBL]
                MFAL_REFTAP    ,--  VARCHAR2(100)  N  Identifiant de la periode de tarif de la ligne [OBL]
                MFAL_REFART    ,--  VARCHAR2(100)  Y
                MFAL_LIBE      ,--  VARCHAR2(200)  Y
                MFAL_NUM       ,--  NUMBER(4)      N
                MFAL_TRAN      ,--  NUMBER(1)      N 1 Tranche de la ligne [OBL]
                MFAL_EXER      ,--  NUMBER(4)      N   Annee exercice de la ligne [OBL]
                MFAL_VOLU      ,--  NUMBER(15,3)   N   Volume facture de la ligne [OBL]
                MFAL_PU        ,--  NUMBER(12,6)   N   P.U. facture de la ligne [OBL]
                MFAL_MTHT      ,--  NUMBER(15,2)   N   Montant HT de la ligne [OBL]
                MFAL_MTVA      ,--  NUMBER(15,2)   N   Montant TVA de la ligne [OBL]
                MFAL_TTVA      ,--  NUMBER(15,2)   N   Taux de TVA de la ligne [OBL]
                MFAL_MTTC      ,--  NUMBER(15,2)   N
                MFAL_DDEBPERFAC,--  DATE           Y   Date de debut de la periode facturee de la ligne
                MFAL_DFINPERFAC,--  DATE           Y   Date de fin de la periode facturee de la ligne
                MFAL_DETAIL     --  NUMBER         Y
                )
                values
               (
               'DIST'||lpad(facture_.dist,2,'0'),
                V_FAC_NUM        ,
                2                ,
                'VAR_ONAS_1'     ,
                'Redevance onas 2eme Tranche',
                5                ,
                2                ,
                annee_           ,
                facture_.volon2  ,
                facture_.tauon2/1000,
                facture_.mon2/1000,
                0                ,
                0                ,
                facture_.mon2/1000,
                null             ,
                DATE_            ,
                null
                );
           exception
          when others then
            err_code := SQLCODE;
            err_msg  := SUBSTR(SQLERRM, 1, 200);
            insert into prob_migration
              (nom_table, val_ref, sql_err, date_pro,type_problem)
            values
              ('miwtfactureligne-gc',
               V_FAC_NUM,
               err_code || '--' || err_msg,
               sysdate,
               'erreur de confomité de type colonne');
        end;
end if;

if to_number(facture_.mon3) <> 0 then
         begin
         insert into miwtfactureligne
            (
                MFAL_SOURCE     ,--  VARCHAR2(100) N   Code source/origine de la ligne [OBL]
                MFAL_REFFAE     ,--  VARCHAR2(100) N   Identifiant de la facture de la ligne [OBL]
                MFAL_REFTAP     ,--  VARCHAR2(100) N   Identifiant de la periode de tarif de la ligne [OBL]
                MFAL_REFART     ,--  VARCHAR2(100) Y
                MFAL_LIBE       ,--  VARCHAR2(200) Y
                MFAL_NUM        ,--  NUMBER(4)     N
                MFAL_TRAN       ,--  NUMBER(1)     N  1 Tranche de la ligne [OBL]
                MFAL_EXER       ,--  NUMBER(4)     N   Annee exercice de la ligne [OBL]
                MFAL_VOLU       ,--  NUMBER(15,3)  N   Volume facture de la ligne [OBL]
                MFAL_PU         ,--  NUMBER(12,6)  N   P.U. facture de la ligne [OBL]
                MFAL_MTHT       ,--  NUMBER(15,2)  N   Montant HT de la ligne [OBL]
                MFAL_MTVA       ,--  NUMBER(15,2)  N   Montant TVA de la ligne [OBL]
                MFAL_TTVA       ,--  NUMBER(15,2)  N   Taux de TVA de la ligne [OBL]
                MFAL_MTTC       ,--  NUMBER(15,2)  N
                MFAL_DDEBPERFAC ,--  DATE          Y   Date de debut de la periode facturee de la ligne
                MFAL_DFINPERFAC ,--  DATE          Y   Date de fin de la periode facturee de la ligne
                MFAL_DETAIL      --  NUMBER        Y
                )
                values
               (
               'DIST'||lpad(facture_.dist,2,'0'),
                V_FAC_NUM        ,
                2                ,
                'VAR_ONAS_1'     ,
                'Redevance onas 3eme Tranche',
                6                ,
                3                ,
                annee_           ,
                facture_.volon3  ,
                facture_.tauon3/1000,
                facture_.mon3/1000,
                0                ,
                0                ,
                facture_.mon3/1000,
                null             ,
                DATE_            ,
                null
                );
           exception
          when others then
            err_code := SQLCODE;
            err_msg  := SUBSTR(SQLERRM, 1, 200);
            insert into prob_migration
              (nom_table, val_ref, sql_err, date_pro,type_problem)
            values
              ('miwtfactureligne-gc',
               V_FAC_NUM,
               err_code || '--' || err_msg,
               sysdate,
               'erreur de confomité de type colonne');
        end;
end if;

if to_number(facture_.fixonas) <> 0 then
         begin
         insert into miwtfactureligne
              (
                MFAL_SOURCE,--  VARCHAR2(100) N    Code source/origine de la ligne [OBL]
                MFAL_REFFAE,--  VARCHAR2(100) N    Identifiant de la facture de la ligne [OBL]
                MFAL_REFTAP,--  VARCHAR2(100) N    Identifiant de la periode de tarif de la ligne [OBL]
                MFAL_REFART,--  VARCHAR2(100) Y
                MFAL_LIBE  ,--  VARCHAR2(200) Y
                MFAL_NUM   ,--  NUMBER(4)     N
                MFAL_TRAN  ,--  NUMBER(1)     N  1 Tranche de la ligne [OBL]
                MFAL_EXER  ,--  NUMBER(4)     N    Annee exercice de la ligne [OBL]
                MFAL_VOLU  ,--  NUMBER(15,3)  N    Volume facture de la ligne [OBL]
                MFAL_PU    ,--  NUMBER(12,6)  N    P.U. facture de la ligne [OBL]
                MFAL_MTHT  ,--  NUMBER(15,2)  N    Montant HT de la ligne [OBL]
                MFAL_MTVA  ,--  NUMBER(15,2)  N    Montant TVA de la ligne [OBL]
                MFAL_TTVA  ,--  NUMBER(15,2)  N    Taux de TVA de la ligne [OBL]
                MFAL_MTTC  ,--  NUMBER(15,2)  N
                MFAL_DDEBPERFAC,--  DATE  Y      Date de debut de la periode facturee de la ligne
                MFAL_DFINPERFAC,--  DATE  Y      Date de fin de la periode facturee de la ligne
                MFAL_DETAIL --  NUMBER  Y
                )
                values
               (
               'DIST'||lpad(facture_.dist,2,'0'),
                V_FAC_NUM        ,
                2                ,
                'FIXE_ONAS_1'    ,
                'Frais fixe onas',
                7                ,
                1                ,
                annee_           ,
                1                ,
                facture_.fixonas/1000,
                facture_.fixonas/1000,
                0                ,
                0                ,
                facture_.fixonas/1000,
                null             ,
                DATE_            ,
                null
                );
           exception
          when others then
            err_code := SQLCODE;
            err_msg  := SUBSTR(SQLERRM, 1, 200);
            insert into prob_migration
              (nom_table, val_ref, sql_err, date_pro,type_problem)
            values
              ('miwtfactureligne-gc',
               V_FAC_NUM,
               err_code || '--' || err_msg,
               sysdate,
               'erreur de confomité de type colonne');
        end;
end if;
/*
if to_number(facture_.FRLETTRE) <> 0 then
         begin
         insert into miwtfactureligne
              (
                MFAL_SOURCE,--  VARCHAR2(100) N    Code source/origine de la ligne [OBL]
                MFAL_REFFAE,--  VARCHAR2(100) N    Identifiant de la facture de la ligne [OBL]
                MFAL_REFTAP,--  VARCHAR2(100) N    Identifiant de la periode de tarif de la ligne [OBL]
                MFAL_REFART,--  VARCHAR2(100) Y
                MFAL_LIBE  ,--  VARCHAR2(200) Y
                MFAL_NUM   ,--  NUMBER(4)     N
                MFAL_TRAN  ,--  NUMBER(1)     N  1 Tranche de la ligne [OBL]
                MFAL_EXER  ,--  NUMBER(4)     N    Annee exercice de la ligne [OBL]
                MFAL_VOLU  ,--  NUMBER(15,3)  N    Volume facture de la ligne [OBL]
                MFAL_PU    ,--  NUMBER(12,6)  N    P.U. facture de la ligne [OBL]
                MFAL_MTHT  ,--  NUMBER(15,2)  N    Montant HT de la ligne [OBL]
                MFAL_MTVA  ,--  NUMBER(15,2)  N    Montant TVA de la ligne [OBL]
                MFAL_TTVA  ,--  NUMBER(15,2)  N    Taux de TVA de la ligne [OBL]
                MFAL_MTTC  ,--  NUMBER(15,2)  N
                MFAL_DDEBPERFAC,--  DATE  Y      Date de debut de la periode facturee de la ligne
                MFAL_DFINPERFAC,--  DATE  Y      Date de fin de la periode facturee de la ligne
                MFAL_DETAIL--  NUMBER  Y
                )
                values
               (
               'DIST'||lpad(facture_.dist,2,'0'),
                V_FAC_NUM        ,
                1                ,
                'FRAIS_FRM_DEP'  ,
                'Frais lettre '  ,
                8                ,
                1                ,
                annee_           ,
                1                ,
                1.900            ,
                1.900            ,
                0                ,
                0                ,
                1.900            ,
                null             ,
                DATE_            ,
                null
               );
           exception
          when others then
            err_code := SQLCODE;
            err_msg  := SUBSTR(SQLERRM, 1, 200);
            insert into prob_migration
              (nom_table, val_ref, sql_err, date_pro,type_problem)
            values
              ('miwtfactureligne-gc',
               V_FAC_NUM,
               err_code || '--' || err_msg,
               sysdate,
               'erreur de confomité de type colonne');
        end;
end if;*/

if to_number(facture_.fraisctr) <> 0 then
         begin
         insert into miwtfactureligne
              (
                MFAL_SOURCE,--  VARCHAR2(100) N     Code source/origine de la ligne [OBL]
                MFAL_REFFAE,--  VARCHAR2(100) N     Identifiant de la facture de la ligne [OBL]
                MFAL_REFTAP,--  VARCHAR2(100) N     Identifiant de la periode de tarif de la ligne [OBL]
                MFAL_REFART,--  VARCHAR2(100) Y
                MFAL_LIBE  ,--  VARCHAR2(200) Y
                MFAL_NUM   ,--  NUMBER(4)     N
                MFAL_TRAN  ,--  NUMBER(1)     N  1  Tranche de la ligne [OBL]
                MFAL_EXER  ,--  NUMBER(4)     N     Annee exercice de la ligne [OBL]
                MFAL_VOLU  ,--  NUMBER(15,3)  N     Volume facture de la ligne [OBL]
                MFAL_PU    ,--  NUMBER(12,6)  N     P.U. facture de la ligne [OBL]
                MFAL_MTHT  ,--  NUMBER(15,2)  N     Montant HT de la ligne [OBL]
                MFAL_MTVA  ,--  NUMBER(15,2)  N     Montant TVA de la ligne [OBL]
                MFAL_TTVA  ,--  NUMBER(15,2)  N     Taux de TVA de la ligne [OBL]
                MFAL_MTTC  ,--  NUMBER(15,2)  N
                MFAL_DDEBPERFAC,--  DATE  Y      Date de debut de la periode facturee de la ligne
                MFAL_DFINPERFAC,--  DATE  Y      Date de fin de la periode facturee de la ligne
                MFAL_DETAIL--  NUMBER  Y
                )
                values
               (
               'DIST'||lpad(facture_.dist,2,'0'),
                V_FAC_NUM        ,
                1                ,
                'FRS_FIX_CSM'    ,
                'Frais fixe sonnede',
                9                ,
                1                ,
                annee_           ,
                1                ,
                facture_.fraisctr/1000,
                facture_.fraisctr/1000,
                facture_.tva_ff/1000,
                18               ,
                facture_.fraisctr/1000+(facture_.TVA_ff/1000),
                null             ,
                DATE_            ,
                null
                );
           exception
          when others then
            err_code := SQLCODE;
            err_msg  := SUBSTR(SQLERRM, 1, 200);
            insert into prob_migration
              (nom_table, val_ref, sql_err, date_pro,type_problem)
            values
              ('miwtfactureligne-gc',
               V_FAC_NUM,
               err_code || '--' || err_msg,
               sysdate,
               'erreur de confomité de type colonne');
        end;
end if;
/*
if to_number(facture_.FRferm) <> 0 then
         begin
         insert into miwtfactureligne
               (
                MFAL_SOURCE,--  VARCHAR2(100) N    Code source/origine de la ligne [OBL]
                MFAL_REFFAE,--  VARCHAR2(100) N   Identifiant de la facture de la ligne [OBL]
                MFAL_REFTAP,--  VARCHAR2(100) N   Identifiant de la periode de tarif de la ligne [OBL]
                MFAL_REFART,--  VARCHAR2(100) Y
                MFAL_LIBE  ,--  VARCHAR2(200) Y
                MFAL_NUM   ,--  NUMBER(4)     N
                MFAL_TRAN  ,--  NUMBER(1)     N  1    Tranche de la ligne [OBL]
                MFAL_EXER  ,--  NUMBER(4)     N  Annee exercice de la ligne [OBL]
                MFAL_VOLU  ,--  NUMBER(15,3)  N  Volume facture de la ligne [OBL]
                MFAL_PU    ,--  NUMBER(12,6)  N  P.U. facture de la ligne [OBL]
                MFAL_MTHT  ,--  NUMBER(15,2)  N  Montant HT de la ligne [OBL]
                MFAL_MTVA  ,--  NUMBER(15,2)  N  Montant TVA de la ligne [OBL]
                MFAL_TTVA  ,--  NUMBER(15,2)  N  Taux de TVA de la ligne [OBL]
                MFAL_MTTC  ,--  NUMBER(15,2)  N
                MFAL_DDEBPERFAC,--  DATE  Y      Date de debut de la periode facturee de la ligne
                MFAL_DFINPERFAC,--  DATE  Y      Date de fin de la periode facturee de la ligne
                MFAL_DETAIL--  NUMBER  Y
                )
                values
               (
               'DIST'||lpad(facture_.dist,2,'0'),
                V_FAC_NUM        ,
                1                ,
                'FRAIS-FERM'     ,
                'Frais FERMETURE',
                10               ,
                1                ,
                annee_           ,
                1                ,
                facture_.FRFERM/1000,
                facture_.FRFERM/1000,
                facture_.tvaferm/1000  ,
                0                ,
                facture_.FRFERM/1000,
                null             ,
                DATE_            ,
                null
                );
           exception
          when others then
            err_code := SQLCODE;
            err_msg  := SUBSTR(SQLERRM, 1, 200);
            insert into prob_migration
              (nom_table, val_ref, sql_err, date_pro,type_problem)
            values
              ('miwtfactureligne-gc',
               V_FAC_NUM,
               err_code || '--' || err_msg,
               sysdate,'erreur de confomité de type colonne');
        end;
end if;
*/

if to_number(facture_.CAPIT) <> 0 then
         begin
         insert into miwtfactureligne
              (
                MFAL_SOURCE,--  VARCHAR2(100) N      Code source/origine de la ligne [OBL]
                MFAL_REFFAE,--  VARCHAR2(100) N      Identifiant de la facture de la ligne [OBL]
                MFAL_REFTAP,--  VARCHAR2(100) N      Identifiant de la periode de tarif de la ligne [OBL]
                MFAL_REFART,--  VARCHAR2(100) Y
                MFAL_LIBE  ,--  VARCHAR2(200) Y
                MFAL_NUM   ,--  NUMBER(4)     N
                MFAL_TRAN  ,--  NUMBER(1)     N  1    Tranche de la ligne [OBL]
                MFAL_EXER  ,--  NUMBER(4)     N      Annee exercice de la ligne [OBL]
                MFAL_VOLU  ,--  NUMBER(15,3)  N      Volume facture de la ligne [OBL]
                MFAL_PU    ,--  NUMBER(12,6)  N      P.U. facture de la ligne [OBL]
                MFAL_MTHT  ,--  NUMBER(15,2)  N      Montant HT de la ligne [OBL]
                MFAL_MTVA  ,--  NUMBER(15,2)  N      Montant TVA de la ligne [OBL]
                MFAL_TTVA  ,--  NUMBER(15,2)  N      Taux de TVA de la ligne [OBL]
                MFAL_MTTC  ,--  NUMBER(15,2)  N
                MFAL_DDEBPERFAC,--  DATE  Y      Date de debut de la periode facturee de la ligne
                MFAL_DFINPERFAC,--  DATE  Y      Date de fin de la periode facturee de la ligne
                MFAL_DETAIL--  NUMBER  Y
                )
                values
               (
               'DIST'||lpad(facture_.dist,2,'0'),
                V_FAC_NUM        ,
                2                ,
                'CAPITAL'        ,
                'Montant capital',
                11               ,
                1                ,
                annee_           ,
                1                ,
                facture_.CAPIT/1000,
                facture_.CAPIT/1000,
                facture_.tva_capit/1000,
                0                ,
                facture_.CAPIT/1000,
                null             ,
                DATE_            ,
                null
                );
           exception
          when others then
            err_code := SQLCODE;
            err_msg  := SUBSTR(SQLERRM, 1, 200);
            insert into prob_migration
              (nom_table, val_ref, sql_err, date_pro,type_problem)
            values
              ('miwtfactureligne-gc',
               V_FAC_NUM,
               err_code || '--' || err_msg,
               sysdate,
               'erreur de confomité de type colonne');
        end;
end if;

if to_number(facture_.INTER) <> 0 then
         begin
         insert into miwtfactureligne
              (
                MFAL_SOURCE,--  VARCHAR2(100)  N      Code source/origine de la ligne [OBL]
                MFAL_REFFAE,--  VARCHAR2(100)  N      Identifiant de la facture de la ligne [OBL]
                MFAL_REFTAP,--  VARCHAR2(100)  N      Identifiant de la periode de tarif de la ligne [OBL]
                MFAL_REFART,--  VARCHAR2(100)  Y
                MFAL_LIBE  ,--  VARCHAR2(200)  Y
                MFAL_NUM   ,--  NUMBER(4)  N
                MFAL_TRAN  ,--  NUMBER(1)  N  1    Tranche de la ligne [OBL]
                MFAL_EXER  ,--  NUMBER(4)  N      Annee exercice de la ligne [OBL]
                MFAL_VOLU  ,--  NUMBER(15,3)  N      Volume facture de la ligne [OBL]
                MFAL_PU    ,--  NUMBER(12,6)  N      P.U. facture de la ligne [OBL]
                MFAL_MTHT  ,--  NUMBER(15,2)  N      Montant HT de la ligne [OBL]
                MFAL_MTVA  ,--  NUMBER(15,2)  N      Montant TVA de la ligne [OBL]
                MFAL_TTVA  ,--  NUMBER(15,2)  N      Taux de TVA de la ligne [OBL]
                MFAL_MTTC  ,--  NUMBER(15,2)  N
                MFAL_DDEBPERFAC,--  DATE  Y      Date de debut de la periode facturee de la ligne
                MFAL_DFINPERFAC,--  DATE  Y      Date de fin de la periode facturee de la ligne
                MFAL_DETAIL--  NUMBER  Y
                )
                values
               (
               'DIST'||lpad(facture_.dist,2,'0'),
                V_FAC_NUM        ,
                2                ,
                'INTERET'        ,
                'Montant Interet',
                12               ,
                1                ,
                annee_           ,
                1                ,
                facture_.INTER/1000,
                facture_.INTER/1000,
                0                ,
                0                ,
                facture_.INTER/1000,
                null             ,
                DATE_            ,
                null
                );
           exception
          when others then
            err_code := SQLCODE;
            err_msg  := SUBSTR(SQLERRM, 1, 200);
            insert into prob_migration
              (nom_table, val_ref, sql_err, date_pro,type_problem)
            values
              ('miwtfactureligne-gc',
               V_FAC_NUM,
               err_code || '--' || err_msg,
               sysdate,
               'erreur de confomité de type colonne');
        end;
end if;

if to_number(facture_.RBRANCHE) <> 0 then
         begin
         insert into miwtfactureligne
              (
                MFAL_SOURCE,--  VARCHAR2(100) N      Code source/origine de la ligne [OBL]
                MFAL_REFFAE,--  VARCHAR2(100) N      Identifiant de la facture de la ligne [OBL]
                MFAL_REFTAP,--  VARCHAR2(100) N      Identifiant de la periode de tarif de la ligne [OBL]
                MFAL_REFART,--  VARCHAR2(100) Y
                MFAL_LIBE  ,--  VARCHAR2(200) Y
                MFAL_NUM   ,--  NUMBER(4)     N
                MFAL_TRAN  ,--  NUMBER(1)     N  1    Tranche de la ligne [OBL]
                MFAL_EXER  ,--  NUMBER(4)     N      Annee exercice de la ligne [OBL]
                MFAL_VOLU  ,--  NUMBER(15,3)  N      Volume facture de la ligne [OBL]
                MFAL_PU    ,--  NUMBER(12,6)  N      P.U. facture de la ligne [OBL]
                MFAL_MTHT  ,--  NUMBER(15,2)  N      Montant HT de la ligne [OBL]
                MFAL_MTVA  ,--  NUMBER(15,2)  N      Montant TVA de la ligne [OBL]
                MFAL_TTVA  ,--  NUMBER(15,2)  N      Taux de TVA de la ligne [OBL]
                MFAL_MTTC  ,--  NUMBER(15,2)  N
                MFAL_DDEBPERFAC,--  DATE      Y      Date de debut de la periode facturee de la ligne
                MFAL_DFINPERFAC,--  DATE      Y      Date de fin de la periode facturee de la ligne
                MFAL_DETAIL--  NUMBER         Y
                )
                values
               (
               'DIST'||lpad(facture_.dist,2,'0'),
                V_FAC_NUM        ,
                1                ,
                'COURETABBR'     ,
                'Montant branchement',
                13               ,
                1                ,
                annee_           ,
                1                ,
                facture_.RBRANCHE/1000,
                facture_.RBRANCHE/1000,
                0                ,
                0                ,
                facture_.RBRANCHE/1000,
                null             ,
                DATE_            ,
                null
                );
           exception
          when others then
            err_code := SQLCODE;
            err_msg  := SUBSTR(SQLERRM, 1, 200);
            insert into prob_migration
              (nom_table, val_ref, sql_err, date_pro,type_problem)
            values
              ('miwtfactureligne-gc',
               V_FAC_NUM,
               err_code || '--' || err_msg,
               sysdate,
               'erreur de confomité de type colonne');
        end;
end if;

if to_number(facture_.RFACADE) <> 0 then
         begin
         insert into miwtfactureligne
               (
                MFAL_SOURCE,--  VARCHAR2(100) N      Code source/origine de la ligne [OBL]
                MFAL_REFFAE,--  VARCHAR2(100) N      Identifiant de la facture de la ligne [OBL]
                MFAL_REFTAP,--  VARCHAR2(100) N      Identifiant de la periode de tarif de la ligne [OBL]
                MFAL_REFART,--  VARCHAR2(100) Y
                MFAL_LIBE  ,--  VARCHAR2(200) Y
                MFAL_NUM   ,--  NUMBER(4)     N
                MFAL_TRAN  ,--  NUMBER(1)     N  1   Tranche de la ligne [OBL]
                MFAL_EXER  ,--  NUMBER(4)     N      Annee exercice de la ligne [OBL]
                MFAL_VOLU  ,--  NUMBER(15,3)  N      Volume facture de la ligne [OBL]
                MFAL_PU    ,--  NUMBER(12,6)  N      P.U. facture de la ligne [OBL]
                MFAL_MTHT  ,--  NUMBER(15,2)  N      Montant HT de la ligne [OBL]
                MFAL_MTVA  ,--  NUMBER(15,2)  N      Montant TVA de la ligne [OBL]
                MFAL_TTVA  ,--  NUMBER(15,2)  N      Taux de TVA de la ligne [OBL]
                MFAL_MTTC  ,--  NUMBER(15,2)  N
                MFAL_DDEBPERFAC,--  DATE  Y      Date de debut de la periode facturee de la ligne
                MFAL_DFINPERFAC,--  DATE  Y      Date de fin de la periode facturee de la ligne
                MFAL_DETAIL--  NUMBER  Y
                )
                values
               (
               'DIST'||lpad(facture_.dist,2,'0'),
                V_FAC_NUM        ,
                1                ,
                'RFACADE'        ,
                'Montant facade' ,
                14               ,
                1                ,
                annee_           ,
                1                ,
                facture_.RFACADE/1000,
                facture_.RFACADE/1000,
                0                ,
                0                ,
                facture_.RFACADE/1000,
                null             ,
                DATE_            ,
                null
                );
           exception
          when others then
            err_code := SQLCODE;
            err_msg  := SUBSTR(SQLERRM, 1, 200);
            insert into prob_migration
              (nom_table, val_ref, sql_err, date_pro,type_problem)
            values
              ('miwtfactureligne-gc',
               V_FAC_NUM,
               err_code || '--' || err_msg,
               sysdate,
               'erreur de confomité de type colonne');
        end;
end if;
/*
if to_number(facture_.REXTENSION) <> 0 then
         begin
         insert into miwtfactureligne
              (
                MFAL_SOURCE,--  VARCHAR2(100)  N      Code source/origine de la ligne [OBL]
                MFAL_REFFAE,--  VARCHAR2(100)  N      Identifiant de la facture de la ligne [OBL]
                MFAL_REFTAP,--  VARCHAR2(100)  N      Identifiant de la periode de tarif de la ligne [OBL]
                MFAL_REFART,--  VARCHAR2(100)  Y
                MFAL_LIBE  ,--  VARCHAR2(200)  Y
                MFAL_NUM   ,--  NUMBER(4)  N
                MFAL_TRAN  ,--  NUMBER(1)  N  1    Tranche de la ligne [OBL]
                MFAL_EXER  ,--  NUMBER(4)  N      Annee exercice de la ligne [OBL]
                MFAL_VOLU  ,--  NUMBER(15,3)  N      Volume facture de la ligne [OBL]
                MFAL_PU    ,--  NUMBER(12,6)  N      P.U. facture de la ligne [OBL]
                MFAL_MTHT  ,--  NUMBER(15,2)  N      Montant HT de la ligne [OBL]
                MFAL_MTVA  ,--  NUMBER(15,2)  N      Montant TVA de la ligne [OBL]
                MFAL_TTVA  ,--  NUMBER(15,2)  N      Taux de TVA de la ligne [OBL]
                MFAL_MTTC  ,--  NUMBER(15,2)  N
                MFAL_DDEBPERFAC,--  DATE  Y      Date de debut de la periode facturee de la ligne
                MFAL_DFINPERFAC,--  DATE  Y      Date de fin de la periode facturee de la ligne
                MFAL_DETAIL--  NUMBER  Y
                )
                values
               (
               'DIST'||lpad(facture_.dist,2,'0'),
                V_FAC_NUM        ,
                1                ,
                'REXTENSION'     ,
                'Montant extension',
                15               ,
                1                ,
                annee_           ,
                1                ,
                facture_.REXTENSION/1000,
                facture_.REXTENSION/1000,
                0                ,
                0                ,
                facture_.REXTENSION/1000,
                null             ,
                DATE_            ,
                null
                );
           exception
          when others then
            err_code := SQLCODE;
            err_msg  := SUBSTR(SQLERRM, 1, 200);
            insert into prob_migration
              (nom_table, val_ref, sql_err, date_pro,type_problem)
            values
              ('miwtfactureligne-gc',
               V_FAC_NUM,
               err_code || '--' || err_msg,
               sysdate,
               'erreur de confomité de type colonne');
        end;
end if;*/
/*
if to_number(facture_.REXTENSION) <> 0 then
         begin
         insert into miwtfactureligne
               (
                MFAL_SOURCE,--  VARCHAR2(100)  N      Code source/origine de la ligne [OBL]
                MFAL_REFFAE,--  VARCHAR2(100)  N      Identifiant de la facture de la ligne [OBL]
                MFAL_REFTAP,--  VARCHAR2(100)  N      Identifiant de la periode de tarif de la ligne [OBL]
                MFAL_REFART,--  VARCHAR2(100)  Y
                MFAL_LIBE  ,--  VARCHAR2(200)  Y
                MFAL_NUM   ,--  NUMBER(4)  N
                MFAL_TRAN  ,--  NUMBER(1)  N  1    Tranche de la ligne [OBL]
                MFAL_EXER  ,--  NUMBER(4)  N      Annee exercice de la ligne [OBL]
                MFAL_VOLU  ,--  NUMBER(15,3)  N      Volume facture de la ligne [OBL]
                MFAL_PU    ,--  NUMBER(12,6)  N      P.U. facture de la ligne [OBL]
                MFAL_MTHT  ,--  NUMBER(15,2)  N      Montant HT de la ligne [OBL]
                MFAL_MTVA  ,--  NUMBER(15,2)  N      Montant TVA de la ligne [OBL]
                MFAL_TTVA  ,--  NUMBER(15,2)  N      Taux de TVA de la ligne [OBL]
                MFAL_MTTC  ,--  NUMBER(15,2)  N
                MFAL_DDEBPERFAC,--  DATE  Y      Date de debut de la periode facturee de la ligne
                MFAL_DFINPERFAC,--  DATE  Y      Date de fin de la periode facturee de la ligne
                MFAL_DETAIL--  NUMBER  Y
                )
                values
               (
               'DIST'||lpad(facture_.dist,2,'0'),
                V_FAC_NUM        ,
                1                ,
                'PFINANCIER'     ,
                'PRODUIT FINANCIER',
                16               ,
                1                ,
                annee_           ,
                1                ,
                facture_.PFINANCIER/1000,
                facture_.PFINANCIER/1000,
                facture_.tva_pfin/1000 ,
                0                ,
                facture_.PFINANCIER/1000,
                null             ,
                DATE_            ,
                null
                );
           exception
          when others then
            err_code := SQLCODE;
            err_msg  := SUBSTR(SQLERRM, 1, 200);
            insert into prob_migration
              (nom_table, val_ref, sql_err, date_pro)
            values
              ('miwtfactureligne-gc',
               V_FAC_NUM,
               err_code || '--' || err_msg,
               sysdate);
        end;
end if;*/
  ---------------
if to_number(facture_.AREPOR) <> 0 then
         begin
         insert into miwtfactureligne
               (
                MFAL_SOURCE,--  VARCHAR2(100)  N      Code source/origine de la ligne [OBL]
                MFAL_REFFAE,--  VARCHAR2(100)  N      Identifiant de la facture de la ligne [OBL]
                MFAL_REFTAP,--  VARCHAR2(100)  N      Identifiant de la periode de tarif de la ligne [OBL]
                MFAL_REFART,--  VARCHAR2(100)  Y
                MFAL_LIBE  ,--  VARCHAR2(200)  Y
                MFAL_NUM   ,--  NUMBER(4)  N
                MFAL_TRAN  ,--  NUMBER(1)  N  1    Tranche de la ligne [OBL]
                MFAL_EXER  ,--  NUMBER(4)  N      Annee exercice de la ligne [OBL]
                MFAL_VOLU  ,--  NUMBER(15,3)  N      Volume facture de la ligne [OBL]
                MFAL_PU    ,--  NUMBER(12,6)  N      P.U. facture de la ligne [OBL]
                MFAL_MTHT  ,--  NUMBER(15,2)  N      Montant HT de la ligne [OBL]
                MFAL_MTVA  ,--  NUMBER(15,2)  N      Montant TVA de la ligne [OBL]
                MFAL_TTVA  ,--  NUMBER(15,2)  N      Taux de TVA de la ligne [OBL]
                MFAL_MTTC  ,--  NUMBER(15,2)  N
                MFAL_DDEBPERFAC,--  DATE  Y      Date de debut de la periode facturee de la ligne
                MFAL_DFINPERFAC,--  DATE  Y      Date de fin de la periode facturee de la ligne
                MFAL_DETAIL--  NUMBER  Y
                )
                values
               (
               'DIST'||lpad(facture_.dist,2,'0'),
                V_FAC_NUM        ,
                1                ,
                'AREPOR'         ,
                'Montant report' ,
                17               ,
                1                ,
                annee_           ,
                1                ,
                decode(facture_.caron,'1',1,-1)* (facture_.AREPOR/1000),
                decode(facture_.caron,'1',1,-1)* (facture_.AREPOR/1000),
                0                ,
                0                ,
                decode(facture_.caron,'1',1,-1)* (facture_.AREPOR/1000),
                null             ,
                DATE_            ,
                null
                );
           exception
          when others then
            err_code := SQLCODE;
            err_msg  := SUBSTR(SQLERRM, 1, 200);
            insert into prob_migration
              (nom_table, val_ref, sql_err, date_pro,type_problem)
            values
              ('miwtfactureligne-gc',
               V_FAC_NUM,
               err_code || '--' || err_msg,
               sysdate,
               'erreur de confomité de type colonne');
        end;
end if;

if to_number(facture_.NAROND) <> 0 then
         begin
         insert into miwtfactureligne
              (
                MFAL_SOURCE,--  VARCHAR2(100)  N      Code source/origine de la ligne [OBL]
                MFAL_REFFAE,--  VARCHAR2(100)  N      Identifiant de la facture de la ligne [OBL]
                MFAL_REFTAP,--  VARCHAR2(100)  N      Identifiant de la periode de tarif de la ligne [OBL]
                MFAL_REFART,--  VARCHAR2(100)  Y
                MFAL_LIBE  ,--  VARCHAR2(200)  Y
                MFAL_NUM   ,--  NUMBER(4)  N
                MFAL_TRAN  ,--  NUMBER(1)  N  1    Tranche de la ligne [OBL]
                MFAL_EXER  ,--  NUMBER(4)  N      Annee exercice de la ligne [OBL]
                MFAL_VOLU  ,--  NUMBER(15,3)  N      Volume facture de la ligne [OBL]
                MFAL_PU    ,--  NUMBER(12,6)  N      P.U. facture de la ligne [OBL]
                MFAL_MTHT  ,--  NUMBER(15,2)  N      Montant HT de la ligne [OBL]
                MFAL_MTVA  ,--  NUMBER(15,2)  N      Montant TVA de la ligne [OBL]
                MFAL_TTVA  ,--  NUMBER(15,2)  N      Taux de TVA de la ligne [OBL]
                MFAL_MTTC  ,--  NUMBER(15,2)  N
                MFAL_DDEBPERFAC,--  DATE  Y      Date de debut de la periode facturee de la ligne
                MFAL_DFINPERFAC,--  DATE  Y      Date de fin de la periode facturee de la ligne
                MFAL_DETAIL--  NUMBER  Y
                )
                values
               (
               'DIST'||lpad(facture_.dist,2,'0'),
                V_FAC_NUM        ,
                1                ,
                'NAROND'         ,
                'Arrondissement' ,
                18               ,
                1                ,
                annee_           ,
                1                ,
                decode(facture_.caron,'1',-1,1)*(facture_.NAROND/1000),
                decode(facture_.caron,'1',-1,1)*(facture_.NAROND/1000),
                0                ,
                0                ,
                decode(facture_.caron,'1',-1,1)*(facture_.NAROND/1000),
                null             ,
                DATE_            ,
                null
                );
           exception
          when others then
            err_code := SQLCODE;
            err_msg  := SUBSTR(SQLERRM, 1, 200);
            insert into prob_migration
              (nom_table, val_ref, sql_err, date_pro,type_problem)
            values
              ('miwtfactureligne-gc',
               V_FAC_NUM,
               err_code || '--' || err_msg,
               sysdate,
               'erreur de confomité de type colonne');
        end;
end if;
/*
if to_number(facture_.DIVERS) <> 0 then
         begin
         insert into miwtfactureligne
              (
                MFAL_SOURCE,--  VARCHAR2(100)  N      Code source/origine de la ligne [OBL]
                MFAL_REFFAE,--  VARCHAR2(100)  N      Identifiant de la facture de la ligne [OBL]
                MFAL_REFTAP,--  VARCHAR2(100)  N      Identifiant de la periode de tarif de la ligne [OBL]
                MFAL_REFART,--  VARCHAR2(100)  Y
                MFAL_LIBE  ,--  VARCHAR2(200)  Y
                MFAL_NUM   ,--  NUMBER(4)  N
                MFAL_TRAN  ,--  NUMBER(1)  N  1    Tranche de la ligne [OBL]
                MFAL_EXER  ,--  NUMBER(4)  N      Annee exercice de la ligne [OBL]
                MFAL_VOLU  ,--  NUMBER(15,3)  N      Volume facture de la ligne [OBL]
                MFAL_PU    ,--  NUMBER(12,6)  N      P.U. facture de la ligne [OBL]
                MFAL_MTHT  ,--  NUMBER(15,2)  N      Montant HT de la ligne [OBL]
                MFAL_MTVA  ,--  NUMBER(15,2)  N      Montant TVA de la ligne [OBL]
                MFAL_TTVA  ,--  NUMBER(15,2)  N      Taux de TVA de la ligne [OBL]
                MFAL_MTTC  ,--  NUMBER(15,2)  N
                MFAL_DDEBPERFAC,--  DATE  Y      Date de debut de la periode facturee de la ligne
                MFAL_DFINPERFAC,--  DATE  Y      Date de fin de la periode facturee de la ligne
                MFAL_DETAIL--  NUMBER  Y
                )
                values
               (
               'DIST'||lpad(facture_.dist,2,'0'),
                V_FAC_NUM        ,
                1                ,
                'AUTREFRAIS'     ,
                'Frais Divers '  ,
                20               ,
                1                ,
                annee_           ,
                1                ,
                (facture_.DIVERS)/1000,
                (facture_.DIVERS)/1000,
                0                ,
                0                ,
                (facture_.DIVERS)/1000,
                null             ,
                DATE_            ,
                null
                );
           exception
          when others then
            err_code := SQLCODE;
            err_msg  := SUBSTR(SQLERRM, 1, 200);
            insert into prob_migration
              (nom_table, val_ref, sql_err, date_pro,type_problem)
            values
              ('miwtfactureligne-gc',
               V_FAC_NUM,
               err_code || '--' || err_msg,
               sysdate,
               'erreur de confomité de type colonne');
        end;
end if;*/
/*
if to_number(facture_.EAUPUIT) <> 0 then
         begin
         insert into miwtfactureligne
               (
                MFAL_SOURCE,--  VARCHAR2(100)  N      Code source/origine de la ligne [OBL]
                MFAL_REFFAE,--  VARCHAR2(100)  N      Identifiant de la facture de la ligne [OBL]
                MFAL_REFTAP,--  VARCHAR2(100)  N      Identifiant de la periode de tarif de la ligne [OBL]
                MFAL_REFART,--  VARCHAR2(100)  Y
                MFAL_LIBE  ,--  VARCHAR2(200)  Y
                MFAL_NUM   ,--  NUMBER(4)  N
                MFAL_TRAN  ,--  NUMBER(1)  N  1    Tranche de la ligne [OBL]
                MFAL_EXER  ,--  NUMBER(4)  N      Annee exercice de la ligne [OBL]
                MFAL_VOLU  ,--  NUMBER(15,3)  N      Volume facture de la ligne [OBL]
                MFAL_PU    ,--  NUMBER(12,6)  N      P.U. facture de la ligne [OBL]
                MFAL_MTHT  ,--  NUMBER(15,2)  N      Montant HT de la ligne [OBL]
                MFAL_MTVA  ,--  NUMBER(15,2)  N      Montant TVA de la ligne [OBL]
                MFAL_TTVA  ,--  NUMBER(15,2)  N      Taux de TVA de la ligne [OBL]
                MFAL_MTTC  ,--  NUMBER(15,2)  N
                MFAL_DDEBPERFAC,--  DATE  Y      Date de debut de la periode facturee de la ligne
                MFAL_DFINPERFAC,--  DATE  Y      Date de fin de la periode facturee de la ligne
                MFAL_DETAIL--  NUMBER  Y
                )
                values
               (
               'DIST'||lpad(facture_.dist,2,'0'),
                V_FAC_NUM        ,
                1                ,
                'VAR_ONAS_C'     ,
                'Eau de puit '   ,
                21               ,
                1                ,
                annee_           ,
                1                ,
                (facture_.EAUPUIT)/1000,
                (facture_.EAUPUIT)/1000,
                0                ,
                0                ,
                (facture_.EAUPUIT)/1000,
                null             ,
                DATE_            ,
                null
                );
           exception
          when others then
            err_code := SQLCODE;
            err_msg  := SUBSTR(SQLERRM, 1, 200);
            insert into prob_migration
              (nom_table, val_ref, sql_err, date_pro,type_problem)
            values
              ('miwtfactureligne-gc',
               V_FAC_NUM,
               err_code || '--' || err_msg,
               sysdate,
               'erreur de confomité de type colonne');
        end;
      end if;
      */
      
      --hkh : Ajouter les lignes des frais : deplacement, depose clent, depose non pai
       if to_number(facture_.deplacement) <> 0 then -- frais de deplacement
          begin
            insert into miwtfactureligne
                  (
                    MFAL_SOURCE    ,--1  VARCHAR2(100)  N    Code source/origine de la ligne [OBL]
                    MFAL_REFFAE    ,--2  VARCHAR2(100)  N    Identifiant de la facture de la ligne [OBL]
                    MFAL_REFTAP    ,--3  VARCHAR2(100)  N    Identifiant de la periode de tarif de la ligne [OBL]
                    MFAL_REFART    ,--4  VARCHAR2(100)  Y
                    MFAL_LIBE      ,--5  VARCHAR2(200)  Y
                    MFAL_NUM       ,--6  NUMBER(4)      N
                    MFAL_TRAN      ,--7  NUMBER(1)      N  1  Tranche de la ligne [OBL]
                    MFAL_EXER      ,--8  NUMBER(4)      N     Annee exercice de la ligne [OBL]
                    MFAL_VOLU      ,--9  NUMBER(15,3)   N     Volume facture de la ligne [OBL]
                    MFAL_PU        ,--10 NUMBER(12,6)   N     P.U. facture de la ligne [OBL]
                    MFAL_MTHT      ,--11 NUMBER(15,2)   N     Montant HT de la ligne [OBL]
                    MFAL_MTVA      ,--12 NUMBER(15,2)   N     Montant TVA de la ligne [OBL]
                    MFAL_TTVA      ,--13 NUMBER(15,2)   N     Taux de TVA de la ligne [OBL]
                    MFAL_MTTC      ,--14 NUMBER(15,2)   N
                    MFAL_DDEBPERFAC,--15 DATE           Y     Date de debut de la periode facturee de la ligne
                    MFAL_DFINPERFAC,--16 DATE           Y     Date de fin de la periode facturee de la ligne
                    MFAL_DETAIL     --17 NUMBER         Y
                    )
                    values
                   (
                    'DIST'||lpad(trim(facture_.dist),2,'0'),--1
                    V_FAC_NUM         ,--2
                    1                 ,--3
                    'F_DEPLACEMNT',--4
                    'Frais de déplacement' ,--5
                    22                ,--6
                    1                 ,--7
                    annee_        ,--8
                    1                 ,--9
                    facture_.deplacement/1000,--10
                    facture_.deplacement/1000,--11
                    facture_.tvadeplac/1000 ,--12
                    18                 ,--13
                    facture_.deplacement/1000 + (facture_.tvadeplac/1000),--14
                    null              ,--15
                    DATE_             ,--16
                    null               --17
                     );
          exception
            when others then
                err_code := SQLCODE;
                err_msg  := SUBSTR(SQLERRM, 1, 200);
                insert into prob_migration
                (nom_table, val_ref, sql_err, date_pro,type_problem)
                values
                ('miwtfactureligne',
                V_FAC_NUM,
                err_code || '--' || err_msg,sysdate,'erreur de confomité de type colonne');  
          end;
        end if;
            
        if to_number(facture_.depose_dem) <> 0 then -- frais de depose demande client
          begin
            insert into miwtfactureligne
                  (
                    MFAL_SOURCE    ,--1  VARCHAR2(100)  N    Code source/origine de la ligne [OBL]
                    MFAL_REFFAE    ,--2  VARCHAR2(100)  N    Identifiant de la facture de la ligne [OBL]
                    MFAL_REFTAP    ,--3  VARCHAR2(100)  N    Identifiant de la periode de tarif de la ligne [OBL]
                    MFAL_REFART    ,--4  VARCHAR2(100)  Y
                    MFAL_LIBE      ,--5  VARCHAR2(200)  Y
                    MFAL_NUM       ,--6  NUMBER(4)      N
                    MFAL_TRAN      ,--7  NUMBER(1)      N  1  Tranche de la ligne [OBL]
                    MFAL_EXER      ,--8  NUMBER(4)      N     Annee exercice de la ligne [OBL]
                    MFAL_VOLU      ,--9  NUMBER(15,3)   N     Volume facture de la ligne [OBL]
                    MFAL_PU        ,--10 NUMBER(12,6)   N     P.U. facture de la ligne [OBL]
                    MFAL_MTHT      ,--11 NUMBER(15,2)   N     Montant HT de la ligne [OBL]
                    MFAL_MTVA      ,--12 NUMBER(15,2)   N     Montant TVA de la ligne [OBL]
                    MFAL_TTVA      ,--13 NUMBER(15,2)   N     Taux de TVA de la ligne [OBL]
                    MFAL_MTTC      ,--14 NUMBER(15,2)   N
                    MFAL_DDEBPERFAC,--15 DATE           Y     Date de debut de la periode facturee de la ligne
                    MFAL_DFINPERFAC,--16 DATE           Y     Date de fin de la periode facturee de la ligne
                    MFAL_DETAIL     --17 NUMBER         Y
                    )
                    values
                   (
                    'DIST'||lpad(trim(facture_.dist),2,'0'),--1
                    V_FAC_NUM         ,--2
                    1                 ,--3
                    'FRAIS_FRM_DEP',--4
                    'Frais de dépose suite à la demande du client' ,--5
                    23                ,--6
                    1                 ,--7
                    annee_        ,--8
                    1                 ,--9
                    facture_.depose_dem/1000,--10
                    facture_.depose_dem/1000,--11
                    facture_.tvadepose_dem/1000 ,--12
                    18                 ,--13
                    facture_.depose_dem/1000 + (facture_.tvadepose_dem/1000),--14
                    null              ,--15
                    DATE_             ,--16
                    null               --17
                     );
          exception
            when others then
                err_code := SQLCODE;
                err_msg  := SUBSTR(SQLERRM, 1, 200);
                insert into prob_migration
                (nom_table, val_ref, sql_err, date_pro,type_problem)
                values
                ('miwtfactureligne',
                V_FAC_NUM,
                err_code || '--' || err_msg,sysdate,'erreur de confomité de type colonne');  
          end;
        end if;
            
        if to_number(facture_.depose_def) <> 0 then -- frais de depose suite defaut de paiement
          begin
            insert into miwtfactureligne
                  (
                    MFAL_SOURCE    ,--1  VARCHAR2(100)  N    Code source/origine de la ligne [OBL]
                    MFAL_REFFAE    ,--2  VARCHAR2(100)  N    Identifiant de la facture de la ligne [OBL]
                    MFAL_REFTAP    ,--3  VARCHAR2(100)  N    Identifiant de la periode de tarif de la ligne [OBL]
                    MFAL_REFART    ,--4  VARCHAR2(100)  Y
                    MFAL_LIBE      ,--5  VARCHAR2(200)  Y
                    MFAL_NUM       ,--6  NUMBER(4)      N
                    MFAL_TRAN      ,--7  NUMBER(1)      N  1  Tranche de la ligne [OBL]
                    MFAL_EXER      ,--8  NUMBER(4)      N     Annee exercice de la ligne [OBL]
                    MFAL_VOLU      ,--9  NUMBER(15,3)   N     Volume facture de la ligne [OBL]
                    MFAL_PU        ,--10 NUMBER(12,6)   N     P.U. facture de la ligne [OBL]
                    MFAL_MTHT      ,--11 NUMBER(15,2)   N     Montant HT de la ligne [OBL]
                    MFAL_MTVA      ,--12 NUMBER(15,2)   N     Montant TVA de la ligne [OBL]
                    MFAL_TTVA      ,--13 NUMBER(15,2)   N     Taux de TVA de la ligne [OBL]
                    MFAL_MTTC      ,--14 NUMBER(15,2)   N
                    MFAL_DDEBPERFAC,--15 DATE           Y     Date de debut de la periode facturee de la ligne
                    MFAL_DFINPERFAC,--16 DATE           Y     Date de fin de la periode facturee de la ligne
                    MFAL_DETAIL     --17 NUMBER         Y
                    )
                    values
                   (
                    'DIST'||lpad(trim(facture_.dist),2,'0'),--1
                    V_FAC_NUM         ,--2
                    1                 ,--3
                    'FRS_DPOZ_RPOZ',--4
                    'Frais de dépose suite au non paiement' ,--5
                    24                ,--6
                    1                 ,--7
                    annee_        ,--8
                    1                 ,--9
                    facture_.depose_def/1000,--10
                    facture_.depose_def/1000,--11
                    facture_.tvadepose_def/1000,--12
                    18                 ,--13
                    facture_.depose_def/1000 + (facture_.tvadepose_def/1000),--14
                    null              ,--15
                    DATE_             ,--16
                    null               --17
                     );
          exception
            when others then
                err_code := SQLCODE;
                err_msg  := SUBSTR(SQLERRM, 1, 200);
                insert into prob_migration
                (nom_table, val_ref, sql_err, date_pro,type_problem)
                values
                ('miwtfactureligne',
                V_FAC_NUM,
                err_code || '--' || err_msg,sysdate,'erreur de confomité de type colonne');  
          end;
        end if;
      ------------------------------------------------------------------------------------
    <<XX>>
commit;
end loop;
/*
      delete xx;
       insert into xx  select  substr(s.mfae_rdet,1,2) distirct,substr(s.mfae_rdet,3,3) tourne,substr(s.mfae_rdet,6,3) ordre ,substr(s.mfae_rdet,9,4)annee,
        substr(s.mfae_rdet,13,2) periode,t.mfal_reffae,sum(t.mfal_mttc) net_calc,s.mfae_solde net,sum(t.mfal_mttc)-s.mfae_solde diff,
        sum(decode(t.mfal_refart,'CAPITAL',t.mfal_mttc,'INTERET',t.mfal_mttc,0)) capit
         from miwtfactureligne t,miwtfactureentete s
         where t.mfal_reffae=s.mfae_ref
         group by t.mfal_reffae,s.mfae_solde,substr(s.mfae_rdet,1,2),substr(s.mfae_rdet,3,3),substr(s.mfae_rdet,6,3),substr(s.mfae_rdet,9,4),substr(s.mfae_rdet,13,2)
         having ((abs(sum(t.mfal_mttc)-s.mfae_solde) <>0)) ;
       commit;

          for c in (select t.*, t.rowid from XX t WHERE diff >= 0.001)
   loop
     select count(*) into x from miwtfactureligne s where s.mfal_reffae=c.mfal_reffae and s.mfal_refart='NAROND'
                                                      And 'DIST'||c.distirct=s.mfal_source;
  if x = 0 then
       insert into miwtfactureligne
               (
                MFAL_SOURCE,--  VARCHAR2(100)  N      Code source/origine de la ligne [OBL]
                MFAL_REFFAE,--  VARCHAR2(100)  N      Identifiant de la facture de la ligne [OBL]
                MFAL_REFTAP,--  VARCHAR2(100)  N      Identifiant de la periode de tarif de la ligne [OBL]
                MFAL_REFART,--  VARCHAR2(100)  Y
                MFAL_LIBE  ,--  VARCHAR2(200)  Y
                MFAL_NUM   ,--  NUMBER(4)  N
                MFAL_TRAN  ,--  NUMBER(1)  N  1    Tranche de la ligne [OBL]
                MFAL_EXER  ,--  NUMBER(4)  N      Annee exercice de la ligne [OBL]
                MFAL_VOLU  ,--  NUMBER(15,3)  N      Volume facture de la ligne [OBL]
                MFAL_PU    ,--  NUMBER(12,6)  N      P.U. facture de la ligne [OBL]
                MFAL_MTHT  ,--  NUMBER(15,2)  N      Montant HT de la ligne [OBL]
                MFAL_MTVA  ,--  NUMBER(15,2)  N      Montant TVA de la ligne [OBL]
                MFAL_TTVA  ,--  NUMBER(15,2)  N      Taux de TVA de la ligne [OBL]
                MFAL_MTTC  ,--  NUMBER(15,2)  N
                MFAL_DDEBPERFAC,--  DATE  Y      Date de debut de la periode facturee de la ligne
                MFAL_DFINPERFAC,--  DATE  Y      Date de fin de la periode facturee de la ligne
                MFAL_DETAIL--  NUMBER  Y
                )
                values
               (
               'DIST'||c.distirct,
                c.mfal_reffae    ,
                1                ,
                'NAROND'         ,
                'Arrondissement' ,
                18               ,
                1                ,
                c.annee          ,
                1                ,
                (-1)*(c.diff)    ,
                (-1)*(c.diff)    ,
                0                ,
                0                ,
                (-1)*(c.diff)    ,
                null             ,
                null             ,
                null
                );
       else
               update miwtfactureligne set MFAL_PU=MFAL_PU-c.diff,
                                           MFAL_MTHT=MFAL_MTHT-c.diff,
                                           MFAL_MTTC=MFAL_MTTC-c.diff
                                           where
                                           mfal_reffae=c.mfal_reffae and mfal_refart='NAROND'
                                            And 'DIST'||c.distirct=mfal_source;
   end if;


  end loop;
  */
           insert into prob_migration (nom_table)values(SYSTIMESTAMP||'   END MIWT_FACTURE_AS400GC');
          commit;



  end;



--******************************************** Traitement des facture District
 procedure MIWT_FACTURE_DIST   is
--********************************* TRAITEMENT DES FACTURES  A PARTIR TABLE facture
      err_code         varchar2(200);
      err_msg          varchar2(200);
      v_MFAE_RDET      varchar2(100);
      v_ID_FACTURE     varchar2(20);
      v_mrel_ref       varchar2(200);
      V_TRAIN_FACT     varchar2(200);
      V_REF_ABN        varchar2(200);
      tiers_           varchar2(1);
      six_             varchar2(1);
      V_FAC_NUM        number;
      V_FAC_RESTANTDU  number;
      V_FAC_ABN_NUM    number(20);
      --nbr_trt          number := 0;
      annee_           number(4);
      periode_         number;
      version          number(1):= 0;
      V_FAC_DATECALCUL date;
      date_            date;
     
      begin
      execute immediate 'alter session set nls_date_format = ''dd/mm/yyyy''';
      execute immediate 'alter session set NLS_NUMERIC_CHARACTERS = '',.''';
    --**************************************************
      delete prob_migration 
      where nom_table in ('miwtfacture-DIST');
      insert into prob_migration (nom_table)values(SYSTIMESTAMP||'   START MIWT_FACTURE_DIST');
      commit;
     -- reception de la liste des releves
      select max(nvl(to_number(MFAE_REF),0)) 
      into  V_FAC_NUM 
      from miwtfactureentete ;
    
      if V_FAC_NUM is null then
      V_FAC_NUM        := 0;
      end if;

      for facture_ in ( select * from facture f
                        where f.annee||trim(f.periode) not in (select j.mfae_exercice||j.mfae_numerorole
                                                                      from miwtfactureentete j
                                                                      where substr(j.mfae_rdet,1,8)= trim(f.DISTRICT)||lpad(trim(f.tournee),3,'0')||
                                                                      lpad(trim(f.ORDRE),3,'0')
                                                               )
                        and f.annee='2015'
                        ) 
       loop

      V_FAC_NUM        := V_FAC_NUM +1;
      --**************************************************
      --Determiner la facture d'origine facture AS400
      v_MFAE_RDET := lpad(trim(facture_.district),2,'0') ||
                    lpad(trim(facture_.tournee),3,'0') ||
                     lpad(trim(facture_.ordre),3,'0')||
                     to_char(facture_.annee) ||
                     lpad(to_char(facture_.periode),2,0)||to_char(version);

      periode_ := facture_.periode;
      select last_day(to_date('01'||lpad(trim(facture_.periode),2,'0')||facture_.annee,'dd/mm/yy'))
      into date_
      from dual;
      ------------------
    /*  begin
          select (r.mrel_date+6) 
          INTO  V_FAC_DATECALCUL 
          from  miwtreleve r
          where r.mrel_refpdl =
          lpad(facture_.DISTRICT,2,'0')||
          lpad(ltrim(rtrim(facture_.tournee)),3,'0')||
          lpad(ltrim(rtrim(facture_.ORDRE)),3,'0')||
          lpad(ltrim(rtrim(facture_.POLICE)),5,'0')
          and mrel_refpdl is not null
          and r.annee = annee_
          and r.periode = periode_
          and rownum=1;
      Exception  when others then
      V_FAC_DATECALCUL := date_;
      end;*/
      
      
        begin
      V_FAC_DATECALCUL := date_;
      Exception  when others then
      V_FAC_DATECALCUL := '01/01/2016';
      end;
      annee_ :=facture_.annee;
      --************************************************
      V_FAC_RESTANTDU  := null;
      V_FAC_ABN_NUM    := null;
      V_REF_ABN        := null;
      begin
         -- reception de l'identfiant de l'abonnement
         v_ID_FACTURE:=lpad(trim(facture_.DISTRICT),2,'0') ||
         lpad(trim(facture_.tournee),3,'0') ||
         lpad(trim(facture_.ORDRE),3,'0')||
         to_char(annee_) ||lpad(to_char(periode_),2,'0')||'0';
      
        /* --mma 18/07/2017 : post migration pour train facturation gro_consom 
        for ref_abn_ in (select a.abn_ref,a.ABN_REFPER_A,a.voc_typsag
                          from miwabn a
                          where substr(a.abn_refsite,1,13) = lpad(facture_.DISTRICT,2,'0') ||
                          lpad(ltrim(rtrim(facture_.tournee)),3,'0') ||
                          lpad(ltrim(rtrim(facture_.Ordre)),3,'0')||
                          lpad(ltrim(rtrim(facture_.POLICE)),5,'0')
                          )
         loop
              V_FAC_ABN_NUM := ref_abn_.abn_ref;
              V_REF_ABN := ref_abn_.ABN_REFPER_A;
          
              if ref_abn_.voc_typsag='G' then
              V_TRAIN_FACT :='ANNEE:'||ltrim(rtrim(facture_.annee))||' MOIS:'||ltrim(rtrim(facture_.periode));
              else
               select NTIERS,NSIXIEME
               into tiers_,six_
               from tourne
               where  trim(code)=lpad(facture_.tournee,3,'0')
               and   trim(district)=trim(facture_.DISTRICT);
               
                V_TRAIN_FACT :='ANNEE:'||trim(facture_.annee) ||
                ' TRIM:'||trim(facture_.periode) ||
                ' TIER:'||trim(tiers_)||
                ' SIX:'||trim(six_ );
              end if;
          
         end loop;

         if V_FAC_ABN_NUM  is null then
            V_FAC_ABN_NUM := lpad(facture_.DISTRICT,2,'0') ||
                          lpad(trim(facture_.tournee),3,'0') ||
                          lpad(trim(facture_.Ordre),3,'0') ||
                          lpad(trim(facture_.POLICE),5,'0');
         end if;*/
          V_FAC_ABN_NUM := lpad(trim(facture_.DISTRICT),2,'0') ||
                          lpad(trim(facture_.tournee),3,'0') ||
                          lpad(trim(facture_.Ordre),3,'0') ||
                          lpad(trim(facture_.POLICE),5,'0');
         
          V_REF_ABN := lpad(trim(facture_.DISTRICT),2,'0') ||
                          lpad(trim(facture_.tournee),3,'0') ||
                          lpad(trim(facture_.Ordre),3,'0') ||
                          lpad(trim(facture_.POLICE),5,'0');
                          
          select NTIERS,NSIXIEME
               into tiers_,six_
               from tourne
               where trim(code)=lpad(trim(facture_.tournee),3,'0')
               and  trim(district)=trim(facture_.DISTRICT);
               
                V_TRAIN_FACT :='ANNEE:'||trim(facture_.annee) ||
                ' TRIM:'||trim(facture_.periode) ||
                ' TIER:'||trim(tiers_)||
                ' SIX:'||trim(six_ );
         
         
      exception
      when others then
      err_code := SQLCODE;
      err_msg  := SUBSTR(SQLERRM, 1, 200);
      insert into prob_migration
      (nom_table, val_ref, sql_err, date_pro,type_problem)
      values
      ('miwtfactureAA-DIST','Tou:'||lpad(trim(facture_.tournee),3,'0')||'ORD:'||lpad(trim(facture_.Ordre),3,'0')||'TRIM :'||facture_.periode||'TIER :'||facture_.TIERS||'AA:'||facture_.ANNEE||'POL:'||lpad(trim(facture_.POLICE),5,'0'),
      err_msg ||'-- periode ',sysdate,' ce pas anomalie :erreur recuperation ref abonner');
      end;
      v_mrel_ref:=null;
      begin
         insert into miwtfactureentete
          (
            MFAE_SOURCE         ,--1   VARCHAR2(100)  N     Code source/origine de la facture [OBL]
            MFAE_REF            ,--2   VARCHAR2(100)  N     Identifiant unique de la facture pour la source [OBL]
            MFAE_REFTRF         ,--3   VARCHAR2(100)  Y     Identifiant du train de la facture
            MFAE_NUME           ,--4   NUMBER(10)     Y     Numero de la facture [OBL]
            MFAE_RDET           ,--5   VARCHAR2(15)   Y     RDET de la facture
            MFAE_CCMO           ,--6   VARCHAR2(1)    Y     Cle controle RDET de la facture
            MFAE_DEDI           ,--7   DATE           N     Date d edition de la facture [OBL]
            MFAE_DLPAI          ,--8   DATE           Y     Date limite de paiement de la facture [OBL]
            MFAE_DPREL          ,--9   DATE           Y     Date de prelevement de la facture [OBL]
            MFAE_TOTHTE         ,--10  NUMBER(10,2)   N     Total HT EAU de la facture [OBL]
            MFAE_TOTTVAE        ,--11  NUMBER(10,2)   N     Total TVA EAU de la facture [OBL]
            MFAE_TOTHTA         ,--12  NUMBER(10,2)   N     Total HT ASS de la facture [OBL]
            MFAE_TOTTVAA        ,--13  NUMBER(10,2)   N     Total TVA ASS de la facture [OBL]
            MFAE_SOLDE          ,--14  NUMBER(10,2)   Y     Solde TTC de la facture
            MFAE_TYPE           ,--15  VARCHAR2(2)    N 'R'
            MFAE_REFFAEDEDU     ,--16  VARCHAR2(100)  Y
            MFAE_REFABN         ,--17  VARCHAR2(100)  N     Identifiant du contrat de la facture [OBL]
            MFAE_REF_CODNIV_RELANCE,--18VARCHAR2(100) Y     Reference Code niveau de chainde relance
            MFAE_RIB_REF        ,--19  VARCHAR2(100)  Y     Reference Rib
            MFAE_RIB_ETAT       ,--20  NUMBER(1)      Y     Mode de payement (pr?l?vement 1 ou tip 2)
            MFAE_COMPTEAUX      ,--21  VARCHAR2(100)  Y     Compte auxilaire GENACCOUNT associe a la facture
            MFAE_REF_ORIGINE    ,--22  VARCHAR2(100)  Y     Facture origine
            MFAE_COMMENT        ,--23  VARCHAR2(4000) Y     Commentaire libre Facture
            MFAE_AMOUNTTTCDEC   ,--24  NUMBER(17,10)  Y     Montant TTC a deduire
            VOC_MODEFACT        ,--25  VARCHAR2(10)   Y
            MFAE_REF_DEDUC      ,--26  VARCHAR2(100)  Y
            MFAE_REFORGA        ,--27  VARCHAR2(100)  Y
            MFAE_EXERCICE       ,--28  NUMBER(4)      Y     Exercice du role de la facture
            MFAE_NUMEROROLE     ,--29  NUMBER(4)      Y     Numero du role pour l exercice
            MFAE_PREL           ,--30  NUMBER         Y
            MFAE_AROND          ,--31  NUMBER         Y
            mrel_ref            --32
          )
        values
         (
          'DIST'||lpad(facture_.DISTRICT,2,'0'),--1
          V_FAC_NUM         ,--2
          V_TRAIN_FACT      ,--3
          V_FAC_NUM         ,--4
          v_ID_FACTURE      ,--5
          NULL              ,--6
          V_FAC_DATECALCUL  ,--7
          V_FAC_DATECALCUL  ,--8
          V_FAC_DATECALCUL  ,--9
          facture_.net_a_payer/1000,--10
          0                 ,--11
          0                 ,--12
          0                 ,--13
          facture_.net_a_payer/1000,--14
          decode(facture_.etat,'P','RF','O','FC','C','FHC','FC'),--15
          NULL              ,--16
          V_FAC_ABN_NUM     ,--17
          'INCONNUE'        ,--18
           null             ,--19
          4                 ,--20
          'IMP_MIG'         ,--21
          v_MFAE_RDET       ,--22
          V_REF_ABN         ,--23
          NULL              ,--24
          4                 ,--25
          NULL              ,--26
          lpad(facture_.DISTRICT,2,'0')        ,--27
          annee_            ,--28
          periode_          ,--29
          1                 ,--30
          0                 ,--31
          v_mrel_ref
         );
        exception
        when others then
            err_code := SQLCODE;
            err_msg  := SUBSTR(SQLERRM, 1, 200);
            insert into prob_migration
            (nom_table, val_ref, sql_err, date_pro,type_problem)
            values
            ('miwtfacture-DIST',
            lpad(facture_.district,2,'0') ||
            lpad(trim(facture_.tournee),3,'0') ||
            lpad(trim(facture_.Ordre),3,'0') ||
            lpad(trim(facture_.POLICE),5,'0'),
            err_code || '--' || err_msg,
            sysdate,'erreur de confomité de type colonne');
        end;
      commit;
      end loop;
      insert into prob_migration (nom_table)values(SYSTIMESTAMP||'   END MIWT_FACTURE_DIST');
      commit;
 end;
--******************************************** Traitement des facture District
 procedure MIWT_FACTURE_VERSION  is
--********************************* TRAITEMENT DES FACTURES  A PARTIR TABLE facture
      err_code         varchar2(200);
      err_msg          varchar2(200);
      v_MFAE_RDET      varchar2(100);
      v_ID_FACTURE     varchar2(20);
      v_mrel_ref       varchar2(200);
      V_TRAIN_FACT     varchar2(200);
      V_REF_ABN        varchar2(200);
      wMFAE_REF        varchar2(100);
      V_FAC_NUM        number;
      V_FAC_RESTANTDU  number;
      V_FAC_DATECALCUL date;
      V_FAC_ABN_NUM    number(20);
      v_date_origine   date;
      annee_           number(4);
      periode_         number;
      mois_            number;
      begin
      execute immediate 'alter session set nls_date_format = ''dd/mm/yyyy''';
      execute immediate 'alter session set NLS_NUMERIC_CHARACTERS = '',.''';
      --**************************************************
      delete prob_migration 
      where nom_table in
      ('miwtfacture-VERSION','SEQ_RELEVE','miwtfactureligne');
      insert into prob_migration (nom_table)values(SYSTIMESTAMP||'   START MIWT_FACTURE_VERSION');
      commit;
      -- reception de la liste des releves
      select max(nvl(to_number(MFAE_REF),0)) 
      into  V_FAC_NUM
      from miwtfactureentete ;
     
      if V_FAC_NUM is null then
      V_FAC_NUM        := 0;
      end if;

      for facture_ in ( select distinct mf.MFAE_RDET, mf.MFAE_DEDI,f.*
                        from facture f,
                        miwtfactureentete mf
                        where f.etat in ('A','P')
                         and mf.mfae_rdet = (trim(f.DISTRICT)||lpad(trim(f.tournee),3,'0')||
                        lpad(trim(f.ORDRE),3,'0')||to_char(f.annee)||lpad(trim(f.periode),2,'0')||'0')
                      ) 
      loop
     V_FAC_NUM        := V_FAC_NUM +1;
      --**************************************************
      --Determiner la facture d'origine facture AS400
      v_MFAE_RDET := facture_.MFAE_RDET;
      v_date_origine := facture_.MFAE_DEDI;
      periode_ := facture_.periode;

      IF facture_.periodicite <> 'G' then
            begin
                select m3 
                 into mois_ 
                from param_tournee 
                where DISTRICT=trim(facture_.district)
                And TRIM =trim(facture_.periode)
                And TIER = facture_.TIERS
                and (TIER,SIX) in (select t.NTIERS,t.NSIXIEME from tourne t
                                  where trim(t.code)=lpad(trim(facture_.tournee),3,'0')
                                  and trim(t.district)=trim(facture_.DISTRICT));
            exception
            when others then
                err_code := SQLCODE;
                err_msg  := SUBSTR(SQLERRM, 1, 200);
                insert into prob_migration
                (nom_table, val_ref, sql_err, type_problem,date_pro)
                values
                ('miwtfacture-VERSION',
                'Tou:'||lpad(ltrim(rtrim(facture_.tournee)),3,'0')||'ORD:'||lpad(ltrim(rtrim(facture_.Ordre)),3,'0')||'TRIM :'||facture_.periode||'TIER :'||facture_.TIERS||'AA:'||facture_.ANNEE||'POL:'||lpad(ltrim(rtrim(facture_.POLICE)),5,'0'),
                err_msg ||'-- periode','ce pas anomalie:erreur recuperation mois a partire de la table param_tournee',sysdate);

                periode_ := facture_.periode;
                IF periode_ = 1 THEN
                mois_:='01';
                ELSIF periode_ = 2 THEN
                mois_:='04';
                ELSIF periode_ = 3 THEN
                mois_:='07';
                ELSIF periode_ = 4 THEN
                mois_:='10';
                end if;
            end;
      else
      mois_ := trim(facture_.periode);
      end if;
      annee_ :=facture_.annee;
     --************************************************
      V_FAC_RESTANTDU  := null;
      V_FAC_DATECALCUL := null;
      V_FAC_ABN_NUM    := null;
      V_REF_ABN        := null;
      
      V_FAC_DATECALCUL := v_date_origine + 5;
            
      begin
          -- reception de l'identfiant de l'abonnement
          v_ID_FACTURE:=lpad(trim(facture_.DISTRICT),2,'0') ||
          lpad(trim(facture_.tournee),3,'0')||
          lpad(trim(facture_.ORDRE),3,'0')||to_char(annee_) ||
          lpad(to_char(periode_),2,'0')||to_char(facture_.version);

          /*for ref_abn_ in (select *
                          from miwabn a
                          where substr(a.abn_refsite,1,8) = lpad(facture_.DISTRICT,2,'0') ||
                          lpad(trim(facture_.tournee),3,'0') ||
                          lpad(trim(facture_.Ordre),3,'0')
          ) loop
          V_FAC_ABN_NUM := ref_abn_.abn_ref;
          V_REF_ABN := ref_abn_.ABN_REFPER_A;
          end loop;
          if V_FAC_ABN_NUM  is null then 
          V_FAC_ABN_NUM := lpad(trim(facture_.DISTRICT),2,'0') ||
          lpad(trim(facture_.tournee),3,'0') ||
          lpad(trim(facture_.Ordre),3,'0') ||
          lpad(trim(facture_.POLICE),5,'0');
          end if;*/
           V_FAC_ABN_NUM := lpad(trim(facture_.DISTRICT),2,'0') ||
          lpad(trim(facture_.tournee),3,'0') ||
          lpad(trim(facture_.Ordre),3,'0') ||
          lpad(trim(facture_.POLICE),5,'0');
          
          V_REF_ABN := lpad(trim(facture_.DISTRICT),2,'0')||
                          lpad(trim(facture_.POLICE),5,'0') ||
                          lpad(trim(facture_.tournee),3,'0') ||
                          lpad(trim(facture_.Ordre),3,'0') ;
      exception
      when others then
          err_code := SQLCODE;
          err_msg  := SUBSTR(SQLERRM, 1, 200);
          insert into prob_migration
          (nom_table, val_ref, sql_err, date_pro,type_problem)
          values
          ('miwtfactureAA-VERSION','Tou:'||lpad(trim(facture_.tournee),3,'0')||'ORD:'||lpad(trim(facture_.Ordre),3,'0')||'TRIM :'||facture_.periode||'TIER :'||facture_.TIERS||'AA:'||facture_.ANNEE||'POL:'||lpad(trim(facture_.POLICE),5,'0'),
          err_msg ||'-- periode ',sysdate,' ce pas anomalie :erreur recuperation ref abonner');
      end;
      V_TRAIN_FACT :='ANNEE:'||trim(annee_)||' MOIS:'||trim(periode_);
      v_mrel_ref:=null;
      
      -- Insertion de la facture
      if facture_.etat='A' then
         begin
            insert into miwtfactureentete
               (
                MFAE_SOURCE,--1    VARCHAR2(100)  N     Code source/origine de la facture [OBL]
                MFAE_REF   ,--2    VARCHAR2(100)  N     Identifiant unique de la facture pour la source [OBL]
                MFAE_REFTRF,--3    VARCHAR2(100)  Y     Identifiant du train de la facture
                MFAE_NUME  ,--4    NUMBER(10) Y     Numero de la facture [OBL]
                MFAE_RDET  ,--5    VARCHAR2(15) Y     RDET de la facture
                MFAE_CCMO  ,--6    VARCHAR2(1)  Y     Cle controle RDET de la facture
                MFAE_DEDI  ,--7    DATE N     Date d edition de la facture [OBL]
                MFAE_DLPAI ,--8    DATE Y     Date limite de paiement de la facture [OBL]
                MFAE_DPREL ,--9    DATE Y     Date de prelevement de la facture [OBL]
                MFAE_TOTHTE,--10   NUMBER(10,2) N     Total HT EAU de la facture [OBL]
                MFAE_TOTTVAE,--11  NUMBER(10,2) N     Total TVA EAU de la facture [OBL]
                MFAE_TOTHTA,--12   NUMBER(10,2) N     Total HT ASS de la facture [OBL]
                MFAE_TOTTVAA,--13  NUMBER(10,2) N     Total TVA ASS de la facture [OBL]
                MFAE_SOLDE ,--14   NUMBER(10,2) Y     Solde TTC de la facture
                MFAE_TYPE  ,--15   VARCHAR2(2)  N 'R'
                MFAE_REFFAEDEDU,--16  VARCHAR2(100) Y
                MFAE_REFABN,--17   VARCHAR2(100)  N     Identifiant du contrat de la facture [OBL]
                MFAE_REF_CODNIV_RELANCE,--18  VARCHAR2(100) Y     Reference Code niveau de chainde relance
                MFAE_RIB_REF  ,--19 VARCHAR2(100) Y     Reference Rib
                MFAE_RIB_ETAT ,--20 NUMBER(1) Y     Mode de payement (pr?l?vement 1 ou tip 2)
                MFAE_COMPTEAUX,--21 VARCHAR2(100) Y     Compte auxilaire GENACCOUNT associe a la facture
                MFAE_REF_ORIGINE,--22 VARCHAR2(100) Y     Facture origine
                MFAE_COMMENT  ,--23   VARCHAR2(4000)  Y     Commentaire libre Facture
                MFAE_AMOUNTTTCDEC,--24 NUMBER(17,10)  Y     Montant TTC a deduire
                VOC_MODEFACT  ,--25   VARCHAR2(10)  Y
                MFAE_REF_DEDUC,--26   VARCHAR2(100) Y
                MFAE_REFORGA  ,--27   VARCHAR2(100) Y
                MFAE_EXERCICE ,--28   NUMBER(4) Y     Exercice du role de la facture
                MFAE_NUMEROROLE,--29  NUMBER(4) Y      Numero du role pour l exercice
                MFAE_PREL     ,--30   NUMBER  Y
                MFAE_AROND    ,--31   NUMBER  Y
                mrel_ref      --30
               )
               (
                SELECT
                'DIST'||lpad(trim(facture_.DISTRICT),2,'0'),--1
                V_FAC_NUM         ,--2
                V_TRAIN_FACT      ,--3
                V_FAC_NUM         ,--4
                v_ID_FACTURE      ,--5
                MFAE_CCMO         ,--6
                V_FAC_DATECALCUL  ,--7
                V_FAC_DATECALCUL  ,--8
                V_FAC_DATECALCUL  ,--9
                -MFAE_TOTHTE      ,--10
                -MFAE_TOTTVAE     ,--11
                0                 ,--12
                0                 ,--13
                0                 ,--14
                'FA'              ,--15
                MFAE_REFFAEDEDU   ,--16
                V_FAC_ABN_NUM     ,--17
                'INCONNUE'        ,--18
                MFAE_RIB_REF      ,--19
                4                 ,--20
                'IMP_MIG'         ,--21
                MFAE_RDET         ,--22
                MFAE_COMMENT      ,--23
                MFAE_AMOUNTTTCDEC ,--24
                4                 ,--25
                NULL              ,--26
                lpad(trim(facture_.DISTRICT),2,'0'),--27
                annee_            ,--28
                periode_          ,--29
                MFAE_PREL         ,--30
                MFAE_AROND         ,--31
                mrel_ref
                from miwtfactureentete where
                MFAE_RDET = v_MFAE_RDET 
                and MFAE_SOURCE='DIST'||lpad(trim(facture_.DISTRICT),2,'0') 
               );
         exception
         when others then
               err_code := SQLCODE;
               err_msg  := SUBSTR(SQLERRM, 1, 200);
               insert into prob_migration
               (nom_table, val_ref, sql_err, date_pro,type_problem)
               values
               ('miwtfacture-VERSION',
               lpad(facture_.district,2,'0') ||
               lpad(trim(facture_.tournee),3,'0') ||
               lpad(trim(facture_.Ordre),3,'0') ||
               lpad(trim(facture_.POLICE),5,'0'),
               err_code || '--' || err_msg,
               sysdate,
               'erreur de confomité de type colonne');
         end;
         
         begin
           insert into miwtfactureligne
               (
                MFAL_SOURCE,--  VARCHAR2(100)  N      Code source/origine de la ligne [OBL]
                MFAL_REFFAE,--  VARCHAR2(100)  N      Identifiant de la facture de la ligne [OBL]
                MFAL_REFTAP,--  VARCHAR2(100)  N      Identifiant de la periode de tarif de la ligne [OBL]
                MFAL_REFART,--  VARCHAR2(100)  Y
                MFAL_LIBE  ,--  VARCHAR2(200)  Y
                MFAL_NUM   ,--  NUMBER(4)      N
                MFAL_TRAN  ,--  NUMBER(1)      N  1   Tranche de la ligne [OBL]
                MFAL_EXER  ,--  NUMBER(4)      N      Annee exercice de la ligne [OBL]
                MFAL_VOLU  ,--  NUMBER(15,3)   N      Volume facture de la ligne [OBL]
                MFAL_PU    ,--  NUMBER(12,6)   N      P.U. facture de la ligne [OBL]
                MFAL_MTHT  ,--  NUMBER(15,2)   N      Montant HT de la ligne [OBL]
                MFAL_MTVA  ,--  NUMBER(15,2)   N      Montant TVA de la ligne [OBL]
                MFAL_TTVA  ,--  NUMBER(15,2)   N      Taux de TVA de la ligne [OBL]
                MFAL_MTTC  ,--  NUMBER(15,2)   N
                MFAL_DDEBPERFAC,--  DATE       Y      Date de debut de la periode facturee de la ligne
                MFAL_DFINPERFAC,--  DATE       Y      Date de fin de la periode facturee de la ligne
                MFAL_DETAIL--  NUMBER          Y
                )
                ( select MFAL_SOURCE,--  VARCHAR2(100)  N      Code source/origine de la ligne [OBL]
                V_FAC_NUM  ,--  VARCHAR2(100)  N      Identifiant de la facture de la ligne [OBL]
                MFAL_REFTAP,--  VARCHAR2(100)  N      Identifiant de la periode de tarif de la ligne [OBL]
                MFAL_REFART,--  VARCHAR2(100)  Y
                MFAL_LIBE  ,--  VARCHAR2(200)  Y
                MFAL_NUM   ,--  NUMBER(4)  N
                MFAL_TRAN  ,--  NUMBER(1)  N  1    Tranche de la ligne [OBL]
                MFAL_EXER  ,--  NUMBER(4)  N      Annee exercice de la ligne [OBL]
                MFAL_VOLU  ,--  NUMBER(15,3)  N      Volume facture de la ligne [OBL]
                MFAL_PU    ,--  NUMBER(12,6)  N      P.U. facture de la ligne [OBL]
                MFAL_MTHT  ,--  NUMBER(15,2)  N      Montant HT de la ligne [OBL]
                MFAL_MTVA  ,--  NUMBER(15,2)  N      Montant TVA de la ligne [OBL]
                MFAL_TTVA  ,--  NUMBER(15,2)  N      Taux de TVA de la ligne [OBL]
                MFAL_MTTC  ,--  NUMBER(15,2)  N
                MFAL_DDEBPERFAC,--  DATE  Y      Date de debut de la periode facturee de la ligne
                MFAL_DFINPERFAC,--  DATE  Y      Date de fin de la periode facturee de la ligne
                MFAL_DETAIL from miwtfactureligne 
                where  MFAL_REFFAE = wMFAE_REF
                and MFAL_SOURCE='DIST'||lpad(trim(facture_.DISTRICT),2,'0') );
         exception
         when others then
                err_code := SQLCODE;
                err_msg  := SUBSTR(SQLERRM, 1, 200);
                insert into prob_migration
                (nom_table, val_ref, sql_err, date_pro,type_problem )
                values
                ('miwtfactureligne-VERSION',
                V_FAC_NUM,
                err_code || '--' || err_msg,
                sysdate,
                'erreur de confomité de type colonne');
          end;
      else

         begin
            insert into miwtfactureentete
               (
               MFAE_SOURCE         ,--1   VARCHAR2(100)  N     Code source/origine de la facture [OBL]
               MFAE_REF            ,--2   VARCHAR2(100)  N     Identifiant unique de la facture pour la source [OBL]
               MFAE_REFTRF         ,--3   VARCHAR2(100)  Y     Identifiant du train de la facture
               MFAE_NUME           ,--4   NUMBER(10)     Y     Numero de la facture [OBL]
               MFAE_RDET           ,--5   VARCHAR2(15)   Y     RDET de la facture
               MFAE_CCMO           ,--6   VARCHAR2(1)    Y     Cle controle RDET de la facture
               MFAE_DEDI           ,--7   DATE           N     Date d edition de la facture [OBL]
               MFAE_DLPAI          ,--8   DATE           Y     Date limite de paiement de la facture [OBL]
               MFAE_DPREL          ,--9   DATE           Y     Date de prelevement de la facture [OBL]
               MFAE_TOTHTE         ,--10  NUMBER(10,2)   N     Total HT EAU de la facture [OBL]
               MFAE_TOTTVAE        ,--11  NUMBER(10,2)   N     Total TVA EAU de la facture [OBL]
               MFAE_TOTHTA         ,--12  NUMBER(10,2)   N     Total HT ASS de la facture [OBL]
               MFAE_TOTTVAA        ,--13  NUMBER(10,2)   N     Total TVA ASS de la facture [OBL]
               MFAE_SOLDE          ,--14  NUMBER(10,2)   Y     Solde TTC de la facture
               MFAE_TYPE           ,--15  VARCHAR2(2)    N 'R'
               MFAE_REFFAEDEDU     ,--16  VARCHAR2(100)  Y
               MFAE_REFABN         ,--17  VARCHAR2(100)  N     Identifiant du contrat de la facture [OBL]
               MFAE_REF_CODNIV_RELANCE,--18VARCHAR2(100) Y     Reference Code niveau de chainde relance
               MFAE_RIB_REF        ,--19  VARCHAR2(100)  Y     Reference Rib
               MFAE_RIB_ETAT       ,--20  NUMBER(1)      Y     Mode de payement (pr?l?vement 1 ou tip 2)
               MFAE_COMPTEAUX      ,--21  VARCHAR2(100)  Y     Compte auxilaire GENACCOUNT associe a la facture
               MFAE_REF_ORIGINE    ,--22  VARCHAR2(100)  Y     Facture origine
               MFAE_COMMENT        ,--23  VARCHAR2(4000) Y     Commentaire libre Facture
               MFAE_AMOUNTTTCDEC   ,--24  NUMBER(17,10)  Y     Montant TTC a deduire
               VOC_MODEFACT        ,--25  VARCHAR2(10)   Y
               MFAE_REF_DEDUC      ,--26  VARCHAR2(100)  Y
               MFAE_REFORGA        ,--27  VARCHAR2(100)  Y
               MFAE_EXERCICE       ,--28  NUMBER(4)      Y     Exercice du role de la facture
               MFAE_NUMEROROLE     ,--29  NUMBER(4)      Y     Numero du role pour l exercice
               MFAE_PREL           ,--30  NUMBER         Y
               MFAE_AROND          ,--31  NUMBER         Y
               mrel_ref            --32
              )
              values
              (
               'DIST'||lpad(trim(facture_.DISTRICT),2,'0') ,--1
               V_FAC_NUM         ,--2
               V_TRAIN_FACT      ,--3
               V_FAC_NUM         ,--4
               v_ID_FACTURE      ,--5
               NULL              ,--6
               V_FAC_DATECALCUL  ,--7
               V_FAC_DATECALCUL  ,--8
               V_FAC_DATECALCUL  ,--9
               facture_.net_a_payer/1000,--10
               0                 ,--11
               0                 ,--12
               0                 ,--13
               facture_.net_a_payer/1000,--14
               decode(facture_.etat,'P','RF','O','FC','C','FHC','FC'),--15
               NULL              ,--16
               V_FAC_ABN_NUM     ,--17
               'INCONNUE'        ,--18
               null             ,--19
               4                 ,--20
               'IMP_MIG'         ,--21
               v_MFAE_RDET       ,--22
               V_REF_ABN         ,--23
               NULL              ,--24
               4                 ,--25
               NULL              ,--26
               lpad(trim(facture_.DISTRICT),2,'0')         ,--27
               annee_            ,--28
               periode_          ,--29
               1                 ,--30
               0                 ,--31
               v_mrel_ref
               );
         exception
         when others then
               err_code := SQLCODE;
               err_msg  := SUBSTR(SQLERRM, 1, 200);
               insert into prob_migration
               (nom_table, val_ref, sql_err, date_pro,type_problem)
               values
               ('miwtfacture-VERSION',
               lpad(facture_.district,2,'0') ||
               lpad(trim(facture_.tournee),3,'0') ||
               lpad(trim(facture_.Ordre),3,'0') ||
               lpad(trim(facture_.POLICE),5,'0'),
               err_code || '--' || err_msg,
               sysdate,
               'erreur de confomité de type colonne'
               );
         end;
 
      end if;
      commit;
      end loop;
      insert into prob_migration (nom_table)values(SYSTIMESTAMP||'   END MIWT_FACTURE_VERSION');
      commit;
      end;
--******************************************************************
procedure MIWT_FACTURE_IMPAYEE  is
--********************************* TRAITEMENT DES FACTURES  A PARTIR TABLE IMPAYEE
      err_code         varchar2(200);
      err_msg          varchar2(200); 
      V_TRAIN_FACT     varchar2(200);
      V_REF_ABN        varchar2(200);
      v_mrel_ref       varchar2(200);    
      v_ID_FACTURE     varchar2(20);
      V_FAC_ABN_NUM    number(20);
      nbr_trt          number := 0;
      annee_           number(4);
      V_FAC_NUM        number;
      V_FAC_RESTANTDU  number;
      V_FAC_DATECALCUL date;
      V_FAC_DATEDLPAI  date;
      periode_         number;
      date_            date;
      begin
      execute immediate 'alter session set nls_date_format = ''dd/mm/yyyy''';
      execute immediate 'alter session set NLS_NUMERIC_CHARACTERS = '',.''';
    --**************************************************
      delete prob_migration 
      where nom_table in
      ('miwtfacture','SEQ_RELEVE','miwtfactureAA-imp');
      insert into prob_migration (nom_table)values(SYSTIMESTAMP||'   START MIWT_FACTURE_impayee');
      commit;
      --**************************************************
      -- reception de la liste des releves
      select max(nvl(to_number(MFAE_REF),0))
      into  V_FAC_NUM
      from miwtfactureentete;
          
      if V_FAC_NUM is null then
      V_FAC_NUM := 0;    
      end if;
      for facture_ in (select * from  impayees_part p 
                       where not exists (select 'X' from miwtfactureentete 
                                         where mfae_rdet = (lpad(DISTRICT,2,'0')||lpad(tournee,3,'0')||
                                         lpad(ORDRE,3,'0')||to_char(annee)||lpad(p.trimestre,2,'0')||0)
                                         )
                       and  p.net<>p.mtpaye
                       ) 
      loop                                                          
         V_FAC_NUM        := V_FAC_NUM +1;
         --**************************************************
         periode_ := facture_.trimestre;
         annee_   :=facture_.ANNEE;
         
         V_FAC_RESTANTDU  := null;
         V_FAC_DATECALCUL := null;
         V_FAC_ABN_NUM    := null;
         V_REF_ABN        := null;
 
        select last_day(to_date('01'||lpad(facture_.trimestre,2,0)||facture_.annee,'ddmmyy')) 
        into date_
        from dual;
        begin 
          select (r.mrel_date+1) 
          INTO V_FAC_DATECALCUL 
          from  miwtreleve r
          where r.mrel_refpdl =
          lpad(facture_.DISTRICT,2,'0')||
          lpad(facture_.tournee,3,'0')||
          lpad(facture_.ORDRE,3,'0')||
          lpad(facture_.POLICE,5,'0')
          and mrel_refpdl is not null
          and r.annee = annee_
          and r.periode = periode_
          and rownum=1;
        Exception  when others then
          V_FAC_DATECALCUL := date_;
        end;
      begin
      -- reception de l'identfiant de l'abonnement
      v_ID_FACTURE:=lpad(trim(facture_.DISTRICT),2,'0')||
                    lpad(trim(facture_.tournee),3,'0')||
                    lpad(trim(facture_.ORDRE),3,'0')||to_char(annee_)||
                    lpad(to_char(periode_),2,'0')||'0';
      V_TRAIN_FACT :='ANNEE:'||trim(annee_) ||' MOIS:'||trim(periode_);
      
   /*   for ref_abn_ in (select *
                       from miwabn a
                       where substr(a.abn_refsite,1,8) = lpad(facture_.DISTRICT,2,'0') ||
                                lpad(trim(facture_.tournee),3,'0') ||
                                lpad(trim(facture_.ordre),3,'0')
                      ) 
      loop
          V_FAC_ABN_NUM := ref_abn_.abn_ref;
          V_REF_ABN := ref_abn_.ABN_REFPER_A;
      end loop;

          if V_FAC_ABN_NUM  is null then
          V_FAC_ABN_NUM := lpad(facture_.DISTRICT,2,'0') ||
          lpad(ltrim(rtrim(facture_.tournee)),3,'0') ||
          lpad(ltrim(rtrim(facture_.ordre)),3,'0') ||
          lpad(ltrim(rtrim(facture_.police)),5,'0');
          end if;*/
          
            V_FAC_ABN_NUM :=lpad(trim(facture_.DISTRICT),2,'0') ||
                           lpad(trim(facture_.tournee),3,'0') ||
                           lpad(trim(facture_.ordre),3,'0') ||
                           lpad(trim(facture_.police),5,'0');
          
            V_REF_ABN :=lpad(trim(facture_.DISTRICT),2,'0') ||
                       lpad(trim(facture_.police),5,'0')||
                       lpad(trim(facture_.tournee),3,'0') ||
                       lpad(trim(facture_.ordre),3,'0') ;
          
      exception
      when others then
          err_code := SQLCODE;
          err_msg  := SUBSTR(SQLERRM, 1, 200);
          insert into prob_migration
          (nom_table, val_ref, sql_err, date_pro,type_problem)
          values
          ('miwtfactureAA-imp','Tou:'||lpad(ltrim(rtrim(facture_.tournee)),3,'0')||'ORD:'||facture_.Ordre||'TRIM :'||facture_.trimestre||'AA:'||facture_.ANNEE||'POL:'||facture_.police,
          err_msg ||'-- periode ',sysdate,'ce pas anomalie erreur recuperation refrenece abonnement');
      end;
      v_mrel_ref:=null;
      V_FAC_DATEDLPAI:= V_FAC_DATECALCUL +25;
      begin
         insert into miwtfactureentete
            (
              MFAE_SOURCE            ,--1   VARCHAR2(100) N     Code source/origine de la facture [OBL]
              MFAE_REF               ,--2   VARCHAR2(100) N     Identifiant unique de la facture pour la source [OBL]
              MFAE_REFTRF            ,--3   VARCHAR2(100) Y     Identifiant du train de la facture
              MFAE_NUME              ,--4   NUMBER(10)    Y     Numero de la facture [OBL]
              MFAE_RDET              ,--5   VARCHAR2(15)  Y     RDET de la facture
              MFAE_CCMO              ,--6   VARCHAR2(1)   Y     Cle controle RDET de la facture
              MFAE_DEDI              ,--7   DATE          N     Date d edition de la facture [OBL]
              MFAE_DLPAI             ,--8   DATE          Y     Date limite de paiement de la facture [OBL]
              MFAE_DPREL             ,--9   DATE          Y     Date de prelevement de la facture [OBL]
              MFAE_TOTHTE            ,--10  NUMBER(10,2)  N     Total HT EAU de la facture [OBL]
              MFAE_TOTTVAE           ,--11  NUMBER(10,2)  N     Total TVA EAU de la facture [OBL]
              MFAE_TOTHTA            ,--12  NUMBER(10,2)  N     Total HT ASS de la facture [OBL]
              MFAE_TOTTVAA           ,--13  NUMBER(10,2)  N     Total TVA ASS de la facture [OBL]
              MFAE_SOLDE             ,--14  NUMBER(10,2)  Y     Solde TTC de la facture
              MFAE_TYPE              ,--15  VARCHAR2(2)   N 'R'
              MFAE_REFFAEDEDU        ,--16  VARCHAR2(100) Y
              MFAE_REFABN            ,--17  VARCHAR2(100) N     Identifiant du contrat de la facture [OBL]
              MFAE_REF_CODNIV_RELANCE,--18  VARCHAR2(100) Y     Reference Code niveau de chainde relance
              MFAE_RIB_REF           ,--19  VARCHAR2(100) Y     Reference Rib
              MFAE_RIB_ETAT          ,--20  NUMBER(1)     Y     Mode de payement (pr?l?vement 1 ou tip 2)
              MFAE_COMPTEAUX         ,--21  VARCHAR2(100) Y     Compte auxilaire GENACCOUNT associe a la facture
              MFAE_REF_ORIGINE       ,--22  VARCHAR2(100) Y     Facture origine
              MFAE_COMMENT           ,--23  VARCHAR2(4000)Y     Commentaire libre Facture
              MFAE_AMOUNTTTCDEC      ,--24  NUMBER(17,10) Y     Montant TTC a deduire
              VOC_MODEFACT           ,--25  VARCHAR2(10)  Y
              MFAE_REF_DEDUC         ,--26  VARCHAR2(100) Y
              MFAE_REFORGA           ,--27  VARCHAR2(100) Y
              MFAE_EXERCICE          ,--28  NUMBER(4)     Y     Exercice du role de la facture
              MFAE_NUMEROROLE        ,--29  NUMBER(4)     Y     Numero du role pour l exercice
              MFAE_PREL              ,--30  NUMBER        Y
              MFAE_AROND             ,--31  NUMBER        Y
              mrel_ref                --32
              )
              values
              (
              'DIST'||lpad(trim(facture_.DISTRICT),2,'0'),--1
              V_FAC_NUM         ,--2
              V_TRAIN_FACT      ,--3
              V_FAC_NUM         ,--4
              v_ID_FACTURE      ,--5
              NULL              ,--6
              V_FAC_DATECALCUL  ,--7
              V_FAC_DATEDLPAI  ,--8
              V_FAC_DATECALCUL  ,--9
              (to_number(trim(facture_.net)))/1000,--10
              0                 ,--11
              0                 ,--12
              0                 ,--13
              (to_number(trim(facture_.net)))/1000 ,--14
              'FC'              ,--15
              NULL              ,--16
              V_FAC_ABN_NUM     ,--17
              'INCONNUE'        ,--18
              null             ,--19
              4                 ,--20
              'IMP_MIG'         ,--21
              null              ,--22
              V_REF_ABN         ,--23
              NULL              ,--24
              4                 ,--25
              NULL              ,--26
              lpad(trim(facture_.DISTRICT),2,'0'),--27
              annee_            ,--28
              periode_          ,--29
              1                 ,--30
              0                 ,--31
              v_mrel_ref         --32
              );
      exception
      when others then
             err_code := SQLCODE;
             err_msg  := SUBSTR(SQLERRM, 1, 200);
             insert into prob_migration
               (nom_table, val_ref, sql_err, date_pro,type_problem)
             values
              ('miwtfacture_impayee',
               lpad(facture_.district,2,'0') ||
               lpad(trim(facture_.tournee),3,'0') ||
               lpad(trim(facture_.ordre),3,'0') ||
               lpad(trim(facture_.police),5,'0'),
               err_code || '--' || err_msg,
               sysdate,
               'erreur de confomité de type colonne');
      end;
      commit;
      insert into miwtfactureligne
               (
                MFAL_SOURCE   ,--1  VARCHAR2(100)  N  Code source/origine de la ligne [OBL]
                MFAL_REFFAE   ,--2  VARCHAR2(100)  N  Identifiant de la facture de la ligne [OBL]
                MFAL_REFTAP   ,--3  VARCHAR2(100)  N  Identifiant de la periode de tarif de la ligne [OBL]
                MFAL_REFART   ,--4  VARCHAR2(100)  Y
                MFAL_LIBE     ,--5  VARCHAR2(200)  Y
                MFAL_NUM      ,--6  NUMBER(4)      N
                MFAL_TRAN     ,--7  NUMBER(1)      N  Tranche de la ligne [OBL]
                MFAL_EXER     ,--8  NUMBER(4)      N  Annee exercice de la ligne [OBL]
                MFAL_VOLU     ,--9  NUMBER(15,3)   N  Volume facture de la ligne [OBL]
                MFAL_PU       ,--10 NUMBER(12,6)   N  P.U. facture de la ligne [OBL]
                MFAL_MTHT     ,--11 NUMBER(15,2)   N  Montant HT de la ligne [OBL]
                MFAL_MTVA     ,--12 NUMBER(15,2)   N  Montant TVA de la ligne [OBL]
                MFAL_TTVA     ,--13 NUMBER(15,2)   N  Taux de TVA de la ligne [OBL]
                MFAL_MTTC     ,--14 NUMBER(15,2)   N
                MFAL_DDEBPERFAC ,--15 DATE         Y  Date de debut de la periode facturee de la ligne
                MFAL_DFINPERFAC ,--16 DATE         Y  Date de fin de la periode facturee de la ligne
                MFAL_DETAIL      --17 NUMBER       Y
                )
                values
               (
               'DIST'||lpad(trim(facture_.DISTRICT),2,'0')          ,--1
                V_FAC_NUM                  ,--2
                1                          ,--3
                'REPRISE-SONEDE'           ,--4
                'Article de reprise SONEDE',--5
                1                          ,--6
                1                          ,--7
                annee_                     ,--8
                0                          ,--9
                0                          ,--10
                (to_number(trim(facture_.net))-to_number(trim(facture_.mtonas)))/1000 ,--11---
                0                          ,--12
                0                          ,--13
                (to_number(trim(facture_.net))-to_number(trim(facture_.mtonas)))/1000 ,--14
                null                       ,--15
                date_                      ,--16
                null                        --17
                 );

      insert into miwtfactureligne
                (
                MFAL_SOURCE   ,--1  VARCHAR2(100)  N      Code source/origine de la ligne [OBL]
                MFAL_REFFAE   ,--2  VARCHAR2(100)  N      Identifiant de la facture de la ligne [OBL]
                MFAL_REFTAP   ,--3  VARCHAR2(100)  N      Identifiant de la periode de tarif de la ligne [OBL]
                MFAL_REFART   ,--4  VARCHAR2(100)  Y
                MFAL_LIBE     ,--5  VARCHAR2(200)  Y
                MFAL_NUM      ,--6  NUMBER(4)      N
                MFAL_TRAN     ,--7  NUMBER(1)      N  1   Tranche de la ligne [OBL]
                MFAL_EXER     ,--8  NUMBER(4)      N      Annee exercice de la ligne [OBL]
                MFAL_VOLU     ,--9  NUMBER(15,3)   N      Volume facture de la ligne [OBL]
                MFAL_PU       ,--10 NUMBER(12,6)   N      P.U. facture de la ligne [OBL]
                MFAL_MTHT     ,--11 NUMBER(15,2)   N      Montant HT de la ligne [OBL]
                MFAL_MTVA     ,--12 NUMBER(15,2)   N      Montant TVA de la ligne [OBL]
                MFAL_TTVA     ,--13 NUMBER(15,2)   N      Taux de TVA de la ligne [OBL]
                MFAL_MTTC     ,--14 NUMBER(15,2)   N
                MFAL_DDEBPERFAC ,--15 DATE         Y      Date de debut de la periode facturee de la ligne
                MFAL_DFINPERFAC ,--16 DATE         Y      Date de fin de la periode facturee de la ligne
                MFAL_DETAIL    --17 NUMBER         Y
                )
                values
               (
                'DIST'||lpad(trim(facture_.DISTRICT),2,'0'),--1
                V_FAC_NUM                ,--2
                2                        ,--3
                'REPRISE-ONAS'           ,--4
                'Article de reprise ONAS',--5
                2                        ,--6
                1                        ,--7
                annee_                   ,--8
                0                        ,--9 ---------
                0                        ,--10
               (to_number(trim(facture_.mtonas))/1000),--11---------
                0                        ,--12
                0                        ,--13
                (to_number(trim(facture_.mtonas))/1000),--14
                null                     ,--15
                date_                    ,--16
                null                      --17
                 );
      commit;
      end loop;

    --*************************************************************************
    -------------------------
    -------------------------IMPAYEEEEEEEEEEEEE GC-------------------------------
    ------------------------
    --*************************************************************************
      for facture_ in (select * from impayees_gc  
                       where  not exists (select 'X' from miwtfactureentete 
                                   where mfae_rdet = (lpad(DISTRICT,2,'0')||lpad(tournee,3,'0')
                                   ||lpad(ORDRE,3,'0')||to_char(annee)||lpad(mois,2,'0')||0))
                      and trim(net)<>trim(mtpaye) 
                       ) 
      loop

         V_FAC_NUM        := V_FAC_NUM +1;
         --**************************************************
         periode_ := facture_.mois;
         annee_ :=facture_.ANNEE;
         -- suivi en temps reel du traitement
         nbr_trt := nbr_trt + 1;
         --************************************************
         V_FAC_RESTANTDU  := null;
         V_FAC_DATECALCUL := null;
         V_FAC_ABN_NUM    := null;
         V_REF_ABN        := null;

         select last_day(to_date('01'||lpad(facture_.mois,2,0)||facture_.annee,'ddmmyy'))
         into date_
         from dual;
    
         begin 
            select (r.mrel_date+1) 
            INTO  V_FAC_DATECALCUL 
            from  miwtreleve r
            where r.mrel_refpdl =
            lpad(facture_.DISTRICT,2,'0')||
            lpad(ltrim(rtrim(facture_.tournee)),3,'0')||
            lpad(ltrim(rtrim(facture_.ORDRE)),3,'0')||
            lpad(ltrim(rtrim(facture_.POLICE)),5,'0')
            and mrel_refpdl is not null
            and r.annee = annee_
            and r.periode = periode_
            and rownum=1;
         Exception  when others then
               V_FAC_DATECALCUL := date_;
         end;
         begin
            -- reception de l'identfiant de l'abonnement  
            v_ID_FACTURE:=ltrim(rtrim(facture_.DISTRICT)) ||
            lpad(ltrim(rtrim(facture_.tournee)),3,'0') ||
            lpad(ltrim(rtrim(facture_.ORDRE)),3,'0')||
            to_char(annee_) ||
            lpad(to_char(periode_),2,'0')||'0';
            V_TRAIN_FACT :='ANNEE:'||trim(annee_) ||' MOIS:'||trim(periode_);
            /*
            for ref_abn_ in (select *
                            from miwabn a
                            where substr(a.abn_refsite,1,8) = lpad(facture_.DISTRICT,2,'0') ||
                            lpad(ltrim(rtrim(facture_.tournee)),3,'0') ||
                            lpad(ltrim(rtrim(facture_.ordre)),3,'0')
                            ) 
             loop
                V_FAC_ABN_NUM := ref_abn_.abn_ref;
                V_REF_ABN := ref_abn_.ABN_REFPER_A;
            end loop;
            if V_FAC_ABN_NUM  is null then
            V_FAC_ABN_NUM := lpad(facture_.DISTRICT,2,'0') ||
            lpad(ltrim(rtrim(facture_.tournee)),3,'0') ||
            lpad(ltrim(rtrim(facture_.ordre)),3,'0') ||
            lpad(ltrim(rtrim(facture_.police)),5,'0');
            end if;*/
             V_FAC_ABN_NUM := lpad(facture_.DISTRICT,2,'0') ||
            lpad(ltrim(rtrim(facture_.tournee)),3,'0') ||
            lpad(ltrim(rtrim(facture_.ordre)),3,'0') ||
            lpad(ltrim(rtrim(facture_.police)),5,'0');
            
         V_REF_ABN := lpad(facture_.DISTRICT,2,'0') ||
          lpad(ltrim(rtrim(facture_.police)),5,'0')||
          lpad(ltrim(rtrim(facture_.tournee)),3,'0') ||
          lpad(ltrim(rtrim(facture_.ordre)),3,'0') ;
         exception
         when others then
            err_code := SQLCODE;
            err_msg  := SUBSTR(SQLERRM, 1, 200);
            insert into prob_migration
            (nom_table, val_ref, sql_err, date_pro,type_problem)
            values
            ('miwtfactureAA-imp','Tou:'||lpad(ltrim(rtrim(facture_.tournee)),3,'0')||'ORD:'||facture_.Ordre||'TRIM :'||facture_.mois||'AA:'||facture_.ANNEE||'POL:'||facture_.police,
            err_msg ||'-- periode ',sysdate,'ce pas anomalie erreur recuperation refrenece abonnement');
         end;
         v_mrel_ref:=null;
         V_FAC_DATEDLPAI:= V_FAC_DATECALCUL +25;
        begin
        insert into miwtfactureentete
            (
            MFAE_SOURCE            ,--1   VARCHAR2(100) N     Code source/origine de la facture [OBL]
            MFAE_REF               ,--2   VARCHAR2(100) N     Identifiant unique de la facture pour la source [OBL]
            MFAE_REFTRF            ,--3   VARCHAR2(100) Y     Identifiant du train de la facture
            MFAE_NUME              ,--4   NUMBER(10)    Y     Numero de la facture [OBL]
            MFAE_RDET              ,--5   VARCHAR2(15)  Y     RDET de la facture
            MFAE_CCMO              ,--6   VARCHAR2(1)   Y     Cle controle RDET de la facture
            MFAE_DEDI              ,--7   DATE          N     Date d edition de la facture [OBL]
            MFAE_DLPAI             ,--8   DATE          Y     Date limite de paiement de la facture [OBL]
            MFAE_DPREL             ,--9   DATE          Y     Date de prelevement de la facture [OBL]
            MFAE_TOTHTE            ,--10  NUMBER(10,2)  N     Total HT EAU de la facture [OBL]
            MFAE_TOTTVAE           ,--11  NUMBER(10,2)  N     Total TVA EAU de la facture [OBL]
            MFAE_TOTHTA            ,--12  NUMBER(10,2)  N     Total HT ASS de la facture [OBL]
            MFAE_TOTTVAA           ,--13  NUMBER(10,2)  N     Total TVA ASS de la facture [OBL]
            MFAE_SOLDE             ,--14  NUMBER(10,2)  Y     Solde TTC de la facture
            MFAE_TYPE              ,--15  VARCHAR2(2)   N 'R'
            MFAE_REFFAEDEDU        ,--16  VARCHAR2(100) Y
            MFAE_REFABN            ,--17  VARCHAR2(100) N     Identifiant du contrat de la facture [OBL]
            MFAE_REF_CODNIV_RELANCE,--18  VARCHAR2(100) Y     Reference Code niveau de chainde relance
            MFAE_RIB_REF           ,--19  VARCHAR2(100) Y     Reference Rib
            MFAE_RIB_ETAT          ,--20  NUMBER(1)     Y     Mode de payement (pr?l?vement 1 ou tip 2)
            MFAE_COMPTEAUX         ,--21  VARCHAR2(100) Y     Compte auxilaire GENACCOUNT associe a la facture
            MFAE_REF_ORIGINE       ,--22  VARCHAR2(100) Y     Facture origine
            MFAE_COMMENT           ,--23  VARCHAR2(4000)Y     Commentaire libre Facture
            MFAE_AMOUNTTTCDEC      ,--24  NUMBER(17,10) Y     Montant TTC a deduire
            VOC_MODEFACT           ,--25  VARCHAR2(10)  Y
            MFAE_REF_DEDUC         ,--26  VARCHAR2(100) Y
            MFAE_REFORGA           ,--27  VARCHAR2(100) Y
            MFAE_EXERCICE          ,--28  NUMBER(4)     Y     Exercice du role de la facture
            MFAE_NUMEROROLE        ,--29  NUMBER(4)     Y     Numero du role pour l exercice
            MFAE_PREL              ,--30  NUMBER        Y
            MFAE_AROND             ,--31  NUMBER        Y
            mrel_ref                --32
            )
           values
           (
            'DIST'||lpad(trim(facture_.DISTRICT),2,'0') ,--1
            V_FAC_NUM         ,--2
            V_TRAIN_FACT      ,--3
            V_FAC_NUM         ,--4
            v_ID_FACTURE      ,--5
            NULL              ,--6
            V_FAC_DATECALCUL  ,--7
            V_FAC_DATEDLPAI   ,--8
            V_FAC_DATECALCUL  ,--9
            (to_number(trim(facture_.net)))/1000 ,--10
            0                 ,--11
            0                 ,--12
            0                 ,--13
            (to_number(trim(facture_.net)))/1000 ,--14
            'FC'              ,--15
            NULL              ,--16
            V_FAC_ABN_NUM     ,--17
            'INCONNUE'        ,--18
             null             ,--19
            4                 ,--20
            'IMP_MIG'         ,--21
            null              ,--22
            V_REF_ABN         ,--23
            NULL              ,--24
            4                 ,--25
            NULL              ,--26
            lpad(trim(facture_.DISTRICT),2,'0')  ,--27
            annee_            ,--28
            periode_          ,--29
            1                 ,--30
            0                 ,--31
            v_mrel_ref         --32
            );
         exception
         when others then
            err_code := SQLCODE;
            err_msg  := SUBSTR(SQLERRM, 1, 200);
            insert into prob_migration
              (nom_table, val_ref, sql_err, date_pro,type_problem)
            values
              ('miwtfacture_impayee',
               lpad(facture_.district,2,'0') ||
               lpad(ltrim(rtrim(facture_.tournee)),3,'0') ||
               lpad(ltrim(rtrim(facture_.ordre)),3,'0') ||
               lpad(ltrim(rtrim(facture_.police)),5,'0'),
               err_code || '--' || err_msg,
               sysdate,'erreur de confomité de type colonne');
         end;
          insert into miwtfactureligne
                         (
                          MFAL_SOURCE   ,--1  VARCHAR2(100)  N  Code source/origine de la ligne [OBL]
                          MFAL_REFFAE   ,--2  VARCHAR2(100)  N  Identifiant de la facture de la ligne [OBL]
                          MFAL_REFTAP   ,--3  VARCHAR2(100)  N  Identifiant de la periode de tarif de la ligne [OBL]
                          MFAL_REFART   ,--4  VARCHAR2(100)  Y
                          MFAL_LIBE     ,--5  VARCHAR2(200)  Y
                          MFAL_NUM      ,--6  NUMBER(4)      N
                          MFAL_TRAN     ,--7  NUMBER(1)      N  Tranche de la ligne [OBL]
                          MFAL_EXER     ,--8  NUMBER(4)      N  Annee exercice de la ligne [OBL]
                          MFAL_VOLU     ,--9  NUMBER(15,3)   N  Volume facture de la ligne [OBL]
                          MFAL_PU       ,--10 NUMBER(12,6)   N  P.U. facture de la ligne [OBL]
                          MFAL_MTHT     ,--11 NUMBER(15,2)   N  Montant HT de la ligne [OBL]
                          MFAL_MTVA     ,--12 NUMBER(15,2)   N  Montant TVA de la ligne [OBL]
                          MFAL_TTVA     ,--13 NUMBER(15,2)   N  Taux de TVA de la ligne [OBL]
                          MFAL_MTTC     ,--14 NUMBER(15,2)   N
                          MFAL_DDEBPERFAC ,--15 DATE           Y  Date de debut de la periode facturee de la ligne
                          MFAL_DFINPERFAC ,--16 DATE           Y  Date de fin de la periode facturee de la ligne
                          MFAL_DETAIL      --17 NUMBER         Y
                          )
                          values
                         (
                         'DIST'||lpad(trim(facture_.DISTRICT),2,'0'),--1
                          V_FAC_NUM                  ,--2
                          1                          ,--3
                          'REPRISE-SONEDE'           ,--4
                          'Article de reprise SONEDE',--5
                          1                          ,--6
                          1                          ,--7
                          annee_                     ,--8
                          0                          ,--9
                          0                          ,--10
                          (to_number(trim(facture_.net))-to_number(trim(facture_.mtonas)))/1000 ,--11----------
                          0                          ,--12
                          0                          ,--13
                          (to_number(trim(facture_.net))-to_number(trim(facture_.mtonas)))/1000 ,--14
                          null                       ,--15
                          date_                      ,--16
                          null                        --17
                           );

          insert into miwtfactureligne
                         (
                          MFAL_SOURCE   ,--1  VARCHAR2(100)  N      Code source/origine de la ligne [OBL]
                          MFAL_REFFAE   ,--2  VARCHAR2(100)  N      Identifiant de la facture de la ligne [OBL]
                          MFAL_REFTAP   ,--3  VARCHAR2(100)  N      Identifiant de la periode de tarif de la ligne [OBL]
                          MFAL_REFART   ,--4  VARCHAR2(100)  Y
                          MFAL_LIBE     ,--5  VARCHAR2(200)  Y
                          MFAL_NUM      ,--6  NUMBER(4)      N
                          MFAL_TRAN     ,--7  NUMBER(1)      N  1   Tranche de la ligne [OBL]
                          MFAL_EXER     ,--8  NUMBER(4)      N      Annee exercice de la ligne [OBL]
                          MFAL_VOLU     ,--9  NUMBER(15,3)   N      Volume facture de la ligne [OBL]
                          MFAL_PU       ,--10 NUMBER(12,6)   N      P.U. facture de la ligne [OBL]
                          MFAL_MTHT     ,--11 NUMBER(15,2)   N      Montant HT de la ligne [OBL]
                          MFAL_MTVA     ,--12 NUMBER(15,2)   N      Montant TVA de la ligne [OBL]
                          MFAL_TTVA     ,--13 NUMBER(15,2)   N      Taux de TVA de la ligne [OBL]
                          MFAL_MTTC     ,--14 NUMBER(15,2)   N
                          MFAL_DDEBPERFAC ,--15 DATE           Y      Date de debut de la periode facturee de la ligne
                          MFAL_DFINPERFAC ,--16 DATE           Y      Date de fin de la periode facturee de la ligne
                          MFAL_DETAIL    --17 NUMBER         Y
                          )
                          values
                         (
                          'DIST'||lpad(trim(facture_.DISTRICT),2,'0') ,--1
                          V_FAC_NUM                ,--2
                          2                        ,--3
                          'REPRISE-ONAS'           ,--4
                          'Article de reprise ONAS',--5
                          2                        ,--6
                          1                        ,--7
                          annee_                   ,--8
                          0                        ,--9 ---------
                          0                        ,--10
                         (to_number(trim(facture_.mtonas))/1000),--11---------
                          0                        ,--12
                          0                        ,--13
                          (to_number(trim(facture_.mtonas))/1000),--14
                          null                     ,--15
                          date_                    ,--16
                          null                      --17
                           );
                           commit;
      end loop;
      insert into prob_migration (nom_table)values(SYSTIMESTAMP||'   END MIWT_FACTURE_impayee');
      commit;
      end;

end PCK_MIG_FACTURE_new;
