declare 

    cursor releh_pose is 
						  select 
								 e.equ_id,
								 e.spt_id,
								 e.heq_startdt,
								 e.heq_enddt,
								 t.mtc_id
						   from techequipment e ,tecmeter t
						   where e.equ_id=t.equ_id
						   and vow_reaspose='P';
				   
    cursor releh_Depose is 
						select 
						e.equ_id,
						e.spt_id,
						e.heq_startdt,
						e.heq_enddt,
						t.mtc_id
						from techequipment e ,tecmeter t
						where e.equ_id=t.equ_id
						and vow_reasdepose='D';	
						
cursor branch_(district_ varchar2, tourne_ varchar2, ordre_ varchar2) is
    select  b.*
    from branchement b
    where  (trim(b.district),2,'0')=district_
	 and lpad(trim(b.tourne),3,'0') = tourne_
     and lpad(trim(b.ordre),3,'0') = ordre_;		
	 
	cursor releve is select district ,tourne ,ordre,annee,trim,releve,prorata,constrim4,marche,releve2,releve3,releve4,releve5,date_releve,
                          compteurt,consommation,lpad(ltrim(rtrim(anomalie)),18,0) anomalie,saisie,avisforte,message_temporaire,compteurchange,
                          n_tsp,matricule_releveur,date_controle,matricule_controle,index_controle,nbre_roues,derniere_releve,usage,
                          tarif,diamctr,cctr,codemarque,ncompteur,ancien_releve
                      from fiche_releve a,branchement b
                      where trim(trim) is not null
                      and trim(a.annee)>=2015
                   ------- sans tenir en compte le donner de relevet------
                      and  to_number(trim(a.annee) || trim(a.trim)) <>
                                                (select max(to_number(trim(v.annee) || trim(v.trim)))
                                                 from fiche_releve v
                                                  where trim(v.tourne) = trim(a.tourne)
                                                  and trim(v.ordre) = trim(a.ordre))	;				
    
	cursor relevet is select decode(annee,0,indexa,indexr) index_releve,a.* 
					 from releveT a ,branchement b;
					 
	cursor releve_gc select distinct  a.nindex,
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
					 
	cursor releve_gcT is select a.*
                   from  relevegc a
                   where  trim(a.mois) is not null				 
					 
					 
	v_vow_comm1          number;
	v_vow_comm2          number;
	v_vow_comm3          number;
	v_vow_readmeth       number;
	v_vow_readreason     number;
	v_vow_readcode   	 number;
	v_mrd_id         	 number;
	v_mrd_agrtype        number;
	v_mrd_comment        varchar2(50);
	v_mrd_locked         number:
	v_mrd_techtype       number;
	v_mrd_subread        number;
	v_mrd_etatfact       number;
	v_age_id             number;
	v_MRD_USECR          number;
	v_mrd_multicad       number;
	v_mrd_year           number;
	v_meu_id             number:=5;
	V_RL_BR_NUM          varchar2(50);
	V_RL_LECIMP	         varchar2(50);
	v_avisforte	         varchar2(50);
	v_NTIERS             number;
    v_NSIXIEME           number;
	v_mrd_dt             date;
	V_DTE_RL             varchar2(60);
	v_MME_DEDUCEMANUAL   number;
	v_trim               number;
    v_date_controle      varchar2(30);
    v_index_controle     varchar2(20);
    v_message_temporaire varchar(200);
    v_compteurt          varchar2(5);
    v_releve2            varchar2(10);
    v_releve3            varchar2(10);
    v_releve4            varchar2(10);
    v_releve5            varchar2(10);
    v_anomalie           varchar2(30);
    v_MATRICULE_RELEVEUR varchar2(100);
	
	V_CODE_ANOMALIE varchar2(20);
    V_TYPE_ANOMALIE varchar2(10);
    V_DESIG_ANOM    varchar2(200);
    V_TYPE_ANOM     varchar2(10);
    V_CODE_SI_ANOMALIE varchar2(20);
	
	
begin 	
	SELECT vow.vow_id
	INTO   v_vow_comm1
	FROM   genvoc     voc,
		   genvocword vow
	WHERE  voc.voc_id   = vow.voc_id
	AND    vow.vow_code = '00'
	AND    voc.voc_code = 'VOW_COMM1';
			
	SELECT vow.vow_id
	INTO   v_vow_readorig
	FROM   genvoc     voc,
		   genvocword vow
	WHERE  voc.voc_id   = vow.voc_id
	AND    vow.vow_code = '03'
	AND    voc.voc_code = 'VOW_READORIG';

	SELECT vow.vow_id
	INTO   v_VOW_READMETH
	FROM   genvoc     voc,
		   genvocword vow
	WHERE  voc.voc_id   = vow.voc_id
	AND    vow.vow_code = 'Inconn'
	AND    voc.voc_code ='VOW_READMETH';
	
	v_vow_comm2      := Null;
	v_vow_comm3      := Null;
	v_vow_readreason :=null;
	v_vow_readcode   :=null;
	v_mrd_comment    :='0';
	v_mrd_agrtype    :=0;
	v_mrd_locked     :=0;
	v_mrd_techtype   :=1;
	v_mrd_subread    :=0;
	v_mrd_etatfact   :=0;
	v_age_id         :=1;
	v_MRD_USECR      :=1;

		--------------------------------------------------------------------
		-----------------------                      -----------------------
		-----------------------    Relève de pose    -----------------------
		-----------------------                      -----------------------
		--------------------------------------------------------------------

		for x in releh_pose
		loop

				 select seq_tecmtrread.nextval into v_mrd_id from dual;
				 select seq_tecmtrmeasure.nextval intov_MME_ID from dual;
					
				 v_mrd_year:=substr(x.heq_startdt,7,4);
				if(substr(releve_.heq_startdt,4,2)in('01','02','03')) then
				v_mrd_multicad:=1;
				elsif (substr(x.heq_startdt,4,2)in('04','05','06')) then
				v_mrd_multicad:=2;
				elsif (substr(x.heq_startdt,4,2)in('07','08','09')) then
				v_mrd_multicad:=3;
				elsif (substr(x.heq_startdt,4,2)in('10','11','12')) then
				v_mrd_multicad:=4;
				end if;
						
				Insert into tecmtrread(
										mrd_id        ,
										equ_id        ,
										mtc_id		  ,
										mrd_dt		  ,
										spt_id        ,
										vow_comm1     ,
										vow_comm2     ,
										vow_comm3     ,
										vow_readcode  ,
										vow_readorig  ,
										vow_readmeth  ,
										vow_readreason,
										mrd_comment   ,
										mrd_locked    ,
										mrd_msgbill   ,
										mrd_agrtype   ,
										mrd_techtype  ,
										mrd_subread   ,
										mrd_deduction_id,
										mrd_etatfact  ,
										AGE_ID        ,
										MRD_USECR     ,
										mrd_year,
										mrd_multicad
										) 
								values
									   (
										v_mrd_id,
										x.equ_id        ,
										x.mtc_id        ,
										x.heq_startdt	      ,
										x.spt_id	      ,
										v_vow_comm1     ,
										v_vow_comm2    ,
										v_vow_comm3     ,
										v_vow_readcode  ,
										v_vow_readorig  ,
										v_vow_readmeth  ,
										v_vow_readreason,
										v_mrd_comment   , 
										v_mrd_locked    ,
										null   ,
										v_mrd_techtype  ,
										v_mrd_subread   ,
										null,
										v_mrd_etatfact  ,
										v_AGE_ID        ,
										v_MRD_USECR     ,
										v_mrd_year      ,
										v_mrd_multicad 
										) ;

				INSERT INTO tecmtrmeasure
									   (
										 MME_ID              	, 
										 MRD_ID              	,
										 MEU_ID              	, 
										 MME_NUM           	    ,
										 MME_VALUE              , 
										 MME_CONSUM             ,
										 MME_AVGCONSUM			,
										 MME_DEDUCEMANUAL 
										)
									   (  
										v_MME_ID      	, 
										v_MRD_ID      	, 
										v_MEU_ID      	, 
										1    			, 
										0 	, 
										0		,
										0				,
										null
									  );
		 COMMIT ;

		end loop;
		
		--------------------------------------------------------------------
		-----------------------                      -----------------------
		-----------------------    Relève de dépose    -----------------------
		-----------------------                      -----------------------
		--------------------------------------------------------------------
		for x in releh_Depose
		loop
		v_mrd_techtype := 2;
		 select seq_tecmtrread.nextval into v_mrd_id from dual;
		 select seq_tecmtrmeasure.nextval into v_MME_ID from dual;
			
		v_mrd_year:=substr(x.heq_enddt,7,4);
		if(substr(releve_.heq_enddt,4,2)in('01','02','03')) then
		v_mrd_multicad:=1;
		elsif (substr(x.heq_enddt,4,2)in('04','05','06')) then
		v_mrd_multicad:=2;
		elsif (substr(x.heq_enddt,4,2)in('07','08','09')) then
		v_mrd_multicad:=3;
		elsif (substr(x.heq_enddt,4,2)in('10','11','12')) then
		v_mrd_multicad:=4;
		end if;
						
				Insert into tecmtrread(
										mrd_id        ,
										equ_id        ,
										mtc_id		  ,
										mrd_dt		  ,
										spt_id        ,
										vow_comm1     ,
										vow_comm2     ,
										vow_comm3     ,
										vow_readcode  ,
										vow_readorig  ,
										vow_readmeth  ,
										vow_readreason,
										mrd_comment   ,
										mrd_locked    ,
										mrd_msgbill   ,
										mrd_agrtype   ,
										mrd_techtype  ,
										mrd_subread   ,
										mrd_deduction_id,
										mrd_etatfact  ,
										AGE_ID        ,
										MRD_USECR     ,
										mrd_year,
										mrd_multicad
										) 
								values
									   (
										v_mrd_id		,
										x.equ_id        ,
										x.mtc_id        ,
										x.heq_enddt		,
										x.spt_id	    ,
										v_vow_comm1     ,
										v_vow_comm2     ,
										v_vow_comm3     ,
										v_vow_readcode  ,
										v_vow_readorig  ,
										v_vow_readmeth  ,
										v_vow_readreason,
										v_mrd_comment   , 
										v_mrd_locked    ,
										null            ,
										v_mrd_techtype  ,
										v_mrd_subread   ,
										null            ,
										v_mrd_etatfact  ,
										v_AGE_ID        ,
										v_MRD_USECR     ,
										v_mrd_year      ,
										v_mrd_multicad 
										) ;

				INSERT INTO tecmtrmeasure
										(
											 MME_ID              	, 
											 MRD_ID              	,
											 MEU_ID              	, 
											 MME_NUM           	    ,
											 MME_VALUE              , 
											 MME_CONSUM             ,
											 MME_AVGCONSUM			,
											 MME_DEDUCEMANUAL 
										)
										(
											v_MME_ID      	        , 
											v_MRD_ID      			, 
											v_MEU_ID      			, 
											1    					, 
											0 						, 
											0						,
											0						,
											null
										) ;
		 COMMIT ;

		end loop;
		
	
	for releve_ in releve 
	loop
			for x in branch_(lpad(releve_.district, 2, '0') ,
							   lpad(trim(releve_.tourne), 3, '0'),
							   lpad(trim(releve_.ordre), 3, '0'))
			loop			   
			v_VOW_READREASON  :=null;
			V_RL_LECIMP       :=null;
			v_mrd_comment     :=null;
			V_DTE_RL          := null;
			v_MME_DEDUCEMANUAL:=null;
			V_RL_BR_NUM       :=null;
			v_mrd_dt          :=null;
			v_NTIERS          :=null;
			v_NSIXIEME        :=null;
	
	        select seq_tecmtrread.nextval into v_mrd_id from dual;
		    select seq_tecmtrmeasure.nextval into v_MME_ID from dual;
	 
			V_RL_BR_NUM := lpad(releve_.district, 2, '0') ||
							   lpad(trim(releve_.tourne), 3, '0') ||
							   lpad(trim(releve_.ordre), 3, '0') ||
							   lpad(to_char(trim(releve_.police)), 5, '0');
					   
					  
	 
	     			
			v_MME_DEDUCEMANUAL:=0;
			if to_number(releve_.prorata)>0 then
			v_MME_DEDUCEMANUAL:=nvl(to_number(trim(releve_.consommation)),0)-releve_.prorata;
			end if;
		
		 
			-------------------recuperation date releve------------------------
			V_DTE_RL:= substr(releve_.date_releve,1,instr(replace(replace(releve_.date_releve,' ','#'),':','#'),'#') - 1);
            V_DTE_RL:= replace(V_DTE_RL, '-', '/');
		BEGIN
			select to_date(lpad(t.datexp,8,'0'),'dd/mm/yyyy')- 7 
			into v_mrd_dt 
			from ROLE_TRIM t
			where lpad(TRIM(t.distr),2,'0') = trim(releve_.district)
			and   TRIM(t.annee) = trim(releve_.annee)
			and   TRIM(t.trim) =trim(releve_.trim)
			and   lpad(TRIM(t.tour),3,'0')= lpad(trim(releve_.tourne),3,'0')
			and   lpad(TRIM(t.ordr),3,'0')= lpad(trim(releve_.ordre),3,'0');
		EXCEPTION WHEN OTHERS THEN
				BEGIN
					select to_date(lpad(t.datexp,8,'0'),'dd/mm/yyyy')- 7 
					into v_mrd_dt 
					from ROLE_MENS t
					where lpad(TRIM(t.distr),2,'0') = trim(releve_.district)
					and   TRIM(t.annee) = trim(releve_.annee)
					and   TRIM(t.mois) =trim(releve_.trim)
					and   lpad(TRIM(t.tour),3,'0')= lpad(trim(releve_.tourne),3,'0')
					and   lpad(TRIM(t.ordr),3,'0')= lpad(trim(releve_.ordre),3,'0');
				EXCEPTION WHEN OTHERS THEN
								if substr(releve_.annee,3,2) != to_char(to_date(substr(releve_.date_releve,1,10),'dd/mm/yyyy hh24:mi:ss'),'YY')
								and releve_.trim in (1,2,3) then
									select t.ntiers, t.NSIXIEME
									into v_NTIERS,v_NSIXIEME
									from tourne t
									where trim(t.code)= releve_.tourne
									and trim(t.district)=releve_.district;
										if v_NSIXIEME=1 THEN
												IF releve_.TRIM=1 THEN
												v_mrd_dt:=to_date('08/0'||to_char(v_NTIERS)||'/'||releve_.annee,'dd/mm/yyyy');
												ELSIF releve_.TRIM = 2 THEN
												v_mrd_dt:=to_date('08/0'||to_char(3+v_NTIERS)||'/'||releve_.annee,'dd/mm/yyyy');
												ELSIF releve_.TRIM = 3 THEN
												v_mrd_dt:=to_date('08/0'||to_char(6+v_NTIERS)||'/'||releve_.annee,'dd/mm/yyyy');
												ELSIF releve_.TRIM = 4 THEN
												v_mrd_dt:=to_date('08/'||to_char(9+v_NTIERS)||'/'||releve_.annee,'dd/mm/yyyy');
										end if;
								else
										IF releve_.TRIM=1 THEN
										  v_mrd_dt:=to_date('15/0'||to_char(v_NTIERS)||'/'||releve_.annee,'dd/mm/yyyy');
										ELSIF releve_.TRIM = 2 THEN
										  v_mrd_dt:=to_date('15/0'||to_char(3+v_NTIERS)||'/'||releve_.annee,'dd/mm/yyyy');
										ELSIF releve_.TRIM = 3 THEN
										  v_mrd_dt:=to_date('15/0'||to_char(6+v_NTIERS)||'/'||releve_.annee,'dd/mm/yyyy');
										ELSIF releve_.TRIM = 4 THEN
										  v_mrd_dt:=to_date('15/'||to_char(9+v_NTIERS)||'/'||releve_.annee,'dd/mm/yyyy');
										end if;
								end if;
					else
							v_mrd_dt := to_date(V_DTE_RL, 'dd/mm/yy');
					end if;
				END;
		    END;
         -----------------------------------	
            if trim(releve_.DATE_CONTROLE) is null 
			and (trim(releve_.INDEX_CONTROLE) is null or trim(releve_.INDEX_CONTROLE)=0) then
			    V_RL_LECIMP:='TOURNEE';
			ELSE
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
			INTO   v_vow_comm2
			FROM   genvoc     voc,
				   genvocword vow
			WHERE  voc.voc_id   = vow.voc_id
			AND    vow.vow_code =  substr(releve_.anomalie,13,2)
			AND    voc.voc_code = 'VOW_COMM2';
										
			SELECT vow.vow_id
			INTO   v_vow_comm3
			FROM   genvoc     voc,
				   genvocword vow
			WHERE  voc.voc_id   = vow.voc_id
			AND    vow.vow_code =substr(releve_.anomalie,1, 2)
			AND    voc.voc_code = 'VOW_COMM3';
			
			
			begin
			if to_number(trim(releve_.avisforte))>0 then
			v_avisforte:='N°Avis Forte='||releve_.avisforte;
			end if;
			exception when others then
			v_avisforte:=null;
			end  ;
			
			v_mrd_comment:=trim(releve_.message_temporaire)||v_avisforte
			v_mrd_techtype:=1;
			v_mrd_multicad:=to_number(releve_.trim);
			begin
            select age_id 
			into v_AGE_ID
			from genagent g
			where g.age_refe=trim(releve_.matricule_releveur);
			exception when others then
			v_AGE_ID=1;
			end;
			v_mrd_year:=to_number(releve_.annee);
			
				for x in (select 
						e.equ_id,e.spt_id,t.mtc_id  
						from techequipment e ,tecmeter t,tecservicepoint spt
						where e.equ_id=t.equ_id	
						and e.spt_id=spt.spt_id
						and spt.spt_refe = V_RL_BR_NUM)
						loop
						
					   
							   Insert into tecmtrread(
										mrd_id        ,
										equ_id        ,
										mtc_id		  ,
										mrd_dt		  ,
										spt_id        ,
										vow_comm1     ,
										vow_comm2     ,
										vow_comm3     ,
										vow_readcode  ,
										vow_readorig  ,
										vow_readmeth  ,
										vow_readreason,
										mrd_comment   ,
										mrd_locked    ,
										mrd_msgbill   ,
										mrd_agrtype   ,
										mrd_techtype  ,
										mrd_subread   ,
										mrd_deduction_id,
										mrd_etatfact  ,
										AGE_ID        ,
										MRD_USECR     ,
										mrd_year      ,
										mrd_multicad
										) 
								values(
										v_mrd_id        ,
										x.equ_id    	,
										x.mtc_id    	,
										v_mrd_dt	    ,
										x.spt_id	    ,
										v_vow_comm1	    ,
										v_vow_comm2 	,
										v_vow_comm3     ,
										v_vow_readcode  ,
										v_vow_readorig  ,
										v_vow_readmeth  ,
										v_vow_readreason,
										v_mrd_comment   ,  
										v_mrd_locked    ,
										null   			,
										v_mrd_agrtype   ,
										v_mrd_techtype  ,
										v_mrd_subread   ,
										null,
										v_mrd_etatfact  ,
										v_AGE_ID        ,
										v_MRD_USECR     ,
										v_mrd_year      ,
										v_mrd_multicad 
										);
				-----------------------------------------------------------------------
				--------------------Création des indexs cadran 1-----------------------
				-----------------------------------------------------------------------
				INSERT INTO tecmtrmeasure
										(
											 MME_ID              	, 
											 MRD_ID              	,
											 MEU_ID              	, 
											 MME_NUM           	    ,
											 MME_VALUE              , 
											 MME_CONSUM             ,
											 MME_AVGCONSUM			,
											 MME_DEDUCEMANUAL 
										)
										(
											v_MME_ID      	, 
											v_MRD_ID      	, 
											v_MEU_ID      	, 
											1    	        , 
											to_number(releve_.index_releve),
											nvl(to_number(trim(releve_.consommation)), 0) ,
											0				,
											v_MME_DEDUCEMANUAL
										) ;
										
				-----------------------------------------------------------------------
				--------------------Création des indexs cadran 2-----------------------
				-----------------------------------------------------------------------
				select seq_tecmtrmeasure.nextval into v_MME_ID from dual;
				INSERT INTO tecmtrmeasure
										(
											 MME_ID              	, 
											 MRD_ID              	,
											 MEU_ID              	, 
											 MME_NUM           	    ,
											 MME_VALUE              , 
											 MME_CONSUM             ,
											 MME_AVGCONSUM			,
											 MME_DEDUCEMANUAL 
										)
										(
											v_MME_ID      	, 
											v_MRD_ID      	, 
											v_MEU_ID      	, 
											2    	        , 
											to_number(replace(v_releve2, '.', null)),
											to_number(replace(v_releve2, '.', null)) ,
											0				,
											v_MME_DEDUCEMANUAL
										) ;
				-----------------------------------------------------------------------
				--------------------Création des indexs cadran 3-----------------------
				-----------------------------------------------------------------------
				select seq_tecmtrmeasure.nextval into v_MME_ID from dual;
				INSERT INTO tecmtrmeasure
										(
											 MME_ID              	, 
											 MRD_ID              	,
											 MEU_ID              	, 
											 MME_NUM           	    ,
											 MME_VALUE              , 
											 MME_CONSUM             ,
											 MME_AVGCONSUM			,
											 MME_DEDUCEMANUAL 
										)
										(
											v_MME_ID      	, 
											v_MRD_ID      	, 
											v_MEU_ID      	, 
											3    	        , 
											to_number(replace(v_releve3, '.', null)),
											to_number(replace(v_releve3, '.', null)),
											0				,
											v_MME_DEDUCEMANUAL
										) ;
				-----------------------------------------------------------------------
				--------------------Création des indexs cadran 4-----------------------
				-----------------------------------------------------------------------
				select seq_tecmtrmeasure.nextval into v_MME_ID from dual;
				INSERT INTO tecmtrmeasure
										(
											 MME_ID              	, 
											 MRD_ID              	,
											 MEU_ID              	, 
											 MME_NUM           	    ,
											 MME_VALUE              , 
											 MME_CONSUM             ,
											 MME_AVGCONSUM			,
											 MME_DEDUCEMANUAL 
										)
										(
											v_MME_ID      	, 
											v_MRD_ID      	, 
											v_MEU_ID      	, 
											4    	        , 
											to_number(replace(v_releve4, '.', null)),
											to_number(replace(v_releve4, '.', null)),
											0				,
											v_MME_DEDUCEMANUAL
										) ;
			    -----------------------------------------------------------------------
			    --------------------Création des indexs cadran 5-----------------------
			    -----------------------------------------------------------------------
			    select seq_tecmtrmeasure.nextval into v_MME_ID from dual;
				INSERT INTO tecmtrmeasure
										(
											 MME_ID              	, 
											 MRD_ID              	,
											 MEU_ID              	, 
											 MME_NUM           	    ,
											 MME_VALUE              , 
											 MME_CONSUM             ,
											 MME_AVGCONSUM			,
											 MME_DEDUCEMANUAL 
										)
										(
											v_MME_ID      	, 
											v_MRD_ID      	, 
											v_MEU_ID      	, 
											5    	        , 
											to_number(replace(v_releve5, '.', null)),
											to_number(replace(v_releve5, '.', null)),
											0				,
											v_MME_DEDUCEMANUAL
										) ;
				-----------------------------------------------------------------------
				--------------------Création des indexs cadran 6-----------------------
				-----------------------------------------------------------------------
				select seq_tecmtrmeasure.nextval into v_MME_ID from dual;
				INSERT INTO tecmtrmeasure
										(
											 MME_ID              	, 
											 MRD_ID              	,
											 MEU_ID              	, 
											 MME_NUM           	    ,
											 MME_VALUE              , 
											 MME_CONSUM             ,
											 MME_AVGCONSUM			,
											 MME_DEDUCEMANUAL 
										)
										(
											v_MME_ID      	, 
											v_MRD_ID      	, 
											v_MEU_ID      	, 
											6    	        , 
0											nvl(to_number(decode(trim(v_compteurt),'T','1','1','1','0')),0) ,
											nvl(to_number(decode(trim(v_compteurt),'T','1','1','1','0')),0) ,
											0				,
											v_MME_DEDUCEMANUAL
										) ;
										
			    Commit;		
	
	
				end loop;
	    end loop;
	end loop;
	
	for releve_ in relevet
    loop
	       for x in branch_(lpad(releve_.district, 2, '0') ,
							   lpad(trim(releve_.tourne), 3, '0'),
							   lpad(trim(releve_.ordre), 3, '0'))
			loop
	
			v_VOW_READREASON  :=null;
			V_RL_LECIMP       :=null;
			v_mrd_comment     :=null;
			V_DTE_RL          :=null;
			v_MME_DEDUCEMANUAL:=null;
			V_RL_BR_NUM       :=null;
			v_mrd_dt          :=null;
			v_NTIERS          :=null;
			v_NSIXIEME        :=null;
			v_trim 			  := null;
			v_date_controle   := null;
			v_index_controle  := null;
			v_avisforte       := null;
			v_message_temporaire := null;
			v_compteurt       := null;
			v_releve2         := null;
			v_releve3         := null;
			v_releve4         := null;
			v_releve5         := null;
			v_anomalie        := null;
			v_MATRICULE_RELEVEUR := null;
			v_mrd_agrtype 	  :=0;
			v_mrd_techtype    :=0;
			v_vow_readcode    :=null;
			v_mrd_locked      :=0;
			
					select seq_tecmtrread.nextval into v_mrd_id from dual;
					select seq_tecmtrmeasure.nextval into v_MME_ID from dual;
			 
					V_RL_BR_NUM := lpad(releve_.district, 2, '0') ||
									   lpad(trim(releve_.tourne), 3, '0') ||
									   lpad(trim(releve_.ordre), 3, '0') ||
									   lpad(to_char(trim(releve_.police)), 5, '0');
									   
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
														 
				
										 
				V_DTE_RL:= substr(releve_.date_releve,1,instr(replace(replace(releve_.date_releve,' ','#'),':','#'),'#') - 1);
				V_DTE_RL     := replace(V_DTE_RL, '-', '/');
				V_mrd_dt := to_date(V_DTE_RL,'dd/mm/yy');
		 
			  ------------------------------------------------------
			BEGIN
				select to_date(lpad(trim(t.datexp),8,'0'), 'dd/mm/yyyy') - 7
				  into v_mrd_dt
				  from ROLE_TRIM t
				 where lpad(TRIM(t.distr),2,'0')= trim(releve_.district)
				   and TRIM(t.annee)= trim(releve_.annee)
				   and TRIM(t.trim)= trim(v_trim)
				   and lpad(TRIM(t.tour),3,'0') =lpad(trim(releve_.tourne),3,'0')
				   and lpad(TRIM(t.ordr),3,'0') =lpad(trim(releve_.ordre),3,'0');
			EXCEPTION WHEN OTHERS THEN
				BEGIN
					    select to_date(lpad(trim(t.datexp),8,'0'),'dd/mm/yyyy') - 7
						into v_mrd_dt
						from ROLE_MENS t
					    where lpad(TRIM(t.distr),2,'0') = trim(releve_.district)
						and TRIM(t.annee) = trim(releve_.annee)
						and TRIM(t.mois) = trim(v_trim)
						and lpad(TRIM(t.tour),3,'0') =lpad(trim(releve_.tourne),3,'0')
						and lpad(TRIM(t.ordr),3,'0') =lpad(trim(releve_.ordre),3,'0');
						
				EXCEPTION WHEN OTHERS THEN
					    if substr(releve_.annee,3,2) !=to_char(to_date(substr(releve_.date_releve,1,10),'dd/mm/yyyy hh24:mi:ss'),'YY') and v_trim in (1, 2, 3) then
					   
							select t.ntiers, t.NSIXIEME
							into v_NTIERS, v_NSIXIEME
							from tourne t
							where trim(t.code) = trim(releve_.tourne)
							and  trim(t.district) = trim(releve_.district);
						 
							if v_NSIXIEME = 1 THEN
								IF v_trim = 1 THEN
								  v_mrd_dt := to_date('08/0' || to_char(v_NTIERS) || '/' ||releve_.annee,'dd/mm/yyyy');
								ELSIF v_trim = 2 THEN
								  v_mrd_dt := to_date('08/0' || to_char(3 + v_NTIERS) || '/' ||releve_.annee,'dd/mm/yyyy');
								ELSIF v_trim = 3 THEN
								  v_mrd_dt := to_date('08/0' || to_char(6 + v_NTIERS) || '/' ||releve_.annee,'dd/mm/yyyy');
								ELSIF v_trim = 4 THEN
								  v_mrd_dt := to_date('08/' || to_char(9 + v_NTIERS) || '/' ||releve_.annee,'dd/mm/yyyy');
								end if;
						    else
								IF v_trim = 1 THEN
								  v_mrd_dt := to_date('15/0' || to_char(v_NTIERS) || '/' ||releve_.annee,'dd/mm/yyyy');
								ELSIF v_trim = 2 THEN
								v_mrd_dt := to_date('15/0' || to_char(3 + v_NTIERS) || '/' ||releve_.annee,'dd/mm/yyyy');
								ELSIF v_trim = 3 THEN
								v_mrd_dt := to_date('15/0' || to_char(6 + v_NTIERS) || '/' ||releve_.annee,'dd/mm/yyyy');
								ELSIF v_trim = 4 THEN
								v_mrd_dt := to_date('15/' || to_char(9 + v_NTIERS) || '/' ||releve_.annee,'dd/mm/yyyy');
								end if;
							end if;
					    end if;
			    END;
			END;

							if trim(v_date_controle) is null and
							(trim(v_index_controle) is null or trim(v_index_controle) = 0) then
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
							INTO   v_vow_comm2
							FROM   genvoc     voc,
								   genvocword vow
							WHERE  voc.voc_id   = vow.voc_id
							AND    vow.vow_code =  substr(v_anomalie, 13, 2)
							AND    voc.voc_code = 'VOW_COMM2';
														
							SELECT vow.vow_id
							INTO   v_vow_comm3
							FROM   genvoc     voc,
								   genvocword vow
							WHERE  voc.voc_id   = vow.voc_id
							AND    vow.vow_code =substr(v_anomalie, 1, 2)
							AND    voc.voc_code = 'VOW_COMM3';
							
							v_MME_DEDUCEMANUAL := 0;
							if to_number(releve_.prorata) > 0 then
							v_MME_DEDUCEMANUAL := nvl(to_number(trim(releve_.consommation)), 0) - releve_.prorata;
							end if;
							
							v_mrd_multicad:=v_trim;
							
							begin
							if to_number(trim(v_avisforte)) > 0 then
							v_avisforte := 'N°Avis Forte=' || v_avisforte;
							end if;
							exception when others then
							v_avisforte := null;
							end;
							v_mrd_comment:=trim(v_message_temporaire)|| v_avisforte;

							if  to_number(releve_.annee)=0 then
							v_mrd_year:=to_char(sysdate,'yyyy');
							else
							v_mrd_year:=to_number(releve_.annee);
							end if;
			
							begin
								select age_id 
								into v_AGE_ID
								from genagent g
								where g.age_refe=v_MATRICULE_RELEVEUR;
							exception when others then
								v_AGE_ID=1;
							end;

							for x in (select 
											e.equ_id,e.spt_id,t.mtc_id  
											from techequipment e ,tecmeter t,tecservicepoint spt
											where e.equ_id=t.equ_id	
											and e.spt_id=spt.spt_id
											and spt.spt_refe = V_RL_BR_NUM)
											loop			   
								
								Insert into tecmtrread(
													mrd_id        ,
													equ_id        ,
													mtc_id		  ,
													mrd_dt		  ,
													spt_id        ,
													vow_comm1     ,
													vow_comm2     ,
													vow_comm3     ,
													vow_readcode  ,
													vow_readorig  ,
													vow_readmeth  ,
													vow_readreason,
													mrd_comment   ,
													mrd_locked    ,
													mrd_msgbill   ,
													mrd_agrtype   ,
													mrd_techtype  ,
													mrd_subread   ,
													mrd_deduction_id,
													mrd_etatfact  ,
													AGE_ID        ,
													MRD_USECR     ,
													mrd_year      ,
													mrd_multicad
													) 
											values(
													v_mrd_id        ,
													x.equ_id    	,
													x.mtc_id    	,
													v_mrd_dt	    ,
													x.spt_id	    ,
													v_vow_comm1	    ,
													v_vow_comm2 	,
													v_vow_comm3     ,
													v_vow_readcode  ,
													v_vow_readorig  ,
													v_vow_readmeth  ,
													v_vow_readreason,
													v_mrd_comment   ,  
													v_mrd_locked    ,
													null   			,
													v_mrd_agrtype   ,
													v_mrd_techtype  ,
													v_mrd_subread   ,
													null,
													v_mrd_etatfact  ,
													v_AGE_ID        ,
													v_MRD_USECR     ,
													v_mrd_year      ,
													v_mrd_multicad
												);	
				-----------------------------------------------------------------------
			    --------------------Création des indexs cadran 1-----------------------
			    -----------------------------------------------------------------------
				INSERT INTO tecmtrmeasure
										(
											 MME_ID              	, 
											 MRD_ID              	,
											 MEU_ID              	, 
											 MME_NUM           	    ,
											 MME_VALUE              , 
											 MME_CONSUM             ,
											 MME_AVGCONSUM			,
											 MME_DEDUCEMANUAL 
										)
										(
											v_MME_ID      	, 
											v_MRD_ID      	, 
											v_MEU_ID      	, 
											1    	        , 
											to_number(releve_.releve),
											nvl(to_number(trim(releve_.consommation)),0) ,
											0				,
											v_MME_DEDUCEMANUAL
										) ;
										
			    -----------------------------------------------------------------------
			    --------------------Création des indexs cadran 2-----------------------
			    -----------------------------------------------------------------------
				select seq_tecmtrmeasure.nextval into v_MME_ID from dual;
				INSERT INTO tecmtrmeasure
										(
											 MME_ID              	, 
											 MRD_ID              	,
											 MEU_ID              	, 
											 MME_NUM           	    ,
											 MME_VALUE              , 
											 MME_CONSUM             ,
											 MME_AVGCONSUM			,
											 MME_DEDUCEMANUAL 
										)
										(
											v_MME_ID      	, 
											v_MRD_ID      	, 
											v_MEU_ID      	, 
											2    	        , 
											to_number(replace(releve_.releve2,'.',null)),
											to_number(replace(releve_.releve2,'.',null)) ,
											0				,
											v_MME_DEDUCEMANUAL
										) ;
				-----------------------------------------------------------------------
				--------------------Création des indexs cadran 3-----------------------
				-----------------------------------------------------------------------
				select seq_tecmtrmeasure.nextval into v_MME_ID from dual;
				INSERT INTO tecmtrmeasure
										(
											 MME_ID              	, 
											 MRD_ID              	,
											 MEU_ID              	, 
											 MME_NUM           	    ,
											 MME_VALUE              , 
											 MME_CONSUM             ,
											 MME_AVGCONSUM			,
											 MME_DEDUCEMANUAL 
										)
										(
											v_MME_ID      	, 
											v_MRD_ID      	, 
											v_MEU_ID      	, 
											3    	        , 
											to_number(replace(releve_.releve3,'.',null)),
											to_number(replace(releve_.releve3,'.',null)) ,
											0				,
											v_MME_DEDUCEMANUAL
										) ;
				-----------------------------------------------------------------------
				--------------------Création des indexs cadran 4-----------------------
				-----------------------------------------------------------------------
				select seq_tecmtrmeasure.nextval into v_MME_ID from dual;
				INSERT INTO tecmtrmeasure
										(
											 MME_ID              	, 
											 MRD_ID              	,
											 MEU_ID              	, 
											 MME_NUM           	    ,
											 MME_VALUE              , 
											 MME_CONSUM             ,
											 MME_AVGCONSUM			,
											 MME_DEDUCEMANUAL 
										)
										(
											v_MME_ID      	, 
											v_MRD_ID      	, 
											v_MEU_ID      	, 
											4    	        , 
											to_number(replace(releve_.releve4,'.',null)),
											to_number(replace(releve_.releve4,'.',null)) ,
											0				,
											v_MME_DEDUCEMANUAL
										) ;
				-----------------------------------------------------------------------
				--------------------Création des indexs cadran 5-----------------------
				-----------------------------------------------------------------------
				select seq_tecmtrmeasure.nextval into v_MME_ID from dual;
				INSERT INTO tecmtrmeasure
										(
											 MME_ID              	, 
											 MRD_ID              	,
											 MEU_ID              	, 
											 MME_NUM           	    ,
											 MME_VALUE              , 
											 MME_CONSUM             ,
											 MME_AVGCONSUM			,
											 MME_DEDUCEMANUAL 
										)
										(
											v_MME_ID      	, 
											v_MRD_ID      	, 
											v_MEU_ID      	, 
											5    	        , 
											to_number(replace(releve_.releve5,'.',null)),
											to_number(replace(releve_.releve5,'.',null)) ,
											0				,
											v_MME_DEDUCEMANUAL
										) ;
			    -----------------------------------------------------------------------
			    --------------------Création des indexs cadran 6-----------------------
			    -----------------------------------------------------------------------
				select seq_tecmtrmeasure.nextval into v_MME_ID from dual;
				INSERT INTO tecmtrmeasure
										(
											 MME_ID              	, 
											 MRD_ID              	,
											 MEU_ID              	, 
											 MME_NUM           	    ,
											 MME_VALUE              , 
											 MME_CONSUM             ,
											 MME_AVGCONSUM			,
											 MME_DEDUCEMANUAL 
										)
										(
											v_MME_ID      	, 
											v_MRD_ID      	, 
											v_MEU_ID      	, 
											6    	        , 
0											nvl(to_number(decode(trim(releve_.compteurt),'T','1','1','1','0')),0),
											nvl(to_number(decode(trim(releve_.compteurt),'T','1','1','1','0')),0) ,
											0				,
											v_MME_DEDUCEMANUAL
										) ;
			
					commit;
					end loop;	
					end loop;
	end loop;
	
	
	for releve_ in releve_gc 
	loop
	V_RL_BR_NUM        :=null;
	V_CODE_ANOMALIE    :=null;
    V_TYPE_ANOMALIE    :=null;
    V_DESIG_ANOM       :=null;
    V_TYPE_ANOM        :=null;
    V_CODE_SI_ANOMALIE :=null;
	v_mrd_comment      :=null;
	v_mrd_dt		   :=null;
	v_mrd_year         :=null;
	v_mrd_multicad     :=null;
	v_MME_DEDUCEMANUAL :=null;
	v_mrd_agrtype      :=0;
	v_mrd_locked       :=0;
	v_mrd_techtype     :=0;
	v_mrd_subread      :=0;
	v_mrd_etatfact     :=0;
	v_age_id           :=1;
	v_MRD_USECR        :=1;
	   for x in branch_(lpad(releve_.district,2,'0'),lpad(trim(releve_.tourne),3,'0'),lpad(trim(releve_.ordre),3,'0'))
		loop
			select seq_tecmtrread.nextval into v_mrd_id from dual;
		    select seq_tecmtrmeasure.nextval into v_MME_ID from dual;
			
				V_RL_BR_NUM :=lpad(releve_.district,2,'0')||lpad(trim(releve_.tourne),3,'0')||
							  lpad(trim(releve_.ordre),3,'0')||lpad(to_char(trim(releve_.police)),5,'0');
				
				if trim(releve_.nindex) is null then
					for com_lectimp_ in (select *
										 from listeanomalies_releve a
										 where trim(a.DISTRICT) = trim(releve_.dist)
										and lpad(trim(a.TOURNE),3,'0')= lpad(trim(releve_.tou),3,'0')
										and lpad(trim(a.ORDRE),3,'0')= lpad(trim(releve_.ord),3,'0')
										and a.ANNEE = '20' || trim(releve_.refc02)
										and a.TRIM = releve_.refc01
										)
					loop
						V_CODE_SI_ANOMALIE := ltrim(rtrim(com_lectimp_.code_anomalie));
						V_TYPE_ANOMALIE := ltrim(rtrim(com_lectimp_.type_anomalie));
					end loop ;
				else
					for com_lectimp_ in (select *
										from listeanomalies_releve a
										where trim(a.DISTRICT) = trim(releve_.dist)
										and lpad(trim(a.TOURNE),3,'0') =lpad(trim(releve_.tou),3,'0')
										and lpad(trim(a.ORDRE),3,'0') = lpad(trim(releve_.ord),3,'0')
										and a.ANNEE = '20'||trim(releve_.refc02)
										and a.TRIM = releve_.refc01
										)
					loop
					    V_CODE_ANOMALIE := trim(com_lectimp_.code_anomalie);
					    V_TYPE_ANOMALIE := trim(com_lectimp_.type_anomalie);
					end loop;

				end if;
				SELECT vow.vow_id
				INTO   v_vow_comm1
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
				v_mrd_dt:='08/'||'01/'||'20'||to_char(to_number(trim(releve_.refc02))+1);
				else
				v_mrd_dt:='08/'||lpad(releve_.refc01+1,2,'0')||'/20'||trim(releve_.refc02);
				end if ;
				v_mrd_year:=to_number('20'||trim(releve_.refc02));
                v_mrd_multicad:=to_number(releve_.refc01);
				v_MME_DEDUCEMANUAL:=nvl(to_number(trim(releve_.prorata)),0)*-1;
	 
			    for x in (select e.equ_id,e.spt_id,t.mtc_id  
						  from techequipment e ,tecmeter t,tecservicepoint spt
						  where e.equ_id=t.equ_id	
						  and e.spt_id=spt.spt_id
						 and spt.spt_refe = V_RL_BR_NUM)
				loop			   
								
					Insert into tecmtrread (
                            					mrd_id        ,
												equ_id        ,
												mtc_id		  ,
												mrd_dt		  ,
												spt_id        ,
												vow_comm1     ,
												vow_comm2     ,
												vow_comm3     ,
												vow_readcode  ,
												vow_readorig  ,
												vow_readmeth  ,
												vow_readreason,
												mrd_comment   ,
												mrd_locked    ,
												mrd_msgbill   ,
												mrd_agrtype   ,
												mrd_techtype  ,
												mrd_subread   ,
												mrd_deduction_id,
												mrd_etatfact  ,
												AGE_ID        ,
												MRD_USECR     ,
												mrd_year      ,
												mrd_multicad
										    ) 
									values (
												v_mrd_id        ,
												x.equ_id    	,
												x.mtc_id    	,
												v_mrd_dt	    ,
												x.spt_id	    ,
												v_vow_comm1	    ,
												v_vow_comm2 	,
												v_vow_comm3     ,
												v_vow_readcode  ,
												v_vow_readorig  ,
												v_vow_readmeth  ,
												v_vow_readreason,
												v_mrd_comment   ,  
												v_mrd_locked    ,
												null   			,
												v_mrd_agrtype   ,
												v_mrd_techtype  ,
												v_mrd_subread   ,
												null,
												v_mrd_etatfact  ,
												v_AGE_ID        ,
												v_MRD_USECR     ,
												v_mrd_year      ,
												v_mrd_multicad 
											);
				-----------------------------------------------------------------------
			    --------------------Création des indexs cadran 1-----------------------
			    -----------------------------------------------------------------------
				INSERT INTO tecmtrmeasure
										(
											 MME_ID              	, 
											 MRD_ID              	,
											 MEU_ID              	, 
											 MME_NUM           	    ,
											 MME_VALUE              , 
											 MME_CONSUM             ,
											 MME_AVGCONSUM			,
											 MME_DEDUCEMANUAL 
										)
										(
											v_MME_ID      	, 
											v_MRD_ID      	, 
											v_MEU_ID      	, 
											1    	        , 
											to_number(releve_.nindex),
											nvl(to_number(trim(releve_.cons)),0) ,
											0				,
											v_MME_DEDUCEMANUAL
										) ;
					
				commit;
				end loop;	
			
		end loop;
	
	end loop;
	for releve_ in releve_gcT 
	loop
	V_RL_BR_NUM        :=null;
	V_CODE_ANOMALIE    :=null;
    V_TYPE_ANOMALIE    :=null;
    V_DESIG_ANOM       :=null;
    V_TYPE_ANOM        :=null;
    V_CODE_SI_ANOMALIE :=null;
	v_mrd_comment      :=null;
	v_mrd_dt		   :=null;
	v_mrd_year         :=null;
	v_mrd_multicad     :=null;
	v_MME_DEDUCEMANUAL :=null;
	v_mrd_agrtype      :=0;
	v_mrd_locked       :=0;
	v_mrd_techtype     :=0;
	v_mrd_subread      :=0;
	v_mrd_etatfact     :=0;
	v_age_id           :=1;
	v_MRD_USECR        :=1;
	   for x in branch_(lpad(releve_.district,2,'0'),lpad(trim(releve_.tourne),3,'0'),lpad(trim(releve_.ordre),3,'0'))
		loop
			select seq_tecmtrread.nextval into v_mrd_id from dual;
		    select seq_tecmtrmeasure.nextval into v_MME_ID from dual;
			
				V_RL_BR_NUM :=lpad(releve_.district,2,'0')||lpad(trim(releve_.tourne),3,'0')||
							  lpad(trim(releve_.ordre),3,'0')||lpad(to_char(trim(releve_.police)),5,'0');
				
				if trim(releve_.nindex) is null then
					for com_lectimp_ in (select *
										 from listeanomalies_releve a
										 where trim(a.DISTRICT) = trim(releve_.dist)
										and lpad(trim(a.TOURNE),3,'0')= lpad(trim(releve_.tou),3,'0')
										and lpad(trim(a.ORDRE),3,'0')= lpad(trim(releve_.ord),3,'0')
										and a.ANNEE = '20' || trim(releve_.refc02)
										and a.TRIM = releve_.refc01
										)
					loop
						V_CODE_SI_ANOMALIE := ltrim(rtrim(com_lectimp_.code_anomalie));
						V_TYPE_ANOMALIE := ltrim(rtrim(com_lectimp_.type_anomalie));
					end loop ;
				else
					for com_lectimp_ in (select *
										from listeanomalies_releve a
										where trim(a.DISTRICT) = trim(releve_.dist)
										and lpad(trim(a.TOURNE),3,'0') =lpad(trim(releve_.tou),3,'0')
										and lpad(trim(a.ORDRE),3,'0') = lpad(trim(releve_.ord),3,'0')
										and a.ANNEE = '20'||trim(releve_.refc02)
										and a.TRIM = releve_.refc01
										)
					loop
					    V_CODE_ANOMALIE := trim(com_lectimp_.code_anomalie);
					    V_TYPE_ANOMALIE := trim(com_lectimp_.type_anomalie);
					end loop;

				end if;
				SELECT vow.vow_id
				INTO   v_vow_comm1
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
				 
				v_mrd_dt:=trim(releve_.date_releve);
				if to_number(trim(releve_.annee))='0' then
				v_mrd_year:=to_char(sysdate,'yyyy');
				else
				v_mrd_year:=to_number(trim(releve_.annee));
				end if;
                v_mrd_multicad:=to_number(releve_.mois);
				
				v_MME_DEDUCEMANUAL := 0;
				if to_number(releve_.prorata) > 0 then
				v_MME_DEDUCEMANUAL := nvl(to_number(trim(releve_.consommation)), 0)-releve_.prorata;
				end if; 
				begin
					select age_id 
					into v_AGE_ID
					from genagent g
					where g.age_refe=trim(releve_.etat);
				exception when others then
					v_AGE_ID=1;
				end;

			    for x in (select e.equ_id,e.spt_id,t.mtc_id  
						  from techequipment e ,tecmeter t,tecservicepoint spt
						  where e.equ_id=t.equ_id	
						  and e.spt_id=spt.spt_id
						 and spt.spt_refe = V_RL_BR_NUM)
				loop			   
								
					Insert into tecmtrread (
                            					mrd_id        ,
												equ_id        ,
												mtc_id		  ,
												mrd_dt		  ,
												spt_id        ,
												vow_comm1     ,
												vow_comm2     ,
												vow_comm3     ,
												vow_readcode  ,
												vow_readorig  ,
												vow_readmeth  ,
												vow_readreason,
												mrd_comment   ,
												mrd_locked    ,
												mrd_msgbill   ,
												mrd_agrtype   ,
												mrd_techtype  ,
												mrd_subread   ,
												mrd_deduction_id,
												mrd_etatfact  ,
												AGE_ID        ,
												MRD_USECR     ,
												mrd_year      ,
												mrd_multicad
										    ) 
									values (
												v_mrd_id        ,
												x.equ_id    	,
												x.mtc_id    	,
												v_mrd_dt	    ,
												x.spt_id	    ,
												v_vow_comm1	    ,
												v_vow_comm2 	,
												v_vow_comm3     ,
												v_vow_readcode  ,
												v_vow_readorig  ,
												v_vow_readmeth  ,
												v_vow_readreason,
												v_mrd_comment   ,  
												v_mrd_locked    ,
												null   			,
												v_mrd_agrtype   ,
												v_mrd_techtype  ,
												v_mrd_subread   ,
												null,
												v_mrd_etatfact  ,
												v_AGE_ID        ,
												v_MRD_USECR     ,
												v_mrd_year      ,
												v_mrd_multicad 
											);
				-----------------------------------------------------------------------
			    --------------------Création des indexs cadran 1-----------------------
			    -----------------------------------------------------------------------
				INSERT INTO tecmtrmeasure
										(
											 MME_ID              	, 
											 MRD_ID              	,
											 MEU_ID              	, 
											 MME_NUM           	    ,
											 MME_VALUE              , 
											 MME_CONSUM             ,
											 MME_AVGCONSUM			,
											 MME_DEDUCEMANUAL 
										)
										(
											v_MME_ID      	, 
											v_MRD_ID      	, 
											v_MEU_ID      	, 
											1    	        , 
											to_number(releve_.indexr),
											nvl(to_number(trim(releve_.consommation)),0) ,
											0				,
											v_MME_DEDUCEMANUAL
										) ;
					
				commit;
				end loop;	
			
		end loop;
	
	end loop;
END;
/

DECLARE
cursor e is select t.spt_refe from tecservicepoint t;
CURSOR C(v_spt_refe varchar2) IS select t.*, t.rowid from TECMTRREAD t 
WHERE t.spt_id= (select y.spt_id from tecservicepoint y where y.spt_refe=v_spt_refe) ORDER BY MRD_DT ;
BEGIN
  for r in e loop
  for s in c(r.spt_refe) loop
  UPDATE TECMTRREAD t 
  set t.mrd_previous_id=s.mrd_id
  where t.mrd_id=(select mrd_id from TECMTRREAD where MRD_DT>s.MRD_DT  
                  and spt_id= (select y.spt_id from tecservicepoint y where y.spt_refe=r.spt_refe)
				  and rownum=1)
  and  t.spt_id= (select y.spt_id from tecservicepoint y where y.spt_refe=r.spt_refe);
  end loop;
  end loop;
  END;
/
declare
cursor c is select avg(m.mme_consum) mme_consum,a.sag_id,a.spt_id 
from TECMTRREAD t,AGRSERVICEAGR a,tecmtrmeasure m
where t.mrd_id=m.mrd_id
and a.spt_id=t.spt_id
group by a.sag_id,a.spt_id;
v_aac_id number;
begin
delete from AGRAVGCONSUM;
commit;
for s in c loop
select seq_AGRAVGCONSUM.nextval into v_aac_id from dual;
--v_aac_id:=v_aac_id+1;
		insert into AGRAVGCONSUM
					(
					  aac_id          ,--1 NUMBER(10) not null,
					  sag_id		  ,--2 NUMBER(10) not null,
					  meu_id		  ,--3 NUMBER(10) not null,
					  aac_avgconsummrd,--4 NUMBER(17,10),
					  aac_avgconsumimp,--5 NUMBER(17,10),
					  aac_enddt       ,--6 DATE,
					  aac_credt       ,--7 DATE default sysdate,
					  aac_updtdt      ,--8 DATE,
					  aac_updtby	   --9 NUMBER(10)
					 )
					values 
					(
					  v_aac_id    ,--1 NUMBER(10) not null,
					  s.sag_id    ,--2 NUMBER(10) not null,
					  5			  ,--3 NUMBER(10) not null,
					  s.mme_consum,--4 NUMBER(17,10),
					  null		  ,--5 NUMBER(17,10),
					  null        ,--6 DATE,
					  null        ,--7 DATE default sysdate,
					  null        ,--8 DATE,
					  null         --9 NUMBER(10)
					);
commit;
end loop;
commit;
end;
/