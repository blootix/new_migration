 CREATE OR REPLACE PACKAGE PK_MIGRATION
AS


PROCEDURE MigrationQuotidien
  (
    p_param in number default 0
  );
  
PROCEDURE MigrationTousClients
  (
    p_param in number default 0
  );

PROCEDURE MigrationHistoriqueReleveTrim
  (
    p_param in number default 0
  );
  
PROCEDURE MigrationReleveT
  (
    p_param in number default 0
  );
  
PROCEDURE MigrationReleveGC
  (
    p_param in number default 0
  );
 
PROCEDURE MigrationFactureAS400
  (
    p_param in number default 0
  );

PROCEDURE MigrationFactureDist
  (
    p_param in number default 0
  );
  
PROCEDURE MigrationFactureVersion
  (
    p_param in number default 0
  );
  
PROCEDURE MigrationMAJImpayees
  (
    p_param in number default 0    
  )  ;
    
PROCEDURE MigrationFactureImpayee
  (
    p_param in number default 0
  );
 
PROCEDURE MigrationFactureB1
  (
    p_param in number default 0
  );
PROCEDURE MigrationFactureB2
(
   p_param in number default 0
);
  PROCEDURE MigrationAttachFactureReleve
  (
    p_param in number default 0
  );
PROCEDURE MigrationCorrectionHistoReleve
(
 p_param in number default 0
);
PROCEDURE MigrationFactureAnnulation
(
  p_param in number default 0
);
PROCEDURE MigrationLienTrain
(
  p_param in number default 0
);
 PROCEDURE MigrationPreviousReleve
   (
     p_param in number default 0
   );
PROCEDURE MigrationDossierEnCours
  (
    p_pk_etape out varchar2,
    p_pk_exception out varchar2,
    p_param in number default 0
  );

end PK_MIGRATION;
/
CREATE OR REPLACE PACKAGE BODY PK_MIGRATION
AS 
v_g_coy_id number := 1;
v_g_age_id number := 0;
v_g_meu_id number:= 5;
v_g_vow_streettp number := 5725;
v_g_vow_title number := 4101;
v_g_vow_partytp number := 2884;
v_g_vow_premisetp number := 2902;
v_g_vow_precontacttp_id number := 2890;
v_g_fld_id number := 14;
v_g_ctt_id number := 1;
v_g_dit_id number := 1;
v_g_err_code varchar2(400);
v_g_err_msg varchar2(400);
v_g_vow_spstatus_actif number := 2988;
v_g_vow_spstatus_res number := 4442;
v_g_vow_equstatus_id number := 2777;
v_g_vow_model_id number := 5841;
v_g_eqy_id number := 1;
v_g_vow_manufact_id number := 4414;
v_g_vow_owner_id number := 4413;
v_g_vow_diam_id number := 5838;
v_g_vow_class_id number := 3582;
v_g_mmo_id number := 7724799;
v_g_vow_methpos number := 4459;
v_g_vow_methdep number := 4461;
v_g_vow_reaspose number := 4889;
v_g_vow_reasdepose number := 5561;
v_g_vow_usgsag_id number := 4800;
v_g_vow_cutagree_id number := 4103;
v_g_vow_agrcontacttp_a number := 2574;
v_g_vow_agrcontacttp_p number := 4848;
v_g_vow_partytp_a    number := 2887;
v_g_vow_readorig     number := 5536;--'migration'-03
v_g_vow_readmeth     number := 5537;--inconn(migration)
v_g_vow_readmeth_g   number := 5863;--Generer
v_g_vow_readreason_t number := 5538;
v_g_vow_readreason_c number := 4895;
v_g_mrd_etatfact number:=0;
v_g_mrd_agrtype number:=0;
v_g_mrd_techtype number:=0;
v_g_mod_con_id number := 10446;
v_g_vow_typlist_age number := 3045;
v_g_vow_typlist_lit number := 3046;
v_g_vow_roleage_id number := 2943;
v_g_vow_roleitc_id number := 2959;
v_g_rec_part_id number := 4;
v_g_rec_adm_id number := 7;
v_g_rec_mens_id number := 8;
v_g_rec_dom_id number := 9;
v_g_dlp_part_id number := 2;
v_g_dlp_adm_id number := 4;
v_g_dlp_mens_id number := 3;
v_g_dlp_dom_id number := 5;
v_g_vow_oridmd_id number := 5595;
v_g_vow_frqfact_trm number := 2790;
v_g_vow_frqfact_mns number := 2788;
v_g_imp_id number := 5;
v_g_vow_acotp_id number := 2558;
v_g_agp_factday date := sysdate;
v_g_vow_modefactnext number := 5563;
v_g_vow_settlemode_a number := 2975;
v_g_vow_settlemode_d number := 2973;
v_g_vow_nbbill_1 number := 2869;
v_g_ofr_mig number := 49;
v_g_ofr_01 number := 23;
v_g_ofr_03 number := 25;
v_g_ofr_04 number := 26;
v_g_ofr_05 number := 27;
v_g_ofr_06 number := 28;
v_g_ofr_11 number := 46;
v_g_ofr_21 number := 47;
v_g_ofr_onas0 number := 48;
v_g_ofr_onas1 number := 32;
v_g_ofr_onas2 number := 40;
v_g_ofr_onas3 number := 35;
v_g_ofr_onas4 number := 31;
v_g_ofr_onas5 number := 41;
v_g_ofr_onas6 number := 43;
v_g_ofr_onas8 number := 36;
v_g_ofr_onas9 number := 39;
v_g_ofr_onasA number := 33;
v_g_ofr_onasC number := 34;
v_g_sut_arr number := 100030;
v_g_sut_echt_onas number := 100026;
v_g_sut_echr_onas number := 100027;
v_g_sut_capi_onas number := 100029;
v_g_sut_intr_onas number := 100028;
v_g_sut_pol_onas number := 100004;
v_g_sut_puit_onas number := 100025;
v_g_sut_plaf_onas number := 100003;
v_g_sut_gros_cons number := 100033;
v_g_meu_eau number := 5;
v_g_meu_ten1 number := 9;
v_g_meu_ten2 number := 10;
v_g_meu_ten3 number := 11;
v_g_meu_ten4 number := 12;
v_g_meu_ten5 number := 13;
v_g_meu_avis number := 52;
v_g_meu_cpt_t number := 13;
v_g_mtc_id number := 1116540;
v_g_vow_debtype     number:= 3134;---'FA' 
v_g_vow_modefact    number:= 5560;---'MIG'
v_g_vow_agrbilltype number:= 2563;---'FC'
v_g_vow_agrbilltype_a number :=2565 ;--AV
v_g_vow_debtype_a number := 3135; --AV
v_g_vow_agrbilltype_hc number := 2567; --FHC
v_g_vow_agrbilltype_rf number := 2566; --FHC

-------------------------------------------------------------------------------------------
-------------------------------------------------------------------------------------------
PROCEDURE EXCEPTION_CLIENT
  (
    p_obj_refe in varchar2,
    p_code_except in varchar2,
    p_message_except in varchar2,
    p_pk_etape in varchar2
  )
 IS
  PRAGMA AUTONOMOUS_TRANSACTION;
 BEGIN
    insert into prob_mig_client(obj_refe,code_except,message_except,pk_etape,date_except)
                         values(p_obj_refe,p_code_except,p_message_except,p_pk_etape,sysdate);
    commit;
 END;
-------------------------------------------------------------------------------------------
-------------------------------------------------------------------------------------------
PROCEDURE EXCEPTION_PDL
  (
    p_obj_refe in varchar2,
    p_code_except in varchar2,
    p_message_except in varchar2,
    p_pk_etape in varchar2
  )
 IS
  PRAGMA AUTONOMOUS_TRANSACTION;
 BEGIN
    insert into prob_mig_pdl(obj_refe,code_except,message_except,pk_etape,date_except)
                         values(p_obj_refe,p_code_except,p_message_except,p_pk_etape,sysdate);
    commit;
 END;
-------------------------------------------------------------------------------------------
-------------------------------------------------------------------------------------------
PROCEDURE EXCEPTION_CONTRAT
  (
    p_obj_refe in varchar2,
    p_code_except in varchar2,
    p_message_except in varchar2,
    p_pk_etape in varchar2
  )
 IS
  PRAGMA AUTONOMOUS_TRANSACTION;
 BEGIN
    insert into prob_mig_contrat(obj_refe,code_except,message_except,pk_etape,date_except)
                         values(p_obj_refe,p_code_except,p_message_except,p_pk_etape,sysdate);
    commit;
 END;
-------------------------------------------------------------------------------------------
-------------------------------------------------------------------------------------------
PROCEDURE EXCEPTION_RELEVE
  (
    p_obj_refe in varchar2,
    p_code_except in varchar2,
    p_message_except in varchar2,
    p_pk_etape in varchar2
  )
 IS
  PRAGMA AUTONOMOUS_TRANSACTION;
 BEGIN
    insert into prob_mig_releve(obj_refe,code_except,message_except,pk_etape,date_except)
                         values(p_obj_refe,p_code_except,p_message_except,p_pk_etape,sysdate);
    commit;
 END;
-------------------------------------------------------------------------------------------
-------------------------------------------------------------------------------------------
PROCEDURE EXCEPTION_FACTURE
  (
    p_obj_refe in varchar2,
    p_code_except in varchar2,
    p_message_except in varchar2,
    p_pk_etape in varchar2
  )
 IS
  PRAGMA AUTONOMOUS_TRANSACTION;
 BEGIN
    insert into prob_mig_facture(obj_refe,code_except,message_except,pk_etape,date_except)
                         values(p_obj_refe,p_code_except,p_message_except,p_pk_etape,sysdate);
    commit;
 END;
-------------------------------------------------------------------------------------------
-------------------------------------------------------------------------------------------
PROCEDURE EXCEPTION_RELEVET
  (
    p_obj_refe in varchar2,
    p_code_except in varchar2,
    p_message_except in varchar2,
    p_pk_etape in varchar2
  )
 IS
  PRAGMA AUTONOMOUS_TRANSACTION;
 BEGIN
    insert into prob_mig_relevet(obj_refe,code_except,message_except,pk_etape,date_except)
                         values(p_obj_refe,p_code_except,p_message_except,p_pk_etape,sysdate);
    commit;
 END;
-------------------------------------------------------------------------------------------
-------------------------------------------------------------------------------------------
PROCEDURE EXCEPTION_RELEVEGC
  (
    p_obj_refe in varchar2,
    p_code_except in varchar2,
    p_message_except in varchar2,
    p_pk_etape in varchar2
  )
 IS
  PRAGMA AUTONOMOUS_TRANSACTION;
 BEGIN
    insert into prob_mig_relevegc(obj_refe,code_except,message_except,pk_etape,date_except)
                         values(p_obj_refe,p_code_except,p_message_except,p_pk_etape,sysdate);
    commit;
 END;
-------------------------------------------------------------------------------------------
-------------------------------------------------------------------------------------------
PROCEDURE EXCEPTION_B1
  (
    p_obj_refe in varchar2,
    p_code_except in varchar2,
    p_message_except in varchar2,
    p_pk_etape in varchar2
  )
 IS
  PRAGMA AUTONOMOUS_TRANSACTION;
 BEGIN
    insert into prob_mig_b1(obj_refe,code_except,message_except,pk_etape,date_except)
                         values(p_obj_refe,p_code_except,p_message_except,p_pk_etape,sysdate);
    commit;
 END;
-------------------------------------------------------------------------------------------
-------------------------------------------------------------------------------------------
PROCEDURE EXCEPTION_B2
  (
    p_obj_refe in varchar2,
    p_code_except in varchar2,
    p_message_except in varchar2,
    p_pk_etape in varchar2
  )
 IS
  PRAGMA AUTONOMOUS_TRANSACTION;
 BEGIN
    insert into prob_mig_b2(obj_refe,code_except,message_except,pk_etape,date_except)
                         values(p_obj_refe,p_code_except,p_message_except,p_pk_etape,sysdate);
    commit;
 END;
-------------------------------------------------------------------------------------------
-------------------------------------------------------------------------------------------
PROCEDURE MigrationAdresse
  (
    p_pk_etape out varchar2,
    p_pk_exception out varchar2,
    p_adr_id out number,
    p_adresse in out varchar2,
    p_code_postal in out varchar2
  )
  IS
    v_twn_id number;
    v_ville_name varchar2(4000);
    v_str_id number;

  BEGIN
    if p_adresse is null then
      p_adresse:= '-';
    end if;
    
    if p_code_postal is null then
      p_code_postal := '0000';
    end if;
    --Ville existante?
    p_pk_etape := 'Recherche/Creation ville';
    select max(twn_id)
    into   v_twn_id
    from   gentown
    where  twn_zipcode = p_code_postal;

    --Creation ville sil nexiste pas
    if(v_twn_id is null)then
       select max(p.libelle)
       into   v_ville_name
       from   r_cpostal p
       where  lpad(to_char(p.kcpost),4,'0') = p_code_postal;

       select seq_gentown.nextval into v_twn_id from dual;
       insert into gentown(twn_id, twn_code, twn_name, twn_namek,twn_namer, twn_zipcode, coy_id, twn_served, twn_updtby)
                    values(v_twn_id, p_code_postal,nvl(v_ville_name,p_code_postal),nvl(v_ville_name,p_code_postal),nvl(v_ville_name,p_code_postal),p_code_postal,v_g_coy_id, 1, v_g_age_id);
    end if;
    --Creation rue
    p_pk_etape := 'Creation rue';
    select max(str_id)
    into   v_str_id
    from   genstreet
    where  twn_id = v_twn_id
    and    vow_streettp = v_g_vow_streettp
    and    str_namek = p_adresse;
    if v_str_id is null then
      select seq_genstreet.nextval into v_str_id from dual;
        insert into genstreet(str_id, str_name, str_namek, str_namer, twn_id, vow_streettp, str_zipcode, str_served, str_updtby)
                       values(v_str_id, p_adresse, p_adresse, p_adresse, v_twn_id, v_g_vow_streettp, p_code_postal, 1, v_g_age_id);
    end if;
    --Creation adresse
    p_pk_etape := 'Creation adresse client';
    select seq_genadress.nextval into p_adr_id from dual;
    insert into genadress(adr_id, str_id,adr_zipcode, adr_updtby)
                   values(p_adr_id, v_str_id, p_code_postal, v_g_age_id);
  EXCEPTION WHEN OTHERS THEN
   v_g_err_code := SQLCODE;
   v_g_err_msg := SUBSTR(SQLERRM, 1, 200);
   p_pk_exception := v_g_err_code || ' : ' ||  v_g_err_msg;
  END;
--------------------------------------------------------------------------------------------------------------------
--------------------------------------------------------------------------------------------------------------------
PROCEDURE MigrationClient
  (
    p_pk_etape out varchar2,
    p_pk_exception out varchar2,
    p_par_id out number,
    p_adresse in out  varchar2,
    p_code_postal in out number,
    p_code_cli in varchar2,
    p_categorie in varchar,
    p_nom in varchar2,
    p_tel in varchar2,
    p_autre_tel in varchar2,
    p_fax in varchar2
  )
  IS
    v_code_postal number;
    v_vow_typsag number;
    v_adr_id number;
  BEGIN
    p_pk_etape := 'Client existant';
    select max(par_id)
    into   p_par_id
    from   genparty
    where  par_refe = p_code_cli;

    if p_par_id is not null then
      p_pk_exception := 'Client :'||p_code_cli||' existe deja';
      return;
    end if;
    
    p_pk_etape := 'creation adresse client';
    MigrationAdresse(p_pk_etape,p_pk_exception,v_adr_id,p_adresse,p_code_postal);
    if p_pk_exception is not null then
      return;
    end if;


    p_pk_etape := 'Selection de la cart�gorie client';
    select vow_id
    into   v_vow_typsag
    from   v_genvocword
    where  voc_code = 'VOW_TYPSAG'
    and    vow_code = decode(lpad(trim(p_categorie),2,'0'),'01','01','02','02','03','10','04','04','08','08','01');

    if(v_vow_typsag is null)then
      p_pk_etape := 'Impossible de trouvre la categorie du client ' || p_code_cli;
      return;
    else
      p_pk_etape := 'Creation du client';
      select seq_genparty.nextval into p_par_id from dual;
      insert into genparty(par_id,par_refe,par_lname,par_kname,vow_title,adr_id,par_telw,par_telp,par_telf,
                           vow_typsag,vow_partytp, par_status, par_profexotva, par_search, par_updtby)
                    values(p_par_id,p_code_cli,nvl(trim(p_nom),'-'),trim(replace(nvl(trim(p_nom),'-'),' ','')),v_g_vow_title,v_adr_id,trim(p_tel),trim(p_autre_tel),trim(p_fax),
                           v_vow_typsag,v_g_vow_partytp,1,0,1,v_g_age_id);
    end if;
  EXCEPTION WHEN OTHERS THEN
   v_g_err_code := SQLCODE;
   v_g_err_msg := SUBSTR(SQLERRM, 1, 200);
   p_pk_exception := v_g_err_code || ' : ' ||  v_g_err_msg;
  END;
--------------------------------------------------------------------------------------------------------------------
--------------------------------------------------------------------------------------------------------------------
PROCEDURE MigrationSitePdl
  (
    p_pk_etape out varchar2,
    p_pk_exception out varchar2,
    p_pre_id out number,
    p_spt_id out number,
    p_rou_id out number,
    p_adr_id out number,
    p_par_id in number,
    p_adresse in out varchar2,
    p_code_postal in out number,
    p_district in varchar2,
    p_tourne in varchar2,
    p_ordre in varchar2,
    p_police in varchar2,
    p_date_creation in date,
    p_date_resil in date,
    p_dvt_id in number,
    p_org_id in number,
    p_etat_branchement in varchar2
  )
  IS
  v_psc_id number;
  v_dpr_id number;
  v_spo_id number;
  v_sps_id number;
  v_cnn_id number;
  v_hcs_id number;
  v_tiers number;
  v_sixieme number;
  v_code_br varchar2(100);
  BEGIN
    v_code_br := p_district||p_tourne||p_ordre||p_police;
    p_pk_etape := 'PDL existante';
    select max(spt_id)
    into   p_spt_id
    from   tecservicepoint
    where  spt_refe = v_code_br;

    if p_spt_id is not null then
      p_pk_exception := 'PDL :'||v_code_br||' existe deja';
      return;
    end if;

    MigrationAdresse(p_pk_etape,p_pk_exception,p_adr_id,p_adresse,p_code_postal);
    if p_pk_exception is not null then
      return;
    end if;
    
    
    p_pk_etape := 'Recherche/Creation tournee';
    if(p_tourne in ('898','899'))then
			
      BEGIN
        select rou_id
        into   p_rou_id 
        from   tecroute
        where  rou_code=p_district||'_AS';
      EXCEPTION WHEN no_data_found THEN
        select seq_tecroute.nextval into p_rou_id from dual;
        insert into tecroute(rou_id,rou_sect,rou_code,rou_name,rou_updtby)
                values(p_rou_id,p_dvt_id,p_district||'_AS',p_district||'_AS', v_g_age_id);
      END;
    else
      BEGIN
        select rou_id
        into   p_rou_id
        from   tecroute
        where  rou_code = p_district||'-'||p_tourne;
      EXCEPTION WHEN OTHERS THEN
        select t.ntiers,t.nsixieme
        into   v_tiers,v_sixieme
        from   test.src_tourne t
        where  lpad(trim(t.code),3,'0') = p_tourne
        and    lpad(trim(t.district),2,'0') = p_district;
        select seq_tecroute.nextval into p_rou_id from dual;
        insert into tecroute(rou_id,rou_sect,rou_code,rou_name,rou_updtby)
                values(p_rou_id,p_dvt_id,p_district||'-'||p_tourne,p_tourne,v_g_age_id);

        insert into tecroucut(rou_id,rcu_third,rcu_sixth,rcu_monthly)
                       values(p_rou_id,v_tiers,v_sixieme,decode(v_tiers,0,1,0));
      END;
    end if;
    
    p_pk_etape := 'Creation du site/pdl';
    select seq_tecpremise.nextval into p_pre_id from dual;
    insert into tecpremise(pre_id,pre_refe,adr_id,vow_premisetp,pre_updtby)
                    values(p_pre_id,v_code_br,p_adr_id,v_g_vow_premisetp,v_g_age_id);

    select seq_tecservicepoint.nextval into p_spt_id from dual;
    insert into tecservicepoint(spt_id,spt_refe,pre_id,rou_id,spt_routeorder,fld_id,adr_id,spt_updtby,ctt_id)
                           values(p_spt_id,v_code_br,p_pre_id,p_rou_id,to_number(p_ordre),v_g_fld_id,p_adr_id,v_g_age_id,v_g_ctt_id);
    
    p_pk_etape := 'Creation du proprietaire site/pdl';
    select seq_tecpresptcontact.nextval into v_psc_id from dual;
    insert into tecpresptcontact(psc_id,pre_id,par_id,vow_precontacttp,psc_startdt,psc_enddt,psc_rank,psc_updtby)
                          values(v_psc_id, p_pre_id,p_par_id,v_g_vow_precontacttp_id, p_date_creation, decode(p_etat_branchement, '0', Null, p_date_resil), 1, v_g_age_id);

    select seq_tecpresptcontact.nextval into v_psc_id from dual;
    insert into tecpresptcontact(psc_id,pre_id,spt_id,par_id,vow_precontacttp,psc_startdt,psc_enddt,psc_rank,psc_updtby)
                          values(v_psc_id,p_pre_id,p_spt_id,p_par_id,v_g_vow_precontacttp_id, p_date_creation, decode(p_etat_branchement, '0', Null, p_date_resil), 2, v_g_age_id);

    p_pk_etape := 'Creation du organisation spt';
    select seq_tecsptorg.nextval into v_spo_id from dual;
      insert into tecsptorg(spo_id,spt_id,org_id,spo_updtby)
                     values(v_spo_id,p_spt_id,p_org_id,v_g_age_id);

    p_pk_etape := 'Creation du secteur spt';
    select seq_gendivspt.nextval into v_dpr_id from dual;
    insert into gendivspt(dpr_id,dvt_id,spt_id,dpr_updtby)
                   values(v_dpr_id,p_dvt_id,p_spt_id,v_g_age_id);

    p_pk_etape := 'Creation du etat PDL';
    select seq_tecspstatus.nextval into v_sps_id from dual;
    insert into tecspstatus(sps_id,spt_id,vow_spstatus,sps_startdt,sps_enddt,sps_updtby,sps_comment)
                     values(v_sps_id,p_spt_id,decode(p_date_resil,null,v_g_vow_spstatus_actif,v_g_vow_spstatus_res),
                            decode(p_date_resil,null,p_date_creation,p_date_resil),null,v_g_age_id,'MIGRATION');

    p_pk_etape := 'Cr�ation de liaison PDL /BRA';
    select seq_tecconnection.nextval into v_cnn_id from dual;
    insert into tecconnection(cnn_id, cnn_refe, adr_id, fld_id, cnn_startdt, cnn_updtby)
                       values(v_cnn_id, v_code_br, p_adr_id, v_g_fld_id, p_date_creation,v_g_age_id);
    select seq_techconspt.nextval into v_hcs_id from dual;
    insert into techconspt(hcs_id, spt_id, con_id, hcs_startdt,hcs_updtby)
                    values(v_hcs_id, p_spt_id, v_cnn_id, p_date_creation, v_g_age_id);
 
    p_pk_etape := 'Cr�ation du PDL EAU';
    insert into tecsptwater(spt_id, swa_updtby)
                     values(p_spt_id, v_g_age_id);
  EXCEPTION WHEN OTHERS THEN
     v_g_err_code := SQLCODE;
     v_g_err_msg := SUBSTR(SQLERRM, 1, 200);
     p_pk_exception := v_g_err_code || ' : ' ||  v_g_err_msg;
  END;
--------------------------------------------------------------------------------------------------------------------
--------------------------------------------------------------------------------------------------------------------
PROCEDURE MigrationCompteur
  (
    p_pk_etape out varchar2,
    p_pk_exception out varchar2,
    p_equ_id out number,
	  p_mtc_id out number,
    p_district varchar2,
    p_tourne varchar2,
    p_ordre varchar2,
    p_compteur_actuel varchar2,
    p_code_marque varchar2
  )
  IS
    cursor c1
    is
      select trim(r.diamctr) diamctr
      from   test.fiche_releve r
      where  lpad(trim(r.district),2,'0') = p_district
      and    lpad(trim(r.tourne),3,'0') = p_tourne
      and    lpad(trim(r.ordre),3,'0') = p_ordre
      and    trim(r.ncompteur) is not null
      and    trim(r.codemarque)!='000'
      order by to_number(r.annee) desc, to_number(r.trim);

    v_diam_compt varchar2(10);
    v_anne_fabric number;
    v_class varchar2(10);
    v_nbr_roues number;
    v_vow_model number;
    v_mmo_id number;
    v_vow_diam number;
    v_vow_class number;
    v_mcd_id number;
    v_compteur_actuel_v varchar2(100);
    v_equ_year date;
    v_nbre number;
	
  BEGIN
    if p_compteur_actuel is not null then
      p_pk_etape := 'Recuperation diametre et annee';
      begin
        select max(trim(c.diam_compteur)),max(c.annee_fabrication)
        into   v_diam_compt,v_anne_fabric
        from   test.compteur c
        where  lpad(trim(c.district),2,'0') = p_district
        and    lpad(trim(c.code_marque),3,'0') = p_code_marque
        and    lpad(trim(c.num_compteur),11,'0') = p_compteur_actuel;
      exception when no_data_found then
        for s1 in c1 loop
          v_diam_compt := s1.diamctr;
          v_anne_fabric := 1900;
          exit;
        end loop;
      end;
      
      if v_diam_compt is null then
        v_diam_compt := '15';
      end if;

      p_pk_etape := 'Recuperation de la classe';
      begin
        select  m.classe
        into    v_class
        from    test.marque m
        where   lpad(trim(m.district),2,'0') = p_district
        and     lpad(trim(m.code),3,'0') = p_code_marque
        and     rownum  = 1;
      exception when no_data_found then
        v_class := 0;
      end;

      p_pk_etape := 'Recuperation du nombre de roues';
      -- Classe 100
      if    p_code_marque = '101' then v_nbr_roues := 0;
      elsif p_code_marque = '102' then v_nbr_roues := 4;
      elsif p_code_marque = '103' then v_nbr_roues := 4;
      elsif p_code_marque = '104' and v_diam_compt = '15' then v_nbr_roues := 4;
      elsif p_code_marque = '104' and v_diam_compt = '40' then v_nbr_roues := 5;
      elsif p_code_marque = '105' then v_nbr_roues := 4;
      elsif p_code_marque = '106' then v_nbr_roues := 6;
      elsif p_code_marque = '107' then v_nbr_roues := 6;
      elsif p_code_marque = '108' then v_nbr_roues := 6;
      elsif p_code_marque = '109' then v_nbr_roues := 5;
      elsif p_code_marque = '110' then v_nbr_roues := 4;
      elsif p_code_marque = '111' then v_nbr_roues := 4;
      elsif p_code_marque = '112' then v_nbr_roues := 0;
      elsif p_code_marque = '113' then v_nbr_roues := 4;
      elsif p_code_marque = '114' then v_nbr_roues := 4;
      elsif p_code_marque = '115' and v_diam_compt = '15' then v_nbr_roues := 4;
      elsif p_code_marque = '115' and v_diam_compt = '30' then v_nbr_roues := 5;
      elsif p_code_marque = '116' then v_nbr_roues := 5;
      elsif p_code_marque = '117' then v_nbr_roues := 5;
      elsif p_code_marque = '118' then v_nbr_roues := 6;
      elsif p_code_marque = '120' then v_nbr_roues := 4;
      elsif p_code_marque = '121' then v_nbr_roues := 4;
      -- Classe 200
      elsif p_code_marque = '201' then v_nbr_roues := 4;
      elsif p_code_marque = '202' then v_nbr_roues := 4;
      elsif p_code_marque = '203' and v_diam_compt = '15' then v_nbr_roues := 4;
      elsif p_code_marque = '203' and v_diam_compt = '40' then v_nbr_roues := 5;
      elsif p_code_marque = '203' and to_number(v_diam_compt) > 40 then v_nbr_roues := 6;
      elsif p_code_marque = '204' then v_nbr_roues := 4;
      elsif p_code_marque = '205' then v_nbr_roues := 4;
      elsif p_code_marque = '206' then v_nbr_roues := 4;
      elsif p_code_marque = '207' and v_diam_compt = '15' then v_nbr_roues := 4;
      elsif p_code_marque = '207' and v_diam_compt = '20' then v_nbr_roues := 4;
      elsif p_code_marque = '207' and v_diam_compt = '40' then v_nbr_roues := 5;
      elsif p_code_marque = '208' then v_nbr_roues := 4;
      elsif p_code_marque = '210' then v_nbr_roues := 5;
      elsif p_code_marque = '211' then v_nbr_roues := 6;
      elsif p_code_marque = '212' then v_nbr_roues := 5;
      -- Classe 300
      elsif p_code_marque = '306' then v_nbr_roues := 4;
      elsif p_code_marque = '310' then v_nbr_roues := 4;
      else  v_nbr_roues:=4;
      end if;

      p_pk_etape := 'Recuperation du modele du compteur';
      begin
        select vow.vow_id
        into   v_vow_model
        from   genvoc     voc,
               genvocword vow
        where  voc.voc_id   = vow.voc_id
        and    vow.vow_code = p_code_marque
        and    voc.voc_code = 'VOW_MODEL';
      exception when no_data_found then
        v_vow_model := v_g_vow_model_id;
      end;

      begin
        select  mmo_id
        into    v_mmo_id
        from    tecequmodel
        where   eqy_id       = v_g_eqy_id
        and     vow_manufact = v_g_vow_manufact_id
        and     vow_model    = v_vow_model;
      exception when no_data_found then
        select seq_tecequmodel.nextval into v_mmo_id from dual;
        insert into tecequmodel(mmo_id,eqy_id,vow_manufact,vow_model,mmo_updtby)
                         values(v_mmo_id,v_g_eqy_id,v_g_vow_manufact_id,v_vow_model,v_g_age_id);
      end;

      p_pk_etape := 'Recuperation de la config';
      begin
        select mtc.mtc_id
        into   p_mtc_id
        from   tecmtrcfg mtc,
               tecmtrcfgdetail mcd
        where  mtc.vow_model    = v_vow_model
        and    mtc.vow_manufact = v_g_vow_manufact_id
        and    mtc.mtc_id       = mcd.mtc_id
        and    mcd.meu_id       = v_g_meu_id
        and    mcd.mcd_wheel    = v_nbr_roues;
      exception when no_data_found then
        select seq_tecmtrcfg.nextval into p_mtc_id from dual;
        insert into tecmtrcfg(mtc_id, mtc_code, mtc_name, vow_manufact, vow_model, fld_id,mtc_updtby)
                       values(p_mtc_id, p_code_marque || '- X' || v_nbr_roues, p_code_marque || '- X' || v_nbr_roues, v_g_vow_manufact_id, v_vow_model, v_g_fld_id,v_g_age_id);
        select seq_tecmtrcfgdetail.nextval into v_mcd_id from dual;
        insert into tecmtrcfgdetail(mcd_id, mcd_num, mtc_id, meu_id, mcd_wheel, mcd_coeff)
                             values(v_mcd_id,1, p_mtc_id, v_g_meu_id, v_nbr_roues, 1);
      end;

      p_pk_etape := 'Recuperation info compteur eau';
      begin
        select vow.vow_id
        into   v_vow_diam
        from   genvoc     voc,
               genvocword vow
        where  voc.voc_id = vow.voc_id
        and    vow.vow_code  = v_diam_compt
        and    voc.voc_code  = 'VOW_DIAM';
      exception when no_data_found then
        v_vow_diam := v_g_vow_diam_id;
      end;

      begin
        select vow.vow_id
        into   v_vow_class
        from   genvoc     voc,
               genvocword vow
        where  voc.voc_id          = vow.voc_id
        and    upper(vow.vow_code) = v_class
        and    voc.voc_code        = 'VOW_CLASS';
      exception when no_data_found then
        v_vow_class := v_g_vow_class_id;
      end;

      p_pk_etape := 'Creation du compteur';
      if v_anne_fabric between 1900 and 2018 then
        v_equ_year := to_date('01/01/'||v_anne_fabric,'dd/mm/yyyy');
      else
        v_equ_year := to_date('01/01/1900');
      end if;
      begin
        select seq_tecequipment.nextval into p_equ_id from dual;
        insert into tecequipment(equ_id,equ_realnumber,equ_serialnumber,vow_equstatus,equ_year,eqy_id,mmo_id,vow_owner,equ_updtby)
                          values(p_equ_id,p_compteur_actuel,p_compteur_actuel,v_g_vow_equstatus_id,v_equ_year,v_g_eqy_id,v_mmo_id,v_g_vow_owner_id,v_g_age_id);
      exception when DUP_VAL_ON_INDEX then
        insert into tecequipment(equ_id,equ_realnumber,equ_serialnumber,vow_equstatus,equ_year,eqy_id,mmo_id,vow_owner,equ_updtby)
                          values(p_equ_id,p_compteur_actuel||'-'||p_equ_id,p_compteur_actuel||'-'||p_equ_id,v_g_vow_equstatus_id,v_equ_year,v_g_eqy_id,v_mmo_id,v_g_vow_owner_id,v_g_age_id);
      end;
      
      insert into tecmeter(equ_id, mtc_id) values(p_equ_id,p_mtc_id);

      insert into tecmtrwater(equ_id, vow_diam, vow_class, mwa_updtby)
                   values(p_equ_id, v_vow_diam, v_vow_class, v_g_age_id);

    else
      p_pk_etape := 'Creation du compteur virtuel';
	    p_mtc_id:= v_g_mtc_id;
      select seq_tecequipment.nextval into p_equ_id from dual;
      v_compteur_actuel_v := p_district||'MIG'||lpad(p_equ_id,11,'0');
      v_equ_year := to_date('01/01/1900');
      insert into tecequipment(equ_id,equ_realnumber,equ_serialnumber,vow_equstatus,equ_year,eqy_id,mmo_id,vow_owner,equ_updtby)
                        values(p_equ_id,v_compteur_actuel_v,v_compteur_actuel_v,v_g_vow_equstatus_id,v_equ_year,v_g_eqy_id,v_g_mmo_id,v_g_vow_owner_id,v_g_age_id);

      insert into tecmeter(equ_id, mtc_id) values(p_equ_id, p_mtc_id);

      insert into tecmtrwater(equ_id, vow_diam, vow_class, mwa_updtby)
                       values(p_equ_id, v_g_vow_diam_id, v_g_vow_class_id, v_g_age_id);
    end if;
  EXCEPTION WHEN OTHERS THEN
   v_g_err_code := SQLCODE;
   v_g_err_msg := SUBSTR(SQLERRM, 1, 200);
   p_pk_exception := v_g_err_code || ' : ' ||  v_g_err_msg;
  END;
--------------------------------------------------------------------------------------------------------------------
--------------------------------------------------------------------------------------------------------------------
PROCEDURE MigrationCompteurEncours
  (
    p_pk_etape out varchar2,
    p_pk_exception out varchar2,
    p_equ_id out number,
    p_mtc_id out number,
    p_compteur_actuel in out varchar2,
    p_code_marque in out varchar2,
    p_spt_id in number,
    p_district in varchar2,
    p_tourne in varchar2,
    p_ordre in varchar2,
    p_date_creation in date,
    p_date_resil in date
  )
   IS
    cursor c1
    is
      select lpad(trim(r.codemarque),3,'0') code_marque ,lpad(trim(r.ncompteur),11,'0') compteur_actuel
      from   test.src_fiche_releve r
      where  lpad(trim(r.district),2,'0') = p_district
      and    lpad(trim(r.tourne),3,'0') = p_tourne
      and    lpad(trim(r.ordre),3,'0') = p_ordre
      and    trim(r.ncompteur) is not null
      and    trim(r.codemarque)!='000'
      order by to_number(r.annee) desc, to_number(r.trim) desc;


    cursor c2
    is
      select lpad(trim(c.code_marque),3,'0') code_marque, lpad(trim(c.num_compteur),11,'0') compteur_actuel
      from   test.gestion_compteur c
      where  lpad(trim(c.district),2,'0') = p_district
      and    lpad(trim(c.tournee),3,'0') = p_tourne
      and    lpad(trim(c.ordre),3,'0') = p_ordre
      and    trim(c.num_compteur) is not null 
      order by to_number(c.annee) desc, to_number(c.trim) desc;

    v_heq_id number;
  BEGIN
    if p_compteur_actuel is null then
      p_pk_etape := 'Recuperation du num compteur depuis la fiche releve';
      begin
        for s1 in c1 loop
          p_code_marque := s1.code_marque;
          p_compteur_actuel := s1.compteur_actuel;
          exit;
        end loop;
      exception when others then
        null;
      end;

      p_pk_etape := 'Recuperation du num compteur depuis la gestion de compteur';
      if p_compteur_actuel is null then
        begin
          for s2 in c2 loop
            p_code_marque := s2.code_marque;
            p_compteur_actuel := s2.compteur_actuel;
            exit;
          end loop;
        exception when others then
          null;
        end;
      end if;
    end if;
	
    p_pk_etape := 'Creation du compteur';
    MigrationCompteur(p_pk_etape,p_pk_exception,p_equ_id,p_mtc_id,p_district,p_tourne,p_ordre,p_compteur_actuel,p_code_marque);
    if p_pk_exception is not null then
      return;
    end if;
    p_pk_etape := 'Pose/Depose compteur';
    select seq_techequipment.nextval into v_heq_id from dual;
    insert into techequipment(heq_id,equ_id,spt_id,age_pose,age_depose,vow_methpos,vow_methdep,vow_reaspose,vow_reasdepose,
                              heq_startdt,heq_enddt,heq_updtby)
                       values(v_heq_id,p_equ_id,p_spt_id,v_g_age_id,decode(p_date_resil,null,null,v_g_age_id),v_g_vow_methpos,
                              decode(p_date_resil,null,null,v_g_vow_methdep),v_g_vow_reaspose, decode(p_date_resil,null,null,v_g_vow_reasdepose),
                              p_date_creation,p_date_resil,v_g_age_id);
  EXCEPTION WHEN OTHERS THEN
     v_g_err_code := SQLCODE;
     v_g_err_msg := SUBSTR(SQLERRM, 1, 200);
     p_pk_exception := v_g_err_code || ' : ' ||  v_g_err_msg;
  END;
--------------------------------------------------------------------------------------------------------------------
--------------------------------------------------------------------------------------------------------------------
PROCEDURE MigrationAbonnement
  (
    p_pk_etape out varchar2,
    p_pk_exception out varchar2,
    p_sag_id out number,
    p_aco_id out number,
    p_adr_fs_id in out number,
    p_district in varchar2,
    p_tourne in varchar2,
    p_ordre in varchar2,
    p_police in varchar2,
    p_date_creation in date,
    p_date_resil in date,
    p_gros_consom in varchar2,
    p_categorie in varchar2,
    p_banque in varchar2,
    p_agence in varchar2,
    p_num_compte in varchar2,
    p_cle_rib in varchar2,
    p_usage in varchar2,
    p_tarif in varchar2,
    p_tarif_onas varchar2,
    p_vol_puit number,
    p_tarif_onas_a varchar2,
    p_codpoll_a varchar2,
    p_tarif_a varchar2,
    p_echt_a number,
    p_echr_a number,
    p_brt_a number,
    p_echronas_a number,
    p_echtonas_a number,
    p_capitonas_a number,
    p_interonas_a number,
    p_arrond_a number,
    p_categ_a number,
    p_gros_consom_a varchar2,
    p_par_id in number,
    p_pre_id in number,
    p_spt_id in number,
    p_rou_id in number,
    p_adr_id in number
  )
  IS
    v_cag_id number;
    v_cag_refe varchar2(20);
    v_nbre number;
    v_grf_id number;
    v_grf_code varchar2(10);
    v_vow_usgsag number;
    v_cot_id number;
    v_adr_fs varchar2(4000);
    v_code_p_fs varchar2(4000);
    v_paa_id number;
    v_pay_id number;
    v_rec_id number;
    v_dlp_id number;
    v_vow_frqfact number;
    v_sco_id number;
    v_stl_id number;
    v_vow_settlemode number;
    v_bap_id number;
    v_ban_id number;
    v_ofr_id number;
    v_ofr_detail_id number;
    v_asu_num number := 0;
    v_asu_id number;
    v_hsf_id number;
    v_suv_id number;
    v_asu_id1 number;
    v_asu_id2 number;
    v_asu_id3 number;
    v_asu_id4 number;
    v_gros_conso varchar2(4);
    
  BEGIN
    p_pk_etape := 'Creation Contrat';
    v_cag_refe := p_district||'0'||p_police;
    begin
      select seq_agrcustomeragr.nextval into v_cag_id from dual;
      insert into agrcustomeragr(cag_id,cag_refe,cag_startdt,cag_enddt,pre_id,par_id,cag_updtby)
                          values(v_cag_id,v_cag_refe,p_date_creation,p_date_resil,p_pre_id,p_par_id,v_g_age_id);
    exception when DUP_VAL_ON_INDEX then
      select count(*)
      into   v_nbre
      from   agrcustomeragr
      where  substr(cag_refe,0,2)  = p_district
      and    substr(cag_refe,-5,5) = p_police;

      v_cag_refe := p_district||v_nbre||p_police;
      select seq_agrcustomeragr.nextval into v_cag_id from dual;
      insert into agrcustomeragr(cag_id,cag_refe,cag_startdt,cag_enddt,pre_id,par_id,cag_updtby)
                          values(v_cag_id,v_cag_refe,p_date_creation,p_date_resil,p_pre_id,p_par_id,v_g_age_id);
    end;

    p_pk_etape := 'Recuperation groupe de fact';
    begin
      select grf_id
      into   v_grf_id
      from   tecroute
      where  rou_id = p_rou_id;
    exception when others then
      select p_district||decode(trim(t.ntiers),0,'M',trim(t.ntiers))||trim(t.nsixieme)
      into   v_grf_code
      from   test.tourne t
      where  lpad(trim(t.district),2,'0') = p_district
      and    lpad(trim(t.code),3,'0') = p_tourne;

      begin
        select grf_id
        into   v_grf_id
        from   agrgrpfact
        where  grf_code = v_grf_code;
      exception when no_data_found then
        select seq_agrgrpfact.nextval into v_grf_id from dual;
        insert into agrgrpfact(grf_id,grf_code,grf_name,grf_updtby)
                        values(v_grf_id,v_grf_code,v_grf_code,v_g_age_id);
      end;

      update tecroute s
      set    s.grf_id=v_grf_id
      where  s.rou_id=p_rou_id;
    END;

    p_pk_etape := 'Recuperation usage';
    begin
      select vow.vow_id
      into   v_vow_usgsag
      from   genvoc     voc,
             genvocword vow
      where  voc.voc_id = vow.voc_id
      and    vow.vow_code  = p_usage
      and    voc.voc_code  = 'VOW_USGSAG';
    exception when no_data_found then
      v_vow_usgsag := v_g_vow_usgsag_id;
    end;

    p_pk_etape := 'Creation abonnement';
    select seq_agrserviceagr.nextval into p_sag_id from dual;
    insert into agrserviceagr(sag_id,sag_refe,sag_startdt,sag_enddt,cag_id,spt_id,grf_id,ctt_id,
                              vow_cutagree,vow_usgsag,sag_updtby)
                       values(p_sag_id,v_cag_refe,p_date_creation,p_date_resil,v_cag_id,p_spt_id,v_grf_id,v_g_ctt_id,
                              v_g_vow_cutagree_id,v_vow_usgsag,v_g_age_id);

    p_pk_etape := 'Creation abonne';
    select seq_agrcustagrcontact.nextval into v_cot_id from dual;
    insert into agrcustagrcontact(cot_id,cag_id,sag_id,par_id,cot_startdt,cot_enddt,vow_agrcontacttp,cot_rank,cot_updtby)
                           values(v_cot_id,v_cag_id,p_sag_id,p_par_id,p_date_creation,p_date_resil,v_g_vow_agrcontacttp_a,1,v_g_age_id);


    p_pk_etape := 'Creation Adresse de faire suivre';
    select max(adr2), max(codpostal)
    into   v_adr_fs,v_code_p_fs
    from   test.src_faire_suivre
    where  lpad(trim(dist),2,'0') = p_district
    and    lpad(trim(pol),5,'0') = p_police
    and    lpad(trim(tou),3,'0') = p_tourne
    and    lpad(trim(ord),3,'0') = p_ordre;

    if v_adr_fs is not null and v_code_p_fs is not null then
      MigrationAdresse(p_pk_etape,p_pk_exception,p_adr_fs_id,v_adr_fs,v_code_p_fs);
      if p_pk_exception is not null then
        return;
      end if;
    else
      p_adr_fs_id := p_adr_id;
    end if;

    select seq_genpartyparty.nextval into v_paa_id from dual;
    insert into genpartyparty(paa_id,par_parent_id,vow_partytp,paa_startdt,paa_enddt,paa_updtby,adr_id)
                       values(v_paa_id,p_par_id,v_g_vow_partytp_a,p_date_creation,p_date_resil,v_g_age_id,p_adr_fs_id);

    p_pk_etape := 'Creation payeur';
    select seq_agrcustagrcontact.nextval into v_cot_id from dual;
    insert into agrcustagrcontact(cot_id,cag_id,sag_id,par_id,cot_startdt,cot_enddt,vow_agrcontacttp,cot_rank,cot_updtby)
                           values(v_cot_id,v_cag_id,p_sag_id,p_par_id,p_date_creation,p_date_resil,v_g_vow_agrcontacttp_p,2,v_g_age_id);
    select seq_agrpayor.nextval into v_pay_id from dual;
    insert into agrpayor(pay_id,cot_id,paa_id,pay_updtby)
                  values(v_pay_id,v_cot_id,v_paa_id,v_g_age_id);
    
    
    p_pk_etape := 'Recuperation de la chaine de relance/delai de paiement/frequence';
    if p_gros_consom = 'O' then
       v_rec_id := v_g_rec_mens_id;
       v_dlp_id := v_g_dlp_mens_id;
       v_vow_frqfact := v_g_vow_frqfact_mns;
    elsif p_categorie in ('02','04','08') then
        v_rec_id := v_g_rec_adm_id;
        v_dlp_id := v_g_dlp_adm_id;
        v_vow_frqfact := v_g_vow_frqfact_trm;
    else
        v_rec_id := v_g_rec_part_id;
        v_dlp_id := v_g_dlp_part_id;
        v_vow_frqfact := v_g_vow_frqfact_trm;
    end if;
    
    p_pk_etape := 'Creation du compte client';
    select seq_genaccount.nextval into p_aco_id from dual;
    insert into genaccount(aco_id,par_id,imp_id,rec_id,vow_acotp,aco_updtby)
                    values(p_aco_id,p_par_id,v_g_imp_id,v_rec_id,v_g_vow_acotp_id,v_g_age_id);
    
    p_pk_etape := 'Affectation du compte client au contrat';
    select seq_agrsagaco.nextval into v_sco_id from dual;
    insert into agrsagaco(sco_id,sco_startdt,sco_enddt,sag_id,aco_id,sco_updtby)
                   values(v_sco_id,p_date_creation,p_date_resil,p_sag_id,p_aco_id,v_g_age_id);
    
    p_pk_etape := 'Creation du planning';
    insert into agrplanningagr(sag_id,vow_frqfact,agp_factday,agp_nextfactdt,vow_modefactnext,agp_updtby)
                        values(p_sag_id,v_vow_frqfact,10,v_g_agp_factday,v_g_vow_modefactnext,v_g_age_id);
    
    
    
    p_pk_etape := 'Coordonnees bancaire';   
    if p_categ_a = 5 then
      select count(*)
      into   v_nbre
      from   test.src_rib r
      where  r.rib = p_banque||p_agence||p_num_compte||p_cle_rib;
      
      if v_nbre > 0 then
        select max(ban_id)
        into   v_ban_id
        from   genbank ban
        where  ban.ban_code = p_banque||p_agence;
        if v_ban_id is null then
          select seq_genbank.nextval into v_ban_id from dual;
          insert into genbank(ban_id,ban_code,ban_name,ban_updtby)
                       values(v_ban_id,p_banque||p_agence,p_banque||p_agence,v_g_age_id);
        end if;
        select seq_genbankparty.nextval into v_bap_id from dual;
        insert into genbankparty(bap_id,bap_num,bap_name,par_id,ban_id,bap_accountnumber,
                                 bap_accountkey,bap_ibannumber,bap_updtby)
                          values(v_bap_id,1,'-',p_par_id,v_ban_id,p_num_compte||p_cle_rib,
                                 p_cle_rib,p_banque||p_agence||p_num_compte||p_cle_rib,v_g_age_id);
        v_vow_settlemode := v_g_vow_settlemode_d;
      else
        v_bap_id := null;
        v_vow_settlemode := v_g_vow_settlemode_a;
      end if;
    else
      v_bap_id := null;
      v_vow_settlemode := v_g_vow_settlemode_a;               
    end if;
    
    p_pk_etape := 'Ajouter modalite de paiement';
    select seq_agrsettlement.nextval into v_stl_id from dual;
    insert into agrsettlement(stl_id,sag_id,stl_startdt,stl_enddt,vow_settlemode,vow_nbbill,dlp_id,bap_id,stl_updtby)
                       values(v_stl_id,p_sag_id,p_date_creation,p_date_resil,v_vow_settlemode,v_g_vow_nbbill_1,v_dlp_id,v_bap_id,v_g_age_id);
    
    p_pk_etape := 'Selection du tarif SONEDE';
    case 
      when p_tarif_a = '01' then v_ofr_id := v_g_ofr_01;
      when p_tarif_a = '03' then v_ofr_id := v_g_ofr_03;
      when p_tarif_a = '04' then v_ofr_id := v_g_ofr_04;
      when p_tarif_a = '05' then v_ofr_id := v_g_ofr_05;
      when p_tarif_a = '06' then v_ofr_id := v_g_ofr_06;
      when p_tarif_a = '11' then v_ofr_id := v_g_ofr_11;
      when p_tarif_a = '21' then v_ofr_id := v_g_ofr_21;
      else v_ofr_id := v_g_ofr_mig;
    end case;
    
    p_pk_etape := 'Selection du tarif ONAS';
    case p_tarif_onas_a
      when '0' then
        v_ofr_detail_id := v_g_ofr_onas0;
      when '1' then
        v_ofr_detail_id := v_g_ofr_onas1;
      when '2' then
        v_ofr_detail_id := v_g_ofr_onas2;
      when '3' then
        v_ofr_detail_id := v_g_ofr_onas3;
      when '4' then
        v_ofr_detail_id := v_g_ofr_onas4;
      when '5' then
        v_ofr_detail_id := v_g_ofr_onas5;
      when '6' then
        v_ofr_detail_id := v_g_ofr_onas6;
      when '8' then
        v_ofr_detail_id := v_g_ofr_onas8;
      when '9' then
        v_ofr_detail_id := v_g_ofr_onas9;
      when 'A' then
        v_ofr_detail_id := v_g_ofr_onasA;
      when 'C' then
        v_ofr_detail_id := v_g_ofr_onasC;
      else
        v_ofr_detail_id := v_g_ofr_mig;
    end case;
    
    p_pk_etape := 'Ajouter detail profil de facturation';
    insert into agrbillingitem(bii_id,meu_id,ite_id,bii_startdt,bii_enddt,sag_id,ofr_id,bii_updtby)
          select seq_agrbillingitem.nextval,meu_id,ite_id,p_date_creation,p_date_resil,
                 p_sag_id,i.ofr_id,v_g_age_id
           from   agrofferitem i
           where  i.ofr_id in(v_ofr_id,v_ofr_detail_id);
    
    p_pk_etape := 'Ajouter historique offre';
    select seq_agrhsagofr.nextval into v_hsf_id from dual;
    insert into agrhsagofr(hsf_id,sag_id,ofr_id,ofr_detail_id,hsf_startdt,hsf_enddt,hsf_updtby)
                    values(v_hsf_id,p_sag_id,v_ofr_id,v_ofr_detail_id,p_date_creation,p_date_resil,v_g_age_id);
    
    p_pk_etape := 'Ajouter engagement arrondis';
    v_asu_num := 0;
    if nvl(p_arrond_a,0)<>0 then
      v_asu_num := v_asu_num + 1;
      select seq_agrsubscription.nextval into v_asu_id from dual;
      insert into agrsubscription(asu_id,asu_num,hsf_id,sag_id,ofr_id,sut_id,asu_startdt,asu_enddt,asu_updtby)
                           values(v_asu_id,v_asu_num,v_hsf_id,p_sag_id,v_ofr_id,v_g_sut_arr,p_date_creation,p_date_resil,v_g_age_id);
      
      select seq_agrsubscriptionvalue.nextval into v_suv_id from dual;
      insert into agrsubscriptionvalue(suv_id,asu_id,suv_value,suv_updtby)
                                values(v_suv_id,v_asu_id,p_arrond_a,v_g_age_id);                     
    end if;
    
    p_pk_etape := 'Ajouter engagement facilite onas';
    if nvl(p_echtonas_a,0)>0then
      select seq_agrsubscription.nextval into v_asu_id1 from dual;
      select seq_agrsubscription.nextval into v_asu_id2 from dual;
      select seq_agrsubscription.nextval into v_asu_id3 from dual;
      select seq_agrsubscription.nextval into v_asu_id4 from dual;
      insert into agrsubscription(asu_id,asu_num,hsf_id,sag_id,ofr_id,sut_id,asu_startdt,asu_enddt,asu_updtby)
                  select v_asu_id1,v_asu_num + 1,v_hsf_id,p_sag_id,v_ofr_id,v_g_sut_echt_onas,
                         p_date_creation,p_date_resil,v_g_age_id from dual
                  union
                  select v_asu_id2,v_asu_num + 2,v_hsf_id,p_sag_id,v_ofr_id,v_g_sut_echr_onas,
                         p_date_creation,p_date_resil,v_g_age_id from dual
                  union
                  select v_asu_id3,v_asu_num + 3,v_hsf_id,p_sag_id,v_ofr_id,v_g_sut_capi_onas,
                         p_date_creation,p_date_resil,v_g_age_id from dual
                  union
                  select v_asu_id4,v_asu_num + 4,v_hsf_id,p_sag_id,v_ofr_id,v_g_sut_intr_onas,
                         p_date_creation,p_date_resil,v_g_age_id from dual;
       
      insert into agrsubscriptionvalue(suv_id,asu_id,suv_value,suv_updtby)
                                select seq_agrsubscriptionvalue.nextval,asu_id,
                                       decode(sut_id,v_g_sut_echt_onas,p_echtonas_a,
                                                     v_g_sut_echr_onas,p_echronas_a,
                                                     v_g_sut_capi_onas,p_capitonas_a,
                                                     v_g_sut_intr_onas,p_interonas_a,
                                                     null),
                                       v_g_age_id
                                from   agrsubscription
                                where  sag_id = p_sag_id
                                and    sut_id in (v_g_sut_echt_onas,v_g_sut_echr_onas,v_g_sut_capi_onas,v_g_sut_intr_onas);
    v_asu_num := v_asu_num + 4;
    end if;
    
    p_pk_etape := 'Ajouter engagement coef pollution';
    if nvl(p_codpoll_a,0)>0 then
      v_asu_num := v_asu_num + 1;
      select seq_agrsubscription.nextval into v_asu_id from dual;
      insert into agrsubscription(asu_id,asu_num,hsf_id,sag_id,ofr_id,sut_id,asu_startdt,asu_enddt,asu_updtby)
                           values(v_asu_id,v_asu_num,v_hsf_id,p_sag_id,v_ofr_id,v_g_sut_pol_onas,p_date_creation,p_date_resil,v_g_age_id);
      
      select seq_agrsubscriptionvalue.nextval into v_suv_id from dual;
      insert into agrsubscriptionvalue(suv_id,asu_id,suv_value,suv_updtby)
                                values(v_suv_id,v_asu_id,p_codpoll_a,v_g_age_id);                     
    end if;
    
    p_pk_etape := 'Ajouter engagement volume puit';
    if nvl(p_vol_puit,0)>0 then
      v_asu_num := v_asu_num + 1;
      select seq_agrsubscription.nextval into v_asu_id from dual;
      insert into agrsubscription(asu_id,asu_num,hsf_id,sag_id,ofr_id,sut_id,asu_startdt,asu_enddt,asu_updtby)
                           values(v_asu_id,v_asu_num,v_hsf_id,p_sag_id,v_ofr_id,v_g_sut_puit_onas,p_date_creation,p_date_resil,v_g_age_id);
      
      select seq_agrsubscriptionvalue.nextval into v_suv_id from dual;
      insert into agrsubscriptionvalue(suv_id,asu_id,suv_value,suv_updtby)
                                values(v_suv_id,v_asu_id,p_vol_puit,v_g_age_id);                     
    end if; 
    
    p_pk_etape := 'Ajouter engagement gros consommateur';
    v_asu_num := v_asu_num + 1;
    select seq_agrsubscription.nextval into v_asu_id from dual;
    insert into agrsubscription(asu_id,asu_num,hsf_id,sag_id,ofr_id,sut_id,asu_startdt,asu_enddt,asu_updtby)
                         values(v_asu_id,v_asu_num,v_hsf_id,p_sag_id,v_ofr_id,v_g_sut_gros_cons,p_date_creation,p_date_resil,v_g_age_id);
    v_gros_conso := null;
    if p_categorie in ('01','03') and p_gros_consom = 'O' then
      v_gros_conso := 'OUI';
    else
      if p_gros_consom_a = 'O' then
        v_gros_conso := 'OUI';
      else
        v_gros_conso := 'NON';
      end if;
    end if;
      
    select seq_agrsubscriptionvalue.nextval into v_suv_id from dual;
    insert into agrsubscriptionvalue(suv_id,asu_id,suv_value,suv_updtby)
                              values(v_suv_id,v_asu_id,decode(v_gros_conso,null,'NON',v_gros_conso),v_g_age_id);                  
  EXCEPTION WHEN OTHERS THEN
   v_g_err_code := SQLCODE;
   v_g_err_msg := SUBSTR(SQLERRM, 1, 200);
   p_pk_exception := v_g_err_code || ' : ' ||  v_g_err_msg;
  END;
--------------------------------------------------------------------------------------------------------------------
--------------------------------------------------------------------------------------------------------------------
procedure MigrationReleve
 (
    p_pk_etape     out varchar2,
    p_pk_exception out varchar2,
    p_mrd_id       out number,
    p_annee        in number,
    p_periode      in number,
    p_index        in number,
    p_consommation in number,
    p_prorata      in number,
    p_avisforte    in number,
    p_tentatif2    in number,
    p_tentatif3    in number,
    p_tentatif4    in number,
    p_tentatif5    in number,
    p_compteur_t   in number,
    p_date_releve  in date,
    p_anomalief    in varchar2,
    p_anomalien    in varchar2,
    p_anomaliec    in varchar2,
    p_message_temporaire in varchar2,
    p_message_temporaire_a in varchar2,
    p_vow_readreason  in number,
    p_vow_readmeth  in number,
    p_mrd_usecr in number,
    p_equ_id       in number,
    p_mtc_id       in number,
    p_spt_id       in number,
    p_age_id       in number
 )
 
 IS
   v_mme_deducemanual number;
   v_mme_num number;
   v_vow_comm1 number;
   v_vow_comm2 number;
   v_vow_comm3 number;
   v_mme_id number;
 BEGIN
   
   if to_number(p_prorata)>0 then
			v_mme_deducemanual:=nvl(to_number(trim(p_consommation)),0)-p_prorata;
	 end if;
   
   ------------------------
   p_pk_etape:='R�cup�ration Anomalie niche';
   begin
     select vow.vow_id
     into   v_vow_comm1
     from   genvoc     voc,
            genvocword vow
     where  voc.voc_id   = vow.voc_id
     and    vow.vow_code = p_anomalien--substr(p_anomalie,7,2)
     and    voc.voc_code = 'VOW_COMM1';
    exception when others then
      null;
    end;
   --------------------------
   p_pk_etape := 'R�cup�ration Anomalie fuite';
   begin
     select vow.vow_id
     into   v_vow_comm2
     from   genvoc     voc,
            genvocword vow
     where  voc.voc_id   = vow.voc_id
     and    vow.vow_code = p_anomalief--substr(p_anomalie,13,2)
     and    voc.voc_code = 'VOW_COMM2';
   exception when others then
     null;
   end;
    
   p_pk_etape := 'R�cup�ration Anomalie compteur';
   begin         
     select vow.vow_id
     into   v_vow_comm3
     from   genvoc     voc,
            genvocword vow
     where  voc.voc_id   = vow.voc_id
     and    vow.vow_code = p_anomaliec--substr(p_anomalie,1,2)
     and    voc.voc_code = 'VOW_COMM3';
   exception when others then
     null;
   end;
   
   p_pk_etape := 'Ajouter releve';
   select seq_tecmtrread.nextval into p_mrd_id from dual;
    insert into tecmtrread(mrd_id,equ_id,mtc_id,mrd_dt,spt_id,vow_comm1,vow_comm2,vow_comm3,
                 vow_readorig,vow_readmeth,vow_readreason,mrd_comment,mrd_agrtype,mrd_techtype,
                 mrd_etatfact,age_id,mrd_usecr,mrd_year,mrd_multicad,mrd_comment_a) 
            values(p_mrd_id,p_equ_id,p_mtc_id,p_date_releve,p_spt_id,v_vow_comm1,v_vow_comm2,v_vow_comm3,
                 v_g_vow_readorig,p_vow_readmeth,p_vow_readreason,p_message_temporaire,v_g_mrd_agrtype,v_g_mrd_techtype,
                 v_g_mrd_etatfact,p_age_id,p_mrd_usecr,p_annee,p_periode,p_message_temporaire_a);
    
    p_pk_etape := 'Ajouter index eau'; 
    v_mme_num := 1;
    select seq_tecmtrmeasure.nextval into v_mme_id from dual;
    insert into tecmtrmeasure(mme_id,mrd_id,meu_id,mme_num,mme_value,mme_consum,mme_avgconsum,mme_deducemanual)
                        values (v_mme_id,p_mrd_id,v_g_meu_eau,v_mme_num,to_number(p_index),nvl(to_number(trim(p_consommation)),0),0,v_mme_deducemanual);    

    p_pk_etape := 'Ajouter index tentatif 1 et 2'; 
    if (nvl(p_tentatif2,0)>0) then
      v_mme_num := v_mme_num + 1;
      select seq_tecmtrmeasure.nextval into v_mme_id from dual;
      insert into tecmtrmeasure(mme_id,mrd_id,meu_id,mme_num,mme_value,mme_consum,mme_avgconsum,mme_deducemanual)
                values (v_mme_id,p_mrd_id,v_g_meu_ten1,v_mme_num,to_number(replace(p_index,'.',null)),to_number(replace(p_index,'.',null)),0,0);
      v_mme_num := v_mme_num + 1;
      select seq_tecmtrmeasure.nextval into v_mme_id from dual;
      insert into tecmtrmeasure(mme_id,mrd_id,meu_id,mme_num,mme_value,mme_consum,mme_avgconsum,mme_deducemanual)
                values (v_mme_id,p_mrd_id,v_g_meu_ten1,v_mme_num,to_number(replace(p_tentatif2,'.',null)),to_number(replace(p_tentatif2,'.',null)),0,0);
    end if;         

    p_pk_etape := 'Ajouter index tentatif 3'; 
    if (nvl(p_tentatif3,0)>0) then
      v_mme_num := v_mme_num + 1;
      select seq_tecmtrmeasure.nextval into v_mme_id from dual;
      insert into tecmtrmeasure(mme_id,mrd_id,meu_id,mme_num,mme_value,mme_consum,mme_avgconsum,mme_deducemanual)
                values (v_mme_id,p_mrd_id,v_g_meu_ten2,v_mme_num,to_number(replace(p_tentatif3,'.',null)),to_number(replace(p_tentatif3,'.',null)),0,0);
    end if;     
        
    p_pk_etape := 'Ajouter index tentatif 4'; 
    if (nvl(p_tentatif4,0)>0) then
      v_mme_num := v_mme_num + 1;
      select seq_tecmtrmeasure.nextval into v_mme_id from dual;
      insert into tecmtrmeasure(mme_id,mrd_id,meu_id,mme_num,mme_value,mme_consum,mme_avgconsum,mme_deducemanual)
                 values(v_mme_id,p_mrd_id,v_g_meu_ten3,v_mme_num,to_number(replace(p_tentatif4,'.',null)),to_number(replace(p_tentatif4,'.',null)),0,0);
    end if;     
           
    p_pk_etape := 'Ajouter index tentatif 5'; 
    if (nvl(p_tentatif5,0)>0) then
      v_mme_num := v_mme_num + 1;
      select seq_tecmtrmeasure.nextval into v_mme_id from dual;
      insert into tecmtrmeasure(mme_id,mrd_id,meu_id,mme_num,mme_value,mme_consum,mme_avgconsum,mme_deducemanual)
                values (v_mme_id,p_mrd_id,v_g_meu_ten4,v_mme_num,to_number(replace(p_tentatif5,'.',null)),to_number(replace(p_tentatif5,'.',null)),0,0);
    end if;           
          
    p_pk_etape := 'Ajouter index avis forte conso';
    if (nvl(p_avisforte,0)>0) then
      v_mme_num := v_mme_num + 1;
      select seq_tecmtrmeasure.nextval into v_mme_id from dual;
      insert into tecmtrmeasure(mme_id,mrd_id,meu_id,mme_num,mme_value,mme_consum,mme_avgconsum,mme_deducemanual)
                 values(v_mme_id,p_mrd_id,v_g_meu_avis,v_mme_num,to_number(trim(p_avisforte)),to_number(trim(p_avisforte)),0,0);
    end if; 
    
    p_pk_etape := 'Ajouter index compteur tournee';
    if (nvl(p_compteur_t,0)>0) then
      v_mme_num := v_mme_num + 1;
      select seq_tecmtrmeasure.nextval into v_mme_id from dual;
      insert into tecmtrmeasure(mme_id,mrd_id,meu_id,mme_num,mme_value,mme_consum,mme_avgconsum,mme_deducemanual)
                 values(v_mme_id,p_mrd_id,v_g_meu_cpt_t,v_mme_num,1,1,0,0);
    end if; 
      
 EXCEPTION WHEN OTHERS THEN
   v_g_err_code := SQLCODE;
   v_g_err_msg := SUBSTR(SQLERRM, 1, 200);
   p_pk_exception := v_g_err_code || ' : ' ||  v_g_err_msg;
 END;
--------------------------------------------------------------------------------------------------------------------
--------------------------------------------------------------------------------------------------------------------

procedure MigrationFacture
 (
    p_pk_etape     out varchar2,
    p_pk_exception out varchar2,
    p_bil_id       out number,
    p_deb_id       out number,
    p_annee        in number,
    p_ref_facture  in out varchar2,
    p_tot_ttc      in number,
    p_tot_ht       in number,
    p_tot_tva      in number,
    p_mt_paye      in number,
    p_fac_datecalcul in date,
    p_fac_datelim    in date,
    p_fac_comment  in varchar2,
    p_qteconso     in number,
    p_mntconso     in number,
    p_prixconso    in number,
    p_tvacons      in number,
    p_fraisctr     in number,
    p_tva_ff       in number,
    p_mntonas1     in number,
    p_volonas1     in number,
    p_prixonas1    in number,
    p_mntonas2     in number,
    p_volonas2     in number,
    p_prixonas2    in number,
    p_mntonas3     in number,
    p_volonas3     in number,
    p_prixonas3    in number,
    p_fixonas      in number,
    p_preavis      in number,
    p_tva_preav    in number,
    p_fermeture    in number, 
    p_tvaferm      in number, 
    p_deplacement  in number,
    p_tvadeplac    in number,
    p_depose_dem   in number,
    p_tvadepose_dem in number,
    p_depose_def   in number,
    p_tvadepose_def in number,
    p_extention    in number,--p_rbranche+p_rfacade
    p_tva_capit    in number,
    p_pfinancier   in number,
    p_tva_pfin     in number,
    p_capit        in number,
    p_inter        in number,
    p_arepor       in number,
    p_narond       in number,
    p_reprise_S    in number,
    p_reprise_O    in number,
    p_reprise_B1   in number,
    p_reprise_B2   in number,
    p_bil_bil_id   in number,
    p_bil_cancel_id in number,
    p_sag_id       in number,
    p_par_id       in number,
    p_adr_id       in number,
    p_org_id       in number,
    p_vow_agrbilltype in number,
    p_vow_debtype    in number,
    p_vow_settlemode in number,
    p_vow_modefact   in number,
    p_run_id         in number,
    p_aco_id         in number
  ) 
  IS 
    v_tva_id           number;
  begin                    
           
    p_pk_etape := 'Creation gendebt';
    select seq_gendebt.nextval into p_deb_id from dual; 
    if p_ref_facture is null then 
      if p_reprise_B1>0then
        p_ref_facture := 'B1_'||p_deb_id;
      elsif p_reprise_B2>0 then
        p_ref_facture := 'B2_'||p_deb_id;  
      end if;
    end if;  
    insert into gendebt(deb_id,deb_refe,org_id,par_id,adr_id,deb_date,deb_duedt,deb_printdt,
                        deb_amountinit,vow_settlemode,aco_id,
                        deb_updtby,deb_comment,deb_amount_cash,sag_id,vow_debtype)
                values (p_deb_id,p_ref_facture,p_org_id,p_par_id,p_adr_id,p_fac_datecalcul,p_fac_datelim,p_fac_datecalcul,
                        p_tot_ttc,p_vow_settlemode,p_aco_id,
                        v_g_age_id,p_fac_comment,p_mt_paye,p_sag_id,p_vow_debtype);
                          
    p_pk_etape := 'Creation agrbill';                         
    select seq_agrbill.nextval into p_bil_id from dual; 
    insert into agrbill(bil_id,sag_id,vow_agrbilltype,vow_modefact)
                 values(p_bil_id,p_sag_id,p_vow_agrbilltype,p_vow_modefact);
    
    p_pk_etape := 'Creation genbill';
    insert into genbill(bil_id,bil_code,bil_calcdt,bil_amountht,bil_amounttva,bil_amountttc,bil_status,
                        deb_id,par_id,bil_debtdt,run_id,bil_updtby,bil_bil_id,bil_cancel_id)
                 values(p_bil_id,p_ref_facture,p_fac_datecalcul,p_tot_ht,p_tot_tva,p_tot_ttc,1,
                        p_deb_id,p_par_id,p_fac_datecalcul,p_run_id,v_g_age_id,p_bil_bil_id,p_bil_cancel_id); 

    if (p_annee>=2018)then
        v_tva_id  :=26;
      else
        v_tva_id  :=24;
      end if;
    
    p_pk_etape := 'Creation genbilline';
    insert into genbilline(bil_id,bli_number,bli_name,bli_exercice,ite_id,pta_id,psl_rank,
                         bli_volumebase,bli_volumefact,bli_puht,tva_id,bli_mht,bli_mttva,
                         bli_mttc,bli_startdt,bli_enddt,vow_unit,bli_updtby,meu_id)   
    select p_bil_id,rownum,ligne.ite_name,p_annee,ligne.ite_id,ligne.pta_id,ligne.psl_rank,
           ligne.vol_base,ligne.vol_fact,ligne.prixht,ligne.tva_id,ligne.mntht,ligne.mnttva,
           ligne.mntttc,p_fac_datecalcul,p_fac_datecalcul,ligne.vow_unit,v_g_age_id,ligne.meu_id
    from
    (                     
      select 'Consommation EAU' ite_name,320 ite_id,760 vow_unit,2112 pta_id,1 psl_rank,v_tva_id tva_id,p_qteconso vol_base,
             p_qteconso vol_fact,p_prixconso/1000 prixht,p_mntconso/1000 mntht,p_tvacons/1000 mnttva,
             (p_mntconso+p_tvacons)/1000 mntttc, v_g_meu_id meu_id from dual
      union all
      select 'Redevance variable ONAS' ite_name,350 ite_id,760 vow_unit,403 pta_id,1 psl_rank,25 tva_id,p_volonas1 vol_base,
             p_volonas1 vol_fact,p_prixonas1/1000 prixht,p_mntonas1/1000 mntht,0/1000 mnttva,
             p_mntonas1/1000 mntttc, v_g_meu_id meu_id from dual
      union all
      select 'Redevance variable ONAS' ite_name,350 ite_id,760 vow_unit,4087 pta_id,2 psl_rank,25 tva_id,p_volonas2 vol_base,
             p_volonas2 vol_fact,p_prixonas2/1000 prixht,p_mntonas2/1000 mntht,0/1000 mnttva,
             p_mntonas2/1000 mntttc, v_g_meu_id meu_id  from dual
      
      union all
      select 'Redevance variable ONAS ' ite_name,350 ite_id,760 vow_unit,4087 pta_id,2 psl_rank,25 tva_id,p_volonas3 vol_base,
             p_volonas3 vol_fact,p_prixonas3/1000 prixht,p_mntonas3/1000 mntht,0/1000 mnttva,
             p_mntonas3/1000 mntttc, v_g_meu_id meu_id from dual
      union all
      select 'Redevance fixe ONAS' ite_name,351 ite_id,4104 vow_unit,409 pta_id,1 psl_rank,25 tva_id,1 vol_base,
             1 vol_fact,p_fixonas/1000 prixht,p_fixonas/1000 mntht,0/1000 mnttva,
             p_fixonas/1000 mntttc, v_g_meu_id meu_id  from dual
      union all
      select 'Frais fixe' ite_name,326 ite_id,4104 vow_unit,341 pta_id,1 psl_rank,v_tva_id tva_id,1 vol_base,
             1 vol_fact,p_fraisctr/1000 prixht,p_fraisctr/1000 mntht,p_tva_ff/1000 mnttva,
             (p_fraisctr+p_tva_ff)/1000 mntttc, null meu_id  from dual
      union all
      select 'Frais de coupure suite � non paiement' ite_name,335 ite_id,4104 vow_unit,365 pta_id,1 psl_rank,v_tva_id tva_id,1 vol_base,
             1 vol_fact,p_fermeture/1000 prixht,p_fermeture/1000 mntht,p_tvaferm/1000 mnttva,
             (p_fermeture+p_tvaferm)/1000 mntttc, null meu_id from dual
      union all
      select 'Frais de pr�avis et de rappel de paiement' ite_name,338 ite_id,4104 vow_unit,389 pta_id,1 psl_rank,v_tva_id tva_id,1 vol_base,
             1 vol_fact,p_preavis/1000 prixht,p_preavis/1000 mntht,p_tva_preav/1000 mnttva,
             (p_preavis+p_tva_preav)/1000  mntttc, null meu_id  from dual
      union all
      select 'Frais de d�placement' ite_name,1764 ite_id,4104 vow_unit,5624 pta_id,1 psl_rank,v_tva_id tva_id,1 vol_base,
             1 vol_fact,p_deplacement/1000 prixht,p_deplacement/1000 mntht,p_tvadeplac/1000 mnttva,
             (p_deplacement+p_tvadeplac)/1000 mntttc,  null meu_id  from dual
      union all
      select 'Frais de d�pose ou repose suite � la demande du client' ite_name,355 ite_id,4104 vow_unit,414 pta_id,1 psl_rank,v_tva_id tva_id,1 vol_base,
             1 vol_fact,p_depose_dem/1000 prixht,p_depose_dem/1000 mntht,p_tvadepose_dem/1000 mnttva,
             (p_depose_dem+p_tvadepose_dem)/1000 mntttc, null meu_id from dual
      union all
      select 'Frais de d�pose ou repose compteur suite � non paiement' ite_name,336 ite_id,4104 vow_unit,377 pta_id,1 psl_rank,v_tva_id tva_id,1 vol_base,
             1 vol_fact,p_depose_def/1000 prixht,p_depose_def/1000 mntht,p_tvadepose_def/1000 mnttva,
             (p_depose_def+p_tvadepose_def)/1000 mntttc, null meu_id   from dual
      union all
      select 'Montant extention' ite_name,1979 ite_id,4104 vow_unit,2303 pta_id,1 psl_rank,v_tva_id tva_id,1 vol_base,
             1 vol_fact,p_extention/1000 prixht,p_extention/1000 mntht,p_tva_capit/1000 mnttva,
             (p_extention+p_tva_capit)/1000 mntttc, null meu_id  from  dual
      union all
      select 'Produit financier' ite_name,1982 ite_id,4104 vow_unit,2306 pta_id,1 psl_rank,v_tva_id tva_id,1 vol_base,
             1 vol_fact,p_pfinancier/1000 prixht,p_pfinancier/1000 mntht,p_tva_pfin/1000 mnttva,
             (p_pfinancier+p_tva_pfin)/1000 mntttc, null meu_id   from dual
      union all
      select 'Montant capital ONAS' ite_name,1981 ite_id,4104 vow_unit,2305 pta_id,1 psl_rank,25 tva_id,1 vol_base,
             1 vol_fact,p_capit/1000 prixht,p_capit/1000 mntht,0/1000 mnttva,
             p_capit/1000 mntttc , null meu_id  from dual
      union all
      select 'Montant interet ONAS' ite_name,1978 ite_id,4104 vow_unit,2302 pta_id,1 psl_rank,25 tva_id,1 vol_base,
             1 vol_fact,p_inter/1000 prixht,p_inter/1000 mntht,0/1000 mnttva,
             p_inter/1000 mntttc , null meu_id  from dual
      union all
      select 'Ancien report' ite_name,1983 ite_id,4104 vow_unit,2307 pta_id,1 psl_rank,25 tva_id,1 vol_base,
             1 vol_fact,p_arepor/1000 prixht,p_arepor/1000 mntht,0/1000 mnttva,
             p_arepor/1000 mntttc , null meu_id  from dual
      union all
      select 'Nouveau report' ite_name,1980 ite_id,4104 vow_unit,2304 pta_id,1 psl_rank,25 tva_id,1 vol_base,
             1 vol_fact,p_narond/1000 prixht,p_narond/1000 mntht,0/1000 mnttva,
             p_narond/1000 mntttc , null meu_id  from dual
      union all
      select 'Article de reprise SONEDE' ite_name,329 ite_id,4104 vow_unit,325 pta_id,1 psl_rank,25 tva_id,1 vol_base,
             1 vol_fact,p_reprise_S/1000 prixht,p_reprise_S/1000 mntht,0/1000 mnttva,
             p_reprise_S/1000 mntttc , null meu_id  from dual
      union all
      select 'Article de reprise ONAS' ite_name,330 ite_id,4104 vow_unit,324 pta_id,1 psl_rank,25 tva_id,1 vol_base,
             1 vol_fact,p_reprise_O/1000 prixht,p_reprise_O/1000 mntht,0/1000 mnttva,
             p_reprise_O/1000 mntttc, null meu_id from dual 
      union all
      select 'Article de reprise B1' ite_name,3696 ite_id,4832 vow_unit,6704 pta_id,1 psl_rank,25 tva_id,1 vol_base,
             1 vol_fact,p_reprise_B1/1000 prixht,p_reprise_B1/1000 mntht,0/1000 mnttva,
             p_reprise_B1/1000 mntttc, null meu_id from dual   
              union all
      select 'Article de reprise B2' ite_name,3698 ite_id,4832 vow_unit,6705 pta_id,1 psl_rank,25 tva_id,1 vol_base,
             1 vol_fact,p_reprise_B2/1000 prixht,p_reprise_B2/1000 mntht,0/1000 mnttva,
             p_reprise_B2/1000 mntttc, null meu_id from dual  
    ) ligne
    where ligne.mntttc<>0;
EXCEPTION WHEN OTHERS THEN
   v_g_err_code := SQLCODE;
   v_g_err_msg := SUBSTR(SQLERRM, 1, 200);
   p_pk_exception := v_g_err_code || ' : ' ||  v_g_err_msg;       
END;  


--------------------------------------------------------------------------------------------------------------------
--------------------------------------------------------------------------------------------------------------------
/*procedure MigrationFacture_version
 (
  p_pk_etape     out varchar2,
  p_pk_exception out varchar2,
  p_deb_id       out number,
  p_bil_id       out number,
  p_district     in varchar2,
  p_tourne       in varchar2,
  p_ordre        in varchar2,
  p_spt_id       in number,
  p_imp_id       in number,
  p_sag_id       in number,
  p_par_id       in number,
  p_adr_id       in number,
  p_org_id       in number,
  p_periode      in number,
  p_annee        in number,
  p_deb_amountinit  in number,
  p_deb_amountremain  in number,
  p_bil_amountht in number,
  p_bil_amounttva   in number,
  p_bil_amountttc  in number,
  p_version in number,
  p_tothte   in number,
  p_tva      in number,
  p_tothta    in number,
  p_tottvaa   in number,
  p_bil_calcdt   in date ,
  p_dt_abn      in date,
  p_fac_datecalcul  in date,
  p_etat in varchar2,
  p_train_fact in varchar2,
  p_deb_comment in varchar2,
  p_net_a_payer  in number,
  p_deb_amount_cash in number,
  p_deb_amountinit in number,
  p_solde          in number,
  c_bil_id       in number,
  p_vow_settlemode in number,
  p_vow_acotp     in number,
  p_vow_modefact  in number,
  p_vow_debtype in number
)  
  IS 
  cursor c1(v_bil_id number)
  is 
  select * 
  from genbilline e  
  where e.bil_id=v_bil_id;
  
/*  cursor c3 (v_fact varchar2)
  is 
  select count(*) nombre
    from src_impayee t
    where trim(t.net)<>trim(t.mtpaye)
    and lpad(trim(t.district),2,'0')||
      lpad(trim(t.tournee),3,'0')||
      lpad(trim(t.ordre),3,'0')||
      to_char(t.annee)||
      lpad(trim(t.trimestre),2,'0')||'0'=v_fact;*//*
  v_run_id           number;
  v_aco_id           number;
  v_sco_id           number;
  v_nbr              number;
begin 
    select count(*) into v_nbr from genbill b where b.bil_code=p_id_facture;
    if v_nbr=0 then
        if (p_annee is not null and p_periode is not null and p_train_fact is not null) then      
			begin
			  select t.run_id
			  into v_run_id
			  from genrun t 
			  where t.run_exercice=p_annee
			  and run_number      =p_periode;
			exception when others then        
			  select seq_genrun.nextval into v_run_id from dual;        
				insert into genrun (run_id,run_exercice,run_number,org_id,run_startdt,run_comment,RUN_NAME,RUN_DTCALC,RUN_ENDDT)
					         values(v_run_id,p_annee,p_periode,p_org_id,p_fac_datecalcul,'Role migr�','Role '||p_train_fact,p_fac_datecalcul,p_fac_datecalcul);
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
       
			select seq_gendebt.nextval into p_deb_id from dual; 
			insert into gendebt(deb_id,deb_refe,org_id,par_id,adr_id,deb_date,deb_duedt,deb_printdt,
								deb_amountinit,deb_amountremain,bap_id,vow_settlemode,aco_id,deb_norecovery,deb_credt,
								deb_updtby,deb_updtdt,deb_comment,deb_amount_cash,sag_id,vow_debtype,deb_prel)
						 values(p_deb_id,p_id_facture,p_org_id,p_par_id,p_adr_id,p_fac_datecalcul,p_fac_datecalcul,p_fac_datecalcul,
								p_deb_amountinit,p_deb_amountremain,null,p_vow_settlemode,v_aco_id,0,sysdate,
								null,null,p_deb_comment,p_deb_amount_cash,p_sag_id,p_vow_debtype,1);  
			commit;
			select seq_agrbill.nextval into p_bil_id from dual;
			insert into agrbill(bil_id,sag_id,vow_agrbilltype,vow_modefact)
						values (p_bil_id,p_sag_id,p_vow_agrbilltype,p_vow_modefact);
			insert into genbill(bil_id,bil_code,bil_calcdt,bil_amountht,bil_amounttva,bil_amountttc,
								deb_id,par_id,bil_status,bil_amountttcdec,bil_debtdt,run_id)
						 values(p_bil_id,p_id_facture,p_fac_datecalcul,p_bil_amountht,p_bil_amounttva,p_bil_amountttc,
								p_deb_id,p_par_id,1,null,p_fac_datecalcul,v_run_id); 
			commit; 
			for s1 in c1(c_bil_id)loop
				insert into genbilline(bil_id,bli_reversebli_id,bli_number,bli_reverseblinumber,bli_name,bli_exercice,ite_id,pta_id,psl_rank,
									   imp_id,bli_volumebase,bli_volumefact,bli_puht,tva_id,bli_mht,bli_mttva,bli_mttc,bli_startdt,
									   bli_enddt,vow_unit,bli_nbunites,bli_detail,bli_cancel,imc_id,imp_analytique_id,bli_periodeinit,
									   bli_periode,bli_reversedt,bli_credt,bli_updtdt,bli_updtby,meu_id,bli_name_a,bli_reverseblidec_id,bli_reverseblinumberdec,bli_reversedecdt)
								values(p_bil_id,null,s1.bli_number,null,s1.bli_name,p_annee,s1.ite_id,s1.pta_id,s1.psl_rank,
									   null,s1.bli_volumebase,s1.bli_volumebase,s1.bli_puht,s1.tva_id,s1.bli_mht,s1.bli_mttva,s1.bli_mttc,v_fac_datecalcul,
									   p_fac_datecalcul,s1.vow_unit,null,0,0,null,null,null,
									   null,null,sysdate,null,null,null,null,null,null,null);
			end loop;     
    		select seq_gendebt.nextval into p_deb_id from dual; 
		   -- for s3 in c3 loop
				p_vow_debtype      := 3134;--'FA'
			 -- if (s3.nombre=0)  then  --- Facture Normal else Facture Avoire
			  p_deb_amount_cash  := p_tothte+p_tva+p_tothta+p_tottvaa;
				p_deb_amountinit   := p_tothte+p_tva+p_tothta+p_tottvaa;
				insert into gendebt(deb_id,deb_refe,org_id,par_id,adr_id,deb_date,deb_duedt,deb_printdt,
								   deb_amountinit,deb_amountremain,bap_id,vow_settlemode,aco_id,deb_norecovery,deb_credt,
								   deb_updtby,deb_updtdt,deb_comment,deb_amount_cash,sag_id,vow_debtype,deb_prel)
						   values (v_deb_id,p_id_facture,p_org_id,p_par_id,p_adr_id,p_fac_datecalcul,p_fac_datecalcul,p_fac_datecalcul,
								   p_deb_amountinit,p_solde,null,p_vow_settlemode,v_aco_id,v_deb_norecovery,sysdate,
								   null,null,p_deb_comment,p_deb_amount_cash,p_sag_id,p_vow_debtype,1);  
			 /* else
			 partie_impayees
				p_deb_amount_cash  := (p_tothte+p_tva+p_tothta+p_tottvaa);
				p_deb_amountinit   := 0;
				insert into gendebt(deb_id,deb_refe,org_id,par_id,adr_id,deb_date,deb_duedt,deb_printdt,
						  deb_amountinit,deb_amountremain,bap_id,vow_settlemode,aco_id,deb_norecovery,deb_credt,
						  deb_updtby,deb_updtdt,deb_comment,deb_amount_cash,sag_id,vow_debtype,deb_prel)
					  values (v_deb_id,p_id_facture,p_org_id,p_par_id,p_adr_id,p_fac_datecalcul,p_fac_datecalcul,p_fac_datecalcul,
						  p_deb_amountinit,p_solde,null,p_vow_settlemode,v_aco_id,v_deb_norecovery,sysdate,
						  null,null,p_deb_comment,p_deb_amount_cash,p_sag_id,p_vow_debtype,1);  
			  end if ; *//*
        select seq_agrbill.nextval into p_bil_id from dual; 
        p_bil_amountht      :=  p_tothte +p_tothta;
        p_bil_amounttva     :=  p_tva+p_tottvaa;
        p_bil_amountttc     :=  p_tothte +p_tva+p_tothta+p_tottvaa;
        p_vow_agrbilltype   :=  pk_genvocword.getidbycode('VOW_AGRBILLTYPE',decode(s1.etat,'P','RF','O','FC','C','FHC','FC'),null) ;
        insert into agrbill(bil_id,sag_id,vow_agrbilltype,vow_modefact)
                     values(v_bil_id,p_sag_id,p_vow_agrbilltype,p_vow_modefact);  
        insert into genbill(bil_id,bil_code,bil_calcdt,bil_amountht,bil_amounttva,bil_amountttc,
						    deb_id,par_id,bil_status,bil_amountttcdec,bil_debtdt,run_id)
				     values(p_bil_id,p_id_facture,p_fac_datecalcul,p_bil_amountht,p_bil_amounttva,p_bil_amountttc,
						    p_deb_id,v_par_id,1,null,p_fac_datecalcul,v_run_id); 
        commit;
      end if;
end; */
--------------------------------------------------------------------------------------------------------------------
--------------------------------------------------------------------------------------------------------------------
PROCEDURE MigrationHistoriqueReleveTrim
  (
    p_param in number default 0
  )
  IS
    cursor c1
      is
      select lpad(trim(r.district),2,'0') district, lpad(trim(r.tourne),3,'0') tourne, lpad(trim(r.ordre),3,'0') ordre,
             to_number(trim(r.annee)) annee,to_number(trim(r.trim)) trim,r.releve,r.prorata,r.releve2,r.releve3,r.releve4,r.releve5,r.date_releve,
             r.compteurt,r.consommation,lpad(trim(r.anomalie),18,0)anomalie,r.avisforte,r.message_temporaire,
             b.spt_id,b.equ_id,b.mtc_id, r.rowid row_id 
      from   test.src_fiche_releve_corrig r   
        inner join   test.branchement b
        on     lpad(trim(b.district),2,'0')=lpad(trim(r.district),2,'0')
        and    lpad(trim(b.tourne),3,'0')  =lpad(trim(r.tourne),3,'0')
        and    lpad(trim(b.ordre),3,'0')   =lpad(trim(r.ordre),3,'0') 
      where   r.mrd_id is null
      and     trim(r.trim)is not null
      and     to_number(r.annee)<=2018;
      
      
      v_date_rel date;
      v_mois3 number;
      v_mrd_id number;
      v_index number;
      v_conso number;
      v_prorata number;
      v_avis_f number;
      v_tentatif1 number;
      v_tentatif2 number;
      v_tentatif3 number;
      v_tentatif4 number;
      v_tentatif5 number;
      v_compteur_t number;
      p_pk_etape     varchar2(400);
      p_pk_exception varchar2(400);
  BEGIN
    --Securite
    if p_param <> 3 then
      return;
    end if;
    
    for s1 in c1 loop
      begin
        p_pk_etape := 'Initialisation param releve';
        v_date_rel := null;
        v_mrd_id := null;
        v_index := null;
        v_conso := null;
        v_prorata := null;
        v_avis_f := null;
        v_tentatif1 := null;
        v_tentatif2 := null;
        v_tentatif3 := null;
        v_tentatif4 := null;
        v_tentatif5 := null;
        v_compteur_t := null;
        p_pk_exception := null;
        begin
          p_pk_etape := 'Recupere date depuis fiche releve';
          v_date_rel  :=to_date(replace(substr(s1.date_releve,1,instr(replace(replace(s1.date_releve,' ','#'),':','#'),'#')-1),'-','/'));
        exception when others then
          p_pk_etape := 'Calcul date depuis mois 3';
          select decode(s1.trim,1,3,2,6,3,9,12) into v_mois3 from dual;
          if (v_mois3=12) then
            v_date_rel :=to_date('08/'||'01'||'/'||to_char(s1.annee+1),'dd/mm/yyyy');
          else
            v_date_rel:=to_date('08/'||lpad(to_char(v_mois3+1),2,'0')||'/'||to_char(s1.annee),'dd/mm/yyyy');
          end if; 
        end;
        
        if v_date_rel is null then
          EXCEPTION_RELEVE(s1.district||s1.tourne||s1.ordre||'-'||s1.annee||'-'||s1.trim,null,'Impossible de recuperer la date de la releve',p_pk_etape);
          continue;
        end if;
        
        begin
          p_pk_etape := 'Recuperer index';
          v_index := to_number(trim(s1.releve));
          p_pk_etape := 'Recuperer conso';
          v_conso := to_number(trim(s1.consommation));
          p_pk_etape := 'Recuperer prorata';
          v_prorata := to_number(trim(s1.prorata));
          p_pk_etape := 'Recuperer avis';
          begin
            v_avis_f := to_number(trim(s1.avisforte));
          exception when others then
            v_avis_f := -99999;
          end;
          p_pk_etape := 'Recuperer tentatif2';
          begin
            v_tentatif2 := to_number(trim(s1.releve2));
          exception when others then
            v_tentatif2 := -99999;
          end;
          p_pk_etape := 'Recuperer tentatif3';
          begin
            v_tentatif3 := to_number(trim(s1.releve3));
          exception when others then
            v_tentatif3 := -99999;
          end;
          p_pk_etape := 'Recuperer tentatif4';
          begin
            v_tentatif4 := to_number(trim(s1.releve4));
          exception when others then
            v_tentatif4 := -99999;
          end;
          p_pk_etape := 'Recuperer tentatif5';
          begin
            v_tentatif5 := to_number(trim(s1.releve5));
          exception when others then
            v_tentatif5 := -99999;
          end;
          p_pk_etape := 'Recuperer compteur T';
          begin
            select decode(to_char(nvl(trim(s1.compteurt),0)),'0',0,1) into v_compteur_t from dual;
          exception when others then
            v_compteur_t := 0;
          end;
        exception when others then
          p_pk_exception := SQLCODE || ' : ' ||  SUBSTR(SQLERRM, 1, 200);
          EXCEPTION_RELEVE(s1.district||s1.tourne||s1.ordre||'-'||s1.annee||'-'||s1.trim,null,p_pk_exception,p_pk_etape);
          continue;
        end;
        
        MigrationReleve(p_pk_etape,p_pk_exception,v_mrd_id,s1.annee,s1.trim,v_index,v_conso,v_prorata,v_avis_f,
                        v_tentatif2,v_tentatif3,v_tentatif4,v_tentatif5,v_compteur_t,v_date_rel, 
                        substr(s1.anomalie,13,2),substr(s1.anomalie,7,2),substr(s1.anomalie,1,2),
                        trim(s1.message_temporaire),null,v_g_vow_readreason_t,v_g_vow_readmeth,1,s1.equ_id,s1.mtc_id,s1.spt_id,
                        v_g_age_id);
                        
        if p_pk_exception is not null then
          rollback;
          EXCEPTION_RELEVE(s1.district||s1.tourne||s1.ordre||'-'||s1.annee||'-'||s1.trim,null,p_pk_exception,p_pk_etape);
          continue;
        end if;
        
        if v_mrd_id is not null then
          update test.src_fiche_releve_corrig
          set    mrd_id = v_mrd_id
          where  rowid = s1.row_id;
          commit;
        end if;
      exception when others then
        p_pk_exception := SQLCODE || ' : ' ||  SUBSTR(SQLERRM, 1, 200);
        EXCEPTION_RELEVE(s1.district||s1.tourne||s1.ordre||'-'||s1.annee||'-'||s1.trim,null,p_pk_exception,p_pk_etape);
        continue;
      end;
    end loop;
  END;
--------------------------------------------------------------------------------------------
--------------------------------------------------------------------------------------------
PROCEDURE MigrationReleveT
  (
    p_param in number default 0
  )
  IS
    cursor c1
    is
      select lpad(trim(r.district),2,'0') district, lpad(trim(r.tourne),3,'0') tourne, lpad(trim(r.ordre),3,'0') ordre, lpad(trim(r.police),5,'0') police,
             to_number(r.annee) annee, to_number(r.trimestre) trimestre, r.indexr,r.consommation,
             r.prorata,r.cpt_tourne,r.anomalie_niche,r.anomalie_compteur,r.anomalie_fuite,r.date_releve,
             b.spt_id,b.mtc_id,b.equ_id, r.rowid row_id
      from   test.relevet r,  --3054157
             test.branchement b
      where  to_number(r.annee)>0
      and    to_number(r.trimestre)>0 --459984
      and    r.mrd_id is null 
      and    lpad(trim(r.district),2,'0') = lpad(trim(b.district),2,'0')
      and    lpad(trim(r.tourne),3,'0') = lpad(trim(b.tourne),3,'0')
      and    lpad(trim(r.ordre),3,'0') = lpad(trim(b.ordre),3,'0')
      and    lpad(trim(r.police),5,'0') = lpad(trim(b.police),5,'0') --459922
      and    not exists(select 1
                        from   tecservicepoint spt,
                               tecmtrread mrd
                        where  spt.spt_refe = lpad(trim(r.district),2,'0')||lpad(trim(r.tourne),3,'0')
                                              ||lpad(trim(r.ordre),3,'0')||lpad(trim(r.police),5,'0')
                        and    spt.spt_id = mrd.spt_id
                        and    mrd.mrd_year = to_number(r.annee)
                        and    mrd.mrd_multicad = to_number(r.trimestre)  --653
                        );
   
    v_date_rel date;
    v_mois3 number;
    v_mrd_id number;
    v_index number;
    v_conso number;
    v_prorata number;
    v_compteur_t number;
    p_pk_etape     varchar2(400);
    p_pk_exception varchar2(400);
  BEGIN
    --Securite
    if p_param <> 3 then
      return;
    end if;
    
    for s1 in c1 loop
      begin
        p_pk_etape := 'Initialisation param releve';
        v_date_rel := null;
        v_mrd_id   := null;
        v_index := null;
        v_conso := null;
        v_prorata := null;
        v_compteur_t := null;
        p_pk_exception := null;
        begin
          p_pk_etape := 'Recupere date depuis releveT';
          v_date_rel  :=to_date(s1.date_releve);
        exception when others then
          p_pk_etape := 'Calcul date depuis mois 3';
          select decode(s1.trimestre,1,3,2,6,3,9,12) into v_mois3 from dual;
          if (v_mois3=12) then
            v_date_rel :=to_date('08/'||'01'||'/'||to_char(s1.annee+1),'dd/mm/yyyy');
          else
            v_date_rel:=to_date('08/'||lpad(to_char(v_mois3+1),2,'0')||'/'||to_char(s1.annee),'dd/mm/yyyy');
          end if; 
        end;
        
        p_pk_etape := 'Recuperer index';
        v_index := to_number(trim(s1.indexr));
        p_pk_etape := 'Recuperer conso';
        v_conso := to_number(trim(s1.consommation));
        p_pk_etape := 'Recuperer prorata';
        v_prorata := to_number(trim(s1.prorata));      
        p_pk_etape := 'Recuperer compteur T';
        begin
          select decode(nvl(trim(s1.cpt_tourne),'0'),'0',0,1) into v_compteur_t from dual;
        exception when others then
          v_compteur_t := 0;
        end;
        
        MigrationReleve(p_pk_etape,p_pk_exception,v_mrd_id,s1.annee,s1.trimestre,v_index,v_conso,v_prorata,null,
                        null,null,null,null,v_compteur_t,v_date_rel, 
                        trim(s1.anomalie_fuite),trim(s1.anomalie_niche),trim(s1.anomalie_compteur),
                        null,'RELEVET',v_g_vow_readreason_t,v_g_vow_readmeth,1,s1.equ_id,s1.mtc_id,s1.spt_id,
                        v_g_age_id);
        
        if p_pk_exception is not null then
          rollback;
          EXCEPTION_RELEVET(s1.district||s1.tourne||s1.ordre||s1.police||'-'||s1.annee||'-'||s1.trimestre,null,p_pk_exception,p_pk_etape);
          continue;
        end if;
        if v_mrd_id is not null then
          update test.relevet
          set    mrd_id = v_mrd_id
          where  rowid = s1.row_id;
        end if;
        commit;       
      exception when others then
        rollback;
        p_pk_exception := SQLCODE || ' : ' ||  SUBSTR(SQLERRM, 1, 200);
        EXCEPTION_RELEVET(s1.district||s1.tourne||s1.ordre||s1.police||'-'||s1.annee||'-'||s1.trimestre,null,p_pk_exception,p_pk_etape);
        continue;
      end;
    end loop;
  END;
--------------------------------------------------------------------------------------------
--------------------------------------------------------------------------------------------
PROCEDURE MigrationReleveGC
  (
    p_param in number default 0
  )
  IS
    cursor c1
    is
      select lpad(trim(r.district),2,'0') district, lpad(trim(r.tourne),3,'0') tourne, lpad(trim(r.ordre),3,'0') ordre, lpad(trim(r.police),5,'0') police,
             to_number(trim(r.annee)) annee, to_number(trim(r.mois)) mois, r.indexr,r.consommation,
             r.prorata,r.cpt_tourne,r.anomalie_niche,r.anomalie_compteur,r.anomalie_fuite,r.date_releve,
             b.spt_id,b.mtc_id,b.equ_id, r.rowid row_id
      from   test.relevegc r,  
             test.branchement b
      where  to_number(trim(r.annee))>0
      and    to_number(trim(r.mois))>0
      and    r.mrd_id is null 
      and    lpad(trim(r.district),2,'0') = lpad(trim(b.district),2,'0')
      and    lpad(trim(r.tourne),3,'0') = lpad(trim(b.tourne),3,'0')
      and    lpad(trim(r.ordre),3,'0') = lpad(trim(b.ordre),3,'0')
      and    lpad(trim(r.police),5,'0') = lpad(trim(b.police),5,'0') 
      and    not exists(select 1
                        from   tecservicepoint spt,
                               tecmtrread mrd
                        where  spt.spt_refe = lpad(trim(r.district),2,'0')||lpad(trim(r.tourne),3,'0')
                                              ||lpad(trim(r.ordre),3,'0')||lpad(trim(r.police),5,'0')
                        and    spt.spt_id = mrd.spt_id
                        and    mrd.mrd_year = to_number(trim(r.annee))
                        and    mrd.mrd_multicad = to_number(trim(r.mois))  
                        );
   
    v_date_rel date;
    v_mois3 number;
    v_mrd_id number;
    v_index number;
    v_conso number;
    v_prorata number;
    v_compteur_t number;
    p_pk_etape     varchar2(400);
    p_pk_exception varchar2(400);
  BEGIN
    --Securite
    if p_param <> 3 then
      return;
    end if;
    
    for s1 in c1 loop
      begin
        p_pk_etape := 'Initialisation param releve';
        v_date_rel := null;
        v_mrd_id := null;
        v_index := null;
        v_conso := null;
        v_prorata := null;
        v_compteur_t := null;
        p_pk_exception := null;
        begin
          p_pk_etape := 'Recupere date depuis releveGC';
          v_date_rel  :=to_date(s1.date_releve);
        exception when others then
          p_pk_etape := 'Calcul date depuis mois 3';
          select decode(s1.mois,1,3,2,6,3,9,12) into v_mois3 from dual;
          if (v_mois3=12) then
            v_date_rel :=to_date('02/'||'01'||'/'||to_char(s1.annee+1),'dd/mm/yyyy');
          else
            v_date_rel:=to_date('02/'||lpad(to_char(v_mois3+1),2,'0')||'/'||to_char(s1.annee),'dd/mm/yyyy');
          end if; 
        end;
        
        p_pk_etape := 'Recuperer index';
        v_index := to_number(trim(s1.indexr));
        p_pk_etape := 'Recuperer conso';
        v_conso := to_number(trim(s1.consommation));
        p_pk_etape := 'Recuperer prorata';
        v_prorata := to_number(trim(s1.prorata));      
        p_pk_etape := 'Recuperer compteur T';
        begin
          select decode(nvl(trim(s1.cpt_tourne),'0'),'0',0,1) into v_compteur_t from dual;
        exception when others then
          v_compteur_t := 0;
        end;
        
        MigrationReleve(p_pk_etape,p_pk_exception,v_mrd_id,s1.annee,s1.mois,v_index,v_conso,v_prorata,null,
                        null,null,null,null,v_compteur_t,v_date_rel, 
                        trim(s1.anomalie_fuite),trim(s1.anomalie_niche),trim(s1.anomalie_compteur),
                        null,'RELEVEGC',v_g_vow_readreason_t,v_g_vow_readmeth,1,s1.equ_id,s1.mtc_id,s1.spt_id,
                        v_g_age_id);
        
        if p_pk_exception is not null then
          rollback;
          EXCEPTION_RELEVEGC(s1.district||s1.tourne||s1.ordre||s1.police||'-'||s1.annee||'-'||s1.mois,null,p_pk_exception,p_pk_etape);
          continue;
        end if;
        if v_mrd_id is not null then
          update test.relevegc
          set    mrd_id = v_mrd_id
          where  rowid = s1.row_id;
        end if;
        commit;       
      exception when others then
        rollback;
        p_pk_exception := SQLCODE || ' : ' ||  SUBSTR(SQLERRM, 1, 200);
        EXCEPTION_RELEVEGC(s1.district||s1.tourne||s1.ordre||s1.police||'-'||s1.annee||'-'||s1.mois,null,p_pk_exception,p_pk_etape);
        continue;
      end;
    end loop;
  END;
---------------------------------------------------------------------------------------------
---------------------------------------------------------------------------------------------  
PROCEDURE MigrationTousClients
  (
    p_param in number default 0
  )
  IS
   --Curseur des client et des adm
    cursor c1
    is
      select district,categorie, code, tel, autre_tel, fax, substr(nom,1,50) nom, adresse, code_postal,
             code_cli, rowid
      from   test.src_clients
      where  par_id is null;
      
    v_par_id number;
    p_pk_etape     varchar2(400);
    p_pk_exception varchar2(400);
  BEGIN
    --Securite
    if p_param <> 3 then
      return;
    end if;

    --Curseur des client et adm
    for s1 in c1 loop
      v_par_id := null;
      MigrationClient(p_pk_etape,p_pk_exception,v_par_id,s1.adresse,s1.code_postal,s1.code_cli,s1.categorie,s1.nom,s1.tel,s1.autre_tel,s1.fax);
      if p_pk_exception is not null then
        rollback;
        EXCEPTION_CLIENT(s1.code_cli,null,p_pk_exception,p_pk_etape);
        continue;
      end if;
      if v_par_id is not null then
        update test.src_clients 
        set    par_id = v_par_id
        where  rowid = s1.rowid;
      end if;
      commit;
    end loop; --Curseur client et adm
  END;
----------------------------------------------------------------------------------------------
----------------------------------------------------------------------------------------------
PROCEDURE MigrationQuotidien
  (
  
  p_param in number default 0

  )
  IS
    cursor c2
    is
      select lpad(trim(b.district),2,'0') district, lpad(trim(b.police),5,'0') police, lpad(trim(b.tourne),3,'0') tourne, lpad(trim(b.ordre),3,'0') ordre, trim(b.adresse) adresse, b.date_creation,
            lpad(trim(b.categorie_actuel),2,'0') categorie_actuel, upper(trim(b.client_actuel)) client_actuel, lpad(trim(b.code_marque),3,'0') code_marque, 
            lpad(trim(b.compteur_actuel),11, '0') compteur_actuel, lpad(trim(b.code_postal),4,'0') code_postal,
            trim(b.usage) usage, b.type_branchement, b.aspect_branchement, b.marche, trim(b.etat_branchement) etat_branchement,trim(b.banque) banque,trim(b.agence) agence,trim(b.num_compte) num_compte,
            trim(b.cle_rib) cle_rib,lpad(trim(b.tarif),2,'0') tarif, substr(b.onas,-1,1) tarif_onas,b.volume_puit_onas vol_puit,upper(trim(b.gros_consommateur)) mensu,
            lpad(trim(b.district),2,'0')||lpad(trim(b.categorie_actuel),2,'0')||trim(upper(b.client_actuel)) code_cli, b.rowid row_id, 
            upper(substr(a.tarif_onas,-1,1)) tarif_onas_a,a.codpoll codpoll_a,lpad(trim(a.tarif),2,'0') tarif_a,a.echt echt_a,a.echr echr_a,a.brt/1000 brt_a,a.echronas echronas_a,
            a.echtonas echtonas_a,a.capitonas/1000 capitonas_a,a.interonas/1000 interonas_a,a.arrond/1000 arrond_a,a.categ categ_a,trim(a.gros_consommateur) gros_consommateur_a,
            decode(lpad(trim(b.categorie_actuel),2,'0') ,'02',lpad(trim(b.client_actuel),4,'0'),lpad(trim(b.district),2,'0')||lpad(trim(b.categorie_actuel),2,'0')||upper(trim(b.client_actuel))) code_cli_bis,
            c.par_id
	    from   test.branchement b
       left join test.src_abonnees a 
       on     lpad(trim(dist),2,'0') = lpad(trim(b.district),2,'0')
       and    lpad(trim(pol),5,'0') = lpad(trim(b.police),5,'0')
       and    lpad(trim(tou),3,'0') = lpad(trim(b.tourne),3,'0')
       and    lpad(trim(ord),3,'0') = lpad(trim(b.ordre),3,'0')
       left join test.src_clients c
       on     c.code_cli = decode(lpad(trim(b.categorie_actuel),2,'0') ,'02',lpad(trim(b.client_actuel),4,'0'),
                                      lpad(trim(b.district),2,'0')||lpad(trim(b.categorie_actuel),2,'0')||upper(trim(b.client_actuel)))
	   where  spt_id is null
     /*and    lpad(trim(b.district),2,'0')||lpad(trim(b.tourne),3,'0')||
            lpad(trim(b.ordre),3,'0')||lpad(trim(b.police),5,'0')='4875478624150'*/
     order by trim(b.etat_branchement);

   v_par_id number;
   v_date_resil date;
   v_pre_id number;
   v_spt_id number;
   v_equ_id number;
   v_rou_id number;
   v_dvt_id number;
   v_sag_id number;
   v_org_id number;
   v_adr_id number;
   v_adr_fs_id number;
   v_mtc_id number;
   v_aco_id number;
   v_aac_id number;
   v_mrd_id number;
   p_pk_etape     varchar2(400);
   p_pk_exception varchar2(400);
  BEGIN
    
    --Securite
    if p_param <> 3 then
      return;
    end if;
    
    
    --Migration des branchement
    for s2 in c2 loop
      --insert into mig_trace values(s2.district||s2.tourne||s2.ordre||s2.police,'Initialisation',systimestamp);
      --initialisation
      v_par_id := null;
      v_date_resil := null;
      v_pre_id := null;
      v_spt_id := null;
      v_equ_id := null;
      v_rou_id := null;
      v_dvt_id := null;
      v_sag_id := null;
      v_org_id := null;
      v_adr_id := null;
      v_mtc_id := null;
      v_aac_id := null;
      v_aco_id := null;
      p_pk_etape := null;
      p_pk_exception := null;
      --Selection du client abonne
      if s2.par_id is null then
        MigrationClient(p_pk_etape,p_pk_exception,v_par_id,s2.adresse,s2.code_postal,
                        s2.code_cli_bis,s2.categorie_actuel,s2.code_cli_bis,null,null,null);
        if v_par_id is null then
          rollback;
          EXCEPTION_PDL(s2.district||s2.tourne||s2.ordre||s2.police,null,'Client/PDL : '||p_pk_exception,p_pk_etape);
          continue;
        end if;
      else
        v_par_id := s2.par_id;
      end if;

      --Selection secteur
      select max(dvt.dvt_id)
      into   v_dvt_id
      from   gendivision div,
             gendivdit dvt
      where  div.div_code = s2.district
      and    div.div_id = dvt.div_id
      and    dvt.dit_id = v_g_dit_id;
      
      if v_dvt_id is null then
        rollback;
        EXCEPTION_PDL(s2.district||s2.tourne||s2.ordre||s2.police,null,'Impossible de trouver le secteur','Selection secteur');
        continue;
      end if;

      --Selection organisation
      select max(org_id)
      into   v_org_id
      from   genorganization
      where  org_code = s2.district;
      if v_org_id is null then
        rollback;
        EXCEPTION_PDL(s2.district||s2.tourne||s2.ordre||s2.police,null,'Impossible de trouver organisation','Selection organisation');
        continue;
      end if;
	  
	    --selection de la date de resiliation en cas de resilier
      v_date_resil := null;
      if s2.etat_branchement='9' and trim(s2.compteur_actuel) is null then
        /*select max(date_res)
        into   v_date_resil
        from   pivot.branchement_res_max
        where  dist = s2.district
        and    ref_pdl = tournee||ordre;

        if v_date_resil is null then
           
        end if;*/
        v_date_resil := trunc(sysdate);
      end if;
      
      --Creation du site/pdl
      MigrationSitePdl(p_pk_etape,p_pk_exception,v_pre_id,v_spt_id,v_rou_id,v_adr_id,v_par_id,s2.adresse,s2.code_postal,
                       s2.district,s2.tourne,s2.ordre,s2.police,s2.date_creation,v_date_resil,
                       v_dvt_id,v_org_id,s2.etat_branchement);
      
      if p_pk_exception is not null then
        rollback;
        EXCEPTION_PDL(s2.district||s2.tourne||s2.ordre||s2.police,null,p_pk_exception,p_pk_etape);
        continue;
      end if;
      --insert into mig_trace values(s2.district||s2.tourne||s2.ordre||s2.police,'Creation PDL',systimestamp);

      --Compteur
      MigrationCompteurEncours(p_pk_etape,p_pk_exception,v_equ_id,v_mtc_id,s2.compteur_actuel,s2.code_marque,v_spt_id,
                               s2.district,s2.tourne,s2.ordre,s2.date_creation,v_date_resil);
      if p_pk_exception is not null then
        rollback;
        EXCEPTION_PDL(s2.district||s2.tourne||s2.ordre||s2.police,null,p_pk_exception,p_pk_etape);
        continue;
      end if;
      --insert into mig_trace values(s2.district||s2.tourne||s2.ordre||s2.police,'Creation Pose compteur',systimestamp);
      
      --Contrat
      MigrationAbonnement(p_pk_etape,p_pk_exception,v_sag_id,v_aco_id,v_adr_fs_id,s2.district,s2.tourne,s2.ordre,s2.police,s2.date_creation,v_date_resil,
                          s2.mensu,s2.categorie_actuel,s2.banque,s2.agence,s2.num_compte,s2.cle_rib,s2.usage,s2.tarif,s2.tarif_onas,
                          s2.vol_puit,nvl(s2.tarif_onas_a,s2.tarif_onas),s2.codpoll_a,nvl(s2.tarif_a,s2.tarif),s2.echt_a,s2.echr_a,
                          s2.brt_a,s2.echronas_a,s2.echtonas_a,s2.capitonas_a,s2.interonas_a,s2.arrond_a,s2.categ_a,nvl(s2.gros_consommateur_a,'N'),
                          v_par_id,v_pre_id,v_spt_id,v_rou_id,v_adr_id);
                          
      if p_pk_exception is not null then
        rollback;
        EXCEPTION_CONTRAT(s2.district||s2.tourne||s2.ordre||s2.police,null,p_pk_exception,p_pk_etape);
        continue;
      end if;
      --insert into mig_trace values(s2.district||s2.tourne||s2.ordre||s2.police,'Creation contrat',systimestamp);
      
      if v_spt_id is not null then
        update test.branchement
        set    spt_id = v_spt_id,
               sag_id = v_sag_id,
               equ_id = v_equ_id,
               mtc_id = v_mtc_id,
               par_id = s2.par_id,
               aco_id = v_aco_id,
               adr_id = v_adr_fs_id
        where  rowid = s2.row_id;
      end if;
      --insert into mig_trace values(s2.district||s2.tourne||s2.ordre||s2.police,'Fin',systimestamp);
      commit;
      
    end loop;   /*
	  --Historique Releve
    for s3 in c3 loop
      v_mrd_id := null;
      if s3.spt_id is null then
        rollback;
        EXCEPTION_releve(s3.district||s3.tourne||s3.ordre||s3.police,null,'Impossible de trouver le pdl','Selection du releve');
        continue;
      else
        v_spt_id := s3.spt_id;
      end if;
      MigrationHitoriquereleve(p_pk_etape,p_pk_exception,s3.district,s3.tourne,s3.ordre,s3.equ_id,s3.mtc_id,v_spt_id,
                               v_g_meu_id,v_g_age_id,s3.prorata,s3.message_temporaire,s3.consommation,s3.trim,
                               s3.annee,s3.avisforte,s3.date_releve,s3.date_controle,s3.index_controle,s3.anomalie,s3.releve,
                               s3.releve2,s3.releve3,s3.releve4,s3.releve5,s3.mois,v_g_vow_readorig,v_g_vow_readmeth,v_mrd_id);
      if p_pk_exception is not null then
        rollback;
        EXCEPTION_releve(s3.district||s3.tourne||s3.ordre||s3.police,null,p_pk_exception,p_pk_etape);
        continue;
          end if;					   
      if v_mrd_id is not null then
        update test.src_fiche_releve
        set    mrd_id = v_mrd_id
        where  rowid = s3.rowid;
      end if;
      commit;
    end loop;
    /*
    for s4 in c4 loop
      v_mrd_id := null;
      if s4.spt_id is null then
      rollback;
      EXCEPTION_releve(s4.district||s4.tourne||s4.ordre||s4.police,null,'Impossible de trouver le pdl','Selection du releve');
      continue;
    else
      v_spt_id := s4.spt_id;
    end if;
  	  
      MigrationDernierreleve(p_pk_etape,p_pk_exception,s4.district,s4.tourne,s4.ordre,v_equ_id,
                             s4.mtc_id,v_spt_id,v_g_meu_id,v_g_age_id,s4.annee,s4.prorata,s4.trimestre,
                             s4.index_releve,s4.date_releve,s4.consommation,s4.moisT,
                             v_g_vow_comm1,v_g_vow_readorig,v_g_vow_readmeth,p_vow_readreason,mrd_id);
  												   
      if p_pk_exception is not null then
        rollback;
        EXCEPTION_releve(s4.district||s4.tourne||s4.ordre||s4.police,null,p_pk_exception,p_pk_etape);
        continue;
      end if;	
      if v_mrd_id is not null then
        update test.relevet
        set    mrd_id= v_mrd_id
        where  rowid = s4.rowid;
      end if;
      commit;  
    end loop;
	   /*
    for s7 in c7 loop
      v_bil_id := null;
      v_deb_id := null;
      if trim(s7.nindex) is null then	 
        select vow.vow_id
        into   v_g_vow_comm1
        from   genvoc     voc,
         genvocword vow
        where  voc.voc_id   = vow.voc_id
        and    vow.vow_code = s7.code_anomalie
        and    voc.voc_code = 'VOW_COMM1';  
      end if; 
      
      MigrationHitoriquerelevegc(p_pk_etape,p_pk_exception,s7.district,s7.tourne,s7.ordre,s7.refc01,s7.refc02,s7.prorata,s7.cons,s7.equ_id,
                                 s7.mtc_id,s7.spt_id,v_g_meu_id,v_g_age_id,s7.nindex,v_g_vow_readorig,v_g_vow_readmeth,v_g_vow_readreason,v_g_vow_comm1);                             
   
      if p_pk_exception is not null then
        rollback;
        EXCEPTION_FACTURE(s7.district||s7.tourne||s7.ordre||s7.police,null,p_pk_exception,p_pk_etape);
        continue;
      end if;	
      if v_mrd_id is not null then
        update test.src_relevet
        set    mrd_id= v_mrd_id
        where  rowid = s7.rowid;
      end if;
      commit;
    end loop;
 */
   
   
END; 
---------------------------------------------------------------------------------------
---------------------------------------------------------------------------------------
PROCEDURE MigrationInstanceProcess
  (
    p_pk_etape out varchar2,
    p_pk_exception out varchar2,
    p_con_id out number,
    p_dos_id out number,
    p_wdo_id out number,
    p_date_creation in date,
    p_etat in varchar2,
    p_par_id in number,
    p_org_id in number,
    p_dos_refe in varchar2,
    p_con_row in wfcontact%rowtype,
    p_dos_row in wfdossier%rowtype,
    p_wmd_id in number
  )
  IS
    v_lag_id number;
    v_lit_id number;
    v_lag_id2 number;
    v_lit_id2 number;
    v_cod_id number;
    v_hpr_id number;
  BEGIN
    --Ajouter le LAG
    select seq_wflist.nextval into v_lag_id from dual;
    insert into wflist(lst_id,vow_typlist,lst_updtby)
                values(v_lag_id,v_g_vow_typlist_age,v_g_age_id);
    insert into wflistage(lag_id,lag_order,age_id,vow_roleage,lag_default,lag_startdt,lag_updtby)
                   values(v_lag_id,0,v_g_age_id,v_g_vow_roleage_id,1,p_date_creation,v_g_age_id);       
    --Ajouter le LIT
    select seq_wflist.nextval into v_lit_id from dual;
    insert into wflist(lst_id,vow_typlist,lst_updtby)
                values(v_lit_id,v_g_vow_typlist_lit,v_g_age_id);
    insert into wflistitc(lit_id,lit_ordre,par_id,vow_roleitc,lit_startdt,lit_default,lit_updtby)
                   values(v_lit_id,0,p_par_id,v_g_vow_roleitc_id,p_date_creation,1,v_g_age_id);
    --Ajouter contact selon modele
    select seq_wfcontact.nextval into p_con_id from dual;
    insert into wfcontact(con_id,con_name,con_mcon_id,con_inout,cls_id,lag_id,lit_id,org_id,vow_oridmd,
                          vow_urgenc,vow_centre,con_comment,con_startdt,con_updtby,con_refe)
                   values(p_con_id,p_con_row.con_name||' '||p_dos_refe,v_g_mod_con_id,p_con_row.con_inout,
                          p_con_row.cls_id,v_lag_id,v_lit_id,p_org_id,v_g_vow_oridmd_id,
                          p_con_row.vow_urgenc,p_con_row.vow_centre,'ETAT_DEMANDE:'||p_etat,p_date_creation,v_g_age_id,p_con_id);
           
          
    --Ajouter le LAG
    select seq_wflist.nextval into v_lag_id2 from dual;
    insert into wflist(lst_id,vow_typlist,lst_updtby)
                values(v_lag_id2,v_g_vow_typlist_age,v_g_age_id);
    insert into wflistage(lag_id,lag_order,age_id,vow_roleage,lag_default,lag_startdt,lag_updtby)
                   values(v_lag_id2,0,v_g_age_id,v_g_vow_roleage_id,1,p_date_creation,v_g_age_id);       
    --Ajouter le LIT
    select seq_wflist.nextval into v_lit_id2 from dual;
    insert into wflist(lst_id,vow_typlist,lst_updtby)
                values(v_lit_id2,v_g_vow_typlist_lit,v_g_age_id);
    insert into wflistitc(lit_id,lit_ordre,par_id,vow_roleitc,lit_startdt,lit_default,lit_updtby)
                   values(v_lit_id2,0,p_par_id,v_g_vow_roleitc_id,p_date_creation,1,v_g_age_id);
    --Ajouter le dossier selon modele
    select seq_wfdossier.nextval into p_dos_id from dual;
    insert into wfdossier(dos_id,dos_name,dos_mdos_id,cls_id,lag_id,lit_id,org_id,vow_urgenc,dos_comment,
                          dos_startdt,dos_updtby,dos_refe,dos_status)
                   values(p_dos_id,p_dos_row.dos_name,p_dos_row.dos_id,p_dos_row.cls_id,v_lag_id2,v_lit_id2,
                          p_org_id,p_dos_row.vow_urgenc,'ETAT_DEMANDE:'||p_etat,p_date_creation,v_g_age_id,
                          p_dos_refe,1);
    insert into wfetape(etp_id,etp_name,etp_metp_id,dos_id,etp_ordre,vow_objetetp,
                        etp_startdt,etp_duedate,etp_updtby,vow_respetp,res_id,vow_typstruct,vow_rolecttage)
                 select seq_wfetape.nextval,etp_name,etp_id,p_dos_id,etp_ordre,vow_objetetp,
                        etp_startdt,etp_duedate,etp_updtby,vow_respetp,res_id,vow_typstruct,vow_rolecttage
                 from   wfetape
                 where  dos_id = p_dos_row.dos_id;
          
          
    --Ajouter lien contact et dossier
    select seq_wfcondos.nextval into v_cod_id from dual;
    insert into wfcondos(cod_id,con_id,dos_id,cod_updtby)
                  values(v_cod_id,p_con_id,p_dos_id,v_g_age_id);
                        
    --Ajouter processus
    select seq_wffolder.nextval into p_wdo_id from dual;
    insert into wffolder(wdo_id,wdo_nom,wdo_commentaire,wdo_dtcre,age_cre_id,wmd_id,int_resp_id,par_id)
                  values(p_wdo_id,p_dos_refe,'ETAT_DEMANDE:'||p_etat,p_date_creation,v_g_age_id,p_wmd_id,-1,p_par_id);
                        
    --Ajouter lien process/dossier/contact
    select seq_wfhprocess.nextval into v_hpr_id from dual;
    insert into wfhprocess(hpr_id,dos_id,con_id,wdo_id,hpr_startdt,hpr_updtby)
                    values(v_hpr_id,p_dos_id,p_con_id,p_wdo_id,p_date_creation,v_g_age_id);   
    --Ajouter les taches/ecran/field
    insert into wfstep(wta_id,wta_nom,wdo_id,wta_dtcre,age_cre_id,wta_execauto,
                       wta_etatexecution,wtt_id,wmt_id)
               select seq_wfstep.nextval,wmt.wmt_nom,p_wdo_id,p_date_creation,v_g_age_id,0,
                      1,wmt.wtt_id,wmt.wmt_id
               from   wfmodstep wmt  
               where  wmt.wmd_id = p_wmd_id;
          
    update wfstep wta    
    set    wta.wta_pere_id = (select wta2.wta_id
                              from   wfmodstep wmt2,
                                     wfstep wta2
                              where  wta.wmt_id = wmt2.wmt_id 
                              and    wmt2.wmt_pere_id = wta2.wmt_id
                              and    wta2.wdo_id = wta.wdo_id
                             )
    where wta.wdo_id = p_wdo_id;
    insert into wfscrean(screanid,name,type,wta_id,wdo_id,nbligne,nbcolumn,mscreanid,scr_comments)
                  select seq_wfscrean.nextval,msc.mname,msc.mtype,wta.wta_id,p_wdo_id,msc.mnbligne,msc.nbcolumn,msc.mscreenid,msc.mscr_comments
                  from   wfstep wta,
                         wfmodstep wmt,
                         wfmodscreen msc
                  where  wta.wdo_id = p_wdo_id
                  and    wta.wmt_id = wmt.wmt_id
                  and    wmt.wmt_id = msc.wmt_id; 
                        
    insert into wffield(fieldid, web_type, java_type, label, value, screanid, varname, 
                        width, height, lov, required, defaultvalue, refobjet, visible, 
                        partialtarget, disabled, ordre, positionx, positiony, hasvalidation, 
                        hastraitement, fld_master, isupdatable, fld_insert, fld_delete, 
                        mfieldid, fld_select, fld_masst, wdo_id, varname_a, 
                        fld_extvarname)
               select seq_wffield.nextval,mfl.mweb_type,mfl.mjava_type,mfl.mlabel,mfl.mvalue,scr.screanid,mfl.mvarname,
                      mfl.mwidth,mfl.mheight,mfl.mlov,mfl.mrequired,mfl.mdefaultvalue,mfl.mrefobjet,mfl.mvisible,
                      mfl.mpartialtarget,mfl.mdisabled,mfl.mordre,mfl.mpositionx,mfl.mpositiony,decode(mvl.mtype,1,1,0),
                      decode(mvl.mtype,0,1,0),mfl.mfld_master,mfl.misupdatable,mfl.mfld_insert,mfl.mfld_delete,
                      mfl.mfieldid,mfl.mfld_select,mfl.mfld_masst,p_wdo_id,mfl.mvarname_a,mfl.mfld_extvarname
               from   wfstep wta,
                      wfscrean scr,
                      wfmodscreen msc,
                      wfmodfield mfl,
                      wfmodfvalid mvl
               where  wta.wdo_id = p_wdo_id
               and    wta.wta_id = scr.wta_id
               and    scr.mscreanid = msc.mscreenid
               and    msc.mscreenid = mfl.mscreanid
               and    mfl.mfieldid = mvl.mfieldid(+);
          
    insert into wffvalid(wfvalid, type, expression, fieldid)
                  select seq_wffvalid.nextval,mvl.mtype,mvl.mexpression, fld.fieldid
                  from   wffield fld,
                         wfmodfield mfl,
                         wfmodfvalid mvl
                  where  fld.wdo_id = p_wdo_id
                  and    fld.mfieldid = mfl.mfieldid
                  and    mfl.mfieldid = mvl.mfieldid;
  EXCEPTION WHEN OTHERS THEN
     v_g_err_code := SQLCODE;
     v_g_err_msg := SUBSTR(SQLERRM, 1, 200);
     p_pk_exception := v_g_err_code || ' : ' ||  v_g_err_msg;
  END;
---------------------------------------------------------------------------------------
---------------------------------------------------------------------------------------
PROCEDURE MigrationDossierEnCours
  (
    p_pk_etape out varchar2,
    p_pk_exception out varchar2,
    p_param in number default 0
  )
  IS
    --Curseur pour les demandes DBS en cours
    cursor c1
    is
      select d.* 
      from   test.demande_ds d
      where  d.annuler = 'N'
      and    d.etat between 3 and 7
      and    ((d.etat in (3,4,5) and d.annee>2016) or (d.etat>5))
      and  trim(d.annee)||trim(d.district)||trim(d.localite)||lpad(trim(d.num),4,'0') = '201820050015';
    
    --Curseur des donn�es etude
    cursor c3(ann varchar2, dist varchar2, loc varchar2, numero varchar2)
    is 
      select *
      from   test.donnee_techniques_ds t
      where  t.annee = ann 
      and    t.district = dist 
      and    t.localite = loc
      and    t.num = numero
      order by t.date_instruction desc;
    
    --Curseur des types refections de l'etude
    cursor c4(ann varchar2, dist varchar2, loc varchar2, numero varchar2)
    is 
      select *
      from   test.refection_ds t
      where  t.annee = ann 
      and    t.district = dist 
      and    t.localite = loc
      and    t.num = numero;
    
    --Curseur des devis
    cursor c5(ann varchar2, dist varchar2, loc varchar2, numero varchar2)
    is 
      select *
      from   test.devis_ds t
      where  t.annee_ds = ann 
      and    t.district = dist 
      and    t.code_localite_ds = loc
      and    t.num_ds = numero
      and    t.etat != 'A';
    
    --Curseur des articles stock du devis
    cursor c6(ann varchar2, dist varchar2, loc varchar2, numero varchar2)
    is
      select i.ite_id, i.ite_code ,i.ite_name , i.vow_unit, p.tva_id,s.pta_id, s.psl_name, a.*
      from   test.article_ds a,
             genitem i,
             genitemtarif t,
             genitemperiodtarif p,
             genptaslice s
      where  a.annee = ann 
      and    a.district = dist 
      and    a.localite = loc
      and    a.num = numero
      and    upper(trim(a.code_article)) = upper(i.ite_code)
      and    i.ite_id = t.ite_id
      and    t.tar_id = p.tar_id
      and    p.pta_enddt is null
      and    p.pta_id = s.pta_id
      and    s.psl_rank = 1;
    
    --Curseur des autres articles devis  
    cursor c7(code varchar2)
    is
      select i.ite_id, i.ite_code ,i.ite_name , i.vow_unit, p.tva_id,s.pta_id, s.psl_name
      from   genitem i,
             genitemtarif t,
             genitemperiodtarif p,
             genptaslice s
      where  upper(i.ite_code) = upper(code)
      and    i.ite_id = t.ite_id
      and    t.tar_id = p.tar_id
      and    p.pta_enddt is null
      and    p.pta_id = s.pta_id
      and    s.psl_rank = 1;
    
    --Curseur des bon de commande
    cursor c8(ann varchar2, dist varchar2, loc varchar2, numero varchar2)
    is
      select *
      from   test.bon_commandeds t
      where  t.annee_ds = ann 
      and    t.district = dist 
      and    t.localite = loc
      and    t.num_ds = numero;
    
    --Curseur des paiement devis  
    cursor c9(ann varchar2, dist varchar2, loc varchar2, numero varchar2, numdevis number)
    is
      select *
      from   test.reglement_ds t
      where  t.annee_ds = ann 
      and    t.district = dist 
      and    t.code_localite_ds = loc
      and    t.num_ds = numero
      and    t.num_devis_ds = numdevis;
      
    --Curseur des credits (entete)
    cursor c10(ann varchar2, dist varchar2, loc varchar2, numero varchar2, numdevis number)
    is
      select distinct t.annee_ds, t.district, t.code_localite_ds, t.num_ds, t.it, t.trimes, t.echetotal
      from   test.credits t
      where  t.annee_ds = ann 
      and    t.district = dist 
      and    t.code_localite_ds = loc
      and    t.num_ds = numero
      and    t.num_devis_ds = numdevis;
    
    --Curseur des crredits (d�tails)
    cursor c11(ann varchar2, dist varchar2, loc varchar2, numero varchar2, numdevis number)
    is
      select *
      from   test.credits t
      where  t.annee_ds = ann 
      and    t.district = dist 
      and    t.code_localite_ds = loc
      and    t.num_ds = numero
      and    t.num_devis_ds = numdevis
      order by t.numecheance;
          
    v_con_row wfcontact%rowtype;
    v_dos_row wfdossier%rowtype;
    v_j number;
    v_categ varchar2(10);
    v_par_id number;
    v_par_name varchar2(400);
    v_par_telw varchar2(100);
    v_par_telm varchar2(100);
    v_cd_ps varchar2(100);
    v_adresse varchar2(4000);
    v_dos_id number;
    v_con_id number;
    v_wdo_id number;
    v_adr_id number;
    v_wmd_id number;
    v_wot_id number;
    v_wot_code varchar2(100);
    v_org_id number;
    v_dvt_id number;
    v_dos_refe varchar2(100);
    v_par_refe varchar2(100);
    v_hpr_id number;
  BEGIN
    --Securite
    if p_param <> 3 then
      return;
    end if;
    
    p_pk_etape := 'Selection du modele contact/dossier/process';
    
    select *
    into   v_con_row
    from   wfcontact
    where  con_id = v_g_mod_con_id;
    
    select dos.*
    into   v_dos_row
    from   wfdossier dos,
           wfcondos  cod
    where  cod.con_id = v_g_mod_con_id
    and    cod.dos_id = dos.dos_id;
    
    select max(wmd_id) 
    into   v_wmd_id
    from   wfmenu m 
    where  m.men_mdos_id = v_dos_row.dos_id;
    
    p_pk_etape := 'Selection du type intervention DBS Classique';
    select wot_id,wot_code
    into   v_wot_id,v_wot_code
    from   worwotype
    where  wot_code = 'DBS_CLASSIQUE';
    
    
    
    for s1 in c1 loop
      p_pk_etape := 'recuperation organisation';
      select max(org_id)
      into   v_org_id
      from   genorganization
      where  org_code = lpad(trim(s1.district),2,'0');
      if v_org_id is null then
         PK_WFSTEP.WF_INSERT_MIG_EXCP(v_dos_refe, 'ERR_ORG : Impossible de recuperer l organisation du code '||lpad(trim(s1.district),2,'0'));
         rollback;
         continue;
         --GOTO end_loop;
      end if;
      
      p_pk_etape := 'Recuperation du secteur';
      select max(dvt.dvt_id)
      into   v_dvt_id
      from   gendivision div,
             gendivdit dvt
      where  div.div_code = lpad(trim(s1.district),2,'0')
      and    div.div_id = dvt.div_id
      and    dvt.dit_id = v_g_dit_id;
    
      if v_dvt_id is null then
         PK_WFSTEP.WF_INSERT_MIG_EXCP(v_dos_refe, 'ERR_DVT : Impossible de recuperer le secteur district du code '||lpad(trim(s1.district),2,'0'));
         rollback;
         continue;
         --GOTO end_loop;
      end if; 
      
      begin
        --chercher si le dossier a ete migrer ou non
        v_dos_refe := trim(s1.annee)||lpad(trim(s1.district),2,'0')||trim(s1.localite)||lpad(trim(s1.num),4,'0');
        
        p_pk_etape := 'Verification existance dossier';
        select max(dos_id)
        into   v_dos_id
        from   wfdossier
        where  dos_refe = v_dos_refe;
        if (v_dos_id is not null) then
          --Le cas ou le dossier est cr�er on le met a jour
          begin
            select con_id 
            into   v_con_id
            from   wfcondos
            where  dos_id = v_dos_id;
            
            select wdo_id
            into   v_wdo_id
            from   wfhprocess
            where  dos_id = v_dos_id;
          exception when others then
            PK_WFSTEP.WF_INSERT_MIG_EXCP(v_dos_refe,'ERR1 : ' ||v_dos_refe ||' - Impossible de recuperer le con_id ou le wdo_id du dossier') ;
            continue;
            --GOTO end_loop;
          end;
        end if;
        
        p_pk_etape := 'Selection/Creation client';
        --Rechecher le client demandeur
        v_par_refe := lpad(trim(s1.district),2,'0')||lpad(trim(s1.CATEGORIE),2,'0')||trim(upper(s1.CLIENT));
        select max(par_id)
        into   v_par_id
        from   genparty p
        where  p.par_refe = v_par_refe;
        
        --Creer le client s'il n'existe pas
        if(v_par_id is null) then
          --Selection de la categorie
          select decode(lpad(trim(s1.categorie),2,'0'),'01','01','02','02','03','03','04','04','08','08','01')
          into   v_categ
          from   dual; 
          
          --Selection des infos clients depuis  
          begin
            select c.nom, c.tel, c.autre_tel, trim(c.code_postal), c.adresse
            into   v_par_name, v_par_telw, v_par_telm, v_cd_ps, v_adresse
            from   test.client c
            where  lpad(trim(c.categorie),2,'0') = lpad(trim(s1.categorie),2,'0')
            and    trim(c.code) = trim(s1.client) 
            and    lpad(trim(c.district),2,'0') = lpad(trim(s1.district),2,'0');
          exception when no_data_found then
            v_par_name := s1.client;
            v_cd_ps := s1.code_postal;
            v_adresse := '-';
          end;  
          
          MigrationClient(p_pk_etape,p_pk_exception,v_par_id,v_adresse,v_cd_ps,v_par_refe,v_categ,v_par_name,v_par_telw,v_par_telm,null);
        end if;
        
        --Creation de l'adresse du site
        p_pk_etape := 'Creation adresse branchement';
        if(s1.etat<8)then
          MigrationAdresse(p_pk_etape,p_pk_exception,v_adr_id,s1.adresse_brt,s1.code_postal);        
        end if;
        
        --Instantiation du processus
        p_pk_etape := 'Creation adresse branchement';
        
        if v_dos_id is null then
          MigrationInstanceProcess(p_pk_etape,p_pk_exception,v_con_id,v_dos_id,v_wdo_id,
                                   nvl(s1.date_creation,sysdate),s1.etat,v_par_id,v_org_id,
                                   v_dos_refe,v_con_row,v_dos_row,v_wmd_id);
          null;
        end if;
        
      exception when others then
        v_g_err_code := SQLCODE;
        v_g_err_msg := SUBSTR(SQLERRM, 1, 200);
        PK_WFSTEP.WF_INSERT_MIG_EXCP(v_dos_refe,'ERR_X : ' ||v_dos_refe ||' - '||v_g_err_code||':'||v_g_err_msg) ;
        rollback;
        v_j:= v_j+1;  
      end;
    end loop;
  END;
-----------------------------------------------------------------------------------
-----------------------------------------------------------------------------------
PROCEDURE MigrationFactureAS400
  (
    p_param in number default 0
  )
  IS
    cursor c1   
    is 
      select lpad(trim(f.dist),2,'0') district,lpad(trim(f.pol),5,'0') police,lpad(trim(f.tou),3,'0') tourne, 
             lpad(trim(f.ord),3,'0') ordre,decode(f.caron,1,1,0,0,-1) caron,f.refc01,f.refc02,f.refc03,f.refc04,f.tvacons,f.tva_ff,f.tvaferm,f.tva_preav,
             f.tvadeplac,f.tvadepose_dem,f.tvadepose_def,f.tva_capit,f.tva_pfin,(f.rbranche+f.rfacade) extention,
             (f.net-f.arriere) nett,f.monttrim,nvl(nvl(f.montt1,f.montt2),f.montt3) montt,nvl(nvl(const1,const2),const3)const,nvl(nvl(f.tauxt1,f.tauxt2),f.tauxt3) taux,f.mon1,
             f.volon1,f.tauon1,f.mon2,f.volon2,f.tauon2,f.mon3,f.volon3,f.tauon3,f.fixonas,f.fraisctr,f.fermeture,f.preavis,
             f.deplacement,f.depose_dem,f.depose_def,f.rbranche,f.rfacade,f.pfinancier,f.capit,f.inter,f.arepor,f.nindex,f.cons,f.prorata,
             f.narond,f.annee,f.periode,f.tiers,f.six ,f.cle_role,f.type,f.rowid row_id,
             b.date_creation,r.datexp fac_datecalcul,r.datl  fac_datelim,
             b.spt_id,b.mtc_id,b.equ_id,b.sag_id,b.par_id,b.aco_id,b.adr_id,b.org_id       
      from test.src_facture_as400_5 f
        inner join test.branchement b 
        on  lpad(trim(b.district),2,'0')= lpad(trim(f.dist),2,'0')
        and lpad(trim(b.tourne),3,'0')  = lpad(trim(f.tou),3,'0')   
        and lpad(trim(b.ordre),3,'0')   = lpad(trim(f.ord),3,'0')   
        and lpad(trim(b.police) ,5,'0') = lpad(trim(f.pol),5,'0')
        and b.sag_id is not null
        left join  test.src_role r
        on    lpad(trim(r.distr),2,'0') = lpad(trim(f.dist),2,'0')
        and   lpad(trim(r.tour),3,'0')  = lpad(trim(f.tou),3,'0')
        and   lpad(trim(r.ordr),3,'0')  = lpad(trim(f.ord),3,'0')
        and   lpad(trim(r.police),5,'0')= lpad(trim(f.pol),5,'0')       
        and   r.cle_role= f.cle_role 
      where f.bil_id is null
      /*and   lpad(trim(f.dist),2,'0')||lpad(trim(f.tou),3,'0')
          ||lpad(trim(f.ord),3,'0')||f.annee||lpad(trim(to_char(f.periode)),2,'0')||'0' = '161697702018070'*/;
   
   v_run_id number;
   v_bil_id number;
   v_deb_id number;
   v_mrd_id number;
   v_index   number;
   v_cons_releve    number;
   v_prorata number;
   v_annee   number;
   v_mois    number;
   v_tva     number;
   v_periode number;
   v_tot_ttc number(25,10);
   v_tot_ht  number(25,10);
   v_tot_tva number(25,10);
   v_vow_agrbilltype number;
   v_date    date;
   v_fac_datecalcul date;
   v_fac_datelim    date;
   v_ref_facture   varchar2(100);
   v_fac_comment   varchar2(100);
   p_pk_etape      varchar2(400);
   p_pk_exception  varchar2(400);
  BEGIN     
    for s1 in c1 loop
      begin
        p_pk_etape := 'Initialisation param facture_as400';
        v_bil_id  := null;
        v_deb_id  := null;
        v_mrd_id  := null;
        v_run_id  := null;
        v_annee   := null;
        v_tva     := null;
        v_periode := null;
        v_tot_ttc := null;
        v_tot_ht  := null;
        v_tot_tva := null;
        v_index   := null;
        v_cons_releve := null;
        v_prorata := null;
        v_vow_agrbilltype  := null;
        v_date          := null;
        v_fac_datecalcul:= null;
        v_fac_datelim   := null;
        v_ref_facture   := null;
        v_fac_comment   := null;
        p_pk_etape      := null;
        p_pk_exception  := null;
        
        p_pk_etape := 'Initialisation pour creation facture_as400';
        v_tva :=(nvl(s1.tvacons,0)+nvl(s1.tva_ff,0)+nvl(s1.tvaferm,0)+nvl(s1.tva_preav,0)+nvl(s1.tvadeplac,0)+nvl(s1.tvadepose_dem,0)+nvl(s1.tvadepose_def,0)+nvl(s1.tva_capit,0)+nvl(s1.tva_pfin,0))/1000;   
        v_fac_comment :=s1.district||s1.police||s1.tourne||s1.ordre;  
        v_annee   := to_number(s1.annee);
        v_periode := lpad(trim(s1.periode),2,'0');
        if trim(s1.fac_datecalcul) is not null then
          begin
            p_pk_etape := 'Recupere date calcul facture';
            v_fac_datecalcul  :=to_date(lpad(trim(s1.fac_datecalcul),8,'0'),'dd/mm/yyyy');
          exception when others then
            v_fac_datecalcul := null;
          end;
        end if;
        
        if v_fac_datecalcul is null then
          p_pk_etape := 'Calcul date depuis mois';
          if s1.type='TRIM' then
            select decode(s1.periode,1,3,2,6,3,9,12) into v_mois from dual;
          else
            v_mois := s1.periode;
          end if;
          if (v_mois=12) then
            v_fac_datecalcul :=to_date('21/'||'01'||'/'||to_char(s1.annee+1),'dd/mm/yyyy');
          else
            v_fac_datecalcul :=to_date('21/'||lpad(to_char(v_mois+1),2,'0')||'/'||to_char(s1.annee),'dd/mm/yyyy');
          end if;
        end if; 
        if trim(s1.fac_datelim) is not null then
          if s1.type='TRIM'then 
            begin
              p_pk_etape := 'Recupere date limt  facture trim';
              v_fac_datelim  :=to_date(lpad(trim(s1.fac_datelim),8,'0'),'ddmmyyyy');
            exception when others then
              v_fac_datelim    := null;
            end;
          else
            begin
              p_pk_etape := 'Recupere date limt  facture mens';
              v_fac_datelim  :=to_date(lpad(trim(s1.fac_datelim),8,'0'),'ddmmyyyy');
            exception when others then
              v_fac_datelim    := null;
            end;
          end if;
        end if;
        
        if v_fac_datelim is null then
          if s1.type='TRIM'then
             v_fac_datelim    := v_fac_datecalcul+37;
          else
             v_fac_datelim    := v_fac_datecalcul+21;
          end if;
        end if;
           
        
        if s1.type<>'TRIM'then 
          p_pk_etape := 'Initialisation pour creation releve_gc';
          v_index      :=to_number(s1.nindex);
          v_cons_releve:=to_number(s1.cons);
          v_prorata    :=to_number(s1.prorata);
          p_pk_etape := 'Creation releve';
          MigrationReleve(p_pk_etape,p_pk_exception,v_mrd_id,v_annee,v_periode,v_index,v_cons_releve,v_prorata,
                          null,null,null,null,null,null,v_fac_datecalcul,
                          null,null,null,null,'RELEVE_AS400_GC',v_g_vow_readreason_t,v_g_vow_readmeth,1,
                          s1.equ_id,s1.mtc_id,s1.spt_id,v_g_age_id);
          if p_pk_exception is not null then
            EXCEPTION_FACTURE(s1.district||s1.tourne||s1.ordre||s1.police||'-'||v_annee||'-'||v_periode,null,p_pk_exception,p_pk_etape);
          end if;
        end if;
        
        
        v_tot_ttc     := s1.nett/1000;
        v_tot_ht      := s1.nett/1000 - v_tva;
        v_tot_tva     := v_tva;
        v_ref_facture := s1.district||s1.tourne||s1.ordre||to_char(v_annee)||lpad(to_char(v_periode),2,'0')||'0';  
         p_pk_etape := 'Creation facture';
        MigrationFacture(p_pk_etape,p_pk_exception,v_bil_id,v_deb_id,v_annee,v_ref_facture,v_tot_ttc,v_tot_ht,v_tot_tva,v_tot_ttc,
                        v_fac_datecalcul,v_fac_datelim,v_fac_comment,nvl(s1.const,0),nvl(s1.montt,0),nvl(s1.taux,0),nvl(s1.tvacons,0),nvl(s1.fraisctr,0),nvl(s1.tva_ff,0),
                        nvl(s1.mon1,0),nvl(s1.volon1,0),nvl(s1.tauon1,0),nvl(s1.mon2,0),nvl(s1.volon2,0),nvl(s1.tauon2,0),nvl(s1.mon3,0),nvl(s1.volon3,0),nvl(s1.tauon3,0),nvl(s1.fixonas,0),
                        nvl(s1.preavis,0),nvl(s1.tva_preav,0),nvl(s1.fermeture,0),nvl(s1.tvaferm,0),nvl(s1.deplacement,0),nvl(s1.tvadeplac,0),nvl(s1.depose_dem,0),nvl(s1.tvadepose_dem,0),
                        nvl(s1.depose_def,0),nvl(s1.tvadepose_def,0),nvl(s1.extention,0),nvl(s1.tva_capit,0),nvl(s1.pfinancier,0),nvl(s1.tva_pfin,0),nvl(s1.capit,0),nvl(s1.inter,0),s1.caron*nvl(s1.arepor,0),
                        -1*abs(nvl(s1.narond,0)),0,0,0,0,null,null,s1.sag_id,s1.par_id,s1.adr_id,s1.org_id,v_g_vow_agrbilltype,v_g_vow_debtype,
                        v_g_vow_settlemode_a,v_g_vow_modefact,v_run_id,s1.aco_id); 
        
        if p_pk_exception is not null then
          rollback;
          EXCEPTION_FACTURE(s1.district||s1.tourne||s1.ordre||s1.police||'-'||v_annee||'-'||v_periode,null,p_pk_exception,p_pk_etape);
          continue;
        end if;	
        if v_bil_id is not null then
          update test.src_facture_as400_5
          set    bil_id= v_bil_id,
                 deb_id= v_deb_id,
                 mrd_id = v_mrd_id
          where  rowid = s1.row_id;
        end if;
        commit; 
      exception when others then
        rollback;
        p_pk_exception := SQLCODE || ' : ' ||  SUBSTR(SQLERRM, 1, 200);
        EXCEPTION_FACTURE(s1.district||s1.tourne||s1.ordre||s1.police||'-'||v_annee||'-'||v_periode,null,p_pk_exception,p_pk_etape);
        continue;
      end;
    end loop;    
  END;
----------------------------------------------------------------------------------------------
----------------------------------------------------------------------------------------------  
PROCEDURE MigrationFactureDist
  (
    p_param in number default 0
  )
  IS
    cursor c1   
    is 
      select lpad(trim(f.district),2,'0') district,lpad(trim(f.police),5,'0') police,lpad(trim(f.tournee),3,'0') tourne,
             lpad(trim(f.ordre),3,'0') ordre,lpad(trim(f.periode),2,'0') periode,decode(f.etat,'P','RF','O','FC','C','FHC','FC') etat,
             f.annee,f.net_a_payer,f.rowid,
             b.spt_id,b.mtc_id,b.equ_id,b.sag_id,b.date_creation,b.par_id,b.aco_id,b.adr_id
      from test.src_facture f 
        left join test.branchement b 
        on   lpad(trim(b.district),2,'0')= lpad(trim(f.district),2,'0')
        and  lpad(trim(b.tourne),3,'0')  = lpad(trim(f.tournee),3,'0')   
        and  lpad(trim(b.ordre),3,'0')   = lpad(trim(f.ordre),3,'0') 
        and  lpad(trim(b.police),5,'0') = lpad(trim(f.police),5,'0')
        and b.sag_id is not null 
      where  f.bil_id is null;
      
   v_org_id  number;
   v_run_id  number;------in
   v_bil_id  number;
   v_deb_id  number;
   v_tva     number;
   v_tot_ttc number(25,10);
   v_tot_ht  number(25,10);
   v_tot_tva number(25,10);
   v_vow_agrbilltype number;
   v_fac_datecalcul date;
   v_fac_datelim    date;
   v_ref_facture   varchar2(100);
   v_fac_comment   varchar2(100);
   p_pk_etape      varchar2(400);
   p_pk_exception  varchar2(400);
  BEGIN
    for s1 in c1 loop
    p_pk_etape := 'Initialisation param facture_Dist';
    v_bil_id  := null;
    v_deb_id  := null;
    v_org_id  := null;
    v_run_id  := null;
    v_tva     := null;
    v_tot_ttc := null;
    v_tot_ht  := null;
    v_tot_tva := null;
    v_vow_agrbilltype:= null;
    v_fac_datecalcul := null;
    v_fac_datelim    := null;
    v_ref_facture    := null;
    v_fac_comment    := null;
    p_pk_etape       := null;
    p_pk_exception   := null;
    p_pk_etape := 'Initialisation pour creation facture_as400';
    select max(org_id)
    into   v_org_id
    from   genorganization
    where  org_code = s1.district; 
    v_ref_facture := s1.district||s1.tourne||s1.ordre||s1.annee||s1.periode||'0';
    begin
      p_pk_etape := 'Recupere date depuis facture_dist';
      select last_day(to_date('01'||s1.periode||s1.annee,'dd/mm/yy'))
      into v_fac_datecalcul
      from dual;
    exception  when others then
      EXCEPTION_FACTURE(s1.district||s1.tourne||s1.ordre||'-'||s1.annee||'-'||s1.periode,null,'Impossible de recuperer la date de la facture_dist',p_pk_etape);
      continue;
      v_fac_datecalcul := '01/01/2016';-------!!!!!!
    end; 
    v_fac_datelim := (v_fac_datecalcul+45);
    v_tva      :=0;
    v_tot_ttc  :=(s1.net_a_payer+v_tva)/1000;
    v_tot_ht   :=(s1.net_a_payer-v_tva)/1000;
    v_tot_tva  :=v_tva;  
    v_fac_comment:=s1.district||s1.police||s1.tourne||s1.ordre;    
     if(s1.etat='RF')then
       v_vow_agrbilltype:=2566;
     elsif(s1.etat='FC')then 
       v_vow_agrbilltype:=2563;
     elsif(s1.etat='FHC')then
       v_vow_agrbilltype:=2567;
     else  
       v_vow_agrbilltype:=2563;
     end if;
     /*MigrationFacture(p_pk_etape,p_pk_exception,v_bil_id,v_deb_id,s1.annee,v_ref_facture,v_tot_ttc,v_tot_ht,v_tot_tva,v_tot_ttc,
                      v_fac_datecalcul,v_fac_datelim,v_fac_comment,0,0,0,0,0,0,
                      0,0,0,0,0,0,0,0,0,0,
                      0,0,0,0,0,0,0,0,
                      0,0,0,0,0,0,0,0,0,
                      0,0,0,0,0,0,null,null,s1.sag_id,s1.par_id,s1.adr_id,v_org_id,v_vow_agrbilltype,v_g_vow_debtype,
                      v_g_vow_settlemode_a,v_g_vow_modefact,v_run_id,s1.aco_id); */                      
     if p_pk_exception is not null then
        rollback;
        EXCEPTION_FACTURE(s1.district||s1.tourne||s1.ordre||s1.police,null,p_pk_exception,p_pk_etape);
        continue;
     end if;	
     if v_bil_id is not null then
       update test.facture 
       set    bil_id= v_bil_id,
              deb_id=v_deb_id
       where  rowid = s1.rowid;
     end if;
      commit;  
    end loop;   
  END;
----------------------------------------------------------------------------------------------
----------------------------------------------------------------------------------------------
PROCEDURE MigrationFactureVersion
  (
    p_param in number default 0
  )
  IS
    cursor c1
    is     
      select lpad(trim(f.district),2,'0') district,lpad(trim(f.police),5,'0') police,lpad(trim(f.tournee),3,'0') tourne,
             lpad(trim(f.ordre),3,'0') ordre,decode(f.etat,'P','RF','O','FC','C','FHC','FC') etat,
             lpad(trim(f.periode),2,'0') periode,f.annee,f.rowid,f.version,f.net_a_payer,
             g.bil_id,g.bil_code,g.bil_calcdt,g.bil_amountht,g.bil_amounttva,g.bil_amountttc,d.deb_comment,
             b.spt_id,b.mtc_id,b.equ_id,b.sag_id,b.date_creation,b.par_id,b.aco_id,b.adr_id
      from test.src_facture f
        left join test.branchement b 
        on   lpad(trim(b.district),2,'0')= lpad(trim(f.district),2,'0')
        and  lpad(trim(b.tourne),3,'0')  = lpad(trim(f.tournee),3,'0')   
        and  lpad(trim(b.ordre),3,'0')   = lpad(trim(f.ordre),3,'0') 
        and  lpad(trim(b.police),5,'0')  = lpad(trim(f.police),3,'0')
        and b.spt_id is not null
        and b.equ_id is not null 
        and b.mtc_id is not null
        and b.sag_id is not null 
        left join genbill g
        on g.bil_code = (lpad(trim(f.district),2,'0')||
                         lpad(trim(f.tournee),3,'0')||
                         lpad(trim(f.ordre),3,'0')||
                         to_char(f.annee)||
                         lpad(trim(f.periode),2,'0')||'0')
        left join gendebt d
        on  g.deb_id=d.deb_id
      where trim(f.etat) in('A','P')
      and f.bil_id is null;
   ----curseur genbilline pour insert les lignes de facture avoir   
   cursor c2(v_bil_id number)
   is
    select b.bil_id,b.bli_number,b.bli_name,b.bli_exercice,b.ite_id,b.pta_id,b.psl_rank,
           b.bli_volumebase,b.bli_volumefact,b.bli_puht,b.tva_id,b.bli_mht,b.bli_mttva,b.bli_mttc,b.vow_unit 
    from genbilline b 
    where b.bil_id=v_bil_id;
     
   v_org_id  number;
   v_run_id  number;------in
   v_bil_id  number;
   v_deb_id  number;
   v_tva     number;
   v_tothta  number;
   v_tottvaa number;
   v_tothte  number;
   v_tot_ttc number(25,10);
   v_tot_ht  number(25,10);
   v_tot_tva number(25,10);
   v_bli_volumedebase   number;
   v_bli_volumefact number;
   v_bli_puht       number;
   v_bli_mht        number;
   v_bli_mttva      number;
   v_bli_mttc       number;
   v_bil_bil_id     number;
   v_vow_agrbilltype number;
   v_vow_debtype    number;
   v_fac_datecalcul date;
   v_fac_datelim    date;
   v_ref_facture    varchar2(100);
   v_fac_comment    varchar2(100);
   p_pk_etape       varchar2(400);
   p_pk_exception   varchar2(400);
   
  BEGIN
    for s1 in c1 loop
    p_pk_etape := 'Initialisation param facture_version';
    v_org_id  := null;
    v_run_id  := null;
    v_bil_id  := null;
    v_deb_id  := null;
    v_tva     := null;
    v_tothta  := null;
    v_tottvaa := null;
    v_tothte  := null;
    v_tot_ttc := null;
    v_tot_ht  := null;
    v_tot_tva := null;
    v_vow_agrbilltype:= null;
    v_vow_debtype   := null;
    v_fac_datecalcul:= null;
    v_fac_datelim   := null;
    v_ref_facture   := null;
    v_fac_comment   := null;
    p_pk_etape      := null;
    p_pk_exception  := null;
    p_pk_etape := 'Initialisation donner pour creation facture_Dist';
    select max(org_id)
    into   v_org_id
    from   genorganization
    where  org_code = s1.district; 
    v_fac_datecalcul := s1.bil_calcdt +5;
    v_ref_facture    := s1.district||s1.tourne||s1.ordre||to_char(s1.annee)||s1.periode||trim(s1.version); 
    v_tothte         :=(s1.net_a_payer/1000);
    v_tva            :=0;
    v_tothta         :=0;
    v_tottvaa        :=0;
    if upper(trim(s1.etat))='A' then 
      p_pk_etape := 'Initialisation  donner  facture_Dist de type -A-';
      v_tot_ttc          := 0;
      v_tot_ht           := -(s1.bil_amountht);
      v_tot_tva          := -(s1.bil_amounttva);
      v_tot_ttc          := -(s1.bil_amountttc);
      v_vow_debtype      := 3135;--'Av'
      v_vow_agrbilltype  := 2565;--'FA'; 
      v_fac_comment      := s1.deb_comment;
      
      /*MigrationFacture(p_pk_etape,p_pk_exception,v_bil_id,v_deb_id,s1.annee,v_ref_facture,v_tot_ttc,v_tot_ht,v_tot_tva,v_tot_ttc,
                       v_fac_datecalcul,v_fac_datelim,v_fac_comment,0,0,0,0,0,0,
                       0,0,0,0,0,0,0,0,0,0,
                       0,0,0,0,0,0,0,0,
                       0,0,0,0,0,0,0,0,0,
                       0,0,0,0,0,0,null,null,s1.sag_id,s1.par_id,s1.adr_id,v_org_id,v_vow_agrbilltype,v_g_vow_debtype,
                       v_g_vow_settlemode_a,v_g_vow_modefact,v_run_id,s1.aco_id); */
      p_pk_etape := 'la mise a jour de BIL_CANCEL_ID pour la facture fc ';                 
      update genbill b set b.BIL_CANCEL_ID=v_bil_id where b.bil_id=s1.bil_id;
      
      for s2 in c2(s1.bil_id)loop
      v_bli_volumedebase:=null;
      v_bli_volumefact  :=null;
      v_bli_puht        :=null;
      v_bli_mht         :=null;
      v_bli_mttva       :=null;
      v_bli_mttc        :=null;
      begin
         p_pk_etape := 'Initialisation  donner ligne  facture_Dist de type -A-';
         v_bli_volumedebase:=-(s2.bli_volumebase);
         v_bli_volumefact  :=-(s2.bli_volumefact);
         v_bli_puht        :=-(s2.bli_puht);
         v_bli_mht         :=-(s2.bli_mht);
         v_bli_mttva       :=-(s2.bli_mttva);
         v_bli_mttc        :=-(s2.bli_mttc);
         
        insert into genbilline(bil_id,bli_number,bli_name,bli_exercice,ite_id,pta_id,psl_rank,
                               bli_volumebase,bli_volumefact,bli_puht,tva_id,bli_mht,bli_mttva,bli_mttc,bli_startdt,
                               bli_enddt,vow_unit,bli_updtby,meu_id)
                        values(v_bil_id,s2.bli_number,s2.bli_name,s2.bli_exercice,s2.ite_id,s2.pta_id,s2.psl_rank,
                               v_bli_volumedebase,v_bli_volumefact,v_bli_puht,s2.tva_id,v_bli_mht,v_bli_mttva,v_bli_mttc,v_fac_datecalcul,
                               v_fac_datecalcul,s2.vow_unit,v_g_age_id,v_g_meu_id);
      exception when others then 
        EXCEPTION_FACTURE(s1.district||s1.tourne||s1.ordre||'-'||s1.annee||'-'||s1.periode,null,'Impossible de recuperer la ligne de facture avoir',p_pk_etape);
        continue;
      end;                       
      end loop; 
    else
      p_pk_etape   := 'Initialisation  donner  facture_Dist de type different de -A-';
      v_tot_ht     := v_tothte+v_tothta;
      v_tot_tva    := v_tva+v_tottvaa;
      v_tot_ttc    := v_tothte +v_tva+v_tothta+v_tottvaa;
      if(s1.etat='RF')then
        v_vow_agrbilltype:=2566;
      elsif(s1.etat='FC')then
        v_vow_agrbilltype:=2563;
      elsif(s1.etat='FHC')then
        v_vow_agrbilltype:=2567;
      else  
        v_vow_agrbilltype:=2563;
      end if;
      v_vow_debtype      := 3134;--'FA'
      v_fac_comment      := s1.district||s1.police||s1.tourne||s1.ordre;
      v_bil_bil_id       := s1.bil_id;
      /*MigrationFacture(p_pk_etape,p_pk_exception,v_bil_id,v_deb_id,s1.annee,v_ref_facture,v_tot_ttc,v_tot_ht,v_tot_tva,v_tot_ttc,
                       v_fac_datecalcul,v_fac_datelim,v_fac_comment,0,0,0,0,0,0,
                       0,0,0,0,0,0,0,0,0,0,
                       0,0,0,0,0,0,0,0,
                       0,0,0,0,0,0,0,0,0,
                       0,0,0,0,0,0,null,v_bil_bil_id,s1.sag_id,s1.par_id,s1.adr_id,v_org_id,v_vow_agrbilltype,v_g_vow_debtype,
                       v_g_vow_settlemode_a,v_g_vow_modefact,v_run_id,s1.aco_id);*/
    end if;
    end loop;
  END;
----------------------------------------------------------------------------------------------
----------------------------------------------------------------------------------------------
PROCEDURE MigrationFactureImpayee
  (
    p_param in number default 0
  )
  IS
    cursor c1
    is
     select lpad(trim(f.district),2,'0') district,lpad(trim(f.police),5,'0') police,lpad(trim(f.tourne),3,'0') tourne,
             lpad(trim(f.ordre),3,'0') ordre ,f.annee,f.periode,f.net,f.rowid,(f.net-f.mtonas) reprise_s,f.mtonas reprise_o,
             b.spt_id,b.sag_id,b.par_id,b.aco_id,b.adr_id
     from  test.src_impayees f
      left join  test.branchement b 
      on   lpad(trim(b.district),2,'0')= lpad(trim(f.district),2,'0')
      and  lpad(trim(b.tourne),3,'0')  = lpad(trim(f.tourne),3,'0')   
      and  lpad(trim(b.ordre),3,'0')   = lpad(trim(f.ordre),3,'0') 
      and  lpad(trim(b.police),5,'0')  = lpad(trim(f.police),3,'0')
      and b.spt_id is not null
      and b.equ_id is not null 
      and b.mtc_id is not null
      and b.sag_id is not null
     where f.bil_id is null;
  
   v_org_id  number;
   v_bil_id  number;
   v_deb_id  number;
   v_tva     number;
   v_tothta  number;
   v_tottvaa number;
   v_tothte  number;
   v_tot_ttc number(25,10);
   v_tot_ht  number(25,10);
   v_tot_tva number(25,10);
   v_vow_agrbilltype number;
   v_fac_datecalcul date;
   v_fac_datelim    date;
   v_ref_facture    varchar2(100);
   v_fac_comment    varchar2(100);
   p_pk_etape       varchar2(400);
   p_pk_exception   varchar2(400);
  BEGIN
    for s1 in c1 loop
    p_pk_etape := 'Initialisation  de param  facture_impayee';
    v_org_id  := null;
    v_bil_id  := null;
    v_deb_id  := null;
    v_tva     := null;
    v_tothta  := null;
    v_tottvaa := null;
    v_tothte  := null;
    v_tot_ttc := null;
    v_tot_ht  := null;
    v_tot_tva := null;
    v_vow_agrbilltype:= null;
    v_fac_datecalcul:= null;
    v_fac_datelim   := null;
    v_ref_facture   := null;
    v_fac_comment   := null;
    p_pk_etape      := null;
    p_pk_exception  := null;
    p_pk_etape := 'Initialisation  de donner facture_impayee';
    select max(org_id)
    into   v_org_id
    from   genorganization
    where  org_code = s1.district; 
    v_ref_facture := s1.district||s1.tourne||s1.ordre||s1.annee||s1.periode||'0';
    begin
      select last_day(to_date('01'||s1.periode||s1.annee,'dd/mm/yy'))
      into v_fac_datecalcul
      from dual;
    exception  when others then
      EXCEPTION_FACTURE(s1.district||s1.tourne||s1.ordre||'-'||s1.annee||'-'||s1.periode,null,'Impossible de recuperer la date de la facture_dist',p_pk_etape);
      continue;
      v_fac_datecalcul := '01/01/2016';-------!!!!!!
    end; 
    v_fac_datelim := (v_fac_datecalcul+45);
    v_tothte   :=(s1.net/1000);
    v_tva      :=0;
    v_tothta   :=0;
    v_tottvaa  :=0;
    v_tot_ttc  :=v_tothte+v_tva+v_tothta+v_tottvaa;
    v_tot_ht   :=v_tothte+v_tothta;
    v_tot_tva  :=v_tva+v_tottvaa;  
    v_fac_comment:=s1.district||s1.police||s1.tourne||s1.ordre;    
    /*MigrationFacture(p_pk_etape,p_pk_exception,v_bil_id,v_deb_id,s1.annee,v_ref_facture,v_tot_ttc,v_tot_ht,v_tot_tva,0,
                    v_fac_datecalcul,v_fac_datelim,v_fac_comment,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,
                    0,0,s1.reprise_s,s1.reprise_o,0,0,null,null,s1.sag_id,s1.par_id,s1.adr_id,v_org_id,v_g_vow_agrbilltype,v_g_vow_debtype,
                    v_g_vow_settlemode_a,v_g_vow_modefact,null,s1.aco_id); */                   
                                            
    if p_pk_exception is not null then
      rollback;
      EXCEPTION_FACTURE(s1.district||s1.tourne||s1.ordre||s1.police,null,p_pk_exception,p_pk_etape);
      continue;
    end if;	
     if v_bil_id is not null then
       update test.facture 
       set    bil_id= v_bil_id,
              deb_id=v_deb_id
       where  rowid = s1.rowid;
     end if;
    commit;  
    end loop;
  END;
----------------------------------------------------------------------------------------
----------------------------------------------------------------------------------------
PROCEDURE MigrationMAJImpayees
  (
    p_param in number default 0    
  )
  IS
  cursor c1 
  is
    select deb.deb_id, ipy.mtpaye, ipy.net, deb.deb_amountinit, ipy.rowid row_id
    from   test.src_impayees ipy,
           gendebt deb,
           genbill bil,
           agrbill abi
    where  deb.deb_refe = ipy.district||ipy.tourne||ipy.ordre||
                          to_char(ipy.annee)||lpad(to_char(ipy.periode),2,'0')||'0'
    and    deb.deb_id = bil.deb_id
    and    bil.bil_id = abi.bil_id
    and    abi.vow_agrbilltype = 2563;
  BEGIN
    for s1 in c1 loop
      if s1.deb_amountinit = s1.net/1000 then
        update gendebt
        set    deb_amount_cash = nvl(s1.mtpaye,0)/1000
        where  deb_id = s1.deb_id;
        
        update test.src_impayees
        set    deb_id = s1.deb_id
        where  rowid = s1.row_id;
      end if;
      commit;
    end loop;
  END;
----------------------------------------------------------------------------------------
----------------------------------------------------------------------------------------  
PROCEDURE MigrationFactureB1
  (
    p_param in number default 0
  )
  IS   
  cursor c
  is 
    select lpad(trim(t.dist),2,'0') district,lpad(trim(t.pol),5,'0') police,
           lpad(trim(t.CATEGORIE_SIC),2,'0') categorie,t.adm,
           t.dexp fac_datecalcul,t.dat  fac_datelim,t.net,v.vow_id,
           t.rowid row_id,p.par_id,o.org_id,o.org_code,c.aco_id
    from  test.src_b1 t
      inner join genparty p
      --on 'DISTRICT'||decode(lpad(trim(t.dist),2,'0'),'02','X',lpad(trim(t.dist),2,'0'))=p.par_refe
      on 'DISTRICT'||lpad(trim(t.dist),2,'0')=p.par_refe
      inner join genaccount c
      on   c.par_id=p.par_id 
      inner join genvocword v
      on  'B1'||decode(lpad(trim(t.CATEGORIE_SIC),2,'0'),'01','01','02','02','03','10','04','04','06','06','08','08','01')=v.vow_code
      and c.vow_acotp=v.vow_id
      inner join genorganization o
      --on  o.org_code= decode(lpad(trim(t.dist),2,'0'),'02','ORGSONEDE',lpad(trim(t.dist),2,'0'));  
      on  o.org_code= lpad(trim(t.dist),2,'0'); 
   
 
  v_run_id number;
  v_bil_id number;
  v_deb_id number;
  v_tva     number;
  v_tot_ttc number(25,10);
  v_tot_ht  number(25,10);
  v_tot_tva number(25,10);
  v_vow_agrbilltype number;
  v_fac_datecalcul date;
  v_fac_datelim    date;
  v_ref_facture   varchar2(100);
  v_fac_comment   varchar2(100);
  p_pk_etape      varchar2(400);
  p_pk_exception  varchar2(400);
  BEGIN
    for s1 in c loop
       begin
        p_pk_etape := 'Initialisation param B1';
        v_bil_id  := null;
        v_deb_id  := null;
        v_run_id  := null;
        v_tva     := null;
        v_tot_ttc := null;
        v_tot_ht  := null;
        v_tot_tva := null;
        v_vow_agrbilltype  := null;
        v_fac_datecalcul:= null;
        v_fac_datelim   := null;
        v_ref_facture   := null;
        v_fac_comment   := null;
        p_pk_etape      := null;
        p_pk_exception  := null;
        
        p_pk_etape := 'Initialisation pour creation B1';
        v_tva :=0;
        
        v_fac_comment :='CATEGORIE:'||s1.CATEGORIE||'| POLICE:'||s1.POLICE||'| TOURNEE:'||''||
         '| ORDRE:'||''||'| CODE_CARTE:'||''||'| CODE_CAISSE:'||''||
         '| CODE_ADM:'||s1.ADM;
        p_pk_etape := 'Recupere date calcul facture';
        v_fac_datecalcul  :=to_date(lpad(trim(s1.fac_datecalcul),8,'0'),'dd/mm/yyyy');
        v_tot_ttc     := s1.net/1000;
        v_tot_ht      := s1.net/1000 -v_tva;
        v_tot_tva     := v_tva;
        v_vow_agrbilltype:=4086;--'FWOR'
          MigrationFacture(p_pk_etape,p_pk_exception,v_bil_id,v_deb_id,null,v_ref_facture,v_tot_ttc,v_tot_ht,v_tot_tva,0,
                           v_fac_datecalcul,v_fac_datecalcul,v_fac_comment,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,
                           0,0,0,0,s1.net,0,null,null,null,s1.par_id,0,s1.org_id,v_vow_agrbilltype,v_g_vow_debtype,
                           v_g_vow_settlemode_a,v_g_vow_modefact,null,s1.aco_id);  
        if p_pk_exception is not null then
          rollback;
          EXCEPTION_B1(s1.district||'-'||s1.police||'-'||s1.categorie||'-'||s1.net,null,p_pk_exception,p_pk_etape);
          continue;
        end if;	
        if v_bil_id is not null then
          update test.src_b1
          set    bil_id= v_bil_id,
                 deb_id= v_deb_id
          where  rowid = s1.row_id;
        end if;
        commit; 
      exception when others then
        rollback;
        p_pk_exception := SQLCODE || ' : ' ||  SUBSTR(SQLERRM, 1, 200);
        EXCEPTION_B1(s1.district||'-'||s1.police||'-'||s1.categorie||'-'||s1.net,null,p_pk_exception,p_pk_etape);
        continue;    
       end; 
    end loop;
  END;
---------------------------------------------------------------------------------------
---------------------------------------------------------------------------------------
PROCEDURE MigrationFactureB2
  (
    p_param in number default 0
  )
  IS   
  cursor c
  is 
  select lpad(trim(t.dist),2,'0') district ,lpad(trim(t.pol),5,'0') police,
       lpad(trim(t.CATEGORIE_SIC),2,'0') categorie,t.adm,t.ndevi,
       t.dexp fac_datecalcul,t.dat fac_datelim,t.net,v.vow_id,
       t.rowid row_id,p.par_id,o.org_id,o.org_code,c.aco_id
  from   test.src_b2 t
    inner join genparty p
    on 'DISTRICT'||decode(lpad(trim(t.dist),2,'0'),'35','32',lpad(trim(t.dist),2,'0'))=p.par_refe
    inner join genaccount c
    on   c.par_id=p.par_id 
    inner join genvocword v
    on  'B2'||decode(lpad(trim(t.CATEGORIE_SIC),2,'0'),'01','01','02','02','03','10','04','04','06','06','08','08')=v.vow_code
    and  c.vow_acotp=v.vow_id
    left join genorganization o
    on  o.org_code= decode(lpad(trim(t.dist),2,'0'),'35','32',lpad(trim(t.dist),2,'0'));
  v_run_id  number;
  v_bil_id  number;
  v_deb_id  number;
  v_tva     number;
  v_tot_ttc number(25,10);
  v_tot_ht  number(25,10);
  v_tot_tva number(25,10);
  v_vow_agrbilltype number;
  v_fac_datecalcul date;
  v_fac_datelim    date;
  v_ref_facture   varchar2(100);
  v_fac_comment   varchar2(100);
  p_pk_etape      varchar2(400);
  p_pk_exception  varchar2(400);
  BEGIN
    for s1 in c loop
       begin
        p_pk_etape := 'Initialisation param B2';
        v_bil_id  := null;
        v_deb_id  := null;
        v_run_id  := null;
        v_tva     := null;
        v_tot_ttc := null;
        v_tot_ht  := null;
        v_tot_tva := null;
        v_vow_agrbilltype  := null;
        v_fac_datecalcul:= null;
        v_fac_datelim   := null;
        v_ref_facture   := null;
        v_fac_comment   := null;
        p_pk_etape      := null;
        p_pk_exception  := null;
        
        p_pk_etape := 'Initialisation pour creation B2';
        
        v_fac_comment :='CATEGORIE:'||s1.CATEGORIE||'| POLICE:'||s1.district||s1.NDEVI||'| TOURNEE:'||''||
         '| ORDRE:'||''||'| CODE_CARTE:'||''||'| CODE_CAISSE:'||''||
         '| CODE_ADM:'||s1.ADM;
        p_pk_etape := 'Recupere date calcul facture';
        v_fac_datecalcul  :=to_date(lpad(trim(s1.fac_datecalcul),8,'0'),'dd/mm/yyyy');
        v_tva :=0;
        v_tot_ttc     := s1.net/1000;
        v_tot_ht      := s1.net/1000 -v_tva;
        v_tot_tva     := v_tva; 
        v_vow_agrbilltype:=4086;--'FWOR'                             
        MigrationFacture(p_pk_etape,p_pk_exception,v_bil_id,v_deb_id,null,v_ref_facture,v_tot_ttc,v_tot_ht,v_tot_tva,0,
                          v_fac_datecalcul,v_fac_datecalcul,v_fac_comment,0,0,0,0,0,0,
                          0,0,0,0,0,0,0,0,0,0,
                          0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,
                          0,0,0,0,s1.net,null,null,null,s1.par_id,0,s1.org_id,v_g_vow_agrbilltype,v_g_vow_debtype,
                          v_g_vow_settlemode_a,v_g_vow_modefact,null,s1.aco_id); 
                          
        if p_pk_exception is not null then
          rollback;
          EXCEPTION_FACTURE(s1.district||'-'||s1.police||'-'||s1.categorie||'-'||s1.net,null,p_pk_exception,p_pk_etape);
          continue;
        end if;	
        if v_bil_id is not null then
          update src_b2@test26
          set    bil_id= v_bil_id,
                 deb_id= v_deb_id
          where  rowid = s1.row_id;
        end if;
        commit; 
      exception when others then
        rollback;
        p_pk_exception := SQLCODE || ' : ' ||  SUBSTR(SQLERRM, 1, 200);
        EXCEPTION_FACTURE(s1.district||'-'||s1.police||'-'||s1.categorie||'-'||s1.net,null,p_pk_exception,p_pk_etape);
        continue;    
       end; 
    end loop;
  END;
----------------------------------------------------------------------------------------------
----------------------------------------------------------------------------------------------   
  PROCEDURE MigrationAttachFactureReleve
   (
     p_param in number default 0
   )
   IS
   cursor c1
   is 
   select sag.spt_id,deb.deb_date,deb.deb_refe,substr(deb.deb_refe,9,4) annee,substr(deb.deb_refe,13,2) periode,
          bil.bil_id,equ.equ_id,equ.mtc_id,fact.nindex,fact.cons,fact.prorata 
   from test.src_deb_facture fact
     inner join gendebt deb
           on deb.deb_id=fact.deb_id
     inner join agrserviceagr sag 
           on sag.sag_id=deb.sag_id
     inner join genbill bil
           on deb.deb_id =bil.bil_id
     inner join agrbill abi
           on bil.bil_id=abi.bil_id
           and abi.vow_agrbilltype = 2563
     inner join tecservicepoint spt
           on spt.spt_id = sag.spt_id
     inner join techequipment heq
           on spt.spt_id = heq.spt_id
     inner join tecmeter equ
           on heq.equ_id = equ.equ_id
     where  not exists (select 1
                        from   tecreaditebill r
                        where  r.bil_id = bil.bil_id);
   v_date_rel date;
   v_mois number;
   v_mrd_id number;
   v_index number;
   v_conso number;
   v_prorata    number;
   v_compteur_t number;
   p_pk_etape     varchar2(400);
   p_pk_exception varchar2(400);
   v_ite_sonede number := 320;
   v_ite_onas number := 350;
   v_mrd_comment_a varchar2(400);
  BEGIN
    for s1 in c1 loop   
      select max(mrd_id), max(mrd_comment_a)
      into   v_mrd_id,v_mrd_comment_a
      from   tecmtrread
      where  spt_id = s1.spt_id
      and    mrd_year = to_number(s1.annee)
      and    mrd_multicad = to_number(s1.periode);
      
      if v_mrd_id is null then
        MigrationReleve(p_pk_exception,p_pk_etape,v_mrd_id,to_number(s1.annee),to_number(s1.periode),
                         s1.nindex,s1.cons,s1.prorata,null,null,null,null,null,null,s1.deb_date-7,null,
                         null,null,null,'RELEVE_GENERER',v_g_vow_readreason_t,v_g_vow_readmeth_g,0,
                         s1.equ_id,s1.mtc_id,s1.spt_id,v_g_age_id);
      /*else
        if v_mrd_comment_a ='correction_histo_releve' then
          update tecmtrmeasure mme
          set    mme.mme_value = s1.nindex,
                 mme.mme_consum  = s1.cons,
                 mme.mme_deducemanual = nvl(to_number(trim(s1.cons)),0)-s1.prorata
          where  mrd_id = v_mrd_id
          and    mme_num = 1;
        end if;  */                 
      end if;
      insert into TECREADITEBILL(BIL_ID,ITE_ID,MRD_ID,RIB_UPDTBY)
               select s1.bil_id bil_id,v_ite_sonede ite_id,v_mrd_id mrd_id,v_g_age_id age_id from dual
               union
               select s1.bil_id bil_id,v_ite_onas ite_id,v_mrd_id mrd_id,v_g_age_id age_id from dual;
                          
      commit;                 
    end loop;  
  END;
 --------------------------------------------------------------- 
 PROCEDURE MigrationCorrectionHistoReleve
 (
   p_param in number default 0
 )
 IS   
   cursor c1
   is 
     select t.spt_id
     from  tecservicepoint t
     inner join agrserviceagr a
       on a.spt_id =t.spt_id
     inner join agrplanningagr p
       on p.sag_id=a.sag_id
     and vow_frqfact=2790;---TRIM

   cursor c2(v_spt_id number)
   is 
     select r.*
     from tecmtrread r
     where r.spt_id=v_spt_id
     order by r.mrd_year,r.mrd_multicad;
       
   cursor c3
   is 
     select t.spt_id 
     from  tecservicepoint t
     inner join agrserviceagr a
        on a.spt_id =t.spt_id
     inner join agrplanningagr p
        on p.sag_id=a.sag_id
     and vow_frqfact=2788;---MENS  
     
   v_min number;
   v_annee number;
   v_periode number;
   v_mrd_id number;
   v_index number;
   v_conso number;
   v_equ_id number;
   v_mtc_id number;
   v_prorata    number;
   v_date date;
   p_pk_etape     varchar2(400);
   p_pk_exception varchar2(400);
 BEGIN
   return;
   for s1 in c1 loop
     for s2 in c2 (s1.spt_id)loop
         v_min    :=null;
         v_annee  :=null;
         v_periode:=null;
         v_mrd_id :=null;
         v_date:=s2.mrd_dt;
         v_min:=to_number(s2.mrd_year||s2.mrd_multicad); 
         v_equ_id := s2.equ_id;
         v_mtc_id := s2.mtc_id;
         exit;
      end loop;
      begin       
         while v_min<=20174 loop
            if v_periode=5 then 
              v_annee:=v_annee+1;
              v_periode:=1;  
            else 
              v_periode:=v_periode+1;
            end if;
            p_pk_etape := 'Initialisation pour creation correction_releve';
            v_index   :=0;
            v_conso   :=0;
            v_prorata :=0;
            v_date:=v_date+90;
            p_pk_etape := 'Creation releve de correction';
            select max(mrd_id)
            into   v_mrd_id
            from   tecmtrread
            where  spt_id = s1.spt_id
            and    mrd_year = v_annee
            and    mrd_multicad = v_periode;
            if v_mrd_id is null then
              MigrationReleve(p_pk_etape,p_pk_exception,v_mrd_id,v_annee,v_periode,v_index,v_conso,v_prorata,
                      null,null,null,null,null,null,v_date,
                      null,null,null,null,'correction_histo_releve',v_g_vow_readreason_t,v_g_vow_readmeth_g,1,
                      v_equ_id,v_mtc_id,s1.spt_id,v_g_age_id);  
            end if;
            
            v_min := to_number(v_annee||v_periode);
            commit;                
         end loop; 
         update tecservicepoint spt
         set    spt.spt_comment_a = 'CORRECTION_TRAITE'
         where  spt_id = s1.spt_id;
         commit;
       exception when others then
         rollback;
         p_pk_exception := SQLCODE|| ' : '||SUBSTR(SQLERRM, 1, 200);
         EXCEPTION_RELEVE(s1.spt_id||'-'||v_annee||'-'||v_periode,null,p_pk_exception,p_pk_etape);
         continue;
       end;
   end loop; 
   ---------------MENS
   for s3 in c3 loop
     for s2 in c2 (s3.spt_id)loop
         v_min    :=null;
         v_annee  :=null;
         v_periode:=null;
         v_mrd_id :=null;
         v_date:=s2.mrd_dt;
         v_min:=to_number(s2.mrd_year||lpad(s2.mrd_multicad,2,'0')); 
         v_equ_id := s2.equ_id;
         v_mtc_id := s2.mtc_id;
         exit;
     end loop;
     begin
         while v_min<=201807 loop
            if v_periode=13 then
              v_annee:=v_annee+1;
              v_periode:=1;
            else
              v_periode:=v_periode+1;
            end if;
            p_pk_etape := 'Initialisation pour creation correction_releve';
            v_index   :=0;
            v_conso   :=0;
            v_prorata :=0;
            v_date:=v_date+30;
            p_pk_etape := 'Creation releve de correction';
            select max(mrd_id)
            into   v_mrd_id
            from   tecmtrread
            where  spt_id = s3.spt_id
            and    mrd_year = v_annee
            and    mrd_multicad = v_periode;
            if v_mrd_id is null then
              MigrationReleve(p_pk_etape,p_pk_exception,v_mrd_id,v_annee,v_periode,v_index,v_conso,v_prorata,
                              null,null,null,null,null,null,v_date,
                              null,null,null,null,'correction_releve',v_g_vow_readreason_t,v_g_vow_readmeth_g,1,
                              v_equ_id,v_mtc_id,s3.spt_id,v_g_age_id);  
            end if; 
             v_min := to_number(v_annee||lpad(v_periode,2,'0'));         
            commit;                
         end loop;
         update tecservicepoint spt
         set    spt.spt_comment_a = 'CORRECTION_TRAITE'
         where  spt_id = s3.spt_id;
         commit;
       exception when others then
           rollback;
           p_pk_exception := SQLCODE || ' : ' ||SUBSTR(SQLERRM, 1, 200);
           EXCEPTION_RELEVE(s3.spt_id||'-'||v_annee||'-'||v_periode,null,p_pk_exception,p_pk_etape);
           continue;
       end;             
   end loop;  
 END; 
 
 PROCEDURE MigrationPreviousReleve
   (
     p_param in number default 0
   )
   IS
      cursor c1
      is
        select m.spt_id,m.mrd_id, decode(m.mrd_multicad-1,0,4,m.mrd_multicad-1) periode_prv,
               decode(m.mrd_multicad-1,0,m.mrd_year-1,m.mrd_year) annee_prv, m.rowid row_id
        from  tecmtrread m
        inner join tecservicepoint t
         on m.spt_id = t.spt_id
        inner join agrserviceagr a
         on a.spt_id =t.spt_id
        inner join agrplanningagr p
         on p.sag_id=a.sag_id
        and vow_frqfact=2790
        where m.mrd_previous_id is null; --TRIM
        
      cursor c2
      is
        select m.spt_id,m.mrd_id, decode(m.mrd_multicad-1,0,4,m.mrd_multicad-1) periode_prv,
               decode(m.mrd_multicad-1,0,m.mrd_year-1,m.mrd_year) annee_prv, m.rowid row_id
        from  tecmtrread m
        inner join tecservicepoint t
         on m.spt_id = t.spt_id
        inner join agrserviceagr a
         on a.spt_id =t.spt_id
        inner join agrplanningagr p
         on p.sag_id=a.sag_id
        and vow_frqfact=2788
        where m.mrd_previous_id is null; --MENS
              
   BEGIN
     for s1 in c1 loop
       update tecmtrread 
       set    mrd_previous_id = (select max(mrd.mrd_id)
                                 from   tecmtrread mrd
                                 where  mrd.spt_id = s1.spt_id
                                 and    mrd.mrd_year = s1.annee_prv
                                 and    mrd.mrd_multicad = s1.periode_prv
                                 )
       where rowid = s1.row_id;
       commit;
     end loop;
     
     for s2 in c2 loop
       update tecmtrread 
       set    mrd_previous_id = (select max(mrd.mrd_id)
                                 from   tecmtrread mrd
                                 where  mrd.spt_id = s2.spt_id
                                 and    mrd.mrd_year = s2.annee_prv
                                 and    mrd.mrd_multicad = s2.periode_prv
                                 )
       where rowid = s2.row_id;
       commit;
     end loop;
   END;

PROCEDURE MigrationFactureAnnulation
  (
    p_param in number default 0
  )
  IS
    cursor c1
    is
      select bil.bil_id,deb.deb_id, deb.deb_refe, deb.aco_id, deb.par_id, deb.org_id, deb.adr_id, deb.sag_id, deb.vow_settlemode,
             bil.bil_amountht,bil.bil_amounttva, bil.bil_amountttc,
             decode(nvl(volume_sonede1,0),0,f.volume_sonede2,nvl(volume_sonede1,0)) volume_sonede,
             f.montant_consommation,decode(nvl(volume_sonede1,0),0,f.prix_sonede2,nvl(prix_sonede2,0)) prix_sonede,
             f.tva_consommation,f.redevance_fix_sonede,f.tva_frais_fix_sonede,
             f.volume_onas1*f.prix_onas1 montantonas1,f.volume_onas1,f.prix_onas1,f.volume_onas2*f.prix_onas2 montantonas2,f.volume_onas2,f.prix_onas2,
             f.frais_fix_onas,f.frais_preavis,f.tva_preavis,f.frais_coupure,f.tva_frais_coupure,f.frais_fermeture,f.tva_frais_fermeture,
             f.frais_resiliation,f.tva_frais_resiliation,f.credit_sonede,f.tva_capital_credit,f.produit_financ,f.tva_produit_financ,
             f.credit_onas,decode(f.code_report,1,f.ancien_report,-1*f.ancien_report) ancien_report,f.nouveau_report,f.code_report,f.net_a_payer,
             f.mois_operation, f.annee_operation,f.district,f.tournee,f.ordre,f.police,f.annee,f.periode,
             f.rowid row_id
      from   gendebt deb,
             genbill bil,
             test.src_fac_annule f
      where  deb.deb_refe = LPAD(TO_CHAR(f.DISTRICT),2,'0')||LPAD(TO_CHAR(f.TOURNEE),3,'0')
                          ||LPAD(TO_CHAR(f.ORDRE),3,'0')||TO_CHAR(f.ANNEE)||LPAD(TO_CHAR(f.PERIODE),2,'0')||'0'
      and    deb.deb_id = bil.deb_id
      and    f.deb_id is null
      and    bil.bil_id in 
             (
              select bil_id from 
               (
                select bil.bil_id, count(*)
                from   gendebt deb,
                       genbill bil,
                       test.src_fac_annule fac
                where  deb.deb_refe = LPAD(TO_CHAR(DISTRICT),2,'0')||LPAD(TO_CHAR(TOURNEE),3,'0')
                                    ||LPAD(TO_CHAR(ORDRE),3,'0')||TO_CHAR(ANNEE)||LPAD(TO_CHAR(PERIODE),2,'0')||'0'
                and    deb.deb_id = bil.deb_id
                group by bil.bil_id
                having count(*)=1
               )
              );
      
   p_pk_etape     varchar2(400);
   p_pk_exception varchar2(400);
   v_bil_cancel_id number;
   v_deb_cancel_id number;
   v_date date;
   v_bil_id number;
   v_deb_id number;
   v_ref_facture varchar2(400);
   v_tot_tva number;
   v_tot_ht number;
   v_tot_ttc number;
   v_fac_comment varchar2(400);
  BEGIN
    for s1 in c1 loop
      begin
      p_pk_etape :='Calcul date operation';
      v_date := to_date('15/'||lpad(to_char(s1.mois_operation),2,'0')||'/'||to_char(s1.annee_operation));
      p_pk_etape :='Creation de la deb facure avoir';
      select seq_gendebt.nextval into v_deb_cancel_id from dual;
      insert into gendebt(deb_id,deb_refe,org_id,par_id,adr_id,deb_date,deb_duedt,deb_printdt,
                    deb_amountinit,vow_settlemode,aco_id,
                    deb_updtby,deb_comment,deb_amount_cash,sag_id,vow_debtype)
            values (v_deb_cancel_id,'999'||v_deb_cancel_id,s1.org_id,s1.par_id,s1.adr_id,v_date,v_date,v_date,
                    0,s1.vow_settlemode,s1.aco_id,
                    v_g_age_id,'AVOIR_MIGREE',s1.bil_amountttc,s1.sag_id,v_g_vow_debtype_a);
      p_pk_etape :='Creation de la abi facure avoir';              
      select seq_agrbill.nextval into v_bil_cancel_id from dual;
      insert into agrbill(bil_id,sag_id,vow_agrbilltype,abi_updtby)
                   values(v_bil_cancel_id,s1.sag_id,v_g_vow_agrbilltype_a,v_g_age_id);
                   
      p_pk_etape :='Creation de la bil facure avoir';              
      insert into genbill(bil_id,bil_code,bil_calcdt,bil_amountht,bil_amounttva,bil_amountttc,bil_status,
                        deb_id,par_id,bil_debtdt,run_id,bil_updtby)
                 values(v_bil_cancel_id,'BIL_'||v_bil_cancel_id,v_date,-1*s1.bil_amountht,-1*s1.bil_amounttva,-1*s1.bil_amountttc,1,
                        v_deb_cancel_id,s1.par_id,v_date,null,v_g_age_id); 
                        
      p_pk_etape :='Creation des lignes bil facure avoir';  
      insert into genbilline(bil_id,bli_number,bli_name,bli_exercice,ite_id,pta_id,psl_rank,
                         bli_volumebase,bli_volumefact,bli_puht,tva_id,bli_mht,bli_mttva,
                         bli_mttc,bli_startdt,bli_enddt,vow_unit,bli_updtby,meu_id)
              select v_bil_cancel_id,bli_number,bli_name,bli_exercice,ite_id,pta_id,psl_rank,
                         bli_volumebase,-1*bli_volumefact,bli_puht,tva_id,-1*bli_mht,-1*bli_mttva,
                         -1*bli_mttc,bli_startdt,bli_enddt,vow_unit,bli_updtby,meu_id
              from   genbilline
              where  bil_id = s1.bil_id;
      
      p_pk_etape :='MAJ facture original';
      update genbill
      set    bil_cancel_id = v_bil_cancel_id
      where  bil_id = s1.bil_id;
      
      p_pk_etape :='MAJ ligne facture original';
      update genbilline l
      set    l.bli_cancel = 1
      where  l.bil_id = s1.bil_id;
      
      p_pk_etape :='Mettre facture impayees';
      update gendebt d
      set    d.deb_amount_cash = 0
      where  d.deb_id = s1.deb_id;
      
      
      p_pk_etape :='Creation facture redressement';
      v_tot_tva := (nvl(s1.tva_consommation,0)+nvl(s1.tva_frais_fix_sonede,0)+nvl(s1.tva_frais_coupure,0)+nvl(s1.tva_preavis,0)+nvl(0,s1.tva_frais_fermeture)+nvl(0,0)+nvl(s1.tva_frais_resiliation,0)+nvl(s1.tva_capital_credit,0)+nvl(s1.tva_produit_financ,0))/1000;   
      v_tot_ttc := s1.net_a_payer/1000;
      v_tot_ht := v_tot_ttc - v_tot_tva;
      v_fac_comment :=LPAD(TO_CHAR(s1.DISTRICT),2,'0')||LPAD(TO_CHAR(s1.POLICE),5,'0')||LPAD(TO_CHAR(s1.TOURNEE),3,'0')||LPAD(TO_CHAR(s1.ORDRE),3,'0');  
      v_ref_facture :=  LPAD(TO_CHAR(s1.DISTRICT),2,'0')||LPAD(TO_CHAR(s1.TOURNEE),3,'0')
                          ||LPAD(TO_CHAR(s1.ORDRE),3,'0')||TO_CHAR(s1.ANNEE)||LPAD(TO_CHAR(s1.PERIODE),2,'0')||'1';
      MigrationFacture(p_pk_etape,p_pk_exception,v_bil_id,v_deb_id,s1.annee,v_ref_facture,v_tot_ttc,v_tot_ht,v_tot_tva,v_tot_ttc,
                       v_date,v_date,v_fac_comment,s1.volume_sonede,s1.montant_consommation,s1.prix_sonede,s1.tva_consommation,
                       s1.redevance_fix_sonede,s1.tva_frais_fix_sonede,s1.montantonas1,s1.volume_onas1,s1.prix_onas1,
                       s1.montantonas2,s1.volume_onas2,s1.prix_onas2,0,0,0,s1.frais_fix_onas,s1.frais_preavis,s1.tva_preavis,
                       s1.frais_coupure,s1.tva_frais_coupure,s1.frais_fermeture,s1.tva_frais_fermeture,0,0,s1.frais_resiliation,
                       s1.tva_frais_resiliation,s1.credit_sonede,s1.tva_capital_credit,s1.produit_financ,s1.tva_produit_financ,
                       s1.credit_onas,0,s1.ancien_report,-1*s1.nouveau_report,0,0,0,0,s1.bil_id,null,s1.sag_id,s1.par_id,s1.adr_id,
                       s1.org_id,v_g_vow_agrbilltype_rf,v_g_vow_debtype,s1.vow_settlemode,v_g_vow_modefact,null,s1.aco_id);
      
      if p_pk_exception is not null then
        rollback;
        EXCEPTION_FACTURE(v_ref_facture,null,p_pk_exception,p_pk_etape);
        continue;
      end if;	
      
      update test.src_fac_annule
      set    deb_id = s1.deb_id
      where  rowid = s1.row_id;
      commit;
      exception when others then
        rollback;
        p_pk_exception := SQLCODE || ' : ' ||  SUBSTR(SQLERRM, 1, 200);
        EXCEPTION_FACTURE(s1.deb_refe,null,p_pk_exception,p_pk_etape);
        continue;
      end;
    end loop;
    
  END;
  
PROCEDURE MigrationLienTrain
  (
    p_param in number default 0
  )
  IS
     cursor c1 
     is
      select bil.bil_id, bil.bil_code, run.run_id, run.run_name, bil.rowid row_id
      from   agrbill abi,
             genbill bil,
             gendebt deb,
             genrun run
      where  abi.vow_agrbilltype = 2563
      and    abi.bil_id = bil.bil_id
      and    bil.deb_id = deb.deb_id
      and    bil.run_id is null
      and    deb.org_id = run.org_id
      and    run.run_name = substr(bil_code,9,4)||'-'||substr(bil_code,13,2);
   
  BEGIN
    for s1 in c1 loop
      update genbill
      set    run_id = s1.run_id 
      where  rowid = s1.row_id;
      commit;
    end loop;
  END;
 ----------------------------------------------------------------------------------------------------------------
 ----------------------------------------------------------------------------------------------------------------
 PROCEDURE MigrationFactureDistrict
  (
    p_param in number default 0
  )
  IS
    cursor c1
    is
      select bil.bil_id,deb.deb_id, deb.deb_refe, deb.aco_id, deb.par_id, deb.org_id, deb.adr_id, deb.sag_id, deb.vow_settlemode,
             bil.bil_amountht,bil.bil_amounttva, bil.bil_amountttc,
             decode(nvl(volume_sonede1,0),0,f.volume_sonede2,nvl(volume_sonede1,0)) volume_sonede,
             f.montant_consommation,decode(nvl(volume_sonede1,0),0,f.prix_sonede2,nvl(prix_sonede2,0)) prix_sonede,
             f.tva_consommation,f.redevance_fix_sonede,f.tva_frais_fix_sonede,
             f.volume_onas1*f.prix_onas1 montantonas1,f.volume_onas1,f.prix_onas1,f.volume_onas2*f.prix_onas2 montantonas2,f.volume_onas2,f.prix_onas2,
             f.frais_fix_onas,f.frais_preavis,f.tva_preavis,f.frais_coupure,f.tva_frais_coupure,f.frais_fermeture,f.tva_frais_fermeture,
             f.frais_resiliation,f.tva_frais_resiliation,f.credit_sonede,f.tva_capital_credit,f.produit_financ,f.tva_produit_financ,
             f.credit_onas,decode(f.code_report,1,f.ancien_report,-1*f.ancien_report) ancien_report,f.nouveau_report,f.code_report,f.net_a_payer,
             f.mois_operation, f.annee_operation,f.district,f.tournee,f.ordre,f.police,f.annee,f.periode,
             f.rowid row_id
      from   gendebt deb,
             genbill bil,
             test.src_fac_annule f
      where  deb.deb_refe = LPAD(TO_CHAR(f.DISTRICT),2,'0')||LPAD(TO_CHAR(f.TOURNEE),3,'0')
                          ||LPAD(TO_CHAR(f.ORDRE),3,'0')||TO_CHAR(f.ANNEE)||LPAD(TO_CHAR(f.PERIODE),2,'0')||'0'
      and    deb.deb_id = bil.deb_id
      and    f.deb_id is null;
      
      
   p_pk_etape     varchar2(400);
   p_pk_exception varchar2(400);
   v_bil_cancel_id number;
   v_deb_cancel_id number;
   v_date date;
   v_bil_id number;
   v_deb_id number;
   v_ref_facture varchar2(400);
   v_tot_tva number;
   v_tot_ht number;
   v_tot_ttc number;
   v_fac_comment varchar2(400);
  BEGIN
    for s1 in c1 loop
      begin
      p_pk_etape :='Calcul date operation';
      v_date := to_date('15/'||lpad(to_char(s1.mois_operation),2,'0')||'/'||to_char(s1.annee_operation));

      p_pk_etape :='Creation facture';
      v_tot_tva := (nvl(s1.tva_consommation,0)+nvl(s1.tva_frais_fix_sonede,0)+nvl(s1.tva_frais_coupure,0)+nvl(s1.tva_preavis,0)+nvl(0,s1.tva_frais_fermeture)+nvl(0,0)+nvl(s1.tva_frais_resiliation,0)+nvl(s1.tva_capital_credit,0)+nvl(s1.tva_produit_financ,0))/1000;   
      v_tot_ttc := s1.net_a_payer/1000;
      v_tot_ht := v_tot_ttc - v_tot_tva;
      v_fac_comment :=LPAD(TO_CHAR(s1.DISTRICT),2,'0')||LPAD(TO_CHAR(s1.POLICE),5,'0')||LPAD(TO_CHAR(s1.TOURNEE),3,'0')||LPAD(TO_CHAR(s1.ORDRE),3,'0');  
      v_ref_facture :=  LPAD(TO_CHAR(s1.DISTRICT),2,'0')||LPAD(TO_CHAR(s1.TOURNEE),3,'0')
                          ||LPAD(TO_CHAR(s1.ORDRE),3,'0')||TO_CHAR(s1.ANNEE)||LPAD(TO_CHAR(s1.PERIODE),2,'0')||'1';
      MigrationFacture(p_pk_etape,p_pk_exception,v_bil_id,v_deb_id,s1.annee,v_ref_facture,v_tot_ttc,v_tot_ht,v_tot_tva,v_tot_ttc,
                       v_date,v_date,v_fac_comment,s1.volume_sonede,s1.montant_consommation,s1.prix_sonede,s1.tva_consommation,
                       s1.redevance_fix_sonede,s1.tva_frais_fix_sonede,s1.montantonas1,s1.volume_onas1,s1.prix_onas1,
                       s1.montantonas2,s1.volume_onas2,s1.prix_onas2,0,0,0,s1.frais_fix_onas,s1.frais_preavis,s1.tva_preavis,
                       s1.frais_coupure,s1.tva_frais_coupure,s1.frais_fermeture,s1.tva_frais_fermeture,0,0,s1.frais_resiliation,
                       s1.tva_frais_resiliation,s1.credit_sonede,s1.tva_capital_credit,s1.produit_financ,s1.tva_produit_financ,
                       s1.credit_onas,0,s1.ancien_report,-1*s1.nouveau_report,0,0,0,0,s1.bil_id,null,s1.sag_id,s1.par_id,s1.adr_id,
                       s1.org_id,v_g_vow_agrbilltype_rf,v_g_vow_debtype,s1.vow_settlemode,v_g_vow_modefact,null,s1.aco_id);
      
      if p_pk_exception is not null then
        rollback;
        EXCEPTION_FACTURE(v_ref_facture,null,p_pk_exception,p_pk_etape);
        continue;
      end if;	
      
      update test.src_fac_annule
      set    deb_id = s1.deb_id
      where  rowid = s1.row_id;
      commit;
      exception when others then
        rollback;
        p_pk_exception := SQLCODE || ' : ' ||  SUBSTR(SQLERRM, 1, 200);
        EXCEPTION_FACTURE(s1.deb_refe,null,p_pk_exception,p_pk_etape);
        continue;
      end;
    end loop;
  END;
  ----------------------------------------------------------------------
  ---------------------------------------------------------------------------
  PROCEDURE MigrationFactureImpayees
  (
    p_param in number default 0
  )
  IS
    cursor c1
    is
      select ipy.district ,ipy.police ,ipy.tourne, ipy.gros_consommateur,ipy.ordre,ipy.annee,ipy.periode,
             ipy.net,ipy.rowid row_id,(ipy.net-ipy.mtonas) reprise_s,ipy.mtonas reprise_o,
             b.sag_id,b.par_id,b.aco_id,b.adr_id,b.org_id
      from   test.src_impayees ipy
      inner join test.branchement b
        on   lpad(trim(b.district),2,'0')= lpad(trim(ipy.district),2,'0')
        and  lpad(trim(b.tourne),3,'0')  = lpad(trim(ipy.tourne),3,'0')   
        and  lpad(trim(b.ordre),3,'0')   = lpad(trim(ipy.ordre),3,'0') 
        and  lpad(trim(b.police),5,'0')  = lpad(trim(ipy.police),5,'0')
        and b.spt_id is not null
      where  ipy.deb_id_41 is null
      and    ipy.annee<2015;
      
      
   p_pk_etape     varchar2(400);
   p_pk_exception varchar2(400);
   v_bil_cancel_id number;
   v_deb_cancel_id number;
   v_date date;
   v_bil_id number;
   v_deb_id number;
   v_ref_facture varchar2(400);
   v_tot_tva number;
   v_tot_ht number;
   v_tot_ttc number;
   v_fac_comment varchar2(400);
   v_mois number;
  BEGIN
    for s1 in c1 loop
      begin
        v_bil_id := null;
        v_deb_id := null;
      p_pk_etape :='Calcul date operation';
      if trim(s1.gros_consommateur)='N' then
        select decode(s1.periode,1,3,2,6,3,9,12) into v_mois from dual;
      else
        v_mois := s1.periode;
      end if;
      if (v_mois=12) then
        v_date :=to_date('21/'||'01'||'/'||to_char(s1.annee+1),'dd/mm/yyyy');
      else
        v_date :=to_date('21/'||lpad(to_char(v_mois+1),2,'0')||'/'||to_char(s1.annee),'dd/mm/yyyy');
      end if;
      

      p_pk_etape :='Creation facture';
      v_tot_tva := 0;
      v_tot_ttc := s1.net/1000;
      v_tot_ht := v_tot_ttc - v_tot_tva;
      v_fac_comment :=LPAD(trim(s1.DISTRICT),2,'0')||LPAD(trim(s1.POLICE),5,'0')||LPAD(trim(s1.TOURNE),3,'0')||LPAD(trim(s1.ORDRE),3,'0');  
      v_ref_facture :=  LPAD(trim(s1.DISTRICT),2,'0')||LPAD(trim(s1.TOURNE),3,'0')
                          ||LPAD(trim(s1.ORDRE),3,'0')||TO_CHAR(s1.ANNEE)||LPAD(TO_CHAR(s1.PERIODE),2,'0')||'0';
      MigrationFacture(p_pk_etape,p_pk_exception,v_bil_id,v_deb_id,s1.annee,v_ref_facture,v_tot_ttc,v_tot_ht,v_tot_tva,v_tot_ttc,
                       v_date,v_date,v_fac_comment,0,0,0,0,
                       0,0,0,0,0,
                       0,0,0,0,0,0,0,0,0,
                       0,0,0,0,0,0,0,
                       0,0,0,0,0,
                       0,0,0,0,s1.reprise_s,s1.reprise_o,0,0,null,null,s1.sag_id,s1.par_id,s1.adr_id,
                       s1.org_id,v_g_vow_agrbilltype,v_g_vow_debtype,v_g_vow_settlemode_a,v_g_vow_modefact,null,s1.aco_id);
      
      if p_pk_exception is not null then
        rollback;
        EXCEPTION_FACTURE(v_ref_facture,null,p_pk_exception,p_pk_etape);
        continue;
      end if;	
      
      update test.src_impayees ipy
      set    deb_id = v_deb_id
      where  rowid = s1.row_id;
      commit;
      exception when others then
        rollback;
        p_pk_exception := SQLCODE || ' : ' ||  SUBSTR(SQLERRM, 1, 200);
        EXCEPTION_FACTURE(v_ref_facture,null,p_pk_exception,p_pk_etape);
        continue;
      end;
    end loop;
  END;
 ----------------------------------------------------------------------------------------------------------------
 ---------------------------------------------------------------------------------------------------------
  
end PK_MIGRATION;
/
