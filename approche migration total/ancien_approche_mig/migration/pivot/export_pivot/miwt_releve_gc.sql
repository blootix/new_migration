create or replace procedure miwt_RELEVE_GC   is
  
  err_code        varchar2(200);
  err_msg         varchar2(200);
  v_msg           varchar2(800);
  v_nbr_trsf      number(10) := 0;
  v_annee         number;
  v_nbr_rej       number(10) := 0;
  V_RL_CP_NUM_BR  varchar2(60);
  V_RL_CP_NUM_RL  varchar2(60);
  V_RL_BR_NUM     varchar2(60);
  V_DTE_RL        varchar2(60);
  V_DTE_TIME_RL   varchar2(60);
  V_CODE_SI_ANOMALIE varchar2(20);
  V_CODE_ANOMALIE varchar2(20);
  V_TYPE_ANOMALIE varchar2(10);
  V_DESIG_ANOM    varchar2(200);
  V_TYPE_ANOM     varchar2(10);
  V_RL_CODE1      varchar2(20);
  V_RL_LECIMP     varchar2(20);
  V_COUNT_BR      number;
  v_MREL_DEDUITE  number;
  v_ref_releve    number;
  V_DTE_RELEVE    date;

begin

	execute immediate 'alter session set nls_date_format = ''dd/mm/yyyy''';
	execute immediate 'alter session set NLS_NUMERIC_CHARACTERS = '',.''';
	--**************************************************
	delete MIWTRELEVE_GC ;
	delete  prob_migration where nom_table in ('miwtreleve_GC','miwtreleve11_GC','miwtrelevegc_ref_cpt');
	insert into prob_migration (nom_table) values(SYSTIMESTAMP||'   START miwt_releve_gc');
    commit;
    v_ref_releve := 0;
    ------------------------
    select nvl(max(to_number(MREL_REF)), 0)
    into v_ref_releve
    from miwtreleve_gc_1;
    ----------------------
    for releve_ in(select a.*from relevegc a where trim(a.mois) is not null) loop

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

        begin
			-- reception du branchement associe
			for bra_ in (select *
						from branchement b
						where b.district = trim(releve_.district)
						 --and lpad(trim(releve_.police),5,'0')=lpad(trim(b.police),5,'0')
						 and lpad(trim(releve_.tourne),3,'0')=lpad(trim(b.tourne),3,'0')
						 and lpad(trim(releve_.ordre),3,'0')=lpad(trim(b.ordre),3,'0')
						  ) 
			loop
				-- numero compteur (branchement)
				-- reception code point instalation PDI
				V_RL_BR_NUM := lpad(trim(bra_.district),2, '0') ||
							   lpad(trim(bra_.tourne),3, '0') ||
							   lpad(trim(bra_.ordre),3, '0') ||
							   lpad(to_char(trim(bra_.police)),5,'0');
				V_COUNT_BR  := V_COUNT_BR + 1;
			end loop;
-- verfication si le compteur existe deja au niveau de la table des compteurs
-------------------------------------------------------
------------------------------------------------------- RECHERCHE COMPTEUR
            V_RL_CP_NUM_RL:=null  ;
			/*  begin

				select distinct  p.mhpc_refcom
				into V_RL_CP_NUM_RL
				from miwthistocpt p
				where  substr(p.mhpc_refpdl,1,8)
				=trim(releve_.district)||
				lpad(trim(releve_.tourne),3,'0')||
				lpad(trim(releve_.ordre),3,'0');--||lpad(trim(releve_.police),5,'0') ;
				exception when others then

				begin
					select distinct  p.mhpc_refcom
					into V_RL_CP_NUM_RL
					from miwthistocpt p
					where  p.mhpc_refpdl=trim(releve_.district)||
					lpad(trim(releve_.tourne),3,'0')||
					lpad(trim(releve_.ordre),3,'0')||lpad(trim(releve_.police),5,'0');

				exception when others then

					err_code := SQLCODE;
					err_msg  := SUBSTR(SQLERRM, 1, 200);
					insert into prob_migration (nom_table, val_ref, sql_err, date_pro,type_problem)
					values ('miwtrelevegc_ref_cpt', releve_.tourne || '--' || releve_.ordre,
						   err_code || '--' || err_msg,sysdate,'problem recuperation compteur pour le pdl '||trim(releve_.district)||trim(releve_.tourne)||trim(releve_.ordre));
					continue;
				end;
				end;*/
------------------------------------------------------
			if trim(releve_.indexr) is null then
				for com_lectimp_ in (select *
										from listeanomalies_releve a
										where trim(a.DISTRICT) = trim(releve_.district)
										  and lpad(trim(a.TOURNE),3,'0')= lpad(trim(releve_.tourne),3,'0')
										  and lpad(trim(a.ORDRE),3,'0')= lpad(trim(releve_.ordre),3,'0')
										  and a.ANNEE = trim(releve_.annee)
										  and a.TRIM =  trim(releve_.mois)) 
				loop
					V_CODE_SI_ANOMALIE := ltrim(rtrim(com_lectimp_.code_anomalie));
					V_TYPE_ANOMALIE    := ltrim(rtrim(com_lectimp_.type_anomalie));
				end loop ;
			else
				for com_lectimp_ in (select *
									 from listeanomalies_releve a
									 where trim(a.DISTRICT) = trim(releve_.district)
									 and lpad(trim(a.TOURNE),3,'0') =lpad(trim(releve_.tourne),3,'0')
									 and lpad(trim(a.ORDRE),3,'0') = lpad(trim(releve_.ordre),3,'0')
									 and a.ANNEE = trim(releve_.annee)
									 and a.TRIM =  trim(releve_.mois)) 
				loop
					V_CODE_ANOMALIE := ltrim(rtrim(com_lectimp_.code_anomalie));
					V_TYPE_ANOMALIE := ltrim(rtrim(com_lectimp_.type_anomalie));
				end loop;
			end if;
            for com_lectimp_ in (select *
								 from listeanomalies_releve a
								where trim(a.DISTRICT) = trim(releve_.district)
								and lpad(trim(a.TOURNE),3,'0') =lpad(trim(releve_.tourne),3,'0')
								and lpad(trim(a.ORDRE),3,'0') = lpad(trim(releve_.ordre),3,'0')
								and a.ANNEE = trim(releve_.annee)
								and a.TRIM = trim(releve_.mois)
								) 
			loop
				V_CODE_ANOMALIE := trim(com_lectimp_.code_anomalie);
				V_TYPE_ANOMALIE := trim(com_lectimp_.type_anomalie);
			end loop;
			--reception du libelle du commentaire
			for anom_rel_ in (select *
							  from ANOMALIES_RELEVE a
							  where ltrim(rtrim(a.code)) = V_CODE_ANOMALIE
							  and ltrim(rtrim(a.typea)) = V_TYPE_ANOMALIE
							 ) loop
				V_DESIG_ANOM := anom_rel_.desig;
				V_TYPE_ANOM  := anom_rel_.typea;

			end loop;
           if V_TYPE_ANOM = 'C' then
				for MIG_COMREL_ in (select *
									from miwtvocable a
									where a.mvoc_libe = V_DESIG_ANOM
									and a.mvoc_type = 'COMM'
									) loop
					V_RL_CODE1 := MIG_COMREL_.MVOC_REF;
				end loop;
			end if;
           if V_TYPE_ANOM = 'L' then
				for MIG_LECIMP_ in (select *
									from miwtvocable a
									where a.mvoc_libe = V_DESIG_ANOM
									and a.mvoc_type = 'READCODE'
									) loop
					V_RL_LECIMP := MIG_LECIMP_.MVOC_REF;
				end loop;
			end if;
            v_ref_releve := v_ref_releve + 1;
            v_MREL_DEDUITE := 0;
            if to_number(releve_.prorata) > 0 then
			  v_MREL_DEDUITE := nvl(to_number(trim(releve_.consommation)), 0)-releve_.prorata;
		    end if;
			if to_number(trim(releve_.annee))='0' then
			v_annee:=to_char(sysdate,'yyyy');
			else
			v_annee:=to_number(trim(releve_.annee));
			end if;
			begin
				insert into miwtreleve_gc(
							MREL_SOURCE    , --1  Identifiant de la source de donnees [OBL]
							MREL_REF       , --2  Reference de la releve dans le SI source (le couple source/reference releve doit etre UNIQUE) [OBL]
							MREL_REFPDL    , --3  Reference du PDl dans le SI source
							MREL_REFCOM    , --4  Reference du compteur dans le SI source
							MREL_DATE      , --5 Date de la releve [OBL]
							MREL_INDEX1    , --6  Index
							MREL_CONSO1    , --7
							MREL_CADRAN1   , --8
							VOC_READORIG   , --9  R L_ORIG
							VOC_READREASON ,--10  RL_TYPLEC
							MREL_ETATFACT  ,--11
							MREL_FACTUREE  ,--12
							MREL_AGESOURCE ,--13
							MREL_AGEREF    ,--14
							annee          ,--15
							periode        ,--16
							mrel_agrtype   ,--17
							mrel_techtype  ,--18
							voc_comm1      ,--19
							VOC_READCODE   ,--20
							MREL_CONSO_REF1,--21
							mrel_fact1     ,--22
							MREL_DEDUITE    --23
							)
						values
							(
							'DIST'||releve_.district,--1
							v_ref_releve      ,--2
							V_RL_BR_NUM       ,--3
							V_RL_CP_NUM_RL    ,--4
							releve_.date_releve,--5
							to_number(releve_.indexr),--6
							nvl(to_number(trim(releve_.consommation)),0),--7
							'EAU'              , --8
							'03'               ,--9
							'TOURNEE'          ,--10
							0                  ,--11
							1                  ,--12
							releve_.etat       ,--13
							releve_.etat       ,--14
							to_number(trim(releve_.annee)),--15
							to_number(releve_.mois),--16
							0                  ,--17
							0                  ,--18
							V_CODE_ANOMALIE    ,--19
							V_CODE_SI_ANOMALIE ,--20
							0                  ,--21
							trim(releve_.district) ||
							lpad(trim(releve_.tourne),3,'0') ||
							lpad(trim(releve_.ordre),3,'0') ||'20' ||
							trim(releve_.annee)||lpad(trim(releve_.mois),2,'0')||'0',--22
							v_MREL_DEDUITE       --23
							);
            EXCEPTION WHEN OTHERS THEN
				err_code := SQLCODE;
				err_msg  := SUBSTR(SQLERRM, 1, 200);
				insert into prob_migration (nom_table, val_ref, sql_err, date_pro,type_problem)
				values ('miwtreleve_GC',V_RL_BR_NUM,err_code || '--' || err_msg,sysdate,'erreur de manque de date  pour le pdl suivante'||trim(releve_.district)||trim(releve_.tourne)||trim(releve_.ordre));
			END;
            v_nbr_trsf := v_nbr_trsf + 1;
        EXCEPTION WHEN OTHERS THEN
            err_code := SQLCODE;
            err_msg  := SUBSTR(SQLERRM, 1, 200);
            insert into prob_migration
              (nom_table, val_ref, sql_err,date_pro,type_problem)
            values
              ('miwtreleve11_GC', V_RL_BR_NUM||'-'||1,err_code || '--' || err_msg,sysdate,'erreur de confomité de type colonne pour le pdl suivante'||trim(releve_.district)||trim(releve_.tourne)||trim(releve_.ordre));
            v_nbr_rej := v_nbr_rej + 1;
            v_msg     := sqlerrm;
        END;
    COMMIT;
    end loop;
insert into prob_migration (nom_table) values(SYSTIMESTAMP||'   END miwt_releve_gc');
commit;
end;

