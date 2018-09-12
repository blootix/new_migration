declare 
    CURSOR releh_pose is select e.equ_id,
								e.spt_id,
								e.heq_startdt,
								e.heq_enddt,
								t.mtc_id
						 from techequipment e,tecmeter t
						 where e.equ_id=t.equ_id
						 and vow_reaspose='P';
				   
    CURSOR releh_Depose is  select e.equ_id,
								   e.spt_id,
								   e.heq_startdt,
								   e.heq_enddt,
								   t.mtc_id
							from techequipment e,tecmeter t
							where e.equ_id=t.equ_id
							and vow_reasdepose='D';	
						
    CURSOR branch_(ref_br varchar2) is select  b.*
									   from branchement b
									   where lpad(trim(b.district),2,'0')||
									   and   lpad(trim(b.tourne),3,'0')  ||
									   and   lpad(trim(b.ordre),3,'0')   = ref_br;		
	 
	CURSOR C_ID(V_SPT_REF varchar2) is select e.equ_id,e.spt_id,t.mtc_id  
									   from techequipment e,tecmeter t,tecservicepoint spt
									   where e.equ_id     = t.equ_id	
									   and   e.spt_id     = spt.spt_id
									   and   spt.spt_refe = V_SPT_REF;
	 
	CURSOR releve is select district,tourne,ordre,annee,trim,releve,prorata,constrim4,marche,releve2,releve3,releve4,releve5,date_releve,
                          compteurt,consommation,lpad(trim(anomalie),18,0)anomalie,saisie,avisFORte,message_temporaire,compteurchange,
                          n_tsp,matricule_releveur,date_controle,matricule_controle,index_controle,nbre_roues,derniere_releve,usage,
                          tarif,diamctr,cctr,codemarque,ncompteur,ancien_releve
                     from fiche_releve a
                     where trim(trim) is not null
                     and trim(a.annee)>=2015
                    ----- sans tenir en compte le donner de relevet------
                     and  to_NUMBER(trim(a.annee)||trim(a.trim))<>(select max(to_NUMBER(trim(v.annee)||trim(v.trim)))
																   from fiche_releve v
																   where trim(v.tourne) = trim(a.tourne)
																   and trim(v.ordre)    = trim(a.ordre));				
    
	CURSOR relevet is select decode(annee,0,indexa,indexr) index_releve,a.* from releveT a;
					 
	CURSOR releve_gc select distinct a.nindex,
                                    a.prorata,
                                    a.cons,
                                    a.refc02,
                                    a.refc01,
                                    a.dist,
                                    a.tou,
                                    a.ord,
                                    a.pol,
                    from  facture_as400gc a,relevegc c
                    where lpad(trim(a.dist),2,'0') =lpad(trim(c.district),2,'0')
                    and   lpad(trim(a.tou) ,3,'0') =lpad(trim(c.tourne),3,'0')
                    and   lpad(trim(a.ord) ,3,'0') =lpad(trim(c.ordre),3,'0') 
                    and   lpad(trim(a.pol) ,5,'0') =lpad(trim(c.police),5,'0');
					 
	CURSOR releve_gcT is select a.* from relevegc a where trim(a.mois) is not null;
 
	CURSOR spt_c is select t.spt_refe from tecservicepoint t;
	
	CURSOR C_TECMTRREAD(V_spt_refe varchar2) is select t.*
												from TECMTRREAD t 
												WHERE t.spt_id=(select y.spt_id 
												                from tecservicepoint y	
																where y.spt_refe=V_spt_refe)
												ORDER BY MRD_DT;			
												
	CURSOR avg_con is select avg(m.mme_consum) mme_consum,a.sag_id,a.spt_id 
					  from TECMTRREAD t,AGRSERVICEAGR a,tecmtrmeasure m
					  where t.mrd_id=m.mrd_id
					  and   t.spt_id=a.spt_id
					  group by a.sag_id,a.spt_id;
	
	v_pk_etape           varchar2(400);
	V_AGE_ID             number:= 1;
	V_MEU_ID             number:= 5;
	V_MRD_ID         	 number;
	V_ACO_ID             number;
	V_AAC_ID 			 number;
	V_VOW_READORIG       number := 5536;--'MIGRATION'-03
	V_VOW_READMETH       number := 5537;--INCONN(MIGRATION)
	V_VOW_COMM1        	 number := 5741;--ANOMALIE Anomalie niche ='00'
	V_VOW_COMM2          number;
	V_VOW_COMM3          number;
	V_VOW_READREASON     number;
	V_VOW_READCODE   	 number;
	V_MRD_AGRTYPE        number := 0;
	V_MRD_LOCKED         number := 0;
	V_MRD_TECHTYPE       number := 0;
    V_MRD_SUBREAD        number := 0;
	V_MRD_ETATFACT       number := 0; 
	V_MRD_USECR          number := 1;
	V_MRD_MULTICAD       number;
	V_MRD_YEAR           number; 
	V_NTIERS             number;
	V_NSIXIEME           number;
	V_MME_DEDUCEMANUAL   number;
	V_TRIM               number;
	V_MRD_DT             DATE;
	V_REF				 VARCHAR2(50);
	V_RL_CP_NUM_RL       VARCHAR2(50);
	V_RL_LECIMP	         VARCHAR2(50);
	V_DTE_RL             VARCHAR2(50);
	V_DATE_CONTROLE      VARCHAR2(50);
	V_INDEX_CONTROLE     VARCHAR2(50);
	V_COMPTEURT          VARCHAR2(50);
	V_RELEVE2            VARCHAR2(50);
	V_RELEVE3            VARCHAR2(50);
	V_RELEVE4            VARCHAR2(50);
	V_RELEVE5            VARCHAR2(50);
	V_ANOMALIE           VARCHAR2(50);
	V_CODE_ANOMALIE 	 VARCHAR2(50); 
	V_MRD_COMMENT        VARCHAR2(100); 
	V_AVISFORTE	         VARCHAR2(100);
	V_MATRICULE_RELEVEUR VARCHAR2(100); 
	V_MSG_TEMPO          VARCHAR2(100);

BEGIN 	
 	  
	V_mrd_comment    :='0';
	V_mrd_techtype   :=1;
	--------------------------------------------------------------------
	-----------------------                      -----------------------
	-----------------------    Relève de pose    -----------------------
	-----------------------                      -----------------------
	--------------------------------------------------------------------
	v_pk_etape:='Création  Relève de pose'
	FOR x in releh_pose	LOOP
		V_mrd_year:=substr(x.heq_startdt,7,4);
		if(substr(x.heq_startdt,4,2)in('01','02','03')) then
			V_mrd_multicad:=1;
		elsif (substr(x.heq_startdt,4,2)in('04','05','06')) then
			V_mrd_multicad:=2;
		elsif (substr(x.heq_startdt,4,2)in('07','08','09')) then
			V_mrd_multicad:=3;
		elsif (substr(x.heq_startdt,4,2)in('10','11','12')) then
			V_mrd_multicad:=4;
		end if;
		select seq_tecmtrread.nextval into V_mrd_id from dual;			
		INSERT INTO tecmtrread(mrd_id,equ_id,mtc_id,mrd_dt,spt_id,vow_comm1,vow_comm2,vow_comm3,vow_readcode,vow_readorig,
							   vow_readmeth,vow_readreason,mrd_comment,mrd_locked,mrd_msgbill,mrd_agrtype,mrd_techtype,
							   mrd_subread,mrd_deduction_id,mrd_etatfact,AGE_ID,MRD_USECR,mrd_year,mrd_multicad) 
						VALUES(V_mrd_id,x.equ_id,x.mtc_id,x.heq_startdt,x.spt_id,V_vow_comm1,V_vow_comm2,V_vow_comm3,V_vow_readcode,
							   V_vow_readorig,V_vow_readmeth,V_vow_readreason,V_mrd_comment,V_mrd_locked,null,V_mrd_techtype,
							   V_mrd_subread,null,V_mrd_etatfact,V_AGE_ID,V_MRD_USECR,V_mrd_year,V_mrd_multicad);
		select seq_tecmtrmeasure.nextval into V_MME_ID from dual;
		INSERT INTO tecmtrmeasure(MME_ID,MRD_ID,MEU_ID,MME_NUM,MME_VALUE,MME_CONSUM,MME_AVGCONSUM,MME_DEDUCEMANUAL)
						   VALUES(V_MME_ID,V_MRD_ID,V_MEU_ID,1,0,0,0,null);
		COMMIT;
	END LOOP;
	--------------------------------------------------------------------
	-----------------------                      -----------------------
	-----------------------    Relève de dépose    -----------------------
	-----------------------                      -----------------------
	--------------------------------------------------------------------
	v_pk_etape:='Création Relève de dépose'	
	FOR x in releh_Depose LOOP
		V_mrd_techtype := 2; 
		V_mrd_year:=substr(x.heq_enddt,7,4);
		if(substr(releve_.heq_enddt,4,2)in('01','02','03')) then
			V_mrd_multicad:=1;
		elsif (substr(x.heq_enddt,4,2)in('04','05','06')) then
			V_mrd_multicad:=2;
		elsif (substr(x.heq_enddt,4,2)in('07','08','09')) then
			V_mrd_multicad:=3;
		elsif (substr(x.heq_enddt,4,2)in('10','11','12')) then
			V_mrd_multicad:=4;
		end if;
		select seq_tecmtrread.nextval into V_mrd_id from dual;					
		INSERT INTO tecmtrread(mrd_id,equ_id,mtc_id,mrd_dt,spt_id,vow_comm1,vow_comm2,vow_comm3,vow_readcode,vow_readorig ,
							   vow_readmeth,vow_readreason,mrd_comment,mrd_locked,mrd_msgbill,mrd_agrtype,mrd_techtype,
							   mrd_subread,mrd_deduction_id,mrd_etatfact,AGE_ID,MRD_USECR,mrd_year,mrd_multicad) 
						VALUES(V_mrd_id,x.equ_id,x.mtc_id,x.heq_enddt,x.spt_id,V_vow_comm1,V_vow_comm2,V_vow_comm3,V_vow_readcode  ,
							   V_vow_readorig,V_vow_readmeth,V_vow_readreason,V_mrd_comment,V_mrd_locked,null,V_mrd_techtype,
							   V_mrd_subread,null,V_mrd_etatfact,V_AGE_ID,V_MRD_USECR,V_mrd_year,V_mrd_multicad);
		select seq_tecmtrmeasure.nextval into V_MME_ID from dual;
		INSERT INTO tecmtrmeasure(MME_ID,MRD_ID,MEU_ID,MME_NUM,MME_VALUE,MME_CONSUM,MME_AVGCONSUM,MME_DEDUCEMANUAL)
						   VALUES(V_MME_ID,V_MRD_ID,V_MEU_ID,1,0,0,0,null);
		COMMIT;
	END LOOP;
---------------------------------------------------------------------------------------------
-------------------------------Historique RELEVE TRIMESTRIEL --------------------------------
---------------------------------------------------------------------------------------------		
	v_pk_etape:='Création Historique Réleve Trimestriel';
	FOR releve_ in releve LOOP
	    v_ref:=lpad(trim(releve_.district),2,'0')||
		       lpad(trim(releve_.tourne),3,'0')||
			   lpad(trim(releve_.ordre),3,'0');
		FOR x in branch_(v_ref)LOOP			   
		 	V_RL_BR_NUM:=lpad(trim(releve_.district),2,'0')||
			             lpad(trim(releve_.tourne),3,'0')||
						 lpad(trim(releve_.ordre),3,'0')||
						 lpad(trim(releve_.police),5,'0');    			
			if to_NUMBER(releve_.prorata)>0 then
				V_MME_DEDUCEMANUAL:=nvl(to_NUMBER(trim(releve_.consommation)),0)-releve_.prorata;
			end if;
---------------------------recuperation date releve------------------------
			V_DTE_RL:=replace(substr(releve_.date_releve,1,instr(replace(replace(releve_.date_releve,' ','#'),':','#'),'#')-1),'-','/');
			BEGIN
				select to_date(lpad(t.datexp,8,'0'),'dd/mm/yyyy')- 7 
				into V_mrd_dt 
				from ROLE_TRIM t
				where lpad(TRIM(t.distr),2,'0')||
				and   lpad(TRIM(t.tour),3,'0')||
				and   lpad(TRIM(t.ordr),3,'0')=v_ref
				and   TRIM(t.annee)= trim(releve_.annee)
				and   TRIM(t.trim) = trim(releve_.trim);
			EXCEPTION WHEN OTHERS THEN
				BEGIN
					select to_date(lpad(t.datexp,8,'0'),'dd/mm/yyyy')- 7 
					into V_mrd_dt 
					from ROLE_MENS t
					where lpad(TRIM(t.distr),2,'0')||
				    and   lpad(TRIM(t.tour),3,'0')||
				    and   lpad(TRIM(t.ordr),3,'0')=v_ref
					and   TRIM(t.annee) = trim(releve_.annee)
					and   TRIM(t.mois)  = trim(releve_.trim)
				EXCEPTION WHEN OTHERS THEN
					if (substr(releve_.annee,3,2)!=to_char(to_date(substr(releve_.date_releve,1,10),'dd/mm/yyyy hh24:mi:ss'),'YY')and releve_.trim in (1,2,3)) then
						select t.ntiers,t.NSIXIEME
						into V_NTIERS,V_NSIXIEME
						from tourne t
						where lpad(trim(t.code),3,'0')    = lpad(trim(releve_.tourne),3,'0')
						and   lpad(trim(t.district),2,'0')= lpad(trim(releve_.district),2,'0');
						if V_NSIXIEME=1 THEN
							IF releve_.TRIM=1 THEN
								V_mrd_dt:=to_date('08/0'||to_char(V_NTIERS)||'/'||releve_.annee,'dd/mm/yyyy');
							ELSIF releve_.TRIM = 2 THEN
								V_mrd_dt:=to_date('08/0'||to_char(3+V_NTIERS)||'/'||releve_.annee,'dd/mm/yyyy');
							ELSIF releve_.TRIM = 3 THEN
								V_mrd_dt:=to_date('08/0'||to_char(6+V_NTIERS)||'/'||releve_.annee,'dd/mm/yyyy');
							ELSIF releve_.TRIM = 4 THEN
								V_mrd_dt:=to_date('08/'||to_char(9+V_NTIERS)||'/'||releve_.annee,'dd/mm/yyyy');
							end if;
						else
							IF releve_.TRIM=1 THEN
								V_mrd_dt:=to_date('15/0'||to_char(V_NTIERS)||'/'||releve_.annee,'dd/mm/yyyy');
							ELSIF releve_.TRIM = 2 THEN
								V_mrd_dt:=to_date('15/0'||to_char(3+V_NTIERS)||'/'||releve_.annee,'dd/mm/yyyy');
							ELSIF releve_.TRIM = 3 THEN
								V_mrd_dt:=to_date('15/0'||to_char(6+V_NTIERS)||'/'||releve_.annee,'dd/mm/yyyy');
							ELSIF releve_.TRIM = 4 THEN
								V_mrd_dt:=to_date('15/'||to_char(9+V_NTIERS)||'/'||releve_.annee,'dd/mm/yyyy');
							end if;
						end if;
					else
						V_mrd_dt := to_date(V_DTE_RL,'dd/mm/yy');
					end if;
				END;
			END;
			if (trim(releve_.DATE_CONTROLE)is null and nvl(trim(releve_.INDEX_CONTROLE),0)=0) then
				V_RL_LECIMP:='TOURNEE';
			else
				V_RL_LECIMP:='CONTROLE';
			end if;		
			-----------VOW_READREASON				
			SELECT vow.vow_id
			INTO   V_VOW_READREASON
			FROM   genvoc     voc,
				   genvocword vow
			WHERE  voc.voc_id   = vow.voc_id
			AND    vow.vow_code = V_RL_LECIMP
			AND    voc.voc_code ='VOW_READREASON';
			------------VOW_COMM2
			SELECT vow.vow_id
			INTO   V_vow_comm2
			FROM   genvoc     voc,
				   genvocword vow
			WHERE  voc.voc_id   = vow.voc_id
			AND    vow.vow_code = substr(releve_.anomalie,13,2)
			AND    voc.voc_code = 'VOW_COMM2';
			------------VOW_COMM3				
			SELECT vow.vow_id
			INTO   V_vow_comm3
			FROM   genvoc     voc,
				   genvocword vow
			WHERE  voc.voc_id   = vow.voc_id
			AND    vow.vow_code =substr(releve_.anomalie,1, 2)
			AND    voc.voc_code = 'VOW_COMM3';
			BEGIN
				if to_NUMBER(trim(releve_.avisforte))>0 then
					V_avisforte:='N°Avis forte='||releve_.avisforte;
				end if;
			EXCEPTION WHEN OTHERS THEN
				V_avisforte:=null;
			END;
			V_mrd_comment :=trim(releve_.message_temporaire)||V_avisforte
			V_mrd_techtype:=1;
			V_mrd_multicad:=to_NUMBER(releve_.trim);
			BEGIN
				select age_id 
				into V_AGE_ID
				from genagent g
				where g.age_refe=trim(releve_.matricule_releveur);
			EXCEPTION WHEN OTHERS THEN
				V_AGE_ID=1;
			END;
			V_mrd_year:=to_NUMBER(releve_.annee);
			FOR x in C_ID(V_RL_BR_NUM)LOOP
			    select seq_tecmtrread.nextval into V_mrd_id from dual;
				INSERT INTO tecmtrread(mrd_id,equ_id,mtc_id,mrd_dt,spt_id,vow_comm1,vow_comm2,vow_comm3,vow_readcode,
									   vow_readorig,vow_readmeth,vow_readreason,mrd_comment,mrd_locked,mrd_msgbill,mrd_agrtype,mrd_techtype,
									   mrd_subread,mrd_deduction_id,mrd_etatfact,AGE_ID,MRD_USECR,mrd_year,mrd_multicad) 
								VALUES(V_mrd_id,x.equ_id,x.mtc_id,V_mrd_dt,x.spt_id,V_vow_comm1,V_vow_comm2,V_vow_comm3,V_vow_readcode,
									   V_vow_readorig,V_vow_readmeth,V_vow_readreason,V_mrd_comment,V_mrd_locked,null,V_mrd_agrtype,V_mrd_techtype,
									   V_mrd_subread,null,V_mrd_etatfact,V_AGE_ID,V_MRD_USECR,V_mrd_year,V_mrd_multicad );
			-----------------------------------------------------------------------
			--------------------Création des indexs cadran 1-----------------------
			-----------------------------------------------------------------------
				select seq_tecmtrmeasure.nextval into V_MME_ID from dual;
				INSERT INTO tecmtrmeasure(MME_ID,MRD_ID,MEU_ID,MME_NUM,MME_VALUE,MME_CONSUM,MME_AVGCONSUM,MME_DEDUCEMANUAL)
								  VALUES (V_MME_ID,V_MRD_ID,V_MEU_ID,1,to_NUMBER(releve_.index_releve),nvl(to_NUMBER(trim(releve_.consommation)),0),0,V_MME_DEDUCEMANUAL) ;
			-----------------------------------------------------------------------
			--------------------Création des indexs cadran 2-----------------------
			-----------------------------------------------------------------------
				select seq_tecmtrmeasure.nextval into V_MME_ID from dual;
				INSERT INTO tecmtrmeasure(MME_ID,MRD_ID,MEU_ID,MME_NUM,MME_VALUE,MME_CONSUM,MME_AVGCONSUM,MME_DEDUCEMANUAL)
								  VALUES (V_MME_ID,V_MRD_ID,V_MEU_ID,2,to_NUMBER(replace(V_releve2,'.',null)),to_NUMBER(replace(V_releve2,'.',null)),0,V_MME_DEDUCEMANUAL) ;
			-----------------------------------------------------------------------
			--------------------Création des indexs cadran 3-----------------------
			-----------------------------------------------------------------------
				select seq_tecmtrmeasure.nextval into V_MME_ID from dual;
				INSERT INTO tecmtrmeasure(MME_ID,MRD_ID,MEU_ID,MME_NUM,MME_VALUE,MME_CONSUM,MME_AVGCONSUM,MME_DEDUCEMANUAL)
								  VALUES (V_MME_ID, V_MRD_ID,V_MEU_ID, 3, to_NUMBER(replace(V_releve3,'.',null)),to_NUMBER(replace(V_releve3,'.',null)),0,V_MME_DEDUCEMANUAL) ;
			-----------------------------------------------------------------------
			--------------------Création des indexs cadran 4-----------------------
			-----------------------------------------------------------------------
				select seq_tecmtrmeasure.nextval into V_MME_ID from dual;
				INSERT INTO tecmtrmeasure(MME_ID,MRD_ID,MEU_ID,MME_NUM,MME_VALUE,MME_CONSUM,MME_AVGCONSUM,MME_DEDUCEMANUAL)
								   VALUES(V_MME_ID,V_MRD_ID,V_MEU_ID,4,to_NUMBER(replace(V_releve4,'.',null)),to_NUMBER(replace(V_releve4,'.',null)),0,V_MME_DEDUCEMANUAL);
			-----------------------------------------------------------------------
			--------------------Création des indexs cadran 5-----------------------
			-----------------------------------------------------------------------
				select seq_tecmtrmeasure.nextval into V_MME_ID from dual;
				INSERT INTO tecmtrmeasure(MME_ID,MRD_ID,MEU_ID,MME_NUM,MME_VALUE,MME_CONSUM,MME_AVGCONSUM,MME_DEDUCEMANUAL)
								  VALUES (V_MME_ID,V_MRD_ID,V_MEU_ID,5,to_NUMBER(replace(V_releve5,'.',null)),to_NUMBER(replace(V_releve5,'.',null)),0,V_MME_DEDUCEMANUAL) ;
			-----------------------------------------------------------------------
			--------------------Création des indexs cadran 6-----------------------
			-----------------------------------------------------------------------
				select seq_tecmtrmeasure.nextval into V_MME_ID from dual;
				INSERT INTO tecmtrmeasure(MME_ID,MRD_ID,MEU_ID,MME_NUM,MME_VALUE,MME_CONSUM,MME_AVGCONSUM,MME_DEDUCEMANUAL)
								   VALUES(V_MME_ID,V_MRD_ID,V_MEU_ID,6,nvl(to_NUMBER(decode(trim(V_compteurt),'T','1','1','1','0')),0),nvl(to_NUMBER(decode(trim(V_compteurt),'T','1','1','1','0')),0),0,V_MME_DEDUCEMANUAL) ;
			COMMIT;		
			END LOOP;
	    END LOOP;
	END LOOP;
---------------------------------------------------------------------------------------------
-------------------------------DERNIERE RELEVE TRIMESTRIEL ----------------------------------
---------------------------------------------------------------------------------------------
	v_pk_etape:='Création Dernier Réleve Trimestriel';
	FOR releve_ in relevet   LOOP
	    v_ref:=lpad(releve_.district,2,'0')||
	           lpad(trim(releve_.tourne),3,'0')||
		       lpad(trim(releve_.ordre),3,'0');
	    FOR x in branch_(v_ref)LOOP
            V_RL_BR_NUM:=lpad(releve_.district,2,'0')||lpad(trim(releve_.tourne),3,'0')||lpad(trim(releve_.ordre),3,'0')||lpad(to_char(trim(releve_.police)),5,'0');
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
			into   V_trim,
				   V_date_controle,
				   V_index_controle,
				   V_avisforte,
				   V_msg_tempo,
				   V_compteurt,
				   V_releve2,
				   V_releve3,
				   V_releve4,
				   V_releve5,
				   V_anomalie,
				   V_MATRICULE_RELEVEUR
			from fiche_releve s
			where trim(s.district) = trim(releve_.district)
			and   trim(s.tourne)   = trim(releve_.tourne)
			and   trim(s.ordre)    = trim(releve_.ordre)
			and   trim(s.annee)||trim(s.trim)=(select max(trim(v.annee)||trim(v.trim))
											   from fiche_releve v
											   where trim(v.district)= trim(s.district)
											   and trim(v.tourne)    = trim(s.tourne)
											   and trim(v.ordre)     = trim(s.ordre));
			V_DTE_RL := replace(substr(releve_.date_releve,1,instr(replace(replace(releve_.date_releve,' ','#'),':','#'),'#')- 1),'-','/');
			V_mrd_dt := to_date(V_DTE_RL,'dd/mm/yy');
		------------------------------------------------------
			BEGIN
				select to_date(lpad(trim(t.datexp),8,'0'),'dd/mm/yyyy')- 7
				into V_mrd_dt
				from ROLE_TRIM t
				where lpad(TRIM(t.distr),2,'0')||
				and   lpad(TRIM(t.tour),3,'0') ||
				and   lpad(TRIM(t.ordr),3,'0') = v_ref
				and   TRIM(t.annee)            = trim(releve_.annee)
				and   TRIM(t.trim)             = trim(V_trim);
			EXCEPTION WHEN OTHERS THEN
				BEGIN
					select to_date(lpad(trim(t.datexp),8,'0'),'dd/mm/yyyy')- 7
					into V_mrd_dt
					from ROLE_MENS t
					where lpad(TRIM(t.distr),2,'0')||
				    and   lpad(TRIM(t.tour),3,'0') ||
				    and   lpad(TRIM(t.ordr),3,'0') = v_ref
					and   TRIM(t.annee)            = trim(releve_.annee)
					and   TRIM(t.mois)             = trim(V_trim);
				EXCEPTION WHEN OTHERS THEN
					if substr(releve_.annee,3,2) !=to_char(to_date(substr(releve_.date_releve,1,10),'dd/mm/yyyy hh24:mi:ss'),'YY') and V_trim in (1, 2, 3) then
						select t.ntiers,t.NSIXIEME
						into   V_NTIERS,V_NSIXIEME
						from tourne t
						where lpad(trim(t.code),3,'0')    = lpad(trim(releve_.tourne),3,'0')
						and   lpad(trim(t.district),2,'0')= lpad(trim(releve_.district),2,'0');
						if V_NSIXIEME = 1 THEN
							IF V_trim = 1 THEN
							  V_mrd_dt := to_date('08/0'|| to_char(V_NTIERS)||'/'||releve_.annee,'dd/mm/yyyy');
							ELSIF V_trim = 2 THEN
							  V_mrd_dt := to_date('08/0'|| to_char(3 + V_NTIERS)||'/'||releve_.annee,'dd/mm/yyyy');
							ELSIF V_trim = 3 THEN
							  V_mrd_dt := to_date('08/0'|| to_char(6 + V_NTIERS)||'/'||releve_.annee,'dd/mm/yyyy');
							ELSIF V_trim = 4 THEN
							  V_mrd_dt := to_date('08/'|| to_char(9 + V_NTIERS)||'/'||releve_.annee,'dd/mm/yyyy');
						    end if;
					    else
							IF V_trim = 1 THEN
							  V_mrd_dt := to_date('15/0'|| to_char(V_NTIERS)||'/'||releve_.annee,'dd/mm/yyyy');
							ELSIF V_trim = 2 THEN
							  V_mrd_dt := to_date('15/0'|| to_char(3 + V_NTIERS)||'/'||releve_.annee,'dd/mm/yyyy');
							ELSIF V_trim = 3 THEN
							  V_mrd_dt := to_date('15/0'|| to_char(6 + V_NTIERS)||'/'||releve_.annee,'dd/mm/yyyy');
							ELSIF V_trim = 4 THEN
							  V_mrd_dt := to_date('15/'|| to_char(9 + V_NTIERS)||'/'||releve_.annee,'dd/mm/yyyy');
							end if;
					    end if;
					end if;
				END;
			END;

			if(trim(V_date_controle) is null 
			and (trim(V_index_controle) is null or trim(V_index_controle) = 0) )then
			 V_RL_LECIMP := 'TOURNEE';
			ELSE
			 V_RL_LECIMP := 'CONTROLE';
			end if;
			----------VOW_READREASON
			SELECT vow.vow_id
			INTO   V_VOW_READREASON
			FROM   genvoc     voc,
				   genvocword vow
			WHERE  voc.voc_id   = vow.voc_id
			AND    vow.vow_code = V_RL_LECIMP
			AND    voc.voc_code ='VOW_READREASON';
			------------VOW_COMM2			
			SELECT vow.vow_id
			INTO   V_vow_comm2
			FROM   genvoc     voc,
				   genvocword vow
			WHERE  voc.voc_id   = vow.voc_id
			AND    vow.vow_code = substr(V_anomalie,13,2)
			AND    voc.voc_code = 'VOW_COMM2';
			------------VOW_COMM3							
			SELECT vow.vow_id
			INTO   V_vow_comm3
			FROM   genvoc     voc,
				   genvocword vow
			WHERE  voc.voc_id   = vow.voc_id
			AND    vow.vow_code = substr(V_anomalie,1,2)
			AND    voc.voc_code = 'VOW_COMM3';
							
			if to_NUMBER(releve_.prorata)> 0 then
			  V_MME_DEDUCEMANUAL := nvl(to_NUMBER(trim(releve_.consommation)),0)-releve_.prorata;
			end if;		
			V_MRD_MULTICAD:=V_trim;		
			BEGIN
			if to_NUMBER(trim(V_avisforte))> 0 then
			  V_avisforte := 'N°Avis FORte='||V_avisforte;
			end if;
			EXCEPTION WHEN OTHERS THEN
			  V_avisforte := null;
			END;
			V_mrd_comment:=trim(V_msg_tempo)||V_avisforte;
			if (to_NUMBER(releve_.annee)=0) then
			 V_mrd_year:=to_char(sysdate,'yyyy');
			else
			 V_mrd_year:=to_NUMBER(releve_.annee);
			end if;
			BEGIN
				select age_id 
				into V_AGE_ID
				from genagent g
				where g.age_refe=V_MATRICULE_RELEVEUR;
			EXCEPTION WHEN OTHERS THEN
				V_AGE_ID=1;
			END;

			FOR x in C_ID(V_RL_BR_NUM)LOOP	
				select seq_tecmtrread.nextval into V_mrd_id from dual;
				INSERT INTO tecmtrread(mrd_id,equ_id,mtc_id,mrd_dt,spt_id,vow_comm1,vow_comm2,vow_comm3,vow_readcode,vow_readorig,
									   vow_readmeth,vow_readreason,mrd_comment,mrd_locked,mrd_msgbill,mrd_agrtype,mrd_techtype,
									   mrd_subread,mrd_deduction_id,mrd_etatfact,AGE_ID,MRD_USECR,mrd_year,mrd_multicad) 
								VALUES(V_mrd_id,x.equ_id,x.mtc_id,V_mrd_dt,x.spt_id,V_vow_comm1,V_vow_comm2,V_vow_comm3,V_vow_readcode,V_vow_readorig,
									   V_vow_readmeth,V_vow_readreason,V_mrd_comment,V_mrd_locked,null,V_mrd_agrtype,V_mrd_techtype,V_mrd_subread,
									   null,V_mrd_etatfact,V_AGE_ID,V_MRD_USECR,V_mrd_year,V_mrd_multicad);	
			-----------------------------------------------------------------------
			--------------------Création des indexs cadran 1-----------------------
			-----------------------------------------------------------------------
				select seq_tecmtrmeasure.nextval into V_MME_ID from dual;
				INSERT INTO tecmtrmeasure(MME_ID,MRD_ID,MEU_ID,MME_NUM,MME_VALUE,MME_CONSUM,MME_AVGCONSUM,MME_DEDUCEMANUAL)
								   VALUES(V_MME_ID,V_MRD_ID,V_MEU_ID,1,to_NUMBER(releve_.releve),nvl(to_NUMBER(trim(releve_.consommation)),0),0,V_MME_DEDUCEMANUAL);					
			-----------------------------------------------------------------------
			--------------------Création des indexs cadran 2-----------------------
			-----------------------------------------------------------------------
				select seq_tecmtrmeasure.nextval into V_MME_ID from dual;
				INSERT INTO tecmtrmeasure(MME_ID,MRD_ID,MEU_ID,MME_NUM,MME_VALUE,MME_CONSUM,MME_AVGCONSUM,MME_DEDUCEMANUAL)
								   VALUES(V_MME_ID,V_MRD_ID,V_MEU_ID,2, to_NUMBER(replace(releve_.releve2,'.',null)),to_NUMBER(replace(releve_.releve2,'.',null)),0,V_MME_DEDUCEMANUAL);
			-----------------------------------------------------------------------
			--------------------Création des indexs cadran 3-----------------------
			-----------------------------------------------------------------------
				select seq_tecmtrmeasure.nextval into V_MME_ID from dual;
				INSERT INTO tecmtrmeasure(MME_ID,MRD_ID,MEU_ID,MME_NUM,MME_VALUE,MME_CONSUM,MME_AVGCONSUM,MME_DEDUCEMANUAL)
								   VALUES(V_MME_ID,V_MRD_ID,V_MEU_ID,3,to_NUMBER(replace(releve_.releve3,'.',null)),to_NUMBER(replace(releve_.releve3,'.',null)),0,V_MME_DEDUCEMANUAL);
			-----------------------------------------------------------------------
			--------------------Création des indexs cadran 4-----------------------
			-----------------------------------------------------------------------
				select seq_tecmtrmeasure.nextval into V_MME_ID from dual;
				INSERT INTO tecmtrmeasure(MME_ID,MRD_ID,MEU_ID,MME_NUM,MME_VALUE,MME_CONSUM,MME_AVGCONSUM,MME_DEDUCEMANUAL)
								   VALUES(V_MME_ID,V_MRD_ID,V_MEU_ID,4,to_NUMBER(replace(releve_.releve4,'.',null)),to_NUMBER(replace(releve_.releve4,'.',null)),0,V_MME_DEDUCEMANUAL);
			-----------------------------------------------------------------------
			--------------------Création des indexs cadran 5-----------------------
			-----------------------------------------------------------------------
				select seq_tecmtrmeasure.nextval into V_MME_ID from dual;
				INSERT INTO tecmtrmeasure(MME_ID,MRD_ID,MEU_ID,MME_NUM,MME_VALUE,MME_CONSUM,MME_AVGCONSUM,MME_DEDUCEMANUAL)
								   VALUES(V_MME_ID,V_MRD_ID,V_MEU_ID,5,to_NUMBER(replace(releve_.releve5,'.',null)),to_NUMBER(replace(releve_.releve5,'.',null)),0,V_MME_DEDUCEMANUAL);
			-----------------------------------------------------------------------
			--------------------Création des indexs cadran 6-----------------------
			-----------------------------------------------------------------------
				select seq_tecmtrmeasure.nextval into V_MME_ID from dual;
				INSERT INTO tecmtrmeasure(MME_ID,MRD_ID,MEU_ID,MME_NUM,MME_VALUE,MME_CONSUM,MME_AVGCONSUM,MME_DEDUCEMANUAL)
								   VALUES(V_MME_ID,V_MRD_ID,V_MEU_ID,6,nvl(to_NUMBER(decode(trim(releve_.compteurt),'T','1','1','1','0')),0),nvl(to_NUMBER(decode(trim(releve_.compteurt),'T','1','1','1','0')),0),0,V_MME_DEDUCEMANUAL);
			COMMIT;
		    END LOOP;	
		END LOOP;
	END LOOP;
---------------------------------------------------------------------------------------------	
-------------------------------HISTORIQUE RELEVE GROS CONSOMATEUR----------------------------
---------------------------------------------------------------------------------------------
	v_pk_etape:='Création Historique Réleve Gros Consomateur';
	FOR releve_ in releve_gc LOOP
	    v_ref:=lpad(trim(releve_.district),2,'0')||
		       lpad(trim(releve_.tourne),3,'0')||
			   lpad(trim(releve_.ordre),3,'0');
		FOR x in branch_(v_ref)LOOP
			V_RL_BR_NUM:=lpad(trim(releve_.district),2,'0')||lpad(trim(releve_.tourne),3,'0')|| lpad(trim(releve_.ordre),3,'0')||lpad(to_char(trim(releve_.police)),5,'0');
			if trim(releve_.nindex) is null then
				FOR com_L in (select a.code_anomalie
							  from listeanomalies_releve a
							  where lpad(trim(a.DISTRICT),2,'0')||  
							  and   lpad(trim(a.TOURNE),3,'0')|| 
							  and   lpad(trim(a.ORDRE),3,'0') = v_ref 
							  and   a.ANNEE                   ='20'||trim(releve_.refc02)
							  and   a.TRIM                    =releve_.refc01)LOOP
					V_CODE_ANOMALIE := trim(com_L.code_anomalie);
				END LOOP ;
			end if;
			----------VOW_COMM1
			SELECT vow.vow_id
			INTO   V_vow_comm1
			FROM   genvoc     voc,
				   genvocword vow
			WHERE  voc.voc_id   = vow.voc_id
			AND    vow.vow_code = V_CODE_ANOMALIE
			AND    voc.voc_code = 'VOW_COMM1';
			----------VOW_READREASON	
			SELECT vow.vow_id
			INTO   V_VOW_READREASON
			FROM   genvoc     voc,
				   genvocword vow
			WHERE  voc.voc_id   = vow.voc_id
			AND    vow.vow_code = 'TOURNEE' 
			AND    voc.voc_code = 'VOW_READREASON';
				
			if (to_NUMBER(releve_.Refc01)='12') then
				V_mrd_dt:='08/'||'01/'||'20'||to_char(to_NUMBER(trim(releve_.refc02))+1);
			else
				V_mrd_dt:='08/'||lpad(releve_.refc01+1,2,'0')||'/20'||trim(releve_.refc02);
			end if ;
			V_MRD_YEAR        :=to_NUMBER('20'||trim(releve_.refc02));
			V_mrd_multicad    :=to_NUMBER(releve_.refc01);
			V_MME_DEDUCEMANUAL:=nvl(to_NUMBER(trim(releve_.prorata)),0)*-1;
	 
			FOR x in C_ID(V_RL_BR_NUM)LOOP	
                select seq_tecmtrread.nextval into V_mrd_id from dual;			
				INSERT INTO tecmtrread(mrd_id,equ_id,mtc_id,mrd_dt,spt_id,vow_comm1,vow_comm2,vow_comm3,vow_readcode,vow_readorig,
									   vow_readmeth,vow_readreason,mrd_comment,mrd_locked,mrd_msgbill,mrd_agrtype,mrd_techtype,
									   mrd_subread,mrd_deduction_id,mrd_etatfact,AGE_ID,MRD_USECR,mrd_year,mrd_multicad) 
								VALUES(V_mrd_id,x.equ_id,x.mtc_id,V_mrd_dt,x.spt_id,V_vow_comm1,V_vow_comm2,V_vow_comm3,V_vow_readcode,V_vow_readorig,
									   V_vow_readmeth,V_vow_readreason,V_mrd_comment,V_mrd_locked,null,V_mrd_agrtype,V_mrd_techtype,V_mrd_subread,
									   null,V_mrd_etatfact,V_AGE_ID,V_MRD_USECR,V_mrd_year,V_mrd_multicad);
				-----------------------------------------------------------------------
			    --------------------Création des indexs cadran 1-----------------------
			    -----------------------------------------------------------------------
				select seq_tecmtrmeasure.nextval into V_MME_ID from dual;
				INSERT INTO tecmtrmeasure(MME_ID,MRD_ID,MEU_ID,MME_NUM,MME_VALUE,MME_CONSUM,MME_AVGCONSUM,MME_DEDUCEMANUAL)
								   VALUES(V_MME_ID,V_MRD_ID,V_MEU_ID,1,to_NUMBER(releve_.nindex),nvl(to_NUMBER(trim(releve_.cons)),0),0,V_MME_DEDUCEMANUAL);
				COMMIT;
			END LOOP;			
		END LOOP;
	END LOOP;
---------------------------------------------------------------------------------------------	
-------------------------------DERNIERE RELEVE GROS CONSOMATEUR------------------------------
---------------------------------------------------------------------------------------------
	v_pk_etape:='Création Derniere Réleve Gros Consomateur';
	FOR releve_ in releve_gcT 	LOOP
	    v_ref:=lpad(trim(releve_.district),2,'0')||
		       lpad(trim(releve_.tourne),3,'0')||
			   lpad(trim(releve_.ordre),3,'0');
		FOR x in branch_(v_ref)LOOP
			V_RL_BR_NUM:=lpad(trim(releve_.district),2,'0')||lpad(trim(releve_.tourne),3,'0')||lpad(trim(releve_.ordre),3,'0')||lpad(to_char(trim(releve_.police)),5,'0');
			if trim(releve_.nindex) is null then
				FOR com_L in (select a.code_anomalie
							  from listeanomalies_releve a
							  where lpad(trim(a.DISTRICT),2,'0')||
							  and   lpad(trim(a.TOURNE),3,'0')  ||
							  and   lpad(trim(a.ORDRE),3,'0')   = v_ref
							  and   a.ANNEE                     = '20'||trim(releve_.refc02)
							  and   a.TRIM                      = releve_.refc01)LOOP
					V_CODE_ANOMALIE := trim(com_L.code_anomalie); 
				END LOOP ;
			end if;
			-----------VOW_COMM1
			SELECT vow.vow_id
			INTO   V_vow_comm1
			FROM   genvoc     voc,
				   genvocword vow
			WHERE  voc.voc_id   = vow.voc_id
			AND    vow.vow_code = V_CODE_ANOMALIE
			AND    voc.voc_code = 'VOW_COMM1';
			------------VOW_READREASON	
			SELECT vow.vow_id
			INTO   V_VOW_READREASON
			FROM   genvoc     voc,
				   genvocword vow
			WHERE  voc.voc_id   = vow.voc_id
			AND    vow.vow_code = 'TOURNEE'
			AND    voc.voc_code ='VOW_READREASON';
				 
			V_mrd_dt:=trim(releve_.date_releve);
			if to_NUMBER(trim(releve_.annee))='0' then
				V_mrd_year:=to_char(sysdate,'yyyy');
			else
				V_mrd_year:=to_NUMBER(trim(releve_.annee));
			end if;
			V_mrd_multicad:=to_NUMBER(releve_.mois);
			V_MME_DEDUCEMANUAL := 0;
			if to_NUMBER(releve_.prorata)> 0 then
			  V_MME_DEDUCEMANUAL := nvl(to_NUMBER(trim(releve_.consommation)),0)-releve_.prorata;
			end if; 
			BEGIN
				select age_id 
				into V_AGE_ID
				from genagent g
				where g.age_refe=trim(releve_.etat);
			EXCEPTION WHEN OTHERS THEN
				V_AGE_ID=1;
			END;
		    FOR x in C_ID(V_RL_BR_NUM)LOOP	
				select seq_tecmtrread.nextval into V_mrd_id from dual;			   
				INSERT INTO tecmtrread(mrd_id,equ_id,mtc_id,mrd_dt,spt_id,vow_comm1,vow_comm2,vow_comm3,vow_readcode,vow_readorig,
									   vow_readmeth,vow_readreason,mrd_comment,mrd_locked,mrd_msgbill,mrd_agrtype,mrd_techtype,
									   mrd_subread,mrd_deduction_id,mrd_etatfact,AGE_ID,MRD_USECR,mrd_year,mrd_multicad) 
								VALUES(V_mrd_id,x.equ_id,x.mtc_id,V_mrd_d,x.spt_id,V_vow_comm1,V_vow_comm2,V_vow_comm3,V_vow_readcode,V_vow_readorig,
									   V_vow_readmeth,V_vow_readreason,V_mrd_comment,V_mrd_locked,null,V_mrd_agrtype,V_mrd_techtype,V_mrd_subread,
									   null,V_mrd_etatfact,V_AGE_ID,V_MRD_USECR,V_mrd_year,V_mrd_multicad);
			-----------------------------------------------------------------------
			--------------------Création des indexs cadran 1-----------------------
			-----------------------------------------------------------------------
				select seq_tecmtrmeasure.nextval into V_MME_ID from dual;
				INSERT INTO tecmtrmeasure(MME_ID,MRD_ID,MEU_ID,MME_NUM,MME_VALUE,MME_CONSUM,MME_AVGCONSUM,MME_DEDUCEMANUAL)
								   VALUES(V_MME_ID,V_MRD_ID,V_MEU_ID,1,to_NUMBER(releve_.indexr),nvl(to_NUMBER(trim(releve_.consommation)),0),0,V_MME_DEDUCEMANUAL);
			COMMIT;
			END LOOP;	
		END LOOP;
	END LOOP;
--------------------------------------------------------------------------------------------------------
-----------------------------UPDATE TECMTRREAD(MRD_PREVIOUS_ID)-----------------------------------------
--------------------------------------------------------------------------------------------------------
    v_pk_etape:='Mise A jour releve precedente MRD_PREVIOUS_ID';
	FOR r in spt_c LOOP
		FOR s in C_TECMTRREAD(r.spt_refe) LOOP
			UPDATE TECMTRREAD t 
			set t.mrd_previous_id=s.mrd_id
			where t.mrd_id=(select mrd_id 
							from TECMTRREAD 
							where MRD_DT>s.MRD_DT  
							and spt_id= (select y.spt_id
									     from tecservicepoint y 
									     where y.spt_refe=r.spt_refe)
							and rownum=1
							)
			and t.spt_id=(select y.spt_id 
			              from tecservicepoint y 
						  where y.spt_refe=r.spt_refe);
		END LOOP;
    END LOOP;
    COMMIT;
--------------------------------------------------------------------------------------------------------
-----------------------------INSERTION AGRAVGCONSUM-----------------------------------------------------
--------------------------------------------------------------------------------------------------------
	v_pk_etape:='Création consommations de reférence'; 
	delete from AGRAVGCONSUM;
	FOR s in avg_con LOOP
		select seq_AGRAVGCONSUM.nextval into V_AAC_ID from dual;
		INSERT INTO AGRAVGCONSUM(aac_id,sag_id,meu_id,aac_avgconsummrd,aac_avgconsumimp,aac_enddt,aac_credt,aac_updtdt,aac_updtby)
						  VALUES(V_AAC_ID,s.sag_id,V_meu_id,s.mme_consum,null,null,null,null,null);
		COMMIT;
	END LOOP;
	COMMIT;
END;
/