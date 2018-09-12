create or replace PROCEDURE MIWT_PERSONNE is
 
    -- adresse du premier branchement d'un client
    cursor adr_branch(categorie_ varchar2, code_ varchar2, v_district varchar2) is
    select a.code_postal, a.adresse
    from branchement a
    where a.categorie_actuel = categorie_
    and a.client_actuel = code_
    and a.district =v_district
    and a.adresse is not null;
    
    -- variables de traitement
    v_ad_vilrue      number(10);
    v_ad_num         number(10);
    v_categ_client   varchar2(500);
    v_nom            varchar2(500);
    v_code_postal_br varchar2(500);
    v_adr_branch     varchar2(800);
    err_code         varchar2(200);
    err_msg          varchar2(200);
    NBR_tot          number := 0;
    rindex           pls_integer := -1;
    slno             pls_integer;
    v_op_name        varchar2(200);
    v_startdt        date;
    v_enddt          date;

    begin
		select sysdate into v_startdt from dual;
		dbms_output.put_line('miwtpersonne start = '||v_startdt);
		execute immediate 'alter session set nls_date_format = ''dd/mm/yyyy''';
		execute immediate 'alter session set NLS_NUMERIC_CHARACTERS = '',.''';
		insert into prob_migration (nom_table,val_ref)values(SYSTIMESTAMP||'   START MIWT_PERSONNE' ,'--');
		commit;
		--**************************************************
		-- pour le suivi d'avancement du traitement
		select count(*) into NBR_tot from client;
		v_op_name := to_char(sysdate, 'ddmmyyyyhh24miss');
		commit;
		dbms_application_info.set_session_longops(RINDEX    => rindex,
												  SLNO      => slno,
												  target    => '1',
												  OP_NAME   => v_op_name,
												  SOFAR     => 0,
												  TOTALWORK => NBR_tot);
		--**************************************************
        -- reception de la liste des clients
		for client_ in (select * 
					   from CLIENT c
					   where c.categorie||code in (select t.categorie||t.code
												   from CLIENT t
												   where t.district=c.district
												   group by t.categorie||t.code
												   having count(*) = 1)) 
		loop
			if true is NOT null then
				-- insertion de l'adresse
				v_ad_num := null;
				if ltrim(rtrim(client_.adresse)) is not null then
				  -- insertion de la ville
					v_ad_vilrue := null;
					v_nom       := null;
					miwtADRESSEPIVOT.MIG_ADR(v_adresse_   => ltrim(rtrim(client_.adresse)),
					v_ad_vilrue_ => NVL(V_AD_VILRUE,999999999),
					V_CODE_POSTAL_ =>CLIENT_.CODE_POSTAL,
					v_district => CLIENT_.District,
					v_ad_num_    => v_ad_num);
				else
					v_code_postal_br := null;
					v_adr_branch     := null;
					for adr_ in adr_branch(trim(client_.categorie),trim(client_.code), CLIENT_.District) 
					loop
					  v_code_postal_br := to_char(trim(adr_.code_postal));
					  v_adr_branch     := trim(adr_.adresse);
					  exit;
					end loop;
					if v_adr_branch is not null then
						v_ad_num := null;
						-- insertion de la ville
						v_ad_vilrue := null;
						v_nom       := null;

						miwtADRESSEPIVOT.MIG_ADR(v_adresse_   => v_adr_branch,
						v_ad_vilrue_ => v_ad_vilrue,
						V_CODE_POSTAL_ =>CLIENT_.CODE_POSTAL,
						v_district=> CLIENT_.District,
						v_ad_num_    => v_ad_num);
					else
						v_ad_num :=0; 
								  
					end if;
                end if;
            end if; 
		    v_categ_client:=trim(client_.categorie);     
			-- insertion du client
		    v_nom := nvl(trim(client_.nom), 'Inconnu');
		    IF V_AD_NUM IS NULL THEN V_AD_NUM:=0; END IF;
            BEGIN
				INSERT INTO MIWTPERSONNE
				(
				MPER_SOURCE    ,--1     VARCHAR2(100)  N      CODE SOURCE/ORIGINE DE LA DONNEE
				MPER_REF       ,--2     VARCHAR2(100)  N      IDENTIFIANT UNIQUE DE LA DONNEE POUR LA SOURCE
				MPER_REFE      ,--3     VARCHAR2(100)  Y      REFERENCE DE LA PERSONNE [TA20]
				MPER_NOM       ,--4     VARCHAR2(100)  Y      NOM DE LA PERSONNE [TA30]
				MPER_PRENOM    ,--5     VARCHAR2(100)  Y      PRENOM DE LA PERSONNE [TA38]
				MPER_COMPL_NOM ,--6     VARCHAR2(100)  Y      COMPLEMENT DU NOM [TA38]
				VOC_TITLE      ,--7     VARCHAR2(100)  Y      CLE SOURCE DU TITRE D UNE PERSONNE DANS LA TABLE DES CORRESPONDANCES
				MPER_REF_ADR   ,--8     VARCHAR2(100)  Y      CLE SOURCE DE L ADRESSE DE LA PERSONNE
				MPER_TEL       ,--9     VARCHAR2(15)   Y      NUMERO DE TELEPHONE DE LA PERSONNE
				MPER_TEL_BUREAU,--10    VARCHAR2(15)   Y      NUMERO DE TELEPHONE DU BUREAU DE LA PERSONNE
				MPER_FAX       ,--11    VARCHAR2(15)   Y      NUMERO DE FAX DE LA PERSONNE
				MPER_TEL_MOBIL ,--12    VARCHAR2(15)   Y      TELEPHONE MOBILE (IE PORTABLE) DE LA PERSONNE
				MPER_TEL_MOBIL1,--13    VARCHAR2(15)   Y
				MPER_MAIL      ,--14    VARCHAR2(255)  Y      MAIL DE LA PERSONNE [TA255]
				MPER_MAIL1     ,--15    VARCHAR2(255)  Y
				VOC_TYPSAG      --16    NUMBER(10)     Y      TYPE DE PROFIL (PROFESSIONNELLE, DOMESTIQUE..)
				)
				VALUES
				(
				'DIST'||CLIENT_.District  ,--1
				CLIENT_.District||trim(client_.categorie)||trim(upper(client_.code)),--2
				CLIENT_.District||trim(client_.categorie)||trim(upper(client_.code)),--3
				trim(v_nom),--4
				trim(v_nom),--5
				NULL               ,--6
				'-'                ,--7
				V_AD_NUM           ,--8
				trim(client_.tel),--9
				trim(client_.autre_tel),--10
				trim(client_.fax),--11
				NULL               ,--12
				NULL               ,--13
				NULL               ,--14
				NULL               ,--15
				decode(lpad(trim(v_categ_client),2,'0'),'03','01','05','01','07','01','11','01','12','10','1','01','06','01',lpad(ltrim(rtrim(v_categ_client)),2,'0'))--16
				);
			EXCEPTION WHEN OTHERS THEN
				err_code := SQLCODE;
				err_msg  := SUBSTR(SQLERRM, 1, 200);
				insert into prob_migration
				(nom_table, val_ref, sql_err, date_pro,type_problem)
				values
				('miwt adr pers',
				CLIENT_.District||' '||client_.categorie ||client_.code||'--'||V_AD_NUM,
				err_code || '--' || err_msg,sysdate,'manque adresse personne');
				commit;
				exit;
			END; 
    end loop; 
    for adm_ in (select * from adm a ) loop
        miwtADRESSEPIVOT.MIG_ADR(v_adresse_   => adm_.adresse,
                               v_ad_vilrue_ => v_ad_vilrue,
                               V_CODE_POSTAL_ =>adm_.code_postal,
                               v_district=> adm_.district,
                               v_ad_num_    => v_ad_num);

        IF V_AD_NUM IS NULL THEN V_AD_NUM:=0; END IF;
        begin
		  INSERT INTO MIWTPERSONNE
			 (
			  MPER_SOURCE   ,--1  VARCHAR2(100)  N     CODE SOURCE/ORIGINE DE LA DONNEE
			  MPER_REF      ,--2  VARCHAR2(100)  N     IDENTIFIANT UNIQUE DE LA DONNEE POUR LA SOURCE
			  MPER_REFE     ,--3  VARCHAR2(100)  Y     REFERENCE DE LA PERSONNE [TA20]
			  MPER_NOM      ,--4  VARCHAR2(100)  Y     NOM DE LA PERSONNE [TA30]
			  MPER_PRENOM   ,--5  VARCHAR2(100)  Y     PRENOM DE LA PERSONNE [TA38]
			  MPER_COMPL_NOM,--6  VARCHAR2(100)  Y     COMPLEMENT DU NOM [TA38]
			  VOC_TITLE     ,--7  VARCHAR2(100)  Y     CLE SOURCE DU TITRE D UNE PERSONNE DANS LA TABLE DES CORRESPONDANCES
			  MPER_REF_ADR  ,--8  VARCHAR2(100)  Y     CLE SOURCE DE L ADRESSE DE LA PERSONNE
			  MPER_TEL      ,--9  VARCHAR2(15)   Y     NUMERO DE TELEPHONE DE LA PERSONNE
			  MPER_TEL_BUREAU,--10VARCHAR2(15)   Y     NUMERO DE TELEPHONE DU BUREAU DE LA PERSONNE
			  MPER_FAX      ,--11 VARCHAR2(15)   Y     NUMERO DE FAX DE LA PERSONNE
			  MPER_TEL_MOBIL,--12 VARCHAR2(15)   Y     TELEPHONE MOBILE (IE PORTABLE) DE LA PERSONNE
			  MPER_TEL_MOBIL1,--13VARCHAR2(15)   Y
			  MPER_MAIL     ,--14 VARCHAR2(255)  Y      MAIL DE LA PERSONNE [TA255]
			  MPER_MAIL1    ,--15 VARCHAR2(255)  Y
			  VOC_TYPSAG     --16 NUMBER(10)     Y      TYPE DE PROFIL (PROFESSIONNELLE, DOMESTIQUE..)
			 )
			 VALUES
			 (
			  'DIST'||adm_.district       ,--1           VARCHAR2(100)  N      CODE SOURCE/ORIGINE DE LA DONNEE
			  lpad(trim(adm_.code),6,'0'),--2 VARCHAR2(100)  N      IDENTIFIANT UNIQUE DE LA DONNEE POUR LA SOURCE
			  lpad(trim(adm_.code),6,'0'),--3 VARCHAR2(100)  Y      REFERENCE DE LA PERSONNE [TA20]
			  TRIM(adm_.desig),--4            VARCHAR2(100)  Y      NOM DE LA PERSONNE [TA30]
			  TRIM(adm_.desig),--5            VARCHAR2(100)  Y      PRENOM DE LA PERSONNE [TA38]
			  NULL                    ,--6            VARCHAR2(100)  Y      COMPLEMENT DU NOM [TA38]
			  '-'                     ,--7            VARCHAR2(100)  Y      CLE SOURCE DU TITRE D UNE PERSONNE DANS LA TABLE DES CORRESPONDANCES
			  V_AD_NUM                ,--8            VARCHAR2(100)  Y      CLE SOURCE DE L ADRESSE DE LA PERSONNE
			  null                    ,--9            VARCHAR2(15)   Y      NUMERO DE TELEPHONE DE LA PERSONNE
			  null                    ,--10           VARCHAR2(15)   Y      NUMERO DE TELEPHONE DU BUREAU DE LA PERSONNE
			  null                    ,--11           VARCHAR2(15)   Y      NUMERO DE FAX DE LA PERSONNE
			  NULL                    ,--12           VARCHAR2(15)   Y      TELEPHONE MOBILE (IE PORTABLE) DE LA PERSONNE
			  NULL                    ,--13           VARCHAR2(15)   Y
			  NULL                    ,--14           VARCHAR2(255)  Y      MAIL DE LA PERSONNE [TA255]
			  NULL                    ,--15           VARCHAR2(255)  Y
			  lpad(ltrim(rtrim(v_categ_client)),2,'0')--16 NUMBER(10)Y      TYPE DE PROFIL (PROFESSIONNELLE, DOMESTIQUE..)
			  );
        EXCEPTION WHEN OTHERS THEN
			err_code := SQLCODE;
			err_msg  := SUBSTR(SQLERRM, 1, 200);
			insert into prob_migration (nom_table, val_ref, sql_err, date_pro,type_problem)
			values ('ADM', adm_.district ||' '||adm_.code,
			        err_code || '--' || err_msg,sysdate,'desingantion null dans la table adm');
        END;
    end loop;
insert into prob_migration (nom_table,val_ref)values(SYSTIMESTAMP||'   END MIWT_PERSONNE','--' );
commit;  
end;
