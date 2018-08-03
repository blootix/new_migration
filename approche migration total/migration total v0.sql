declare
  v_adresse varchar2(4000);
  v_code_postal varchar2(400);
  v_ville_name varchar2(400);
  v_code_cli varchar2(400);
  v_code_br varchar2(400);
  v_police varchar2(400);
  -------
  v_pk_etape varchar2(400);
  v_age_id number := 0;
  v_twn_id number;
  v_coy_id number := 1;
  v_str_id number;
  v_vow_streettp number := 5725;
  v_adr_id number;
  v_vow_partytp number := 2884;
  v_vow_title number := 4101;
  v_vow_typsag number;
  v_par_id number;
  v_vow_premisetp number := 2902;
  v_pre_id number;
  v_psc_id number;
  v_vow_precontacttp number := 2890;
  
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
     select b.district,b.police,b.tourne,b.ordre,gros_consommateur,b.adresse,date_creation,
            categorie_actuel,client_actuel,b.compteur_actuel,b.code_marque,b.code_postal,
            b.usage,b.type_branchement,b.aspect_branchement,b.marche
     from   branchement b   
     where  trim(categorie_actuel) = trim(categ)
     and    trim(client_actuel) = trim(code_client);

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
                      values(v_par_id,v_code_cli,trim(s1.nom),trim(replace(s1.nom,' ','')),v_vow_tile,v_adr_id,trim(s1.tel),trim(s1.autre_tel),trim(s1.fax),
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
                                  values(v_psc_id,v_pre_id,v_vow_precontacttp,'01/01/1900',decode(s2.etat_branchement,'0',null,'01/01/1900'),1,v_age_id);
            
            
          end if;
        end loop;
      end if;     
    end if;
  end loop;
end;
