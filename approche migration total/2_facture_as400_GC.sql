declare 
cursor branch_(district_ varchar2, tourne_ varchar2, ordre_ varchar2) is 
select  b.*
from branchement b
where  lpad(trim(b.district),2,'0')=district_
and lpad(trim(b.tourne),3,'0') = tourne_
and lpad(trim(b.ordre),3,'0') = ordre_;

cursor fact_as400gc select * from facture_as400gc ;

	MEU_ID     		  number;
    Debt_Id           Number ;
    Genbill_Id        Number ;
    Agrbill_Id        Number ;
    genimp_id         number ;
    genaccount_id     number ;
    agrsagaco_id      number ;
    genrun_id         number ;
	v_ORG_ID		  number ;
	v_PAR_ID          number ;
	V_ADR_ID          number ;
	v_SAG_ID          number;
	v                 number;
	v_nbr             number;
	v_ID_FACTURE      varchar2(50);
	V_pdl_ref         varchar2(50);
	V_REF_ABN         varchar2(50);
	V_COMPTEAUX		  varchar2(10);
	v_TOTHTE          NUMBER(25,10);
    v_TVA             NUMBER(25,10);
    V_TOTHTA          NUMBER(25,10);
    V_TOTTVAA         NUMBER(25,10);
	V_SOLDE           NUMBER(25,10);
	anneereel_        varchar2(4);
	periode_          number;
	tiers_            varchar2(1);
    six_              varchar2(1);
	V_TRAIN_FACT      varchar2(200);
	v_version         number(1):=0;
	V_FAC_DATECALCUL  date;
	V_FAC_DATELIM     date;
	date_             date;
	v_ABN_DT_DEB      date;
	WITE_ID    		  number;
	wite_name  		  varchar2(100);
	WTVA_ID           number;
	WVOW_UNIT         NUMBER;
	WPTA_ID           number;
	WPSL_RANK         number;
	nbr        		  number;
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
	
		
Procedure Genere_genrun (Newgenrun genrun%rowtype ,genrunId  in out   number ,ref_genrun out number) is
    V_RUN_NUMBER NUMBER;
 BEGIN
      SELECT  run_id 
	  INTO  ref_genrun
      from    genrun
      where   RUN_NAME = Newgenrun.RUN_NAME;
Exception
  WHEN NO_DATA_FOUND THEN
    select nvl(max(RUN_NUMBER),0)+1
	  into   V_RUN_NUMBER
	  from   genrun
	  where  run_exercice = Newgenrun.run_exercice;
	  
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
Procedure Genere_genimp (Newgenimp genimp%rowtype ,genimpId  in out number ,ref_genimp out number) is
 BEGIN
      SELECT  imp_id 
	  INTO  ref_genimp
      from    genimp
      where   nvl(imp_code,'*') = nvl(Newgenimp.imp_code ,'*')
      and     nvl(ORG_ID,0)  = nvl(Newgenimp.ORG_ID ,0) ;
Exception
  WHEN NO_DATA_FOUND THEN
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
    
BEGIN	 
	for facture_ in fact_as400gc
	loop
	
		for x in branch_(lpad(facture_.DIST,2,'0'),lpad(trim(facture_.TOU),3,'0'),lpad(trim(facture_.ORD), 3, '0'))
		loop	
			
			select seq_genrun.nextval     into genrun_id     from dual;
			select seq_agrbill.nextval    into Agrbill_Id    from dual;
			select seq_gendebt.nextval    into Debt_Id       from dual;
			select seq_genimp.nextval     into genimp_id     from dual;
			select seq_agrsagaco.nextval  into agrsagaco_id  from dual;
			select seq_genaccount.nextval into genaccount_id from dual;
			
				select last_day(to_date('01'||lpad(facture_.refc01,2,'0')||facture_.refc02,'ddmmyy')) 
				into date_
				from dual;
				periode_     := trim(facture_.refc01);
				anneereel_   := to_char(date_,'yyyy');
             
      
				V_ID_FACTURE:=lpad(trim(facture_.DIST),2,'0')||
							  lpad(trim(facture_.tou),3,'0') ||
							  lpad(trim(facture_.ORD),3,'0')||
							  to_char(anneereel_)||
							  lpad(to_char(periode_),2,0)||
							  to_char(version);
							  
					  
			select count(*) 
				into v_nbr
				from genbill b
				where b.BIL_CODE=v_ID_FACTURE;
			
			if v_nbr=0 then 
			 
			    V_FAC_DATECALCUL :=null;
				V_FAC_DATELIM    :=null;
				V_TRAIN_FACT     :=null;
				V_pdl_ref        :=null;
				V_AMOUNTTTCDEC   :=null;
				
				V_pdl_ref:= lpad(trim(facture_.dist),2,'0') ||
								lpad(trim(facture_.tou),3,'0') ||
								lpad(trim(facture_.ord),3,'0') ||
								lpad(trim(facture_.pol),5,'0');		
								
				
			    select g.org_id
				into v_ORG_ID 
				from GENORGANIZATION g 
				where upper (g.org_code)=lpad(trim(facture_.dist),2,'0');
				
				 
				select cag.par_id  
				into v_PAR_ID
				from AGRCUSTOMERAGR cag
				where cag.cag_id in (
									 select sag.cag_id
									 from TECSERVICEPOINT spt,
										  AGRSERVICEAGR sag
									 where spt.spt_id=sag.spt_id
									 and spt.spt_refe=V_pdl_ref
									);
				select  par.adr_id
				into    V_ADR_ID
				from GENPARTY  par
				where par.par_id=v_PAR_ID;		

				select sag.sag_id ,sag.sag_startdt
				into v_SAG_ID,v_ABN_DT_DEB
				from AGRSERVICEAGR sag,
					 TECSERVICEPOINT spt
				where sag.spt_id=spt.spt_id 
				and spt.spt_refe=V_pdl_ref;	
				
							
				BEGIN
					select to_date(lpad(trim(DATEXP),8,'0'),'ddmmyyyy'),
					to_date(lpad(trim(DATL),8,'0'),'ddmmyyyy')    
					into V_FAC_DATECALCUL,V_FAC_DATELIM 
					from role_mens
					where to_number(facture_.pol)=POLICE
					AND to_number(facture_.Dist) = DISTR
					And to_number(facture_.refc01) = MOIS
					AND rownum = 1;
				EXCEPTION WHEN OTHERS THEN
					V_FAC_DATECALCUL := date_;
					V_FAC_DATELIM    := date_;
				END;
				V_REF_ABN := lpad(trim(facture_.DIST),2,'0')||
							 lpad(to_char(facture_.pol),5,'0')||
							 lpad(trim(facture_.tou),3,'0') ||
							 lpad(trim(facture_.ORD),3,'0');
                     
				V_TRAIN_FACT:='ANNEE:'||trim(anneereel_)||' MOIS:'||trim(periode_);
				V_COMPTEAUX:='IMP_MIG'			   
				v_TOTHTE:=(facture_.monttrim-(v_tva))/1000;
				v_TVA:=(facture_.tva_ff+facture_.tva_capit+facture_.tva_pfin+facture_.tvacons+facture_.tva_preav+ facture_.tvaferm+facture_.tvadeplac+facture_.tvadepose_dem+facture_.tvadepose_def)/1000;
				V_TOTHTA:=0;
				V_TOTTVAA:=0;
				V_SOLDE:=facture_.monttrim/1000;
				
				New_Det     := null;
			    New_Genbill := null;
			    New_genrun  := null;
					If  (anneereel_ is not null 
						 and periode_ is not null 
						 and V_TRAIN_FACT is not null) then
    
					New_genrun.RUN_EXERCICE   :=  anneereel_ ;
					New_genrun.RUN_NUMBER     :=  periode_ ;
					New_genrun.ORG_ID         :=  V_ORG_ID ;
					New_genrun.RUN_STARTDT    :=  V_FAC_DATECALCUL;
					New_genrun.RUN_COMMENT    :=  'Role migré' ;
					New_genrun.RUN_NAME       :=  'Role '||V_TRAIN_FACT;
					Genere_genrun(New_genrun,genrun_id,genrun_ref);
					end if ;
					
					--------------------------------------------------------Traitement Det
					New_Det.DEB_ID           :=  Debt_Id ;
					New_Det.DEB_REFE         :=  V_ID_FACTURE;
					New_Det.ORG_ID           :=  V_ORG_ID ;
					New_Det.PAR_ID           :=  V_PAR_ID ;
					New_Det.ADR_ID           :=  V_ADR_ID ;
					New_Det.DEB_DATE         :=  V_FAC_DATECALCUL;
					New_Det.DEB_DUEDT        :=  V_FAC_DATELIM;
					New_Det.DEB_PRINTDT      :=  V_FAC_DATECALCUL;
					New_Det.SAG_ID           :=  V_SAG_ID ;
					New_Det.DEB_PREL         :=  1 ;
					If (v_TOTHTE+v_TVA+V_TOTHTA+V_TOTTVAA) > 0 then 
					New_Det.DEB_AMOUNTINIT   := V_TOTHTE+V_TOTTVAE+V_TOTHTA+V_TOTTVAA;
					New_Det.VOW_DEBTYPE      := pk_genvocword.getidbycode('VOW_DEBTYPE','FA',null) ;
					else
					New_Det.deb_amount_cash  := -(V_TOTHTE+V_TOTTVAE+V_TOTHTA+V_TOTTVAA) ;
					New_Det.DEB_AMOUNTINIT   := 0;
					New_Det.VOW_DEBTYPE      := pk_genvocword.getidbycode('VOW_DEBTYPE','AV',null) ;
					end if ;

					New_Det.DEB_AMOUNTREMAIN :=  V_SOLDE ;
					New_Det.DEB_COMMENT      :=  V_REF_ABN ;
					New_Det.VOW_SETTLEMODE   := pk_genvocword.getidbycode('VOW_SETTLEMODE',4,null) ;
				--
					--------------------------------------------------------Traitement GENACCOUNT ,GENIMP
					New_genimp.imp_code      :=  V_COMPTEAUX ;
					New_genimp.imp_name      :=  V_COMPTEAUX ;
					New_genimp.vow_budgtp    :=  pk_genvocword.getidbycode('VOW_BUDGTP','EA',null);
					Genere_genimp(New_genimp,genimp_id,genimp_ref);
					New_genaccount.PAR_ID    :=  V_PAR_ID;
					New_genaccount.IMP_ID    :=  genimp_ref ;
					New_genaccount.VOW_ACOTP :=  pk_genvocword.getidbycode('VOW_ACOTP','1',null);
					New_genaccount.REC_ID    :=  V_REC_ID ;
					New_agrsagaco.SAG_ID     :=  V_SAG_ID ;
					New_agrsagaco.SCO_STARTDT:=  V_ABN_DT_DEB;
					Genere_genaccount(New_genaccount ,genaccount_id ,genaccount_ref ,agrsagaco_id,New_agrsagaco) ;
					New_Det.ACO_ID           := genaccount_ref ;
					New_Det.DEB_NORECOVERY   := 0;
					
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
								commit;
--------------------------------------------------------Traitement agrbill
					New_Agrbill.BIL_ID            :=  Agrbill_Id ;
					New_Agrbill.SAG_ID            :=  V_SAG_ID;
					New_Agrbill.VOW_AGRBILLTYPE   :=  pk_genvocword.getidbycode('VOW_AGRBILLTYPE','FC',null) ;
					New_Agrbill.VOW_MODEFACT      :=  pk_genvocword.getidbycode('VOW_MODEFACT',4,null) ;
					
					Insert into agrbill(
										BIL_ID,
										SAG_ID,
										VOW_AGRBILLTYPE,
										VOW_MODEFACT
										)
								values(
										New_Agrbill.BIL_ID,
										New_Agrbill.SAG_ID,
										New_Agrbill.VOW_AGRBILLTYPE,
										New_Agrbill.VOW_MODEFACT
									  );
			        
					
				--------------------------------------------------------Traitement genbill
					New_Genbill.BIL_ID            :=  Agrbill_Id;
					New_Genbill.BIL_CODE          :=  V_ID_FACTURE; --Fac.MFAE_NUME;
					New_Genbill.BIL_CALCDT        :=  V_FAC_DATECALCUL;
					New_Genbill.BIL_AMOUNTHT      :=  V_TOTHTE +V_TOTHTA ;
					New_Genbill.BIL_AMOUNTTVA     :=  V_TOTTVAE+V_TOTTVAA ;
					New_Genbill.BIL_AMOUNTTTC     :=  V_TOTHTE+V_TOTTVAE+V_TOTHTA+V_TOTTVAA ;
					New_Genbill.BIL_AMOUNTTTCDEC  :=  V_AMOUNTTTCDEC;
					New_Genbill.BIL_STATUS        :=  1;
					New_Genbill.DEB_ID            :=  Debt_Id;
					New_Genbill.PAR_ID            :=  Fac.PAR_ID ;
					New_Genbill.BIL_DEBTDT        :=  V_FAC_DATECALCUL;
					New_Genbill.RUN_ID            :=  genrun_ref  ;
						begin
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
		end if;						

v := 0;
-------------------------------------------------------------------------------------------
-----------------------------------CONSOMMATION SONEDE 1ERE TRANCHE---------------------------------------
-------------------------------------------------------------------------------------------		
		if to_number(facture_.montt1) <> 0 then
									v := v+1;
							WPTA_ID := null;
							WPSL_RANK := null;
										begin
										select ITE_ID,ite_name,VOW_UNIT  
										INTO WITE_ID,wite_name,WVOW_UNIT  
										from genitem s 
										where s.ITE_CODE = 'CSM_STD';
										exception when no_data_found then null;
										end;
										begin
										select tva_id 
										into wtva_id 
										from gentva 
										where tva_taux= 18;
										exception when no_data_found then 
										wtva_id := 25;
										end;

										select count(*) 
										into nbr 
										from genptaslice 
										where PTA_ID in (select PTA_ID 	from genitemperiodtarif 
														 where TAR_id in ( select tar_id from genitemtarif where ITE_ID=WITE_ID )
														);
										if nbr=1 then
										
											select PTA_ID,PSL_RANK  
											into WPTA_ID,WPSL_RANK 
											from genptaslice 
											where PTA_ID in (select PTA_ID 
															 from genitemperiodtarif 
															 where TAR_id in (select tar_id from genitemtarif where ITE_ID=WITE_ID)
															)
											and rownum=1;
										
										end if;

										if nbr>1 then
											select PTA_ID,PSL_RANK  
											into WPTA_ID,WPSL_RANK 
											from genptaslice 
											where   PTA_ID
											in (select PTA_ID 
												from genitemperiodtarif
												where TAR_id in (select tar_id from genitemtarif where ITE_ID=WITE_Id) 
											   )and rownum=1;
										 
										end if;

										BEGIN
											insert into genbilline
																	(
																	BIL_ID			    ,--1   NUMBER(10) not null,
																	BLI_REVERSEBLI_ID	,--2   NUMBER(10),
																	BLI_NUMBER		    ,--3   NUMBER(4) not null,
																	BLI_REVERSEBLINUMBER,--4   NUMBER(4),
																	BLI_NAME            ,--5   VARCHAR2(200),
																	BLI_EXERCICE		,--6   NUMBER(4),
																	ITE_ID				,--7   NUMBER(10) not null,
																	PTA_ID				,-- 8  NUMBER(10) not null,
																	PSL_RANK			,--9   NUMBER(2),
																	IMP_ID				,--10  NUMBER(10),
																	BLI_VOLUMEBASE		,--11  NUMBER(17,10),
																	BLI_VOLUMEFACT		,--12  NUMBER(17,10),
																	BLI_PUHT			,--13  NUMBER(17,3),
																	TVA_ID				,--14  NUMBER(10) not null,
																	BLI_MHT				,--15  NUMBER(17,10),
																	BLI_MTTVA			,--16  NUMBER(17,10),
																	BLI_MTTC			,--17  NUMBER(17,10),
																	BLI_STARTDT			,--18  DATE,
																	BLI_ENDDT			,--19  DATE,
																	VOW_UNIT			,--20  NUMBER(10),
																	BLI_NBUNITES		,--21  NUMBER(10),
																	BLI_DETAIL			,--22  NUMBER(1) default 0 not null,
																	BLI_CANCEL			,--23  NUMBER(1) default 0 not null,
																	IMC_ID				,--24  NUMBER(10),
																	IMP_ANALYTIQUE_ID	,--25  NUMBER(10),
																	BLI_PERIODEINIT		,--26  VARCHAR2(20),
																	BLI_PERIODE			,--27  VARCHAR2(20),
																	BLI_REVERSEDT		,--28  DATE,
																	BLI_CREDT			,--29  DATE default sysdate,
																	BLI_UPDTDT			,--30  DATE,
																	BLI_UPDTBY			,--31  NUMBER(10),
																	MEU_ID				,--32  NUMBER(10),
																	BLI_NAME_A			,--33  VARCHAR2(200),
																	BLI_REVERSEBLIDEC_ID,--34  NUMBER(10),
																	BLI_REVERSEBLINUMBERDEC,--35 NUMBER(4),
																	BLI_REVERSEDECDT    ,--35 
																	)
															values
																	(
																	New_Genbill.BIL_ID,--1
																	null				,--2
																	v					,--3
																	null				,--4
																	wite_name			,--5
																	anneereel_			,--6
																	WITE_ID				,--7
																	WPTA_ID				,--8
																	WPSL_RANK			,--9
																	null				,--10
																	facture_.const1		,--11
																	facture_.const1		,--12
																	c.MFAL_PU			,--13
																	WTVA_ID				,--14
																	facture_.montt1/1000,--15
																	facture_.tvacons/1000,--16
																	facture_.montt1/1000+(facture_.tvacons/1000),--17
																	New_genrun.RUN_STARTDT,--18
																	V_FAC_DATECALCUL	,--19
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
																EXCEPTION WHEN OTHERS THEN
																	BEGIN
																	insert into genbilline
																		(
																			BIL_ID			    ,--1   
																			BLI_REVERSEBLI_ID	,--2   
																			BLI_NUMBER			,--3   
																			BLI_REVERSEBLINUMBER,--4 
																			BLI_NAME          	,--5   
																			BLI_EXERCICE		,--6   
																			ITE_ID				,--7   
																			PTA_ID				,--8  
																			PSL_RANK			,--9   
																			IMP_ID				,--10  
																			BLI_VOLUMEBASE		,--11  
																			BLI_VOLUMEFACT		,--12  
																			BLI_PUHT			,--13  
																			TVA_ID				,--14  
																			BLI_MHT				,--15  
																			BLI_MTTVA			,--16  
																			BLI_MTTC			,--17  
																			BLI_STARTDT			,--18  
																			BLI_ENDDT			,--19  
																			VOW_UNIT			,--20  
																			BLI_NBUNITES		,--21  
																			BLI_DETAIL			,--22  
																			BLI_CANCEL			,--23  
																			IMC_ID				,--24  
																			IMP_ANALYTIQUE_ID	,--25  
																			BLI_PERIODEINIT		,--26  
																			BLI_PERIODE			,--27  
																			BLI_REVERSEDT		,--28  
																			BLI_CREDT			,--29  
																			BLI_UPDTDT			,--30  
																			BLI_UPDTBY			,--31  
																			MEU_ID				,--32  
																			BLI_NAME_A			,--33  
																			BLI_REVERSEBLIDEC_ID,--34  
																			BLI_REVERSEBLINUMBERDEC,--35 
																			BLI_REVERSEDECDT    --36
																			)
																			values
																			(
																			New_Genbill.BIL_ID,--1
																			null				,--2
																			v+1					,--3
																			null				,--4
																			wite_name			,--5
																			anneereel_		,--6
																			WITE_ID			,--7
																			WPTA_ID			,--8
																			WPSL_RANK			,--9
																			null				,--10
																			facture_.const1		,--11
																			facture_.const1		,--12
																			c.MFAL_PU			,--13
																			WTVA_ID				,--14
																			facture_.montt1/1000,--15
																			facture_.tvacons/1000,--16
																			facture_.montt1/1000+(facture_.tvacons/1000),--17
																			New_genrun.RUN_STARTDT,--18
																			V_FAC_DATECALCUL		,--19
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
																	EXCEPTION WHEN OTHERS THEN NULL;
																	END;
											END;
		end if; 
		
-------------------------------------------------------------------------------------------
------------------------------------CONSOMMATION SONEDE 2EME TRANCHE--------------------------------------
-------------------------------------------------------------------------------------------		
		if to_number(facture_.montt2) <> 0 then
									v := v+1;
							WPTA_ID := null;
							WPSL_RANK := null;
										begin
										select ITE_ID,ite_name,VOW_UNIT  
										INTO WITE_ID,wite_name,WVOW_UNIT  
										from genitem s 
										where s.ITE_CODE ='CSM_STD';
										exception when no_data_found then null;
										end;
										begin
										select tva_id 
										into wtva_id 
										from gentva 
										where tva_taux= 18;
										exception when no_data_found then wtva_id := 25;
										end;

										select count(*) 
										into nbr 
										from genptaslice 
										where PTA_ID in (select PTA_ID 	from genitemperiodtarif 
														 where TAR_id in ( select tar_id from genitemtarif where ITE_ID=WITE_ID )
														);
										if nbr=1 then
										
											select PTA_ID,PSL_RANK  
											into WPTA_ID,WPSL_RANK 
											from genptaslice 
											where PTA_ID in (select PTA_ID 
															 from genitemperiodtarif 
															 where TAR_id in (select tar_id from genitemtarif where ITE_ID=WITE_ID)
															)
											and rownum=1;
										
										end if;

										if nbr>1 then
											select PTA_ID,PSL_RANK  
											into WPTA_ID,WPSL_RANK 
											from genptaslice 
											where   PTA_ID
											in (select PTA_ID 
												from genitemperiodtarif
												where TAR_id in (select tar_id from genitemtarif where ITE_ID=WITE_Id) 
											   )and rownum=1;
										 
										end if;

										BEGIN
											insert into genbilline
																	(
																	BIL_ID			    ,--1   NUMBER(10) not null,
																	BLI_REVERSEBLI_ID	,--2   NUMBER(10),
																	BLI_NUMBER		    ,--3   NUMBER(4) not null,
																	BLI_REVERSEBLINUMBER,--4   NUMBER(4),
																	BLI_NAME            ,--5   VARCHAR2(200),
																	BLI_EXERCICE		,--6   NUMBER(4),
																	ITE_ID				,--7   NUMBER(10) not null,
																	PTA_ID				,-- 8  NUMBER(10) not null,
																	PSL_RANK			,--9   NUMBER(2),
																	IMP_ID				,--10  NUMBER(10),
																	BLI_VOLUMEBASE		,--11  NUMBER(17,10),
																	BLI_VOLUMEFACT		,--12  NUMBER(17,10),
																	BLI_PUHT			,--13  NUMBER(17,3),
																	TVA_ID				,--14  NUMBER(10) not null,
																	BLI_MHT				,--15  NUMBER(17,10),
																	BLI_MTTVA			,--16  NUMBER(17,10),
																	BLI_MTTC			,--17  NUMBER(17,10),
																	BLI_STARTDT			,--18  DATE,
																	BLI_ENDDT			,--19  DATE,
																	VOW_UNIT			,--20  NUMBER(10),
																	BLI_NBUNITES		,--21  NUMBER(10),
																	BLI_DETAIL			,--22  NUMBER(1) default 0 not null,
																	BLI_CANCEL			,--23  NUMBER(1) default 0 not null,
																	IMC_ID				,--24  NUMBER(10),
																	IMP_ANALYTIQUE_ID	,--25  NUMBER(10),
																	BLI_PERIODEINIT		,--26  VARCHAR2(20),
																	BLI_PERIODE			,--27  VARCHAR2(20),
																	BLI_REVERSEDT		,--28  DATE,
																	BLI_CREDT			,--29  DATE default sysdate,
																	BLI_UPDTDT			,--30  DATE,
																	BLI_UPDTBY			,--31  NUMBER(10),
																	MEU_ID				,--32  NUMBER(10),
																	BLI_NAME_A			,--33  VARCHAR2(200),
																	BLI_REVERSEBLIDEC_ID,--34  NUMBER(10),
																	BLI_REVERSEBLINUMBERDEC,--35 NUMBER(4),
																	BLI_REVERSEDECDT    ,--35 
																	)
															values
																	(
																	New_Genbill.BIL_ID  ,--1
																	null				,--2
																	v					,--3
																	null				,--4
																	wite_name			,--5
																	anneereel_			,--6
																	WITE_ID				,--7
																	WPTA_ID				,--8
																	WPSL_RANK			,--9
																	null				,--10
																	facture_.const2		,--11
																	facture_.const2		,--12
																	facture_.tauxt2/1000,--13
																	WTVA_ID				,--14
																	facture_.montt2/1000,--15
																	facture_.tvacons/1000,--16
																	facture_.montt2/1000+(facture_.tvacons/1000),--17
																	New_genrun.RUN_STARTDT,--18
																	V_FAC_DATECALCUL	,--19
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
																EXCEPTION WHEN OTHERS THEN
																	BEGIN
																	insert into genbilline
																		(
																			BIL_ID			    ,--1   
																			BLI_REVERSEBLI_ID	,--2   
																			BLI_NUMBER			,--3   
																			BLI_REVERSEBLINUMBER,--4 
																			BLI_NAME          	,--5   
																			BLI_EXERCICE		,--6   
																			ITE_ID				,--7   
																			PTA_ID				,--8  
																			PSL_RANK			,--9   
																			IMP_ID				,--10  
																			BLI_VOLUMEBASE		,--11  
																			BLI_VOLUMEFACT		,--12  
																			BLI_PUHT			,--13  
																			TVA_ID				,--14  
																			BLI_MHT				,--15  
																			BLI_MTTVA			,--16  
																			BLI_MTTC			,--17  
																			BLI_STARTDT			,--18  
																			BLI_ENDDT			,--19  
																			VOW_UNIT			,--20  
																			BLI_NBUNITES		,--21  
																			BLI_DETAIL			,--22  
																			BLI_CANCEL			,--23  
																			IMC_ID				,--24  
																			IMP_ANALYTIQUE_ID	,--25  
																			BLI_PERIODEINIT		,--26  
																			BLI_PERIODE			,--27  
																			BLI_REVERSEDT		,--28  
																			BLI_CREDT			,--29  
																			BLI_UPDTDT			,--30  
																			BLI_UPDTBY			,--31  
																			MEU_ID				,--32  
																			BLI_NAME_A			,--33  
																			BLI_REVERSEBLIDEC_ID,--34  
																			BLI_REVERSEBLINUMBERDEC,--35 
																			BLI_REVERSEDECDT    --36
																			)
																			values
																			(
																			New_Genbill.BIL_ID,--1
																			null				,--2
																			v+1					,--3
																			null				,--4
																			wite_name			,--5
																			anneereel_			,--6
																			WITE_ID				,--7
																			WPTA_ID				,--8
																			WPSL_RANK			,--9
																			null				,--10
																			facture_.const2		,--11
																			facture_.const2		,--12
																			facture_.tauxt2/1000,--13
																			WTVA_ID				,--14
																			facture_.montt2/1000,--15
																			facture_.tvacons/1000,--16
																			facture_.montt2/1000+(facture_.tvacons/1000),--17
																			New_genrun.RUN_STARTDT,--18
																			V_FAC_DATECALCUL		,--19
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
																	EXCEPTION WHEN OTHERS THEN NULL;
																	END;
											END;
		end if;
		
		
-------------------------------------------------------------------------------------------
-----------------------------------CONSOMMATION SONEDE 3EME TRANCHE---------------------------------------
-------------------------------------------------------------------------------------------		
		if to_number(facture_.montt3) <> 0 then
									v := v+1;
							WPTA_ID := null;
							WPSL_RANK := null;
										begin
										select ITE_ID,ite_name,VOW_UNIT  
										INTO WITE_ID,wite_name,WVOW_UNIT  
										from genitem s 
										where s.ITE_CODE = 'CSM_STD';
										exception when no_data_found then null;
										end;
										begin
										select tva_id 
										into wtva_id 
										from gentva 
										where tva_taux= 18;
										exception when no_data_found then wtva_id := 25;
										end;

										select count(*) 
										into nbr 
										from genptaslice 
										where PTA_ID in (select PTA_ID 	from genitemperiodtarif 
														 where TAR_id in ( select tar_id from genitemtarif where ITE_ID=WITE_ID )
														);
										if nbr=1 then
										
											select PTA_ID,PSL_RANK  
											into WPTA_ID,WPSL_RANK 
											from genptaslice 
											where PTA_ID in (select PTA_ID 
															 from genitemperiodtarif 
															 where TAR_id in (select tar_id from genitemtarif where ITE_ID=WITE_ID)
															)
											and rownum=1;
										
										end if;

										if nbr>1 then
											select PTA_ID,PSL_RANK  
											into WPTA_ID,WPSL_RANK 
											from genptaslice 
											where   PTA_ID
											in (select PTA_ID 
												from genitemperiodtarif
												where TAR_id in (select tar_id from genitemtarif where ITE_ID=WITE_Id) 
											   )and rownum=1;
										 
										end if;

										BEGIN
											insert into genbilline
																	(
																	BIL_ID			    ,--1   NUMBER(10) not null,
																	BLI_REVERSEBLI_ID	,--2   NUMBER(10),
																	BLI_NUMBER		    ,--3   NUMBER(4) not null,
																	BLI_REVERSEBLINUMBER,--4   NUMBER(4),
																	BLI_NAME            ,--5   VARCHAR2(200),
																	BLI_EXERCICE		,--6   NUMBER(4),
																	ITE_ID				,--7   NUMBER(10) not null,
																	PTA_ID				,-- 8  NUMBER(10) not null,
																	PSL_RANK			,--9   NUMBER(2),
																	IMP_ID				,--10  NUMBER(10),
																	BLI_VOLUMEBASE		,--11  NUMBER(17,10),
																	BLI_VOLUMEFACT		,--12  NUMBER(17,10),
																	BLI_PUHT			,--13  NUMBER(17,3),
																	TVA_ID				,--14  NUMBER(10) not null,
																	BLI_MHT				,--15  NUMBER(17,10),
																	BLI_MTTVA			,--16  NUMBER(17,10),
																	BLI_MTTC			,--17  NUMBER(17,10),
																	BLI_STARTDT			,--18  DATE,
																	BLI_ENDDT			,--19  DATE,
																	VOW_UNIT			,--20  NUMBER(10),
																	BLI_NBUNITES		,--21  NUMBER(10),
																	BLI_DETAIL			,--22  NUMBER(1) default 0 not null,
																	BLI_CANCEL			,--23  NUMBER(1) default 0 not null,
																	IMC_ID				,--24  NUMBER(10),
																	IMP_ANALYTIQUE_ID	,--25  NUMBER(10),
																	BLI_PERIODEINIT		,--26  VARCHAR2(20),
																	BLI_PERIODE			,--27  VARCHAR2(20),
																	BLI_REVERSEDT		,--28  DATE,
																	BLI_CREDT			,--29  DATE default sysdate,
																	BLI_UPDTDT			,--30  DATE,
																	BLI_UPDTBY			,--31  NUMBER(10),
																	MEU_ID				,--32  NUMBER(10),
																	BLI_NAME_A			,--33  VARCHAR2(200),
																	BLI_REVERSEBLIDEC_ID,--34  NUMBER(10),
																	BLI_REVERSEBLINUMBERDEC,--35 NUMBER(4),
																	BLI_REVERSEDECDT    ,--35 
																	)
															values
																	(
																	New_Genbill.BIL_ID,--1
																	null				,--2
																	v					,--3
																	null				,--4
																	wite_name			,--5
																	anneereel_			,--6
																	WITE_ID				,--7
																	WPTA_ID				,--8
																	WPSL_RANK			,--9
																	null				,--10
																	facture_.const3 	,--11
																	facture_.const3 	,--12
																	facture_.tauxt3/1000,--13
																	WTVA_ID				,--14
																	facture_.montt3/1000,--15
																	facture_.tvacons/1000,--16
																	facture_.montt3/1000+(facture_.tvacons/1000),--17
																	New_genrun.RUN_STARTDT,--18
																	V_FAC_DATECALCUL		,--19
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
																EXCEPTION WHEN OTHERS THEN
																	BEGIN
																	insert into genbilline
																		(
																			BIL_ID			    ,--1   
																			BLI_REVERSEBLI_ID	,--2   
																			BLI_NUMBER			,--3   
																			BLI_REVERSEBLINUMBER,--4 
																			BLI_NAME          	,--5   
																			BLI_EXERCICE		,--6   
																			ITE_ID				,--7   
																			PTA_ID				,--8  
																			PSL_RANK			,--9   
																			IMP_ID				,--10  
																			BLI_VOLUMEBASE		,--11  
																			BLI_VOLUMEFACT		,--12  
																			BLI_PUHT			,--13  
																			TVA_ID				,--14  
																			BLI_MHT				,--15  
																			BLI_MTTVA			,--16  
																			BLI_MTTC			,--17  
																			BLI_STARTDT			,--18  
																			BLI_ENDDT			,--19  
																			VOW_UNIT			,--20  
																			BLI_NBUNITES		,--21  
																			BLI_DETAIL			,--22  
																			BLI_CANCEL			,--23  
																			IMC_ID				,--24  
																			IMP_ANALYTIQUE_ID	,--25  
																			BLI_PERIODEINIT		,--26  
																			BLI_PERIODE			,--27  
																			BLI_REVERSEDT		,--28  
																			BLI_CREDT			,--29  
																			BLI_UPDTDT			,--30  
																			BLI_UPDTBY			,--31  
																			MEU_ID				,--32  
																			BLI_NAME_A			,--33  
																			BLI_REVERSEBLIDEC_ID,--34  
																			BLI_REVERSEBLINUMBERDEC,--35 
																			BLI_REVERSEDECDT    --36
																			)
																			values
																			(
																			New_Genbill.BIL_ID,--1
																			null				,--2
																			v+1					,--3
																			null				,--4
																			wite_name			,--5
																			anneereel_		,--6
																			WITE_ID			,--7
																			WPTA_ID			,--8
																			WPSL_RANK			,--9
																			null				,--10
																			facture_.const3 	,--11
																			facture_.const3 	,--12
																			facture_.tauxt3/1000,--13
																			WTVA_ID				,--14
																			facture_.montt3/1000,--15
																			facture_.tvacons/1000,--16
																			facture_.montt3/1000+(facture_.tvacons/1000),--17
																			New_genrun.RUN_STARTDT,--18
																			V_FAC_DATECALCUL	,--19
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
																	EXCEPTION WHEN OTHERS THEN NULL;
																	END;
											END;
		end if;		
		
-------------------------------------------------------------------------------------------
-----------------------------------REDEVANCE ONAS 1ERE TRANCHE---------------------------------------
-------------------------------------------------------------------------------------------		
		if to_number(facture_.mon1) <> 0 then
		
						v := v+1;
						WPTA_ID := null;
						WPSL_RANK := null;
										begin
										select ITE_ID,ite_name,VOW_UNIT  
										INTO WITE_ID,wite_name,WVOW_UNIT  
										from genitem s 
										where s.ITE_CODE = 'VAR_ONAS_1';
										exception when no_data_found then null;
										end;
										begin
										select tva_id 
										into wtva_id 
										from gentva 
										where tva_taux= 0;
										exception when no_data_found then wtva_id := 25;
										end;

										select count(*) 
										into nbr 
										from genptaslice 
										where PTA_ID in (select PTA_ID 	from genitemperiodtarif 
														 where TAR_id in ( select tar_id from genitemtarif where ITE_ID=WITE_ID )
														);
										if nbr=1 then
										
											select PTA_ID,PSL_RANK  
											into WPTA_ID,WPSL_RANK 
											from genptaslice 
											where PTA_ID in (select PTA_ID 
															 from genitemperiodtarif 
															 where TAR_id in (select tar_id from genitemtarif where ITE_ID=WITE_ID)
															)
											and rownum=1;
										
										end if;

										if nbr>1 then
											select PTA_ID,PSL_RANK  
											into WPTA_ID,WPSL_RANK 
											from genptaslice 
											where   PTA_ID
											in (select PTA_ID 
												from genitemperiodtarif
												where TAR_id in (select tar_id from genitemtarif where ITE_ID=WITE_Id) 
											   )and rownum=1;
										 
										end if;

										BEGIN
											insert into genbilline
																	(
																	BIL_ID			    ,--1   NUMBER(10) not null,
																	BLI_REVERSEBLI_ID	,--2   NUMBER(10),
																	BLI_NUMBER		    ,--3   NUMBER(4) not null,
																	BLI_REVERSEBLINUMBER,--4   NUMBER(4),
																	BLI_NAME            ,--5   VARCHAR2(200),
																	BLI_EXERCICE		,--6   NUMBER(4),
																	ITE_ID				,--7   NUMBER(10) not null,
																	PTA_ID				,-- 8  NUMBER(10) not null,
																	PSL_RANK			,--9   NUMBER(2),
																	IMP_ID				,--10  NUMBER(10),
																	BLI_VOLUMEBASE		,--11  NUMBER(17,10),
																	BLI_VOLUMEFACT		,--12  NUMBER(17,10),
																	BLI_PUHT			,--13  NUMBER(17,3),
																	TVA_ID				,--14  NUMBER(10) not null,
																	BLI_MHT				,--15  NUMBER(17,10),
																	BLI_MTTVA			,--16  NUMBER(17,10),
																	BLI_MTTC			,--17  NUMBER(17,10),
																	BLI_STARTDT			,--18  DATE,
																	BLI_ENDDT			,--19  DATE,
																	VOW_UNIT			,--20  NUMBER(10),
																	BLI_NBUNITES		,--21  NUMBER(10),
																	BLI_DETAIL			,--22  NUMBER(1) default 0 not null,
																	BLI_CANCEL			,--23  NUMBER(1) default 0 not null,
																	IMC_ID				,--24  NUMBER(10),
																	IMP_ANALYTIQUE_ID	,--25  NUMBER(10),
																	BLI_PERIODEINIT		,--26  VARCHAR2(20),
																	BLI_PERIODE			,--27  VARCHAR2(20),
																	BLI_REVERSEDT		,--28  DATE,
																	BLI_CREDT			,--29  DATE default sysdate,
																	BLI_UPDTDT			,--30  DATE,
																	BLI_UPDTBY			,--31  NUMBER(10),
																	MEU_ID				,--32  NUMBER(10),
																	BLI_NAME_A			,--33  VARCHAR2(200),
																	BLI_REVERSEBLIDEC_ID,--34  NUMBER(10),
																	BLI_REVERSEBLINUMBERDEC,--35 NUMBER(4),
																	BLI_REVERSEDECDT    ,--35 
																	)
															values
																	(
																	New_Genbill.BIL_ID	,--1
																	null				,--2
																	v					,--3
																	null				,--4
																	wite_name			,--5
																	anneereel_			,--6
																	WITE_ID				,--7
																	WPTA_ID				,--8
																	WPSL_RANK			,--9
																	null				,--10
																	facture_.volon1		,--11
																	facture_.volon1		,--12
																	facture_.tauon1/1000,--13
																	WTVA_ID				,--14
																	facture_.mon1/1000  ,--15
																	0					,--16
																	facture_.mon1/1000	,--17
																	New_genrun.RUN_STARTDT,--18
																	V_FAC_DATECALCUL	  ,--19
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
																EXCEPTION WHEN OTHERS THEN
																	BEGIN
																	insert into genbilline
																		(
																			BIL_ID			    ,--1   
																			BLI_REVERSEBLI_ID	,--2   
																			BLI_NUMBER			,--3   
																			BLI_REVERSEBLINUMBER,--4 
																			BLI_NAME          	,--5   
																			BLI_EXERCICE		,--6   
																			ITE_ID				,--7   
																			PTA_ID				,--8  
																			PSL_RANK			,--9   
																			IMP_ID				,--10  
																			BLI_VOLUMEBASE		,--11  
																			BLI_VOLUMEFACT		,--12  
																			BLI_PUHT			,--13  
																			TVA_ID				,--14  
																			BLI_MHT				,--15  
																			BLI_MTTVA			,--16  
																			BLI_MTTC			,--17  
																			BLI_STARTDT			,--18  
																			BLI_ENDDT			,--19  
																			VOW_UNIT			,--20  
																			BLI_NBUNITES		,--21  
																			BLI_DETAIL			,--22  
																			BLI_CANCEL			,--23  
																			IMC_ID				,--24  
																			IMP_ANALYTIQUE_ID	,--25  
																			BLI_PERIODEINIT		,--26  
																			BLI_PERIODE			,--27  
																			BLI_REVERSEDT		,--28  
																			BLI_CREDT			,--29  
																			BLI_UPDTDT			,--30  
																			BLI_UPDTBY			,--31  
																			MEU_ID				,--32  
																			BLI_NAME_A			,--33  
																			BLI_REVERSEBLIDEC_ID,--34  
																			BLI_REVERSEBLINUMBERDEC,--35 
																			BLI_REVERSEDECDT    --36
																			)
																			values
																			(
																			New_Genbill.BIL_ID  ,--1
																			null				,--2
																			v+1					,--3
																			null				,--4
																			wite_name			,--5
																			anneereel_			,--6
																			WITE_ID				,--7
																			WPTA_ID				,--8
																			WPSL_RANK			,--9
																			null				,--10
																			facture_.volon1		,--11
																			facture_.volon1		,--12
																			facture_.tauon1/1000,--13
																			WTVA_ID				,--14
																			facture_.mon1/1000  ,--15
																			0					,--16
																			facture_.mon1/1000	,--17
																			New_genrun.RUN_STARTDT,--18
																			V_FAC_DATECALCUL		,--19
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
																	EXCEPTION WHEN OTHERS THEN NULL;
																	END;
											END;
		end if;
 
 -------------------------------------------------------------------------------------------
-----------------------------------REDEVANCE ONAS 2EME TRANCHE---------------------------------------
-------------------------------------------------------------------------------------------		

		if to_number(facture_.mon2) <> 0 then
		
				v := v+1;
							WPTA_ID := null;
							WPSL_RANK := null;
										begin
										select ITE_ID,ite_name,VOW_UNIT  
										INTO WITE_ID,wite_name,WVOW_UNIT  
										from genitem s 
										where s.ITE_CODE = 'VAR_ONAS_1';
										exception when no_data_found then null;
										end;
										begin
										select tva_id 
										into wtva_id 
										from gentva 
										where tva_taux= 0;
										exception when no_data_found then 
										wtva_id := 25;
										end;

										select count(*) 
										into nbr 
										from genptaslice 
										where PTA_ID in (select PTA_ID 	from genitemperiodtarif 
														 where TAR_id in ( select tar_id from genitemtarif where ITE_ID=WITE_ID )
														);
										if nbr=1 then
										
											select PTA_ID,PSL_RANK  
											into WPTA_ID,WPSL_RANK 
											from genptaslice 
											where PTA_ID in (select PTA_ID 
															 from genitemperiodtarif 
															 where TAR_id in (select tar_id from genitemtarif where ITE_ID=WITE_ID)
															)
											and rownum=1;
										
										end if;

										if nbr>1 then
											select PTA_ID,PSL_RANK  
											into WPTA_ID,WPSL_RANK 
											from genptaslice 
											where   PTA_ID
											in (select PTA_ID 
												from genitemperiodtarif
												where TAR_id in (select tar_id from genitemtarif where ITE_ID=WITE_Id) 
											   )and rownum=1;
										 
										end if;

										BEGIN
											insert into genbilline
																	(
																	BIL_ID			    ,--1   NUMBER(10) not null,
																	BLI_REVERSEBLI_ID	,--2   NUMBER(10),
																	BLI_NUMBER		    ,--3   NUMBER(4) not null,
																	BLI_REVERSEBLINUMBER,--4   NUMBER(4),
																	BLI_NAME            ,--5   VARCHAR2(200),
																	BLI_EXERCICE		,--6   NUMBER(4),
																	ITE_ID				,--7   NUMBER(10) not null,
																	PTA_ID				,-- 8  NUMBER(10) not null,
																	PSL_RANK			,--9   NUMBER(2),
																	IMP_ID				,--10  NUMBER(10),
																	BLI_VOLUMEBASE		,--11  NUMBER(17,10),
																	BLI_VOLUMEFACT		,--12  NUMBER(17,10),
																	BLI_PUHT			,--13  NUMBER(17,3),
																	TVA_ID				,--14  NUMBER(10) not null,
																	BLI_MHT				,--15  NUMBER(17,10),
																	BLI_MTTVA			,--16  NUMBER(17,10),
																	BLI_MTTC			,--17  NUMBER(17,10),
																	BLI_STARTDT			,--18  DATE,
																	BLI_ENDDT			,--19  DATE,
																	VOW_UNIT			,--20  NUMBER(10),
																	BLI_NBUNITES		,--21  NUMBER(10),
																	BLI_DETAIL			,--22  NUMBER(1) default 0 not null,
																	BLI_CANCEL			,--23  NUMBER(1) default 0 not null,
																	IMC_ID				,--24  NUMBER(10),
																	IMP_ANALYTIQUE_ID	,--25  NUMBER(10),
																	BLI_PERIODEINIT		,--26  VARCHAR2(20),
																	BLI_PERIODE			,--27  VARCHAR2(20),
																	BLI_REVERSEDT		,--28  DATE,
																	BLI_CREDT			,--29  DATE default sysdate,
																	BLI_UPDTDT			,--30  DATE,
																	BLI_UPDTBY			,--31  NUMBER(10),
																	MEU_ID				,--32  NUMBER(10),
																	BLI_NAME_A			,--33  VARCHAR2(200),
																	BLI_REVERSEBLIDEC_ID,--34  NUMBER(10),
																	BLI_REVERSEBLINUMBERDEC,--35 NUMBER(4),
																	BLI_REVERSEDECDT    ,--35 
																	)
															values
																	(
																	New_Genbill.BIL_ID  ,--1
																	null				,--2
																	v					,--3
																	null				,--4
																	wite_name			,--5
																	anneereel_		    ,--6
																	WITE_ID			    ,--7
																	WPTA_ID			    ,--8
																	WPSL_RANK			,--9
																	null				,--10
																	facture_.volon2		,--11
																	facture_.volon2		,--12
																	facture_.tauon2/1000,--13
																	WTVA_ID			    ,--14
																	facture_.mon2/1000  ,--15
																	0					,--16
																	facture_.mon2/1000	,--17
																	New_genrun.RUN_STARTDT,--18
																	V_FAC_DATECALCUL		,--19
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
																EXCEPTION WHEN OTHERS THEN
																	BEGIN
																	insert into genbilline
																		(
																			BIL_ID			    ,--1   
																			BLI_REVERSEBLI_ID	,--2   
																			BLI_NUMBER			,--3   
																			BLI_REVERSEBLINUMBER,--4 
																			BLI_NAME          	,--5   
																			BLI_EXERCICE		,--6   
																			ITE_ID				,--7   
																			PTA_ID				,--8  
																			PSL_RANK			,--9   
																			IMP_ID				,--10  
																			BLI_VOLUMEBASE		,--11  
																			BLI_VOLUMEFACT		,--12  
																			BLI_PUHT			,--13  
																			TVA_ID				,--14  
																			BLI_MHT				,--15  
																			BLI_MTTVA			,--16  
																			BLI_MTTC			,--17  
																			BLI_STARTDT			,--18  
																			BLI_ENDDT			,--19  
																			VOW_UNIT			,--20  
																			BLI_NBUNITES		,--21  
																			BLI_DETAIL			,--22  
																			BLI_CANCEL			,--23  
																			IMC_ID				,--24  
																			IMP_ANALYTIQUE_ID	,--25  
																			BLI_PERIODEINIT		,--26  
																			BLI_PERIODE			,--27  
																			BLI_REVERSEDT		,--28  
																			BLI_CREDT			,--29  
																			BLI_UPDTDT			,--30  
																			BLI_UPDTBY			,--31  
																			MEU_ID				,--32  
																			BLI_NAME_A			,--33  
																			BLI_REVERSEBLIDEC_ID,--34  
																			BLI_REVERSEBLINUMBERDEC,--35 
																			BLI_REVERSEDECDT    --36
																			)
																			values
																			(
																			New_Genbill.BIL_ID,--1
																			null				,--2
																			v+1					,--3
																			null				,--4
																			wite_name			,--5
																			anneereel_			,--6
																			WITE_ID				,--7
																			WPTA_ID				,--8
																			WPSL_RANK			,--9
																			null				,--10
																			facture_.volon2		,--11
																			facture_.volon2		,--12
																			facture_.tauon2/1000,--13
																			WTVA_ID			    ,--14
																			facture_.mon2/1000  ,--15
																			0					,--16
																			facture_.mon2/1000	,--17
																			New_genrun.RUN_STARTDT,--18
																			V_FAC_DATECALCUL	,--19
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
																	EXCEPTION WHEN OTHERS THEN NULL;
																	END;
											END;
		end if;
		
 -------------------------------------------------------------------------------------------
----------------------------------REDEVANCE ONAS 3EME TRANCHE--------------------------------------
-------------------------------------------------------------------------------------------		

		if to_number(facture_.mon3) <> 0 then
									v := v+1;
							WPTA_ID := null;
							WPSL_RANK := null;
										begin
										select ITE_ID,ite_name,VOW_UNIT  
										INTO WITE_ID,wite_name,WVOW_UNIT  
										from genitem s 
										where s.ITE_CODE = 'VAR_ONAS_1';
										exception when no_data_found then null;
										end;
										begin
										select tva_id 
										into wtva_id 
										from gentva 
										where tva_taux= 0;
										exception when no_data_found then 
										wtva_id := 25;
										end;

										select count(*) 
										into nbr 
										from genptaslice 
										where PTA_ID in (select PTA_ID 	from genitemperiodtarif 
														 where TAR_id in ( select tar_id from genitemtarif where ITE_ID=WITE_ID )
														);
										if nbr=1 then
										
											select PTA_ID,PSL_RANK  
											into WPTA_ID,WPSL_RANK 
											from genptaslice 
											where PTA_ID in (select PTA_ID 
															 from genitemperiodtarif 
															 where TAR_id in (select tar_id from genitemtarif where ITE_ID=WITE_ID)
															)
											and rownum=1;
										
										end if;

										if nbr>1 then
											select PTA_ID,PSL_RANK  
											into WPTA_ID,WPSL_RANK 
											from genptaslice 
											where   PTA_ID
											in (select PTA_ID 
												from genitemperiodtarif
												where TAR_id in (select tar_id from genitemtarif where ITE_ID=WITE_Id) 
											   )and rownum=1;
										 
										end if;

										BEGIN
											insert into genbilline
																	(
																	BIL_ID			    ,--1   NUMBER(10) not null,
																	BLI_REVERSEBLI_ID	,--2   NUMBER(10),
																	BLI_NUMBER		    ,--3   NUMBER(4) not null,
																	BLI_REVERSEBLINUMBER,--4   NUMBER(4),
																	BLI_NAME            ,--5   VARCHAR2(200),
																	BLI_EXERCICE		,--6   NUMBER(4),
																	ITE_ID				,--7   NUMBER(10) not null,
																	PTA_ID				,-- 8  NUMBER(10) not null,
																	PSL_RANK			,--9   NUMBER(2),
																	IMP_ID				,--10  NUMBER(10),
																	BLI_VOLUMEBASE		,--11  NUMBER(17,10),
																	BLI_VOLUMEFACT		,--12  NUMBER(17,10),
																	BLI_PUHT			,--13  NUMBER(17,3),
																	TVA_ID				,--14  NUMBER(10) not null,
																	BLI_MHT				,--15  NUMBER(17,10),
																	BLI_MTTVA			,--16  NUMBER(17,10),
																	BLI_MTTC			,--17  NUMBER(17,10),
																	BLI_STARTDT			,--18  DATE,
																	BLI_ENDDT			,--19  DATE,
																	VOW_UNIT			,--20  NUMBER(10),
																	BLI_NBUNITES		,--21  NUMBER(10),
																	BLI_DETAIL			,--22  NUMBER(1) default 0 not null,
																	BLI_CANCEL			,--23  NUMBER(1) default 0 not null,
																	IMC_ID				,--24  NUMBER(10),
																	IMP_ANALYTIQUE_ID	,--25  NUMBER(10),
																	BLI_PERIODEINIT		,--26  VARCHAR2(20),
																	BLI_PERIODE			,--27  VARCHAR2(20),
																	BLI_REVERSEDT		,--28  DATE,
																	BLI_CREDT			,--29  DATE default sysdate,
																	BLI_UPDTDT			,--30  DATE,
																	BLI_UPDTBY			,--31  NUMBER(10),
																	MEU_ID				,--32  NUMBER(10),
																	BLI_NAME_A			,--33  VARCHAR2(200),
																	BLI_REVERSEBLIDEC_ID,--34  NUMBER(10),
																	BLI_REVERSEBLINUMBERDEC,--35 NUMBER(4),
																	BLI_REVERSEDECDT    ,--35 
																	)
															values
																	(
																	New_Genbill.BIL_ID  ,--1
																	null				,--2
																	v					,--3
																	null				,--4
																	wite_name			,--5
																	anneereel_		    ,--6
																	WITE_ID			    ,--7
																	WPTA_ID			    ,--8
																	WPSL_RANK			,--9
																	null				,--10
																	facture_.volon3		,--11
																	facture_.volon3		,--12
																	facture_.tauon3/1000,--13
																	WTVA_ID			    ,--14
																	facture_.mon3/1000	,--15
																	0					,--16
																	facture_.mon3/1000	,--17
																	New_genrun.RUN_STARTDT,--18
																	V_FAC_DATECALCUL		,--19
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
																EXCEPTION WHEN OTHERS THEN
																	BEGIN
																	insert into genbilline
																		(
																			BIL_ID			    ,--1   
																			BLI_REVERSEBLI_ID	,--2   
																			BLI_NUMBER			,--3   
																			BLI_REVERSEBLINUMBER,--4 
																			BLI_NAME          	,--5   
																			BLI_EXERCICE		,--6   
																			ITE_ID				,--7   
																			PTA_ID				,--8  
																			PSL_RANK			,--9   
																			IMP_ID				,--10  
																			BLI_VOLUMEBASE		,--11  
																			BLI_VOLUMEFACT		,--12  
																			BLI_PUHT			,--13  
																			TVA_ID				,--14  
																			BLI_MHT				,--15  
																			BLI_MTTVA			,--16  
																			BLI_MTTC			,--17  
																			BLI_STARTDT			,--18  
																			BLI_ENDDT			,--19  
																			VOW_UNIT			,--20  
																			BLI_NBUNITES		,--21  
																			BLI_DETAIL			,--22  
																			BLI_CANCEL			,--23  
																			IMC_ID				,--24  
																			IMP_ANALYTIQUE_ID	,--25  
																			BLI_PERIODEINIT		,--26  
																			BLI_PERIODE			,--27  
																			BLI_REVERSEDT		,--28  
																			BLI_CREDT			,--29  
																			BLI_UPDTDT			,--30  
																			BLI_UPDTBY			,--31  
																			MEU_ID				,--32  
																			BLI_NAME_A			,--33  
																			BLI_REVERSEBLIDEC_ID,--34  
																			BLI_REVERSEBLINUMBERDEC,--35 
																			BLI_REVERSEDECDT    --36
																			)
																			values
																			(
																			New_Genbill.BIL_ID,--1
																			null				,--2
																			v+1					,--3
																			null				,--4
																			wite_name			,--5
																			anneereel_			,--6
																			WITE_ID				,--7
																			WPTA_ID				,--8
																			WPSL_RANK			,--9
																			null				,--10
																			facture_.volon3		,--11
																			facture_.volon3		,--12
																			facture_.tauon3/1000,--13
																			WTVA_ID			    ,--14
																			facture_.mon3/1000	,--15
																			0					,--16
																			facture_.mon3/1000	,--17
																			New_genrun.RUN_STARTDT,--18
																			V_FAC_DATECALCUL		,--19
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
																	EXCEPTION WHEN OTHERS THEN NULL;
																	END;
											END;
		end if;
				
				
-------------------------------------------------------------------------------------------
-----------------------------------FRAIS FIXE ONAS--------------------------------------
-------------------------------------------------------------------------------------------		

		if to_number(facture_.fixonas) <> 0 then
									v := v+1;
							WPTA_ID := null;
							WPSL_RANK := null;
										begin
										select ITE_ID,ite_name,VOW_UNIT  
										INTO WITE_ID,wite_name,WVOW_UNIT  
										from genitem s 
										where s.ITE_CODE = 'FIXE_ONAS_1';
										exception when no_data_found then null;
										end;
										begin
										select tva_id 
										into wtva_id 
										from gentva 
										where tva_taux= 0;
										exception when no_data_found then 
										wtva_id := 25;
										end;

										select count(*) 
										into nbr 
										from genptaslice 
										where PTA_ID in (select PTA_ID 	from genitemperiodtarif 
														 where TAR_id in ( select tar_id from genitemtarif where ITE_ID=WITE_ID )
														);
										if nbr=1 then
										
											select PTA_ID,PSL_RANK  
											into WPTA_ID,WPSL_RANK 
											from genptaslice 
											where PTA_ID in (select PTA_ID 
															 from genitemperiodtarif 
															 where TAR_id in (select tar_id from genitemtarif where ITE_ID=WITE_ID)
															)
											and rownum=1;
										
										end if;

										if nbr>1 then
											select PTA_ID,PSL_RANK  
											into WPTA_ID,WPSL_RANK 
											from genptaslice 
											where   PTA_ID
											in (select PTA_ID 
												from genitemperiodtarif
												where TAR_id in (select tar_id from genitemtarif where ITE_ID=WITE_Id) 
											   )and rownum=1;
										 
										end if;

										BEGIN
											insert into genbilline
																	(
																	BIL_ID			    ,--1   NUMBER(10) not null,
																	BLI_REVERSEBLI_ID	,--2   NUMBER(10),
																	BLI_NUMBER		    ,--3   NUMBER(4) not null,
																	BLI_REVERSEBLINUMBER,--4   NUMBER(4),
																	BLI_NAME            ,--5   VARCHAR2(200),
																	BLI_EXERCICE		,--6   NUMBER(4),
																	ITE_ID				,--7   NUMBER(10) not null,
																	PTA_ID				,-- 8  NUMBER(10) not null,
																	PSL_RANK			,--9   NUMBER(2),
																	IMP_ID				,--10  NUMBER(10),
																	BLI_VOLUMEBASE		,--11  NUMBER(17,10),
																	BLI_VOLUMEFACT		,--12  NUMBER(17,10),
																	BLI_PUHT			,--13  NUMBER(17,3),
																	TVA_ID				,--14  NUMBER(10) not null,
																	BLI_MHT				,--15  NUMBER(17,10),
																	BLI_MTTVA			,--16  NUMBER(17,10),
																	BLI_MTTC			,--17  NUMBER(17,10),
																	BLI_STARTDT			,--18  DATE,
																	BLI_ENDDT			,--19  DATE,
																	VOW_UNIT			,--20  NUMBER(10),
																	BLI_NBUNITES		,--21  NUMBER(10),
																	BLI_DETAIL			,--22  NUMBER(1) default 0 not null,
																	BLI_CANCEL			,--23  NUMBER(1) default 0 not null,
																	IMC_ID				,--24  NUMBER(10),
																	IMP_ANALYTIQUE_ID	,--25  NUMBER(10),
																	BLI_PERIODEINIT		,--26  VARCHAR2(20),
																	BLI_PERIODE			,--27  VARCHAR2(20),
																	BLI_REVERSEDT		,--28  DATE,
																	BLI_CREDT			,--29  DATE default sysdate,
																	BLI_UPDTDT			,--30  DATE,
																	BLI_UPDTBY			,--31  NUMBER(10),
																	MEU_ID				,--32  NUMBER(10),
																	BLI_NAME_A			,--33  VARCHAR2(200),
																	BLI_REVERSEBLIDEC_ID,--34  NUMBER(10),
																	BLI_REVERSEBLINUMBERDEC,--35 NUMBER(4),
																	BLI_REVERSEDECDT    ,--35 
																	)
															values
																	(
																	New_Genbill.BIL_ID  ,--1
																	null				,--2
																	v					,--3
																	null				,--4
																	wite_name			,--5
																	anneereel_		    ,--6
																	WITE_ID			    ,--7
																	WPTA_ID			    ,--8
																	WPSL_RANK			,--9
																	null				,--10
																	1					,--11
																	1					,--12
																	facture_.fixonas/1000,--13
																	WTVA_ID			     ,--14
																	facture_.fixonas/1000,--15
																	0					 ,--16
																	facture_.fixonas/1000,--17
																	New_genrun.RUN_STARTDT,--18
																	V_FAC_DATECALCUL		,--19
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
																EXCEPTION WHEN OTHERS THEN
																	BEGIN
																	insert into genbilline
																		(
																			BIL_ID			    ,--1   
																			BLI_REVERSEBLI_ID	,--2   
																			BLI_NUMBER			,--3   
																			BLI_REVERSEBLINUMBER,--4 
																			BLI_NAME          	,--5   
																			BLI_EXERCICE		,--6   
																			ITE_ID				,--7   
																			PTA_ID				,--8  
																			PSL_RANK			,--9   
																			IMP_ID				,--10  
																			BLI_VOLUMEBASE		,--11  
																			BLI_VOLUMEFACT		,--12  
																			BLI_PUHT			,--13  
																			TVA_ID				,--14  
																			BLI_MHT				,--15  
																			BLI_MTTVA			,--16  
																			BLI_MTTC			,--17  
																			BLI_STARTDT			,--18  
																			BLI_ENDDT			,--19  
																			VOW_UNIT			,--20  
																			BLI_NBUNITES		,--21  
																			BLI_DETAIL			,--22  
																			BLI_CANCEL			,--23  
																			IMC_ID				,--24  
																			IMP_ANALYTIQUE_ID	,--25  
																			BLI_PERIODEINIT		,--26  
																			BLI_PERIODE			,--27  
																			BLI_REVERSEDT		,--28  
																			BLI_CREDT			,--29  
																			BLI_UPDTDT			,--30  
																			BLI_UPDTBY			,--31  
																			MEU_ID				,--32  
																			BLI_NAME_A			,--33  
																			BLI_REVERSEBLIDEC_ID,--34  
																			BLI_REVERSEBLINUMBERDEC,--35 
																			BLI_REVERSEDECDT    --36
																			)
																			values
																			(
																			New_Genbill.BIL_ID,--1
																			null				,--2
																			v+1					,--3
																			null				,--4
																			wite_name			,--5
																			anneereel_			,--6
																			WITE_ID				,--7
																			WPTA_ID				,--8
																			WPSL_RANK			,--9
																			null				,--10
																			1					,--11
																			1					,--12
																			facture_.fixonas/1000,--13
																			WTVA_ID			     ,--14
																			facture_.fixonas/1000,--15
																			0					 ,--16
																			facture_.fixonas/1000,--17
																			New_genrun.RUN_STARTDT,--18
																			V_FAC_DATECALCUL		,--19
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
																	EXCEPTION WHEN OTHERS THEN NULL;
																	END;
											END;
		end if;		
		
		
-------------------------------------------------------------------------------------------
-----------------------------------FRAIS FIXE SONEDE--------------------------------------
-------------------------------------------------------------------------------------------		

		if to_number(facture_.fraisctr) <> 0 then
									v := v+1;
							WPTA_ID := null;
							WPSL_RANK := null;
										begin
										select ITE_ID,ite_name,VOW_UNIT  
										INTO WITE_ID,wite_name,WVOW_UNIT  
										from genitem s 
										where s.ITE_CODE = 'FRS_FIX_CSM';
										exception when no_data_found then null;
										end;
										begin
										select tva_id 
										into   wtva_id 
										from gentva 
										where tva_taux= 18;
										exception when no_data_found then 
										wtva_id := 25;
										end;

										select count(*) 
										into nbr 
										from genptaslice 
										where PTA_ID in (select PTA_ID 	from genitemperiodtarif 
														 where TAR_id in ( select tar_id from genitemtarif where ITE_ID=WITE_ID )
														);
										if nbr=1 then
										
											select PTA_ID,PSL_RANK  
											into WPTA_ID,WPSL_RANK 
											from genptaslice 
											where PTA_ID in (select PTA_ID 
															 from genitemperiodtarif 
															 where TAR_id in (select tar_id from genitemtarif where ITE_ID=WITE_ID)
															)
											and rownum=1;
										
										end if;

										if nbr>1 then
											select PTA_ID,PSL_RANK  
											into WPTA_ID,WPSL_RANK 
											from genptaslice 
											where PTA_ID
											in (select PTA_ID 
												from genitemperiodtarif
												where TAR_id in (select tar_id from genitemtarif where ITE_ID=WITE_Id) 
											   )
											   and rownum=1;
										 
										end if;

										BEGIN
											insert into genbilline
																(
																	BIL_ID			    ,--1   NUMBER(10) not null,
																	BLI_REVERSEBLI_ID	,--2   NUMBER(10),
																	BLI_NUMBER		    ,--3   NUMBER(4) not null,
																	BLI_REVERSEBLINUMBER,--4   NUMBER(4),
																	BLI_NAME            ,--5   VARCHAR2(200),
																	BLI_EXERCICE		,--6   NUMBER(4),
																	ITE_ID				,--7   NUMBER(10) not null,
																	PTA_ID				,-- 8  NUMBER(10) not null,
																	PSL_RANK			,--9   NUMBER(2),
																	IMP_ID				,--10  NUMBER(10),
																	BLI_VOLUMEBASE		,--11  NUMBER(17,10),
																	BLI_VOLUMEFACT		,--12  NUMBER(17,10),
																	BLI_PUHT			,--13  NUMBER(17,3),
																	TVA_ID				,--14  NUMBER(10) not null,
																	BLI_MHT				,--15  NUMBER(17,10),
																	BLI_MTTVA			,--16  NUMBER(17,10),
																	BLI_MTTC			,--17  NUMBER(17,10),
																	BLI_STARTDT			,--18  DATE,
																	BLI_ENDDT			,--19  DATE,
																	VOW_UNIT			,--20  NUMBER(10),
																	BLI_NBUNITES		,--21  NUMBER(10),
																	BLI_DETAIL			,--22  NUMBER(1) default 0 not null,
																	BLI_CANCEL			,--23  NUMBER(1) default 0 not null,
																	IMC_ID				,--24  NUMBER(10),
																	IMP_ANALYTIQUE_ID	,--25  NUMBER(10),
																	BLI_PERIODEINIT		,--26  VARCHAR2(20),
																	BLI_PERIODE			,--27  VARCHAR2(20),
																	BLI_REVERSEDT		,--28  DATE,
																	BLI_CREDT			,--29  DATE default sysdate,
																	BLI_UPDTDT			,--30  DATE,
																	BLI_UPDTBY			,--31  NUMBER(10),
																	MEU_ID				,--32  NUMBER(10),
																	BLI_NAME_A			,--33  VARCHAR2(200),
																	BLI_REVERSEBLIDEC_ID,--34  NUMBER(10),
																	BLI_REVERSEBLINUMBERDEC,--35 NUMBER(4),
																	BLI_REVERSEDECDT    ,--35 
																)
															values
																(
																	New_Genbill.BIL_ID  ,--1
																	null				,--2
																	v					,--3
																	null				,--4
																	wite_name			,--5
																	anneereel_		    ,--6
																	WITE_ID			    ,--7
																	WPTA_ID			    ,--8
																	WPSL_RANK			,--9
																	null				,--10
																	1					,--11
																	1					,--12
																	facture_.fraisctr/1000,--13
																	WTVA_ID			    ,--14
																	facture_.fraisctr/1000,--15
																	facture_.tva_ff/1000,--16
																	(facture_.fraisctr/1000)+(facture_.TVA_ff/1000),--17
																	New_genrun.RUN_STARTDT,--18
																	V_FAC_DATECALCUL		,--19
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
																EXCEPTION WHEN OTHERS THEN
																	BEGIN
																	insert into genbilline
																		(
																			BIL_ID			    ,--1   
																			BLI_REVERSEBLI_ID	,--2   
																			BLI_NUMBER			,--3   
																			BLI_REVERSEBLINUMBER,--4 
																			BLI_NAME          	,--5   
																			BLI_EXERCICE		,--6   
																			ITE_ID				,--7   
																			PTA_ID				,--8  
																			PSL_RANK			,--9   
																			IMP_ID				,--10  
																			BLI_VOLUMEBASE		,--11  
																			BLI_VOLUMEFACT		,--12  
																			BLI_PUHT			,--13  
																			TVA_ID				,--14  
																			BLI_MHT				,--15  
																			BLI_MTTVA			,--16  
																			BLI_MTTC			,--17  
																			BLI_STARTDT			,--18  
																			BLI_ENDDT			,--19  
																			VOW_UNIT			,--20  
																			BLI_NBUNITES		,--21  
																			BLI_DETAIL			,--22  
																			BLI_CANCEL			,--23  
																			IMC_ID				,--24  
																			IMP_ANALYTIQUE_ID	,--25  
																			BLI_PERIODEINIT		,--26  
																			BLI_PERIODE			,--27  
																			BLI_REVERSEDT		,--28  
																			BLI_CREDT			,--29  
																			BLI_UPDTDT			,--30  
																			BLI_UPDTBY			,--31  
																			MEU_ID				,--32  
																			BLI_NAME_A			,--33  
																			BLI_REVERSEBLIDEC_ID,--34  
																			BLI_REVERSEBLINUMBERDEC,--35 
																			BLI_REVERSEDECDT    --36
																			)
																			values
																			(
																			New_Genbill.BIL_ID,--1
																			null				,--2
																			v+1					,--3
																			null				,--4
																			wite_name			,--5
																			anneereel_			,--6
																			WITE_ID				,--7
																			WPTA_ID				,--8
																			WPSL_RANK			,--9
																			null				,--10
																			1					,--11
																			1					,--12
																			facture_.fraisctr/1000,--13
																			WTVA_ID			    ,--14
																			facture_.fraisctr/1000,--15
																			facture_.tva_ff/1000,--16
																			(facture_.fraisctr/1000)+(facture_.TVA_ff/1000),--17
																			New_genrun.RUN_STARTDT,--18
																			V_FAC_DATECALCUL	,--19
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
																	EXCEPTION WHEN OTHERS THEN NULL;
																	END;
											END;
		end if;
		
-------------------------------------------------------------------------------------------
--------------------------------Montant capital---------------------------------------
-------------------------------------------------------------------------------------------		

		if to_number(facture_.CAPIT) <> 0 then
									v := v+1;
							WPTA_ID := null;
							WPSL_RANK := null;
										begin
										select ITE_ID,ite_name,VOW_UNIT  
										INTO WITE_ID,wite_name,WVOW_UNIT  
										from genitem s 
										where s.ITE_CODE = 'CAPITAL';
										exception when no_data_found then null;
										end;
										begin
										select tva_id 
										into wtva_id 
										from gentva 
										where tva_taux= 0;
										exception when no_data_found then 
										wtva_id := 25;
										end;

										select count(*) 
										into nbr 
										from genptaslice 
										where PTA_ID in (select PTA_ID 	from genitemperiodtarif 
														 where TAR_id in ( select tar_id from genitemtarif where ITE_ID=WITE_ID )
														);
										if nbr=1 then
										
											select PTA_ID,PSL_RANK  
											into WPTA_ID,WPSL_RANK 
											from genptaslice 
											where PTA_ID in (select PTA_ID 
															 from genitemperiodtarif 
															 where TAR_id in (select tar_id from genitemtarif where ITE_ID=WITE_ID)
															)
											and rownum=1;
										
										end if;

										if nbr>1 then
											select PTA_ID,PSL_RANK  
											into WPTA_ID,WPSL_RANK 
											from genptaslice 
											where   PTA_ID
											in (select PTA_ID 
												from genitemperiodtarif
												where TAR_id in (select tar_id from genitemtarif where ITE_ID=WITE_Id) 
											   )and rownum=1;
										 
										end if;

										BEGIN
											insert into genbilline
																	(
																	BIL_ID			    ,--1   NUMBER(10) not null,
																	BLI_REVERSEBLI_ID	,--2   NUMBER(10),
																	BLI_NUMBER		    ,--3   NUMBER(4) not null,
																	BLI_REVERSEBLINUMBER,--4   NUMBER(4),
																	BLI_NAME            ,--5   VARCHAR2(200),
																	BLI_EXERCICE		,--6   NUMBER(4),
																	ITE_ID				,--7   NUMBER(10) not null,
																	PTA_ID				,-- 8  NUMBER(10) not null,
																	PSL_RANK			,--9   NUMBER(2),
																	IMP_ID				,--10  NUMBER(10),
																	BLI_VOLUMEBASE		,--11  NUMBER(17,10),
																	BLI_VOLUMEFACT		,--12  NUMBER(17,10),
																	BLI_PUHT			,--13  NUMBER(17,3),
																	TVA_ID				,--14  NUMBER(10) not null,
																	BLI_MHT				,--15  NUMBER(17,10),
																	BLI_MTTVA			,--16  NUMBER(17,10),
																	BLI_MTTC			,--17  NUMBER(17,10),
																	BLI_STARTDT			,--18  DATE,
																	BLI_ENDDT			,--19  DATE,
																	VOW_UNIT			,--20  NUMBER(10),
																	BLI_NBUNITES		,--21  NUMBER(10),
																	BLI_DETAIL			,--22  NUMBER(1) default 0 not null,
																	BLI_CANCEL			,--23  NUMBER(1) default 0 not null,
																	IMC_ID				,--24  NUMBER(10),
																	IMP_ANALYTIQUE_ID	,--25  NUMBER(10),
																	BLI_PERIODEINIT		,--26  VARCHAR2(20),
																	BLI_PERIODE			,--27  VARCHAR2(20),
																	BLI_REVERSEDT		,--28  DATE,
																	BLI_CREDT			,--29  DATE default sysdate,
																	BLI_UPDTDT			,--30  DATE,
																	BLI_UPDTBY			,--31  NUMBER(10),
																	MEU_ID				,--32  NUMBER(10),
																	BLI_NAME_A			,--33  VARCHAR2(200),
																	BLI_REVERSEBLIDEC_ID,--34  NUMBER(10),
																	BLI_REVERSEBLINUMBERDEC,--35 NUMBER(4),
																	BLI_REVERSEDECDT    ,--35 
																	)
															values
																	(
																	New_Genbill.BIL_ID  ,--1
																	null				,--2
																	v					,--3
																	null				,--4
																	wite_name			,--5
																	anneereel_		    ,--6
																	WITE_ID			    ,--7
																	WPTA_ID			    ,--8
																	WPSL_RANK			,--9
																	null				,--10
																	1					,--11
																	1					,--12
																	facture_.CAPIT/1000	,--13
																	WTVA_ID			    ,--14
																	facture_.CAPIT/1000	,--15
																	facture_.tva_capit/1000,--16
																	facture_.CAPIT/1000	,--17
																	New_genrun.RUN_STARTDT,--18
																	V_FAC_DATECALCUL	,--19
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
																EXCEPTION WHEN OTHERS THEN
																	BEGIN
																	insert into genbilline
																		(
																			BIL_ID			    ,--1   
																			BLI_REVERSEBLI_ID	,--2   
																			BLI_NUMBER			,--3   
																			BLI_REVERSEBLINUMBER,--4 
																			BLI_NAME          	,--5   
																			BLI_EXERCICE		,--6   
																			ITE_ID				,--7   
																			PTA_ID				,--8  
																			PSL_RANK			,--9   
																			IMP_ID				,--10  
																			BLI_VOLUMEBASE		,--11  
																			BLI_VOLUMEFACT		,--12  
																			BLI_PUHT			,--13  
																			TVA_ID				,--14  
																			BLI_MHT				,--15  
																			BLI_MTTVA			,--16  
																			BLI_MTTC			,--17  
																			BLI_STARTDT			,--18  
																			BLI_ENDDT			,--19  
																			VOW_UNIT			,--20  
																			BLI_NBUNITES		,--21  
																			BLI_DETAIL			,--22  
																			BLI_CANCEL			,--23  
																			IMC_ID				,--24  
																			IMP_ANALYTIQUE_ID	,--25  
																			BLI_PERIODEINIT		,--26  
																			BLI_PERIODE			,--27  
																			BLI_REVERSEDT		,--28  
																			BLI_CREDT			,--29  
																			BLI_UPDTDT			,--30  
																			BLI_UPDTBY			,--31  
																			MEU_ID				,--32  
																			BLI_NAME_A			,--33  
																			BLI_REVERSEBLIDEC_ID,--34  
																			BLI_REVERSEBLINUMBERDEC,--35 
																			BLI_REVERSEDECDT    --36
																			)
																			values
																			(
																			New_Genbill.BIL_ID,--1
																			null				,--2
																			v+1					,--3
																			null				,--4
																			wite_name			,--5
																			anneereel_			,--6
																			WITE_ID				,--7
																			WPTA_ID				,--8
																			WPSL_RANK			,--9
																			null				,--10
																			1					,--11
																			1					,--12
																			facture_.CAPIT/1000	,--13
																			WTVA_ID			    ,--14
																			facture_.CAPIT/1000	,--15
																			facture_.tva_capit/1000,--16
																			facture_.CAPIT/1000	,--17
																			New_genrun.RUN_STARTDT,--18
																			V_FAC_DATECALCUL		,--19
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
																	EXCEPTION WHEN OTHERS THEN NULL;
																	END;
											END;
		end if;
		
		
		
		end loop;
	end loop;	
	 
	 
END;
/