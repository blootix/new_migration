declare 

    CURSOR releh_pose is select 
								 e.equ_id,
								 e.spt_id,
								 e.heq_startdt,
								 e.heq_enddt,
								 t.mtc_id
						   from techequipment e ,tecmeter t
						   where e.equ_id=t.equ_id
						   and vow_reaspose='P';
				   
    CURSOR releh_Depose is select 
							e.equ_id,
							e.spt_id,
							e.heq_startdt,
							e.heq_enddt,
							t.mtc_id
							from techequipment e ,tecmeter t
							where e.equ_id=t.equ_id
							and vow_reasdepose='D';	
						
    CURSOR branch_(district_ varchar2, tourne_ varchar2, ordre_ varchar2) is
    select  b.*
    from branchement b
    where  (trim(b.district),2,'0')=district_
	 and lpad(trim(b.tourne),3,'0')= tourne_
     and lpad(trim(b.ordre),3,'0')= ordre_;		
	 
	CURSOR C_ID (V_SPT_REF varchar2) is select e.equ_id,e.spt_id,t.mtc_id  
						  from techequipment e ,tecmeter t,tecservicepoint spt
						  where e.equ_id=t.equ_id	
						  and e.spt_id=spt.spt_id
						  and spt.spt_refe = V_SPT_REF;
	 
	CURSOR releve is select district ,tourne ,ordre,annee,trim,releve,prorata,constrim4,marche,releve2,releve3,releve4,releve5,date_releve,
                          compteurt,consommation,lpad(ltrim(rtrim(anomalie)),18,0) anomalie,saisie,avisFORte,message_temporaire,compteurchange,
                          n_tsp,matricule_releveur,date_controle,matricule_controle,index_controle,nbre_roues,derniere_releve,usage,
                          tarif,diamctr,cctr,codemarque,ncompteur,ancien_releve
                      from fiche_releve a,branchement b
                      where trim(trim) is not null
                      and trim(a.annee)>=2015
                   ------- sans tenir en compte le donner de relevet------
                      and  to_number(trim(a.annee) || trim(a.trim)) <>(select max(to_number(trim(v.annee) || trim(v.trim)))
																		from fiche_releve v
																		where trim(v.tourne) = trim(a.tourne)
																	    and trim(v.ordre) = trim(a.ordre))	;				
    
	CURSOR relevet is select decode(annee,0,indexa,indexr) index_releve,a.* from releveT a ,branchement b;
					 
	CURSOR releve_gc select distinct  a.nindex,
                                    a.prorata,
                                    a.cons,
                                    a.refc02,
                                    a.refc01,
                                    a.dist,
                                    a.tou,
                                    a.ord,
                                    a.pol,
                     from  facture_as400gc a, branchement b,relevegc c
                    where lpad(trim(a.pol),5,'0')=lpad(trim(c.police),5,'0')
                     and lpad(trim(a.tou),3,'0')=lpad(trim(c.tourne),3,'0')
                     and lpad(trim(a.ord),3,'0')=lpad(trim(c.ordre),3,'0') 
                     and lpad(trim(a.dist),2,'0')=trim(c.district);
					 
	CURSOR releve_gcT is select a.* from relevegc a  where  trim(a.mois) is not null	;
 
	CURSOR spt_c is select t.spt_refe from tecservicepoint t;
	
	CURSOR C_TECMTRREAD(V_spt_refe varchar2) IS select t.*, t.rowid 
												from TECMTRREAD t 
												WHERE t.spt_id= (select y.spt_id from tecservicepoint y	where y.spt_refe=V_spt_refe)
												ORDER BY MRD_DT ;			
												
	CURSOR avg_con is select avg(m.mme_consum) mme_consum,a.sag_id,a.spt_id 
						from TECMTRREAD t,AGRSERVICEAGR a,tecmtrmeasure m
						where t.mrd_id=m.mrd_id
						and a.spt_id=t.spt_id
						group by a.sag_id,a.spt_id;
	
	V_aac_id 			 number;		 				 
	V_vow_comm1          number;
	V_vow_comm2          number;
	V_vow_comm3          number;
	V_vow_readmeth       number;
	V_vow_readreason     number;
	V_vow_readcode   	 number;
	V_mrd_id         	 number;
	V_mrd_agrtype        number;
	V_mrd_comment        varchar2(50);
	V_mrd_locked         number:
	V_mrd_techtype       number;
	V_mrd_subread        number;
	V_mrd_etatfact       number;
	V_age_id             number;
	V_MRD_USECR          number;
	V_mrd_multicad       number;
	V_mrd_year           number;
	V_meu_id             number:=5;
	V_RL_BR_NUM          varchar2(50);
	V_RL_LECIMP	         varchar2(50);
	V_avisforte	         varchar2(50);
	V_NTIERS             number;
    V_NSIXIEME           number;
	V_mrd_dt             date;
	V_DTE_RL             varchar2(60);
	V_MME_DEDUCEMANUAL   number;
	V_trim               number;
    V_date_controle      varchar2(30);
    V_index_controle     varchar2(20);
    V_message_temporaire varchar(200);
    V_compteurt          varchar2(5);
    V_releve2            varchar2(10);
    V_releve3            varchar2(10);
    V_releve4            varchar2(10);
    V_releve5            varchar2(10);
    V_anomalie           varchar2(30);
    V_MATRICULE_RELEVEUR varchar2(100);
	V_CODE_ANOMALIE 	 varchar2(20);
    V_TYPE_ANOMALIE 	 varchar2(10);
    V_DESIG_ANOM    	 varchar2(200);
    V_TYPE_ANOM     	 varchar2(10);
    V_CODE_SI_ANOMALIE   varchar2(20);
	
	
BEGIN 	
	SELECT vow.vow_id
	INTO   V_vow_comm1
	FROM   genvoc     voc,
		   genvocword vow
	WHERE  voc.voc_id   = vow.voc_id
	AND    vow.vow_code = '00'
	AND    voc.voc_code = 'VOW_COMM1';
			
	SELECT vow.vow_id
	INTO   V_vow_readorig
	FROM   genvoc     voc,
		   genvocword vow
	WHERE  voc.voc_id   = vow.voc_id
	AND    vow.vow_code = '03'
	AND    voc.voc_code = 'VOW_READORIG';

	SELECT vow.vow_id
	INTO   V_VOW_READMETH
	FROM   genvoc     voc,
		   genvocword vow
	WHERE  voc.voc_id   = vow.voc_id
	AND    vow.vow_code = 'Inconn'
	AND    voc.voc_code ='VOW_READMETH';
	
	V_vow_comm2      :=NULL;
	V_vow_comm3      :=NULL;
	V_vow_readreason :=NULL;
	V_vow_readcode   :=NULL;
	V_mrd_comment    :='0';
	V_mrd_agrtype    :=0;
	V_mrd_locked     :=0;
	V_mrd_techtype   :=1;
	V_mrd_subread    :=0;
	V_mrd_etatfact   :=0;
	V_age_id         :=1;
	V_MRD_USECR      :=1;

		--------------------------------------------------------------------
		-----------------------                      -----------------------
		-----------------------    Relève de pose    -----------------------
		-----------------------                      -----------------------
		--------------------------------------------------------------------

		FOR x in releh_pose	LOOP

			select seq_tecmtrread.nextval into V_mrd_id from dual;
			select seq_tecmtrmeasure.nextval intoV_MME_ID from dual;
					
			V_mrd_year:=substr(x.heq_startdt,7,4);
			if(substr(releve_.heq_startdt,4,2)in('01','02','03')) then
				V_mrd_multicad:=1;
			elsif (substr(x.heq_startdt,4,2)in('04','05','06')) then
				V_mrd_multicad:=2;
			elsif (substr(x.heq_startdt,4,2)in('07','08','09')) then
				V_mrd_multicad:=3;
			elsif (substr(x.heq_startdt,4,2)in('10','11','12')) then
				V_mrd_multicad:=4;
			end if;
						
			INSERT INTO tecmtrread(mrd_id,equ_id,mtc_id,mrd_dt,spt_id,vow_comm1,vow_comm2,vow_comm3,vow_readcode,vow_readorig,
								   vow_readmeth,vow_readreason,mrd_comment,mrd_locked,mrd_msgbill,mrd_agrtype,mrd_techtype,
								   mrd_subread,mrd_deduction_id,mrd_etatfact,AGE_ID,MRD_USECR,mrd_year,mrd_multicad) 
							VALUES(V_mrd_id,x.equ_id,x.mtc_id,x.heq_startdt,x.spt_id,V_vow_comm1,V_vow_comm2,V_vow_comm3,V_vow_readcode,
								   V_vow_readorig,V_vow_readmeth,V_vow_readreason,V_mrd_comment,V_mrd_locked,null,V_mrd_techtype,
								   V_mrd_subread,null,V_mrd_etatfact,V_AGE_ID,V_MRD_USECR,V_mrd_year,V_mrd_multicad);

			INSERT INTO tecmtrmeasure(MME_ID,MRD_ID,MEU_ID,MME_NUM,MME_VALUE,MME_CONSUM,MME_AVGCONSUM,MME_DEDUCEMANUAL)
							VALUES(V_MME_ID,V_MRD_ID,V_MEU_ID,1,0,0,0,null);
		    COMMIT ;
		END LOOP;
		
		--------------------------------------------------------------------
		-----------------------                      -----------------------
		-----------------------    Relève de dépose    -----------------------
		-----------------------                      -----------------------
		--------------------------------------------------------------------
		FOR x in releh_Depose LOOP
		    V_mrd_techtype := 2;
		    select seq_tecmtrread.nextval into V_mrd_id from dual;
		    select seq_tecmtrmeasure.nextval into V_MME_ID from dual;
			
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
						
			INSERT INTO tecmtrread(mrd_id,equ_id,mtc_id,mrd_dt,spt_id,vow_comm1,vow_comm2,vow_comm3,vow_readcode,vow_readorig ,
								   vow_readmeth,vow_readreason,mrd_comment,mrd_locked,mrd_msgbill,mrd_agrtype,mrd_techtype,
								   mrd_subread,mrd_deduction_id,mrd_etatfact,AGE_ID,MRD_USECR,mrd_year,mrd_multicad) 
							VALUES(V_mrd_id,x.equ_id,x.mtc_id,x.heq_enddt,x.spt_id,V_vow_comm1,V_vow_comm2,V_vow_comm3,V_vow_readcode  ,
								   V_vow_readorig,V_vow_readmeth,V_vow_readreason,V_mrd_comment,V_mrd_locked,null,V_mrd_techtype,
								   V_mrd_subread,null,V_mrd_etatfact,V_AGE_ID,V_MRD_USECR,V_mrd_year,V_mrd_multicad);

			INSERT INTO tecmtrmeasure(MME_ID,MRD_ID,MEU_ID,MME_NUM,MME_VALUE,MME_CONSUM,MME_AVGCONSUM,MME_DEDUCEMANUAL)
							   VALUES(V_MME_ID,V_MRD_ID,V_MEU_ID,1,0,0,0,null);
		    COMMIT ;
		END LOOP;
		
	    FOR releve_ in releve LOOP
		
			FOR x in branch_(lpad(releve_.district,2,'0'),lpad(trim(releve_.tourne),3,'0'),lpad(trim(releve_.ordre),3,'0'))	LOOP			   
				V_VOW_READREASON  :=null;
				V_RL_LECIMP       :=null;
				V_mrd_comment     :=null;
				V_DTE_RL          :=null;
				V_MME_DEDUCEMANUAL:=null;
				V_RL_BR_NUM       :=null;
				V_mrd_dt          :=null;
				V_NTIERS          :=null;
				V_NSIXIEME        :=null;
				
	            select seq_tecmtrread.nextval into V_mrd_id from dual;
		        select seq_tecmtrmeasure.nextval into V_MME_ID from dual;
	 		    V_RL_BR_NUM:=lpad(releve_.district,2,'0')||lpad(trim(releve_.tourne),3,'0')||lpad(trim(releve_.ordre),3,'0')||lpad(to_char(trim(releve_.police)),5,'0');    			
				V_MME_DEDUCEMANUAL:=0;
				if to_number(releve_.prorata)>0 then
					V_MME_DEDUCEMANUAL:=nvl(to_number(trim(releve_.consommation)),0)-releve_.prorata;
				end if;
		        -------------------recuperation date releve------------------------
				V_DTE_RL:= substr(releve_.date_releve,1,instr(replace(replace(releve_.date_releve,' ','#'),':','#'),'#') - 1);
				V_DTE_RL:= replace(V_DTE_RL, '-', '/');
				BEGIN
					select to_date(lpad(t.datexp,8,'0'),'dd/mm/yyyy')- 7 
					into V_mrd_dt 
					from ROLE_TRIM t
					where lpad(TRIM(t.distr),2,'0')=trim(releve_.district)
					and   TRIM(t.annee)=trim(releve_.annee)
					and   TRIM(t.trim)=trim(releve_.trim)
					and   lpad(TRIM(t.tour),3,'0')= lpad(trim(releve_.tourne),3,'0')
					and   lpad(TRIM(t.ordr),3,'0')= lpad(trim(releve_.ordre),3,'0');
				EXCEPTION WHEN OTHERS THEN
						BEGIN
							select to_date(lpad(t.datexp,8,'0'),'dd/mm/yyyy')- 7 
							into V_mrd_dt 
							from ROLE_MENS t
							where lpad(TRIM(t.distr),2,'0') = trim(releve_.district)
							and   TRIM(t.annee) = trim(releve_.annee)
							and   TRIM(t.mois) =trim(releve_.trim)
							and   lpad(TRIM(t.tour),3,'0')= lpad(trim(releve_.tourne),3,'0')
							and   lpad(TRIM(t.ordr),3,'0')= lpad(trim(releve_.ordre),3,'0');
						EXCEPTION WHEN OTHERS THEN
								if (substr(releve_.annee,3,2)!=to_char(to_date(substr(releve_.date_releve,1,10),'dd/mm/yyyy hh24:mi:ss'),'YY')and releve_.trim in (1,2,3)) then
									select t.ntiers, t.NSIXIEME
									into V_NTIERS,V_NSIXIEME
									from tourne t
									where trim(t.code)= releve_.tourne
									and trim(t.district)=releve_.district;
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
										V_mrd_dt := to_date(V_DTE_RL, 'dd/mm/yy');
									end if;
						END;
				END;
				
      			if trim(releve_.DATE_CONTROLE)is null and(trim(releve_.INDEX_CONTROLE) is null or trim(releve_.INDEX_CONTROLE)=0) then
					V_RL_LECIMP:='TOURNEE';
				else
					V_RL_LECIMP:='CONTROLE';
				end if;		 
				SELECT vow.vow_id
				INTO   V_VOW_READREASON
				FROM   genvoc     voc,
					   genvocword vow
				WHERE  voc.voc_id   = vow.voc_id
				AND    vow.vow_code = V_RL_LECIMP
				AND    voc.voc_code ='VOW_READREASON';
				SELECT vow.vow_id
				INTO   V_vow_comm2
				FROM   genvoc     voc,
					   genvocword vow
				WHERE  voc.voc_id   = vow.voc_id
				AND    vow.vow_code =  substr(releve_.anomalie,13,2)
				AND    voc.voc_code = 'VOW_COMM2';						
				SELECT vow.vow_id
				INTO   V_vow_comm3
				FROM   genvoc     voc,
					   genvocword vow
				WHERE  voc.voc_id   = vow.voc_id
				AND    vow.vow_code =substr(releve_.anomalie,1, 2)
				AND    voc.voc_code = 'VOW_COMM3';
			    BEGIN
					if to_number(trim(releve_.avisFORte))>0 then
						V_avisforte:='N°Avis FORte='||releve_.avisFORte;
					end if;
				EXCEPTION WHEN OTHERS THEN
					V_avisforte:=null;
				END ;
				V_mrd_comment:=trim(releve_.message_temporaire)||V_avisforte
				V_mrd_techtype:=1;
				V_mrd_multicad:=to_number(releve_.trim);
				BEGIN
					select age_id 
					into V_AGE_ID
					from genagent g
					where g.age_refe=trim(releve_.matricule_releveur);
				EXCEPTION WHEN OTHERS THEN
					V_AGE_ID=1;
				END;
			    V_mrd_year:=to_number(releve_.annee);
				FOR x in C_ID(V_RL_BR_NUM)LOOP
				INSERT INTO tecmtrread(mrd_id,equ_id,mtc_id,mrd_dt,spt_id,vow_comm1,vow_comm2,vow_comm3,vow_readcode,vow_readorig,
									   vow_readmeth,vow_readreason,mrd_comment,mrd_locked,mrd_msgbill,mrd_agrtype,mrd_techtype  ,
									   mrd_subread,mrd_deduction_id,mrd_etatfact,AGE_ID,MRD_USECR,mrd_year,mrd_multicad) 
								VALUES(V_mrd_id,x.equ_id,x.mtc_id,V_mrd_dt,x.spt_id,V_vow_comm1,V_vow_comm2,V_vow_comm3,V_vow_readcode,
									   V_vow_readorig,V_vow_readmeth,V_vow_readreason,V_mrd_comment,V_mrd_locked,null,V_mrd_agrtype,V_mrd_techtype  ,
									   V_mrd_subread,null,V_mrd_etatfact,V_AGE_ID,V_MRD_USECR,V_mrd_year,V_mrd_multicad );
				-----------------------------------------------------------------------
				--------------------Création des indexs cadran 1-----------------------
				-----------------------------------------------------------------------
				INSERT INTO tecmtrmeasure(MME_ID,MRD_ID,MEU_ID,MME_NUM,MME_VALUE,MME_CONSUM,MME_AVGCONSUM,MME_DEDUCEMANUAL)
								  VALUES (V_MME_ID,V_MRD_ID,V_MEU_ID,1,to_number(releve_.index_releve),nvl(to_number(trim(releve_.consommation)),0),0,V_MME_DEDUCEMANUAL) ;
										
				-----------------------------------------------------------------------
				--------------------Création des indexs cadran 2-----------------------
				-----------------------------------------------------------------------
				select seq_tecmtrmeasure.nextval into V_MME_ID from dual;
				INSERT INTO tecmtrmeasure(MME_ID,MRD_ID,MEU_ID,MME_NUM,MME_VALUE,MME_CONSUM,MME_AVGCONSUM,MME_DEDUCEMANUAL)
								  VALUES (V_MME_ID,V_MRD_ID,V_MEU_ID,2,to_number(replace(V_releve2,'.', null)),to_number(replace(V_releve2,'.', null)),0,V_MME_DEDUCEMANUAL) ;
				-----------------------------------------------------------------------
				--------------------Création des indexs cadran 3-----------------------
				-----------------------------------------------------------------------
				select seq_tecmtrmeasure.nextval into V_MME_ID from dual;
				INSERT INTO tecmtrmeasure(MME_ID,MRD_ID,MEU_ID,MME_NUM,MME_VALUE,MME_CONSUM,MME_AVGCONSUM,MME_DEDUCEMANUAL)
								  VALUES (V_MME_ID, V_MRD_ID,V_MEU_ID, 3, to_number(replace(V_releve3,'.', null)),to_number(replace(V_releve3,'.', null)),0,V_MME_DEDUCEMANUAL) ;
				-----------------------------------------------------------------------
				--------------------Création des indexs cadran 4-----------------------
				-----------------------------------------------------------------------
				select seq_tecmtrmeasure.nextval into V_MME_ID from dual;
				INSERT INTO tecmtrmeasure(MME_ID,MRD_ID,MEU_ID,MME_NUM,MME_VALUE,MME_CONSUM,MME_AVGCONSUM,MME_DEDUCEMANUAL)
								  VALUES(V_MME_ID,V_MRD_ID,V_MEU_ID,4,to_number(replace(V_releve4,'.', null)),to_number(replace(V_releve4,'.', null)),0,V_MME_DEDUCEMANUAL);
			    -----------------------------------------------------------------------
			    --------------------Création des indexs cadran 5-----------------------
			    -----------------------------------------------------------------------
			    select seq_tecmtrmeasure.nextval into V_MME_ID from dual;
				INSERT INTO tecmtrmeasure(MME_ID,MRD_ID,MEU_ID,MME_NUM,MME_VALUE,MME_CONSUM,MME_AVGCONSUM,MME_DEDUCEMANUAL)
								  VALUES (V_MME_ID,V_MRD_ID,V_MEU_ID,5,to_number(replace(V_releve5,'.', null)),to_number(replace(V_releve5,'.', null)),0,V_MME_DEDUCEMANUAL) ;
				-----------------------------------------------------------------------
				--------------------Création des indexs cadran 6-----------------------
				-----------------------------------------------------------------------
				select seq_tecmtrmeasure.nextval into V_MME_ID from dual;
				INSERT INTO tecmtrmeasure(MME_ID,MRD_ID,MEU_ID,MME_NUM,MME_VALUE,MME_CONSUM,MME_AVGCONSUM,MME_DEDUCEMANUAL)
								  VALUES (V_MME_ID,V_MRD_ID,V_MEU_ID,6,nvl(to_number(decode(trim(V_compteurt),'T','1','1','1','0')),0),nvl(to_number(decode(trim(V_compteurt),'T','1','1','1','0')),0),0,V_MME_DEDUCEMANUAL) ;
				COMMIT;		
		        END LOOP;
	    END LOOP;
	END LOOP;
	
	FOR releve_ in relevet   LOOP
	    FOR x in branch_(lpad(releve_.district,2,'0'),lpad(trim(releve_.tourne),3,'0'),lpad(trim(releve_.ordre),3,'0'))LOOP
	
			    V_VOW_READREASON  :=null;
				V_RL_LECIMP       :=null;
				V_mrd_comment     :=null;
				V_DTE_RL          :=null;
				V_MME_DEDUCEMANUAL:=null;
				V_RL_BR_NUM       :=null;
				V_mrd_dt          :=null;
				V_NTIERS          :=null;
				V_NSIXIEME        :=null;
				V_trim 			  := null;
				V_date_controle   := null;
				V_index_controle  := null;
				V_avisforte       := null;
				V_message_temporaire := null;
				V_compteurt       := null;
				V_releve2         := null;
				V_releve3         := null;
				V_releve4         := null;
				V_releve5         := null;
				V_anomalie        := null;
				V_MATRICULE_RELEVEUR := null;
				V_mrd_agrtype 	  :=0;
				V_mrd_techtype    :=0;
				V_vow_readcode    :=null;
				V_mrd_locked      :=0;
				select seq_tecmtrread.nextval into V_mrd_id from dual;
				select seq_tecmtrmeasure.nextval into V_MME_ID from dual;
			 
				V_RL_BR_NUM:= lpad(releve_.district,2,'0')||lpad(trim(releve_.tourne),3,'0')||lpad(trim(releve_.ordre),3,'0')||lpad(to_char(trim(releve_.police)), 5, '0');
									   
				select s.trim,
					   s.date_controle,
					   s.index_controle,
					   s.avisFORte,
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
					   V_message_temporaire,
					   V_compteurt,
					   V_releve2,
					   V_releve3,
					   V_releve4,
					   V_releve5,
					   V_anomalie,
					   V_MATRICULE_RELEVEUR
				from fiche_releve s
				where trim(s.district) = trim(releve_.district)
				and trim(s.tourne)   = trim(releve_.tourne)
				and trim(s.ordre)    = trim(releve_.ordre)
				and trim(s.annee)||trim(s.trim)=(select max(trim(v.annee)||trim(v.trim))
												 from fiche_releve v
												 where trim(v.district)=trim(s.district)
												 and trim(v.tourne) = trim(s.tourne)
												 and trim(v.ordre) = trim(s.ordre));
				V_DTE_RL:= substr(releve_.date_releve,1,instr(replace(replace(releve_.date_releve,' ','#'),':','#'),'#') - 1);
				V_DTE_RL := replace(V_DTE_RL, '-', '/');
				V_mrd_dt := to_date(V_DTE_RL,'dd/mm/yy');
			  ------------------------------------------------------
				BEGIN
					select to_date(lpad(trim(t.datexp),8,'0'), 'dd/mm/yyyy') - 7
					  into V_mrd_dt
					  from ROLE_TRIM t
					 where lpad(TRIM(t.distr),2,'0')= trim(releve_.district)
					   and TRIM(t.annee)= trim(releve_.annee)
					   and TRIM(t.trim)= trim(V_trim)
					   and lpad(TRIM(t.tour),3,'0') =lpad(trim(releve_.tourne),3,'0')
					   and lpad(TRIM(t.ordr),3,'0') =lpad(trim(releve_.ordre),3,'0');
				EXCEPTION WHEN OTHERS THEN
					BEGIN
							select to_date(lpad(trim(t.datexp),8,'0'),'dd/mm/yyyy') - 7
							into V_mrd_dt
							from ROLE_MENS t
							where lpad(TRIM(t.distr),2,'0') = trim(releve_.district)
							and TRIM(t.annee) = trim(releve_.annee)
							and TRIM(t.mois) = trim(V_trim)
							and lpad(TRIM(t.tour),3,'0') =lpad(trim(releve_.tourne),3,'0')
							and lpad(TRIM(t.ordr),3,'0') =lpad(trim(releve_.ordre),3,'0');
							
					EXCEPTION WHEN OTHERS THEN
							if substr(releve_.annee,3,2) !=to_char(to_date(substr(releve_.date_releve,1,10),'dd/mm/yyyy hh24:mi:ss'),'YY') and V_trim in (1, 2, 3) then
						   
								select t.ntiers, t.NSIXIEME
								into V_NTIERS, V_NSIXIEME
								from tourne t
								where trim(t.code) = trim(releve_.tourne)
								and  trim(t.district) = trim(releve_.district);
								if V_NSIXIEME = 1 THEN
									IF V_trim = 1 THEN
									  V_mrd_dt := to_date('08/0' || to_char(V_NTIERS) || '/' ||releve_.annee,'dd/mm/yyyy');
									ELSIF V_trim = 2 THEN
									  V_mrd_dt := to_date('08/0' || to_char(3 + V_NTIERS) || '/' ||releve_.annee,'dd/mm/yyyy');
									ELSIF V_trim = 3 THEN
									  V_mrd_dt := to_date('08/0' || to_char(6 + V_NTIERS) || '/' ||releve_.annee,'dd/mm/yyyy');
									ELSIF V_trim = 4 THEN
									  V_mrd_dt := to_date('08/' || to_char(9 + V_NTIERS) || '/' ||releve_.annee,'dd/mm/yyyy');
								end if;
							else
								IF V_trim = 1 THEN
								  V_mrd_dt := to_date('15/0' || to_char(V_NTIERS) || '/' ||releve_.annee,'dd/mm/yyyy');
								ELSIF V_trim = 2 THEN
								V_mrd_dt := to_date('15/0' || to_char(3 + V_NTIERS) || '/' ||releve_.annee,'dd/mm/yyyy');
								ELSIF V_trim = 3 THEN
								V_mrd_dt := to_date('15/0' || to_char(6 + V_NTIERS) || '/' ||releve_.annee,'dd/mm/yyyy');
								ELSIF V_trim = 4 THEN
								V_mrd_dt := to_date('15/' || to_char(9 + V_NTIERS) || '/' ||releve_.annee,'dd/mm/yyyy');
								end if;
								end if;
							end if;
					END;
				END;

				if trim(V_date_controle) is null and
				(trim(V_index_controle) is null or trim(V_index_controle) = 0) then
				V_RL_LECIMP := 'TOURNEE';
				ELSE
				V_RL_LECIMP := 'CONTROLE';
				end if;
				SELECT vow.vow_id
				INTO   V_VOW_READREASON
				FROM   genvoc     voc,
				genvocword vow
				WHERE  voc.voc_id   = vow.voc_id
				AND    vow.vow_code = V_RL_LECIMP
				AND    voc.voc_code ='VOW_READREASON';
							
				SELECT vow.vow_id
				INTO   V_vow_comm2
				FROM   genvoc     voc,
					   genvocword vow
				WHERE  voc.voc_id   = vow.voc_id
				AND    vow.vow_code =  substr(V_anomalie, 13, 2)
				AND    voc.voc_code = 'VOW_COMM2';
											
				SELECT vow.vow_id
				INTO   V_vow_comm3
				FROM   genvoc     voc,
					   genvocword vow
				WHERE  voc.voc_id   = vow.voc_id
				AND    vow.vow_code =substr(V_anomalie, 1, 2)
				AND    voc.voc_code = 'VOW_COMM3';
							
				V_MME_DEDUCEMANUAL := 0;
				if to_number(releve_.prorata) > 0 then
				V_MME_DEDUCEMANUAL := nvl(to_number(trim(releve_.consommation)), 0) - releve_.prorata;
				end if;		
				V_MRD_MULTICAD:=V_trim;		
				BEGIN
				if to_number(trim(V_avisforte)) > 0 then
				V_avisforte := 'N°Avis FORte=' || V_avisforte;
				end if;
				EXCEPTION WHEN OTHERS THEN
				V_avisforte := null;
				END;
				V_mrd_comment:=trim(V_message_temporaire)|| V_avisforte;
				if  to_number(releve_.annee)=0 then
				V_mrd_year:=to_char(sysdate,'yyyy');
				else
				V_mrd_year:=to_number(releve_.annee);
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
								
						INSERT INTO tecmtrread(mrd_id,equ_id,mtc_id,mrd_dt,spt_id,vow_comm1,vow_comm2,vow_comm3,vow_readcode,vow_readorig ,
								   vow_readmeth,vow_readreason,mrd_comment,mrd_locked,mrd_msgbill,mrd_agrtype,mrd_techtype,
								   mrd_subread,mrd_deduction_id,mrd_etatfact,AGE_ID,MRD_USECR,mrd_year,mrd_multicad) 
						VALUES(V_mrd_id,x.equ_id,x.mtc_id,V_mrd_dt,x.spt_id,V_vow_comm1,V_vow_comm2,V_vow_comm3,V_vow_readcode,V_vow_readorig  ,
							   V_vow_readmeth,V_vow_readreason,V_mrd_comment,V_mrd_locked,null,V_mrd_agrtype,V_mrd_techtype,V_mrd_subread,
							   null,V_mrd_etatfact,V_AGE_ID,V_MRD_USECR,V_mrd_year,V_mrd_multicad);	
				-----------------------------------------------------------------------
			    --------------------Création des indexs cadran 1-----------------------
			    -----------------------------------------------------------------------
				INSERT INTO tecmtrmeasure(MME_ID,MRD_ID,MEU_ID,MME_NUM,MME_VALUE,MME_CONSUM,MME_AVGCONSUM,MME_DEDUCEMANUAL)
								   VALUES(V_MME_ID,V_MRD_ID,V_MEU_ID,1,to_number(releve_.releve),nvl(to_number(trim(releve_.consommation)),0),0,V_MME_DEDUCEMANUAL);
										
			    -----------------------------------------------------------------------
			    --------------------Création des indexs cadran 2-----------------------
			    -----------------------------------------------------------------------
				select seq_tecmtrmeasure.nextval into V_MME_ID from dual;
				INSERT INTO tecmtrmeasure(MME_ID,MRD_ID,MEU_ID,MME_NUM,MME_VALUE,MME_CONSUM,MME_AVGCONSUM,MME_DEDUCEMANUAL)
								VALUES(V_MME_ID,V_MRD_ID,V_MEU_ID,2, to_number(replace(releve_.releve2,'.',null)),to_number(replace(releve_.releve2,'.',null)),0,V_MME_DEDUCEMANUAL) ;
				-----------------------------------------------------------------------
				--------------------Création des indexs cadran 3-----------------------
				-----------------------------------------------------------------------
				select seq_tecmtrmeasure.nextval into V_MME_ID from dual;
				INSERT INTO tecmtrmeasure(MME_ID,MRD_ID,MEU_ID,MME_NUM,MME_VALUE,MME_CONSUM,MME_AVGCONSUM,MME_DEDUCEMANUAL)
								VALUES(V_MME_ID,V_MRD_ID,V_MEU_ID,3,to_number(replace(releve_.releve3,'.',null)),to_number(replace(releve_.releve3,'.',null)),0,V_MME_DEDUCEMANUAL) ;
				-----------------------------------------------------------------------
				--------------------Création des indexs cadran 4-----------------------
				-----------------------------------------------------------------------
				select seq_tecmtrmeasure.nextval into V_MME_ID from dual;
				INSERT INTO tecmtrmeasure(MME_ID,MRD_ID,MEU_ID,MME_NUM,MME_VALUE,MME_CONSUM,MME_AVGCONSUM,MME_DEDUCEMANUAL)
								VALUES(V_MME_ID,V_MRD_ID,V_MEU_ID,4,to_number(replace(releve_.releve4,'.',null)),to_number(replace(releve_.releve4,'.',null)),0,V_MME_DEDUCEMANUAL);
				-----------------------------------------------------------------------
				--------------------Création des indexs cadran 5-----------------------
				-----------------------------------------------------------------------
				select seq_tecmtrmeasure.nextval into V_MME_ID from dual;
				INSERT INTO tecmtrmeasure(MME_ID,MRD_ID,MEU_ID,MME_NUM,MME_VALUE,MME_CONSUM,MME_AVGCONSUM,MME_DEDUCEMANUAL)
								   VALUES(V_MME_ID,V_MRD_ID,V_MEU_ID,5,to_number(replace(releve_.releve5,'.',null)),to_number(replace(releve_.releve5,'.',null)),0,V_MME_DEDUCEMANUAL) ;
			    -----------------------------------------------------------------------
			    --------------------Création des indexs cadran 6-----------------------
			    -----------------------------------------------------------------------
				select seq_tecmtrmeasure.nextval into V_MME_ID from dual;
				INSERT INTO tecmtrmeasure(MME_ID,MRD_ID,MEU_ID,MME_NUM,MME_VALUE,MME_CONSUM,MME_AVGCONSUM,MME_DEDUCEMANUAL)
								VALUES(V_MME_ID,V_MRD_ID,V_MEU_ID,6,nvl(to_number(decode(trim(releve_.compteurt),'T','1','1','1','0')),0),nvl(to_number(decode(trim(releve_.compteurt),'T','1','1','1','0')),0),0,V_MME_DEDUCEMANUAL) ;
			    COMMIT;
		    END LOOP;	
		END LOOP;
	END LOOP;
	
	
	FOR releve_ in releve_gc LOOP
		V_RL_BR_NUM        :=null;
		V_CODE_ANOMALIE    :=null;
		V_TYPE_ANOMALIE    :=null;
		V_DESIG_ANOM       :=null;
		V_TYPE_ANOM        :=null;
		V_CODE_SI_ANOMALIE :=null;
		V_mrd_comment      :=null;
		V_mrd_dt		   :=null;
		V_mrd_year         :=null;
		V_mrd_multicad     :=null;
		V_MME_DEDUCEMANUAL :=null;
		V_mrd_agrtype      :=0;
		V_mrd_locked       :=0;
		V_mrd_techtype     :=0;
		V_mrd_subread      :=0;
		V_mrd_etatfact     :=0;
		V_age_id           :=1;
		V_MRD_USECR        :=1;
	    FOR x in branch_(lpad(releve_.district,2,'0'),lpad(trim(releve_.tourne),3,'0'),lpad(trim(releve_.ordre),3,'0'))LOOP
			select seq_tecmtrread.nextval into V_mrd_id from dual;
		    select seq_tecmtrmeasure.nextval into V_MME_ID from dual;
			V_RL_BR_NUM:=lpad(releve_.district,2,'0')||lpad(trim(releve_.tourne),3,'0')|| lpad(trim(releve_.ordre),3,'0')||lpad(to_char(trim(releve_.police)),5,'0');
				
			if trim(releve_.nindex) is null then
				FOR com_L in (select a.code_anomalie,a.type_anomalie
									 from listeanomalies_releve a
									 where trim(a.DISTRICT) = trim(releve_.dist)
									and lpad(trim(a.TOURNE),3,'0')= lpad(trim(releve_.tou),3,'0')
									and lpad(trim(a.ORDRE),3,'0')= lpad(trim(releve_.ord),3,'0')
									and a.ANNEE ='20'|| trim(releve_.refc02)
									and a.TRIM =releve_.refc01)LOOP
					V_CODE_SI_ANOMALIE := trim(com_L.code_anomalie);
					V_TYPE_ANOMALIE    := trim(com_L.type_anomalie);
				end LOOP ;
			
			end if;
			SELECT vow.vow_id
			INTO   V_vow_comm1
			FROM   genvoc     voc,
				   genvocword vow
			WHERE  voc.voc_id   = vow.voc_id
			AND    vow.vow_code = V_CODE_ANOMALIE
			AND    voc.voc_code = 'VOW_COMM1';
			
			SELECT vow.vow_id
			INTO   V_VOW_READREASON
			FROM   genvoc     voc,
				   genvocword vow
			WHERE  voc.voc_id   = vow.voc_id
			AND    vow.vow_code = '1'
			AND    voc.voc_code ='VOW_READREASON';
				
			if (to_number(releve_.Refc01)='12') then
			V_mrd_dt:='08/'||'01/'||'20'||to_char(to_number(trim(releve_.refc02))+1);
			else
			V_mrd_dt:='08/'||lpad(releve_.refc01+1,2,'0')||'/20'||trim(releve_.refc02);
			end if ;
			V_mrd_year:=to_number('20'||trim(releve_.refc02));
			V_mrd_multicad:=to_number(releve_.refc01);
			V_MME_DEDUCEMANUAL:=nvl(to_number(trim(releve_.prorata)),0)*-1;
	 
			FOR x in C_ID(V_RL_BR_NUM)LOOP			   
								
					INSERT INTO tecmtrread(mrd_id,equ_id,mtc_id,mrd_dt,spt_id,vow_comm1,vow_comm2,vow_comm3,vow_readcode,vow_readorig ,
								   vow_readmeth,vow_readreason,mrd_comment,mrd_locked,mrd_msgbill,mrd_agrtype,mrd_techtype,
								   mrd_subread,mrd_deduction_id,mrd_etatfact,AGE_ID,MRD_USECR,mrd_year,mrd_multicad) 
						VALUES(V_mrd_id,x.equ_id,x.mtc_id,V_mrd_dt,x.spt_id,V_vow_comm1,V_vow_comm2,V_vow_comm3,V_vow_readcode,V_vow_readorig,
							   V_vow_readmeth,V_vow_readreason,V_mrd_comment,V_mrd_locked,null,V_mrd_agrtype,V_mrd_techtype,V_mrd_subread,
							   null,V_mrd_etatfact,V_AGE_ID,V_MRD_USECR,V_mrd_year,V_mrd_multicad);
				-----------------------------------------------------------------------
			    --------------------Création des indexs cadran 1-----------------------
			    -----------------------------------------------------------------------
					INSERT INTO tecmtrmeasure(MME_ID,MRD_ID,MEU_ID,MME_NUM,MME_VALUE,MME_CONSUM,MME_AVGCONSUM,MME_DEDUCEMANUAL)
								  VALUES	(V_MME_ID,V_MRD_ID,V_MEU_ID,1,to_number(releve_.nindex),nvl(to_number(trim(releve_.cons)),0),0,V_MME_DEDUCEMANUAL);
				COMMIT;
			END LOOP;			
		END LOOP;
	
	END LOOP;
	FOR releve_ in releve_gcT 	LOOP
			V_RL_BR_NUM        :=null;
			V_CODE_ANOMALIE    :=null;
			V_TYPE_ANOMALIE    :=null;
			V_DESIG_ANOM       :=null;
			V_TYPE_ANOM        :=null;
			V_CODE_SI_ANOMALIE :=null;
			V_mrd_comment      :=null;
			V_mrd_dt		   :=null;
			V_mrd_year         :=null;
			V_mrd_multicad     :=null;
			V_MME_DEDUCEMANUAL :=null;
			V_mrd_agrtype      :=0;
			V_mrd_locked       :=0;
			V_mrd_techtype     :=0;
			V_mrd_subread      :=0;
			V_mrd_etatfact     :=0;
			V_age_id           :=1;
			V_MRD_USECR        :=1;
	    FOR x in branch_(lpad(releve_.district,2,'0'),lpad(trim(releve_.tourne),3,'0'),lpad(trim(releve_.ordre),3,'0'))	LOOP
			select seq_tecmtrread.nextval into V_mrd_id from dual;
		    select seq_tecmtrmeasure.nextval into V_MME_ID from dual;
			
			V_RL_BR_NUM:=lpad(releve_.district,2,'0')||lpad(trim(releve_.tourne),3,'0')||lpad(trim(releve_.ordre),3,'0')||lpad(to_char(trim(releve_.police)),5,'0');
				
			if trim(releve_.nindex) is null then
				FOR com_L in (select a.code_anomalie,a.type_anomalie
									 from listeanomalies_releve a
									 where trim(a.DISTRICT) = trim(releve_.dist)
									and lpad(trim(a.TOURNE),3,'0')= lpad(trim(releve_.tou),3,'0')
									and lpad(trim(a.ORDRE),3,'0')= lpad(trim(releve_.ord),3,'0')
									and a.ANNEE = '20' || trim(releve_.refc02)
									and a.TRIM = releve_.refc01
									)LOOP
					V_CODE_SI_ANOMALIE := trim(com_L.code_anomalie);
					V_TYPE_ANOMALIE := trim(com_L.type_anomalie);
				end LOOP ;
			 
			end if;
			SELECT vow.vow_id
			INTO   V_vow_comm1
			FROM   genvoc     voc,
				   genvocword vow
			WHERE  voc.voc_id   = vow.voc_id
			AND    vow.vow_code = V_CODE_ANOMALIE
			AND    voc.voc_code = 'VOW_COMM1';
			
			SELECT vow.vow_id
			INTO   V_VOW_READREASON
			FROM   genvoc     voc,
				   genvocword vow
			WHERE  voc.voc_id   = vow.voc_id
			AND    vow.vow_code = 'TOURNEE'
			AND    voc.voc_code ='VOW_READREASON';
			
			SELECT vow.vow_id
			INTO   V_VOW_READCODE
			FROM   genvoc     voc,
				   genvocword vow
			WHERE  voc.voc_id   = vow.voc_id
			AND    vow.vow_code = V_CODE_SI_ANOMALIE
			AND    voc.voc_code ='VOW_READCODE';
				 
			V_mrd_dt:=trim(releve_.date_releve);
			if to_number(trim(releve_.annee))='0' then
				V_mrd_year:=to_char(sysdate,'yyyy');
			else
				V_mrd_year:=to_number(trim(releve_.annee));
			end if;
			V_mrd_multicad:=to_number(releve_.mois);
				
			V_MME_DEDUCEMANUAL := 0;
			if to_number(releve_.prorata) > 0 then
			V_MME_DEDUCEMANUAL := nvl(to_number(trim(releve_.consommation)), 0)-releve_.prorata;
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
								
					INSERT INTO tecmtrread(mrd_id,equ_id,mtc_id,mrd_dt,spt_id,vow_comm1,vow_comm2,vow_comm3,vow_readcode,vow_readorig ,
								   vow_readmeth,vow_readreason,mrd_comment,mrd_locked,mrd_msgbill,mrd_agrtype,mrd_techtype,
								   mrd_subread,mrd_deduction_id,mrd_etatfact,AGE_ID,MRD_USECR,mrd_year,mrd_multicad) 
									VALUES (V_mrd_id,x.equ_id,x.mtc_id,V_mrd_d,x.spt_id,V_vow_comm1,V_vow_comm2,V_vow_comm3,V_vow_readcode,V_vow_readorig  ,
											V_vow_readmeth,V_vow_readreason,V_mrd_comment,V_mrd_locked,null,V_mrd_agrtype,V_mrd_techtype,V_mrd_subread   ,
											null,V_mrd_etatfact,V_AGE_ID,V_MRD_USECR,V_mrd_year,V_mrd_multicad);
				-----------------------------------------------------------------------
			    --------------------Création des indexs cadran 1-----------------------
			    -----------------------------------------------------------------------
				    INSERT INTO tecmtrmeasure(MME_ID,MRD_ID,MEU_ID,MME_NUM,MME_VALUE,MME_CONSUM,MME_AVGCONSUM,MME_DEDUCEMANUAL)
								  VALUES(V_MME_ID,V_MRD_ID,V_MEU_ID,1,to_number(releve_.indexr),nvl(to_number(trim(releve_.consommation)),0),0,V_MME_DEDUCEMANUAL);
					
				COMMIT;
				END LOOP;	
			
		END LOOP;
	
	END LOOP;
-----------------------------UPDATE TECMTRREAD(mrd_previous_id)-----------------------------------------------------
    FOR r in spt_c LOOP
		FOR s in c_TECMTRREAD(r.spt_refe) LOOP
		  UPDATE TECMTRREAD t 
		  set t.mrd_previous_id=s.mrd_id
		  where t.mrd_id=(select mrd_id from TECMTRREAD 
						  where MRD_DT>s.MRD_DT  
						  and spt_id= (select y.spt_id
									   from tecservicepoint y 
									   where y.spt_refe=r.spt_refe)
						  and rownum=1)
		  and  t.spt_id= (select y.spt_id from tecservicepoint y where y.spt_refe=r.spt_refe);
		END LOOP;
    END LOOP;
  COMMIT;
-----------------------------INSERTION AGRAVGCONSUM----------------------------------------------------- 
delete from AGRAVGCONSUM;
COMMIT;
FOR s in avg_con LOOP
	select seq_AGRAVGCONSUM.nextval into V_aac_id from dual;
	INSERT INTO AGRAVGCONSUM(aac_id,sag_id,meu_id,aac_avgconsummrd,aac_avgconsumimp,aac_enddt,aac_credt,aac_updtdt,aac_updtby)
					VALUES(V_aac_id,s.sag_id,5,s.mme_consum,null,null,null,null,null);
	COMMIT;
END LOOP;
COMMIT;
END;
/