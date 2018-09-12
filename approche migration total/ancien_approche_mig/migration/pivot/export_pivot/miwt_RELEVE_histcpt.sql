create or replace procedure miwt_RELEVE_histcpt is
  
  err_code           varchar2(200);
  err_msg            varchar2(200);
  v_msg              varchar2(800);
  V_RL_CP_NUM_BR     varchar2(60);
  V_RL_CP_NUM_RL     varchar2(60);
  V_RL_BR_NUM        varchar2(60);
  V_DTE_RL           varchar2(60);
  V_DTE_TIME_RL      varchar2(60);
  V_DTE_RELEVE       date;
  V_CODE_ANOMALIE    varchar2(20);
  V_TYPE_ANOMALIE    varchar2(10);
  V_DESIG_ANOM       varchar2(200);
  V_TYPE_ANOM        varchar2(10);
  V_RL_CODE1         varchar2(20);
  V_RL_LECIMP        varchar2(20);
  V_COUNT_BR         number;
  v_MREL_DEDUITE     number;
  v_periode          number;
  v_trim             number;
  v_annee            number;
  v_ref_releve_      number;
  v_nbr_trsf         number(10) := 0;
  v_nbr_rej          number(10) := 0;

BEGIN
	execute immediate 'alter session set nls_date_format = ''dd/mm/yyyy''';
	execute immediate 'alter session set NLS_NUMERIC_CHARACTERS = '',.''';
	--**************************************************
	delete  prob_migration where nom_table in ('miwt_RELEVE_histcpt');
	DELETE FROM MIWTRELEVE_histocpt h ;
	insert into prob_migration (nom_table)values(SYSTIMESTAMP||'   START miwt_RELEVE_histcpt');
	commit;
	v_ref_releve_ := 0;
	select NVL(max(to_number(MREL_REF)),0)
	into v_ref_releve_
	from MIWTRELEVE_histocpt;
	------------------------------------------
	-------------------------- Releve dans le cas de pose
    for releve_ in (select
                         a.mhpc_source,
                         nvl(a.index_depart,0) index_depart,
                         a.mhpc_ddeb,
                         a.mhpc_refcom,
                         a.mhpc_refpdl
                   from MIWTHISTOCPT  a
                   where  a.voc_reaspose = 'P'
                   --and a.voc_reasdepose is null
                    ) loop
		V_RL_CP_NUM_BR  := NULL;
		V_RL_CP_NUM_RL  := NULL;
		V_RL_BR_NUM     := NULL;
		V_DTE_RL        := NULL;
		V_DTE_TIME_RL   := NULL;
		V_DTE_RELEVE    := NULL;
		V_CODE_ANOMALIE := NULL;
		V_TYPE_ANOMALIE := NULL;
		V_DESIG_ANOM    := NULL;
		V_TYPE_ANOM     := NULL;
		V_RL_CODE1      := NULL;
		V_RL_LECIMP     := NULL;
		V_COUNT_BR      := 0;
        BEGIN
			-- reception du branchement associe
			V_RL_BR_NUM := releve_.mhpc_refpdl;
			-- verfication si le compteur existe deja au niveau de la table des compteurs
			V_RL_CP_NUM_RL := releve_.mhpc_refcom;
			V_DTE_RELEVE := releve_.mhpc_ddeb;
			v_ref_releve_  := v_ref_releve_ + 1;
			v_MREL_DEDUITE := 0;
			v_annee:=substr(releve_.mhpc_ddeb,7,4);
            if(substr(releve_.mhpc_ddeb,4,2)in('01','02','03')) then
			v_trim:=1;
			elsif (substr(releve_.mhpc_ddeb,4,2)in('04','05','06')) then
			v_trim:=2;
			elsif (substr(releve_.mhpc_ddeb,4,2)in('07','08','09')) then
			v_trim:=3;
			elsif (substr(releve_.mhpc_ddeb,4,2)in('10','11','12')) then
			v_trim:=4;
			end if;
			BEGIN
				insert into MIWTRELEVE_histocpt
						  (
						   MREL_SOURCE ,--1  Identifiant de la source de donnees [OBL]
						   MREL_REF    ,--2  Reference de la releve dans le SI source (le couple source/reference releve doit etre UNIQUE) [OBL]
						   MREL_REFPDL ,--3  Reference du PDl dans le SI source
						   MREL_REFCOM ,--4  Reference du compteur dans le SI source
						   MREL_DATE   ,--5  Date de la releve [OBL]
						   MREL_INDEX1 ,--6  Index
						   MREL_CONSO1 ,--7
						   MREL_CADRAN1,--8
						   MREL_CADRAN2,--9
						   MREL_CADRAN3,--10
						   MREL_CADRAN4,--11
						   MREL_CADRAN5,--12
						   MREL_CADRAN6,--13
						   VOC_READORIG,--14
						   VOC_READREASON,--15
						   MREL_ETATFACT,--16
						   MREL_FACTUREE,--17
						   MREL_AGESOURCE,--18
						   MREL_AGEREF   ,--19
						   annee         ,--20
						   periode       ,--21
						   mrel_agrtype  ,--22
						   mrel_techtype ,--23
						   voc_comm1     ,--24
						   VOC_READCODE  ,--25
						   MREL_CONSO_REF1,--26
						   mrel_ano_c1   ,--27
						   mrel_ano_c2   ,--28
						   mrel_ano_c3   ,--29
						   mrel_ano_n1   ,--30
						   mrel_ano_n2   ,--31
						   mrel_ano_n3   ,--32
						   mrel_ano_f1   ,--33
						   mrel_ano_f2   ,--34
						   mrel_ano_f3   ,--35
						   MREL_DEDUITE  ,--36
						   MREL_INDEX2   ,--37
						   MREL_INDEX3   ,--38
						   MREL_INDEX4   ,--39
						   MREL_INDEX5   ,--40
						   MREL_INDEX6   ,--41
						   mrel_comlibre  --42
						   )
					values
						  (
						   releve_.mhpc_source,--1
						   v_ref_releve_       ,--2
						   V_RL_BR_NUM         ,--3
						   V_RL_CP_NUM_RL      ,--4
						   V_DTE_RELEVE        ,--5
						   0                   ,--6
						   0                   ,--7
						   'EAU'               ,--8
						   NULL                ,--9
						   NULL                ,--10
						   NULL                ,--11
						   NULL                ,--12
						   NULL                ,--13
						   '03'                ,--14
						   V_RL_LECIMP         ,--15
						   0                   ,--16
						   1                   ,--17
						   NULL                ,--18
						   NULL                ,--19
						   to_number(v_annee)  ,--20
						   to_number(v_trim)   ,--21
						   0                   ,--22
						   1                   ,--23
						   NULL                ,--24
						   NULL                ,--25
						   0                   ,--26
						   NULL                ,--27
						   NULL                ,--28
						   NULL                ,--29
						   NULL                ,--30
						   NULL                ,--31
						   NULL                ,--32
						   NULL                ,--33
						   NULL                ,--34
						   NULL                ,--35
						   NULL                ,--36
						   NULL                ,--37
						   NULL                ,--38
						   NULL                ,--39
						   NULL                ,--40
						   NULL                ,--41
						   '0'                  --42
						   );
			EXCEPTION WHEN OTHERS THEN
				err_code := SQLCODE;
				err_msg  := SUBSTR(SQLERRM, 1, 200);
				insert into prob_migration(nom_table, val_ref, sql_err, date_pro,type_problem)
				values('miwt_RELEVE_histcpt', V_RL_BR_NUM || '--' || to_number(v_annee)||to_number(v_trim),
				err_code || '--' || err_msg,sysdate,'erreur de manque date releve pour le pdl suivante'||V_RL_BR_NUM);
			END;
			v_nbr_trsf := v_nbr_trsf + 1;
        EXCEPTION WHEN OTHERS THEN
			err_code := SQLCODE;
			err_msg  := SUBSTR(SQLERRM, 1, 200);
			insert into prob_migration(nom_table, val_ref, sql_err, date_pro,type_problem)
			values('miwt_RELEVE_histcpt',V_RL_BR_NUM || '-' || releve_.mhpc_ddeb,
			      err_code || '--' || err_msg,sysdate,'erreur de confomité de type colonne pour le pdl suivante'||V_RL_BR_NUM);
			v_nbr_rej := v_nbr_rej + 1;
			v_msg     := sqlerrm;
	    END;
	COMMIT;
	end loop;
	---------------------------------------------
	----------------------- Releve dans le cas de depose
	for releve_ in (select
								 a.mhpc_source,
								 a.mhpc_dfin,
								 a.mhpc_refcom,
								 a.mhpc_refpdl,
								 a.mhpc_ddeb
							from MIWTHISTOCPT  a
						   where  a.voc_reasdepose ='D'
						   ) loop
        V_RL_CP_NUM_BR  := NULL;
		V_RL_CP_NUM_RL  := NULL;
		V_RL_BR_NUM     := NULL;
		V_DTE_RL        := NULL;
		V_DTE_TIME_RL   := NULL;
		V_DTE_RELEVE    := NULL;
		V_CODE_ANOMALIE := NULL;
		V_TYPE_ANOMALIE := NULL;
		V_DESIG_ANOM    := NULL;
		V_TYPE_ANOM     := NULL;
		V_RL_CODE1      := NULL;
		V_RL_LECIMP     := NULL;
		V_COUNT_BR      := 0;

		BEGIN
			-- reception du branchement associe
			V_RL_BR_NUM := releve_.mhpc_refpdl;
			-- verfication si le compteur existe deja au niveau de la table des compteurs
			V_RL_CP_NUM_RL := releve_.mhpc_refcom;
			-- Date de depose
			V_DTE_RELEVE := releve_.mhpc_dfin;
			--calcule de consomation avec l'ancienne releve
			v_annee:=substr(releve_.mhpc_dfin,7,4);
			if(substr(releve_.mhpc_dfin,4,2)in('01','02','03')) then
			v_trim:=1;
			elsif (substr(releve_.mhpc_dfin,4,2)in('04','05','06')) then
			v_trim:=2;
			elsif (substr(releve_.mhpc_dfin,4,2)in('07','08','09')) then
			v_trim:=3;
			elsif (substr(releve_.mhpc_dfin,4,2)in('10','11','12')) then
			v_trim:=4;
			end if;

			if v_trim=1 then
			v_periode:=to_char(v_annee-1)||'4';
			else
			v_periode:=to_char(v_annee)||v_trim-1;
			end if;
			v_ref_releve_  := v_ref_releve_ + 1;
			v_MREL_DEDUITE := 0;
			begin
				insert into MIWTRELEVE_histocpt
				  (
				   MREL_SOURCE   ,--1  Identifiant de la source de donnees [OBL]
				   MREL_REF      ,--2  Reference de la releve dans le SI source (le couple source/reference releve doit etre UNIQUE) [OBL]
				   MREL_REFPDL   ,--3  Reference du PDl dans le SI source
				   MREL_REFCOM   ,--4  Reference du compteur dans le SI source
				   MREL_DATE     ,--5  Date de la releve [OBL]
				   MREL_INDEX1   ,--6  Index
				   MREL_CONSO1   ,--7
				   MREL_CADRAN1  ,--8
				   MREL_CADRAN2  ,--9
				   MREL_CADRAN3  ,--10
				   MREL_CADRAN4  ,--11
				   MREL_CADRAN5  ,--12
				   MREL_CADRAN6  ,--13
				   VOC_READORIG  ,--14
				   VOC_READREASON,--15
				   MREL_ETATFACT ,--16
				   MREL_FACTUREE ,--17
				   MREL_AGESOURCE,--18
				   MREL_AGEREF   ,--19
				   annee         ,--20
				   periode       ,--21
				   mrel_agrtype  ,--22
				   mrel_techtype ,--23
				   voc_comm1     ,--24
				   VOC_READCODE  ,--25
				   MREL_CONSO_REF1,--26
				   mrel_ano_c1   ,--27
				   mrel_ano_c2   ,--28
				   mrel_ano_c3   ,--29
				   mrel_ano_n1   ,--30
				   mrel_ano_n2   ,--31
				   mrel_ano_n3   ,--32
				   mrel_ano_f1   ,--33
				   mrel_ano_f2   ,--34
				   mrel_ano_f3   ,--35
				   MREL_DEDUITE  ,--36
				   MREL_INDEX2   ,--37
				   MREL_INDEX3   ,--38
				   MREL_INDEX4   ,--39
				   MREL_INDEX5   ,--40
				   MREL_INDEX6   ,--41
				   mrel_comlibre  --42
				   )
				values
				  (
				   releve_.mhpc_source,-- 1
				   v_ref_releve_       ,--2
				   V_RL_BR_NUM         ,--3
				   V_RL_CP_NUM_RL      ,--4
				   V_DTE_RELEVE        ,--5
				   0                   ,--6
				   0                   ,--7
				   'EAU'               ,--8
				   NULL                ,--9
				   NULL                ,--10
				   NULL                ,--11
				   NULL                ,--12
				   NULL                ,--13
				   '03'                ,--14
				   V_RL_LECIMP         ,--15
				   0                   ,--16
				   1                   ,--17
				   NULL                ,--18
				   NULL                ,--19
				   to_number(v_annee)  ,--20
				   to_number(v_trim)   ,--21
				   0                   ,--22
				   2                   ,--23
				   NULL                ,--24
				   NULL                ,--25
				   0                   ,--26
				   NULL                ,--27
				   NULL                ,--28
				   NULL                ,--29
				   NULL                ,--30
				   NULL                ,--31
				   NULL                ,--32
				   NULL                ,--33
				   NULL                ,--34
				   NULL                ,--35
				   NULL                ,--36
				   NULL                ,--37
				   NULL                ,--38
				   NULL                ,--39
				   NULL                ,--40
				   NULL                ,--41
				   '0'                  --42
				   );
			EXCEPTION WHEN OTHERS THEN
				err_code := SQLCODE;
				err_msg  := SUBSTR(SQLERRM, 1, 200);
				insert into prob_migration (nom_table, val_ref, sql_err, date_pro)
				values ('miwt_RELEVE_histcpt', V_RL_BR_NUM || '--'||to_number(v_annee)||to_number(v_trim),
				        err_code || '--' || err_msg,
				        sysdate);
			END;
		    v_nbr_trsf := v_nbr_trsf + 1;
		EXCEPTION WHEN OTHERS THEN
			err_code := SQLCODE;
			err_msg  := SUBSTR(SQLERRM, 1, 200);
			insert into prob_migration
			(nom_table, val_ref, sql_err, date_pro)
			values
			('miwt_RELEVE_histcpt',
			V_RL_BR_NUM || '-' || releve_.mhpc_dfin,
			err_code || '--' || err_msg,
			sysdate);
			v_nbr_rej := v_nbr_rej + 1;
			v_msg     := sqlerrm;
        END;
    COMMIT;
    end loop;
insert into prob_migration (nom_table)values(SYSTIMESTAMP||'   END miwt_RELEVE_histcpt');
commit;
end;

