declare
  v_adresse          varchar2(4000);
  v_code_postal      varchar2(400);
  v_ville_name       varchar2(400);
  v_code_cli         varchar2(400);
  v_code_br          varchar2(400);
  v_police           varchar2(400); --
  -------
  v_pk_etape         varchar2(400);
  v_age_id           number := 0;
  v_twn_id           number;
  v_coy_id           number := 1;
  v_str_id           number;
  v_vow_streettp     number := 5725;
  v_adr_id           number;
  v_vow_partytp      number := 2884;
  v_vow_title        number := 4101;
  v_vow_typsag       number;
  v_par_id           number;
  v_vow_premisetp    number := 2902;
  v_pre_id           number;
  v_psc_id           number;
  v_vow_precontacttp number := 2890;
  v_rou_id           number;
  v_fld_id           number;
  v_spt_id           number;
  v_sps_id           number;
  v_vow_spstatus     number;
  v_div_id           number;
  v_dvt_id           number;
  v_org_id           number;
  v_spo_id           number;
  v_cnn_id           number;
  v_hcs_id           number;
  v_vow_connat       number;
  v_vow_constatus    number;
  val                number default (0);
  v_rl_cp_num_rl     varchar2(60);
  v_district         varchar2(50);
  v_code_marque      varchar2(50);
  v_compteur_actuel  varchar2(50);
  v_vow_equstatus    number;
  v_voc_model        number;
  v_voc_diam         number;
  v_nbr_roues        number;
  v_annee            number;
  v_equ_techinfo     clob;
  v_vow_manufact     number := 4414;
  v_vow_model        number;
  v_mmo_id           number;
  v_vow_owner        number;
  v_vow_diam         number;
  v_vow_class        number;
  v_heq_id           number;
  v_voc_pose         varchar2(50);
  v_voc_depose       varchar2(50);
  v_vow_reaspose     number;
  v_vow_reasdepose   number;
  v_meu_id           number := 5;
  v_mtc_id           number;
  v_mcd_id           number;
  v_mcd_num          number := 1;
  v_mcd_coeff        number := 1;
  v_aco_id           number;
  v_imp_id           number;
  v_sco_id           number;
  v_paa_id           number;
  v_hsf_id           number;
  v_grf_id           number;
  v_ofr_id           number;
  v_vow_frozen       number;
  v_vow_typdurbill   number;
  v_vow_cutagree     number;
  v_vow_usgsag       number;
  v_vow_typsag       number;
  v_codpoll          varchar2(20);
  v_napt             varchar2(20);
  v_consmoy          varchar2(20);
  v_echtonas         varchar2(20);
  v_echronas         varchar2(20);
  v_capitonas        varchar2(20);
  v_interonas        varchar2(20);
  v_arrond           varchar2(20);
  v_periodicite      varchar2(1);
  v_CODONAS          varchar2(10);
  v_abn_contrat      varchar2(200);
  v_abn_ref          varchar2(200);
  v_date             date;
  v_ctt_id           number := 1;
  v_date_ferm        date;
  v_sag_factmode     number := 0;
  v_sag_frozen       number := 0;
  v_sag_exotva       number := 0;
  v_sag_comment      varchar2(4000) := Null;
  v_cag_id           number;
  v_sag_id           number;
  v_vow_agrcontacttp number;
  v_cot_id           number;
  v_stl_id           number;
  v_vow_settlemode   number;
  v_vow_nbbill       number;
  v_dlp_id           number;
  v_paa_id           number;
  v_pay_id           number;
  v_vow_acotp        number;
  v_vow_frqfact      number;
  v_mrd_id           number;
  v_vow_comm1        number;
  v_vow_comm2        number;
  v_vow_comm3        number;
  v_vow_readorig     number;
  v_vow_readmeth     number;
  v_vow_readreason   number;
  v_mrd_dt           date;
  v_mrd_comment      varchar2(4000);
  v_mrd_locked       number;
  v_mrd_agrtype      number;
  v_mrd_techtype     number;
  v_mrd_subread      number;
  v_mrd_etatfact     number;
  v_age_id           number;
  v_mrd_year         tecmtrread.mrd_year%type;
  v_trimestre        number;
  v_mrd_multicad     number;
  
   --Curseur des client et des adm
   cursor c1
   is
     select 1 tp, district, categorie, code, tel, autre_tel, fax, nom, adresse, code_postal
     from   client
     union
     select 2 tp, district, null categorie, code, null tel, null autre_tel, null fax, desig nom, adresse, to_char(code_postal) code_postal
     from   adm;
     
   cursor c2(categ varchar2, code_client varchar2)
   is
     select trim(b.district) district, trim(b.police) police, trim(b.tourne) tourne, trim(b.ordre) ordre,gros_consommateur, b.adresse, date_creation,
            categorie_actuel, client_actuel, lpad(trim(b.code_marque),3,'0') code_marque, lpad(trim(b.compteur_actuel),11, '0') compteur_actuel, b.code_postal,
            b.usage, b.type_branchement, b.aspect_branchement, b.marche, TRIM(b.etat_branchement) etat_branchement
     from   branchement b   
     where  trim(categorie_actuel) = trim(categ)
     and    trim(client_actuel) = trim(code_client);
   
   cursor lstReleve(v_district varchar2, v_tournee varchar2, v_ordre varchar2)
   is
     select district ,tourne ,ordre,annee,trim,releve,prorata,constrim4,marche,releve2,releve3,releve4,releve5,date_releve,
            compteurt,consommation,lpad(ltrim(rtrim(anomalie)),18,0) anomalie,saisie,avisforte,message_temporaire,compteurchange,
            n_tsp,matricule_releveur,date_controle,matricule_controle,index_controle,nbre_roues,derniere_releve,usage,
            tarif,diamctr,cctr,codemarque,ncompteur,ancien_releve
     from   fiche_releve a
     where  trim(trim) is not null
     and    trim(a.district)             = v_district
     and    lpad(trim(a.tourne),3,'0')   = v_tournee
     and    lpad(trim(a.ordre),3,'0')    = v_ordre
     and    trim(a.annee) >= 2015
                   ------- sans tenir en compte le donner de relevet------
     and  to_number(trim(a.annee) || trim(a.trim)) <> (select max(to_number(trim(v.annee) || trim(v.trim)))
                                                       from   fiche_releve v
                                                       where  trim(v.tourne) = trim(a.tourne)
                                                       and    trim(v.ordre)  = trim(a.ordre));

begin
  for s1 in c1 loop --Client
    v_pk_etape := 'Recherche de l''adresse du client';
    if(s1.adresse is null)then --recuperer adresse branchement si adresse client est null
       select max(a.code_postal), max(a.adresse)
       into   v_code_postal, v_adresse
       from branchement a
       where trim(a.categorie_actuel) = trim(s1.categorie)
       and trim(a.client_actuel) = trim(s1.code)
       and a.district = s1.district
       and a.adresse is not null;        
    else
      v_code_postal := s1.code_postal;
      v_adresse := s1.adresse;
    end if;
    
    if(v_adresse is null or v_code_postal is null)then
       null;
       --inserrer erreur adresse client dans un table mouchard
    else
      --creation de l'adresse client
      v_pk_etape := 'Recherche/Creation ville client';
      select max(twn_id)
      into   v_twn_id
      from   gentown
      where  twn_code = s1.code_postal;
      
      if(v_twn_id is null)then
         select p.libelle
         into   v_ville_name
         from   r_cpostal p
         where  to_char(p.kcpost) = trim(s1.code_postal)         
      
         select seq_gentown.nextval into v_twn_id from dual;
         insert into gentown(twn_id, twn_code, twn_name, twn_namek, twn_zipcode, coy_id, twn_served, twn_updtby)
                      values(v_twn_id, s1.code_postal,v_ville_name,v_ville_name,s1.code_postal,v_coy_id, 1, v_age_id);         
      end if;
      v_pk_etape := 'Creation rue client';
      select seq_genstreet.nextval into v_str_id from dual;
      insert into genstreet(str_id, str_name, str_namek, str_namer, twn_id, vow_streettp, str_zipcode, str_served, str_updtby)
                     values(v_str_id, s1.adresse, s1.adresse, s1.adresse, v_twn_id, v_vow_streettp, s1.code_postal, 1, v_age_id);
      
      v_pk_etape := 'Creation adresse client';               
      select genadress.nextval into v_adr_id from dual;
      insert into genadress(adr_id, str_id,,adr_zipcode, adr_updtby)
                     values(v_adr_id, v_str_id, s1.code_postal, v_age_id);
                     
      
      --creation du client     
      v_pk_etape := 'Selection de la cartégorie client'; 
      select vow_id
      into   v_vow_typsag
      from   v_genvocword
      where  voc_code = 'VOW_TYPSAG'    
      and    vow.vow_code = decode(lpad(ltrim(rtrim(s1.categorie)),2,'0')null,'02','03','01','05','01','07','01','11','01','12','10','1','01','06','01',lpad(ltrim(rtrim(s1.categorie)),2,'0'));  
                     
      if(v_vow_typsag is null)then
        null;
        --inserreur erreur recuperation categorie client
      else
        if(s1.tp == 1)then
          v_code_cli := s1.district||trim(s1.categorie)||trim(upper(s1.code));
        else
          v_code_cli := s1.district||lpad(trim(s1.code),6,'0')
        end if;
        
        v_pk_etape := 'creation du client client';
        select seq_genparty.nextval into v_par_id from dual;
        insert into genparty(par_id,par_refe,par_lname,par_kname,vow_title,adr_id,par_telw,par_telp,par_telf,
                             vow_typsag,vow_partytp, par_status, par_profexotva, par_search, par_updtby)
                      values(v_par_id,v_code_cli,trim(s1.nom),trim(replace(s1.nom,' ','')),v_vow_title,v_adr_id,trim(s1.tel),trim(s1.autre_tel),trim(s1.fax),
                             v_vow_typsag,v_vow_partytp,1,0,1,v_age_id);
        
        
        for s2 in c2(s1.categorie, s1.code) loop --branchement
          v_pk_etape := 'creation du l''adresse du site/pdl';
          v_code_postal := s2.code_postal;
          v_adresse := s2.adresse;
          if(v_adresse is null or v_code_postal is null)then
            null;
            --inserrer erreur adresse client dans un table mouchard
          else
            --creation de l'adresse client
            v_pk_etape := 'Recherche/Creation ville site/pdl';
            select max(twn_id)
            into   v_twn_id
            from   gentown
            where  twn_code = s1.code_postal;
            
            if(v_twn_id is null)then
               select p.libelle
               into   v_ville_name
               from   r_cpostal p
               where  to_char(p.kcpost) = trim(s1.code_postal)         
            
               select seq_gentown.nextval into v_twn_id from dual;
               insert into gentown(twn_id, twn_code, twn_name, twn_namek, twn_zipcode, coy_id, twn_served, twn_updtby)
                            values(v_twn_id, s1.code_postal,v_ville_name,v_ville_name,s1.code_postal,v_coy_id, 1, v_age_id);         
            end if;
            v_pk_etape := 'Creation rue site/pdl';
            select seq_genstreet.nextval into v_str_id from dual;
            insert into genstreet(str_id, str_name, str_namek, str_namer, twn_id, vow_streettp, str_zipcode, str_served, str_updtby)
                           values(v_str_id, s1.adresse, s1.adresse, s1.adresse, v_twn_id, v_vow_streettp, s1.code_postal, 1, v_age_id);
            
            v_pk_etape := 'Creation adresse site/pdl';               
            select genadress.nextval into v_adr_id from dual;
            insert into genadress(adr_id, str_id, adr_zipcode, adr_updtby)
                           values(v_adr_id, v_str_id, s1.code_postal, v_age_id);
            
            v_pk_etape := 'Creation du site'; 
            v_code_br := lpad(s2.district,2,'0')||lpad(s2.tourne,3,'0')||lpad(s2.ordre,3,'0')||lpad(to_char(s2.police),5,'0');
            select seq_tecpremise.nextval into v_pre_id from dual;
            insert into tecpremise(pre_id,pre_refe,adr_id,vow_premisetp,pre_updtby)
                            values(v_pre_id,v_code_br,v_adr_id,v_vow_premisetp,v_age_id);
            
            v_pk_etape := 'Creation du proprietaire site'; 
            select seq_tecpresptcontact.nextval into v_psc_id from dual;
            insert into tecpresptcontact(psc_id,pre_id,par_id,vow_precontacttp,psc_startdt,psc_enddt,psc_rank,psc_updtby)
                                  values(v_psc_id, v_pre_id, v_vow_precontacttp, '01/01/1900', decode(s2.etat_branchement, '0', Null, '01/01/1900'), 1, v_age_id);
            v_pk_etape := 'Creation du PDL'; 
            v_pk_etape := 'Récupértion de l''identifiant de la tournée'; 
            select max(rou_id)
            into   v_rou_id
            from   tecroute
            where  rou_code = s2.tourne;
            v_pk_etape := 'Récupération de l''identifiant du fluide';
            select max(fld_id)
            into   v_fld_id
            from   tecfluid
            where  fld_codei = 'PDC EAU';
            v_spt_id := seq_tecservicepoint.nextval;
            Insert Into tecservicepoint (SPT_ID,SPT_REFE,ROU_ID,SPT_ROUTEORDER,SPT_COMMENT,SPT_NEEDRDV,
		                             VOW_DIFFREAD,VOW_ACCESS,VOW_READINFO1,VOW_READINFO2,VOW_READINFO3,
									               FLD_ID,PRE_ID,ADR_ID,spt_updtby) 
		                    Values  (v_spt_id,v_code_br,v_rou_id,s2.ordre,s2.marche,0,
		                             Null,Null,Null,Null,Null,
									               v_fld_id,v_pre_id,v_adr_id,v_age_id);
            v_pk_etape := 'Creation du statut PDL';
            v_sps_id := seq_tecspstatus.nextval;
            v_pk_etape := 'Récpération du statut du PDL';
            begin
              select decode(nvl(posit,0),0,1,2), codpoll, napt, consmoy, echronas, echtonas, capitonas, interonas, arrond, '1'
              into   v_posit, v_codpoll, v_napt, v_consmoy, v_echronas, v_echtonas, v_capitonas, v_interonas, v_arrond, v_periodicite
              from   abonnees t
              where  lpad(t.pol,5,'0')           = lpad(s2.police,5,'0')
              and    lpad(t.tou,3,'0')           = lpad(s2.tourne,3,'0')
              and    lpad(t.ord,3,'0')           = lpad(s2.ordre,3,'0')
              and    t.dist                      = s2.district;
            exception 
              when others then 
                v_posit := 1;
            end;
			--Il faut gérer l'exception d'absence de statut en base et soit interdire soit mettre une valeur par défaut
            select vow.vow_id
            into   v_vow_spstatus
            from   genvoc voc,
                   genvocword vow
            where  voc.voc_id       = vow.voc_id
            and    voc.voc_code     = 'VOW_SPSTATUS'
            and    vow.vow_internal = 1
            and    vow.vow_icode    = v_posit;
            Insert Into tecspstatus (sps_id, spt_id, vow_spstatus, sps_startdt, sps_updtby)
            Values(v_sps_id, v_spt_id, v_vow_spstatus, decode(s2.DATE_CREATION,'00:00:00','01/01/1900',to_char(to_date(s2.DATE_CREATION,'dd/mm/yyyy hh24:mi:ss'),'dd/mm/yyyy')), v_age_id);
            v_pk_etape := 'Création de la sectorisation du PDL (Type secteur DISTRICT uniquement)';
            v_dpr_id := seq_gendivspt.nextval;
			--Il faut gérer l'exception d'absence de sectorisation
            select div_id
            into   v_div_id
            from   gendivision
            where  div_code = s2.district;
            select dvt_id
            into   v_dvt_id
            from   gendivdit
            where  div_id = v_div_id
            and    dit_id = 1; --DISTRICT
            Insert into gendivspt(dpr_id, dvt_id, spt_id, dpr_updtby)
            values(v_dpr_id, v_dvt_id, v_spt_id, v_age_id);
            v_pk_etape := 'Création de l''affectation de l''organisation du PDL';
            select max(org_id)
            into   v_org_id
            from   genorganization 
            where  org_code = s2.district;
            if v_org_id is not null then
              v_spo_id := seq_tecsptorg.nextval;
              insert into tecsptorg(spo_id, spt_id, org_id, spo_comment, spo_updtby)
              values(v_spo_id, v_spt_id, v_org_id, 'Migration', v_age_id);
            else
              --Il faut tracer l'absence de l'organisation ou bien la créer avant de continuer
              Null;
            end if;
            v_pk_etape := 'Création de liaison PDL /BRA';
            v_cnn_id := seq_tecconnection.nextval;
            insert into tecconnection(cnn_id, cnn_refe, adr_id, fld_id, cnn_startdt, cnn_updtby)
            values(v_cnn_id, v_code_br, v_adr_id, v_fld_id, decode(s2.DATE_CREATION,'00:00:00','01/01/1900',to_char(to_date(s2.DATE_CREATION,'dd/mm/yyyy hh24:mi:ss'),'dd/mm/yyyy')), v_age_id);
            v_hcs_id := seq_TECHCONSPT.nextval;
            insert into TECHCONSPT(hcs_id, spt_id, con_id, hcs_startdt)
            values(v_hcs_id, v_spt_id, v_con_id, decode(s2.DATE_CREATION,'00:00:00','01/01/1900',to_char(to_date(s2.DATE_CREATION,'dd/mm/yyyy hh24:mi:ss'),'dd/mm/yyyy')), v_age_id);
            v_pk_etape := 'Création de liason TECSPTWATER';
            v_pk_etape := 'Récupération de l''etat du branchement';
            select vow.vow_id
            into   v_vow_constatus
            from   genvoc     voc,
                   genvocword vow
            where  voc.voc_id       = vow.voc_id
            and    voc.voc_code     = 'VOW_CONSTATUS'
            and    vow.vow_code    = decode(s2.aspect_branchement, 'B', 'B', 'M', 'M', 'I', 'I', 'I');
            v_pk_etape := 'Récupération de la nature du branchement';
            select vow.vow_id
            into   v_vow_connat
            from   genvoc     voc,
                   genvocword vow
            where  voc.voc_id       = vow.voc_id
            and    voc.voc_code     = 'VOW_CONNAT'
            and    vow.vow_code    = decode(s2.type_branchement, '0', '0', '1', '1', '2', '2', '3', '3', '0');
            insert into tecsptwater(spt_id, vow_connat, vow_constatus, swa_updtby)
            values(v_spt_id, v_vow_connat, v_vow_constatus, v_age_id);
            -----------------------------------------------------------------
            -----------------------                   -----------------------
            ----------------------- Compteur en cours -----------------------
            -----------------------                   -----------------------
            -----------------------------------------------------------------
            v_district        := s2.district;
		    v_code_marque     := s2.code_marque;
			v_compteur_actuel := s2.compteur_actuel;
            v_police          := s2.police;
            if v_compteur_actuel Is Null then
              begin
                select trim(b.district),lpad(trim(b.codemarque),3,'0') code_marque ,lpad(trim(b.ncompteur),11,'0') compteur_actuel
		        into   v_district, v_code_marque, v_compteur_actuel
				from   fiche_releve b
				where  trim(b.district)||lpad(trim(b.tourne),3,'0')||lpad(trim(b.ordre),3,'0')=substr(v_code_br,1,8)
				and    trim(b.annee)||trim(b.trim)=(select max(trim(f.annee)||trim(f.trim)) from fiche_releve f
				where  trim(f.district)||lpad(trim(f.tourne),3,'0')||lpad(trim(f.ordre),3,'0')=substr(v_code_br,1,8)
				and    trim(f.ncompteur) is not null 
				and    trim(f.codemarque)!='000');
              exception 
                when others then
                  begin
                    select  trim(c.district),lpad(trim(c.code_marque),3,'0') code_marque, lpad(trim(c.num_compteur),11,'0') compteur_actuel
					into    v_district, v_code_marque,v_compteur_actuel
					from    gestion_compteur c
					where   trim(c.district)||lpad(trim(c.tournee),3,'0')||lpad(trim(c.ordre),3,'0')=substr(v_code_br,1,8)
					and     trim(c.num_compteur) is not null
					and     trim(c.annee)||trim(c.trim) = (select max(trim(b.annee)||trim(b.trim)) from gestion_compteur b
					where   trim(b.district)||lpad(trim(b.tournee),3,'0')||lpad(trim(b.ordre),3,'0')=substr(v_code_br,1,8));
				  exception when others then
			        v_compteur_actuel:='00000000000';
				    v_code_marque:='000';
				  end;
			  end;
            end if;
            if (v_compteur_actuel='00000000000'and v_code_marque='000') then
              val := val + 1;
              v_rl_cp_num_rl := v_district ||'MIG'||lpad(val,11,'0');
            else
              v_rl_cp_num_rl := v_district || v_code_marque || v_compteur_actuel;
            end if;
            v_voc_model := 0;
	        v_lib_voc   := v_lib_voc;
	        v_voc_diam  := 0;
	        v_voc_class := 0;
	        v_nbr_roues := 0;
	        v_annee     := 0;
            --recupere diam  de comteur
	        begin
		      select c.diam_compteur, c.nbr_roues, c.annee_fabrication 
              into   v_voc_diam, v_nbr_roues, v_annee
		      from   compteur c
		      where  ref_cpt = v_district||v_code_marque||v_compteur_actuel;
	        exception 
              when others then 
                v_voc_diam  := 0;
                v_annee     := 0;
                v_nbr_roues := 0; 
	        end;
            --recupere class de compteur
	        begin
		      select  m.classe 
              into    v_voc_class 
		      from    compteur c,marque m
		      where   c.code_marque = m.code
		      and     c.district    = m.district
		      and     ref_cpt       = v_district||v_code_marque||v_compteur_actuel
		      and rownum            = 1;
	        exception 
              when others then 
                v_voc_class := 0;
	        end;
            begin
	        -- Classe 100
			  if    v_code_marque = 101 then v_nbr_roues := 0;
			  elsif v_code_marque = 102 then v_nbr_roues := 4;
			  elsif v_code_marque = 103 then v_nbr_roues := 4;
			  elsif v_code_marque = 104 and v_voc_diam = 15 then v_nbr_roues := 4;
			  elsif v_code_marque = 104 and v_voc_diam = 40 then v_nbr_roues := 5;
			  elsif v_code_marque = 105 then v_nbr_roues := 4;
			  elsif v_code_marque = 106 then v_nbr_roues := 6;
			  elsif v_code_marque = 107 then v_nbr_roues := 6;
			  elsif v_code_marque = 108 then v_nbr_roues := 6;
			  elsif v_code_marque = 109 then v_nbr_roues := 5;
			  elsif v_code_marque = 110 then v_nbr_roues := 4;
			  elsif v_code_marque = 111 then v_nbr_roues := 4;
			  elsif v_code_marque = 112 then v_nbr_roues := 0;
			  elsif v_code_marque = 113 then v_nbr_roues := 4;
			  elsif v_code_marque = 114 then v_nbr_roues := 4;
			  elsif v_code_marque = 115 and v_voc_diam = 15 then v_nbr_roues := 4;
			  elsif v_code_marque = 115 and v_voc_diam = 30 then v_nbr_roues := 5;
			  elsif v_code_marque = 116 then v_nbr_roues := 5;
			  elsif v_code_marque = 117 then v_nbr_roues := 5;
			  elsif v_code_marque = 118 then v_nbr_roues := 6;
			  elsif v_code_marque = 120 then v_nbr_roues := 4;
			  elsif v_code_marque = 121 then v_nbr_roues := 4;
			  -- Classe 200
			  elsif v_code_marque = 201 then v_nbr_roues := 4;
			  elsif v_code_marque = 202 then v_nbr_roues := 4;
			  elsif v_code_marque = 203 and v_voc_diam = 15 then v_nbr_roues := 4;
			  elsif v_code_marque = 203 and v_voc_diam = 40 then v_nbr_roues := 5;
			  elsif v_code_marque = 203 and v_voc_diam > 40 then v_nbr_roues := 6;
			  elsif v_code_marque = 204 then v_nbr_roues := 4;
			  elsif v_code_marque = 205 then v_nbr_roues := 4;
			  elsif v_code_marque = 206 then v_nbr_roues := 4;
			  elsif v_code_marque = 207 and v_voc_diam = 15 then v_nbr_roues := 4;
			  elsif v_code_marque = 207 and v_voc_diam = 20 then v_nbr_roues := 4;
			  elsif v_code_marque = 207 and v_voc_diam = 40 then v_nbr_roues := 5;
			  elsif v_code_marque = 208 then v_nbr_roues := 4;
			  elsif v_code_marque = 210 then v_nbr_roues := 5;
			  elsif v_code_marque = 211 then v_nbr_roues := 6;
			  elsif v_code_marque = 212 then v_nbr_roues := 5;
			  -- Classe 300
			  elsif v_code_marque = 306 then v_nbr_roues := 4;
			  elsif v_code_marque = 310 then v_nbr_roues := 4;
			  else  v_nbr_roues:=4; end if;
              
              insert into miwtcompteur
		   (
			MCOM_SOURCE      ,--1
			MCOM_REF         ,--2
			MCOM_REEL        ,--3
			VOC_DIAM         ,--4
			MCOM_ANNEE       ,--5
			MCOM_REFVOCCLASSE,--6
			NCOM_NBROUE      ,--7
			VOC_MODEL        ,--8
			REF_TYPEEQUI     ,--9
			VOC_EQUSTATUS    ,--10
			MTC_ID            --11
		   )
		  values
		  (
			'DIST'||trim(cpt_.district)   ,--1
			ref_cpt             ,--2
			lpad(trim(cpt_.num_cpt),11,'0'),--3
			nvl(v_voc_diam,0)   ,--4
			nvl(v_annee,1900)   ,--5
			v_voc_CLASS         ,--6
			nvl(v_nbr_roues,0)  ,--7
			lpad(trim(cpt_.codemarque),3,'0') ,--8
			'EAU'               ,--9
			1                   ,--10
			1                    --11
		   );
            v_equ_id := seq_tecequipment.nextval;
            v_equ_realnumber := v_district||v_code_marque||v_compteur_actuel;
            SELECT vow.vow_id
            INTO   v_vow_equstatus
            FROM   genvoc     voc,
                   genvocword vow
            WHERE  voc.voc_id = vow.voc_id
            AND    vow.vow_code     = '1'
			AND    vow.vow_internal = 1
            AND    voc.voc_code     = 'VOW_EQUSTATUS';
            if v_nbr_roues Is Not Null then 
		      SELECT '<?xml version="1.0" encoding="iso-8859-15"?>'||CHR(10)||xmlagg(xmlelement("parameters",
                                                                                     xmlelement("longueur'" , NVL(v_nbr_roues, 0)),
                                                                                     xmlelement("nombreroue", Null)
                                                                                               )
                                                                                    )
              INTO   v_equ_techinfo 
              FROM   dual ;
		    end if;
            SELECT eqy_id
            INTO   v_eqy_id 
            FROM   Tecequtype
            WHERE  eqy_code = 'EAU';
            SELECT vow.vow_id
            INTO   v_vow_model
            FROM   genvoc     voc,
                   genvocword vow
            WHERE  voc.voc_id = vow.voc_id
            AND    vow.vow_code     = v_code_marque
            AND    voc.voc_code     = 'VOW_MODEL';
            SELECT  mmo_id 
            INTO    v_mmo_id
			FROM    tecequmodel
			WHERE   eqy_id       = v_eqy_id
			and     vow_manufact = v_vow_manufact
			and     vow_model    = v_vow_model;
            SELECT vow.vow_id
            INTO   v_vow_owner
            FROM   genvoc     voc,
                   genvocword vow
            WHERE  voc.voc_id = vow.voc_id
            AND    vow.vow_code     = 'ELD'
            AND    voc.voc_code     = 'VOW_OWNER';
            insert into tecequipment(equ_id, equ_realnumber, equ_key, equ_serialnumber, vow_equstatus, equ_lot, equ_year, equ_techinfo, mmo_id, eqy_id, vow_owner)
            values(v_equ_id, v_equ_realnumber, Null, v_equ_realnumber, v_vow_equstatus, Null, NVL(v_annee, 1900), v_equ_techinfo, v_mmo_id, v_eqy_id, v_vow_owner);
            --Récupération de la configuration compteur
            SELECT MAX(mtc.mtc_id)
            INTO   v_mtc_id
            FROM   tecmtrcfg mtc,
                   tecmtrcfgdetail mcd
            WHERE  mtc.vow_model    = v_vow_model
            AND    mtc.vow_manufact = v_vow_manufact
            AND    mtc.mtc_id       = mcd.mtc_id
            AND    mcd.meu_id       = v_meu_id
            AND    mcd.mcd_wheel    = v_nbr_roues;
            if v_mtc_id Is Null then
              v_mtc_id := seq_tecmtrcfg.NEXTVAL;
              insert into tecmtrcfg(mtc_id, mtc_code, mtc_name, vow_manufact, vow_model, FLD_ID)
              values(v_mtc_id, v_code_marque || '- X' || v_nbr_roues, v_code_marque || '- X' || v_nbr_roues, v_vow_manufact, v_vow_model, v_fld_id);
              v_mcd_id := seq_tecmtrcfgdetail.NEXTVAL;
              insert into tecmtrcfgdetail(mcd_id, mcd_num, mtc_id, meu_id, mcd_wheel, mcd_coeff)
              values(v_mcd_id, v_mcd_num, v_mtc_id, v_meu_id, v_nbr_roues, v_mcd_coeff);
            end if;
            Insert into tecmeter(equ_id, mtc_id)
            values(v_equ_id, v_mtc_id);
            SELECT vow.vow_id
            INTO   v_vow_diam
            FROM   genvoc     voc,
                   genvocword vow
            WHERE  voc.voc_id = vow.voc_id
            AND    vow.vow_code     = v_voc_diam
            AND    voc.voc_code     = 'VOW_DIAM';
            SELECT vow.vow_id
            INTO   v_vow_class
            FROM   genvoc     voc,
                   genvocword vow
            WHERE  voc.voc_id = vow.voc_id
            AND    upper(vow.vow_code) = 'INCONNUE'
            AND    voc.voc_code        = 'VOW_CLASS';
            insert into tecmtrwater(equ_id, vow_diam, vow_class, vow_qn)
            values(v_equ_id, v_vow_diam, v_vow_class, Null);
            v_heq_id := seq_techequipment.nextval;
            SELECT  MAX(TO_DATE( m.date_res,'dd/mm/yyyy'))
            INTO    v_date_ferm
            FROM    branchement_res_max m
            WHERE   m.dist || m.ref_pdl = substr(v_code_br,1,8)
            AND     TRIM(s2.etat_branchement) = '9';
            if v_date_ferm Is Null then
			  v_voc_pose   := 'P';
			  v_voc_depose := Null;
			else
			  v_voc_pose   := 'P';
			  v_voc_depose :='D';
			end if;
            SELECT vow.vow_id
            INTO   v_vow_reaspose
            FROM   genvoc     voc,
                   genvocword vow
            WHERE  voc.voc_id = vow.voc_id
            AND    vow.vow_code     = v_voc_pose
            AND    voc.voc_code     = 'VOW_REASPOSE';
            SELECT vow.vow_id
            INTO   v_vow_reasdepose
            FROM   genvoc     voc,
                   genvocword vow
            WHERE  voc.voc_id = vow.voc_id
            AND    vow.vow_code     = v_voc_depose
            AND    voc.voc_code     = 'VOW_REASPOSE';
            insert into techequipment(heq_id, equ_id, spt_id, age_pose, heq_startdt, heq_enddt, vow_reaspose, vow_reasdepose)
            values(v_heq_id, v_equ_id, v_spt_id, 1, decode(s2.DATE_CREATION,'00:00:00','01/01/1900',to_char(to_date(s2.DATE_CREATION,'dd/mm/yyyy hh24:mi:ss'),'dd/mm/yyyy')),
                   v_date_ferm, v_vow_reaspose, v_vow_reasdepose);
            -----------------------------------------------------------------
            -----------------------                   -----------------------
            -----------------------    Contrat PDS    -----------------------
            -----------------------                   -----------------------
            -----------------------------------------------------------------
            SELECT imp_id INTO v_imp_id FROM genimp   WHERE imp_code = 'IMP_MIG';
            SELECT ofr_id INTO v_ofr_id FROM agroffer WHERE ofr_code = 'OM';
            v_vow_frozen := Null;
            v_vow_typdurbill := Null; -- Facturation par avance ADP / Non ADP
            --Droit de coupure
            SELECT vow.vow_id
            INTO   v_vow_cutagree
            FROM   genvoc     voc,
                   genvocword vow
            WHERE  voc.voc_id = vow.voc_id
            AND    vow.vow_code     = '0'
            AND    voc.voc_code     = 'VOW_CUTAGREE';
            --Type d'usage PDS ((Tout usage), Producteur, Communal, Collectif/Agricole, Professionnel, , Local Technique, Batiment Administratif, Particulier)
            SELECT vow.vow_id
            INTO   v_vow_usgsag
            FROM   genvoc     voc,
                   genvocword vow
            WHERE  voc.voc_id = vow.voc_id
            AND    vow.vow_code     = s2.usage
            AND    voc.voc_code     = 'VOW_USGSAG';
            --Type de Service PDS
            --Si gros consommateur == Oui, alors 'G' sinon 'P'
            if s2.gros_consommateur = 'O' then
              SELECT vow.vow_id
              INTO   v_vow_typsag
              FROM   genvoc     voc,
                     genvocword vow
              WHERE  voc.voc_id   = vow.voc_id
              AND    vow.vow_code = 'G'
              AND    voc.voc_code = 'VOW_TYPSAG';
              v_aac_avgconsumimp := v_consmoy / 30;
		      v_dlp_id           := 3;
              SELECT vow.vow_id
              INTO   v_vow_frqfact
              FROM   genvoc     voc,
                     genvocword vow
              WHERE  voc.voc_id   = vow.voc_id
              AND    vow.vow_code = '30'
              AND    voc.voc_code = 'VOW_FRQFACT';
            else
              SELECT vow.vow_id
              INTO   v_vow_typsag
              FROM   genvoc     voc,
                     genvocword vow
              WHERE  voc.voc_id   = vow.voc_id
              AND    vow.vow_code = 'P'
              AND    voc.voc_code = 'VOW_TYPSAG';
              v_aac_avgconsumimp := v_consmoy / 90;
              v_dlp_id           := 2;
              SELECT vow.vow_id
              INTO   v_vow_frqfact
              FROM   genvoc     voc,
                     genvocword vow
              WHERE  voc.voc_id   = vow.voc_id
              AND    vow.vow_code = '90'
              AND    voc.voc_code = 'VOW_FRQFACT';
            end if;
            v_aac_avgconsummrd := v_consmoy;
            v_abn_ref := ltrim(rtrim(v_district)) || '0' || lpad(to_char(trim(s2.police)),5,'0');
            v_date    := '01/01/1969';
            v_cag_id  := seq_agrcustomeragr.nextval;
            --Création du contrat 
            insert into agrcustomeragr(cag_id, pre_id, par_id, cag_refe, cag_startdt, cag_enddt)
            values(v_cag_id, v_pre_id, v_par_id, v_abn_ref, v_date, v_date_ferm);
            --Recerche du groupe de facturation
            if v_rou_id Is Not Null then
              SELECT grf_id
              INTO   v_grf_id
              FROM   tecroute
              WHERE  rou_id = v_rou_id;
            end if;
            v_sag_id := seq_agrserviceagr.nextval;
            --Création du PDS
            insert into agrserviceagr(sag_id, sag_refe, sag_startdt, sag_enddt, cag_id, spt_id, grf_id, ctt_id, sag_factmode, sag_frozen, sag_frozendt, sag_exotva,
                                      vow_frozen, vow_typdurbill, vow_cutagree, vow_typsag, vow_usgsag, sag_comment, sag_credt, sag_updtdt, sag_updtby)
            values(v_sag_id, v_abn_ref, v_date, v_date_ferm, v_cag_id, v_spt_id, v_grf_id, v_ctt_id, v_sag_factmode, v_sag_frozen, Null, v_sag_exotva, v_vow_frozen,
                   v_vow_typdurbill, v_vow_cutagree, v_vow_typsag, v_vow_usgsag, v_sag_comment, sysdate, Null, v_age_id);
            --Création de l'abonné
            SELECT vow.vow_id
            INTO   v_vow_agrcontacttp
            FROM   genvoc     voc,
                   genvocword vow
            WHERE  voc.voc_id   = vow.voc_id
            AND    vow.vow_code = '2'
            AND    voc.voc_code = 'VOW_AGRCONTACTTP';
            v_cot_id := seq_agrcustagrcontact.nextval;
            insert into agrcustagrcontact(cot_id, cag_id, sag_id, par_id, cot_startdt, cot_enddt, vow_agrcontacttp, cot_rank)
            values(v_cot_id, v_cag_id, v_sag_id, v_par_id, v_date, v_date_ferm, v_vow_agrcontacttp, 1);
            --Création modalité de paiement
            v_stl_id := seq_agrsettlement.nextval;
            SELECT vow.vow_id
            INTO   v_vow_settlemode
            FROM   genvoc     voc,
                   genvocword vow
            WHERE  voc.voc_id   = vow.voc_id
            AND    vow.vow_code = '4'
            AND    voc.voc_code = 'VOW_SETTLEMODE';
            SELECT vow.vow_id
            INTO   v_vow_nbbill
            FROM   genvoc     voc,
                   genvocword vow
            WHERE  voc.voc_id   = vow.voc_id
            AND    vow.vow_code = '1'
            AND    voc.voc_code = 'VOW_NBBILL';
            insert into agrsettlement(stl_id, sag_id, stl_startdt, vow_settlemode, vow_nbbill, dlp_id)
            values(v_stl_id, v_sag_id, v_date, v_vow_settlemode, v_vow_nbbill, v_dlp_id);
            --Création du payeur
            SELECT vow.vow_id
            INTO   v_vow_agrcontacttp
            FROM   genvoc     voc,
                   genvocword vow
            WHERE  voc.voc_id   = vow.voc_id
            AND    vow.vow_code = 'PAY'
            AND    voc.voc_code = 'VOW_AGRCONTACTTP';
            v_cot_id := seq_agrcustagrcontact.nextval;
            insert into agrcustagrcontact(cot_id, cag_id, sag_id, par_id, cot_startdt, cot_enddt, vow_agrcontacttp, cot_rank)
            values(v_cot_id, v_cag_id, v_sag_id, v_par_id, v_date, v_date_ferm, v_vow_agrcontacttp, 2);
            --Crétion de l'adresse de facturation
            v_paa_id := seq_GENPARTYPARTY.nextval;
            SELECT vow.vow_id
            INTO   v_vow_partytp
            FROM   genvoc     voc,
                   genvocword vow
            WHERE  voc.voc_id   = vow.voc_id
            AND    vow.vow_code = '4'
            AND    voc.voc_code = 'VOW_PARTYTP';
            insert into genpartyparty(paa_id, par_parent_id, adr_id, vow_partytp, paa_startdt, paa_enddt)
            values(v_paa_id, v_par_id, v_adr_id, v_vow_partytp, v_date, v_date_ferm);
            v_pay_id := seq_agrpayor.nextval;
            insert into agrpayor(pay_id, cot_id, paa_id)
            values(v_pay_id, v_cot_id, v_paa_id);
            --Création du compte client
            v_aco_id := seq_genaccount.nextval;
            SELECT vow.vow_id
            INTO   v_vow_acotp
            FROM   genvoc     voc,
                   genvocword vow
            WHERE  voc.voc_id   = vow.voc_id
            AND    vow.vow_code = '1'
            AND    voc.voc_code = 'VOW_ACOTP';
            insert into genaccount(aco_id, par_id, imp_id, vow_acotp, rec_id, aco_status, ACO_COMMENT)
            values(v_aco_id, v_par_id, v_imp_id, v_vow_acotp, rec_id, 0, 'Migration');
            v_sco_id := seq_agrsagaco.nextval;
            insert into agrsagaco(sco_id, sco_startdt, sco_enddt, sag_id, aco_id)
            values(v_sco_id, v_date, v_date_ferm, v_sag_id, v_aco_id);
            --Création de l'offre de facturation du PDS
            v_hsf_id := seq_agrhsagofr.nextval;
            insert into agrhsagofr(hsf_id, sag_id, ofr_id, hsf_startdt, hsf_enddt)
            values(v_hsf_id, v_sag_id, v_ofr_id, v_date, v_date_ferm);
            insert into agrplanningagr(sag_id, vow_frqfact, agp_factday, agp_factmtmax, agp_factmtmin, agp_nextfactdt, agp_nextreaddt, vow_modefactnext,
                                       agp_nextfactdtold, agp_factnextrelold, vow_modefactold, agp_credt, agp_updtby, agp_updtdt, agp_sagdt, agp_sagdtold)
            values(v_sag_id, v_vow_frqfact, 10, null, null, sysdate, null, 2844, sysdate, null, 2844, sysdate, 1, null, sysdate, null);
            --------------------------------------------------------------------
            -----------------------                      -----------------------
            -----------------------    Relève de pose    -----------------------
            -----------------------                      -----------------------
            --------------------------------------------------------------------
            v_mrd_id := seq_tecmtrread.nextval;
            SELECT vow.vow_id
            INTO   v_vow_comm1
            FROM   genvoc     voc,
                   genvocword vow
            WHERE  voc.voc_id   = vow.voc_id
            AND    vow.vow_code = '00'
            AND    voc.voc_code = 'VOW_COMM1';
            v_vow_comm2 := Null;
            v_vow_comm3 := Null;
            SELECT vow.vow_id
            INTO   v_vow_readorig
            FROM   genvoc     voc,
                   genvocword vow
            WHERE  voc.voc_id   = vow.voc_id
            AND    vow.vow_code = '03'
            AND    voc.voc_code = 'VOW_READORIG';
            v_vow_readmeth   := Null;
            v_vow_readreason := Null;
            v_vow_readcode   := Null;
            v_mrd_dt := decode(s2.DATE_CREATION,'00:00:00','01/01/1900',to_char(to_date(s2.DATE_CREATION,'dd/mm/yyyy hh24:mi:ss'),'dd/mm/yyyy'));
            v_mrd_comment  := Null;
            v_mrd_locked   := 0;
            v_mrd_agrtype  := 0;
            v_mrd_techtype := 1;
            v_mrd_subread  := 0;
            v_mrd_etatfact := 0;
            v_age_id       := 1;
            v_mrd_usecr    := 1;
            v_mrd_year     := to_char(v_mrd_dt,'yyyy');
            if substr(v_mrd_dt, 4, 2) in ('01', '02', '03') then
			  v_trimestre := 1;
			elsif substr(v_mrd_dt, 4, 2) in ('04', '05', '06') then
			  v_trimestre := 2;
			elsif substr(v_mrd_dt, 4, 2) in ('07', '08', '09') then
			  v_trimestre := 3;
			elsif substr(v_mrd_dt, 4, 2) in ('10','11','12') then
			  v_trimestre := 4;
			end if;
            v_mrd_multicad := v_trimestre;
            insert into tecmtrread(mrd_id, equ_id, mtc_id, mrd_dt, spt_id, vow_comm1, vow_comm2, vow_comm3, vow_readcode, vow_readorig,	vow_readmeth,
                                   vow_readreason, mrd_comment, mrd_locked, mrd_msgbill, mrd_agrtype, mrd_techtype, mrd_subread, mrd_deduction_id,
                                   mrd_etatfact, age_id, mrd_usecr, mrd_year, mrd_multicad) 
            values(v_mrd_id, v_equ_id, v_mtc_id, v_mrd_dt, v_spt_id, v_vow_comm1, v_vow_comm2, v_vow_comm3, v_vow_readcode, v_vow_readorig, v_vow_readmeth,
                   v_vow_readreason, v_mrd_comment, v_mrd_locked, null, v_mrd_agrtype, v_mrd_techtype, v_mrd_subread, null, v_mrd_etatfact, v_age_id,
                   v_mrd_usecr, v_mrd_year, v_mrd_multicad);
            v_mme_id := seq_tecmtrmeasure.nextval;
            insert into tecmtrmeasure(mme_id, mrd_id, meu_id, mme_num, mme_value, mme_consum, mme_avgconsum, mme_deducemanual)
            values(v_mme_id, v_mrd_id, v_meu_id, 1, 0, 0, 0, Null);
            --------------------------------------------------------------------
            -----------------------                      -----------------------
            -----------------------    Relève de dépose    -----------------------
            -----------------------                      -----------------------
            --------------------------------------------------------------------
            v_mrd_id := seq_tecmtrread.nextval;
            SELECT vow.vow_id
            INTO   v_vow_comm1
            FROM   genvoc     voc,
                   genvocword vow
            WHERE  voc.voc_id   = vow.voc_id
            AND    vow.vow_code = '00'
            AND    voc.voc_code = 'VOW_COMM1';
            v_vow_comm2 := Null;
            v_vow_comm3 := Null;
            SELECT vow.vow_id
            INTO   v_vow_readorig
            FROM   genvoc     voc,
                   genvocword vow
            WHERE  voc.voc_id   = vow.voc_id
            AND    vow.vow_code = '03'
            AND    voc.voc_code = 'VOW_READORIG';
            v_vow_readmeth   := Null;
            v_vow_readreason := Null;
            v_vow_readcode   := Null;
            v_mrd_dt := decode(s2.DATE_CREATION,'00:00:00','01/01/1900',to_char(to_date(s2.DATE_CREATION,'dd/mm/yyyy hh24:mi:ss'),'dd/mm/yyyy'));
            v_mrd_comment  := Null;
            v_mrd_locked   := 0;
            v_mrd_agrtype  := 0;
            v_mrd_techtype := 2;
            v_mrd_subread  := 0;
            v_mrd_etatfact := 0;
            v_age_id       := 1;
            v_mrd_usecr    := 1;
            v_mrd_year     := to_char(v_mrd_dt,'yyyy');
            if substr(v_mrd_dt, 4, 2) in ('01', '02', '03') then
			  v_trimestre := 1;
			elsif substr(v_mrd_dt, 4, 2) in ('04', '05', '06') then
			  v_trimestre := 2;
			elsif substr(v_mrd_dt, 4, 2) in ('07', '08', '09') then
			  v_trimestre := 3;
			elsif substr(v_mrd_dt, 4, 2) in ('10','11','12') then
			  v_trimestre := 4;
			end if;
            v_mrd_multicad := v_trimestre;
            insert into tecmtrread(mrd_id, equ_id, mtc_id, mrd_dt, spt_id, vow_comm1, vow_comm2, vow_comm3, vow_readcode, vow_readorig,	vow_readmeth,
                                   vow_readreason, mrd_comment, mrd_locked, mrd_msgbill, mrd_agrtype, mrd_techtype, mrd_subread, mrd_deduction_id,
                                   mrd_etatfact, age_id, mrd_usecr, mrd_year, mrd_multicad) 
            values(v_mrd_id, v_equ_id, v_mtc_id, v_mrd_dt, v_spt_id, v_vow_comm1, v_vow_comm2, v_vow_comm3, v_vow_readcode, v_vow_readorig, v_vow_readmeth,
                   v_vow_readreason, v_mrd_comment, v_mrd_locked, null, v_mrd_agrtype, v_mrd_techtype, v_mrd_subread, null, v_mrd_etatfact, v_age_id,
                   v_mrd_usecr, v_mrd_year, v_mrd_multicad);
            v_mme_id := seq_tecmtrmeasure.nextval;
            insert into tecmtrmeasure(mme_id, mrd_id, meu_id, mme_num, mme_value, mme_consum, mme_avgconsum, mme_deducemanual)
            values(v_mme_id, v_mrd_id, v_meu_id, 1, 0, 0, 0, Null);
            for s3 in lstReleve(v_district, lpad(s2.tourne,3,'0'), lpad(trim(s2.ordre),3,'0')) loop
            
            end loop;
            SELECT vow.vow_id
            INTO   v_vow_readreason
            FROM   genvoc     voc,
                   genvocword vow
            WHERE  voc.voc_id   = vow.voc_id
            AND    vow.vow_code = '03'
            AND    voc.voc_code = 'VOW_READREASON';
          end if;
        end loop;
      end if;     
    end if;
  end loop;
end;
