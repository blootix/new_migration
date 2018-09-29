CREATE OR REPLACE PACKAGE PK_MIGRATION
AS

PROCEDURE MigrationQuotidien
  (
    p_pk_etape out varchar2,
    p_pk_exception out varchar2,
    p_param in number default 0
  );

PROCEDURE MigrationDossierEnCours
  (
    p_pk_etape out varchar2,
    p_pk_exception out varchar2,
    p_param in number default 0
  );
  
PROCEDURE MigrationSuppressionGmf
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
v_g_vow_comm1        number := 5741;--anomalie anomalie niche ='00'
v_g_vow_readreason   number:=5843;--'Tournee'
v_g_vow_readcode   	 number;
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
-------------------------------------------------------------------------------------------
-------------------------------------------------------------------------------------------
PROCEDURE MigrationAdresse
  (
    p_pk_etape out varchar2,
    p_pk_exception out varchar2,
    p_adr_id out number,
    p_adresse in varchar2,
    p_code_postal in number
  )
  IS
    v_twn_id number;
    v_ville_name varchar2(4000);
    v_str_id number;

  BEGIN
    --Ville existante?
    p_pk_etape := 'Recherche/Creation ville';
    select max(twn_id)
    into   v_twn_id
    from   gentown
    where  twn_code = p_code_postal;

    --Creation ville sil nexiste pas
    if(v_twn_id is null)then
       select max(p.libelle)
       into   v_ville_name
       from   r_cpostal p
       where  to_char(p.kcpost) = p_code_postal;

       select seq_gentown.nextval into v_twn_id from dual;
       insert into gentown(twn_id, twn_code, twn_name, twn_namek, twn_zipcode, coy_id, twn_served, twn_updtby)
                    values(v_twn_id, p_code_postal,nvl(v_ville_name,p_code_postal),nvl(v_ville_name,p_code_postal),p_code_postal,v_g_coy_id, 1, v_g_age_id);
    end if;
    --Creation rue
    p_pk_etape := 'Creation rue';
    select seq_genstreet.nextval into v_str_id from dual;
      insert into genstreet(str_id, str_name, str_namek, str_namer, twn_id, vow_streettp, str_zipcode, str_served, str_updtby)
                     values(v_str_id, p_adresse, p_adresse, p_adresse, v_twn_id, v_g_vow_streettp, p_code_postal, 1, v_g_age_id);

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
    p_district in varchar2,
    p_code in varchar2,
    p_adresse in varchar2,
    p_code_postal in number,
    p_code_cli in varchar2,
    p_categorie in varchar,
    p_nom in varchar2,
    p_tel in varchar2,
    p_autre_tel in varchar2,
    p_fax in varchar2
  )
  IS
    v_code_postal number;
    v_adresse varchar2(4000);
    v_vow_typsag number;
    v_code_cli varchar2(100);
    v_adr_id number;

  BEGIN
    p_pk_etape := 'Client existant';
    select max(par_id)
    into   p_par_id
    from   genparty
    where  par_refe = v_code_cli;

    if p_par_id is not null then
      p_pk_exception := 'Client :'||v_code_cli||' existe deja';
      return;
    end if;
    p_pk_etape := 'Recherche de l''adresse du client';
    --recuperer adresse branchement si adresse client est null
    if(p_adresse is null)then
       select max(a.code_postal), max(a.adresse)
       into   v_code_postal, v_adresse
       from test.branchement a
       where trim(a.categorie_actuel) = p_categorie
       and trim(a.client_actuel) = p_code
       and a.district = p_district
       and a.adresse is not null;
    else
      v_code_postal := p_code_postal;
      v_adresse := p_adresse;
    end if;

    if(v_adresse is null or v_code_postal is null)then
      p_pk_etape := 'Probleme de recuperation de l''adresse ou le code postal du client '  || p_code_cli;
    else
      MigrationAdresse(p_pk_etape,p_pk_exception,v_adr_id,v_adresse,v_code_postal);
    end if;

    p_pk_etape := 'Selection de la cartégorie client';
    select vow_id
    into   v_vow_typsag
    from   v_genvocword
    where  voc_code = 'VOW_TYPSAG'
    and    vow_code = decode(lpad(trim(p_categorie),2,'0'),'01','01','02','02','03','03','04','04','08','08','01');

    if(v_vow_typsag is null)then
      p_pk_etape := 'Impossible de trouvre la categorie du client ' || p_code_cli;
    else
      p_pk_etape := 'Creation du client client';
      select seq_genparty.nextval into p_par_id from dual;
      insert into genparty(par_id,par_refe,par_lname,par_kname,vow_title,adr_id,par_telw,par_telp,par_telf,
                           vow_typsag,vow_partytp, par_status, par_profexotva, par_search, par_updtby)
                    values(p_par_id,p_code_cli,trim(p_nom),trim(replace(p_nom,' ','')),v_g_vow_title,v_adr_id,trim(p_tel),trim(p_autre_tel),trim(p_fax),
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
    p_adresse in varchar2,
    p_code_postal in number,
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
    p_pk_etape := 'Creation du site/pdl';

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
        from   test.tourne t
        where  lpad(trim(t.code),3,'0') = p_tourne;
        select seq_tecroute.nextval into p_rou_id from dual;
        insert into tecroute(rou_id,rou_sect,rou_code,rou_name,rou_updtby)
                values(p_rou_id,p_dvt_id,p_district||'-'||p_tourne,p_tourne,v_g_age_id);

        insert into tecroucut(rou_id,rcu_third,rcu_sixth,rcu_monthly)
                       values(p_rou_id,v_tiers,v_sixieme,decode(v_tiers,0,1,0));
      END;
    end if;
    
    select seq_tecpremise.nextval into p_pre_id from dual;
    insert into tecpremise(pre_id,pre_refe,adr_id,vow_premisetp,pre_updtby)
                    values(p_pre_id,v_code_br,p_adr_id,v_g_vow_premisetp,v_g_age_id);

    select seq_tecservicepoint.nextval into p_spt_id from dual;
    insert into tecservicepoint(spt_id,spt_refe,pre_id,rou_id,fld_id,adr_id,spt_updtby,ctt_id)
                           values(p_spt_id,v_code_br,p_pre_id,p_rou_id,v_g_fld_id,p_adr_id,v_g_age_id,v_g_ctt_id);
    
    p_pk_etape := 'Creation du proprietaire site';
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
                            p_date_creation,null,v_g_age_id,'MIGRATION');

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

    --p_rou_id := v_rou_id;
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
	
  BEGIN
    if p_compteur_actuel is not null then
      p_pk_etape := 'Recuperation diametre et annee';
      begin
        select trim(c.diam_compteur),c.annee_fabrication
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

      p_pk_etape := 'Creatin du compteur';
      v_equ_year := to_date('01/01/'||v_anne_fabric,'dd/mm/yyyy');
      select seq_tecequipment.nextval into p_equ_id from dual;
      insert into tecequipment(equ_id,equ_realnumber,equ_serialnumber,vow_equstatus,equ_year,eqy_id,mmo_id,vow_owner,equ_updtby)
                        values(p_equ_id,p_compteur_actuel,p_compteur_actuel,v_g_vow_equstatus_id,v_equ_year,v_g_eqy_id,v_mmo_id,v_g_vow_owner_id,v_g_age_id);

      insert into tecmeter(equ_id, mtc_id) values(p_equ_id,p_mtc_id);

      insert into tecmtrwater(equ_id, vow_diam, vow_class, mwa_updtby)
                   values(p_equ_id, v_vow_diam, v_vow_class, v_g_age_id);

    else
      p_pk_etape := 'Creatin du compteur virtuel';
	  p_mtc_id:= 1116540;
      select seq_tecequipment.nextval into p_equ_id from dual;
      v_compteur_actuel_v := p_district||'MIG'||lpad(p_equ_id,11,'0');
      v_anne_fabric := 1900;
      v_equ_year := to_date('01/01/'||v_anne_fabric,'dd/mm/yyyy');
      insert into tecequipment(equ_id,equ_realnumber,equ_serialnumber,vow_equstatus,equ_year,eqy_id,mmo_id,vow_owner,equ_updtby)
                        values(p_equ_id,v_compteur_actuel_v,v_compteur_actuel_v,v_g_vow_equstatus_id,v_equ_year,v_g_mmo_id,v_g_eqy_id,v_g_vow_owner_id,v_g_age_id);

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
      from   test.fiche_releve r
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
      for s1 in c1 loop
        p_code_marque := s1.code_marque;
        p_compteur_actuel := s1.compteur_actuel;
        exit;
      end loop;

      p_pk_etape := 'Recuperation du num compteur depuis la fiche releve';
      if p_compteur_actuel is null then
        for s2 in c2 loop
          --p_code_marque := s2.code_marque;
          --p_compteur_actuel := s2.compteur_actuel;
          exit;
        end loop;
      end if;
    end if;
	
    p_pk_etape := 'Creation du compteur';
    MigrationCompteur(p_pk_etape,p_pk_exception,p_equ_id,p_mtc_id,p_district,p_tourne,p_ordre,p_compteur_actuel,p_code_marque);

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
    v_adr_fs_id number;
    v_paa_id number;
    v_pay_id number;
    v_rec_id number;
    v_dlp_id number;
    v_tarif_onas varchar2(4);
    v_codpoll varchar2(4);
    v_tarif varchar2(4);
    v_echt number;
    v_echr number;
    v_brt number;
    v_echronas number;
    v_echtonas number;
    v_capitonas number;
    v_interonas number;
    v_arrond number;
    v_vow_frqfact number;
    v_sco_id number;
    v_aco_id number;
    v_stl_id number;
    v_vow_settlemode number;
    v_categ number;
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
    v_gros_consom varchar2(4);
  BEGIN
    p_pk_etape := 'Recuperation info depuis abonnees';
    begin
      select upper(substr(tarif_onas,-1,1)),codpoll,lpad(trim(tarif),2,'0'),echt,echr,brt/1000,echronas,
             echtonas,capitonas/1000,interonas/1000,arrond/1000,categ,trim(gros_consommateur)
      into   v_tarif_onas,v_codpoll,v_tarif,v_echt,v_echr,v_brt,v_echronas,
             v_echtonas,v_capitonas,v_interonas,v_arrond,v_categ,v_gros_consom
      from   test.src_abonnees
      where  lpad(trim(dist),2,'0') = p_district
      and    lpad(trim(pol),5,'0') = p_police
      and    lpad(trim(tou),3,'0') = p_tourne
      and    lpad(trim(ord),3,'0') = p_ordre;
    exception when no_data_found then
      p_pk_etape := 'Recuperation info depuis branchement en cas inexistante dans abonnees';
      v_tarif_onas := p_tarif_onas;
      v_codpoll := null;
      v_tarif := p_tarif;
      v_echt := null;
      v_echr := null;
      v_brt := null;
      v_echronas := null;
      v_echtonas := null;
      v_capitonas := null;
      v_interonas := null;
      v_arrond := null;
      v_categ := to_number(p_categorie);
      v_gros_consom := 'N';
      --gerer une exception pour dir qu'il n'ya pas d'info dans abonnees ou double
    end;
    
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
      MigrationAdresse(p_pk_etape,p_pk_exception,v_adr_fs_id,v_adr_fs,v_code_p_fs);
    else
      v_adr_fs_id := p_adr_id;
    end if;

    select seq_genpartyparty.nextval into v_paa_id from dual;
    insert into genpartyparty(paa_id,par_parent_id,vow_partytp,paa_startdt,paa_enddt,paa_updtby,adr_id)
                       values(v_paa_id,p_par_id,v_g_vow_partytp_a,p_date_creation,p_date_resil,v_g_age_id,v_adr_fs_id);

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
    select seq_genaccount.nextval into v_aco_id from dual;
    insert into genaccount(aco_id,par_id,imp_id,rec_id,vow_acotp,aco_status,aco_updtby)
                    values(v_aco_id,p_par_id,v_g_imp_id,v_rec_id,v_g_vow_acotp_id,1,v_g_age_id);
    
    p_pk_etape := 'Affectation du compte client au contrat';
    select seq_agrsagaco.nextval into v_sco_id from dual;
    insert into agrsagaco(sco_id,sco_startdt,sco_enddt,sag_id,aco_id,sco_updtby)
                   values(v_sco_id,p_date_creation,p_date_resil,p_sag_id,v_aco_id,v_g_age_id);
    
    p_pk_etape := 'Creation du planning';
    insert into agrplanningagr(sag_id,vow_frqfact,agp_factday,agp_nextfactdt,vow_modefactnext,agp_updtby)
                        values(p_sag_id,v_vow_frqfact,10,v_g_agp_factday,v_g_vow_modefactnext,v_g_age_id);
    
    
    
    p_pk_etape := 'Coordonnees bancaire';   
    if v_categ = 5 then
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
    end if;
    
    p_pk_etape := 'Ajouter modalite de paiement';
    select seq_agrsettlement.nextval into v_stl_id from dual;
    insert into agrsettlement(stl_id,sag_id,stl_startdt,stl_enddt,vow_settlemode,vow_nbbill,dlp_id,bap_id,stl_updtby)
                       values(v_stl_id,p_sag_id,p_date_creation,p_date_resil,v_vow_settlemode,v_g_vow_nbbill_1,v_dlp_id,v_bap_id,v_g_age_id);
    
    p_pk_etape := 'Selection du tarif SONEDE';
    case 
      when v_tarif = '01' then v_ofr_id := v_g_ofr_01;
      when v_tarif = '03' then v_ofr_id := v_g_ofr_03;
      when v_tarif = '04' then v_ofr_id := v_g_ofr_04;
      when v_tarif = '05' then v_ofr_id := v_g_ofr_05;
      when v_tarif = '06' then v_ofr_id := v_g_ofr_06;
      when v_tarif = '11' then v_ofr_id := v_g_ofr_11;
      when v_tarif = '21' then v_ofr_id := v_g_ofr_21;
      else v_ofr_id := v_g_ofr_mig;
    end case;
    
    p_pk_etape := 'Selection du tarif ONAS';
    case v_tarif_onas
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
    if nvl(v_arrond,0)>0 then
      v_asu_num := v_asu_num + 1;
      select seq_agrsubscription.nextval into v_asu_id from dual;
      insert into agrsubscription(asu_id,asu_num,hsf_id,sag_id,ofr_id,sut_id,asu_startdt,asu_enddt,asu_updtby)
                           values(v_asu_id,v_asu_num,v_hsf_id,p_sag_id,v_ofr_id,v_g_sut_arr,p_date_creation,p_date_resil,v_g_age_id);
      
      select seq_agrsubscriptionvalue.nextval into v_suv_id from dual;
      insert into agrsubscriptionvalue(suv_id,asu_id,suv_value,suv_updtby)
                                values(v_suv_id,v_asu_id,v_arrond,v_g_age_id);                     
    end if;
    
    p_pk_etape := 'Ajouter engagement facilite onas';
    if nvl(v_echtonas,0)>0then
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
                                       decode(sut_id,v_g_sut_echt_onas,v_echtonas,
                                                     v_g_sut_echr_onas,v_echronas,
                                                     v_g_sut_capi_onas,v_capitonas,
                                                     v_g_sut_intr_onas,v_interonas,
                                                     null),
                                       v_g_age_id
                                from   agrsubscription
                                where  sag_id = p_sag_id
                                and    sut_id in (v_g_sut_echt_onas,v_g_sut_echr_onas,v_g_sut_capi_onas,v_g_sut_intr_onas);
    end if;
    
    p_pk_etape := 'Ajouter engagement coef pollution';
    if nvl(v_codpoll,0)>0 then
      v_asu_num := v_asu_num + 5;
      select seq_agrsubscription.nextval into v_asu_id from dual;
      insert into agrsubscription(asu_id,asu_num,hsf_id,sag_id,ofr_id,sut_id,asu_startdt,asu_enddt,asu_updtby)
                           values(v_asu_id,v_asu_num,v_hsf_id,p_sag_id,v_ofr_id,v_g_sut_pol_onas,p_date_creation,p_date_resil,v_g_age_id);
      
      select seq_agrsubscriptionvalue.nextval into v_suv_id from dual;
      insert into agrsubscriptionvalue(suv_id,asu_id,suv_value,suv_updtby)
                                values(v_suv_id,v_asu_id,v_codpoll,v_g_age_id);                     
    end if;
    
    p_pk_etape := 'Ajouter engagement volume puit';
    if nvl(p_vol_puit,0)>0 then
      v_asu_num := v_asu_num + 5;
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
      
    select seq_agrsubscriptionvalue.nextval into v_suv_id from dual;
    insert into agrsubscriptionvalue(suv_id,asu_id,suv_value,suv_updtby)
                              values(v_suv_id,v_asu_id,v_gros_consom,v_g_age_id);                  
  EXCEPTION WHEN OTHERS THEN
   v_g_err_code := SQLCODE;
   v_g_err_msg := SUBSTR(SQLERRM, 1, 200);
   p_pk_exception := v_g_err_code || ' : ' ||  v_g_err_msg;
  END;
--------------------------------------------------------------------------------------------------------------------
--------------------------------------------------------------------------------------------------------------------
procedure MigrationHitoriquereleve
 (
    p_pk_etape     out varchar2,
    p_pk_exception out varchar2,
    p_district     in varchar2,
    p_tourne       in varchar2,
    p_ordre        in varchar2,
    p_equ_id       in number,
    p_mtc_id       in number,
    p_spt_id       in number,
    p_meu_id       in number,
    p_age_id       in number,
    p_vow_readorig in number,
    p_vow_readmeth in number
 )
  IS
  	CURSOR c1 
	is 
	select district,tourne,ordre,annee,trim,releve,prorata,releve2,releve3,releve4,releve5,date_releve,
		   compteurt,consommation,lpad(trim(anomalie),18,0)anomalie,avisforte,message_temporaire,
		   date_controle,index_controle
	from test.fiche_releve a
	where trim(trim) is not null
	and trim(a.annee)>=2015
	and lpad(trim(a.district),2,'0')= p_district
	and lpad(trim(a.tourne),3,'0')  = p_tourne
	and lpad(trim(a.ordre),3,'0')   = p_ordre;
	 
	v_g_vow_comm2        number;
	v_g_vow_comm3        number;
	v_g_vow_readcode     number;
	v_g_vow_readreason   number;
	v_mrd_id           	 number;
	v_mme_deducemanual   number := 0;
	v_mrd_agrtype        number := 0;
	v_mrd_locked         number := 0;
	v_mrd_techtype       number := 0;
  v_mrd_subread        number := 0;
	v_mrd_etatfact       number := 0; 
	v_mrd_usecr          number := 1;
	v_mrd_multicad       number;
	v_mrd_year           number; 
	v_mrd_dt             date;
	v_mois               varchar2(10);
	v_trim               varchar2(10);
	v_dte_rl             varchar2(50);
	v_compteurt          varchar2(50);
	v_mrd_comment        varchar2(100); 
	v_avisforte	         varchar2(100);		
  v_mme_id             number;									   
BEGIN
	p_pk_etape:='Création Historique Réleve Trimestriel';
	for s1 in c1 loop
	    if to_number(s1.prorata)>0 then
			v_mme_deducemanual:=nvl(to_number(trim(s1.consommation)),0)-s1.prorata;
		end if;
		v_mrd_comment :=trim(s1.message_temporaire)||v_avisforte;
		v_mrd_multicad:=to_number(s1.trim);
		v_mrd_year    :=to_number(s1.annee);
		begin
			if to_number(trim(s1.avisforte))>0 then
				v_avisforte:='n°avis forte='||s1.avisforte;
			end if;
		exception when others then
			v_avisforte:=null;
		end;
---------------------------recuperation date releve------------------------
    p_pk_etape:='Recuperation date releve';
		v_dte_rl  :=replace(substr(s1.date_releve,1,instr(replace(replace(s1.date_releve,' ','#'),':','#'),'#')-1),'-','/');
		 
		select p.m3,trim(p.trim)
		into  v_mois,v_trim
		from  test.tourne t, test.param_tournee p
		where t.ntiers  =p.tier
		and   t.nsixieme=p.six
		and   lpad(trim(t.district),2,'0')= lpad(trim(p.district),2,'0')
		and   lpad(trim(t.code),3,'0')    = lpad(trim(s1.tourne),3,'0')
		and   lpad(trim(t.district),2,'0')= lpad(trim(s1.district),2,'0')
		and   trim(p.trim)  = trim(s1.trim);
		begin 
			if (v_mois=12 and v_trim=4) then
			   v_mrd_dt :=to_date('08/'||'01'||'/'||s1.annee+1,'dd/mm/yyyy');
			elsif (v_mois in(1,2,3)and v_trim=4)then 
			   v_mrd_dt:=to_date('08/'||lpad(v_mois+1,2,'0')||'/'||s1.annee+1,'dd/mm/yyyy');
			elsif (v_mois=12) then
			   v_mrd_dt :=to_date('08/'||'01'||'/'||s1.annee,'dd/mm/yyyy');
			else
			   v_mrd_dt:=to_date('08/'||lpad(v_mois+1,2,'0')||'/'||s1.annee,'dd/mm/yyyy');
			end if;	
        exception when others then
		   v_mrd_dt:=v_dte_rl;
		end;		
		
		p_pk_etape := 'Récupération Raison de relève';
		if (trim(s1.date_controle)is null and nvl(trim(s1.index_controle),0)=0) then
			v_g_vow_readreason:=5843;
		else
			v_g_vow_readreason:=4895;
		end if;		 
		
		p_pk_etape := 'Récupération Anomalie fuite';
		select vow.vow_id
		into   v_g_vow_comm2
		from   genvoc     voc,
			   genvocword vow
		where  voc.voc_id   = vow.voc_id
		and    vow.vow_code = substr(s1.anomalie,13,2)
		and    voc.voc_code = 'VOW_COMM2';
		
		p_pk_etape := 'Récupération Anomalie compteur'; 				
		select vow.vow_id
		into   v_g_vow_comm3
		from   genvoc     voc,
			   genvocword vow
		where  voc.voc_id   = vow.voc_id
		and    vow.vow_code = substr(s1.anomalie,1,2)
		and    voc.voc_code = 'VOW_COMM3';
		
    p_pk_etape := 'Ajouter la releve'; 	
		select seq_tecmtrread.nextval into v_mrd_id from dual;
		insert into tecmtrread(mrd_id,equ_id,mtc_id,mrd_dt,spt_id,vow_comm1,vow_comm2,vow_comm3,vow_readcode,
							   vow_readorig,vow_readmeth,vow_readreason,mrd_comment,mrd_locked,mrd_msgbill,mrd_agrtype,mrd_techtype,
							   mrd_subread,mrd_deduction_id,mrd_etatfact,age_id,mrd_usecr,mrd_year,mrd_multicad) 
						values(v_mrd_id,p_equ_id,p_mtc_id,v_mrd_dt,p_spt_id,v_g_vow_comm1,v_g_vow_comm2,v_g_vow_comm3,v_g_vow_readcode,
							   p_vow_readorig,p_vow_readmeth,v_g_vow_readreason,v_mrd_comment,v_mrd_locked,null,v_mrd_agrtype,v_mrd_techtype,
							   v_mrd_subread,null,v_mrd_etatfact,p_age_id,v_mrd_usecr,v_mrd_year,v_mrd_multicad);
    
    p_pk_etape := 'Ajouter index eau'; 
    begin 
      select seq_tecmtrmeasure.nextval into v_mme_id from dual;
      insert into tecmtrmeasure(mme_id,mrd_id,meu_id,mme_num,mme_value,mme_consum,mme_avgconsum,mme_deducemanual)
                        values (v_mme_id,v_mrd_id,v_g_meu_eau,1,to_number(s1.releve),nvl(to_number(trim(s1.consommation)),0),0,v_mme_deducemanual);
    exception when others then
      -------Exception : index releve non numérique
      null;
    end;		

    p_pk_etape := 'Ajouter index tentatif 1'; 
    if (to_number(replace(s1.releve2,'.',0))>0) then
			select seq_tecmtrmeasure.nextval into v_mme_id from dual;
			insert into tecmtrmeasure(mme_id,mrd_id,meu_id,mme_num,mme_value,mme_consum,mme_avgconsum,mme_deducemanual)
							  values (v_mme_id,v_mrd_id,v_g_meu_ten1,2,to_number(replace(s1.releve2,'.',null)),to_number(replace(s1.releve2,'.',null)),0,v_mme_deducemanual);
		end if;				  

    p_pk_etape := 'Ajouter index tentatif 2'; 
    if (to_number(replace(s1.releve3,'.',0))>0) then
			select seq_tecmtrmeasure.nextval into v_mme_id from dual;
			insert into tecmtrmeasure(mme_id,mrd_id,meu_id,mme_num,mme_value,mme_consum,mme_avgconsum,mme_deducemanual)
							  values (v_mme_id,v_mrd_id,v_g_meu_ten2,3,to_number(replace(s1.releve3,'.',null)),to_number(replace(s1.releve3,'.',null)),0,v_mme_deducemanual);
		end if;			
    	  
    p_pk_etape := 'Ajouter index tentatif 3'; 
    if (to_number(replace(s1.releve4,'.',0))>0) then
			select seq_tecmtrmeasure.nextval into v_mme_id from dual;
			insert into tecmtrmeasure(mme_id,mrd_id,meu_id,mme_num,mme_value,mme_consum,mme_avgconsum,mme_deducemanual)
							   values(v_mme_id,v_mrd_id,v_g_meu_ten3,4,to_number(replace(s1.releve4,'.',null)),to_number(replace(s1.releve4,'.',null)),0,v_mme_deducemanual);
		end if;			
    		   
    p_pk_etape := 'Ajouter index tentatif 4'; 
		if (to_number(replace(s1.releve5,'.',0))>0) then
			select seq_tecmtrmeasure.nextval into v_mme_id from dual;
			insert into tecmtrmeasure(mme_id,mrd_id,meu_id,mme_num,mme_value,mme_consum,mme_avgconsum,mme_deducemanual)
							  values (v_mme_id,v_mrd_id,v_g_meu_ten4,5,to_number(replace(s1.releve5,'.',null)),to_number(replace(s1.releve5,'.',null)),0,v_mme_deducemanual);
		end if;					  

    p_pk_etape := 'Ajouter index tentatif 5'; 
		/*if (nvl(to_number(decode(trim(s1.compteurt),'t','1','1','1','0')),0)>0) then
			select seq_tecmtrmeasure.nextval into v_mme_id from dual;
			insert into tecmtrmeasure(mme_id,mrd_id,meu_id,mme_num,mme_value,mme_consum,mme_avgconsum,mme_deducemanual)
							   values(v_mme_id,v_mrd_id,v_g_meu_ten5,6,nvl(to_number(decode(trim(s1.compteurt),'t','1','1','1','0')),0),nvl(to_number(decode(trim(s1.compteurt),'t','1','1','1','0')),0),0,v_mme_deducemanual);
		end if;	 */
          
    p_pk_etape := 'Ajouter index avis forte conso';
    begin
			if (to_number(trim(s1.avisforte))>0) then
				select seq_tecmtrmeasure.nextval into v_mme_id from dual;
				insert into tecmtrmeasure(mme_id,mrd_id,meu_id,mme_num,mme_value,mme_consum,mme_avgconsum,mme_deducemanual)
								   values(v_mme_id,v_mrd_id,v_g_meu_avis,7,to_number(trim(s1.avisforte)),to_number(trim(s1.avisforte)),0,v_mme_deducemanual);
			end if;	
     exception when others then
		     -------Exception : avisforte non numerique
         null;
     end; 		
	   commit;		
	end loop;
EXCEPTION WHEN OTHERS THEN
 v_g_err_code := SQLCODE;
 v_g_err_msg := SUBSTR(SQLERRM,1,200);
 p_pk_exception := v_g_err_code || ' : ' ||  v_g_err_msg;
END;
--------------------------------------------------------------------------------------------------------------------
--------------------------------------------------------------------------------------------------------------------
procedure MigrationDernierreleve
 (
    p_pk_etape       out varchar2,
    p_pk_exception   out varchar2,
    p_district 	     in varchar2,
    p_tourne         in varchar2,
    p_ordre          in varchar2,
    p_equ_id         in number,
    p_mtc_id       	 in number,
    p_spt_id         in number,
    p_meu_id         in number,
    p_age_id         in number,
    p_vow_comm1      in number,
    p_vow_readorig   in number,
    p_vow_readmeth   in number,
    p_vow_readreason in number
  )
  IS
  	CURSOR c1
	is 	
	select decode(annee,0,indexa,indexr) index_releve,a.* 
	from test.releveT a
	where lpad(trim(a.district),2,'0')= p_district
	and   lpad(trim(a.tourne),2,'0')  = p_tourne
	and   lpad(trim(a.ordre),2,'0')   = p_ordre;
	
	v_g_vow_comm2        number;
	v_g_vow_comm3        number;
	v_nbr                number;
	v_mrd_year           number; 
  v_mrd_multicad       number;
	v_mrd_id         	 number;
	v_mrd_agrtype        number := 0;
	v_mrd_locked         number := 0;
	v_mrd_techtype       number := 0;
  v_mrd_subread        number := 0;
	v_mrd_etatfact       number := 0; 
	v_mrd_usecr          number := 1;
	v_mme_deducemanual   number;
	v_mrd_comment        varchar2(100);
  v_trim               varchar2(10);
	v_mois               varchar2(10);
	v_dte_rl             varchar2(50);
	v_mrd_dt             date;	
  v_mme_id             number;
BEGIN
	p_pk_etape:='Création dernier réleve trimestriel';
	for s1 in c1 loop 
		
		v_mrd_year:=replace(to_number(s1.annee),0,to_char(sysdate,'yyyy'));
		if to_number(s1.prorata)>0 then
		  v_mme_deducemanual := nvl(to_number(trim(s1.consommation)),0)-s1.prorata;
		end if;	
		
		select p.m3
		into  v_mois
		from  test.tourne t,test.param_tournee p
		where t.ntiers  =p.tier
		and   t.nsixieme=p.six
		and   lpad(trim(t.district),2,'0')= lpad(trim(p.district),2,'0')
		and   lpad(trim(t.district),2,'0')= lpad(trim(s1.district),2,'0')
		and   lpad(trim(t.code),3,'0')    = lpad(trim(s1.tourne),3,'0')
		and p.trim=v_trim;
		
		select t.mrd_multicad
		into v_trim
        from tecmtrread t
        where t.mrd_year||t.mrd_multicad=(select max(to_number(mrd_year||mrd_multicad))
										  from tecmtrread 
										  where spt_id=p_spt_id)
        and t.spt_id  =p_spt_id
        and t.mrd_year=v_mrd_year;		
		
		if(trim(s1.trimestre)='0')then
			v_mrd_multicad:= v_trim;
	    else
			v_mrd_multicad:= trim(s1.trimestre);
		end if;
		
	    select count(*) 
		into v_nbr
		from tecmtrread t
		where t.spt_id=p_spt_id
		and t.mrd_year=v_mrd_year
		and t.mrd_multicad=v_mrd_multicad;
		
		if v_nbr=1 then	
			update tecmtrmeasure 
			set mme_value=to_number(s1.index_releve),
				mme_consum=nvl(to_number(trim(s1.consommation)),0),
				mme_deducemanual=v_mme_deducemanual
			where mrd_id in (select t.mrd_id
							   from tecmtrread t
							   where t.spt_id=p_spt_id
							   and t.mrd_year=v_mrd_year
							   and t.mrd_multicad=v_mrd_multicad)
			and mme_num=1;	
		else 
			p_pk_etape:='Récupération date relevet';
			v_dte_rl  :=replace(substr(s1.date_releve,1,instr(replace(replace(s1.date_releve,' ','#'),':','#'),'#')-1),'-','/');
			begin 
				if (v_mois=12 and v_trim=4) then
				   v_mrd_dt :=to_date('08/'||'01'||'/'||s1.annee+1,'dd/mm/yyyy');
				elsif (v_mois in(1,2,3)and v_trim=4)then 
				   v_mrd_dt:=to_date('08/'||lpad(v_mois+1,2,'0')||'/'||s1.annee+1,'dd/mm/yyyy');
				elsif (v_mois=12) then
				   v_mrd_dt :=to_date('08/'||'01'||'/'||s1.annee,'dd/mm/yyyy');
				else
				   v_mrd_dt:=to_date('08/'||lpad(v_mois+1,2,'0')||'/'||s1.annee,'dd/mm/yyyy');
				end if;	
			exception when others then
			   v_mrd_dt:=v_dte_rl;
			end;
			select seq_tecmtrread.nextval into v_mrd_id from dual;
			insert into tecmtrread(mrd_id,equ_id,mtc_id,mrd_dt,spt_id,vow_comm1,vow_comm2,vow_comm3,vow_readcode,
			                       vow_readorig,vow_readmeth,vow_readreason,mrd_comment,mrd_locked,mrd_msgbill,mrd_agrtype,mrd_techtype,
								   mrd_subread,mrd_deduction_id,mrd_etatfact,age_id,mrd_usecr,mrd_year,mrd_multicad) 
							values(v_mrd_id,p_equ_id,p_mtc_id,v_mrd_dt,p_spt_id,p_vow_comm1,v_g_vow_comm2,v_g_vow_comm3,v_g_vow_readcode,
							       p_vow_readorig,p_vow_readmeth,p_vow_readreason,v_mrd_comment,v_mrd_locked,null,v_mrd_agrtype,v_mrd_techtype,
								   v_mrd_subread,null,v_mrd_etatfact,p_age_id,v_mrd_usecr,v_mrd_year,v_mrd_multicad);	
			select seq_tecmtrmeasure.nextval into v_mme_id from dual;
			insert into tecmtrmeasure(mme_id,mrd_id,meu_id,mme_num,mme_value,mme_consum,mme_avgconsum,mme_deducemanual)
							   values(v_mme_id,v_mrd_id,p_meu_id,1,to_number(s1.index_releve),nvl(to_number(trim(s1.consommation)),0),0,v_mme_deducemanual);					
		    commit;
		end if;
	end loop;
EXCEPTION WHEN OTHERS THEN
 v_g_err_code := SQLCODE;
 v_g_err_msg := SUBSTR(SQLERRM, 1, 200);
 p_pk_exception := v_g_err_code || ' : ' ||  v_g_err_msg;
END;	
--------------------------------------------------------------------------------------------------------------------
--------------------------------------------------------------------------------------------------------------------
procedure MigrationHitoriquerelevegc
 (
    p_pk_etape       out varchar2,
    p_pk_exception   out varchar2,
    p_district 		 in varchar2,
    p_tourne         in varchar2,
    p_ordre 		 in varchar2,
	p_equ_id 		 in number,
	p_mtc_id 		 in number,
	p_spt_id 		 in number,
	p_meu_id 		 in number,
	p_age_id 		 in number,
	p_vow_readorig   in number,
	p_vow_readmeth   in number,
	p_vow_readreason in number
  )
  IS

	cursor c1 
	is
	select distinct a.nindex,
					a.prorata,
					a.cons,
					a.refc02,
					a.refc01,
					a.dist,
					a.tou,
					a.ord,
					a.pol
	from  test.fich24_gc a,test.relevegc c
	where lpad(trim(a.dist),2,'0') =lpad(trim(c.district),2,'0')
	and   lpad(trim(a.tou) ,3,'0') =lpad(trim(c.tourne),3,'0')
	and   lpad(trim(a.ord) ,3,'0') =lpad(trim(c.ordre),3,'0') 
	and   lpad(trim(a.pol) ,5,'0') =lpad(trim(c.police),5,'0')
	and   lpad(trim(c.district),2,'0')=p_district
	and   lpad(trim(c.tourne),3,'0')=p_tourne
	and   lpad(trim(c.ordre),3,'0') =p_ordre;
	
	cursor c2 (v_annee varchar2,v_trim varchar2)
	is
	select a.code_anomalie
	from  test.listeanomalies_releve a
	where lpad(trim(a.district),2,'0') = p_district
	and   lpad(trim(a.tourne),3,'0')   = p_tourne
	and   lpad(trim(a.ordre),3,'0')    = p_ordre
	and   a.annee                      = v_annee
	and   a.trim                       = v_trim;
	
	v_mrd_multicad       number;
	v_mrd_year           number; 
	v_mme_deducemanual   number;
	v_g_vow_comm1        number;
	v_g_vow_comm2        number;
	v_g_vow_comm3        number;
	v_g_vow_readcode     number;
	v_mrd_id         	 number;
	v_mrd_agrtype        number := 0;
	v_mrd_locked         number := 0;
	v_mrd_techtype       number := 0;
  v_mrd_subread        number := 0;
	v_mrd_etatfact       number := 0; 
	v_mrd_usecr          number := 1;
	v_mrd_comment        varchar2(100);
	v_code_anomalie      varchar2(10);
	v_mrd_dt             date;
	v_mme_id             number;
begin	
	p_pk_etape:='Création historique réleve gros consomateur';
	for s1 in c1 loop	     
		if trim(s1.nindex) is null then
			for s2 in c2('20'||trim(s1.refc02),s1.refc01)loop
				v_code_anomalie := trim(s2.code_anomalie);
			end loop ;
		end if;
		if (to_number(s1.refc01)='12') then
			v_mrd_dt:='08/'||'01/'||'20'||to_char(to_number(trim(s1.refc02))+1);
		else
			v_mrd_dt:='08/'||lpad(s1.refc01+1,2,'0')||'/20'||trim(s1.refc02);
		end if ;
		v_mrd_year        :=to_number('20'||trim(s1.refc02));
		v_mrd_multicad    :=to_number(s1.refc01);
		v_mme_deducemanual:=nvl(to_number(trim(s1.prorata)),0)*-1;
		
		p_pk_etape := 'Récupération Raison de relève';
		select vow.vow_id
		into   v_g_vow_comm1
		from   genvoc     voc,
			   genvocword vow
		where  voc.voc_id   = vow.voc_id
		and    vow.vow_code = v_code_anomalie
		and    voc.voc_code = 'VOW_COMM1';
		  
		select seq_tecmtrread.nextval into v_mrd_id from dual;			
		insert into tecmtrread(mrd_id,equ_id,mtc_id,mrd_dt,spt_id,vow_comm1,vow_comm2,vow_comm3,
		                       vow_readcode,vow_readorig,vow_readmeth,vow_readreason,mrd_comment,mrd_locked,mrd_msgbill,mrd_agrtype,
							   mrd_techtype,mrd_subread,mrd_deduction_id,mrd_etatfact,age_id,mrd_usecr,mrd_year,mrd_multicad) 
						values(v_mrd_id,p_equ_id,p_mtc_id,v_mrd_dt,p_spt_id,v_g_vow_comm1,v_g_vow_comm2,v_g_vow_comm3,
						       v_g_vow_readcode,p_vow_readorig, p_vow_readmeth,p_vow_readreason,v_mrd_comment,v_mrd_locked,null,v_mrd_agrtype,
							   v_mrd_techtype,v_mrd_subread,null,v_mrd_etatfact,p_age_id,v_mrd_usecr,v_mrd_year,v_mrd_multicad);
		
		select seq_tecmtrmeasure.nextval into v_mme_id from dual;
		insert into tecmtrmeasure(mme_id,mrd_id,meu_id,mme_num,mme_value,mme_consum,mme_avgconsum,mme_deducemanual)
						   values(v_mme_id,v_mrd_id,p_meu_id,1,to_number(s1.nindex),nvl(to_number(trim(s1.cons)),0),0,v_mme_deducemanual);
		commit;
	end loop;
EXCEPTION WHEN OTHERS THEN
 v_g_err_code := SQLCODE;
 v_g_err_msg := SUBSTR(SQLERRM, 1, 200);
 p_pk_exception := v_g_err_code || ' : ' ||  v_g_err_msg;
END;
--------------------------------------------------------------------------------------------------------------------
--------------------------------------------------------------------------------------------------------------------
 procedure MigrationRelevegc
 (
    p_pk_etape       out varchar2,
    p_pk_exception   out varchar2,
    p_district       in varchar2,
    p_tourne         in varchar2,
    p_ordre          in varchar2,
    p_equ_id         in number,
    p_mtc_id 	     in number,
    p_spt_id         in number,
    p_meu_id         in number,
    p_age_id         in number,
    p_vow_comm1      in number,
    p_vow_readorig   in number,
    p_vow_readmeth   in number,
    p_vow_readreason in number
  )
  is
	cursor c1 
	is
	select a.* 
	from test.relevegc a 
	where trim(a.mois) is not null
	and lpad(trim(a.district),2,'0')= p_district
	and lpad(trim(a.tourne),3,'0')  = p_tourne
	and lpad(trim(a.ordre),3,'0')   = p_ordre;
  
	cursor c2 (v_annee varchar2,v_trim varchar2)
	is
	select a.code_anomalie
	from  test.listeanomalies_releve a
	where lpad(trim(a.district),2,'0') = p_district
	and   lpad(trim(a.tourne),3,'0')   = p_tourne
	and   lpad(trim(a.ordre),3,'0')    = p_ordre
	and   trim(a.annee)                = v_annee
	and   trim(a.trim)                 = v_trim;
    
  v_mrd_year         number;
  v_mrd_multicad     number;
  v_mme_deducemanual number;
  v_g_vow_comm2      number;
  v_g_vow_comm3      number;
  v_g_vow_readcode   number;
	v_mrd_id           number;
	v_mrd_agrtype      number := 0;
	v_mrd_locked       number := 0;
	v_mrd_techtype     number := 0;
  v_mrd_subread      number := 0;
	v_mrd_etatfact     number := 0; 
	v_mrd_usecr        number := 1;
	v_mrd_dt           date;
	v_mrd_comment      varchar2(100);
	v_code_anomalie    varchar2(10);
  v_vow_comm1        number;
  v_mme_id           number;
	
begin
	p_pk_etape:='Création derniere réleve gros consomateur';
	for s1 in c1 loop
	   	 
		/*if trim(s1.nindex) is null then
			for s2 in c2(trim(s1.annee),trim(s1.mois))loop
				v_code_anomalie := trim(s2.code_anomalie);
			end loop ;
		end if;*/
		v_mrd_dt:=trim(s1.date_releve);
		if to_number(trim(s1.annee))=0 then
			v_mrd_year:=to_number(to_char(sysdate,'yyyy'));
		else
			v_mrd_year:=to_number(trim(s1.annee));
		end if;
		v_mrd_multicad:=to_number(s1.mois);
		if to_number(s1.prorata)> 0 then
		  v_mme_deducemanual := nvl(to_number(trim(s1.consommation)),0)-s1.prorata;
		end if;
		p_pk_etape := 'Récupération Raison de relève';
		select vow.vow_id
		into   v_vow_comm1
		from   genvoc     voc,
			   genvocword vow
		where  voc.voc_id   = vow.voc_id
		and    vow.vow_code = v_code_anomalie
		and    voc.voc_code = 'VOW_COMM1';
			 				
		select seq_tecmtrread.nextval into v_mrd_id from dual;			   
		insert into tecmtrread(mrd_id,equ_id,mtc_id,mrd_dt,spt_id,vow_comm1,vow_comm2,vow_comm3,vow_readcode,vow_readorig,
							   vow_readmeth,vow_readreason,mrd_comment,mrd_locked,mrd_msgbill,mrd_agrtype,mrd_techtype,
							   mrd_subread,mrd_deduction_id,mrd_etatfact,age_id,mrd_usecr,mrd_year,mrd_multicad) 
						values(v_mrd_id,p_equ_id,p_mtc_id,v_mrd_dt,p_spt_id,p_vow_comm1,v_g_vow_comm2,v_g_vow_comm3,v_g_vow_readcode,p_vow_readorig,
							   p_vow_readmeth,p_vow_readreason,v_mrd_comment,v_mrd_locked,null,v_mrd_agrtype,v_mrd_techtype,v_mrd_subread,
							   null,v_mrd_etatfact,p_age_id,v_mrd_usecr,v_mrd_year,v_mrd_multicad);

		select seq_tecmtrmeasure.nextval into v_mme_id from dual;
		insert into tecmtrmeasure(mme_id,mrd_id,meu_id,mme_num,mme_value,mme_consum,mme_avgconsum,mme_deducemanual)
						   values(v_mme_id,v_mrd_id,p_meu_id,1,to_number(s1.indexr),nvl(to_number(trim(s1.consommation)),0),0,v_mme_deducemanual);
		commit;
	end loop;
EXCEPTION WHEN OTHERS THEN
 v_g_err_code := SQLCODE;
 v_g_err_msg := SUBSTR(SQLERRM, 1, 200);
 p_pk_exception := v_g_err_code || ' : ' ||  v_g_err_msg;
END;
--------------------------------------------------------------------------------------------------------------------
--------------------------------------------------------------------------------------------------------------------

PROCEDURE MigrationQuotidien
  (
  p_pk_etape out varchar2,
  p_pk_exception out varchar2,
  p_param in number default 0

  )
  IS
    --Curseur des client et des adm
    cursor c1
    is
      select lpad(trim(district),2,'0') district, lpad(trim(categorie),2,'0') categorie, trim(upper(code)) code, tel, autre_tel, fax, nom, adresse, to_number(code_postal) code_postal,
             lpad(trim(district),2,'0')||lpad(trim(categorie),2,'0')||trim(upper(code)) code_cli
      from   test.client
      /*union
      select lpad(to_number((district),2,'0') district, null categorie, code, null tel, null autre_tel, null fax, desig nom, adresse, to_number(code_postal) code_postal,
             lpad(to_number(district),2,'0')||'04'||lpad(trim(s1.code),4,'0') code_cli
      from   tes.adm*/;

    --Curseur des branchement actif
    cursor c2(etat varchar2)
    is
     select lpad(trim(b.district),2,'0') district, lpad(trim(b.police),5,'0') police, lpad(trim(b.tourne),3,'0') tourne, lpad(trim(b.ordre),3,'0') ordre, b.adresse, b.date_creation,
            lpad(trim(b.categorie_actuel),2,'0') categorie_actuel, upper(trim(b.client_actuel)) client_actuel, lpad(trim(b.code_marque),3,'0') code_marque, lpad(trim(b.compteur_actuel),11, '0') compteur_actuel, b.code_postal,
            trim(b.usage) usage, b.type_branchement, b.aspect_branchement, b.marche, trim(b.etat_branchement) etat_branchement,trim(b.banque) banque,trim(b.agence) agence,trim(b.num_compte) num_compte,
            trim(b.cle_rib) cle_rib,lpad(trim(b.tarif),2,'0') tarif, substr(b.onas,-1,1) tarif_onas,b.volume_puit_onas vol_puit,upper(trim(b.gros_consommateur)) mensu,
            lpad(trim(b.district),2,'0')||lpad(trim(b.categorie_actuel),2,'0')||trim(upper(b.client_actuel)) code_cli
     from   test.branchement b
     where  trim(b.etat_branchement) = etat;
	--Curseur releve precedente 
	cursor c3(f_spt_id number)
	is
    select t.*
    from TECMTRREAD t
    where t.spt_id=f_spt_id
    order by t.MRD_DT;
	---cursor consommations de reférence 
	CURSOR c4 (f_spt_id number)
	is 
	select avg(m.mme_consum) mme_consum,a.sag_id,a.spt_id 
	from TECMTRREAD t,AGRSERVICEAGR a,tecmtrmeasure m
	where t.mrd_id=m.mrd_id
	and   t.spt_id=a.spt_id
	and   t.spt_id=f_spt_id
	group by a.sag_id,a.spt_id;

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
   v_mtc_id number;
   v_aac_id number;
  BEGIN
    --Securite
    if p_param <> 3 then
      return;
    end if;

    --Curseur des client et adm
    for s1 in c1 loop
      MigrationClient(p_pk_etape,p_pk_exception,v_par_id,s1.district,s1.code,s1.adresse,s1.code_postal,s1.code_cli,s1.categorie,s1.nom,s1.tel,s1.autre_tel,s1.fax);
      commit;
      --// Gerer le v_pk_etape si elle est pleine
    end loop; --Curseur client et adm

    --Migration des branchement actif
    for s2 in c2('0') loop
      --Selection du Client
      begin
        select par_id
        into   v_par_id
        from   genparty
        where  par_refe = s2.code_cli;
      exception when no_data_found then
        --Exception : Client introuvable
        continue;
      end;

      --selection secteur
      select max(dvt.dvt_id)
      into   v_dvt_id
      from   gendivision div,
             gendivdit dvt
      where  div.div_code = s2.district
      and    div.div_id = dvt.div_id
      and    dvt.dit_id = v_g_dit_id;

      --selection organisation
      select max(org_id)
      into   v_org_id
      from   genorganization
      where  org_code = s2.district;
	  
	  --selection de la date de resiliation en cas de resilier
      v_date_resil := null;
      /*if s2.etat_branchement='9' and trim(s2.compteur_actuel) is null then
        select max(date_res)
        into   v_date_resil
        from   pivot.branchement_res_max
        where  dist = s2.district
        and    ref_pdl = tournee||ordre;

        if v_date_resil is null then

        end if;
      end if;*/

      --Creation du site/pdl
      MigrationSitePdl(p_pk_etape,p_pk_exception,v_pre_id,v_spt_id,v_rou_id,v_adr_id,v_par_id,s2.adresse,s2.code_postal,
                       s2.district,s2.tourne,s2.ordre,s2.police,s2.date_creation,v_date_resil,
                       v_dvt_id,v_org_id,s2.etat_branchement);

      --Compteur
      MigrationCompteurEncours(p_pk_etape,p_pk_exception,v_equ_id,v_mtc_id,s2.compteur_actuel,s2.code_marque,v_spt_id,
                               s2.district,s2.tourne,s2.ordre,s2.date_creation,v_date_resil);

      --Contrat
      MigrationAbonnement(p_pk_etape,p_pk_exception,v_sag_id,s2.district,s2.tourne,s2.ordre,s2.police,s2.date_creation,v_date_resil,
                          s2.mensu,s2.categorie_actuel,s2.banque,s2.agence,s2.num_compte,s2.cle_rib,s2.usage,s2.tarif,s2.tarif_onas,
                          s2.vol_puit,v_par_id,v_pre_id,v_spt_id,v_rou_id,v_adr_id);
      
      commit;
	  --Releve
	  /*MigrationHitoriquereleve(p_pk_etape,p_pk_exception,s2.district,s2.tourne,s2.ordre,v_equ_id,
	                           v_mtc_id,v_spt_id,v_g_meu_id,v_g_age_id,v_g_vow_readorig,v_g_vow_readmeth);
							   
	  MigrationDernierreleve(p_pk_etape,p_pk_exception,s2.district,s2.tourne,s2.ordre,v_equ_id,
	                         v_mtc_id,v_spt_id,,v_g_meu_id,v_g_age_id,v_g_vow_comm1,v_g_vow_readorig,v_g_vow_readmeth,p_vow_readreason);
							   
	  MigrationHitoriquerelevegc(p_pk_etape,p_pk_exception,s2.district,s2.tourne,s2.ordre,v_equ_id,
	                             v_mtc_id,v_spt_id,v_g_meu_id,v_g_age_id,v_g_vow_readorig,v_g_vow_readmeth,p_vow_readreason);
								 
      MigrationRrelevegc(p_pk_etape,p_pk_exception,s2.district,s2.tourne,s2.ordre,v_equ_id,
	                     v_mtc_id,v_spt_id,v_g_meu_id,v_g_age_id,v_g_vow_comm1,v_g_vow_readorig,v_g_vow_readmeth,p_vow_readreason);
		
		p_pk_etape:='Mise A jour releve precedente MRD_PREVIOUS_ID';				 
	    for s3 in c3(v_spt_id) loop
		
			UPDATE TECMTRREAD t 
			set t.mrd_previous_id=s3.mrd_id
			where t.mrd_id=(select mrd_id 
							from TECMTRREAD 
							where MRD_DT>s3.MRD_DT  
							and spt_id= v_spt_id
							and rownum=1
							)
			and t.spt_id=v_spt_id;
		end loop;	
        p_pk_etape:='Création consommations de reférence'; 
		delete from agravgconsum;
		for s4 in c4(v_spt_id) loop
			select seq_agravgconsum.nextval into v_aac_id from dual;
			insert into agravgconsum(aac_id,sag_id,meu_id,aac_avgconsummrd,aac_avgconsumimp)
							  values(v_aac_id,s4.sag_id,v_g_meu_id,s4.mme_consum,null);
			commit;
		end loop;*/
    end loop; --Curseur des branchement
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
          
          MigrationClient(p_pk_etape,p_pk_exception,v_par_id,lpad(trim(s1.district),2,'0'),trim(upper(s1.CLIENT)),
                          v_adresse,v_cd_ps,v_par_refe,v_categ,v_par_name,v_par_telw,v_par_telm,null);
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
PROCEDURE MigrationSuppressionGmf
  (
    p_pk_etape out varchar2,
    p_pk_exception out varchar2,
    p_param in number default 0
  )
  IS
  
  BEGIN
    --Securite
    if p_param <> 3 then
      return;
    end if;
    update WFLISTITC t set t.par_id=null;
    update WFLISTAGE w set w.age_id=null;
    update WFMETAPE w set w.age_id = null;
    COMMIT;
    
    

    delete from WFTMODFOLDER;
    commit;	
    delete from AGRADDDETAIL;
    commit;
    delete from AGRADDENDUM;
    commit;
    delete from AGRAVGCONSUM;
    commit;
    commit;
    delete from AGRCGHBILL;  
    commit; 
    delete from AGRCUSTAGRCONTACT;  
    commit;
    delete from AGRCUSTOMERAGR;  
    commit;
    delete from AGRHSAGOFR;  
    commit;
    delete from AGRMONTHPAY;  
    commit;
    delete from AGRMONTHPAYSCHED;  
    commit;
    delete from AGRPAYOR;  
    commit;
    delete from AGRPLANNINGAGR;  
    commit;
    delete from AGRSAGACO;  
    commit;
    delete from AGRSAGBUN;  
    commit;
    delete from AGRSERVICEAGR;  
    commit;
    delete from AGRSETTLEMENT;  
    commit;
    delete from AGRSUBSCRIPTION;  
    commit;
    delete from AGRSUBSCRIPTIONVALUE;  
    commit;
    delete from AGRTMPITEBILL;  
    commit;
    delete from AGRTMPTARIF;  
    commit;
    delete from AGRTMPWORBILL;  
    commit;
    delete from BILTMPBILLINGITEM;  
    commit;
    delete from BILTMPCONSUMACO;  
    commit;
    delete from BILTMPLASTBILL;  
    commit;
    delete from BILTMPNEXTMRD;  
    commit;
    delete from BILTMPSAG;  
    commit;
    delete from BILTMPSUBSCRIPTIONVALUE;  
    commit;
    delete from BILTMPTARIF;  
    commit;
    delete from FILTRE_SAV_AGRCONTRATTYPE;  
    commit;
    delete from FILTRE_SAV_GENAGENT;  
    commit;
    delete from FILTRE_SAV_GENPARTY;  
    commit;
    delete from FILTRE_SAV_WFMCONTACT;  
    commit;
    delete from FILTRE_SAV_WFMDOSSIER;  
    commit;
    delete from DEFALCROUTE;
    commit;
    delete from DEFALCROUTEHIST;
    commit;
    delete from GENACCOUNT where aco_status != 1 and par_id not in (select org_id from genorganization);  
    commit;
    delete from GENACTIVERECO;  
    commit;
    delete from GENACTIVERECODETAIL;
    commit;
    delete from GENACTIVITY;
    commit;
    /*
    delete from GENADRESS w where w.adr_id not in (0,98772,100158,100167,157900);
    delete from GENSTREET w where str_id not in (select str_id from genadress);*/
    delete from GENADRESS where adr_id not in (select adr_id from genparty where par_id in (select org_id from genorganization) union select adr_id from genagent);  
    commit;
    delete from GENANOMALY;  
    commit;
    delete from GENAVGCONSUM;  
    commit;
    delete from GENBANKPARTY where bap_id not in (select * from (select NVL(o.bap_credit_id,o.bap_debit_id) bap_id
     from genorganization o union select NVL(o.bap_debit_id,o.bap_credit_id) bap_id
      from genorganization o)
      where bap_id is not null); 
    commit;
    delete from GENBILL;   
    commit;
    delete from GENBUNDLE;  
    commit;
    delete from GENCAD;  
    commit;
    delete from GENCADPRESPT;  
    commit;
    delete from GENCONTEST;  
    commit;
    delete from GENCTRANOMALY;  
    commit;
    delete from GENDATADYN;  
    commit;
    delete from GENDATADYNDFT;  
    commit;
    delete from GENDEBIMP;  
    commit;
    delete from GENDEBREC;  
    commit;
    delete from GENPAYSCHEDBRDETAIL;
    commit;
    delete from GENPAYSCHEDBR;
    commit;
    delete from GENDIVSPT;  
    commit;
    delete from GENDOCISSUE;  
    commit;
    delete from GENFILE;  
    commit;
    delete from GENHCTRL;  
    commit;
    delete from GENHIMPCTT;  
    commit;
    delete from GENHTREATMENT;  
    commit;
    delete from GENHTREATPARAM;  
    commit;
    delete from GENLETTDEBT;  
    commit;
    delete from GENLETTDEBTDETAIL;  
    commit;
    delete from GENNEWS;  
    commit;
    delete from GENPAYSCHEDDETAIL;
    commit;
    delete from GENPAYSCHEDBRDETAIL;
    commit;
    delete from GENPAYSCHEDBR;
    commit;
    delete from GENPAYSCHED;
    commit;
    delete from GENPASDEB;
    commit;
    delete from GENPARTY where par_id not in(select org_id from genorganization 
                                            union 
                        select 1 from dual 
                        union 
                        select par.par_id
                        from  genparty par,
                            genrefext rex, 
                            genrefextdft ref,
                            genvocword vow
                        where par.par_id = rex.rex_idorig 
                        and   ref.ref_id = rex.rex_id
                        and   ref.ref_table = 'GENPARTY'
                        and   ref.ref_column = 'PAR_REFE'
                        and   ref.vow_soft = vow.vow_id 
                        and   vow.vow_code in ('RHUI','REXP'));  
    commit;
    delete from GENPARTYPARTY where par_parent_id not in(select par_id from genparty);  
    commit;
    delete from GENPASDEB;  
    commit;
    delete from GENPAYSCHED;  
    commit;
    delete from GENPAYSCHEDDETAIL;  
    commit;
    delete from GENPROJECT;
    commit;
    delete from GENPROVIDER;
    commit;
    delete from GENREFEXT;  
    commit;
    delete from GENRUN;  
    commit;
    delete from GENRUNAGR;  
    commit;
    delete from GENRUNDETAIL;  
    commit;
    delete from GENRUNDVT;  
    commit;
    delete from GENRUNGRF;   
    commit;
    delete from GENSOCIALSTATUS;  
    commit; 
    delete from GENSTREET where str_id != 0;  
    commit; 
    delete from GENTMPBILLINE;  
    commit;
    delete from GENTMPEDDEBT;  
    commit;
    delete from GENTMPHGED;  
    commit;
    delete from GENTMPITEMTARIF;  
    commit;
    delete from GENTMPSEPA;  
    commit; 
    delete from GENWORKSTATE;  
    commit;
    delete from LIGNE_PLGREL;
    commit;
    delete from LIGNE_PLGRELHIST;
    commit;
    delete from PAYCASHBLI;  
    commit;
    delete from PAYCASHDEBT;  
    commit;
    delete from PAYCASHDESKMOVE;  
    commit;
    delete from PAYCASHDESKSESSION WHERE CSS_ID not in (select css_id from paycashdesk where cah_code = '01');--  CAISSE
    commit;
    delete from PAYCASHIMP;  
    commit;
    delete from PAYCASHING;  
    commit;
    delete from PAYJOURNAL;  
    commit;
    delete from PAYSLIP;  
    commit;
    delete from PLGREL;
    commit;
    delete from PLGRELHIST;
    commit;
    delete from TECCONNECTION;  
    commit;
    delete from TECCONNHIER;
    commit;
    delete from TECDEVICE;
    commit;
    delete from TECEQUIPMENT;  
    commit;
    delete from TECEQUMODEL;  
    commit;
    delete from TECHCONSPT;  
    commit;
    delete from TECHEQUCOM;  
    commit;
    delete from TECHEQUIPMENT;  
    commit;
    delete from TECHEQUMTRCFG;  
    commit;
    delete from TECIMPORTDETAIL;  
    commit;
    delete from TECIMPORTMODEL;  
    commit;
    delete from TECMETER;  
    commit;
    delete from TECMTRELEC;  
    commit;
    delete from TECMTRGAS;  
    commit;
    delete from TECMTRMEASURE;  
    commit;
    delete from TECMTRMEASURECHARGE;  
    commit;
    delete from TECMTRWATER;  
    commit;
    delete from TECMTRWASTE;
    commit;
    delete from TECPLGREL;
    commit;
    delete from TECPLGRELHIST;
    commit;
    delete from TECPREINFOETUDE;
    commit;
    delete from TECPREMISE;  
    commit;
    delete from TECPREMISEHIER;  
    commit;
    delete from TECPREREJECT;  
    commit;
    delete from tecpreinfoetude;
    commit;
    delete from TECPRESPTCONTACT;  
    commit;
    delete from TECREADITEBILL;  
    commit;
    delete from TECROUCUT;  
    commit;
    delete from TECROUFLD;  
    commit;
    delete from TECROUSTR;  
    commit;
    delete from TECROUTE;  
    commit;
    delete from TECROUTEDEFALC;  
    commit;
    delete from TECROUTEDEFALCDETAIL;  
    commit;
    delete from TECROUTELOAD;  
    commit;
    delete from TECROUTELOADDETAIL;  
    commit;
    delete from TECROUTEPLAN;  
    commit;
    delete from TECROUTEUNLOAD;  
    commit;
    delete from TECSERVICEPOINT;  
    commit;
    delete from TECSPSTATUS;  
    commit;
    delete from TECSPTELECTRIC;  
    commit;
    delete from TECSPTGAS;  
    commit;
    delete from TECSPTHIER;  
    commit;
    delete from TECSPTORG;  
    commit;
    delete from TECSPTREJECT;  
    commit;
    delete from TECSPTWASTE;  
    commit;
    delete from TECSPTWATER;  
    commit;
    delete from WFCONDOS where con_id in (select con_id from wfcontact where con_mcon_id is not null);
    commit;
    delete from WFCONTACT where con_mcon_id is not null;
    commit;
    delete from WFDOCTAG;
    commit;
    delete from WFDOCUMENTLIE;
    commit;
    delete from WFDOSSIER where dos_mdos_id is not null;
    commit;
    delete from WFETAPE where dos_id in (select dos_id from WFDOSSIER where dos_mdos_id is not null);
    commit;
    delete from WFFIELD;
    commit;
    delete from WFFIELDARCH;
    commit;
    delete from WFFOLDER;
    commit;
    delete from WFFVALID;
    commit;
    delete from WFFVALIDARCH;
    commit;
    delete from WFHPROCESS where dos_id in (select dos_id from WFDOSSIER where dos_mdos_id is not null);
    commit;
    delete from WFLIST where lst_id in (select lag_id from wfcontact where con_mcon_id is not null
                                        union  
                      select lit_id from wfcontact where con_mcon_id is not null
                      union
                      select lob_id from wfcontact where con_mcon_id is not null
                      union
                      select lag_id from wfdossier where dos_mdos_id is not null
                                        union  
                      select lit_id from wfdossier where dos_mdos_id is not null
                      union
                      select lob_id from wfdossier where dos_mdos_id is not null);
    commit;
    delete from WFLISTAGE where lag_id in (select lag_id from wfcontact where con_mcon_id is not null
                         union
                         select lag_id from wfdossier where dos_mdos_id is not null);
    commit;
    delete from WFLISTITC where lit_id in (select lit_id from wfcontact where con_mcon_id is not null
                         union
                         select lit_id from wfdossier where dos_mdos_id is not null);
    commit;
    delete from WFLISTOBJECT where lob_id in (select lob_id from wfcontact where con_mcon_id is not null
                            union
                            select lob_id from wfdossier where dos_mdos_id is not null);
    commit;
    delete from WFLOTDEDEPENDANCE;
    commit;
    delete from WFMOTIF;
    commit;
    delete from WFSCREAN;
    commit;
    delete from WFSCREANARCH;
    commit;
    delete from WFSTEP;
    commit;
    delete from WFTAFFECTATION;
    commit;
    delete from WFTASSISTANT;
    commit;
    delete from WFTCONDITION;
    commit;
    delete from WFTCOURRIER;
    commit;
    delete from WFTDEMANDE;
    commit;
    delete from WFTIMPRESSION;
    commit;
    delete from WFTINTERVENTION;
    commit;
    delete from WFTITERATIF;
    commit;
    delete from WFTOBJETMETIER;
    commit;
    delete from WFTROLLBACK;
    commit;
    delete from WFTTRAITEMENT;
    commit;
    delete from WFTTRAVAUX;
    commit;
    delete from WORASSIGNMENT;  
    commit;
    delete from WORBILL;  
    commit;
    delete from WORBILLINTERV;
    commit;
    delete from WORLINEQUOTATION;  
    commit;
    delete from WORQUOTATION;  
    commit;
    delete from WORREPORTORDER;   
    commit;
    delete from WORTEMPJER;  
    commit;
    delete from WORWOPLAN;
    commit;
    delete from WORWORKORDER;  
    commit;
    delete from WORWORKSHEET;  
    commit;
    delete from WORWORKSHEETITEM;  
    commit;
  END;
end PK_MIGRATION;
/
