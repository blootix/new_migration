create or replace procedure miwtabonne_GC is

    seq_miwtprop      number default 0;
    v_msg             varchar2(800);
    v_nbr_trsf_inst   number default 0;
    v_nbr_trsf_abn    number(10) default 0;
    V_IN_INS          miwtsite.site_refe%type;
    v_nbr             number;
    v_ad_vilrue       number(10);
    v_ad_num          number(10);
    v_clt_code        varchar2(100);
    v_asu_value       varchar2(100);
    v_clt_nom         varchar2(200);
    v_abn_contrat     varchar2(200);
    v_abn_ref         varchar2(200);
    v_VOC_FRQFACT     varchar2(200);
    v_tournee         varchar2(20); 
    v_date            date;
    v_date_ferm       date;
    V_DTO             number;
    V_POLICE          number;
    V_COMPTEUR        number;
    err_code          varchar2(200);
    err_msg           varchar2(200);
    mnt_val_eng_      number;
    v_adm             varchar2(4);
    v_posit           varchar2(1);
    -- suivi traitement
    nbr_trt           number := 0;
    NBR_tot           number := 0; 
    v_op_name         varchar2(200);
    nbr_abn           number default 0;
    v_codpoll         varchar2(20);
    v_napt            varchar2(20);
    v_consmoy         varchar2(20);
    v_echtonas        varchar2(20);
    v_echronas        varchar2(20);
    v_capitonas       varchar2(20);
    v_interonas       varchar2(20);
    v_arrond          varchar2(20);
    v_periodicite     varchar2(1);
    v_CODONAS         varchar2(10);
    v_nombre          number;
    v_startdt         date;
    v_enddt           date;
begin
    select sysdate into v_startdt from dual;
    dbms_output.put_line('miwtpersonne start = '||v_startdt);
    DBMS_OUTPUT.ENABLE( 1000000 ) ;
    execute immediate 'alter session set nls_date_format = ''dd/mm/yyyy''';
    execute immediate 'alter session set NLS_NUMERIC_CHARACTERS = '',.''';
    insert into prob_migration (nom_table)values(SYSTIMESTAMP||'   START miwtabonne_GC');
    commit;
    /*delete from miwabn;
    delete from miwtpdl;
    delete from MIWTPROPRIETAIRE;
    delete from MIWTHISTOPAYEUR;
    delete from miwtsite;
    delete from miwtbra;*/
    -- pour le suivi d'avancement du traitement
    --select count(*) into NBR_tot from branchement;
    --v_op_name := to_char(sysdate, 'ddmmyyyyhh24miss');
    V_AD_NUM:=null;
	--**************************************************
	-- reception de la liste des branchement
	for branch_ in (select b.district,b.police,b.tourne,b.ordre,gros_consommateur,
					b.adresse,date_creation,categorie_actuel,client_actuel,b.compteur_actuel,
					b.code_marque,b.code_postal,b.type_branchement,b.etat_branchement,b.aspect_branchement,b.usage,b.marche,ltrim(rtrim(b.tarif)) ofr_snd
					from branchement b
					where  upper(trim(b.gros_consommateur))='O') loop

        ---*************************************************------------------
          begin
         /* select nvl(min(date_), '01/01/1970')
          into v_date
          from (select min(to_date('01/' || lpad(trim(a.refc03), 2, '0') || '/20' || trim(a.refc04),'dd/mm/yyyy')) date_
          from facture_as400gc a, param_tournee p, tourne t
          where lpad(trim(t.code),3,'0') = lpad(trim(a.tou),3,'0')
          and lpad(trim(branch_.tourne),3,'0') =lpad(trim(t.code),3,'0')
          and lpad(trim(a.tou),3,'0') =lpad(trim(branch_.tourne),3,'0')
          and lpad(trim(a.ord),3,'0') =lpad(trim(branch_.ordre),3,'0')
          and trim(t.ntiers) = trim(p.tier)
          and trim(t.nsixieme) = trim(p.six)
          and trim(p.district) = trim(a.dist)
          and trim(p.district) = trim(t.district)
          and trim(a.dist) = trim(t.district)
          and trim(branch_.district)=trim(p.district)  
          and trim(branch_.district) = trim(a.dist)
          and trim(branch_.district)=trim(t.district)
          union
          select min(to_date('01/' || lpad(trim(p.m3), 2, '0') || '/' ||trim(f.annee),'dd/mm/yyyy')) date_
          from facture f, param_tournee p, tourne t
          where lpad(trim(t.code),3,'0') = lpad(trim(f.tournee),3,'0')
          and lpad(trim(branch_.tourne),3, '0')=lpad(trim(f.tournee),3,'0') 
          and lpad(trim(branch_.ordre),3,'0') =lpad(trim(f.ordre),3,'0')
          and lpad(trim(branch_.tourne),3,'0') =lpad(trim(t.code),3,'0')
          and trim(t.ntiers) = trim(p.tier)
          and trim(t.nsixieme) = trim(p.six)
          and trim(p.district) = trim(f.district)
          and trim(p.district) = trim(t.district)
          and trim(f.district) = trim(t.district)
          and trim(branch_.district)=trim(p.district)
          and trim(branch_.district)=trim(f.district)
          and trim(branch_.district)=trim(t.district)
          union
          select min(to_date('01/' || lpad(trim(p.m3), 2, '0') || '/' ||trim(r.annee),'dd/mm/yyyy')) date_
          from fiche_releve r, param_tournee p, tourne t
          where lpad(trim(branch_.tourne),3, '0') =lpad(trim(t.code),3,'0')
          and lpad(trim(r.tourne),3,'0') =lpad(trim(branch_.tourne),3,'0')
          and lpad(trim(t.code),3,'0')  =lpad(trim(r.tourne),3,'0')
          and lpad(trim(r.ordre),3,'0') =lpad(trim(branch_.ordre),3,'0')
          and trim(p.district) = trim(r.district)   
          and trim(p.district) = trim(t.district)
          and trim(r.district) = trim(t.district)
          and trim(branch_.district) =trim(p.district)
          and trim(branch_.district) =trim(r.district)
          and trim(branch_.district) =trim(t.district)
          and trim(t.ntiers)   = trim(p.tier)
          and trim(t.nsixieme) = trim(p.six)
          and trim(r.annee) <> '0'  
          and to_number(trim(r.annee))>'1900'
          union
          select min(to_date('01/'||lpad(trim(p.m1),2,'0')||'/'||trim(i.annee),'dd/mm/yyyy'))date_
          from  IMPAYEES_PART i,param_tournee p,tourne t
          where lpad(trim(branch_.tourne),3,'0')=lpad(trim(t.code),3,'0')
          and lpad(trim(i.tournee),3,'0')=lpad(trim(branch_.tourne),3,'0')
          and lpad(trim(t.code),3,'0')=lpad(trim(i.tournee),3,'0')
          and lpad(trim(i.ordre),3,'0')=lpad(trim(branch_.ordre),3,'0')
          and lpad(trim(i.police),5,'0')=lpad(trim(branch_.police),5,'0')
          and lpad(trim(i.district),2,'0')=trim(p.district)
          and lpad(trim(i.district),2,'0')=trim(t.district)
          and trim(t.district)=trim(p.district)
          and trim(branch_.district)=trim(p.district)
          and trim(branch_.district)=lpad(trim(i.district),2,'0')
          and trim(branch_.district)=trim(t.district)
          and trim(t.ntiers)=trim(p.tier)
          and trim(t.nsixieme)=trim(p.six)
          union
          select min(to_date('01/'||lpad(trim(p.m1),2,'0')||'/'||trim(i.annee),'dd/mm/yyyy'))date_
          from  imp_gc i,param_tournee p,tourne t
          where lpad(trim(branch_.tourne),3,'0')=lpad(trim(t.code),3,'0')
          and lpad(trim(i.tournee),3,'0')=lpad(trim(branch_.tourne),3,'0')
          and lpad(trim(t.code),3,'0')=lpad(trim(i.tournee),3,'0')
          and lpad(trim(i.ordre),3,'0')=lpad(trim(branch_.ordre),3,'0')
          and lpad(trim(i.police),5,'0')=lpad(trim(branch_.police),5,'0')
          and  lpad(trim(i.district),2,'0')=trim(p.district)
          and  lpad(trim(i.district),2,'0')=trim(t.district)
          and trim(t.district)=trim(p.district)
          and trim(branch_.district)=trim(p.district)
          and trim(branch_.district)=lpad(trim(i.district),2,'0')
          and trim(branch_.district)=trim(t.district)
          and trim(t.ntiers)=trim(p.tier)
          and trim(t.nsixieme)=trim(p.six)
          union
          select min(to_date('01/'||lpad(trim(p.m1),2,'0')||'/'||trim(c.annee),'dd/mm/yyyy'))date_
          from  gestion_compteur c,param_tournee p, tourne t
          where lpad(trim(branch_.tourne),3,'0')=lpad(trim(t.code),3,'0')
          and lpad(trim(c.tournee),3,'0')=lpad(trim(branch_.tourne),3,'0')
          and lpad(trim(c.ordre),3,'0')=lpad(trim(branch_.ordre),3,'0')
          and lpad(trim(t.code),3,'0')=lpad(trim(c.tournee),3,'0')
          and trim(branch_.district)=trim(p.district)
          and trim(branch_.district)=trim(t.district)
          and trim(branch_.district)=trim(c.district)
          and trim(t.district)=trim(c.district)
          and trim(t.district)=trim(p.district)
          and trim(c.district)=trim(p.district)
          and trim(t.ntiers)=trim(p.tier)
          and trim(t.nsixieme)=trim(p.six)
          and trim(c.annee)<>'0' 
          and to_number(trim(c.annee))>'1900');*/
		v_date:='01/01/1969';
		exception
		when others then
		v_date := '01/01/1970';
		end;
---************************************************-------------------
--**************************************************
		-- suivi en temps reel du traitement
		nbr_trt := nbr_trt + 1;
		--**************************************************
		v_abn_contrat := null;
		V_IN_INS      := null;
		-- reception du code client
		v_clt_code := null;
		for clt_ in (select a.mper_ref, a.mper_nom,mper_ref_adr
					 from miwtpersonne a
					 where a.mper_ref = trim(branch_.district)||lpad(branch_.categorie_actuel,2,'0')||trim(upper(branch_.client_actuel)) )
		loop
			v_clt_code := clt_.mper_ref;
			v_clt_nom  := clt_.mper_nom;
			BEGIN
				select madr_ref into V_AD_NUM
				from miwtadr a
				where a.madr_ref=clt_.mper_ref_adr
				and a.madr_seq =branch_.adresse ;
				exception when others then V_AD_NUM:=null;
			END ;
		END LOOP;
        BEGIN
        -- verfication si le code POLICE est dupplique
        V_POLICE := 0;
        -- hkh+mma : 09/07/2018 : code inutilisable
          /*select count(*)
          into V_POLICE
          from  branchement t
          where lpad(trim(t.police),5,'0') = lpad(trim(branch_.police),5,'0')
          and   lpad(trim(t.tourne),3,'0') = lpad(trim(branch_.tourne),3,'0')
          and   lpad(trim(t.ordre),3,'0') = lpad(trim(branch_.ordre),3,'0')
          and   t.district=branch_.district
          and  upper(trim(t.gros_consommateur)) = 'N';*/
        -- verfication si le COMPTEUR est dupplique
        V_COMPTEUR := 0;
        --hkh + mma : 09/07/2018  : code unitilisable
          /*select count(*)
          into V_COMPTEUR
          from branchement t
          where  lpad(ltrim(rtrim(t.compteur_actuel)),11,'0') =lpad(ltrim(rtrim(branch_.compteur_actuel)),11,'0')
          and trim(t.code_marque) = trim(branch_.code_marque)
          and  t.district=branch_.district;*/
        if  /*V_POLICE <= 1*/ true  then -- hkh + mma : 09/07/2018 : code non utilisé
			--********************************************************************
			-- insertion  SITE SITE SITE SITE SITE SITE SITE SITE SITE SITE SITE
			--********************************************************************
			-- generation du cosde site
			V_IN_INS := lpad(trim(branch_.district),2,'0')||lpad(trim(branch_.tourne),3,'0')||lpad(trim(branch_.ordre),3,'0')||lpad(to_char(trim(branch_.police)),5,'0');
			select count(*)
			into nbr_abn
			from miwabn a
			where substr(a.abn_ref,1,2)||substr(a.abn_ref,4) = trim(branch_.district)||lpad(to_char(trim(branch_.police)),5,'0');
			v_abn_ref := trim(branch_.district)|| nbr_abn ||lpad(to_char(trim(branch_.police)),5,'0');
			if branch_.adresse is not null then
				  miwtADRESSEPIVOT.MIG_ADR(v_adresse_   => ltrim(rtrim(branch_.adresse)),
				  v_ad_vilrue_ => NVL(V_AD_VILRUE,999999999),
				  V_CODE_POSTAL_ =>branch_.CODE_POSTAL,
				  v_district =>trim(branch_.district),
				  v_ad_num_    => v_ad_num);
			  else
				  v_ad_num:=0;
			end if;
            BEGIN
				select count(*)  
				into v_nbr
				from branchement j
				WHERE trim(branch_.district) =trim(j.district)
				and lpad(trim(branch_.tourne),3,'0')=lpad(trim(j.tourne),3,'0')
				and lpad(trim(branch_.ordre),3,'0')=lpad(trim(j.ordre),3,'0')
				and lpad(trim(branch_.police),5,'0')=lpad(trim(j.police),5,'0')
				and upper(trim(j.gros_consommateur))='N'
				and trim(branch_.etat_branchement)='0';
          
				select count(*)  
				into v_nombre
				from branchement j, miwabn p
				WHERE trim(branch_.district)=trim(j.district)
				and lpad(trim(branch_.tourne),3,'0')=lpad(trim(j.tourne),3,'0')
				and lpad(trim(branch_.ordre),3,'0')=lpad(trim(j.ordre),3,'0')
				and lpad(trim(branch_.police),5,'0')=lpad(trim(j.police),5,'0')
				and upper(trim(j.gros_consommateur))='O'
				and substr(p.abn_refsite,3,3)=lpad(trim(j.tourne),3,'0')
				and substr(p.abn_refsite,6,3)=lpad(trim(j.ordre),3,'0')
				and  p.VOC_TYPSAG='G';
				if (v_nbr<>0)then
					update  miwabn p set p.VOC_TYPSAG='G',p.abn_refper_a=v_clt_code, ABN_DT_FIN=null
					where p.abn_refsite=trim(branch_.district)||lpad(trim(branch_.tourne),3,'0')||lpad(trim(branch_.ordre),3,'0')||lpad(trim(branch_.police),5,'0');

					update miwtpdl l set l.pdl_etat='0' , l.pdl_dfermeture=null ,l.VOC_FRQFACT='30'
					where l.pdl_ref=trim(branch_.district)||lpad(trim(branch_.tourne),3,'0')||lpad(trim(branch_.ordre),3,'0')||lpad(trim(branch_.police),5,'0');

					update MIWTPROPRIETAIRE s set s.pro_cl_code =v_clt_code , s.pro_dt_fin=null
					where s.pro_in_ins=trim(branch_.district)||lpad(trim(branch_.tourne),3,'0')||lpad(trim(branch_.ordre),3,'0')||lpad(trim(branch_.police),5,'0');

					update miwthistopayeur s set s.mhpa_ref_payeur =v_clt_code ,s.mhpa_dfin =null
					where s.mhpa_ref_abnt=(select p.abn_ref
										from miwabn p 
										where p.abn_refsite=trim(branch_.district)||lpad(trim(branch_.tourne),3,'0')||lpad(trim(branch_.ordre),3,'0')||lpad(trim(branch_.police),5,'0'));
				elsif (v_nombre=0) then
					BEGIN
					  insert into miwtsite(
								  SITE_SOURCE     ,--1
								  SITE_REFE       ,--2
								  SITE_REF_ADR    ,--3
								  SITE_DATCREATION --4
								  )
							  Values
							     ( 
								  'DIST'||trim(branch_.district),--1
								  V_IN_INS           ,--2
								  V_AD_NUM           ,--3
								  sysdate             --4
							     ) ;
					EXCEPTION WHEN OTHERS THEN
					  err_code := SQLCODE;
					  err_msg := SUBSTR(SQLERRM, 1, 200);
					  insert into prob_migration (nom_table,val_ref,sql_err , date_pro,type_problem )
					  values('miwtsite',V_IN_INS,err_code||'--'||err_msg, sysdate,'site existe deja avec cette reference'||V_IN_INS);
					END;
				--********************************************************************
				-- Insertion PROPRIETAIRE PROPRIETAIRE PROPRIETAIRE PROPRIETAIRE
				--********************************************************************
					seq_miwtprop:=seq_miwtprop+1;
				    v_date_ferm:=null;
					BEGIN
					  select  max(to_date( m.date_res,'dd/mm/yyyy'))into v_date_ferm
					  from branchement_res_max m
					  where m.dist||m.ref_pdl=branch_.district||branch_.tourne||branch_.ORDre
					  and trim(branch_.ETAT_BRANCHEMENT)='9';
					EXCEPTION WHEN NO_DATA_FOUND THEN NULL;
					END;
		   
					BEGIN
						BEGIN
							select adm 
							into v_adm 
							from abonnees t
							where lpad(trim(t.pol),5,'0')=lpad(trim(branch_.police),5,'0')
							and   lpad(trim(t.tou),3,'0')= lpad(trim(branch_.tourne),3,'0')
							and   lpad(trim(t.ord),3,'0')=lpad(trim(branch_.ordre),3,'0')
							and   trim(t.dist)=trim(branch_.district)
							and   upper(trim(branch_.gros_consommateur))='O';
						EXCEPTION WHEN OTHERS THEN NULL;
						END;
						insert into MIWTPROPRIETAIRE(
									PRO_NUM     ,--1
									PRO_IN_INS  ,--2
									PRO_CL_CODE ,--3
									pro_adm     ,--4
									PRO_DT_DEBUT,--5
									PRO_DT_FIN  ,--6
									PRO_DATCREATION--7
									)
									values(
									seq_miwtprop,--1 NUMBER(10)   N     Identifiant unique
									V_IN_INS    ,--2 VARCHAR2(20) N     Identifiant de l'installation
									v_clt_code  ,--3 NUMBER(10)   N     Code du client
									v_adm       ,--4
									v_date      ,--5 DATE         N     date de debut de propriete  (mettre une date bidon) (obligatoire)
									v_date_ferm ,--6 DATE         Y     date de fin de propriete
									sysdate      --7
									);
					EXCEPTION WHEN OTHERS THEN
						err_code := SQLCODE;
						err_msg := SUBSTR(SQLERRM, 1, 200);
						insert into prob_migration (nom_table,val_ref,sql_err , date_pro,type_problem )
						values('MIWTPROPRIETAIRE',V_IN_INS,err_code||'--'||err_msg, sysdate,'PROPRIETAIRE existe avec cette refrence'||V_IN_INS);
					END;
					BEGIN
						insert into MIWTHISTOPAYEUR(
									MHPA_SOURCE     ,--1
									MHPA_REF_ABNT   ,--2
									MHPA_REF_PAYEUR ,--3
									MHPA_MRIB_REF   ,--4
									MHPA_DDEB       ,--5
									MHPA_DFIN       ,--6
									VOC_SETTLEMODE  ,--7
									MHPA_DATCREATION--8
									)
						      values
									(
									'DIST'||trim(branch_.district),--1
									v_abn_ref          ,--2
									v_clt_code         ,--3
									null               ,--4
									v_date             ,--5
									v_date_ferm        ,--6
									1                  ,--7
									sysdate            --8
									);
					EXCEPTION WHEN OTHERS THEN
						err_code := SQLCODE;
						err_msg := SUBSTR(SQLERRM, 1, 200);
						insert into prob_migration (nom_table,val_ref,sql_err , date_pro,type_problem )
						values('MIWTHISTOPAYEUR',V_IN_INS,err_code||'--'||err_msg, sysdate,'payeur existe avec cette refrence'||V_IN_INS);
					END;
				--********************************************************************
				-- insertion BRANCHEMENT EAU BRANCHEMENT EAU BRANCHEMENT EAU
				--********************************************************************
					BEGIN
						select posit
						into v_posit
						from abonnees t
						where lpad(trim(t.pol),5,'0')=lpad(trim(branch_.police),5,'0')
						and   lpad(trim(t.tou),3,'0')= lpad(trim(branch_.tourne),3,'0')
						and   lpad(trim(t.ord),3,'0')=lpad(trim(branch_.ordre),3,'0')
						and   trim(t.dist)=trim(branch_.district)
						and   upper(trim(branch_.gros_consommateur))='O';
					EXCEPTION WHEN OTHERS THEN NULL;
					END;
				    if v_posit <9 then
					  v_posit:=0;
					end if;
					BEGIN
						insert into miwtbra(
									MBRA_SOURCE      ,--1  VARCHAR2(100)  N      Identifiant de la source de donnees [OBL]
									MBRA_REF         ,--2  VARCHAR2(100)  N      Reference du branchement dans le SI source (le couple source/reference doit etre unique) [OBL]
									MBRA_REFADR      ,--3  VARCHAR2(100)  N      Reference de l'adresse dans le SI source [OBL]
									MBRA_TYPE        ,--4  VARCHAR2(1)    Y      Type du branchement (U=unique;S=serie;P=parallele;C=compose)
									MBRA_ETAT        ,--5  VARCHAR2(1)    Y      Etat du branchement : 0=ferme, 1=Ouvert, 2=Supprime
									MBRA_DETAT       ,--6  DATE           Y      Date du dernier changement d'etat
									MBRA_REFVOCRESEAU,--7  VARCHAR2(100)  Y      Reference du reseau auquel appartient le branchement (libelle ou code source dans la table des correspondances)
									MBRA_STEP        ,--8  VARCHAR2(100)  Y
									MBRA_CHATEAU     ,--9  VARCHAR2(100)  Y
									VOC_MATBRA       ,--10 VARCHAR2(100)  Y      Composition physique
									VOC_DIABRA       ,--11 VARCHAR2(100)  Y      diametre
									VOC_LGBRA        ,--12 VARCHAR2(100)  Y      longuer
									MBRA_ETATASS     ,--13 VARCHAR2(100)  Y      Date Etat raccordement Ass
									MBRA_DATEASS     ,--14 DATE           Y
									MBRA_VANNEINDIV  ,--15 VARCHAR2(100)  Y      Vanne Individuelle
									MBRA_VANNEINNAC  ,--16 VARCHAR2(100)  Y      Vanne Innacessible
									COMMENTAIRE      ,--17 VARCHAR2(4000) Y
									MBRA_DATCREATION  --18
									)
									values
									(
									'DIST'||trim(branch_.district),--1   VARCHAR2(100)  N      Identifiant de la source de donnees [OBL]
									V_IN_INS          ,--2   VARCHAR2(100)  N      Reference du branchement dans le SI source (le couple source/reference doit etre unique) [OBL]
									V_AD_NUM          ,--3   VARCHAR2(100)  N      Reference de l'adresse dans le SI source [OBL]
									1                 ,--4   VARCHAR2(1)    Y      Type du branchement (U=unique;S=serie;P=parallele;C=compose)
									v_posit           ,--5   VARCHAR2(1)    Y      Etat du branchement : 0=ferme, 1=Ouvert, 2=Supprime
									v_date            ,--6   DATE           Y      Date du dernier changement d'etat
									NULL              ,--7   VARCHAR2(100)  Y      Reference du reseau auquel appartient le branchement (libelle ou code source dans la table des correspondances)
									NULL              ,--8   VARCHAR2(100)  Y
									NULL              ,--9   VARCHAR2(100)  Y
									NULL              ,--10  VARCHAR2(100)  Y      Composition physique
									NULL              ,--11  VARCHAR2(100)  Y      diametre
									NULL              ,--12  VARCHAR2(100)  Y      longuer
									NULL              ,--13  VARCHAR2(100)  Y      Date Etat raccordement Ass
									NULL              ,--14  DATE           Y
									NULL              ,--15  VARCHAR2(100)  Y      Vanne Individuelle
									NULL              ,--16  VARCHAR2(100)  Y      Vanne Innacessible
									NULL              ,--17  VARCHAR2(4000) Y      Type de raccord assainissement
									sysdate            --18
									);
					EXCEPTION WHEN OTHERS THEN
						err_code := SQLCODE;
						err_msg := SUBSTR(SQLERRM, 1, 200);
						insert into prob_migration (nom_table,val_ref,sql_err , date_pro,type_problem )
						values('miwtbra',V_IN_INS,err_code||'--'||err_msg, sysdate,'branchement existe avec cette refrence'||V_IN_INS);
					END;
				--********************************************************************
				-- insertion PDI PDI PDI PDI PDI PDI PDI PDI PDI PDI PDI PDI PDI PDI
				--********************************************************************
					BEGIN
						v_VOC_FRQFACT:=null;
						if(upper(trim(branch_.gros_consommateur))='N' )then
						  v_VOC_FRQFACT:='90';
						else
						  v_VOC_FRQFACT:='30';
						end if;
						if(branch_.tourne='898' or branch_.tourne='899')then
						  v_tournee:=trim(branch_.district)||'_AS';
						else
						  v_tournee:=branch_.tourne;
						end if;

					    insert into miwtpdl(
									PDL_SOURCE      ,--1  VARCHAR2(100)  N      Identifiant de la source de donnees [OBL]
									PDL_REF         ,--2  VARCHAR2(100)  N      Reference du point de comptage dans le SI source (le couple source/reference doit etre unique) [OBL]
									PDL_REFBRA      ,--3  VARCHAR2(100)  Y      Reference du branchement dans le SI source [OBL]
									PDL_REFADR      ,--4  VARCHAR2(100)  N      Reference de l''adresse dans le SI source [OBL]
									PDL_REFTOU      ,--5  VARCHAR2(100)  Y      Reference de la tournee dans la source du client
									PDL_REFPDE_PERE ,--6  VARCHAR2(100)  Y
									PDL_TYPE        ,--7  VARCHAR2(1)    Y
									PDL_TOUORDRE    ,--8  NUMBER(10)     Y      Ordre du point de comptage dans la tournee
									PDL_REFSITE     ,--9  VARCHAR2(100)  Y      Reference de la site dans le SI source
									VOC_DIFFREAD    ,--10 VARCHAR2(100)  Y      Liste des Vocabulaires etat de releve (Difficulte de releve, plaque de fonte, Egout...) ..difficulte releve
									VOC_ACCESS      ,--11 VARCHAR2(100)  Y      Liste des vocabulaire Accessibilite (Jardin, Limite propriete ...) ..accessibilite compteur
									VOC_READINFO1   ,--12 VARCHAR2(100)  Y      Liste des Vocabulaires Inforamation 1 sur releve ...Emplacement compteur
									VOC_READINFO2   ,--13 VARCHAR2(100)  Y      Liste des Vocabulaires Inforamation 2 sur releve
									VOC_READINFO3   ,--14 VARCHAR2(100)  Y      Liste des Vocabulaires Inforamation 3 sur releve
									PDL_REFFLD      ,--15 VARCHAR2(100)  Y
									PDL_SECTEUR_1   ,--16 VARCHAR2(32)   Y      Secteur 1 administratif
									PDL_SECTEUR_2   ,--17 VARCHAR2(32)   Y      Secteur 2 intervention de terrain
									PDL_SECTEUR_3   ,--18 VARCHAR2(32)   Y      Secteur 3
									PDL_SECTEUR_4   ,--19 VARCHAR2(32)   Y      Secteur 4
									PDL_SECTEUR_5   ,--20 VARCHAR2(32)   Y      Secteur 5
									PDL_ETAT        ,--21 VARCHAR2(1)    Y      Etat du point de comptage : 0=ferme, 1=Ouvert, 2=Supprime
									PDL_DETAT       ,--22 DATE           Y      Date du dernier changement d''etat
									VOC_METHDEP     ,--23 VARCHAR2(100)  Y
									PDL_COMMENT     ,--24 VARCHAR2(4000) Y
									PDL_REFPER_P    ,--25 NUMBER(10)     Y      Ref Client Proprietaire
									VOC_CONNAT      ,--26
									VOC_CONSTATUS   ,--27
									PDL_DFERMETURE   ,--28
									VOC_FRQFACT
									)
								values
									(
									'DIST'||trim(branch_.district),--1
									V_IN_INS           ,--2 not null identifiant du branchement   -- PDI_REFERENCE
									V_IN_INS           ,--3 not null Reference de l'installation (mig_ins.ins_id)
									V_AD_NUM           ,--4 Numero d'adresse du branchement
									v_tournee     ,--5 Code de la tournee associee a ce PDI
									NULL               ,--6
									'E'                ,--7 not null 'E' type eau
									branch_.ORDre      ,--8 Numero d'ordre dans la tournee : Permet de commencer par tel pdi dans tel rue en 1er
									V_IN_INS           ,--9
									NULL               ,--10
									NULL               ,--11
									NULL               ,--12
									NULL               ,--13
									NULL               ,--14
									'PDC EAU'          ,--15
									trim(branch_.district),--16
									NULL               ,--17
									NULL               ,--18
									NULL               ,--19
									NULL               ,--20
									v_posit            ,--21 Code etat du branchement
									v_date             ,--22
									NULL               ,--23
									branch_.marche     ,--24 Commentaire point d'installation      -- PDI_LIBRE
									NULL               ,--25
									branch_.type_branchement,--26
									branch_.aspect_branchement,--27
									v_date_ferm         ,--28
									v_VOC_FRQFACT       --29
									) ;
					EXCEPTION WHEN OTHERS THEN
					  err_code := SQLCODE;
					  err_msg := SUBSTR(SQLERRM, 1, 200);
					  insert into prob_migration (nom_table,val_ref,sql_err , date_pro,type_problem )
					  values('miwtpdl',V_IN_INS,err_code||'--'||err_msg, sysdate,'pdl existe avec cette refrence'||V_IN_INS);
					END;
				--********************************************************************
				-- insertion ABONNEMENT ABONNEMENT ABONNEMENT ABONNEMENT ABONNEMENT
				--********************************************************************
				    BEGIN
					--hkh + mma : 09/07/2018 : code inutilisable
					/*v_abn_contrat := branch_.district || lpad(to_char(trim(branch_.police)),5,'0') ||
					lpad(trim(branch_.ordre),3,'0') || lpad(trim(branch_.tourne),3,'0');*/
				        BEGIN
				   
						/* hkh + mma : 09/07/2018 : On utilise plus la conso moyenne begin
							select consmoy,'ONAS'||t.codonas  
							into v_consmoy, v_CODONAS
							from   abonnes_gc t
							where lpad(trim(t.pol),5,'0')=lpad(trim(branch_.police),5,'0')
							and   lpad(trim(t.tou),3,'0')= lpad(trim(branch_.tourne),3,'0')
							and   lpad(trim(t.ord),3,'0')=lpad(trim(branch_.ordre),3,'0')
							and   trim(t.dist)=trim(branch_.district)
							and   upper(trim(branch_.gros_consommateur))='O';
							exception when others then v_consmoy:=0;
							end;
						   */
							v_consmoy:=0;
							v_CODONAS:='ONAS0';
					
				            insert into miwabn(
								  ABN_SOURCE        ,--1   VARCHAR2(100)  N
								  ABN_REF           ,--2   VARCHAR2(100)  N      identifiant de l'abonnement : N? fourni par l'utilisateur (cle primaire)
								  ABN_REFSITE       ,--3   VARCHAR2(100)  Y      Reference de l'installation (obligatoire)
								  ABN_REFPDL        ,--4   VARCHAR2(100)  N      Reference du point de comptage dans le SI source
								  ABN_REFGRF        ,--5   VARCHAR2(100)  Y      Voir description du groupe de facturation
								  ABN_REFPER_A      ,--6   VARCHAR2(100)  Y
								  ABN_DT_DEB        ,--7   DATE           N      Date de debut d'abonnement (obligatoire)
								  ABN_DT_FIN        ,--8   DATE           Y      Date de fin d'abonnement
								  ABN_CTRTYPE_REF   ,--9   VARCHAR2(100)  Y      Reference du contrat d'abonnement (police) (obligatoire)
								  ABN_MODEFACT      ,--10  NUMBER(1)      Y      0=facturation par role, 1=facturation par planning
								  ABN_GELER         ,--11  NUMBER(1)      Y      1:gel de contrat en facturation,0 Sinon
								  ABN_DTGELER       ,--12  DATE           Y      date de gel de facturation
								  ABN_EXOTVA        ,--13  NUMBER(1)      Y  0   1: Exonere de TVA,0 sinon
								  VOC_FROZEN        ,--14  VARCHAR2(100)  Y      motif du gel [FROZEN]
								  VOC_TYPDURBILL    ,--15  VARCHAR2(100)  Y      1: Exonere de TVA,0 sinon
								  VOC_CUTAGREE      ,--16  VARCHAR2(100)  Y      drois de coupure [CUTAGREE]
								  VOC_TYPSAG        ,--17  VARCHAR2(100)  Y      type de service (professionnel, domestique) [TYPSAG]
								  VOC_USGSAG        ,--18  VARCHAR2(100)  Y      Usage Res Principal, Local, Res. Secondaire [USGCAG]
								  ABN_REFREL        ,--19  VARCHAR2(100)  Y      Reference du chaine de relance  dans le SI source
								  ABN_REFPFT        ,--20  VARCHAR2(100)  Y      Reference du Profil type dans le SI source
								  ABN_NORECOVERY    ,--21  NUMBER(1)      Y      exonerer de relance (0=non, 1=oui)
								  ABN_DTFIN_RECOVERY,--22  DATE           Y
								  ABN_DELAIP        ,--23  NUMBER(2)      Y      Delai de paiement
								  ABN_COMMENTAIRE   ,--24  VARCHAR2(4000) Y      Commentaire libre PDS
								  ABN_SOLDE         ,--25  NUMBER(17,10)  Y      Solde de l'abonnement
								  MIGABN_CR         ,--26  NUMBER(10,3)   Y      consommation de reference par defaut
								  MIGABN_CRDTFIN    ,--27  DATE           Y      fin de validite de la consommation de reference par defaut
								  ABN_REFPFT_DETAIL ,--28  VARCHAR2(100)  Y      Reference du Profil type  Detaildans le SI source
								  ofr_code          ,--29
								  ofr_code_second   ,--30
								  ABN_DATCREATION    --31
								  )
								  Values
								  (
								  'DIST'||trim(branch_.district)  ,--1
								  v_abn_ref           ,--2
								  V_IN_INS            ,--3
								  V_IN_INS            ,--4
								  '1'                 ,--5 groupe facturation
								  v_clt_code          ,--6 Numero du client Abonne A
								  v_date              ,--7
								  v_date_ferm         ,--8
								  null                ,--9
								  0                   ,--10
								  0                   ,--11
								  null                ,--12
								  0                   ,--13
								  null                ,--14
								  0                   ,--15
								  0                   ,--16
								  'G'                 ,--17
								  branch_.usage       ,--18
								  null                ,--19
								  'OFRTEST'           ,--20
								  0                   ,--21
								  null                ,--22
								  30                  ,--23
								  null                ,--24
								  0                   ,--25 avoir
								  v_consmoy           ,--26
								  null                ,--27
								  null                ,--28
								  branch_.ofr_snd     ,--29
								  v_CODONAS           ,--30
								  sysdate              --31
								  );
				        EXCEPTION WHEN OTHERS THEN
							err_code := SQLCODE;
							err_msg := SUBSTR(SQLERRM, 1, 200);
							insert into prob_migration (nom_table,val_ref,sql_err , date_pro,type_problem )
							values('miwabn',V_IN_INS,err_code||'--'||err_msg,sysdate,'abonnement existe avec cette refrence'||V_IN_INS);
				        END;
				        commit;
				  
						BEGIN
							select napt,consmoy,echronas,echtonas,capitonas,interonas,AR1,'0'
							into v_napt,v_consmoy,v_echronas,v_echtonas,v_capitonas,v_interonas,v_arrond,v_periodicite
							from abonnes_gc t
							where lpad(trim(t.pol),5,'0')=lpad(trim(branch_.police),5,'0')
							and   lpad(trim(t.tou),3,'0')= lpad(trim(branch_.tourne),3,'0')
							and   lpad(trim(t.ord),3,'0')=lpad(trim(branch_.ordre),3,'0')
							and   trim(t.dist)=trim(branch_.district)
							and   upper(trim(branch_.gros_consommateur))='O';
						EXCEPTION WHEN OTHERS THEN NULL;
						END;
		            for c in (select  * from miwengagement t where t.sub_source='DIST'||trim(branch_.district)) loop
						if to_number(nvl(v_codpoll,'0'))!=0 and c.sub_comment=upper('codpoll') then 
						   mnt_val_eng_:=v_codpoll;
						elsif to_number(nvl(v_napt,'0'))!=0 and c.sub_comment=upper('napt') then 
						   mnt_val_eng_:=v_napt; 
						elsif to_number(nvl(v_echtonas,'0'))!=0 and c.sub_comment=upper('echtonas') then 
						   mnt_val_eng_:=to_number(v_echtonas);
						elsif to_number(nvl(v_echronas,'0'))!=0 and c.sub_comment=upper('echronas') then
						   mnt_val_eng_:=to_number(v_echronas);
						elsif to_number(nvl(v_capitonas,'0'))!=0 and c.sub_comment=upper('capitonas') then 
						   mnt_val_eng_:=to_number(v_capitonas)/1000;
						elsif to_number(nvl(v_interonas,'0'))!=0 and c.sub_comment=upper('interonas') then 
						   mnt_val_eng_:=to_number(v_interonas)/1000;
						elsif  v_arrond is not null and c.sub_comment=upper('arrond') then
						   mnt_val_eng_:=to_number(v_arrond)/1000; 
                        else goto xx;
				        end if;
						BEGIN
							insert into miwengabn(
										asu_subsource,--1
										asu_subref   ,--2
										asu_refsource,--3
										asu_refabn   ,--4
										asu_value    ,--5
										asu_dtdebut  ,--6
										ASU_DATCREATION--7
										)
								values
										(
										c.sub_source,--1
										c.sub_ref   ,--2
										c.sub_source,--3
										v_abn_ref   ,--4
										mnt_val_eng_,--5
										v_date      ,--6 branch_.date_creation
										sysdate      --7
										);
						EXCEPTION WHEN OTHERS THEN
							err_code := SQLCODE;
							err_msg := SUBSTR(SQLERRM, 1, 200);
							insert into prob_migration (nom_table,val_ref,sql_err , date_pro,type_problem  )
							values('miwengabn',v_abn_ref,err_code||'--'||err_msg, sysdate,'engagement existe avec cette refrence'||V_IN_INS);
						END;
                        BEGIN
							insert into miwengabn(
										asu_subsource,--1
										asu_subref   ,--2
										asu_refsource,--3
										asu_refabn   ,--4
										asu_value    ,--5
										asu_dtdebut   --6
										)
								  values
										(
										c.sub_source,--1
										'GROS_CONSOMMATEUR'   ,--2
										c.sub_source,--3
										v_abn_ref   ,--4
										'Oui',--5
										null       --6
										);
						EXCEPTION WHEN OTHERS THEN
							err_code := SQLCODE;
							err_msg := SUBSTR(SQLERRM, 1, 200);
							insert into prob_migration (nom_table,val_ref,sql_err , date_pro,type_problem )
							values('miwengabn_1',v_abn_ref,err_code||'--'||err_msg, sysdate,'engagement existe avec cette refrence'||V_IN_INS);
						END;
                    commit;
			        <<xx>>
			        null;
		            end loop;
                    BEGIN
						for v in(select distinct b.district, b.police,b.tourne,b.ordre,b.etat_branchement,b.gros_consommateur,g.gc
						         from branchement b ,gestion_compteur g
						         where b.district||trim(b.tourne)||trim(b.ordre) not in(select lpad(trim(t.dist),2,'0')||
								                                                               lpad(trim(t.tou),3,'0')||
																							   lpad(trim(t.ord),3,'0')
																		                from abonnees t)
						         and b.district||trim(b.tourne)||trim(b.ordre) not in(select lpad(trim(r.dist),2,'0')||
								                                                             lpad(trim(r.tou),3,'0')||
																							 lpad(trim(r.ord),3,'0')
																	                   from abonnees_gr r)
								and b.district||trim(b.tourne)||trim(b.ordre) = g.district||lpad(trim(g.tournee),3,'0')||lpad(trim(g.ordre),3,'0')
								and lpad(trim(b.police),5,'0')=lpad(trim(branch_.police),5,'0')
								and lpad(trim(b.tourne),3,'0')=lpad(trim(branch_.tourne),3,'0')
								and lpad(trim(b.ordre),3,'0')=lpad(trim(branch_.ordre),3,'0')
								and b.district=branch_.district 
								and to_date(g.date_action,'dd/mm/yyyy') =(select max(to_date(s.date_action,'dd/mm/yyyy'))
																	   from gestion_compteur s
																	   where s.district||trim(s.tournee)||trim(s.ordre)=g.district||trim(g.tournee)||trim(g.ordre) )
						)loop
                            BEGIN
								select a.abn_ref 
								into v_abn_ref
								from miwabn a where a.abn_refsite=trim(v.district)
													   ||lpad(trim(v.tourne),3,'0')
													   ||lpad(trim(v.ordre),3,'0')
													   ||lpad(trim(v.police),5,'0');
								if upper(trim(v.gc))='O' then
								  v_asu_value:='Oui';
								else
								  v_asu_value:='Non';
								end if;
								insert into miwengabn(
											asu_subsource,--1
											asu_subref   ,--2
											asu_refsource,--3
											asu_refabn   ,--4
											asu_value    ,--5
											asu_dtdebut   --6
											)
										values
											(
											'DIST'||trim(branch_.district),--1
											'GROS_CONSOMMATEUR',--2
											'DIST'||trim(branch_.district),--3
											v_abn_ref   ,--4
											v_asu_value ,--5
											null         --6
											);
							EXCEPTION WHEN OTHERS THEN
								err_code := SQLCODE;
								err_msg := SUBSTR(SQLERRM, 1, 200);
								insert into prob_migration (nom_table,val_ref,sql_err , date_pro,type_problem )
								values('miwengabn_1',v_abn_ref,err_code||'--'||err_msg, sysdate,'engagement existe avec cette refrence'||V_IN_INS);
							END;
			                commit;
                        end loop;
	                end;
                    v_nbr_trsf_abn := v_nbr_trsf_abn + 1;
				    end;
					v_nbr_trsf_inst := v_nbr_trsf_inst + 1;
					v_msg := null;
					if V_DTO > 1 then
					   v_msg := '(DISTRICT,TOURNEE,ORDRE) dupplique';
					end if;
					if V_POLICE > 1 then
					   v_msg := v_msg || 'CODE POLICE dupplique)';
					end if;
					if V_COMPTEUR > 1 then
					   v_msg := v_msg || 'COMPTEUR dupplique';
					end if;
				end if;
		    end;
        V_AD_NUM:=null;
       end if;
    end;
    end loop;
select sysdate into v_enddt from dual;
dbms_output.put_line('miwtpersonne start = '||v_enddt);   
insert into prob_migration (nom_table)values(SYSTIMESTAMP||'   END miwtabonne_GC');
commit;
end;
