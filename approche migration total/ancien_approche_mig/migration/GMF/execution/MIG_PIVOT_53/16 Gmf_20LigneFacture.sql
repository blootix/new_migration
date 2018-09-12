--update miwtreleve s set s.mrel_fact1=(select mrel_fact1 from  mig_pivot_53.miwtreleve t where t.mrel_ref=s.mrel_ref)where s.mrel_fact1 is null;
--commit;
spo Gmf_11Fac.lst;
SELECT to_char(sysdate, 'DD/MM/YY HH24:MI') heure FROM dual;
ANALYZE TABLE  mig_pivot_53.miwtfactureentete COMPUTE STATISTICS;
ANALYZE TABLE  mig_pivot_53.miwthistopayeur COMPUTE STATISTICS;
ANALYZE TABLE genorganization COMPUTE STATISTICS;
ANALYZE TABLE  mig_pivot_53.miwabn COMPUTE STATISTICS;
ANALYZE TABLE genaccount COMPUTE STATISTICS;
ANALYZE TABLE agrsagaco COMPUTE STATISTICS;
ANALYZE TABLE gendebt COMPUTE STATISTICS;
ANALYZE TABLE genbill COMPUTE STATISTICS;
Update  mig_pivot_53.miwtfactureentete set MFAE_REF_CODNIV_RELANCE = 'INCONNUE' where  MFAE_REF_CODNIV_RELANCE Is null ;
update  mig_pivot_53.MIWTFACTUREENTETE r set r.MFAE_DLPAI=r.MFAE_DEDI+15 where r.MFAE_DLPAI is null ;
Update  mig_pivot_53.miwtfactureentete set MFAE_RIB_ETAT = 4 where  MFAE_RIB_ETAT Is null ;

PROMPT *******************************************************
PROMPT *** MIGRATION  / Création  mig_pivot_53.miwtfactureentete***********
PROMPT *******************************************************
SET serveroutput on;
Declare
Cursor Facture  is select
    MFAE_SOURCE     ,
    MFAE_REF        ,
    MFAE_REFTRF     ,
    MFAE_NUME       ,
    MFAE_RDET       ,
    MFAE_CCMO       ,
    MFAE_DEDI       ,
    MFAE_DLPAI      ,
    MFAE_DPREL      ,
    MFAE_TOTHTE     ,
    MFAE_TOTTVAE    ,
    MFAE_TOTHTA     ,
    MFAE_TOTTVAA    ,
    MFAE_SOLDE      ,
    MFAE_TYPE       ,
    --decode(MFAE_TYPE,'A','1','3')  MFAE_TYPE     ,
    MFAE_REFFAEDEDU ,
    MFAE_REFABN     ,
    pay.BAP_ID      ,
    abn.SAG_ID      ,
    ABN_DT_DEB      ,
    ORG_ID          ,
    adr_id          ,
    pay.PAR_ID      ,
    red_id          ,
    MFAE_COMPTEAUX  ,
    MFAE_RIB_ETAT   ,
    REC_ID          ,
    MFAE_COMMENT    ,
    VOC_MODEFACT    ,
    nvl(MFAE_AMOUNTTTCDEC,0)MFAE_AMOUNTTTCDEC,
    MFAE_EXERCICE  ,
    MFAE_NUMEROROLE,
    MFAE_PREL
from     mig_pivot_53.miwtfactureentete fac ,
		 mig_pivot_53.miwthistopayeur pay ,
		 mig_pivot_53.miwabn abn ,
		genorganization g,
		agrserviceagr ss
		
where   fac.MFAE_SOURCE   = ABN_SOURCE
and     lpad(fac.MFAE_REFABN,8,'0')   = abn.ABN_REF--abn.abn_refpdl
and     pay.MHPA_REF_ABNT = ABN_REF
and     pay.MHPA_SOURCE   = ABN_SOURCE
and     upper (org_code)  = MFAE_REFORGA
and BIL_ID is  null
and abn.SAG_ID  is not null
and ss.sag_id = abn.sag_id;
	
	v                 number;
	WITE_ID    		  number;
	wite_name  		  varchar2(100);
	WTVA_ID           number;
	WVOW_UNIT         NUMBER;
	WPTA_ID           number;
	WPSL_RANK         number;
	nbr        		  number;
	MEU_ID     		  number;
	v_bil_bil_id   	  number;
	v_bil_cancel_id   number;
    New_Det           gendebt%rowtype;
    Debt_Id           Number ;
    ref_Debt          Number ;
	
    New_Genbill       genbill%rowtype;
    Genbill_Id        Number ;
    ref_Genbill       Number ;
	
    New_Agrbill       agrbill%rowtype;
    Agrbill_Id        Number ;
    ref_Agrbill       Number ;


    New_genimp        genimp%rowtype ;
    genimp_id         number ;
    genimp_ref        number ;

    New_genaccount    genaccount%rowtype ;
    genaccount_id     number ;
    genaccount_ref    number ;

    New_agrsagaco     agrsagaco%rowtype ;
    agrsagaco_id      number ;
    agrsagaco_ref     number ;

    New_genrun        genrun%rowtype ;
    genrun_id         number ;
    genrun_ref        number ;

Procedure Genere_gendebrec (Newgendebrec gendebrec%rowtype ,gendebrecId  in out   number ,ref_gendebrec out number) is
 BEGIN
      SELECT  DER_ID INTO  ref_gendebrec
      from    gendebrec
      where   nvl(deb_id,0)             = nvl(Newgendebrec.deb_id ,0)
      and     nvl(red_id,0)             = nvl(Newgendebrec.red_id ,0)
      and     nvl(der_startdt,null)     = nvl(Newgendebrec.der_startdt ,null);
Exception
  WHEN NO_DATA_FOUND THEN
        
		select seq_gendebrec.nextval into gendebrecId from dual ; 
		--gendebrecId   := gendebrecId+1;
        ref_gendebrec := gendebrecId;
      insert into gendebrec (
							der_id,
							deb_id,
							red_id,
							der_duedate
							)
                    values (
						    gendebrecId,
							Newgendebrec.deb_id,
							Newgendebrec.red_id,
							Newgendebrec.der_duedate
							) ;

end Genere_gendebrec;

--prompt ***********************************************************
--prompt **** MIGRATION  / Imputaion                                                    *********
---prompt **********************************************************
Procedure Genere_genimp (Newgenimp genimp%rowtype ,genimpId  in out   number ,ref_genimp out number) is
 BEGIN
      SELECT  imp_id INTO  ref_genimp
      from    genimp
      where   nvl(imp_code,'*') = nvl(Newgenimp.imp_code ,'*')
      and     nvl(ORG_ID,0)  = nvl(Newgenimp.ORG_ID ,0) ;
Exception
  WHEN NO_DATA_FOUND THEN
        --genimpId   := genimpId+1;
        ref_genimp := genimpId;
		
      insert into genimp (
	                      imp_id   ,
						  imp_code  ,
						  imp_name  ,
						  vow_budgtp,
						  org_id
						 )
                 values (
				         genimpId,
						 Newgenimp.imp_code,
						 Newgenimp.imp_name,
						 Newgenimp.vow_budgtp,
						 Newgenimp.org_id
						 );

end Genere_genimp;


 Procedure Genere_genaccount (Newgenaccount genaccount%rowtype ,genaccountId  in out number ,ref_genaccount out number,agrsagacoId  in out   number,Newagrsagaco agrsagaco%rowtype) is
 BEGIN

select aco.aco_id  INTO  ref_genaccount  from genaccount aco ,agrsagaco sco
where
  aco.aco_id = sco.aco_id
  and nvl(par_id,0)        = nvl(Newgenaccount.par_id ,0)
  and nvl(imp_id,0)        = nvl(Newgenaccount.imp_id ,0)
  and nvl(sag_id,0)        = nvl(Newagrsagaco.sag_id ,0) ;

Exception
  WHEN NO_DATA_FOUND THEN
        --genaccountId   := genaccountId+1;
        ref_genaccount := genaccountId;
      insert into genaccount (
							   aco_id,
							   par_id,
							   imp_id,
							   vow_acotp,
							   rec_id
							 )
                      values(
					         genaccountId,
							 Newgenaccount.par_id,
							 Newgenaccount.imp_id,
							 Newgenaccount.vow_acotp,
							 Newgenaccount.rec_id
							 );

      --agrsagacoId   := agrsagacoId+1;
      New_agrsagaco.ACO_ID       :=  genaccountId ;
      insert into agrsagaco (
	                          sco_id,
							  sag_id,
							  aco_id,
							  sco_startdt
						     )
                     values (
					          agrsagacoId,
							  Newagrsagaco.sag_id,
							  Newagrsagaco.aco_id,
							  Newagrsagaco.sco_startdt
							  ) ;

end Genere_genaccount;

 Procedure Genere_genrun (Newgenrun genrun%rowtype ,genrunId  in out   number ,ref_genrun out number) is
    V_RUN_NUMBER NUMBER;
 BEGIN
      SELECT  run_id INTO  ref_genrun
      from    genrun
      where   RUN_NAME = Newgenrun.RUN_NAME;
Exception
  WHEN NO_DATA_FOUND THEN
    select nvl(max(RUN_NUMBER),0)+1
	  into   V_RUN_NUMBER
	  from   genrun
	  where  run_exercice = Newgenrun.run_exercice;
	  
      --genrunId   := genrunId+1;
        
      insert into genrun (
	                      run_id      ,
						  run_exercice,
						  run_number  ,
						  org_id      ,
						  run_startdt ,
						  run_comment ,
						  RUN_NAME    , 
						  RUN_DTCALC  ,  
						  RUN_ENDDT
						  )
                  values (
				          genrunId,
						  Newgenrun.run_exercice,
						  V_RUN_NUMBER,
						  Newgenrun.org_id,
						  Newgenrun.run_startdt,
						  Newgenrun.run_comment,
						  Newgenrun.RUN_NAME,
						  Newgenrun.run_startdt,
						  Newgenrun.run_startdt
						  );
		  
      ref_genrun := genrunId;
end Genere_genrun;
 begin
/*select nvl(max(deb_id),0)+1 into Debt_Id      from gendebt;
select nvl(max(bil_id),0) +1 into Agrbill_Id  from agrbill;
select nvl(max(aco_id),0) into genaccount_id from genaccount;
select nvl(max(sco_id),0) into agrsagaco_id  from agrsagaco;
select nvl(max(imp_id),0) into genimp_id     from genimp;
select nvl(max(run_id),0) into genrun_id     from genrun;*/

For Fac in Facture loop

select seq_gendebt.nextval    into Debt_Id       from dual;
select seq_agrbill.nextval    into Agrbill_Id    from dual;
select seq_genaccount.nextval into genaccount_id from dual;
select seq_agrsagaco.nextval  into agrsagaco_id  from dual;
select seq_genimp.nextval     into genimp_id     from dual;
select seq_genrun.nextval     into genrun_id     from dual;

		select count(*) into v 
		from  mig_pivot_53.miwtfactureentete e 
		where e.MFAE_RDET=fac.MFAE_RDET ;
		
if v=1 then
    New_Det   := null;
  New_Genbill := null;
  New_genrun  := null;
      --------------------------------------------------------Traitement Role
    If Fac.MFAE_EXERCICE is not null and Fac.MFAE_NUMEROROLE is not null and Fac.MFAE_REFTRF is not null then
    
	New_genrun.RUN_EXERCICE   :=  Fac.MFAE_EXERCICE ;
    New_genrun.RUN_NUMBER     :=  Fac.MFAE_NUMEROROLE ;
    New_genrun.ORG_ID         :=  Fac.ORG_ID ;
    New_genrun.RUN_STARTDT    :=  Fac.MFAE_DEDI;
    New_genrun.RUN_COMMENT    :=  'Role migré' ;
    New_genrun.RUN_NAME       :=  'Role '||Fac.MFAE_REFTRF ;
    Genere_genrun(New_genrun,genrun_id,genrun_ref);

    end if ;
    --------------------------------------------------------Traitement Det
    New_Det.DEB_ID           :=  Debt_Id ;
    New_Det.DEB_REFE         :=  Fac.MFAE_RDET;
    New_Det.ORG_ID           :=  Fac.ORG_ID ;
    New_Det.PAR_ID           :=  Fac.PAR_ID ;
    New_Det.ADR_ID           :=  Fac.adr_id ;
    New_Det.DEB_DATE         :=  Fac.MFAE_DEDI ;
    New_Det.DEB_DUEDT        :=  Fac.MFAE_DLPAI ;
    New_Det.DEB_PRINTDT      :=  Fac.MFAE_DEDI ;
    New_Det.SAG_ID           :=  Fac.SAG_ID ;
    New_Det.DEB_PREL         :=  Fac.MFAE_PREL ;
    If (Fac.MFAE_TOTHTE+ Fac.MFAE_TOTTVAE+ Fac.MFAE_TOTHTA+ Fac.MFAE_TOTTVAA) > 0 then --- Facture Normal else Facture Avoire
    New_Det.DEB_AMOUNTINIT   :=  Fac.MFAE_TOTHTE+ Fac.MFAE_TOTTVAE+ Fac.MFAE_TOTHTA+ Fac.MFAE_TOTTVAA ;
    New_Det.VOW_DEBTYPE      := pk_genvocword.getidbycode('VOW_DEBTYPE','FA',null) ;
    else
    New_Det.deb_amount_cash  :=  -(Fac.MFAE_TOTHTE+ Fac.MFAE_TOTTVAE+ Fac.MFAE_TOTHTA+ Fac.MFAE_TOTTVAA) ;
    New_Det.DEB_AMOUNTINIT   := 0;
    New_Det.VOW_DEBTYPE      := pk_genvocword.getidbycode('VOW_DEBTYPE','AV',null) ;
    end if ;

    New_Det.DEB_AMOUNTREMAIN :=  Fac.MFAE_SOLDE ;
    New_Det.DEB_COMMENT      :=  Fac.MFAE_COMMENT ;
    --New_Det.BAP_ID        :=
    New_Det.VOW_SETTLEMODE   := pk_genvocword.getidbycode('VOW_SETTLEMODE',Fac.MFAE_RIB_ETAT,null) ;
--
    --------------------------------------------------------Traitement GENACCOUNT ,GENIMP

    --New_genimp.imp_id      :=  ctr.REC_ID ;
    New_genimp.imp_code      :=  Fac.MFAE_COMPTEAUX ;
    New_genimp.imp_name      :=  Fac.MFAE_COMPTEAUX ;
    New_genimp.vow_budgtp    :=  pk_genvocword.getidbycode('VOW_BUDGTP','EA',null);
    --New_genimp.org_id      :=  Fac.org_id ;
    Genere_genimp (New_genimp ,genimp_id,genimp_ref);
    New_genaccount.PAR_ID    :=  Fac.PAR_ID ;
    New_genaccount.IMP_ID    :=  genimp_ref ;
    New_genaccount.VOW_ACOTP :=  pk_genvocword.getidbycode('VOW_ACOTP','1',null);
    New_genaccount.REC_ID    :=  Fac.REC_ID ;

    New_agrsagaco.SAG_ID     :=  Fac.SAG_ID ;
    New_agrsagaco.SCO_STARTDT:= Fac.ABN_DT_DEB ;

    Genere_genaccount (New_genaccount ,genaccount_id ,genaccount_ref ,agrsagaco_id,New_agrsagaco) ;

    New_Det.ACO_ID           := genaccount_ref ;
    New_Det.DEB_NORECOVERY   := 0;
    --New_Det.DEB_CREDT        :=
	
    Insert into gendebt(
	                    deb_id     	    ,
						deb_refe		,
						org_id			, 
						par_id			, 
						adr_id			, 
						deb_date		,
                        deb_duedt		,
						deb_printdt		,
						deb_amountinit  ,
						deb_amountremain,
						bap_id          ,
                        vow_settlemode	,
						aco_id			, 
						deb_norecovery	,
						deb_credt		,
						deb_updtby		,
						deb_updtdt		,
						DEB_COMMENT		,
						deb_amount_cash	,
						SAG_ID 			,
						VOW_DEBTYPE 	,
						DEB_PREL 
				      )
              values 
			         (
					  New_Det.deb_id     ,
					  New_Det.deb_refe   ,
					  New_Det.org_id     , 
					  New_Det.par_id     , 
					  New_Det.adr_id     , 
					  New_Det.deb_date   ,
					  New_Det.deb_duedt  ,
					  New_Det.deb_printdt,
					  New_Det.deb_amountinit, 
					  New_Det.deb_amountremain, 
					  New_Det.bap_id     ,
					  New_Det.vow_settlemode, 
					  New_Det.aco_id     ,
					  New_Det.deb_norecovery,
					  New_Det.deb_credt  , 
					  New_Det.deb_updtby ,
					  New_Det.deb_updtdt ,
					  New_Det.DEB_COMMENT,
					  nvl(New_Det.deb_amount_cash,0),
					  New_Det.SAG_ID     ,
					  New_Det.VOW_DEBTYPE,
					  New_Det.DEB_PREL
			        );
							

    --------------------------------------------------------Traitement agrbill
    New_Agrbill.BIL_ID            :=  Agrbill_Id ;
    New_Agrbill.SAG_ID            :=  Fac.SAG_ID;
    New_Agrbill.VOW_AGRBILLTYPE   :=  pk_genvocword.getidbycode('VOW_AGRBILLTYPE',Fac.Mfae_Type,null) ;
    New_Agrbill.VOW_MODEFACT      :=  pk_genvocword.getidbycode('VOW_MODEFACT',Fac.VOC_MODEFACT,null) ;
    --pk_genvocword.getidbycode('VOW_AGRBILLTYPE','FC',null) ;----VOW_AGRBILLTYPE ..Mfae_Type
       Insert into agrbill (
	                        BIL_ID,
							SAG_ID,
							VOW_AGRBILLTYPE,
							VOW_MODEFACT
							)
                    values (
					        New_Agrbill.BIL_ID,
							New_Agrbill.SAG_ID,
							New_Agrbill.VOW_AGRBILLTYPE,
							New_Agrbill.VOW_MODEFACT
							);


        --------------------------------------------------------Traitement genbill

    New_Genbill.BIL_ID            :=  Agrbill_Id;
    New_Genbill.BIL_CODE          :=  Fac.MFAE_RDET; --Fac.MFAE_NUME;
    New_Genbill.BIL_CALCDT        :=  Fac.MFAE_DEDI ;
    New_Genbill.BIL_AMOUNTHT      :=  Fac.MFAE_TOTHTE + Fac.MFAE_TOTHTA ;
    New_Genbill.BIL_AMOUNTTVA     :=  Fac.MFAE_TOTTVAE+  Fac.MFAE_TOTTVAA ;
    New_Genbill.BIL_AMOUNTTTC     :=  Fac.MFAE_TOTHTE+ Fac.MFAE_TOTTVAE+ Fac.MFAE_TOTHTA+ Fac.MFAE_TOTTVAA ;
    New_Genbill.BIL_AMOUNTTTCDEC  :=  Fac.MFAE_AMOUNTTTCDEC ;
    New_Genbill.BIL_STATUS        :=  1;
    New_Genbill.DEB_ID            :=  Debt_Id;
    New_Genbill.PAR_ID            :=  Fac.PAR_ID ;
    New_Genbill.BIL_DEBTDT        :=  Fac.MFAE_DEDI  ;
    New_Genbill.RUN_ID            :=  genrun_ref  ;
	
    Insert into genbill (
						 BIL_ID       ,
						 BIL_CODE     ,
						 BIL_CALCDT   ,
						 BIL_AMOUNTHT ,
						 BIL_AMOUNTTVA,
						 BIL_AMOUNTTTC,
						 DEB_ID,PAR_ID,
						 BIL_STATUS   ,
						 BIL_AMOUNTTTCDEC,
						 BIL_DEBTDT   ,
						 RUN_ID 
						 )
                 values(
				        New_Genbill.BIL_ID       ,
				        New_Genbill.BIL_CODE	 ,
						New_Genbill.BIL_CALCDT   ,
						New_Genbill.BIL_AMOUNTHT ,
						New_Genbill.BIL_AMOUNTTVA,
						New_Genbill.BIL_AMOUNTTTC,
						New_Genbill.DEB_ID       ,
						New_Genbill.PAR_ID		 ,
						New_Genbill.BIL_STATUS   ,
						New_Genbill.BIL_AMOUNTTTCDEC ,
						New_Genbill.BIL_DEBTDT   ,
						New_Genbill.RUN_ID  
						);
						
						
    Update  mig_pivot_53.miwtfactureentete 
	set BIL_ID = Agrbill_Id ,
	DEB_ID =Debt_Id 
	where MFAE_REF = Fac.MFAE_REF  
	and mfae_source = Fac.mfae_source ;
	
    --Agrbill_Id :=Agrbill_Id+1;
    --Debt_Id    :=Debt_Id +1;
    end if;
-----------------
    v := 0;
    for c in (select * from  mig_pivot_53.miwtfactureligne e  where fac.mfae_ref=e.mfal_reffae)
         loop
         v := v+1;
		  
                 WPTA_ID := null;WPSL_RANK := null;
                begin
                select ITE_ID,ite_name,VOW_UNIT  INTO WITE_ID,wite_name,WVOW_UNIT  from genitem s where s.ITE_CODE = c.MFAL_REFART;
				exception when no_data_found then null;
                end;
                begin
                select tva_id into wtva_id from gentva where tva_taux= c.MFAL_TTVA;
                exception when no_data_found then wtva_id := 25;
                end;
             select count(*) into nbr from genptaslice where PTA_ID
                        in (select PTA_ID from genitemperiodtarif where TAR_id in (select tar_id from genitemtarif where ITE_ID=WITE_ID));
              if nbr=1 then
                begin
                 select PTA_ID,PSL_RANK  into WPTA_ID,WPSL_RANK from genptaslice where PTA_ID
                        in (select PTA_ID from genitemperiodtarif where TAR_id in (select tar_id from genitemtarif where ITE_ID=WITE_ID))and rownum=1;
                -- exception when no_data_found then WPTA_ID := null; WPSL_RANK := null;
                end;
				end if;
              if nbr>1 then
                begin
                 select PTA_ID,PSL_RANK  into WPTA_ID,WPSL_RANK from genptaslice where   PTA_ID
                        in (select PTA_ID from genitemperiodtarif where TAR_id in (select tar_id from genitemtarif where ITE_ID=WITE_ID) )and rownum=1;
                 --exception when no_data_found then WPTA_ID := null; WPSL_RANK := null;
                end;
              
              end if;
			  --select max(meu_id) into MEU_ID from tecmeasureunit where meu_code = c.mfal_cadran;
			  begin
         insert into genbilline
					 (
					  BIL_ID			,--1   NUMBER(10) not null,
					  BLI_REVERSEBLI_ID	,--2   NUMBER(10),
					  BLI_NUMBER		,--3   NUMBER(4) not null,
					  BLI_REVERSEBLINUMBER,--4 NUMBER(4),
					  BLI_NAME          ,--5   VARCHAR2(200),
					  BLI_EXERCICE		,--6   NUMBER(4),
					  ITE_ID			,--7   NUMBER(10) not null,
					  PTA_ID			,-- 8  NUMBER(10) not null,
					  PSL_RANK			,--9   NUMBER(2),
					  IMP_ID			,--10  NUMBER(10),
					  BLI_VOLUMEBASE	,--11  NUMBER(17,10),
					  BLI_VOLUMEFACT	,--12  NUMBER(17,10),
					  BLI_PUHT			,--13  NUMBER(17,3),
					  TVA_ID			,--14  NUMBER(10) not null,
					  BLI_MHT			,--15  NUMBER(17,10),
					  BLI_MTTVA			,--16  NUMBER(17,10),
					  BLI_MTTC			,--17  NUMBER(17,10),
					  BLI_STARTDT		,--18  DATE,
					  BLI_ENDDT			,--19  DATE,
					  VOW_UNIT			,--20  NUMBER(10),
					  BLI_NBUNITES		,--21  NUMBER(10),
					  BLI_DETAIL		,--22  NUMBER(1) default 0 not null,
					  BLI_CANCEL		,--23  NUMBER(1) default 0 not null,
					  IMC_ID			,--24  NUMBER(10),
					  IMP_ANALYTIQUE_ID	,--25  NUMBER(10),
					  BLI_PERIODEINIT	,--26  VARCHAR2(20),
					  BLI_PERIODE		,--27  VARCHAR2(20),
					  BLI_REVERSEDT		,--28  DATE,
					  BLI_CREDT			,--29  DATE default sysdate,
					  BLI_UPDTDT		,--30  DATE,
					  BLI_UPDTBY		,--31  NUMBER(10),
					  MEU_ID			,--32  NUMBER(10),
					  BLI_NAME_A		,--33  VARCHAR2(200),
					  BLI_REVERSEBLIDEC_ID,--34NUMBER(10),
					  BLI_REVERSEBLINUMBERDEC,--35     NUMBER(4),
					  BLI_REVERSEDECDT  
					)
		   values
				  (
					  New_Genbill.BIL_ID,--1
					  null				,--2
					  v					,--3
					  null				,--4
					  wite_name			,--5
					  c.MFAL_EXER		,--6
					  WITE_ID			,--7
					  WPTA_ID			,--8
					  WPSL_RANK			,--9
					  null				,--10
					  c.MFAL_VOLU		,--11
					  c.MFAL_VOLU		,--12
					  c.MFAL_PU			,--13
					  WTVA_ID			,--14
					  c.MFAL_MTHT		,--15
					  c.MFAL_MTVA		,--16
					  c.MFAL_MTTC		,--17
					  New_genrun.RUN_STARTDT,--18
					  Fac.MFAE_DEDI		,--19
					  WVOW_UNIT			,--20
					  null				,--21
					  0					,--22
					  0					,--23
					  null				,--24
					  null				,--25
					  null				,--26
					  null				,--27
					  null				,--28
					  null				,--29
					  null				,--30
					  null				,--31
					  null				,--32
					  null				,--33
					  null				,--34
					  null				,--35
					  null				 --36
					);
					exception when others then
					begin
					insert into genbilline
					 (
					  BIL_ID			,--1   NUMBER(10) not null,
					  BLI_REVERSEBLI_ID	,--2   NUMBER(10),
					  BLI_NUMBER		,--3   NUMBER(4) not null,
					  BLI_REVERSEBLINUMBER,--4 NUMBER(4),
					  BLI_NAME          ,--5   VARCHAR2(200),
					  BLI_EXERCICE		,--6   NUMBER(4),
					  ITE_ID			,--7   NUMBER(10) not null,
					  PTA_ID			,-- 8  NUMBER(10) not null,
					  PSL_RANK			,--9   NUMBER(2),
					  IMP_ID			,--10  NUMBER(10),
					  BLI_VOLUMEBASE	,--11  NUMBER(17,10),
					  BLI_VOLUMEFACT	,--12  NUMBER(17,10),
					  BLI_PUHT			,--13  NUMBER(17,3),
					  TVA_ID			,--14  NUMBER(10) not null,
					  BLI_MHT			,--15  NUMBER(17,10),
					  BLI_MTTVA			,--16  NUMBER(17,10),
					  BLI_MTTC			,--17  NUMBER(17,10),
					  BLI_STARTDT		,--18  DATE,
					  BLI_ENDDT			,--19  DATE,
					  VOW_UNIT			,--20  NUMBER(10),
					  BLI_NBUNITES		,--21  NUMBER(10),
					  BLI_DETAIL		,--22  NUMBER(1) default 0 not null,
					  BLI_CANCEL		,--23  NUMBER(1) default 0 not null,
					  IMC_ID			,--24  NUMBER(10),
					  IMP_ANALYTIQUE_ID	,--25  NUMBER(10),
					  BLI_PERIODEINIT	,--26  VARCHAR2(20),
					  BLI_PERIODE		,--27  VARCHAR2(20),
					  BLI_REVERSEDT		,--28  DATE,
					  BLI_CREDT			,--29  DATE default sysdate,
					  BLI_UPDTDT		,--30  DATE,
					  BLI_UPDTBY		,--31  NUMBER(10),
					  MEU_ID			,--32  NUMBER(10),
					  BLI_NAME_A		,--33  VARCHAR2(200),
					  BLI_REVERSEBLIDEC_ID,--34NUMBER(10),
					  BLI_REVERSEBLINUMBERDEC,--35     NUMBER(4),
					  BLI_REVERSEDECDT  
					)
		   values
				  (
					  New_Genbill.BIL_ID,--1
					  null				,--2
					  v+1					,--3
					  null				,--4
					  wite_name			,--5
					  c.MFAL_EXER		,--6
					  WITE_ID			,--7
					  WPTA_ID			,--8
					  WPSL_RANK			,--9
					  null				,--10
					  c.MFAL_VOLU		,--11
					  c.MFAL_VOLU		,--12
					  c.MFAL_PU			,--13
					  WTVA_ID			,--14
					  c.MFAL_MTHT		,--15
					  c.MFAL_MTVA		,--16
					  c.MFAL_MTTC		,--17
					  New_genrun.RUN_STARTDT,--18
					  Fac.MFAE_DEDI		,--19
					  WVOW_UNIT			,--20
					  null				,--21
					  0					,--22
					  0					,--23
					  null				,--24
					  null				,--25
					  null				,--26
					  null				,--27
					  null				,--28
					  null				,--29
					  null				,--30
					  null				,--31
					  null				,--32
					  null				,--33
					  null				,--34
					  null				,--35
					  null				 --36
					);
					exception when others then null;
					end;
					end;
end loop;
Commit;
end loop;
--------Lien entre les factures, avoirs, refacturation
for fac_ in (select * from  mig_pivot_53.miwtfactureentete where MFAE_REF_ORIGINE is not null) loop

   if(fac_.MFAE_TYPE='FA')then  
   begin
	  select bil_id
	  into   v_bil_cancel_id
	  from   genbill
	  where  bil_code = fac_.MFAE_RDET;
	  
	  update genbill 
	  set BIL_CANCEL_ID = v_bil_cancel_id 
	  where bil_code = fac_.MFAE_REF_ORIGINE;
	 exception when others then null;
	  end; 
   elsif (fac_.MFAE_TYPE='RF') then
   begin
      select bil_id
	  into   v_bil_bil_id
	  from   genbill
	  where  bil_code = fac_.MFAE_RDET;
	  
	  update genbill 
	  set BIL_BIL_ID = v_bil_bil_id 
	  where bil_code = fac_.MFAE_REF_ORIGINE;
	  exception when others then null;
	  end; 
   end if;
 commit;
end loop;
end ;
/
SELECT to_char(sysdate, 'DD/MM/YY HH24:MI') heure FROM dual;

PROMPT **************************************************************
PROMPT *** MIGRATION  / Création LIAISON FACTURES RELEVE   **********
PROMPT **************************************************************
--DELETE FROM TECREADITEBILL;
--commit;
--			insert into TECREADITEBILL(select l.bil_id,l.ite_id,t.mrd_id,b.bil_calcdt,null,null,0 from miwtreleve t, mig_pivot_53.miwtfactureentete f,genbill b,genbilline l
	--		where t.mrel_fact1=f.mfae_rdet
	--		and   t.mrel_source=f.mfae_source
	--		and   f.bil_id=b.bil_id
	--		and   b.bil_id=l.bil_id
	--		and   l.meu_id is not null
	--		and t.mrel_fact1 is not null);
--COMMIT;			

PROMPT *******************************************************
PROMPT *** MIGRATION  / Association Acompte Decompte            **********
PROMPT *******************************************************

SELECT to_char(sysdate, 'DD/MM/YY HH24:MI') heure FROM dual;
spo off;
