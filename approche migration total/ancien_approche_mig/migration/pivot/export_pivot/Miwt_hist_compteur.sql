create or replace procedure MIWT_HIST_COMPTEUR is


v_NB_LIGNE     number default(0);
err_code       varchar2(200);
err_msg        varchar2(200);
v_district varchar2(50);
v_code_marque  varchar2(50);
v_cpt        varchar2(50);
v_compteur_actuel  varchar2(50);
v_voc_pose     varchar2(50);
v_voc_depose   varchar2(50);
val            number default (0);
v_nbr_roues    number;
v_annee        number;
v_voc_diam     number;
V_RL_CP_NUM_RL varchar2(60);

begin
execute immediate 'alter session set nls_date_format = ''dd/mm/yyyy''';
execute immediate 'alter session set NLS_NUMERIC_CHARACTERS = '',.''';
delete from miwthistocpt t;
delete  prob_migration where nom_table like 'HISTO_CPT%';
insert into prob_migration (nom_table)values(SYSTIMESTAMP||'   START Miwt_hist_compteur');
commit;

for releve_ in (select * from miwtpdl  ) loop
------------------------------------------------------
--------------------------- RECHERCHE COMPTEUR
    BEGIN
		select distinct trim(w.district)||lpad(trim(w.code_marque),3,'0')||lpad(trim(w.compteur_actuel),11, '0') 
		into v_cpt
		from branchement w
		where trim(w.district)||trim(w.tourne)||trim(w.ordre) =substr(releve_.pdl_ref,1,8)
		and lpad(trim(w.compteur_actuel),11, '0') <>'00000000000'  ;
    EXCEPTION WHEN OTHERS THEN
		BEGIN
			select distinct trim(b.district)||lpad(trim(b.codemarque),3,'0')||lpad(trim(b.ncompteur),11,'0') 
			into v_cpt
			from fiche_releve b
			where trim(b.district)||lpad(trim(b.tourne),3,'0')||lpad(trim(b.ordre),3,'0')=substr(releve_.pdl_ref,1,8)
			and trim(b.annee)||trim(b.trim)=(select max(trim(f.annee)||trim(f.trim)) from fiche_releve f
			where  trim(f.district)||lpad(trim(f.tourne),3,'0')||lpad(trim(f.ordre),3,'0')=substr(releve_.pdl_ref,1,8)
			and trim(f.ncompteur) is not null 
			and trim(f.codemarque)!='000');
		EXCEPTION WHEN OTHERS THEN
			BEGIN
				select distinct trim(c.district)||lpad(trim(c.code_marque),3,'0')||lpad(trim(c.num_compteur),11,'0') 
				into v_cpt
				from gestion_compteur c
				where  trim(c.district)||lpad(trim(c.tournee),3,'0')||lpad(trim(c.ordre),3,'0')=substr(releve_.pdl_ref,1,8)
				and trim(c.num_compteur) is not null
				and trim(c.annee)||trim(c.trim) = (select max(trim(b.annee)||trim(b.trim)) from gestion_compteur b
				where trim(b.district)||lpad(trim(b.tournee),3,'0')||lpad(trim(b.ordre),3,'0')=substr(releve_.pdl_ref,1,8));
			EXCEPTION WHEN OTHERS THEN
			v_cpt:=substr(releve_.pdl_ref,1,2)||'00000000000000';
			END;
		END;
    END;

    if (v_cpt=substr(releve_.pdl_ref,1,2)||'00000000000000') then

        val:=val+1;
        V_RL_CP_NUM_RL :=substr(releve_.pdl_ref,1,2) ||'MIG'||lpad(val,11,'0');
        begin
		    insert into miwtcompteur
					(
					MCOM_SOURCE   ,--1
					MCOM_REF      ,--2
					MCOM_REEL     ,--3
					VOC_DIAM      ,--4
					MCOM_ANNEE    ,--5
					MCOM_REFVOCCLASSE,--6
					NCOM_NBROUE   ,--7
					VOC_MODEL     ,--8
					REF_TYPEEQUI  ,--9
					VOC_EQUSTATUS ,--10
					MTC_ID         --11
					)
			values
					(
					'DIST'||substr(releve_.pdl_ref,1,2) ,--1
					V_RL_CP_NUM_RL     ,--2
					lpad(val,11,'0')   ,--3
					nvl(v_voc_diam,0)  ,--4
					nvl(v_annee,1900)  ,--5
					'Inconnue'         ,--6
					nvl(v_nbr_roues,0) ,--7
					'MIG'              ,--8
					'EAU'              ,--9
					1                  ,--10
					1                   --11
					);
        EXCEPTION WHEN OTHERS THEN
			err_code := SQLCODE;
			err_msg := SUBSTR(SQLERRM, 1, 200);
			insert into prob_migration (nom_table,val_ref,sql_err , date_pro,type_problem )
			values('miwtcompteur_mig',V_RL_CP_NUM_RL,err_code||'--'||err_msg,
			sysdate,'erreur de confomité de type colonne pour le compteur suivante '||releve_.pdl_ref);
        END;
        COMMIT;
    else
         V_RL_CP_NUM_RL := v_cpt;
    end if ;

    select SEQ_miwthistocpt.Nextval into v_NB_LIGNE from dual;
    begin

		if(releve_.pdl_dfermeture is null)then
			v_voc_pose:='P';
			v_voc_depose:=null;
		else
			v_voc_pose:='P';
			v_voc_depose :='D';
		end if;

		insert into miwthistocpt
		(
		MHPC_SOURCE   ,--1 VARCHAR2(100) not null,
		MHPC_REFCOM   ,--2 VARCHAR2(100) not null,
		MHPC_REFPDL   ,--3 VARCHAR2(100) not null,
		VOC_REASPOSE  ,--4 VARCHAR2(100) Vocabulaire Raison de pose
		MHPC_AGESOURCE,--5 VARCHAR2(100) Identifiant agent ayant Pose la compteur
		MHPC_DDEB     ,--6 DATE not null
		MHPC_DFIN     ,--7 DATE
		VOC_REASDEPOSE,--8
		NB_LIGNE      ,--9
		INDEX_DEPART  ,--10
		INDEX_ARRET    --11
		)
		values
		(
		'DIST' || substr(releve_.pdl_ref,1,2)  ,--1 VARCHAR2(100) not null,
		V_RL_CP_NUM_RL       ,--2 VARCHAR2(100) not null,
		releve_.pdl_ref      ,--3 VARCHAR2(100) not null,
		v_voc_pose           ,--4 VARCHAR2(100) Vocabulaire Raison de pose
		null                 ,--5 VARCHAR2(100) Identifiant agent ayant Pose la compteur
		releve_.pdl_detat    ,--6 DATE not null
		releve_.pdl_dfermeture,--7 DATE
		v_voc_depose         ,--8
		v_NB_LIGNE           ,--9
		0                    ,--10
		0                     --11
		);
    EXCEPTION WHEN OTHERS THEN
		err_code := SQLCODE;
		err_msg  := SUBSTR(SQLERRM, 1, 200);
		insert into prob_migration(nom_table, val_ref, sql_err, date_pro,type_problem)
		values ('HISTO_CPT',V_RL_CP_NUM_RL||'--'|| releve_.pdl_detat,err_code||'--'|| err_msg,sysdate,'erreur de confomité de type colonne pour le pdl suivante '||releve_.pdl_ref);
    END;
    commit;
end loop;

 insert into prob_migration (nom_table)values(SYSTIMESTAMP||'   START Miwt_hist_compteur');
  commit;

end;

