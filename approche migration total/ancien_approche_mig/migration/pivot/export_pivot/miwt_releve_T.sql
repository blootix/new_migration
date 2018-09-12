 create or replace procedure miwt_RELEVE_T  is

  v_NTIERS             number;
  v_NSIXIEME           number;
  v_annee              number;
  err_code             varchar2(200);
  err_msg              varchar2(200);
  v_msg                varchar2(800);
  v_nbr_trsf           number(10) := 0;
  v_nbr_rej            number(10) := 0;
  V_RL_CP_NUM_BR       varchar2(60);
  V_RL_CP_NUM_RL       varchar2(60);
  V_RL_BR_NUM          varchar2(60);
  V_DTE_RL             varchar2(60);
  V_DTE_TIME_RL        varchar2(60);
  V_DTE_RELEVE         date;
  V_CODE_ANOMALIE      varchar2(20);
  V_TYPE_ANOMALIE      varchar2(10);
  V_DESIG_ANOM         varchar2(200);
  V_TYPE_ANOM          varchar2(10);
  V_RL_CODE1           varchar2(20);
  V_RL_LECIMP          varchar2(20);
  V_COUNT_BR           number;
  V_CODE_SI_ANOMALIE   varchar2(20);
  v_MREL_DEDUITE       number;
  v_avisforte          varchar2(50);
  v_code_marque        varchar2(50);
  v_compteur_actuel    varchar2(50);
  v_date_controle      varchar2(30);
  v_index_controle     varchar2(20);
  v_message_temporaire varchar(200);
  -- suivi traitement
  v_trim               number;
  v_ref_releve_        number;
  v_compteurt          varchar2(5);
  v_releve2            varchar2(10);
  v_releve3            varchar2(10);
  v_releve4            varchar2(10);
  v_releve5            varchar2(10);
  v_anomalie           varchar2(30);
  v_MATRICULE_RELEVEUR varchar2(100);
BEGIN
	execute immediate 'alter session set nls_date_format = ''dd/mm/yyyy''';
	execute immediate 'alter session set NLS_NUMERIC_CHARACTERS = '',.''';
	delete MIWTRELEVET ;
	delete prob_migration
	where nom_table in ('miwtreleveT', 'miwtreleveT11','miwtreleveT_ref_cpt');
	insert into prob_migration (nom_table)values(SYSTIMESTAMP||'   START miw_treleve_T');
	commit;
	v_ref_releve_ := 0;
	select nvl(max(to_number(MREL_REF)), 0)
	into v_ref_releve_
	from miwtreleve;
    for releve_ in (select decode(annee,0,indexa,indexr) index_releve,a.*from releveT a)loop
        v_code_marque:=null;
        v_compteur_actuel:=null;
        BEGIN
            select s.trim,
                   s.date_controle,
                   s.index_controle,
                   s.avisforte,
                   s.message_temporaire,
                   s.compteurt,
                   s.releve2,
                   s.releve3,
                   s.releve4,
                   s.releve5,
                   s.anomalie,
                   s.MATRICULE_RELEVEUR
            into v_trim,
				v_date_controle,
				v_index_controle,
				v_avisforte,
				v_message_temporaire,
				v_compteurt,
				v_releve2,
				v_releve3,
				v_releve4,
				v_releve5,
				v_anomalie,
				v_MATRICULE_RELEVEUR
            from fiche_releve s
            where trim(s.district) = trim(releve_.district)
			and trim(s.tourne) = trim(releve_.tourne)
			and trim(s.ordre) = trim(releve_.ordre)
			and trim(s.annee)||trim(s.trim) =(select max(trim(v.annee)||trim(v.trim))
                                                 from fiche_releve v
                                                 where  trim(v.district)=trim(s.district)
                                                 and trim(v.tourne) = trim(s.tourne)
                                                 and trim(v.ordre) = trim(s.ordre)
                                                 );
        EXCEPTION WHEN OTHERS THEN
			err_code := SQLCODE;
			err_msg  := SUBSTR(SQLERRM, 1, 200);
			insert into prob_migration(nom_table, val_ref, sql_err, date_pro,type_problem)
			values('miwtreleveT',releve_.tourne || '--' || releve_.ordre,
			       err_code || '--' || err_msg,sysdate,'erreur de recupertion des donnees pour le relevet pour le pdl '||releve_.district|| releve_.tourne|| releve_.ordre );
            continue;
        END;
-----------------------------------------------------------
-----------------------------------------------------------
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
						from branchement a
						where trim(a.district) = trim(releve_.district)
						and lpad(trim(a.tourne),3, '0') =lpad(trim(releve_.tourne), 3, '0')
						and lpad(trim(a.ordre),3, '0') =lpad(trim(releve_.ordre), 3, '0')) loop
				-- numero compteur (branchement)
				-- reception code point instalation PDI
				V_RL_BR_NUM :=lpad(bra_.district,2,'0')||lpad(trim(bra_.tourne),3,'0')||lpad(trim(bra_.ordre),3,'0')||lpad(to_char(trim(bra_.police)), 5, '0');
				V_COUNT_BR  := V_COUNT_BR + 1;
            end loop;

			-- verfication si le compteur existe deja au niveau de la table des compteurs
			-------------------------------------------------------
			------------------------------------------------------- RECHERCHE COMPTEUR
			V_RL_CP_NUM_RL:=null  ;
			/*begin
			select p.mhpc_refcom
			into V_RL_CP_NUM_RL
			from miwthistocpt p
			where substr(p.mhpc_refpdl,1,8)=trim(releve_.district)||trim(releve_.tourne)||trim(releve_.ordre);
			exception
			when others then

			err_code := SQLCODE;
			err_msg  := SUBSTR(SQLERRM, 1, 200);
			insert into prob_migration
			(nom_table, val_ref, sql_err, date_pro,type_problem)
			values
			('miwtreleveT_ref_cpt',
			releve_.tourne || '--' || releve_.ordre,
			err_code || '--' || err_msg,sysdate,'problem recuperation compteur pour le pdl '||trim(releve_.district)||trim(releve_.tourne)||trim(releve_.ordre));
			continue;
			end;*/
			-----------------------------------------------------
			V_DTE_RL := substr(releve_.date_releve,1, instr(replace(replace(releve_.date_releve,' ','#'),':','#'),'#') - 1);
			V_DTE_RL := replace(V_DTE_RL, '-', '/');
			V_DTE_RELEVE := to_date(V_DTE_RL,'dd/mm/yy');
			--test date
			------------------------------------------------------
			BEGIN
				select to_date(lpad(trim(t.datexp),8,'0'), 'dd/mm/yyyy') - 7
				into V_DTE_RELEVE
				from ROLE_TRIM t
				where lpad(TRIM(t.distr),2,'0')= trim(releve_.district)
				and TRIM(t.annee)= trim(releve_.annee)
				and TRIM(t.trim)= trim(v_trim)
				and lpad(TRIM(t.tour),3,'0') =lpad(trim(releve_.tourne),3,'0')
				and lpad(TRIM(t.ordr),3,'0') =lpad(trim(releve_.ordre),3,'0');
			EXCEPTION WHEN OTHERS THEN
				BEGIN
				  select to_date(lpad(trim(t.datexp),8,'0'),'dd/mm/yyyy') - 7
					into V_DTE_RELEVE
					from ROLE_MENS t
				    where lpad(TRIM(t.distr),2,'0') = trim(releve_.district)
					and TRIM(t.annee) = trim(releve_.annee)
					and TRIM(t.mois) = trim(v_trim)
					and lpad(TRIM(t.tour),3,'0') =lpad(trim(releve_.tourne),3,'0')
					and lpad(TRIM(t.ordr),3,'0') =lpad(trim(releve_.ordre),3,'0');
				EXCEPTION WHEN OTHERS THen
                    if substr(releve_.annee,3,2) !=to_char(to_date(substr(releve_.date_releve,1,10),'dd/mm/yyyy hh24:mi:ss'),'YY') and v_trim in (1, 2, 3) then
				       select t.ntiers, t.NSIXIEME
					   into v_NTIERS, v_NSIXIEME
					   from tourne t
					   where trim(t.code) = trim(releve_.tourne)
					   and  trim(t.district) = trim(releve_.district);
					 
					    if v_NSIXIEME = 1 THEN
							IF v_trim = 1 THEN
							  V_DTE_RELEVE := to_date('08/0' || to_char(v_NTIERS) || '/' ||
													  releve_.annee,
													  'dd/mm/yyyy');
							ELSIF v_trim = 2 THEN
							  V_DTE_RELEVE := to_date('08/0' || to_char(3 + v_NTIERS) || '/' ||
													  releve_.annee,
													  'dd/mm/yyyy');
							ELSIF v_trim = 3 THEN
							  V_DTE_RELEVE := to_date('08/0' || to_char(6 + v_NTIERS) || '/' ||
													  releve_.annee,
													  'dd/mm/yyyy');
							ELSIF v_trim = 4 THEN
							  V_DTE_RELEVE := to_date('08/' || to_char(9 + v_NTIERS) || '/' ||
													  releve_.annee,
													  'dd/mm/yyyy');
							end if;
					    else
							IF v_trim = 1 THEN
							  V_DTE_RELEVE := to_date('15/0' || to_char(v_NTIERS) || '/' ||releve_.annee,'dd/mm/yyyy');
							ELSIF v_trim = 2 THEN
							V_DTE_RELEVE := to_date('15/0' || to_char(3 + v_NTIERS) || '/' ||releve_.annee,'dd/mm/yyyy');
							ELSIF v_trim = 3 THEN
							V_DTE_RELEVE := to_date('15/0' || to_char(6 + v_NTIERS) || '/' ||releve_.annee,'dd/mm/yyyy');
							ELSIF v_trim = 4 THEN
							V_DTE_RELEVE := to_date('15/' || to_char(9 + v_NTIERS) || '/' ||releve_.annee,'dd/mm/yyyy');
							end if;
					    end if;
				    end if;
			    END;
			END;
            IF trim(v_date_controle) is null and trim(v_index_controle) is null or trim(v_index_controle) = 0) then
			  V_RL_LECIMP := 'TOURNEE';
			ELSE
			  V_RL_LECIMP := 'CONTROLE';
			END IF;
            v_ref_releve_  := v_ref_releve_ + 1;
			v_MREL_DEDUITE := 0;
			if to_number(releve_.prorata) > 0 then
			  v_MREL_DEDUITE := nvl(to_number(trim(releve_.consommation)), 0) - releve_.prorata;
			end if;
			BEGIN
				if to_number(ltrim(rtrim(v_avisforte))) > 0 then
				v_avisforte := 'N°Avis Forte=' || v_avisforte;
				end if;
			EXCEPTION WHEN OTHERS THEN
				v_avisforte := null;
			END;
            if to_number(releve_.annee)=0 then
			  v_annee:=to_char(sysdate,'yyyy');
			else
			  v_annee:=to_number(releve_.annee);
			end if;
            BEGIN
				insert into Miwtrelevet
				  (
				   MREL_SOURCE      ,--1  Identifiant de la source de donnees [OBL]
				   MREL_REF         ,--2  Reference de la releve dans le SI source (le couple source/reference releve doit etre UNIQUE) [OBL]
				   MREL_REFPDL      ,--3  Reference du PDl dans le SI source
				   MREL_REFCOM      ,--4  Reference du compteur dans le SI source
				   MREL_DATE        ,--5  Date de la releve [OBL]
				   MREL_INDEX1      ,--6  Index
				   MREL_CONSO1      ,--7
				   MREL_CADRAN1     ,--8
				   MREL_CADRAN2     ,--9
				   MREL_CADRAN3     ,--10
				   MREL_CADRAN4     ,--11
				   MREL_CADRAN5     ,--12
				   MREL_CADRAN6     ,--13
				   VOC_READORIG     ,--14
				   VOC_READREASON   ,--15
				   MREL_ETATFACT    ,--16
				   MREL_FACTUREE    ,--17
				   MREL_AGESOURCE   ,--18
				   MREL_AGEREF      ,--19
				   annee            ,--20
				   periode          ,--21
				   mrel_agrtype     ,--22
				   mrel_techtype    ,--23
				   voc_comm1        ,--24
				   VOC_READCODE     ,--25
				   MREL_CONSO_REF1  ,--26
				   mrel_ano_c1      ,--27
				   mrel_ano_c2      ,--28
				   mrel_ano_c3      ,--29
				   mrel_ano_n1      ,--30
				   mrel_ano_n2      ,--31
				   mrel_ano_n3      ,--32
				   mrel_ano_f1      ,--33
				   mrel_ano_f2      ,--34
				   mrel_ano_f3      ,--35
				   MREL_DEDUITE     ,--36
				   MREL_INDEX2      ,--37
				   MREL_INDEX3      ,--38
				   MREL_INDEX4      ,--39
				   MREL_INDEX5      ,--40
				   MREL_INDEX6      ,--41
				   mrel_comlibre     --42
				  )
			    values
				  (
				  'DIST' || releve_.district ,-- 1
				   v_ref_releve_       ,--2
				   V_RL_BR_NUM         ,--3
				   V_RL_CP_NUM_RL      ,--4
				   releve_.date_releve ,--5
				   to_number(releve_.index_releve),--6
				   nvl(to_number(trim(releve_.consommation)), 0),--7
				   'EAU'               ,--8
				   'TENT1'             ,--9
				   'TENT2'             ,--10
				   'TENT3'             ,--11
				   'TENT4'             ,--12
				   'CPTTOU'            ,--13
				   '03'                ,--14
				   V_RL_LECIMP         ,--15
				   0                   ,--16
				   1                   ,--17
				   v_MATRICULE_RELEVEUR,--18
				   v_MATRICULE_RELEVEUR,--19
				   v_annee             ,--20
				   to_number(v_trim)   ,--21
				   0                   ,--22
				   0                   ,--23
				   V_CODE_ANOMALIE     ,--24
				   V_CODE_SI_ANOMALIE  ,--25
				   0                   ,--26
				   substr(v_anomalie, 1, 2),--27
				   substr(v_anomalie, 3, 2),--28
				   substr(v_anomalie, 5, 2),--29
				   substr(v_anomalie, 7, 2),--30
				   substr(v_anomalie, 9, 2),--31
				   substr(v_anomalie, 11, 2),--32
				   substr(v_anomalie, 13, 2),--33
				   substr(v_anomalie, 15, 2),--34
				   substr(v_anomalie, 17, 2),--35
				   v_MREL_DEDUITE           ,--36
				   to_number(replace(v_releve2, '.', null)),--37
				   to_number(replace(v_releve3, '.', null)),--38
				   to_number(replace(v_releve4, '.', null)),--39
				   to_number(replace(v_releve5, '.', null)),--40
				   nvl(to_number(decode(trim(v_compteurt),'T','1','1','1','0')),0),--41
					trim(v_message_temporaire) || v_avisforte --42
				   );
            EXCEPTION WHEN OTHERS THEN
				err_code := SQLCODE;
				err_msg  := SUBSTR(SQLERRM, 1, 200);
				insert into prob_migration(nom_table, val_ref, sql_err, date_pro,type_problem)
				values('miwtreleveT',V_RL_BR_NUM || '--' || to_number(releve_.annee) ||
				       to_number(v_trim),
				       err_code || '--' || err_msg,sysdate,'erreur de manque de date relevet pour le pdl suivante'||trim(releve_.district)||trim(releve_.tourne)||trim(releve_.ordre));
            END;
            v_nbr_trsf := v_nbr_trsf + 1;
        EXCEPTION WHEN OTHERS THEN
			err_code := SQLCODE;
			err_msg  := SUBSTR(SQLERRM, 1, 200);
			insert into prob_migration(nom_table, val_ref, sql_err, date_pro,type_problem)
			values('miwtreleveT11',V_RL_BR_NUM || '-' || releve_.date_releve,
			   err_code || '--' || err_msg,sysdate,'erreur de confomité de type colonne pour le pdl suivante'||trim(releve_.district)||trim(releve_.tourne)||trim(releve_.ordre));
			v_nbr_rej := v_nbr_rej + 1;
			v_msg     := sqlerrm;
        END;
        COMMIT;
    end loop;
insert into prob_migration (nom_table)values(SYSTIMESTAMP||'   END miw_treleve_T');
commit;
end;

