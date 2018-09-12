create or replace procedure miwt_compteur
is
  cursor c is select distinct trim(x.district) district ,
  trim(x.num_compteur) num_cpt,trim(x.code_marque) codemarque
      from
      (
      select trim(b.district) district ,lpad(trim(b.compteur_actuel),11,'0') num_compteur,lpad(trim(b.code_marque),3,'0') code_marque
      from branchement b
      where trim(b.compteur_actuel) is not null
      union
      select trim(g.district) district,lpad(trim(g.num_compteur),11,'0') num_compteur,lpad(trim(g.code_marque),3,'0') code_marque
      from gestion_compteur g
      where trim(g.num_compteur) is not null
      union
      select trim(c.district) district,lpad(trim(c.num_compteur),11,'0') num_compteur,lpad(trim(c.code_marque),3,'0') code_marque
       from compteur c
       where trim(c.num_compteur) is not null
      ) x;

	v_voc_model number;
	v_voc_diam  number;
	v_nbr_roues number;
	v_annee     number;
	v_voc_CLASS VARCHAR2(2);
	V_RL_CP_NUM_RL varchar2(60);
	ref_cpt     varchar2(20);
	v_lib_voc   varchar2(50);
	err_code    varchar2(200);
	err_msg     varchar2(200);

begin
execute immediate 'alter session set nls_date_format = ''dd/mm/yyyy''';
execute immediate 'alter session set NLS_NUMERIC_CHARACTERS = '',.''';
    --***
    delete miwtcompteur ;
    delete prob_migration
    where nom_table in ('miwtcompteur','   START Miwt_compteur','   END  Miwt_compteur');
    insert into prob_migration (nom_table)values(SYSTIMESTAMP||'   START Miwt_compteur');
    commit;

    for cpt_ in c  loop
	  v_voc_model:=0;
	  v_lib_voc:=v_lib_voc;
	  v_voc_diam:=0;
	  v_voc_CLASS:=0;
	  v_nbr_roues:=0;
	  v_annee:=0;
      ref_cpt:=trim(cpt_.district)||lpad(trim(cpt_.codemarque),3,'0')||lpad(trim(cpt_.num_cpt),11,'0');
	    if ref_cpt is not null then
	 
			--recupere diam  de comteur
			BEGIN
				select c.diam_compteur,c.nbr_roues,c.annee_fabrication into v_voc_diam,v_nbr_roues,v_annee
				from  compteur c
				where ref_cpt = trim(c.district)||lpad(trim(c.code_marque),3,'0')||lpad(trim(c.NUM_COMPTEUR),11,'0');
			EXCEPTION WHEN OTHERS THEN 
				v_voc_diam:=0;v_annee:=0;v_nbr_roues:=0; 
			END;

			----recupere class de compteur
			BEGIN
				select  m.classe into v_voc_CLASS 
				from compteur c,marque m
				where  c.code_marque = m.code
				and c.district=m.district
				and ref_cpt = trim(c.district)||lpad(trim(c.code_marque),3,'0')||lpad(trim(c.NUM_COMPTEUR),11,'0')
				and rownum=1;
			EXCEPTION WHEN OTHERS THEN 
			    v_voc_CLASS:=0;
			END;

		    BEGIN
		    --classe 100
				IF cpt_.codemarque= 101 THEN v_nbr_roues:=0 ;
				elsif cpt_.codemarque= 102 THEN v_nbr_roues:=4 ;
				elsif cpt_.codemarque= 103 THEN v_nbr_roues:=4 ;
				elsif cpt_.codemarque= 104 AND v_voc_diam=15 THEN v_nbr_roues:=4 ;
				elsif cpt_.codemarque= 104 AND v_voc_diam=40 THEN v_nbr_roues:=5;
				elsif cpt_.codemarque= 105 THEN v_nbr_roues:=4 ;
				elsif cpt_.codemarque= 106 THEN v_nbr_roues:=6 ;
				elsif cpt_.codemarque= 107 THEN v_nbr_roues:=6 ;
				elsif cpt_.codemarque= 108 THEN v_nbr_roues:=6 ;
				elsif cpt_.codemarque= 109 THEN v_nbr_roues:=5 ;
				elsif cpt_.codemarque= 110 THEN v_nbr_roues:=4;
				elsif cpt_.codemarque= 111 THEN v_nbr_roues:=4;
				elsif cpt_.codemarque= 112 THEN v_nbr_roues:=0;
				elsif cpt_.codemarque= 113 THEN v_nbr_roues:=4;
				elsif cpt_.codemarque= 114 THEN v_nbr_roues:=4;
				elsif cpt_.codemarque= 115 AND v_voc_diam=15 THEN v_nbr_roues:=4 ;
				elsif cpt_.codemarque= 115 AND v_voc_diam=30 THEN v_nbr_roues:=5;
				elsif cpt_.codemarque= 116 THEN v_nbr_roues:=5 ;
				elsif cpt_.codemarque= 117 THEN v_nbr_roues:=5  ;
				elsif cpt_.codemarque= 118 THEN v_nbr_roues:=6;
				elsif cpt_.codemarque= 120 THEN v_nbr_roues:=4;
				elsif cpt_.codemarque= 121 THEN v_nbr_roues:=4;
				--    classe 200
				elsif cpt_.codemarque= 201 THEN v_nbr_roues:=4;
				elsif cpt_.codemarque= 202 THEN v_nbr_roues:=4;
				elsif cpt_.codemarque= 203 AND v_voc_diam=15 THEN v_nbr_roues:=4 ;
				elsif cpt_.codemarque= 203 AND v_voc_diam=40 THEN v_nbr_roues:=5 ;
				elsif cpt_.codemarque= 203 AND v_voc_diam>40 THEN v_nbr_roues:=6;
				elsif cpt_.codemarque= 204 THEN v_nbr_roues:=4;
				elsif cpt_.codemarque= 205 THEN v_nbr_roues:=4;
				elsif cpt_.codemarque= 206 THEN v_nbr_roues:=4;
				elsif cpt_.codemarque= 207 AND v_voc_diam=15 THEN v_nbr_roues:=4 ;
				elsif cpt_.codemarque= 207 AND v_voc_diam=20 THEN v_nbr_roues:=4;
				elsif cpt_.codemarque= 207 AND v_voc_diam=40 THEN v_nbr_roues:=5;
				elsif cpt_.codemarque= 208 THEN v_nbr_roues:=4;
				elsif cpt_.codemarque= 210 THEN v_nbr_roues:=5;
				elsif cpt_.codemarque= 211 THEN v_nbr_roues:=6;
				elsif cpt_.codemarque= 212 THEN v_nbr_roues:=5 ;
				--    classe 300
				elsif cpt_.codemarque= 306  THEN v_nbr_roues:=4;
				elsif cpt_.codemarque= 310 THEN v_nbr_roues:=4;
				ELSE
				v_nbr_roues:=4;
				END IF;

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
			    values(
						'DIST'||trim(cpt_.district),--1
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
		    EXCEPTION WHEN OTHERS THEN
				err_code := SQLCODE;
				err_msg := SUBSTR(SQLERRM, 1, 200);
				insert into prob_migration (nom_table,val_ref,sql_err , date_pro,type_problem )
				values('miwtcompteur',ref_cpt,err_code||'--'||err_msg, sysdate,'erreur de confomité de type colonne pour le compteur suivante '||ref_cpt);
		    END;
		    commit;
		end if;
end loop;

for v in (select distinct lpad(trim(b.codemarque),3,'0') code_marque,
			  lpad(trim(b.ncompteur),11,'0') compteur_actuel,trim(b.district) district,
		      b.diamctr,
			  b.nbre_roues
		   from fiche_releve b
		   where trim(b.annee)||trim(b.trim)=(select max(trim(f.annee)||trim(f.trim)) from fiche_releve f
											  where  trim(f.district)||lpad(trim(f.tourne),3,'0')||lpad(trim(f.ordre),3,'0')
													=trim(b.district)||lpad(trim(b.tourne),3,'0')||lpad(trim(b.ordre),3,'0')
													and trim(f.ncompteur) is not null and trim(f.codemarque)!='000')
		   and trim(b.district)||trim(b.codemarque)||lpad(trim(b.ncompteur),11,'0')not in(select c.MCOM_REF from miwtcompteur c)
		   and trim(b.ncompteur) is not null and trim(b.codemarque)!='000')
loop
    V_RL_CP_NUM_RL := v.district||v.code_marque||v.compteur_actuel;
   
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
					'DIST'||v.district ,--1
					V_RL_CP_NUM_RL    ,--2
					v.compteur_actuel ,--3
					nvl(v.diamctr,0)  ,--4
					nvl(v_annee,1900) ,--5
					'Inconnue'        ,--6
					nvl(v.nbre_roues,0),--7
					v.code_marque     ,--8
					'EAU'             ,--9
					1                 ,--10
					1                  --11
				  );
	EXCEPTION WHEN OTHERS THEN
		err_code := SQLCODE;
		err_msg := SUBSTR(SQLERRM, 1, 200);
		insert into prob_migration (nom_table,val_ref,sql_err , date_pro,type_problem )
		values('miwtcompteur',V_RL_CP_NUM_RL,err_code||'--'||err_msg,
		sysdate,'erreur de confomité de type colonne pour le compteur suivante '||V_RL_CP_NUM_RL);
	END;
	commit;
end loop;
insert into prob_migration (nom_table)values(SYSTIMESTAMP||'   END  Miwt_compteur');
commit;
end;

