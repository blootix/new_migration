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
/*  
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
  
    
PROCEDURE MigrationFactureImpayee
  (
    p_param in number default 0
  );
  */
  
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


    p_pk_etape := 'Selection de la cartégorie client';
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
    insert into tecservicepoint(spt_id,spt_refe,pre_id,rou_id,fld_id,adr_id,spt_updtby,ctt_id)
                           values(p_spt_id,v_code_br,p_pre_id,p_rou_id,v_g_fld_id,p_adr_id,v_g_age_id,v_g_ctt_id);
    
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

    p_pk_etape := 'Création de liaison PDL /BRA';
    select seq_tecconnection.nextval into v_cnn_id from dual;
    insert into tecconnection(cnn_id, cnn_refe, adr_id, fld_id, cnn_startdt, cnn_updtby)
                       values(v_cnn_id, v_code_br, p_adr_id, v_g_fld_id, p_date_creation,v_g_age_id);
    select seq_techconspt.nextval into v_hcs_id from dual;
    insert into techconspt(hcs_id, spt_id, con_id, hcs_startdt,hcs_updtby)
                    values(v_hcs_id, p_spt_id, v_cnn_id, p_date_creation, v_g_age_id);
 
    p_pk_etape := 'Création du PDL EAU';
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
    insert into genaccount(aco_id,par_id,imp_id,rec_id,vow_acotp,aco_status,aco_updtby)
                    values(p_aco_id,p_par_id,v_g_imp_id,v_rec_id,v_g_vow_acotp_id,1,v_g_age_id);
    
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
    p_vow_readreason  in number,
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
   p_pk_etape:='Récupération Anomalie niche';
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
   p_pk_etape := 'Récupération Anomalie fuite';
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
    
   p_pk_etape := 'Récupération Anomalie compteur';
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
                 mrd_etatfact,age_id,mrd_usecr,mrd_year,mrd_multicad) 
            values(p_mrd_id,p_equ_id,p_mtc_id,p_date_releve,p_spt_id,v_vow_comm1,v_vow_comm2,v_vow_comm3,
                 v_g_vow_readorig,v_g_vow_readmeth,p_vow_readreason,p_message_temporaire,v_g_mrd_agrtype,v_g_mrd_techtype,
                 v_g_mrd_etatfact,p_age_id,p_mrd_usecr,p_annee,p_periode);
    
    p_pk_etape := 'Ajouter index eau'; 
    v_mme_num := 1;
    select seq_tecmtrmeasure.nextval into v_mme_id from dual;
    insert into tecmtrmeasure(mme_id,mrd_id,meu_id,mme_num,mme_value,mme_consum,mme_avgconsum,mme_deducemanual)
                        values (v_mme_id,p_mrd_id,v_g_meu_eau,v_mme_num,to_number(p_index),nvl(to_number(trim(p_consommation)),0),0,v_mme_deducemanual);    

    p_pk_etape := 'Ajouter index tentatif 1 et 2'; 
    if (to_number(replace(p_tentatif2,'.',0))>0) then
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
    if (to_number(replace(p_tentatif3,'.',0))>0) then
      v_mme_num := v_mme_num + 1;
      select seq_tecmtrmeasure.nextval into v_mme_id from dual;
      insert into tecmtrmeasure(mme_id,mrd_id,meu_id,mme_num,mme_value,mme_consum,mme_avgconsum,mme_deducemanual)
                values (v_mme_id,p_mrd_id,v_g_meu_ten2,v_mme_num,to_number(replace(p_tentatif3,'.',null)),to_number(replace(p_tentatif3,'.',null)),0,0);
    end if;     
        
    p_pk_etape := 'Ajouter index tentatif 4'; 
    if (to_number(replace(p_tentatif4,'.',0))>0) then
      v_mme_num := v_mme_num + 1;
      select seq_tecmtrmeasure.nextval into v_mme_id from dual;
      insert into tecmtrmeasure(mme_id,mrd_id,meu_id,mme_num,mme_value,mme_consum,mme_avgconsum,mme_deducemanual)
                 values(v_mme_id,p_mrd_id,v_g_meu_ten3,v_mme_num,to_number(replace(p_tentatif4,'.',null)),to_number(replace(p_tentatif4,'.',null)),0,0);
    end if;     
           
    p_pk_etape := 'Ajouter index tentatif 5'; 
    if (to_number(replace(p_tentatif5,'.',0))>0) then
      v_mme_num := v_mme_num + 1;
      select seq_tecmtrmeasure.nextval into v_mme_id from dual;
      insert into tecmtrmeasure(mme_id,mrd_id,meu_id,mme_num,mme_value,mme_consum,mme_avgconsum,mme_deducemanual)
                values (v_mme_id,p_mrd_id,v_g_meu_ten4,v_mme_num,to_number(replace(p_tentatif5,'.',null)),to_number(replace(p_tentatif5,'.',null)),0,0);
    end if;           
          
    p_pk_etape := 'Ajouter index avis forte conso';
    if (to_number(trim(p_avisforte))>0) then
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
    p_periode      in number,
    p_annee        in number,
    p_ref_facture  in number,
    p_tot_ttc      in number,
    p_tot_ht       in number,
    p_tot_tva      in number,
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
    p_caron        in number,
    p_reprise_S    in number,
    p_reprise_O    in number,
    p_spt_id       in number,
    p_imp_id       in number,
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
    v_ite_id           number;
    v_tva_id           number;
    v_pta_id           number;
    v_bli_volumebase   number(25,10);
    v_bli_volumefact   number(25,10);
    v_bli_puht         number(25,10);
    v_bli_mht          number(25,10);
    v_bli_mttva        number(25,10);
    v_bli_mttc         number(25,10);
    v_vow_unit         number;
    v_psl_rank         number; 
    v_ite_name         varchar2(100);
    v_bli_num          number;
  begin                              
    p_pk_etape := 'Creation gendebt';
    select seq_gendebt.nextval into p_deb_id from dual; 
    insert into gendebt(deb_id,deb_refe,org_id,par_id,adr_id,deb_date,deb_duedt,deb_printdt,
                        deb_amountinit,vow_settlemode,aco_id,
                        deb_updtby,deb_comment,deb_amount_cash,sag_id,vow_debtype)
                values (p_deb_id,p_ref_facture,p_org_id,p_par_id,p_adr_id,p_fac_datecalcul,p_fac_datelim,p_fac_datecalcul,
                        p_tot_ttc,p_vow_settlemode,p_aco_id,
                        v_g_age_id,p_fac_comment,0,p_sag_id,p_vow_debtype);
                          
    p_pk_etape := 'Creation agrbill';                         
    select seq_agrbill.nextval into p_bil_id from dual; 
    insert into agrbill(bil_id,sag_id,vow_agrbilltype,vow_modefact)
                 values(p_bil_id,p_sag_id,p_vow_agrbilltype,p_vow_modefact);
    
    p_pk_etape := 'Creation genbill';
    insert into genbill(bil_id,bil_code,bil_calcdt,bil_amountht,bil_amounttva,bil_amountttc,
                        deb_id,par_id,bil_debtdt,run_id,bil_updtby)
                 values(p_bil_id,p_ref_facture,p_fac_datecalcul,p_tot_ht,p_tot_tva,p_tot_ttc,
                        p_deb_id,p_par_id,p_fac_datecalcul,p_run_id,v_g_age_id); 
    v_bli_num:=0;     
    p_pk_etape := 'Creation genbilline';
    p_pk_etape := 'Article Consommation EAU ';
    if to_number(p_mntconso)>0 then
      v_bli_num := v_bli_num+1;
      v_ite_name:='Consommation EAU';
      v_ite_id  :=320;
      v_vow_unit:=760;
      if (p_annee>=2018)then
        v_tva_id  :=26;
      else
        v_tva_id  :=24;
      end if;
      v_pta_id  :=2112;
      v_psl_rank:=1;
      v_bli_volumebase:= p_qteconso;
      v_bli_volumefact:= p_qteconso;
      v_bli_puht      := p_prixconso/1000;
      v_bli_mht       := p_mntconso/1000;
      v_bli_mttva     := p_tvacons/1000;
      v_bli_mttc      :=(p_prixconso+p_tvacons)/1000;
      insert into genbilline(bil_id,bli_number,bli_name,bli_exercice,ite_id,pta_id,psl_rank,
                             bli_volumebase,bli_volumefact,bli_puht,tva_id,bli_mht,bli_mttva,bli_mttc,bli_startdt,
                             bli_enddt,vow_unit,bli_updtby,meu_id)
                      values(p_bil_id,v_bli_num,v_ite_name,p_annee,v_ite_id,v_pta_id,v_psl_rank,
                             v_bli_volumebase,v_bli_volumefact,v_bli_puht,v_tva_id,v_bli_mht,v_bli_mttva,v_bli_mttc,p_fac_datecalcul,
                             p_fac_datecalcul,v_vow_unit,v_g_age_id,v_g_meu_id);
    end if;
    p_pk_etape := 'Article REDEVANCE ONAS 1ERE TRANCHE';        
    if to_number(p_mntonas1)>0 then
      v_bli_num := v_bli_num+1; 
      v_ite_name:='Redevance variable pour usage domestique';
      v_ite_id  :=350;
      v_vow_unit:=760;
      v_tva_id  :=25; 
      v_pta_id  :=403;
      v_psl_rank:=1;
      v_bli_volumebase:= p_volonas1;
      v_bli_volumefact:= p_volonas1;
      v_bli_puht      := p_prixonas1/1000;
      v_bli_mht       := p_mntonas1/1000;
      v_bli_mttva     := 0;
      v_bli_mttc      := p_mntonas1/1000;
      insert into genbilline(bil_id,bli_number,bli_name,bli_exercice,ite_id,pta_id,psl_rank,
                             bli_volumebase,bli_volumefact,bli_puht,tva_id,bli_mht,bli_mttva,bli_mttc,bli_startdt,
                             bli_enddt,vow_unit,bli_updtby,meu_id)
                      values(p_bil_id,v_bli_num,v_ite_name,p_annee,v_ite_id,v_pta_id,v_psl_rank,
                             v_bli_volumebase,v_bli_volumefact,v_bli_puht,v_tva_id,v_bli_mht,v_bli_mttva,v_bli_mttc,p_fac_datecalcul,
                             p_fac_datecalcul,v_vow_unit,v_g_age_id,v_g_meu_id);
    end if;
    p_pk_etape := 'Article REDEVANCE ONAS 2EME TRANCHE'; 
    if to_number(p_mntonas2)>0 then
      v_bli_num := v_bli_num+1;
      v_ite_name:='Redevance variable pour usage domestique';
      v_ite_id  :=350;
      v_vow_unit:=760;
      v_tva_id  :=25; 
      v_pta_id  :=403;
      v_psl_rank:=1;
      v_bli_volumebase:= p_volonas2;
      v_bli_volumefact:= p_volonas2;
      v_bli_puht      := p_prixonas2/1000;
      v_bli_mht       := p_mntonas2/1000;
      v_bli_mttva     := 0;
      v_bli_mttc      := p_mntonas2/1000;
      insert into genbilline(bil_id,bli_number,bli_name,bli_exercice,ite_id,pta_id,psl_rank,
                             bli_volumebase,bli_volumefact,bli_puht,tva_id,bli_mht,bli_mttva,bli_mttc,bli_startdt,
                             bli_enddt,vow_unit,bli_updtby,meu_id)
                      values(p_bil_id,v_bli_num,v_ite_name,p_annee,v_ite_id,v_pta_id,v_psl_rank,
                             v_bli_volumebase,v_bli_volumefact,v_bli_puht,v_tva_id,v_bli_mht,v_bli_mttva,v_bli_mttc,p_fac_datecalcul,
                             p_fac_datecalcul,v_vow_unit,v_g_age_id,v_g_meu_id);
    end if;
    p_pk_etape := 'Article REDEVANCE ONAS 3EME TRANCHE';        
    if to_number(p_mntonas3)>0 then
      v_bli_num := v_bli_num+1;
      v_ite_name:='Redevance variable pour usage domestique';
      v_ite_id  :=350;
      v_vow_unit:=760;
      v_tva_id  :=25; 
      v_pta_id  :=403;
      v_psl_rank:=1; 
      v_bli_volumebase:= p_volonas3;
      v_bli_volumefact:= p_volonas3;
      v_bli_puht      := p_prixonas3/1000;
      v_bli_mht       := p_mntonas3/1000;
      v_bli_mttva     := 0;
      v_bli_mttc      := p_mntonas3/1000;
      insert into genbilline(bil_id,bli_number,bli_name,bli_exercice,ite_id,pta_id,psl_rank,
                             bli_volumebase,bli_volumefact,bli_puht,tva_id,bli_mht,bli_mttva,bli_mttc,bli_startdt,
                             bli_enddt,vow_unit,bli_updtby,meu_id)
                      values(p_bil_id,v_bli_num,v_ite_name,p_annee,v_ite_id,v_pta_id,v_psl_rank,
                             v_bli_volumebase,v_bli_volumefact,v_bli_puht,v_tva_id,v_bli_mht,v_bli_mttva,v_bli_mttc,p_fac_datecalcul,
                             p_fac_datecalcul,v_vow_unit,v_g_age_id,v_g_meu_id);
    end if;
    p_pk_etape := 'Article FRAIS FIXE ONAS';  
    if to_number(p_fixonas)>0 then
      v_bli_num := v_bli_num+1;
      v_ite_name:='Redevance fixe domestique ONAS';
      v_ite_id  := 351;
      v_vow_unit:= 760;
      v_tva_id  := 25;
      v_pta_id  := 409;
      v_psl_rank:= 1;
      v_bli_volumebase:= 1;
      v_bli_volumefact:= 1;
      v_bli_puht      := p_fixonas/1000;
      v_bli_mht       := p_fixonas/1000;
      v_bli_mttva     := 0;
      v_bli_mttc      := p_fixonas/1000;         
      insert into genbilline(bil_id,bli_number,bli_name,bli_exercice,ite_id,pta_id,psl_rank,
                             bli_volumebase,bli_volumefact,bli_puht,tva_id,bli_mht,bli_mttva,bli_mttc,bli_startdt,
                             bli_enddt,vow_unit,bli_updtby,meu_id)
                      values(p_bil_id,v_bli_num,v_ite_name,p_annee,v_ite_id,v_pta_id,v_psl_rank,
                             v_bli_volumebase,v_bli_volumefact,v_bli_puht,v_tva_id,v_bli_mht,v_bli_mttva,v_bli_mttc,p_fac_datecalcul,
                             p_fac_datecalcul,v_vow_unit,v_g_age_id,v_g_meu_id);
    end if;      
    p_pk_etape := 'Article FRAIS FIXE SONEDE';    
    if to_number(p_fraisctr)>0 then
      v_bli_num := v_bli_num+1;
      V_ite_name:='Frais fixe';
      v_ite_id  :=326;
      v_vow_unit:=4104;
      if (p_annee>=2018)then
        v_tva_id  :=26;
      else
        v_tva_id  :=24;
      end if;
      v_pta_id  := 341;
      v_psl_rank:= 1; 
      v_bli_volumebase:= 1;
      v_bli_volumefact:= 1;
      v_bli_puht      := p_fraisctr/1000;
      v_bli_mht       := p_fraisctr/1000;
      v_bli_mttva     := p_tva_ff/1000;
      v_bli_mttc      := (p_fraisctr/+p_tva_ff)/1000;         
      insert into genbilline(bil_id,bli_number,bli_name,bli_exercice,ite_id,pta_id,psl_rank,
                             bli_volumebase,bli_volumefact,bli_puht,tva_id,bli_mht,bli_mttva,bli_mttc,bli_startdt,
                             bli_enddt,vow_unit,bli_updtby,meu_id)
                      values(p_bil_id,v_bli_num,v_ite_name,p_annee,v_ite_id,v_pta_id,v_psl_rank,
                             v_bli_volumebase,v_bli_volumefact,v_bli_puht,v_tva_id,v_bli_mht,v_bli_mttva,v_bli_mttc,p_fac_datecalcul,
                             p_fac_datecalcul,v_vow_unit,v_g_age_id,v_g_meu_id);
    end if;     
    p_pk_etape := 'Article Frais FERMETURE'; 
    if to_number(p_fermeture)>0 then
      v_bli_num := v_bli_num+1; 
      v_ite_name:='Frais de coupure d''eau suite à non paiement';
      v_ite_id  :=335;
      v_vow_unit:=4104; 
      if (p_annee>=2018)then
        v_tva_id  :=26;
      else
        v_tva_id  :=24;
      end if; 
      v_pta_id  := 365;
      v_psl_rank:= 1;  
      v_bli_volumebase:= 1;
      v_bli_volumefact:= 1;
      v_bli_puht      := p_fermeture/1000;
      v_bli_mht       := p_fermeture/1000;
      v_bli_mttva     := p_tvaferm/1000;
      v_bli_mttc      := (p_fermeture+p_tvaferm)/1000;
      insert into genbilline(bil_id,bli_number,bli_name,bli_exercice,ite_id,pta_id,psl_rank,
                             bli_volumebase,bli_volumefact,bli_puht,tva_id,bli_mht,bli_mttva,bli_mttc,bli_startdt,
                             bli_enddt,vow_unit,bli_updtby,meu_id)
                      values(p_bil_id,v_bli_num,v_ite_name,p_annee,v_ite_id,v_pta_id,v_psl_rank,
                             v_bli_volumebase,v_bli_volumefact,v_bli_puht,v_tva_id,v_bli_mht,v_bli_mttva,v_bli_mttc,p_fac_datecalcul,
                             p_fac_datecalcul,v_vow_unit,v_g_age_id,v_g_meu_id);
    end if;   
    p_pk_etape := 'Article Frais PREAVIS'; 
    if to_number(p_preavis)>0 then
      v_bli_num := v_bli_num+1; 
      v_ite_name:='Frais de preavis et de rappel de paiement';
      v_ite_id  :=338;
      v_vow_unit:=4104; 
      if (p_annee>=2018)then
        v_tva_id  :=26;
      else
        v_tva_id  :=24;
      end if; 
      v_pta_id  := 389;
      v_psl_rank:= 1;  
      v_bli_volumebase:= 1;
      v_bli_volumefact:= 1;
      v_bli_puht      := p_preavis/1000;
      v_bli_mht       := p_preavis/1000;
      v_bli_mttva     := p_tva_preav/1000;
      v_bli_mttc      :=(p_preavis+p_tva_preav)/1000;
      insert into genbilline(bil_id,bli_number,bli_name,bli_exercice,ite_id,pta_id,psl_rank,
                             bli_volumebase,bli_volumefact,bli_puht,tva_id,bli_mht,bli_mttva,bli_mttc,bli_startdt,
                             bli_enddt,vow_unit,bli_updtby,meu_id)
                      values(p_bil_id,v_bli_num,v_ite_name,p_annee,v_ite_id,v_pta_id,v_psl_rank,
                             v_bli_volumebase,v_bli_volumefact,v_bli_puht,v_tva_id,v_bli_mht,v_bli_mttva,v_bli_mttc,p_fac_datecalcul,
                             p_fac_datecalcul,v_vow_unit,v_g_age_id,v_g_meu_id);
    end if;     
    p_pk_etape := 'Article Frais de déplacement'; 
    if to_number(p_deplacement)>0 then  
      v_bli_num := v_bli_num+1; 
      v_ite_name:='Frais de déplacement';
      v_ite_id  :=1764;
      v_vow_unit:=4104;
      if (p_annee>=2018)then
        v_tva_id  :=26;
      else
        v_tva_id  :=24;
      end if;
      v_pta_id  :=5624;
      v_psl_rank:=1;
      v_bli_volumebase:= 1;
      v_bli_volumefact:= 1;
      v_bli_puht      := p_deplacement/1000;
      v_bli_mht       := p_deplacement/1000;
      v_bli_mttva     := p_deplacement/1000;
      v_bli_mttc      := (p_deplacement+p_tvadeplac)/1000;
      insert into genbilline(bil_id,bli_number,bli_name,bli_exercice,ite_id,pta_id,psl_rank,
                             bli_volumebase,bli_volumefact,bli_puht,tva_id,bli_mht,bli_mttva,bli_mttc,bli_startdt,
                             bli_enddt,vow_unit,bli_updtby,meu_id)
                      values(p_bil_id,v_bli_num,v_ite_name,p_annee,v_ite_id,v_pta_id,v_psl_rank,
                             v_bli_volumebase,v_bli_volumefact,v_bli_puht,v_tva_id,v_bli_mht,v_bli_mttva,v_bli_mttc,p_fac_datecalcul,
                             p_fac_datecalcul,v_vow_unit,v_g_age_id,v_g_meu_id);
    end if;
    p_pk_etape := 'Article Frais de dépose suite à la demande du client'; 
    if to_number(p_depose_dem)>0 then  
      v_bli_num := v_bli_num+1;
      v_ite_name:='Frais de depose ou repose suite à la demande du client';
      v_ite_id  :=355;
      v_vow_unit:=1404;
      if (p_annee>=2018)then
        v_tva_id  :=26;
      else
        v_tva_id  :=24;
      end if;
      v_pta_id  :=414;
      v_psl_rank:=1;
      v_bli_volumebase:= 1;
      v_bli_volumefact:= 1;
      v_bli_puht      := p_depose_dem/1000;
      v_bli_mht       := p_depose_dem/1000;
      v_bli_mttva     := p_tvadepose_dem/1000;
      v_bli_mttc      := (p_depose_dem +p_tvadepose_dem)/1000;
      insert into genbilline(bil_id,bli_number,bli_name,bli_exercice,ite_id,pta_id,psl_rank,
                             bli_volumebase,bli_volumefact,bli_puht,tva_id,bli_mht,bli_mttva,bli_mttc,bli_startdt,
                             bli_enddt,vow_unit,bli_updtby,meu_id)
                      values(p_bil_id,v_bli_num,v_ite_name,p_annee,v_ite_id,v_pta_id,v_psl_rank,
                             v_bli_volumebase,v_bli_volumefact,v_bli_puht,v_tva_id,v_bli_mht,v_bli_mttva,v_bli_mttc,p_fac_datecalcul,
                             p_fac_datecalcul,v_vow_unit,v_g_age_id,v_g_meu_id);
    end if;
    p_pk_etape := 'Article frais de depose suite au non paiement';
    if to_number(p_depose_def)>0 then  
      v_bli_num := v_bli_num+1; 
      v_ite_name:='Frais de dépose ou repose compteur';
      v_ite_id  :=336;
      v_vow_unit:=4104;
      if (p_annee>=2018)then
        v_tva_id  :=26;
      else
        v_tva_id  :=24;
      end if;
      v_pta_id  :=377;
      v_psl_rank:=1; 
      v_bli_volumebase:= 1;
      v_bli_volumefact:= 1;
      v_bli_puht      := (p_depose_def/1000);
      v_bli_mht       := (p_depose_def/1000);
      v_bli_mttva     := (p_tvadepose_def/1000);
      v_bli_mttc      := (p_depose_def+p_tvadepose_def)/1000;
      insert into genbilline(bil_id,bli_number,bli_name,bli_exercice,ite_id,pta_id,psl_rank,
                             bli_volumebase,bli_volumefact,bli_puht,tva_id,bli_mht,bli_mttva,bli_mttc,bli_startdt,
                             bli_enddt,vow_unit,bli_updtby,meu_id)
                      values(p_bil_id,v_bli_num,v_ite_name,p_annee,v_ite_id,v_pta_id,v_psl_rank,
                             v_bli_volumebase,v_bli_volumefact,v_bli_puht,v_tva_id,v_bli_mht,v_bli_mttva,v_bli_mttc,p_fac_datecalcul,
                             p_fac_datecalcul,v_vow_unit,v_g_age_id,v_g_meu_id);
    end if; 
    p_pk_etape := 'Article montant extension';
    if (p_extention)>0 then
      v_bli_num := v_bli_num+1; 
      v_ite_name:='Montant extention';  
      v_ite_id  :=1979;
      v_vow_unit:=4751;   
      if(p_annee>=2018)then
        v_tva_id  :=26;
      else
        v_tva_id  :=24;
      end if;
      v_pta_id  :=2310;
      v_psl_rank:=1;
      v_bli_volumebase:= 1;
      v_bli_volumefact:= 1;
      v_bli_puht      := (p_extention)/1000;
      v_bli_mht       := (p_extention)/1000;
      v_bli_mttva     :=  p_tva_capit/1000;
      v_bli_mttc      := (p_extention+p_tva_capit)/1000;
      insert into genbilline(bil_id,bli_number,bli_name,bli_exercice,ite_id,pta_id,psl_rank,
                             bli_volumebase,bli_volumefact,bli_puht,tva_id,bli_mht,bli_mttva,bli_mttc,bli_startdt,
                             bli_enddt,vow_unit,bli_updtby,meu_id)
                      values(p_bil_id,v_bli_num,v_ite_name,p_annee,v_ite_id,v_pta_id,v_psl_rank,
                             v_bli_volumebase,v_bli_volumefact,v_bli_puht,v_tva_id,v_bli_mht,v_bli_mttva,v_bli_mttc,p_fac_datecalcul,
                             p_fac_datecalcul,v_vow_unit,v_g_age_id,v_g_meu_id);
    end if; 
    p_pk_etape := 'Article produit financier';
    if p_pfinancier>0 then
      v_bli_num := v_bli_num+1; 
      v_ite_name:='Produit financier';  
      v_ite_id  :=1982;
      v_vow_unit:=4751;   
      if(p_annee>=2018)then
        v_tva_id  :=26;
      else
        v_tva_id  :=24;
      end if;
      v_pta_id  :=2306;
      v_psl_rank:=1;
      v_bli_volumebase:= 1;
      v_bli_volumefact:= 1;
      v_bli_puht      := p_pfinancier/1000;
      v_bli_mht       := p_pfinancier/1000;
      v_bli_mttva     := p_tva_pfin/1000;
      v_bli_mttc      := (p_pfinancier+p_tva_pfin)/1000;
      insert into genbilline(bil_id,bli_number,bli_name,bli_exercice,ite_id,pta_id,psl_rank,
                             bli_volumebase,bli_volumefact,bli_puht,tva_id,bli_mht,bli_mttva,bli_mttc,bli_startdt,
                             bli_enddt,vow_unit,bli_updtby,meu_id)
                      values(p_bil_id,v_bli_num,v_ite_name,p_annee,v_ite_id,v_pta_id,v_psl_rank,
                             v_bli_volumebase,v_bli_volumefact,v_bli_puht,v_tva_id,v_bli_mht,v_bli_mttva,v_bli_mttc,p_fac_datecalcul,
                             p_fac_datecalcul,v_vow_unit,v_g_age_id,v_g_meu_id);
    end if;
    p_pk_etape := 'Article montant capital';     
    if p_capit >0 then
      v_bli_num := v_bli_num+1; 
      v_ite_name:='Montant capital ONAS';
      v_ite_id  :=1981;
      v_vow_unit:=4751; 
      v_tva_id  :=25;
      v_pta_id  :=2305;
      v_psl_rank:=1;
      v_bli_volumebase:= 1;
      v_bli_volumefact:= 1;
      v_bli_puht      := p_capit/1000;
      v_bli_mht       := p_capit/1000;
      v_bli_mttva     := 0;
      v_bli_mttc      := p_capit/1000;
      insert into genbilline(bil_id,bli_number,bli_name,bli_exercice,ite_id,pta_id,psl_rank,
                             bli_volumebase,bli_volumefact,bli_puht,tva_id,bli_mht,bli_mttva,bli_mttc,bli_startdt,
                             bli_enddt,vow_unit,bli_updtby,meu_id)
                      values(p_bil_id,v_bli_num,v_ite_name,p_annee,v_ite_id,v_pta_id,v_psl_rank,
                             v_bli_volumebase,v_bli_volumefact,v_bli_puht,v_tva_id,v_bli_mht,v_bli_mttva,v_bli_mttc,p_fac_datecalcul,
                             p_fac_datecalcul,v_vow_unit,v_g_age_id,v_g_meu_id);
    end if; 
    p_pk_etape := 'Article montant Interet'; 
    if p_inter>0 then
      v_bli_num := v_bli_num+1;   
      v_ite_name:='Montant interet ONAS';
      v_ite_id  :=1978;
      v_vow_unit:=4751;
      v_tva_id  :=25;
      v_pta_id  :=2302;
      v_psl_rank:=1;
      v_bli_volumebase:= 1;
      v_bli_volumefact:= 1;
      v_bli_puht      := p_inter/1000;
      v_bli_mht       := p_inter/1000;
      v_bli_mttva     := 0;
      v_bli_mttc      := p_inter/1000;
      insert into genbilline(bil_id,bli_number,bli_name,bli_exercice,ite_id,pta_id,psl_rank,
                           bli_volumebase,bli_volumefact,bli_puht,tva_id,bli_mht,bli_mttva,bli_mttc,bli_startdt,
                           bli_enddt,vow_unit,bli_updtby,meu_id)
                    values(p_bil_id,v_bli_num,v_ite_name,p_annee,v_ite_id,v_pta_id,v_psl_rank,
                           v_bli_volumebase,v_bli_volumefact,v_bli_puht,v_tva_id,v_bli_mht,v_bli_mttva,v_bli_mttc,p_fac_datecalcul,
                           p_fac_datecalcul,v_vow_unit,v_g_age_id,v_g_meu_id);
    end if;       
    p_pk_etape := 'Article montant report';  
    if p_arepor>0 then
      v_bli_num := v_bli_num+1; 
      v_ite_name:='Ancien report';
      v_ite_id  :=1983;
      v_vow_unit:=4751; 
      v_tva_id  :=25;
      v_pta_id  :=2307;
      v_psl_rank:=1; 
      v_bli_volumebase:= 1;
      v_bli_volumefact:= 1; 
      v_bli_puht      := p_caron*(p_arepor/1000); 
      v_bli_mht       := p_caron*(p_arepor/1000);
      v_bli_mttva     := 0;
      v_bli_mttc      := p_caron*(p_arepor/1000);
      insert into genbilline(bil_id,bli_number,bli_name,bli_exercice,ite_id,pta_id,psl_rank,
                             bli_volumebase,bli_volumefact,bli_puht,tva_id,bli_mht,bli_mttva,bli_mttc,bli_startdt,
                             bli_enddt,vow_unit,bli_updtby,meu_id)
                      values(p_bil_id,v_bli_num,v_ite_name,p_annee,v_ite_id,v_pta_id,v_psl_rank,
                             v_bli_volumebase,v_bli_volumefact,v_bli_puht,v_tva_id,v_bli_mht,v_bli_mttva,v_bli_mttc,p_fac_datecalcul,
                             p_fac_datecalcul,v_vow_unit,v_g_age_id,v_g_meu_id);
    end if; 
    p_pk_etape := 'Article Arrondissement';
    if to_number(p_narond)>0 then
      v_bli_num := v_bli_num+1; 
      V_ite_name:='Nouveau report';
      v_ite_id  :=1980;
      v_vow_unit:=4751;
      v_tva_id  :=25;
      v_pta_id  :=2304;
      v_psl_rank:=1; 
      v_bli_volumebase:= 1;
      v_bli_volumefact:= 1;
      v_bli_puht      := (p_caron*(p_narond/1000));
      v_bli_mht       := (p_caron*(p_narond/1000));
      v_bli_mttva     := 0;
      v_bli_mttc      := (p_caron*(p_narond/1000));
      insert into genbilline(bil_id,bli_number,bli_name,bli_exercice,ite_id,pta_id,psl_rank,
                           bli_volumebase,bli_volumefact,bli_puht,tva_id,bli_mht,bli_mttva,bli_mttc,bli_startdt,
                           bli_enddt,vow_unit,bli_updtby,meu_id)
                    values(p_bil_id,v_bli_num,v_ite_name,p_annee,v_ite_id,v_pta_id,v_psl_rank,
                           v_bli_volumebase,v_bli_volumefact,v_bli_puht,v_tva_id,v_bli_mht,v_bli_mttva,v_bli_mttc,p_fac_datecalcul,
                           p_fac_datecalcul,v_vow_unit,v_g_age_id,v_g_meu_id);
    end if;  
    p_pk_etape := 'Article de reprise SONEDE';
    if (p_reprise_S>0) then          
      v_bli_num := v_bli_num+1; 
      v_ite_id  :=329;
      v_ite_name:='Article de reprise SONEDE';
      v_vow_unit:=4104;
      v_tva_id  := 25;
      v_pta_id  :=325;
      v_psl_rank:=1; 
      v_bli_volumebase:= 0;
      v_bli_volumefact:= 0;
      v_bli_puht      := 0;
      v_bli_mht       := (p_reprise_S)/1000;
      v_bli_mttva     := 0;
      v_bli_mttc      := (p_reprise_S)/1000;
      insert into genbilline(bil_id,bli_number,bli_name,bli_exercice,ite_id,pta_id,psl_rank,
                           bli_volumebase,bli_volumefact,bli_puht,tva_id,bli_mht,bli_mttva,bli_mttc,bli_startdt,
                           bli_enddt,vow_unit,bli_updtby,meu_id)
                    values(p_bil_id,v_bli_num,v_ite_name,p_annee,v_ite_id,v_pta_id,v_psl_rank,
                           v_bli_volumebase,v_bli_volumefact,v_bli_puht,v_tva_id,v_bli_mht,v_bli_mttva,v_bli_mttc,p_fac_datecalcul,
                           p_fac_datecalcul,v_vow_unit,v_g_age_id,v_g_meu_id);
    end if;           
    p_pk_etape := 'Article de reprise ONAS';
    if (p_reprise_O>0) then
      v_bli_num := v_bli_num+1;
      v_ite_id  :=330;
      v_ite_name:='Article de reprise ONAS';
      v_vow_unit:=4104;
      v_tva_id  := 25;
      v_pta_id  :=324;
      v_psl_rank:=1;
      v_bli_volumebase:= 0;
      v_bli_volumefact:= 0;
      v_bli_puht      := 0;
      v_bli_mht       := p_reprise_O/1000;
      v_bli_mttva     := 0;
      v_bli_mttc      := p_reprise_O/1000;
      insert into genbilline(bil_id,bli_number,bli_name,bli_exercice,ite_id,pta_id,psl_rank,
                           bli_volumebase,bli_volumefact,bli_puht,tva_id,bli_mht,bli_mttva,bli_mttc,bli_startdt,
                           bli_enddt,vow_unit,bli_updtby,meu_id)
                    values(p_bil_id,v_bli_num,v_ite_name,p_annee,v_ite_id,v_pta_id,v_psl_rank,
                           v_bli_volumebase,v_bli_volumefact,v_bli_puht,v_tva_id,v_bli_mht,v_bli_mttva,v_bli_mttc,p_fac_datecalcul,
                           p_fac_datecalcul,v_vow_unit,v_g_age_id,v_g_meu_id);
   end if;
      
end;  


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
					         values(v_run_id,p_annee,p_periode,p_org_id,p_fac_datecalcul,'Role migré','Role '||p_train_fact,p_fac_datecalcul,p_fac_datecalcul);
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
      from   test.src_fiche_releve r   
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
            v_date_rel :=to_date('08/'||'01'||'/'||s1.annee+1,'dd/mm/yyyy');
          else
            v_date_rel:=to_date('08/'||lpad(v_mois3+1,2,'0')||'/'||s1.annee,'dd/mm/yyyy');
          end if; 
        end;
        
        if v_date_rel is null then
          EXCEPTION_RELEVE(s1.district||s1.tourne||s1.ordre||'-'||s1.annee||'-'||s1.trim,null,'Impossible de recuperer la date de la releve',p_pk_etape);
          continue;
        end if;
        
        begin
          p_pk_etape := 'Initialisation pour creation releve';
          v_index := to_number(trim(s1.releve));
          v_conso := to_number(trim(s1.consommation));
          v_prorata := to_number(trim(s1.prorata));
          v_avis_f := to_number(trim(s1.avisforte));
          v_tentatif2 := to_number(trim(s1.releve2));
          v_tentatif3 := to_number(trim(s1.releve3));
          v_tentatif4 := to_number(trim(s1.releve4));
          v_tentatif5 := to_number(trim(s1.releve5));
          select decode(to_char(nvl(trim(s1.compteurt),0)),'0',0,1) into v_compteur_t from dual;
        exception when others then
          p_pk_exception := SQLCODE || ' : ' ||  SUBSTR(SQLERRM, 1, 200);
          EXCEPTION_RELEVE(s1.district||s1.tourne||s1.ordre||'-'||s1.annee||'-'||s1.trim,null,p_pk_exception,p_pk_etape);
          continue;
        end;
        
        MigrationReleve(p_pk_etape,p_pk_exception,v_mrd_id,s1.annee,s1.trim,v_index,v_conso,v_prorata,v_avis_f,
                        v_tentatif2,v_tentatif3,v_tentatif4,v_tentatif5,v_compteur_t,v_date_rel, 
                        substr(s1.anomalie,13,2),substr(s1.anomalie,7,2),substr(s1.anomalie,1,2),
                        trim(s1.message_temporaire),v_g_vow_readreason_t,1,s1.equ_id,s1.mtc_id,s1.spt_id,
                        v_g_age_id);
                        
        if p_pk_exception is not null then
          rollback;
          EXCEPTION_RELEVE(s1.district||s1.tourne||s1.ordre||'-'||s1.annee||'-'||s1.trim,null,p_pk_exception,p_pk_etape);
          continue;
        end if;
        
        if v_mrd_id is not null then
          update test.src_fiche_releve
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
    
    --Curseur des données etude
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
    
    --Curseur des crredits (détails)
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
          --Le cas ou le dossier est créer on le met a jour
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
/*PROCEDURE MigrationFactureAS400
  (
    p_param in number default 0
  )
  IS
    cursor c1   
    is 
      select f.rowid,decode(f.caron,'1',1,-1) caron,f.refc01,f.refc02,f.refc03,f.refc04,f.tvacons,f.tva_ff,f.tvaferm,f.tva_preav,
            f.tvadeplac,f.tvadepose_dem,f.tvadepose_def,f.tva_capit,f.tva_pfin,f.arriere,(f.rbranche+f.rfacade) extention,
            f.net,f.monttrim,nvl(nvl(f.montt1,f.montt2),f.montt3) montt ,nvl(nvl(const1,const2),const3)const,nvl(nvl(f.tauxt1,f.tauxt2),f.tauxt3) taux,f.mon1,
            f.volon1,f.tauon1,f.mon2,f.volon2,f.tauon2,f.mon3,f.volon3,f.tauon3,f.fixonas,f.fraisctr,f.fermeture,f.preavis,
            f.deplacement,f.depose_dem,f.depose_def,f.rbranche,f.rfacade,f.pfinancier,f.capit,f.inter,f.arepor,
            f.narond,lpad(trim(b.district),2,'0') district,lpad(trim(b.police),5,'0') police,lpad(trim(b.tourne),3,'0') tourne, 
            lpad(trim(b.ordre),3,'0') ordre,b.spt_id,b.mtc_id,b.equ_id,b.sag_id,b.par_id,b.aco_id,b.adr_id,b.date_creation,p.trim,p.tier,p.six, 
            to_date(lpad(trim(r.datexp),8,'0'),'ddmmyyyy') fac_datecalcul_trim,
            to_date(lpad(trim(r.datl),8,'0'),'ddmmyyyy')   fac_datelim_trim,
            to_date(lpad(trim(l.datexp),8,'0'),'ddmmyyyy') fac_datecalcul_mens,
            to_date(lpad(trim(l.datl),8,'0'),'ddmmyyyy')   fac_datelim_mens
          
      from test.src_facture_as400 f
        left join test.branchement b 
        on  lpad(trim(b.district),2,'0')= lpad(trim(f.dist),2,'0')
        and lpad(trim(b.tourne),3,'0')  = lpad(trim(f.tou),3,'0')   
        and lpad(trim(b.ordre),3,'0')   = lpad(trim(f.ord),3,'0')   
        and lpad(trim(b.police) ,5,'0') = lpad(trim(f.pol),3,'0')
        and b.spt_id is not null
        and b.equ_id is not null 
        and b.mtc_id is not null
        and b.sag_id is not null 
        left join test.tourne t
        on  lpad(trim(t.district),2,'0')= lpad(trim(f.dist),2,'0')
        and lpad(trim(t.code),3,'0')    = lpad(trim(f.tou),3,'0')
        left join test.param_tournee p
        on  lpad(trim(p.district),2,'0')= lpad(trim(f.dist),2,'0')
        and lpad(trim(p.district),2,'0')= lpad(trim(t.district),2,'0')
        and   p.m1      = f.refc01
        and   p.m2      = f.refc02
        and   p.m3      = f.refc03
        and   p.tier    = t.ntiers
        and   p.six     = t.nsixieme 
        left join  test.role_trim r
        on    lpad(trim(r.distr),2,'0') = lpad(trim(f.dist),2,'0')
        and   lpad(trim(r.tour),3,'0')  = lpad(trim(f.tou),3,'0')
        and   lpad(trim(r.ordr),3,'0')  = lpad(trim(f.ord),3,'0')
        and   lpad(trim(r.police),5,'0')= lpad(trim(f.pol),5,'0')
        and   r.tier                    = to_number(t.ntiers)
        and   r.trim                    = p.trim
        and   r.six                     = to_number(t.nsixieme)        
        and   r.annee                   = '20'||f.refc04
        and   rownum = 1
        left join test.role_gc l
        on    lpad(trim(l.distr),2,'0')  = lpad(trim(f.dist),2,'0')
        and   lpad(trim(l.tour),3,'0')   = lpad(trim(f.tou),3,'0')
        and   lpad(trim(l.ordr),3,'0')   = lpad(trim(f.ord),3,'0')
        and   lpad(trim(l.police),5,'0') = lpad(trim(f.pol),5,'0')
        and   l.mois =f.refc01
        and   l.annee=f.refc02
        and   rownum = 1
      where f.bil_id is null;
 
   v_org_id number;
   v_adr_id number;
   v_run_id number;
   v_aco_id number;
   v_bil_id number;
   v_deb_id number;
   v_annee  number;
   v_tva    number;
   v_tothta number;
   v_tottvaa number;
   v_tothte number;
   v_periode number;
   v_tot_ttc number(25,10);
   v_tot_ht  number(25,10);
   v_tot_tva number(25,10);
   v_vow_agrbilltype number;
   v_date    date;
   v_fac_datecalcul date;
   v_fac_datelim    date;
   v_ref_facture   varchar2(100);
   v_fac_comment  varchar2(100);
   p_pk_etape     varchar2(400);
   p_pk_exception varchar2(400);
   BEGIN     
    for s1 in c1 loop
      v_bil_id  := null;
      v_deb_id  := null;
      v_org_id  := null;
      v_adr_id  := null;
      v_run_id  := null;
      v_aco_id  := null;
      v_annee   := null;
      v_tva     := null;
      v_tothta  := null;
      v_tottvaa := null;
      v_tothte  := null;
      v_periode := null;
      v_tot_ttc := null;
      v_tot_ht  := null;
      v_tot_tva := null;
      v_vow_agrbilltype  := null;
      v_date    := null;
      v_fac_datecalcul:= null;
      v_fac_datelim   := null;
      v_ref_facture   := null;
      v_fac_comment   := null;
      p_pk_etape      := null;
      p_pk_exception  := null; 
      select max(org_id)
      into   v_org_id
      from   genorganization
      where  org_code = s1.district;    
      v_tothta     :=0;
      v_tottvaa    :=0;
      v_tva :=(s1.tvacons+s1.tva_ff+s1.tvaferm+s1.tva_preav+s1.tvadeplac+s1.tvadepose_dem+s1.tvadepose_def+s1.tva_capit+s1.tva_pfin)/1000;   
      v_fac_comment :=s1.district||s1.police||s1.tourne||s1.ordre;  
      if s1.refc04 is not null then 
          if(to_number(s1.refc01)<to_number(s1.refc03) )then
            v_annee := to_number('20'||s1.refc04);
          else
            v_annee := to_number('20'||to_char((to_number(s1.refc04)-1)));
          end if;
          v_periode := lpad(trim(s1.trim),2,'0');
          if s1.fac_datecalcul_trim is null then
            select last_day(to_date('01'||lpad(s1.refc03,2,'0')||s1.refc04,'ddmmyy')) 
            into v_fac_datecalcul
            from dual;
          else
            v_fac_datecalcul:=s1.fac_datecalcul_trim;
          end if;  
          v_fac_datelim:=nvl(s1.fac_datelim_trim,v_fac_datecalcul+45); 
          v_tothte     :=(s1.net-(v_tva+s1.arriere))/1000;
          --v_solde      :=(s1.net-s1.arriere)/1000;
      else
          select last_day(to_date('01'||lpad(s1.refc01,2,'0')||s1.refc02,'ddmmyy')) 
          into v_date
          from dual;
          v_annee   := to_number(to_char(v_date,'yyyy'));
          v_periode := lpad(trim(s1.refc01),2,'0');
          v_fac_datecalcul := nvl(s1.fac_datecalcul_mens,v_date);
          v_fac_datelim    := nvl(s1.fac_datelim_mens,v_date);
          v_tothte    := (s1.monttrim-v_tva)/1000;
          --v_solde     := s1.monttrim/1000; 
      end if;  
      v_tot_ttc    := v_tothte+v_tva+v_tothta+v_tottvaa;
      v_tot_ht     := v_tothte+v_tothta;
      v_tot_tva    := v_tva+v_tottvaa;
      v_ref_facture := s1.district||s1.tourne||s1.ordre||to_char(v_annee)||lpad(trim(v_periode),2,'0')||'0';     
      MigrationFacture(p_pk_etape,p_pk_exception,v_bil_id,v_deb_id,v_periode,v_annee,v_ref_facture,v_tot_ttc,v_tot_ht,v_tot_tva,
                      v_fac_datecalcul,v_fac_datelim,v_fac_comment,s1.const,s1.montt,s1.taux,s1.tvacons,s1.fraisctr,s1.tva_ff,
                      s1.mon1,s1.volon1,s1.tauon1,s1.mon2,s1.volon2,s1.tauon2,s1.mon3,s1.volon3,s1.tauon3,s1.fixonas,
                      s1.preavis,s1.tva_preav,s1.fermeture,s1.tvaferm,s1.deplacement,s1.tvadeplac,s1.depose_dem,s1.tvadepose_dem,
                      s1.depose_def,s1.tvadepose_def,s1.extention,s1.tva_capit,s1.pfinancier,s1.tva_pfin,s1.capit,s1.inter,s1.arepor,
                      s1.narond,s1.caron,0,0,s1.spt_id,v_g_imp_id,s1.sag_id,s1.par_id,v_adr_id,v_org_id,v_g_vow_agrbilltype,v_g_vow_debtype,
                      v_g_vow_settlemode_a,v_g_vow_modefact,v_run_id,v_aco_id); 
      
      if p_pk_exception is not null then
        rollback;
        EXCEPTION_FACTURE(s1.district||s1.tourne||s1.ordre||s1.police,null,p_pk_exception,p_pk_etape);
        continue;
      end if;	
      if v_bil_id is not null then
        update test.src_facture_as400
        set    bil_id= v_bil_id,
               deb_id= v_deb_id
        where  rowid = s1.rowid;
      end if;
      commit; 
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
             b.spt_id,b.mtc_id,b.equ_id,b.sag_id,b.date_creation,b.par_id,b.aco_id,b.adr_id,t.ntiers,t.nsixieme
      from test.facture f 
        left join test.branchement b 
        on   lpad(trim(b.district),2,'0')= lpad(trim(f.district),2,'0')
        and  lpad(trim(b.tourne),3,'0')  = lpad(trim(f.tournee),3,'0')   
        and  lpad(trim(b.ordre),3,'0')   = lpad(trim(f.ordre),3,'0') 
        and  lpad(trim(b.police) ,5,'0') = lpad(trim(f.police),3,'0')
        and b.spt_id is not null
        and b.equ_id is not null 
        and b.mtc_id is not null
        and b.sag_id is not null 
        left join  test.tourne t
        on   lpad(trim(t.district),2,'0') = lpad(trim(f.district),2,'0') 
        and  lpad(trim(t.code),3,'0')     = lpad(trim(f.tournee),3,'0')
      where  f.annee>='2015' 
      and    f.bil_id is null;
      
   v_org_id number;
   v_run_id number;------in
   v_bil_id number;
   v_deb_id number;
   v_tva    number;
   v_tothta number;
   v_tottvaa number;
   v_tothte number;
   v_tot_ttc number(25,10);
   v_tot_ht  number(25,10);
   v_tot_tva number(25,10);
   v_vow_agrbilltype number;
   v_fac_datecalcul date;
   v_fac_datelim    date;
   v_ref_facture   varchar2(100);
   v_fac_comment  varchar2(100);
   p_pk_etape     varchar2(400);
   p_pk_exception varchar2(400);
  BEGIN
    for s1 in c1 loop
    v_bil_id  := null;
    v_deb_id  := null;
    v_org_id  := null;
    v_run_id  := null;
    v_tva     := null;
    v_tothta  := null;
    v_tottvaa := null;
    v_tothte  := null;
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
       v_fac_datecalcul := '01/01/2016';-------!!!!!!
     end; 
     v_fac_datelim := (v_fac_datecalcul+45);
     v_tothte   :=(s1.net_a_payer/1000);
     v_tva      :=0;
     v_tothta   :=0;
     v_tottvaa  :=0;
     v_tot_ttc  := v_tothte+v_tva+v_tothta+v_tottvaa;
     v_tot_ht   :=v_tothte+v_tothta;
     v_tot_tva  :=v_tva+v_tottvaa;
     --v_solde    :=(s1.net_a_payer/1000);   
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
     MigrationFacture(p_pk_etape,p_pk_exception,v_bil_id,v_deb_id,s1.periode,s1.annee,v_ref_facture,v_tot_ttc,v_tot_ht,v_tot_tva,
                      v_fac_datecalcul,v_fac_datelim,v_fac_comment,0,0,0,0,0,0,
                      0,0,0,0,0,0,0,0,0,0,
                      0,0,0,0,0,0,0,0,
                      0,0,0,0,0,0,0,0,0,
                      0,0,0,0,s1.spt_id,v_g_imp_id,s1.sag_id,s1.par_id,s1.adr_id,v_org_id,v_vow_agrbilltype,v_g_vow_debtype,
                      v_g_vow_settlemode_a,v_g_vow_modefact,v_run_id,s1.aco_id);                       
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
             b.spt_id,b.mtc_id,b.equ_id,b.sag_id,b.date_creation,b.par_id,b.aco_id,b.adr_id,t.ntiers,t.nsixieme
      from test.facture f
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
        on   g.deb_id=d.deb_id
        left join  test.tourne t
        on   lpad(trim(t.district),2,'0') = lpad(trim(f.district),2,'0') 
        and  lpad(trim(t.code),3,'0')     = lpad(trim(f.tournee),3,'0')
      where trim(f.etat) in ('A','P')
      and trim(f.annee)>=2015
      and  f.bil_id is null;
   cursor c2(v_bil_id number)
   is
     select * from genbilline b where b.bil_id=v_bil_id;
     
   v_org_id number;
   v_run_id number;------in
   v_bil_id number;
   v_deb_id number;
   v_tva    number;
   v_tothta number;
   v_tottvaa number;
   v_tothte number;
   v_tot_ttc number(25,10);
   v_tot_ht  number(25,10);
   v_tot_tva number(25,10);
   v_vow_agrbilltype number;
   v_vow_debtype  number;
   v_fac_datecalcul date;
   v_fac_datelim    date;
   v_ref_facture  varchar2(100);
   v_fac_comment  varchar2(100);
   p_pk_etape     varchar2(400);
   p_pk_exception varchar2(400);
   
  BEGIN
    for s1 in c1 loop
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
    select max(org_id)
    into   v_org_id
    from   genorganization
    where  org_code = s1.district; 
    v_fac_datecalcul := s1.bil_calcdt +5;
    v_ref_facture    := s1.district||s1.tourne||s1.ordre||to_char(s1.annee)||s1.periode||trim(s1.version); 
    v_tothte         :=(s1.net_a_payer/1000);
    v_tva       :=0;
    v_tothta    :=0;
    v_tottvaa   :=0;
    if upper(trim(s1.etat))='A' then 
      v_tot_ttc          := 0;
      v_tot_ht           := -(s1.bil_amountht);
      v_tot_tva          := -(s1.bil_amounttva);
      v_tot_ttc          := -(s1.bil_amountttc);
      v_vow_debtype      := 3135;--'Av'
      v_vow_agrbilltype  := 2565;--'FA'; 
      v_fac_comment      := s1.deb_comment;
      
      MigrationFacture(p_pk_etape,p_pk_exception,v_bil_id,v_deb_id,s1.periode,s1.annee,v_ref_facture,v_tot_ttc,v_tot_ht,v_tot_tva,
                      v_fac_datecalcul,v_fac_datelim,v_fac_comment,0,0,0,0,0,0,
                      0,0,0,0,0,0,0,0,0,0,
                      0,0,0,0,0,0,0,0,
                      0,0,0,0,0,0,0,0,0,
                      0,0,0,0,s1.spt_id,v_g_imp_id,s1.sag_id,s1.par_id,s1.adr_id,v_org_id,v_vow_agrbilltype,v_g_vow_debtype,
                      v_g_vow_settlemode_a,v_g_vow_modefact,v_run_id,s1.aco_id);  
      
      
      for s2 in c2(s1.bil_id)loop
        insert into genbilline(bil_id,bli_number,bli_name,bli_exercice,ite_id,pta_id,psl_rank,
                               bli_volumebase,bli_volumefact,bli_puht,tva_id,bli_mht,bli_mttva,bli_mttc,bli_startdt,
                               bli_enddt,vow_unit,bli_updtby,meu_id)
                        values(v_bil_id,s2.bli_number,s2.bli_name,s2.bli_exercice,s2.ite_id,s2.pta_id,s2.psl_rank,
                               s2.bli_volumebase,s2.bli_volumebase,s2.bli_puht,s2.tva_id,s2.bli_mht,s2.bli_mttva,s2.bli_mttc,v_fac_datecalcul,
                               v_fac_datecalcul,s2.vow_unit,v_g_age_id,v_g_meu_id);
      end loop; 
    else
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
      MigrationFacture(p_pk_etape,p_pk_exception,v_bil_id,v_deb_id,s1.periode,s1.annee,v_ref_facture,v_tot_ttc,v_tot_ht,v_tot_tva,
                       v_fac_datecalcul,v_fac_datelim,v_fac_comment,null,null,null,null,null,null,
                       null,null,null,null,null,null,null,null,null,null,
                       null,null,null,null,null,null,null,null,
                       null,null,null,null,null,null,null,null,null,
                       null,null,null,null,s1.spt_id,v_g_imp_id,s1.sag_id,s1.par_id,s1.adr_id,v_org_id,v_vow_agrbilltype,v_g_vow_debtype,
                       v_g_vow_settlemode_a,v_g_vow_modefact,v_run_id,s1.aco_id); 
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
     select lpad(trim(f.district),2,'0') district,lpad(trim(f.police),5,'0') police,lpad(trim(f.tournee),3,'0') tourne,
             lpad(trim(f.ordre),3,'0') ordre ,f.annee,f.periode,f.net,f.rowid,(f.net-f.mtonas) reprise_s,f.mtonas reprise_o,
             b.spt_id,b.sag_id,b.par_id,b.aco_id,b.adr_id
     from  test.src_impayee f
      left join  test.branchement b 
      on   lpad(trim(b.district),2,'0')= lpad(trim(f.district),2,'0')
      and  lpad(trim(b.tourne),3,'0')  = lpad(trim(f.tournee),3,'0')   
      and  lpad(trim(b.ordre),3,'0')   = lpad(trim(f.ordre),3,'0') 
      and  lpad(trim(b.police),5,'0')  = lpad(trim(f.police),3,'0')
      and b.spt_id is not null
      and b.equ_id is not null 
      and b.mtc_id is not null
      and b.sag_id is not null 
     where  f.bil_id is null;
  
   v_org_id number;
   v_bil_id number;
   v_deb_id number;
   v_tva    number;
   v_tothta number;
   v_tottvaa number;
   v_tothte number;
   v_tot_ttc number(25,10);
   v_tot_ht  number(25,10);
   v_tot_tva number(25,10);
   v_vow_agrbilltype number;
   v_fac_datecalcul date;
   v_fac_datelim    date;
   v_ref_facture   varchar2(100);
   v_fac_comment  varchar2(100);
   p_pk_etape     varchar2(400);
   p_pk_exception varchar2(400);
  BEGIN
    for s1 in c1 loop
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
    MigrationFacture(p_pk_etape,p_pk_exception,v_bil_id,v_deb_id,s1.periode,s1.annee,v_ref_facture,v_tot_ttc,v_tot_ht,v_tot_tva,
                    v_fac_datecalcul,v_fac_datelim,v_fac_comment,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,
                    0,0,s1.reprise_s,s1.reprise_o,s1.spt_id,v_g_imp_id,s1.sag_id,s1.par_id,s1.adr_id,v_org_id,v_g_vow_agrbilltype,v_g_vow_debtype,
                    v_g_vow_settlemode_a,v_g_vow_modefact,null,s1.aco_id);                    
                                            
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
  END;   */     
end PK_MIGRATION;
/
