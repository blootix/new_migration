create or replace procedure miwt_RELEVE_GC_facture  is

  err_code        varchar2(200);
  err_msg         varchar2(200);
  v_ref_releve    number;
  v_annee         number;
  v_msg           varchar2(800);
  v_nbr_trsf      number(10) := 0;
  v_nbr_rej       number(10) := 0;
  V_RL_CP_NUM_BR  varchar2(60);
  V_RL_CP_NUM_RL  varchar2(60);
  V_RL_BR_NUM     varchar2(60);
  V_DTE_RL        varchar2(60);
  V_DTE_TIME_RL   varchar2(60);
  V_DTE_RELEVE    date;
  V_CODE_ANOMALIE varchar2(20);
  V_TYPE_ANOMALIE varchar2(10);
  V_DESIG_ANOM    varchar2(200);
  V_TYPE_ANOM     varchar2(10);
  V_RL_CODE1      varchar2(20);
  V_RL_LECIMP     varchar2(20);
  V_COUNT_BR      number;
  V_CODE_SI_ANOMALIE varchar2(20);
  -- suivi traitement

begin
	execute immediate 'alter session set nls_date_format = ''dd/mm/yyyy''';
	execute immediate 'alter session set NLS_NUMERIC_CHARACTERS = '',.''';
	--**************************************************
	delete MIWTRELEVE_GC_1 ;
	delete  prob_migration where nom_table in ('miwtreleve_GC_1','miwtreleve11_GC_1','miwtrelevegc_fact_cpt');
	insert into prob_migration (nom_table)values(SYSTIMESTAMP||'   START miwt_releve_gc_facture');
	commit;
	v_ref_releve := 0;
	------------------------
	select nvl(max(to_number(MREL_REF)), 0)
	into v_ref_releve
	from miwtrelevet;
	------------------------
	for releve_ in ( select distinct  a.nindex,
                                    a.prorata,
                                    a.cons,
                                    a.refc02,
                                    a.refc01,
                                    a.dist,
                                    a.tou,
                                    a.ord,
                                    a.pol,
                                    b.district,
                                    b.tourne,
                                    b.ordre
                     from  facture_as400gc a, branchement b,relevegc c
                    where trim(b.district) = lpad(trim(a.dist),2,'0')
                     and lpad(trim(a.pol),5,'0')=lpad(trim(b.police),5,'0')
                     and lpad(trim(a.tou),3,'0')=lpad(trim(b.tourne),3,'0')
                     and lpad(trim(a.ord),3,'0')=lpad(trim(b.ordre),3,'0') 
                     and lpad(trim(a.pol),5,'0')=lpad(trim(c.police),5,'0')
                     and lpad(trim(a.tou),3,'0')=lpad(trim(c.tourne),3,'0')
                     and lpad(trim(a.ord),3,'0')=lpad(trim(c.ordre),3,'0') 
                     and lpad(trim(a.dist),2,'0')=trim(c.district)
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
			for bra_ in (select *
						 from branchement b
						where b.district = releve_.dist
						 and lpad(trim(releve_.pol),5,'0')=lpad(trim(b.police),5,'0')
						 and lpad(trim(releve_.tou),3,'0')=lpad(trim(b.tourne),3,'0')
						 and lpad(trim(releve_.ord),3,'0')=lpad(trim(b.ordre),3,'0')
					   ) loop
			-- numero compteur (branchement)
			-- reception code point instalation PDI
			V_RL_BR_NUM := lpad(trim(bra_.district), 2, '0') ||
						   lpad(trim(bra_.tourne), 3, '0') ||
						   lpad(trim(bra_.ordre), 3, '0') ||
						   lpad(to_char(trim(bra_.police)), 5, '0');
			V_COUNT_BR  := V_COUNT_BR + 1;
			end loop;
            -- verfication si le compteur existe deja au niveau de la table des compteurs
			/*V_RL_CP_NUM_RL := lpad(releve_.dist,2,'0')||ltrim(rtrim(releve_.code_marque )) ||
								lpad(ltrim(rtrim(releve_.compteur_actuel)),11,'0');*/
			BEGIN
			   select distinct  p.mhpc_refcom
				into V_RL_CP_NUM_RL
				from miwthistocpt p
			   where  substr(p.mhpc_refpdl,1,8) =trim(releve_.district)||
												 lpad(trim(releve_.tourne),3,'0')||
												 lpad(trim(releve_.ordre),3,'0');
		    EXCEPTION WHEN OTHERS THEN
				err_code := SQLCODE;
				err_msg  := SUBSTR(SQLERRM, 1, 200);
				insert into prob_migration(nom_table, val_ref, sql_err,date_pro,type_problem)
				values ('miwtrelevegc_fact_cpt',
						releve_.tourne || '--' || releve_.ordre,
						err_code || '--' || err_msg,sysdate,'problem recuperation compteur pour le pdl '||trim(releve_.district)||trim(releve_.tourne)||trim(releve_.ordre));
				continue;
			END;
            if (to_number(releve_.Refc01)='12') then
			   V_DTE_RELEVE:='08/'||'01/'||'20'||to_char(to_number(trim(releve_.refc02))+1);
			else
			   V_DTE_RELEVE:='08/'||lpad(releve_.refc01+1,2,'0')||'/20'||trim(releve_.refc02);
			end if ;
------------------------------------------------------
			if trim(releve_.nindex) is null then
				for com_lectimp_ in (select *
									from listeanomalies_releve a
									where trim(a.DISTRICT) = trim(releve_.dist)
									and lpad(trim(a.TOURNE),3,'0')= lpad(trim(releve_.tou),3,'0')
									and lpad(trim(a.ORDRE),3,'0')= lpad(trim(releve_.ord),3,'0')
									and a.ANNEE = '20' || trim(releve_.refc02)
									and a.TRIM = releve_.refc01) loop
					V_CODE_SI_ANOMALIE := trim(com_lectimp_.code_anomalie);
					V_TYPE_ANOMALIE    := trim(com_lectimp_.type_anomalie);
				end loop;
			else
				for com_lectimp_ in (select *
									from listeanomalies_releve a
									where trim(a.DISTRICT) = trim(releve_.dist)
									and lpad(trim(a.TOURNE),3,'0') =lpad(trim(releve_.tou),3,'0')
									and lpad(trim(a.ORDRE),3,'0') = lpad(trim(releve_.ord),3,'0')
									and a.ANNEE = '20'||trim(releve_.refc02)
									and a.TRIM = releve_.refc01) loop
					V_CODE_ANOMALIE := trim(com_lectimp_.code_anomalie);
					V_TYPE_ANOMALIE := trim(com_lectimp_.type_anomalie);
				end loop;
			end if;
            for com_lectimp_ in (select *
								from listeanomalies_releve a
								where trim(a.DISTRICT) = trim(releve_.dist)
								and lpad(trim(a.TOURNE),3,'0') =lpad(trim(releve_.tou),3,'0')
								and lpad(trim(a.ORDRE),3,'0') = lpad(trim(releve_.ord),3,'0')
								and a.ANNEE = '20' || trim(releve_.refc02)
								and a.TRIM  = releve_.refc01) loop
			  V_CODE_ANOMALIE := trim(com_lectimp_.code_anomalie);
			  V_TYPE_ANOMALIE := trim(com_lectimp_.type_anomalie);
			end loop;
            -- reception du libelle du commentaire
			for anom_rel_ in (select *
							   from ANOMALIES_RELEVE a
							   where trim(a.code) = V_CODE_ANOMALIE
							   and trim(a.typea)  = V_TYPE_ANOMALIE) loop
				V_DESIG_ANOM := anom_rel_.desig;
				V_TYPE_ANOM  := anom_rel_.typea;
			end loop;

			if V_TYPE_ANOM = 'C' then
				for MIG_COMREL_ in (select *
								from miwtvocable a
								where a.mvoc_libe = V_DESIG_ANOM
								and a.mvoc_type = 'COMM') loop
				   V_RL_CODE1 := MIG_COMREL_.MVOC_REF;
				end loop;
			end if;
			if V_TYPE_ANOM = 'L' then
				for MIG_LECIMP_ in (select *
								from miwtvocable a
								where a.mvoc_libe = V_DESIG_ANOM
								and a.mvoc_type = 'READCODE') loop
				V_RL_LECIMP := MIG_LECIMP_.MVOC_REF;
				end loop;
			end if;
			v_ref_releve := v_ref_releve + 1;
			BEGIN
			    insert into miwtreleve_gc_1(
							 MREL_SOURCE ,--1  Identifiant de la source de donnees [OBL]
							 MREL_REF    ,--2  Reference de la releve dans le SI source (le couple source/reference releve doit etre UNIQUE) [OBL]
							 MREL_REFPDL ,--3  Reference du PDl dans le SI source
							 MREL_REFCOM ,--4  Reference du compteur dans le SI source
							 MREL_DATE   ,--5  Date de la releve [OBL]
							 MREL_INDEX1 ,--6  Index
							 MREL_DEDUITE,--7  Index
							 MREL_CONSO1 ,--8
							 MREL_CADRAN1,--9
							 VOC_READORIG,--10   RL_ORIG
							 VOC_READREASON,--11 RL_TYPLEC
							 MREL_ETATFACT,--12
							 MREL_FACTUREE,--13
							 MREL_AGESOURCE,--14
							 MREL_AGEREF   ,--15
							 annee         ,--16
							 periode       ,--17
							 mrel_agrtype  ,--18
							 mrel_techtype ,--19
							 voc_comm1     ,--20
							 VOC_READCODE  ,--21
							 MREL_CONSO_REF1,--22
							 mrel_fact1      --23
							)
						  values
							(
							 'DIST'||trim(releve_.district),--1
							 v_ref_releve      ,--2
							 V_RL_BR_NUM       ,--3
							 V_RL_CP_NUM_RL    ,--4
							 V_DTE_RELEVE      ,--5
							 to_number(releve_.nindex),--6
							 nvl(to_number(trim(releve_.prorata)),0)*-1,--7
							 nvl(to_number(trim(releve_.cons)),0),--8
							 'EAU'             ,--9
							 '03'              ,--10
							 '1'               ,--11 'tournee'
							 0                 ,--12
							 1                 ,--13
							 '1'               ,--14
							 '1'               ,--15
							 to_number('20'||trim(releve_.refc02)),--16
							 to_number(releve_.refc01),--17
							 0                 ,--18
							 0                 ,--19
							 V_CODE_ANOMALIE   ,--20
							 V_CODE_SI_ANOMALIE,--21
							 0                 ,--22
							trim(releve_.dist) ||lpad(trim(releve_.tou),3,'0')||
							lpad(trim(releve_.ord),3,'0')||'20'||trim(releve_.refc02)||lpad(trim(releve_.refc01),2,'0')||'0'--23
							);
            EXCEPTION WHEN OTHERS THEN
				err_code := SQLCODE;
				err_msg  := SUBSTR(SQLERRM, 1, 200);
				insert into prob_migration(nom_table, val_ref, sql_err, date_pro,type_problem)
				values('miwtreleve_GC_1',V_RL_BR_NUM||'--'||trim(releve_.refc02)||'--'||releve_.refc01,
				   err_code || '--' || err_msg, sysdate,'erreur de manque de date releve_gc_1 pour le pdl suivante'||trim(releve_.district)||trim(releve_.tourne)||trim(releve_.ordre));
            END;
        v_nbr_trsf := v_nbr_trsf + 1;
        EXCEPTION WHEN OTHERS THEN
            err_code := SQLCODE;
            err_msg  := SUBSTR(SQLERRM, 1, 200);
            insert into prob_migration
              (nom_table, val_ref, sql_err, date_pro,type_problem)
            values
              ('miwtreleve11_GC_1',
               V_RL_BR_NUM||'-'||'--'||trim(releve_.refc02)||'--'||releve_.refc01,
               err_code || '--' || err_msg,sysdate,'erreur de confomité de type colonne pour le pdl suivante'||trim(releve_.district)||trim(releve_.tourne)||trim(releve_.ordre));
            v_nbr_rej := v_nbr_rej + 1;
            v_msg     := sqlerrm;
        END;
    COMMIT;
    end loop;
insert into prob_migration (nom_table)values(SYSTIMESTAMP||'   END miwt_releve_gc_facture');
commit;
end;

