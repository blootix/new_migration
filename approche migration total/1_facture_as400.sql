declare 
cursor branch_(district_ varchar2, tourne_ varchar2, ordre_ varchar2) is 
    select  b.*
    from branchement b
    where  lpad(trim(b.district),2,'0')=district_
	 and lpad(trim(b.tourne),3,'0') = tourne_
     and lpad(trim(b.ordre),3,'0') = ordre_;
	 
cursor C_ITEM(V_Icode varchar2) is select ITE_ID,ite_name,VOW_UNIT  
									from genitem s 
									where s.ITE_CODE=V_Icode;
					
cursor C_TVA(v_taux number) is select tva_id 
							from gentva 
							where tva_taux=v_taux;
	 
cursor fact_as400 is select * from facture_as400;

cursor fact_as400gc is select * from facture_as400gc;
cursor fact_Dist is select * from facture f where  f.annee='2015';
cursor fact_vers is select distinct b.BIL_CODE,b.BIL_CALCDT,f.*,d.*
					from facture f, genbill b,gendebt d
					where f.etat in ('A','P')
					and b.BIL_CODE = (trim(f.DISTRICT)||lpad(trim(f.tournee),3,'0')||
					lpad(trim(f.ORDRE),3,'0')||to_char(f.annee)||lpad(trim(f.periode),2,'0')||'0')
					and b.bil_id=d.bil_id;

                        

	MEU_ID     		  Number ;
    Debt_Id           Number ;
    Genbill_Id        Number ;
    Agrbill_Id        Number ;
    genimp_id         Number ;
    genaccount_id     Number ;
    agrsagaco_id      Number ;
    genrun_id         Number ;
	V_ORG_ID		  Number ;
	v_PAR_ID          Number ;
	V_ADR_ID          Number ;
	V_SAG_ID          Number ;
	v                 Number ;
	v_nbr             Number ;
	V_ID_FACTURE      varchar2(50);
	V_pdl_ref         varchar2(50);
	V_REF_ABN         varchar2(50);
	v_code			  varchar2(50);
	V_COMPTEAUX		  varchar2(10);
	V_TOTHTE          NUMBER(25,10);
    V_TVA             NUMBER(25,10);
    V_TOTHTA          NUMBER(25,10);
    V_TOTTVAA         NUMBER(25,10);
	V_SOLDE           NUMBER(25,10);
	v_anneereel       varchar2(4);
	V_periode         Number ;
	V_tiers           varchar2(1);
    V_six             varchar2(1);
	V_TRAIN_FACT      varchar2(200);
	v_version         NUMBER(1):=0;
	V_FAC_DATECALCUL  date;
	V_FAC_DATELIM     date;
	V_date_           date;
	V_ABN_DT_DEB      date;
	V_ITE_ID    	  Number ;
	V_ite_name  	  varchar2(100);
	V_tva_id          Number ;
	V_VOW_UNIT        Number ;
	V_PTA_ID          Number ;
	V_PSL_RANK        Number ;
	nbr        		  Number ;
	v_bil_bil_id   	  Number ;
	v_bil_cancel_id   Number ;
	
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
    genimp_id         Number ;
    genimp_ref        Number ;

    New_genaccount    genaccount%rowtype ;
    genaccount_id     Number ;
    genaccount_ref    Number ;

    New_agrsagaco     agrsagaco%rowtype ;
    agrsagaco_id      Number ;
    agrsagaco_ref     Number ;

    New_genrun        genrun%rowtype ;
    genrun_id         Number ;
    genrun_ref        Number ;
	 
------------------------------PROC GENRUN------------------------------------------	 
Procedure Genere_genrun (Newgenrun genrun%rowtype ,genrunId  in out   number ,ref_genrun out number) is
    V_RUN_NUMBER Number ;
BEGIN
      SELECT run_id INTO ref_genrun from genrun where RUN_NAME = Newgenrun.RUN_NAME;
Exception  WHEN NO_DATA_FOUND THEN
    select nvl(max(RUN_NUMBER),0)+1 into V_RUN_NUMBER from genrun where run_exercice = Newgenrun.run_exercice;
	insert into genrun (run_id,run_exercice,run_number,org_id,run_startdt,run_comment,RUN_NAME,RUN_DTCALC,RUN_ENDDT)
                values (genrunId,Newgenrun.run_exercice,V_RUN_NUMBER,Newgenrun.org_id,Newgenrun.run_startdt,Newgenrun.run_comment,Newgenrun.RUN_NAME,Newgenrun.run_startdt,Newgenrun.run_startdt);
      ref_genrun := genrunId;
end Genere_genrun;
------------------------------PROC GENACCOUNT------------------------------------------	
Procedure Genere_genaccount (Newgenaccount genaccount%rowtype ,genaccountId  in out number ,ref_genaccount out number,agrsagacoId  in out   number,Newagrsagaco agrsagaco%rowtype) is
BEGIN
select aco.aco_id INTO ref_genaccount from genaccount aco,agrsagaco sco
where aco.aco_id = sco.aco_id
and nvl(par_id,0)        = nvl(Newgenaccount.par_id ,0)
and nvl(imp_id,0)        = nvl(Newgenaccount.imp_id ,0)
and nvl(sag_id,0)        = nvl(Newagrsagaco.sag_id ,0) ;
Exception  WHEN NO_DATA_FOUND THEN
        ref_genaccount := genaccountId;
    insert into genaccount(aco_id,par_id,imp_id,vow_acotp,rec_id)
					  values(genaccountId,Newgenaccount.par_id,Newgenaccount.imp_id,Newgenaccount.vow_acotp,Newgenaccount.rec_id);
      New_agrsagaco.ACO_ID  :=  genaccountId ;
    insert into agrsagaco (sco_id,sag_id,aco_id,sco_startdt)
                values (agrsagacoId,Newagrsagaco.sag_id,Newagrsagaco.aco_id,Newagrsagaco.sco_startdt);

end Genere_genaccount;
------------------------------PROC GENIMP------------------------------------------	
Procedure Genere_genimp (Newgenimp genimp%rowtype ,genimpId  in out   number ,ref_genimp out number) is
BEGIN
      SELECT  imp_id 
	  INTO  ref_genimp
      from    genimp
      where   nvl(imp_code,'*') = nvl(Newgenimp.imp_code ,'*')
      and     nvl(ORG_ID,0)  = nvl(Newgenimp.ORG_ID ,0) ;
EXCEPTION WHEN NO_DATA_FOUND THEN
        ref_genimp := genimpId;
    insert into genimp (imp_id,imp_code,imp_name,vow_budgtp,org_id)
                values(genimpId,Newgenimp.imp_code,Newgenimp.imp_name,Newgenimp.vow_budgtp,Newgenimp.org_id);

end Genere_genimp;
    
begin

	FOR facture_ in fact_as400 LOOP
	
	    FOR x in branch_(lpad(facture_.DIST, 2, '0'),lpad(trim(facture_.TOU), 3, '0'),lpad(trim(facture_.ORD), 3, '0'))LOOP	
			
			select seq_genrun.nextval     into genrun_id     from dual;
			select seq_agrbill.nextval    into Agrbill_Id    from dual;
			select seq_gendebt.nextval    into Debt_Id       from dual;
			select seq_genimp.nextval     into genimp_id     from dual;
			select seq_agrsagaco.nextval  into agrsagaco_id  from dual;
			select seq_genaccount.nextval into genaccount_id from dual;
			
			if(to_number(facture_.refc01)<to_number(facture_.refc03))then
				V_anneereel := '20'||facture_.refc04;
			else
				V_anneereel := '20'||to_char((to_number(facture_.refc04)-1));
			end if;
			begin
				select TRIM,tier,six
				into V_periode,V_tiers,V_six
				from param_tournee p
				where p.DISTRICT=facture_.dist
				And p.m1 =facture_.refc01
				And p.m2 = facture_.refc02
				And p.m3 = facture_.refc03
				And (p.TIER,p.SIX) in (select t.NTIERS,t.NSIXIEME from tourne t
										where trim(t.code)=lpad(facture_.tou,3,'0')
										and trim(t.district)=trim(p.DISTRICT)
										and trim(t.district)=facture_.dist
										);
			exception
			when others then
			V_periode := 1;
			end;
			
			V_ID_FACTURE:=lpad(trim(facture_.DIST),2,'0')||lpad(trim(facture_.tou),3,'0')||lpad(trim(facture_.ORD),3,'0')||to_char(V_anneereel)||lpad(to_char(V_periode),2,'0')||to_char(v_version);
						  
			V_pdl_ref := lpad(facture_.dist,2,'0')||lpad(facture_.tou,3,'0')||lpad(facture_.ord,3,'0')||lpad(facture_.pol,5,'0');			  
						  
			select count(*) into v_nbr from genbill b where b.BIL_CODE=V_ID_FACTURE;
			
			if v_nbr=0 then 
			 
			    V_FAC_DATECALCUL :=null;
				V_FAC_DATELIM    :=null;
				V_TRAIN_FACT     :=null;
				V_AMOUNTTTCDEC   :=null;
			    select g.org_id	
				into V_ORG_ID 
				from GENORGANIZATION g 
				where upper(g.org_code)=lpad(trim(facture_.dist),2,'0');
				
				select cag.par_id  
				into v_PAR_ID
				from AGRCUSTOMERAGR cag
				where cag.cag_id in (select sag.cag_id
									 from TECSERVICEPOINT spt,
									      AGRSERVICEAGR sag
									 where spt.spt_id=sag.spt_id
									 and spt.spt_refe=V_pdl_ref
									);
				select par.adr_id
				into   V_ADR_ID
				from   GENPARTY  par
				where par.par_id=v_PAR_ID;		

				select sag.sag_id ,sag.sag_startdt
				into V_SAG_ID,V_ABN_DT_DEB
				from AGRSERVICEAGR sag,
					 TECSERVICEPOINT spt
				where sag.spt_id=spt.spt_id 
				and spt.spt_refe=V_pdl_ref;				
				
				V_TRAIN_FACT :='ANNEE:'||trim(V_anneereel)||' TRIM:'||trim(V_periode)||' TIER:'||trim(V_tiers)||' SIX:'||trim(V_six );
				
				V_REF_ABN :=lpad(trim(facture_.DIST),2,'0')||lpad(to_char(facture_.pol),5,'0')||lpad(trim(facture_.tou),3,'0')||lpad(trim(facture_.ORD),3,'0');			   
				V_COMPTEAUX:='IMP_MIG'			   
				V_TOTHTE:=(facture_.net-(V_TVA+facture_.arriere))/1000;
				V_TVA:=(facture_.tva_ff+facture_.tva_capit+facture_.tva_pfin+facture_.tvacons+facture_.tva_preav+ facture_.tvaferm+facture_.tvadeplac+facture_.tvadepose_dem+facture_.tvadepose_def)/1000;
				V_TOTHTA:=0;
				V_TOTTVAA:=0;
				V_SOLDE:=(facture_.net-facture_.arriere)/1000;
				
				select last_day(to_date('01'||lpad(facture_.refc03,2,'0')||facture_.refc04,'ddmmyy')) 
                into V_date_
                from dual;
				
				BEGIN
					select to_date(lpad(trim(DATEXP),8,'0'),'ddmmyyyy'),
					to_date(lpad(trim(DATL),8,'0'),'ddmmyyyy')   
					into V_FAC_DATECALCUL,V_FAC_DATELIM
					from ROLE_TRIM
					where trim(facture_.Dist)= DISTR
					and to_number(facture_.pol)=POLICE
					and to_number(facture_.tou )=TOUR
					and to_number(facture_.ord)=ORDR
					and to_number(V_tiers)= tier
					and to_number(V_periode)=trim
					and to_number(V_six)= six
					and annee = V_anneereel
					and rownum = 1;
				EXCEPTION WHEN OTHERS THEN
						V_FAC_DATECALCUL := V_date_;
						V_FAC_DATELIM    := '01/01/2016';
				    BEGIN 
					EXCEPTION WHEN OTHERS THEN
						V_FAC_DATECALCUL := '01/01/2016';
						V_FAC_DATELIM    := '01/01/2016';
					END;
				END;
			      New_Det     := null;
				  New_Genbill := null;
				  New_genrun  := null;
			    --------------------------------------------------------Traitement Role
				If (V_anneereel is not null and V_periode is not null and V_TRAIN_FACT is not null) then			
					New_genrun.RUN_EXERCICE   :=  V_anneereel;
					New_genrun.RUN_NUMBER     :=  V_periode ;
					New_genrun.ORG_ID         :=  V_ORG_ID;			
					New_genrun.RUN_STARTDT    :=  V_FAC_DATECALCUL;
					New_genrun.RUN_COMMENT    := 'Role migré' ;
					New_genrun.RUN_NAME       :=  'Role '||V_TRAIN_FACT;
				Genere_genrun(New_genrun,genrun_id,genrun_ref);
				end if ; 			
				--------------------------------------------------------Traitement Det
				New_Det.DEB_ID           :=  Debt_Id ;
				New_Det.DEB_REFE         :=  V_ID_FACTURE;
				New_Det.ORG_ID           :=  V_ORG_ID;
				New_Det.PAR_ID           :=  V_PAR_ID;
				New_Det.ADR_ID           :=  V_ADR_ID;
				New_Det.DEB_DATE         :=  V_FAC_DATECALCUL;
				New_Det.DEB_DUEDT        :=  V_FAC_DATELIM;
				New_Det.DEB_PRINTDT      :=  V_FAC_DATECALCUL;
				New_Det.SAG_ID           :=  V_SAG_ID;
				New_Det.DEB_PREL         :=  1;
				
				If (V_TOTHTE+V_TVA+V_TOTHTA+V_TOTTVAA) > 0 then
					New_Det.DEB_AMOUNTINIT   :=  V_TOTHTE+V_TVA+V_TOTHTA+V_TOTTVAA;
					New_Det.VOW_DEBTYPE      :=  pk_genvocword.getidbycode('VOW_DEBTYPE','FA',null) ;
				else
					New_Det.deb_amount_cash  :=  -(V_TOTHTE+V_TVA+V_TOTHTA+V_TOTTVAA);
					New_Det.DEB_AMOUNTINIT   := 0;
					New_Det.VOW_DEBTYPE      := pk_genvocword.getidbycode('VOW_DEBTYPE','AV',null) ;
				end if ;
				New_Det.DEB_AMOUNTREMAIN :=  V_SOLDE ;
				New_Det.DEB_COMMENT      :=  V_REF_ABN;
				New_Det.VOW_SETTLEMODE   := pk_genvocword.getidbycode('VOW_SETTLEMODE',4,null) ;
				
				--------------------------------------------------------Traitement GENACCOUNT ,GENIMP
				New_genimp.imp_code      :=  V_COMPTEAUX ;
				New_genimp.imp_name      :=  V_COMPTEAUX ;
				New_genimp.vow_budgtp    :=  pk_genvocword.getidbycode('VOW_BUDGTP','EA',null);
				Genere_genimp (New_genimp ,genimp_id,genimp_ref);
				New_genaccount.PAR_ID    :=  V_PAR_ID ;
				New_genaccount.IMP_ID    :=  genimp_ref ;
				New_genaccount.VOW_ACOTP :=  pk_genvocword.getidbycode('VOW_ACOTP','1',null);
				New_genaccount.REC_ID    :=  null;
				New_agrsagaco.SAG_ID     :=  V_SAG_ID ;
				New_agrsagaco.SCO_STARTDT:=  V_ABN_DT_DEB ;
				Genere_genaccount (New_genaccount ,genaccount_id ,genaccount_ref ,agrsagaco_id,New_agrsagaco);
				New_Det.ACO_ID           := genaccount_ref ;
				New_Det.DEB_NORECOVERY   := 0;
				  
				Insert into gendebt(deb_id,deb_refe,org_id,par_id,adr_id,deb_date,deb_duedt,deb_printdt,deb_amountinit,deb_amountremain,bap_id,
									vow_settlemode,aco_id,deb_norecovery,deb_credt,deb_updtby,deb_updtdt,deb_comment,sag_id,vow_debtype,deb_prel)
							values (New_Det.deb_id,New_Det.deb_refe,New_Det.org_id,New_Det.par_id,New_Det.adr_id,New_Det.deb_date,New_Det.deb_duedt,New_Det.deb_printdt,
									New_Det.deb_amountinit,New_Det.deb_amountremain,New_Det.bap_id,New_Det.vow_settlemode,New_Det.aco_id,New_Det.deb_norecovery,New_Det.deb_credt,
									New_Det.deb_updtby,New_Det.deb_updtdt,New_Det.DEB_COMMENT,nvl(New_Det.deb_amount_cash,0),New_Det.SAG_ID,New_Det.VOW_DEBTYPE,New_Det.DEB_PREL);	
							commit;
				 --------------------------------------------------------Traitement agrbill
				New_Agrbill.BIL_ID            :=  Agrbill_Id ;
				New_Agrbill.SAG_ID            :=  V_SAG_ID;
				New_Agrbill.VOW_AGRBILLTYPE   :=  pk_genvocword.getidbycode('VOW_AGRBILLTYPE','FC',null);
				New_Agrbill.VOW_MODEFACT      :=  pk_genvocword.getidbycode('VOW_MODEFACT',4,null);
				Insert into agrbill (BIL_ID,SAG_ID,VOW_AGRBILLTYPE,VOW_MODEFACT)
							values (New_Agrbill.BIL_ID,New_Agrbill.SAG_ID,New_Agrbill.VOW_AGRBILLTYPE,New_Agrbill.VOW_MODEFACT);	
				commit;
				--------------------------------------------------------Traitement genbill
				New_Genbill.BIL_ID            :=  Agrbill_Id;
				New_Genbill.BIL_CODE          :=  V_ID_FACTURE; 
				New_Genbill.BIL_CALCDT        :=  V_FAC_DATECALCUL ;
				New_Genbill.BIL_AMOUNTHT      :=  V_TOTHTE + V_TOTHTA ;
				New_Genbill.BIL_AMOUNTTVA     :=  V_TOTTVAE+ V_TOTTVAA ;
				New_Genbill.BIL_AMOUNTTTC     :=  V_TOTHTE+V_TOTTVAE+V_TOTHTA+V_TOTTVAA ;
				New_Genbill.BIL_AMOUNTTTCDEC  :=  V_AMOUNTTTCDEC ;
				New_Genbill.BIL_STATUS        :=  1;
				New_Genbill.DEB_ID            :=  Debt_Id;
				New_Genbill.PAR_ID            :=  V_PAR_ID ;
				New_Genbill.BIL_DEBTDT        :=  V_FAC_DATECALCUL;
				New_Genbill.RUN_ID            :=  genrun_ref  ;
		 
				Insert into genbill(BIL_ID,BIL_CODE,BIL_CALCDT,BIL_AMOUNTHT,BIL_AMOUNTTVA,BIL_AMOUNTTTC,DEB_ID,PAR_ID,BIL_STATUS,BIL_AMOUNTTTCDEC,BIL_DEBTDT,RUN_ID)
							 values(New_Genbill.BIL_ID,New_Genbill.BIL_CODE,New_Genbill.BIL_CALCDT,New_Genbill.BIL_AMOUNTHT,New_Genbill.BIL_AMOUNTTVA,New_Genbill.BIL_AMOUNTTTC,
									New_Genbill.DEB_ID,New_Genbill.PAR_ID,New_Genbill.BIL_STATUS,New_Genbill.BIL_AMOUNTTTCDEC,New_Genbill.BIL_DEBTDT,New_Genbill.RUN_ID); 
							commit;
			end if;		
	V := 0;
-------------------------------------------------------------------------------------------
------------------------------CONSOMMATION SONEDE 1ERE TRANCHE-----------------------------
-------------------------------------------------------------------------------------------				 
				if to_number(facture_.montt1) <> 0 then
				    V := V+1;
						V_PTA_ID := null;
						V_PSL_RANK := null;
						begin
						v_code:='CSM_STD';
							for x in C_ITEM(v_code) loop
							V_ITE_ID:=x.ite_id;
							V_ite_name:=x.ite_name
							V_VOW_UNIT:=x.VOW_UNIT
							end loop;
						EXCEPTION WHEN NO_DATA_FOUND THEN NULL;
						end;
						begin
						v_tva_taux:= 18;
							for v in C_TVA(v_tva_taux) loop
							   V_tva_id:=v.tva_id; 
							end loop;
						EXCEPTION WHEN NO_DATA_FOUND THEN 
						V_tva_id := 25;
						end;

						select count(*) 
						into V_nbr 
						from genptaslice 
						where PTA_ID in (select PTA_ID 
										from genitemperiodtarif 
										where TAR_id in (select tar_id from genitemtarif where ITE_ID=V_ITE_ID)
										);

						if V_nbr =1 then
							select PTA_ID,PSL_RANK  
							into V_PTA_ID,V_PSL_RANK 
							from genptaslice 
							where PTA_ID in (select PTA_ID 
											from genitemperiodtarif 
											where TAR_id in (select tar_id from genitemtarif where ITE_ID=V_ITE_ID )
							                )
							and rownum=1;
						end if;
						if V_nbr >1 then
							select PTA_ID,PSL_RANK  
							into V_PTA_ID,V_PSL_RANK 
							from genptaslice 
							where   PTA_ID in (select PTA_ID 
										       from genitemperiodtarif 
											   where TAR_id in (select tar_id from genitemtarif where ITE_ID=V_ITE_ID) 
								              )
							and rownum=1; 
						end if;
			   
					BEGIN
						insert into genbilline(BIL_ID,BLI_REVERSEBLI_ID,BLI_NUMBER,BLI_REVERSEBLINUMBER,BLI_NAME,BLI_EXERCICE,ITE_ID,PTA_ID,PSL_RANK,IMP_ID,BLI_VOLUMEBASE,BLI_VOLUMEFACT,
											   BLI_PUHT,TVA_ID,BLI_MHT,BLI_MTTVA,BLI_MTTC,BLI_STARTDT,BLI_ENDDT,VOW_UNIT,BLI_NBUNITES,BLI_DETAIL,BLI_CANCEL,IMC_ID,IMP_ANALYTIQUE_ID,
											   BLI_PERIODEINIT,BLI_PERIODE,BLI_REVERSEDT,BLI_CREDT,BLI_UPDTDT,BLI_UPDTBY,MEU_ID,BLI_NAME_A,BLI_REVERSEBLIDEC_ID,BLI_REVERSEBLINUMBERDEC,BLI_REVERSEDECDT)
										values(New_Genbill.BIL_ID,null,v,null,V_ite_name,V_anneereel,V_ITE_ID,V_PTA_ID,V_PSL_RANK,null,facture_.const1,facture_.const1,facture_.tauxt1/1000,V_tva_id,
											 facture_.montt1/1000,facture_.TVACONS/1000,(facture_.montt1/1000)+(facture_.TVACONS/1000),New_genrun.RUN_STARTDT,V_FAC_DATECALCUL,V_VOW_UNIT, null,0,0,null,
											 null,null,null,null,null,null,null,null,null,null,null,null);
					EXCEPTION WHEN OTHERS THEN
											BEGIN
											insert into genbilline(BIL_ID,BLI_REVERSEBLI_ID,BLI_NUMBER,BLI_REVERSEBLINUMBER,BLI_NAME,BLI_EXERCICE,ITE_ID,PTA_ID,PSL_RANK,IMP_ID,BLI_VOLUMEBASE,BLI_VOLUMEFACT,
																   BLI_PUHT,TVA_ID,BLI_MHT,BLI_MTTVA,BLI_MTTC,BLI_STARTDT,BLI_ENDDT,VOW_UNIT,BLI_NBUNITES,BLI_DETAIL,BLI_CANCEL,IMC_ID,IMP_ANALYTIQUE_ID,
																   BLI_PERIODEINIT,BLI_PERIODE,BLI_REVERSEDT,BLI_CREDT,BLI_UPDTDT,BLI_UPDTBY,MEU_ID,BLI_NAME_A,BLI_REVERSEBLIDEC_ID,BLI_REVERSEBLINUMBERDEC,BLI_REVERSEDECDT)
														    values(New_Genbill.BIL_ID,null,v+1,null,V_ite_name,V_anneereel,V_ITE_ID,V_PTA_ID,V_PSL_RANK,null,facture_.const1,facture_.const1,facture_.tauxt1/1000,V_tva_id,
																  facture_.montt1/1000,facture_.TVACONS/1000,(facture_.montt1/1000)+(facture_.TVACONS/1000), New_genrun.RUN_STARTDT,V_FAC_DATECALCUL,V_VOW_UNIT,null,0,0,null,
																  null,null,null,null,null,null,null,null,null,null,null,null);
									        EXCEPTION WHEN OTHERS THEN NULL;
											END;
		            END;
					end if;
	            end if;
-------------------------------------------------------------------------------------------
------------------------------CONSOMMATION SONEDE 2EME TRANCHE-----------------------------
-------------------------------------------------------------------------------------------
				if to_number(facture_.montt2) <> 0 then
				    v := v+1;
                        V_PTA_ID := null;
                        V_PSL_RANK := null;
						begin
						v_code:='CSM_STD';
							for x in C_ITEM(v_code) loop
							V_ITE_ID:=x.ite_id;
							V_ite_name:=x.ite_name
							V_VOW_UNIT:=x.VOW_UNIT
							end loop;
						EXCEPTION WHEN NO_DATA_FOUND THEN NULL;
						end;
						begin
						v_tva_taux:= 18;
							for v in C_TVA(v_tva_taux) loop
							   V_tva_id:=v.tva_id; 
							end loop;
						EXCEPTION WHEN NO_DATA_FOUND THEN 
						V_tva_id := 25;
						end;
						select count(*) 
						into V_nbr 
						from genptaslice 
						where PTA_ID in (select PTA_ID 	from genitemperiodtarif 
										 where TAR_id in ( select tar_id from genitemtarif where ITE_ID=V_ITE_ID )
										);
						if V_nbr =1 then
							select PTA_ID,PSL_RANK  
							into V_PTA_ID,V_PSL_RANK 
							from genptaslice 
							where PTA_ID in (select PTA_ID 
											 from genitemperiodtarif 
											 where TAR_id in (select tar_id from genitemtarif where ITE_ID=V_ITE_ID)
											)
							and rownum=1;
						end if;
						if V_nbr >1 then
							select PTA_ID,PSL_RANK  
							into V_PTA_ID,V_PSL_RANK 
							from genptaslice 
							where   PTA_ID
							in (select PTA_ID 
								from genitemperiodtarif
								where TAR_id in (select tar_id from genitemtarif where ITE_ID=V_ITE_ID) 
							   )and rownum=1;
						end if;
						BEGIN
							insert into genbilline(BIL_ID,BLI_REVERSEBLI_ID,BLI_NUMBER,BLI_REVERSEBLINUMBER,BLI_NAME,BLI_EXERCICE,ITE_ID,PTA_ID,PSL_RANK,IMP_ID,BLI_VOLUMEBASE,BLI_VOLUMEFACT,
												   BLI_PUHT,TVA_ID,BLI_MHT,BLI_MTTVA,BLI_MTTC,BLI_STARTDT,BLI_ENDDT,VOW_UNIT,BLI_NBUNITES,BLI_DETAIL,BLI_CANCEL,IMC_ID,IMP_ANALYTIQUE_ID,
												   BLI_PERIODEINIT,BLI_PERIODE,BLI_REVERSEDT,BLI_CREDT,BLI_UPDTDT,BLI_UPDTBY,MEU_ID,BLI_NAME_A,BLI_REVERSEBLIDEC_ID,BLI_REVERSEBLINUMBERDEC,BLI_REVERSEDECDT)
											values(New_Genbill.BIL_ID,null,v,null,V_ite_name,V_anneereel,V_ITE_ID,V_PTA_ID,V_PSL_RANK,null,facture_.const2,facture_.const2,facture_.tauxt2/1000,V_tva_id			   ,4
												   facture_.montt2/1000,facture_.TVACONS/1000,(facture_.montt2/1000)+(facture_.TVACONS/1000),New_genrun.RUN_STARTDT,V_FAC_DATECALCUL,V_VOW_UNIT,null,0,0,null,
													null,null,null,null,null,null,null,	null,null,null,null,null,);
						EXCEPTION WHEN OTHERS THEN
												BEGIN
												insert into genbilline(BIL_ID,BLI_REVERSEBLI_ID,BLI_NUMBER,BLI_REVERSEBLINUMBER,BLI_NAME,BLI_EXERCICE,ITE_ID,PTA_ID,PSL_RANK,IMP_ID,BLI_VOLUMEBASE,BLI_VOLUMEFACT,
																	   BLI_PUHT,TVA_ID,BLI_MHT,BLI_MTTVA,BLI_MTTC,BLI_STARTDT,BLI_ENDDT,VOW_UNIT,BLI_NBUNITES,BLI_DETAIL,BLI_CANCEL,IMC_ID,IMP_ANALYTIQUE_ID,
																	   BLI_PERIODEINIT,BLI_PERIODE,BLI_REVERSEDT,BLI_CREDT,BLI_UPDTDT,BLI_UPDTBY,MEU_ID,BLI_NAME_A,BLI_REVERSEBLIDEC_ID,BLI_REVERSEBLINUMBERDEC,BLI_REVERSEDECDT)
															   values(New_Genbill.BIL_ID,null,v+1,null,V_ite_name,V_anneereel,V_ITE_ID,V_PTA_ID,V_PSL_RANK,null,facture_.const2,facture_.const2,facture_.tauxt2/1000,V_tva_id,
																	  facture_.montt2/1000,facture_.TVACONS/1000,(facture_.montt2/1000)+(facture_.TVACONS/1000),New_genrun.RUN_STARTDT,V_FAC_DATECALCUL,V_VOW_UNIT,null,0,0,null,
																	  null,null,null,null,null,null,null,null,null,null,null,null);
												EXCEPTION WHEN OTHERS THEN NULL;
												END;
						END;
					commit;	
	            end if;
				
-------------------------------------------------------------------------------------------
------------------------------CONSOMMATION SONEDE 3EME TRANCHE-----------------------------
-------------------------------------------------------------------------------------------				
				if to_number(facture_.montt3) <> 0 then
				    v := v+1;
					    V_PTA_ID := null;
					    V_PSL_RANK := null;
						begin
						v_code:='CSM_STD';
							for x in C_ITEM(v_code) loop
							V_ITE_ID:=x.ite_id;
							V_ite_name:=x.ite_name
							V_VOW_UNIT:=x.VOW_UNIT
							end loop;
						EXCEPTION WHEN NO_DATA_FOUND THEN NULL;
						end;
						begin
						v_tva_taux:= 18;
							for v in C_TVA(v_tva_taux) loop
							   V_tva_id:=v.tva_id; 
							end loop;
						EXCEPTION WHEN NO_DATA_FOUND THEN 
						V_tva_id := 25;
						end;
						select count(*) 
						into V_nbr 
						from genptaslice 
						where PTA_ID in (select PTA_ID 	from genitemperiodtarif 
										 where TAR_id in (select tar_id from genitemtarif where ITE_ID=V_ITE_ID )
										);
						if V_nbr =1 then
							select PTA_ID,PSL_RANK  
							into V_PTA_ID,V_PSL_RANK 
							from genptaslice 
							where PTA_ID in (select PTA_ID 
											 from genitemperiodtarif 
											 where TAR_id in (select tar_id from genitemtarif where ITE_ID=V_ITE_ID)
											)
							and rownum=1;
						end if;
						if V_nbr >1 then
							select PTA_ID,PSL_RANK  
							into V_PTA_ID,V_PSL_RANK 
							from genptaslice 
							where   PTA_ID
							in (select PTA_ID 
								from genitemperiodtarif
								where TAR_id in (select tar_id from genitemtarif where ITE_ID=V_ITE_ID) 
							   )
							   and rownum=1;
						end if;
						BEGIN
						    insert into genbilline(BIL_ID,BLI_REVERSEBLI_ID,BLI_NUMBER,BLI_REVERSEBLINUMBER,BLI_NAME,BLI_EXERCICE,ITE_ID,PTA_ID,PSL_RANK,IMP_ID,BLI_VOLUMEBASE,BLI_VOLUMEFACT,
												   BLI_PUHT,TVA_ID,BLI_MHT,BLI_MTTVA,BLI_MTTC,BLI_STARTDT,BLI_ENDDT,VOW_UNIT,BLI_NBUNITES,BLI_DETAIL,BLI_CANCEL,IMC_ID,IMP_ANALYTIQUE_ID,
												   BLI_PERIODEINIT,BLI_PERIODE,BLI_REVERSEDT,BLI_CREDT,BLI_UPDTDT,BLI_UPDTBY,MEU_ID,BLI_NAME_A,BLI_REVERSEBLIDEC_ID,BLI_REVERSEBLINUMBERDEC,BLI_REVERSEDECDT)
											values(New_Genbill.BIL_ID,null,v,null,V_ite_name,V_anneereel,V_ITE_ID,V_PTA_ID,V_PSL_RANK,null,facture_.const3,facture_.const3,facture_.tauxt3/1000,V_tva_id,
													facture_.montt3/1000,facture_.TVACONS/1000,facture_.montt3/1000+(facture_.TVACONS/1000),New_genrun.RUN_STARTDT,V_FAC_DATECALCUL,V_VOW_UNIT,null,0,0,null,
													null,null,null,null,null,null,null,null,null,null,null,null);
						EXCEPTION WHEN OTHERS THEN
												BEGIN
												insert into genbilline(BIL_ID,BLI_REVERSEBLI_ID,BLI_NUMBER,BLI_REVERSEBLINUMBER,BLI_NAME,BLI_EXERCICE,ITE_ID,PTA_ID,PSL_RANK,IMP_ID,BLI_VOLUMEBASE,BLI_VOLUMEFACT,
																	   BLI_PUHT,TVA_ID,BLI_MHT,BLI_MTTVA,BLI_MTTC,BLI_STARTDT,BLI_ENDDT,VOW_UNIT,BLI_NBUNITES,BLI_DETAIL,BLI_CANCEL,IMC_ID,IMP_ANALYTIQUE_ID,
																	   BLI_PERIODEINIT,BLI_PERIODE,BLI_REVERSEDT,BLI_CREDT,BLI_UPDTDT,BLI_UPDTBY,MEU_ID,BLI_NAME_A,BLI_REVERSEBLIDEC_ID,BLI_REVERSEBLINUMBERDEC,BLI_REVERSEDECDT)
																values(New_Genbill.BIL_ID,null,v+1,null,V_ite_name,V_anneereel,V_ITE_ID,V_PTA_ID,V_PSL_RANK,null,facture_.const3,facture_.const3,facture_.tauxt3/1000,V_tva_id,
																	  facture_.montt3/1000,facture_.TVACONS/1000,facture_.montt3/1000+(facture_.TVACONS/1000),New_genrun.RUN_STARTDT,V_FAC_DATECALCUL,V_VOW_UNIT,null,0,0,null,
																	  null,null,null,null,null,null,null,null,null,null,null,null);
												EXCEPTION WHEN OTHERS THEN NULL;
												END;
						END;
						commit;
	            end if;
-------------------------------------------------------------------------------------------
-----------------------------------REDEVANCE ONAS 1ERE TRANCHE-----------------------------
-------------------------------------------------------------------------------------------					
				if to_number(facture_.mon1) <> 0 then
					v := v+1;
					    V_PTA_ID := null;
					    V_PSL_RANK := null;	 
						begin
						v_code:='VAR_ONAS_1';
							for x in C_ITEM(v_code) loop
							V_ITE_ID:=x.ite_id;
							V_ite_name:=x.ite_name
							V_VOW_UNIT:=x.VOW_UNIT
							end loop;
						EXCEPTION WHEN NO_DATA_FOUND THEN NULL;
						end;
						begin
						v_tva_taux= 0;
							for v in C_TVA(v_tva_taux) loop
							   V_tva_id:=v.tva_id; 
							end loop;
						EXCEPTION WHEN NO_DATA_FOUND THEN 
						V_tva_id := 25;
						end;
						select count(*) 
						into V_nbr 
						from genptaslice 
						where PTA_ID in (select PTA_ID 	from genitemperiodtarif 
										 where TAR_id in ( select tar_id from genitemtarif where ITE_ID=V_ITE_ID )
										);
						if V_nbr =1 then
							select PTA_ID,PSL_RANK  
							into V_PTA_ID,V_PSL_RANK 
							from genptaslice 
							where PTA_ID in (select PTA_ID 
											 from genitemperiodtarif 
											 where TAR_id in (select tar_id from genitemtarif where ITE_ID=V_ITE_ID)
											)
							and rownum=1;
						end if;
						if V_nbr >1 then
							select PTA_ID,PSL_RANK  
							into V_PTA_ID,V_PSL_RANK 
							from genptaslice 
							where   PTA_ID
							in (select PTA_ID 
								from genitemperiodtarif
								where TAR_id in (select tar_id from genitemtarif where ITE_ID=V_ITE_ID) 
							   )and rownum=1;
						 
						end if;
                        BEGIN
								insert into genbilline(BIL_ID,BLI_REVERSEBLI_ID,BLI_NUMBER,BLI_REVERSEBLINUMBER,BLI_NAME,BLI_EXERCICE,ITE_ID,PTA_ID,PSL_RANK,IMP_ID,BLI_VOLUMEBASE,BLI_VOLUMEFACT,
													   BLI_PUHT,TVA_ID,BLI_MHT,BLI_MTTVA,BLI_MTTC,BLI_STARTDT,BLI_ENDDT,VOW_UNIT,BLI_NBUNITES,BLI_DETAIL,BLI_CANCEL,IMC_ID,IMP_ANALYTIQUE_ID,
														BLI_PERIODEINIT,BLI_PERIODE,BLI_REVERSEDT,BLI_CREDT,BLI_UPDTDT,BLI_UPDTBY,MEU_ID,BLI_NAME_A,BLI_REVERSEBLIDEC_ID,BLI_REVERSEBLINUMBERDEC,BLI_REVERSEDECDT)
													values(	New_Genbill.BIL_ID,null,v,null,V_ite_name,V_anneereel,V_ITE_ID,V_PTA_ID,V_PSL_RANK,null,facture_.volon1,facture_.volon1,facture_.tauon1/1000,V_tva_id,
															facture_.mon1/1000,0,facture_.mon1/1000,New_genrun.RUN_STARTDT,V_FAC_DATECALCUL,V_VOW_UNIT,null,0,0,null,
															null,null,null,null,null,null,null,null,null,null,null,null);
						EXCEPTION WHEN OTHERS THEN
											BEGIN
											insert into genbilline(BIL_ID,BLI_REVERSEBLI_ID,BLI_NUMBER,BLI_REVERSEBLINUMBER,BLI_NAME,BLI_EXERCICE,ITE_ID,PTA_ID,PSL_RANK,IMP_ID,BLI_VOLUMEBASE,BLI_VOLUMEFACT,
																   BLI_PUHT,TVA_ID,BLI_MHT,BLI_MTTVA,BLI_MTTC,BLI_STARTDT,BLI_ENDDT,VOW_UNIT,BLI_NBUNITES,BLI_DETAIL,BLI_CANCEL,IMC_ID,IMP_ANALYTIQUE_ID,
																   BLI_PERIODEINIT,BLI_PERIODE,BLI_REVERSEDT,BLI_CREDT,BLI_UPDTDT,BLI_UPDTBY,MEU_ID,BLI_NAME_A,BLI_REVERSEBLIDEC_ID,BLI_REVERSEBLINUMBERDEC,BLI_REVERSEDECDT)
															values(	New_Genbill.BIL_ID,null,v+1,null,V_ite_name,V_anneereel,V_ITE_ID,V_PTA_ID,V_PSL_RANK,null,facture_.volon1,facture_.volon1,facture_.tauon1/1000,V_tva_id,
																  facture_.mon1/1000,0,facture_.mon1/1000,New_genrun.RUN_STARTDT,V_FAC_DATECALCUL,V_VOW_UNIT,null,0,0,null,
																  null,null,null,null,null,null,null,null,null,null,null,null);
											EXCEPTION WHEN OTHERS THEN NULL;
											END;
						END;
						commit;
				end if;
-------------------------------------------------------------------------------------------
-----------------------------------REDEVANCE ONAS 2EME TRANCHE-----------------------------
-------------------------------------------------------------------------------------------	
                if to_number(facture_.mon2) <> 0 then
					v := v+1;
						V_PTA_ID := null;
						V_PSL_RANK := null;
						begin
						v_code:='VAR_ONAS_1';
							for x in C_ITEM(v_code) loop
							V_ITE_ID:=x.ite_id;
							V_ite_name:=x.ite_name
							V_VOW_UNIT:=x.VOW_UNIT
							end loop;
						EXCEPTION WHEN NO_DATA_FOUND THEN NULL;
						end;
						begin
						v_tva_taux= 0;
							for v in C_TVA(v_tva_taux) loop
							   V_tva_id:=v.tva_id; 
							end loop;
						EXCEPTION WHEN NO_DATA_FOUND THEN 
						V_tva_id := 25;
						end;
						select count(*) 
						into V_nbr 
						from genptaslice 
						where PTA_ID in (select PTA_ID 	from genitemperiodtarif 
										 where TAR_id in ( select tar_id from genitemtarif where ITE_ID=V_ITE_ID )
										);
						if V_nbr =1 then
							select PTA_ID,PSL_RANK  
							into V_PTA_ID,V_PSL_RANK 
							from genptaslice 
							where PTA_ID in (select PTA_ID 
											 from genitemperiodtarif 
											 where TAR_id in (select tar_id from genitemtarif where ITE_ID=V_ITE_ID)
											)
							and rownum=1;
						end if;
						if V_nbr >1 then
							select PTA_ID,PSL_RANK  
							into V_PTA_ID,V_PSL_RANK 
							from genptaslice 
							where   PTA_ID
							in (select PTA_ID 
								from genitemperiodtarif
								where TAR_id in (select tar_id from genitemtarif where ITE_ID=V_ITE_ID) 
							   )and rownum=1;
						end if;

						BEGIN
							insert into genbilline(BIL_ID,BLI_REVERSEBLI_ID,BLI_NUMBER,BLI_REVERSEBLINUMBER,BLI_NAME,BLI_EXERCICE,ITE_ID,PTA_ID,PSL_RANK,IMP_ID,BLI_VOLUMEBASE,BLI_VOLUMEFACT,
												   BLI_PUHT,TVA_ID,BLI_MHT,BLI_MTTVA,BLI_MTTC,BLI_STARTDT,BLI_ENDDT,VOW_UNIT,BLI_NBUNITES,BLI_DETAIL,BLI_CANCEL,IMC_ID,IMP_ANALYTIQUE_ID,
												   BLI_PERIODEINIT,BLI_PERIODE,BLI_REVERSEDT,BLI_CREDT,BLI_UPDTDT,BLI_UPDTBY,MEU_ID,BLI_NAME_A,BLI_REVERSEBLIDEC_ID,BLI_REVERSEBLINUMBERDEC,BLI_REVERSEDECDT)
											values(New_Genbill.BIL_ID,null,v,null,V_ite_name,V_anneereel,V_ITE_ID,V_PTA_ID,V_PSL_RANK,null,facture_.volon2,facture_.volon2,facture_.tauon2/1000,V_tva_id,
													facture_.mon2/1000,0,facture_.mon2/1000,New_genrun.RUN_STARTDT,V_FAC_DATECALCUL,V_VOW_UNIT,null,0,0,null,
													null,null,null,null,null,null,null,null,null,null,null,null);
						EXCEPTION WHEN OTHERS THEN
											BEGIN
											insert into genbilline(BIL_ID,BLI_REVERSEBLI_ID,BLI_NUMBER,BLI_REVERSEBLINUMBER,BLI_NAME,BLI_EXERCICE,ITE_ID,PTA_ID,PSL_RANK,IMP_ID,BLI_VOLUMEBASE,BLI_VOLUMEFACT,
																   BLI_PUHT,TVA_ID,BLI_MHT,BLI_MTTVA,BLI_MTTC,BLI_STARTDT,BLI_ENDDT,VOW_UNIT,BLI_NBUNITES,BLI_DETAIL,BLI_CANCEL,IMC_ID,IMP_ANALYTIQUE_ID,
																   BLI_PERIODEINIT,BLI_PERIODE,BLI_REVERSEDT,BLI_CREDT,BLI_UPDTDT,BLI_UPDTBY,MEU_ID,BLI_NAME_A,BLI_REVERSEBLIDEC_ID,BLI_REVERSEBLINUMBERDEC,BLI_REVERSEDECDT)
														   values(New_Genbill.BIL_ID,null,v+1,null,V_ite_name,V_anneereel,V_ITE_ID,V_PTA_ID,V_PSL_RANK,null,facture_.volon2,facture_.volon2,facture_.tauon2/1000,V_tva_id,
																 facture_.mon2/1000,0,facture_.mon2/1000,New_genrun.RUN_STARTDT,V_FAC_DATECALCUL,V_VOW_UNIT,null,0,0,null,
																 null,null,null,null,null,null,null,null,null,null,null,null);
											EXCEPTION WHEN OTHERS THEN NULL;
											END;
						END;
						commit;
	            end if;
-------------------------------------------------------------------------------------------
-----------------------------------REDEVANCE ONAS 3EME TRANCHE-----------------------------
-------------------------------------------------------------------------------------------					
				if to_number(facture_.mon3) <> 0 then
				    v := v+1;
					    V_PTA_ID := null;
					    V_PSL_RANK := null;
						begin
						v_code:='VAR_ONAS_1';
							for x in C_ITEM(v_code) loop
							V_ITE_ID:=x.ite_id;
							V_ite_name:=x.ite_name
							V_VOW_UNIT:=x.VOW_UNIT
							end loop;
						EXCEPTION WHEN NO_DATA_FOUND THEN NULL;
						end;
						begin
						v_tva_taux= 0;
							for v in C_TVA(v_tva_taux) loop
							   V_tva_id:=v.tva_id; 
							end loop;
						EXCEPTION WHEN NO_DATA_FOUND THEN 
						V_tva_id := 25;
						end;
						select count(*) 
						into V_nbr 
						from genptaslice 
						where PTA_ID in (select PTA_ID 	from genitemperiodtarif 
										 where TAR_id in ( select tar_id from genitemtarif where ITE_ID=V_ITE_ID )
										);
						if V_nbr =1 then
						
							select PTA_ID,PSL_RANK  
							into V_PTA_ID,V_PSL_RANK 
							from genptaslice 
							where PTA_ID in (select PTA_ID 
											 from genitemperiodtarif 
											 where TAR_id in (select tar_id from genitemtarif where ITE_ID=V_ITE_ID)
											)
							and rownum=1;
						end if;

						if V_nbr >1 then
							select PTA_ID,PSL_RANK  
							into V_PTA_ID,V_PSL_RANK 
							from genptaslice 
							where   PTA_ID
							in (select PTA_ID 
								from genitemperiodtarif
								where TAR_id in (select tar_id from genitemtarif where ITE_ID=V_ITE_ID) 
							   )and rownum=1;
						end if;

						BEGIN
							insert into genbilline(BIL_ID,BLI_REVERSEBLI_ID,BLI_NUMBER,BLI_REVERSEBLINUMBER,BLI_NAME,BLI_EXERCICE,ITE_ID,PTA_ID,PSL_RANK,IMP_ID,BLI_VOLUMEBASE,BLI_VOLUMEFACT,
												   BLI_PUHT,TVA_ID,BLI_MHT,BLI_MTTVA,BLI_MTTC,BLI_STARTDT,BLI_ENDDT,VOW_UNIT,BLI_NBUNITES,BLI_DETAIL,BLI_CANCEL,IMC_ID,IMP_ANALYTIQUE_ID,
												   BLI_PERIODEINIT,BLI_PERIODE,BLI_REVERSEDT,BLI_CREDT,BLI_UPDTDT,BLI_UPDTBY,MEU_ID,BLI_NAME_A,BLI_REVERSEBLIDEC_ID,BLI_REVERSEBLINUMBERDEC,BLI_REVERSEDECDT)
											values(New_Genbill.BIL_ID,null,v,null,V_ite_name,V_anneereel,V_ITE_ID,V_PTA_ID,V_PSL_RANK,null,facture_.volon3,facture_.volon3,facture_.tauon3/1000,V_tva_id,
												  facture_.mon3/1000,0,facture_.mon3/1000,New_genrun.RUN_STARTDT,V_FAC_DATECALCUL,V_VOW_UNIT,null,0,0,null,
												  null,null,null,null,null,null,null,null,null,null,null,null);
						EXCEPTION WHEN OTHERS THEN
											BEGIN
											insert into genbilline(BIL_ID,BLI_REVERSEBLI_ID,BLI_NUMBER,BLI_REVERSEBLINUMBER,BLI_NAME,BLI_EXERCICE,ITE_ID,PTA_ID,PSL_RANK,IMP_ID,BLI_VOLUMEBASE,BLI_VOLUMEFACT,
																   BLI_PUHT,TVA_ID,BLI_MHT,BLI_MTTVA,BLI_MTTC,BLI_STARTDT,BLI_ENDDT,VOW_UNIT,BLI_NBUNITES,BLI_DETAIL,BLI_CANCEL,IMC_ID,IMP_ANALYTIQUE_ID,
																   BLI_PERIODEINIT,BLI_PERIODE,BLI_REVERSEDT,BLI_CREDT,BLI_UPDTDT,BLI_UPDTBY,MEU_ID,BLI_NAME_A,BLI_REVERSEBLIDEC_ID,BLI_REVERSEBLINUMBERDEC,BLI_REVERSEDECDT)
															values(New_Genbill.BIL_ID,null,v+1,null,V_ite_name,V_anneereel,ITE_ID,V_PTA_ID,V_PSL_RANK,null,facture_.volon3,facture_.volon3,facture_.tauon3/1000,V_tva_id,
																  facture_.mon3/1000,0,facture_.mon3/1000,New_genrun.RUN_STARTDT,V_FAC_DATECALCUL,V_VOW_UNIT,null,0,0,null,
															      null,null,null,null,null,null,null,null,null,null,null,null);
											EXCEPTION WHEN OTHERS THEN NULL;
											END;
						END;
						commit;
				end if;
	           
-------------------------------------------------------------------------------------------
----------------------------------- FRAIS FIXE ONAS-----------------------------
-------------------------------------------------------------------------------------------	
				if to_number(facture_.fixonas) <> 0 then
					v := v+1;
						V_PTA_ID := null;
						V_PSL_RANK := null;
						begin
						v_code:='FIXE_ONAS_1';
							for x in C_ITEM(v_code) loop
							V_ITE_ID:=x.ite_id;
							V_ite_name:=x.ite_name
							V_VOW_UNIT:=x.VOW_UNIT
							end loop;
						EXCEPTION WHEN NO_DATA_FOUND THEN NULL;
						end;
						begin
						v_tva_taux= 0;
							for v in C_TVA(v_tva_taux) loop
							   V_tva_id:=v.tva_id; 
							end loop;
						EXCEPTION WHEN NO_DATA_FOUND THEN 
						V_tva_id := 25;
						end;
						select count(*) 
						into V_nbr 
						from genptaslice 
						where PTA_ID in (select PTA_ID 	from genitemperiodtarif 
										 where TAR_id in (select tar_id from genitemtarif where ITE_ID=V_ITE_ID )
										);
						if V_nbr =1 then
						    select PTA_ID,PSL_RANK  
							into V_PTA_ID,V_PSL_RANK 
							from genptaslice 
							where PTA_ID in (select PTA_ID 
											 from genitemperiodtarif 
											 where TAR_id in (select tar_id from genitemtarif where ITE_ID=V_ITE_ID)
											)
							and rownum=1;
						end if;
						if V_nbr >1 then
							select PTA_ID,PSL_RANK  
							into V_PTA_ID,V_PSL_RANK 
							from genptaslice 
							where   PTA_ID
							in (select PTA_ID 
								from genitemperiodtarif
								where TAR_id in (select tar_id from genitemtarif where ITE_ID=V_ITE_ID) 
							   )
							and rownum=1;
						end if;
                        BEGIN
							insert into genbilline(BIL_ID,BLI_REVERSEBLI_ID,BLI_NUMBER,BLI_REVERSEBLINUMBER,BLI_NAME,BLI_EXERCICE,ITE_ID,PTA_ID,PSL_RANK,IMP_ID,BLI_VOLUMEBASE,BLI_VOLUMEFACT,
												   BLI_PUHT,TVA_ID,BLI_MHT,BLI_MTTVA,BLI_MTTC,BLI_STARTDT,BLI_ENDDT,VOW_UNIT,BLI_NBUNITES,BLI_DETAIL,BLI_CANCEL,IMC_ID,IMP_ANALYTIQUE_ID,
												   BLI_PERIODEINIT,BLI_PERIODE,BLI_REVERSEDT,BLI_CREDT,BLI_UPDTDT,BLI_UPDTBY,MEU_ID,BLI_NAME_A,BLI_REVERSEBLIDEC_ID,BLI_REVERSEBLINUMBERDEC,BLI_REVERSEDECDT)
											values(New_Genbill.BIL_ID,null,v,null,V_ite_name,V_anneereel,V_ITE_ID,V_PTA_ID,V_PSL_RANK,null,1,1,facture_.fixonas/1000,V_tva_id,
												  facture_.fixonas/1000,0,facture_.fixonas/1000,New_genrun.RUN_STARTDT,V_FAC_DATECALCUL,V_VOW_UNIT,null,0,0,null,
													null,null,null,null,null,null,null,null,null,null,null,null);
						EXCEPTION WHEN OTHERS THEN
											BEGIN
											insert into genbilline(BIL_ID,BLI_REVERSEBLI_ID,BLI_NUMBER,BLI_REVERSEBLINUMBER,BLI_NAME,BLI_EXERCICE,ITE_ID,PTA_ID,PSL_RANK,IMP_ID,BLI_VOLUMEBASE,BLI_VOLUMEFACT,
																   BLI_PUHT,TVA_ID,BLI_MHT,BLI_MTTVA,BLI_MTTC,BLI_STARTDT,BLI_ENDDT,VOW_UNIT,BLI_NBUNITES,BLI_DETAIL,BLI_CANCEL,IMC_ID,IMP_ANALYTIQUE_ID,
																   BLI_PERIODEINIT,BLI_PERIODE,BLI_REVERSEDT,BLI_CREDT,BLI_UPDTDT,BLI_UPDTBY,MEU_ID,BLI_NAME_A,BLI_REVERSEBLIDEC_ID,BLI_REVERSEBLINUMBERDEC,BLI_REVERSEDECDT)
													values(New_Genbill.BIL_ID,null,v+1,null,V_ite_name,V_anneereel,V_ITE_ID,V_PTA_ID,V_PSL_RANK,null,1,1,facture_.fixonas/1000,V_tva_id,
														  facture_.fixonas/1000,0,facture_.fixonas/1000,New_genrun.RUN_STARTDT,V_FAC_DATECALCUL,V_VOW_UNIT,null,0,0,null,
														  null,null,null,null,null,null,null,null,null,null,null,null);
											EXCEPTION WHEN OTHERS THEN NULL;
											END;
						END;
						commit;
				end if;
	            
				
-------------------------------------------------------------------------------------------
-----------------------------------FRAIS FIXE SONEDE---------------------------------------
-------------------------------------------------------------------------------------------					
				
				if to_number(facture_.fraisctr) <> 0then
					v := v+1;
						V_PTA_ID := null;
						V_PSL_RANK := null;
						begin
						v_code:='FRS_FIX_CSM';
							for x in C_ITEM(v_code) loop
							V_ITE_ID:=x.ite_id;
							V_ite_name:=x.ite_name
							V_VOW_UNIT:=x.VOW_UNIT
							end loop;
						EXCEPTION WHEN NO_DATA_FOUND THEN NULL;
						end;
						begin
						v_tva_taux:= 18;
							for v in C_TVA(v_tva_taux) loop
							   V_tva_id:=v.tva_id; 
							end loop;
						EXCEPTION WHEN NO_DATA_FOUND THEN 
						V_tva_id := 25;
						end;
						select count(*) 
						into V_nbr 
						from genptaslice 
						where PTA_ID in (select PTA_ID 	from genitemperiodtarif 
										 where TAR_id in ( select tar_id from genitemtarif where ITE_ID=V_ITE_ID )
										);
						if V_nbr =1 then
						
							select PTA_ID,PSL_RANK  
							into V_PTA_ID,V_PSL_RANK 
							from genptaslice 
							where PTA_ID in (select PTA_ID 
											 from genitemperiodtarif 
											 where TAR_id in (select tar_id from genitemtarif where ITE_ID=V_ITE_ID)
											)
							and rownum=1;
						end if;
						if V_nbr >1 then
							select PTA_ID,PSL_RANK  
							into V_PTA_ID,V_PSL_RANK 
							from genptaslice 
							where   PTA_ID
							in (select PTA_ID 
								from genitemperiodtarif
								where TAR_id in (select tar_id from genitemtarif where ITE_ID=V_ITE_ID) 
							   )and rownum=1;
						end if;

						BEGIN
							insert into genbilline(BIL_ID,BLI_REVERSEBLI_ID,BLI_NUMBER,BLI_REVERSEBLINUMBER,BLI_NAME,BLI_EXERCICE,ITE_ID,PTA_ID,PSL_RANK,IMP_ID,BLI_VOLUMEBASE,BLI_VOLUMEFACT,
												   BLI_PUHT,TVA_ID,BLI_MHT,BLI_MTTVA,BLI_MTTC,BLI_STARTDT,BLI_ENDDT,VOW_UNIT,BLI_NBUNITES,BLI_DETAIL,BLI_CANCEL,IMC_ID,IMP_ANALYTIQUE_ID,
												   BLI_PERIODEINIT,BLI_PERIODE,BLI_REVERSEDT,BLI_CREDT,BLI_UPDTDT,BLI_UPDTBY,MEU_ID,BLI_NAME_A,BLI_REVERSEBLIDEC_ID,BLI_REVERSEBLINUMBERDEC,BLI_REVERSEDECDT)
											values(New_Genbill.BIL_ID,null,v,null,V_ite_name,V_anneereel ,V_ITE_ID,V_PTA_ID,V_PSL_RANK,null,1,1,facture_.fraisctr/1000,V_tva_id			  
												   facture_.fraisctr/1000,facture_.TVA_ff/1000,(facture_.fraisctr/1000)+(facture_.tva_ff/1000),New_genrun.RUN_STARTDT,V_FAC_DATECALCUL,V_VOW_UNIT,null,0,0,null,
													null,null,null,null,null,null,null,null,null,null,null,null);
						EXCEPTION WHEN OTHERS THEN
												BEGIN
												insert into genbilline(BIL_ID,BLI_REVERSEBLI_ID,BLI_NUMBER,BLI_REVERSEBLINUMBER,BLI_NAME,BLI_EXERCICE,ITE_ID,PTA_ID,PSL_RANK,IMP_ID,BLI_VOLUMEBASE,BLI_VOLUMEFACT,
																	   BLI_PUHT,TVA_ID,BLI_MHT,BLI_MTTVA,BLI_MTTC,BLI_STARTDT,BLI_ENDDT,VOW_UNIT,BLI_NBUNITES,BLI_DETAIL,BLI_CANCEL,IMC_ID,IMP_ANALYTIQUE_ID,
																	   BLI_PERIODEINIT,BLI_PERIODE,BLI_REVERSEDT,BLI_CREDT,BLI_UPDTDT,BLI_UPDTBY,MEU_ID,BLI_NAME_A,BLI_REVERSEBLIDEC_ID,BLI_REVERSEBLINUMBERDEC,BLI_REVERSEDECDT)
														values(New_Genbill.BIL_ID,null,v+1,null,V_ite_name,V_anneereel,V_ITE_ID,V_PTA_ID,V_PSL_RANK,null,1,1,facture_.fraisctr/1000,V_tva_id,
															  facture_.fraisctr/1000,facture_.TVA_ff/1000,(facture_.fraisctr/1000)+(facture_.tva_ff/1000),New_genrun.RUN_STARTDT,V_FAC_DATECALCUL,V_VOW_UNIT,null,0,0,null,
															  null,null,null,null,null,null,null,null,null,null,null,null);
												EXCEPTION WHEN OTHERS THEN NULL;
												END;
						END;
						commit;
				end if;
-------------------------------------------------------------------------------------------
-----------------------------------Frais FERMETURE---------------------------------------
-------------------------------------------------------------------------------------------	
				if to_number(facture_.fermeture) <> 0 then
					v := v+1;
						V_PTA_ID := null;
						V_PSL_RANK := null;
						begin
						v_code:='FRS_FIX_PAVI_CPR';
							for x in C_ITEM(v_code) loop
							V_ITE_ID:=x.ite_id;
							V_ite_name:=x.ite_name
							V_VOW_UNIT:=x.VOW_UNIT
							end loop;
						EXCEPTION WHEN NO_DATA_FOUND THEN NULL;
						end;
						begin
						v_tva_taux:= 18;
							for v in C_TVA(v_tva_taux) loop
							   V_tva_id:=v.tva_id; 
							end loop;
						EXCEPTION WHEN NO_DATA_FOUND THEN 
						V_tva_id := 25;
						end;
						select count(*) 
						into V_nbr 
						from genptaslice 
						where PTA_ID in (select PTA_ID 	from genitemperiodtarif 
										 where TAR_id in ( select tar_id from genitemtarif where ITE_ID=V_ITE_ID )
										);
						if V_nbr =1 then
						
							select PTA_ID,PSL_RANK  
							into V_PTA_ID,V_PSL_RANK 
							from genptaslice 
							where PTA_ID in (select PTA_ID 
											 from genitemperiodtarif 
											 where TAR_id in (select tar_id from genitemtarif where ITE_ID=V_ITE_ID)
											)
							and rownum=1;
						end if;
						if V_nbr >1 then
							select PTA_ID,PSL_RANK  
							into V_PTA_ID,V_PSL_RANK 
							from genptaslice 
							where   PTA_ID
							in (select PTA_ID 
								from genitemperiodtarif
								where TAR_id in (select tar_id from genitemtarif where ITE_ID=V_ITE_ID) 
							   )and rownum=1;
						end if;

						BEGIN
							insert into genbilline(BIL_ID,BLI_REVERSEBLI_ID,BLI_NUMBER,BLI_REVERSEBLINUMBER,BLI_NAME,BLI_EXERCICE,ITE_ID,PTA_ID,PSL_RANK,IMP_ID,BLI_VOLUMEBASE,BLI_VOLUMEFACT,
												  BLI_PUHT,TVA_ID,BLI_MHT,BLI_MTTVA,BLI_MTTC,BLI_STARTDT,BLI_ENDDT,VOW_UNIT,BLI_NBUNITES,BLI_DETAIL,BLI_CANCEL,IMC_ID,IMP_ANALYTIQUE_ID,
												  BLI_PERIODEINIT,BLI_PERIODE,BLI_REVERSEDT,BLI_CREDT,BLI_UPDTDT,BLI_UPDTBY,MEU_ID,BLI_NAME_A,BLI_REVERSEBLIDEC_ID,BLI_REVERSEBLINUMBERDEC,BLI_REVERSEDECDT)
											values(New_Genbill.BIL_ID,null,v,null,V_ite_name,V_anneereel,V_ITE_ID,V_PTA_ID,V_PSL_RANK,null,1,1,facture_.fermeture/1000,V_tva_id,
													facture_.fermeture/1000,facture_.tvaferm/1000,(facture_.fermeture/1000)+(facture_.tvaferm/1000),New_genrun.RUN_STARTDT,V_FAC_DATECALCUL,V_VOW_UNIT,null,0,0,null,
													null,null,null,null,null,null,null,null,null,null,null,null);
						EXCEPTION WHEN OTHERS THEN
											BEGIN
											 insert into genbilline(BIL_ID,BLI_REVERSEBLI_ID,BLI_NUMBER,BLI_REVERSEBLINUMBER,BLI_NAME,BLI_EXERCICE,ITE_ID,PTA_ID,PSL_RANK,IMP_ID,BLI_VOLUMEBASE,BLI_VOLUMEFACT,
																	BLI_PUHT,TVA_ID,BLI_MHT,BLI_MTTVA,BLI_MTTC,BLI_STARTDT,BLI_ENDDT,VOW_UNIT,BLI_NBUNITES,BLI_DETAIL,BLI_CANCEL,IMC_ID,IMP_ANALYTIQUE_ID,
																	BLI_PERIODEINIT,BLI_PERIODE,BLI_REVERSEDT,BLI_CREDT,BLI_UPDTDT,BLI_UPDTBY,MEU_ID,BLI_NAME_A,BLI_REVERSEBLIDEC_ID,BLI_REVERSEBLINUMBERDEC,BLI_REVERSEDECDT)
													values(New_Genbill.BIL_ID,null,	v+1,null,V_ite_name,V_anneereel,V_ITE_ID,V_PTA_ID,V_PSL_RANK,null,1,1,facture_.fermeture/1000,V_tva_id,
														  facture_.fermeture/1000,facture_.tvaferm/1000,(facture_.fermeture/1000)+(facture_.tvaferm/1000),New_genrun.RUN_STARTDT,V_FAC_DATECALCUL,V_VOW_UNIT,null,0,0,null,
														  null,null,null,null,null,null,null,null,null,null,null,null);
											EXCEPTION WHEN OTHERS THEN NULL;
											END;
						END;
						commit;
				end if;
-------------------------------------------------------------------------------------------
-----------------------------------Frais de déplacement---------------------------------------
-------------------------------------------------------------------------------------------		
				if to_number(facture_.deplacement) <> 0 then  
					 v := v+1;
						V_PTA_ID := null;
						V_PSL_RANK := null;
						begin
						v_code:='F_DEPLACEMNT';
							for x in C_ITEM(v_code) loop
							V_ITE_ID:=x.ite_id;
							V_ite_name:=x.ite_name
							V_VOW_UNIT:=x.VOW_UNIT
							end loop;
						EXCEPTION WHEN NO_DATA_FOUND THEN NULL;
						end;
						begin
						v_tva_taux:= 18;
							for v in C_TVA(v_tva_taux) loop
							   V_tva_id:=v.tva_id; 
							end loop;
						EXCEPTION WHEN NO_DATA_FOUND THEN 
						V_tva_id := 25;
						end;
						select count(*) 
						into V_nbr 
						from genptaslice 
						where PTA_ID in (select PTA_ID 	from genitemperiodtarif 
										 where TAR_id in ( select tar_id from genitemtarif where ITE_ID=V_ITE_ID )
										);
						if V_nbr =1 then
							select PTA_ID,PSL_RANK  
							into V_PTA_ID,V_PSL_RANK 
							from genptaslice 
							where PTA_ID in (select PTA_ID 
											 from genitemperiodtarif 
											 where TAR_id in (select tar_id from genitemtarif where ITE_ID=V_ITE_ID)
											)
							and rownum=1;
						end if;
						if V_nbr >1 then
							select PTA_ID,PSL_RANK  
							into V_PTA_ID,V_PSL_RANK 
							from genptaslice 
							where   PTA_ID
							in (select PTA_ID 
								from genitemperiodtarif
								where TAR_id in (select tar_id from genitemtarif where ITE_ID=V_ITE_ID) 
							   )and rownum=1;
						end if;
						BEGIN
							 insert into genbilline(BIL_ID,BLI_REVERSEBLI_ID,BLI_NUMBER,BLI_REVERSEBLINUMBER,BLI_NAME,BLI_EXERCICE,ITE_ID,PTA_ID,PSL_RANK,IMP_ID,BLI_VOLUMEBASE,BLI_VOLUMEFACT,
													BLI_PUHT,TVA_ID,BLI_MHT,BLI_MTTVA,BLI_MTTC,BLI_STARTDT,BLI_ENDDT,VOW_UNIT,BLI_NBUNITES,BLI_DETAIL,BLI_CANCEL,IMC_ID,IMP_ANALYTIQUE_ID,
													BLI_PERIODEINIT,BLI_PERIODE,BLI_REVERSEDT,BLI_CREDT,BLI_UPDTDT,BLI_UPDTBY,MEU_ID,BLI_NAME_A,BLI_REVERSEBLIDEC_ID,BLI_REVERSEBLINUMBERDEC,BLI_REVERSEDECDT)
											values(New_Genbill.BIL_ID,null,v,null,V_ite_name,V_anneereel,V_ITE_ID,V_PTA_ID,V_PSL_RANK,null,1,1,facture_.deplacement/1000,V_tva_id,
													facture_.deplacement/1000,facture_.tvadeplac/1000,(facture_.deplacement/1000)+(facture_.tvadeplac/1000),New_genrun.RUN_STARTDT,V_FAC_DATECALCUL,V_VOW_UNIT,null,0,0,null,
													null,null,null,null,null,null,null,null,null,null,null,null);
						EXCEPTION WHEN OTHERS THEN
											BEGIN
											 insert into genbilline(BIL_ID,BLI_REVERSEBLI_ID,BLI_NUMBER,BLI_REVERSEBLINUMBER,BLI_NAME,BLI_EXERCICE,ITE_ID,PTA_ID,PSL_RANK,IMP_ID,BLI_VOLUMEBASE,BLI_VOLUMEFACT,
																	BLI_PUHT,TVA_ID,BLI_MHT,BLI_MTTVA,BLI_MTTC,BLI_STARTDT,BLI_ENDDT,VOW_UNIT,BLI_NBUNITES,BLI_DETAIL,BLI_CANCEL,IMC_ID,IMP_ANALYTIQUE_ID,
																	BLI_PERIODEINIT,BLI_PERIODE,BLI_REVERSEDT,BLI_CREDT,BLI_UPDTDT,BLI_UPDTBY,MEU_ID,BLI_NAME_A,BLI_REVERSEBLIDEC_ID,BLI_REVERSEBLINUMBERDEC,BLI_REVERSEDECDT)
															 values(New_Genbill.BIL_ID,null,v+1,null,V_ite_name,V_anneereel,V_ITE_ID,V_PTA_ID,V_PSL_RANK,null,1,1,facture_.deplacement/1000,V_tva_id,
																	facture_.deplacement/1000,facture_.tvadeplac/1000,(facture_.deplacement/1000)+(facture_.tvadeplac/1000),New_genrun.RUN_STARTDT,V_FAC_DATECALCUL,V_VOW_UNIT,null,0,0,null,
																	 null,null,null,null,null,null,null,null,null,null,null,null);
											EXCEPTION WHEN OTHERS THEN NULL;
											END;
							END;
							commit;
				end if;
	
-------------------------------------------------------------------------------------------
-----------------------------------Frais de dépose suite à la demande du client---------------------------------------
-------------------------------------------------------------------------------------------	
				if to_number(facture_.depose_dem) <> 0 then  
					v := v+1;
						V_PTA_ID := null;
						V_PSL_RANK := null;
						begin
						v_code:='FRAIS_FRM_DEP';
							for x in C_ITEM(v_code) loop
							V_ITE_ID:=x.ite_id;
							V_ite_name:=x.ite_name
							V_VOW_UNIT:=x.VOW_UNIT
							end loop;
						EXCEPTION WHEN NO_DATA_FOUND THEN NULL;
						end;
						begin
						v_tva_taux:= 18;
							for v in C_TVA(v_tva_taux) loop
							   V_tva_id:=v.tva_id; 
							end loop;
						EXCEPTION WHEN NO_DATA_FOUND THEN 
						V_tva_id := 25;
						end;
						select count(*) 
						into V_nbr 
						from genptaslice 
						where PTA_ID in (select PTA_ID 	from genitemperiodtarif 
										 where TAR_id in ( select tar_id from genitemtarif where ITE_ID=V_ITE_ID )
										);
						if V_nbr =1 then
						
							select PTA_ID,PSL_RANK  
							into V_PTA_ID,V_PSL_RANK 
							from genptaslice 
							where PTA_ID in (select PTA_ID 
											 from genitemperiodtarif 
											 where TAR_id in (select tar_id from genitemtarif where ITE_ID=V_ITE_ID)
											)
							and rownum=1;
						end if;
						if V_nbr >1 then
							select PTA_ID,PSL_RANK  
							into V_PTA_ID,V_PSL_RANK 
							from genptaslice 
							where   PTA_ID
							in (select PTA_ID 
								from genitemperiodtarif
								where TAR_id in (select tar_id from genitemtarif where ITE_ID=V_ITE_ID) 
							   )and rownum=1;
						end if;

						BEGIN
							insert into genbilline(BIL_ID,BLI_REVERSEBLI_ID,BLI_NUMBER,BLI_REVERSEBLINUMBER,BLI_NAME,BLI_EXERCICE,ITE_ID,PTA_ID,PSL_RANK,IMP_ID,BLI_VOLUMEBASE,BLI_VOLUMEFACT,
												   BLI_PUHT,TVA_ID,BLI_MHT,BLI_MTTVA,BLI_MTTC,BLI_STARTDT,BLI_ENDDT,VOW_UNIT,BLI_NBUNITES,BLI_DETAIL,BLI_CANCEL,IMC_ID,IMP_ANALYTIQUE_ID,
												   BLI_PERIODEINIT,BLI_PERIODE,BLI_REVERSEDT,BLI_CREDT,BLI_UPDTDT,BLI_UPDTBY,MEU_ID,BLI_NAME_A,BLI_REVERSEBLIDEC_ID,BLI_REVERSEBLINUMBERDEC,BLI_REVERSEDECDT)
											values(New_Genbill.BIL_ID,null,v,null,V_ite_name,V_anneereel,V_ITE_ID,V_PTA_ID,V_PSL_RANK,null,1,1,facture_.depose_dem/1000,V_tva_id,
													facture_.depose_dem/1000,facture_.tvadepose_dem/1000,facture_.depose_dem/1000 + (facture_.tvadepose_dem/1000),New_genrun.RUN_STARTDT,V_FAC_DATECALCUL,V_VOW_UNIT,null,0,0,null,
													null,null,null,null,null,null,null,null,null,null,null,null);
						EXCEPTION WHEN OTHERS THEN
											BEGIN
											 insert into genbilline(BIL_ID,BLI_REVERSEBLI_ID,BLI_NUMBER,BLI_REVERSEBLINUMBER,BLI_NAME,BLI_EXERCICE,ITE_ID,PTA_ID,PSL_RANK,IMP_ID,BLI_VOLUMEBASE,BLI_VOLUMEFACT,
														   BLI_PUHT,TVA_ID,BLI_MHT,BLI_MTTVA,BLI_MTTC,BLI_STARTDT,BLI_ENDDT,VOW_UNIT,BLI_NBUNITES,BLI_DETAIL,BLI_CANCEL,IMC_ID,IMP_ANALYTIQUE_ID,
														   BLI_PERIODEINIT,BLI_PERIODE,BLI_REVERSEDT,BLI_CREDT,BLI_UPDTDT,BLI_UPDTBY,MEU_ID,BLI_NAME_A,BLI_REVERSEBLIDEC_ID,BLI_REVERSEBLINUMBERDEC,BLI_REVERSEDECDT)
													values(New_Genbill.BIL_ID,null,v+1,null,V_ite_name,V_anneereel,V_ITE_ID,V_PTA_ID,V_PSL_RANK,null,1,1,facture_.depose_dem/1000,V_tva_id,
													facture_.depose_dem/1000,facture_.tvadepose_dem/1000,facture_.depose_dem/1000 + (facture_.tvadepose_dem/1000),New_genrun.RUN_STARTDT,V_FAC_DATECALCUL,V_VOW_UNIT,null,0,0,null,
													null,null,null,null,null,null,null,null,null,null,null,null);
											EXCEPTION WHEN OTHERS THEN NULL;
											END;
						END;
						commit;
				end if;
				
-------------------------------------------------------------------------------------------
-----------------------------------FRAIS DE DÉPOSE SUITE AU NON PAIEMENT---------------------------------------
-------------------------------------------------------------------------------------------	
				if to_number(facture_.depose_def) <> 0 then  
					v := v+1;
						V_PTA_ID := null;
						V_PSL_RANK := null;
						begin
						v_code:='FRS_DPOZ_RPOZ';
							for x in C_ITEM(v_code) loop
							V_ITE_ID:=x.ite_id;
							V_ite_name:=x.ite_name
							V_VOW_UNIT:=x.VOW_UNIT
							end loop;
						EXCEPTION WHEN NO_DATA_FOUND THEN NULL;
						end;
						begin
						v_tva_taux:= 18;
							for v in C_TVA(v_tva_taux) loop
							   V_tva_id:=v.tva_id; 
							end loop;
						EXCEPTION WHEN NO_DATA_FOUND THEN 
						V_tva_id := 25;
						end;

						select count(*) 
						into V_nbr 
						from genptaslice 
						where PTA_ID in (select PTA_ID 	from genitemperiodtarif 
										 where TAR_id in ( select tar_id from genitemtarif where ITE_ID=V_ITE_ID )
										);
						if V_nbr =1 then
						
							select PTA_ID,PSL_RANK  
							into V_PTA_ID,V_PSL_RANK 
							from genptaslice 
							where PTA_ID in (select PTA_ID 
											 from genitemperiodtarif 
											 where TAR_id in (select tar_id from genitemtarif where ITE_ID=V_ITE_ID)
											)
							and rownum=1;
						end if;
						if V_nbr >1 then
							select PTA_ID,PSL_RANK  
							into V_PTA_ID,V_PSL_RANK 
							from genptaslice 
							where  PTA_ID
							in (select PTA_ID 
								from genitemperiodtarif
								where TAR_id in (select tar_id from genitemtarif where ITE_ID=V_ITE_ID) 
							   )
							 and rownum=1;
						end if;
						BEGIN
							insert into genbilline(BIL_ID,BLI_REVERSEBLI_ID,BLI_NUMBER,BLI_REVERSEBLINUMBER,BLI_NAME,BLI_EXERCICE,ITE_ID,PTA_ID,PSL_RANK,IMP_ID,BLI_VOLUMEBASE,BLI_VOLUMEFACT,
													BLI_PUHT,TVA_ID,BLI_MHT,BLI_MTTVA,BLI_MTTC,BLI_STARTDT,BLI_ENDDT,VOW_UNIT,BLI_NBUNITES,BLI_DETAIL,BLI_CANCEL,IMC_ID,IMP_ANALYTIQUE_ID,
													BLI_PERIODEINIT,BLI_PERIODE,BLI_REVERSEDT,BLI_CREDT,BLI_UPDTDT,BLI_UPDTBY,MEU_ID,BLI_NAME_A,BLI_REVERSEBLIDEC_ID,BLI_REVERSEBLINUMBERDEC,BLI_REVERSEDECDT)
											values(New_Genbill.BIL_ID,null,v,null,V_ite_name,V_anneereel,V_ITE_ID,V_PTA_ID,V_PSL_RANK,null,1,1,facture_.depose_def/1000,V_tva_id,
													facture_.depose_def/1000,facture_.tvadepose_def/1000,facture_.depose_def/1000 + (facture_.tvadepose_def/1000),New_genrun.RUN_STARTDT,V_FAC_DATECALCUL,V_VOW_UNIT,null,0,	0,null,
													null,null,null,null,null,null,null,null,null,null,null,null);				 
													);
						EXCEPTION WHEN OTHERS THEN
											BEGIN
											insert into genbilline(BIL_ID,BLI_REVERSEBLI_ID,BLI_NUMBER,BLI_REVERSEBLINUMBER,BLI_NAME,BLI_EXERCICE,ITE_ID,PTA_ID,PSL_RANK,IMP_ID,BLI_VOLUMEBASE,BLI_VOLUMEFACT,
														           BLI_PUHT,TVA_ID,BLI_MHT,BLI_MTTVA,BLI_MTTC,BLI_STARTDT,BLI_ENDDT,VOW_UNIT,BLI_NBUNITES,BLI_DETAIL,BLI_CANCEL,IMC_ID,IMP_ANALYTIQUE_ID,
														           BLI_PERIODEINIT,BLI_PERIODE,BLI_REVERSEDT,BLI_CREDT,BLI_UPDTDT,BLI_UPDTBY,MEU_ID,BLI_NAME_A,BLI_REVERSEBLIDEC_ID,BLI_REVERSEBLINUMBERDEC,BLI_REVERSEDECDT)
													values(New_Genbill.BIL_ID,null,v+1,null,V_ite_name,V_anneereel,V_ITE_ID,V_PTA_ID,V_PSL_RANK,null,1,1,facture_.depose_def/1000,V_tva_id,
														  facture_.depose_def/1000,facture_.tvadepose_def/1000,facture_.depose_def/1000 + (facture_.tvadepose_def/1000),New_genrun.RUN_STARTDT,V_FAC_DATECALCUL,V_VOW_UNIT,null,0,	0,null,
														  null,null,null,null,null,null,null,null,null,null,null,null);				 
											EXCEPTION WHEN OTHERS THEN NULL;
											END;
						END;
						commit;
				end if;	
	
-------------------------------------------------------------------------------------------
-----------------------------------MONTANT CAPITAL---------------------------------------
-------------------------------------------------------------------------------------------	
				if to_number(facture_.CAPIT) <> 0 then
					v := v+1;
						V_PTA_ID := null;
						V_PSL_RANK := null;
						begin
						v_code:='CAPITAL';
							for x in C_ITEM(v_code) loop
							V_ITE_ID:=x.ite_id;
							V_ite_name:=x.ite_name
							V_VOW_UNIT:=x.VOW_UNIT
							end loop;
						EXCEPTION WHEN NO_DATA_FOUND THEN NULL;
						end;
						begin
						v_tva_taux:=0;
							for v in C_TVA(v_tva_taux) loop
							   V_tva_id:=v.tva_id; 
							end loop;
						EXCEPTION WHEN NO_DATA_FOUND THEN 
						V_tva_id := 25;
						end;
						select count(*) 
						into V_nbr 
						from genptaslice 
						where PTA_ID in (select PTA_ID 	from genitemperiodtarif 
										 where TAR_id in ( select tar_id from genitemtarif where ITE_ID=V_ITE_ID )
										);
						if V_nbr =1 then
						
							select PTA_ID,PSL_RANK  
							into V_PTA_ID,V_PSL_RANK 
							from genptaslice 
							where PTA_ID in (select PTA_ID 
											 from genitemperiodtarif 
											 where TAR_id in (select tar_id from genitemtarif where ITE_ID=V_ITE_ID)
											)
							and rownum=1;
						end if;
						if V_nbr >1 then
							select PTA_ID,PSL_RANK  
							into V_PTA_ID,V_PSL_RANK 
							from genptaslice 
							where   PTA_ID
							in (select PTA_ID 
								from genitemperiodtarif
								where TAR_id in (select tar_id from genitemtarif where ITE_ID=V_ITE_ID) 
							   )and rownum=1;
						end if;
						BEGIN
							insert into genbilline(BIL_ID,BLI_REVERSEBLI_ID,BLI_NUMBER,BLI_REVERSEBLINUMBER,BLI_NAME,BLI_EXERCICE,ITE_ID,PTA_ID,PSL_RANK,IMP_ID,BLI_VOLUMEBASE,BLI_VOLUMEFACT,
												 BLI_PUHT,TVA_ID,BLI_MHT,BLI_MTTVA,BLI_MTTC,BLI_STARTDT,BLI_ENDDT,VOW_UNIT,BLI_NBUNITES,BLI_DETAIL,BLI_CANCEL,IMC_ID,IMP_ANALYTIQUE_ID,
												 BLI_PERIODEINIT,BLI_PERIODE,BLI_REVERSEDT,BLI_CREDT,BLI_UPDTDT,BLI_UPDTBY,MEU_ID,BLI_NAME_A,BLI_REVERSEBLIDEC_ID,BLI_REVERSEBLINUMBERDEC,BLI_REVERSEDECDT)
											values(New_Genbill.BIL_ID,null,v,null,V_ite_name,V_anneereel,V_ITE_ID,V_PTA_ID,V_PSL_RANK,null,1,1,facture_.CAPIT/1000	,V_tva_id,
													facture_.CAPIT/1000,facture_.tva_capit/1000,facture_.CAPIT/1000,New_genrun.RUN_STARTDT,V_FAC_DATECALCUL,V_VOW_UNIT,null,0,0,null,
													null,null,null,null,null,null,null,null,null,null,null,null	);
						EXCEPTION WHEN OTHERS THEN
											BEGIN
											 insert into genbilline(BIL_ID,BLI_REVERSEBLI_ID,BLI_NUMBER,BLI_REVERSEBLINUMBER,BLI_NAME,BLI_EXERCICE,ITE_ID,PTA_ID,PSL_RANK,IMP_ID,BLI_VOLUMEBASE,BLI_VOLUMEFACT,
														   BLI_PUHT,TVA_ID,BLI_MHT,BLI_MTTVA,BLI_MTTC,BLI_STARTDT,BLI_ENDDT,VOW_UNIT,BLI_NBUNITES,BLI_DETAIL,BLI_CANCEL,IMC_ID,IMP_ANALYTIQUE_ID,
														   BLI_PERIODEINIT,BLI_PERIODE,BLI_REVERSEDT,BLI_CREDT,BLI_UPDTDT,BLI_UPDTBY,MEU_ID,BLI_NAME_A,BLI_REVERSEBLIDEC_ID,BLI_REVERSEBLINUMBERDEC,BLI_REVERSEDECDT)
													values(New_Genbill.BIL_ID,null,v+1,null,V_ite_name,V_anneereel,V_ITE_ID,V_PTA_ID,V_PSL_RANK,null,1,1,facture_.CAPIT/1000	,V_tva_id,
														  facture_.CAPIT/1000,facture_.tva_capit/1000,facture_.CAPIT/1000,New_genrun.RUN_STARTDT,V_FAC_DATECALCUL,V_VOW_UNIT,null,0,0,null,
														  null,null,null,null,null,null,null,null,null,null,null,null	);
											EXCEPTION WHEN OTHERS THEN NULL;
											END;
					   END;
					   commit;
				end if;	
-------------------------------------------------------------------------------------------
-----------------------------------Montant Interet---------------------------------------
-------------------------------------------------------------------------------------------	
				if to_number(facture_.INTER) <> 0 then
					v := v+1;
						V_PTA_ID := null;
						V_PSL_RANK := null;
						begin
						v_code:='INTERET';
							for x in C_ITEM(v_code) loop
							V_ITE_ID:=x.ite_id;
							V_ite_name:=x.ite_name
							V_VOW_UNIT:=x.VOW_UNIT
							end loop;
						EXCEPTION WHEN NO_DATA_FOUND THEN NULL;
						end;
						begin
						v_tva_taux:=0;
							for v in C_TVA(v_tva_taux) loop
							   V_tva_id:=v.tva_id; 
							end loop;
						EXCEPTION WHEN NO_DATA_FOUND THEN 
						V_tva_id := 25;
						end;
						select count(*) 
						into V_nbr 
						from genptaslice 
						where PTA_ID in (select PTA_ID 	from genitemperiodtarif 
										 where TAR_id in ( select tar_id from genitemtarif where ITE_ID=V_ITE_ID )
										);
						if V_nbr =1 then
						
							select PTA_ID,PSL_RANK  
							into V_PTA_ID,V_PSL_RANK 
							from genptaslice 
							where PTA_ID in (select PTA_ID 
											 from genitemperiodtarif 
											 where TAR_id in (select tar_id from genitemtarif where ITE_ID=V_ITE_ID)
											)
							and rownum=1;
						end if;
						if V_nbr >1 then
							select PTA_ID,PSL_RANK  
							into V_PTA_ID,V_PSL_RANK 
							from genptaslice 
							where   PTA_ID
							in (select PTA_ID 
								from genitemperiodtarif
								where TAR_id in (select tar_id from genitemtarif where ITE_ID=V_ITE_ID) 
							   )and rownum=1;
						 
						end if;

						BEGIN
							insert into genbilline(BIL_ID,BLI_REVERSEBLI_ID,BLI_NUMBER,BLI_REVERSEBLINUMBER,BLI_NAME,BLI_EXERCICE,ITE_ID,PTA_ID,PSL_RANK,IMP_ID,BLI_VOLUMEBASE,BLI_VOLUMEFACT,
												  BLI_PUHT,TVA_ID,BLI_MHT,BLI_MTTVA,BLI_MTTC,BLI_STARTDT,BLI_ENDDT,VOW_UNIT,BLI_NBUNITES,BLI_DETAIL,BLI_CANCEL,IMC_ID,IMP_ANALYTIQUE_ID,
												  BLI_PERIODEINIT,BLI_PERIODE,BLI_REVERSEDT,BLI_CREDT,BLI_UPDTDT,BLI_UPDTBY,MEU_ID,BLI_NAME_A,BLI_REVERSEBLIDEC_ID,BLI_REVERSEBLINUMBERDEC,BLI_REVERSEDECDT)
											values(New_Genbill.BIL_ID,null,v,null,V_ite_name,V_anneereel,V_ITE_ID,V_PTA_ID,V_PSL_RANK,null,1,1,facture_.INTER/1000,V_tva_id,
													facture_.INTER/1000,0,facture_.INTER/1000,New_genrun.RUN_STARTDT,V_FAC_DATECALCUL,V_VOW_UNIT,null,0,0,null,
													null,null,null,null,null,null,null,null,null,null,null,null);
						EXCEPTION WHEN OTHERS THEN
											BEGIN
											insert into genbilline(BIL_ID,BLI_REVERSEBLI_ID,BLI_NUMBER,BLI_REVERSEBLINUMBER,BLI_NAME,BLI_EXERCICE,ITE_ID,PTA_ID,PSL_RANK,IMP_ID,BLI_VOLUMEBASE,BLI_VOLUMEFACT,
																   BLI_PUHT,TVA_ID,BLI_MHT,BLI_MTTVA,BLI_MTTC,BLI_STARTDT,BLI_ENDDT,VOW_UNIT,BLI_NBUNITES,BLI_DETAIL,BLI_CANCEL,IMC_ID,IMP_ANALYTIQUE_ID,
																   BLI_PERIODEINIT,BLI_PERIODE,BLI_REVERSEDT,BLI_CREDT,BLI_UPDTDT,BLI_UPDTBY,MEU_ID,BLI_NAME_A,BLI_REVERSEBLIDEC_ID,BLI_REVERSEBLINUMBERDEC,BLI_REVERSEDECDT)
															values(New_Genbill.BIL_ID,null,v+1,null,V_ite_name,V_anneereel,V_ITE_ID,V_PTA_ID,V_PSL_RANK,null,1,1,facture_.INTER/1000,V_tva_id,
																  facture_.INTER/1000,0,facture_.INTER/1000,New_genrun.RUN_STARTDT,V_FAC_DATECALCUL,V_VOW_UNIT,null,0,0,null,
																 null,null,null,null,null,null,null,null,null,null,null,null);
											EXCEPTION WHEN OTHERS THEN NULL;
											END;
						END;
						commit;
				end if;	
				
-------------------------------------------------------------------------------------------
-----------------------------------MONTANT BRANCHEMENT---------------------------------------
-------------------------------------------------------------------------------------------	
				if to_number(facture_.RBRANCHE) <> 0 then
					v := v+1;
						V_PTA_ID   := null;
						V_PSL_RANK := null;
						begin
						v_code:='COURETABBR';
							for x in C_ITEM(v_code) loop
							V_ITE_ID:=x.ite_id;
							V_ite_name:=x.ite_name
							V_VOW_UNIT:=x.VOW_UNIT
							end loop;
						EXCEPTION WHEN NO_DATA_FOUND THEN NULL;
						end;
						begin
						v_tva_taux:= 0;
							for v in C_TVA(v_tva_taux) loop
							   V_tva_id:=v.tva_id; 
							end loop;
						EXCEPTION WHEN NO_DATA_FOUND THEN 
						V_tva_id := 25;
						end;
						select count(*) 
						into V_nbr 
						from genptaslice 
						where PTA_ID in (select PTA_ID 	from genitemperiodtarif 
										 where TAR_id in ( select tar_id from genitemtarif where ITE_ID=V_ITE_ID )
										);
						if V_nbr =1 then
						
							select PTA_ID,PSL_RANK  
							into V_PTA_ID,V_PSL_RANK 
							from genptaslice 
							where PTA_ID in (select PTA_ID 
											 from genitemperiodtarif 
											 where TAR_id in (select tar_id from genitemtarif where ITE_ID=V_ITE_ID)
											)
							and rownum=1;
						end if;
						if V_nbr >1 then
							select PTA_ID,PSL_RANK  
							into V_PTA_ID,V_PSL_RANK 
							from genptaslice 
							where   PTA_ID
							in (select PTA_ID 
								from genitemperiodtarif
								where TAR_id in (select tar_id from genitemtarif where ITE_ID=V_ITE_ID) 
							   )and rownum=1;
						end if;

						BEGIN
							insert into genbilline(BIL_ID,BLI_REVERSEBLI_ID,BLI_NUMBER,BLI_REVERSEBLINUMBER,BLI_NAME,BLI_EXERCICE,ITE_ID,PTA_ID,PSL_RANK,IMP_ID,BLI_VOLUMEBASE,BLI_VOLUMEFACT,
												   BLI_PUHT,TVA_ID,BLI_MHT,BLI_MTTVA,BLI_MTTC,BLI_STARTDT,BLI_ENDDT,VOW_UNIT,BLI_NBUNITES,BLI_DETAIL,BLI_CANCEL,IMC_ID,IMP_ANALYTIQUE_ID,
												   BLI_PERIODEINIT,BLI_PERIODE,BLI_REVERSEDT,BLI_CREDT,BLI_UPDTDT,BLI_UPDTBY,MEU_ID,BLI_NAME_A,BLI_REVERSEBLIDEC_ID,BLI_REVERSEBLINUMBERDEC,BLI_REVERSEDECDT)
											values(New_Genbill.BIL_ID,null,v,null,V_ite_name,V_anneereel,V_ITE_ID,V_PTA_ID,V_PSL_RANK,null,1,1,facture_.RBRANCHE/1000,V_tva_id,
													facture_.RBRANCHE/1000,0,facture_.RBRANCHE/1000,New_genrun.RUN_STARTDT,V_FAC_DATECALCUL,V_VOW_UNIT,null,0,0,null,
													null,null,null,null,null,null,null,null,null,null,null,null);
						EXCEPTION WHEN OTHERS THEN
											BEGIN
											insert into genbilline(BIL_ID,BLI_REVERSEBLI_ID,BLI_NUMBER,BLI_REVERSEBLINUMBER,BLI_NAME,BLI_EXERCICE,ITE_ID,PTA_ID,PSL_RANK,IMP_ID,BLI_VOLUMEBASE,BLI_VOLUMEFACT,
																   BLI_PUHT,TVA_ID,BLI_MHT,BLI_MTTVA,BLI_MTTC,BLI_STARTDT,BLI_ENDDT,VOW_UNIT,BLI_NBUNITES,BLI_DETAIL,BLI_CANCEL,IMC_ID,IMP_ANALYTIQUE_ID,
																   BLI_PERIODEINIT,BLI_PERIODE,BLI_REVERSEDT,BLI_CREDT,BLI_UPDTDT,BLI_UPDTBY,MEU_ID,BLI_NAME_A,BLI_REVERSEBLIDEC_ID,BLI_REVERSEBLINUMBERDEC,BLI_REVERSEDECDT)
															values(New_Genbill.BIL_ID,null,v+1,null,V_ite_name,V_anneereel,V_ITE_ID,V_PTA_ID,V_PSL_RANK,null,1,1,facture_.RBRANCHE/1000,V_tva_id,
																	facture_.RBRANCHE/1000,0,facture_.RBRANCHE/1000,New_genrun.RUN_STARTDT,V_FAC_DATECALCUL,V_VOW_UNIT,null,0,0,null,
																	null,null,null,null,null,null,null,null,null,null,null,null);
											EXCEPTION WHEN OTHERS THEN NULL;
											END;
						END;
						commit;
				end if;
	
-------------------------------------------------------------------------------------------
-----------------------------------PRODUIT FINANCIER---------------------------------------
-------------------------------------------------------------------------------------------	
				if to_number(facture_.PFINANCIER) <> 0 then
					v := v+1;
						V_PTA_ID := null;
						V_PSL_RANK := null;
						begin
						v_code:='PFINANCIER';
							for x in C_ITEM(v_code) loop
							V_ITE_ID:=x.ite_id;
							V_ite_name:=x.ite_name
							V_VOW_UNIT:=x.VOW_UNIT
							end loop;
						EXCEPTION WHEN NO_DATA_FOUND THEN NULL;
						end;
						begin
						v_tva_taux:= 0;
							for v in C_TVA(v_tva_taux) loop
							   V_tva_id:=v.tva_id; 
							end loop;
						EXCEPTION WHEN NO_DATA_FOUND THEN 
						V_tva_id := 25;
						end;
						select count(*) 
						into V_nbr 
						from genptaslice 
						where PTA_ID in (select PTA_ID 	from genitemperiodtarif 
										 where TAR_id in ( select tar_id from genitemtarif where ITE_ID=V_ITE_ID )
										);
						if V_nbr =1 then
						   select PTA_ID,PSL_RANK  
							into V_PTA_ID,V_PSL_RANK 
							from genptaslice 
							where PTA_ID in (select PTA_ID 
											 from genitemperiodtarif 
											 where TAR_id in (select tar_id from genitemtarif where ITE_ID=V_ITE_ID)
											)
							and rownum=1;
						end if;
						if V_nbr >1 then
							select PTA_ID,PSL_RANK  
							into V_PTA_ID,V_PSL_RANK 
							from genptaslice 
							where   PTA_ID
							in (select PTA_ID 
								from genitemperiodtarif
								where TAR_id in (select tar_id from genitemtarif where ITE_ID=V_ITE_ID) 
							   )and rownum=1;
						end if;
						BEGIN
							insert into genbilline(BIL_ID,BLI_REVERSEBLI_ID,BLI_NUMBER,BLI_REVERSEBLINUMBER,BLI_NAME,BLI_EXERCICE,ITE_ID,PTA_ID,PSL_RANK,IMP_ID,BLI_VOLUMEBASE,BLI_VOLUMEFACT,
												   BLI_PUHT,TVA_ID,BLI_MHT,BLI_MTTVA,BLI_MTTC,BLI_STARTDT,BLI_ENDDT,VOW_UNIT,BLI_NBUNITES,BLI_DETAIL,BLI_CANCEL,IMC_ID,IMP_ANALYTIQUE_ID,
												   BLI_PERIODEINIT,BLI_PERIODE,BLI_REVERSEDT,BLI_CREDT,BLI_UPDTDT,BLI_UPDTBY,MEU_ID,BLI_NAME_A,BLI_REVERSEBLIDEC_ID,BLI_REVERSEBLINUMBERDEC,BLI_REVERSEDECDT)
											values(New_Genbill.BIL_ID,null,v,null,V_ite_name,V_anneereel,V_ITE_ID,V_PTA_ID,V_PSL_RANK,null,1,1,facture_.PFINANCIER/1000,V_tva_id,
													facture_.PFINANCIER/1000,facture_.tva_pfin/1000,facture_.PFINANCIER/1000,New_genrun.RUN_STARTDT,V_FAC_DATECALCUL,V_VOW_UNIT,null,0,0,null,
													null,null,null,null,null,null,null,null,null,null,null,null);
						EXCEPTION WHEN OTHERS THEN
											BEGIN
											insert into genbilline(BIL_ID,BLI_REVERSEBLI_ID,BLI_NUMBER,BLI_REVERSEBLINUMBER,BLI_NAME,BLI_EXERCICE,ITE_ID,PTA_ID,PSL_RANK,IMP_ID,BLI_VOLUMEBASE,BLI_VOLUMEFACT,
														   BLI_PUHT,TVA_ID,BLI_MHT,BLI_MTTVA,BLI_MTTC,BLI_STARTDT,BLI_ENDDT,VOW_UNIT,BLI_NBUNITES,BLI_DETAIL,BLI_CANCEL,IMC_ID,IMP_ANALYTIQUE_ID,
														   BLI_PERIODEINIT,BLI_PERIODE,BLI_REVERSEDT,BLI_CREDT,BLI_UPDTDT,BLI_UPDTBY,MEU_ID,BLI_NAME_A,BLI_REVERSEBLIDEC_ID,BLI_REVERSEBLINUMBERDEC,BLI_REVERSEDECDT)
													values(New_Genbill.BIL_ID,null,v+1,null,V_ite_name,V_anneereel,V_ITE_ID,V_PTA_ID,V_PSL_RANK,null,1,1,facture_.PFINANCIER/1000,V_tva_id,
															facture_.PFINANCIER/1000,facture_.tva_pfin/1000,facture_.PFINANCIER/1000,New_genrun.RUN_STARTDT,V_FAC_DATECALCUL,V_VOW_UNIT,null,0,0,null,
															null,null,null,null,null,null,null,null,null,null,null,null);
											EXCEPTION WHEN OTHERS THEN NULL;
											END;
						END;
						commit;
				end if;	
	
-------------------------------------------------------------------------------------------
-----------------------------------MONTANT REPORT---------------------------------------
-------------------------------------------------------------------------------------------	
				if to_number(facture_.AREPOR) <> 0 then
					v := v+1;
						V_PTA_ID := null;
						V_PSL_RANK := null;
						begin
						v_code:='AREPOR';
							for x in C_ITEM(v_code) loop
							V_ITE_ID:=x.ite_id;
							V_ite_name:=x.ite_name
							V_VOW_UNIT:=x.VOW_UNIT
						end loop;
						EXCEPTION WHEN NO_DATA_FOUND THEN NULL;
						end;
						begin
						v_tva_taux:= 0;
							for v in C_TVA(v_tva_taux) loop
							   V_tva_id:=v.tva_id; 
							end loop;
						EXCEPTION WHEN NO_DATA_FOUND THEN 
						V_tva_id := 25;
						end;
						select count(*) 
						into V_nbr 
						from genptaslice 
						where PTA_ID in (select PTA_ID 	from genitemperiodtarif 
										 where TAR_id in ( select tar_id from genitemtarif where ITE_ID=V_ITE_ID )
										);
						if V_nbr =1 then
						
							select PTA_ID,PSL_RANK  
							into V_PTA_ID,V_PSL_RANK 
							from genptaslice 
							where PTA_ID in (select PTA_ID 
											 from genitemperiodtarif 
											 where TAR_id in (select tar_id from genitemtarif where ITE_ID=V_ITE_ID)
											)
							and rownum=1;
						end if;
						if V_nbr >1 then
							select PTA_ID,PSL_RANK  
							into V_PTA_ID,V_PSL_RANK 
							from genptaslice 
							where   PTA_ID
							in (select PTA_ID 
								from genitemperiodtarif
								where TAR_id in (select tar_id from genitemtarif where ITE_ID=V_ITE_ID) 
							   )and rownum=1;
						end if;
						BEGIN
							insert into genbilline(BIL_ID,BLI_REVERSEBLI_ID,BLI_NUMBER,BLI_REVERSEBLINUMBER,BLI_NAME,BLI_EXERCICE,ITE_ID,PTA_ID,PSL_RANK,IMP_ID,BLI_VOLUMEBASE,BLI_VOLUMEFACT,
												   BLI_PUHT,TVA_ID,BLI_MHT,BLI_MTTVA,BLI_MTTC,BLI_STARTDT,BLI_ENDDT,VOW_UNIT,BLI_NBUNITES,BLI_DETAIL,BLI_CANCEL,IMC_ID,IMP_ANALYTIQUE_ID,
												   BLI_PERIODEINIT,BLI_PERIODE,BLI_REVERSEDT,BLI_CREDT,BLI_UPDTDT,BLI_UPDTBY,MEU_ID,BLI_NAME_A,BLI_REVERSEBLIDEC_ID,BLI_REVERSEBLINUMBERDEC,BLI_REVERSEDECDT)
											values(New_Genbill.BIL_ID,null,v,null,V_ite_name,V_anneereel,V_ITE_ID,V_PTA_ID,V_PSL_RANK,null,1,1,decode(facture_.caron,'1',1,-1)* (facture_.AREPOR/1000),V_tva_id,
													decode(facture_.caron,'1',1,-1)* (facture_.AREPOR/1000),0,decode(facture_.caron,'1',1,-1)* (facture_.AREPOR/1000),New_genrun.RUN_STARTDT,V_FAC_DATECALCUL,V_VOW_UNIT,null,0,0,null,
													null,null,null,null,null,null,null,null,null,null,null,null);				 
						EXCEPTION WHEN OTHERS THEN
											BEGIN
											insert into genbilline(BIL_ID,BLI_REVERSEBLI_ID,BLI_NUMBER,BLI_REVERSEBLINUMBER,BLI_NAME,BLI_EXERCICE,ITE_ID,PTA_ID,PSL_RANK,IMP_ID,BLI_VOLUMEBASE,BLI_VOLUMEFACT,
																	BLI_PUHT,TVA_ID,BLI_MHT,BLI_MTTVA,BLI_MTTC,BLI_STARTDT,BLI_ENDDT,VOW_UNIT,BLI_NBUNITES,BLI_DETAIL,BLI_CANCEL,IMC_ID,IMP_ANALYTIQUE_ID,
																	BLI_PERIODEINIT,BLI_PERIODE,BLI_REVERSEDT,BLI_CREDT,BLI_UPDTDT,BLI_UPDTBY,MEU_ID,BLI_NAME_A,BLI_REVERSEBLIDEC_ID,BLI_REVERSEBLINUMBERDEC,BLI_REVERSEDECDT)
													values(New_Genbill.BIL_ID,null,v+1,null,V_ite_name,V_anneereel,V_ITE_ID,V_PTA_ID,V_PSL_RANK,null,1,1,decode(facture_.caron,'1',1,-1)* (facture_.AREPOR/1000),V_tva_id,
															decode(facture_.caron,'1',1,-1)* (facture_.AREPOR/1000),0,decode(facture_.caron,'1',1,-1)* (facture_.AREPOR/1000),New_genrun.RUN_STARTDT,V_FAC_DATECALCUL,V_VOW_UNIT,null,0,0,null,
															null,null,null,null,null,null,null,null,null,null,null,null);	
											EXCEPTION WHEN OTHERS THEN NULL;
											END;
						END;
						commit;
				end if;	
-------------------------------------------------------------------------------------------
-----------------------------------ARRONDISSEMENT---------------------------------------
-------------------------------------------------------------------------------------------	
				if to_number(facture_.NAROND) <> 0 then
					v := v+1;
						V_PTA_ID := null;
						V_PSL_RANK := null;
						begin
						v_code:='NAROND';
							for x in C_ITEM(v_code) loop
							V_ITE_ID:=x.ite_id;
							V_ite_name:=x.ite_name
							V_VOW_UNIT:=x.VOW_UNIT
							end loop;
						EXCEPTION WHEN NO_DATA_FOUND THEN NULL;
						end;
						begin
						v_tva_taux:= 0;
							for v in C_TVA(v_tva_taux) loop
							   V_tva_id:=v.tva_id; 
							end loop;
						EXCEPTION WHEN NO_DATA_FOUND THEN 
						V_tva_id := 25;
						end;
						select count(*) 
						into V_nbr 
						from genptaslice 
						where PTA_ID in (select PTA_ID 	from genitemperiodtarif 
										 where TAR_id in ( select tar_id from genitemtarif where ITE_ID=V_ITE_ID )
										);
						if V_nbr =1 then
						
							select PTA_ID,PSL_RANK  
							into V_PTA_ID,V_PSL_RANK 
							from genptaslice 
							where PTA_ID in (select PTA_ID 
											 from genitemperiodtarif 
											 where TAR_id in (select tar_id from genitemtarif where ITE_ID=V_ITE_ID)
											)
							and rownum=1;
						end if;
						if V_nbr >1 then
							select PTA_ID,PSL_RANK  
							into V_PTA_ID,V_PSL_RANK 
							from genptaslice 
							where   PTA_ID
							in (select PTA_ID 
								from genitemperiodtarif
								where TAR_id in (select tar_id from genitemtarif where ITE_ID=V_ITE_ID) 
							   )and rownum=1;
						end if;
						BEGIN
							 insert into genbilline(BIL_ID,BLI_REVERSEBLI_ID,BLI_NUMBER,BLI_REVERSEBLINUMBER,BLI_NAME,BLI_EXERCICE,ITE_ID,PTA_ID,PSL_RANK,IMP_ID,BLI_VOLUMEBASE,BLI_VOLUMEFACT,
													BLI_PUHT,TVA_ID,BLI_MHT,BLI_MTTVA,BLI_MTTC,BLI_STARTDT,BLI_ENDDT,VOW_UNIT,BLI_NBUNITES,BLI_DETAIL,BLI_CANCEL,IMC_ID,IMP_ANALYTIQUE_ID,
													BLI_PERIODEINIT,BLI_PERIODE,BLI_REVERSEDT,BLI_CREDT,BLI_UPDTDT,BLI_UPDTBY,MEU_ID,BLI_NAME_A,BLI_REVERSEBLIDEC_ID,BLI_REVERSEBLINUMBERDEC,BLI_REVERSEDECDT)
											values(New_Genbill.BIL_ID,null,v,null,V_ite_name,V_anneereel,V_ITE_ID,V_PTA_ID,V_PSL_RANK,null,1,1,decode(facture_.caron,'1',-1,1)*(facture_.NAROND/1000),V_tva_id,
													decode(facture_.caron,'1',-1,1)*(facture_.NAROND/1000),0,decode(facture_.caron,'1',-1,1)*(facture_.NAROND/1000),New_genrun.RUN_STARTDT,V_FAC_DATECALCUL,V_VOW_UNIT,null,0,0,null,
													null,null,null,null,null,null,null,null,null,null,null,null);	
						EXCEPTION WHEN OTHERS THEN
											BEGIN
											insert into genbilline(BIL_ID,BLI_REVERSEBLI_ID,BLI_NUMBER,BLI_REVERSEBLINUMBER,BLI_NAME,BLI_EXERCICE,ITE_ID,PTA_ID,PSL_RANK,IMP_ID,BLI_VOLUMEBASE,BLI_VOLUMEFACT,
																  BLI_PUHT,TVA_ID,BLI_MHT,BLI_MTTVA,BLI_MTTC,BLI_STARTDT,BLI_ENDDT,VOW_UNIT,BLI_NBUNITES,BLI_DETAIL,BLI_CANCEL,IMC_ID,IMP_ANALYTIQUE_ID,
																  BLI_PERIODEINIT,BLI_PERIODE,BLI_REVERSEDT,BLI_CREDT,BLI_UPDTDT,BLI_UPDTBY,MEU_ID,BLI_NAME_A,BLI_REVERSEBLIDEC_ID,BLI_REVERSEBLINUMBERDEC,BLI_REVERSEDECDT)
													values(New_Genbill.BIL_ID,null,v+1,null,V_ite_name,V_anneereel,V_ITE_ID,V_PTA_ID,V_PSL_RANK,null,1,1,decode(facture_.caron,'1',-1,1)*(facture_.NAROND/1000),V_tva_id,
														  decode(facture_.caron,'1',-1,1)*(facture_.NAROND/1000),0,decode(facture_.caron,'1',-1,1)*(facture_.NAROND/1000),New_genrun.RUN_STARTDT,V_FAC_DATECALCUL,V_VOW_UNIT,null,0,0,null,
															null,null,null,null,null,null,null,null,null,null,null,null);	
											EXCEPTION WHEN OTHERS THEN NULL;
											END;
						END;
						commit;
				end if;	
	    end LOOP;				  
	end LOOP;
------------------------------------------------------------------------------------------------------------------------	
----------------------Facture_AS400GC----------------------Facture_AS400GC---------------------------Facture_AS400GC-------------
------------------------------------------------------------------------------------------------------------------------	

	for facture_ in fact_as400gc loop
		V_ID_FACTURE :=null;
		V_date_      :=null;
		V_periode    :=null;
		v_anneereel  :=null ;
		v_nbr		 :=null;
		v_ORG_ID     :=null;
		v_PAR_ID 	 :=null;
		v_SAG_ID     :=null;
		V_ADR_ID     :=null;
		v_ABN_DT_DEB :=null;
		for x in branch_(lpad(facture_.DIST,2,'0'),lpad(trim(facture_.TOU),3,'0'),lpad(trim(facture_.ORD), 3, '0'))	loop	
			
			select seq_genrun.nextval     into genrun_id     from dual;
			select seq_agrbill.nextval    into Agrbill_Id    from dual;
			select seq_gendebt.nextval    into Debt_Id       from dual;
			select seq_genimp.nextval     into genimp_id     from dual;
			select seq_agrsagaco.nextval  into agrsagaco_id  from dual;
			select seq_genaccount.nextval into genaccount_id from dual;
			
			select last_day(to_date('01'||lpad(facture_.refc01,2,'0')||facture_.refc02,'ddmmyy')) 
			into V_date_
			from dual;
			V_periode     := trim(facture_.refc01);
			v_anneereel   := to_char(V_date_,'yyyy');
			
			V_ID_FACTURE:=lpad(trim(facture_.DIST),2,'0')||lpad(trim(facture_.tou),3,'0')||lpad(trim(facture_.ORD),3,'0')||to_char(v_anneereel)||lpad(to_char(V_periode),2,0)||to_char(v_version);
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
				V_REF_ABN        :=null;
				V_pdl_ref:= lpad(trim(facture_.dist),2,'0')||lpad(trim(facture_.tou),3,'0')||lpad(trim(facture_.ord),3,'0')||lpad(trim(facture_.pol),5,'0');		
				
				select g.org_id
				into v_ORG_ID 
				from GENORGANIZATION g 
				where upper (g.org_code)=lpad(trim(facture_.dist),2,'0');
				
				select cag.par_id  
				into v_PAR_ID
				from AGRCUSTOMERAGR cag
				where cag.cag_id in (select sag.cag_id
									 from TECSERVICEPOINT spt, AGRSERVICEAGR sag
									 where spt.spt_id=sag.spt_id
									 and spt.spt_refe=V_pdl_ref);
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
					select to_date(lpad(trim(DATEXP),8,'0'),'ddmmyyyy'),to_date(lpad(trim(DATL),8,'0'),'ddmmyyyy')    
					into V_FAC_DATECALCUL,V_FAC_DATELIM 
					from role_mens
					where to_number(facture_.pol)  =POLICE
					AND to_number(facture_.Dist)   = DISTR
					And to_number(facture_.refc01) = MOIS
					AND rownum = 1;
				EXCEPTION WHEN OTHERS THEN
					V_FAC_DATECALCUL := V_date_;
					V_FAC_DATELIM    := V_date_;
				END;
				V_REF_ABN := lpad(trim(facture_.DIST),2,'0')||lpad(to_char(facture_.pol),5,'0')||lpad(trim(facture_.tou),3,'0')||lpad(trim(facture_.ORD),3,'0');
                     
				V_TRAIN_FACT:='ANNEE:'||trim(v_anneereel)||' MOIS:'||trim(V_periode);
				V_COMPTEAUX:='IMP_MIG'			   
				v_TOTHTE:=(facture_.monttrim-(v_tva))/1000;
				v_TVA:=(facture_.tva_ff+facture_.tva_capit+facture_.tva_pfin+facture_.tvacons+facture_.tva_preav+ facture_.tvaferm+facture_.tvadeplac+facture_.tvadepose_dem+facture_.tvadepose_def)/1000;
				V_TOTHTA:=0;
				V_TOTTVAA:=0;
				V_SOLDE:=facture_.monttrim/1000;
				New_Det     := null;
			    New_Genbill := null;
			    New_genrun  := null;
				If  (v_anneereel is not null and V_periode is not null and V_TRAIN_FACT is not null) then
					New_genrun.RUN_EXERCICE   :=  v_anneereel ;
					New_genrun.RUN_NUMBER     :=  V_periode ;
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
					New_Det.VOW_DEBTYPE      := pk_genvocword.getidbycode('VOW_DEBTYPE','FA',null);
				else
					New_Det.deb_amount_cash  := -(V_TOTHTE+V_TOTTVAE+V_TOTHTA+V_TOTTVAA) ;
					New_Det.DEB_AMOUNTINIT   := 0;
					New_Det.VOW_DEBTYPE      := pk_genvocword.getidbycode('VOW_DEBTYPE','AV',null);
				end if ;
				New_Det.DEB_AMOUNTREMAIN :=  V_SOLDE ;
				New_Det.DEB_COMMENT      :=  V_REF_ABN ;
				New_Det.VOW_SETTLEMODE   := pk_genvocword.getidbycode('VOW_SETTLEMODE',4,null) ;
				----------------------------------------------------------Traitement GENACCOUNT ,GENIMP
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
					
				Insert into gendebt(deb_id,deb_refe,org_id,par_id,adr_id,deb_date,deb_duedt,deb_printdt,deb_amountinit,deb_amountremain,bap_id,
									vow_settlemode,aco_id,deb_norecovery,deb_credt,deb_updtby,deb_updtdt,deb_comment,sag_id,vow_debtype,deb_prel)
						    values(New_Det.deb_id,New_Det.deb_refe,New_Det.org_id,New_Det.par_id,New_Det.adr_id,New_Det.deb_date,New_Det.deb_duedt,New_Det.deb_printdt,
								  New_Det.deb_amountinit,New_Det.deb_amountremain,New_Det.bap_id,New_Det.vow_settlemode,New_Det.aco_id,New_Det.deb_norecovery,New_Det.deb_credt, 
								  New_Det.deb_updtby,New_Det.deb_updtdt,New_Det.DEB_COMMENT,nvl(New_Det.deb_amount_cash,0),New_Det.SAG_ID,New_Det.VOW_DEBTYPE,New_Det.DEB_PREL); 
							commit;
--------------------------------------------------------Traitement agrbill
				New_Agrbill.BIL_ID            :=  Agrbill_Id ;
				New_Agrbill.SAG_ID            :=  V_SAG_ID;
				New_Agrbill.VOW_AGRBILLTYPE   :=  pk_genvocword.getidbycode('VOW_AGRBILLTYPE','FC',null) ;
				New_Agrbill.VOW_MODEFACT      :=  pk_genvocword.getidbycode('VOW_MODEFACT',4,null) ;
				Insert into agrbill (BIL_ID,SAG_ID,VOW_AGRBILLTYPE,VOW_MODEFACT)
						     values (New_Agrbill.BIL_ID,New_Agrbill.SAG_ID,New_Agrbill.VOW_AGRBILLTYPE,New_Agrbill.VOW_MODEFACT);	
			    commit;
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
						
				Insert into genbill(BIL_ID,BIL_CODE,BIL_CALCDT,BIL_AMOUNTHT,BIL_AMOUNTTVA,BIL_AMOUNTTTC,DEB_ID,PAR_ID,BIL_STATUS,BIL_AMOUNTTTCDEC,BIL_DEBTDT,RUN_ID)
							 values(New_Genbill.BIL_ID,New_Genbill.BIL_CODE,New_Genbill.BIL_CALCDT,New_Genbill.BIL_AMOUNTHT,New_Genbill.BIL_AMOUNTTVA,New_Genbill.BIL_AMOUNTTTC,
									New_Genbill.DEB_ID,New_Genbill.PAR_ID,New_Genbill.BIL_STATUS,New_Genbill.BIL_AMOUNTTTCDEC,New_Genbill.BIL_DEBTDT,New_Genbill.RUN_ID); 
				commit;
		end if;						

		v := 0;
-------------------------------------------------------------------------------------------
-----------------------------------CONSOMMATION SONEDE 1ERE TRANCHE---------------------------------------
-------------------------------------------------------------------------------------------		
			if to_number(facture_.montt1) <> 0 then
				v := v+1;
					V_PTA_ID   := null;
					V_PSL_RANK := null;
					begin
					v_code:='CSM_STD';
						for x in C_ITEM(v_code) loop
						V_ITE_ID:=x.ite_id;
						V_ite_name:=x.ite_name
						V_VOW_UNIT:=x.VOW_UNIT
						end loop;
					EXCEPTION WHEN NO_DATA_FOUND THEN NULL;
					end;
					begin
					v_tva_taux:= 18;
						for v in C_TVA(v_tva_taux) loop
						   V_tva_id:=v.tva_id; 
						end loop;
					EXCEPTION WHEN NO_DATA_FOUND THEN 
					V_tva_id := 25;
					end;
					select count(*) 
					into V_nbr 
					from genptaslice 
					where PTA_ID in (select PTA_ID 
									 from genitemperiodtarif 
									 where TAR_id in(select tar_id 
													 from genitemtarif 
													 where ITE_ID=V_ITE_ID )
									);
					if V_nbr=1 then
						select PTA_ID,PSL_RANK  
						into V_PTA_ID,V_PSL_RANK 
						from genptaslice 
						where PTA_ID in (select PTA_ID 
										 from genitemperiodtarif 
										 where TAR_id in (select tar_id 
														  from genitemtarif 
														  where ITE_ID=V_ITE_ID)
										)
						and rownum=1;
					end if;

					if V_nbr>1 then
						select PTA_ID,PSL_RANK  
						into V_PTA_ID,V_PSL_RANK 
						from genptaslice 
						where   PTA_ID
						in (select PTA_ID 
							from genitemperiodtarif
							where TAR_id in (select tar_id from genitemtarif where ITE_ID=V_ITE_ID) 
						   )
						and rownum=1;
					end if;
					BEGIN
						insert into genbilline(BIL_ID,BLI_REVERSEBLI_ID,BLI_NUMBER,BLI_REVERSEBLINUMBER,BLI_NAME,BLI_EXERCICE,ITE_ID,PTA_ID,PSL_RANK,IMP_ID,BLI_VOLUMEBASE,BLI_VOLUMEFACT,
											  BLI_PUHT,TVA_ID,BLI_MHT,BLI_MTTVA,BLI_MTTC,BLI_STARTDT,BLI_ENDDT,VOW_UNIT,BLI_NBUNITES,BLI_DETAIL,BLI_CANCEL,IMC_ID,IMP_ANALYTIQUE_ID,
											  BLI_PERIODEINIT,BLI_PERIODE,BLI_REVERSEDT,BLI_CREDT,BLI_UPDTDT,BLI_UPDTBY,MEU_ID,BLI_NAME_A,BLI_REVERSEBLIDEC_ID,BLI_REVERSEBLINUMBERDEC,BLI_REVERSEDECDT)
										Values(New_Genbill.BIL_ID,null,v,null,V_ite_name,v_anneereel,V_ITE_ID,V_PTA_ID,V_PSL_RANK,null,facture_.const1,facture_.const1,facture_.tauxt1/1000,V_tva_id,
											   facture_.montt1/1000,facture_.tvacons/1000,facture_.montt1/1000+(facture_.tvacons/1000),New_genrun.RUN_STARTDT,V_FAC_DATECALCUL,V_VOW_UNIT,null,0,0,null,
											   null,null,null,null,null,null,null,null,null,null,null,null);
					EXCEPTION WHEN OTHERS THEN
										  BEGIN
										   insert into genbilline(BIL_ID,BLI_REVERSEBLI_ID,BLI_NUMBER,BLI_REVERSEBLINUMBER,BLI_NAME,BLI_EXERCICE,ITE_ID,PTA_ID,PSL_RANK,IMP_ID,BLI_VOLUMEBASE,BLI_VOLUMEFACT,
																BLI_PUHT,TVA_ID,BLI_MHT,BLI_MTTVA,BLI_MTTC,BLI_STARTDT,BLI_ENDDT,VOW_UNIT,BLI_NBUNITES,BLI_DETAIL,BLI_CANCEL,IMC_ID,IMP_ANALYTIQUE_ID,
																BLI_PERIODEINIT,BLI_PERIODE,BLI_REVERSEDT,BLI_CREDT,BLI_UPDTDT,BLI_UPDTBY,MEU_ID,BLI_NAME_A,BLI_REVERSEBLIDEC_ID,BLI_REVERSEBLINUMBERDEC,BLI_REVERSEDECDT)
														values(New_Genbill.BIL_ID,null,v+1,null,V_ite_name,v_anneereel,V_ITE_ID,V_PTA_ID,V_PSL_RANK,null,facture_.const1,facture_.const1,facture_.tauxt1/1000,V_tva_id,
															  facture_.montt1/1000,facture_.tvacons/1000,facture_.montt1/1000+(facture_.tvacons/1000),New_genrun.RUN_STARTDT,V_FAC_DATECALCUL,V_VOW_UNIT,null,0,0,null,
															  null,null,null,null,null,null,null,null,null,null,null,null);
										   EXCEPTION WHEN OTHERS THEN NULL;
										   END;
					END;
					commit;
			end if; 
			
	-------------------------------------------------------------------------------------------
	------------------------------------CONSOMMATION SONEDE 2EME TRANCHE--------------------------------------
	-------------------------------------------------------------------------------------------		
			if to_number(facture_.montt2) <> 0 then
				v := v+1;
					V_PTA_ID := null;
					V_PSL_RANK := null;
					begin
						v_code:='CSM_STD';
							for x in C_ITEM(v_code) loop
							V_ITE_ID:=x.ite_id;
							V_ite_name:=x.ite_name
							V_VOW_UNIT:=x.VOW_UNIT
							end loop;
					EXCEPTION WHEN NO_DATA_FOUND THEN NULL;
					end;
					begin
					v_tva_taux:= 18;
						for v in C_TVA(v_tva_taux) loop
						   V_tva_id:=v.tva_id; 
						end loop;
					EXCEPTION WHEN NO_DATA_FOUND THEN 
					V_tva_id := 25;
					end;
					select count(*) 
					into V_nbr 
					from genptaslice 
					where PTA_ID in (select PTA_ID 	from genitemperiodtarif 
									 where TAR_id in ( select tar_id from genitemtarif where ITE_ID=V_ITE_ID )
									);
					if V_nbr=1 then
					
						select PTA_ID,PSL_RANK  
						into V_PTA_ID,V_PSL_RANK 
						from genptaslice 
						where PTA_ID in (select PTA_ID 
										 from genitemperiodtarif 
										 where TAR_id in (select tar_id from genitemtarif where ITE_ID=V_ITE_ID)
										)
						and rownum=1;
					end if;
					if V_nbr>1 then
						select PTA_ID,PSL_RANK  
						into V_PTA_ID,V_PSL_RANK 
						from genptaslice 
						where   PTA_ID
						in (select PTA_ID 
							from genitemperiodtarif
							where TAR_id in (select tar_id from genitemtarif where ITE_ID=V_ITE_ID) 
						   )and rownum=1;
					end if;

					BEGIN
					insert into genbilline(BIL_ID,BLI_REVERSEBLI_ID,BLI_NUMBER,BLI_REVERSEBLINUMBER,BLI_NAME,BLI_EXERCICE,ITE_ID,PTA_ID,PSL_RANK,IMP_ID,BLI_VOLUMEBASE,BLI_VOLUMEFACT,
									  BLI_PUHT,TVA_ID,BLI_MHT,BLI_MTTVA,BLI_MTTC,BLI_STARTDT,BLI_ENDDT,VOW_UNIT,BLI_NBUNITES,BLI_DETAIL,BLI_CANCEL,IMC_ID,IMP_ANALYTIQUE_ID,
									  BLI_PERIODEINIT,BLI_PERIODE,BLI_REVERSEDT,BLI_CREDT,BLI_UPDTDT,BLI_UPDTBY,MEU_ID,BLI_NAME_A,BLI_REVERSEBLIDEC_ID,BLI_REVERSEBLINUMBERDEC,BLI_REVERSEDECDT)
								values(New_Genbill.BIL_ID,null,v,null,V_ite_name,v_anneereel,V_ITE_ID,V_PTA_ID,V_PSL_RANK,null,facture_.const2,facture_.const2,facture_.tauxt2/1000,V_tva_id,
									  facture_.montt2/1000,facture_.tvacons/1000,facture_.montt2/1000+(facture_.tvacons/1000),New_genrun.RUN_STARTDT,V_FAC_DATECALCUL,V_VOW_UNIT,null,0,0,null,
									  null,null,null,null,null,null,null,null,null,null,null,null);
					EXCEPTION WHEN OTHERS THEN
										BEGIN
										insert into genbilline(BIL_ID,BLI_REVERSEBLI_ID,BLI_NUMBER,BLI_REVERSEBLINUMBER,BLI_NAME,BLI_EXERCICE,ITE_ID,PTA_ID,PSL_RANK,IMP_ID,BLI_VOLUMEBASE,BLI_VOLUMEFACT,
																BLI_PUHT,TVA_ID,BLI_MHT,BLI_MTTVA,BLI_MTTC,BLI_STARTDT,BLI_ENDDT,VOW_UNIT,BLI_NBUNITES,BLI_DETAIL,BLI_CANCEL,IMC_ID,IMP_ANALYTIQUE_ID,
																BLI_PERIODEINIT,BLI_PERIODE,BLI_REVERSEDT,BLI_CREDT,BLI_UPDTDT,BLI_UPDTBY,MEU_ID,BLI_NAME_A,BLI_REVERSEBLIDEC_ID,BLI_REVERSEBLINUMBERDEC,BLI_REVERSEDECDT)
														values(New_Genbill.BIL_ID,null,v+1,null,V_ite_name,v_anneereel,V_ITE_ID,V_PTA_ID,V_PSL_RANK,null,facture_.const2,facture_.const2,facture_.tauxt2/1000,V_tva_id,
															  facture_.montt2/1000,facture_.tvacons/1000,facture_.montt2/1000+(facture_.tvacons/1000),New_genrun.RUN_STARTDT,V_FAC_DATECALCUL,V_VOW_UNIT,null,0,0,null,
															  null,null,null,null,null,null,null,null,null,null,null,null);
										EXCEPTION WHEN OTHERS THEN NULL;
										END;
					END;
					commit;
			end if;
			
			
	-------------------------------------------------------------------------------------------
	-----------------------------------CONSOMMATION SONEDE 3EME TRANCHE---------------------------------------
	-------------------------------------------------------------------------------------------		
			if to_number(facture_.montt3) <> 0 then
				v := v+1;
					V_PTA_ID := null;
					V_PSL_RANK := null;
					begin
					v_code:='CSM_STD';
						for x in C_ITEM(v_code) loop
						V_ITE_ID:=x.ite_id;
						V_ite_name:=x.ite_name
						V_VOW_UNIT:=x.VOW_UNIT
						end loop;
					EXCEPTION WHEN NO_DATA_FOUND THEN NULL;
					end;
					begin
					v_tva_taux:= 18;
						for v in C_TVA(v_tva_taux) loop
						   V_tva_id:=v.tva_id; 
						end loop;
					EXCEPTION WHEN NO_DATA_FOUND THEN 
					V_tva_id := 25;
					end;
					select count(*) 
					into V_nbr 
					from genptaslice 
					where PTA_ID in (select PTA_ID 	from genitemperiodtarif 
									 where TAR_id in ( select tar_id from genitemtarif where ITE_ID=V_ITE_ID )
									);
					if V_nbr=1 then
					   select PTA_ID,PSL_RANK  
						into V_PTA_ID,V_PSL_RANK 
						from genptaslice 
						where PTA_ID in (select PTA_ID 
										 from genitemperiodtarif 
										 where TAR_id in (select tar_id from genitemtarif where ITE_ID=V_ITE_ID)
										)
						and rownum=1;
						
					end if;

					if V_nbr>1 then
						select PTA_ID,PSL_RANK  
						into V_PTA_ID,V_PSL_RANK 
						from genptaslice 
						where   PTA_ID
						in (select PTA_ID 
							from genitemperiodtarif
							where TAR_id in (select tar_id from genitemtarif where ITE_ID=V_ITE_ID) 
						   )and rownum=1;
					end if;						

											

					BEGIN
					insert into genbilline(BIL_ID,BLI_REVERSEBLI_ID,BLI_NUMBER,BLI_REVERSEBLINUMBER,BLI_NAME,BLI_EXERCICE,ITE_ID,PTA_ID,PSL_RANK,IMP_ID,BLI_VOLUMEBASE,BLI_VOLUMEFACT,
										  BLI_PUHT,TVA_ID,BLI_MHT,BLI_MTTVA,BLI_MTTC,BLI_STARTDT,BLI_ENDDT,VOW_UNIT,BLI_NBUNITES,BLI_DETAIL,BLI_CANCEL,IMC_ID,IMP_ANALYTIQUE_ID,
										  BLI_PERIODEINIT,BLI_PERIODE,BLI_REVERSEDT,BLI_CREDT,BLI_UPDTDT,BLI_UPDTBY,MEU_ID,BLI_NAME_A,BLI_REVERSEBLIDEC_ID,BLI_REVERSEBLINUMBERDEC,BLI_REVERSEDECDT)
									values(New_Genbill.BIL_ID,null,v,null,V_ite_name,v_anneereel,V_ITE_ID,V_PTA_ID,V_PSL_RANK,null,facture_.const3,facture_.const3,facture_.tauxt3/1000,V_tva_id,
										  facture_.montt3/1000,facture_.tvacons/1000,facture_.montt3/1000+(facture_.tvacons/1000),New_genrun.RUN_STARTDT,V_FAC_DATECALCUL,V_VOW_UNIT,null,0,0,null,
										  null,null,null,null,null,null,null,null,null,null,null,null);
					EXCEPTION WHEN OTHERS THEN
										BEGIN
										insert into genbilline(BIL_ID,BLI_REVERSEBLI_ID,BLI_NUMBER,BLI_REVERSEBLINUMBER,BLI_NAME,BLI_EXERCICE,ITE_ID,PTA_ID,PSL_RANK,IMP_ID,BLI_VOLUMEBASE,BLI_VOLUMEFACT,
																BLI_PUHT,TVA_ID,BLI_MHT,BLI_MTTVA,BLI_MTTC,BLI_STARTDT,BLI_ENDDT,VOW_UNIT,BLI_NBUNITES,BLI_DETAIL,BLI_CANCEL,IMC_ID,IMP_ANALYTIQUE_ID,
																BLI_PERIODEINIT,BLI_PERIODE,BLI_REVERSEDT,BLI_CREDT,BLI_UPDTDT,BLI_UPDTBY,MEU_ID,BLI_NAME_A,BLI_REVERSEBLIDEC_ID,BLI_REVERSEBLINUMBERDEC,BLI_REVERSEDECDT)
														values(New_Genbill.BIL_ID,null,v+1,null,V_ite_name,v_anneereel,V_ITE_ID,V_PTA_ID,V_PSL_RANK,null,facture_.const3,facture_.const3,facture_.tauxt3/1000,V_tva_id,
															  facture_.montt3/1000,facture_.tvacons/1000,facture_.montt3/1000+(facture_.tvacons/1000),New_genrun.RUN_STARTDT,V_FAC_DATECALCUL,V_VOW_UNIT,null,0,0,null,
															  null,null,null,null,null,null,null,null,null,null,null,null);
										EXCEPTION WHEN OTHERS THEN NULL;
										END;
					END;
					commit;
			end if;		
			
	-------------------------------------------------------------------------------------------
	-----------------------------------REDEVANCE ONAS 1ERE TRANCHE---------------------------------------
	-------------------------------------------------------------------------------------------		
			if to_number(facture_.mon1) <> 0 then
				v := v+1;
					V_PTA_ID := null;
					V_PSL_RANK := null;
					begin
					v_code:='VAR_ONAS_1';
						for x in C_ITEM(v_code) loop
						V_ITE_ID:=x.ite_id;
						V_ite_name:=x.ite_name
						V_VOW_UNIT:=x.VOW_UNIT
						end loop;
					EXCEPTION WHEN NO_DATA_FOUND THEN NULL;
					end;
					begin
					v_tva_taux= 0;
						for v in C_TVA(v_tva_taux) loop
						   V_tva_id:=v.tva_id; 
						end loop;
					EXCEPTION WHEN NO_DATA_FOUND THEN 
					V_tva_id := 25;
					end;
					select count(*) 
					into V_nbr 
					from genptaslice 
					where PTA_ID in (select PTA_ID 	from genitemperiodtarif 
									 where TAR_id in ( select tar_id from genitemtarif where ITE_ID=V_ITE_ID )
									);

					if V_nbr=1 then
						select PTA_ID,PSL_RANK  
						into V_PTA_ID,V_PSL_RANK 
						from genptaslice 
						where PTA_ID in (select PTA_ID 
										 from genitemperiodtarif 
										 where TAR_id in (select tar_id from genitemtarif where ITE_ID=V_ITE_ID)
										)
						and rownum=1;
					end if;
					if V_nbr>1 then
						select PTA_ID,PSL_RANK  
						into V_PTA_ID,V_PSL_RANK 
						from genptaslice 
						where   PTA_ID
						in (select PTA_ID 
							from genitemperiodtarif
							where TAR_id in (select tar_id from genitemtarif where ITE_ID=V_ITE_ID) 
						   )and rownum=1;
					end if;

					BEGIN
						insert into genbilline(BIL_ID,BLI_REVERSEBLI_ID,BLI_NUMBER,BLI_REVERSEBLINUMBER,BLI_NAME,BLI_EXERCICE,ITE_ID,PTA_ID,PSL_RANK,IMP_ID,BLI_VOLUMEBASE,BLI_VOLUMEFACT,
											  BLI_PUHT,TVA_ID,BLI_MHT,BLI_MTTVA,BLI_MTTC,BLI_STARTDT,BLI_ENDDT,VOW_UNIT,BLI_NBUNITES,BLI_DETAIL,BLI_CANCEL,IMC_ID,IMP_ANALYTIQUE_ID,
											  BLI_PERIODEINIT,BLI_PERIODE,BLI_REVERSEDT,BLI_CREDT,BLI_UPDTDT,BLI_UPDTBY,MEU_ID,BLI_NAME_A,BLI_REVERSEBLIDEC_ID,BLI_REVERSEBLINUMBERDEC,BLI_REVERSEDECDT)
									   values(New_Genbill.BIL_ID,null,v,null,V_ite_name,v_anneereel,V_ITE_ID,V_PTA_ID,V_PSL_RANK,null,facture_.volon1,facture_.volon1,facture_.tauon1/1000,V_tva_id,
											facture_.mon1/1000,0,facture_.mon1/1000,New_genrun.RUN_STARTDT,V_FAC_DATECALCUL,V_VOW_UNIT,null,0,0,null,
											 null,null,null,null,null,null,null,null,null,null,null,null);
					EXCEPTION WHEN OTHERS THEN
										BEGIN
										insert into genbilline(BIL_ID,BLI_REVERSEBLI_ID,BLI_NUMBER,BLI_REVERSEBLINUMBER,BLI_NAME,BLI_EXERCICE,ITE_ID,PTA_ID,PSL_RANK,IMP_ID,BLI_VOLUMEBASE,BLI_VOLUMEFACT,
															   BLI_PUHT,TVA_ID,BLI_MHT,BLI_MTTVA,BLI_MTTC,BLI_STARTDT,BLI_ENDDT,VOW_UNIT,BLI_NBUNITES,BLI_DETAIL,BLI_CANCEL,IMC_ID,IMP_ANALYTIQUE_ID,
															   BLI_PERIODEINIT,BLI_PERIODE,BLI_REVERSEDT,BLI_CREDT,BLI_UPDTDT,BLI_UPDTBY,MEU_ID,BLI_NAME_A,BLI_REVERSEBLIDEC_ID,BLI_REVERSEBLINUMBERDEC,BLI_REVERSEDECDT)
														  values(New_Genbill.BIL_ID,null,v+1,null,V_ite_name,v_anneereel,V_ITE_ID,V_PTA_ID,V_PSL_RANK,null,facture_.volon1,facture_.volon1,facture_.tauon1/1000,V_tva_id,
																 facture_.mon1/1000,0,facture_.mon1/1000,New_genrun.RUN_STARTDT,V_FAC_DATECALCUL,V_VOW_UNIT,null,0,0,null,
																 null,null,null,null,null,null,null,null,null,null,null,null);
										EXCEPTION WHEN OTHERS THEN NULL;
										END;
					END;
					commit;
			end if;
	 
	 -------------------------------------------------------------------------------------------
	-----------------------------------REDEVANCE ONAS 2EME TRANCHE---------------------------------------
	-------------------------------------------------------------------------------------------		
		   if to_number(facture_.mon2) <> 0 then
				v := v+1;
					V_PTA_ID := null;
					V_PSL_RANK := null;
					begin
					v_code:='VAR_ONAS_1';
						for x in C_ITEM(v_code) loop
						V_ITE_ID:=x.ite_id;
						V_ite_name:=x.ite_name
						V_VOW_UNIT:=x.VOW_UNIT
						end loop;
					EXCEPTION WHEN NO_DATA_FOUND THEN NULL;
					end;
					begin
					v_tva_taux= 0;
						for v in C_TVA(v_tva_taux) loop
						   V_tva_id:=v.tva_id; 
						end loop;
					EXCEPTION WHEN NO_DATA_FOUND THEN 
					V_tva_id := 25;
					end;
					select count(*) 
					into V_nbr 
					from genptaslice 
					where PTA_ID in (select PTA_ID 	from genitemperiodtarif 
									 where TAR_id in ( select tar_id from genitemtarif where ITE_ID=V_ITE_ID )
									);
					if V_nbr=1 then
					   select PTA_ID,PSL_RANK  
						into V_PTA_ID,V_PSL_RANK 
						from genptaslice 
						where PTA_ID in (select PTA_ID 
										 from genitemperiodtarif 
										 where TAR_id in (select tar_id from genitemtarif where ITE_ID=V_ITE_ID)
										)
						and rownum=1;
					end if;
					if V_nbr>1 then
						select PTA_ID,PSL_RANK  
						into V_PTA_ID,V_PSL_RANK 
						from genptaslice 
						where   PTA_ID
						in (select PTA_ID 
							from genitemperiodtarif
							where TAR_id in (select tar_id from genitemtarif where ITE_ID=V_ITE_ID) 
						   )and rownum=1;
					end if;

					BEGIN
						insert into genbilline(BIL_ID,BLI_REVERSEBLI_ID,BLI_NUMBER,BLI_REVERSEBLINUMBER,BLI_NAME,BLI_EXERCICE,ITE_ID,PTA_ID,PSL_RANK,IMP_ID,BLI_VOLUMEBASE,BLI_VOLUMEFACT,
											  BLI_PUHT,TVA_ID,BLI_MHT,BLI_MTTVA,BLI_MTTC,BLI_STARTDT,BLI_ENDDT,VOW_UNIT,BLI_NBUNITES,BLI_DETAIL,BLI_CANCEL,IMC_ID,IMP_ANALYTIQUE_ID,
											  BLI_PERIODEINIT,BLI_PERIODE,BLI_REVERSEDT,BLI_CREDT,BLI_UPDTDT,BLI_UPDTBY,MEU_ID,BLI_NAME_A,BLI_REVERSEBLIDEC_ID,BLI_REVERSEBLINUMBERDEC,BLI_REVERSEDECDT)
										values(New_Genbill.BIL_ID,null,v,null,V_ite_name,v_anneereel,V_ITE_ID,V_PTA_ID,V_PSL_RANK,null,facture_.volon2,facture_.volon2,facture_.tauon2/1000,V_tva_id,
												facture_.mon2/1000,0,facture_.mon2/1000,New_genrun.RUN_STARTDT,V_FAC_DATECALCUL,V_VOW_UNIT,null,0,0,null,
												null,null,null,null,null,null,null,null,null,null,null,null);
					EXCEPTION WHEN OTHERS THEN
										BEGIN
											insert into genbilline(BIL_ID,BLI_REVERSEBLI_ID,BLI_NUMBER,BLI_REVERSEBLINUMBER,BLI_NAME,BLI_EXERCICE,ITE_ID,PTA_ID,PSL_RANK,IMP_ID,BLI_VOLUMEBASE,BLI_VOLUMEFACT,
																	BLI_PUHT,TVA_ID,BLI_MHT,BLI_MTTVA,BLI_MTTC,BLI_STARTDT,BLI_ENDDT,VOW_UNIT,BLI_NBUNITES,BLI_DETAIL,BLI_CANCEL,IMC_ID,IMP_ANALYTIQUE_ID,
																	BLI_PERIODEINIT,BLI_PERIODE,BLI_REVERSEDT,BLI_CREDT,BLI_UPDTDT,BLI_UPDTBY,MEU_ID,BLI_NAME_A,BLI_REVERSEBLIDEC_ID,BLI_REVERSEBLINUMBERDEC,BLI_REVERSEDECDT)
															values(New_Genbill.BIL_ID,null,v+1,null,V_ite_name,v_anneereel,V_ITE_ID,V_PTA_ID,V_PSL_RANK,null,facture_.volon2,facture_.volon2,facture_.tauon2/1000,V_tva_id,
																	facture_.mon2/1000,0,facture_.mon2/1000,New_genrun.RUN_STARTDT,V_FAC_DATECALCUL,V_VOW_UNIT,null,0,0,null,
																	null,null,null,null,null,null,null,null,null,null,null,null);
										EXCEPTION WHEN OTHERS THEN NULL;
										END;
					END;
					commit;
			end if;
			
	 -------------------------------------------------------------------------------------------
	----------------------------------REDEVANCE ONAS 3EME TRANCHE--------------------------------------
	-------------------------------------------------------------------------------------------		
			if to_number(facture_.mon3) <> 0 then
				v := v+1;
					V_PTA_ID := null;
					V_PSL_RANK := null;
					begin
					v_code:='VAR_ONAS_1';
						for x in C_ITEM(v_code) loop
						V_ITE_ID:=x.ite_id;
						V_ite_name:=x.ite_name
						V_VOW_UNIT:=x.VOW_UNIT
						end loop;
					EXCEPTION WHEN NO_DATA_FOUND THEN NULL;
					end;
					begin
					v_tva_taux= 0;
						for v in C_TVA(v_tva_taux) loop
						   V_tva_id:=v.tva_id; 
						end loop;
					EXCEPTION WHEN NO_DATA_FOUND THEN 
					V_tva_id := 25;
					end;
					select count(*) 
					into V_nbr 
					from genptaslice 
					where PTA_ID in (select PTA_ID 	from genitemperiodtarif 
									 where TAR_id in ( select tar_id from genitemtarif where ITE_ID=V_ITE_ID )
									);
					if V_nbr=1 then
						select PTA_ID,PSL_RANK  
						into V_PTA_ID,V_PSL_RANK 
						from genptaslice 
						where PTA_ID in (select PTA_ID 
										 from genitemperiodtarif 
										 where TAR_id in (select tar_id from genitemtarif where ITE_ID=V_ITE_ID)
										)
						and rownum=1;
					end if;
					if V_nbr>1 then
						select PTA_ID,PSL_RANK  
						into V_PTA_ID,V_PSL_RANK 
						from genptaslice 
						where   PTA_ID
						in (select PTA_ID 
							from genitemperiodtarif
							where TAR_id in (select tar_id from genitemtarif where ITE_ID=V_ITE_ID) 
						   )and rownum=1;
					end if;
					BEGIN
						insert into genbilline(BIL_ID,BLI_REVERSEBLI_ID,BLI_NUMBER,BLI_REVERSEBLINUMBER,BLI_NAME,BLI_EXERCICE,ITE_ID,PTA_ID,PSL_RANK,IMP_ID,BLI_VOLUMEBASE,BLI_VOLUMEFACT,
											  BLI_PUHT,TVA_ID,BLI_MHT,BLI_MTTVA,BLI_MTTC,BLI_STARTDT,BLI_ENDDT,VOW_UNIT,BLI_NBUNITES,BLI_DETAIL,BLI_CANCEL,IMC_ID,IMP_ANALYTIQUE_ID,
											  BLI_PERIODEINIT,BLI_PERIODE,BLI_REVERSEDT,BLI_CREDT,BLI_UPDTDT,BLI_UPDTBY,MEU_ID,BLI_NAME_A,BLI_REVERSEBLIDEC_ID,BLI_REVERSEBLINUMBERDEC,BLI_REVERSEDECDT)
										values(New_Genbill.BIL_ID,null,v,null,V_ite_name,v_anneereel,V_ITE_ID,V_PTA_ID,V_PSL_RANK,null,facture_.volon3,facture_.volon3,facture_.tauon3/1000,V_tva_id,
												facture_.mon3/1000,0,facture_.mon3/1000,New_genrun.RUN_STARTDT,V_FAC_DATECALCUL,V_VOW_UNIT,null,0,0,null,
												null,null,null,null,null,null,null,null,null,null,null,null);
					EXCEPTION WHEN OTHERS THEN
										BEGIN
										insert into genbilline(BIL_ID,BLI_REVERSEBLI_ID,BLI_NUMBER,BLI_REVERSEBLINUMBER,BLI_NAME,BLI_EXERCICE,ITE_ID,PTA_ID,PSL_RANK,IMP_ID,BLI_VOLUMEBASE,BLI_VOLUMEFACT,
															   BLI_PUHT,TVA_ID,BLI_MHT,BLI_MTTVA,BLI_MTTC,BLI_STARTDT,BLI_ENDDT,VOW_UNIT,BLI_NBUNITES,BLI_DETAIL,BLI_CANCEL,IMC_ID,IMP_ANALYTIQUE_ID,
															   BLI_PERIODEINIT,BLI_PERIODE,BLI_REVERSEDT,BLI_CREDT,BLI_UPDTDT,BLI_UPDTBY,MEU_ID,BLI_NAME_A,BLI_REVERSEBLIDEC_ID,BLI_REVERSEBLINUMBERDEC,BLI_REVERSEDECDT)
														values(New_Genbill.BIL_ID,null,v+1,null,V_ite_name,v_anneereel,V_ITE_ID,V_PTA_ID,V_PSL_RANK,null,facture_.volon3,facture_.volon3,facture_.tauon3/1000,V_tva_id,
																facture_.mon3/1000,0,facture_.mon3/1000,New_genrun.RUN_STARTDT,V_FAC_DATECALCUL,V_VOW_UNIT,null,0,0,null,
																null,null,null,null,null,null,null,null,null,null,null,null);
										EXCEPTION WHEN OTHERS THEN NULL;
										END;
					END;
					commit;
			end if;
					
					
	-------------------------------------------------------------------------------------------
	-----------------------------------FRAIS FIXE ONAS--------------------------------------
	-------------------------------------------------------------------------------------------		
			if to_number(facture_.fixonas) <> 0 then
				v := v+1;
					V_PTA_ID := null;
					V_PSL_RANK := null;
					begin
					v_code:='FIXE_ONAS_1';
						for x in C_ITEM(v_code) loop
						V_ITE_ID:=x.ite_id;
						V_ite_name:=x.ite_name
						V_VOW_UNIT:=x.VOW_UNIT
						end loop;
					EXCEPTION WHEN NO_DATA_FOUND THEN NULL;
					end;
					begin
					v_tva_taux= 0;
						for v in C_TVA(v_tva_taux) loop
						   V_tva_id:=v.tva_id; 
						end loop;
					EXCEPTION WHEN NO_DATA_FOUND THEN 
					V_tva_id := 25;
					end;
					select count(*) 
					into V_nbr 
					from genptaslice 
					where PTA_ID in (select PTA_ID 	from genitemperiodtarif 
									 where TAR_id in ( select tar_id from genitemtarif where ITE_ID=V_ITE_ID )
									);
					if V_nbr=1 then
						select PTA_ID,PSL_RANK  
						into V_PTA_ID,V_PSL_RANK 
						from genptaslice 
						where PTA_ID in (select PTA_ID 
										 from genitemperiodtarif 
										 where TAR_id in (select tar_id from genitemtarif where ITE_ID=V_ITE_ID)
										)
						and rownum=1;
					end if;
					if V_nbr>1 then
						select PTA_ID,PSL_RANK  
						into V_PTA_ID,V_PSL_RANK 
						from genptaslice 
						where   PTA_ID
						in (select PTA_ID 
							from genitemperiodtarif
							where TAR_id in (select tar_id from genitemtarif where ITE_ID=V_ITE_ID) 
						   )and rownum=1;
					end if;

					BEGIN
						insert into genbilline(BIL_ID,BLI_REVERSEBLI_ID,BLI_NUMBER,BLI_REVERSEBLINUMBER,BLI_NAME,BLI_EXERCICE,ITE_ID,PTA_ID,PSL_RANK,IMP_ID,BLI_VOLUMEBASE,BLI_VOLUMEFACT,
											   BLI_PUHT,TVA_ID,BLI_MHT,BLI_MTTVA,BLI_MTTC,BLI_STARTDT,BLI_ENDDT,VOW_UNIT,BLI_NBUNITES,BLI_DETAIL,BLI_CANCEL,IMC_ID,IMP_ANALYTIQUE_ID,
											   BLI_PERIODEINIT,BLI_PERIODE,BLI_REVERSEDT,BLI_CREDT,BLI_UPDTDT,BLI_UPDTBY,MEU_ID,BLI_NAME_A,BLI_REVERSEBLIDEC_ID,BLI_REVERSEBLINUMBERDEC,BLI_REVERSEDECDT)
										values(New_Genbill.BIL_ID,null,v,null,V_ite_name,v_anneereel,V_ITE_ID,V_PTA_ID,V_PSL_RANK,null,1,1,facture_.fixonas/1000,V_tva_id,
												facture_.fixonas/1000,0,facture_.fixonas/1000,New_genrun.RUN_STARTDT,V_FAC_DATECALCUL,V_VOW_UNIT,null,0,0,null,
												null,null,null,null,null,null,null,null,null,null,null,null);
					EXCEPTION WHEN OTHERS THEN
										  BEGIN
											insert into genbilline(BIL_ID,BLI_REVERSEBLI_ID,BLI_NUMBER,BLI_REVERSEBLINUMBER,BLI_NAME,BLI_EXERCICE,ITE_ID,PTA_ID,PSL_RANK,IMP_ID,BLI_VOLUMEBASE,BLI_VOLUMEFACT,
																   BLI_PUHT,TVA_ID,BLI_MHT,BLI_MTTVA,BLI_MTTC,BLI_STARTDT,BLI_ENDDT,VOW_UNIT,BLI_NBUNITES,BLI_DETAIL,BLI_CANCEL,IMC_ID,IMP_ANALYTIQUE_ID,
																   BLI_PERIODEINIT,BLI_PERIODE,BLI_REVERSEDT,BLI_CREDT,BLI_UPDTDT,BLI_UPDTBY,MEU_ID,BLI_NAME_A,BLI_REVERSEBLIDEC_ID,BLI_REVERSEBLINUMBERDEC,BLI_REVERSEDECDT)
															values(New_Genbill.BIL_ID,null,v+1,null,V_ite_name,v_anneereel,V_ITE_ID,V_PTA_ID,V_PSL_RANK,null,1,1,facture_.fixonas/1000,V_tva_id,
																	facture_.fixonas/1000,0,facture_.fixonas/1000,New_genrun.RUN_STARTDT,V_FAC_DATECALCUL,V_VOW_UNIT,null,0,0,null,
																	null,null,null,null,null,null,null,null,null,null,null,null);
										  EXCEPTION WHEN OTHERS THEN NULL;
										  END;
					END;
					commit;
			end if;		
			
			
	-------------------------------------------------------------------------------------------
	-----------------------------------FRAIS FIXE SONEDE--------------------------------------
	-------------------------------------------------------------------------------------------		
		   if to_number(facture_.fraisctr) <> 0 then
				v := v+1;
					V_PTA_ID := null;
					V_PSL_RANK := null;
					begin
					v_code:='FRS_FIX_CSM';
						for x in C_ITEM(v_code) loop
						V_ITE_ID:=x.ite_id;
						V_ite_name:=x.ite_name
						V_VOW_UNIT:=x.VOW_UNIT
						end loop;
					EXCEPTION WHEN NO_DATA_FOUND THEN NULL;
					end;
					begin
					v_tva_taux:= 18;
						for v in C_TVA(v_tva_taux) loop
						   V_tva_id:=v.tva_id; 
						end loop;
					EXCEPTION WHEN NO_DATA_FOUND THEN 
					V_tva_id := 25;
					end;
					select count(*) 
					into V_nbr 
					from genptaslice 
					where PTA_ID in (select PTA_ID 	from genitemperiodtarif 
									 where TAR_id in ( select tar_id from genitemtarif where ITE_ID=V_ITE_ID )
									);
					if V_nbr=1 then
						select PTA_ID,PSL_RANK  
						into V_PTA_ID,V_PSL_RANK 
						from genptaslice 
						where PTA_ID in (select PTA_ID 
										 from genitemperiodtarif 
										 where TAR_id in (select tar_id from genitemtarif where ITE_ID=V_ITE_ID)
										)
						and rownum=1;
					end if;
					if V_nbr>1 then
						select PTA_ID,PSL_RANK  
						into V_PTA_ID,V_PSL_RANK 
						from genptaslice 
						where PTA_ID
						in (select PTA_ID 
							from genitemperiodtarif
							where TAR_id in (select tar_id from genitemtarif where ITE_ID=V_ITE_ID) 
						   )
						   and rownum=1;
					end if;

					BEGIN
						insert into genbilline(BIL_ID,BLI_REVERSEBLI_ID,BLI_NUMBER,BLI_REVERSEBLINUMBER,BLI_NAME,BLI_EXERCICE,ITE_ID,PTA_ID,PSL_RANK,IMP_ID,BLI_VOLUMEBASE,BLI_VOLUMEFACT,
											   BLI_PUHT,TVA_ID,BLI_MHT,BLI_MTTVA,BLI_MTTC,BLI_STARTDT,BLI_ENDDT,VOW_UNIT,BLI_NBUNITES,BLI_DETAIL,BLI_CANCEL,IMC_ID,IMP_ANALYTIQUE_ID,
											   BLI_PERIODEINIT,BLI_PERIODE,BLI_REVERSEDT,BLI_CREDT,BLI_UPDTDT,BLI_UPDTBY,MEU_ID,BLI_NAME_A,BLI_REVERSEBLIDEC_ID,BLI_REVERSEBLINUMBERDEC,BLI_REVERSEDECDT)
										values(New_Genbill.BIL_ID,,null,v,null,V_ite_name,v_anneereel,V_ITE_ID,V_PTA_ID,V_PSL_RANK,null,1,1,facture_.fraisctr/1000,V_tva_id,
												facture_.fraisctr/1000,facture_.tva_ff/1000,(facture_.fraisctr/1000)+(facture_.TVA_ff/1000),New_genrun.RUN_STARTDT,V_FAC_DATECALCUL,V_VOW_UNIT,null,0,0,null,
												null,null,null,null,null,null,null,null,null,null,null,null);
					EXCEPTION WHEN OTHERS THEN
										BEGIN
											insert into genbilline(BIL_ID,BLI_REVERSEBLI_ID,BLI_NUMBER,BLI_REVERSEBLINUMBER,BLI_NAME,BLI_EXERCICE,ITE_ID,PTA_ID,PSL_RANK,IMP_ID,BLI_VOLUMEBASE,BLI_VOLUMEFACT,
																	BLI_PUHT,TVA_ID,BLI_MHT,BLI_MTTVA,BLI_MTTC,BLI_STARTDT,BLI_ENDDT,VOW_UNIT,BLI_NBUNITES,BLI_DETAIL,BLI_CANCEL,IMC_ID,IMP_ANALYTIQUE_ID,
																	BLI_PERIODEINIT,BLI_PERIODE,BLI_REVERSEDT,BLI_CREDT,BLI_UPDTDT,BLI_UPDTBY,MEU_ID,BLI_NAME_A,BLI_REVERSEBLIDEC_ID,BLI_REVERSEBLINUMBERDEC,BLI_REVERSEDECDT)
															values(New_Genbill.BIL_ID,,null,v+1,null,V_ite_name,v_anneereel,V_ITE_ID,V_PTA_ID,V_PSL_RANK,null,1,1,facture_.fraisctr/1000,V_tva_id,
																	facture_.fraisctr/1000,facture_.tva_ff/1000,(facture_.fraisctr/1000)+(facture_.TVA_ff/1000),New_genrun.RUN_STARTDT,V_FAC_DATECALCUL,V_VOW_UNIT,null,0,0,null,
																	null,null,null,null,null,null,null,null,null,null,null,null);
										EXCEPTION WHEN OTHERS THEN NULL;
										END;
					END;
					commit;
			end if;
			
	-------------------------------------------------------------------------------------------
	--------------------------------Montant capital---------------------------------------
	-------------------------------------------------------------------------------------------		
			if to_number(facture_.CAPIT) <> 0 then
				v := v+1;
					V_PTA_ID := null;
					V_PSL_RANK := null;
					begin
					v_code:='CAPITAL';
						for x in C_ITEM(v_code) loop
						V_ITE_ID:=x.ite_id;
						V_ite_name:=x.ite_name
						V_VOW_UNIT:=x.VOW_UNIT
						end loop;
					EXCEPTION WHEN NO_DATA_FOUND THEN NULL;
					end;
					begin
					v_tva_taux:=0;
						for v in C_TVA(v_tva_taux) loop
						   V_tva_id:=v.tva_id; 
						end loop;
					EXCEPTION WHEN NO_DATA_FOUND THEN 
					V_tva_id := 25;
					end;
					select count(*) 
					into V_nbr 
					from genptaslice 
					where PTA_ID in (select PTA_ID 	from genitemperiodtarif 
									 where TAR_id in ( select tar_id from genitemtarif where ITE_ID=V_ITE_ID )
									);
					if V_nbr=1 then
					select PTA_ID,PSL_RANK  
						into V_PTA_ID,V_PSL_RANK 
						from genptaslice 
						where PTA_ID in (select PTA_ID 
										 from genitemperiodtarif 
										 where TAR_id in (select tar_id from genitemtarif where ITE_ID=V_ITE_ID)
										)
						and rownum=1;
					end if;
					if V_nbr>1 then
						select PTA_ID,PSL_RANK  
						into V_PTA_ID,V_PSL_RANK 
						from genptaslice 
						where   PTA_ID
						in (select PTA_ID 
							from genitemperiodtarif
							where TAR_id in (select tar_id from genitemtarif where ITE_ID=V_ITE_ID) 
						   )and rownum=1;
					end if;

					BEGIN
						insert into genbilline(BIL_ID,BLI_REVERSEBLI_ID,BLI_NUMBER,BLI_REVERSEBLINUMBER,BLI_NAME,BLI_EXERCICE,ITE_ID,PTA_ID,PSL_RANK,IMP_ID,BLI_VOLUMEBASE,BLI_VOLUMEFACT,
											   BLI_PUHT,TVA_ID,BLI_MHT,BLI_MTTVA,BLI_MTTC,BLI_STARTDT,BLI_ENDDT,VOW_UNIT,BLI_NBUNITES,BLI_DETAIL,BLI_CANCEL,IMC_ID,IMP_ANALYTIQUE_ID,
											   BLI_PERIODEINIT,BLI_PERIODE,BLI_REVERSEDT,BLI_CREDT,BLI_UPDTDT,BLI_UPDTBY,MEU_ID,BLI_NAME_A,BLI_REVERSEBLIDEC_ID,BLI_REVERSEBLINUMBERDEC,BLI_REVERSEDECDT)
										values(New_Genbill.BIL_ID,null,v,null,V_ite_name,v_anneereel,V_ITE_ID,V_PTA_ID,V_PSL_RANK,null,1,1,facture_.CAPIT/1000,V_tva_id,
											  facture_.CAPIT/1000,facture_.tva_capit/1000,facture_.CAPIT/1000,New_genrun.RUN_STARTDT,V_FAC_DATECALCUL,V_VOW_UNIT,null,0,0,null,
											  null,null,null,null,null,null,null,null,null,null,null,null);
					EXCEPTION WHEN OTHERS THEN
										BEGIN
											insert into genbilline(BIL_ID,BLI_REVERSEBLI_ID,BLI_NUMBER,BLI_REVERSEBLINUMBER,BLI_NAME,BLI_EXERCICE,ITE_ID,PTA_ID,PSL_RANK,IMP_ID,BLI_VOLUMEBASE,BLI_VOLUMEFACT,
																   BLI_PUHT,TVA_ID,BLI_MHT,BLI_MTTVA,BLI_MTTC,BLI_STARTDT,BLI_ENDDT,VOW_UNIT,BLI_NBUNITES,BLI_DETAIL,BLI_CANCEL,IMC_ID,IMP_ANALYTIQUE_ID,
																   BLI_PERIODEINIT,BLI_PERIODE,BLI_REVERSEDT,BLI_CREDT,BLI_UPDTDT,BLI_UPDTBY,MEU_ID,BLI_NAME_A,BLI_REVERSEBLIDEC_ID,BLI_REVERSEBLINUMBERDEC,BLI_REVERSEDECDT)
															values(New_Genbill.BIL_ID,null,v+1,null,V_ite_name,v_anneereel,V_ITE_ID,V_PTA_ID,V_PSL_RANK,null,1,1,facture_.CAPIT/1000,V_tva_id,
																  facture_.CAPIT/1000,facture_.tva_capit/1000,facture_.CAPIT/1000,New_genrun.RUN_STARTDT,V_FAC_DATECALCUL,V_VOW_UNIT,null,0,0,null,
																  null,null,null,null,null,null,null,null,null,null,null,null);
										EXCEPTION WHEN OTHERS THEN NULL;
										END;
					END;
					commit;
			end if;
			if to_number(facture_.INTER) <> 0 then
				v := v+1;
					V_PTA_ID := null;
					V_PSL_RANK := null;
					begin
					v_code:='INTERET';
						for x in C_ITEM(v_code) loop
						V_ITE_ID:=x.ite_id;
						V_ite_name:=x.ite_name
						V_VOW_UNIT:=x.VOW_UNIT
						end loop;
					EXCEPTION WHEN NO_DATA_FOUND THEN NULL;
					end;
					begin
					v_tva_taux:=0;
						for v in C_TVA(v_tva_taux) loop
						   V_tva_id:=v.tva_id; 
						end loop;
					EXCEPTION WHEN NO_DATA_FOUND THEN 
					V_tva_id := 25;
					end;
					select count(*) 
					into V_nbr 
					from genptaslice 
					where PTA_ID in (select PTA_ID 	from genitemperiodtarif 
									 where TAR_id in ( select tar_id from genitemtarif where ITE_ID=V_ITE_ID )
									);
					if V_nbr=1 then
					   select PTA_ID,PSL_RANK  
						into V_PTA_ID,V_PSL_RANK 
						from genptaslice 
						where PTA_ID in (select PTA_ID 
										 from genitemperiodtarif 
										 where TAR_id in (select tar_id from genitemtarif where ITE_ID=V_ITE_ID)
										)
						and rownum=1;
					end if;
					if V_nbr>1 then
						select PTA_ID,PSL_RANK  
						into V_PTA_ID,V_PSL_RANK 
						from genptaslice 
						where   PTA_ID
						in (select PTA_ID 
							from genitemperiodtarif
							where TAR_id in (select tar_id from genitemtarif where ITE_ID=V_ITE_ID) 
						   )and rownum=1;
					 
					end if;
					BEGIN
					insert into genbilline(BIL_ID,BLI_REVERSEBLI_ID,BLI_NUMBER,BLI_REVERSEBLINUMBER,BLI_NAME,BLI_EXERCICE,ITE_ID,PTA_ID,PSL_RANK,IMP_ID,BLI_VOLUMEBASE,BLI_VOLUMEFACT,
										   BLI_PUHT,TVA_ID,BLI_MHT,BLI_MTTVA,BLI_MTTC,BLI_STARTDT,BLI_ENDDT,VOW_UNIT,BLI_NBUNITES,BLI_DETAIL,BLI_CANCEL,IMC_ID,IMP_ANALYTIQUE_ID,
										   BLI_PERIODEINIT,BLI_PERIODE,BLI_REVERSEDT,BLI_CREDT,BLI_UPDTDT,BLI_UPDTBY,MEU_ID,BLI_NAME_A,BLI_REVERSEBLIDEC_ID,BLI_REVERSEBLINUMBERDEC,BLI_REVERSEDECDT)
									values(New_Genbill.BIL_ID,null,v,null,V_ite_name,v_anneereel,V_ITE_ID,V_PTA_ID,V_PSL_RANK,null,1,1,facture_.INTER/1000,V_TVA_ID,
										  facture_.INTER/1000,0,facture_.INTER/1000,New_genrun.RUN_STARTDT,V_FAC_DATECALCUL,V_VOW_UNIT,null,0,0,null,
										  null,null,null,null,null,null,null,null,null,null,null,null);
					EXCEPTION WHEN OTHERS THEN
										BEGIN
										insert into genbilline(BIL_ID,BLI_REVERSEBLI_ID,BLI_NUMBER,BLI_REVERSEBLINUMBER,BLI_NAME,BLI_EXERCICE,ITE_ID,PTA_ID,PSL_RANK,IMP_ID,BLI_VOLUMEBASE,BLI_VOLUMEFACT,
															   BLI_PUHT,TVA_ID,BLI_MHT,BLI_MTTVA,BLI_MTTC,BLI_STARTDT,BLI_ENDDT,VOW_UNIT,BLI_NBUNITES,BLI_DETAIL,BLI_CANCEL,IMC_ID,IMP_ANALYTIQUE_ID,
															   BLI_PERIODEINIT,BLI_PERIODE,BLI_REVERSEDT,BLI_CREDT,BLI_UPDTDT,BLI_UPDTBY,MEU_ID,BLI_NAME_A,BLI_REVERSEBLIDEC_ID,BLI_REVERSEBLINUMBERDEC,BLI_REVERSEDECDT)
														values(New_Genbill.BIL_ID,null,v+1,null,V_ite_name,v_anneereel,V_ITE_ID,V_PTA_ID,V_PSL_RANK,null,1,1,facture_.INTER/1000,V_TVA_ID,
															  facture_.INTER/1000,0,facture_.INTER/1000,New_genrun.RUN_STARTDT,V_FAC_DATECALCUL,V_VOW_UNIT,null,0,0,null,
															  null,null,null,null,null,null,null,null,null,null,null,null);
										EXCEPTION WHEN OTHERS THEN NULL;
										END;
					END;
					commit;
			end if;
			if to_number(facture_.RBRANCHE) <> 0 then
				v := v+1;
					V_PTA_ID := null;
					V_PSL_RANK := null;
					begin
					v_code:='COURETABBR';
						for x in C_ITEM(v_code) loop
						V_ITE_ID:=x.ite_id;
						V_ite_name:=x.ite_name
						V_VOW_UNIT:=x.VOW_UNIT
						end loop;
					EXCEPTION WHEN NO_DATA_FOUND THEN NULL;
					end;
					begin
					v_tva_taux:= 0;
						for v in C_TVA(v_tva_taux) loop
						   V_tva_id:=v.tva_id; 
						end loop;
					EXCEPTION WHEN NO_DATA_FOUND THEN 
					V_tva_id := 25;
					end;
					select count(*) 
					into V_nbr 
					from genptaslice 
					where PTA_ID in (select PTA_ID 	from genitemperiodtarif 
									 where TAR_id in ( select tar_id from genitemtarif where ITE_ID=V_ITE_ID )
									);
					if V_nbr=1 then
					   select PTA_ID,PSL_RANK  
						into V_PTA_ID,V_PSL_RANK 
						from genptaslice 
						where PTA_ID in (select PTA_ID 
										 from genitemperiodtarif 
										 where TAR_id in (select tar_id from genitemtarif where ITE_ID=V_ITE_ID)
										)
						and rownum=1;
					end if;
					if V_nbr>1 then
						select PTA_ID,PSL_RANK  
						into V_PTA_ID,V_PSL_RANK 
						from genptaslice 
						where   PTA_ID
						in (select PTA_ID 
							from genitemperiodtarif
							where TAR_id in (select tar_id from genitemtarif where ITE_ID=V_ITE_ID) 
						   )and rownum=1;
					end if;

					BEGIN
					insert into genbilline(BIL_ID,BLI_REVERSEBLI_ID,BLI_NUMBER,BLI_REVERSEBLINUMBER,BLI_NAME,BLI_EXERCICE,ITE_ID,PTA_ID,PSL_RANK,IMP_ID,BLI_VOLUMEBASE,BLI_VOLUMEFACT,
										   BLI_PUHT,TVA_ID,BLI_MHT,BLI_MTTVA,BLI_MTTC,BLI_STARTDT,BLI_ENDDT,VOW_UNIT,BLI_NBUNITES,BLI_DETAIL,BLI_CANCEL,IMC_ID,IMP_ANALYTIQUE_ID,
										   BLI_PERIODEINIT,BLI_PERIODE,BLI_REVERSEDT,BLI_CREDT,BLI_UPDTDT,BLI_UPDTBY,MEU_ID,BLI_NAME_A,BLI_REVERSEBLIDEC_ID,BLI_REVERSEBLINUMBERDEC,BLI_REVERSEDECDT)
									values(New_Genbill.BIL_ID,null,v,null,V_ite_name,v_anneereel,V_ITE_ID,V_PTA_ID,V_PSL_RANK,null,1,1,facture_.RBRANCHE/1000,V_TVA_ID,
										   facture_.RBRANCHE/1000,0,facture_.RBRANCHE/1000,New_genrun.RUN_STARTDT,V_FAC_DATECALCUL,V_VOW_UNIT,null,0,0,null,
										   null,null,null,null,null,null,null,null,null,null,null,null);
					EXCEPTION WHEN OTHERS THEN
										BEGIN
											insert into genbilline(BIL_ID,BLI_REVERSEBLI_ID,BLI_NUMBER,BLI_REVERSEBLINUMBER,BLI_NAME,BLI_EXERCICE,ITE_ID,PTA_ID,PSL_RANK,IMP_ID,BLI_VOLUMEBASE,BLI_VOLUMEFACT,
																   BLI_PUHT,TVA_ID,BLI_MHT,BLI_MTTVA,BLI_MTTC,BLI_STARTDT,BLI_ENDDT,VOW_UNIT,BLI_NBUNITES,BLI_DETAIL,BLI_CANCEL,IMC_ID,IMP_ANALYTIQUE_ID,
																   BLI_PERIODEINIT,BLI_PERIODE,BLI_REVERSEDT,BLI_CREDT,BLI_UPDTDT,BLI_UPDTBY,MEU_ID,BLI_NAME_A,BLI_REVERSEBLIDEC_ID,BLI_REVERSEBLINUMBERDEC,BLI_REVERSEDECDT)
															values(New_Genbill.BIL_ID,null,v+1,null,V_ite_name,v_anneereel,V_ITE_ID,V_PTA_ID,V_PSL_RANK,null,1,1,facture_.RBRANCHE/1000,V_TVA_ID,
																   facture_.RBRANCHE/1000,0,facture_.RBRANCHE/1000,New_genrun.RUN_STARTDT,V_FAC_DATECALCUL,V_VOW_UNIT,null,0,0,null,
																	null,null,null,null,null,null,null,null,null,null,null,null);
										EXCEPTION WHEN OTHERS THEN NULL;
										END;
					END;
					commit;
			end if;
			if to_number(facture_.RFACADE) <> 0 then
				v := v+1;
					V_PTA_ID := null;
					V_PSL_RANK := null;
					begin
					v_code:='RFACADE';
						for x in C_ITEM(v_code) loop
						V_ITE_ID:=x.ite_id;
						V_ite_name:=x.ite_name
						V_VOW_UNIT:=x.VOW_UNIT
						end loop;
					EXCEPTION WHEN NO_DATA_FOUND THEN NULL;
					end;
					begin
					v_tva_taux:= 0;
						for v in C_TVA(v_tva_taux) loop
						   V_tva_id:=v.tva_id; 
						end loop;
					EXCEPTION WHEN NO_DATA_FOUND THEN 
					V_tva_id := 25;
					end;
					select count(*) 
					into V_nbr 
					from genptaslice 
					where PTA_ID in (select PTA_ID 	from genitemperiodtarif 
									 where TAR_id in ( select tar_id from genitemtarif where ITE_ID=V_ITE_ID )
									);
					if V_nbr=1 then
						select PTA_ID,PSL_RANK  
						into V_PTA_ID,V_PSL_RANK 
						from genptaslice 
						where PTA_ID in (select PTA_ID 
										 from genitemperiodtarif 
										 where TAR_id in (select tar_id from genitemtarif where ITE_ID=V_ITE_ID)
										)
						and rownum=1;
					end if;
						if V_nbr>1 then
						select PTA_ID,PSL_RANK  
						into V_PTA_ID,V_PSL_RANK 
						from genptaslice 
						where   PTA_ID
						in (select PTA_ID 
							from genitemperiodtarif
							where TAR_id in (select tar_id from genitemtarif where ITE_ID=V_ITE_ID) 
						   )and rownum=1;
					end if;
					BEGIN
						insert into genbilline(BIL_ID,BLI_REVERSEBLI_ID,BLI_NUMBER,BLI_REVERSEBLINUMBER,BLI_NAME,BLI_EXERCICE,ITE_ID,PTA_ID,PSL_RANK,IMP_ID,BLI_VOLUMEBASE,BLI_VOLUMEFACT,
											   BLI_PUHT,TVA_ID,BLI_MHT,BLI_MTTVA,BLI_MTTC,BLI_STARTDT,BLI_ENDDT,VOW_UNIT,BLI_NBUNITES,BLI_DETAIL,BLI_CANCEL,IMC_ID,IMP_ANALYTIQUE_ID,
											   BLI_PERIODEINIT,BLI_PERIODE,BLI_REVERSEDT,BLI_CREDT,BLI_UPDTDT,BLI_UPDTBY,MEU_ID,BLI_NAME_A,BLI_REVERSEBLIDEC_ID,BLI_REVERSEBLINUMBERDEC,BLI_REVERSEDECDT)
										values(New_Genbill.BIL_ID,null,v,null,V_ite_name,v_anneereel,V_ITE_ID,V_PTA_ID,V_PSL_RANK,null,1,1,facture_.RFACADE/1000,V_TVA_ID,
											   facture_.RFACADE/1000,0,facture_.RFACADE/1000,New_genrun.RUN_STARTDT,V_FAC_DATECALCUL,V_VOW_UNIT,null,0,0,null,
											   null,null,null,null,null,null,null,null,null,null,null,null);
					EXCEPTION WHEN OTHERS THEN
										BEGIN
										   insert into genbilline(BIL_ID,BLI_REVERSEBLI_ID,BLI_NUMBER,BLI_REVERSEBLINUMBER,BLI_NAME,BLI_EXERCICE,ITE_ID,PTA_ID,PSL_RANK,IMP_ID,BLI_VOLUMEBASE,BLI_VOLUMEFACT,
																  BLI_PUHT,TVA_ID,BLI_MHT,BLI_MTTVA,BLI_MTTC,BLI_STARTDT,BLI_ENDDT,VOW_UNIT,BLI_NBUNITES,BLI_DETAIL,BLI_CANCEL,IMC_ID,IMP_ANALYTIQUE_ID,
																  BLI_PERIODEINIT,BLI_PERIODE,BLI_REVERSEDT,BLI_CREDT,BLI_UPDTDT,BLI_UPDTBY,MEU_ID,BLI_NAME_A,BLI_REVERSEBLIDEC_ID,BLI_REVERSEBLINUMBERDEC,BLI_REVERSEDECDT)
									values(New_Genbill.BIL_ID,null,v+1,null,V_ite_name,v_anneereel,V_ITE_ID,V_PTA_ID,V_PSL_RANK,null,1,1,facture_.RFACADE/1000,V_TVA_ID,
										   facture_.RFACADE/1000,0,facture_.RFACADE/1000,New_genrun.RUN_STARTDT,V_FAC_DATECALCUL,V_VOW_UNIT,null,0,0,null,
										   null,null,null,null,null,null,null,null,null,null,null,null);
										EXCEPTION WHEN OTHERS THEN NULL;
										END;
					END;
					commit;
			end if;
			if to_number(facture_.AREPOR) <> 0 then
				v := v+1;
					V_PTA_ID := null;
					V_PSL_RANK := null;
					begin
					v_code:='AREPOR';
						for x in C_ITEM(v_code) loop
						V_ITE_ID:=x.ite_id;
						V_ite_name:=x.ite_name
						V_VOW_UNIT:=x.VOW_UNIT
						end loop;
					EXCEPTION WHEN NO_DATA_FOUND THEN NULL;
					end;
					begin
					v_tva_taux:= 0;
						for v in C_TVA(v_tva_taux) loop
						   V_tva_id:=v.tva_id; 
						end loop;
					EXCEPTION WHEN NO_DATA_FOUND THEN 
					V_tva_id := 25;
					end;
					select count(*) 
					into V_nbr 
					from genptaslice 
					where PTA_ID in (select PTA_ID 	from genitemperiodtarif 
									 where TAR_id in ( select tar_id from genitemtarif where ITE_ID=V_ITE_ID )
									);
					if V_nbr=1 then
					   select PTA_ID,PSL_RANK  
						into V_PTA_ID,V_PSL_RANK 
						from genptaslice 
						where PTA_ID in (select PTA_ID 
										 from genitemperiodtarif 
										 where TAR_id in (select tar_id from genitemtarif where ITE_ID=V_ITE_ID)
										)
						and rownum=1;
					end if;
					if V_nbr>1 then
						select PTA_ID,PSL_RANK  
						into V_PTA_ID,V_PSL_RANK 
						from genptaslice 
						where   PTA_ID
						in (select PTA_ID 
							from genitemperiodtarif
							where TAR_id in (select tar_id from genitemtarif where ITE_ID=V_ITE_ID) 
						   )and rownum=1;
					end if;


					BEGIN
						insert into genbilline(BIL_ID,BLI_REVERSEBLI_ID,BLI_NUMBER,BLI_REVERSEBLINUMBER,BLI_NAME,BLI_EXERCICE,ITE_ID,PTA_ID,PSL_RANK,IMP_ID,BLI_VOLUMEBASE,BLI_VOLUMEFACT,
											   BLI_PUHT,TVA_ID,BLI_MHT,BLI_MTTVA,BLI_MTTC,BLI_STARTDT,BLI_ENDDT,VOW_UNIT,BLI_NBUNITES,BLI_DETAIL,BLI_CANCEL,IMC_ID,IMP_ANALYTIQUE_ID,
											   BLI_PERIODEINIT,BLI_PERIODE,BLI_REVERSEDT,BLI_CREDT,BLI_UPDTDT,BLI_UPDTBY,MEU_ID,BLI_NAME_A,BLI_REVERSEBLIDEC_ID,BLI_REVERSEBLINUMBERDEC,BLI_REVERSEDECDT)
										values(New_Genbill.BIL_ID,null,v,null,V_ite_name,v_anneereel,V_ITE_ID,V_PTA_ID,V_PSL_RANK,null,1,1,decode(facture_.caron,'1',1,-1)* (facture_.AREPOR/1000),V_TVA_ID			,--14
											   decode(facture_.caron,'1',1,-1)* (facture_.AREPOR/1000),0,decode(facture_.caron,'1',1,-1)* (facture_.AREPOR/1000),New_genrun.RUN_STARTDT,V_FAC_DATECALCUL,V_VOW_UNIT,null,0,0,null,
											   null,null,null,null,null,null,null,null,null,null,null,null);
					EXCEPTION WHEN OTHERS THEN
										BEGIN
										insert into genbilline(BIL_ID,BLI_REVERSEBLI_ID,BLI_NUMBER,BLI_REVERSEBLINUMBER,BLI_NAME,BLI_EXERCICE,ITE_ID,PTA_ID,PSL_RANK,IMP_ID,BLI_VOLUMEBASE,BLI_VOLUMEFACT,
															   BLI_PUHT,TVA_ID,BLI_MHT,BLI_MTTVA,BLI_MTTC,BLI_STARTDT,BLI_ENDDT,VOW_UNIT,BLI_NBUNITES,BLI_DETAIL,BLI_CANCEL,IMC_ID,IMP_ANALYTIQUE_ID,
															   BLI_PERIODEINIT,BLI_PERIODE,BLI_REVERSEDT,BLI_CREDT,BLI_UPDTDT,BLI_UPDTBY,MEU_ID,BLI_NAME_A,BLI_REVERSEBLIDEC_ID,BLI_REVERSEBLINUMBERDEC,BLI_REVERSEDECDT)
														values(New_Genbill.BIL_ID,null,v+1,null,V_ite_name,v_anneereel,V_ITE_ID,V_PTA_ID,V_PSL_RANK,null,1,1,decode(facture_.caron,'1',1,-1)* (facture_.AREPOR/1000),V_TVA_ID			,--14
															   decode(facture_.caron,'1',1,-1)* (facture_.AREPOR/1000),0,decode(facture_.caron,'1',1,-1)* (facture_.AREPOR/1000),New_genrun.RUN_STARTDT,V_FAC_DATECALCUL,V_VOW_UNIT,null,0,0,null,
															   null,null,null,null,null,null,null,null,null,null,null,null);
										EXCEPTION WHEN OTHERS THEN NULL;
										END;
					END;
					commit;
			end if;
			if to_number(facture_.NAROND) <> 0 then
				v := v+1;
					V_PTA_ID := null;
					V_PSL_RANK := null;
					begin
						v_code:='NAROND';
							for x in C_ITEM(v_code) loop
							V_ITE_ID:=x.ite_id;
							V_ite_name:=x.ite_name
							V_VOW_UNIT:=x.VOW_UNIT
							end loop;
					EXCEPTION WHEN NO_DATA_FOUND THEN NULL;
					end;
					begin
					v_tva_taux:= 0;
						for v in C_TVA(v_tva_taux) loop
						   V_tva_id:=v.tva_id; 
						end loop;
					EXCEPTION WHEN NO_DATA_FOUND THEN 
					V_tva_id := 25;
					end;
					select count(*) 
					into V_nbr 
					from genptaslice 
					where PTA_ID in (select PTA_ID 	from genitemperiodtarif 
									 where TAR_id in ( select tar_id from genitemtarif where ITE_ID=V_ITE_ID )
									);
					if V_nbr=1 then
					   select PTA_ID,PSL_RANK  
						into V_PTA_ID,V_PSL_RANK 
						from genptaslice 
						where PTA_ID in (select PTA_ID 
										 from genitemperiodtarif 
										 where TAR_id in (select tar_id from genitemtarif where ITE_ID=V_ITE_ID)
										)
						and rownum=1;
					end if;
					if V_nbr>1 then
						select PTA_ID,PSL_RANK  
						into V_PTA_ID,V_PSL_RANK 
						from genptaslice 
						where   PTA_ID
						in (select PTA_ID 
							from genitemperiodtarif
							where TAR_id in (select tar_id from genitemtarif where ITE_ID=V_ITE_ID) 
						   )and rownum=1;
					end if;
					BEGIN
						insert into genbilline(BIL_ID,BLI_REVERSEBLI_ID,BLI_NUMBER,BLI_REVERSEBLINUMBER,BLI_NAME,BLI_EXERCICE,ITE_ID,PTA_ID,PSL_RANK,IMP_ID,BLI_VOLUMEBASE,BLI_VOLUMEFACT,
											   BLI_PUHT,TVA_ID,BLI_MHT,BLI_MTTVA,BLI_MTTC,BLI_STARTDT,BLI_ENDDT,VOW_UNIT,BLI_NBUNITES,BLI_DETAIL,BLI_CANCEL,IMC_ID,IMP_ANALYTIQUE_ID,
											   BLI_PERIODEINIT,BLI_PERIODE,BLI_REVERSEDT,BLI_CREDT,BLI_UPDTDT,BLI_UPDTBY,MEU_ID,BLI_NAME_A,BLI_REVERSEBLIDEC_ID,BLI_REVERSEBLINUMBERDEC,BLI_REVERSEDECDT)
									   values(New_Genbill.BIL_ID,null,v,null,V_ite_name,v_anneereel,V_ITE_ID,V_PTA_ID,V_PSL_RANK,null,1,1,decode(facture_.caron,'1',-1,1)*(facture_.NAROND/1000),V_TVA_ID,
											  decode(facture_.caron,'1',-1,1)*(facture_.NAROND/1000),0,decode(facture_.caron,'1',-1,1)*(facture_.NAROND/1000),New_genrun.RUN_STARTDT,V_FAC_DATECALCUL,V_VOW_UNIT,null,0,0,null,
											  null,null,null,null,null,null,null,null,null,null,null,null);	 
					EXCEPTION WHEN OTHERS THEN
										BEGIN
										insert into genbilline(BIL_ID,BLI_REVERSEBLI_ID,BLI_NUMBER,BLI_REVERSEBLINUMBER,BLI_NAME,BLI_EXERCICE,ITE_ID,PTA_ID,PSL_RANK,IMP_ID,BLI_VOLUMEBASE,BLI_VOLUMEFACT,
															   BLI_PUHT,TVA_ID,BLI_MHT,BLI_MTTVA,BLI_MTTC,BLI_STARTDT,BLI_ENDDT,VOW_UNIT,BLI_NBUNITES,BLI_DETAIL,BLI_CANCEL,IMC_ID,IMP_ANALYTIQUE_ID,
															   BLI_PERIODEINIT,BLI_PERIODE,BLI_REVERSEDT,BLI_CREDT,BLI_UPDTDT,BLI_UPDTBY,MEU_ID,BLI_NAME_A,BLI_REVERSEBLIDEC_ID,BLI_REVERSEBLINUMBERDEC,BLI_REVERSEDECDT)
													   values(New_Genbill.BIL_ID,null,v+1,null,V_ite_name,v_anneereel,V_ITE_ID,V_PTA_ID,V_PSL_RANK,null,1,1,decode(facture_.caron,'1',-1,1)*(facture_.NAROND/1000),V_TVA_ID,
															  decode(facture_.caron,'1',-1,1)*(facture_.NAROND/1000),0,decode(facture_.caron,'1',-1,1)*(facture_.NAROND/1000),New_genrun.RUN_STARTDT,V_FAC_DATECALCUL,V_VOW_UNIT,null,0,0,null,
															  null,null,null,null,null,null,null,null,null,null,null,null);	 
										EXCEPTION WHEN OTHERS THEN NULL;
										END;
						END;
						commit;
			end if;
			 if to_number(facture_.deplacement) <> 0 then 
				v := v+1;
					V_PTA_ID := null;
					V_PSL_RANK := null;
					begin
					v_code:='F_DEPLACEMNT';
						for x in C_ITEM(v_code) loop
						V_ITE_ID:=x.ite_id;
						V_ite_name:=x.ite_name
						V_VOW_UNIT:=x.VOW_UNIT
						end loop;
					EXCEPTION WHEN NO_DATA_FOUND THEN NULL;
					end;
					begin
					v_tva_taux:= 18;
						for v in C_TVA(v_tva_taux) loop
						   V_tva_id:=v.tva_id; 
						end loop;
					EXCEPTION WHEN NO_DATA_FOUND THEN 
					V_tva_id := 25;
					end;				
					select count(*) 
					into V_nbr 
					from genptaslice 
					where PTA_ID in (select PTA_ID 	from genitemperiodtarif 
									 where TAR_id in ( select tar_id from genitemtarif where ITE_ID=V_ITE_ID )
									);
					if V_nbr=1 then
						select PTA_ID,PSL_RANK  
						into V_PTA_ID,V_PSL_RANK 
						from genptaslice 
						where PTA_ID in (select PTA_ID 
										 from genitemperiodtarif 
										 where TAR_id in (select tar_id from genitemtarif where ITE_ID=V_ITE_ID)
										)
						and rownum=1;
					end if;
					if V_nbr>1 then
						select PTA_ID,PSL_RANK  
						into V_PTA_ID,V_PSL_RANK 
						from genptaslice 
						where   PTA_ID
						in (select PTA_ID 
							from genitemperiodtarif
							where TAR_id in (select tar_id from genitemtarif where ITE_ID=V_ITE_ID) 
						   )and rownum=1;
					end if;
					BEGIN
						insert into genbilline(BIL_ID,BLI_REVERSEBLI_ID,BLI_NUMBER,BLI_REVERSEBLINUMBER,BLI_NAME,BLI_EXERCICE,ITE_ID,PTA_ID,PSL_RANK,IMP_ID,BLI_VOLUMEBASE,BLI_VOLUMEFACT,
											   BLI_PUHT,TVA_ID,BLI_MHT,BLI_MTTVA,BLI_MTTC,BLI_STARTDT,BLI_ENDDT,VOW_UNIT,BLI_NBUNITES,BLI_DETAIL,BLI_CANCEL,IMC_ID,IMP_ANALYTIQUE_ID,
											   BLI_PERIODEINIT,BLI_PERIODE,BLI_REVERSEDT,BLI_CREDT,BLI_UPDTDT,BLI_UPDTBY,MEU_ID,BLI_NAME_A,BLI_REVERSEBLIDEC_ID,BLI_REVERSEBLINUMBERDEC,BLI_REVERSEDECDT)
									  values(New_Genbill.BIL_ID,null,v,null,V_ite_name,v_anneereel,V_ITE_ID,V_PTA_ID,V_PSL_RANK,null,1,1,facture_.deplacement/1000,V_TVA_ID,
											 facture_.deplacement/1000,facture_.tvadeplac/1000 ,facture_.deplacement/1000 + (facture_.tvadeplac/1000),New_genrun.RUN_STARTDT,V_FAC_DATECALCUL,V_VOW_UNIT,null,0,0,null,
											null,null,null,null,null,null,null,null,null,null,null,null);	 
					EXCEPTION WHEN OTHERS THEN
										BEGIN
										insert into genbilline(BIL_ID,BLI_REVERSEBLI_ID,BLI_NUMBER,BLI_REVERSEBLINUMBER,BLI_NAME,BLI_EXERCICE,ITE_ID,PTA_ID,PSL_RANK,IMP_ID,BLI_VOLUMEBASE,BLI_VOLUMEFACT,
															   BLI_PUHT,TVA_ID,BLI_MHT,BLI_MTTVA,BLI_MTTC,BLI_STARTDT,BLI_ENDDT,VOW_UNIT,BLI_NBUNITES,BLI_DETAIL,BLI_CANCEL,IMC_ID,IMP_ANALYTIQUE_ID,
															   BLI_PERIODEINIT,BLI_PERIODE,BLI_REVERSEDT,BLI_CREDT,BLI_UPDTDT,BLI_UPDTBY,MEU_ID,BLI_NAME_A,BLI_REVERSEBLIDEC_ID,BLI_REVERSEBLINUMBERDEC,BLI_REVERSEDECDT)
													  values(New_Genbill.BIL_ID,null,v+1,null,V_ite_name,v_anneereel,V_ITE_ID,V_PTA_ID,V_PSL_RANK,null,1,1,facture_.deplacement/1000,V_TVA_ID,
															 facture_.deplacement/1000,facture_.tvadeplac/1000 ,facture_.deplacement/1000 + (facture_.tvadeplac/1000),New_genrun.RUN_STARTDT,V_FAC_DATECALCUL,V_VOW_UNIT,null,0,0,null,
															 null,null,null,null,null,null,null,null,null,null,null,null);
										EXCEPTION WHEN OTHERS THEN NULL;
										END;
					END;
					commit;
			 end if;
			 if to_number(facture_.depose_dem) <> 0 then
				v := v+1;
					V_PTA_ID := null;
					V_PSL_RANK := null;
					begin
					v_code:='FRAIS_FRM_DEP';
						for x in C_ITEM(v_code) loop
						V_ITE_ID:=x.ite_id;
						V_ite_name:=x.ite_name
						V_VOW_UNIT:=x.VOW_UNIT
						end loop;
					EXCEPTION WHEN NO_DATA_FOUND THEN NULL;
					end;
					begin
					v_tva_taux:= 18;
						for v in C_TVA(v_tva_taux) loop
						   V_tva_id:=v.tva_id; 
						end loop;
					EXCEPTION WHEN NO_DATA_FOUND THEN 
					 V_tva_id := 25;
					end;
					select count(*) 
					into V_nbr 
					from genptaslice 
					where PTA_ID in (select PTA_ID 	from genitemperiodtarif 
									 where TAR_id in ( select tar_id from genitemtarif where ITE_ID=V_ITE_ID )
									);
					if V_nbr=1 then
						select PTA_ID,PSL_RANK  
						into V_PTA_ID,V_PSL_RANK 
						from genptaslice 
						where PTA_ID in (select PTA_ID 
										 from genitemperiodtarif 
										 where TAR_id in (select tar_id from genitemtarif where ITE_ID=V_ITE_ID)
										)
						and rownum=1;
					
					end if;
					if V_nbr>1 then
						select PTA_ID,PSL_RANK  
						into V_PTA_ID,V_PSL_RANK 
						from genptaslice 
						where   PTA_ID
						in (select PTA_ID 
							from genitemperiodtarif
							where TAR_id in (select tar_id from genitemtarif where ITE_ID=V_ITE_ID) 
						   )
						   and rownum=1;
					end if;

					BEGIN
						insert into genbilline(BIL_ID,BLI_REVERSEBLI_ID,BLI_NUMBER,BLI_REVERSEBLINUMBER,BLI_NAME,BLI_EXERCICE,ITE_ID,PTA_ID,PSL_RANK,IMP_ID,BLI_VOLUMEBASE,BLI_VOLUMEFACT,
											   BLI_PUHT,TVA_ID,BLI_MHT,BLI_MTTVA,BLI_MTTC,BLI_STARTDT,BLI_ENDDT,VOW_UNIT,BLI_NBUNITES,BLI_DETAIL,BLI_CANCEL,IMC_ID,IMP_ANALYTIQUE_ID,
											   BLI_PERIODEINIT,BLI_PERIODE,BLI_REVERSEDT,BLI_CREDT,BLI_UPDTDT,BLI_UPDTBY,MEU_ID,BLI_NAME_A,BLI_REVERSEBLIDEC_ID,BLI_REVERSEBLINUMBERDEC,BLI_REVERSEDECDT)
								  values(New_Genbill.BIL_ID,null,v,null,V_ite_name,v_anneereel,V_ITE_ID,V_PTA_ID,V_PSL_RANK,null,1,1,facture_.depose_dem/1000,V_TVA_ID,
										facture_.depose_dem/1000,facture_.tvadepose_dem/1000,facture_.depose_dem/1000 + (facture_.tvadepose_dem/1000),New_genrun.RUN_STARTDT,V_FAC_DATECALCUL,V_VOW_UNIT,null,0,0,null,
										null,null,null,null,null,null,null,null,null,null,null,null);
										EXCEPTION WHEN OTHERS THEN
											BEGIN
												insert into genbilline(BIL_ID,BLI_REVERSEBLI_ID,BLI_NUMBER,BLI_REVERSEBLINUMBER,BLI_NAME,BLI_EXERCICE,ITE_ID,PTA_ID,PSL_RANK,IMP_ID,BLI_VOLUMEBASE,BLI_VOLUMEFACT,
																	   BLI_PUHT,TVA_ID,BLI_MHT,BLI_MTTVA,BLI_MTTC,BLI_STARTDT,BLI_ENDDT,VOW_UNIT,BLI_NBUNITES,BLI_DETAIL,BLI_CANCEL,IMC_ID,IMP_ANALYTIQUE_ID,
																	   BLI_PERIODEINIT,BLI_PERIODE,BLI_REVERSEDT,BLI_CREDT,BLI_UPDTDT,BLI_UPDTBY,MEU_ID,BLI_NAME_A,BLI_REVERSEBLIDEC_ID,BLI_REVERSEBLINUMBERDEC,BLI_REVERSEDECDT)
															  values(New_Genbill.BIL_ID,null,v+1,null,V_ite_name,v_anneereel,V_ITE_ID,V_PTA_ID,V_PSL_RANK,null,1,1,facture_.depose_dem/1000,V_TVA_ID,
																	facture_.depose_dem/1000,facture_.tvadepose_dem/1000,facture_.depose_dem/1000 + (facture_.tvadepose_dem/1000),New_genrun.RUN_STARTDT,V_FAC_DATECALCUL,V_VOW_UNIT,null,0,0,null,
																	null,null,null,null,null,null,null,null,null,null,null,null); 
											EXCEPTION WHEN OTHERS THEN NULL;
											END;
					END;
					commit;
			end if;		 
			if to_number(facture_.depose_def) <> 0 then
				v := v+1;
					V_PTA_ID := null;
					V_PSL_RANK := null;
					begin
					v_code:='FRS_DPOZ_RPOZ';
						for x in C_ITEM(v_code) loop
						V_ITE_ID:=x.ite_id;
						V_ite_name:=x.ite_name
						V_VOW_UNIT:=x.VOW_UNIT
						end loop;
					EXCEPTION WHEN NO_DATA_FOUND THEN NULL;
					end;
					begin
					v_tva_taux:= 18;
						for v in C_TVA(v_tva_taux) loop
						   V_tva_id:=v.tva_id; 
						end loop;
					EXCEPTION WHEN NO_DATA_FOUND THEN 
					V_tva_id := 25;
					end;
					select count(*) 
					into V_nbr 
					from genptaslice 
					where PTA_ID in (select PTA_ID 	from genitemperiodtarif 
									 where TAR_id in ( select tar_id from genitemtarif where ITE_ID=V_ITE_ID )
									);
					if V_nbr=1 then
						select PTA_ID,PSL_RANK  
						into V_PTA_ID,V_PSL_RANK 
						from genptaslice 
						where PTA_ID in (select PTA_ID 
										 from genitemperiodtarif 
										 where TAR_id in (select tar_id from genitemtarif where ITE_ID=V_ITE_ID)
										)
						and rownum=1;
					end if;
					if V_nbr>1 then
						select PTA_ID,PSL_RANK  
						into V_PTA_ID,V_PSL_RANK 
						from genptaslice 
						where   PTA_ID
						in (select PTA_ID 
							from genitemperiodtarif
							where TAR_id in (select tar_id from genitemtarif where ITE_ID=V_ITE_ID) 
						   )and rownum=1;
					end if;

					BEGIN
						insert into genbilline(BIL_ID,BLI_REVERSEBLI_ID,BLI_NUMBER,BLI_REVERSEBLINUMBER,BLI_NAME,BLI_EXERCICE,ITE_ID,PTA_ID,PSL_RANK,IMP_ID,BLI_VOLUMEBASE,BLI_VOLUMEFACT,
											   BLI_PUHT,TVA_ID,BLI_MHT,BLI_MTTVA,BLI_MTTC,BLI_STARTDT,BLI_ENDDT,VOW_UNIT,BLI_NBUNITES,BLI_DETAIL,BLI_CANCEL,IMC_ID,IMP_ANALYTIQUE_ID,
											   BLI_PERIODEINIT,BLI_PERIODE,BLI_REVERSEDT,BLI_CREDT,BLI_UPDTDT,BLI_UPDTBY,MEU_ID,BLI_NAME_A,BLI_REVERSEBLIDEC_ID,BLI_REVERSEBLINUMBERDEC,BLI_REVERSEDECDT)
										values(New_Genbill.BIL_ID,null,v,null,V_ite_name,v_anneereel,V_ITE_ID,V_PTA_ID,V_PSL_RANK,null,1,1,facture_.depose_def/1000,V_TVA_ID,
											   facture_.depose_def/1000,facture_.tvadepose_def/1000,facture_.depose_def/1000 + (facture_.tvadepose_def/1000),New_genrun.RUN_STARTDT,V_FAC_DATECALCUL,V_VOW_UNIT,null,0,0,null,
											   null,null,null,null,null,null,null,null,null,null,null,null); 
					EXCEPTION WHEN OTHERS THEN
											BEGIN
											  insert into genbilline(BIL_ID,BLI_REVERSEBLI_ID,BLI_NUMBER,BLI_REVERSEBLINUMBER,BLI_NAME,BLI_EXERCICE,ITE_ID,PTA_ID,PSL_RANK,IMP_ID,BLI_VOLUMEBASE,BLI_VOLUMEFACT,
																	BLI_PUHT,TVA_ID,BLI_MHT,BLI_MTTVA,BLI_MTTC,BLI_STARTDT,BLI_ENDDT,VOW_UNIT,BLI_NBUNITES,BLI_DETAIL,BLI_CANCEL,IMC_ID,IMP_ANALYTIQUE_ID,
																	BLI_PERIODEINIT,BLI_PERIODE,BLI_REVERSEDT,BLI_CREDT,BLI_UPDTDT,BLI_UPDTBY,MEU_ID,BLI_NAME_A,BLI_REVERSEBLIDEC_ID,BLI_REVERSEBLINUMBERDEC,BLI_REVERSEDECDT)
															values(New_Genbill.BIL_ID,null,v+1,null,V_ite_name,v_anneereel,V_ITE_ID,V_PTA_ID,V_PSL_RANK,null,1,1,facture_.depose_def/1000,V_TVA_ID,
																   facture_.depose_def/1000,facture_.tvadepose_def/1000,facture_.depose_def/1000 + (facture_.tvadepose_def/1000),New_genrun.RUN_STARTDT,V_FAC_DATECALCUL,V_VOW_UNIT,null,0,0,null,
																	null,null,null,null,null,null,null,null,null,null,null,null); 
											EXCEPTION WHEN OTHERS THEN NULL;
											END;
					END;
			commit;
			end if;
		end loop;
	end loop;	
--------------------------------------------------------------------------------------
------FACTURE_DIST -------------FACTURE_DIST ----------------------FACTURE_DIST ------	
--------------------------------------------------------------------------------------
	FOR facture_ in fact_Dist LOOP
	    FOR x in branch_(lpad(facture_.DIST, 2, '0'),lpad(trim(facture_.TOU), 3, '0'),lpad(trim(facture_.ORD), 3, '0'))LOOP		
        select seq_genrun.nextval     into genrun_id     from dual;
		select seq_agrbill.nextval    into Agrbill_Id    from dual;
		select seq_gendebt.nextval    into Debt_Id       from dual;
		select seq_genimp.nextval     into genimp_id     from dual;
		select seq_agrsagaco.nextval  into agrsagaco_id  from dual;
		select seq_genaccount.nextval into genaccount_id from dual;
		V_FAC_DATECALCUL :=null;
		V_FAC_DATELIM    :=null;
		V_TRAIN_FACT     :=null;
		V_AMOUNTTTCDEC   :=null;
		V_ID_FACTURE:= lpad(trim(facture_.district),2,'0')||lpad(trim(facture_.tournee),3,'0')||lpad(trim(facture_.ordre),3,'0')||to_char(facture_.annee)||lpad(to_char(facture_.periode),2,0)||to_char(v_version);
        
		select last_day(to_date('01'||lpad(trim(facture_.periode),2,'0')||facture_.annee,'dd/mm/yy'))
	    into v_date
	    from dual;
		begin
	    V_FAC_DATECALCUL := v_date;
	    Exception  when others then
	    V_FAC_DATECALCUL := '01/01/2016';
	    end;
		
        V_anneereel:=facture_.annee;
		V_periode:= facture_.periode;
		V_pdl_ref := lpad(trim(facture_.DISTRICT),2,'0')||lpad(trim(facture_.tournee),3,'0')||lpad(trim(facture_.Ordre),3,'0')||lpad(trim(facture_.POLICE),5,'0');
        V_REF_ABN := lpad(trim(facture_.DISTRICT),2,'0')||lpad(trim(facture_.POLICE),5,'0')||lpad(trim(facture_.tournee),3,'0')||lpad(trim(facture_.Ordre),3,'0');
        
		select NTIERS,NSIXIEME
		into V_tiers,V_six
		from tourne
		where trim(code)=lpad(trim(facture_.tournee),3,'0')
		and  trim(district)=trim(facture_.DISTRICT);
        
		V_TRAIN_FACT :='ANNEE:'||trim(facture_.annee)||' TRIM:'||trim(facture_.periode)||' TIER:'||trim(V_tiers)||' SIX:'||trim(V_six );
		
		select g.org_id	
		into V_ORG_ID 
		from GENORGANIZATION g 
		where upper(g.org_code)=lpad(trim(facture_.dist),2,'0');
		
		select cag.par_id  
		into v_PAR_ID
		from AGRCUSTOMERAGR cag
		where cag.cag_id in (select sag.cag_id
							 from TECSERVICEPOINT spt,
								  AGRSERVICEAGR sag
							 where spt.spt_id=sag.spt_id
							 and spt.spt_refe=V_pdl_ref);
		select par.adr_id
		into   V_ADR_ID
		from   GENPARTY  par
		where par.par_id=v_PAR_ID;		

		select sag.sag_id ,sag.sag_startdt
		into V_SAG_ID,V_ABN_DT_DEB
		from AGRSERVICEAGR sag,
			 TECSERVICEPOINT spt
		where sag.spt_id=spt.spt_id 
		and spt.spt_refe=V_pdl_ref;		
		
		select count(*) into v_nbr from genbill b where b.BIL_CODE=V_ID_FACTURE;
		
		V_COMPTEAUX:='IMP_MIG'			   
		V_TOTHTE:=(facture_.net_a_payer/1000);
		V_TVA:=0
		V_TOTHTA:=0;
		V_TOTTVAA:=0;
		V_SOLDE:=(facture_.net_a_payer/1000);
        
		if v_nbr=1 then
		    New_Det     := null;
		    New_Genbill := null;
		    New_genrun  := null;
 --------------------------------------------------------Traitement Role
			If v_anneereel is not null and V_periode is not null and V_TRAIN_FACT is not null then
				New_genrun.RUN_EXERCICE   :=  V_anneereel ;
				New_genrun.RUN_NUMBER     :=  V_periode;
				New_genrun.ORG_ID         :=  V_ORG_ID ;
				New_genrun.RUN_STARTDT    :=  V_FAC_DATECALCUL;
				New_genrun.RUN_COMMENT    :=  'Role migré' ;
				New_genrun.RUN_NAME       :=  'Role '||V_TRAIN_FACT ;
				Genere_genrun(New_genrun,genrun_id,genrun_ref);
			end if ;
--------------------------------------------------------Traitement Det
			New_Det.DEB_ID           :=  Debt_Id ;
			New_Det.DEB_REFE         :=  V_ID_FACTURE;
			New_Det.ORG_ID           :=  V_ORG_ID ;
			New_Det.PAR_ID           :=  V_PAR_ID ;
			New_Det.ADR_ID           :=  V_adr_id ;
			New_Det.DEB_DATE         :=  V_FAC_DATECALCUL ;
			New_Det.DEB_DUEDT        :=  V_FAC_DATECALCUL;
			New_Det.DEB_PRINTDT      :=  V_FAC_DATECALCUL;
			New_Det.SAG_ID           :=  V_SAG_ID ;
			New_Det.DEB_PREL         :=  1 ;
			If (V_TOTHTE+ V_TOTTVAE+V_TOTHTA+V_TOTTVAA) > 0 then --- Facture Normal else Facture Avoire
			New_Det.DEB_AMOUNTINIT   := V_TOTHTE+V_TOTTVAE+V_TOTHTA+V_TOTTVAA ;
			New_Det.VOW_DEBTYPE      := pk_genvocword.getidbycode('VOW_DEBTYPE','FA',null) ;
			else
			New_Det.deb_amount_cash  := -(V_TOTHTE+V_TOTTVAE+V_TOTHTA+V_TOTTVAA) ;
			New_Det.DEB_AMOUNTINIT   := 0;
			New_Det.VOW_DEBTYPE      := pk_genvocword.getidbycode('VOW_DEBTYPE','AV',null) ;
			end if ;

			New_Det.DEB_AMOUNTREMAIN := V_SOLDE ;
			New_Det.DEB_COMMENT      := V_REF_ABN ;
			New_Det.VOW_SETTLEMODE   := pk_genvocword.getidbycode('VOW_SETTLEMODE',4,null) ;
----------------------------------------------------------Traitement GENACCOUNT ,GENIMP
			New_genimp.imp_code      := V_COMPTEAUX ;
			New_genimp.imp_name      := V_COMPTEAUX ;
			New_genimp.vow_budgtp    := pk_genvocword.getidbycode('VOW_BUDGTP','EA',null);
			Genere_genimp (New_genimp ,genimp_id,genimp_ref);
			New_genaccount.PAR_ID    := V_PAR_ID ;
			New_genaccount.IMP_ID    := genimp_ref ;
			New_genaccount.VOW_ACOTP := pk_genvocword.getidbycode('VOW_ACOTP','1',null);
			New_genaccount.REC_ID    := null ;
			New_agrsagaco.SAG_ID     := V_SAG_ID ;
			New_agrsagaco.SCO_STARTDT:= V_ABN_DT_DEB ;
			Genere_genaccount (New_genaccount ,genaccount_id ,genaccount_ref ,agrsagaco_id,New_agrsagaco) ;
            New_Det.ACO_ID           := genaccount_ref ;
			New_Det.DEB_NORECOVERY   := 0;
			 
				Insert into gendebt(deb_id,deb_refe,org_id,par_id,adr_id,deb_date,deb_duedt,deb_printdt,deb_amountinit,deb_amountremain,bap_id,
									vow_settlemode,aco_id,deb_norecovery,deb_credt,deb_updtby,deb_updtdt,deb_comment,sag_id,vow_debtype,deb_prel)
							values (New_Det.deb_id,New_Det.deb_refe,New_Det.org_id,New_Det.par_id,New_Det.adr_id,New_Det.deb_date,New_Det.deb_duedt,New_Det.deb_printdt,
									New_Det.deb_amountinit,New_Det.deb_amountremain,New_Det.bap_id,New_Det.vow_settlemode,New_Det.aco_id,New_Det.deb_norecovery,New_Det.deb_credt,
									New_Det.deb_updtby,New_Det.deb_updtdt,New_Det.DEB_COMMENT,nvl(New_Det.deb_amount_cash,0),New_Det.SAG_ID,New_Det.VOW_DEBTYPE,New_Det.DEB_PREL);	
				commit;
--------------------------------------------------------Traitement agrbill
			New_Agrbill.BIL_ID            :=  Agrbill_Id ;
			New_Agrbill.SAG_ID            :=  Fac.SAG_ID;
			New_Agrbill.VOW_AGRBILLTYPE   :=  pk_genvocword.getidbycode('VOW_AGRBILLTYPE',Fac.Mfae_Type,null) ;
			New_Agrbill.VOW_MODEFACT      :=  pk_genvocword.getidbycode('VOW_MODEFACT',Fac.VOC_MODEFACT,null) ;
			Insert into agrbill (BIL_ID,SAG_ID,VOW_AGRBILLTYPE,VOW_MODEFACT)
							  values(New_Agrbill.BIL_ID,New_Agrbill.SAG_ID,New_Agrbill.VOW_AGRBILLTYPE,New_Agrbill.VOW_MODEFACT);	
			commit;
--------------------------------------------------------Traitement genbill
            New_Genbill.BIL_ID            :=  Agrbill_Id;
			New_Genbill.BIL_CODE          :=  V_ID_FACTURE;
			New_Genbill.BIL_CALCDT        :=  V_FAC_DATECALCUL;
			New_Genbill.BIL_AMOUNTHT      :=  V_TOTHTE +V_TOTHTA ;
			New_Genbill.BIL_AMOUNTTVA     :=  V_TOTTVAE+V_TOTTVAA ;
			New_Genbill.BIL_AMOUNTTTC     :=  V_TOTHTE+V_TOTTVAE+V_TOTHTA+V_TOTTVAA ;
			New_Genbill.BIL_AMOUNTTTCDEC  :=  V_AMOUNTTTCDEC ;
			New_Genbill.BIL_STATUS        :=  1;
			New_Genbill.DEB_ID            :=  Debt_Id;
			New_Genbill.PAR_ID            :=  V_PAR_ID ;
			New_Genbill.BIL_DEBTDT        :=  V_FAC_DATECALCUL;
			New_Genbill.RUN_ID            :=  genrun_ref  ;
				
					Insert into genbill(BIL_ID,BIL_CODE,BIL_CALCDT,BIL_AMOUNTHT,BIL_AMOUNTTVA,BIL_AMOUNTTTC,DEB_ID,PAR_ID,BIL_STATUS,BIL_AMOUNTTTCDEC,BIL_DEBTDT,RUN_ID)
							 values(New_Genbill.BIL_ID,New_Genbill.BIL_CODE,New_Genbill.BIL_CALCDT,New_Genbill.BIL_AMOUNTHT,New_Genbill.BIL_AMOUNTTVA,New_Genbill.BIL_AMOUNTTTC,
									New_Genbill.DEB_ID,New_Genbill.PAR_ID,New_Genbill.BIL_STATUS,New_Genbill.BIL_AMOUNTTTCDEC,New_Genbill.BIL_DEBTDT,New_Genbill.RUN_ID); 
							commit;
			end if;
			commit;
	    end loop;
	end loop;
-----------------------------------------------------------------------------------------------------
--------FACTURE_VERSION----------------FACTURE_VERSION--------------------------FACTURE_VERSION------	
-----------------------------------------------------------------------------------------------------	
    FOR facture_ in fact_vers LOOP
	
	    FOR x in branch_(lpad(facture_.DIST, 2, '0'),lpad(trim(facture_.TOU), 3, '0'),lpad(trim(facture_.ORD), 3, '0'))LOOP	
			
			select seq_genrun.nextval     into genrun_id     from dual;
			select seq_agrbill.nextval    into Agrbill_Id    from dual;
			select seq_gendebt.nextval    into Debt_Id       from dual;
			select seq_genimp.nextval     into genimp_id     from dual;
			select seq_agrsagaco.nextval  into agrsagaco_id  from dual;
			select seq_genaccount.nextval into genaccount_id from dual;
            --v_MFAE_RDET := facture_.MFAE_RDET; 
	        V_periode:= facture_.periode;
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
					V_periode := facture_.periode;
					IF V_periode = 1 THEN
					mois_:='01';
					ELSIF V_periode = 2 THEN
					mois_:='04';
					ELSIF V_periode = 3 THEN
					mois_:='07';
					ELSIF V_periode = 4 THEN
					mois_:='10';
					end if;
				end;
			else
			  mois_ := trim(facture_.periode);
			end if;
			V_anneereel :=facture_.annee;
			V_FAC_RESTANTDU  := null;
			V_FAC_DATECALCUL := null;
			V_REF_ABN        := null;
			V_FAC_DATECALCUL := BIL_CALCDT + 5;
			v_ID_FACTURE:=lpad(trim(facture_.DISTRICT),2,'0')||lpad(trim(facture_.tournee),3,'0')||lpad(trim(facture_.ORDRE),3,'0')||to_char(V_anneereel)||lpad(to_char(V_periode),2,'0')||to_char(facture_.version);
		    V_pdl_ref := lpad(trim(facture_.DISTRICT),2,'0')||lpad(trim(facture_.tournee),3,'0')||lpad(trim(facture_.Ordre),3,'0')||lpad(trim(facture_.POLICE),5,'0');
			V_REF_ABN := lpad(trim(facture_.DISTRICT),2,'0')||lpad(trim(facture_.POLICE),5,'0')||lpad(trim(facture_.tournee),3,'0')||lpad(trim(facture_.Ordre),3,'0') ;
		    V_TRAIN_FACT :='ANNEE:'||trim(V_anneereel)||' MOIS:'||trim(V_periode);
			select NTIERS,NSIXIEME
			into V_tiers,V_six
			from tourne
			where trim(code)=lpad(trim(facture_.tournee),3,'0')
			and  trim(district)=trim(facture_.DISTRICT);
            V_TRAIN_FACT :='ANNEE:'||trim(facture_.annee)||' TRIM:'||trim(facture_.periode)||' TIER:'||trim(V_tiers)||' SIX:'||trim(V_six );
		    
			select g.org_id	
			into V_ORG_ID 
			from GENORGANIZATION g 
			where upper(g.org_code)=lpad(trim(facture_.dist),2,'0');
			
			select cag.par_id  
			into v_PAR_ID
			from AGRCUSTOMERAGR cag
			where cag.cag_id in (select sag.cag_id
								 from TECSERVICEPOINT spt,
									  AGRSERVICEAGR sag
								 where spt.spt_id=sag.spt_id
								 and spt.spt_refe=V_pdl_ref);
			select par.adr_id
			into   V_ADR_ID
			from   GENPARTY  par
			where par.par_id=v_PAR_ID;		

			select sag.sag_id ,sag.sag_startdt
			into V_SAG_ID,V_ABN_DT_DEB
			from AGRSERVICEAGR sag,
				 TECSERVICEPOINT spt
			where sag.spt_id=spt.spt_id 
			and spt.spt_refe=V_pdl_ref;		
						V_COMPTEAUX:='IMP_MIG'			   
			V_TOTHTE:=(facture_.net_a_payer/1000);
			V_TVA:=0
			V_TOTHTA:=0;
			V_TOTTVAA:=0;
			V_SOLDE:=(facture_.net_a_payer/1000); 

			select count(*) into v_nbr from genbill b where b.BIL_CODE=V_ID_FACTURE;
		    if v_nbr=1 then
			    if facture_.etat='A' then
			        New_Det   := null;
				    New_Genbill := null;
				    New_genrun  := null;
--------------------------------------------------------Traitement Role
					If V_anneereel is not null and V_periode is not null and V_TRAIN_FACT is not null then
						New_genrun.RUN_EXERCICE   :=  V_anneereel ;
						New_genrun.RUN_NUMBER     :=  V_periode ;
						New_genrun.ORG_ID         :=  v_ORG_ID ;
						New_genrun.RUN_STARTDT    :=  V_FAC_DATECALCUL;
						New_genrun.RUN_COMMENT    :=  'Role migré' ;
						New_genrun.RUN_NAME       :=  'Role '||V_TRAIN_FACT ;
						Genere_genrun(New_genrun,genrun_id,genrun_ref);
					end if ;
					--------------------------------------------------------Traitement Det
					New_Det.DEB_ID           :=  Debt_Id ;
					New_Det.DEB_REFE         :=  v_ID_FACTURE;
					New_Det.ORG_ID           :=  V_ORG_ID ;
					New_Det.PAR_ID           :=  V_PAR_ID ;
					New_Det.ADR_ID           :=  V_adr_id ;
					New_Det.DEB_DATE         :=  V_FAC_DATECALCUL;
					New_Det.DEB_DUEDT        :=  V_FAC_DATECALCUL ;
					New_Det.DEB_PRINTDT      :=  V_FAC_DATECALCUL;
					New_Det.SAG_ID           :=  V_SAG_ID ;
					New_Det.DEB_PREL         :=  1 ;
					New_Det.deb_amount_cash  := -(facture_.DEB_AMOUNTINIT) ;
					New_Det.DEB_AMOUNTINIT   := 0;
					New_Det.VOW_DEBTYPE      := pk_genvocword.getidbycode('VOW_DEBTYPE','AV',null) ;
					New_Det.DEB_AMOUNTREMAIN :=  facture_.DEB_AMOUNTREMAIN ;
					New_Det.DEB_COMMENT      :=  facture_.DEB_COMMENT ;
					New_Det.VOW_SETTLEMODE   := pk_genvocword.getidbycode('VOW_SETTLEMODE',4,null) ;
---------------------------------------------------------Traitement GENACCOUNT ,GENIMP
					New_genimp.imp_code      :=  v_COMPTEAUX ;
					New_genimp.imp_name      :=  v_COMPTEAUX ;
					New_genimp.vow_budgtp    :=  pk_genvocword.getidbycode('VOW_BUDGTP','EA',null);
					Genere_genimp (New_genimp ,genimp_id,genimp_ref);
					New_genaccount.PAR_ID    :=  V_PAR_ID ;
					New_genaccount.IMP_ID    :=  genimp_ref ;
					New_genaccount.VOW_ACOTP :=  pk_genvocword.getidbycode('VOW_ACOTP','1',null);
					New_genaccount.REC_ID    :=  V_REC_ID ;
					New_agrsagaco.SAG_ID     :=  V_SAG_ID ;
					New_agrsagaco.SCO_STARTDT:=  V_ABN_DT_DEB ;
					Genere_genaccount (New_genaccount ,genaccount_id ,genaccount_ref ,agrsagaco_id,New_agrsagaco) ;
					New_Det.ACO_ID           := genaccount_ref ;
					New_Det.DEB_NORECOVERY   := 0;
							Insert into gendebt(deb_id,deb_refe,org_id,par_id,adr_id,deb_date,deb_duedt,deb_printdt,deb_amountinit,deb_amountremain,bap_id,
									vow_settlemode,aco_id,deb_norecovery,deb_credt,deb_updtby,deb_updtdt,deb_comment,sag_id,vow_debtype,deb_prel)
							values (New_Det.deb_id,New_Det.deb_refe,New_Det.org_id,New_Det.par_id,New_Det.adr_id,New_Det.deb_date,New_Det.deb_duedt,New_Det.deb_printdt,
									New_Det.deb_amountinit,New_Det.deb_amountremain,New_Det.bap_id,New_Det.vow_settlemode,New_Det.aco_id,New_Det.deb_norecovery,New_Det.deb_credt,
									New_Det.deb_updtby,New_Det.deb_updtdt,New_Det.DEB_COMMENT,nvl(New_Det.deb_amount_cash,0),New_Det.SAG_ID,New_Det.VOW_DEBTYPE,New_Det.DEB_PREL);	
				        commit;
					--------------------------------------------------------Traitement agrbill
					
					New_Agrbill.BIL_ID            :=  Agrbill_Id ;
					New_Agrbill.SAG_ID            :=  V_SAG_ID;
					New_Agrbill.VOW_AGRBILLTYPE   :=  pk_genvocword.getidbycode('VOW_AGRBILLTYPE',Fac.Mfae_Type,null) ;
					New_Agrbill.VOW_MODEFACT      :=  pk_genvocword.getidbycode('VOW_MODEFACT',Fac.VOC_MODEFACT,null) ;
					   Insert into agrbill (BIL_ID,SAG_ID,VOW_AGRBILLTYPE,VOW_MODEFACT)
									values (New_Agrbill.BIL_ID,New_Agrbill.SAG_ID,New_Agrbill.VOW_AGRBILLTYPE,New_Agrbill.VOW_MODEFACT);
--------------------------------------------------------Traitement genbill
                    New_Genbill.BIL_ID            :=  Agrbill_Id;
					New_Genbill.BIL_CODE          :=  v_ID_FACTURE; --Fac.MFAE_NUME;
					New_Genbill.BIL_CALCDT        :=  V_FAC_DATECALCUL;
					New_Genbill.BIL_AMOUNTHT      :=  -(facture_.BIL_AMOUNTHT);
					New_Genbill.BIL_AMOUNTTVA     :=  -(facture_.BIL_AMOUNTTVA) ;
					New_Genbill.BIL_AMOUNTTTC     :=  -(facture_.BIL_AMOUNTTTC);
					New_Genbill.BIL_AMOUNTTTCDEC  :=  V_AMOUNTTTCDEC ;
					New_Genbill.BIL_STATUS        :=  1;
					New_Genbill.DEB_ID            :=  Debt_Id;
					New_Genbill.PAR_ID            :=  V_PAR_ID ;
					New_Genbill.BIL_DEBTDT        :=  V_FAC_DATECALCUL;
					New_Genbill.RUN_ID            :=  genrun_ref  ;
							Insert into genbill(BIL_ID,BIL_CODE,BIL_CALCDT,BIL_AMOUNTHT,BIL_AMOUNTTVA,BIL_AMOUNTTTC,DEB_ID,PAR_ID,BIL_STATUS,BIL_AMOUNTTTCDEC,BIL_DEBTDT,RUN_ID)
							 values(New_Genbill.BIL_ID,New_Genbill.BIL_CODE,New_Genbill.BIL_CALCDT,New_Genbill.BIL_AMOUNTHT,New_Genbill.BIL_AMOUNTTVA,New_Genbill.BIL_AMOUNTTTC,
									New_Genbill.DEB_ID,New_Genbill.PAR_ID,New_Genbill.BIL_STATUS,New_Genbill.BIL_AMOUNTTTCDEC,New_Genbill.BIL_DEBTDT,New_Genbill.RUN_ID); 
							commit; 

				 
				 
			 
			    end if;
			end if; 
        end loop;  
    end loop;



end;
/