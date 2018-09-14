CREATE OR REPLACE PACKAGE BODY PK_MIGRATION
AS
v_g_coy_id number := 1;
v_g_age_id number := 0;
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
v_g_equstatus_id number := 2777;
v_g_vow_model_id number := 5841;
v_g_eqy_id number := 1;
v_g_vow_manufact_id number := 4414;
v_g_vow_owner_id number := 4413;
v_g_meu_id number := 5;
v_g_vow_diam_id number := 5838;
v_g_vow_class_id number := 3582;
v_g_mtc_id number := 1116540;
v_g_mmo_id number := 7724799;
v_g_vow_methpos number := 4459;
v_g_vow_methdep number := 4461;
v_g_vow_reaspose number := 4889;
v_g_vow_reasdepose number := 5561;
v_g_vow_usgsag_id number := 4800;
v_g_vow_cutagree_id number := 4103;
v_g_ctt_id number := 1;
v_vow_agrcontacttp_a number := 2574;
v_vow_agrcontacttp_p number := 4848;
v_vow_partytp_a number := 2887;

-------------------------------------------------------------------------------------------
-------------------------------------------------------------------------------------------
PROCEDURE MigrationAdresse
  (
    p_pk_etape out varchar2,
    p_pk_exception out varchar2,
    p_adr_id out number,
    p_adresse in varchar2
    p_code_postal in number
  )
  IS
    v_twn_id number;
    v_ville_name varchar2(4000);
    v_str_id number;
    v_adr_id number;
    
  BEGIN
    --Ville existante?
    p_pk_etape := 'Recherche/Creation ville';
    select max(twn_id)
    into   v_twn_id
    from   gentown
    where  twn_code = s1.code_postal;
    
    --Creation ville sil nexiste pas
    if(v_twn_id is null)then
       select p.libelle
       into   v_ville_name
       from   r_cpostal p
       where  to_char(p.kcpost) = trim(s1.code_postal)         
      
       select seq_gentown.nextval into v_twn_id from dual;
       insert into gentown(twn_id, twn_code, twn_name, twn_namek, twn_zipcode, coy_id, twn_served, twn_updtby)
                    values(v_twn_id, p_code_postal,v_ville_name,v_ville_name,p_code_postal,v_g_coy_id, 1, v_g_age_id);         
    end if;
    --Creation rue
    p_pk_etape := 'Creation rue';
    select seq_genstreet.nextval into v_str_id from dual;
      insert into genstreet(str_id, str_name, str_namek, str_namer, twn_id, vow_streettp, str_zipcode, str_served, str_updtby)
                     values(v_str_id, p_adresse, p_adresse, p_adresse, v_twn_id, v_vow_streettp, s1.code_postal, 1, v_g_age_id);
     
    --Creation adresse
    p_pk_etape := 'Creation adresse client';               
    select genadress.nextval into p_adr_id from dual;
    insert into genadress(adr_id, str_id,,adr_zipcode, adr_updtby)
                   values(p_adr_id, v_str_id, p_code_postal, v_g_age_id);
  
  END;
--------------------------------------------------------------------------------------------------------------------
--------------------------------------------------------------------------------------------------------------------
PROCEDURE MigrationClient
  (
    p_pk_etape out varchar2,
    p_pk_exception out varchar2,
    p_par_id out number,
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
    v_pk_etape varchar2(4000);
    v_vow_typsag number;
    v_code_cli varchar2(100);
    v_adr_id number;
    v_nbre number;
    
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
       where trim(a.categorie_actuel) = trim(s1.categorie)
       and trim(a.client_actuel) = trim(s1.code)
       and a.district = s1.district
       and a.adresse is not null;        
    else
      v_code_postal := p_code_postal;
      v_adresse := p_adresse;
    end if;
    
    if(v_adresse is null or v_code_postal is null)then
      p_pk_etape := 'Probleme de recuperation de l''adresse ou le code postal du client '  || ;
    else
      MigrationAdresse(p_pk_etape,v_adr_id,v_adresse,v_code_postal);
    end if;
    
    p_pk_etape := 'Selection de la cartégorie client'; 
    select vow_id
    into   v_vow_typsag
    from   v_genvocword
    where  voc_code = 'VOW_TYPSAG'    
    and    vow.vow_code = decode(lpad(trim(p_categorie),2,'0'),'01','01','02','02','03','03','04','04','08','08','01');  
    
    if(v_vow_typsag is null)then
      p_pk_etape := 'Impossible de trouvre la categorie du client ' || ; 
    else
      v_pk_etape := 'creation du client client';
      select seq_genparty.nextval into p_par_id from dual;
      insert into genparty(par_id,par_refe,par_lname,par_kname,vow_title,adr_id,par_telw,par_telp,par_telf,
                           vow_typsag,vow_partytp, par_status, par_profexotva, par_search, par_updtby)
                    values(v_par_id,p_code_cli,trim(p_nom),trim(replace(p_nom,' ','')),v_g_vow_title,v_adr_id,trim(p_tel),trim(p_autre_tel),trim(p_fax),
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
    p_rou_id out number;
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
  v_pre_id number;
  v_spt_id number
  v_dpr_id number;
  v_spo_id number;
  v_sps_id number;
  v_cnn_id number;
  v_hcs_id number;
  v_nbre_pdl number;
  v_rou_id number;
  v_tiers number;
  v_sixieme number;
  BEGIN
    p_pk_etape := 'PDL existante';

    select max(spt_id)
    into   p_spt_id
    from   tecservicepoint
    where  spt_refe = v_code_br;
    
    if p_spt_id is not null then
      p_pk_exception := 'PDL :'||v_code_br||' existe deja';
      return;
    end if;
    
    MigrationAdresse(p_pk_etape,v_adr_id,p_adresse,p_code_postal);
    p_pk_etape := 'Creation du site/pdl'; 
    if(p_tourne in ('898','899'))then
      BEGIN 
        select rou_id
        into   v_rou_id
        from   tecroute
        where  rou_code=p_district||'_AS';
      EXCEPTION WHEN no_data_found THEN 
        select seq_tecroute.nextval into v_rou_id from dual;
        insert into tecroute(rou_id,rou_sect,rou_code,rou_name,rou_updtby)
                values(v_rou_id,p_dvt_id,p_district||'_AS',p_district||'_AS', v_g_age_id);
      END;
    else
      BEGIN 
        select rou_id
        into   v_rou_id
        from   tecroute
        where  rou_code = p_district||'-'p_tournee;
      EXCEPTION WHEN OTHERS THEN 
        select t.ntiers,t.nsixieme
        into   v_tiers,v_sixieme 
        from   test.tourne t
        where  lpad(trim(t.code),3,'0') = p_tournee;
        select seq_tecroute.nextval into v_rou_id from dual;
        insert into tecroute(rou_id,rou_sect,rou_code,rou_name,rou_updtby)
                values(v_rou_id,p_dvt_id,p_district||'-'p_tournee,p_tournee,v_g_age_id);
                
        insert into tecroucut(rou_id,rcu_third,rcu_sixth,rcu_monthly)
                       values(v_rou_id,v_tiers,v_sixieme,decode(v_tiers,0,1,0);
      END;
    end if;
    v_code_br := p_district||p_tourne||p_ordre||p_police;
    select seq_tecpremise.nextval into p_pre_id from dual;
    insert into tecpremise(pre_id,pre_refe,adr_id,vow_premisetp,pre_updtby)
                    values(p_pre_id,v_code_br,v_adr_id,v_g_vow_premisetp,v_g_age_id);
    
    select seq_tecservicepoint.nextval into v_spt_id from dual;
    insert into tecservicepoint(spt_id,spt_refe,pre_id,rou_id,fld_id,adr_id,spt_updtby,ctt_id)
                           values(v_spt_id,v_code_br,v_pre_id,v_rou_id,v_g_fld_id,v_adr_id,v_g_age_id,v_g_ctt_id);
    
    p_pk_etape := 'Creation du proprietaire site'; 
    select seq_tecpresptcontact.nextval into v_psc_id from dual;
    insert into tecpresptcontact(psc_id,pre_id,par_id,vow_precontacttp,psc_startdt,psc_enddt,psc_rank,psc_updtby)
                          values(v_psc_id, v_pre_id,p_par_id,v_g_vow_precontacttp_id, p_date_creation, decode(s2.etat_branchement, '0', Null, p_date_resil), 1, v_g_age_id);
    
    select seq_tecpresptcontact.nextval into v_psc_id from dual;
    insert into tecpresptcontact(psc_id,pre_id,spt_id,par_id,vow_precontacttp,psc_startdt,psc_enddt,psc_rank,psc_updtby)
                          values(v_psc_id,v_pre_id,v_spt_id,p_par_id,v_g_vow_precontacttp_id, p_date_creation, decode(s2.etat_branchement, '0', Null, p_date_resil), 2, v_g_age_id);
    
    p_pk_etape := 'Creation du organisation spt'; 
    select seq_tecsptorg.nextval into v_spo_id from dual;
      insert into tecsptorg(spo_id,spt_id,org_id,spo_updtby)
                     values(v_spo_id,v_spt_id,p_org_id,v_g_age_id);
    
    p_pk_etape := 'Creation du secteur spt';  
    select seq_gendivspt.nextval into v_dpr_id from dual;
    insert into gendivspt(dpr_id,dvt_id,spt_id,dpr_updtby)
                   values(v_dpr_id,p_dvt_id,v_spt_id,v_g_age_id);
                   
    p_pk_etape := 'Creation du etat PDL';  
    select seq_tecspstatus.nextval into v_sps_id from dual;
    insert into tecspstatus(sps_id,spt_id,vow_spstatus,sps_startdt,sps_enddt,sps_updtby,sps_comment)
                     values(v_sps_id,v_spt_id,decode(p_date_resil,null,v_g_vow_spstatus_actif,v_g_vow_spstatus_res),
                            p_date_creation,null,v_g_age_id,'MIGRATION');
    
    v_pk_etape := 'Création de liaison PDL /BRA';
    select seq_tecconnection.nextval into v_cnn_id from dual;
    insert into tecconnection(cnn_id, cnn_refe, adr_id, fld_id, cnn_startdt, cnn_updtby)
                        values(v_cnn_id, v_code_br, v_adr_id, v_g_fld_id, p_date_creation,v_g_age_id);
    select seq_techconspt.nextval into v_hcs_id from dual;
    insert into TECHCONSPT(hcs_id, spt_id, con_id, hcs_startdt)
    values(v_hcs_id, v_spt_id, v_con_id, p_date_creation, v_g_age_id);
    
    v_pk_etape := 'Création du PDL EAU';
    insert into tecsptwater(spt_id, swa_updtby)
                     values(v_spt_id, v_g_age_id);
    
    p_rou_id := v_rou_id;           
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
      and    trim(r.codemarque)!='000')
      order by to_number(r.annee) desc, to_number(r.trim);
  
    v_diam_compt varchar2(10);
    v_anne_fabric number;
    v_class varchar2(10);
    v_nbr_roues number;
    v_vow_model number;
    v_mmo_id number;
    v_mtc_id number;
    v_vow_diam number;
    v_vow_class number;
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
          v_diam_compt := s1.diamctr
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
        and     lpad(trim(m.code_marque),3,'0') = p_code_marque
        and     rownum  = 1;
      exception when no_data_found then 
        v_class := 0;
      end;
      
      p_pk_etape := 'Recuperation du nombre de roues';
      -- Classe 100
      if    p_code_marque = '101' then v_nbr_roues := 0;
      elsif p_code_marque = '102' then v_nbr_roues := 4;
      elsif p_code_marque = '103' then v_nbr_roues := 4;
      elsif p_code_marque = '104' and v_voc_diam = '15' then v_nbr_roues := 4;
      elsif p_code_marque = '104' and v_voc_diam = '40' then v_nbr_roues := 5;
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
      elsif p_code_marque = '115' and v_voc_diam = '15' then v_nbr_roues := 4;
      elsif p_code_marque = '115' and v_voc_diam = '30' then v_nbr_roues := 5;
      elsif p_code_marque = '116' then v_nbr_roues := 5;
      elsif p_code_marque = '117' then v_nbr_roues := 5;
      elsif p_code_marque = '118' then v_nbr_roues := 6;
      elsif p_code_marque = '120' then v_nbr_roues := 4;
      elsif p_code_marque = '121' then v_nbr_roues := 4;
      -- Classe 200
      elsif p_code_marque = '201' then v_nbr_roues := 4;
      elsif p_code_marque = '202' then v_nbr_roues := 4;
      elsif p_code_marque = '203' and v_voc_diam = '15' then v_nbr_roues := 4;
      elsif p_code_marque = '203' and v_voc_diam = '40' then v_nbr_roues := 5;
      elsif p_code_marque = '203' and to_number(v_voc_diam) > 40 then v_nbr_roues := 6;
      elsif p_code_marque = '204' then v_nbr_roues := 4;
      elsif p_code_marque = '205' then v_nbr_roues := 4;
      elsif p_code_marque = '206' then v_nbr_roues := 4;
      elsif p_code_marque = '207' and v_voc_diam = '15' then v_nbr_roues := 4;
      elsif p_code_marque = '207' and v_voc_diam = '20' then v_nbr_roues := 4;
      elsif p_code_marque = '207' and v_voc_diam = '40' then v_nbr_roues := 5;
      elsif p_code_marque = '208' then v_nbr_roues := 4;
      elsif p_code_marque = '210' then v_nbr_roues := 5;
      elsif p_code_marque = '211' then v_nbr_roues := 6;
      elsif p_code_marque = '212' then v_nbr_roues := 5;
      -- Classe 300
      elsif v_code_marque = '306' then v_nbr_roues := 4;
      elsif v_code_marque = '310' then v_nbr_roues := 4;
      else  v_nbr_roues:=4; 
      end if;
      
      p_pk_etape := 'Recuperation du modele du compteur';
      begin
        select vow.vow_id
        into   v_vow_model
        from   genvoc     voc,
               genvocword vow
        where  voc.voc_id = vow.voc_id
        and    vow.vow_code     = p_code_marque
        and    voc.voc_code     = 'VOW_MODEL';
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
        select mtc.mtc_id)
        into   v_mtc_id
        from   tecmtrcfg mtc,
               tecmtrcfgdetail mcd
        where  mtc.vow_model    = v_vow_model
        and    mtc.vow_manufact = v_g_vow_manufact_id
        and    mtc.mtc_id       = mcd.mtc_id
        and    mcd.meu_id       = v_g_meu_id
        and    mcd.mcd_wheel    = v_nbr_roues;
      exception when no_data_found then
        select seq_tecmtrcfg.nextval into v_mtc_id from dual;
        insert into tecmtrcfg(mtc_id, mtc_code, mtc_name, vow_manufact, vow_model, fld_id,mtc_updtby)
               values(v_mtc_id, p_code_marque || '- X' || v_nbr_roues, p_code_marque || '- X' || v_nbr_roues, v_g_vow_manufact_id, v_vow_model, v_g_fld_id,v_g_age_id);
        select seq_tecmtrcfgdetail.nextval into v_mcd_id from dual;
        insert into tecmtrcfgdetail(mcd_id, mcd_num, mtc_id, meu_id, mcd_wheel, mcd_coeff)
                   values(v_mcd_id,1, v_mtc_id, v_g_meu_id, v_nbr_roues, 1);
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
        and    upper(vow.vow_code) = v_voc_class
        and    voc.voc_code        = 'VOW_CLASS';
      exception when no_data_found then
        v_vow_class := v_g_vow_class_id;
      end;
      
      p_pk_etape := 'Creatin du compteur';
      select seq_tecequipment.nextval into p_equ_id from dual;
      insert into tecequipment(equ_id,equ_realnumber,equ_serialnumber,vow_equstatus,equ_year,eqy_id,mmo_id,vow_owner,equ_updtby)
                        values(v_equ_id,p_compteur_actuel,p_compteur_actuel,v_g_vow_equstatus_id,v_anne_fabric,v_g_eqy_id,v_g_vow_owner_id,v_g_age_id);
      
      insert into tecmeter(equ_id, mtc_id) values(v_equ_id, v_mtc_id);
      
      insert into tecmtrwater(equ_id, vow_diam, vow_class, mwa_updtby)
                   values(v_equ_id, v_vow_diam, v_vow_class, v_g_age_id);
    
    else
      select seq_tecequipment.nextval into p_equ_id from dual;
      p_compteur_actuel := p_district||'MIG'||lpad(p_equ_id,11,'0');
      v_anne_fabric := 1900;
      insert into tecequipment(equ_id,equ_realnumber,equ_serialnumber,vow_equstatus,equ_year,eqy_id,mmo_id,vow_owner,equ_updtby)
                        values(v_equ_id,p_compteur_actuel,p_compteur_actuel,v_g_vow_equstatus_id,v_anne_fabric,v_g_eqy_id,v_g_vow_owner_id,v_g_age_id);
      
      insert into tecmeter(equ_id, mtc_id) values(v_equ_id, v_g_mtc_id);
      
      insert into tecmtrwater(equ_id, vow_diam, vow_class, mwa_updtby)
                   values(v_equ_id, v_g_vow_diam, v_g_vow_class, v_g_age_id);
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
    p_compteur_actuel in out varchar2,
    p_code_marque in out varchar2
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
      select lpad(trim(b.codemarque),3,'0') code_marque ,lpad(trim(b.ncompteur),11,'0') compteur_actuel
      from   test.fiche_releve r
      where  lpad(trim(r.district),2,'0') = p_district 
      and    lpad(trim(r.tourne),3,'0') = p_tourne 
      and    lpad(trim(r.ordre),3,'0') = p_ordre
      and    trim(r.ncompteur) is not null 
      and    trim(r.codemarque)!='000')
      order by to_number(r.annee) desc, to_number(r.trim) desc;
      
    
    cursor c2
    is
      select lpad(trim(c.code_marque),3,'0') code_marque, lpad(trim(c.num_compteur),11,'0') compteur_actuel
      from   gestion_compteur c
      where  lpad(trim(c.district),2,'0') = p_district 
      and    lpad(trim(c.tourne),3,'0') = p_tourne 
      and    lpad(trim(c.ordre),3,'0') = p_ordre
      and    trim(c.num_compteur) is not null ;
      order by to_number(c.annee) desc, to_number(b.trim);
    
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
          p_code_marque := s2.code_marque;
          p_compteur_actuel := s2.compteur_actuel;
        end if;
      end if;
    end if;
    p_pk_etape := 'Creation du compteur';
    MigrationCompteur(p_pk_etape,p_pk_exceptio,p_equ_id,p_district,p_tourne,p_ordre,p_compteur_actuel,p_code_marque);
    
    p_pk_etape := 'Pose/Depose compteur';
    select seq_techequipment.nextval into v_heq_id from dual;
    insert into techequipment(heq_id,equ_id,spt_id,age_pose,age_depose,vow_methpos,vow_methdep,vow_reaspose,vow_reasdepose,
                              heq_startdt,heq_enddt,heq_updtby)
                       values(v_heq_id,p_equ_id,v_spt_id,v_g_age_id,decode(p_date_resil,null,null,v_g_age_id),v_g_vow_methpos,
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
    p_district in varchar2,
    p_tourne in varchar2,
    p_ordre in varchar2,
    p_police in varchar2, 
    p_date_creation date,
    p_date_resil date,
    p_gros_consom varchar2,
    p_usage varchar2,
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
    v_sag_id number;
    v_grf_id number;
    v_grf_code varchar2(10);
    v_vow_usgsag number;
    v_cot_id number;
    v_adr_fs varchar2
    v_code_p_fs varchar2;
    v_adr_fs_id number;
    v_paa_id number;
    v_pay_id number;
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
      where  substr(cag_refe,0,2) = p_district
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
      select p_district||decode(trim(t.ntiers),0,'M',trim(t.ntiers)||trim(t.nsixieme)
      into   v_grf_code
      from   test.tourne t
      where  lpad(trim(t.district),2,'0') = p_district
      and    lpad(trim(t.code),3,'0') = p_tournee;
      
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
    select seq_agrserviceagr.nextval into v_sag_id from dual;
    insert into agrserviceagr(sag_id,sag_refe,sag_startdt,sag_enddt,cag_id,spt_id,grf_id,ctt_id,
                              vow_cutagree,vow_usgsag,sag_updtby)
                       values(v_sag_id,v_cag_refe,p_date_creation,p_date_resil,v_cag_id,p_spt_id,v_grf_id,v_g_ctt_id,
                              v_g_vow_cutagree_id,v_vow_usgsag,v_g_age_id);
                              
    p_pk_etape := 'Creation abonne';
    select seq_agrcustagrcontact.nextval into v_cot_id from dual;
    insert into agrcustagrcontact(cot_id,cag_id,sag_id,par_id,cot_startdt,cot_enddt,vow_agrcontacttp,cot_rank,cot_updtby)
                           values(v_cot_id,v_cag_id,v_sag_id,p_par_id,p_date_creation,p_date_resil,v_vow_agrcontacttp_a,1,v_g_age_id);     
                               
    
    p_pk_etape := 'Adresse de faire suivre';
    select max(decode(adr1,null,decode(adr2,null,adr3,adr2),adr1)), max(codpostal)
    into   v_adr_fs,v_code_p_fs
    from
    (
      select dist,pol,tou,ord,adr1,adr2,adr3,codpostal from test.abn_trimcat7
      union
      select dist,pol,tou,ord,ad1 adr1,ad2 adr2,ad3 adr3, codpostal from test.abn_gccat7
    )
    where  lpad(trim(dist),2,'0') = p_district
    and    lpad(trim(pol),5,'0') = p_police
    and    lpad(trim(tou),3,'0') = p_tournee
    and    lpad(trim(ord),3,'0') = p_ordre;
    
    if v_adr_fs is not null and v_code_p_fs is not null then
      MigrationAdresse(p_pk_etape,p_pk_exception,v_adr_fs_id,v_adr_fs,v_code_p_fs);
    else
      v_adr_fs_id = p_adr_id;
    end if;
    
    select seq_genpartyparty.nextval into v_paa_id from dual;
    insert into genpartyparty(paa_id,par_parent_id,vow_partytp,paa_startdt,paa_enddt,paa_updtby,adr_id)
                       values(v_paa_id,p_par_id,v_vow_partytp_a,p_date_creation,p_date_resil,v_ag_age_id,v_adr_fs_id);
    
    p_pk_etape := 'Creation payeur';                   
    select seq_agrcustagrcontact.nextval into v_cot_id from dual;
    insert into agrcustagrcontact(cot_id,cag_id,sag_id,par_id,cot_startdt,cot_enddt,vow_agrcontacttp,cot_rank,cot_updtby)
                           values(v_cot_id,v_cag_id,v_sag_id,p_par_id,p_date_creation,p_date_resil,v_vow_agrcontacttp_p,2,v_g_age_id); 
    select seq_agrpayor.nextval into v_pay_id from dual;
    insert into agrpayor(pay_id,cot_id,paa_id,pay_updtby)
                  values(v_pay_id,v_cot_id,v_paa_id,v_g_age_id);
 
                               
        
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
      select lpad(trim(district),2,'0') district, lpad(trim(s1.categorie),2,'0') categorie, trim(upper(code)) code, tel, autre_tel, fax, nom, adresse, to_number(code_postal) code_postal, 
             lpad(trim(district),2,'0')||lpad(trim(s1.categorie),2,'0')||trim(upper(code)) code_cli
      from   tes.client
      /*union
      select lpad(to_number((district),2,'0') district, null categorie, code, null tel, null autre_tel, null fax, desig nom, adresse, to_number(code_postal) code_postal,
             lpad(to_number(district),2,'0')||'04'||lpad(trim(s1.code),4,'0') code_cli
      from   tes.adm;*/
    
    --Curseur des branchement actif
    cursor c2(etat varchar2)
    is
     select lpad(trim(b.district)) district, lpad(trim(b.police)) police, lpad(trim((b.tourne),3,'0') tourne, lpad(trim((b.ordre),3,'0') ordre, b.adresse, date_creation,
            lpad(trim(categorie_actuel),2,'0') categorie_actuel, upper(trim(client_actuel) client_actuel, lpad(trim(b.code_marque),3,'0') code_marque, lpad(trim(b.compteur_actuel),11, '0') compteur_actuel, b.code_postal,
            trim(b.usage) usage, b.type_branchement, b.aspect_branchement, b.marche, trim(b.etat_branchement) etat_branchement,
            lpad(trim(district),2,'0')||lpad(trim(categorie_actuel),2,'0')||trim(upper(client_actuel)) code_cli
     from   test.branchement b   
     where  trim(b.etat_branchement) = etat;
    
   
   v_par_refe varchar2(100);   
   v_par_id number;  
   v_date_resil date;
   v_pre_id number;
   v_spt_id number;
   v_rou_id number;
  BEGIN
    --Securite
    if p_param <> 3 then
      return;
    end if;
    
    --Curseur des client et adm
    for s1 in c1 loop
      MigrationClient(v_pk_etape,p_pk_exception,v_par_id,s1.adresse,s1.code_postal,s1.code_cli,s1.categorie,s1.nom,s1.tel,s1.autre_tel,s1.fax);
      commit;
      --// Gerer le v_pk_etape si elle est pleine
    end loop --Curseur client et adm
    
    --Migration des branchement actif
    for s2 in c2('0') loop
      --Selection du Client
      begin
        select par_id)
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
      MigrationSitePdl(v_pk_etape,p_pk_exception,v_pre_id,v_spt_id,v_rou_id,v_par_id,s2.adresse,s2.code_postal,
                       s2.district,s2.tourne,s2.ordre,s1.police,s2.date_creation,v_date_resil,
                       v_dvt_id,v_org_id,s2.etat_branchement);
        
      --Compteur                 
      MigrationCompteurEncours(v_pk_etape,p_pk_exception,s2.compteur_actuel,s2.code_marque,v_spt_id,
                               s2.district,s2.tourne,s2.ordre,s2.date_creation,v_date_resil,s2.usage);
       
      --Contrat                 
      --MigrationAbonnement(
    end loop --Curseur des branchement
  END;
---------------------------------------------------------------------------------------
---------------------------------------------------------------------------------------
end PK_MIGRATION;
