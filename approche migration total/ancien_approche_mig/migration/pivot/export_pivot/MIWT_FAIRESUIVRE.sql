CREATE OR REPLACE PROCEDURE MIWT_FAIRESUIVRE(v_district varchar2)
 is

    -- variables de traitement
    v_ad_vilrue     number(10);
    v_ad_num        number(10);
    err_code        varchar2(200);
    err_msg         varchar2(200);
    -- suivi traitement
    NBR_tot         number := 0;
    rindex          pls_integer := -1;
    slno            pls_integer;
    v_op_name       varchar2(200);
    v_ref_pdl       varchar2(200);
  begin
    --**************************************************
    delete from MIWTFAIRESUIVRE;
    delete  prob_migration where nom_table in ('FAIRESUIVRE');
    commit;
    --**************************************************
    FOR adm_ in (select a.ad2,b.client_actuel,b.categorie_actuel,a.codpostal,a.dist,a.tou,a.ord,a.pol
                from faire_suivre_gc a,branchement b
                where lpad(trim(a.dist),2,'0')=lpad(trim(b.district),2,'0')
                and   lpad(trim(a.tou),3,'0')=lpad(trim(b.tourne),3,'0')
                and   lpad(trim(a.ord),3,'0')=lpad(trim(b.ordre),3,'0')
                and   lpad(trim(a.pol),5,'0')=lpad(trim(b.police),5,'0')
				)LOOP

		V_REF_PDL:=lpad(trim(adm_.dist),2,'0')||lpad(trim(adm_.tou),3,'0')||lpad(trim(adm_.ord),3,'0')||lpad(trim(adm_.pol),5,'0');
        V_AD_VILRUE:='999999999';
		miwtADRESSEPIVOT.MIG_ADR(v_adresse_   => adm_.ad2,
								   v_ad_vilrue_ => v_ad_vilrue,
								   V_CODE_POSTAL_ =>adm_.codpostal,
								   v_district=> v_district,
								   v_ad_num_    => v_ad_num
						          );
    BEGIN

		INSERT INTO MIWTFAIRESUIVRE
			  (
				MFS_SOURCE ,--1
				MFS_REF    ,--2
				MFS_REFE   ,--3
				MFS_REF_ADR,--4
				MFS_REFPDL  --5
			  )
		VALUES
			 (
				'DIST'||v_district, --1
				v_district||adm_.categorie_actuel|| adm_.client_actuel,--2
				v_district||adm_.categorie_actuel|| adm_.client_actuel,--3
				V_AD_NUM,--4
				v_ref_pdl--5
			 );
    EXCEPTION WHEN OTHERS THEN
		err_code := SQLCODE;
		err_msg  := SUBSTR(SQLERRM, 1, 200);
		insert into prob_migration(nom_table, val_ref, sql_err, date_pro)
		values ('FAIRESUIVRE',v_district||adm_.categorie_actuel|| adm_.client_actuel,
		        err_code || '--' || err_msg,sysdate);
    END;
    end loop;
	
    for adm_ in (select a.adr2,b.client_actuel,b.categorie_actuel,a.codpostal,a.dist,a.tou,a.ord,a.pol
                from faire_suivre_part a,branchement b
                where lpad(trim(a.dist),2,'0')=lpad(trim(b.district),2,'0')
                and   lpad(trim(a.tou),3,'0')=lpad(trim(b.tourne),3,'0')
                and   lpad(trim(a.ord),3,'0')=lpad(trim(b.ordre),3,'0')
                and   lpad(trim(a.pol),5,'0')=lpad(trim(b.police),5,'0')
				) loop
        V_REF_PDL:=lpad(trim(adm_.dist),2,'0')||lpad(trim(adm_.tou),3,'0')||lpad(trim(adm_.ord),3,'0')||lpad(trim(adm_.pol),5,'0');
        V_AD_VILRUE:='999999999';
		miwtADRESSEPIVOT.MIG_ADR(v_adresse_   => adm_.adr2,
								 v_ad_vilrue_ => v_ad_vilrue,
								 V_CODE_POSTAL_ =>adm_.codpostal,
								 v_district=> v_district,
								 v_ad_num_    => v_ad_num);
        begin

		    INSERT INTO MIWTFAIRESUIVRE
					(
					MFS_SOURCE ,--1
					MFS_REF    ,--2
					MFS_REFE   ,--3
					MFS_REF_ADR,--4
					MFS_REFPDL  --5
					)
		    VALUES
				   (
					'DIST'||v_district, --1
					v_district||adm_.categorie_actuel|| adm_.client_actuel,--2
					v_district||adm_.categorie_actuel|| adm_.client_actuel,--3
					V_AD_NUM,--4
					v_ref_pdl--5
				   );
        EXCEPTION WHEN OTHERS THEN
			err_code := SQLCODE;
			err_msg  := SUBSTR(SQLERRM, 1, 200);
			insert into prob_migration
			(nom_table, val_ref, sql_err, date_pro)
			values
			('FAIRESUIVRE',
			v_district||adm_.categorie_actuel|| adm_.client_actuel,
			err_code || '--' || err_msg,sysdate);
        END;
    end loop;
 commit;
end;

