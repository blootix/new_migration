 CREATE OR REPLACE PACKAGE PK_MIGRATION_FACTURE
AS

 CREATE OR REPLACE PACKAGE BODY PK_MIGRATION_FACTURE
AS

v_g_imp_id          number:= 5;   ---'MIG'
v_g_vow_settlemode  number:= 2975;---'4'
v_g_vow_acotp		number:= 2558;---'1-Client'
v_g_vow_debtype     number:= 3134;---'FA' 
v_g_vow_modefact    number:= 5560;---'MIG'

procedure MigrationFacture_as400
 (
    p_pk_etape     out varchar2,
    p_pk_exception out varchar2,
    p_district     in varchar2,
    p_tourne       in varchar2,
    p_ordre        in varchar2
	p_spt_id       in number,
	p_imp_id       in number,
	p_sag_id       in number,
	p_par_id       in number,
	p_adr_id       in number,
	p_org_id	   in number,
	p_dat_abn      in date,
	p_vow_settlemode in number,
	p_vow_acotp     in number,
	p_vow_debtype   in number,
	p_vow_modefact  in number
) 
  IS
	cursor c1   
	is 
	select * 
	from test.src_facture_as400 f
	where lpad(trim(f.dist),2,'0')=p_district
	and lpad(trim(f.tou),3,'0')   =p_tourne
	and lpad(trim(f.ord),3,'0')   =p_ordre;

	cursor c2(v_fact varchar2(50))
	is
	select count(*) nombre
	from test.src_impayee t
	where lpad(trim(t.district),2,'0')||
	      lpad(trim(t.tournee),3,'0')||
	      lpad(trim(t.ordre),3,'0')||
	      to_char(t.annee)||
	      lpad(trim(t.trimestre),2,'0')||'0'=v_fact;
		  
	cursor c1 
	CASE &cnt
	WHEN 1 THEN 
    select * 
	from test.src_facture_as400 f
	where lpad(trim(f.dist),2,'0')=p_district
	and lpad(trim(f.tou),3,'0')   =p_tourne
 	and lpad(trim(f.ord),3,'0')   =p_ordre 

	
	p_org_id           number;
	v_run_id           number;
	v_deb_id           number;
	v_aco_id           number;
	v_sco_id           number;
	v_ite_id  		   number;
	v_tva_id           number;
	v_pta_id           number;
	v_tva              number(25,10);
	v_tothte           number(25,10);
	v_tothta           number(25,10);
	v_tottvaa          number(25,10);
	v_solde            number(25,10);
	v_deb_amountinit   number(25,10);
	v_deb_amount_cash  number(25,10);
	v_bil_amountht     number(25,10);
	v_bil_amounttva    number(25,10);
	v_bil_amountttc    number(25,10);
	v_bli_volumebase   number(25,10);
	v_bli_volumefact   number(25,10);
	v_bli_puht         number(25,10);
	v_bli_mht          number(25,10);
	v_bli_mttva        number(25,10);
	v_bli_mttc         number(25,10);
	v_version          number(1):=0;
	v_anneereel        number(4);
	v_vow_agrbilltype  number;
	v_vow_unit         number;
	v_nbr              number;
	v_periode          number;
	v_psl_rank         number; 
	v_val              number; 
	v_tiers            varchar2(1);
	v_six              varchar2(1);
	v_id_facture       varchar2(50);
	v_deb_comment      varchar2(100);
	v_train_fact       varchar2(100);
	v_ite_name         varchar2(100);

begin
	for s1 in c1 loop
	    begin
	     	select trim,tier,six
			into v_periode,v_tiers,v_six
			from test.param_tournee p,test.tourne t
			where lpad(trim(t.district),2,'0')= lpad(trim(s1.dist),2,'0')
			and   lpad(trim(t.code),3,'0')    = lpad(trim(s1.tou),3,'0')
			and   lpad(trim(p.district),2,'0')= lpad(trim(s1.dist),2,'0')
			and   lpad(trim(t.district),2,'0')= lpad(trim(p.district),2,'0')
            and   p.m1      = s1.refc01
			and   p.m2      = s1.refc02
			and   p.m3      = s1.refc03
			and   p.tier    = t.ntiers
			and   p.six     = t.nsixieme 
			and s1.refc03 is not null
			and s1.refc04 is not null;   
		exception when others then
			v_periode := 1;----------------------en cas de non existance de la periode !!!
		end;
	    if s1.refc04 is not null then 
			if(to_number(s1.refc01)<to_number(s1.refc03) )then
				v_anneereel := to_number('20'||s1.refc04);
			else (to_number(s1.refc01)>to_number(s1.refc03))
				v_anneereel := to_number('20'||to_char((to_number(s1.refc04)-1)));
			end if;
		else
			select last_day(to_date('01'||lpad(s1.refc01,2,'0')||s1.refc02,'ddmmyy')) 
			into v_date
			from dual;
			v_anneereel   := to_number(to_char(v_date,'yyyy'));
			v_periode     := trim(s1.refc01);
		end if;		
		v_id_facture  := lpad(trim(s1.dist),2,'0')||
						 lpad(trim(s1.tou),3,'0')||
						 lpad(trim(s1.ORD),3,'0')||
						 to_char(v_anneereel)||
						 lpad(trim(v_periode),2,'0')||
						 to_char(v_version);
		select count(*) 
		into v_nbr
		from genbill b
		where b.bil_code=v_id_facture;
		
		if v_nbr=0 then 
			if (refc04 is not null)then
				begin
					select to_date(lpad(trim(t.datexp),8,'0'),'ddmmyyyy'),
					       to_date(lpad(trim(t.datl),8,'0'),'ddmmyyyy')   
					into v_fac_datecalcul,v_fac_datelim
					from test.src_role t
					where lpad(trim(t.distr),2,'0') = lpad(trim(s1.dist),2,'0')
					and   lpad(trim(t.tour),3,'0')  = lpad(trim(s1.tou),3,'0')
					and   lpad(trim(t.ordr),3,'0')  = lpad(trim(s1.ord),3,'0')
					and   lpad(trim(t.police),5,'0')= lpad(trim(s1.pol),5,'0')
					and   t.tier                    = to_number(v_tiers)
					and   t.trim					= v_periode
					and   t.six						= to_number(v_six)        
					and   t.annee 					= v_anneereel
					and   rownum = 1;
				exception when others then
					select last_day(to_date('01'||lpad(s1.refc03,2,'0')||s1.refc04,'ddmmyy')) 
					into v_fac_datecalcul
					from dual; 
					v_fac_datelim := '01/01/2016';------date a verifier 
				end;  
				v_train_fact :='Annee:'||trim(v_anneereel)||' trim:'||trim(v_periode)||' tier:'||trim(v_tiers)||' six:'||trim(v_six );
			else 
			-------------gc		
				begin 
					select to_date(lpad(trim(t.datexp),8,'0'),'ddmmyyyy'),
						   to_date(lpad(trim(t.datl),8,'0'),'ddmmyyyy')    
					into v_fac_datecalcul,v_fac_datelim 
					from test.src_role t
					where lpad(trim(t.distr),2,'0')  = lpad(trim(s1.dist),2,'0')
					and	  lpad(trim(t.tour),3,'0')   = lpad(trim(s1.tou),3,'0')
					and   lpad(trim(t.ordr),3,'0')   = lpad(trim(s1.ord),3,'0')
					and	  lpad(trim(t.police),5,'0') = lpad(trim(s1.pol),5,'0')
					and   t.trim =v_periode
					and   t.annee=v_anneereel
					and   rownum = 1;
				exception when others then
					v_fac_datecalcul := v_date;
					v_fac_datelim    := v_date;
				end; 
				v_train_fact:='ANNEE:'||trim(v_anneereel)||' MOIS:'||trim(v_periode);
            end if;
			v_tva := (s1.tvacons+s1.tva_ff+s1.tvaferm+s1.tva_preav+s1.tvadeplac+s1.tvadepose_dem+s1.tvadepose_def+s1.tva_capit+s1.tva_pfin+)/1000;
			if (s1.net is not null)then
			------as_400
				v_tothte    :=(s1.net-(v_tva+s1.arriere))/1000;
				v_solde     :=(s1.net-s1.arriere)/1000;
			else
			-------gc
				v_tothte    := (s1.monttrim-v_tva)/1000;
				v_solde     := s1.monttrim/1000; 
			end if;
			v_tothta     :=0;
			v_tottvaa    :=0;
			if (v_anneereel is not null and v_periode is not null and v_train_fact is not null) then			
				begin
					select t.run_id
					into   v_run_id
					from genrun t 
					where t.run_exercice=v_anneereel
					and   t.run_number  =v_periode;
				exception when others then 			  
					select seq_genrun.nextval into v_run_id from dual;				
					insert into genrun(run_id,run_exercice,run_number,org_id,run_startdt,run_comment,run_name,run_dtcalc,run_enddt)
								values(v_run_id,v_anneereel,v_periode,p_org_id,v_fac_datecalcul,'Role migré','Role '||v_train_fact,v_fac_datecalcul,v_fac_datecalcul);
				end;    
			end if; 							
			v_deb_comment :=lpad(trim(s1.dist),2,'0')||lpad(trim(s1.pol),5,'0')||lpad(trim(s1.tou),3,'0')||lpad(trim(s1.ord),3,'0');			   	   				
			begin 
				select aco.aco_id 
				into v_aco_id
				from genaccount aco ,agrsagaco sco
				where aco.aco_id             = sco.aco_id
				and nvl(aco.par_id,0)        = p_par_id
				and nvl(aco.imp_id,0)        = p_imp_id
				and nvl(sco.sag_id,0)        = p_sag_id;				
			exception when others then 
				select seq_genaccount.nextval into v_aco_id from dual;
				insert into genaccount(aco_id,par_id,imp_id,vow_acotp,rec_id)
								values(v_aco_id,p_par_id,p_imp_id,p_vow_acotp,null);
			end;				
			begin	
				select t.sco_id
				into v_sco_id
				from agrsagaco t
				where t.aco_id=v_aco_id;
			exception when others then
				select seq_agrsagaco.nextval into v_sco_id from dual;
				insert into agrsagaco(sco_id,sag_id,aco_id,sco_startdt)
							   values(v_sco_id,p_sag_id,v_aco_id,p_dt_abn);
			end;		
			for s2 in c2(v_id_facture) loop 		
				if  s2.nombre=0 then
					v_deb_amountinit   := v_tothte+v_tva+v_tothta+v_tottvaa;
					v_deb_amount_cash  := v_tothte+v_tva+v_tothta+v_tottvaa;
					select seq_gendebt.nextval into v_deb_id from dual; 
					insert into gendebt(deb_id,deb_refe,org_id,par_id,adr_id,deb_date,deb_duedt,deb_printdt,
										deb_amountinit,deb_amountremain,bap_id,vow_settlemode,aco_id,deb_norecovery,deb_credt,
										deb_updtby,deb_updtdt,deb_comment,deb_amount_cash,sag_id,vow_debtype,deb_prel)
								values (v_deb_id,v_id_facture,p_org_id,p_par_id,p_adr_id,v_fac_datecalcul,v_fac_datelim,v_fac_datecalcul,
										v_deb_amountinit,v_solde,null,p_vow_settlemode,v_aco_id,0,sysdate,
										null,null,v_deb_comment,v_deb_amount_cash,p_sag_id,p_vow_debtype,1);	
					commit;
				else
				 	v_deb_amountinit   := 0;
					v_deb_amount_cash  :=(v_tothte+v_tva+v_tothta+v_tottvaa);
					select seq_gendebt.nextval into v_deb_id from dual; 
					insert into gendebt(deb_id,deb_refe,org_id,par_id,adr_id,deb_date,deb_duedt,deb_printdt,
										deb_amountinit,deb_amountremain,bap_id,vow_settlemode,aco_id,deb_norecovery,deb_credt,
										deb_updtby,deb_updtdt,deb_comment,deb_amount_cash,sag_id,vow_debtype,deb_prel)
								values (v_deb_id,v_id_facture,p_org_id,p_par_id,p_adr_id,v_fac_datecalcul,v_fac_datelim,v_fac_datecalcul,
										v_deb_amountinit,v_solde,null,p_vow_settlemode,v_aco_id,0,sysdate,
										null,null,v_deb_comment,v_deb_amount_cash,p_sag_id,p_vow_debtype,1);	
					commit;
				end if; 
			end loop;
			select seq_agrbill.nextval into v_bil_id from dual; 
			v_vow_agrbilltype   := 2563;--'FC'
			v_bil_amountht      := v_tothte+v_tothta;
			v_bil_amounttva     := v_tva+v_tottvaa;
			v_bil_amountttc     := v_tothte+v_tva+v_tothta+v_tottvaa; 
			insert into agrbill(bil_id,sag_id,vow_agrbilltype,vow_modefact)
						 values(v_bil_id,p_sag_id,v_vow_agrbilltype,p_vow_modefact);
			insert into genbill(bil_id,bil_code,bil_calcdt,bil_amountht,bil_amounttva,bil_amountttc,
								deb_id,par_id,bil_status,bil_amountttcdec,bil_debtdt,run_id)
						 values(v_bil_id,v_id_facture,v_fac_datecalcul,v_bil_amountht,v_bil_amounttva,v_bil_amountttc,
								v_deb_id,p_par_id,1,null,v_fac_datecalcul,v_run_id); 
			commit;	
			v_val := 0;
-------------------------------------------------------------------------------------------
------------------------------CONSOMMATION SONEDE 1ERE TRANCHE-----------------------------
-------------------------------------------------------------------------------------------				 
			if to_number(s1.montt1)>0 then
				v_val := v_val+1;
				v_ite_name:='Consommation EAU';
				v_ite_id  :=320;
				v_vow_unit:=760;
				if (v_anneereel>=2018)then
				  v_tva_id  :=26;
				else
				  v_tva_id  :=24;
				end if;
				v_pta_id  :=2112;
				v_psl_rank:=1;
				v_bli_volumebase:= s1.const1;
				v_bli_volumefact:= s1.const1;
				v_bli_puht      := s1.tauxt1/1000;
				v_bli_mht       := s1.montt1/1000;
				v_bli_mttva     := s1.tvacons/1000;
				v_bli_mttc      :=(s1.montt1+s1.tvacons)/1000;
				insert into genbilline(bil_id,bli_reversebli_id,bli_number,bli_reverseblinumber,bli_name,bli_exercice,ite_id,pta_id,psl_rank,
									   imp_id,bli_volumebase,bli_volumefact,bli_puht,tva_id,bli_mht,bli_mttva,bli_mttc,bli_startdt,
									   bli_enddt,vow_unit,bli_nbunites,bli_detail,bli_cancel,imc_id,imp_analytique_id,bli_periodeinit,bli_periode,
									   bli_reversedt,bli_credt,bli_updtdt,bli_updtby,meu_id,bli_name_a,bli_reverseblidec_id,bli_reverseblinumberdec,bli_reversedecdt)
								values(v_bil_id,null,v_val,null,v_ite_name,v_anneereel,v_ite_id,v_pta_id,v_psl_rank,
									   null,v_bli_volumebase,v_bli_volumefact,v_bli_puht,v_tva_id,v_bli_mht,v_bli_mttva,v_bli_mttc,v_fac_datecalcul,
									   v_fac_datecalcul,v_vow_unit, null,0,0,null,null,null,null,
									   null,sysdate,null,null,null,null,null,null,null);
			end if;
-------------------------------------------------------------------------------------------
------------------------------CONSOMMATION SONEDE 2EME TRANCHE-----------------------------
-------------------------------------------------------------------------------------------
			if to_number(s1.montt2)>0 then
				v_val := v_val+1; 
				v_ite_name:='Consommation EAU';
				v_ite_id  :=320;
				v_vow_unit:=760;
				if (v_anneereel>=2018)then
				  v_tva_id  :=26;
				else
				  v_tva_id  :=24;
				end if;
				v_pta_id  :=2112;
				v_psl_rank:=1;
				v_bli_volumebase:= s1.const2;
				v_bli_volumefact:= s1.const2;
				v_bli_puht      := s1.tauxt2/1000;
				v_bli_mht       := s1.montt2/1000;
				v_bli_mttva     := s1.tvacons/1000;
				v_bli_mttc      :=(s1.montt2+s1.tvacons)/1000;
				insert into genbilline(bil_id,bli_reversebli_id,bli_number,bli_reverseblinumber,bli_name,bli_exercice,ite_id,pta_id,psl_rank,
									   imp_id,bli_volumebase,bli_volumefact,bli_puht,tva_id,bli_mht,bli_mttva,bli_mttc,bli_startdt,
									   bli_enddt,vow_unit,bli_nbunites,bli_detail,bli_cancel,imc_id,imp_analytique_id,bli_periodeinit,bli_periode,
									   bli_reversedt,bli_credt,bli_updtdt,bli_updtby,meu_id,bli_name_a,bli_reverseblidec_id,bli_reverseblinumberdec,bli_reversedecdt)
								values(v_bil_id,null,v_val,null,v_ite_name,v_anneereel,v_ite_id,v_pta_id,v_psl_rank,
									   null,v_bli_volumebase,v_bli_volumefact,v_bli_puht,v_tva_id,v_bli_mht,v_bli_mttva,v_bli_mttc,v_fac_datecalcul,
									   v_fac_datecalcul,v_vow_unit,null,0,0,null,null,null,null,
									   null,sysdate,null,null,null,null,null,null,null);
				commit;	
			end if;				
-------------------------------------------------------------------------------------------
------------------------------CONSOMMATION SONEDE 3EME TRANCHE-----------------------------
-------------------------------------------------------------------------------------------				
			if to_number(s1.montt3)>0 then
				v_val := v_val+1;
				v_ite_name:='Consommation EAU';
				v_ite_id  :=320;
				v_vow_unit:=760;
				if (v_anneereel>=2018)then
				  v_tva_id  :=26;
				else
				  v_tva_id  :=24;
				end if;
				v_pta_id  :=2112;
				v_psl_rank:=1;
				v_bli_volumebase:= s1.const3;
				v_bli_volumefact:= s1.const3;
				v_bli_puht      := s1.tauxt3/1000;
				v_bli_mht       := s1.montt3/1000;
				v_bli_mttva     := s1.tvacons/1000;
				v_bli_mttc      := (s1.montt3+s1.tvacons)/1000;
				insert into genbilline(bil_id,bli_reversebli_id,bli_number,bli_reverseblinumber,bli_name,bli_exercice,ite_id,pta_id,psl_rank,
									   imp_id,bli_volumebase,bli_volumefact,bli_puht,tva_id,bli_mht,bli_mttva,bli_mttc,bli_startdt,
									   bli_enddt,vow_unit,bli_nbunites,bli_detail,bli_cancel,imc_id,imp_analytique_id,bli_periodeinit,bli_periode,
									   bli_reversedt,bli_credt,bli_updtdt,bli_updtby,meu_id,bli_name_a,bli_reverseblidec_id,bli_reverseblinumberdec,bli_reversedecdt)
								values(v_bil_id,null,v_val,null,v_ite_name,v_anneereel,v_ite_id,v_pta_id,v_psl_rank,
									   null,v_bli_volumebase,v_bli_volumefact,v_bli_puht,v_tva_id,v_bli_mht,v_bli_mttva,v_bli_mttc,v_fac_datecalcul,
									   v_fac_datecalcul,v_vow_unit,null,0,0,null,null,null,null,
									   null,sysdate,null,null,null,null,null,null,null);
				commit;
			end if;
-------------------------------------------------------------------------------------------
-----------------------------------REDEVANCE ONAS 1ERE TRANCHE-----------------------------
-------------------------------------------------------------------------------------------					
			if to_number(s1.mon1)>0 then
				v_val := v_val+1; 
				v_ite_name:='Redevance variable pour usage domestique';
				v_ite_id  :=350;
				v_vow_unit:=760;
				v_tva_id  :=25; 
				v_pta_id  :=403;
				v_psl_rank:=1;
				v_bli_volumebase:= s1.volon1;
				v_bli_volumefact:= s1.volon1;
				v_bli_puht      := s1.tauon1/1000;
				v_bli_mht       := s1.mon1/1000;
				v_bli_mttva     := 0;
				v_bli_mttc      := s1.mon1/1000;
				insert into genbilline(bil_id,bli_reversebli_id,bli_number,bli_reverseblinumber,bli_name,bli_exercice,ite_id,pta_id,psl_rank,
									   imp_id,bli_volumebase,bli_volumefact,bli_puht,tva_id,bli_mht,bli_mttva,bli_mttc,bli_startdt,
									   bli_enddt,vow_unit,bli_nbunites,bli_detail,bli_cancel,imc_id,imp_analytique_id,bli_periodeinit,bli_periode,
									   bli_reversedt,bli_credt,bli_updtdt,bli_updtby,meu_id,bli_name_a,bli_reverseblidec_id,bli_reverseblinumberdec,bli_reversedecdt)
								values(v_bil_id,null,v_val,null,v_ite_name,v_anneereel,v_ite_id,v_pta_id,v_psl_rank,
									   null,v_bli_volumebase,v_bli_volumefact,v_bli_puht,v_tva_id,v_bli_mht,v_bli_mttva,v_bli_mttc,v_fac_datecalcul,
									   v_fac_datecalcul,v_vow_unit,null,0,0,null,null,null,null,
									   null,sysdate,null,null,null,null,null,null,null);
				commit;
			end if;
-------------------------------------------------------------------------------------------
-----------------------------------REDEVANCE ONAS 2EME TRANCHE-----------------------------
-------------------------------------------------------------------------------------------	
			if to_number(s1.mon2)>0 then
				v_val := v_val+1;
				v_ite_name:='Redevance variable pour usage domestique';
				v_ite_id  :=350;
				v_vow_unit:=760;
				v_tva_id  :=25; 
				v_pta_id  :=403;
				v_psl_rank:=1;
				v_bli_volumebase:= s1.volon2;
				v_bli_volumefact:= s1.volon2;
				v_bli_puht      := s1.tauon2/1000;
				v_bli_mht       := s1.mon2/1000;
				v_bli_mttva     := 0;
				v_bli_mttc      := s1.mon2/1000;
				insert into genbilline(bil_id,bli_reversebli_id,bli_number,bli_reverseblinumber,bli_name,bli_exercice,ite_id,pta_id,psl_rank,
									   imp_id,bli_volumebase,bli_volumefact,bli_puht,tva_id,bli_mht,bli_mttva,bli_mttc,bli_startdt,
									   bli_enddt,vow_unit,bli_nbunites,bli_detail,bli_cancel,imc_id,imp_analytique_id,bli_periodeinit,bli_periode,
									   bli_reversedt,bli_credt,bli_updtdt,bli_updtby,meu_id,bli_name_a,bli_reverseblidec_id,bli_reverseblinumberdec,bli_reversedecdt)
							   values(v_bil_id,null,v_val,null,v_ite_name,v_anneereel,v_ite_id,v_pta_id,v_psl_rank,
									  null,v_bli_volumebase,v_bli_volumefact,v_bli_puht,v_tva_id,v_bli_mht,v_bli_mttva,v_bli_mttc,v_fac_datecalcul,
									  v_fac_datecalcul,v_vow_unit,null,0,0,null,null,null,null,
									  null,sysdate,null,null,null,null,null,null,null);
				commit;
			end if;
-------------------------------------------------------------------------------------------
-----------------------------------REDEVANCE ONAS 3EME TRANCHE-----------------------------
-------------------------------------------------------------------------------------------					
			if to_number(s1.mon3)>0 then
				v_val := v_val+1;
				v_ite_name:='Redevance variable pour usage domestique';
				v_ite_id  :=350;
				v_vow_unit:=760;
				v_tva_id  :=25; 
				v_pta_id  :=403;
				v_psl_rank:=1; 
				v_bli_volumebase:= s1.volon3;
				v_bli_volumefact:= s1.volon3;
				v_bli_puht      := s1.tauon3/1000;
				v_bli_mht       := s1.mon3/1000;
				v_bli_mttva     := 0;
				v_bli_mttc      := s1.mon3/1000;
				insert into genbilline(bil_id,bli_reversebli_id,bli_number,bli_reverseblinumber,bli_name,bli_exercice,ite_id,pta_id,psl_rank,
									   imp_id,bli_volumebase,bli_volumefact,bli_puht,tva_id,bli_mht,bli_mttva,bli_mttc,bli_startdt,
									   bli_enddt,vow_unit,bli_nbunites,bli_detail,bli_cancel,imc_id,imp_analytique_id,bli_periodeinit,bli_periode,
									   bli_reversedt,bli_credt,bli_updtdt,bli_updtby,meu_id,bli_name_a,bli_reverseblidec_id,bli_reverseblinumberdec,bli_reversedecdt)
								values(v_bil_id,null,v_val,null,v_ite_name,v_anneereel,v_ite_id,v_pta_id,v_psl_rank,
									   null,v_bli_volumebase,v_bli_volumefact,v_bli_puht,v_tva_id,v_bli_mht,v_bli_mttva,v_bli_mttc,v_fac_datecalcul,
									   v_fac_datecalcul,v_vow_unit,null,0,0,null,null,null,null,
									   null,sysdate,null,null,null,null,null,null,null);
				commit;
			end if;
-------------------------------------------------------------------------------------------
-----------------------------------FRAIS FIXE ONAS-----------------------------------------
-------------------------------------------------------------------------------------------		
			if to_number(s1.fixonas)>0 then
				v_val := v_val+1;
				v_ite_name:='Redevance fixe domestique ONAS';
				v_ite_id  := 351;
				v_vow_unit:= 760;
				v_tva_id  := 25;
				v_pta_id  := 409;
				v_psl_rank:= 1;
				v_bli_volumebase:= 1;
				v_bli_volumefact:= 1;
				v_bli_puht      := s1.fixonas/1000;
				v_bli_mht       := s1.fixonas/1000;
				v_bli_mttva     := 0;
				v_bli_mttc      := s1.fixonas/1000;					
				insert into genbilline(bil_id,bli_reversebli_id,bli_number,bli_reverseblinumber,bli_name,bli_exercice,ite_id,pta_id,psl_rank,
									   imp_id,bli_volumebase,bli_volumefact,bli_puht,tva_id,bli_mht,bli_mttva,bli_mttc,bli_startdt,
									   bli_enddt,vow_unit,bli_nbunites,bli_detail,bli_cancel,imc_id,imp_analytique_id,bli_periodeinit,bli_periode,
									   bli_reversedt,bli_credt,bli_updtdt,bli_updtby,meu_id,bli_name_a,bli_reverseblidec_id,bli_reverseblinumberdec,bli_reversedecdt)
								values(v_bil_id,null,v_val,null,v_ite_name,v_anneereel,v_ite_id,v_pta_id,v_psl_rank,null,
									   v_bli_volumebase,v_bli_volumefact,v_bli_puht,v_tva_id,v_bli_mht,v_bli_mttva,v_bli_mttc,v_fac_datecalcul,
									   v_fac_datecalcul,v_vow_unit,null,0,0,null,null,null,null,
									   null,sysdate,null,null,null,null,null,null,null);
				commit;
			end if;		
-------------------------------------------------------------------------------------------
-----------------------------------FRAIS FIXE SONEDE--------------------------------------
-------------------------------------------------------------------------------------------		
		    if to_number(s1.fraisctr)>0 then
				v_val := v_val+1;
				V_ite_name:='Frais fixe';
				v_ite_id  :=326;
				v_vow_unit:=4104;
				if (v_anneereel>=2018)then
				  v_tva_id  :=26;
				else
				  v_tva_id  :=24;
				end if;
				v_pta_id  := 341;
				v_psl_rank:= 1; 
				v_bli_volumebase:= 1;
				v_bli_volumefact:= 1;
				v_bli_puht      := s1.fraisctr/1000;
				v_bli_mht       := s1.fraisctr/1000;
				v_bli_mttva     := s1.tva_ff/1000;
				v_bli_mttc      := (s1.fraisctr/+s1.tva_ff)/1000;					
				insert into genbilline(bil_id,bli_reversebli_id,bli_number,bli_reverseblinumber,bli_name,bli_exercice,ite_id,pta_id,psl_rank,
									   imp_id,bli_volumebase,bli_volumefact,bli_puht,tva_id,bli_mht,bli_mttva,bli_mttc,bli_startdt,
									   bli_enddt,vow_unit,bli_nbunites,bli_detail,bli_cancel,imc_id,imp_analytique_id,bli_periodeinit,bli_periode,
									   bli_reversedt,bli_credt,bli_updtdt,bli_updtby,meu_id,bli_name_a,bli_reverseblidec_id,bli_reverseblinumberdec,bli_reversedecdt)
								values(v_bil_id,,null,v_val,null,v_ite_name,v_anneereel,v_ite_id,v_pta_id,v_psl_rank,null,
									   v_bli_volumebase,v_bli_volumefact,v_bli_puht,v_tva_id,v_bli_mht,v_bli_mttva,v_bli_mttc,v_fac_datecalcul,
									   v_fac_datecalcul,v_vow_unit,null,0,0,null,null,null,null,
									   null,sysdate,null,null,null,null,null,null,null);
				commit;
			end if;			
-------------------------------------------------------------------------------------------
-----------------------------------Frais FERMETURE---------------------------------------
-------------------------------------------------------------------------------------------	
			if to_number(s1.fermeture)>0 then
				v_val := v_val+1; 
				v_ite_name:='Frais de coupure d''eau suite à non paiement'
				v_ite_id  :=335;
				v_vow_unit:=4104; 
				if (v_anneereel>=2018)then
				  v_tva_id  :=26;
				else
				  v_tva_id  :=24;
				end if; 
				v_pta_id  := 365;
				v_psl_rank:= 1;  
				v_bli_volumebase:= 1;
				v_bli_volumefact:= 1;
				v_bli_puht      := s1.fermeture/1000;
				v_bli_mht       := s1.fermeture/1000;
				v_bli_mttva     := s1.tvaferm/1000;
				v_bli_mttc      := (s1.fermeture+s1.tvaferm)/1000;
				insert into genbilline(bil_id,bli_reversebli_id,bli_number,bli_reverseblinumber,bli_name,bli_exercice,ite_id,pta_id,psl_rank,
									   imp_id,bli_volumebase,bli_volumefact,bli_puht,tva_id,bli_mht,bli_mttva,bli_mttc,bli_startdt,
									   bli_enddt,vow_unit,bli_nbunites,bli_detail,bli_cancel,imc_id,imp_analytique_id,bli_periodeinit,bli_periode,
									   bli_reversedt,bli_credt,bli_updtdt,bli_updtby,meu_id,bli_name_a,bli_reverseblidec_id,bli_reverseblinumberdec,bli_reversedecdt)
								values(v_bil_id,null,v_val,null,v_ite_name,v_anneereel,v_ite_id,v_pta_id,v_psl_rank,
									   null,v_bli_volumebase,v_bli_volumefact,v_bli_puht,v_tva_id,v_bli_mht,v_bli_mttva,v_bli_mttc,v_fac_datecalcul,
									   v_fac_datecalcul,v_vow_unit,null,0,0,null,null,null,null,
									   null,sysdate,null,null,null,null,null,null,null);
				commit;
			end if;		
-------------------------------------------------------------------------------------------
-----------------------------------Frais PREAVIS-------------------------------------------
-------------------------------------------------------------------------------------------	
			if to_number(s1.preavis)>0 then
				v_val := v_val+1; 
				v_ite_name:='Frais de preavis et de rappel de paiement';
				v_ite_id  :=338;
				v_vow_unit:=4104; 
				if (v_anneereel>=2018)then
				  v_tva_id  :=26;
				else
				  v_tva_id  :=24;
				end if; 
				v_pta_id  := 389;
				v_psl_rank:= 1;  
				v_bli_volumebase:= 1;
				v_bli_volumefact:= 1;
				v_bli_puht      := s1.preavis/1000;
				v_bli_mht       := s1.preavis/1000;
				v_bli_mttva     := s1.tva_preav/1000;
				v_bli_mttc      :=(s1.preavis+s1.tva_preav)/1000;
				insert into genbilline(bil_id,bli_reversebli_id,bli_number,bli_reverseblinumber,bli_name,bli_exercice,ite_id,pta_id,psl_rank,
									   imp_id,bli_volumebase,bli_volumefact,bli_puht,tva_id,bli_mht,bli_mttva,bli_mttc,bli_startdt,
									   bli_enddt,vow_unit,bli_nbunites,bli_detail,bli_cancel,imc_id,imp_analytique_id,bli_periodeinit,bli_periode,
									   bli_reversedt,bli_credt,bli_updtdt,bli_updtby,meu_id,bli_name_a,bli_reverseblidec_id,bli_reverseblinumberdec,bli_reversedecdt)
								values(v_bil_id,null,v_val,null,v_ite_name,v_anneereel,v_ite_id,v_pta_id,v_psl_rank,
									   null,v_bli_volumebase,v_bli_volumefact,v_bli_puht,v_tva_id,v_bli_mht,v_bli_mttva,v_bli_mttc,v_fac_datecalcul,
									   v_fac_datecalcul,v_vow_unit,null,0,0,null,null,null,null,
									   null,sysdate,null,null,null,null,null,null,null);
				commit;
			end if;			
-------------------------------------------------------------------------------------------
-----------------------------------Frais de déplacement---------------------------------------
-------------------------------------------------------------------------------------------		
			if to_number(s1.deplacement)>0 then  
				v_val := v_val+1; 
				v_ite_name:='Frais de déplacement';
				v_ite_id  :=1764;
				v_vow_unit:=4104;
				if (v_anneereel>=2018)then
				  v_tva_id  :=26;
				else
				  v_tva_id  :=24;
				end if;
				v_pta_id  :=5624;
				v_psl_rank:=1;
				v_bli_volumebase:= 1;
				v_bli_volumefact:= 1;
				v_bli_puht      := s1.deplacement/1000;
				v_bli_mht       := s1.deplacement/1000;
				v_bli_mttva     := s1.tvadeplac/1000;
				v_bli_mttc      := (s1.deplacement+s1.tvadeplac)/1000;
				insert into genbilline(bil_id,bli_reversebli_id,bli_number,bli_reverseblinumber,bli_name,bli_exercice,ite_id,pta_id,psl_rank,
									   imp_id,bli_volumebase,bli_volumefact,bli_puht,tva_id,bli_mht,bli_mttva,bli_mttc,bli_startdt,
									   bli_enddt,vow_unit,bli_nbunites,bli_detail,bli_cancel,imc_id,imp_analytique_id,bli_periodeinit,bli_periode,
									   bli_reversedt,bli_credt,bli_updtdt,bli_updtby,meu_id,bli_name_a,bli_reverseblidec_id,bli_reverseblinumberdec,bli_reversedecdt)
								values(v_bil_id,null,v_val,null,v_ite_name,v_anneereel,v_ite_id,v_pta_id,v_psl_rank,
									   null,v_bli_volumebase,v_bli_volumefact,v_bli_puht,v_tva_id,v_bli_mht,v_bli_mttva,v_bli_mttc,v_fac_datecalcul,
									   v_fac_datecalcul,v_vow_unit,null,0,0,null,null,null,null,
									   null,sysdate,null,null,null,null,null,null,null);
				commit;
			end if;
-------------------------------------------------------------------------------------------
-----------------------------------Frais de dépose suite à la demande du client------------
-------------------------------------------------------------------------------------------	
			if to_number(s1.depose_dem)>0 then  
				v_val := v_val+1;
				v_ite_name:='Frais de depose ou repose suite à la demande du client';
				v_ite_id  :=355;
				v_vow_unit:=1404;
				if (v_anneereel>=2018)then
				  v_tva_id  :=26;
				else
				  v_tva_id  :=24;
				end if;
				v_pta_id  :=414;
				v_psl_rank:=1;
				v_bli_volumebase:= 1;
				v_bli_volumefact:= 1;
				v_bli_puht      := s1.depose_dem/1000;
				v_bli_mht       := s1.depose_dem/1000;
				v_bli_mttva     := s1.tvadepose_dem/1000;
				v_bli_mttc      := (s1.depose_dem +s1.tvadepose_dem)/1000;
				insert into genbilline(bil_id,bli_reversebli_id,bli_number,bli_reverseblinumber,bli_name,bli_exercice,ite_id,pta_id,psl_rank,
									   imp_id,bli_volumebase,bli_volumefact,bli_puht,tva_id,bli_mht,bli_mttva,bli_mttc,bli_startdt,
									   bli_enddt,vow_unit,bli_nbunites,bli_detail,bli_cancel,imc_id,imp_analytique_id,bli_periodeinit,bli_periode,
									   bli_reversedt,bli_credt,bli_updtdt,bli_updtby,meu_id,bli_name_a,bli_reverseblidec_id,bli_reverseblinumberdec,bli_reversedecdt)
								values(v_bil_id,null,v_val,null,v_ite_name,v_anneereel,v_ite_id,v_pta_id,v_psl_rank,
									   null,v_bli_volumebase,v_bli_volumefact,v_bli_puht,v_tva_id,v_bli_mht,v_bli_mttva,v_bli_mttc,v_fac_datecalcul,
									   v_fac_datecalcul,v_vow_unit,null,0,0,null,null,null,null,
									   null,sysdate,null,null,null,null,null,null,null);
				commit;
			end if;
-------------------------------------------------------------------------------------------
-----------------------------------FRAIS DE DÉPOSE SUITE AU NON PAIEMENT-------------------
-------------------------------------------------------------------------------------------	
			if to_number(s1.depose_def)>0 then  
				v_val := v_val+1; 
				v_ite_name:='Frais de dépose ou repose compteur';
				v_ite_id  :=336;
				v_vow_unit:=4104;
				if (v_anneereel>=2018)then
				  v_tva_id  :=26;
				else
				  v_tva_id  :=24;
				end if;
				v_pta_id  :=377;
				v_psl_rank:=1; 
				v_bli_volumebase:= 1;
				v_bli_volumefact:= 1;
				v_bli_puht      := (s1.depose_def/1000);
				v_bli_mht       := (s1.depose_def/1000);
				v_bli_mttva     := (s1.tvadepose_def/1000);
				v_bli_mttc      := (s1.depose_def+s1.tvadepose_def)/1000;
				insert into genbilline(bil_id,bli_reversebli_id,bli_number,bli_reverseblinumber,bli_name,bli_exercice,ite_id,pta_id,psl_rank,
									   imp_id,bli_volumebase,bli_volumefact,bli_puht,tva_id,bli_mht,bli_mttva,bli_mttc,bli_startdt,
									   bli_enddt,vow_unit,bli_nbunites,bli_detail,bli_cancel,imc_id,imp_analytique_id,bli_periodeinit,bli_periode,
									   bli_reversedt,bli_credt,bli_updtdt,bli_updtby,meu_id,bli_name_a,bli_reverseblidec_id,bli_reverseblinumberdec,bli_reversedecdt)
								values(v_bil_id,null,v_val,null,v_ite_name,v_anneereel,v_ite_id,v_pta_id,v_psl_rank,
									   null,v_bli_volumebase,v_bli_volumefact,v_bli_puht,v_tva_id,v_bli_mht,v_bli_mttva,v_bli_mttc,v_fac_datecalcul,
									   v_fac_datecalcul,v_vow_unit,null,0,0,null,null,null,null,
									   null,sysdate,null,null,null,null,null,null,null);
				commit;
			end if;	
-------------------------------------------------------------------------------------------
-----------------------------------MONTANT REXTENSION-------------------------------------
-------------------------------------------------------------------------------------------	
			if (to_number(s1.RBRANCHE)+to_number(s1.RFACADE))>0 then
				v_val := v_val+1; 
				v_ite_name:='Montant extention';  
				v_ite_id  :=1979;
				v_vow_unit:=4751;   
				if(v_anneereel>=2018)then
				  v_tva_id  :=26;
				else
				  v_tva_id  :=24;
				end if;
				v_pta_id  :=2310;
				v_psl_rank:=1;
				v_bli_volumebase:= 1;
				v_bli_volumefact:= 1;
				v_bli_puht      := (s1.RBRANCHE+s1.RFACADE)/1000;
				v_bli_mht       := (s1.RBRANCHE+s1.RFACADE)/1000;
				v_bli_mttva     :=  s1.TVA_CAPIT/1000;
				v_bli_mttc      := (s1.RBRANCHE+s1.RFACADE+s1.TVA_CAPIT)/1000;
				insert into genbilline(bil_id,bli_reversebli_id,bli_number,bli_reverseblinumber,bli_name,bli_exercice,ite_id,pta_id,psl_rank,
									   imp_id,bli_volumebase,bli_volumefact,bli_puht,tva_id,bli_mht,bli_mttva,bli_mttc,bli_startdt,
									   bli_enddt,vow_unit,bli_nbunites,bli_detail,bli_cancel,imc_id,imp_analytique_id,bli_periodeinit,bli_periode,
									   bli_reversedt,bli_credt,bli_updtdt,bli_updtby,meu_id,bli_name_a,bli_reverseblidec_id,bli_reverseblinumberdec,bli_reversedecdt)
								values(v_bil_id,null,v_val,null,v_ite_name,v_anneereel,v_ite_id,v_pta_id,v_psl_rank,
									   null,v_bli_volumebase,v_bli_volumefact,v_bli_puht,v_tva_id,v_bli_mht,v_bli_mttva,v_bli_mttc,v_fac_datecalcul,
									   v_fac_datecalcul,v_vow_unit,null,0,0,null,null,null,null,
									   null,sysdate,null,null,null,null,null,null,null);
				commit;
			end if;	
-------------------------------------------------------------------------------------------
-----------------------------------PRODUIT FINANCIER-------------------------------------
-------------------------------------------------------------------------------------------	
			if (to_number(s1.pfinancier))>0 then
				v_val := v_val+1; 
				v_ite_name:='Produit financier';  
				v_ite_id  :=1982;
				v_vow_unit:=4751;   
				if(v_anneereel>=2018)then
				  v_tva_id  :=26;
				else
				  v_tva_id  :=24;
				end if;
				v_pta_id  :=2306;
				v_psl_rank:=1;
				v_bli_volumebase:= 1;
				v_bli_volumefact:= 1;
				v_bli_puht      := s1.pfinancier/1000;
				v_bli_mht       := s1.pfinancier/1000;
				v_bli_mttva     := s1.tva_pfin/1000;
				v_bli_mttc      := (s1.pfinancier+s1.tva_pfin)/1000;
				insert into genbilline(bil_id,bli_reversebli_id,bli_number,bli_reverseblinumber,bli_name,bli_exercice,ite_id,pta_id,psl_rank,
									   imp_id,bli_volumebase,bli_volumefact,bli_puht,tva_id,bli_mht,bli_mttva,bli_mttc,bli_startdt,
									   bli_enddt,vow_unit,bli_nbunites,bli_detail,bli_cancel,imc_id,imp_analytique_id,bli_periodeinit,bli_periode,
									   bli_reversedt,bli_credt,bli_updtdt,bli_updtby,meu_id,bli_name_a,bli_reverseblidec_id,bli_reverseblinumberdec,bli_reversedecdt)
								values(v_bil_id,null,v_val,null,v_ite_name,v_anneereel,v_ite_id,v_pta_id,v_psl_rank,
									   null,v_bli_volumebase,v_bli_volumefact,v_bli_puht,v_tva_id,v_bli_mht,v_bli_mttva,v_bli_mttc,v_fac_datecalcul,
									   v_fac_datecalcul,v_vow_unit,null,0,0,null,null,null,null,
									   null,sysdate,null,null,null,null,null,null,null);
				commit;
			end if;			
-------------------------------------------------------------------------------------------
-----------------------------------MONTANT CAPITAL-----------------------------------------
-------------------------------------------------------------------------------------------	
			if to_number(s1.CAPIT)>0 then
				v_val := v_val+1; 
				v_ite_name:='Montant capital ONAS';
				v_ite_id  :=1981;
				v_vow_unit:=4751; 
				v_tva_id  :=25;
				v_pta_id  :=2305;
				v_psl_rank:=1;
				v_bli_volumebase:= 1;
				v_bli_volumefact:= 1;
				v_bli_puht      := s1.capit/1000;
				v_bli_mht       := s1.capit/1000;
				v_bli_mttva     := 0;
				v_bli_mttc      := s1.capit/1000;
			    insert into genbilline(bil_id,bli_reversebli_id,bli_number,bli_reverseblinumber,bli_name,bli_exercice,ite_id,pta_id,psl_rank,
									   imp_id,bli_volumebase,bli_volumefact,bli_puht,tva_id,bli_mht,bli_mttva,bli_mttc,bli_startdt,
									   bli_enddt,vow_unit,bli_nbunites,bli_detail,bli_cancel,imc_id,imp_analytique_id,bli_periodeinit,bli_periode,
									   bli_reversedt,bli_credt,bli_updtdt,bli_updtby,meu_id,bli_name_a,bli_reverseblidec_id,bli_reverseblinumberdec,bli_reversedecdt)
							    values(v_bil_id,null,v_val,null,v_ite_name,v_anneereel,v_ite_id,v_pta_id,v_psl_rank,
									   null,v_bli_volumebase,v_bli_volumefact,v_bli_puht,v_tva_id,v_bli_mht,v_bli_mttva,v_bli_mttc,v_fac_datecalcul,
									   v_fac_datecalcul,v_vow_unit,null,0,0,null,null,null,null,
									   null,sysdate,null,null,null,null,null,null,null);
				commit;
			end if;	
-------------------------------------------------------------------------------------------
-----------------------------------Montant Interet-----------------------------------------
-------------------------------------------------------------------------------------------	
			if to_number(s1.INTER)>0 then
				v_val := v_val+1;   
				v_ite_name:='Montant interet ONAS';
				v_ite_id  :=1978;
				v_vow_unit:=4751;
				v_tva_id  :=25;
				v_pta_id  :=2302;
				v_psl_rank:=1;
				v_bli_volumebase:= 1;
				v_bli_volumefact:= 1;
				v_bli_puht      := s1.inter/1000;
				v_bli_mht       := s1.inter/1000;
				v_bli_mttva     := 0;
				v_bli_mttc      := s1.inter/1000;
				insert into genbilline(bil_id,bli_reversebli_id,bli_number,bli_reverseblinumber,bli_name,bli_exercice,ite_id,pta_id,psl_rank,
									   imp_id,bli_volumebase,bli_volumefact,bli_puht,tva_id,bli_mht,bli_mttva,bli_mttc,bli_startdt,
									   bli_enddt,vow_unit,bli_nbunites,bli_detail,bli_cancel,imc_id,imp_analytique_id,bli_periodeinit,bli_periode,
									   bli_reversedt,bli_credt,bli_updtdt,bli_updtby,meu_id,bli_name_a,bli_reverseblidec_id,bli_reverseblinumberdec,bli_reversedecdt)
								values(v_bil_id,null,v_val,null,v_ite_name,v_anneereel,v_ite_id,v_pta_id,v_psl_rank,
									   null,v_bli_volumebase,v_bli_volumefact,v_bli_puht,v_tva_id,v_bli_mht,v_bli_mttva,v_bli_mttc,v_fac_datecalcul,
									   v_fac_datecalcul,v_vow_unit,null,0,0,null,null,null,null,
									   null,sysdate,null,null,null,null,null,null,null);
				commit;
			end if;				
-------------------------------------------------------------------------------------------
-----------------------------------MONTANT REPORT------------------------------------------
-------------------------------------------------------------------------------------------	
			if to_number(s1.AREPOR)>0 then
				v_val := v_val+1; 
				v_ite_name:='Ancien report';
				v_ite_id  :=1983;
				v_vow_unit:=4751; 
				v_tva_id  :=25;
				v_pta_id  :=2307;
				v_psl_rank:=1; 
				v_bli_volumebase:= 1;
				v_bli_volumefact:= 1;
				v_bli_puht      := decode(s1.caron,'1',1,-1)*(s1.arepor/1000);
				v_bli_mht       := decode(s1.caron,'1',1,-1)*(s1.arepor/1000);
				v_bli_mttva     := 0;
				v_bli_mttc      := decode(s1.caron,'1',1,-1)*(s1.arepor/1000);
				insert into genbilline(bil_id,bli_reversebli_id,bli_number,bli_reverseblinumber,bli_name,bli_exercice,ite_id,pta_id,psl_rank,
									   imp_id,bli_volumebase,bli_volumefact,bli_puht,tva_id,bli_mht,bli_mttva,bli_mttc,bli_startdt,
									   bli_enddt,vow_unit,bli_nbunites,bli_detail,bli_cancel,imc_id,imp_analytique_id,bli_periodeinit,bli_periode,
									   bli_reversedt,bli_credt,bli_updtdt,bli_updtby,meu_id,bli_name_a,bli_reverseblidec_id,bli_reverseblinumberdec,bli_reversedecdt)
								values(v_bil_id,null,v_val,null,v_ite_name,v_anneereel,v_ite_id,v_pta_id,v_psl_rank,
									   null,v_bli_volumebase,v_bli_volumefact,v_tva_id,v_bli_mht,v_bli_mttva,v_bli_mttc,v_fac_datecalcul,
									   v_fac_datecalcul,v_vow_unit,null,0,0,null,null,null,null,
									   null,sysdate,null,null,null,null,null,null,null);			 
				commit;
			end if;	
-------------------------------------------------------------------------------------------
-----------------------------------ARRONDISSEMENT------------------------------------------
-------------------------------------------------------------------------------------------	
			if to_number(s1.NAROND)>0 then
				v_val := v_val+1; 
				V_ite_name:='Nouveau report';
				v_ite_id  :=1980;
				v_vow_unit:=4751;
				v_tva_id  :=25;
				v_pta_id  :=2304;
				v_psl_rank:=1; 
				v_bli_volumebase:= 1;
				v_bli_volumefact:= 1;
				v_bli_puht      := (decode(s1.caron,'1',-1,1)*(s1.narond/1000));
				v_bli_mht       := (decode(s1.caron,'1',-1,1)*(s1.narond/1000));
				v_bli_mttva     := 0;
				v_bli_mttc      := (decode(s1.caron,'1',-1,1)*(s1.narond/1000));
				insert into genbilline(bil_id,bli_reversebli_id,bli_number,bli_reverseblinumber,bli_name,bli_exercice,ite_id,pta_id,psl_rank,
									   imp_id,bli_volumebase,bli_volumefact,bli_puht,tva_id,bli_mht,bli_mttva,bli_mttc,bli_startdt,
									   bli_enddt,vow_unit,bli_nbunites,bli_detail,bli_cancel,imc_id,imp_analytique_id,bli_periodeinit,bli_periode,
									   bli_reversedt,bli_credt,bli_updtdt,bli_updtby,meu_id,bli_name_a,bli_reverseblidec_id,bli_reverseblinumberdec,bli_reversedecdt)
								values(v_bil_id,null,v_val,null,v_ite_name,v_anneereel,v_ite_id,v_pta_id,v_psl_rank,
									   null,v_bli_volumebase,v_bli_volumefact,v_bli_puht,v_tva_id,v_bli_mht,v_bli_mttva,0,v_bli_mttc,v_fac_datecalcul,
									   v_fac_datecalcul,v_vow_unit,null,0,0,null,null,null,null,
									   null,sysdate,null,null,null,null,null,null,null);	
				commit;
			end if;			
		end if;
	end loop;
end;	
--------------------------------------------------------------------------------------
------FACTURE_DIST -------------FACTURE_DIST----------------------FACTURE_DIST--------	
--------------------------------------------------------------------------------------
procedure MigrationFacture_dist
 (
    p_pk_etape     out varchar2,
    p_pk_exception out varchar2,
    p_district     in varchar2,
    p_tourne       in varchar2,
    p_ordre        in varchar2,
	p_spt_id       in number,
	p_imp_id       in number,
	p_sag_id       in number,
	p_par_id       in number,
	p_adr_id       in number,
	p_dat_abn      in date,
	p_vow_settlemode in number,
	p_vow_acotp     in number,
	p_vow_debtype   in number,
	p_vow_modefact  in number
) 
    IS
	cursor c1    
	is 
	select * 
	from facture f 
	where  f.annee>='2015' 
	and lpad(trim(f.district),2,'0')= p_district
	and lpad(trim(f.tournee),3,'0') = p_tourne
	and lpad(trim(f.ordre),3,'0')   = p_ordre;
	
	cursor c2 (v_fact varchar2(50))
	is 
	select count(*) nombre
	from src_impayee t
	where lpad(trim(t.district),2,'0')||
		  lpad(trim(t.tournee),3,'0')||
		  lpad(trim(t.ordre),3,'0')||
		  to_char(t.annee)||
		  lpad(trim(t.trimestre),2,'0')||'0'=v_fact;
		
	V_periode          number;
	p_org_id		   number;
	v_run_id           number;
	v_aco_id           number;
	v_sco_id           number;
	v_nbr              number;
	v_tothte           number(25,10);
	v_tva              number(25,10);
	v_tothta           number(25,10);
	v_tottvaa          number(25,10);
	v_solde            number(25,10);
	v_deb_amountinit   number(25,10);
	v_deb_amount_cash  number(25,10);
	v_bil_amountht     number(25,10);
	v_bil_amounttva    number(25,10);
	v_bil_amountttc    number(25,10);
	v_version          number(1):=0;
	v_vow_agrbilltype  number;
	v_id_facture       varchar2(50);
	v_tiers            varchar2(1);
	v_six              varchar2(1);	
	v_anneereel        varchar2(4);
	v_deb_comment      varchar2(100);
	v_train_fact       varchar2(200);
	v_fac_datecalcul   date;
begin	
	for s1 in c1 loop	 
		v_id_facture:= lpad(trim(s1.district),2,'0')||
				       lpad(trim(s1.tournee),3,'0')||
					   lpad(trim(s1.ordre),3,'0')||
					   to_char(s1.annee)||
					   lpad(trim(s1.periode),2,'0')||
					   to_char(v_version);     
		begin
			select last_day(to_date('01'||lpad(trim(s1.periode),2,'0')||s1.annee,'dd/mm/yy'))
			into v_fac_datecalcul
			from dual;
	    exception  when others then
	        v_fac_datecalcul := '01/01/2016';
	    end;
		v_anneereel:= s1.annee;
		v_periode  := s1.periode;        
		select ntiers,nsixieme
		into v_tiers,v_six
		from tourne t
		where lpad(trim(t.code),3,'0')   =lpad(trim(s1.tournee),3,'0')
		and  lpad(trim(t.district),2,'0')=lpad(trim(s1.district),2,'0');        
		v_train_fact :='ANNEE:'||trim(s1.annee)||' TRIM:'||trim(s1.periode)||' TIER:'||trim(v_tiers)||' SIX:'||trim(v_six );
		select g.org_id	
		into p_org_id 
		from genorganization g 
		where g.org_code=lpad(trim(s1.district),2,'0');	
		select count(*) into v_nbr from genbill b where b.bil_code=v_id_facture;
	 	v_tothte   :=(s1.net_a_payer/1000);
		v_tva      :=0;
		v_tothta   :=0;
		v_tottvaa  :=0;
		v_solde    :=(s1.net_a_payer/1000);
		if v_nbr=0 then 
			if (v_anneereel is not null and v_periode is not null and v_train_fact is not null) then			
				begin
					select t.run_id
					into v_run_id
					from genrun t 
					where t.run_exercice=v_anneereel
					and run_number      =v_periode;
				exception when others then 			  
					select seq_genrun.nextval into v_run_id from dual;				
				    insert into genrun (run_id,run_exercice,run_number,org_id,run_startdt,run_comment,run_name,run_dtcalc,run_enddt)
								values (v_run_id,v_anneereel,v_periode,p_org_id,v_fac_datecalcul,'Role migré','Role '||v_train_fact,v_fac_datecalcul,v_fac_datecalcul);
				end;    
			end if ; 
			v_deb_comment:=lpad(trim(s1.district),2,'0')||lpad(trim(s1.police),5,'0')||lpad(trim(s1.tournee),3,'0')||lpad(trim(s1.ordre),3,'0'); ;
			begin 
				select aco.aco_id 
				into v_aco_id
				from genaccount aco ,agrsagaco sco
				where aco.aco_id             = sco.aco_id
				and nvl(aco.par_id,0)        = p_par_id
				and nvl(aco.imp_id,0)        = p_imp_id
				and nvl(sco.sag_id,0)        = p_sag_id;				
			exception when others then 
				select seq_genaccount.nextval into v_aco_id from dual;
				insert into genaccount(aco_id,par_id,imp_id,vow_acotp,rec_id)
								values(v_aco_id,p_par_id,p_imp_id,p_vow_acotp,null);
			end;				
			begin	
				select t.sco_id
				into v_sco_id
				from agrsagaco t
				where t.aco_id=v_aco_id;
			exception when others then
				select seq_agrsagaco.nextval  into v_sco_id from dual;
				insert into agrsagaco(sco_id,sag_id,aco_id,sco_startdt)
							   values(v_sco_id,p_sag_id,v_aco_id,p_dt_abn);
			end;
			for s2 in c2 loop
				if (s2.nombre=0) then 
				 	v_deb_amount_cash  := v_tothte+v_tva+v_tothta+v_tottvaa;
					v_deb_amountinit   := v_tothte+v_tva+v_tothta+v_tottvaa;
					select seq_gendebt.nextval into debt_id from dual; 
		            insert into gendebt(deb_id,deb_refe,org_id,par_id,adr_id,deb_date,deb_duedt,deb_printdt,
										deb_amountinit,deb_amountremain,bap_id,vow_settlemode,aco_id,deb_norecovery,deb_credt,
										deb_updtby,deb_updtdt,deb_comment,deb_amount_cash,sag_id,vow_debtype,deb_prel)
								values (v_deb_id,v_id_facture,p_org_id,p_par_id,p_adr_id,v_fac_datecalcul,v_fac_datecalcul,v_fac_datecalcul,
										v_deb_amountinit,v_solde,null,p_vow_settlemode,v_aco_id,0,sysdate,
										null,null,v_deb_comment,v_deb_amount_cash,p_sag_id,p_vow_debtype,1);	
			        commit;
				else
					v_deb_amount_cash  := (v_tothte+v_tva+v_tothta+v_tottvaa);
					v_deb_amountinit   := 0;
					select seq_gendebt.nextval into debt_id from dual; 
		            insert into gendebt(deb_id,deb_refe,org_id,par_id,adr_id,deb_date,deb_duedt,deb_printdt,
										deb_amountinit,deb_amountremain,bap_id,vow_settlemode,aco_id,deb_norecovery,deb_credt,
										deb_updtby,deb_updtdt,deb_comment,deb_amount_cash,sag_id,vow_debtype,deb_prel)
								values (v_deb_id,v_id_facture,p_org_id,p_par_id,p_adr_id,v_fac_datecalcul,v_fac_datecalcul,v_fac_datecalcul,
										v_deb_amountinit,v_solde,null,p_vow_settlemode,v_aco_id,0,sysdate,
										null,null,v_deb_comment,v_deb_amount_cash,p_sag_id,p_vow_debtype,1);	
			        commit;
				end if ; 
			end loop;
			select seq_agrbill.nextval into v_bil_id from dual;
			v_vow_agrbilltype   :=  pk_genvocword.getidbycode('VOW_AGRBILLTYPE',decode(s1.etat,'P','RF','O','FC','C','FHC','FC'),null) ;
			v_bil_amountht      :=  v_tothte +v_tothta;
			v_bil_amounttva     :=  v_tva+v_tottvaa;
			v_bil_amountttc     :=  v_tothte+v_tva+v_tothta+v_tottvaa;
			insert into agrbill(bil_id,sag_id,vow_agrbilltype,vow_modefact)
						 values(v_bil_id,p_sag_id,v_vow_agrbilltype,p_vow_modefact);	
          	insert into genbill(bil_id,bil_code,bil_calcdt,bil_amountht,bil_amounttva,bil_amountttc,
			                    deb_id,par_id,bil_status,bil_amountttcdec,bil_debtdt,run_id)
						 values(v_bil_id,v_id_facture,v_fac_datecalcul,v_bil_amountht,v_bil_amounttva,v_bil_amountttc,
								v_deb_id,p_par_id,1,null,v_fac_datecalcul,v_run_id); 
		    commit;
		end if;		
	end loop;
end;	
-----------------------------------------------------------------------------------------------------
--------FACTURE_VERSION----------------FACTURE_VERSION--------------------------FACTURE_VERSION------	
-----------------------------------------------------------------------------------------------------
procedure MigrationFacture_version
 (
    p_pk_etape     out varchar2,
    p_pk_exception out varchar2,
    p_district     in varchar2,
    p_tourne       in varchar2,
    p_ordre        in varchar2
	p_spt_id       in number,
	p_imp_id       in number,
	p_sag_id       in number,
	p_par_id       in number,
	p_adr_id       in number,
	p_dat_abn      in date,
	p_vow_settlemode in number,
	p_vow_acotp     in number,
	p_vow_modefact  in number
) 
    IS
    cursor c1    
	is 
	select  b.bil_code,b.bil_calcdt,f.*,d.*
    from facture f,genbill b,gendebt d
    where trim(f.etat) in ('A','P')
    and b.bil_code = (lpad(trim(f.district),2,'0')||
					 lpad(trim(f.tournee),3,'0')||
					 lpad(trim(f.ordre),3,'0')||
					 to_char(f.annee)||
					 lpad(trim(f.periode),2,'0')||'0')
    and b.deb_id=d.deb_id
    and lpad(trim(f.district),2,'0')= p_district
    and lpad(trim(f.tournee),3,'0') = p_tourne
    and lpad(trim(f.ordre),3,'0')   = p_ordre;
	
	cursor c2(v_bil_id number)
	is 
	select * 
	from genbilline e  
	where e.bil_id=v_bil_id;
	
	cursor c3 (v_fact varchar2(50))
	is 
	select count(*) nombre
    from src_impayee t
    where trim(t.net)<>trim(t.mtpaye)
    and lpad(trim(t.district),2,'0')||
	    lpad(trim(t.tournee),3,'0')||
	    lpad(trim(t.ordre),3,'0')||
	    to_char(t.annee)||
	    lpad(trim(t.trimestre),2,'0')||'0'=v_fact;
	
    v_periode          number;
	p_org_id		   number;
	v_run_id           number;
	v_aco_id           number;
	v_sco_id           number;
	v_nbr              number;
	v_tothte           number(25,10);
	v_tva              number(25,10);
	v_tothta           number(25,10);
	v_tottvaa          number(25,10);
	v_solde            number(25,10);
	v_deb_amountinit   number(25,10);
	v_deb_amount_cash  number(25,10);
	v_bil_amountht     number(25,10);
	v_bil_amounttva    number(25,10);
	v_bil_amountttc    number(25,10);
	v_vow_debtype      number;
	v_vow_agrbilltype  number;
	v_id_facture       varchar2(50);
	v_tiers            varchar2(1);
	v_six              varchar2(1);	
	v_anneereel        varchar2(4);
	v_deb_comment      varchar2(100);
	v_train_fact       varchar2(200);
	v_fac_datecalcul   date;
begin
    for s1 in c1 loop
	    v_periode   := s1.periode;
		v_anneereel := s1.annee;
		v_fac_datecalcul := s1.bil_calcdt + 5;
		v_id_facture:= lpad(trim(s1.district),2,'0')||
		               lpad(trim(s1.tournee),3,'0')||
					   lpad(trim(s1.ordre),3,'0')||
					   to_char(v_anneereel)||
					   lpad(trim(v_periode),2,'0')||
					   trim(s1.version);
		v_train_fact:='ANNEE:'||trim(v_anneereel)||' MOIS:'||trim(v_periode);
		select t.ntiers,t.nsixieme
		into v_tiers,v_six
		from tourne t
		where lpad(trim(t.code),3,'0')    =lpad(trim(s1.tournee),3,'0')
		and   lpad(trim(t.district),2,'0')=lpad(trim(s1.district),2,'0');
		
		select g.org_id	
		into p_org_id 
		from genorganization g 
		where g.org_code=lpad(trim(s1.district),2,'0');		   
		v_tothte   :=(s1.net_a_payer/1000);
		v_tva      :=0;
		v_tothta   :=0;
		v_tottvaa  :=0;
		v_solde    :=(s1.net_a_payer/1000); 
		select count(*) into v_nbr from genbill b where b.bil_code=v_id_facture;
		if v_nbr=0 then
		    if (v_anneereel is not null and v_periode is not null and v_train_fact is not null) then			
				begin
					select t.run_id
					into v_run_id
					from genrun t 
					where t.run_exercice=v_anneereel
					and run_number      =v_periode;
				exception when others then 			  
					select seq_genrun.nextval into v_run_id from dual;				
						insert into genrun (run_id,run_exercice,run_number,org_id,run_startdt,run_comment,RUN_NAME,RUN_DTCALC,RUN_ENDDT)
									values (v_run_id,V_anneereel,V_periode,p_org_id,V_FAC_DATECALCUL,'Role migré','Role '||V_TRAIN_FACT,V_FAC_DATECALCUL,V_FAC_DATECALCUL);
				end;    
			end if ;
			begin 
				select aco.aco_id 
				into v_aco_id
				from genaccount aco ,agrsagaco sco
				where aco.aco_id = sco.aco_id
				and nvl(aco.par_id,0)        = p_par_id
				and nvl(aco.imp_id,0)        = p_imp_id
				and nvl(sco.sag_id,0)        = p_sag_id;				
			exception when others then 
				select seq_genaccount.nextval into v_aco_id from dual;
				insert into genaccount(aco_id,par_id,imp_id,vow_acotp,rec_id)
								values(v_aco_id,p_par_id,p_imp_id,p_vow_acotp,null);
			end;				
			begin	
				select t.sco_id
				into v_sco_id
				from agrsagaco t
				where t.aco_id=v_aco_id;
			exception when others then
				select seq_agrsagaco.nextval  into v_sco_id  from dual;
				insert into agrsagaco(sco_id,sag_id,aco_id,sco_startdt)
							   values(v_sco_id,p_sag_id,v_aco_id,p_dt_abn);
			end;
		    if upper(trim(s1.etat))='A' then 
				select seq_gendebt.nextval into v_deb_id from dual; 
				V_deb_amount_cash  := -(s1.deb_amountinit) ;
				v_deb_amountinit   := 0;
				v_vow_debtype      := 3135;--'Av'
				v_deb_amountremain := s1.deb_amountremain;
				v_deb_comment      := s1.deb_comment;
				insert into gendebt(deb_id,deb_refe,org_id,par_id,adr_id,deb_date,deb_duedt,deb_printdt,
									deb_amountinit,deb_amountremain,bap_id,vow_settlemode,aco_id,deb_norecovery,deb_credt,
									deb_updtby,deb_updtdt,deb_comment,deb_amount_cash,sag_id,vow_debtype,deb_prel)
							 values(v_deb_id,v_id_facture,p_org_id,p_par_id,p_adr_id,v_fac_datecalcul,v_fac_datecalcul,v_fac_datecalcul,
									v_deb_amountinit,v_deb_amountremain,null,p_vow_settlemode,v_aco_id,v_deb_norecovery,sysdate,
									null,null,v_deb_comment,v_deb_amount_cash,p_sag_id,v_vow_debtype,1);	
				commit;
				select seq_agrbill.nextval into v_bil_id from dual;
				v_vow_agrbilltype   :=  2565;--'FA'; 
				v_bil_amountht      :=  -(s1.bil_amountht);
				v_bil_amounttva     :=  -(s1.bil_amounttva);
				v_bil_amountttc     :=  -(s1.bil_amountttc);
				insert into agrbill(bil_id,sag_id,vow_agrbilltype,vow_modefact)
							values (v_bil_id,p_sag_id,v_vow_agrbilltype,p_vow_modefact);
                insert into genbill(bil_id,bil_code,bil_calcdt,bil_amountht,bil_amounttva,bil_amountttc,
									deb_id,par_id,bil_status,bil_amountttcdec,bil_debtdt,run_id)
							 values(v_bil_id,v_id_facture,v_fac_datecalcul,v_bil_amountht,v_bil_amounttva,v_bil_amountttc,
									v_deb_id,p_par_id,1,v_amountttcdec,v_fac_datecalcul,v_run_id); 
				commit; 
				for s2 in c2(s1.bil_id)loop
					insert into genbilline(bil_id,bli_reversebli_id,bli_number,bli_reverseblinumber,bli_name,bli_exercice,ite_id,pta_id,psl_rank,
					                       imp_id,bli_volumebase,bli_volumefact,bli_puht,tva_id,bli_mht,bli_mttva,bli_mttc,bli_startdt,
										   bli_enddt,vow_unit,bli_nbunites,bli_detail,bli_cancel,imc_id,imp_analytique_id,bli_periodeinit,
										   bli_periode,bli_reversedt,bli_credt,bli_updtdt,bli_updtby,meu_id,bli_name_a,bli_reverseblidec_id,bli_reverseblinumberdec,bli_reversedecdt)
									values(v_bil_id,null,s2.bli_number,null,s2.bli_name,v_anneereel,s2.ite_id,s2.pta_id,s2.psl_rank,
									       null,s2.bli_volumebase,s2.bli_volumebase,s2.bli_puht,s2.tva_id,s2.bli_mht,s2.bli_mttva,s2.bli_mttc,v_fac_datecalcul,
										   v_fac_datecalcul,s2.vow_unit,null,0,0,null,null,null,
										   null,null,sysdate,null,null,null,null,null,null,null);
				end loop;
			 
			else 
				v_deb_comment:= lpad(trim(s1.district),2,'0')||lpad(trim(s1.police),5,'0')||lpad(trim(s1.tournee),3,'0')||lpad(trim(s1.ordre),3,'0');
				select seq_gendebt.nextval into v_deb_id from dual; 
				for s3 in c3 loop
				    v_vow_debtype      := 3134;--'FA'
					if (s3.nombre=0)  then  --- Facture Normal else Facture Avoire
						v_deb_amountinit   := v_tothte+v_tva+v_tothta+v_tottvaa;
						v_deb_amount_cash  := v_tothte+v_tva+v_tothta+v_tottvaa;
						insert into gendebt(deb_id,deb_refe,org_id,par_id,adr_id,deb_date,deb_duedt,deb_printdt,
											deb_amountinit,deb_amountremain,bap_id,vow_settlemode,aco_id,deb_norecovery,deb_credt,
											deb_updtby,deb_updtdt,deb_comment,deb_amount_cash,sag_id,vow_debtype,deb_prel)
									values (v_deb_id,v_id_facture,p_org_id,p_par_id,p_adr_id,v_fac_datecalcul,v_fac_datecalcul,v_fac_datecalcul,
											v_deb_amountinit,v_solde,null,p_vow_settlemode,v_aco_id,v_deb_norecovery,sysdate,
											null,null,v_deb_comment,v_deb_amount_cash,p_sag_id,v_vow_debtype,1);	
					else
						V_deb_amount_cash  := (v_tothte+v_tva+v_tothta+v_tottvaa);
						v_deb_amountinit   := 0;
						insert into gendebt(deb_id,deb_refe,org_id,par_id,adr_id,deb_date,deb_duedt,deb_printdt,
											deb_amountinit,deb_amountremain,bap_id,vow_settlemode,aco_id,deb_norecovery,deb_credt,
											deb_updtby,deb_updtdt,deb_comment,deb_amount_cash,sag_id,vow_debtype,deb_prel)
									values (v_deb_id,v_id_facture,p_org_id,p_par_id,p_adr_id,v_fac_datecalcul,v_fac_datecalcul,v_fac_datecalcul,
											v_deb_amountinit,v_solde,null,p_vow_settlemode,v_aco_id,v_deb_norecovery,sysdate,
											null,null,v_deb_comment,v_deb_amount_cash,p_sag_id,v_vow_debtype,1);	
					end if ; 
				select seq_agrbill.nextval into v_bil_id from dual; 
				v_bil_amountht      :=  v_tothte +v_tothta;
				v_bil_amounttva     :=  v_tva+v_tottvaa;
				v_bil_amountttc     :=  v_tothte +v_tva+v_tothta+v_tottvaa;
				v_vow_agrbilltype   :=  pk_genvocword.getidbycode('VOW_AGRBILLTYPE',decode(s1.etat,'P','RF','O','FC','C','FHC','FC'),null) ;
				insert into agrbill(bil_id,sag_id,vow_agrbilltype,vow_modefact)
							 values(v_bil_id,p_sag_id,v_vow_agrbilltype,p_vow_modefact);	
				insert into genbill(bil_id,bil_code,bil_calcdt,bil_amountht,bil_amounttva,bil_amountttc,
									deb_id,par_id,bil_status,bil_amountttcdec,bil_debtdt,run_id)
							 values(v_bil_id,v_id_facture,v_fac_datecalcul,v_bil_amountht,v_bil_amounttva,v_bil_amountttc,
									v_deb_id,v_par_id,1,v_amountttcdec,v_fac_datecalcul,v_run_id); 
				commit;
			end if;
		end if;  
end loop;
end; 
-----------------------------------------------------------------------------------------
-----------FACTURE_IMPAYEE--------------FACTURE_IMPAYEE-----------FACTURE_IMPAYEE--------
-----------------------------------------------------------------------------------------
procedure MigrationFacture_impayee
 (
    p_pk_etape     out varchar2,
    p_pk_exception out varchar2,
    p_district     in varchar2,
    p_tourne       in varchar2,
    p_ordre        in varchar2
	p_spt_id       in number,
	p_imp_id       in number,
	p_sag_id       in number,
	p_par_id       in number,
	p_adr_id       in number,
	p_dat_abn      in date,
	p_vow_settlemode in number,
	p_vow_acotp     in number,
	p_vow_debtype   in   number,
	p_vow_modefact in number
) 
  IS
    cursor c1 
	is 
	select * 
	from  src_impayee p 
    where  trim(p.net)<>trim(p.mtpaye)
	and lpad(trim(p.district),2,'0')= p_district
	and lpad(trim(p.tournee),3,'0') = p_tourne
	and lpad(trim(p.ordre),3,'0')   = p_ordre;
		
	v_periode          number;
	p_org_id		   number;
	v_run_id           number;
	v_aco_id           number;
	v_sco_id           number;
	v_ite_id           number;
	v_tva_id           number;
	v_nbr              number;
	v_tothte           number(25,10);
	v_tva              number(25,10);
	v_tothta           number(25,10);
	v_tottvaa          number(25,10);
	v_solde            number(25,10);
	v_deb_amountinit   number(25,10);
	v_deb_amount_cash  number(25,10);
	v_bil_amountht     number(25,10);
	v_bil_amounttva    number(25,10);
	v_bil_amountttc    number(25,10);
	v_bli_volumebase   number(25,10);
	v_bli_volumefact   number(25,10);
	v_bli_puht         number(25,10);
	v_bli_mht          number(25,10);
	v_bli_mttva        number(25,10);
	v_bli_mttc         number(25,10);
	v_vow_agrbilltype  number;
	v_vow_unit         number;
	v_val              number; 
	v_pta_id           number; 
	v_psl_rank         number;  
	v_id_facture       varchar2(50); 	
	v_anneereel        varchar2(4);
	v_deb_comment      varchar2(100);
	v_train_fact       varchar2(200);
	v_ite_name         varchar2(100);
	v_fac_datecalcul   date;
	v_fac_datelim      date;
    for s1 in c1 loop
	    v_periode   := s1.trimestre;
		v_anneereel := s1.annee;
		begin
			select last_day(to_date('01'||lpad(s1.trimestre,2,0)||s1.annee,'ddmmyy')) 
			into v_fac_datecalcul
			from dual;
		exception when others then
		    v_fac_datecalcul := '01/01/2016';-----------------date a verifier
		end;
		v_fac_datelim:= v_fac_datecalcul+25;
		v_id_facture :=lpad(trim(s1.district),2,'0')||
					   lpad(trim(s1.tournee),3,'0')||
					   lpad(trim(s1.ordre),3,'0')||
					   to_char(v_anneereel)||
					   lpad(trim(v_periode),2,'0')||'0';
		v_train_fact :='ANNEE:'||trim(v_anneereel)||' MOIS:'||trim(v_periode);
		select count(*) into v_nbr from genbill b where b.bil_code=v_id_facture;
		if v_nbr=0 then 
			select g.org_id	
			into p_org_id 
			from genorganization g 
			where g.org_code=lpad(trim(s1.district),2,'0');
			v_tothte :=s1.net/1000;
			v_tva    :=0;
			v_tothta :=0;
			v_tottvaa:=0;
			v_solde  :=s1.net/1000;
			if (v_anneereel is not null and v_periode is not null and v_train_fact is not null) then			
				begin
					select t.run_id
					into v_run_id
					from genrun t 
					where t.run_exercice=v_anneereel
					and run_number      =v_periode;
				exception when others then 			  
					select seq_genrun.nextval into v_run_id from dual;				
					insert into genrun (run_id,run_exercice,run_number,org_id,run_startdt,run_comment,run_name,run_dtcalc,run_enddt)
								values (v_run_id,v_anneereel,v_periode,p_org_id,v_fac_datecalcul,'Role migré','Role '||v_train_fact,v_fac_datecalcul,v_fac_datecalcul);
				end;    
			end if; 
			v_deb_comment:=lpad(trim(s1.district),2,'0')||lpad(trim(s1.police),5,'0')||lpad(trim(s1.tournee),3,'0')||lpad(trim(s1.ordre),3,'0');
			begin 
				select aco.aco_id 
				into v_aco_id
				from genaccount aco ,agrsagaco sco
				where aco.aco_id             = sco.aco_id
				and nvl(aco.par_id,0)        = p_par_id
				and nvl(aco.imp_id,0)        = p_imp_id
				and nvl(sco.sag_id,0)        = p_sag_id;				
			exception when others then 
				select seq_genaccount.nextval into v_aco_id from dual;
				insert into genaccount(aco_id,par_id,imp_id,vow_acotp,rec_id)
								values(v_aco_id,p_par_id,p_imp_id,p_vow_acotp,null);
			end;				
			begin	
				select t.sco_id
				into v_sco_id
				from agrsagaco t
				where t.aco_id=v_aco_id;
			exception when others then
				select seq_agrsagaco.nextval  into v_sco_id  from dual;
				insert into agrsagaco(sco_id,sag_id,aco_id,sco_startdt)
							   values(v_sco_id,p_sag_id,v_aco_id,v_dt_abn);
			end;
			select seq_gendebt.nextval into debt_id from dual;
			v_deb_amount_cash  := (v_tothte+v_tva+v_tothta+v_tottvaa);
			v_deb_amountinit   := 0;
			insert into gendebt(deb_id,deb_refe,org_id,par_id,adr_id,deb_date,deb_duedt,deb_printdt,
								deb_amountinit,deb_amountremain,bap_id,vow_settlemode,aco_id,deb_norecovery,deb_credt,
								deb_updtby,deb_updtdt,deb_comment,deb_amount_cash,sag_id,vow_debtype,deb_prel)
						 values(v_deb_id,v_id_facture,p_org_id,p_par_id,p_adr_id,v_fac_datecalcul,v_fac_datelim,v_fac_datecalcul,
						        v_deb_amountinit,v_solde,null,p_vow_settlemode,v_aco_id,v_deb_norecovery,sysdate,
						        null,null,v_deb_comment,v_deb_amount_cash,p_sag_id,p_vow_debtype,1);	
			commit;
			select seq_agrbill.nextval into v_bil_id from dual; 
			v_vow_agrbilltype   :=  2563;--'FC' 
			insert into agrbill(bil_id,sag_id,vow_agrbilltype,vow_modefact)
						 values(v_bil_id,p_sag_id,v_vow_agrbilltype,p_vow_modefact);	
			v_bil_amountht      :=  v_tothte +v_tothta ;
			v_bil_amounttva     :=  v_tottvae+v_tottvaa ;
			v_bil_amountttc     :=  v_tothte+v_tva+v_tothta+v_tottvaa;
			insert into genbill(bil_id,bil_code,bil_calcdt,bil_amountht,bil_amounttva,bil_amountttc,
								deb_id,par_id,bil_status,bil_amountttcdec,bil_debtdt,run_id)
						 values(v_bil_id,v_id_facture,v_fac_datecalcul,v_bil_amountht,v_bil_amounttva,v_bil_amountttc,
								v_deb_id,p_par_id,1,v_amountttcdec,v_fac_datecalcul,v_run_id); 
			commit; 
-------------------------------------------------------------------------------------------
--------------------------ARTICLE DE REPRISE SONEDE----------------------------------------
-------------------------------------------------------------------------------------------							
			v_val :=1; 
			v_ite_id  :=329;
			v_ite_name:='Article de reprise SONEDE';
			v_vow_unit:=4104;
			v_tva_id  := 25;
			v_pta_id  :=325;
			v_psl_rank:=1; 
			v_bli_volumebase:= 0;
			v_bli_volumefact:= 0;
			v_bli_puht      := 0;
			v_bli_mht       := (s1.net-s1.mtonas)/1000;
			v_bli_mttva     := 0;
			v_bli_mttc      := (s1.net-s1.mtonas)/1000;
			insert into genbilline(bil_id,bli_reversebli_id,bli_number,bli_reverseblinumber,bli_name,bli_exercice,ite_id,pta_id,psl_rank,
								   imp_id,bli_volumebase,bli_volumefact,bli_puht,tva_id,bli_mht,bli_mttva,bli_mttc,bli_startdt,
								   bli_enddt,vow_unit,bli_nbunites,bli_detail,bli_cancel,imc_id,imp_analytique_id,bli_periodeinit,bli_periode,
								   bli_reversedt,bli_credt,bli_updtdt,bli_updtby,meu_id,bli_name_a,bli_reverseblidec_id,bli_reverseblinumberdec,bli_reversedecdt)
						    values(v_bil_id,null,v_val,null,v_ite_name,v_anneereel,v_ite_id,v_pta_id,v_psl_rank,
							 	   p_imp_id,v_bli_volumebase,v_bli_volumefact,v_bli_puht,v_tva_id,v_bli_mht,v_bli_mttva,v_bli_mttc,v_fac_datecalcul,
								   v_fac_datecalcul,v_vow_unit,null,0,0,null,null,null,null,
								   null,sysdate,null,null,null,null,null,null,null);		  
-------------------------------------------------------------------------------------------
----------------------------ARTICLE DE REPRISE ONAS----------------------------------------
-------------------------------------------------------------------------------------------		
			v_val := v_val+1;
			v_ite_id  :=330;
			v_ite_name:='Article de reprise ONAS';
			v_vow_unit:=4104;
			v_tva_id  := 25;
			v_pta_id  :=324;
			v_psl_rank:=1;
			v_bli_volumebase:= 0;
			v_bli_volumefact:= 0;
			v_bli_puht      := 0;
			v_bli_mht       := s1.mtonas/1000;
			v_bli_mttva     := 0;
			v_bli_mttc      := s1.mtonas/1000;
			insert into genbilline(bil_id,bli_reversebli_id,bli_number,bli_reverseblinumber,bli_name,bli_exercice,ite_id,pta_id,psl_rank,
								   imp_id,bli_volumebase,bli_volumefact,bli_puht,tva_id,bli_mht,bli_mttva,bli_mttc,bli_startdt,
								   bli_enddt,vow_unit,bli_nbunites,bli_detail,bli_cancel,imc_id,imp_analytique_id,bli_periodeinit,bli_periode,
								   bli_reversedt,bli_credt,bli_updtdt,bli_updtby,meu_id,bli_name_a,bli_reverseblidec_id,bli_reverseblinumberdec,bli_reversedecdt)
							values(v_bil_id,null,v_val,null,v_ite_name,v_anneereel,v_ite_id,v_pta_id,v_psl_rank,
								   p_imp_id,v_bli_volumebase,v_bli_volumefact,v_bli_puht,v_tva_id,v_bli_mht,v_bli_mttva,v_bli_mttc,v_fac_datecalcul,
								   v_fac_datecalcul,v_vow_unit,null,0,0,null,null,null,null,
								   null,sysdate,null,null,null,null,null,null,null);
			commit;					   
		end if;
	end loop;	
end;
end PK_MIGRATION_FACTURE;	