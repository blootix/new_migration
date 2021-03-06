 declare 
CURSOR branch_(district_ varchar2,tourne_ varchar2,ordre_ varchar2) is 
				select  b.*
				from branchement b
				where  lpad(trim(b.district),2,'0') = district_
				and    lpad(trim(b.tourne),3,'0')   = tourne_
				and    lpad(trim(b.ordre),3,'0')    = ordre_;
	 
CURSOR C_ITEM(V_Icode varchar2) is select ITE_ID,ite_name,VOW_UNIT  
								   from genitem s 
								   where s.ITE_CODE=V_Icode;
					
CURSOR C_TVA(v_taux number) is select tva_id 
							   from gentva 
							   where tva_taux=v_taux;
	 
CURSOR fact_as400   is select * from facture_as400;

CURSOR fact_as400gc is select * from facture_as400gc;

CURSOR fact_Dist    is select * from facture f where  f.annee='2015';

CURSOR fact_vers    is select distinct b.BIL_CODE,b.BIL_CALCDT,f.*,d.*
					   from facture f, genbill b,gendebt d
					   where f.etat in ('A','P')
					   and b.BIL_CODE = (lpad(trim(f.DISTRICT),2,'0')||
										 lpad(trim(f.tournee),3,'0')||
										 lpad(trim(f.ORDRE),3,'0')||
										 to_char(f.annee)||
										 lpad(trim(f.periode),2,'0')||'0')
					   and b.bil_id=d.bil_id;

CURSOR fact_IMPPART is select * from  impayees_part p 
					   where not exists (select 'X' from genbill b 
										 where b.BIL_CODE = (lpad(trim(DISTRICT),2,'0')||
															 lpad(trim(tournee),3,'0')||
															 lpad(trim(ORDRE),3,'0')||
															 to_char(annee)||
															 lpad(trim(p.trimestre),2,'0')||0)
										)
						  and  p.net<>p.mtpaye; 

CURSOR fact_IMPGC is select * from impayees_gc  i
                     where not exists (select 'X' from genbill b 
                                        where b.BIL_CODE =(lpad(trim(i.DISTRICT),2,'0')||
														   lpad(i.tournee,3,'0')||
														   lpad(i.ORDRE,3,'0')||
														   to_char(i.annee)||
														   lpad(i.mois,2,'0')||0))
                      and trim(i.net)<>trim(i.mtpaye); 				   

	V_Deb_ID           Number ;  
	V_ORG_ID		   Number ;
	v_PAR_ID           Number ;
	V_ADR_ID           Number ;
	V_ITE_ID    	   Number ;
	V_SAG_ID           Number ;
	V_IMP_ID		   Number ;
	V_ACO_ID		   Number ;
	V_SCO_ID           Number ;
	V_BIL_ID           Number ;
	V_PTA_ID           Number ;
	V_TVA_ID           Number ;
	v                  Number ;
	V_NBR              Number ;
	V_VOW_UNIT         Number ;
	V_PSL_RANK         Number ; 
	V_bil_cancel_id    Number ;
	V_DEB_NORECOVERY   Number ;
	V_BIL_STATUS       Number ;
	V_BLI_MHT          Number ;
	V_periode          Number ;
	V_VERSION          Number(1):=0 ;
	V_TOTHTE           Number(25,10);
    V_TVA              Number(25,10);
    V_TOTHTA           Number(25,10);
    V_TOTTVAA          Number(25,10);
	V_SOLDE            Number(25,10);
	V_AMOUNTTTCDEC     Number(25,10);
	V_BIL_AMOUNTHT     Number(25,10);
	V_BIL_AMOUNTTVA    Number(25,10);
	V_BIL_AMOUNTTTC    Number(25,10);
	V_BIL_AMOUNTTTCDEC Number(25,10);
	V_DEB_AMOUNTREMAIN Number(25,10);
	V_DEB_AMOUNTINIT   Number(25,10);
	V_DEB_AMOUNT_CASH  Number(25,10);
	V_TRAIN_FACT       varchar2(200);
	V_ite_name  	   varchar2(100);
	V_ID_FACTURE       varchar2(50) ;
	V_PDL_REF          varchar2(50) ;
	V_DEB_COMMENT      varchar2(100);
	V_REF_ABN          varchar2(50) ;
	V_VOW_SETTLEMODE   varchar2(50) ;
	V_VOW_AGRBILLTYPE  varchar2(50) ;
	V_VOW_MODEFACT     varchar2(50) ;
	V_VOW_DEBTYPE      varchar2(50) ;
	v_code			   varchar2(50) ;
	V_COMPTEAUX		   varchar2(10) ;
	V_anneereel        varchar2(4)  ;
	V_tiers            varchar2(1)  ;
    V_six              varchar2(1)  ;
	V_FAC_DATECALCUL   date;
	V_FAC_DATELIM      date; 
	V_date            date;
	V_ABN_DT_DEB       date;  
   
   
BEGIN
-------------------------------------------------------------------------------------------
------Facture_as400------------------Facture_as400--------------------Facture_as400--------
-------------------------------------------------------------------------------------------
	FOR facture_ in fact_as400 LOOP
	    FOR x in branch_(lpad(trim(facture_.DIST),2,'0'),lpad(trim(facture_.TOU),3,'0'),lpad(trim(facture_.ORD),3,'0'))LOOP	
			     
			if(to_number(facture_.refc01)<to_number(facture_.refc03))then
				V_anneereel := '20'||facture_.refc04;
			else
				V_anneereel := '20'||to_char((to_number(facture_.refc04)-1));
			end if;
			BEGIN
				select TRIM,tier,six
				into V_periode,V_tiers,V_six
				from param_tournee p
				where p.DISTRICT=facture_.dist
				And   p.m1 =facture_.refc01
				And   p.m2 = facture_.refc02
				And   p.m3 = facture_.refc03
				And  (p.TIER,p.SIX) in (select t.NTIERS,t.NSIXIEME from tourne t
										where trim(t.code)  =lpad(facture_.tou,3,'0')
										and trim(t.district)=trim(p.DISTRICT)
										and trim(t.district)=facture_.dist
									    );
			EXCEPTION WHEN OTHERS THEN
			    V_periode := 1;
			END;
			V_ID_FACTURE:= lpad(trim(facture_.DIST),2,'0')||lpad(trim(facture_.tou),3,'0')||lpad(trim(facture_.ORD),3,'0')||to_char(V_anneereel)||lpad(to_char(V_periode),2,'0')||to_char(v_version);
			V_pdl_ref   := lpad(trim(facture_.DIST),2,'0')||lpad(trim(facture_.tou),3,'0')||lpad(trim(facture_.ORD),3,'0')||lpad(trim(facture_.pol),5,'0');	
			
			select count(*) into V_NBR from genbill b where b.BIL_CODE=V_ID_FACTURE;
			if V_NBR=0 then 
			    V_FAC_DATECALCUL :=null;
				V_FAC_DATELIM    :=null;
				V_TRAIN_FACT     :=null;
				V_AMOUNTTTCDEC   :=null;
			    BEGIN
					if lpad(trim(facture_.dist),2,'0')='57' then
						select g.org_id	
						into V_ORG_ID 
						from GENORGANIZATION g 
						where upper(g.org_code)='22';
					elsif lpad(trim(facture_.dist),2,'0')='58' then
						select g.org_id	
						into V_ORG_ID 
						from GENORGANIZATION g 
						where upper(g.org_code)='32';	
					elsif lpad(trim(facture_.dist),2,'0')='60' then
						select g.org_id	
						into V_ORG_ID 
						from GENORGANIZATION g 
						where upper(g.org_code)='36';			
					elsif lpad(trim(facture_.dist),2,'0')='61' then
						select g.org_id	
						into V_ORG_ID 
						from GENORGANIZATION g 
						where upper(g.org_code)='03';
					elsif lpad(trim(facture_.dist),2,'0')='63' then
						select g.org_id	
						into V_ORG_ID 
						from GENORGANIZATION g 
						where upper(g.org_code)='15';
					end if ;
				EXCEPTION WHEN OTHERS THEN 
					select g.org_id	
					into V_ORG_ID 
					from GENORGANIZATION g 
					where upper(g.org_code)=lpad(trim(facture_.dist),2,'0');
				END;
				
				select cag.par_id  
				into V_PAR_ID
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
				where par.par_id=V_PAR_ID;		

				select sag.sag_id,sag.sag_startdt
				into V_SAG_ID,V_ABN_DT_DEB
				from AGRSERVICEAGR sag,
					 TECSERVICEPOINT spt
				where sag.spt_id=spt.spt_id 
				and spt.spt_refe=V_pdl_ref;	
				
				V_TRAIN_FACT :='ANNEE:'||trim(V_anneereel)||' TRIM:'||trim(V_periode)||' TIER:'||trim(V_tiers)||' SIX:'||trim(V_six );
				V_REF_ABN    :=lpad(trim(facture_.DIST),2,'0')||lpad(to_char(trim(facture_.pol)),5,'0')||lpad(trim(facture_.tou),3,'0')||lpad(trim(facture_.ORD),3,'0');			   
				V_COMPTEAUX  :='IMP_MIG';			   
				V_TVA        :=(facture_.tva_ff+facture_.tva_capit+facture_.tva_pfin+facture_.tvacons+facture_.tva_preav+ facture_.tvaferm+facture_.tvadeplac+facture_.tvadepose_dem+facture_.tvadepose_def)/1000;
				V_TOTHTE     :=(facture_.net-(V_TVA+facture_.arriere))/1000;
				V_TOTHTA     :=0;
				V_TOTTVAA    :=0;
				V_SOLDE      :=(facture_.net-facture_.arriere)/1000;
				select last_day(to_date('01'||lpad(facture_.refc03,2,'0')||facture_.refc04,'ddmmyy')) 
                into V_date
                from dual;
				BEGIN
					select to_date(lpad(trim(DATEXP),8,'0'),'ddmmyyyy'),
					to_date(lpad(trim(DATL),8,'0'),'ddmmyyyy')   
					into V_FAC_DATECALCUL,V_FAC_DATELIM
					from ROLE_TRIM
					where trim(facture_.Dist)   = DISTR
					and to_number(facture_.pol) = POLICE
					and to_number(facture_.tou )= TOUR
					and to_number(facture_.ord) = ORDR
					and to_number(V_tiers)      = tier
					and to_number(V_periode)    = trim
					and to_number(V_six)        = six
					and annee  					= V_anneereel
					and rownum = 1;
				EXCEPTION WHEN OTHERS THEN
						V_FAC_DATECALCUL := V_date;
						V_FAC_DATELIM    := '01/01/2016';------date a verifier 
				    BEGIN 
					EXCEPTION WHEN OTHERS THEN
						V_FAC_DATECALCUL := '01/01/2016';------date a verifier
						V_FAC_DATELIM    := '01/01/2016';------date a verifier
					END;
				END;  
--------------------------------------------------------Traitement Role
			If (V_anneereel is not null and V_periode is not null and V_TRAIN_FACT is not null) then			
				Begin
					select t.run_id
					into   v_run_id
					from genrun t 
					where t.run_exercice=V_anneereel
					and   t.run_number  =V_periode;
				EXCEPTION WHEN OTHERS THEN 			  
					select seq_genrun.nextval into v_run_id from dual;				
						insert into genrun (run_id,run_exercice,run_number,org_id,run_startdt,run_comment,RUN_NAME,RUN_DTCALC,RUN_ENDDT)
									values (v_run_id,V_anneereel,V_periode,V_org_id,V_FAC_DATECALCUL,'Role migré','Role '||V_TRAIN_FACT,V_FAC_DATECALCUL,V_FAC_DATECALCUL);
				END;    
			end if ; 							
--------------------------------------------------------Traitement Det
                select seq_gendebt.nextval into V_Deb_ID from dual; 
				If (V_TOTHTE+V_TVA+V_TOTHTA+V_TOTTVAA) > 0 then
					V_DEB_AMOUNTINIT   := V_TOTHTE+V_TVA+V_TOTHTA+V_TOTTVAA;
					V_deb_amount_cash  := V_TOTHTE+V_TVA+V_TOTHTA+V_TOTTVAA;
					V_VOW_DEBTYPE      := pk_genvocword.getidbycode('VOW_DEBTYPE','FA',null);
				else
					V_deb_amount_cash  := -(V_TOTHTE+V_TVA+V_TOTHTA+V_TOTTVAA);
					V_DEB_AMOUNTINIT   := 0;
					V_VOW_DEBTYPE      := pk_genvocword.getidbycode('VOW_DEBTYPE','AV',null);
				end if ;
				V_DEB_AMOUNTREMAIN     := V_SOLDE ;
				V_DEB_COMMENT          := V_REF_ABN;
				V_VOW_SETTLEMODE       := pk_genvocword.getidbycode('VOW_SETTLEMODE',4,null);
				V_DEB_NORECOVERY       := 0;
 --------------------------------------------------------Traitement GENACCOUNT ,GENIMP
                Begin 
					select t.imp_id
					into V_IMP_ID
					from genimp t 
					where t.imp_code=V_COMPTEAUX;
				EXCEPTION WHEN OTHERS THEN 
					V_VOW_BUDGTP        :=  pk_genvocword.getidbycode('VOW_BUDGTP','EA',null);
					select seq_genimp.nextval  into V_IMP_ID  from dual;
					insert into genimp (imp_id,imp_code,imp_name,VOW_BUDGTP,org_id)
								 values(V_IMP_ID,V_COMPTEAUX,V_COMPTEAUX,V_VOW_BUDGTP,V_org_id);
				END;
				BEGIN 
					select t.aco_id 
					into V_ACO_ID
					from genaccount t
					where t.par_id=V_PAR_ID;
                EXCEPTION WHEN OTHERS THEN 
					V_VOW_ACOTP     :=  pk_genvocword.getidbycode('VOW_ACOTP','1',null);
					select seq_genaccount.nextval into V_ACO_ID from dual;
					insert into genaccount(aco_id,par_id,imp_id,VOW_ACOTP,rec_id)
									values(V_ACO_ID,V_PAR_ID,V_imp_id,V_VOW_ACOTP,null);
				END;				
				BEGIN	
					select t.sco_id
					into V_sco_id
					from agrsagaco t
					where t.aco_id=V_ACO_ID;
				EXCEPTION WHEN OTHERS THEN
					select seq_agrsagaco.nextval  into V_sco_id  from dual;
					insert into agrsagaco(sco_id,sag_id,aco_id,sco_startdt)
								   values(V_sco_id,V_SAG_ID,V_ACO_ID,V_ABN_DT_DEB);
				END;			   
                --------------------------------------------------- 
				Insert into gendebt(deb_id,deb_refe,org_id,par_id,adr_id,deb_date,deb_duedt,deb_printdt,
									deb_amountinit,deb_amountremain,bap_id,VOW_SETTLEMODE,aco_id,deb_norecovery,deb_credt,
									deb_updtby,deb_updtdt,deb_comment,deb_amount_cash,sag_id,VOW_DEBTYPE,deb_prel)
							values (V_Deb_ID,V_ID_FACTURE,V_ORG_ID,V_PAR_ID,V_ADR_ID,V_FAC_DATECALCUL,V_FAC_DATELIM,V_FAC_DATECALCUL,
									V_DEB_AMOUNTINIT,V_DEB_AMOUNTREMAIN,null,V_VOW_SETTLEMODE,V_ACO_ID,V_DEB_NORECOVERY,sysdate,
									null,null,V_DEB_COMMENT,nvl(V_deb_amount_cash,0),V_SAG_ID,V_VOW_DEBTYPE,1);	
							commit;
--------------------------------------------------------Traitement agrbill
                select seq_agrbill.nextval into V_BIL_ID from dual; 
			    V_VOW_AGRBILLTYPE   :=  pk_genvocword.getidbycode('VOW_AGRBILLTYPE','FC',null);
				V_VOW_MODEFACT      :=  pk_genvocword.getidbycode('VOW_MODEFACT',4,null);--------NB:(4 ou MIG) a verifier
				Insert into agrbill(BIL_ID,SAG_ID,VOW_AGRBILLTYPE,VOW_MODEFACT)
							 values(V_BIL_ID,V_SAG_ID,V_VOW_AGRBILLTYPE,v_VOW_MODEFACT);	
				commit;
--------------------------------------------------------Traitement genbill
				V_BIL_AMOUNTHT      :=  V_TOTHTE + V_TOTHTA ;
				V_BIL_AMOUNTTVA     :=  V_TVA+ V_TOTTVAA ;
				V_BIL_AMOUNTTTC     :=  V_TOTHTE+V_TVA+V_TOTHTA+V_TOTTVAA ;
				V_BIL_STATUS        :=  1; 
		        Insert into genbill(BIL_ID,BIL_CODE,BIL_CALCDT,BIL_AMOUNTHT,BIL_AMOUNTTVA,BIL_AMOUNTTTC,
									DEB_ID,PAR_ID,BIL_STATUS,BIL_AMOUNTTTCDEC,BIL_DEBTDT,RUN_ID)
							 values(V_BIL_ID,V_ID_FACTURE,V_FAC_DATECALCUL,V_BIL_AMOUNTHT,V_BIL_AMOUNTTVA,V_BIL_AMOUNTTTC,
									V_Deb_ID,V_PAR_ID,V_BIL_STATUS,V_AMOUNTTTCDEC,V_FAC_DATECALCUL,v_run_id); 
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
						BEGIN
						v_code:='CSM_STD';
							for x in C_ITEM(v_code) loop
							V_ITE_ID  :=x.ite_id;
							V_ite_name:=x.ite_name
							V_VOW_UNIT:=x.VOW_UNIT
							end loop;
						EXCEPTION WHEN NO_DATA_FOUND THEN NULL;
						END;
						BEGIN
						v_tva_taux:= 18;
							for v in C_TVA(v_tva_taux) loop
							   V_TVA_ID:=v.tva_id; 
							end loop;
						EXCEPTION WHEN NO_DATA_FOUND THEN 
						V_TVA_ID := 25;
						END;

						select count(*) 
						into V_NBR 
						from genptaslice 
						where PTA_ID in (select PTA_ID 
										 from genitemperiodtarif 
										 where TAR_id in (select tar_id 
														  from genitemtarif 
														  where ITE_ID=V_ITE_ID)
										);
                        if V_nbr =1 then
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
						if V_nbr >1 then
							select PTA_ID,PSL_RANK  
							into V_PTA_ID,V_PSL_RANK 
							from genptaslice 
							where PTA_ID in (select PTA_ID 
										     from genitemperiodtarif 
											 where TAR_id in(select tar_id
											                 from genitemtarif 
															 where ITE_ID=V_ITE_ID) 
								            )
							and rownum=1; 
						end if;
			        BEGIN
						INSERT INTO genbilline(BIL_ID,BLI_REVERSEBLI_ID,BLI_NUMBER,BLI_REVERSEBLINUMBER,BLI_NAME,BLI_EXERCICE,ITE_ID,PTA_ID,PSL_RANK,
						                       IMP_ID,BLI_VOLUMEBASE,BLI_VOLUMEFACT,BLI_PUHT,TVA_ID,BLI_MHT,BLI_MTTVA,BLI_MTTC,BLI_STARTDT,
											   BLI_ENDDT,VOW_UNIT,BLI_NBUNITES,BLI_DETAIL,BLI_CANCEL,IMC_ID,IMP_ANALYTIQUE_ID,BLI_PERIODEINIT,BLI_PERIODE,
											   BLI_REVERSEDT,BLI_CREDT,BLI_UPDTDT,BLI_UPDTBY,MEU_ID,BLI_NAME_A,BLI_REVERSEBLIDEC_ID,BLI_REVERSEBLINUMBERDEC,BLI_REVERSEDECDT)
										values(V_BIL_ID,null,v,null,V_ite_name,V_anneereel,V_ITE_ID,V_PTA_ID,V_PSL_RANK,
										       null,facture_.const1,facture_.const1,facture_.tauxt1/1000,V_TVA_ID,facture_.montt1/1000,facture_.TVACONS/1000,(facture_.montt1/1000)+(facture_.TVACONS/1000),V_FAC_DATECALCUL,
											   V_FAC_DATECALCUL,V_VOW_UNIT, null,0,0,null,null,null,null,
											   null,null,null,null,null,null,null,null,null);
					EXCEPTION WHEN OTHERS THEN
										BEGIN
											INSERT INTO genbilline(BIL_ID,BLI_REVERSEBLI_ID,BLI_NUMBER,BLI_REVERSEBLINUMBER,BLI_NAME,BLI_EXERCICE,ITE_ID,PTA_ID,PSL_RANK,
																   IMP_ID,BLI_VOLUMEBASE,BLI_VOLUMEFACT,BLI_PUHT,TVA_ID,BLI_MHT,BLI_MTTVA,BLI_MTTC,BLI_STARTDT,
																   BLI_ENDDT,VOW_UNIT,BLI_NBUNITES,BLI_DETAIL,BLI_CANCEL,IMC_ID,IMP_ANALYTIQUE_ID,BLI_PERIODEINIT,BLI_PERIODE,
																   BLI_REVERSEDT,BLI_CREDT,BLI_UPDTDT,BLI_UPDTBY,MEU_ID,BLI_NAME_A,BLI_REVERSEBLIDEC_ID,BLI_REVERSEBLINUMBERDEC,BLI_REVERSEDECDT)
															values(V_BIL_ID,null,v+1,null,V_ite_name,V_anneereel,V_ITE_ID,V_PTA_ID,V_PSL_RANK,
																   null,facture_.const1,facture_.const1,facture_.tauxt1/1000,V_TVA_ID,facture_.montt1/1000,facture_.TVACONS/1000,(facture_.montt1/1000)+(facture_.TVACONS/1000),V_FAC_DATECALCUL,
																   V_FAC_DATECALCUL,V_VOW_UNIT, null,0,0,null,null,null,null,
																   null,null,null,null,null,null,null,null,null);
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
						BEGIN
						v_code:='CSM_STD';
							for x in C_ITEM(v_code) loop
								V_ITE_ID:=x.ite_id;
								V_ite_name:=x.ite_name
								V_VOW_UNIT:=x.VOW_UNIT
							end loop;
						EXCEPTION WHEN NO_DATA_FOUND THEN NULL;
						END;
						BEGIN
						v_tva_taux:= 18;
							for v in C_TVA(v_tva_taux) loop
							   V_TVA_ID:=v.tva_id; 
							end loop;
						EXCEPTION WHEN NO_DATA_FOUND THEN 
						V_TVA_ID := 25;
						END;
						select count(*) 
						into V_NBR 
						from genptaslice 
						where PTA_ID in (select PTA_ID 	
						                 from genitemperiodtarif 
										 where TAR_id in(select tar_id 
										                 from genitemtarif 
														 where ITE_ID=V_ITE_ID )
										);
						if V_NBR =1 then
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
						if V_NBR >1 then
							select PTA_ID,PSL_RANK  
							into V_PTA_ID,V_PSL_RANK 
							from genptaslice 
							where PTA_IDin (select PTA_ID 
											from genitemperiodtarif
											where TAR_id in (select tar_id 
															 from genitemtarif 
															 where ITE_ID=V_ITE_ID) 
							               )
							and rownum=1;
						end if;
						BEGIN
							INSERT INTO genbilline(BIL_ID,BLI_REVERSEBLI_ID,BLI_NUMBER,BLI_REVERSEBLINUMBER,BLI_NAME,BLI_EXERCICE,ITE_ID,PTA_ID,PSL_RANK,
						                           IMP_ID,BLI_VOLUMEBASE,BLI_VOLUMEFACT,BLI_PUHT,TVA_ID,BLI_MHT,BLI_MTTVA,BLI_MTTC,BLI_STARTDT,
											       BLI_ENDDT,VOW_UNIT,BLI_NBUNITES,BLI_DETAIL,BLI_CANCEL,IMC_ID,IMP_ANALYTIQUE_ID,BLI_PERIODEINIT,BLI_PERIODE,
											       BLI_REVERSEDT,BLI_CREDT,BLI_UPDTDT,BLI_UPDTBY,MEU_ID,BLI_NAME_A,BLI_REVERSEBLIDEC_ID,BLI_REVERSEBLINUMBERDEC,BLI_REVERSEDECDT)
											values(V_BIL_ID,null,v,null,V_ite_name,V_anneereel,V_ITE_ID,V_PTA_ID,V_PSL_RANK,
											       null,facture_.const2,facture_.const2,facture_.tauxt2/1000,V_TVA_ID,facture_.montt2/1000,facture_.TVACONS/1000,(facture_.montt2/1000)+(facture_.TVACONS/1000),V_FAC_DATECALCUL,
												   V_FAC_DATECALCUL,V_VOW_UNIT,null,0,0,null,null,null,null,
												   null,null,null,null,	null,null,null,null,null,);
						EXCEPTION WHEN OTHERS THEN
												BEGIN
													INSERT INTO genbilline(BIL_ID,BLI_REVERSEBLI_ID,BLI_NUMBER,BLI_REVERSEBLINUMBER,BLI_NAME,BLI_EXERCICE,ITE_ID,PTA_ID,PSL_RANK,
						                                                   IMP_ID,BLI_VOLUMEBASE,BLI_VOLUMEFACT,BLI_PUHT,TVA_ID,BLI_MHT,BLI_MTTVA,BLI_MTTC,BLI_STARTDT,
																		   BLI_ENDDT,VOW_UNIT,BLI_NBUNITES,BLI_DETAIL,BLI_CANCEL,IMC_ID,IMP_ANALYTIQUE_ID,BLI_PERIODEINIT,BLI_PERIODE,
											                               BLI_REVERSEDT,BLI_CREDT,BLI_UPDTDT,BLI_UPDTBY,MEU_ID,BLI_NAME_A,BLI_REVERSEBLIDEC_ID,BLI_REVERSEBLINUMBERDEC,BLI_REVERSEDECDT)
																	values(V_BIL_ID,null,v+1,null,V_ite_name,V_anneereel,V_ITE_ID,V_PTA_ID,V_PSL_RANK,
																		   null,facture_.const2,facture_.const2,facture_.tauxt2/1000,V_TVA_ID,facture_.montt2/1000,facture_.TVACONS/1000,(facture_.montt2/1000)+(facture_.TVACONS/1000),V_FAC_DATECALCUL,
																		   V_FAC_DATECALCUL,V_VOW_UNIT,null,0,0,null,null,null,null,
																		   null,null,null,null,	null,null,null,null,null,);
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
						BEGIN
						v_code:='CSM_STD';
							for x in C_ITEM(v_code) loop
							V_ITE_ID:=x.ite_id;
							V_ite_name:=x.ite_name
							V_VOW_UNIT:=x.VOW_UNIT
							end loop;
						EXCEPTION WHEN NO_DATA_FOUND THEN NULL;
						END;
						BEGIN
						v_tva_taux:= 18;
							for v in C_TVA(v_tva_taux) loop
							   V_TVA_ID:=v.tva_id; 
							end loop;
						EXCEPTION WHEN NO_DATA_FOUND THEN 
						V_TVA_ID := 25;
						END;
						select count(*) 
						into V_nbr 
						from genptaslice 
						where PTA_ID in (select PTA_ID 	
						                 from genitemperiodtarif 
										 where TAR_id in (select tar_id 
														  from genitemtarif 
														  where ITE_ID=V_ITE_ID )
										);
						if V_nbr =1 then
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
						if V_nbr >1 then
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
						BEGIN
						    INSERT INTO genbilline(BIL_ID,BLI_REVERSEBLI_ID,BLI_NUMBER,BLI_REVERSEBLINUMBER,BLI_NAME,BLI_EXERCICE,ITE_ID,PTA_ID,PSL_RANK,
						                           IMP_ID,BLI_VOLUMEBASE,BLI_VOLUMEFACT,BLI_PUHT,TVA_ID,BLI_MHT,BLI_MTTVA,BLI_MTTC,BLI_STARTDT,
												   BLI_ENDDT,VOW_UNIT,BLI_NBUNITES,BLI_DETAIL,BLI_CANCEL,IMC_ID,IMP_ANALYTIQUE_ID,BLI_PERIODEINIT,BLI_PERIODE,
											       BLI_REVERSEDT,BLI_CREDT,BLI_UPDTDT,BLI_UPDTBY,MEU_ID,BLI_NAME_A,BLI_REVERSEBLIDEC_ID,BLI_REVERSEBLINUMBERDEC,BLI_REVERSEDECDT)
										    values(V_BIL_ID,null,v,null,V_ite_name,V_anneereel,V_ITE_ID,V_PTA_ID,V_PSL_RANK,
											       null,facture_.const3,facture_.const3,facture_.tauxt3/1000,V_TVA_ID,
												   facture_.montt3/1000,facture_.TVACONS/1000,facture_.montt3/1000+(facture_.TVACONS/1000),V_FAC_DATECALCUL,
												   V_FAC_DATECALCUL,V_VOW_UNIT,null,0,0,null,null,null,null,
												   null,null,null,null,null,null,null,null,null);
						EXCEPTION WHEN OTHERS THEN
												BEGIN
													INSERT INTO genbilline(BIL_ID,BLI_REVERSEBLI_ID,BLI_NUMBER,BLI_REVERSEBLINUMBER,BLI_NAME,BLI_EXERCICE,ITE_ID,PTA_ID,PSL_RANK,
						                                                   IMP_ID,BLI_VOLUMEBASE,BLI_VOLUMEFACT,BLI_PUHT,TVA_ID,BLI_MHT,BLI_MTTVA,BLI_MTTC,BLI_STARTDT,
																		   BLI_ENDDT,VOW_UNIT,BLI_NBUNITES,BLI_DETAIL,BLI_CANCEL,IMC_ID,IMP_ANALYTIQUE_ID,BLI_PERIODEINIT,BLI_PERIODE,
																		   BLI_REVERSEDT,BLI_CREDT,BLI_UPDTDT,BLI_UPDTBY,MEU_ID,BLI_NAME_A,BLI_REVERSEBLIDEC_ID,BLI_REVERSEBLINUMBERDEC,BLI_REVERSEDECDT)
																	values(V_BIL_ID,null,v+1,null,V_ite_name,V_anneereel,V_ITE_ID,V_PTA_ID,V_PSL_RANK,
																		   null,facture_.const3,facture_.const3,facture_.tauxt3/1000,V_TVA_ID,
																		   facture_.montt3/1000,facture_.TVACONS/1000,facture_.montt3/1000+(facture_.TVACONS/1000),V_FAC_DATECALCUL,
																		   V_FAC_DATECALCUL,V_VOW_UNIT,null,0,0,null,null,null,null,
																		   null,null,null,null,null,null,null,null,null);
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
					    V_PTA_ID   := null;
					    V_PSL_RANK := null;	 
						BEGIN
						v_code:='VAR_ONAS_1';
							for x in C_ITEM(v_code) loop
							V_ITE_ID:=x.ite_id;
							V_ite_name:=x.ite_name
							V_VOW_UNIT:=x.VOW_UNIT
							end loop;
						EXCEPTION WHEN NO_DATA_FOUND THEN NULL;
						END;
						BEGIN
						v_tva_taux= 0;
							for v in C_TVA(v_tva_taux) loop
							   V_TVA_ID:=v.tva_id; 
							end loop;
						EXCEPTION WHEN NO_DATA_FOUND THEN 
						V_TVA_ID := 25;
						END;
						select count(*) 
						into V_nbr 
						from genptaslice 
						where PTA_ID in (select PTA_ID 	
						                 from genitemperiodtarif 
										 where TAR_id in(select tar_id 
														 from genitemtarif 
														 where ITE_ID=V_ITE_ID)
										);
						if V_nbr =1 then
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
						if V_nbr >1 then
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
                        BEGIN
							 INSERT INTO genbilline(BIL_ID,BLI_REVERSEBLI_ID,BLI_NUMBER,BLI_REVERSEBLINUMBER,BLI_NAME,BLI_EXERCICE,ITE_ID,PTA_ID,PSL_RANK,
						                           IMP_ID,BLI_VOLUMEBASE,BLI_VOLUMEFACT,BLI_PUHT,TVA_ID,BLI_MHT,BLI_MTTVA,BLI_MTTC,BLI_STARTDT,
												   BLI_ENDDT,VOW_UNIT,BLI_NBUNITES,BLI_DETAIL,BLI_CANCEL,IMC_ID,IMP_ANALYTIQUE_ID,BLI_PERIODEINIT,BLI_PERIODE,
											       BLI_REVERSEDT,BLI_CREDT,BLI_UPDTDT,BLI_UPDTBY,MEU_ID,BLI_NAME_A,BLI_REVERSEBLIDEC_ID,BLI_REVERSEBLINUMBERDEC,BLI_REVERSEDECDT)
										    values(V_BIL_ID,null,v,null,V_ite_name,V_anneereel,V_ITE_ID,V_PTA_ID,V_PSL_RANK,
											       null,facture_.volon1,facture_.volon1,facture_.tauon1/1000,V_TVA_ID,facture_.mon1/1000,0,facture_.mon1/1000,V_FAC_DATECALCUL,
												   V_FAC_DATECALCUL,V_VOW_UNIT,null,0,0,null,null,null,null,
												   null,null,null,null,null,null,null,null,null);
						EXCEPTION WHEN OTHERS THEN
											BEGIN
												INSERT INTO genbilline(BIL_ID,BLI_REVERSEBLI_ID,BLI_NUMBER,BLI_REVERSEBLINUMBER,BLI_NAME,BLI_EXERCICE,ITE_ID,PTA_ID,PSL_RANK,
																	   IMP_ID,BLI_VOLUMEBASE,BLI_VOLUMEFACT,BLI_PUHT,TVA_ID,BLI_MHT,BLI_MTTVA,BLI_MTTC,BLI_STARTDT,
																	   BLI_ENDDT,VOW_UNIT,BLI_NBUNITES,BLI_DETAIL,BLI_CANCEL,IMC_ID,IMP_ANALYTIQUE_ID,BLI_PERIODEINIT,BLI_PERIODE,
																	   BLI_REVERSEDT,BLI_CREDT,BLI_UPDTDT,BLI_UPDTBY,MEU_ID,BLI_NAME_A,BLI_REVERSEBLIDEC_ID,BLI_REVERSEBLINUMBERDEC,BLI_REVERSEDECDT)
										    values(V_BIL_ID,null,v+1,null,V_ite_name,V_anneereel,V_ITE_ID,V_PTA_ID,V_PSL_RANK,
											       null,facture_.volon1,facture_.volon1,facture_.tauon1/1000,V_TVA_ID,facture_.mon1/1000,0,facture_.mon1/1000,V_FAC_DATECALCUL,
												   V_FAC_DATECALCUL,V_VOW_UNIT,null,0,0,null,null,null,null,
												   null,null,null,null,null,null,null,null,null);
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
						BEGIN
						v_code:='VAR_ONAS_1';
							for x in C_ITEM(v_code) loop
							V_ITE_ID:=x.ite_id;
							V_ite_name:=x.ite_name
							V_VOW_UNIT:=x.VOW_UNIT
							end loop;
						EXCEPTION WHEN NO_DATA_FOUND THEN NULL;
						END;
						BEGIN
						v_tva_taux= 0;
							for v in C_TVA(v_tva_taux) loop
							   V_TVA_ID:=v.tva_id; 
							end loop;
						EXCEPTION WHEN NO_DATA_FOUND THEN 
						V_TVA_ID := 25;
						END;
						select count(*) 
						into V_nbr 
						from genptaslice 
						where PTA_ID in (select PTA_ID 	
						                 from genitemperiodtarif 
										 where TAR_id in(select tar_id 
										                 from genitemtarif 
														 where ITE_ID=V_ITE_ID )
										);
						if V_nbr =1 then
							select PTA_ID,PSL_RANK  
							into V_PTA_ID,V_PSL_RANK 
							from genptaslice 
							where PTA_ID in (select PTA_ID 
											 from genitemperiodtarif 
											 where TAR_id in(select tar_id 
														     from genitemtarif 
															 where ITE_ID=V_ITE_ID)
											)
							and rownum=1;
						end if;
						if V_nbr >1 then
							select PTA_ID,PSL_RANK  
							into V_PTA_ID,V_PSL_RANK 
							from genptaslice 
							where PTA_ID in (select PTA_ID 
											from genitemperiodtarif
											where TAR_id in(select tar_id 
														    from genitemtarif 
															where ITE_ID=V_ITE_ID) 
										   )
							and rownum=1;
						end if;
                        BEGIN
							INSERT INTO genbilline(BIL_ID,BLI_REVERSEBLI_ID,BLI_NUMBER,BLI_REVERSEBLINUMBER,BLI_NAME,BLI_EXERCICE,ITE_ID,PTA_ID,PSL_RANK,
						                           IMP_ID,BLI_VOLUMEBASE,BLI_VOLUMEFACT,BLI_PUHT,TVA_ID,BLI_MHT,BLI_MTTVA,BLI_MTTC,BLI_STARTDT,
												   BLI_ENDDT,VOW_UNIT,BLI_NBUNITES,BLI_DETAIL,BLI_CANCEL,IMC_ID,IMP_ANALYTIQUE_ID,BLI_PERIODEINIT,BLI_PERIODE,
											       BLI_REVERSEDT,BLI_CREDT,BLI_UPDTDT,BLI_UPDTBY,MEU_ID,BLI_NAME_A,BLI_REVERSEBLIDEC_ID,BLI_REVERSEBLINUMBERDEC,BLI_REVERSEDECDT)
										   values(V_BIL_ID,null,v,null,V_ite_name,V_anneereel,V_ITE_ID,V_PTA_ID,V_PSL_RANK,
										          null,facture_.volon2,facture_.volon2,facture_.tauon2/1000,V_TVA_ID,facture_.mon2/1000,0,facture_.mon2/1000,V_FAC_DATECALCUL,
												  V_FAC_DATECALCUL,V_VOW_UNIT,null,0,0,null,null,null,null,
												  null,null,null,null,null,null,null,null,null);
						EXCEPTION WHEN OTHERS THEN
											BEGIN
											INSERT INTO genbilline(BIL_ID,BLI_REVERSEBLI_ID,BLI_NUMBER,BLI_REVERSEBLINUMBER,BLI_NAME,BLI_EXERCICE,ITE_ID,PTA_ID,PSL_RANK,
						                           IMP_ID,BLI_VOLUMEBASE,BLI_VOLUMEFACT,BLI_PUHT,TVA_ID,BLI_MHT,BLI_MTTVA,BLI_MTTC,BLI_STARTDT,
												   BLI_ENDDT,VOW_UNIT,BLI_NBUNITES,BLI_DETAIL,BLI_CANCEL,IMC_ID,IMP_ANALYTIQUE_ID,BLI_PERIODEINIT,BLI_PERIODE,
											       BLI_REVERSEDT,BLI_CREDT,BLI_UPDTDT,BLI_UPDTBY,MEU_ID,BLI_NAME_A,BLI_REVERSEBLIDEC_ID,BLI_REVERSEBLINUMBERDEC,BLI_REVERSEDECDT)
										   values(V_BIL_ID,null,v+1,null,V_ite_name,V_anneereel,V_ITE_ID,V_PTA_ID,V_PSL_RANK,
										          null,facture_.volon2,facture_.volon2,facture_.tauon2/1000,V_TVA_ID,facture_.mon2/1000,0,facture_.mon2/1000,V_FAC_DATECALCUL,
												  V_FAC_DATECALCUL,V_VOW_UNIT,null,0,0,null,null,null,null,
												  null,null,null,null,null,null,null,null,null);
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
						BEGIN
						v_code:='VAR_ONAS_1';
							for x in C_ITEM(v_code) loop
							V_ITE_ID:=x.ite_id;
							V_ite_name:=x.ite_name
							V_VOW_UNIT:=x.VOW_UNIT
							end loop;
						EXCEPTION WHEN NO_DATA_FOUND THEN NULL;
						END;
						BEGIN
						v_tva_taux= 0;
							for v in C_TVA(v_tva_taux) loop
							   V_TVA_ID:=v.tva_id; 
							end loop;
						EXCEPTION WHEN NO_DATA_FOUND THEN 
						V_TVA_ID := 25;
						END;
						select count(*) 
						into V_nbr 
						from genptaslice 
						where PTA_ID in (select PTA_ID 	
										 from genitemperiodtarif 
										 where TAR_id in(select tar_id 
														 from genitemtarif 
														 where ITE_ID=V_ITE_ID )
										);
						if V_nbr =1 then
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

						if V_nbr >1 then
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
						BEGIN
							INSERT INTO genbilline(BIL_ID,BLI_REVERSEBLI_ID,BLI_NUMBER,BLI_REVERSEBLINUMBER,BLI_NAME,BLI_EXERCICE,ITE_ID,PTA_ID,PSL_RANK,
						                           IMP_ID,BLI_VOLUMEBASE,BLI_VOLUMEFACT,BLI_PUHT,TVA_ID,BLI_MHT,BLI_MTTVA,BLI_MTTC,BLI_STARTDT,
												   BLI_ENDDT,VOW_UNIT,BLI_NBUNITES,BLI_DETAIL,BLI_CANCEL,IMC_ID,IMP_ANALYTIQUE_ID,BLI_PERIODEINIT,BLI_PERIODE,
											       BLI_REVERSEDT,BLI_CREDT,BLI_UPDTDT,BLI_UPDTBY,MEU_ID,BLI_NAME_A,BLI_REVERSEBLIDEC_ID,BLI_REVERSEBLINUMBERDEC,BLI_REVERSEDECDT)
										   values(V_BIL_ID,null,v,null,V_ite_name,V_anneereel,V_ITE_ID,V_PTA_ID,V_PSL_RANK,
										          null,facture_.volon3,facture_.volon3,facture_.tauon3/1000,V_TVA_ID,facture_.mon3/1000,0,facture_.mon3/1000,V_FAC_DATECALCUL,
												  V_FAC_DATECALCUL,V_VOW_UNIT,null,0,0,null,null,null,null,
												  null,null,null,null,null,null,null,null,null);
						EXCEPTION WHEN OTHERS THEN
											BEGIN
											INSERT INTO genbilline(BIL_ID,BLI_REVERSEBLI_ID,BLI_NUMBER,BLI_REVERSEBLINUMBER,BLI_NAME,BLI_EXERCICE,ITE_ID,PTA_ID,PSL_RANK,
						                                           IMP_ID,BLI_VOLUMEBASE,BLI_VOLUMEFACT,BLI_PUHT,TVA_ID,BLI_MHT,BLI_MTTVA,BLI_MTTC,BLI_STARTDT,
												                   BLI_ENDDT,VOW_UNIT,BLI_NBUNITES,BLI_DETAIL,BLI_CANCEL,IMC_ID,IMP_ANALYTIQUE_ID,BLI_PERIODEINIT,BLI_PERIODE,
											                       BLI_REVERSEDT,BLI_CREDT,BLI_UPDTDT,BLI_UPDTBY,MEU_ID,BLI_NAME_A,BLI_REVERSEBLIDEC_ID,BLI_REVERSEBLINUMBERDEC,BLI_REVERSEDECDT)
														    values(V_BIL_ID,null,v+1,null,V_ite_name,V_anneereel,V_ITE_ID,V_PTA_ID,V_PSL_RANK,
																   null,facture_.volon3,facture_.volon3,facture_.tauon3/1000,V_TVA_ID,facture_.mon3/1000,0,facture_.mon3/1000,V_FAC_DATECALCUL,
																   V_FAC_DATECALCUL,V_VOW_UNIT,null,0,0,null,null,null,null,
																   null,null,null,null,null,null,null,null,null);
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
						BEGIN
						v_code:='FIXE_ONAS_1';
							for x in C_ITEM(v_code) loop
							V_ITE_ID:=x.ite_id;
							V_ite_name:=x.ite_name
							V_VOW_UNIT:=x.VOW_UNIT
							end loop;
						EXCEPTION WHEN NO_DATA_FOUND THEN NULL;
						END;
						BEGIN
						v_tva_taux= 0;
							for v in C_TVA(v_tva_taux) loop
							   V_TVA_ID:=v.tva_id; 
							end loop;
						EXCEPTION WHEN NO_DATA_FOUND THEN 
						V_TVA_ID := 25;
						END;
						select count(*) 
						into V_nbr 
						from genptaslice 
						where PTA_ID in (select PTA_ID 	
										 from genitemperiodtarif 
										 where TAR_id in(select tar_id 
														 from genitemtarif 
														 where ITE_ID=V_ITE_ID)
										);
						if V_nbr =1 then
						    select PTA_ID,PSL_RANK  
							into V_PTA_ID,V_PSL_RANK 
							from genptaslice 
							where PTA_ID in (select PTA_ID 
											 from genitemperiodtarif 
											 where TAR_id in(select tar_id 
															 from genitemtarif 
															 where ITE_ID=V_ITE_ID)
											)
							and rownum=1;
						end if;
						if V_nbr >1 then
							select PTA_ID,PSL_RANK  
							into V_PTA_ID,V_PSL_RANK 
							from genptaslice 
							where PTA_ID in (select PTA_ID 
											 from genitemperiodtarif
								             where TAR_id in(select tar_id 
															 from genitemtarif 
															 where ITE_ID=V_ITE_ID) 
							                )
							and rownum=1;
						end if;
                        BEGIN
							INSERT INTO genbilline(BIL_ID,BLI_REVERSEBLI_ID,BLI_NUMBER,BLI_REVERSEBLINUMBER,BLI_NAME,BLI_EXERCICE,ITE_ID,PTA_ID,PSL_RANK,
						                           IMP_ID,BLI_VOLUMEBASE,BLI_VOLUMEFACT,BLI_PUHT,TVA_ID,BLI_MHT,BLI_MTTVA,BLI_MTTC,BLI_STARTDT,
												   BLI_ENDDT,VOW_UNIT,BLI_NBUNITES,BLI_DETAIL,BLI_CANCEL,IMC_ID,IMP_ANALYTIQUE_ID,BLI_PERIODEINIT,BLI_PERIODE,
											       BLI_REVERSEDT,BLI_CREDT,BLI_UPDTDT,BLI_UPDTBY,MEU_ID,BLI_NAME_A,BLI_REVERSEBLIDEC_ID,BLI_REVERSEBLINUMBERDEC,BLI_REVERSEDECDT)
										   values(V_BIL_ID,null,v,null,V_ite_name,V_anneereel,V_ITE_ID,V_PTA_ID,V_PSL_RANK,
										          null,1,1,facture_.fixonas/1000,V_TVA_ID,facture_.fixonas/1000,0,facture_.fixonas/1000,V_FAC_DATECALCUL,
												  V_FAC_DATECALCUL,V_VOW_UNIT,null,0,0,null,null,null,null,
												  null,null,null,null,null,null,null,null,null);
						EXCEPTION WHEN OTHERS THEN
											BEGIN
											INSERT INTO genbilline(BIL_ID,BLI_REVERSEBLI_ID,BLI_NUMBER,BLI_REVERSEBLINUMBER,BLI_NAME,BLI_EXERCICE,ITE_ID,PTA_ID,PSL_RANK,
						                                           IMP_ID,BLI_VOLUMEBASE,BLI_VOLUMEFACT,BLI_PUHT,TVA_ID,BLI_MHT,BLI_MTTVA,BLI_MTTC,BLI_STARTDT,
																   BLI_ENDDT,VOW_UNIT,BLI_NBUNITES,BLI_DETAIL,BLI_CANCEL,IMC_ID,IMP_ANALYTIQUE_ID,BLI_PERIODEINIT,BLI_PERIODE,
																   BLI_REVERSEDT,BLI_CREDT,BLI_UPDTDT,BLI_UPDTBY,MEU_ID,BLI_NAME_A,BLI_REVERSEBLIDEC_ID,BLI_REVERSEBLINUMBERDEC,BLI_REVERSEDECDT)
															values(V_BIL_ID,null,v+1,null,V_ite_name,V_anneereel,V_ITE_ID,V_PTA_ID,V_PSL_RANK,
																   null,1,1,facture_.fixonas/1000,V_TVA_ID,facture_.fixonas/1000,0,facture_.fixonas/1000,V_FAC_DATECALCUL,
																   V_FAC_DATECALCUL,V_VOW_UNIT,null,0,0,null,null,null,null,
																   null,null,null,null,null,null,null,null,null);
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
						BEGIN
						v_code:='FRS_FIX_CSM';
							for x in C_ITEM(v_code) loop
							V_ITE_ID:=x.ite_id;
							V_ite_name:=x.ite_name
							V_VOW_UNIT:=x.VOW_UNIT
							end loop;
						EXCEPTION WHEN NO_DATA_FOUND THEN NULL;
						end;
						BEGIN
						v_tva_taux:= 18;
							for v in C_TVA(v_tva_taux) loop
							   V_TVA_ID:=v.tva_id; 
							end loop;
						EXCEPTION WHEN NO_DATA_FOUND THEN 
						V_TVA_ID := 25;
						END;
						select count(*) 
						into V_nbr 
						from genptaslice 
						where PTA_ID in (select PTA_ID 	
										 from genitemperiodtarif 
										 where TAR_id in(select tar_id 
														 from genitemtarif 
														 where ITE_ID=V_ITE_ID)
										);
						if V_nbr =1 then
						
							select PTA_ID,PSL_RANK  
							into V_PTA_ID,V_PSL_RANK 
							from genptaslice 
							where PTA_ID in (select PTA_ID 
											 from genitemperiodtarif 
											 where TAR_id in(select tar_id 
															 from genitemtarif 
															 where ITE_ID=V_ITE_ID)
											)
							and rownum=1;
						end if;
						if V_nbr >1 then
							select PTA_ID,PSL_RANK  
							into V_PTA_ID,V_PSL_RANK 
							from genptaslice 
							where PTA_ID in (select PTA_ID 
											 from genitemperiodtarif
											 where TAR_id in(select tar_id 
															 from genitemtarif 
															 where ITE_ID=V_ITE_ID) 
										    )
							and rownum=1;
						end if;
						BEGIN
							INSERT INTO genbilline(BIL_ID,BLI_REVERSEBLI_ID,BLI_NUMBER,BLI_REVERSEBLINUMBER,BLI_NAME,BLI_EXERCICE,ITE_ID,PTA_ID,PSL_RANK,
						                           IMP_ID,BLI_VOLUMEBASE,BLI_VOLUMEFACT,BLI_PUHT,TVA_ID,BLI_MHT,BLI_MTTVA,BLI_MTTC,BLI_STARTDT,
												   BLI_ENDDT,VOW_UNIT,BLI_NBUNITES,BLI_DETAIL,BLI_CANCEL,IMC_ID,IMP_ANALYTIQUE_ID,BLI_PERIODEINIT,BLI_PERIODE,
											       BLI_REVERSEDT,BLI_CREDT,BLI_UPDTDT,BLI_UPDTBY,MEU_ID,BLI_NAME_A,BLI_REVERSEBLIDEC_ID,BLI_REVERSEBLINUMBERDEC,BLI_REVERSEDECDT)
										    values(V_BIL_ID,null,v,null,V_ite_name,V_anneereel ,V_ITE_ID,V_PTA_ID,V_PSL_RANK,
											       null,1,1,facture_.fraisctr/1000,V_TVA_ID	facture_.fraisctr/1000,facture_.TVA_ff/1000,(facture_.fraisctr/1000)+(facture_.tva_ff/1000),V_FAC_DATECALCUL,
												   V_FAC_DATECALCUL,V_VOW_UNIT,null,0,0,null,null,null,null,
												   null,null,null,null,null,null,null,null,null);
						EXCEPTION WHEN OTHERS THEN
												BEGIN
												INSERT INTO genbilline(BIL_ID,BLI_REVERSEBLI_ID,BLI_NUMBER,BLI_REVERSEBLINUMBER,BLI_NAME,BLI_EXERCICE,ITE_ID,PTA_ID,PSL_RANK,
																	   IMP_ID,BLI_VOLUMEBASE,BLI_VOLUMEFACT,BLI_PUHT,TVA_ID,BLI_MHT,BLI_MTTVA,BLI_MTTC,BLI_STARTDT,
																	   BLI_ENDDT,VOW_UNIT,BLI_NBUNITES,BLI_DETAIL,BLI_CANCEL,IMC_ID,IMP_ANALYTIQUE_ID,BLI_PERIODEINIT,BLI_PERIODE,
																	   BLI_REVERSEDT,BLI_CREDT,BLI_UPDTDT,BLI_UPDTBY,MEU_ID,BLI_NAME_A,BLI_REVERSEBLIDEC_ID,BLI_REVERSEBLINUMBERDEC,BLI_REVERSEDECDT)
																values(V_BIL_ID,null,v,null,V_ite_name,V_anneereel ,V_ITE_ID,V_PTA_ID,V_PSL_RANK,
																	   null,1,1,facture_.fraisctr/1000,V_TVA_ID	facture_.fraisctr/1000,facture_.TVA_ff/1000,(facture_.fraisctr/1000)+(facture_.tva_ff/1000),V_FAC_DATECALCUL,
																	   V_FAC_DATECALCUL,V_VOW_UNIT,null,0,0,null,null,null,null,
																	   null,null,null,null,null,null,null,null,null);
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
						BEGIN
						v_code:='FRS_FIX_PAVI_CPR';
							for x in C_ITEM(v_code) loop
							V_ITE_ID:=x.ite_id;
							V_ite_name:=x.ite_name
							V_VOW_UNIT:=x.VOW_UNIT
							end loop;
						EXCEPTION WHEN NO_DATA_FOUND THEN NULL;
						END;
						BEGIN
						v_tva_taux:= 18;
							for v in C_TVA(v_tva_taux) loop
							   V_TVA_ID:=v.tva_id; 
							end loop;
						EXCEPTION WHEN NO_DATA_FOUND THEN 
						V_TVA_ID := 25;
						END;
						select count(*) 
						into V_nbr 
						from genptaslice 
						where PTA_ID in (select PTA_ID 	from genitemperiodtarif 
										 where TAR_id in(select tar_id 
														 from genitemtarif 
														 where ITE_ID=V_ITE_ID )
										);
						if V_nbr =1 then
						    select PTA_ID,PSL_RANK  
							into V_PTA_ID,V_PSL_RANK 
							from genptaslice 
							where PTA_ID in (select PTA_ID 
											 from genitemperiodtarif 
											 where TAR_id in(select tar_id 
															 from genitemtarif 
															 where ITE_ID=V_ITE_ID)
											)
							and rownum=1;
						end if;
						if V_nbr >1 then
							select PTA_ID,PSL_RANK  
							into V_PTA_ID,V_PSL_RANK 
							from genptaslice 
							where PTA_ID in(select PTA_ID 
											from genitemperiodtarif
										    where TAR_id in(select tar_id 
															from genitemtarif 
															where ITE_ID=V_ITE_ID) 
							                )
							and rownum=1;
						end if;

						BEGIN
							INSERT INTO genbilline(BIL_ID,BLI_REVERSEBLI_ID,BLI_NUMBER,BLI_REVERSEBLINUMBER,BLI_NAME,BLI_EXERCICE,ITE_ID,PTA_ID,PSL_RANK,
												   IMP_ID,BLI_VOLUMEBASE,BLI_VOLUMEFACT,BLI_PUHT,TVA_ID,BLI_MHT,BLI_MTTVA,BLI_MTTC,BLI_STARTDT,
												   BLI_ENDDT,VOW_UNIT,BLI_NBUNITES,BLI_DETAIL,BLI_CANCEL,IMC_ID,IMP_ANALYTIQUE_ID,BLI_PERIODEINIT,BLI_PERIODE,
												   BLI_REVERSEDT,BLI_CREDT,BLI_UPDTDT,BLI_UPDTBY,MEU_ID,BLI_NAME_A,BLI_REVERSEBLIDEC_ID,BLI_REVERSEBLINUMBERDEC,BLI_REVERSEDECDT)
											values(V_BIL_ID,null,v,null,V_ite_name,V_anneereel,V_ITE_ID,V_PTA_ID,V_PSL_RANK,
											       null,1,1,facture_.fermeture/1000,V_TVA_ID,facture_.fermeture/1000,facture_.tvaferm/1000,(facture_.fermeture/1000)+(facture_.tvaferm/1000),V_FAC_DATECALCUL,
												   V_FAC_DATECALCUL,V_VOW_UNIT,null,0,0,null,null,null,null,
												   null,null,null,null,null,null,null,null,null);
						EXCEPTION WHEN OTHERS THEN
											BEGIN
											     INSERT INTO genbilline(BIL_ID,BLI_REVERSEBLI_ID,BLI_NUMBER,BLI_REVERSEBLINUMBER,BLI_NAME,BLI_EXERCICE,ITE_ID,PTA_ID,PSL_RANK,
																	   IMP_ID,BLI_VOLUMEBASE,BLI_VOLUMEFACT,BLI_PUHT,TVA_ID,BLI_MHT,BLI_MTTVA,BLI_MTTC,BLI_STARTDT,
																	   BLI_ENDDT,VOW_UNIT,BLI_NBUNITES,BLI_DETAIL,BLI_CANCEL,IMC_ID,IMP_ANALYTIQUE_ID,BLI_PERIODEINIT,BLI_PERIODE,
																	   BLI_REVERSEDT,BLI_CREDT,BLI_UPDTDT,BLI_UPDTBY,MEU_ID,BLI_NAME_A,BLI_REVERSEBLIDEC_ID,BLI_REVERSEBLINUMBERDEC,BLI_REVERSEDECDT)
																values(V_BIL_ID,null,v+1,null,V_ite_name,V_anneereel,V_ITE_ID,V_PTA_ID,V_PSL_RANK,
																	   null,1,1,facture_.fermeture/1000,V_TVA_ID,facture_.fermeture/1000,facture_.tvaferm/1000,(facture_.fermeture/1000)+(facture_.tvaferm/1000),V_FAC_DATECALCUL,
																	   V_FAC_DATECALCUL,V_VOW_UNIT,null,0,0,null,null,null,null,
																	   null,null,null,null,null,null,null,null,null);
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
						BEGIN
						v_code:='F_DEPLACEMNT';
							for x in C_ITEM(v_code) loop
							V_ITE_ID:=x.ite_id;
							V_ite_name:=x.ite_name
							V_VOW_UNIT:=x.VOW_UNIT
							end loop;
						EXCEPTION WHEN NO_DATA_FOUND THEN NULL;
						END;
						BEGIN
						v_tva_taux:= 18;
							for v in C_TVA(v_tva_taux) loop
							   V_TVA_ID:=v.tva_id; 
							end loop;
						EXCEPTION WHEN NO_DATA_FOUND THEN 
						V_TVA_ID := 25;
						END;
						select count(*) 
						into V_nbr 
						from genptaslice 
						where PTA_ID in (select PTA_ID 	
										 from genitemperiodtarif 
										 where TAR_id in(select tar_id 
														 from genitemtarif 
														 where ITE_ID=V_ITE_ID )
										);
						if V_nbr =1 then
							select PTA_ID,PSL_RANK  
							into V_PTA_ID,V_PSL_RANK 
							from genptaslice 
							where PTA_ID in (select PTA_ID 
											 from genitemperiodtarif 
											 where TAR_id in(select tar_id 
															 from genitemtarif 
															 where ITE_ID=V_ITE_ID)
											)
							and rownum=1;
						end if;
						if V_nbr >1 then
							select PTA_ID,PSL_RANK  
							into V_PTA_ID,V_PSL_RANK 
							from genptaslice 
							where PTA_ID in (select PTA_ID 
											 from genitemperiodtarif
											 where TAR_id in(select tar_id 
															 from genitemtarif 
															 where ITE_ID=V_ITE_ID) 
										    )
							and rownum=1;
						end if;
						BEGIN
							  INSERT INTO genbilline(BIL_ID,BLI_REVERSEBLI_ID,BLI_NUMBER,BLI_REVERSEBLINUMBER,BLI_NAME,BLI_EXERCICE,ITE_ID,PTA_ID,PSL_RANK,
												     IMP_ID,BLI_VOLUMEBASE,BLI_VOLUMEFACT,BLI_PUHT,TVA_ID,BLI_MHT,BLI_MTTVA,BLI_MTTC,BLI_STARTDT,
												     BLI_ENDDT,VOW_UNIT,BLI_NBUNITES,BLI_DETAIL,BLI_CANCEL,IMC_ID,IMP_ANALYTIQUE_ID,BLI_PERIODEINIT,BLI_PERIODE,
												     BLI_REVERSEDT,BLI_CREDT,BLI_UPDTDT,BLI_UPDTBY,MEU_ID,BLI_NAME_A,BLI_REVERSEBLIDEC_ID,BLI_REVERSEBLINUMBERDEC,BLI_REVERSEDECDT)
											values(V_BIL_ID,null,v,null,V_ite_name,V_anneereel,V_ITE_ID,V_PTA_ID,V_PSL_RANK,
											       null,1,1,facture_.deplacement/1000,V_TVA_ID,facture_.deplacement/1000,facture_.tvadeplac/1000,(facture_.deplacement/1000)+(facture_.tvadeplac/1000),V_FAC_DATECALCUL,
												   V_FAC_DATECALCUL,V_VOW_UNIT,null,0,0,null,null,null,null,
												   null,null,null,null,null,null,null,null,null);
						EXCEPTION WHEN OTHERS THEN
											BEGIN
											  INSERT INTO genbilline(BIL_ID,BLI_REVERSEBLI_ID,BLI_NUMBER,BLI_REVERSEBLINUMBER,BLI_NAME,BLI_EXERCICE,ITE_ID,PTA_ID,PSL_RANK,
																	 IMP_ID,BLI_VOLUMEBASE,BLI_VOLUMEFACT,BLI_PUHT,TVA_ID,BLI_MHT,BLI_MTTVA,BLI_MTTC,BLI_STARTDT,
																	 BLI_ENDDT,VOW_UNIT,BLI_NBUNITES,BLI_DETAIL,BLI_CANCEL,IMC_ID,IMP_ANALYTIQUE_ID,BLI_PERIODEINIT,BLI_PERIODE,
																	 BLI_REVERSEDT,BLI_CREDT,BLI_UPDTDT,BLI_UPDTBY,MEU_ID,BLI_NAME_A,BLI_REVERSEBLIDEC_ID,BLI_REVERSEBLINUMBERDEC,BLI_REVERSEDECDT)
															values(V_BIL_ID,null,v+1,null,V_ite_name,V_anneereel,V_ITE_ID,V_PTA_ID,V_PSL_RANK,
																   null,1,1,facture_.deplacement/1000,V_TVA_ID,facture_.deplacement/1000,facture_.tvadeplac/1000,(facture_.deplacement/1000)+(facture_.tvadeplac/1000),V_FAC_DATECALCUL,
																   V_FAC_DATECALCUL,V_VOW_UNIT,null,0,0,null,null,null,null,
																   null,null,null,null,null,null,null,null,null);
											EXCEPTION WHEN OTHERS THEN NULL;
											END;
						END;
						commit;
				end if;
-------------------------------------------------------------------------------------------
-----------------------------------Frais de dépose suite à la demande du client------------
-------------------------------------------------------------------------------------------	
				if to_number(facture_.depose_dem) <> 0 then  
					v := v+1;
						V_PTA_ID := null;
						V_PSL_RANK := null;
						BEGIN
						v_code:='FRAIS_FRM_DEP';
							for x in C_ITEM(v_code) loop
							V_ITE_ID:=x.ite_id;
							V_ite_name:=x.ite_name
							V_VOW_UNIT:=x.VOW_UNIT
							end loop;
						EXCEPTION WHEN NO_DATA_FOUND THEN NULL;
						END;
						BEGIN
						v_tva_taux:= 18;
							for v in C_TVA(v_tva_taux) loop
							   V_TVA_ID:=v.tva_id; 
							end loop;
						EXCEPTION WHEN NO_DATA_FOUND THEN 
						V_TVA_ID := 25;
						END;
						select count(*) 
						into V_nbr 
						from genptaslice 
						where PTA_ID in (select PTA_ID 	
										 from genitemperiodtarif 
										 where TAR_id in(select tar_id 
														 from genitemtarif 
														 where ITE_ID=V_ITE_ID)
										);
						if V_nbr =1 then
						    select PTA_ID,PSL_RANK  
							into V_PTA_ID,V_PSL_RANK 
							from genptaslice 
							where PTA_ID in (select PTA_ID 
											 from genitemperiodtarif 
											 where TAR_id in(select tar_id 
															 from genitemtarif 
															 where ITE_ID=V_ITE_ID)
											)
							and rownum=1;
						end if;
						if V_nbr >1 then
							select PTA_ID,PSL_RANK  
							into V_PTA_ID,V_PSL_RANK 
							from genptaslice 
							where PTA_ID in(select PTA_ID 
											 from genitemperiodtarif
								             where TAR_id in(select tar_id 
															 from genitemtarif 
															 where ITE_ID=V_ITE_ID) 
							                )
							and rownum=1;
						end if;

						BEGIN
							INSERT INTO genbilline(BIL_ID,BLI_REVERSEBLI_ID,BLI_NUMBER,BLI_REVERSEBLINUMBER,BLI_NAME,BLI_EXERCICE,ITE_ID,PTA_ID,PSL_RANK,
												   IMP_ID,BLI_VOLUMEBASE,BLI_VOLUMEFACT,BLI_PUHT,TVA_ID,BLI_MHT,BLI_MTTVA,BLI_MTTC,BLI_STARTDT,
												   BLI_ENDDT,VOW_UNIT,BLI_NBUNITES,BLI_DETAIL,BLI_CANCEL,IMC_ID,IMP_ANALYTIQUE_ID,BLI_PERIODEINIT,BLI_PERIODE,
												   BLI_REVERSEDT,BLI_CREDT,BLI_UPDTDT,BLI_UPDTBY,MEU_ID,BLI_NAME_A,BLI_REVERSEBLIDEC_ID,BLI_REVERSEBLINUMBERDEC,BLI_REVERSEDECDT)
											values(V_BIL_ID,null,v,null,V_ite_name,V_anneereel,V_ITE_ID,V_PTA_ID,V_PSL_RANK,
											       null,1,1,facture_.depose_dem/1000,V_TVA_ID,facture_.depose_dem/1000,facture_.tvadepose_dem/1000,facture_.depose_dem/1000 + (facture_.tvadepose_dem/1000),V_FAC_DATECALCUL,
												   V_FAC_DATECALCUL,V_VOW_UNIT,null,0,0,null,null,null,null,
												   null,null,null,null,null,null,null,null,null);
						EXCEPTION WHEN OTHERS THEN
											BEGIN
												INSERT INTO genbilline(BIL_ID,BLI_REVERSEBLI_ID,BLI_NUMBER,BLI_REVERSEBLINUMBER,BLI_NAME,BLI_EXERCICE,ITE_ID,PTA_ID,PSL_RANK,
																	   IMP_ID,BLI_VOLUMEBASE,BLI_VOLUMEFACT,BLI_PUHT,TVA_ID,BLI_MHT,BLI_MTTVA,BLI_MTTC,BLI_STARTDT,
																	   BLI_ENDDT,VOW_UNIT,BLI_NBUNITES,BLI_DETAIL,BLI_CANCEL,IMC_ID,IMP_ANALYTIQUE_ID,BLI_PERIODEINIT,BLI_PERIODE,
																	   BLI_REVERSEDT,BLI_CREDT,BLI_UPDTDT,BLI_UPDTBY,MEU_ID,BLI_NAME_A,BLI_REVERSEBLIDEC_ID,BLI_REVERSEBLINUMBERDEC,BLI_REVERSEDECDT)
																values(V_BIL_ID,null,v+1,null,V_ite_name,V_anneereel,V_ITE_ID,V_PTA_ID,V_PSL_RANK,
																	   null,1,1,facture_.depose_dem/1000,V_TVA_ID,facture_.depose_dem/1000,facture_.tvadepose_dem/1000,facture_.depose_dem/1000 + (facture_.tvadepose_dem/1000),V_FAC_DATECALCUL,
																	   V_FAC_DATECALCUL,V_VOW_UNIT,null,0,0,null,null,null,null,
																	   null,null,null,null,null,null,null,null,null);
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
						BEGIN
						v_code:='FRS_DPOZ_RPOZ';
							for x in C_ITEM(v_code) loop
							V_ITE_ID:=x.ite_id;
							V_ite_name:=x.ite_name
							V_VOW_UNIT:=x.VOW_UNIT
							end loop;
						EXCEPTION WHEN NO_DATA_FOUND THEN NULL;
						END;
						BEGIN
						v_tva_taux:= 18;
							for v in C_TVA(v_tva_taux) loop
							   V_TVA_ID:=v.tva_id; 
							end loop;
						EXCEPTION WHEN NO_DATA_FOUND THEN 
						V_TVA_ID := 25;
						END;
                        select count(*) 
						into V_nbr 
						from genptaslice 
						where PTA_ID in (select PTA_ID 
										 from genitemperiodtarif 
										 where TAR_id in(select tar_id 
														 from genitemtarif 
														 where ITE_ID=V_ITE_ID )
										);
						if V_nbr =1 then
						    select PTA_ID,PSL_RANK  
							into V_PTA_ID,V_PSL_RANK 
							from genptaslice 
							where PTA_ID in (select PTA_ID 
											 from genitemperiodtarif 
											 where TAR_id in(select tar_id 
															 from genitemtarif 
															 where ITE_ID=V_ITE_ID)
											)
							and rownum=1;
						end if;
						if V_nbr >1 then
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
						BEGIN
							INSERT INTO genbilline(BIL_ID,BLI_REVERSEBLI_ID,BLI_NUMBER,BLI_REVERSEBLINUMBER,BLI_NAME,BLI_EXERCICE,ITE_ID,PTA_ID,PSL_RANK,
												   IMP_ID,BLI_VOLUMEBASE,BLI_VOLUMEFACT,BLI_PUHT,TVA_ID,BLI_MHT,BLI_MTTVA,BLI_MTTC,BLI_STARTDT,
												   BLI_ENDDT,VOW_UNIT,BLI_NBUNITES,BLI_DETAIL,BLI_CANCEL,IMC_ID,IMP_ANALYTIQUE_ID,BLI_PERIODEINIT,BLI_PERIODE,
												   BLI_REVERSEDT,BLI_CREDT,BLI_UPDTDT,BLI_UPDTBY,MEU_ID,BLI_NAME_A,BLI_REVERSEBLIDEC_ID,BLI_REVERSEBLINUMBERDEC,BLI_REVERSEDECDT)
											values(V_BIL_ID,null,v,null,V_ite_name,V_anneereel,V_ITE_ID,V_PTA_ID,V_PSL_RANK,
											       null,1,1,(facture_.depose_def/1000),V_TVA_ID,(facture_.depose_def/1000),(facture_.tvadepose_def/1000),(facture_.depose_def/1000 + (facture_.tvadepose_def/1000)),V_FAC_DATECALCUL,
												   V_FAC_DATECALCUL,V_VOW_UNIT,null,0,0,null,null,null,null,
												   null,null,null,null,null,null,null,null,null);
						EXCEPTION WHEN OTHERS THEN
											BEGIN
												INSERT INTO genbilline(BIL_ID,BLI_REVERSEBLI_ID,BLI_NUMBER,BLI_REVERSEBLINUMBER,BLI_NAME,BLI_EXERCICE,ITE_ID,PTA_ID,PSL_RANK,
																	   IMP_ID,BLI_VOLUMEBASE,BLI_VOLUMEFACT,BLI_PUHT,TVA_ID,BLI_MHT,BLI_MTTVA,BLI_MTTC,BLI_STARTDT,
																	   BLI_ENDDT,VOW_UNIT,BLI_NBUNITES,BLI_DETAIL,BLI_CANCEL,IMC_ID,IMP_ANALYTIQUE_ID,BLI_PERIODEINIT,BLI_PERIODE,
																	   BLI_REVERSEDT,BLI_CREDT,BLI_UPDTDT,BLI_UPDTBY,MEU_ID,BLI_NAME_A,BLI_REVERSEBLIDEC_ID,BLI_REVERSEBLINUMBERDEC,BLI_REVERSEDECDT)
																values(V_BIL_ID,null,v+1,null,V_ite_name,V_anneereel,V_ITE_ID,V_PTA_ID,V_PSL_RANK,
																	   null,1,1,(facture_.depose_def/1000),V_TVA_ID,(facture_.depose_def/1000),(facture_.tvadepose_def/1000),(facture_.depose_def/1000 + (facture_.tvadepose_def/1000)),V_FAC_DATECALCUL,
																	   V_FAC_DATECALCUL,V_VOW_UNIT,null,0,0,null,null,null,null,
																	   null,null,null,null,null,null,null,null,null);			 
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
						BEGIN
						v_code:='CAPITAL';
							for x in C_ITEM(v_code) loop
							V_ITE_ID:=x.ite_id;
							V_ite_name:=x.ite_name
							V_VOW_UNIT:=x.VOW_UNIT
							end loop;
						EXCEPTION WHEN NO_DATA_FOUND THEN NULL;
						END;
						BEGIN
						v_tva_taux:=0;
							for v in C_TVA(v_tva_taux) loop
							   V_TVA_ID:=v.tva_id; 
							end loop;
						EXCEPTION WHEN NO_DATA_FOUND THEN 
						V_TVA_ID := 25;
						END;
						select count(*) 
						into V_nbr 
						from genptaslice 
						where PTA_ID in (select PTA_ID 	
										 from genitemperiodtarif 
										 where TAR_id in(select tar_id
														 from genitemtarif 
														 where ITE_ID=V_ITE_ID)
										);
						if V_nbr =1 then
						    select PTA_ID,PSL_RANK  
							into V_PTA_ID,V_PSL_RANK 
							from genptaslice 
							where PTA_ID in (select PTA_ID 
											 from genitemperiodtarif 
											 where TAR_id in(select tar_id 
															  from genitemtarif 
															  where ITE_ID=V_ITE_ID)
											)
							and rownum=1;
						end if;
						if V_nbr >1 then
							select PTA_ID,PSL_RANK  
							into V_PTA_ID,V_PSL_RANK 
							from genptaslice 
							where PTA_ID in (select PTA_ID 
											 from genitemperiodtarif
									         where TAR_id in(select tar_id 
													         from genitemtarif 
															 where ITE_ID=V_ITE_ID) 
							                )
							and rownum=1;
						end if;
						BEGIN
							INSERT INTO genbilline(BIL_ID,BLI_REVERSEBLI_ID,BLI_NUMBER,BLI_REVERSEBLINUMBER,BLI_NAME,BLI_EXERCICE,ITE_ID,PTA_ID,PSL_RANK,
												   IMP_ID,BLI_VOLUMEBASE,BLI_VOLUMEFACT,BLI_PUHT,TVA_ID,BLI_MHT,BLI_MTTVA,BLI_MTTC,BLI_STARTDT,
												   BLI_ENDDT,VOW_UNIT,BLI_NBUNITES,BLI_DETAIL,BLI_CANCEL,IMC_ID,IMP_ANALYTIQUE_ID,BLI_PERIODEINIT,BLI_PERIODE,
												   BLI_REVERSEDT,BLI_CREDT,BLI_UPDTDT,BLI_UPDTBY,MEU_ID,BLI_NAME_A,BLI_REVERSEBLIDEC_ID,BLI_REVERSEBLINUMBERDEC,BLI_REVERSEDECDT)
										   values(V_BIL_ID,null,v,null,V_ite_name,V_anneereel,V_ITE_ID,V_PTA_ID,V_PSL_RANK,
											       null,1,1,facture_.CAPIT/1000,V_TVA_ID,facture_.CAPIT/1000,facture_.tva_capit/1000,facture_.CAPIT/1000,V_FAC_DATECALCUL,
												   V_FAC_DATECALCUL,V_VOW_UNIT,null,0,0,null,null,null,null,
												   null,null,null,null,null,null,null,null,null	);
						EXCEPTION WHEN OTHERS THEN
											BEGIN
											 	INSERT INTO genbilline(BIL_ID,BLI_REVERSEBLI_ID,BLI_NUMBER,BLI_REVERSEBLINUMBER,BLI_NAME,BLI_EXERCICE,ITE_ID,PTA_ID,PSL_RANK,
																	   IMP_ID,BLI_VOLUMEBASE,BLI_VOLUMEFACT,BLI_PUHT,TVA_ID,BLI_MHT,BLI_MTTVA,BLI_MTTC,BLI_STARTDT,
																	   BLI_ENDDT,VOW_UNIT,BLI_NBUNITES,BLI_DETAIL,BLI_CANCEL,IMC_ID,IMP_ANALYTIQUE_ID,BLI_PERIODEINIT,BLI_PERIODE,
																	   BLI_REVERSEDT,BLI_CREDT,BLI_UPDTDT,BLI_UPDTBY,MEU_ID,BLI_NAME_A,BLI_REVERSEBLIDEC_ID,BLI_REVERSEBLINUMBERDEC,BLI_REVERSEDECDT)
															   values(V_BIL_ID,null,v+1,null,V_ite_name,V_anneereel,V_ITE_ID,V_PTA_ID,V_PSL_RANK,
																	   null,1,1,facture_.CAPIT/1000,V_TVA_ID,facture_.CAPIT/1000,facture_.tva_capit/1000,facture_.CAPIT/1000,V_FAC_DATECALCUL,
																	   V_FAC_DATECALCUL,V_VOW_UNIT,null,0,0,null,null,null,null,
																	   null,null,null,null,null,null,null,null,null	);
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
						BEGIN
						v_code:='INTERET';
							for x in C_ITEM(v_code) loop
							V_ITE_ID:=x.ite_id;
							V_ite_name:=x.ite_name
							V_VOW_UNIT:=x.VOW_UNIT
							end loop;
						EXCEPTION WHEN NO_DATA_FOUND THEN NULL;
						END;
						BEGIN
						v_tva_taux:=0;
							for v in C_TVA(v_tva_taux) loop
							   V_TVA_ID:=v.tva_id; 
							end loop;
						EXCEPTION WHEN NO_DATA_FOUND THEN 
						V_TVA_ID := 25;
						END;
						select count(*) 
						into V_nbr 
						from genptaslice 
						where PTA_ID in (select PTA_ID 	
										 from genitemperiodtarif 
										 where TAR_id in(select tar_id 
														 from genitemtarif 
														 where ITE_ID=V_ITE_ID)
										);
						if V_nbr =1 then
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
						if V_nbr >1 then
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
                        BEGIN
							 INSERT INTO genbilline(BIL_ID,BLI_REVERSEBLI_ID,BLI_NUMBER,BLI_REVERSEBLINUMBER,BLI_NAME,BLI_EXERCICE,ITE_ID,PTA_ID,PSL_RANK,
												    IMP_ID,BLI_VOLUMEBASE,BLI_VOLUMEFACT,BLI_PUHT,TVA_ID,BLI_MHT,BLI_MTTVA,BLI_MTTC,BLI_STARTDT,
												    BLI_ENDDT,VOW_UNIT,BLI_NBUNITES,BLI_DETAIL,BLI_CANCEL,IMC_ID,IMP_ANALYTIQUE_ID,BLI_PERIODEINIT,BLI_PERIODE,
												    BLI_REVERSEDT,BLI_CREDT,BLI_UPDTDT,BLI_UPDTBY,MEU_ID,BLI_NAME_A,BLI_REVERSEBLIDEC_ID,BLI_REVERSEBLINUMBERDEC,BLI_REVERSEDECDT)
										   values(V_BIL_ID,null,v,null,V_ite_name,V_anneereel,V_ITE_ID,V_PTA_ID,V_PSL_RANK,
										          null,1,1,facture_.INTER/1000,V_TVA_ID,facture_.INTER/1000,0,facture_.INTER/1000,V_FAC_DATECALCUL,
												  V_FAC_DATECALCUL,V_VOW_UNIT,null,0,0,null,null,null,null,
												  null,null,null,null,null,null,null,null,null);
						EXCEPTION WHEN OTHERS THEN
											BEGIN
											 INSERT INTO genbilline(BIL_ID,BLI_REVERSEBLI_ID,BLI_NUMBER,BLI_REVERSEBLINUMBER,BLI_NAME,BLI_EXERCICE,ITE_ID,PTA_ID,PSL_RANK,
																	IMP_ID,BLI_VOLUMEBASE,BLI_VOLUMEFACT,BLI_PUHT,TVA_ID,BLI_MHT,BLI_MTTVA,BLI_MTTC,BLI_STARTDT,
																	BLI_ENDDT,VOW_UNIT,BLI_NBUNITES,BLI_DETAIL,BLI_CANCEL,IMC_ID,IMP_ANALYTIQUE_ID,BLI_PERIODEINIT,BLI_PERIODE,
																	BLI_REVERSEDT,BLI_CREDT,BLI_UPDTDT,BLI_UPDTBY,MEU_ID,BLI_NAME_A,BLI_REVERSEBLIDEC_ID,BLI_REVERSEBLINUMBERDEC,BLI_REVERSEDECDT)
														   values(V_BIL_ID,null,v+1,null,V_ite_name,V_anneereel,V_ITE_ID,V_PTA_ID,V_PSL_RANK,
																  null,1,1,facture_.INTER/1000,V_TVA_ID,facture_.INTER/1000,0,facture_.INTER/1000,V_FAC_DATECALCUL,
																  V_FAC_DATECALCUL,V_VOW_UNIT,null,0,0,null,null,null,null,
																  null,null,null,null,null,null,null,null,null);
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
						BEGIN
						v_code:='COURETABBR';
							for x in C_ITEM(v_code) loop
							V_ITE_ID:=x.ite_id;
							V_ite_name:=x.ite_name
							V_VOW_UNIT:=x.VOW_UNIT
							end loop;
						EXCEPTION WHEN NO_DATA_FOUND THEN NULL;
						END;
						BEGIN
						v_tva_taux:= 0;
							for v in C_TVA(v_tva_taux) loop
							   V_TVA_ID:=v.tva_id; 
							end loop;
						EXCEPTION WHEN NO_DATA_FOUND THEN 
						  V_TVA_ID := 25;
						END;
						select count(*) 
						into V_nbr 
						from genptaslice 
						where PTA_ID in (select PTA_ID 	
										 from genitemperiodtarif 
										 where TAR_id in(select tar_id 
														 from genitemtarif 
														 where ITE_ID=V_ITE_ID)
										);
						if V_nbr =1 then
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
						if V_nbr >1 then
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
						BEGIN
							INSERT INTO genbilline(BIL_ID,BLI_REVERSEBLI_ID,BLI_NUMBER,BLI_REVERSEBLINUMBER,BLI_NAME,BLI_EXERCICE,ITE_ID,PTA_ID,PSL_RANK,
												   IMP_ID,BLI_VOLUMEBASE,BLI_VOLUMEFACT,BLI_PUHT,TVA_ID,BLI_MHT,BLI_MTTVA,BLI_MTTC,BLI_STARTDT,
												   BLI_ENDDT,VOW_UNIT,BLI_NBUNITES,BLI_DETAIL,BLI_CANCEL,IMC_ID,IMP_ANALYTIQUE_ID,BLI_PERIODEINIT,BLI_PERIODE,
												   BLI_REVERSEDT,BLI_CREDT,BLI_UPDTDT,BLI_UPDTBY,MEU_ID,BLI_NAME_A,BLI_REVERSEBLIDEC_ID,BLI_REVERSEBLINUMBERDEC,BLI_REVERSEDECDT)
											values(V_BIL_ID,null,v,null,V_ite_name,V_anneereel,V_ITE_ID,V_PTA_ID,V_PSL_RANK,
											       null,1,1,facture_.RBRANCHE/1000,V_TVA_ID,facture_.RBRANCHE/1000,0,facture_.RBRANCHE/1000,V_FAC_DATECALCUL,
												   V_FAC_DATECALCUL,V_VOW_UNIT,null,0,0,null,null,null,null,
												   null,null,null,null,null,null,null,null,null);
						EXCEPTION WHEN OTHERS THEN
											BEGIN
											INSERT INTO genbilline(BIL_ID,BLI_REVERSEBLI_ID,BLI_NUMBER,BLI_REVERSEBLINUMBER,BLI_NAME,BLI_EXERCICE,ITE_ID,PTA_ID,PSL_RANK,
																   IMP_ID,BLI_VOLUMEBASE,BLI_VOLUMEFACT,BLI_PUHT,TVA_ID,BLI_MHT,BLI_MTTVA,BLI_MTTC,BLI_STARTDT,
																   BLI_ENDDT,VOW_UNIT,BLI_NBUNITES,BLI_DETAIL,BLI_CANCEL,IMC_ID,IMP_ANALYTIQUE_ID,BLI_PERIODEINIT,BLI_PERIODE,
																   BLI_REVERSEDT,BLI_CREDT,BLI_UPDTDT,BLI_UPDTBY,MEU_ID,BLI_NAME_A,BLI_REVERSEBLIDEC_ID,BLI_REVERSEBLINUMBERDEC,BLI_REVERSEDECDT)
															values(V_BIL_ID,null,v+1,null,V_ite_name,V_anneereel,V_ITE_ID,V_PTA_ID,V_PSL_RANK,
															       null,1,1,facture_.RBRANCHE/1000,V_TVA_ID,facture_.RBRANCHE/1000,0,facture_.RBRANCHE/1000,V_FAC_DATECALCUL,
																   V_FAC_DATECALCUL,V_VOW_UNIT,null,0,0,null,null,null,null,
																   null,null,null,null,null,null,null,null,null);
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
						BEGIN
						v_code:='PFINANCIER';
							for x in C_ITEM(v_code) loop
							V_ITE_ID:=x.ite_id;
							V_ite_name:=x.ite_name
							V_VOW_UNIT:=x.VOW_UNIT
							end loop;
						EXCEPTION WHEN NO_DATA_FOUND THEN NULL;
						END;
						BEGIN
						v_tva_taux:= 0;
							for v in C_TVA(v_tva_taux) loop
							   V_TVA_ID:=v.tva_id; 
							end loop;
						EXCEPTION WHEN NO_DATA_FOUND THEN 
						V_TVA_ID := 25;
						END;
						select count(*) 
						into V_nbr 
						from genptaslice 
						where PTA_ID in (select PTA_ID
										 from genitemperiodtarif 
										 where TAR_id in(select tar_id 
														 from genitemtarif 
														 where ITE_ID=V_ITE_ID )
										);
						if V_nbr =1 then
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
						if V_nbr >1 then
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
						BEGIN
							INSERT INTO genbilline(BIL_ID,BLI_REVERSEBLI_ID,BLI_NUMBER,BLI_REVERSEBLINUMBER,BLI_NAME,BLI_EXERCICE,ITE_ID,PTA_ID,PSL_RANK,
												   IMP_ID,BLI_VOLUMEBASE,BLI_VOLUMEFACT,BLI_PUHT,TVA_ID,BLI_MHT,BLI_MTTVA,BLI_MTTC,BLI_STARTDT,
												   BLI_ENDDT,VOW_UNIT,BLI_NBUNITES,BLI_DETAIL,BLI_CANCEL,IMC_ID,IMP_ANALYTIQUE_ID,BLI_PERIODEINIT,BLI_PERIODE,
												   BLI_REVERSEDT,BLI_CREDT,BLI_UPDTDT,BLI_UPDTBY,MEU_ID,BLI_NAME_A,BLI_REVERSEBLIDEC_ID,BLI_REVERSEBLINUMBERDEC,BLI_REVERSEDECDT)
											values(V_BIL_ID,null,v,null,V_ite_name,V_anneereel,V_ITE_ID,V_PTA_ID,V_PSL_RANK,
											       null,1,1,(facture_.PFINANCIER/1000),V_TVA_ID,(facture_.PFINANCIER/1000),(facture_.tva_pfin/1000),(facture_.PFINANCIER/1000),V_FAC_DATECALCUL,
												   V_FAC_DATECALCUL,V_VOW_UNIT,null,0,0,null,null,null,null,
												   null,null,null,null,null,null,null,null,null);
						EXCEPTION WHEN OTHERS THEN
											BEGIN
											INSERT INTO genbilline(BIL_ID,BLI_REVERSEBLI_ID,BLI_NUMBER,BLI_REVERSEBLINUMBER,BLI_NAME,BLI_EXERCICE,ITE_ID,PTA_ID,PSL_RANK,
																   IMP_ID,BLI_VOLUMEBASE,BLI_VOLUMEFACT,BLI_PUHT,TVA_ID,BLI_MHT,BLI_MTTVA,BLI_MTTC,BLI_STARTDT,
																   BLI_ENDDT,VOW_UNIT,BLI_NBUNITES,BLI_DETAIL,BLI_CANCEL,IMC_ID,IMP_ANALYTIQUE_ID,BLI_PERIODEINIT,BLI_PERIODE,
																   BLI_REVERSEDT,BLI_CREDT,BLI_UPDTDT,BLI_UPDTBY,MEU_ID,BLI_NAME_A,BLI_REVERSEBLIDEC_ID,BLI_REVERSEBLINUMBERDEC,BLI_REVERSEDECDT)
															values(V_BIL_ID,null,v+1,null,V_ite_name,V_anneereel,V_ITE_ID,V_PTA_ID,V_PSL_RANK,
																   null,1,1,(facture_.PFINANCIER/1000),V_TVA_ID,(facture_.PFINANCIER/1000),(facture_.tva_pfin/1000),(facture_.PFINANCIER/1000),V_FAC_DATECALCUL,
																   V_FAC_DATECALCUL,V_VOW_UNIT,null,0,0,null,null,null,null,
																   null,null,null,null,null,null,null,null,null);
											EXCEPTION WHEN OTHERS THEN NULL;
											END;
						END;
						commit;
				end if;	
-------------------------------------------------------------------------------------------
-----------------------------------MONTANT REPORT------------------------------------------
-------------------------------------------------------------------------------------------	
				if to_number(facture_.AREPOR) <> 0 then
					v := v+1;
						V_PTA_ID   := null;
						V_PSL_RANK := null;
						V_BLI_MHT  := null;
						BEGIN
						v_code:='AREPOR';
							for x in C_ITEM(v_code) loop
							V_ITE_ID:=x.ite_id;
							V_ite_name:=x.ite_name
							V_VOW_UNIT:=x.VOW_UNIT
						end loop;
						EXCEPTION WHEN NO_DATA_FOUND THEN NULL;
						END;
						BEGIN
						v_tva_taux:= 0;
							for v in C_TVA(v_tva_taux) loop
							   V_TVA_ID:=v.tva_id; 
							end loop;
						EXCEPTION WHEN NO_DATA_FOUND THEN 
						V_TVA_ID := 25;
						END;
						select count(*) 
						into V_nbr 
						from genptaslice 
						where PTA_ID in (select PTA_ID 	from genitemperiodtarif 
										 where TAR_id in(select tar_id 
														 from genitemtarif 
														 where ITE_ID=V_ITE_ID)
										);
						if V_nbr =1 then
						    select PTA_ID,PSL_RANK  
							into V_PTA_ID,V_PSL_RANK 
							from genptaslice 
							where PTA_ID in (select PTA_ID 
											 from genitemperiodtarif 
											 where TAR_id in(select tar_id
															 from genitemtarif 
															 where ITE_ID=V_ITE_ID)
											)
							and rownum=1;
						end if;
						if V_nbr >1 then
							select PTA_ID,PSL_RANK  
							into V_PTA_ID,V_PSL_RANK 
							from genptaslice 
							where PTA_ID in (select PTA_ID 
											 from genitemperiodtarif 
											 where TAR_id in(select tar_id
															 from genitemtarif 
															 where ITE_ID=V_ITE_ID)
											)
							and rownum=1;
						end if;
						V_BLI_MHT:=decode(facture_.caron,'1',1,-1)* (facture_.AREPOR/1000);
						BEGIN
							 INSERT INTO genbilline(BIL_ID,BLI_REVERSEBLI_ID,BLI_NUMBER,BLI_REVERSEBLINUMBER,BLI_NAME,BLI_EXERCICE,ITE_ID,PTA_ID,PSL_RANK,
												    IMP_ID,BLI_VOLUMEBASE,BLI_VOLUMEFACT,BLI_PUHT,TVA_ID,BLI_MHT,BLI_MTTVA,BLI_MTTC,BLI_STARTDT,
												    BLI_ENDDT,VOW_UNIT,BLI_NBUNITES,BLI_DETAIL,BLI_CANCEL,IMC_ID,IMP_ANALYTIQUE_ID,BLI_PERIODEINIT,BLI_PERIODE,
												    BLI_REVERSEDT,BLI_CREDT,BLI_UPDTDT,BLI_UPDTBY,MEU_ID,BLI_NAME_A,BLI_REVERSEBLIDEC_ID,BLI_REVERSEBLINUMBERDEC,BLI_REVERSEDECDT)
											values(V_BIL_ID,null,v,null,V_ite_name,V_anneereel,V_ITE_ID,V_PTA_ID,V_PSL_RANK,
											       null,1,1,V_BLI_MHT,V_TVA_ID,V_BLI_MHT,0,V_BLI_MHT,V_FAC_DATECALCUL,
												   V_FAC_DATECALCUL,V_VOW_UNIT,null,0,0,null,
												   null,null,null,null,null,null,null,null,null,null,null,null);				 
						EXCEPTION WHEN OTHERS THEN
											BEGIN
											INSERT INTO genbilline(BIL_ID,BLI_REVERSEBLI_ID,BLI_NUMBER,BLI_REVERSEBLINUMBER,BLI_NAME,BLI_EXERCICE,ITE_ID,PTA_ID,PSL_RANK,
																   IMP_ID,BLI_VOLUMEBASE,BLI_VOLUMEFACT,BLI_PUHT,TVA_ID,BLI_MHT,BLI_MTTVA,BLI_MTTC,BLI_STARTDT,
																   BLI_ENDDT,VOW_UNIT,BLI_NBUNITES,BLI_DETAIL,BLI_CANCEL,IMC_ID,IMP_ANALYTIQUE_ID,BLI_PERIODEINIT,BLI_PERIODE,
																   BLI_REVERSEDT,BLI_CREDT,BLI_UPDTDT,BLI_UPDTBY,MEU_ID,BLI_NAME_A,BLI_REVERSEBLIDEC_ID,BLI_REVERSEBLINUMBERDEC,BLI_REVERSEDECDT)
														    values(V_BIL_ID,null,v+1,null,V_ite_name,V_anneereel,V_ITE_ID,V_PTA_ID,V_PSL_RANK,
															       null,1,1,V_BLI_MHT,V_TVA_ID,V_BLI_MHT,0,V_BLI_MHT,V_FAC_DATECALCUL,
															       V_FAC_DATECALCUL,V_VOW_UNIT,null,0,0,null,
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
						V_PTA_ID   := null;
						V_PSL_RANK := null;
						V_BLI_MHT  :=null;
						BEGIN
						v_code:='NAROND';
							for x in C_ITEM(v_code) loop
							V_ITE_ID:=x.ite_id;
							V_ite_name:=x.ite_name
							V_VOW_UNIT:=x.VOW_UNIT
							end loop;
						EXCEPTION WHEN NO_DATA_FOUND THEN NULL;
						END;
						BEGIN
						v_tva_taux:= 0;
							for v in C_TVA(v_tva_taux) loop
							   V_TVA_ID:=v.tva_id; 
							end loop;
						EXCEPTION WHEN NO_DATA_FOUND THEN 
						V_TVA_ID := 25;
						END;
						select count(*) 
						into V_nbr 
						from genptaslice 
						where PTA_ID in (select PTA_ID 
											 from genitemperiodtarif 
											 where TAR_id in(select tar_id
															 from genitemtarif 
															 where ITE_ID=V_ITE_ID)
											)
						if V_nbr =1 then
						    select PTA_ID,PSL_RANK  
							into V_PTA_ID,V_PSL_RANK 
							from genptaslice 
							where PTA_ID in (select PTA_ID 
											 from genitemperiodtarif 
											 where TAR_id in(select tar_id
															 from genitemtarif 
															 where ITE_ID=V_ITE_ID)
											)
							and rownum=1;
						end if;
						if V_nbr >1 then
							select PTA_ID,PSL_RANK  
							into V_PTA_ID,V_PSL_RANK 
							from genptaslice 
							where   PTA_ID in(select PTA_ID 
											  from genitemperiodtarif 
											  where TAR_id in(select tar_id
															 from genitemtarif 
															 where ITE_ID=V_ITE_ID)
											)
							and rownum=1;
						end if;
						V_BLI_MHT:=(decode(facture_.caron,'1',-1,1)*(facture_.NAROND/1000));
						BEGIN
							INSERT INTO genbilline(BIL_ID,BLI_REVERSEBLI_ID,BLI_NUMBER,BLI_REVERSEBLINUMBER,BLI_NAME,BLI_EXERCICE,ITE_ID,PTA_ID,PSL_RANK,
												    IMP_ID,BLI_VOLUMEBASE,BLI_VOLUMEFACT,BLI_PUHT,TVA_ID,BLI_MHT,BLI_MTTVA,BLI_MTTC,BLI_STARTDT,
												    BLI_ENDDT,VOW_UNIT,BLI_NBUNITES,BLI_DETAIL,BLI_CANCEL,IMC_ID,IMP_ANALYTIQUE_ID,BLI_PERIODEINIT,BLI_PERIODE,
												    BLI_REVERSEDT,BLI_CREDT,BLI_UPDTDT,BLI_UPDTBY,MEU_ID,BLI_NAME_A,BLI_REVERSEBLIDEC_ID,BLI_REVERSEBLINUMBERDEC,BLI_REVERSEDECDT)
											values(V_BIL_ID,null,v,null,V_ite_name,V_anneereel,V_ITE_ID,V_PTA_ID,V_PSL_RANK,
											       null,1,1,V_BLI_MHT,V_TVA_ID,V_BLI_MHT,0,V_BLI_MHT,V_FAC_DATECALCUL,
												   V_FAC_DATECALCUL,V_VOW_UNIT,null,0,0,null,null,null,null,
												   null,null,null,null,null,null,null,null,null);	
						EXCEPTION WHEN OTHERS THEN
											BEGIN
												INSERT INTO genbilline(BIL_ID,BLI_REVERSEBLI_ID,BLI_NUMBER,BLI_REVERSEBLINUMBER,BLI_NAME,BLI_EXERCICE,ITE_ID,PTA_ID,PSL_RANK,
																	   IMP_ID,BLI_VOLUMEBASE,BLI_VOLUMEFACT,BLI_PUHT,TVA_ID,BLI_MHT,BLI_MTTVA,BLI_MTTC,BLI_STARTDT,
																	   BLI_ENDDT,VOW_UNIT,BLI_NBUNITES,BLI_DETAIL,BLI_CANCEL,IMC_ID,IMP_ANALYTIQUE_ID,BLI_PERIODEINIT,BLI_PERIODE,
																	   BLI_REVERSEDT,BLI_CREDT,BLI_UPDTDT,BLI_UPDTBY,MEU_ID,BLI_NAME_A,BLI_REVERSEBLIDEC_ID,BLI_REVERSEBLINUMBERDEC,BLI_REVERSEDECDT)
																values(V_BIL_ID,null,v+1,null,V_ite_name,V_anneereel,V_ITE_ID,V_PTA_ID,V_PSL_RANK,
																	   null,1,1,V_BLI_MHT,V_TVA_ID,V_BLI_MHT,0,V_BLI_MHT,V_FAC_DATECALCUL,
																	   V_FAC_DATECALCUL,V_VOW_UNIT,null,0,0,null,null,null,null,
																	   null,null,null,null,null,null,null,null,null);
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
		V_date      :=null;
		V_periode    :=null;
		v_anneereel  :=null;
		v_nbr		 :=null;
		v_ORG_ID     :=null;
		v_PAR_ID 	 :=null;
		v_SAG_ID     :=null;
		V_ADR_ID     :=null;
		v_ABN_DT_DEB :=null;
		for x in branch_(lpad(facture_.DIST,2,'0'),lpad(trim(facture_.TOU),3,'0'),lpad(trim(facture_.ORD), 3, '0'))	loop	
			    
			select last_day(to_date('01'||lpad(facture_.refc01,2,'0')||facture_.refc02,'ddmmyy')) 
			into V_date
			from dual;
			V_periode     := trim(facture_.refc01);
			v_anneereel   := to_char(V_date,'yyyy');
			
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
				
				BEGIN
					if lpad(trim(facture_.dist),2,'0')='57' then
						select g.org_id	
						into V_ORG_ID 
						from GENORGANIZATION g 
						where upper(g.org_code)='22';
					elsif lpad(trim(facture_.dist),2,'0')='58' then
						select g.org_id	
						into V_ORG_ID 
						from GENORGANIZATION g 
						where upper(g.org_code)='32';	
					elsif lpad(trim(facture_.dist),2,'0')='60' then
						select g.org_id	
						into V_ORG_ID 
						from GENORGANIZATION g 
						where upper(g.org_code)='36';			
					elsif lpad(trim(facture_.dist),2,'0')='61' then
						select g.org_id	
						into V_ORG_ID 
						from GENORGANIZATION g 
						where upper(g.org_code)='03';
					elsif lpad(trim(facture_.dist),2,'0')='63' then
						select g.org_id	
						into V_ORG_ID 
						from GENORGANIZATION g 
						where upper(g.org_code)='15';
					end if ;
				EXCEPTION WHEN OTHERS THEN 
					select g.org_id	
					into V_ORG_ID 
					from GENORGANIZATION g 
					where upper(g.org_code)=lpad(trim(facture_.dist),2,'0');
				END;
				
				select cag.par_id  
				into v_PAR_ID
				from AGRCUSTOMERAGR cag
				where cag.cag_id in (select sag.cag_id
									 from TECSERVICEPOINT spt,AGRSERVICEAGR sag
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
					V_FAC_DATECALCUL := V_date;
					V_FAC_DATELIM    := V_date;
				END;
				V_REF_ABN   := lpad(trim(facture_.DIST),2,'0')||lpad(to_char(facture_.pol),5,'0')||lpad(trim(facture_.tou),3,'0')||lpad(trim(facture_.ORD),3,'0');
                V_TRAIN_FACT:='ANNEE:'||trim(v_anneereel)||' MOIS:'||trim(V_periode);
				V_COMPTEAUX :='IMP_MIG'			   
				V_TVA       :=(facture_.tva_ff+facture_.tva_capit+facture_.tva_pfin+facture_.tvacons+facture_.tva_preav+ facture_.tvaferm+facture_.tvadeplac+facture_.tvadepose_dem+facture_.tvadepose_def)/1000;
				V_TOTHTE    :=(facture_.monttrim-(V_TVA))/1000;
				V_TOTHTA    :=0;
				V_TOTTVAA   :=0;
				V_SOLDE     := facture_.monttrim/1000;
			    
				If (V_anneereel is not null and V_periode is not null and V_TRAIN_FACT is not null) then			
					Begin
						select t.run_id
						into v_run_id
						from genrun t 
						where t.run_exercice=V_anneereel
						and run_number      =V_periode;
					EXCEPTION WHEN OTHERS THEN 			  
						select seq_genrun.nextval into v_run_id from dual;				
							insert into genrun (run_id,run_exercice,run_number,org_id,run_startdt,run_comment,RUN_NAME,RUN_DTCALC,RUN_ENDDT)
										values (v_run_id,V_anneereel,V_periode,V_org_id,V_FAC_DATECALCUL,'Role migré','Role '||V_TRAIN_FACT,V_FAC_DATECALCUL,V_FAC_DATECALCUL);
					end;    
				end if ; 
				--------------------------------------------------------Traitement Det
				 
			    select seq_gendebt.nextval into V_Deb_ID from dual;
				   
				If (V_TOTHTE+V_TVA+V_TOTHTA+V_TOTTVAA) > 0 then 
					V_DEB_AMOUNTINIT   := V_TOTHTE+V_TVA+V_TOTHTA+V_TOTTVAA;
					V_deb_amount_cash  := V_TOTHTE+V_TVA+V_TOTHTA+V_TOTTVAA;
					V_VOW_DEBTYPE      := pk_genvocword.getidbycode('VOW_DEBTYPE','FA',null);
				else
					V_deb_amount_cash  := -(V_TOTHTE+V_TVA+V_TOTHTA+V_TOTTVAA) ;
					V_DEB_AMOUNTINIT   := 0;
					V_VOW_DEBTYPE      := pk_genvocword.getidbycode('VOW_DEBTYPE','AV',null);
				end if;
				V_DEB_AMOUNTREMAIN :=  V_SOLDE ;
				V_DEB_COMMENT      :=  V_REF_ABN ;
				V_VOW_SETTLEMODE   :=  pk_genvocword.getidbycode('VOW_SETTLEMODE',4,null) ;
				V_DEB_NORECOVERY   := 0;
----------------------------------------------------------Traitement GENACCOUNT ,GENIMP
				BEGIN 
					select t.imp_id
					into V_IMP_ID
					from genimp t 
					where t.imp_code=V_COMPTEAUX;
				EXCEPTION WHEN OTHERS THEN 
					V_VOW_BUDGTP        :=  pk_genvocword.getidbycode('VOW_BUDGTP','EA',null);
					select seq_genimp.nextval into V_IMP_ID from dual;
					insert into genimp (imp_id,imp_code,imp_name,vow_budgtp,org_id)
								 values(V_IMP_ID,V_COMPTEAUX,V_COMPTEAUX,V_VOW_BUDGTP,V_org_id);
				END;
				 
				BEGIN 
					select t.aco_id 
					into V_ACO_ID
					from genaccount t
					where t.par_id=V_PAR_ID;
                EXCEPTION WHEN OTHERS THEN 
					V_VOW_ACOTP     :=  pk_genvocword.getidbycode('VOW_ACOTP','1',null);
					select seq_genaccount.nextval into V_ACO_ID from dual;
					insert into genaccount(aco_id,par_id,imp_id,VOW_ACOTP,rec_id)
									values(V_ACO_ID,V_PAR_ID,V_imp_id,V_VOW_ACOTP,null);
				END;				
				BEGIN	
					select t.sco_id
					into V_SCO_ID
					from agrsagaco t
					where t.aco_id=V_ACO_ID;
				EXCEPTION WHEN OTHERS THEN
					select seq_agrsagaco.nextval  into V_SCO_ID  from dual;
					insert into agrsagaco(sco_id,sag_id,aco_id,sco_startdt)
								   values(V_SCO_ID,V_SAG_ID,V_ACO_ID,V_ABN_DT_DEB);
				END;
				Insert into gendebt(deb_id,deb_refe,org_id,par_id,adr_id,deb_date,deb_duedt,deb_printdt,
									deb_amountinit,deb_amountremain,bap_id,VOW_SETTLEMODE,aco_id,deb_norecovery,deb_credt,
									deb_updtby,deb_updtdt,deb_comment,deb_amount_cash,sag_id,VOW_DEBTYPE,deb_prel)
						    values(V_Deb_ID,V_ID_FACTURE,V_ORG_ID,V_PAR_ID,V_ADR_ID,V_FAC_DATECALCUL,V_FAC_DATELIM,V_FAC_DATECALCUL,
								   V_DEB_AMOUNTINIT,V_DEB_AMOUNTREMAIN,null,V_VOW_SETTLEMODE,V_ACO_ID,V_DEB_NORECOVERY,sysdate, 
								   null,null,V_DEB_COMMENT,nvl(V_deb_amount_cash,0),V_SAG_ID,V_VOW_DEBTYPE,1); 
							commit;
--------------------------------------------------------Traitement agrbill
				select seq_agrbill.nextval into V_BIL_ID from dual; 
				V_VOW_AGRBILLTYPE   :=  pk_genvocword.getidbycode('VOW_AGRBILLTYPE','FC',null) ;
				V_VOW_MODEFACT      :=  pk_genvocword.getidbycode('VOW_MODEFACT',4,null);--------NB:(4 ou MIG) a verifier
				Insert into agrbill (BIL_ID,SAG_ID,VOW_AGRBILLTYPE,VOW_MODEFACT)
						     values (V_BIL_ID,V_SAG_ID,V_VOW_AGRBILLTYPE,V_VOW_MODEFACT);	
			    commit;
--------------------------------------------------------Traitement genbill
				V_BIL_AMOUNTHT      :=  V_TOTHTE +V_TOTHTA ;
				V_BIL_AMOUNTTVA     :=  V_TVA+V_TOTTVAA ;
				V_BIL_AMOUNTTTC     :=  V_TOTHTE+V_TVA+V_TOTHTA+V_TOTTVAA ;
				V_BIL_STATUS        :=  1;  
				Insert into genbill(BIL_ID,BIL_CODE,BIL_CALCDT,BIL_AMOUNTHT,BIL_AMOUNTTVA,BIL_AMOUNTTTC,
				                    DEB_ID,PAR_ID,BIL_STATUS,BIL_AMOUNTTTCDEC,BIL_DEBTDT,RUN_ID)
							 values(V_BIL_ID,V_ID_FACTURE,V_FAC_DATECALCUL,V_BIL_AMOUNTHT,V_BIL_AMOUNTTVA,V_BIL_AMOUNTTTC,
									V_Deb_ID,V_PAR_ID,V_BIL_STATUS,V_AMOUNTTTCDEC,V_FAC_DATECALCUL,v_run_id); 
				commit;
		end if;						
 v := 0;
-------------------------------------------------------------------------------------------
-----------------------------------CONSOMMATION SONEDE 1ERE TRANCHE------------------------
-------------------------------------------------------------------------------------------		
			if to_number(facture_.montt1) <> 0 then
				v := v+1;
					V_PTA_ID   := null;
					V_PSL_RANK := null;
					BEGIN
					v_code:='CSM_STD';
						for x in C_ITEM(v_code) loop
						V_ITE_ID:=x.ite_id;
						V_ite_name:=x.ite_name
						V_VOW_UNIT:=x.VOW_UNIT
						end loop;
					EXCEPTION WHEN NO_DATA_FOUND THEN NULL;
					END;
					BEGIN
					v_tva_taux:= 18;
						for v in C_TVA(v_tva_taux) loop
						   V_TVA_ID:=v.tva_id; 
						end loop;
					EXCEPTION WHEN NO_DATA_FOUND THEN 
					V_TVA_ID := 25;
					END;
					select count(*) 
					into V_NBR 
					from genptaslice 
					where PTA_ID in (select PTA_ID 
									 from genitemperiodtarif 
									 where TAR_id in(select tar_id 
													 from genitemtarif 
													 where ITE_ID=V_ITE_ID )
									);
					if V_NBR=1 then
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
                    if V_NBR>1 then
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
					BEGIN
						INSERT INTO genbilline(BIL_ID,BLI_REVERSEBLI_ID,BLI_NUMBER,BLI_REVERSEBLINUMBER,BLI_NAME,BLI_EXERCICE,ITE_ID,PTA_ID,PSL_RANK,
											   IMP_ID,BLI_VOLUMEBASE,BLI_VOLUMEFACT,BLI_PUHT,TVA_ID,BLI_MHT,BLI_MTTVA,BLI_MTTC,BLI_STARTDT,
											   BLI_ENDDT,VOW_UNIT,BLI_NBUNITES,BLI_DETAIL,BLI_CANCEL,IMC_ID,IMP_ANALYTIQUE_ID,BLI_PERIODEINIT,BLI_PERIODE,
											   BLI_REVERSEDT,BLI_CREDT,BLI_UPDTDT,BLI_UPDTBY,MEU_ID,BLI_NAME_A,BLI_REVERSEBLIDEC_ID,BLI_REVERSEBLINUMBERDEC,BLI_REVERSEDECDT)
										Values(V_BIL_ID,null,v,null,V_ite_name,v_anneereel,V_ITE_ID,V_PTA_ID,V_PSL_RANK,
										       null,facture_.const1,facture_.const1,facture_.tauxt1/1000,V_TVA_ID,
											   facture_.montt1/1000,facture_.tvacons/1000,facture_.montt1/1000+(facture_.tvacons/1000),V_FAC_DATECALCUL,
											   V_FAC_DATECALCUL,V_VOW_UNIT,null,0,0,null,null,null,null,
											   null,null,null,null,null,null,null,null,null);
					EXCEPTION WHEN OTHERS THEN
										  BEGIN
										   INSERT INTO genbilline(BIL_ID,BLI_REVERSEBLI_ID,BLI_NUMBER,BLI_REVERSEBLINUMBER,BLI_NAME,BLI_EXERCICE,ITE_ID,PTA_ID,PSL_RANK,
																  IMP_ID,BLI_VOLUMEBASE,BLI_VOLUMEFACT,BLI_PUHT,TVA_ID,BLI_MHT,BLI_MTTVA,BLI_MTTC,BLI_STARTDT,
																  BLI_ENDDT,VOW_UNIT,BLI_NBUNITES,BLI_DETAIL,BLI_CANCEL,IMC_ID,IMP_ANALYTIQUE_ID,BLI_PERIODEINIT,BLI_PERIODE,
																  BLI_REVERSEDT,BLI_CREDT,BLI_UPDTDT,BLI_UPDTBY,MEU_ID,BLI_NAME_A,BLI_REVERSEBLIDEC_ID,BLI_REVERSEBLINUMBERDEC,BLI_REVERSEDECDT)
															Values(V_BIL_ID,null,v+1,null,V_ite_name,v_anneereel,V_ITE_ID,V_PTA_ID,V_PSL_RANK,
																   null,facture_.const1,facture_.const1,facture_.tauxt1/1000,V_TVA_ID,
																   facture_.montt1/1000,facture_.tvacons/1000,facture_.montt1/1000+(facture_.tvacons/1000),V_FAC_DATECALCUL,
																   V_FAC_DATECALCUL,V_VOW_UNIT,null,0,0,null,null,null,null,
																   null,null,null,null,null,null,null,null,null);
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
					BEGIN
						v_code:='CSM_STD';
							for x in C_ITEM(v_code) loop
							V_ITE_ID:=x.ite_id;
							V_ite_name:=x.ite_name
							V_VOW_UNIT:=x.VOW_UNIT
							end loop;
					EXCEPTION WHEN NO_DATA_FOUND THEN NULL;
					END;
					BEGIN
					v_tva_taux:= 18;
						for v in C_TVA(v_tva_taux) loop
						   V_TVA_ID:=v.tva_id; 
						end loop;
					EXCEPTION WHEN NO_DATA_FOUND THEN 
					V_TVA_ID := 25;
					END;
					select count(*) 
					into V_nbr 
					from genptaslice 
					where PTA_ID in (select PTA_ID 	from genitemperiodtarif 
									 where TAR_id in (select tar_id 
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
						where PTA_ID in (select PTA_ID 
										   from genitemperiodtarif
							               where TAR_id in (select tar_id 
															from genitemtarif 
															where ITE_ID=V_ITE_ID) 
						                )
						and rownum=1;
					end if;
                    BEGIN
						  INSERT INTO genbilline(BIL_ID,BLI_REVERSEBLI_ID,BLI_NUMBER,BLI_REVERSEBLINUMBER,BLI_NAME,BLI_EXERCICE,ITE_ID,PTA_ID,PSL_RANK,
												 IMP_ID,BLI_VOLUMEBASE,BLI_VOLUMEFACT,BLI_PUHT,TVA_ID,BLI_MHT,BLI_MTTVA,BLI_MTTC,BLI_STARTDT,
												 BLI_ENDDT,VOW_UNIT,BLI_NBUNITES,BLI_DETAIL,BLI_CANCEL,IMC_ID,IMP_ANALYTIQUE_ID,BLI_PERIODEINIT,BLI_PERIODE,
												 BLI_REVERSEDT,BLI_CREDT,BLI_UPDTDT,BLI_UPDTBY,MEU_ID,BLI_NAME_A,BLI_REVERSEBLIDEC_ID,BLI_REVERSEBLINUMBERDEC,BLI_REVERSEDECDT)
										  VALUES(V_BIL_ID,null,v,null,V_ite_name,v_anneereel,V_ITE_ID,V_PTA_ID,V_PSL_RANK,
										         null,facture_.const2,facture_.const2,facture_.tauxt2/1000,V_TVA_ID,
											     facture_.montt2/1000,facture_.tvacons/1000,facture_.montt2/1000+(facture_.tvacons/1000),V_FAC_DATECALCUL,
											     V_FAC_DATECALCUL,V_VOW_UNIT,null,0,0,null,null,null,null,
											     null,null,null,null,null,null,null,null,null);
					EXCEPTION WHEN OTHERS THEN
										BEGIN
											INSERT INTO genbilline(BIL_ID,BLI_REVERSEBLI_ID,BLI_NUMBER,BLI_REVERSEBLINUMBER,BLI_NAME,BLI_EXERCICE,ITE_ID,PTA_ID,PSL_RANK,
																   IMP_ID,BLI_VOLUMEBASE,BLI_VOLUMEFACT,BLI_PUHT,TVA_ID,BLI_MHT,BLI_MTTVA,BLI_MTTC,BLI_STARTDT,
																   BLI_ENDDT,VOW_UNIT,BLI_NBUNITES,BLI_DETAIL,BLI_CANCEL,IMC_ID,IMP_ANALYTIQUE_ID,BLI_PERIODEINIT,BLI_PERIODE,
																   BLI_REVERSEDT,BLI_CREDT,BLI_UPDTDT,BLI_UPDTBY,MEU_ID,BLI_NAME_A,BLI_REVERSEBLIDEC_ID,BLI_REVERSEBLINUMBERDEC,BLI_REVERSEDECDT)
															VALUES(V_BIL_ID,null,v+1,null,V_ite_name,v_anneereel,V_ITE_ID,V_PTA_ID,V_PSL_RANK,
																   null,facture_.const2,facture_.const2,facture_.tauxt2/1000,V_TVA_ID,
																   facture_.montt2/1000,facture_.tvacons/1000,facture_.montt2/1000+(facture_.tvacons/1000),V_FAC_DATECALCUL,
																   V_FAC_DATECALCUL,V_VOW_UNIT,null,0,0,null,null,null,null,
																   null,null,null,null,null,null,null,null,null);
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
					BEGIN
					v_code:='CSM_STD';
						for x in C_ITEM(v_code) loop
						V_ITE_ID:=x.ite_id;
						V_ite_name:=x.ite_name
						V_VOW_UNIT:=x.VOW_UNIT
						end loop;
					EXCEPTION WHEN NO_DATA_FOUND THEN NULL;
					END;
					BEGIN
					v_tva_taux:= 18;
						for v in C_TVA(v_tva_taux) loop
						   V_TVA_ID:=v.tva_id; 
						end loop;
					EXCEPTION WHEN NO_DATA_FOUND THEN 
					V_TVA_ID := 25;
					END;
					select count(*) 
					into V_NBR 
					from genptaslice 
					where PTA_ID in (select PTA_ID 	from genitemperiodtarif 
									 where TAR_id in (select tar_id 
													  from genitemtarif 
													  where ITE_ID=V_ITE_ID)
									);
					if V_NBR=1 then
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
					if V_NBR>1 then
						select PTA_ID,PSL_RANK  
						into V_PTA_ID,V_PSL_RANK 
						from genptaslice 
						where PTA_ID in (select PTA_ID 
											 from genitemperiodtarif 
											 where TAR_id in(select tar_id
															 from genitemtarif 
															 where ITE_ID=V_ITE_ID)
											)
						and rownum=1;
					end if;						
                    BEGIN
						INSERT INTO genbilline(BIL_ID,BLI_REVERSEBLI_ID,BLI_NUMBER,BLI_REVERSEBLINUMBER,BLI_NAME,BLI_EXERCICE,ITE_ID,PTA_ID,PSL_RANK,IMP_ID,BLI_VOLUMEBASE,BLI_VOLUMEFACT,
											   BLI_PUHT,TVA_ID,BLI_MHT,BLI_MTTVA,BLI_MTTC,BLI_STARTDT,BLI_ENDDT,VOW_UNIT,BLI_NBUNITES,BLI_DETAIL,BLI_CANCEL,IMC_ID,IMP_ANALYTIQUE_ID,
											   BLI_PERIODEINIT,BLI_PERIODE,BLI_REVERSEDT,BLI_CREDT,BLI_UPDTDT,BLI_UPDTBY,MEU_ID,BLI_NAME_A,BLI_REVERSEBLIDEC_ID,BLI_REVERSEBLINUMBERDEC,BLI_REVERSEDECDT)
										values(V_BIL_ID,null,v,null,V_ite_name,v_anneereel,V_ITE_ID,V_PTA_ID,V_PSL_RANK,null,facture_.const3,facture_.const3,facture_.tauxt3/1000,V_TVA_ID,
											  facture_.montt3/1000,facture_.tvacons/1000,facture_.montt3/1000+(facture_.tvacons/1000),V_FAC_DATECALCUL,V_FAC_DATECALCUL,V_VOW_UNIT,null,0,0,null,
											  null,null,null,null,null,null,null,null,null,null,null,null);
					EXCEPTION WHEN OTHERS THEN
										BEGIN
											INSERT INTO genbilline(BIL_ID,BLI_REVERSEBLI_ID,BLI_NUMBER,BLI_REVERSEBLINUMBER,BLI_NAME,BLI_EXERCICE,ITE_ID,PTA_ID,PSL_RANK,IMP_ID,BLI_VOLUMEBASE,BLI_VOLUMEFACT,
																   BLI_PUHT,TVA_ID,BLI_MHT,BLI_MTTVA,BLI_MTTC,BLI_STARTDT,BLI_ENDDT,VOW_UNIT,BLI_NBUNITES,BLI_DETAIL,BLI_CANCEL,IMC_ID,IMP_ANALYTIQUE_ID,
																   BLI_PERIODEINIT,BLI_PERIODE,BLI_REVERSEDT,BLI_CREDT,BLI_UPDTDT,BLI_UPDTBY,MEU_ID,BLI_NAME_A,BLI_REVERSEBLIDEC_ID,BLI_REVERSEBLINUMBERDEC,BLI_REVERSEDECDT)
															values(V_BIL_ID,null,v+1,null,V_ite_name,v_anneereel,V_ITE_ID,V_PTA_ID,V_PSL_RANK,null,facture_.const3,facture_.const3,facture_.tauxt3/1000,V_TVA_ID,
																  facture_.montt3/1000,facture_.tvacons/1000,facture_.montt3/1000+(facture_.tvacons/1000),V_FAC_DATECALCUL,V_FAC_DATECALCUL,V_VOW_UNIT,null,0,0,null,
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
					BEGIN
					v_code:='VAR_ONAS_1';
						for x in C_ITEM(v_code) loop
						V_ITE_ID:=x.ite_id;
						V_ite_name:=x.ite_name
						V_VOW_UNIT:=x.VOW_UNIT
						end loop;
					EXCEPTION WHEN NO_DATA_FOUND THEN NULL;
					END;
					BEGIN
					v_tva_taux= 0;
						for v in C_TVA(v_tva_taux) loop
						   V_TVA_ID:=v.tva_id; 
						end loop;
					EXCEPTION WHEN NO_DATA_FOUND THEN 
					V_TVA_ID := 25;
					END;
					select count(*) 
					into V_NBR 
					from genptaslice 
					where PTA_ID in (select PTA_ID 
											 from genitemperiodtarif 
											 where TAR_id in(select tar_id
															 from genitemtarif 
															 where ITE_ID=V_ITE_ID)
									);
					if V_NBR=1 then
						select PTA_ID,PSL_RANK  
						into V_PTA_ID,V_PSL_RANK 
						from genptaslice 
						where PTA_ID in (select PTA_ID 
										 from genitemperiodtarif 
										 where TAR_id in (select tar_id from genitemtarif where ITE_ID=V_ITE_ID)
										)
						and rownum=1;
					end if;
					if V_NBR>1 then
						select PTA_ID,PSL_RANK  
						into V_PTA_ID,V_PSL_RANK 
						from genptaslice 
						where PTA_ID in (select PTA_ID 
										 from genitemperiodtarif
										 where TAR_id in (select tar_id from genitemtarif where ITE_ID=V_ITE_ID) 
										)
						and rownum=1;
					end if;	

					BEGIN
						INSERT INTO genbilline(BIL_ID,BLI_REVERSEBLI_ID,BLI_NUMBER,BLI_REVERSEBLINUMBER,BLI_NAME,BLI_EXERCICE,ITE_ID,PTA_ID,PSL_RANK,IMP_ID,BLI_VOLUMEBASE,BLI_VOLUMEFACT,
											   BLI_PUHT,TVA_ID,BLI_MHT,BLI_MTTVA,BLI_MTTC,BLI_STARTDT,BLI_ENDDT,VOW_UNIT,BLI_NBUNITES,BLI_DETAIL,BLI_CANCEL,IMC_ID,IMP_ANALYTIQUE_ID,
											   BLI_PERIODEINIT,BLI_PERIODE,BLI_REVERSEDT,BLI_CREDT,BLI_UPDTDT,BLI_UPDTBY,MEU_ID,BLI_NAME_A,BLI_REVERSEBLIDEC_ID,BLI_REVERSEBLINUMBERDEC,BLI_REVERSEDECDT)
									   values(V_BIL_ID,null,v,null,V_ite_name,v_anneereel,V_ITE_ID,V_PTA_ID,V_PSL_RANK,null,facture_.volon1,facture_.volon1,facture_.tauon1/1000,V_TVA_ID,
											  facture_.mon1/1000,0,facture_.mon1/1000,V_FAC_DATECALCUL,V_FAC_DATECALCUL,V_VOW_UNIT,null,0,0,null,
											  null,null,null,null,null,null,null,null,null,null,null,null);
					EXCEPTION WHEN OTHERS THEN
										BEGIN
											INSERT INTO genbilline(BIL_ID,BLI_REVERSEBLI_ID,BLI_NUMBER,BLI_REVERSEBLINUMBER,BLI_NAME,BLI_EXERCICE,ITE_ID,PTA_ID,PSL_RANK,IMP_ID,BLI_VOLUMEBASE,BLI_VOLUMEFACT,
																   BLI_PUHT,TVA_ID,BLI_MHT,BLI_MTTVA,BLI_MTTC,BLI_STARTDT,BLI_ENDDT,VOW_UNIT,BLI_NBUNITES,BLI_DETAIL,BLI_CANCEL,IMC_ID,IMP_ANALYTIQUE_ID,
																   BLI_PERIODEINIT,BLI_PERIODE,BLI_REVERSEDT,BLI_CREDT,BLI_UPDTDT,BLI_UPDTBY,MEU_ID,BLI_NAME_A,BLI_REVERSEBLIDEC_ID,BLI_REVERSEBLINUMBERDEC,BLI_REVERSEDECDT)
															values(V_BIL_ID,null,v+1,null,V_ite_name,v_anneereel,V_ITE_ID,V_PTA_ID,V_PSL_RANK,null,facture_.volon1,facture_.volon1,facture_.tauon1/1000,V_TVA_ID,
																   facture_.mon1/1000,0,facture_.mon1/1000,V_FAC_DATECALCUL,V_FAC_DATECALCUL,V_VOW_UNIT,null,0,0,null,
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
					BEGIN
					v_code:='VAR_ONAS_1';
						for x in C_ITEM(v_code) loop
						V_ITE_ID:=x.ite_id;
						V_ite_name:=x.ite_name
						V_VOW_UNIT:=x.VOW_UNIT
						end loop;
					EXCEPTION WHEN NO_DATA_FOUND THEN NULL;
					END;
					BEGIN
					V_TVA_TAUX= 0;
						for v in C_TVA(v_tva_taux) loop
						   V_TVA_ID:=v.tva_id; 
						end loop;
					EXCEPTION WHEN NO_DATA_FOUND THEN 
					V_TVA_ID := 25;
					END;
					select count(*) 
					into V_NBR 
					from genptaslice 
					where PTA_ID in (select PTA_ID 
									 from genitemperiodtarif 
									 where TAR_id in(select tar_id
													 from genitemtarif 
													 where ITE_ID=V_ITE_ID)
									);
					if V_NBR=1 then
					   select PTA_ID,PSL_RANK  
						into V_PTA_ID,V_PSL_RANK 
						from genptaslice 
						where PTA_ID in (select PTA_ID 
										 from genitemperiodtarif 
										 where TAR_id in(select tar_id
														 from genitemtarif 
														 where ITE_ID=V_ITE_ID)
										)
						and rownum=1;
					end if;
					if V_nbr>1 then
						select PTA_ID,PSL_RANK  
						into V_PTA_ID,V_PSL_RANK 
						from genptaslice 
						where PTA_ID in (select PTA_ID 
											 from genitemperiodtarif 
											 where TAR_id in(select tar_id
															 from genitemtarif 
															 where ITE_ID=V_ITE_ID)
								        )
						and rownum=1;
					end if;	

					BEGIN
						INSERT INTO genbilline(BIL_ID,BLI_REVERSEBLI_ID,BLI_NUMBER,BLI_REVERSEBLINUMBER,BLI_NAME,BLI_EXERCICE,ITE_ID,PTA_ID,PSL_RANK,IMP_ID,BLI_VOLUMEBASE,BLI_VOLUMEFACT,
											   BLI_PUHT,TVA_ID,BLI_MHT,BLI_MTTVA,BLI_MTTC,BLI_STARTDT,BLI_ENDDT,VOW_UNIT,BLI_NBUNITES,BLI_DETAIL,BLI_CANCEL,IMC_ID,IMP_ANALYTIQUE_ID,
											   BLI_PERIODEINIT,BLI_PERIODE,BLI_REVERSEDT,BLI_CREDT,BLI_UPDTDT,BLI_UPDTBY,MEU_ID,BLI_NAME_A,BLI_REVERSEBLIDEC_ID,BLI_REVERSEBLINUMBERDEC,BLI_REVERSEDECDT)
										VALUES(V_BIL_ID,null,v,null,V_ite_name,v_anneereel,V_ITE_ID,V_PTA_ID,V_PSL_RANK,null,facture_.volon2,facture_.volon2,facture_.tauon2/1000,V_TVA_ID,
											   facture_.mon2/1000,0,facture_.mon2/1000,V_FAC_DATECALCUL,V_FAC_DATECALCUL,V_VOW_UNIT,null,0,0,null,
											   null,null,null,null,null,null,null,null,null,null,null,null);
					EXCEPTION WHEN OTHERS THEN
										BEGIN
											INSERT INTO genbilline(BIL_ID,BLI_REVERSEBLI_ID,BLI_NUMBER,BLI_REVERSEBLINUMBER,BLI_NAME,BLI_EXERCICE,ITE_ID,PTA_ID,PSL_RANK,IMP_ID,BLI_VOLUMEBASE,BLI_VOLUMEFACT,
																   BLI_PUHT,TVA_ID,BLI_MHT,BLI_MTTVA,BLI_MTTC,BLI_STARTDT,BLI_ENDDT,VOW_UNIT,BLI_NBUNITES,BLI_DETAIL,BLI_CANCEL,IMC_ID,IMP_ANALYTIQUE_ID,
																   BLI_PERIODEINIT,BLI_PERIODE,BLI_REVERSEDT,BLI_CREDT,BLI_UPDTDT,BLI_UPDTBY,MEU_ID,BLI_NAME_A,BLI_REVERSEBLIDEC_ID,BLI_REVERSEBLINUMBERDEC,BLI_REVERSEDECDT)
															VALUES(V_BIL_ID,null,v+1,null,V_ite_name,v_anneereel,V_ITE_ID,V_PTA_ID,V_PSL_RANK,null,facture_.volon2,facture_.volon2,facture_.tauon2/1000,V_TVA_ID,
																   facture_.mon2/1000,0,facture_.mon2/1000,V_FAC_DATECALCUL,V_FAC_DATECALCUL,V_VOW_UNIT,null,0,0,null,
																   null,null,null,null,null,null,null,null,null,null,null,null);
										EXCEPTION WHEN OTHERS THEN NULL;
										END;
					END;
					commit;
			end if;
-------------------------------------------------------------------------------------------
----------------------------------REDEVANCE ONAS 3EME TRANCHE------------------------------
-------------------------------------------------------------------------------------------		
			if to_number(facture_.mon3) <> 0 then
				v := v+1;
					V_PTA_ID := null;
					V_PSL_RANK := null;
					BEGIN
					v_code:='VAR_ONAS_1';
						FOR x in C_ITEM(v_code) LOOP
						V_ITE_ID:=x.ite_id;
						V_ite_name:=x.ite_name
						V_VOW_UNIT:=x.VOW_UNIT
						END LOOP;
					EXCEPTION WHEN NO_DATA_FOUND THEN NULL;
					END;
					BEGIN
					v_tva_taux= 0;
						FOR v in C_TVA(v_tva_taux) LOOP
						   V_TVA_ID:=v.tva_id; 
						END LOOP;
					EXCEPTION WHEN NO_DATA_FOUND THEN 
					V_TVA_ID := 25;
					END;
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
						where PTA_ID in (select PTA_ID 
										 from genitemperiodtarif
										 where TAR_id in (select tar_id from genitemtarif where ITE_ID=V_ITE_ID) 
										)
						and rownum=1;
					end if;	
					BEGIN
						insert into genbilline(BIL_ID,BLI_REVERSEBLI_ID,BLI_NUMBER,BLI_REVERSEBLINUMBER,BLI_NAME,BLI_EXERCICE,ITE_ID,PTA_ID,PSL_RANK,IMP_ID,BLI_VOLUMEBASE,BLI_VOLUMEFACT,
											   BLI_PUHT,TVA_ID,BLI_MHT,BLI_MTTVA,BLI_MTTC,BLI_STARTDT,BLI_ENDDT,VOW_UNIT,BLI_NBUNITES,BLI_DETAIL,BLI_CANCEL,IMC_ID,IMP_ANALYTIQUE_ID,
											   BLI_PERIODEINIT,BLI_PERIODE,BLI_REVERSEDT,BLI_CREDT,BLI_UPDTDT,BLI_UPDTBY,MEU_ID,BLI_NAME_A,BLI_REVERSEBLIDEC_ID,BLI_REVERSEBLINUMBERDEC,BLI_REVERSEDECDT)
										values(V_BIL_ID,null,v,null,V_ite_name,v_anneereel,V_ITE_ID,V_PTA_ID,V_PSL_RANK,null,facture_.volon3,facture_.volon3,facture_.tauon3/1000,V_TVA_ID,
											   facture_.mon3/1000,0,facture_.mon3/1000,V_FAC_DATECALCUL,V_FAC_DATECALCUL,V_VOW_UNIT,null,0,0,null,
											   null,null,null,null,null,null,null,null,null,null,null,null);
					EXCEPTION WHEN OTHERS THEN
										BEGIN
											insert into genbilline(BIL_ID,BLI_REVERSEBLI_ID,BLI_NUMBER,BLI_REVERSEBLINUMBER,BLI_NAME,BLI_EXERCICE,ITE_ID,PTA_ID,PSL_RANK,IMP_ID,BLI_VOLUMEBASE,BLI_VOLUMEFACT,
																   BLI_PUHT,TVA_ID,BLI_MHT,BLI_MTTVA,BLI_MTTC,BLI_STARTDT,BLI_ENDDT,VOW_UNIT,BLI_NBUNITES,BLI_DETAIL,BLI_CANCEL,IMC_ID,IMP_ANALYTIQUE_ID,
																   BLI_PERIODEINIT,BLI_PERIODE,BLI_REVERSEDT,BLI_CREDT,BLI_UPDTDT,BLI_UPDTBY,MEU_ID,BLI_NAME_A,BLI_REVERSEBLIDEC_ID,BLI_REVERSEBLINUMBERDEC,BLI_REVERSEDECDT)
															values(V_BIL_ID,null,v+1,null,V_ite_name,v_anneereel,V_ITE_ID,V_PTA_ID,V_PSL_RANK,null,facture_.volon3,facture_.volon3,facture_.tauon3/1000,V_TVA_ID,
																   facture_.mon3/1000,0,facture_.mon3/1000,V_FAC_DATECALCUL,V_FAC_DATECALCUL,V_VOW_UNIT,null,0,0,null,
																   null,null,null,null,null,null,null,null,null,null,null,null);
										EXCEPTION WHEN OTHERS THEN NULL;
										END;
					END;
					commit;
			end if;
-------------------------------------------------------------------------------------------
-----------------------------------FRAIS FIXE ONAS-----------------------------------------
-------------------------------------------------------------------------------------------		
			if to_number(facture_.fixonas) <> 0 then
				v := v+1;
					V_PTA_ID := null;
					V_PSL_RANK := null;
					BEGIN
					v_code:='FIXE_ONAS_1';
						for x in C_ITEM(v_code) loop
						V_ITE_ID:=x.ite_id;
						V_ite_name:=x.ite_name
						V_VOW_UNIT:=x.VOW_UNIT
						end loop;
					EXCEPTION WHEN NO_DATA_FOUND THEN NULL;
					END;
					BEGIN
					v_tva_taux= 0;
						for v in C_TVA(v_tva_taux) loop
						   V_TVA_ID:=v.tva_id; 
						end loop;
					EXCEPTION WHEN NO_DATA_FOUND THEN 
					V_TVA_ID := 25;
					END;
					select count(*) 
					into V_nbr 
					from genptaslice 
					where PTA_ID in (select PTA_ID 
											 from genitemperiodtarif 
											 where TAR_id in(select tar_id
															 from genitemtarif 
															 where ITE_ID=V_ITE_ID)
											);
					if V_nbr=1 then
						select PTA_ID,PSL_RANK  
						into V_PTA_ID,V_PSL_RANK 
						from genptaslice 
						where PTA_ID in(select PTA_ID 
											 from genitemperiodtarif 
											 where TAR_id in(select tar_id
															 from genitemtarif 
															 where ITE_ID=V_ITE_ID)
											)
						and rownum=1;
					end if;
					if V_nbr>1 then
						select PTA_ID,PSL_RANK  
						into V_PTA_ID,V_PSL_RANK 
						from genptaslice 
						where PTA_ID in (select PTA_ID 
										 from genitemperiodtarif
										 where TAR_id in (select tar_id from genitemtarif where ITE_ID=V_ITE_ID) 
										)
						and rownum=1;
					end if;	
					BEGIN
						insert into genbilline(BIL_ID,BLI_REVERSEBLI_ID,BLI_NUMBER,BLI_REVERSEBLINUMBER,BLI_NAME,BLI_EXERCICE,ITE_ID,PTA_ID,PSL_RANK,IMP_ID,BLI_VOLUMEBASE,BLI_VOLUMEFACT,
											   BLI_PUHT,TVA_ID,BLI_MHT,BLI_MTTVA,BLI_MTTC,BLI_STARTDT,BLI_ENDDT,VOW_UNIT,BLI_NBUNITES,BLI_DETAIL,BLI_CANCEL,IMC_ID,IMP_ANALYTIQUE_ID,
											   BLI_PERIODEINIT,BLI_PERIODE,BLI_REVERSEDT,BLI_CREDT,BLI_UPDTDT,BLI_UPDTBY,MEU_ID,BLI_NAME_A,BLI_REVERSEBLIDEC_ID,BLI_REVERSEBLINUMBERDEC,BLI_REVERSEDECDT)
										values(V_BIL_ID,null,v,null,V_ite_name,v_anneereel,V_ITE_ID,V_PTA_ID,V_PSL_RANK,null,1,1,facture_.fixonas/1000,V_TVA_ID,
											   facture_.fixonas/1000,0,facture_.fixonas/1000,V_FAC_DATECALCUL,V_FAC_DATECALCUL,V_VOW_UNIT,null,0,0,null,
											   null,null,null,null,null,null,null,null,null,null,null,null);
					EXCEPTION WHEN OTHERS THEN
										  BEGIN
											  insert into genbilline(BIL_ID,BLI_REVERSEBLI_ID,BLI_NUMBER,BLI_REVERSEBLINUMBER,BLI_NAME,BLI_EXERCICE,ITE_ID,PTA_ID,PSL_RANK,IMP_ID,BLI_VOLUMEBASE,BLI_VOLUMEFACT,
																     BLI_PUHT,TVA_ID,BLI_MHT,BLI_MTTVA,BLI_MTTC,BLI_STARTDT,BLI_ENDDT,VOW_UNIT,BLI_NBUNITES,BLI_DETAIL,BLI_CANCEL,IMC_ID,IMP_ANALYTIQUE_ID,
																     BLI_PERIODEINIT,BLI_PERIODE,BLI_REVERSEDT,BLI_CREDT,BLI_UPDTDT,BLI_UPDTBY,MEU_ID,BLI_NAME_A,BLI_REVERSEBLIDEC_ID,BLI_REVERSEBLINUMBERDEC,BLI_REVERSEDECDT)
															  values(V_BIL_ID,null,v+1,null,V_ite_name,v_anneereel,V_ITE_ID,V_PTA_ID,V_PSL_RANK,null,1,1,facture_.fixonas/1000,V_TVA_ID,
																	 facture_.fixonas/1000,0,facture_.fixonas/1000,V_FAC_DATECALCUL,V_FAC_DATECALCUL,V_VOW_UNIT,null,0,0,null,
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
					BEGIN
					v_code:='FRS_FIX_CSM';
						for x in C_ITEM(v_code) loop
						V_ITE_ID:=x.ite_id;
						V_ite_name:=x.ite_name
						V_VOW_UNIT:=x.VOW_UNIT
						end loop;
					EXCEPTION WHEN NO_DATA_FOUND THEN NULL;
					END;
					BEGIN
					v_tva_taux:= 18;
						for v in C_TVA(v_tva_taux) loop
						   V_TVA_ID:=v.tva_id; 
						end loop;
					EXCEPTION WHEN NO_DATA_FOUND THEN 
					V_TVA_ID := 25;
					END;
					select count(*) 
					into V_nbr 
					from genptaslice 
					where PTA_ID in (select PTA_ID 
									 from genitemperiodtarif 
									 where TAR_id in(select tar_id
													 from genitemtarif 
													 where ITE_ID=V_ITE_ID)
									);
					if V_nbr=1 then
						select PTA_ID,PSL_RANK  
						into V_PTA_ID,V_PSL_RANK 
						from genptaslice 
						where PTA_ID in(select PTA_ID 
									    from genitemperiodtarif 
									    where TAR_id in(select tar_id
													    from genitemtarif 
													    where ITE_ID=V_ITE_ID)
									   )
						and rownum=1;
					end if;
					if V_nbr>1 then
						select PTA_ID,PSL_RANK  
						into V_PTA_ID,V_PSL_RANK 
						from genptaslice 
						where PTA_ID in (select PTA_ID 
									     from genitemperiodtarif 
									     where TAR_id in(select tar_id
													     from genitemtarif 
													     where ITE_ID=V_ITE_ID)
									    )
						and rownum=1;
					end if;	
                    BEGIN
						insert into genbilline(BIL_ID,BLI_REVERSEBLI_ID,BLI_NUMBER,BLI_REVERSEBLINUMBER,BLI_NAME,BLI_EXERCICE,ITE_ID,PTA_ID,PSL_RANK,IMP_ID,BLI_VOLUMEBASE,BLI_VOLUMEFACT,
											   BLI_PUHT,TVA_ID,BLI_MHT,BLI_MTTVA,BLI_MTTC,BLI_STARTDT,BLI_ENDDT,VOW_UNIT,BLI_NBUNITES,BLI_DETAIL,BLI_CANCEL,IMC_ID,IMP_ANALYTIQUE_ID,
											   BLI_PERIODEINIT,BLI_PERIODE,BLI_REVERSEDT,BLI_CREDT,BLI_UPDTDT,BLI_UPDTBY,MEU_ID,BLI_NAME_A,BLI_REVERSEBLIDEC_ID,BLI_REVERSEBLINUMBERDEC,BLI_REVERSEDECDT)
										values(V_BIL_ID,,null,v,null,V_ite_name,v_anneereel,V_ITE_ID,V_PTA_ID,V_PSL_RANK,null,1,1,facture_.fraisctr/1000,V_TVA_ID,
											   facture_.fraisctr/1000,facture_.tva_ff/1000,(facture_.fraisctr/1000)+(facture_.TVA_ff/1000),V_FAC_DATECALCUL,V_FAC_DATECALCUL,V_VOW_UNIT,null,0,0,null,
											   null,null,null,null,null,null,null,null,null,null,null,null);
					EXCEPTION WHEN OTHERS THEN
										BEGIN
											insert into genbilline(BIL_ID,BLI_REVERSEBLI_ID,BLI_NUMBER,BLI_REVERSEBLINUMBER,BLI_NAME,BLI_EXERCICE,ITE_ID,PTA_ID,PSL_RANK,IMP_ID,BLI_VOLUMEBASE,BLI_VOLUMEFACT,
																   BLI_PUHT,TVA_ID,BLI_MHT,BLI_MTTVA,BLI_MTTC,BLI_STARTDT,BLI_ENDDT,VOW_UNIT,BLI_NBUNITES,BLI_DETAIL,BLI_CANCEL,IMC_ID,IMP_ANALYTIQUE_ID,
																   BLI_PERIODEINIT,BLI_PERIODE,BLI_REVERSEDT,BLI_CREDT,BLI_UPDTDT,BLI_UPDTBY,MEU_ID,BLI_NAME_A,BLI_REVERSEBLIDEC_ID,BLI_REVERSEBLINUMBERDEC,BLI_REVERSEDECDT)
															values(V_BIL_ID,,null,v+1,null,V_ite_name,v_anneereel,V_ITE_ID,V_PTA_ID,V_PSL_RANK,null,1,1,facture_.fraisctr/1000,V_TVA_ID,
																   facture_.fraisctr/1000,facture_.tva_ff/1000,(facture_.fraisctr/1000)+(facture_.TVA_ff/1000),V_FAC_DATECALCUL,V_FAC_DATECALCUL,V_VOW_UNIT,null,0,0,null,
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
					BEGIN
					v_code:='CAPITAL';
						for x in C_ITEM(v_code) loop
						V_ITE_ID:=x.ite_id;
						V_ite_name:=x.ite_name
						V_VOW_UNIT:=x.VOW_UNIT
						end loop;
					EXCEPTION WHEN NO_DATA_FOUND THEN NULL;
					END;
					BEGIN
					v_tva_taux:=0;
						for v in C_TVA(v_tva_taux) loop
						   V_TVA_ID:=v.tva_id; 
						end loop;
					EXCEPTION WHEN NO_DATA_FOUND THEN 
					V_TVA_ID := 25;
					END;
					select count(*) 
					into V_nbr 
					from genptaslice 
					where PTA_ID in (select PTA_ID 
									 from genitemperiodtarif 
									 where TAR_id in(select tar_id
													 from genitemtarif 
													 where ITE_ID=V_ITE_ID)
									);
					if V_nbr=1 then
					select PTA_ID,PSL_RANK  
						into V_PTA_ID,V_PSL_RANK 
						from genptaslice 
						where PTA_ID in (select PTA_ID 
									 from genitemperiodtarif 
									 where TAR_id in(select tar_id
													 from genitemtarif 
													 where ITE_ID=V_ITE_ID)
									);
						and rownum=1;
					end if;
					if V_nbr>1 then
						select PTA_ID,PSL_RANK  
						into V_PTA_ID,V_PSL_RANK 
						from genptaslice 
						where PTA_ID in (select PTA_ID 
									 from genitemperiodtarif 
									 where TAR_id in(select tar_id
													 from genitemtarif 
													 where ITE_ID=V_ITE_ID)
									)
						and rownum=1;
					end if;	
                    BEGIN
						insert into genbilline(BIL_ID,BLI_REVERSEBLI_ID,BLI_NUMBER,BLI_REVERSEBLINUMBER,BLI_NAME,BLI_EXERCICE,ITE_ID,PTA_ID,PSL_RANK,IMP_ID,BLI_VOLUMEBASE,BLI_VOLUMEFACT,
											   BLI_PUHT,TVA_ID,BLI_MHT,BLI_MTTVA,BLI_MTTC,BLI_STARTDT,BLI_ENDDT,VOW_UNIT,BLI_NBUNITES,BLI_DETAIL,BLI_CANCEL,IMC_ID,IMP_ANALYTIQUE_ID,
											   BLI_PERIODEINIT,BLI_PERIODE,BLI_REVERSEDT,BLI_CREDT,BLI_UPDTDT,BLI_UPDTBY,MEU_ID,BLI_NAME_A,BLI_REVERSEBLIDEC_ID,BLI_REVERSEBLINUMBERDEC,BLI_REVERSEDECDT)
										values(V_BIL_ID,null,v,null,V_ite_name,v_anneereel,V_ITE_ID,V_PTA_ID,V_PSL_RANK,null,1,1,facture_.CAPIT/1000,V_TVA_ID,
											  facture_.CAPIT/1000,facture_.tva_capit/1000,facture_.CAPIT/1000,V_FAC_DATECALCUL,V_FAC_DATECALCUL,V_VOW_UNIT,null,0,0,null,
											  null,null,null,null,null,null,null,null,null,null,null,null);
					EXCEPTION WHEN OTHERS THEN
										BEGIN
											insert into genbilline(BIL_ID,BLI_REVERSEBLI_ID,BLI_NUMBER,BLI_REVERSEBLINUMBER,BLI_NAME,BLI_EXERCICE,ITE_ID,PTA_ID,PSL_RANK,IMP_ID,BLI_VOLUMEBASE,BLI_VOLUMEFACT,
																   BLI_PUHT,TVA_ID,BLI_MHT,BLI_MTTVA,BLI_MTTC,BLI_STARTDT,BLI_ENDDT,VOW_UNIT,BLI_NBUNITES,BLI_DETAIL,BLI_CANCEL,IMC_ID,IMP_ANALYTIQUE_ID,
																   BLI_PERIODEINIT,BLI_PERIODE,BLI_REVERSEDT,BLI_CREDT,BLI_UPDTDT,BLI_UPDTBY,MEU_ID,BLI_NAME_A,BLI_REVERSEBLIDEC_ID,BLI_REVERSEBLINUMBERDEC,BLI_REVERSEDECDT)
															values(V_BIL_ID,null,v+1,null,V_ite_name,v_anneereel,V_ITE_ID,V_PTA_ID,V_PSL_RANK,null,1,1,facture_.CAPIT/1000,V_TVA_ID,
																  facture_.CAPIT/1000,facture_.tva_capit/1000,facture_.CAPIT/1000,V_FAC_DATECALCUL,V_FAC_DATECALCUL,V_VOW_UNIT,null,0,0,null,
																  null,null,null,null,null,null,null,null,null,null,null,null);
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
					BEGIN
					v_code:='INTERET';
						for x in C_ITEM(v_code) loop
						V_ITE_ID:=x.ite_id;
						V_ite_name:=x.ite_name
						V_VOW_UNIT:=x.VOW_UNIT
						end loop;
					EXCEPTION WHEN NO_DATA_FOUND THEN NULL;
					END;
					BEGIN
					v_tva_taux:=0;
						for v in C_TVA(v_tva_taux) loop
						   V_TVA_ID:=v.tva_id; 
						end loop;
					EXCEPTION WHEN NO_DATA_FOUND THEN 
					V_TVA_ID := 25;
					END;
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
						where PTA_ID in (select PTA_ID 
										 from genitemperiodtarif
										 where TAR_id in (select tar_id from genitemtarif where ITE_ID=V_ITE_ID) 
										)
						and rownum=1;
					end if;	
					BEGIN
						INSERT INTO genbilline(BIL_ID,BLI_REVERSEBLI_ID,BLI_NUMBER,BLI_REVERSEBLINUMBER,BLI_NAME,BLI_EXERCICE,ITE_ID,PTA_ID,PSL_RANK,IMP_ID,BLI_VOLUMEBASE,BLI_VOLUMEFACT,
											   BLI_PUHT,TVA_ID,BLI_MHT,BLI_MTTVA,BLI_MTTC,BLI_STARTDT,BLI_ENDDT,VOW_UNIT,BLI_NBUNITES,BLI_DETAIL,BLI_CANCEL,IMC_ID,IMP_ANALYTIQUE_ID,
											   BLI_PERIODEINIT,BLI_PERIODE,BLI_REVERSEDT,BLI_CREDT,BLI_UPDTDT,BLI_UPDTBY,MEU_ID,BLI_NAME_A,BLI_REVERSEBLIDEC_ID,BLI_REVERSEBLINUMBERDEC,BLI_REVERSEDECDT)
										VALUES(V_BIL_ID,null,v,null,V_ite_name,v_anneereel,V_ITE_ID,V_PTA_ID,V_PSL_RANK,null,1,1,facture_.INTER/1000,V_TVA_ID,
											   facture_.INTER/1000,0,facture_.INTER/1000,V_FAC_DATECALCUL,V_FAC_DATECALCUL,V_VOW_UNIT,null,0,0,null,
											   null,null,null,null,null,null,null,null,null,null,null,null);
					EXCEPTION WHEN OTHERS THEN
										BEGIN
											INSERT INTO genbilline(BIL_ID,BLI_REVERSEBLI_ID,BLI_NUMBER,BLI_REVERSEBLINUMBER,BLI_NAME,BLI_EXERCICE,ITE_ID,PTA_ID,PSL_RANK,IMP_ID,BLI_VOLUMEBASE,BLI_VOLUMEFACT,
																   BLI_PUHT,TVA_ID,BLI_MHT,BLI_MTTVA,BLI_MTTC,BLI_STARTDT,BLI_ENDDT,VOW_UNIT,BLI_NBUNITES,BLI_DETAIL,BLI_CANCEL,IMC_ID,IMP_ANALYTIQUE_ID,
																   BLI_PERIODEINIT,BLI_PERIODE,BLI_REVERSEDT,BLI_CREDT,BLI_UPDTDT,BLI_UPDTBY,MEU_ID,BLI_NAME_A,BLI_REVERSEBLIDEC_ID,BLI_REVERSEBLINUMBERDEC,BLI_REVERSEDECDT)
															VALUES(V_BIL_ID,null,v+1,null,V_ite_name,v_anneereel,V_ITE_ID,V_PTA_ID,V_PSL_RANK,null,1,1,facture_.INTER/1000,V_TVA_ID,
																  facture_.INTER/1000,0,facture_.INTER/1000,V_FAC_DATECALCUL,V_FAC_DATECALCUL,V_VOW_UNIT,null,0,0,null,
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
					V_PTA_ID := null;
					V_PSL_RANK := null;
					BEGIN
					v_code:='COURETABBR';
						for x in C_ITEM(v_code) loop
						V_ITE_ID:=x.ite_id;
						V_ite_name:=x.ite_name
						V_VOW_UNIT:=x.VOW_UNIT
						end loop;
					EXCEPTION WHEN NO_DATA_FOUND THEN NULL;
					END;
					BEGIN
					v_tva_taux:= 0;
						for v in C_TVA(v_tva_taux) loop
						   V_TVA_ID:=v.tva_id; 
						end loop;
					EXCEPTION WHEN NO_DATA_FOUND THEN 
					V_TVA_ID := 25;
					END;
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
						where PTA_ID in (select PTA_ID 
										 from genitemperiodtarif
										 where TAR_id in (select tar_id from genitemtarif where ITE_ID=V_ITE_ID) 
										)
						and rownum=1;
					end if;	
                    BEGIN
						INSERT INTO genbilline(BIL_ID,BLI_REVERSEBLI_ID,BLI_NUMBER,BLI_REVERSEBLINUMBER,BLI_NAME,BLI_EXERCICE,ITE_ID,PTA_ID,PSL_RANK,IMP_ID,BLI_VOLUMEBASE,BLI_VOLUMEFACT,
											   BLI_PUHT,TVA_ID,BLI_MHT,BLI_MTTVA,BLI_MTTC,BLI_STARTDT,BLI_ENDDT,VOW_UNIT,BLI_NBUNITES,BLI_DETAIL,BLI_CANCEL,IMC_ID,IMP_ANALYTIQUE_ID,
											   BLI_PERIODEINIT,BLI_PERIODE,BLI_REVERSEDT,BLI_CREDT,BLI_UPDTDT,BLI_UPDTBY,MEU_ID,BLI_NAME_A,BLI_REVERSEBLIDEC_ID,BLI_REVERSEBLINUMBERDEC,BLI_REVERSEDECDT)
										values(V_BIL_ID,null,v,null,V_ite_name,v_anneereel,V_ITE_ID,V_PTA_ID,V_PSL_RANK,null,1,1,facture_.RBRANCHE/1000,V_TVA_ID,
											   facture_.RBRANCHE/1000,0,facture_.RBRANCHE/1000,V_FAC_DATECALCUL,V_FAC_DATECALCUL,V_VOW_UNIT,null,0,0,null,
											   null,null,null,null,null,null,null,null,null,null,null,null);
					EXCEPTION WHEN OTHERS THEN
										BEGIN
											INSERT INTO genbilline(BIL_ID,BLI_REVERSEBLI_ID,BLI_NUMBER,BLI_REVERSEBLINUMBER,BLI_NAME,BLI_EXERCICE,ITE_ID,PTA_ID,PSL_RANK,IMP_ID,BLI_VOLUMEBASE,BLI_VOLUMEFACT,
																   BLI_PUHT,TVA_ID,BLI_MHT,BLI_MTTVA,BLI_MTTC,BLI_STARTDT,BLI_ENDDT,VOW_UNIT,BLI_NBUNITES,BLI_DETAIL,BLI_CANCEL,IMC_ID,IMP_ANALYTIQUE_ID,
																   BLI_PERIODEINIT,BLI_PERIODE,BLI_REVERSEDT,BLI_CREDT,BLI_UPDTDT,BLI_UPDTBY,MEU_ID,BLI_NAME_A,BLI_REVERSEBLIDEC_ID,BLI_REVERSEBLINUMBERDEC,BLI_REVERSEDECDT)
															values(V_BIL_ID,null,v+1,null,V_ite_name,v_anneereel,V_ITE_ID,V_PTA_ID,V_PSL_RANK,null,1,1,facture_.RBRANCHE/1000,V_TVA_ID,
																   facture_.RBRANCHE/1000,0,facture_.RBRANCHE/1000,V_FAC_DATECALCUL,V_FAC_DATECALCUL,V_VOW_UNIT,null,0,0,null,
																   null,null,null,null,null,null,null,null,null,null,null,null);
										EXCEPTION WHEN OTHERS THEN NULL;
										END;
					END;
					commit;
			end if;
-------------------------------------------------------------------------------------------
-----------------------------------MONTANT FACADE---------------------------------------
-------------------------------------------------------------------------------------------				
			if to_number(facture_.RFACADE) <> 0 then
				v := v+1;
					V_PTA_ID := null;
					V_PSL_RANK := null;
					BEGIN
					v_code:='RFACADE';
						for x in C_ITEM(v_code) loop
						V_ITE_ID:=x.ite_id;
						V_ite_name:=x.ite_name
						V_VOW_UNIT:=x.VOW_UNIT
						end loop;
					EXCEPTION WHEN NO_DATA_FOUND THEN NULL;
					END;
					BEGIN
					v_tva_taux:= 0;
						for v in C_TVA(v_tva_taux) loop
						   V_TVA_ID:=v.tva_id; 
						end loop;
					EXCEPTION WHEN NO_DATA_FOUND THEN 
					V_TVA_ID := 25;
					END;
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
						where PTA_ID in (select PTA_ID 
										 from genitemperiodtarif
										 where TAR_id in (select tar_id from genitemtarif where ITE_ID=V_ITE_ID) 
										)
						and rownum=1;
					end if;	
					BEGIN
						INSERT INTO genbilline(BIL_ID,BLI_REVERSEBLI_ID,BLI_NUMBER,BLI_REVERSEBLINUMBER,BLI_NAME,BLI_EXERCICE,ITE_ID,PTA_ID,PSL_RANK,IMP_ID,BLI_VOLUMEBASE,BLI_VOLUMEFACT,
											   BLI_PUHT,TVA_ID,BLI_MHT,BLI_MTTVA,BLI_MTTC,BLI_STARTDT,BLI_ENDDT,VOW_UNIT,BLI_NBUNITES,BLI_DETAIL,BLI_CANCEL,IMC_ID,IMP_ANALYTIQUE_ID,
											   BLI_PERIODEINIT,BLI_PERIODE,BLI_REVERSEDT,BLI_CREDT,BLI_UPDTDT,BLI_UPDTBY,MEU_ID,BLI_NAME_A,BLI_REVERSEBLIDEC_ID,BLI_REVERSEBLINUMBERDEC,BLI_REVERSEDECDT)
										values(V_BIL_ID,null,v,null,V_ite_name,v_anneereel,V_ITE_ID,V_PTA_ID,V_PSL_RANK,null,1,1,facture_.RFACADE/1000,V_TVA_ID,
											   facture_.RFACADE/1000,0,facture_.RFACADE/1000,V_FAC_DATECALCUL,V_FAC_DATECALCUL,V_VOW_UNIT,null,0,0,null,
											   null,null,null,null,null,null,null,null,null,null,null,null);
					EXCEPTION WHEN OTHERS THEN
										BEGIN
										    INSERT INTO genbilline(BIL_ID,BLI_REVERSEBLI_ID,BLI_NUMBER,BLI_REVERSEBLINUMBER,BLI_NAME,BLI_EXERCICE,ITE_ID,PTA_ID,PSL_RANK,IMP_ID,BLI_VOLUMEBASE,BLI_VOLUMEFACT,
																   BLI_PUHT,TVA_ID,BLI_MHT,BLI_MTTVA,BLI_MTTC,BLI_STARTDT,BLI_ENDDT,VOW_UNIT,BLI_NBUNITES,BLI_DETAIL,BLI_CANCEL,IMC_ID,IMP_ANALYTIQUE_ID,
																   BLI_PERIODEINIT,BLI_PERIODE,BLI_REVERSEDT,BLI_CREDT,BLI_UPDTDT,BLI_UPDTBY,MEU_ID,BLI_NAME_A,BLI_REVERSEBLIDEC_ID,BLI_REVERSEBLINUMBERDEC,BLI_REVERSEDECDT)
															values(V_BIL_ID,null,v+1,null,V_ite_name,v_anneereel,V_ITE_ID,V_PTA_ID,V_PSL_RANK,null,1,1,facture_.RFACADE/1000,V_TVA_ID,
																   facture_.RFACADE/1000,0,facture_.RFACADE/1000,V_FAC_DATECALCUL,V_FAC_DATECALCUL,V_VOW_UNIT,null,0,0,null,
																   null,null,null,null,null,null,null,null,null,null,null,null);
										EXCEPTION WHEN OTHERS THEN NULL;
										END;
					END;
					commit;
			end if;
-------------------------------------------------------------------------------------------
-----------------------------------MONTANT REPORT------------------------------------------
-------------------------------------------------------------------------------------------	
			if to_number(facture_.AREPOR) <> 0 then
				v := v+1;
					V_PTA_ID := null;
					V_PSL_RANK := null;
					BEGIN
					v_code:='AREPOR';
						for x in C_ITEM(v_code) loop
						V_ITE_ID:=x.ite_id;
						V_ite_name:=x.ite_name
						V_VOW_UNIT:=x.VOW_UNIT
						end loop;
					EXCEPTION WHEN NO_DATA_FOUND THEN NULL;
					END;
					BEGIN
					v_tva_taux:= 0;
						for v in C_TVA(v_tva_taux) loop
						   V_TVA_ID:=v.tva_id; 
						end loop;
					EXCEPTION WHEN NO_DATA_FOUND THEN 
					V_TVA_ID := 25;
					END;
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
						where PTA_ID in (select PTA_ID 
										 from genitemperiodtarif
										 where TAR_id in (select tar_id from genitemtarif where ITE_ID=V_ITE_ID) 
										)
						and rownum=1;
					end if;	
                    BEGIN
						INSERT into genbilline(BIL_ID,BLI_REVERSEBLI_ID,BLI_NUMBER,BLI_REVERSEBLINUMBER,BLI_NAME,BLI_EXERCICE,ITE_ID,PTA_ID,PSL_RANK,IMP_ID,BLI_VOLUMEBASE,BLI_VOLUMEFACT,
											   BLI_PUHT,TVA_ID,BLI_MHT,BLI_MTTVA,BLI_MTTC,BLI_STARTDT,BLI_ENDDT,VOW_UNIT,BLI_NBUNITES,BLI_DETAIL,BLI_CANCEL,IMC_ID,IMP_ANALYTIQUE_ID,
											   BLI_PERIODEINIT,BLI_PERIODE,BLI_REVERSEDT,BLI_CREDT,BLI_UPDTDT,BLI_UPDTBY,MEU_ID,BLI_NAME_A,BLI_REVERSEBLIDEC_ID,BLI_REVERSEBLINUMBERDEC,BLI_REVERSEDECDT)
										values(V_BIL_ID,null,v,null,V_ite_name,v_anneereel,V_ITE_ID,V_PTA_ID,V_PSL_RANK,null,1,1,decode(facture_.caron,'1',1,-1)* (facture_.AREPOR/1000),V_TVA_ID			,--14
											   decode(facture_.caron,'1',1,-1)* (facture_.AREPOR/1000),0,decode(facture_.caron,'1',1,-1)* (facture_.AREPOR/1000),V_FAC_DATECALCUL,V_FAC_DATECALCUL,V_VOW_UNIT,null,0,0,null,
											   null,null,null,null,null,null,null,null,null,null,null,null);
					EXCEPTION WHEN OTHERS THEN
										BEGIN
										    INSERT into genbilline(BIL_ID,BLI_REVERSEBLI_ID,BLI_NUMBER,BLI_REVERSEBLINUMBER,BLI_NAME,BLI_EXERCICE,ITE_ID,PTA_ID,PSL_RANK,IMP_ID,BLI_VOLUMEBASE,BLI_VOLUMEFACT,
															       BLI_PUHT,TVA_ID,BLI_MHT,BLI_MTTVA,BLI_MTTC,BLI_STARTDT,BLI_ENDDT,VOW_UNIT,BLI_NBUNITES,BLI_DETAIL,BLI_CANCEL,IMC_ID,IMP_ANALYTIQUE_ID,
															       BLI_PERIODEINIT,BLI_PERIODE,BLI_REVERSEDT,BLI_CREDT,BLI_UPDTDT,BLI_UPDTBY,MEU_ID,BLI_NAME_A,BLI_REVERSEBLIDEC_ID,BLI_REVERSEBLINUMBERDEC,BLI_REVERSEDECDT)
															values(V_BIL_ID,null,v+1,null,V_ite_name,v_anneereel,V_ITE_ID,V_PTA_ID,V_PSL_RANK,null,1,1,decode(facture_.caron,'1',1,-1)* (facture_.AREPOR/1000),V_TVA_ID			,--14
																   decode(facture_.caron,'1',1,-1)* (facture_.AREPOR/1000),0,decode(facture_.caron,'1',1,-1)* (facture_.AREPOR/1000),V_FAC_DATECALCUL,V_FAC_DATECALCUL,V_VOW_UNIT,null,0,0,null,
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
					BEGIN
					v_code:='NAROND';
						FOR x in C_ITEM(v_code) LOOP
						V_ITE_ID:=x.ite_id;
						V_ite_name:=x.ite_name
						V_VOW_UNIT:=x.VOW_UNIT
						END LOOP;
					EXCEPTION WHEN NO_DATA_FOUND THEN NULL;
					END;
					BEGIN
					v_tva_taux:= 0;
						FOR v in C_TVA(v_tva_taux) LOOP
						   V_TVA_ID:=v.tva_id; 
						END LOOP;
					EXCEPTION WHEN NO_DATA_FOUND THEN 
					V_TVA_ID := 25;
					END;
					select count(*) 
					into V_nbr 
					from genptaslice 
					where PTA_ID in (select PTA_ID 	from genitemperiodtarif 
									 where TAR_id in (select tar_id from genitemtarif where ITE_ID=V_ITE_ID )
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
						where PTA_ID in (select PTA_ID 
										 from genitemperiodtarif
										 where TAR_id in (select tar_id from genitemtarif where ITE_ID=V_ITE_ID) 
										)
						and rownum=1;
					end if;	
					BEGIN
						INSERT INTO genbilline(BIL_ID,BLI_REVERSEBLI_ID,BLI_NUMBER,BLI_REVERSEBLINUMBER,BLI_NAME,BLI_EXERCICE,ITE_ID,PTA_ID,PSL_RANK,IMP_ID,BLI_VOLUMEBASE,BLI_VOLUMEFACT,
											   BLI_PUHT,TVA_ID,BLI_MHT,BLI_MTTVA,BLI_MTTC,BLI_STARTDT,BLI_ENDDT,VOW_UNIT,BLI_NBUNITES,BLI_DETAIL,BLI_CANCEL,IMC_ID,IMP_ANALYTIQUE_ID,
											   BLI_PERIODEINIT,BLI_PERIODE,BLI_REVERSEDT,BLI_CREDT,BLI_UPDTDT,BLI_UPDTBY,MEU_ID,BLI_NAME_A,BLI_REVERSEBLIDEC_ID,BLI_REVERSEBLINUMBERDEC,BLI_REVERSEDECDT)
									   VALUES(V_BIL_ID,null,v,null,V_ite_name,v_anneereel,V_ITE_ID,V_PTA_ID,V_PSL_RANK,null,1,1,decode(facture_.caron,'1',-1,1)*(facture_.NAROND/1000),V_TVA_ID,
											  decode(facture_.caron,'1',-1,1)*(facture_.NAROND/1000),0,decode(facture_.caron,'1',-1,1)*(facture_.NAROND/1000),V_FAC_DATECALCUL,V_FAC_DATECALCUL,V_VOW_UNIT,null,0,0,null,
											  null,null,null,null,null,null,null,null,null,null,null,null);	 
					EXCEPTION WHEN OTHERS THEN
										BEGIN
											INSERT INTO genbilline(BIL_ID,BLI_REVERSEBLI_ID,BLI_NUMBER,BLI_REVERSEBLINUMBER,BLI_NAME,BLI_EXERCICE,ITE_ID,PTA_ID,PSL_RANK,IMP_ID,BLI_VOLUMEBASE,BLI_VOLUMEFACT,
																   BLI_PUHT,TVA_ID,BLI_MHT,BLI_MTTVA,BLI_MTTC,BLI_STARTDT,BLI_ENDDT,VOW_UNIT,BLI_NBUNITES,BLI_DETAIL,BLI_CANCEL,IMC_ID,IMP_ANALYTIQUE_ID,
																   BLI_PERIODEINIT,BLI_PERIODE,BLI_REVERSEDT,BLI_CREDT,BLI_UPDTDT,BLI_UPDTBY,MEU_ID,BLI_NAME_A,BLI_REVERSEBLIDEC_ID,BLI_REVERSEBLINUMBERDEC,BLI_REVERSEDECDT)
														   VALUES(V_BIL_ID,null,v+1,null,V_ite_name,v_anneereel,V_ITE_ID,V_PTA_ID,V_PSL_RANK,null,1,1,decode(facture_.caron,'1',-1,1)*(facture_.NAROND/1000),V_TVA_ID,
																  decode(facture_.caron,'1',-1,1)*(facture_.NAROND/1000),0,decode(facture_.caron,'1',-1,1)*(facture_.NAROND/1000),V_FAC_DATECALCUL,V_FAC_DATECALCUL,V_VOW_UNIT,null,0,0,null,
																  null,null,null,null,null,null,null,null,null,null,null,null);	 
										EXCEPTION WHEN OTHERS THEN NULL;
										END;
					END;
					commit;
			end if;
-------------------------------------------------------------------------------------------
----------------------------------FRAIS DE DÉPLACEMENT-------------------------------------
-------------------------------------------------------------------------------------------				
			 if to_number(facture_.deplacement) <> 0 then 
				v := v+1;
					V_PTA_ID := null;
					V_PSL_RANK := null;
					BEGIN
					v_code:='F_DEPLACEMNT';
						for x in C_ITEM(v_code) loop
						V_ITE_ID:=x.ite_id;
						V_ite_name:=x.ite_name
						V_VOW_UNIT:=x.VOW_UNIT
						end loop;
					EXCEPTION WHEN NO_DATA_FOUND THEN NULL;
					END;
					BEGIN
					v_tva_taux:= 18;
						for v in C_TVA(v_tva_taux) loop
						   V_TVA_ID:=v.tva_id; 
						end loop;
					EXCEPTION WHEN NO_DATA_FOUND THEN 
					V_TVA_ID := 25;
					END;				
					select count(*) 
					into V_nbr 
					from genptaslice 
					where PTA_ID in (select PTA_ID from genitemperiodtarif 
									 where TAR_id in (select tar_id from genitemtarif where ITE_ID=V_ITE_ID )
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
						where PTA_ID in (select PTA_ID 
										 from genitemperiodtarif
										 where TAR_id in (select tar_id from genitemtarif where ITE_ID=V_ITE_ID) 
										)
						and rownum=1;
					end if;	
					BEGIN
						INSERT INTO genbilline(BIL_ID,BLI_REVERSEBLI_ID,BLI_NUMBER,BLI_REVERSEBLINUMBER,BLI_NAME,BLI_EXERCICE,ITE_ID,PTA_ID,PSL_RANK,IMP_ID,BLI_VOLUMEBASE,BLI_VOLUMEFACT,
											   BLI_PUHT,TVA_ID,BLI_MHT,BLI_MTTVA,BLI_MTTC,BLI_STARTDT,BLI_ENDDT,VOW_UNIT,BLI_NBUNITES,BLI_DETAIL,BLI_CANCEL,IMC_ID,IMP_ANALYTIQUE_ID,
											   BLI_PERIODEINIT,BLI_PERIODE,BLI_REVERSEDT,BLI_CREDT,BLI_UPDTDT,BLI_UPDTBY,MEU_ID,BLI_NAME_A,BLI_REVERSEBLIDEC_ID,BLI_REVERSEBLINUMBERDEC,BLI_REVERSEDECDT)
										values(V_BIL_ID,null,v,null,V_ite_name,v_anneereel,V_ITE_ID,V_PTA_ID,V_PSL_RANK,null,1,1,facture_.deplacement/1000,V_TVA_ID,
											   facture_.deplacement/1000,facture_.tvadeplac/1000,facture_.deplacement/1000 + (facture_.tvadeplac/1000),V_FAC_DATECALCUL,V_FAC_DATECALCUL,V_VOW_UNIT,null,0,0,null,
											   null,null,null,null,null,null,null,null,null,null,null,null);	 
					EXCEPTION WHEN OTHERS THEN
										BEGIN
										INSERT INTO genbilline(BIL_ID,BLI_REVERSEBLI_ID,BLI_NUMBER,BLI_REVERSEBLINUMBER,BLI_NAME,BLI_EXERCICE,ITE_ID,PTA_ID,PSL_RANK,IMP_ID,BLI_VOLUMEBASE,BLI_VOLUMEFACT,
															   BLI_PUHT,TVA_ID,BLI_MHT,BLI_MTTVA,BLI_MTTC,BLI_STARTDT,BLI_ENDDT,VOW_UNIT,BLI_NBUNITES,BLI_DETAIL,BLI_CANCEL,IMC_ID,IMP_ANALYTIQUE_ID,
															   BLI_PERIODEINIT,BLI_PERIODE,BLI_REVERSEDT,BLI_CREDT,BLI_UPDTDT,BLI_UPDTBY,MEU_ID,BLI_NAME_A,BLI_REVERSEBLIDEC_ID,BLI_REVERSEBLINUMBERDEC,BLI_REVERSEDECDT)
													    values(V_BIL_ID,null,v+1,null,V_ite_name,v_anneereel,V_ITE_ID,V_PTA_ID,V_PSL_RANK,null,1,1,facture_.deplacement/1000,V_TVA_ID,
															   facture_.deplacement/1000,facture_.tvadeplac/1000,facture_.deplacement/1000 + (facture_.tvadeplac/1000),V_FAC_DATECALCUL,V_FAC_DATECALCUL,V_VOW_UNIT,null,0,0,null,
															   null,null,null,null,null,null,null,null,null,null,null,null);
										EXCEPTION WHEN OTHERS THEN NULL;
										END;
					END;
					commit;
			 end if;
-------------------------------------------------------------------------------------------
---------------------FRAIS DE DÉPOSE SUITE À LA DEMANDE DU CLIENT---------------------------
-------------------------------------------------------------------------------------------			 
			 if to_number(facture_.depose_dem) <> 0 then
				v := v+1;
					V_PTA_ID := null;
					V_PSL_RANK := null;
					BEGIN
					v_code:='FRAIS_FRM_DEP';
						for x in C_ITEM(v_code) loop
						V_ITE_ID:=x.ite_id;
						V_ite_name:=x.ite_name
						V_VOW_UNIT:=x.VOW_UNIT
						end loop;
					EXCEPTION WHEN NO_DATA_FOUND THEN NULL;
					END;
					BEGIN
					v_tva_taux:= 18;
						for v in C_TVA(v_tva_taux) loop
						   V_TVA_ID:=v.tva_id; 
						end loop;
					EXCEPTION WHEN NO_DATA_FOUND THEN 
					 V_TVA_ID := 25;
					END;
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
						where PTA_ID in (select PTA_ID 
										 from genitemperiodtarif
										 where TAR_id in (select tar_id from genitemtarif where ITE_ID=V_ITE_ID) 
										)
						and rownum=1;
					end if;	
                    BEGIN
						INSERT INTO genbilline(BIL_ID,BLI_REVERSEBLI_ID,BLI_NUMBER,BLI_REVERSEBLINUMBER,BLI_NAME,BLI_EXERCICE,ITE_ID,PTA_ID,PSL_RANK,IMP_ID,BLI_VOLUMEBASE,BLI_VOLUMEFACT,
											   BLI_PUHT,TVA_ID,BLI_MHT,BLI_MTTVA,BLI_MTTC,BLI_STARTDT,BLI_ENDDT,VOW_UNIT,BLI_NBUNITES,BLI_DETAIL,BLI_CANCEL,IMC_ID,IMP_ANALYTIQUE_ID,
											   BLI_PERIODEINIT,BLI_PERIODE,BLI_REVERSEDT,BLI_CREDT,BLI_UPDTDT,BLI_UPDTBY,MEU_ID,BLI_NAME_A,BLI_REVERSEBLIDEC_ID,BLI_REVERSEBLINUMBERDEC,BLI_REVERSEDECDT)
									    values(V_BIL_ID,null,v,null,V_ite_name,v_anneereel,V_ITE_ID,V_PTA_ID,V_PSL_RANK,null,1,1,facture_.depose_dem/1000,V_TVA_ID,
											   facture_.depose_dem/1000,facture_.tvadepose_dem/1000,facture_.depose_dem/1000 + (facture_.tvadepose_dem/1000),V_FAC_DATECALCUL,V_FAC_DATECALCUL,V_VOW_UNIT,null,0,0,null,
											   null,null,null,null,null,null,null,null,null,null,null,null);
										EXCEPTION WHEN OTHERS THEN
											BEGIN
												INSERT INTO genbilline(BIL_ID,BLI_REVERSEBLI_ID,BLI_NUMBER,BLI_REVERSEBLINUMBER,BLI_NAME,BLI_EXERCICE,ITE_ID,PTA_ID,PSL_RANK,IMP_ID,BLI_VOLUMEBASE,BLI_VOLUMEFACT,
																	   BLI_PUHT,TVA_ID,BLI_MHT,BLI_MTTVA,BLI_MTTC,BLI_STARTDT,BLI_ENDDT,VOW_UNIT,BLI_NBUNITES,BLI_DETAIL,BLI_CANCEL,IMC_ID,IMP_ANALYTIQUE_ID,
																	   BLI_PERIODEINIT,BLI_PERIODE,BLI_REVERSEDT,BLI_CREDT,BLI_UPDTDT,BLI_UPDTBY,MEU_ID,BLI_NAME_A,BLI_REVERSEBLIDEC_ID,BLI_REVERSEBLINUMBERDEC,BLI_REVERSEDECDT)
																 values(V_BIL_ID,null,v+1,null,V_ite_name,v_anneereel,V_ITE_ID,V_PTA_ID,V_PSL_RANK,null,1,1,facture_.depose_dem/1000,V_TVA_ID,
																		facture_.depose_dem/1000,facture_.tvadepose_dem/1000,facture_.depose_dem/1000 + (facture_.tvadepose_dem/1000),V_FAC_DATECALCUL,V_FAC_DATECALCUL,V_VOW_UNIT,null,0,0,null,
																		null,null,null,null,null,null,null,null,null,null,null,null); 
											EXCEPTION WHEN OTHERS THEN NULL;
											END;
					END;
					commit;
			end if;	
-------------------------------------------------------------------------------------------
---------------------FRAIS DE DÉPOSE SUITE AU NON PAIEMENT---------------------------------
-------------------------------------------------------------------------------------------				
			if to_number(facture_.depose_def) <> 0 then
				v := v+1;
					V_PTA_ID := null;
					V_PSL_RANK := null;
					BEGIN
					v_code:='FRS_DPOZ_RPOZ';
						for x in C_ITEM(v_code) loop
						V_ITE_ID:=x.ite_id;
						V_ite_name:=x.ite_name
						V_VOW_UNIT:=x.VOW_UNIT
						end loop;
					EXCEPTION WHEN NO_DATA_FOUND THEN NULL;
					END;
					BEGIN
					v_tva_taux:= 18;
						for v in C_TVA(v_tva_taux) loop
						   V_TVA_ID:=v.tva_id; 
						end loop;
					EXCEPTION WHEN NO_DATA_FOUND THEN 
					V_TVA_ID := 25;
					END;
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
						where PTA_ID in (select PTA_ID 
										 from genitemperiodtarif
										 where TAR_id in (select tar_id from genitemtarif where ITE_ID=V_ITE_ID) 
										)
						and rownum=1;
					end if;	
                    BEGIN
						INSERT INTO genbilline(BIL_ID,BLI_REVERSEBLI_ID,BLI_NUMBER,BLI_REVERSEBLINUMBER,BLI_NAME,BLI_EXERCICE,ITE_ID,PTA_ID,PSL_RANK,IMP_ID,BLI_VOLUMEBASE,BLI_VOLUMEFACT,
											   BLI_PUHT,TVA_ID,BLI_MHT,BLI_MTTVA,BLI_MTTC,BLI_STARTDT,BLI_ENDDT,VOW_UNIT,BLI_NBUNITES,BLI_DETAIL,BLI_CANCEL,IMC_ID,IMP_ANALYTIQUE_ID,
											   BLI_PERIODEINIT,BLI_PERIODE,BLI_REVERSEDT,BLI_CREDT,BLI_UPDTDT,BLI_UPDTBY,MEU_ID,BLI_NAME_A,BLI_REVERSEBLIDEC_ID,BLI_REVERSEBLINUMBERDEC,BLI_REVERSEDECDT)
										values(V_BIL_ID,null,v,null,V_ite_name,v_anneereel,V_ITE_ID,V_PTA_ID,V_PSL_RANK,null,1,1,facture_.depose_def/1000,V_TVA_ID,
											   facture_.depose_def/1000,facture_.tvadepose_def/1000,facture_.depose_def/1000 + (facture_.tvadepose_def/1000),V_FAC_DATECALCUL,V_FAC_DATECALCUL,V_VOW_UNIT,null,0,0,null,
											   null,null,null,null,null,null,null,null,null,null,null,null); 
					EXCEPTION WHEN OTHERS THEN
											BEGIN
											  INSERT INTO genbilline(BIL_ID,BLI_REVERSEBLI_ID,BLI_NUMBER,BLI_REVERSEBLINUMBER,BLI_NAME,BLI_EXERCICE,ITE_ID,PTA_ID,PSL_RANK,IMP_ID,BLI_VOLUMEBASE,BLI_VOLUMEFACT,
																	 BLI_PUHT,TVA_ID,BLI_MHT,BLI_MTTVA,BLI_MTTC,BLI_STARTDT,BLI_ENDDT,VOW_UNIT,BLI_NBUNITES,BLI_DETAIL,BLI_CANCEL,IMC_ID,IMP_ANALYTIQUE_ID,
																	 BLI_PERIODEINIT,BLI_PERIODE,BLI_REVERSEDT,BLI_CREDT,BLI_UPDTDT,BLI_UPDTBY,MEU_ID,BLI_NAME_A,BLI_REVERSEBLIDEC_ID,BLI_REVERSEBLINUMBERDEC,BLI_REVERSEDECDT)
															  values(V_BIL_ID,null,v+1,null,V_ite_name,v_anneereel,V_ITE_ID,V_PTA_ID,V_PSL_RANK,null,1,1,facture_.depose_def/1000,V_TVA_ID,
																     facture_.depose_def/1000,facture_.tvadepose_def/1000,facture_.depose_def/1000 + (facture_.tvadepose_def/1000),V_FAC_DATECALCUL,V_FAC_DATECALCUL,V_VOW_UNIT,null,0,0,null,
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
	    FOR x in branch_(lpad(facture_.DIST,2,'0'),lpad(trim(facture_.TOU),3,'0'),lpad(trim(facture_.ORD),3,'0'))LOOP		
        V_FAC_DATECALCUL :=null;
		V_FAC_DATELIM    :=null;
		V_TRAIN_FACT     :=null;
		V_AMOUNTTTCDEC   :=null;
		V_ID_FACTURE:= lpad(trim(facture_.district),2,'0')||lpad(trim(facture_.tournee),3,'0')||lpad(trim(facture_.ordre),3,'0')||to_char(facture_.annee)||lpad(to_char(facture_.periode),2,0)||to_char(v_version);
        
		select last_day(to_date('01'||lpad(trim(facture_.periode),2,'0')||facture_.annee,'dd/mm/yy'))
	    into v_date
	    from dual;
		BEGIN
	      V_FAC_DATECALCUL := v_date;
	    EXCEPTION  WHEN OTHERS THEN
	      V_FAC_DATECALCUL := '01/01/2016';
	    END;
		
        V_ANNEEREEL:= facture_.annee;
		V_periode  := facture_.periode;
		V_pdl_ref  := lpad(trim(facture_.DISTRICT),2,'0')||lpad(trim(facture_.tournee),3,'0')||lpad(trim(facture_.Ordre),3,'0')||lpad(trim(facture_.POLICE),5,'0');
        V_REF_ABN  := lpad(trim(facture_.DISTRICT),2,'0')||lpad(trim(facture_.POLICE),5,'0')||lpad(trim(facture_.tournee),3,'0')||lpad(trim(facture_.Ordre),3,'0');
        
		select NTIERS,NSIXIEME
		into V_tiers,V_six
		from tourne
		where trim(code)=lpad(trim(facture_.tournee),3,'0')
		and  trim(district)=trim(facture_.DISTRICT);
        
		V_TRAIN_FACT :='ANNEE:'||trim(facture_.annee)||' TRIM:'||trim(facture_.periode)||' TIER:'||trim(V_tiers)||' SIX:'||trim(V_six );
		BEGIN
			if lpad(trim(facture_.DISTRICT),2,'0')='57' then
				select g.org_id	
				into V_ORG_ID 
				from GENORGANIZATION g 
				where upper(g.org_code)='22';
			elsif lpad(trim(facture_.DISTRICT),2,'0')='58' then
				select g.org_id	
				into V_ORG_ID 
				from GENORGANIZATION g 
				where upper(g.org_code)='32';	
			elsif lpad(trim(facture_.DISTRICT),2,'0')='60' then
				select g.org_id	
				into V_ORG_ID 
				from GENORGANIZATION g 
				where upper(g.org_code)='36';			
			elsif lpad(trim(facture_.DISTRICT),2,'0')='61' then
				select g.org_id	
				into V_ORG_ID 
				from GENORGANIZATION g 
				where upper(g.org_code)='03';
			elsif lpad(trim(facture_.DISTRICT),2,'0')='63' then
				select g.org_id	
				into V_ORG_ID 
				from GENORGANIZATION g 
				where upper(g.org_code)='15';
			end if ;
		EXCEPTION WHEN OTHERS THEN 
			select g.org_id	
			into V_ORG_ID 
			from GENORGANIZATION g 
			where upper(g.org_code)=lpad(trim(facture_.DISTRICT),2,'0');
		END;
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
        
		if v_nbr=0 then 
 --------------------------------------------------------Traitement Role
			If (V_anneereel is not null and V_periode is not null and V_TRAIN_FACT is not null) then			
				Begin
					select t.run_id
					into v_run_id
					from genrun t 
					where t.run_exercice=V_anneereel
					and run_number      =V_periode;
				EXCEPTION WHEN OTHERS THEN 			  
					select seq_genrun.nextval into v_run_id from dual;				
						insert into genrun (run_id,run_exercice,run_number,org_id,run_startdt,run_comment,RUN_NAME,RUN_DTCALC,RUN_ENDDT)
									values (v_run_id,V_anneereel,V_periode,V_org_id,V_FAC_DATECALCUL,'Role migré','Role '||V_TRAIN_FACT,V_FAC_DATECALCUL,V_FAC_DATECALCUL);
				end;    
			end if ; 
--------------------------------------------------------Traitement Det
			select seq_gendebt.nextval    into Debt_Id       from dual; 
			If (V_TOTHTE+ V_TVA+V_TOTHTA+V_TOTTVAA) > 0 then --- Facture Normal else Facture Avoire
				V_DEB_AMOUNTINIT   := V_TOTHTE+V_TVA+V_TOTHTA+V_TOTTVAA ;
				V_deb_amount_cash  := V_TOTHTE+V_TVA+V_TOTHTA+V_TOTTVAA;
				V_VOW_DEBTYPE      := pk_genvocword.getidbycode('VOW_DEBTYPE','FA',null) ;
			else
				V_deb_amount_cash  := -(V_TOTHTE+V_TVA+V_TOTHTA+V_TOTTVAA) ;
				V_DEB_AMOUNTINIT   := 0;
				V_VOW_DEBTYPE      := pk_genvocword.getidbycode('VOW_DEBTYPE','AV',null) ;
			end if ;
            V_DEB_AMOUNTREMAIN := V_SOLDE ;
			V_DEB_COMMENT      := V_REF_ABN ;
			V_VOW_SETTLEMODE   := pk_genvocword.getidbycode('VOW_SETTLEMODE',4,null) ;
			V_DEB_NORECOVERY   := 0;
----------------------------------------------------------Traitement GENACCOUNT ,GENIMP
			    Begin 
					select t.imp_id
					into V_IMP_ID
					from genimp t 
					where t.imp_code=V_COMPTEAUX;
				EXCEPTION WHEN OTHERS THEN 
					V_VOW_BUDGTP        :=  pk_genvocword.getidbycode('VOW_BUDGTP','EA',null);
					select seq_genimp.nextval  into V_IMP_ID  from dual;
					insert into genimp (imp_id,imp_code,imp_name,vow_budgtp,org_id)
								 values(V_IMP_ID,V_COMPTEAUX,V_COMPTEAUX,V_VOW_BUDGTP,V_org_id);
				END;
			 	BEGIN 
					select t.aco_id 
					into V_ACO_ID
					from genaccount t
					where t.par_id=V_PAR_ID;
                EXCEPTION WHEN OTHERS THEN 
					V_VOW_ACOTP     :=  pk_genvocword.getidbycode('VOW_ACOTP','1',null);
					select seq_genaccount.nextval into V_ACO_ID from dual;
					insert into genaccount(aco_id,par_id,imp_id,vow_acotp,rec_id)
									values(V_ACO_ID,V_PAR_ID,V_imp_id,V_VOW_ACOTP,null);
				END;				
				BEGIN	
					select t.sco_id
					into V_SCO_ID
					from agrsagaco t
					where t.aco_id=V_ACO_ID;
				EXCEPTION WHEN OTHERS THEN
					select seq_agrsagaco.nextval  into V_SCO_ID  from dual;
					insert into agrsagaco(sco_id,sag_id,aco_id,sco_startdt)
								   values(V_SCO_ID,V_SAG_ID,V_ACO_ID,V_ABN_DT_DEB);
				END;
			
			   Insert into gendebt(deb_id,deb_refe,org_id,par_id,adr_id,deb_date,deb_duedt,deb_printdt,
								   deb_amountinit,deb_amountremain,bap_id,VOW_SETTLEMODE,aco_id,deb_norecovery,deb_credt,
								   deb_updtby,deb_updtdt,deb_comment,deb_amount_cash,sag_id,VOW_DEBTYPE,deb_prel)
						  values (V_Deb_ID,V_ID_FACTURE,V_ORG_ID,V_PAR_ID,V_ADR_ID,V_FAC_DATECALCUL,V_FAC_DATECALCUL,V_FAC_DATECALCUL,
								  V_DEB_AMOUNTINIT,V_DEB_AMOUNTREMAIN,null,V_VOW_SETTLEMODE,V_ACO_ID,V_DEB_NORECOVERY,sysdate,
								  null,null,V_DEB_COMMENT,nvl(V_deb_amount_cash,0),V_SAG_ID,V_VOW_DEBTYPE,1);	
				commit;
--------------------------------------------------------Traitement agrbill
			select seq_agrbill.nextval into V_BIL_ID from dual;
			V_VOW_AGRBILLTYPE   :=  pk_genvocword.getidbycode('VOW_AGRBILLTYPE',decode(facture_.etat,'P','RF','O','FC','C','FHC','FC'),null) ;
			v_VOW_MODEFACT      :=  pk_genvocword.getidbycode('VOW_MODEFACT',4,null);--------NB:(4 ou MIG) a verifier
			Insert into agrbill(BIL_ID,SAG_ID,VOW_AGRBILLTYPE,VOW_MODEFACT)
						 values(V_BIL_ID,V_SAG_ID,V_VOW_AGRBILLTYPE,v_VOW_MODEFACT);	
			commit;
--------------------------------------------------------Traitement genbill
            V_BIL_AMOUNTHT      :=  V_TOTHTE +V_TOTHTA ;
			V_BIL_AMOUNTTVA     :=  V_TVA+V_TOTTVAA ;
			V_BIL_AMOUNTTTC     :=  V_TOTHTE+V_TVA+V_TOTHTA+V_TOTTVAA ;
			V_BIL_STATUS        :=  1;
				    Insert into genbill(BIL_ID,BIL_CODE,BIL_CALCDT,BIL_AMOUNTHT,BIL_AMOUNTTVA,BIL_AMOUNTTTC,DEB_ID,PAR_ID,BIL_STATUS,BIL_AMOUNTTTCDEC,BIL_DEBTDT,RUN_ID)
							     values(V_BIL_ID,V_ID_FACTURE,V_FAC_DATECALCUL,V_BIL_AMOUNTHT,V_BIL_AMOUNTTVA,V_BIL_AMOUNTTTC,
									    V_Deb_ID,V_PAR_ID,V_BIL_STATUS,V_AMOUNTTTCDEC,V_FAC_DATECALCUL,v_run_id); 
				commit;
			end if;
			commit;
	    end loop;
	end loop;
-----------------------------------------------------------------------------------------------------
--------FACTURE_VERSION----------------FACTURE_VERSION--------------------------FACTURE_VERSION------	
-----------------------------------------------------------------------------------------------------	
    FOR facture_ in fact_vers LOOP
	    FOR x in branch_(lpad(facture_.DIST,2,'0'),lpad(trim(facture_.TOU),3,'0'),lpad(trim(facture_.ORD),3,'0'))LOOP	
			V_periode:= facture_.periode;
			IF facture_.periodicite <> 'G' then
				BEGIN
					select m3 
					into mois_ 
					from param_tournee 
					where DISTRICT=trim(facture_.district)
					And TRIM =trim(facture_.periode)
					And TIER = facture_.TIERS
					and (TIER,SIX) in (select t.NTIERS,t.NSIXIEME from tourne t
									   where trim(t.code)=lpad(trim(facture_.tournee),3,'0')
									   and trim(t.district)=trim(facture_.DISTRICT));
				EXCEPTION WHEN OTHERS THEN
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
				END;
			else
			  mois_ := trim(facture_.periode);
			end if;
			V_anneereel :=facture_.annee;
			V_FAC_RESTANTDU  := null;
			V_FAC_DATECALCUL := null;
			V_REF_ABN        := null;
			V_FAC_DATECALCUL := BIL_CALCDT + 5;
			v_ID_FACTURE:=lpad(trim(facture_.DISTRICT),2,'0')||lpad(trim(facture_.tournee),3,'0')||lpad(trim(facture_.ORDRE),3,'0')||to_char(V_anneereel)||lpad(to_char(V_periode),2,'0')||to_char(facture_.version);
		    V_pdl_ref   := lpad(trim(facture_.DISTRICT),2,'0')||lpad(trim(facture_.tournee),3,'0')||lpad(trim(facture_.Ordre),3,'0')||lpad(trim(facture_.POLICE),5,'0');
			V_REF_ABN   := lpad(trim(facture_.DISTRICT),2,'0')||lpad(trim(facture_.POLICE),5,'0')||lpad(trim(facture_.tournee),3,'0')||lpad(trim(facture_.Ordre),3,'0') ;
		    V_TRAIN_FACT:='ANNEE:'||trim(V_anneereel)||' MOIS:'||trim(V_periode);
			select NTIERS,NSIXIEME
			into V_tiers,V_six
			from tourne
			where trim(code)=lpad(trim(facture_.tournee),3,'0')
			and  trim(district)=trim(facture_.DISTRICT);
            V_TRAIN_FACT :='ANNEE:'||trim(facture_.annee)||' TRIM:'||trim(facture_.periode)||' TIER:'||trim(V_tiers)||' SIX:'||trim(V_six );
		    BEGIN
				if lpad(trim(facture_.DISTRICT),2,'0')='57' then
					select g.org_id	
					into V_ORG_ID 
					from GENORGANIZATION g 
					where upper(g.org_code)='22';
				elsif lpad(trim(facture_.DISTRICT),2,'0')='58' then
					select g.org_id	
					into V_ORG_ID 
					from GENORGANIZATION g 
					where upper(g.org_code)='32';	
				elsif lpad(trim(facture_.DISTRICT),2,'0')='60' then
					select g.org_id	
					into V_ORG_ID 
					from GENORGANIZATION g 
					where upper(g.org_code)='36';			
				elsif lpad(trim(facture_.DISTRICT),2,'0')='61' then
					select g.org_id	
					into V_ORG_ID 
					from GENORGANIZATION g 
					where upper(g.org_code)='03';
				elsif lpad(trim(facture_.DISTRICT),2,'0')='63' then
					select g.org_id	
					into V_ORG_ID 
					from GENORGANIZATION g 
					where upper(g.org_code)='15';
				end if ;
			EXCEPTION WHEN OTHERS THEN 
				select g.org_id	
				into V_ORG_ID 
				from GENORGANIZATION g 
				where upper(g.org_code)=lpad(trim(facture_.DISTRICT),2,'0');
			END;	
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
		if v_nbr=0 then
			if facture_.etat='A' then 
--------------------------------------------------------Traitement Role
			If (V_anneereel is not null and V_periode is not null and V_TRAIN_FACT is not null) then			
				Begin
					select t.run_id
					into v_run_id
					from genrun t 
					where t.run_exercice=V_anneereel
					and run_number      =V_periode;
				EXCEPTION WHEN OTHERS THEN 			  
					select seq_genrun.nextval into v_run_id from dual;				
						insert into genrun (run_id,run_exercice,run_number,org_id,run_startdt,run_comment,RUN_NAME,RUN_DTCALC,RUN_ENDDT)
									values (v_run_id,V_anneereel,V_periode,V_org_id,V_FAC_DATECALCUL,'Role migré','Role '||V_TRAIN_FACT,V_FAC_DATECALCUL,V_FAC_DATECALCUL);
				end;    
			end if ; 
--------------------------------------------------------Traitement Det
					select seq_gendebt.nextval into Debt_Id  from dual; 
					V_deb_amount_cash  := -(facture_.DEB_AMOUNTINIT) ;
					V_DEB_AMOUNTINIT   := 0;
					V_VOW_DEBTYPE      := pk_genvocword.getidbycode('VOW_DEBTYPE','AV',null) ;
					V_DEB_AMOUNTREMAIN :=  facture_.DEB_AMOUNTREMAIN ;
					V_DEB_COMMENT      :=  facture_.DEB_COMMENT ;
					V_VOW_SETTLEMODE   := pk_genvocword.getidbycode('VOW_SETTLEMODE',4,null) ;
					V_DEB_NORECOVERY   := 0;
---------------------------------------------------------Traitement GENACCOUNT ,GENIMP
					Begin 
						select t.imp_id
						into V_IMP_ID
						from genimp t 
						where t.imp_code=V_COMPTEAUX;
					EXCEPTION WHEN OTHERS THEN 
						V_VOW_BUDGTP        :=  pk_genvocword.getidbycode('VOW_BUDGTP','EA',null);
						select seq_genimp.nextval  into V_IMP_ID  from dual;
						insert into genimp (imp_id,imp_code,imp_name,VOW_BUDGTP,org_id)
									 values(V_IMP_ID,V_COMPTEAUX,V_COMPTEAUX,V_VOW_BUDGTP,V_org_id);
					END;
					 
					begin 
						select t.aco_id 
						into V_ACO_ID
						from genaccount t
						where t.par_id=V_PAR_ID;
					exception when others then 
						V_VOW_ACOTP     :=  pk_genvocword.getidbycode('VOW_ACOTP','1',null);
						select seq_genaccount.nextval into V_ACO_ID from dual;
						insert into genaccount(aco_id,par_id,imp_id,VOW_ACOTP,rec_id)
										values(V_ACO_ID,V_PAR_ID,V_imp_id,V_VOW_ACOTP,null);
					end;				
					BEGIN	
						select t.sco_id
						into V_sco_id
						from agrsagaco t
						where t.aco_id=V_ACO_ID;
					EXCEPTION WHEN OTHERS THEN
						select seq_agrsagaco.nextval  into V_sco_id  from dual;
						insert into agrsagaco(sco_id,sag_id,aco_id,sco_startdt)
									   values(V_sco_id,V_SAG_ID,V_ACO_ID,V_ABN_DT_DEB);
					END;
					
						Insert into gendebt(deb_id,deb_refe,org_id,par_id,adr_id,deb_date,deb_duedt,deb_printdt,
											deb_amountinit,deb_amountremain,bap_id,VOW_SETTLEMODE,aco_id,deb_norecovery,deb_credt,
											deb_updtby,deb_updtdt,deb_comment,deb_amount_cash,sag_id,VOW_DEBTYPE,deb_prel)
									 values(V_Deb_ID,V_ID_FACTURE,V_ORG_ID,V_PAR_ID,V_ADR_ID,V_FAC_DATECALCUL,V_FAC_DATECALCUL,V_FAC_DATECALCUL,
											V_DEB_AMOUNTINIT,V_DEB_AMOUNTREMAIN,null,V_VOW_SETTLEMODE,V_ACO_ID,V_DEB_NORECOVERY,sysdate,
											null,null,V_DEB_COMMENT,nvl(V_deb_amount_cash,0),V_SAG_ID,V_VOW_DEBTYPE,1);	
				    commit;
--------------------------------------------------------Traitement agrbill
				    select seq_agrbill.nextval into V_BIL_ID from dual;
			        V_VOW_AGRBILLTYPE   :=  pk_genvocword.getidbycode('VOW_AGRBILLTYPE','FA',null) ;
					v_VOW_MODEFACT      :=  pk_genvocword.getidbycode('VOW_MODEFACT',4,null);--------NB:(4 ou MIG) a verifier
					   Insert into agrbill (BIL_ID,SAG_ID,VOW_AGRBILLTYPE,VOW_MODEFACT)
									values (V_BIL_ID,V_SAG_ID,V_VOW_AGRBILLTYPE,v_VOW_MODEFACT);
--------------------------------------------------------Traitement genbill
					V_BIL_AMOUNTHT      :=  -(facture_.BIL_AMOUNTHT);
					V_BIL_AMOUNTTVA     :=  -(facture_.BIL_AMOUNTTVA) ;
					V_BIL_AMOUNTTTC     :=  -(facture_.BIL_AMOUNTTTC);
					V_BIL_STATUS        :=  1;
							Insert into genbill(BIL_ID,BIL_CODE,BIL_CALCDT,BIL_AMOUNTHT,BIL_AMOUNTTVA,BIL_AMOUNTTTC,
							                    DEB_ID,PAR_ID,BIL_STATUS,BIL_AMOUNTTTCDEC,BIL_DEBTDT,RUN_ID)
										 values(V_BIL_ID,V_ID_FACTURE,V_FAC_DATECALCUL,V_BIL_AMOUNTHT,V_BIL_AMOUNTTVA,V_BIL_AMOUNTTTC,
												V_Deb_ID,V_PAR_ID,V_BIL_STATUS,V_AMOUNTTTCDEC,V_FAC_DATECALCUL,v_run_id); 
							commit; 
                    v := 0;
                    for c in (select * from genbilline e  where e.bil_id=facture_.bil_id)loop
				        v := v+1;
							V_PTA_ID := null;
							V_PSL_RANK := null;
							begin
								select t.ite_id,t.ite_name,VOW_UNIT
								into V_ITE_ID,V_ite_name,V_VOW_UNIT
								from genitem t 
								where t.ite_id=c.ite_id;  
							EXCEPTION WHEN NO_DATA_FOUND THEN NULL;
							end;
							begin
							   V_TVA_ID:=c.tva_id;
							EXCEPTION WHEN NO_DATA_FOUND THEN 
							V_TVA_ID := 25;
							end;
							select count(*) 
							into V_nbr 
							from genptaslice 
							where PTA_ID in (select PTA_ID from genitemperiodtarif 
											 where TAR_id in (select tar_id from genitemtarif where ITE_ID=V_ITE_ID ));
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
								where PTA_ID in (select PTA_ID 
											 from genitemperiodtarif
											 where TAR_id in (select tar_id from genitemtarif where ITE_ID=V_ITE_ID) 
											)
								and rownum=1;
						    end if;	
			                BEGIN
								INSERT INTO genbilline(BIL_ID,BLI_REVERSEBLI_ID,BLI_NUMBER,BLI_REVERSEBLINUMBER,BLI_NAME,BLI_EXERCICE,ITE_ID,PTA_ID,PSL_RANK,IMP_ID,BLI_VOLUMEBASE,BLI_VOLUMEFACT,
													   BLI_PUHT,TVA_ID,BLI_MHT,BLI_MTTVA,BLI_MTTC,BLI_STARTDT,BLI_ENDDT,VOW_UNIT,BLI_NBUNITES,BLI_DETAIL,BLI_CANCEL,IMC_ID,IMP_ANALYTIQUE_ID,
													   BLI_PERIODEINIT,BLI_PERIODE,BLI_REVERSEDT,BLI_CREDT,BLI_UPDTDT,BLI_UPDTBY,MEU_ID,BLI_NAME_A,BLI_REVERSEBLIDEC_ID,BLI_REVERSEBLINUMBERDEC,BLI_REVERSEDECDT)
												VALUES(V_BIL_ID,null,v,null,V_ite_name,V_anneereel,V_ITE_ID,V_PTA_ID,V_PSL_RANK,null,c.BLI_VOLUMEBASE,c.BLI_VOLUMEBASE,c.BLI_PUHT,V_TVA_ID,
													   c.BLI_MHT,c.BLI_MTTVA,c.BLI_MTTC,V_FAC_DATECALCUL,V_FAC_DATECALCUL,V_VOW_UNIT,null,0,0,null,
													   null,null,null,null,null,null,null,null,null,null,null,null);
							EXCEPTION WHEN OTHERS THEN
									BEGIN
											insert into genbilline(BIL_ID,BLI_REVERSEBLI_ID,BLI_NUMBER,BLI_REVERSEBLINUMBER,BLI_NAME,BLI_EXERCICE,ITE_ID,PTA_ID,PSL_RANK,IMP_ID,BLI_VOLUMEBASE,BLI_VOLUMEFACT,
																   BLI_PUHT,TVA_ID,BLI_MHT,BLI_MTTVA,BLI_MTTC,BLI_STARTDT,BLI_ENDDT,VOW_UNIT,BLI_NBUNITES,BLI_DETAIL,BLI_CANCEL,IMC_ID,IMP_ANALYTIQUE_ID,
																   BLI_PERIODEINIT,BLI_PERIODE,BLI_REVERSEDT,BLI_CREDT,BLI_UPDTDT,BLI_UPDTBY,MEU_ID,BLI_NAME_A,BLI_REVERSEBLIDEC_ID,BLI_REVERSEBLINUMBERDEC,BLI_REVERSEDECDT)
															values(V_BIL_ID,null,v+1,null,V_ite_name,V_anneereel,V_ITE_ID,V_PTA_ID,V_PSL_RANK,null,c.BLI_VOLUMEBASE,c.BLI_VOLUMEBASE,c.BLI_PUHT,V_TVA_ID,
																   c.BLI_MHT,c.BLI_MTTVA,c.BLI_MTTC,V_FAC_DATECALCUL,V_FAC_DATECALCUL,V_VOW_UNIT,null,0,0,null,
																   null,null,null,null,null,null,null,null,null,null,null,null);
									EXCEPTION WHEN OTHERS THEN NULL;
									END;
							END;
			        end loop;
			 
			else 
				    
--------------------------------------------------------Traitement Role
			If (V_anneereel is not null and V_periode is not null and V_TRAIN_FACT is not null) then			
				Begin
					select t.run_id
					into v_run_id
					from genrun t 
					where t.run_exercice=V_anneereel
					and run_number      =V_periode;
				EXCEPTION WHEN OTHERS THEN 			  
					select seq_genrun.nextval into v_run_id from dual;				
						insert into genrun (run_id,run_exercice,run_number,org_id,run_startdt,run_comment,RUN_NAME,RUN_DTCALC,RUN_ENDDT)
									values (v_run_id,V_anneereel,V_periode,V_org_id,V_FAC_DATECALCUL,'Role migré','Role '||V_TRAIN_FACT,V_FAC_DATECALCUL,V_FAC_DATECALCUL);
				end;    
			end if ; 
--------------------------------------------------------Traitement Det
				select seq_gendebt.nextval into Debt_Id  from dual; 
					If (V_TOTHTE+V_TVA+V_TOTHTA+ V_TOTTVAA) > 0 then --- Facture Normal else Facture Avoire
						V_DEB_AMOUNTINIT   :=  V_TOTHTE+V_TVA+V_TOTHTA+V_TOTTVAA;
						V_deb_amount_cash  := V_TOTHTE+V_TVA+V_TOTHTA+V_TOTTVAA;
						V_VOW_DEBTYPE      := pk_genvocword.getidbycode('VOW_DEBTYPE','FA',null);
					else
						V_deb_amount_cash  := -(V_TOTHTE+V_TVA+V_TOTHTA+V_TOTTVAA) ;
						V_DEB_AMOUNTINIT   := 0;
						V_VOW_DEBTYPE      := pk_genvocword.getidbycode('VOW_DEBTYPE','AV',null);
					end if ;
					V_DEB_AMOUNTREMAIN :=  V_SOLDE ;
					V_DEB_COMMENT      :=  V_REF_ABN ;
					V_VOW_SETTLEMODE   := pk_genvocword.getidbycode('VOW_SETTLEMODE',4,null);
					V_DEB_NORECOVERY   := 0;
--------------------------------------------------------Traitement GENACCOUNT ,GENIMP
					Begin 
						select t.imp_id
						into V_IMP_ID
						from genimp t 
						where t.imp_code=V_COMPTEAUX;
					EXCEPTION WHEN OTHERS THEN 
						V_VOW_BUDGTP        :=  pk_genvocword.getidbycode('VOW_BUDGTP','EA',null);
						select seq_genimp.nextval  into V_IMP_ID  from dual;
						insert into genimp (imp_id,imp_code,imp_name,vow_budgtp,org_id)
									 values(V_IMP_ID,V_COMPTEAUX,V_COMPTEAUX,V_VOW_BUDGTP,V_org_id);
					END;
					 
					BEGIN 
						select t.aco_id 
						into V_ACO_ID
						from genaccount t
						where t.par_id=V_PAR_ID;
					EXCEPTION WHEN OTHERS THEN 
						V_VOW_ACOTP     :=  pk_genvocword.getidbycode('VOW_ACOTP','1',null);
						select seq_genaccount.nextval into V_ACO_ID from dual;
						insert into genaccount(aco_id,par_id,imp_id,VOW_ACOTP,rec_id)
										values(V_ACO_ID,V_PAR_ID,V_imp_id,V_VOW_ACOTP,null);
					END;				
					BEGIN	
						select t.sco_id
						into V_sco_id
						from agrsagaco t
						where t.aco_id=V_ACO_ID;
					EXCEPTION WHEN OTHERS THEN
						select seq_agrsagaco.nextval  into V_sco_id  from dual;
						insert into agrsagaco(sco_id,sag_id,aco_id,sco_startdt)
									   values(V_sco_id,V_SAG_ID,V_ACO_ID,V_ABN_DT_DEB);
					END;
						Insert into gendebt(deb_id,deb_refe,org_id,par_id,adr_id,deb_date,deb_duedt,deb_printdt,
											deb_amountinit,deb_amountremain,bap_id,VOW_SETTLEMODE,aco_id,deb_norecovery,deb_credt,
											deb_updtby,deb_updtdt,deb_comment,deb_amount_cash,sag_id,vow_debtype,deb_prel)
									values (V_Deb_ID,V_ID_FACTURE,V_ORG_ID,V_PAR_ID,V_ADR_ID,V_FAC_DATECALCUL,V_FAC_DATECALCUL,V_FAC_DATECALCUL,
											V_DEB_AMOUNTINIT,V_DEB_AMOUNTREMAIN,null,V_VOW_SETTLEMODE,V_ACO_ID,V_DEB_NORECOVERY,sysdate,
											null,null,V_DEB_COMMENT,nvl(V_deb_amount_cash,0),V_SAG_ID,V_VOW_DEBTYPE,1);	
--------------------------------------------------------Traitement agrbill
					V_VOW_AGRBILLTYPE   :=  pk_genvocword.getidbycode('VOW_AGRBILLTYPE',decode(facture_.etat,'P','RF','O','FC','C','FHC','FC'),null) ;
					V_VOW_MODEFACT      :=  pk_genvocword.getidbycode('VOW_MODEFACT',4,null);--------NB:(4 ou MIG) a verifier
						Insert into agrbill(BIL_ID,SAG_ID,VOW_AGRBILLTYPE,VOW_MODEFACT)
									 values(V_BIL_ID,V_SAG_ID,V_VOW_AGRBILLTYPE,v_VOW_MODEFACT);	
							commit;
--------------------------------------------------------Traitement genbill
                    select seq_agrbill.nextval into V_BIL_ID from dual; 
					V_BIL_AMOUNTHT      :=  V_TOTHTE +V_TOTHTA ;
					V_BIL_AMOUNTTVA     :=  V_TVA+V_TOTTVAA ;
					V_BIL_AMOUNTTTC     :=  V_TOTHTE +V_TVA+V_TOTHTA+V_TOTTVAA ;
					V_BIL_STATUS        :=  1;
						Insert into genbill(BIL_ID,BIL_CODE,BIL_CALCDT,BIL_AMOUNTHT,BIL_AMOUNTTVA,BIL_AMOUNTTTC,
						                    DEB_ID,PAR_ID,BIL_STATUS,BIL_AMOUNTTTCDEC,BIL_DEBTDT,RUN_ID)
									 values(V_BIL_ID,V_ID_FACTURE,V_FAC_DATECALCUL,V_BIL_AMOUNTHT,V_BIL_AMOUNTTVA,V_BIL_AMOUNTTTC,
											V_Deb_ID,V_PAR_ID,V_BIL_STATUS,V_AMOUNTTTCDEC,V_FAC_DATECALCUL,v_run_id); 
						COMMIT;
			end if;
		end if; 
        end loop;  
    end loop;
-----------------------------------------------------------------------------------------
-----------FACTURE_IMPAYEE--------------FACTURE_IMPAYEE-----------FACTURE_IMPAYEE--------
-----------------------------------------------------------------------------------------
-----------IMPAYEE PART
    FOR facture_ in fact_IMPPART LOOP
	    FOR x in branch_(lpad(trim(facture_.DIST), 2, '0'),lpad(trim(facture_.TOU), 3, '0'),lpad(trim(facture_.ORD), 3, '0'))LOOP	
		    V_FAC_RESTANTDU  := null;
			V_FAC_DATECALCUL := null;
			V_FAC_ABN_NUM    := null;
			V_REF_ABN        := null;
			V_periode  := facture_.trimestre;
            V_anneereel :=facture_.ANNEE;
			select last_day(to_date('01'||lpad(facture_.trimestre,2,0)||facture_.annee,'ddmmyy')) 
			into v_date
			from dual;
			BEGIN
			V_FAC_DATECALCUL := v_date;
			EXCEPTION WHEN OTHERS THEN
			V_FAC_DATECALCUL := '01/01/2016';
			END;
			V_FAC_DATELIM:= V_FAC_DATECALCUL+25;
		    v_ID_FACTURE :=lpad(trim(facture_.DISTRICT),2,'0')||lpad(trim(facture_.tournee),3,'0')||lpad(trim(facture_.ORDRE),3,'0')||to_char(annee_)||lpad(to_char(periode_),2,'0')||'0';
            V_TRAIN_FACT :='ANNEE:'||trim(annee_)||' MOIS:'||trim(periode_);
            V_pdl_ref    :=lpad(trim(facture_.DISTRICT),2,'0')||lpad(trim(facture_.tournee),3,'0')||lpad(trim(facture_.ordre),3,'0')||lpad(trim(facture_.police),5,'0');
            V_REF_ABN    :=lpad(trim(facture_.DISTRICT),2,'0')||lpad(trim(facture_.police),5,'0')||lpad(trim(facture_.tournee),3,'0')||lpad(trim(facture_.ordre),3,'0') ;
		    
			select count(*) into V_NBR from genbill b where b.BIL_CODE=V_ID_FACTURE;
			if v_nbr=0 then 
				BEGIN
					if lpad(trim(facture_.DISTRICT),2,'0')='57' then
						select g.org_id	
						into V_ORG_ID 
						from GENORGANIZATION g 
						where upper(g.org_code)='22';
					elsif lpad(trim(facture_.DISTRICT),2,'0')='58' then
						select g.org_id	
						into V_ORG_ID 
						from GENORGANIZATION g 
						where upper(g.org_code)='32';	
					elsif lpad(trim(facture_.DISTRICT),2,'0')='60' then
						select g.org_id	
						into V_ORG_ID 
						from GENORGANIZATION g 
						where upper(g.org_code)='36';			
					elsif lpad(trim(facture_.DISTRICT),2,'0')='61' then
						select g.org_id	
						into V_ORG_ID 
						from GENORGANIZATION g 
						where upper(g.org_code)='03';
					elsif lpad(trim(facture_.DISTRICT),2,'0')='63' then
						select g.org_id	
						into V_ORG_ID 
						from GENORGANIZATION g 
						where upper(g.org_code)='15';
					end if ;
				EXCEPTION WHEN OTHERS THEN 
					select g.org_id	
					into V_ORG_ID 
					from GENORGANIZATION g 
					where upper(g.org_code)=lpad(trim(facture_.DISTRICT),2,'0');
				END;	
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
				
				V_COMPTEAUX:='IMP_MIG'			   
				V_TOTHTE :=(to_number(trim(facture_.net)))/1000;
				V_TVA    :=0
				V_TOTHTA :=0;
				V_TOTTVAA:=0;
				V_SOLDE:=(to_number(trim(facture_.net)))/1000;
				  
 --------------------------------------------------------Traitement Role
				If (V_anneereel is not null and V_periode is not null and V_TRAIN_FACT is not null) then			
				Begin
					select t.run_id
					into v_run_id
					from genrun t 
					where t.run_exercice=V_anneereel
					and run_number      =V_periode;
				EXCEPTION WHEN OTHERS THEN 			  
					select seq_genrun.nextval into v_run_id from dual;				
						insert into genrun (run_id,run_exercice,run_number,org_id,run_startdt,run_comment,RUN_NAME,RUN_DTCALC,RUN_ENDDT)
									values (v_run_id,V_anneereel,V_periode,V_org_id,V_FAC_DATECALCUL,'Role migré','Role '||V_TRAIN_FACT,V_FAC_DATECALCUL,V_FAC_DATECALCUL);
				end;    
			end if ; 
--------------------------------------------------------Traitement Det
			    select seq_gendebt.nextval into Debt_Id from dual;
			
				If (V_TOTHTE+V_TVA+V_TOTHTA+V_TOTTVAA)>0 then --- Facture Normal else Facture Avoire
				  V_DEB_AMOUNTINIT   :=  V_TOTHTE+ V_TVA+V_TOTHTA+V_TOTTVAA ;
				  V_VOW_DEBTYPE      := pk_genvocword.getidbycode('VOW_DEBTYPE','FA',null) ;
				else
					V_deb_amount_cash  := -(V_TOTHTE+V_TVA+V_TOTHTA+V_TOTTVAA) ;
					V_DEB_AMOUNTINIT   := 0;
					V_VOW_DEBTYPE      := pk_genvocword.getidbycode('VOW_DEBTYPE','AV',null) ;
				end if ;
				V_DEB_AMOUNTREMAIN := V_SOLDE ;
				V_DEB_COMMENT      := V_REF_ABN ;
				V_VOW_SETTLEMODE   := pk_genvocword.getidbycode('VOW_SETTLEMODE',4,null) ;
				V_DEB_NORECOVERY   := 0;
----------------------------------------------------------Traitement GENACCOUNT ,GENIMP
				Begin 
					select t.imp_id
					into V_IMP_ID
					from genimp t 
					where t.imp_code=V_COMPTEAUX;
				EXCEPTION WHEN OTHERS THEN 
						V_VOW_BUDGTP        :=  pk_genvocword.getidbycode('VOW_BUDGTP','EA',null);
						select seq_genimp.nextval  into V_IMP_ID  from dual;
						insert into genimp (imp_id,imp_code,imp_name,vow_budgtp,org_id)
									 values(V_IMP_ID,V_COMPTEAUX,V_COMPTEAUX,V_VOW_BUDGTP,V_org_id);
				END;
				  
				begin 
					select t.aco_id 
					into V_ACO_ID
					from genaccount t
					where t.par_id=V_PAR_ID;
                exception when others then 
					V_VOW_ACOTP     :=  pk_genvocword.getidbycode('VOW_ACOTP','1',null);
					select seq_genaccount.nextval into V_ACO_ID from dual;
					insert into genaccount(aco_id,par_id,imp_id,VOW_ACOTP,rec_id)
									values(V_ACO_ID,V_PAR_ID,V_imp_id,V_VOW_ACOTP,null);
				end;				
				BEGIN	
					select t.sco_id
					into V_sco_id
					from agrsagaco t
					where t.aco_id=V_ACO_ID;
				EXCEPTION WHEN OTHERS THEN
					select seq_agrsagaco.nextval  into V_sco_id  from dual;
					insert into agrsagaco(sco_id,sag_id,aco_id,sco_startdt)
								   values(V_sco_id,V_SAG_ID,V_ACO_ID,V_ABN_DT_DEB);
				END;
				    Insert into gendebt(deb_id,deb_refe,org_id,par_id,adr_id,deb_date,deb_duedt,deb_printdt,
									    deb_amountinit,deb_amountremain,bap_id,VOW_SETTLEMODE,aco_id,deb_norecovery,deb_credt,
									    deb_updtby,deb_updtdt,deb_comment,deb_amount_cash,sag_id,VOW_DEBTYPE,deb_prel)
								values(V_Deb_ID,V_ID_FACTURE,V_ORG_ID,V_PAR_ID,V_ADR_ID,V_FAC_DATECALCUL,V_FAC_DATELIM,V_FAC_DATECALCUL,
									   V_DEB_AMOUNTINIT,V_DEB_AMOUNTREMAIN,null,V_VOW_SETTLEMODE,V_ACO_ID,V_DEB_NORECOVERY,sysdate,
									   null,null,V_DEB_COMMENT,nvl(V_deb_amount_cash,0),V_SAG_ID,V_VOW_DEBTYPE,1);	
							commit;
--------------------------------------------------------Traitement agrbill
				select seq_agrbill.nextval into V_BIL_ID from dual; 
				V_VOW_AGRBILLTYPE   :=  pk_genvocword.getidbycode('VOW_AGRBILLTYPE','FC',null) ;
				v_VOW_MODEFACT      :=  pk_genvocword.getidbycode('VOW_MODEFACT',4,null);--------NB:(4 ou MIG) a verifier
					Insert into agrbill(BIL_ID,SAG_ID,VOW_AGRBILLTYPE,VOW_MODEFACT)
								 values(V_BIL_ID,V_SAG_ID,V_VOW_AGRBILLTYPE,V_VOW_MODEFACT);	
					commit;
--------------------------------------------------------Traitement genbill
				V_BIL_AMOUNTHT      :=  V_TOTHTE +V_TOTHTA ;
				V_BIL_AMOUNTTVA     :=  V_TOTTVAE+V_TOTTVAA ;
				V_BIL_AMOUNTTTC     :=  V_TOTHTE+V_TVA+V_TOTHTA+V_TOTTVAA;
				V_BIL_STATUS        :=  1;
					Insert into genbill(BIL_ID,BIL_CODE,BIL_CALCDT,BIL_AMOUNTHT,BIL_AMOUNTTVA,BIL_AMOUNTTTC,
					                    DEB_ID,PAR_ID,BIL_STATUS,BIL_AMOUNTTTCDEC,BIL_DEBTDT,RUN_ID)
								 values(V_BIL_ID,V_ID_FACTURE,V_FAC_DATECALCUL,V_BIL_AMOUNTHT,V_BIL_AMOUNTTVA,V_BIL_AMOUNTTTC,
									    V_Deb_ID,V_PAR_ID,V_BIL_STATUS,V_AMOUNTTTCDEC,V_FAC_DATECALCUL,v_run_id); 
					commit; 
-------------------------------------------------------------------------------------------
--------------------------ARTICLE DE REPRISE SONEDE----------------------------------------
-------------------------------------------------------------------------------------------							
			    v := 0;		
	            v := v+1;
				V_PTA_ID := null;
				V_PSL_RANK := null;
				V_BLI_MHT  := null;
				BEGIN
				v_code:='REPRISE-SONEDE';
					for x in C_ITEM(v_code) loop
					V_ITE_ID:=x.ite_id;
					V_ite_name:=x.ite_name
					V_VOW_UNIT:=x.VOW_UNIT
					end loop;
				EXCEPTION WHEN NO_DATA_FOUND THEN NULL;
				END;
				BEGIN
				v_tva_taux:= 0;
					FOR v in C_TVA(v_tva_taux) LOOP
					   V_TVA_ID:=v.tva_id; 
					END LOOP;
				EXCEPTION WHEN NO_DATA_FOUND THEN 
				V_TVA_ID := 25;
				END;
				select count(*) 
				into V_nbr 
				from genptaslice 
				where PTA_ID in (select PTA_ID from genitemperiodtarif 
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
				if V_nbr>1 then
					select PTA_ID,PSL_RANK  
					into V_PTA_ID,V_PSL_RANK 
					from genptaslice 
					where PTA_ID in (select PTA_ID 
									 from genitemperiodtarif
									 where TAR_id in (select tar_id from genitemtarif where ITE_ID=V_ITE_ID) 
									)
					and rownum=1;
				end if;	
                 V_BLI_MHT:=(to_number(trim(facture_.net))-to_number(trim(facture_.mtonas)))/1000;
				BEGIN
					INSERT INTO genbilline(BIL_ID,BLI_REVERSEBLI_ID,BLI_NUMBER,BLI_REVERSEBLINUMBER,BLI_NAME,BLI_EXERCICE,ITE_ID,PTA_ID,PSL_RANK,IMP_ID,BLI_VOLUMEBASE,BLI_VOLUMEFACT,
										   BLI_PUHT,TVA_ID,BLI_MHT,BLI_MTTVA,BLI_MTTC,BLI_STARTDT,BLI_ENDDT,VOW_UNIT,BLI_NBUNITES,BLI_DETAIL,BLI_CANCEL,IMC_ID,IMP_ANALYTIQUE_ID,
										   BLI_PERIODEINIT,BLI_PERIODE,BLI_REVERSEDT,BLI_CREDT,BLI_UPDTDT,BLI_UPDTBY,MEU_ID,BLI_NAME_A,BLI_REVERSEBLIDEC_ID,BLI_REVERSEBLINUMBERDEC,BLI_REVERSEDECDT)
								   VALUES(V_BIL_ID,null,v,null,V_ite_name,V_anneereel,V_ITE_ID,V_PTA_ID,V_PSL_RANK,null,0,0,0,V_TVA_ID,
										  V_BLI_MHT,0,V_BLI_MHT,V_FAC_DATECALCUL,V_FAC_DATECALCUL,V_VOW_UNIT,null,0,0,null,
										  null,null,null,null,null,null,null,null,null,null,null,null);
				EXCEPTION WHEN OTHERS THEN
									BEGIN
										INSERT INTO genbilline(BIL_ID,BLI_REVERSEBLI_ID,BLI_NUMBER,BLI_REVERSEBLINUMBER,BLI_NAME,BLI_EXERCICE,ITE_ID,PTA_ID,PSL_RANK,IMP_ID,BLI_VOLUMEBASE,BLI_VOLUMEFACT,
															   BLI_PUHT,TVA_ID,BLI_MHT,BLI_MTTVA,BLI_MTTC,BLI_STARTDT,BLI_ENDDT,VOW_UNIT,BLI_NBUNITES,BLI_DETAIL,BLI_CANCEL,IMC_ID,IMP_ANALYTIQUE_ID,
															   BLI_PERIODEINIT,BLI_PERIODE,BLI_REVERSEDT,BLI_CREDT,BLI_UPDTDT,BLI_UPDTBY,MEU_ID,BLI_NAME_A,BLI_REVERSEBLIDEC_ID,BLI_REVERSEBLINUMBERDEC,BLI_REVERSEDECDT)
													   VALUES(V_BIL_ID,null,v+1,null,V_ite_name,V_anneereel,V_ITE_ID,V_PTA_ID,V_PSL_RANK,null,0,0,0,V_TVA_ID,
															  V_BLI_MHT,0,V_BLI_MHT,V_FAC_DATECALCUL,V_FAC_DATECALCUL,V_VOW_UNIT,null,0,0,null,
															  null,null,null,null,null,null,null,null,null,null,null,null);
									EXCEPTION WHEN OTHERS THEN NULL;
									END;
				END;
-------------------------------------------------------------------------------------------
----------------------------ARTICLE DE REPRISE ONAS----------------------------------------
-------------------------------------------------------------------------------------------		
	            v := v+1;
				V_PTA_ID := null;
				V_PSL_RANK := null;
				V_BLI_MHT  := null;
				begin
				v_code:='REPRISE-ONAS';
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
					   V_TVA_ID:=v.tva_id; 
					end loop;
				EXCEPTION WHEN NO_DATA_FOUND THEN 
				V_TVA_ID := 25;
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
				if V_nbr>1 then
					select PTA_ID,PSL_RANK  
					into   V_PTA_ID,V_PSL_RANK 
					from genptaslice 
					where PTA_ID in (select PTA_ID 
									 from genitemperiodtarif
									 where TAR_id in (select tar_id from genitemtarif where ITE_ID=V_ITE_ID) 
									)
					and rownum=1;
				end if;	
                V_BLI_MHT:= (to_number(trim(facture_.mtonas))/1000);		
                BEGIN
					INSERT INTO genbilline(BIL_ID,BLI_REVERSEBLI_ID,BLI_NUMBER,BLI_REVERSEBLINUMBER,BLI_NAME,BLI_EXERCICE,ITE_ID,PTA_ID,PSL_RANK,IMP_ID,BLI_VOLUMEBASE,BLI_VOLUMEFACT,
										   BLI_PUHT,TVA_ID,BLI_MHT,BLI_MTTVA,BLI_MTTC,BLI_STARTDT,BLI_ENDDT,VOW_UNIT,BLI_NBUNITES,BLI_DETAIL,BLI_CANCEL,IMC_ID,IMP_ANALYTIQUE_ID,
										   BLI_PERIODEINIT,BLI_PERIODE,BLI_REVERSEDT,BLI_CREDT,BLI_UPDTDT,BLI_UPDTBY,MEU_ID,BLI_NAME_A,BLI_REVERSEBLIDEC_ID,BLI_REVERSEBLINUMBERDEC,BLI_REVERSEDECDT)
								    values(V_BIL_ID,null,v,null,V_ite_name,V_anneereel,V_ITE_ID,V_PTA_ID,V_PSL_RANK,null,0,0,0,V_TVA_ID,
										   V_BLI_MHT,0,V_BLI_MHT,V_FAC_DATECALCUL,V_FAC_DATECALCUL,V_VOW_UNIT,null,0,0,null,
										   null,null,null,null,null,null,null,null,null,null,null,null);
				EXCEPTION WHEN OTHERS THEN
									BEGIN
										INSERT INTO genbilline(BIL_ID,BLI_REVERSEBLI_ID,BLI_NUMBER,BLI_REVERSEBLINUMBER,BLI_NAME,BLI_EXERCICE,ITE_ID,PTA_ID,PSL_RANK,IMP_ID,BLI_VOLUMEBASE,BLI_VOLUMEFACT,
															   BLI_PUHT,TVA_ID,BLI_MHT,BLI_MTTVA,BLI_MTTC,BLI_STARTDT,BLI_ENDDT,VOW_UNIT,BLI_NBUNITES,BLI_DETAIL,BLI_CANCEL,IMC_ID,IMP_ANALYTIQUE_ID,
															   BLI_PERIODEINIT,BLI_PERIODE,BLI_REVERSEDT,BLI_CREDT,BLI_UPDTDT,BLI_UPDTBY,MEU_ID,BLI_NAME_A,BLI_REVERSEBLIDEC_ID,BLI_REVERSEBLINUMBERDEC,BLI_REVERSEDECDT)
													    VALUES(V_BIL_ID,null,v+1,null,V_ite_name,V_anneereel,V_ITE_ID,V_PTA_ID,V_PSL_RANK,null,0,0,0,V_TVA_ID,
															   V_BLI_MHT,0,V_BLI_MHT,V_FAC_DATECALCUL,V_FAC_DATECALCUL,V_VOW_UNIT,null,0,0,null,
															   null,null,null,null,null,null,null,null,null,null,null,null);
									EXCEPTION WHEN OTHERS THEN NULL;
									END;
				END;
			end if;
		end loop;	
    end loop;
-----------------------------	
-----------IMPAYEE GC
-----------------------------
    FOR facture_ in fact_IMPGC LOOP
	
	    FOR x in branch_(lpad(facture_.DIST, 2, '0'),lpad(trim(facture_.TOU), 3, '0'),lpad(trim(facture_.ORD), 3, '0'))LOOP	
		    V_FAC_RESTANTDU  := null;
			V_FAC_DATECALCUL := null;
			V_FAC_ABN_NUM    := null;
			V_REF_ABN        := null;
			V_periode        := facture_.mois;
            V_anneereel      := facture_.ANNEE;
			select last_day(to_date('01'||lpad(facture_.mois,2,0)||facture_.annee,'ddmmyy')) 
			into v_date
			from dual;
			BEGIN
			 V_FAC_DATECALCUL := v_date;
			EXCEPTION WHEN OTHERS THEN
			 V_FAC_DATECALCUL := '01/01/2016';
			END;
			V_FAC_DATELIM:= V_FAC_DATECALCUL+25;
		    v_ID_FACTURE :=lpad(trim(facture_.DISTRICT),2,'0')||lpad(trim(facture_.tournee),3,'0')||lpad(trim(facture_.ORDRE),3,'0')||to_char(annee_)||lpad(to_char(periode_),2,'0')||'0';
            V_TRAIN_FACT :='ANNEE:'||trim(annee_)||' MOIS:'||trim(periode_);
            V_pdl_ref    :=lpad(trim(facture_.DISTRICT),2,'0')||lpad(trim(facture_.tournee),3,'0')||lpad(trim(facture_.ordre),3,'0')||lpad(trim(facture_.police),5,'0');
            V_REF_ABN    :=lpad(trim(facture_.DISTRICT),2,'0')||lpad(trim(facture_.police),5,'0')||lpad(trim(facture_.tournee),3,'0')||lpad(trim(facture_.ordre),3,'0') ;
		    
			select count(*) into v_nbr from genbill b where b.BIL_CODE=V_ID_FACTURE;
			if v_nbr=0 then 
				BEGIN
					if lpad(trim(facture_.DISTRICT),2,'0')='57' then
						select g.org_id	
						into V_ORG_ID 
						from GENORGANIZATION g 
						where upper(g.org_code)='22';
					elsif lpad(trim(facture_.DISTRICT),2,'0')='58' then
						select g.org_id	
						into V_ORG_ID 
						from GENORGANIZATION g 
						where upper(g.org_code)='32';	
					elsif lpad(trim(facture_.DISTRICT),2,'0')='60' then
						select g.org_id	
						into V_ORG_ID 
						from GENORGANIZATION g 
						where upper(g.org_code)='36';			
					elsif lpad(trim(facture_.DISTRICT),2,'0')='61' then
						select g.org_id	
						into V_ORG_ID 
						from GENORGANIZATION g 
						where upper(g.org_code)='03';
					elsif lpad(trim(facture_.DISTRICT),2,'0')='63' then
						select g.org_id	
						into V_ORG_ID 
						from GENORGANIZATION g 
						where upper(g.org_code)='15';
					end if ;
				EXCEPTION WHEN OTHERS THEN 
					select g.org_id	
					into V_ORG_ID 
					from GENORGANIZATION g 
					where upper(g.org_code)=lpad(trim(facture_.DISTRICT),2,'0');
				END;	
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
				V_TOTHTE:=(to_number(trim(facture_.net)))/1000;
				V_TVA:=0;
				V_TOTHTA:=0;
				V_TOTTVAA:=0;
				V_SOLDE:=(to_number(trim(facture_.net)))/1000;
				
--------------------------------------------------------Traitement Role
				If (V_anneereel is not null and V_periode is not null and V_TRAIN_FACT is not null) then			
				Begin
					select t.run_id
					into v_run_id
					from genrun t 
					where t.run_exercice=V_anneereel
					and run_number      =V_periode;
				EXCEPTION WHEN OTHERS THEN 			  
					select seq_genrun.nextval into v_run_id from dual;				
						insert into genrun (run_id,run_exercice,run_number,org_id,run_startdt,run_comment,RUN_NAME,RUN_DTCALC,RUN_ENDDT)
									values (v_run_id,V_anneereel,V_periode,V_org_id,V_FAC_DATECALCUL,'Role migré','Role '||V_TRAIN_FACT,V_FAC_DATECALCUL,V_FAC_DATECALCUL);
				end;    
			end if ; 
--------------------------------------------------------Traitement Det
			select seq_gendebt.nextval  into V_Deb_ID  from dual;
			    If (V_TOTHTE+V_TVA+V_TOTHTA+V_TOTTVAA) > 0 then --- Facture Normal else Facture Avoire
				    V_DEB_AMOUNTINIT   :=  V_TOTHTE+ V_TVA+V_TOTHTA+V_TOTTVAA ;
				    V_VOW_DEBTYPE      := pk_genvocword.getidbycode('VOW_DEBTYPE','FA',null) ;
				else
					V_DEB_AMOUNT_CASH  := -(V_TOTHTE+V_TVA+V_TOTHTA+V_TOTTVAA) ;
					V_DEB_AMOUNTINIT   := 0;
					V_VOW_DEBTYPE      := pk_genvocword.getidbycode('VOW_DEBTYPE','AV',null) ;
				end if ;
				V_DEB_AMOUNTREMAIN := V_SOLDE ;
				V_DEB_COMMENT      := V_REF_ABN ;
				V_VOW_SETTLEMODE   := pk_genvocword.getidbycode('VOW_SETTLEMODE',4,null) ;
				V_DEB_NORECOVERY   := 0;
----------------------------------------------------------Traitement GENACCOUNT ,GENIMP
				Begin 
						select t.imp_id
						into V_IMP_ID
						from genimp t 
						where t.imp_code=V_COMPTEAUX;
					EXCEPTION WHEN OTHERS THEN 
						V_VOW_BUDGTP        :=  pk_genvocword.getidbycode('VOW_BUDGTP','EA',null);
						select seq_genimp.nextval  into V_IMP_ID  from dual;
						insert into genimp (imp_id,imp_code,imp_name,vow_budgtp,org_id)
									 values(V_IMP_ID,V_COMPTEAUX,V_COMPTEAUX,V_VOW_BUDGTP,V_org_id);
					END;
				BEGIN 
					select t.aco_id 
					into V_ACO_ID
					from genaccount t
					where t.par_id=V_PAR_ID;
                EXCEPTION WHEN OTHERS THEN 
					V_VOW_ACOTP     :=  pk_genvocword.getidbycode('VOW_ACOTP','1',null);
					select seq_genaccount.nextval into V_ACO_ID from dual;
					insert into genaccount(aco_id,par_id,imp_id,vow_acotp,rec_id)
									values(V_ACO_ID,V_PAR_ID,V_imp_id,V_VOW_ACOTP,null);
				END;				
				BEGIN	
					select t.sco_id
					into V_SCO_ID
					from agrsagaco t
					where t.aco_id=V_ACO_ID;
				EXCEPTION WHEN OTHERS THEN
					select seq_agrsagaco.nextval into V_SCO_ID from dual;
					insert into agrsagaco(sco_id,sag_id,aco_id,sco_startdt)
								   values(V_SCO_ID,V_SAG_ID,V_ACO_ID,V_ABN_DT_DEB);
				END;
			
				    Insert into gendebt(deb_id,deb_refe,org_id,par_id,adr_id,deb_date,deb_duedt,deb_printdt,
									    deb_amountinit,deb_amountremain,bap_id,vow_settlemode,aco_id,deb_norecovery,deb_credt,
									    deb_updtby,deb_updtdt,deb_comment,deb_amount_cash,sag_id,vow_debtype,deb_prel)
								values (V_Deb_ID,V_ID_FACTURE,V_ORG_ID,V_PAR_ID,V_ADR_ID,V_FAC_DATECALCUL,V_FAC_DATELIM,V_FAC_DATECALCUL,
										V_DEB_AMOUNTINIT,V_DEB_AMOUNTREMAIN,null,V_VOW_SETTLEMODE,V_ACO_ID,V_DEB_NORECOVERY,sysdate,
										null,null,V_DEB_COMMENT,nvl(V_deb_amount_cash,0),V_SAG_ID,V_VOW_DEBTYPE,1);	
				commit;
--------------------------------------------------------Traitement agrbill
			    select seq_agrbill.nextval into V_BIL_ID from dual; 
			    V_VOW_AGRBILLTYPE   :=  pk_genvocword.getidbycode('VOW_AGRBILLTYPE','FC',null) ;
				V_VOW_MODEFACT      :=  pk_genvocword.getidbycode('VOW_MODEFACT',4,null);--------NB:(4 ou MIG) a verifier
					Insert into agrbill(BIL_ID,SAG_ID,VOW_AGRBILLTYPE,VOW_MODEFACT)
								 values(V_BIL_ID,V_SAG_ID,V_VOW_AGRBILLTYPE,V_VOW_MODEFACT);	
					commit;
--------------------------------------------------------Traitement genbill
                V_BIL_AMOUNTHT      :=  V_TOTHTE +V_TOTHTA ;
				V_BIL_AMOUNTTVA     :=  V_TOTTVAE+V_TOTTVAA ;
				V_BIL_AMOUNTTTC     :=  V_TOTHTE+V_TVA+V_TOTHTA+V_TOTTVAA;
				V_AMOUNTTTCDEC  :=  V_AMOUNTTTCDEC;
				V_BIL_STATUS        :=  1; 
				V_FAC_DATECALCUL        :=  V_FAC_DATECALCUL;
				v_run_id            :=  genrun_ref;
					Insert into genbill(BIL_ID,BIL_CODE,BIL_CALCDT,BIL_AMOUNTHT,BIL_AMOUNTTVA,BIL_AMOUNTTTC,
					                    DEB_ID,PAR_ID,BIL_STATUS,BIL_AMOUNTTTCDEC,BIL_DEBTDT,RUN_ID)
								values(V_BIL_ID,V_ID_FACTURE,V_FAC_DATECALCUL,V_BIL_AMOUNTHT,V_BIL_AMOUNTTVA,V_BIL_AMOUNTTTC,
									   V_Deb_ID,V_PAR_ID,V_BIL_STATUS,V_AMOUNTTTCDEC,V_FAC_DATECALCUL,v_run_id); 
					commit; 
v := 0;		
-------------------------------------------------------------------------------------------
----------------------------ARTICLE DE REPRISE SONEDE----------------------------------------
-------------------------------------------------------------------------------------------					
	            v := v+1;
				V_PTA_ID := null;
				V_PSL_RANK := null;
				V_BLI_MHT  := null;
				BEGIN
				v_code:='REPRISE-SONEDE';
					FOR x in C_ITEM(v_code) LOOP
						V_ITE_ID:=x.ite_id;
						V_ite_name:=x.ite_name
						V_VOW_UNIT:=x.VOW_UNIT
					end loop;
				EXCEPTION WHEN NO_DATA_FOUND THEN NULL;
				END;
				BEGIN
				v_tva_taux:= 0;
					for v in C_TVA(v_tva_taux) loop
					    V_TVA_ID:=v.tva_id; 
					end loop;
				EXCEPTION WHEN NO_DATA_FOUND THEN 
				V_TVA_ID := 25;
				END;
				select count(*) 
				into V_nbr 
				from genptaslice 
				where PTA_ID in (select PTA_ID 	
				                 from genitemperiodtarif 
								 where TAR_id in (select tar_id 
								                  from genitemtarif 
												  where ITE_ID=V_ITE_ID )
								 );
				if V_nbr =1 then
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
						where PTA_ID in (select PTA_ID 
										 from genitemperiodtarif
										 where TAR_id in (select tar_id
														  from genitemtarif 
														  where ITE_ID=V_ITE_ID) 
										)
						and rownum=1;
				end if;	
                 V_BLI_MHT:=(to_number(trim(facture_.net))-to_number(trim(facture_.mtonas)))/1000;
				BEGIN
					INSERT INTO genbilline(BIL_ID,BLI_REVERSEBLI_ID,BLI_NUMBER,BLI_REVERSEBLINUMBER,BLI_NAME,BLI_EXERCICE,ITE_ID,PTA_ID,PSL_RANK,IMP_ID,BLI_VOLUMEBASE,BLI_VOLUMEFACT,
										   BLI_PUHT,TVA_ID,BLI_MHT,BLI_MTTVA,BLI_MTTC,BLI_STARTDT,BLI_ENDDT,VOW_UNIT,BLI_NBUNITES,BLI_DETAIL,BLI_CANCEL,IMC_ID,IMP_ANALYTIQUE_ID,
										   BLI_PERIODEINIT,BLI_PERIODE,BLI_REVERSEDT,BLI_CREDT,BLI_UPDTDT,BLI_UPDTBY,MEU_ID,BLI_NAME_A,BLI_REVERSEBLIDEC_ID,BLI_REVERSEBLINUMBERDEC,BLI_REVERSEDECDT)
								    values(V_BIL_ID,null,v,null,V_ite_name,V_anneereel,V_ITE_ID,V_PTA_ID,V_PSL_RANK,null,0,0,0,V_TVA_ID,
										   V_BLI_MHT,0,V_BLI_MHT,V_FAC_DATECALCUL,V_FAC_DATECALCUL,V_VOW_UNIT,null,0,0,null,
										   null,null,null,null,null,null,null,null,null,null,null,null);
				EXCEPTION WHEN OTHERS THEN
									BEGIN
										INSERT INTO genbilline(BIL_ID,BLI_REVERSEBLI_ID,BLI_NUMBER,BLI_REVERSEBLINUMBER,BLI_NAME,BLI_EXERCICE,ITE_ID,PTA_ID,PSL_RANK,IMP_ID,BLI_VOLUMEBASE,BLI_VOLUMEFACT,
															   BLI_PUHT,TVA_ID,BLI_MHT,BLI_MTTVA,BLI_MTTC,BLI_STARTDT,BLI_ENDDT,VOW_UNIT,BLI_NBUNITES,BLI_DETAIL,BLI_CANCEL,IMC_ID,IMP_ANALYTIQUE_ID,
															   BLI_PERIODEINIT,BLI_PERIODE,BLI_REVERSEDT,BLI_CREDT,BLI_UPDTDT,BLI_UPDTBY,MEU_ID,BLI_NAME_A,BLI_REVERSEBLIDEC_ID,BLI_REVERSEBLINUMBERDEC,BLI_REVERSEDECDT)
													   values(V_BIL_ID,null,v+1,null,V_ite_name,V_anneereel,V_ITE_ID,V_PTA_ID,V_PSL_RANK,null,0,0,0,V_TVA_ID,
															  V_BLI_MHT,0,V_BLI_MHT,V_FAC_DATECALCUL,V_FAC_DATECALCUL,V_VOW_UNIT,null,0,0,null,
															  null,null,null,null,null,null,null,null,null,null,null,null);
									EXCEPTION WHEN OTHERS THEN NULL;
									END;
				END;
-------------------------------------------------------------------------------------------
----------------------------ARTICLE DE REPRISE ONAS----------------------------------------
-------------------------------------------------------------------------------------------	
	            v := v+1;
				V_PTA_ID   := null;
				V_PSL_RANK := null;
				V_BLI_MHT  := null;
				begin
				v_code:='REPRISE-ONAS';
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
					   V_TVA_ID:=v.tva_id; 
					end loop;
				EXCEPTION WHEN NO_DATA_FOUND THEN 
				V_TVA_ID := 25;
				end;
				select count(*) 
				into V_nbr 
				from genptaslice 
				where PTA_ID in (select PTA_ID 
				                 from genitemperiodtarif 
								 where TAR_id in (select tar_id 
								                  from genitemtarif 
												  where ITE_ID=V_ITE_ID )
								);
				if V_nbr =1 then
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
					where PTA_ID in (select PTA_ID 
									 from genitemperiodtarif
									 where TAR_id in (select tar_id 
													  from genitemtarif
													  where ITE_ID=V_ITE_ID) 
									)
					and rownum=1;
				end if;	
                V_BLI_MHT:= (to_number(trim(facture_.mtonas))/1000);		
                BEGIN
					INSERT INTO genbilline(BIL_ID,BLI_REVERSEBLI_ID,BLI_NUMBER,BLI_REVERSEBLINUMBER,BLI_NAME,BLI_EXERCICE,ITE_ID,PTA_ID,PSL_RANK,IMP_ID,BLI_VOLUMEBASE,BLI_VOLUMEFACT,
										   BLI_PUHT,TVA_ID,BLI_MHT,BLI_MTTVA,BLI_MTTC,BLI_STARTDT,BLI_ENDDT,VOW_UNIT,BLI_NBUNITES,BLI_DETAIL,BLI_CANCEL,IMC_ID,IMP_ANALYTIQUE_ID,
										   BLI_PERIODEINIT,BLI_PERIODE,BLI_REVERSEDT,BLI_CREDT,BLI_UPDTDT,BLI_UPDTBY,MEU_ID,BLI_NAME_A,BLI_REVERSEBLIDEC_ID,BLI_REVERSEBLINUMBERDEC,BLI_REVERSEDECDT)
								    VALUES(V_BIL_ID,null,v,null,V_ite_name,V_anneereel,V_ITE_ID,V_PTA_ID,V_PSL_RANK,null,0,0,0,V_TVA_ID,
										   V_BLI_MHT,0,V_BLI_MHT,V_FAC_DATECALCUL,V_FAC_DATECALCUL,V_VOW_UNIT,null,0,0,null,
										   null,null,null,null,null,null,null,null,null,null,null,null);
				EXCEPTION WHEN OTHERS THEN
									BEGIN
										INSERT INTO genbilline(BIL_ID,BLI_REVERSEBLI_ID,BLI_NUMBER,BLI_REVERSEBLINUMBER,BLI_NAME,BLI_EXERCICE,ITE_ID,PTA_ID,PSL_RANK,IMP_ID,BLI_VOLUMEBASE,BLI_VOLUMEFACT,
															   BLI_PUHT,TVA_ID,BLI_MHT,BLI_MTTVA,BLI_MTTC,BLI_STARTDT,BLI_ENDDT,VOW_UNIT,BLI_NBUNITES,BLI_DETAIL,BLI_CANCEL,IMC_ID,IMP_ANALYTIQUE_ID,
															   BLI_PERIODEINIT,BLI_PERIODE,BLI_REVERSEDT,BLI_CREDT,BLI_UPDTDT,BLI_UPDTBY,MEU_ID,BLI_NAME_A,BLI_REVERSEBLIDEC_ID,BLI_REVERSEBLINUMBERDEC,BLI_REVERSEDECDT)
													    VALUES(V_BIL_ID,null,v+1,null,V_ite_name,V_anneereel,V_ITE_ID,V_PTA_ID,V_PSL_RANK,null,0,0,0,V_TVA_ID,
															   V_BLI_MHT,0,V_BLI_MHT,V_FAC_DATECALCUL,V_FAC_DATECALCUL,V_VOW_UNIT,null,0,0,null,
															   null,null,null,null,null,null,null,null,null,null,null,null);
									EXCEPTION WHEN OTHERS THEN NULL;
									END;
				END;
			end if;
		end loop;
    end loop;		
end;
/