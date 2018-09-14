declare
  cursor c1
  is
    select rgl.police, rgl.district, dmd.code_postal, dmd.adresse_brt, dmd.client, dmd.categorie, rgl.date_prise_charge,
           fdb.cred/1000 cred, (rgl.nbr_echeance_total-1) nbre_ech, dvi.prix_global_ds_ht/1000 mnt_ht, 
           dvi.prix_global_ds_ttc/1000 mnt_ttc, rgl.montant_pr_vers_ds/1000 mnt_encaisse, rgl.nbrannee,
           dmd.etat
    from   test.fdbt108 fdb , --79004 --57316
           test.reglement_ds rgl,
           test.devis_ds dvi,
           test.demande_ds dmd
    where  lpad(to_number(fdb.pol),5,'0') = lpad(to_number(rgl.police),5,'0')
    and    lpad(to_number(fdb.dist),2,'0') = lpad(to_number(rgl.district),2,'0')
    and    trim(to_char(rgl.date_prise_charge,'ddmmyyyy')) = trim(fdb.datpc)
    and    rgl.annee_ds = dvi.annee_ds
    and    rgl.district = dvi.district
    and    rgl.code_localite_ds = dvi.code_localite_ds
    and    rgl.num_ds = dvi.num_ds
    and    rgl.num_devis_ds = dvi.num
    and    dvi.etat = 'V'
    and    rgl.annee_ds = dmd.annee
    and    rgl.district = dmd.district
    and    rgl.code_localite_ds = dmd.localite
    and    rgl.num_ds = dmd.num;
    --and    trunc(rgl.date_prise_charge) <'31/05/2018';
    --and    fdb.pol = '48148'
    --and    fdb.dist = '01';
  
  cursor c2(sag varchar2)
  is
    select sag.sag_id, par.par_id, par.adr_id, sco.aco_id, sag.sag_refe
    from   agrserviceagr sag,
           agrsagaco sco,
           agrcustagrcontact cot,
           genparty par
    where  sag.sag_refe = sag
    and    sag.sag_id = cot.sag_id
    and    cot.cot_rank = 1
    and    cot.par_id = par.par_id
    and    sag.sag_id = sco.sag_id
    and    sco.sco_enddt is null;
    
  v_dvt_id number;
  v_dit_id number := 1;
  v_par_refe varchar2(400);
  v_categ varchar2(10);
  v_par_name varchar2(400);
  v_par_telw varchar2(400);
  v_par_telm varchar2(400);
  v_par_telf varchar2(400);
  v_cd_ps varchar2(400);
  v_adresse varchar2(400);
  v_org_id number;
  v_adr_id number;
  v_par_id number;
  v_coy_id number;
  v_twn_id number;
  v_str_id number;
  v_age_id number := 0;
  v_pre_id number;
  v_spt_id number;
  v_psc_id number;
  v_sag_id number;
  v_cag_id number;
  v_cot_id number;
  v_stl_id number;
  v_sco_id number;
  v_hsf_id number;
  v_pay_id number;
  v_vow_premisetp_id number := 5596;
  v_vow_precontacttp_id number := 2890;
  v_fld_id number := 14;
  v_ctt_id number := 1;
  v_spo_id number;
  v_dpr_id number;
  v_aco_id number;
  v_deb_id number;
  v_paa_id number;
  v_twn_name varchar2(4000);
  v_imp_id number := 5 ;
  v_vow_acotp_id number := 2558;
  v_vow_usgsag_id number := 4762;
  v_vow_agrcontacttp_a number := 2574;
  v_vow_agrcontacttp_p number := 4848;
  v_vow_partytp_a number := 2887;
  v_vow_settlemode_id number := 2975;
  v_vow_nbbill_id number := 2869;
  v_vow_frqfact_id number := 2790;
  v_vow_modefactnext_id number := 2848;
  v_ofr_id number := 23;
  v_ofr_details_id number := 48;
  v_sag_refe_2 varchar2(10);
  v_bil_devis_id number;
  v_deb_withshed number;
  v_message varchar2(4000);
  v_vow_agrbilltype_id number := 4087;
  v_vow_modefact_id number := 5560;
  v_vow_debtype_id number := 3134;
  v_nbre_ech_exist number;
  err_code varchar2(4000);
  err_msg varchar2(4000);
begin
  --return;
  delete from tempo_ex_hkh;
  commit;
  for s1 in c1 loop
   begin
    select max(dvt.dvt_id)
    into   v_dvt_id
    from   gendivision div,
           gendivdit dvt
    where  div.div_code = lpad(trim(s1.district),2,'0')
    and    div.div_id = dvt.div_id
    and    dvt.dit_id = v_dit_id;
      
    select max(org_id)
    into   v_org_id
    from   genorganization
    where  org_code = lpad(trim(s1.district),2,'0');
    
    v_sag_refe_2 := lpad(to_number(s1.district),2,'0')||'0'||lpad(to_number(s1.police),5,'0');
    v_sag_id := null;
    for s2 in c2(v_sag_refe_2) loop
      v_sag_id := s2.sag_id;
      v_par_id := s2.par_id;
      v_aco_id := s2.aco_id;
      v_adr_id := s2.adr_id;
      exit;
    end loop;
    if v_sag_id is not null then
      select max(bil.bil_id), max(deb.deb_withshed), max(deb.deb_id)
      into   v_bil_devis_id, v_deb_withshed, v_deb_id
      from   agrbill abi,
             genbill bil,
             gendebt deb 
      where  abi.sag_id = v_sag_id
      and    abi.vow_agrbilltype = pk_genvocword.GetIdByCode('VOW_AGRBILLTYPE','FDEVIS',null)
      and    abi.bil_id = bil.bil_id
      and    bil.deb_id = deb.deb_id;
      
      if v_bil_devis_id is null then
        select seq_agrbill.nextval into v_bil_devis_id from dual;
        insert into agrbill(bil_id,sag_id,vow_agrbilltype,vow_modefact,abi_updtby)
                     values(v_bil_devis_id,v_sag_id,v_vow_agrbilltype_id,v_vow_modefact_id,v_age_id);
        select seq_gendebt.nextval into v_deb_id from dual;
        insert into gendebt(deb_id,deb_refe,org_id,par_id,adr_id,deb_date,deb_duedt,deb_amountinit,vow_settlemode,
                            aco_id,deb_updtby,deb_amount_cash,sag_id,vow_debtype,deb_comment_a,deb_withshed,deb_minamoutcash)
                     values(v_deb_id,to_char(v_bil_devis_id),v_org_id,v_par_id,v_adr_id,s1.date_prise_charge,s1.date_prise_charge,s1.mnt_ttc,v_vow_settlemode_id,
                            v_aco_id,v_age_id,s1.mnt_encaisse,v_sag_id,v_vow_debtype_id,'MIGRATION FDB108',
                            decode(nvl(s1.nbrannee,0),0,0,1),decode(nvl(s1.nbrannee,0),0,0,s1.mnt_encaisse));
        
        insert into genbill(bil_id,bil_code,bil_calcdt,bil_amountht,bil_amounttva,bil_amountttc,
                            deb_id,par_id,bil_debtdt,bil_updtby)
                     values(v_bil_devis_id,to_char(v_bil_devis_id),s1.date_prise_charge,s1.mnt_ht, s1.mnt_ttc-s1.mnt_ht,s1.mnt_ttc,
                            v_deb_id,v_par_id,s1.date_prise_charge,v_age_id);
      else
        update gendebt
        set    deb_comment_a = 'MIGRATION FDB108',
               aco_id = v_aco_id
        where  deb_id = v_deb_id;
      end if;
      
      select count(*)
      into   v_nbre_ech_exist
      from   genpayschedbr br
      where  br.deb_id = v_deb_id;
      
      if(v_nbre_ech_exist = 0 and v_deb_withshed = 1) then
        pk_wfhkh.FaciliteFactureBr_Hors_WF_NC(v_message,v_bil_devis_id,s1.nbre_ech,s1.cred,11,18,6);
      end if;  
      commit;
      insert into tempo_ex_hkh(obj_refe, 
                              message)
                       values(lpad(to_number(s1.district),2,'0')||'0'||lpad(to_number(s1.police),5,'0'),
                              'OK');
      commit;
      ----------    
    else
      v_par_refe := s1.district||LTRIM(rtrim(s1.CATEGORIE))||ltrim(rtrim(upper(s1.CLIENT)));
      select max(par_id)
      into   v_par_id
      from   genparty p
      where  p.par_refe = v_par_refe;
      v_aco_id := null;
      if(v_par_id is null)then
         select decode(lpad(trim(s1.CATEGORIE),2,'0'),'01','01','02','02','03','03','04','04','06','06','08','08','01')
         into   v_categ
         from dual;
         
         begin
           select c.nom, c.tel, c.autre_tel, trim(c.code_postal), c.adresse
           into   v_par_name, v_par_telw, v_par_telm, v_cd_ps, v_adresse
           from   test.client c
           where  trim(c.categorie) = s1.CATEGORIE
           and    trim(c.code) = s1.CLIENT 
           and    trim(c.district) = s1.district;
         exception when no_data_found then
           begin
             select c.desig, null, null, trim(c.code_postal), c.adresse
             into   v_par_name, v_par_telw, v_par_telm, v_cd_ps, v_adresse
             from   test.adm c
             where  trim(c.code) = s1.CLIENT
             and    trim(c.district) = s1.district;  
           exception when no_data_found then
             v_par_name := s1.CLIENT;
             v_cd_ps := s1.code_postal;
             v_adresse := '-';
           end;
         end;
         
         select coy_id
         into   v_coy_id 
         from   gencountry
         where  coy_code = 'TN';
         
         select max(twn_id)
         into   v_twn_id
         from   gentown t
         where  t.twn_code = v_cd_ps;
         
         if(v_twn_id is null) then
            SELECT max(A.DESIG) 
            INTO   v_twn_name
            FROM   test.postal A 
            WHERE TO_CHAR(A.code) = TRIM(v_cd_ps);
          
            select seq_gentown.nextval into v_twn_id from dual;  
            insert into gentown(twn_id,twn_code,twn_name,twn_namek,twn_namer,
                                twn_zipcode,coy_id,twn_served,twn_credt,
                                twn_updtby,twn_name_a,twn_namek_a)
                         values(v_twn_id,v_cd_ps,v_twn_name,v_twn_name,v_twn_name,
                                v_cd_ps,v_coy_id,1,sysdate,
                                v_age_id,v_twn_name,'MIG-DEMANDE');      
         end if;
         
         select max(str_id)
         into   v_str_id 
         from   genstreet s
         where  s.str_namek = v_adresse
         and    s.twn_id = v_twn_id;
         
         if(v_str_id is null) then
          select seq_genstreet.nextval into v_str_id from dual;
          insert into genstreet(str_id,str_name,str_namek,str_namer,twn_id,
                                str_served,str_credt,str_updtby,str_name_a,str_namek_a)
                         values(v_str_id,v_adresse,v_adresse,v_adresse,v_twn_id,
                                1,sysdate,v_age_id, v_adresse,'MIG-DEMANDE');
         end if;
         
         select seq_genadress.nextval into v_adr_id from dual;
         insert into genadress(adr_id,str_id)
                        values(v_adr_id,v_str_id);
         
         select seq_genparty.nextval into v_par_id from dual;
         insert into genparty(par_id,par_refe, par_lname,par_kname,adr_id,par_telw,
                             par_telm,par_telf,vow_typsag,vow_partytp,par_info)
                      values(v_par_id,v_par_refe,v_par_name,v_par_name,v_adr_id,v_par_telw,
                             v_par_telm,v_par_telf,
                             pk_genvocword.GetIdByCode('VOW_TYPSAG',v_categ,null),
                             v_vow_partytp_a,'MIG-DEMANDE');
      else
        select max(aco_id)
        into   v_aco_id
        from   genaccount
        where  par_id = v_par_id;
      end if;
      
      if v_aco_id is null then
        select seq_genaccount.nextval into v_aco_id from dual;
        insert into genaccount(aco_id,par_id,imp_id,vow_acotp,aco_status,aco_updtby)
                         values(v_aco_id,v_par_id,v_imp_id,v_vow_acotp_id,1,v_age_id);
      end if;
      v_adr_id := nvl(v_adr_id,0);
      select seq_tecpremise.nextval into v_pre_id from dual;
      insert into tecpremise(pre_id,pre_refe,adr_id,vow_premisetp,pre_updtby)
                      values(v_pre_id,to_char(v_pre_id),v_adr_id,v_vow_premisetp_id,v_age_id);
      
      select seq_tecservicepoint.nextval into v_spt_id from dual;
      insert into tecservicepoint(spt_id,spt_refe,pre_id,fld_id,adr_id,spt_updtby,ctt_id)
                           values(v_spt_id,to_char(v_pre_id),v_pre_id,v_fld_id,v_adr_id,v_age_id,v_ctt_id);
      
      select seq_tecpresptcontact.nextval into v_psc_id from dual;
      insert into tecpresptcontact(psc_id,par_id,pre_id,spt_id,vow_precontacttp,
                                   psc_startdt,psc_rank,psc_updtby)
                            values(v_psc_id,v_par_id,v_pre_id,null,2890,
                                   s1.date_prise_charge,1,v_age_id);
      select seq_tecpresptcontact.nextval into v_psc_id from dual;
      insert into tecpresptcontact(psc_id,par_id,pre_id,spt_id,vow_precontacttp,
                                   psc_startdt,psc_rank,psc_updtby)
                            values(v_psc_id,v_par_id,v_pre_id,v_spt_id,2890,
                                   s1.date_prise_charge,2,v_age_id);
      
      select seq_tecsptorg.nextval into v_spo_id from dual;
      insert into tecsptorg(spo_id,spt_id,org_id,spo_updtby)
                     values(v_spo_id,v_spt_id,v_org_id,v_age_id);
      
      select seq_gendivspt.nextval into v_dpr_id from dual;
      insert into gendivspt(dpr_id,dvt_id,spt_id,dpr_updtby)
                     values(v_dpr_id,v_dvt_id,v_spt_id,v_age_id);
                     
      select seq_agrcustomeragr.nextval into v_cag_id from dual;
      insert into agrcustomeragr(cag_id,cag_refe,cag_startdt,pre_id,par_id,cag_updtby)
                          values(v_cag_id,to_char(v_cag_id),s1.date_prise_charge,v_pre_id,v_par_id,v_age_id);
                          
      select seq_agrserviceagr.nextval into v_sag_id from dual;
      insert into agrserviceagr(sag_id,sag_refe,sag_startdt,cag_id,spt_id,ctt_id,vow_usgsag,sag_comment_a)
                         values(v_sag_id,to_char(v_cag_id),s1.date_prise_charge,v_cag_id,v_spt_id,v_ctt_id,v_vow_usgsag_id,'MIGRATION FDB108');
      
      select seq_agrcustagrcontact.nextval into v_cot_id from dual;
      insert into agrcustagrcontact(cot_id,cag_id,sag_id,par_id,cot_startdt,vow_agrcontacttp,cot_rank,cot_updtby)
                             values(v_cot_id,v_cag_id,v_sag_id,v_par_id,s1.date_prise_charge,v_vow_agrcontacttp_a,1,v_age_id);
                             
      select seq_agrcustagrcontact.nextval into v_cot_id from dual;
      insert into agrcustagrcontact(cot_id,cag_id,sag_id,par_id,cot_startdt,vow_agrcontacttp,cot_rank,cot_updtby)
                             values(v_cot_id,v_cag_id,v_sag_id,v_par_id,s1.date_prise_charge,v_vow_agrcontacttp_p,2,v_age_id);
      
      select seq_genpartyparty.nextval into v_paa_id from dual;
      insert into genpartyparty(paa_id,par_parent_id,vow_partytp,paa_startdt,paa_updtby,adr_id)
                         values(v_paa_id,v_par_id,v_vow_partytp_a,s1.date_prise_charge,v_age_id,v_adr_id);

      select seq_agrpayor.nextval into v_pay_id from dual;   
      insert into agrpayor(pay_id,cot_id,paa_id,pay_updtby)
                    values(v_pay_id,v_cot_id,v_paa_id,v_age_id);
      
      select seq_agrsettlement.nextval into v_stl_id from dual;
      insert into agrsettlement(stl_id,sag_id,stl_startdt,vow_settlemode,vow_nbbill,dlp_id,stl_updtby)
                         values(v_stl_id,v_sag_id,s1.date_prise_charge,v_vow_settlemode_id,v_vow_nbbill_id,2,v_age_id);
      
      insert into agrplanningagr(sag_id,vow_frqfact,agp_factday,agp_nextfactdt,vow_modefactnext,agp_updtby)
                          values(v_sag_id,v_vow_frqfact_id,10,sysdate,v_vow_modefactnext_id,v_age_id);
      
      select seq_agrsagaco.nextval into v_sco_id from dual;
      insert into agrsagaco(sco_id,sco_startdt,sag_id,aco_id,sco_updtby)
                     values(v_sco_id,s1.date_prise_charge,v_sag_id,v_aco_id,v_age_id);
                          
      select seq_agrhsagofr.nextval into v_hsf_id from dual;
      insert into agrhsagofr(hsf_id,sag_id,ofr_id,ofr_detail_id,hsf_startdt,hsf_updtby)
                      values(v_hsf_id,v_sag_id,v_ofr_id,v_ofr_details_id,s1.date_prise_charge,v_age_id);
                      
                      
                      
      select seq_agrbill.nextval into v_bil_devis_id from dual;
      insert into agrbill(bil_id,sag_id,vow_agrbilltype,vow_modefact,abi_updtby)
                   values(v_bil_devis_id,v_sag_id,v_vow_agrbilltype_id,v_vow_modefact_id,v_age_id);
      select seq_gendebt.nextval into v_deb_id from dual;
      insert into gendebt(deb_id,deb_refe,org_id,par_id,adr_id,deb_date,deb_duedt,deb_amountinit,vow_settlemode,
                          aco_id,deb_updtby,deb_amount_cash,sag_id,vow_debtype,deb_comment_a,deb_withshed,deb_minamoutcash)
                   values(v_deb_id,to_char(v_bil_devis_id),v_org_id,v_par_id,v_adr_id,s1.date_prise_charge,s1.date_prise_charge,s1.mnt_ttc,v_vow_settlemode_id,
                          v_aco_id,v_age_id,s1.mnt_encaisse,v_sag_id,v_vow_debtype_id,'MIGRATION FDB108',
                          decode(nvl(s1.nbrannee,0),0,0,1),decode(nvl(s1.nbrannee,0),0,0,s1.mnt_encaisse));
      
      insert into genbill(bil_id,bil_code,bil_calcdt,bil_amountht,bil_amounttva,bil_amountttc,
                          deb_id,par_id,bil_debtdt,bil_updtby)
                   values(v_bil_devis_id,to_char(v_bil_devis_id),s1.date_prise_charge,s1.mnt_ht, s1.mnt_ttc-s1.mnt_ht,s1.mnt_ttc,
                          v_deb_id,v_par_id,s1.date_prise_charge,v_age_id);
      
      if(nvl(s1.nbrannee,0) >0) then
        pk_wfhkh.FaciliteFactureBr_Hors_WF_NC(v_message,v_bil_devis_id,s1.nbre_ech,s1.cred,11,18,6);
      end if;
      commit;
      insert into tempo_ex_hkh(obj_refe, 
                              message)
                       values(lpad(to_number(s1.district),2,'0')||'0'||lpad(to_number(s1.police),5,'0'),
                              'OK');
      commit;
      ------
    end if;
   exception when others then
     rollback;
     err_code := SQLCODE;
     err_msg := SUBSTR(SQLERRM, 1, 200);
     insert into tempo_ex_hkh(obj_refe, 
                              message)
                       values(lpad(to_number(s1.district),2,'0')||'0'||lpad(to_number(s1.police),5,'0'),
                              'ERROR:'||err_code||'-'||err_msg);
     commit;
   end;                 
  end loop;
end;
