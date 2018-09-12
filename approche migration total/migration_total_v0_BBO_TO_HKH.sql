declare
    v_adresse            varchar2(4000);
	v_code_postal        varchar2(100);
	v_code_cli           varchar2(100);
	v_code_br            varchar2(100); 
	v_pk_etape           varchar2(400);
	V_AGE_ID             number:= 1;
	V_MEU_ID             number:= 5;
	V_CTT_ID             number:= 1;
	V_COY_ID             number:= 1;
	V_REC_ID			 number:= 4;
	V_SUT_ID             number:= 100003;
	V_TWN_ID             number;
	V_STR_ID             number;
	V_ADR_ID             number;
	V_PAR_ID             number;
	V_PRE_ID             number;
	V_PSC_ID             number;
	V_ROU_ID             number;
	V_FLD_ID             number;
	V_EQU_ID             number;
	V_SPT_ID             number;
	V_SPS_ID             number;
	V_DIV_ID             number;
	V_DVT_ID             number;
	V_ORG_ID             number;
	V_SPO_ID             number;
	V_CNN_ID             number;
	V_HCS_ID             number;
	V_MMO_ID             number;
	V_MTC_ID             number;	 
	V_MCD_ID             number;
	V_HEQ_ID             number;
	V_ACO_ID             number;
	V_IMP_ID             number;
	V_SCO_ID             number;
	V_PAA_ID             number;
	V_HSF_ID             number;
	V_GRF_ID             number;
	V_OFR_ID             number;
	V_CAG_ID             number;
	V_SAG_ID             number; 
	V_COT_ID             number;
	V_STL_ID             number;
	V_DLP_ID             number:=2;
	V_AAC_ID 			 number;
	V_PAY_ID             number; 
	V_BAN_ID    	     number;
	V_BAP_ID             number;
	V_VOC_DIAM           number;
	V_VOC_POSE           VARCHAR2(50);
	V_VOC_DEPOSE         VARCHAR2(50);
	V_VOW_STREETTP       number := 5725;--Boulevard	ÔÇÑÚ
	V_VOW_PARTYTP        number := 2884;--CLIENT
	V_VOW_TITLE          number := 4101;--'-' 
	V_VOW_MANUFACT     	 number := 4414;--'-'
	V_VOW_PREMISETP      number := 2902;--MAISON
	V_VOW_PRECONTACTTP   number := 2890;--PROPRIETAIRE
	V_VOW_MODEFACTNEXT   number := 2848;--Releve 
	V_VOW_VALUE          number := 4435;--Plafond de consommation
	V_VOW_TYPSAG         number;
	V_VOW_SPSTATUS       number;
	V_VOW_CONNAT         number;
	V_VOW_CONSTATUS      number;
	V_VOW_EQUSTATUS      number;
	V_VOW_MODEL          number;
	V_VOW_OWNER          number;
	V_VOW_DIAM           number;
	V_VOW_CLASS          number;
	V_VOW_REASPOSE       number;
	V_VOW_REASDEPOSE     number;
	V_VOW_FROZEN         number;
	V_VOW_TYPDURBILL     number;
	V_VOW_CUTAGREE       number;
	V_VOW_USGSAG         number;
	V_VOW_AGRCONTACTTP   number;
	V_VOW_SETTLEMODE     number;
	V_VOW_NBBILL         number;
	V_VOW_ACOTP          number;
	V_VOW_FRQFACT        number; 
	V_VOW_READREASON     number;
	V_VOW_READCODE   	 number;
	VAL                  number := 0;
	V_SAG_FACTMODE       number := 0;
	V_SAG_FROZEN         number := 0;
	V_SAG_EXOTVA         number := 0;
	V_MCD_NUM            number := 1;
	V_MCD_COEFF          number := 1;
	V_NBR                number:
	V_BAP_NUM            number;   
	V_NBR_ROUES          number;
	V_ANNEE              number;
	V_EQU_TECHINFO       CLOB; 
	V_DATE               DATE;
	V_DATE_FERM          DATE;
	V_PERIODICITE        VARCHAR2(1); 
	V_RL_CP_NUM_RL       VARCHAR2(50);
	V_DISTRICT           VARCHAR2(50);
	V_CODE_MARQUE        VARCHAR2(50);
	V_COMPTEUR_ACTUEL    VARCHAR2(50); 
    V_GRF_NAME		     VARCHAR2(50);
	V_GRF_CODE           VARCHAR2(50);
	V_RL_LECIMP	         VARCHAR2(50);
	V_ABN_REF            VARCHAR2(100);
	V_SAG_COMMENT        VARCHAR2(100);
	V_CODPOLL            VARCHAR2(50);
	V_NAPT               VARCHAR2(50);
	V_CONSMOY            VARCHAR2(50);
	V_ECHTONAS           VARCHAR2(50);
	V_ECHRONAS           VARCHAR2(50);
	V_CAPITONAS          VARCHAR2(50);
	V_INTERONAS          VARCHAR2(50);
	V_ARROND             VARCHAR2(50);
	V_posit 			 VARCHAR2(20);
  
   --Curseur des client et des adm
    cursor c1
    is
     select 1 tp, district, categorie, code, tel, autre_tel, fax, nom, adresse, code_postal
     from   client
     union
     select 2 tp, district, null categorie, code, null tel, null autre_tel, null fax, desig nom, adresse, to_char(code_postal) code_postal
     from   adm;
     
    cursor C2(categ varchar2, code_client varchar2)
    is
     select trim(b.district) district, trim(b.police) police, trim(b.tourne) tourne, trim(b.ordre) ordre,gros_consommateur, b.adresse, date_creation,
            categorie_actuel, client_actuel, lpad(trim(b.code_marque),3,'0') code_marque, lpad(trim(b.compteur_actuel),11, '0') compteur_actuel, b.code_postal,
            b.usage, b.type_branchement, b.aspect_branchement, b.marche, TRIM(b.etat_branchement) etat_branchement
     from   branchement b   
     where  trim(categorie_actuel) = trim(categ)
     and    trim(client_actuel)    = trim(code_client);
    
-----curseur tournee
	cursor c_tourne is 
	SELECT TR.ROU_ID,TR.ROU_CODE,T.NTIERS,T.NSIXIEME,T.district ,T.code
	FROM TOURNE T,TECROUTE TR
	WHERE TR.ROU_CODE=lpad(trim(T.district),2,'0')||'-'||T.CODE;
---------------------------
	CURSOR c3(V_REF varchar2(100)) is select *
									from abonnees a
									where lpad(trim(a.dist),2,'0')||
										  lpad(trim(a.tou),3,'0') ||
										  lpad(trim(a.ord),3,'0') =V_REF 
									and   trim(a.categ)=5
									union 
									select *
									from  abonnees_gr a
									where lpad(trim(a.dist),2,'0')||
										  lpad(trim(a.tou),3,'0') ||
										  lpad(trim(a.ord),3,'0') = V_REF
									and   trim(a.categ)=5;
----------------------------------
	CURSOR rib(V_rib VARCHAR2(100)) is select *
									   from rib_part p
									   where trim(p.rib)=V_rib
									   union
									   select *
									   from rib_gc t 
									   where trim(t.rib)=V_rib;		
	--------------------------------------------------
	cursor C4(V_pdlref VARCHAR2(100)) is select a.adr2,a.codpostal,a.dist,a.tou,a.ord,a.pol
										from faire_suivre_part a
										where lpad(trim(a.dist),2,'0')||
											  lpad(trim(a.tou),3,'0') ||
											  lpad(trim(a.ord),3,'0') ||
											  lpad(trim(a.pol),5,'0')=V_pdlref
										union
										select a.ad2,a.codpostal,a.dist,a.tou,a.ord,a.pol
										from faire_suivre_gc a
										where lpad(trim(a.dist),2,'0')||
											  lpad(trim(a.tou),3,'0') ||
											  lpad(trim(a.ord)),3,'0')||
											  lpad(trim(a.pol),5,'0') =	V_pdlref;
BEGIN
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
		end if; 
		--creation du client     
		v_pk_etape := 'Selection de la cartégorie client'; 
		select vow_id
		into   v_vow_typsag
		from   v_genvocword
		where  voc_code = 'VOW_TYPSAG'    
		and    vow.vow_code = decode(lpad(trim(s1.categorie),2,'0'),'03','01','05','01','07','01','11','01','12','10','1','01','06','01',lpad(trim(s1.categorie),2,'0'));
                     
		if(v_vow_typsag is null)then
		  null;
		  --inserreur erreur recuperation categorie client
		else
			if(s1.tp == 1)then
				v_code_cli := s1.district||trim(s1.categorie)||trim(upper(s1.code));
				v_rec_id=9;
			else
				v_code_cli := s1.district||lpad(trim(s1.code),6,'0');
				v_rec_id=7;
			end if;
			
			v_pk_etape := 'creation du client client';
			select seq_genparty.nextval into v_par_id from dual;
			insert into genparty(par_id,par_refe,par_lname,par_kname,vow_title,adr_id,par_telw,par_telp,par_telf,
								 vow_typsag,vow_partytp, par_status, par_profexotva, par_search, par_updtby)
						  values(v_par_id,v_code_cli,trim(s1.nom),trim(replace(s1.nom,' ','')),v_vow_title,v_adr_id,trim(s1.tel),trim(s1.autre_tel),trim(s1.fax),
								 v_vow_typsag,v_vow_partytp,1,0,1,v_age_id);
		end if;					 
        
        for s2 in C2(s1.categorie, s1.code) loop --branchement
		   v_pk_etape    :='creation du l''adresse du site/pdl';
           v_code_postal := s2.code_postal;
           v_adresse     := s2.adresse;
            if(v_adresse is null or v_code_postal is null)then
				null;
				--inserrer erreur adresse client dans un table mouchard
            else
				--Création de l'adresse client
				v_pk_etape := 'Recherche/Création ville site/pdl';
				Begin 
					select max(twn_id)
					into   v_twn_id
					from   gentown
					where  twn_code = s1.code_postal;
				EXCEPTION WHEN OTHERS THAN 
					   select p.libelle
					   into   v_ville_name
					   from   r_cpostal p
					   where  to_char(p.kcpost) = trim(s1.code_postal)         
					
					   select seq_gentown.nextval into v_twn_id from dual;
					   insert into gentown(twn_id, twn_code, twn_name, twn_namek, twn_zipcode, coy_id, twn_served)
									values(v_twn_id, s1.code_postal,v_ville_name,v_ville_name,s1.code_postal,v_coy_id, 1);         
				COMMIT;
				END;
			end if;
            v_pk_etape := 'Creation rue site/pdl';
            select seq_genstreet.nextval into v_str_id from dual;
            insert into genstreet(str_id, str_name, str_namek, str_namer, twn_id, vow_streettp, str_zipcode, str_served, str_updtby)
                           values(v_str_id, s1.adresse, s1.adresse, s1.adresse, v_twn_id, v_vow_streettp, s1.code_postal, 1, v_age_id);
            
            v_pk_etape := 'Creation adresse site/pdl';               
            select genadress.nextval into v_adr_id from dual;
            insert into genadress(adr_id, str_id, adr_zipcode, adr_updtby)
                           values(v_adr_id, v_str_id, s1.code_postal, v_age_id);
		
			select count(*)
			into nbr_pdl
			from tecservicepoint p,agrserviceagr a
			where p.spt_refe = lpad(s2.district,2,'0')||lpad(s2.tourne,3,'0')||lpad(s2.ordre,3,'0')||lpad(to_char(s2.police),5,'0')
			and   trim(s2.etat_branchement)='0'
			and   p.spt_id=a.spt_id
			and   p.spt_enddt is not null
			and   a.sag_enddt is not null;
		   
		    if nbr_pdl=1 then
				if s2.gros_consommateur = 'O' then
				  SELECT vow.vow_id
				  INTO   v_vow_frqfact
				  FROM   genvoc     voc,
						 genvocword vow
				  WHERE  voc.voc_id   = vow.voc_id
				  AND    vow.vow_code = '30'
				  AND    voc.voc_code = 'VOW_FRQFACT';
				else
				  
				  SELECT vow.vow_id
				  INTO   v_vow_frqfact
				  FROM   genvoc     voc,
						 genvocword vow
				  WHERE  voc.voc_id   = vow.voc_id
				  AND    vow.vow_code = '90'
				  AND    voc.voc_code = 'VOW_FRQFACT';
				end if;
			
				select vow.vow_id
				into   v_vow_spstatus
				from   genvoc voc,
					   genvocword vow
				where  voc.voc_id       = vow.voc_id
				and    voc.voc_code     = 'VOW_SPSTATUS'
				and    vow.vow_internal = 1
				and    vow.vow_code     = decode(nvl(trim(s2.etat_branchement),0),0,1,9,2);
			  
				update agrserviceagr a  
				set sag_enddt=null 
				where a.spt_id in(select p.spt_id 
								  from tecservicepoint p
								  where  p.spt_refe = lpad(s2.district,2,'0')||
													  lpad(s2.tourne,3,'0')||
													  lpad(s2.ordre,3,'0')||
													  lpad(trim(s2.police),5,'0')); 
				update tecservicepoint  
				set spt_enddt=null 
				where p.spt_refe = lpad(s2.district,2,'0')||
								   lpad(s2.tourne,3,'0')||
								   lpad(s2.ordre,3,'0')||
								   lpad(trim(s2.police),5,'0');
				update agrplanningagr t 
				set vow_frqfact=v_vow_frqfact 
				where sag_id=(select sag_id 
							  from  agrserviceagr a  
							  where a.spt_id in (select p.spt_id 
												 from tecservicepoint p
												 where  p.spt_refe = lpad(s2.district,2,'0')||
																	 lpad(s2.tourne,3,'0')||
																	 lpad(s2.ordre,3,'0')||
																	 lpad(trim(s2.police),5,'0')));
				update tecspstatus set vow_spstatus=v_vow_spstatus 
				where  spt_id in(select p.spt_id 
								 from tecservicepoint p
								 where  p.spt_refe = lpad(s2.district,2,'0')||
													 lpad(s2.tourne,3,'0')||
													 lpad(s2.ordre,3,'0')||
													 lpad(trim(s2.police),5,'0'));			
		    else--------------------
				v_pk_etape := 'Creation du site'; 
				v_code_br := lpad(s2.district,2,'0')||lpad(s2.tourne,3,'0')||lpad(s2.ordre,3,'0')||lpad(to_char(s2.police),5,'0');
				select seq_tecpremise.nextval into v_pre_id from dual;
				insert into tecpremise(pre_id,pre_refe,adr_id,vow_premisetp,pre_updtby)
								values(v_pre_id,v_code_br,v_adr_id,v_vow_premisetp,v_age_id);
				v_date     := '01/01/1969';
				v_pk_etape := 'Creation du proprietaire site'; 
				select seq_tecpresptcontact.nextval into v_psc_id from dual;
				insert into tecpresptcontact(psc_id,pre_id,par_id,vow_precontacttp,psc_startdt,psc_enddt,psc_rank)
									  values(v_psc_id, v_pre_id, v_vow_precontacttp,v_date,decode(s2.etat_branchement, '0', Null, '01/01/1900'),1);
				v_pk_etape := 'Creation du PDL'; 
				v_pk_etape := 'Récupértion de l''identifiant de la tournée'; 
				if(lpad(trim(s2.tourne),3,'0')='898' or lpad(trim(s2.tourne),3,'0')='899')then
					BEGIN 
						select max(rou_id)
						into   v_rou_id
						from   tecroute
						where  rou_code=trim(s2.district)||'_AS';
					EXCEPTION OTHERS THEN 
						v_pk_etape := 'Création du TOURNE _AS';
						select seq_TECROUTE.nextval into v_rou_id from dual;
						insert into TECROUTE(ROU_ID,ROU_SECT,ROU_CODE,ROU_NAME)
									  values(v_rou_id,'DIST'||lpad(trim(s2.district),2,'0'),lpad(trim(s2.district),2,'0')||'_AS',lpad(trim(s2.district),2,'0')||'_AS');
						commit;
					END;
				else
					BEGIN 
						select max(rou_id)
						into   v_rou_id
						from   tecroute
						where  rou_code = lpad(trim(s2.tourne),3,'0');
					EXCEPTION WHEN OTHERS THEN 
						v_pk_etape := 'Création du TOURNE';
						for x in select distinct t.district,t.code from tourne t  loop
							select seq_TECROUTE.nextval into v_rou_id  from dual;
							INSERT INTO TECROUTE(ROU_ID,ROU_SECT,ROU_CODE,ROU_NAME)
										  VALUES(V_ROU_ID,'DIST'||lpad(trim(x.district),2,'0'),x.code,x.code);
							commit;
						end loop;
					END;
				end if;
				v_pk_etape := 'Récupération de l''identifiant du fluide';
				select max(fld_id)
				into   v_fld_id
				from   tecfluid
				where  fld_codei = 'PDC EAU';
				v_spt_id := seq_tecservicepoint.nextval;
                Insert Into tecservicepoint(SPT_ID,SPT_REFE,ROU_ID,SPT_ROUTEORDER,SPT_COMMENT,SPT_NEEDRDV,
		                                    VOW_DIFFREAD,VOW_ACCESS,VOW_READINFO1,VOW_READINFO2,VOW_READINFO3,
									        FLD_ID,PRE_ID,ADR_ID) 
								     Values(v_spt_id,v_code_br,v_rou_id,s2.ordre,s2.marche,0,
										    Null,Null,Null,Null,Null,
										    v_fld_id,v_pre_id,v_adr_id);
				v_pk_etape := 'Creation du statut PDL';
				v_sps_id := seq_tecspstatus.nextval;
				v_pk_etape := 'Récpération du statut du PDL';
			
				BEGIN
					select decode(nvl(posit,0),0,0,1,0,2,0,9,9), codpoll, napt, consmoy, echronas, echtonas, capitonas, interonas, arrond, '1'
					into   v_posit, v_codpoll, v_napt, v_consmoy, v_echronas, v_echtonas, v_capitonas, v_interonas, v_arrond, v_periodicite
					from   abonnees t
					where  lpad(t.pol,5,'0')           = lpad(s2.police,5,'0')
					and    lpad(t.tou,3,'0')           = lpad(s2.tourne,3,'0')
					and    lpad(t.ord,3,'0')           = lpad(s2.ordre,3,'0')
					and    t.dist                      = s2.district;
				EXCEPTION WHEN OTHERS THEN 
					v_posit := 0;
				END;
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
				where  div_code = lpad(trim(s2.district),2,'0');
			    v_pk_etape := 'Récupération de Division';
				BEGIN
					if lpad(trim(s2.district),2,'0')='57' then
						select div_id
						into   v_div_id
						from   gendivision
						where  div_code = ='22';
					elsif lpad(trim(s2.district),2,'0')='58' then
						select div_id
						into   v_div_id
						from   gendivision
						where  div_code = ='32';	
					elsif lpad(trim(s2.district),2,'0')='60' then
						select div_id
						into   v_div_id
						from   gendivision
						where  div_code = ='36';			
					elsif lpad(trim(s2.district),2,'0')='61' then
						select div_id
						into   v_div_id
						from   gendivision
						where  div_code = ='03';
					elsif lpad(trim(s2.district),2,'0')='63' then
						select div_id
						into   v_div_id
						from   gendivision
						where  div_code = ='15';
					end if ;
				EXCEPTION WHEN OTHERS THEN 
					select div_id
					into   v_div_id
					from   gendivision
					where  div_code = lpad(trim(s2.district),2,'0');
				END;
				select dvt_id
				into   v_dvt_id
				from   gendivdit
				where  div_id = v_div_id
				and    dit_id = 1; --DISTRICT
				Insert into gendivspt(dpr_id  , dvt_id  , spt_id)
							   values(v_dpr_id, v_dvt_id, v_spt_id);
				v_pk_etape := 'Création de l''affectation de l''organisation du PDL';
				BEGIN
					if lpad(trim(s2.district),2,'0')='57' then
						select max(g.org_id)	
						into V_ORG_ID 
						from GENORGANIZATION g 
						where g.org_code='22';
					elsif lpad(trim(s2.district),2,'0')='58' then
						select max(g.org_id)
						into V_ORG_ID 
						from GENORGANIZATION g 
						where g.org_code='32';	
					elsif lpad(trim(s2.district),2,'0')='60' then
						select max(g.org_id)
						into V_ORG_ID 
						from GENORGANIZATION g 
						where g.org_code='36';			
					elsif lpad(trim(s2.district),2,'0')='61' then
						select max(g.org_id)
						into V_ORG_ID 
						from GENORGANIZATION g 
						where g.org_code='03';
					elsif lpad(trim(s2.district),2,'0')='63' then
						select max(g.org_id)
						into V_ORG_ID 
						from GENORGANIZATION g 
						where g.org_code='15';
					end if ;
				EXCEPTION WHEN OTHERS THEN 
					select max(g.org_id)	
					into V_ORG_ID 
					from GENORGANIZATION g 
					where g.org_code=lpad(trim(s2.district),2,'0');
				END;	
				if v_org_id is not null then
					v_spo_id := seq_tecsptorg.nextval;
					insert into tecsptorg(spo_id  , spt_id, org_id, spo_comment)
								   values(V_SPO_ID, V_SPT_ID, V_ORG_ID,'Migration');
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
				-------------VOW_CONSTATUS
				select vow.vow_id
				into   v_vow_constatus
				from   genvoc     voc,
					   genvocword vow
				where  voc.voc_id       = vow.voc_id
				and    voc.voc_code     = 'VOW_CONSTATUS'
				and    vow.vow_code    = decode(s2.aspect_branchement, 'B', 'B', 'M', 'M', 'I', 'I', 'I');
				v_pk_etape := 'Récupération de la nature du branchement';
				 -------------VOW_CONNAT
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
				v_pk_etape 		  := 'Selection compteur reel';
				V_DISTRICT        := lpad(trim(s2.district),2,'0');
				V_CODE_MARQUE     := lpad(trim(s2.code_marque),3,'0');
				V_COMPTEUR_ACTUEL := lpad(trim(s2.compteur_actuel),11,'0'); 
				if v_compteur_actuel Is Null then
					BEGIN
						select lpad(trim(b.district),2,'0'),lpad(trim(b.codemarque),3,'0') code_marque ,lpad(trim(b.ncompteur),11,'0') compteur_actuel
						into   V_DISTRICT,V_CODE_MARQUE,V_COMPTEUR_ACTUEL
						from   fiche_releve b
						where  lpad(trim(b.district),2,'0')||lpad(trim(b.tourne),3,'0')||lpad(trim(b.ordre),3,'0')=substr(v_code_br,1,8)
						and    trim(b.annee)||trim(b.trim)=(select max(trim(f.annee)||trim(f.trim)) 
															from fiche_releve f
															where  lpad(trim(f.district),2,'0')||lpad(trim(f.tourne),3,'0')||lpad(trim(f.ordre),3,'0')=substr(v_code_br,1,8)
															and    trim(f.ncompteur) is not null 
															and    trim(f.codemarque)!='000');
					EXCEPTION WHEN OTHERS THEN
						BEGIN
							select  lpad(trim(c.district),2,'0'),lpad(trim(c.code_marque),3,'0') code_marque, lpad(trim(c.num_compteur),11,'0') compteur_actuel
							into    V_DISTRICT, V_CODE_MARQUE,V_COMPTEUR_ACTUEL
							from    gestion_compteur c
							where   lpad(trim(c.district),2,'0')||lpad(trim(c.tournee),3,'0')||lpad(trim(c.ordre),3,'0')=substr(v_code_br,1,8)
							and     trim(c.num_compteur) is not null
							and     trim(c.annee)||trim(c.trim) = (select max(trim(b.annee)||trim(b.trim)) 
																   from gestion_compteur b
																   where lpad(trim(b.district),2,'0')||lpad(trim(b.tournee),3,'0')||lpad(trim(b.ordre),3,'0')=substr(v_code_br,1,8));
						EXCEPTION WHEN OTHERS THEN
							v_rl_cp_num_rl:=V_DISTRICT||'00000000000000';
						END;
					END;
			    end if;
				if (v_rl_cp_num_rl:=V_DISTRICT||'00000000000000') then
					select max(to_number(replace(substr(e.equ_realnumber,3,length(e.equ_realnumber)),'MIG',0)))+1
					into val
					from tecequipment e 
					where e.equ_realnumber like'%MIG%'
					and substr(e.equ_realnumber,1,2)=V_DISTRICT;
						   
					v_rl_cp_num_rl := V_DISTRICT ||'MIG'||lpad(val,11,'0');
				else
					v_rl_cp_num_rl := V_DISTRICT || V_CODE_MARQUE || V_COMPTEUR_ACTUEL;
				end if;
             
				--recupere diam  de comteur
				BEGIN
					select c.diam_compteur,/*c.nbr_roues,*/ c.annee_fabrication 
					into   V_VOC_DIAM, /*V_NBR_ROUES,*/ V_ANNEE
					from   compteur c
					where  lpad(trim(c.district),2,'0')||lpad(trim(c.code_marque),3,'0')||lpad(trim(c.num_compteur),11,'0') = v_rl_cp_num_rl;
				EXCEPTION WHEN OTHERS THEN 
					BEGIN
						select  b.diamctr,/*b.nbre_roues,*/0
						into   V_VOC_DIAM,/*V_NBR_ROUES,*/V_ANNEE
						from fiche_releve b
						where trim(b.annee)||trim(b.trim)=(select max(trim(f.annee)||trim(f.trim)) 
														   from fiche_releve f
														   where trim(f.district)||lpad(trim(f.tourne),3,'0')||lpad(trim(f.ordre),3,'0')
																=trim(b.district)||lpad(trim(b.tourne),3,'0')||lpad(trim(b.ordre),3,'0')
														   and trim(f.ncompteur) is not null 
														   and trim(f.codemarque)!='000')
						and lpad(trim(b.district),2,'0')||lpad(trim(b.codemarque),3,'0')||lpad(trim(b.ncompteur),11,'0')=v_rl_cp_num_rl
						and trim(b.ncompteur) is not null;
					EXCEPTION WHEN OTHERS THAN
						V_VOC_DIAM  := 0;
						V_ANNEE     := 0;
						V_NBR_ROUES := 0; 
					END;
				END;
				--recupere class de compteur
				-------------V_VOC_CLASS
				BEGIN
					select  m.classe 
					into    V_VOC_CLASS 
					from    compteur c,marque m
					where   c.code_marque = m.code
					and     c.district    = m.district
					and     lpad(trim(c.district),2,'0')||lpad(trim(c.code_marque),3,'0')||lpad(trim(c.num_compteur),11,'0')= v_rl_cp_num_rl;
					and rownum            = 1;
				EXCEPTION WHEN OTHERS THEN 
					V_VOC_CLASS := 0;
				END;
            
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
				else  v_nbr_roues:=4; 
				end if;
				v_equ_id := seq_tecequipment.nextval;
				v_equ_realnumber := v_rl_cp_num_rl;
				SELECT vow.vow_id
				INTO   v_vow_equstatus
				FROM   genvoc     voc,
					   genvocword vow
				WHERE  voc.voc_id = vow.voc_id
				AND    vow.vow_code     = '1'
				AND    vow.vow_internal = 1
				AND    voc.voc_code     = 'VOW_EQUSTATUS';
				if v_nbr_roues Is Not Null then 
					SELECT '<?xml version="1.0" encoding="iso-8859-15"?>'||
						   CHR(10)||
						   xmlagg(xmlelement("parameters",
						   xmlelement("longueur'" , NVL(v_nbr_roues, 0)),
						   xmlelement("nombreroue", Null)))
					INTO   v_equ_techinfo 
					FROM   dual ;
				end if;
				----------------eqy_id
				SELECT eqy_id
				INTO   v_eqy_id 
				FROM   Tecequtype
				WHERE  eqy_code = 'EAU';
				----------------VOW_MODEL
				SELECT vow.vow_id
				INTO   v_vow_model
				FROM   genvoc     voc,
					   genvocword vow
				WHERE  voc.voc_id = vow.voc_id
				AND    vow.vow_code     = v_code_marque
				AND    voc.voc_code     = 'VOW_MODEL';
				----------------mmo_id
				SELECT  mmo_id 
				INTO    v_mmo_id
				FROM    tecequmodel
				WHERE   eqy_id       = v_eqy_id
				and     vow_manufact = v_vow_manufact
				and     vow_model    = v_vow_model;
				----------------VOW_OWNER
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
				Insert into tecmeter(equ_id, mtc_id) values(v_equ_id, v_mtc_id);
				--------------VOW_DIAM
				SELECT vow.vow_id
				INTO   v_vow_diam
				FROM   genvoc     voc,
					   genvocword vow
				WHERE  voc.voc_id = vow.voc_id
				AND    vow.vow_code     = v_voc_diam
				AND    voc.voc_code     = 'VOW_DIAM';
				----------------VOW_CLASS
				BEGIN
					SELECT vow.vow_id
					INTO   v_vow_class
					FROM   genvoc     voc,
						   genvocword vow
					WHERE  voc.voc_id          = vow.voc_id
					AND    upper(vow.vow_code) = v_voc_class
					AND    voc.voc_code        = 'VOW_CLASS';
				EXCEPTION WHEN OTHERS THEN
					SELECT vow.vow_id
					INTO   V_VOW_CLASS
					FROM   genvoc     voc,
						   genvocword vow
					WHERE  voc.voc_id          = vow.voc_id
					AND    upper(vow.vow_code) = 'INCONNUE'
					AND    voc.voc_code        = 'VOW_CLASS';
				END;
				v_pk_etape := 'Création Compteur EAU';
				insert into tecmtrwater(equ_id, vow_diam, vow_class, vow_qn)
								 values(v_equ_id, v_vow_diam, v_vow_class, Null);
				v_pk_etape := 'Création Modele Compteur';				 
				select seq_tecequmodel.NEXTVAL  into v_mmo_id from dual;
				insert into tecequmodel (mmo_id,eqy_id,vow_manufact,vow_model)
								 values (v_mmo_id,v_eqy_id,v_vow_manufact,V_vow_model);			 
							 
				v_pk_etape := 'Selection Historique Compteur';					 
				v_heq_id := seq_techequipment.nextval;
				SELECT  MAX(TO_DATE( m.date_res,'dd/mm/yyyy'))
				INTO    v_date_ferm
				FROM    branchement_res_max m
				WHERE   m.dist || m.ref_pdl = substr(v_code_br,1,8)
				AND     TRIM(s2.etat_branchement) = '9';
				
				if v_date_ferm IS NULL then
					v_voc_pose   := 'P';
					v_voc_depose := NULL;
				else
					v_voc_pose   := NULL;
					v_voc_depose :='D';
				end if;
				-------------VOW_REASPOSE
				SELECT vow.vow_id
				INTO   v_vow_reaspose
				FROM   genvoc     voc,
					   genvocword vow
				WHERE  voc.voc_id   = vow.voc_id
				AND    vow.vow_code = v_voc_pose
				AND    voc.voc_code = 'VOW_REASPOSE';
				----------------VOW_REASDEPOSE
				SELECT vow.vow_id
				INTO   v_vow_reasdepose
				FROM   genvoc     voc,
					   genvocword vow
				WHERE  voc.voc_id   = vow.voc_id
				AND    vow.vow_code = v_voc_depose
				AND    voc.voc_code = 'VOW_REASDEPOSE';
				v_pk_etape := 'Création Historique Compteur';
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
				v_vow_frozen     := Null;
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
				WHERE  voc.voc_id       = vow.voc_id
				AND    vow.vow_code     = s2.usage
				AND    voc.voc_code     = 'VOW_USGSAG';
				--Type de Service PDS
				--Si gros consommateur == Oui, alors 'G' sinon 'P'
				if s2.gros_consommateur = 'O' then
					--v_aac_avgconsumimp := v_consmoy / 30;
					  v_dlp_id           := 3;
					  SELECT vow.vow_id
					  INTO   v_vow_frqfact
					  FROM   genvoc     voc,
							 genvocword vow
					  WHERE  voc.voc_id   = vow.voc_id
					  AND    vow.vow_code = '30'
					  AND    voc.voc_code = 'VOW_FRQFACT';
				else
					--v_aac_avgconsumimp := v_consmoy / 90;
					v_dlp_id           := 5;
					SELECT vow.vow_id
					INTO   v_vow_frqfact
					FROM   genvoc     voc,
						   genvocword vow
					WHERE  voc.voc_id   = vow.voc_id
					AND    vow.vow_code = '90'
					AND    voc.voc_code = 'VOW_FRQFACT';
				end if;
				--v_aac_avgconsummrd := v_consmoy;
				v_pk_etape := 'Selection Contrat';
				select count(*) 
				into V_NBR
				from agrserviceagr a 
				where  substr(a.sag_refe,1,2)=trim(v_district)
				and    substr(a.sag_refe,length(a.sag_refe)-4)=lpad(to_char(trim(s2.police)),5,'0');  
				
				if V_NBR=0 then 
				   v_abn_ref := trim(v_district)||'0'||lpad(to_char(trim(s2.police)),5,'0');
				else 
				   v_abn_ref := trim(v_district)||V_NBR||lpad(to_char(trim(s2.police)),5,'0');
				end if;
			    v_cag_id  := seq_agrcustomeragr.nextval;
				--Création du contrat 
				insert into agrcustomeragr(cag_id, pre_id, par_id, cag_refe, cag_startdt, cag_enddt)
									values(v_cag_id, v_pre_id, v_par_id, v_abn_ref, v_date, v_date_ferm);
				--Recerche du groupe de facturation
				 V_pk_etape := 'Selection GROUP Facturation';
				if V_ROU_ID IS NOT NULL then
					BEGIN 
						SELECT grf_id
						INTO   V_GRF_ID
						FROM   tecroute
						WHERE  rou_id = V_ROU_ID;
					EXCEPTION WHEN OTHERS THEN 
						For gf in c_tourne loop
							select seq_agrgrpfact.nextval 	 
							into V_GRF_ID    
							from dual;
							V_GRF_CODE := lpad(trim(gf.district),2,'0')||gf.NTIERS||gf.NSIXIEME;
							
							if gf.NTIERS||gf.NSIXIEME='00' then 
								V_GRF_NAME :='Groupe facturation '||lpad(trim(gf.district),2,'0')||'M';
							else    
								V_GRF_NAME :='Groupe facturation '||lpad(trim(gf.district),2,'0')||gf.NTIERS||gf.NSIXIEME;
							end if;   
							v_pk_etape := 'Création Group Facturation';
							insert into agrgrpfact(GRF_ID,GRF_CODE,GRF_NAME,grf_name_a)
											values(V_GRF_ID,V_GRF_CODE,V_GRF_NAME,V_GRF_NAME);
							COMMIT;
							update tecroute s set s.grf_id=V_GRF_ID where s.rou_id=gf.rou_id;
							 
							BEGIN
								select t.ROU_ID  
								into  V_ROU_ID
								from  TECROUCUT t
								where t.ROU_ID   =gf.ROU_ID
								and   t.RCU_THIRD=gf.NTIERS
								and   t.RCU_SIXTH=gf.NSIXIEME;
							EXCEPTION WHEN OTHERS THAN
								INSERT INTO TECROUCUT(ROU_ID,RCU_THIRD,RCU_SIXTH) 
											   VALUES(gf.ROU_ID,gf.NTIERS,gf.NSIXIEME);
							END;			   
							COMMIT;
						END LOOP;
					END;
				end if;
				v_sag_id := seq_agrserviceagr.nextval;
				--Création du PDS
				v_pk_etape := 'Création du PDS';
				insert into agrserviceagr(sag_id, sag_refe, sag_startdt, sag_enddt, cag_id, spt_id, grf_id, ctt_id, sag_factmode, sag_frozen, sag_frozendt, sag_exotva,
										  vow_frozen, vow_typdurbill, vow_cutagree, vow_typsag, vow_usgsag, sag_comment, sag_credt, sag_updtdt, sag_updtby)
								   values(v_sag_id, v_abn_ref, v_date, v_date_ferm, v_cag_id, v_spt_id, v_grf_id, v_ctt_id, v_sag_factmode, v_sag_frozen, Null, v_sag_exotva,
										  v_vow_frozen,v_vow_typdurbill, v_vow_cutagree, v_vow_typsag, v_vow_usgsag, v_sag_comment, sysdate, Null, v_age_id);
				--Création de l'abonné
				v_pk_etape := 'Création du L''abonnees';
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
				v_pk_etape := 'Création modalité de paiement';
				v_stl_id := seq_agrsettlement.nextval;
				-----------------VOW_SETTLEMODE
				SELECT vow.vow_id
				INTO   v_vow_settlemode
				FROM   genvoc     voc,
					   genvocword vow
				WHERE  voc.voc_id   = vow.voc_id
				AND    vow.vow_code = '4'
				AND    voc.voc_code = 'VOW_SETTLEMODE';--Autres
				SELECT vow.vow_id
				INTO   v_vow_nbbill
				FROM   genvoc     voc,
					   genvocword vow
				WHERE  voc.voc_id   = vow.voc_id
				AND    vow.vow_code = '1'--1ex.
				AND    voc.voc_code = 'VOW_NBBILL';
				insert into agrsettlement(stl_id, sag_id, stl_startdt, vow_settlemode, vow_nbbill, dlp_id)
								   values(v_stl_id, v_sag_id, v_date, v_vow_settlemode, v_vow_nbbill, v_dlp_id);
				v_pk_etape := 'Création du payeur';				   
				--Création du payeur
				-----------------VOW_AGRCONTACTTP
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
				
				v_pk_etape := 'Création de l''adresse de facturation';	
				--Création de l'adresse de facturation
				-----------------VOW_PARTYTP
				v_paa_id := seq_GENPARTYPARTY.nextval;
				SELECT vow.vow_id
				INTO   v_vow_partytp
				FROM   genvoc     voc,
					   genvocword vow
				WHERE  voc.voc_id   = vow.voc_id
				AND    vow.vow_code = '4'--Adresse de Facturation
				AND    voc.voc_code = 'VOW_PARTYTP';
				insert into genpartyparty(paa_id, par_parent_id, adr_id, vow_partytp, paa_startdt, paa_enddt)
								   values(v_paa_id, v_par_id, v_adr_id, v_vow_partytp, v_date, v_date_ferm);
				v_pay_id := seq_agrpayor.nextval;
				insert into agrpayor(pay_id, cot_id, paa_id)
							  values(v_pay_id, v_cot_id, v_paa_id);
				--Création du compte client
				v_aco_id := seq_genaccount.nextval;
				----------------VOW_ACOTP
				SELECT vow.vow_id
				INTO   v_vow_acotp
				FROM   genvoc     voc,
					   genvocword vow
				WHERE  voc.voc_id   = vow.voc_id
				AND    vow.vow_code = '1'--Client
				AND    voc.voc_code = 'VOW_ACOTP';
				insert into genaccount(aco_id, par_id, imp_id, vow_acotp, rec_id, aco_status, ACO_COMMENT)
							   values(v_aco_id, v_par_id, v_imp_id, v_vow_acotp, v_rec_id, 0, 'Migration');
				v_sco_id := seq_agrsagaco.nextval;
				insert into agrsagaco(sco_id, sco_startdt, sco_enddt, sag_id, aco_id)
							   values(v_sco_id, v_date, v_date_ferm, v_sag_id, v_aco_id);
				--Création de l'offre de facturation du PDS
				v_hsf_id := seq_agrhsagofr.nextval;
				insert into agrhsagofr(hsf_id, sag_id, ofr_id, hsf_startdt, hsf_enddt)
								values(v_hsf_id, v_sag_id, v_ofr_id, v_date, v_date_ferm);
				insert into agrplanningagr(sag_id, vow_frqfact, agp_factday, agp_factmtmax, agp_factmtmin, agp_nextfactdt, agp_nextreaddt,
										   vow_modefactnext,agp_nextfactdtold, agp_factnextrelold, vow_modefactold, agp_sagdt, agp_sagdtold)
									values(v_sag_id,v_vow_frqfact,10,null,null,sysdate,null,
										   V_VOW_MODEFACTNEXT,sysdate,null,null,sysdate,null);
									   
				FOR s3 in c3(substr(V_CODE_BR,1,8)LOOP
					FOR x in rib(trim(s2.banque)||trim(s2.agence)||trim(s2.num_compte)||trim(s2.cle_rib))LOOP
						v_pk_etape := 'Création Compte Bancaire';
						BEGIN 
							select BAN_ID 
							into   V_BAN_ID 
							from from genbank 
							where substr(ban_code,1,5)=substr(s3.rib,1,5);
						EXCEPTION WHEN OTHERS THEn 
							select seq_genbank.nextval 
							into V_BAN_ID  
							from dual;
							insert into genbank(BAN_ID,BAN_CODE,BAN_NAME) 
										 values(V_BAN_ID,substr(s3.rib,1,5),substr(s3.rib,1,2));
						END;	
						select seq_genbankparty.nextval 
						into V_BAP_ID  
						from dual;
						select nvl(max(BAP_NUM),0)+1 
						into V_BAP_NUM 
						from genbankparty 
						where PAR_ID=V_par_id;
						
						INSERT INTO genbankparty(BAP_ID,BAP_NUM,BAP_NAME,PAR_ID,BAN_ID,BAP_ACCOUNTNUMBER,BAP_ACCOUNTKEY,BAP_STATUS,BAP_IBANNUMBER)
										  VALUES(V_BAP_ID,V_BAP_NUM,trim(s1.nom),V_PAR_ID,V_BAN_ID,s3.rib,substr(s3.rib,19,2),1,substr(s3.rib,6,13));
						 
						SELECT vow.vow_id
						INTO   v_vow_settlemode
						FROM   genvoc     voc,
							   genvocword vow
						WHERE  voc.voc_id   = vow.voc_id
						AND    vow.vow_code = '2'--Domiciliation bancaire
						AND    voc.voc_code = 'VOW_SETTLEMODE';
						
						update agrsettlement t 
						set t.VOW_SETTLEMODE=V_VOW_SETTLEMODE,t.bap_id = V_BAP_ID
						where t.sag_id in(select distinct(f.sag_id) 
										  from agrpayor r,
											   agrcustagrcontact f 
										  where r.cot_id=f.cot_id
										  and   f.cot_enddt is null
										  and   f.par_id=V_PAR_ID);
					END LOOP;
			    END LOOP;
			    v_pk_etape := 'Création Adresse Facturation';
				FOR s4 in c4(V_CODE_BR) LOOP
					select seq_genpartyparty.NEXTVAL 
					into V_PAA_ID 
					from dual;
					INSERT into genpartyparty(PAA_ID ,PAR_PARENT_ID,VOW_PARTYTP,ADR_ID,PAA_STARTDT)
									   values(V_PAA_ID,V_PAR_ID,V_VOW_PARTYTP,V_ADR_ID,v_date);
					commit;
				END LOOP;	
                v_pk_etape := 'Création Plafond de consommation';
				select hsf_id, ofr_id
				into   v_hsf_id, v_ofr_id
				from   agrhsagofr hsf
				where  hsf.sag_id = V_SAG_ID
				and    hsf.hsf_startdt = (select max(hsf2.hsf_startdt)
						                  from   agrhsagofr hsf2
						                  where  hsf2.sag_id = V_SAG_ID);
				select nvl(max(asu_num),0)+1
				into   v_asu_num
				from   agrsubscription
				where  sag_id = V_SAG_ID;
				
				select seq_agrsubscription.nextval into v_asu_id from dual;
				insert into agrsubscription(asu_id,asu_num,hsf_id,sag_id,ofr_id,sut_id,asu_startdt,asu_updtby)
									 values(v_asu_id,v_asu_num,v_hsf_id,V_SAG_ID,v_ofr_id,v_sut_id,v_date,1);
				select seq_agrsubscriptionvalue.nextval into v_suv_id from dual;
				insert into agrsubscriptionvalue(suv_id,asu_id,vow_value,suv_updtby)
										  values(v_suv_id,v_asu_id,v_vow_value,1);
                commit; 
		    END LOOP;						   
		end if;							   
    END LOOP;
END;
