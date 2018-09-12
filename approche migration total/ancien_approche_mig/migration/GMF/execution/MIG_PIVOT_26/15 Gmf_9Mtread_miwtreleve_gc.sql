spo Gmf_9Mtrread.lst;
SELECT to_char(sysdate, 'DD/MM/YY HH24:MI') heure FROM dual;

prompt *******************************************************************
prompt **** MIGRATION  / Affecter le equ_id à la relève  *****************
prompt *******************************************************************
update  mig_pivot_26.miwtreleve_gc set  mrel_cadran1 ='EAU' where mrel_cadran1 is null ;
update  mig_pivot_26.miwtreleve_gc set  VOC_COMM1 ='0' where VOC_COMM1 is null ;
update  mig_pivot_26.miwtreleve_gc set  VOC_READMETH ='Inconn' where VOC_READMETH is null ;
update  mig_pivot_26.miwtreleve_gc set  MREL_SUBREAD =0 where MREL_SUBREAD is null ;

ANALYZE TABLE  mig_pivot_26.miwtreleve_gc COMPUTE STATISTICS;
UPDATE  mig_pivot_26.miwtreleve_gc m
SET    equ_id =
           (
               SELECT equ_id 
               FROM    mig_pivot_26.miwtcompteur c 
               WHERE  MREL_REFCOM = MCOM_REF
            )
WHERE equ_id is null;

COMMIT;
prompt *******************************************************************
prompt **** MIGRATION  / Affecter le spt_id à la relève  *****************
prompt *******************************************************************


UPDATE  mig_pivot_26.miwtreleve_gc m
SET    spt_id =
           (
               SELECT spt_id 
               FROM   tecservicepoint c 
               WHERE   spt_refe = m.mrel_refpdl
            )
WHERE spt_id is null;



	update  mig_pivot_26.miwtreleve_gc 
	 set MREL_AGESOURCE = MREL_SOURCE,
	     MREL_AGEREF ='INCONNUE' 
	 where  MREL_AGEREF is null;

UPDATE  mig_pivot_26.miwtreleve_gc m
SET    AGE_ID =
           (
               SELECT AGE_ID 
               FROM   genagent c 
               WHERE   c.age_refe    = MREL_AGEREF
			   --and    AGE_SOURCE  =MREL_AGESOURCE  
            )
WHERE AGE_ID is null;

PROMPT *******************************************************
PROMPT *** MIGRATION  / Création  mig_pivot_26.miwtreleve_gc ****************
PROMPT *******************************************************
SET serveroutput on;
Declare 
Cursor Releve  is select
					mrel_source        ,
					mrel_ref           ,
					mrel_refpdl        ,
					mrel_refcom        ,
					mrel_date          ,
					--mrel_index         ,
					--mrel_conso         ,
					mrel_deduite       ,
					mrel_facturee      ,
					--mrel_refvoccomm1   varchar2(100)         ,
					-- mrel_refvoccomm2   varchar2(100)         ,
					VOC_COMM1          ,
					VOC_COMM2          ,
					VOC_COMM3          ,
					voc_READORIG       ,
					VOC_READCODE       ,
					VOC_READMETH       ,
					VOC_READREASON     ,
					mrel_AGRTYPE       ,
					mrel_TECHTYPE      ,
					mrel_ETATFACT      ,
					mrel_comlibre      ,
					spt_id             ,
					equ_id             ,
					AGE_ID             ,
					mtc_id             ,
					MREL_SUBREAD       ,
					periode            ,
					nvl(annee,to_char(mrel_date,'yyyy')) annee,
					mrel_ano_c1        ,
					mrel_ano_f1        ,
					mrel_ano_n1
			from    mig_pivot_26.miwtreleve_gc
			where  mrd_id is null
			and EQU_ID is not null
			and spt_id is not null;
 
		New_Rel		  tecmtrread%rowtype;
		Rel_Id           Number ;
		ref_Rel          Number ;
		v_VOW_COMM1      varchar2(2);
		v_VOW_COMM2      varchar2(2);
		v_VOW_READCODE   varchar2(2);
		
 begin
--select nvl(max(mrd_id),0)+1 into Rel_Id      from tecmtrread;


For Rel in Releve loop

select seq_tecmtrread.nextval into Rel_Id from dual;

New_Rel:= null;
--------------------------------------------------------Voc ne pas traiter 
--select distinct t.mrel_ano_n1 into v_VOW_COMM1 from  mig_pivot_26.miwtreleve_gc t
--where Rel.mrel_ano_n1 in (select vow_code from GENVOCWORD i where i.voc_id in (select voc_id from genvoc where voc_code in ('VOW_COMM1')));
--if v_VOW_COMM1!= null then
		PK_Util_Vocabulaire.Genere_voc( New_Rel.vow_comm1,'VOW_COMM1',  '00') ;-----anomalie Niche
		PK_Util_Vocabulaire.Genere_voc( New_Rel.vow_comm2,  'VOW_COMM2',    Rel.mrel_ano_f1) ;-----anomalie Fuite
		PK_Util_Vocabulaire.Genere_voc( New_Rel.vow_comm3,  'VOW_COMM3',    Rel.mrel_ano_c1) ;-----anomalie compteur


--PK_Util_Vocabulaire.Genere_voc( New_Rel.vow_readcode,'VOW_READCODE',Rel.mrel_ano_c1) ;-----anomalie compteur	
	
		
			
		
		PK_Util_Vocabulaire.Genere_voc( New_Rel.vow_readorig,'VOW_READORIG', Rel .voc_READORIG) ;
		PK_Util_Vocabulaire.Genere_voc( New_Rel.vow_readmeth,'VOW_READMETH', Rel .VOC_READMETH) ;
		PK_Util_Vocabulaire.Genere_voc( New_Rel.vow_readreason,'VOW_READREASON', Rel .VOC_READREASON) ;

		--------------------------------------------------------Traitement tecequipment 	
        New_Rel.mrd_id        :=  Rel_Id ;		
		New_Rel.equ_id        :=  Rel.equ_id ;
		New_Rel.mtc_id        :=  Rel.mtc_id;
		New_Rel.mrd_dt        :=  Rel.mrel_date ;
		New_Rel.spt_id        :=  Rel.spt_id ;
		New_Rel.mrd_comment   :=  Rel.mrel_comlibre ;
		New_Rel.mrd_locked    :=  0;
		--New_Rel.mrd_msgbill   :=  Rel.mcom_reel ;
		New_Rel.mrd_agrtype   :=  Rel.mrel_agrtype ;
		New_Rel.mrd_techtype  :=  Rel.mrel_techtype ;
		New_Rel.mrd_subread   :=  Rel.MREL_SUBREAD;
		--New_Rel.mrd_deduction_id     :=  Equi.mcom_reel ;
		New_Rel.mrd_etatfact  :=  Rel.mrel_etatfact ;
		New_Rel.AGE_ID        :=  Rel.AGE_ID ;
		New_Rel.MRD_USECR     :=  1 ;
		New_Rel.mrd_year      :=  Rel.annee ;
		New_Rel.mrd_multicad  := Rel.periode ;
		New_Rel.mtc_id        := 1; --Configuration compteur par défaut;
		
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
							    mrd_year,mrd_multicad
								) 
						values
						       (
						        New_Rel.mrd_id    ,
								New_Rel.equ_id    ,
								New_Rel.mtc_id    ,
								New_Rel.mrd_dt	  ,
								New_Rel.spt_id	  ,
								New_Rel.vow_comm1 ,
							    New_Rel.vow_comm2 ,
								New_Rel.vow_comm3 ,
								New_Rel.vow_readcode,
								New_Rel.vow_readorig,
								New_Rel.vow_readmeth,
							    New_Rel.vow_readreason,
								New_Rel.mrd_comment, 
								New_Rel.mrd_locked ,
								New_Rel.mrd_msgbill,
								New_Rel.mrd_agrtype,
							    New_Rel.mrd_techtype,
								New_Rel.mrd_subread ,
								New_Rel.mrd_deduction_id,
								New_Rel.mrd_etatfact,
								New_Rel.AGE_ID      ,
							    New_Rel.MRD_USECR   ,
								New_Rel.mrd_year    ,
								New_Rel.mrd_multicad 
								) ;
		update 	  mig_pivot_26.miwtreleve_gc 
		set mrd_id = Rel_Id 
		where MREL_REF = Rel.MREL_REF ;						 
							 
		--Rel_Id :=Rel_Id+1 ;		
  Commit;      
end loop ;
--exception  when others then dbms_output.put_line('************************************'||Ref_Agr);

end ;
/

--alter table  mig_pivot_26.miwtreleve_gc add MEU_ID number;
UPDATE  mig_pivot_26.miwtreleve_gc SET MEU_ID     = null WHERE  MEU_ID    is not null;
UPDATE  mig_pivot_26.miwtreleve_gc SET MEU_ID2    = null WHERE  MEU_ID2    is not null;
UPDATE  mig_pivot_26.miwtreleve_gc SET MEU_ID3    = null WHERE  MEU_ID3    is not null;
UPDATE  mig_pivot_26.miwtreleve_gc SET MEU_ID4    = null WHERE  MEU_ID4    is not null;
UPDATE  mig_pivot_26.miwtreleve_gc SET MEU_ID5    = null WHERE  MEU_ID5    is not null;
UPDATE  mig_pivot_26.miwtreleve_gc SET MEU_ID6    = null WHERE  MEU_ID6    is not null;
--UPDATE  mig_pivot_26.miwtreleve_gc SET MEU_ID7    = null WHERE  MEU_ID7    is not null;
--UPDATE  mig_pivot_26.miwtreleve_gc SET MEU_ID8    = null WHERE  MEU_ID8    is not null;
--UPDATE  mig_pivot_26.miwtreleve_gc SET MEU_ID9    = null WHERE  MEU_ID9    is not null;
--UPDATE  mig_pivot_26.miwtreleve_gc SET MEU_ID10   = null WHERE  MEU_ID10    is not null;

--alter table  mig_pivot_26.miwtreleve_gc add MME_ID number;
UPDATE  mig_pivot_26.miwtreleve_gc SET MME_ID     = null WHERE  MME_ID    is not null;
UPDATE  mig_pivot_26.miwtreleve_gc SET MME_ID2    = null WHERE  MME_ID2    is not null;
UPDATE  mig_pivot_26.miwtreleve_gc SET MME_ID3    = null WHERE  MME_ID3    is not null;
UPDATE  mig_pivot_26.miwtreleve_gc SET MME_ID4    = null WHERE  MME_ID4    is not null;
UPDATE  mig_pivot_26.miwtreleve_gc SET MME_ID5    = null WHERE  MME_ID5    is not null;
UPDATE  mig_pivot_26.miwtreleve_gc SET MME_ID6    = null WHERE  MME_ID6    is not null;
--UPDATE  mig_pivot_26.miwtreleve_gc SET MME_ID7    = null WHERE  MME_ID7    is not null;
--UPDATE  mig_pivot_26.miwtreleve_gc SET MME_ID8    = null WHERE  MME_ID8    is not null;
--UPDATE  mig_pivot_26.miwtreleve_gc SET MME_ID9    = null WHERE  MME_ID9    is not null;
--UPDATE  mig_pivot_26.miwtreleve_gc SET MME_ID10   = null WHERE  MME_ID10    is not null;
prompt **********************************************************
prompt **** MIGRATION  / Création des indexs cadran 1   *********
prompt **********************************************************

DECLARE
v_min integer;
v_max integer;
v_depart integer;
v_pas  integer;
BEGIN
select min(mrd_id) into v_min from  mig_pivot_26.miwtreleve_gc ;
select max(mrd_id) into v_max from  mig_pivot_26.miwtreleve_gc;
v_pas := round((v_max-v_min+1)/10) + 1;
v_depart := v_min;
while v_depart <= v_max
loop
		update  /*+rule*/  mig_pivot_26.miwtreleve_gc r
		set    meu_id =  ---- Type Cadran 
		(
		select t.meu_id
		from   tecmeasureunit t
		where  1 = 1
		and    r.mrel_cadran1 =  t.meu_code
		)
		where   meu_id is  null
		and   	mrd_id >= v_depart
		and   	mrd_id <  v_depart + v_pas;
		v_depart := v_depart + v_pas ;
		commit;
end loop ;
END;
/



DECLARE
v_max_id integer;
v_max_mig integer;
BEGIN
select nvl(max(MME_ID),0) into v_max_mig from tecmtrmeasure ;
-- index 1
update  mig_pivot_26.miwtreleve_gc
set    MME_ID = v_max_mig + rownum
where  MREL_INDEX1 is not null ;

end ;
/

DECLARE
v_min integer;
v_max integer;
v_depart integer;
v_pas  integer;
BEGIN
select min(MME_ID) into v_min from  mig_pivot_26.miwtreleve_gc ;
select max(MME_ID) into v_max from  mig_pivot_26.miwtreleve_gc ;
v_pas := round((v_max-v_min+1)/10) + 1;
v_depart := v_min;
while v_depart <= v_max
loop
 INSERT 
 INTO tecmtrmeasure
 (
	 MME_ID              	, -- number(10) not null 
	 MRD_ID              	, -- number(10) not null 
	 MEU_ID              	, -- number(10) not null 
	 MME_NUM           	    , -- number(10) not null 
	 MME_VALUE              , -- number(2) not null 
	 MME_CONSUM             ,
	 MME_AVGCONSUM			,
	 MME_DEDUCEMANUAL 
 )
 (
	SELECT  /*+RULE*/
									MME_ID      	, --  INDEX 
									MRD_ID      	, --  RELEVE
									MEU_ID      	, --  TYPE CADRAN
									1    			, --  IDX_INDEX     NUMBER(10) NOT NULL
									MREL_INDEX1     ,    	  --  IDX_NUMCADRAN NUMBER(2) NOT NULL
									MREL_CONSO1		,
									0				,
									MREL_DEDUITE
	FROM      mig_pivot_26.miwtreleve_gc R
	WHERE   MME_ID   IS NOT NULL
	AND     MRD_ID IS NOT  NULL
	AND    MEU_ID  IS  NOT NULL
	AND     MME_ID >= V_DEPART
	AND     MME_ID < V_DEPART + V_PAS 
	AND not EXISTS	(SELECT 1 FROM tecmtrmeasure M WHERE R.MRD_ID = M.MRD_ID));
 COMMIT ;
	v_depart := v_depart + v_pas ;
end loop;

END;
/
prompt **********************************************************
prompt **** MIGRATION  / Création des indexs cadran 2   *********
prompt **********************************************************

DECLARE
v_min integer;
v_max integer;
v_depart integer;
v_pas  integer;
BEGIN
select min(mrd_id) into v_min from  mig_pivot_26.miwtreleve_gc ;
select max(mrd_id) into v_max from  mig_pivot_26.miwtreleve_gc;
v_pas := round((v_max-v_min+1)/10) + 1;
v_depart := v_min;
while v_depart <= v_max
loop
		update  /*+rule*/  mig_pivot_26.miwtreleve_gc r
		set    meu_id2 =  ---- Type Cadran 
		(
		select t.meu_id
		from   tecmeasureunit t
		where  1 = 1
		and    r.mrel_cadran2 =  t.meu_code
		)
		where   meu_id2 is  null
		and   	mrd_id >= v_depart
		and   	mrd_id <  v_depart + v_pas;
		v_depart := v_depart + v_pas ;
		commit;
end loop ;
END;
/

DECLARE
v_max_id integer;
v_max_mig integer;
BEGIN
select nvl(max(MME_ID),0) into v_max_mig from tecmtrmeasure ;
-- index 1
update  mig_pivot_26.miwtreleve_gc
set    MME_ID2 = v_max_mig + rownum
where  MREL_INDEX2 !=0 ;
end ;
/

DECLARE
v_min integer;
v_max integer;
v_depart integer;
v_pas  integer;
BEGIN
select min(MME_ID2) into v_min from  mig_pivot_26.miwtreleve_gc ;
select max(MME_ID2) into v_max from  mig_pivot_26.miwtreleve_gc ;
v_pas := round((v_max-v_min+1)/10) + 1;
v_depart := v_min;
while v_depart <= v_max
loop
 INSERT 
 INTO tecmtrmeasure
 (
	 MME_ID              	, -- number(10) not null 
	 MRD_ID              	, -- number(10) not null 
	 MEU_ID              	, -- number(10) not null 
	 MME_NUM           	    , -- number(10) not null 
	 MME_VALUE              , -- number(2) not null 
	 MME_CONSUM             ,
	 MME_AVGCONSUM			,
	 MME_DEDUCEMANUAL 
 )
 (
	SELECT  /*+RULE*/
									MME_ID2      	, --  INDEX 
									MRD_ID      	, --  RELEVE
									MEU_ID2      	, --  TYPE CADRAN
									2    			, --  IDX_INDEX     NUMBER(10) NOT NULL
									MREL_INDEX2     , --  IDX_NUMCADRAN NUMBER(2) NOT NULL
									MREL_INDEX2     ,
									0               ,
									MREL_DEDUITE
	FROM      mig_pivot_26.miwtreleve_gc R
	WHERE   MME_ID2   IS NOT NULL
	AND     MRD_ID IS NOT  NULL
	AND    MEU_ID2  IS  NOT NULL
	AND     MME_ID2 >= V_DEPART
	AND     MME_ID2 < V_DEPART + V_PAS 
	AND not EXISTS	(SELECT 1 FROM tecmtrmeasure M WHERE R.MRD_ID = M.MRD_ID));
 COMMIT ;
	v_depart := v_depart + v_pas ;
end loop;

END;
/
prompt **********************************************************
prompt **** MIGRATION  / Création des indexs cadran 3   *********
prompt **********************************************************

DECLARE
v_min integer;
v_max integer;
v_depart integer;
v_pas  integer;
BEGIN
select min(mrd_id) into v_min from  mig_pivot_26.miwtreleve_gc ;
select max(mrd_id) into v_max from  mig_pivot_26.miwtreleve_gc;
v_pas := round((v_max-v_min+1)/10) + 1;
v_depart := v_min;
while v_depart <= v_max
loop
		update  /*+rule*/  mig_pivot_26.miwtreleve_gc r
		set    meu_id3 =  ---- Type Cadran 
		(
		select t.meu_id
		from   tecmeasureunit t
		where  1 = 1
		and    r.mrel_cadran3 =  t.meu_code
		)
		where   meu_id3 is  null
		and   	mrd_id >= v_depart
		and   	mrd_id <  v_depart + v_pas;
		v_depart := v_depart + v_pas ;
		commit;
end loop ;
END;
/

DECLARE
v_max_id integer;
v_max_mig integer;
BEGIN
select nvl(max(MME_ID),0) into v_max_mig from tecmtrmeasure ;
-- index 3
update  mig_pivot_26.miwtreleve_gc
set    MME_ID3 = v_max_mig + rownum
where  MREL_INDEX3 !=0 ;

end ;
/

DECLARE
v_min integer;
v_max integer;
v_depart integer;
v_pas  integer;
BEGIN
select min(MME_ID3) into v_min from  mig_pivot_26.miwtreleve_gc ;
select max(MME_ID3) into v_max from  mig_pivot_26.miwtreleve_gc ;
v_pas := round((v_max-v_min+1)/10) + 1;
v_depart := v_min;
while v_depart <= v_max
loop
 INSERT 
 INTO tecmtrmeasure
 (
	 MME_ID              	, -- number(10) not null 
	 MRD_ID              	, -- number(10) not null 
	 MEU_ID              	, -- number(10) not null 
	 MME_NUM           	    , -- number(10) not null 
	 MME_VALUE              , -- number(2) not null 
	 MME_CONSUM             ,
	 MME_AVGCONSUM			,
	 MME_DEDUCEMANUAL 
 )
 (
	SELECT  /*+RULE*/
									MME_ID3      	, --  INDEX 
									MRD_ID      	, --  RELEVE
									MEU_ID3      	, --  TYPE CADRAN
									3    			, --  IDX_INDEX     NUMBER(10) NOT NULL
									MREL_INDEX3     , --  IDX_NUMCADRAN NUMBER(2) NOT NULL
									MREL_INDEX3		,
									0				,
									MREL_DEDUITE
	FROM      mig_pivot_26.miwtreleve_gc R
	WHERE   MME_ID3   IS NOT NULL
	AND     MRD_ID IS NOT  NULL
	AND    MEU_ID3  IS  NOT NULL
	AND     MME_ID3 >= V_DEPART
	AND     MME_ID3 < V_DEPART + V_PAS 
	AND not EXISTS	(SELECT 1 FROM tecmtrmeasure M WHERE R.MRD_ID = M.MRD_ID));
	
 COMMIT ;
	v_depart := v_depart + v_pas ;
end loop;

END;
/
prompt **********************************************************
prompt **** MIGRATION  / Création des indexs cadran 4   *********
prompt **********************************************************

DECLARE
v_min integer;
v_max integer;
v_depart integer;
v_pas  integer;
BEGIN
select min(mrd_id) into v_min from  mig_pivot_26.miwtreleve_gc ;
select max(mrd_id) into v_max from  mig_pivot_26.miwtreleve_gc;
v_pas := round((v_max-v_min+1)/10) + 1;
v_depart := v_min;
while v_depart <= v_max
loop
		update  /*+rule*/  mig_pivot_26.miwtreleve_gc r
		set    meu_id4 =  ---- Type Cadran 
		(
		select t.meu_id
		from   tecmeasureunit t
		where  1 = 1
		and    r.mrel_cadran4 =  t.meu_code
		)
		where   meu_id4 is  null
		and   	mrd_id >= v_depart
		and   	mrd_id <  v_depart + v_pas;
		v_depart := v_depart + v_pas ;
		commit;
end loop ;
END;
/


DECLARE
v_max_id integer;
v_max_mig integer;
BEGIN
select nvl(max(MME_ID),0) into v_max_mig from tecmtrmeasure ;
-- index 4
update  mig_pivot_26.miwtreleve_gc
set    MME_ID4 = v_max_mig + rownum
where  MREL_INDEX4 !=0 ;

end ;
/

DECLARE
v_min integer;
v_max integer;
v_depart integer;
v_pas  integer;
BEGIN
select min(MME_ID4) into v_min from  mig_pivot_26.miwtreleve_gc ;
select max(MME_ID4) into v_max from  mig_pivot_26.miwtreleve_gc ;
v_pas := round((v_max-v_min+1)/10) + 1;
v_depart := v_min;
while v_depart <= v_max
loop
 INSERT 
 INTO tecmtrmeasure
 (
	 MME_ID              	, -- number(10) not null 
	 MRD_ID              	, -- number(10) not null 
	 MEU_ID              	, -- number(10) not null 
	 MME_NUM           	    , -- number(10) not null 
	 MME_VALUE              , -- number(2) not null 
	 MME_CONSUM             ,
	 MME_AVGCONSUM          ,
	 MME_DEDUCEMANUAL 
 )
 (
	SELECT  /*+RULE*/
									MME_ID4      	, --  INDEX 
									MRD_ID      	, --  RELEVE
									MEU_ID4      	, --  TYPE CADRAN
									4    			, --  IDX_INDEX     NUMBER(10) NOT NULL
									MREL_INDEX4     , --  IDX_NUMCADRAN NUMBER(2) NOT NULL
									MREL_INDEX4		,
									0				,
									MREL_DEDUITE
	FROM      mig_pivot_26.miwtreleve_gc R
	WHERE   MME_ID4   IS NOT NULL
	AND     MRD_ID IS NOT  NULL
	AND    MEU_ID4  IS  NOT NULL
	AND     MME_ID4 >= V_DEPART
	AND     MME_ID4 < V_DEPART + V_PAS 
	AND not EXISTS	(SELECT 1 FROM tecmtrmeasure M WHERE R.MRD_ID = M.MRD_ID));
 COMMIT ;
	v_depart := v_depart + v_pas ;
end loop;

END;
/
prompt **********************************************************
prompt **** MIGRATION  / Création des indexs cadran 5   *********
prompt **********************************************************

DECLARE
v_min integer;
v_max integer;
v_depart integer;
v_pas  integer;
BEGIN
select min(mrd_id) into v_min from  mig_pivot_26.miwtreleve_gc ;
select max(mrd_id) into v_max from  mig_pivot_26.miwtreleve_gc;
v_pas := round((v_max-v_min+1)/10) + 1;
v_depart := v_min;
while v_depart <= v_max
loop
		update  /*+rule*/  mig_pivot_26.miwtreleve_gc r
		set    meu_id5 =  ---- Type Cadran 
		(
		select t.meu_id
		from   tecmeasureunit t
		where  1 = 1
		and    r.mrel_cadran5 =  t.meu_code
		)
		where   meu_id5 is  null
		and   	mrd_id >= v_depart
		and   	mrd_id <  v_depart + v_pas;
		v_depart := v_depart + v_pas ;
		commit;
end loop ;
END;
/



DECLARE
v_max_id integer;
v_max_mig integer;
BEGIN
select nvl(max(MME_ID),0) into v_max_mig from tecmtrmeasure ;
-- index 5
update  mig_pivot_26.miwtreleve_gc
set    MME_ID5 = v_max_mig + rownum
where  MREL_INDEX5 !=0 ;
end ;
/

DECLARE
v_min integer;
v_max integer;
v_depart integer;
v_pas  integer;
BEGIN
select min(MME_ID5) into v_min from  mig_pivot_26.miwtreleve_gc ;
select max(MME_ID5) into v_max from  mig_pivot_26.miwtreleve_gc ;
v_pas := round((v_max-v_min+1)/10) + 1;
v_depart := v_min;
while v_depart <= v_max
loop
 INSERT 
 INTO tecmtrmeasure
 (
	 MME_ID              	, -- number(10) not null 
	 MRD_ID              	, -- number(10) not null 
	 MEU_ID              	, -- number(10) not null 
	 MME_NUM           	    , -- number(10) not null 
	 MME_VALUE              , -- number(2) not null 
	 MME_CONSUM             ,
	 MME_AVGCONSUM			,
	 MME_DEDUCEMANUAL 
 )
 (
	SELECT  /*+RULE*/
									MME_ID5      	, --  INDEX 
									MRD_ID      	, --  RELEVE
									MEU_ID5      	, --  TYPE CADRAN
									5    			, --  IDX_INDEX     NUMBER(10) NOT NULL
									MREL_INDEX5     ,    	  --  IDX_NUMCADRAN NUMBER(2) NOT NULL
									MREL_INDEX5		,
									0				,
									MREL_DEDUITE
	FROM     mig_pivot_26.miwtreleve_gc R
	WHERE   MME_ID5   IS NOT NULL
	AND     MRD_ID IS NOT  NULL
	AND     MEU_ID5  IS  NOT NULL
	AND     MME_ID5 >= V_DEPART
	AND     MME_ID5 < V_DEPART + V_PAS 
	AND not EXISTS	(SELECT 1 FROM tecmtrmeasure M WHERE R.MRD_ID = M.MRD_ID));
	
 COMMIT;
	v_depart := v_depart + v_pas ;
end loop;

END;
/

prompt **********************************************************
prompt **** MIGRATION  / Création des indexs cadran 6   *********
prompt **********************************************************

DECLARE
v_min integer;
v_max integer;
v_depart integer;
v_pas  integer;
BEGIN
select min(mrd_id) into v_min from  mig_pivot_26.miwtreleve_gc ;
select max(mrd_id) into v_max from  mig_pivot_26.miwtreleve_gc;
v_pas := round((v_max-v_min+1)/10) + 1;
v_depart := v_min;
while v_depart <= v_max
loop
		update  /*+rule*/  mig_pivot_26.miwtreleve_gc r
		set    meu_id6 =  ---- Type Cadran 
		(
		select t.meu_id
		from   tecmeasureunit t
		where  1 = 1
		and    r.mrel_cadran6 =  t.meu_code
		)
		where   meu_id6 is  null
		and   	mrd_id >= v_depart
		and   	mrd_id <  v_depart + v_pas
		;
		v_depart := v_depart + v_pas ;
		commit;
end loop ;
END;
/



DECLARE
v_max_id integer;
v_max_mig integer;
BEGIN
select nvl(max(MME_ID),0) into v_max_mig from tecmtrmeasure ;
-- index 1
update  mig_pivot_26.miwtreleve_gc
set    MME_ID6 = v_max_mig + rownum
where  MREL_INDEX6 !=0 ;

end ;
/

DECLARE
v_min integer;
v_max integer;
v_depart integer;
v_pas  integer;
BEGIN
select min(MME_ID6) into v_min from  mig_pivot_26.miwtreleve_gc ;
select max(MME_ID6) into v_max from  mig_pivot_26.miwtreleve_gc ;
v_pas := round((v_max-v_min+1)/10) + 1;
v_depart := v_min;
while v_depart <= v_max
loop
 INSERT 
 INTO tecmtrmeasure
 (
	 MME_ID              	, -- number(10) not null 
	 MRD_ID              	, -- number(10) not null 
	 MEU_ID              	, -- number(10) not null 
	 MME_NUM           	    , -- number(10) not null 
	 MME_VALUE              , -- number(2) not null 
	 MME_CONSUM             ,
	 MME_AVGCONSUM			,
	 MME_DEDUCEMANUAL 
 )
 (
	SELECT  /*+RULE*/
									MME_ID6      	, --  INDEX 
									MRD_ID      	, --  RELEVE
									MEU_ID6      	, --  TYPE CADRAN
									6    			, --  IDX_INDEX     NUMBER(10) NOT NULL
									MREL_INDEX6     , --  IDX_NUMCADRAN NUMBER(2) NOT NULL
									MREL_INDEX6		,
									0				,
									MREL_DEDUITE
	FROM      mig_pivot_26.miwtreleve_gc R
	WHERE   MME_ID6   IS NOT NULL
	AND     MRD_ID IS NOT  NULL
	AND    MEU_ID6  IS  NOT NULL
	AND     MME_ID6 >= V_DEPART
	AND     MME_ID6 < V_DEPART + V_PAS 
	AND not EXISTS	(SELECT 1 FROM tecmtrmeasure M WHERE R.MRD_ID = M.MRD_ID)
 );
 COMMIT ;
	v_depart := v_depart + v_pas ;
end loop;

END;
/
DECLARE
cursor e is select t.spt_refe from tecservicepoint t;
CURSOR C(v_spt_refe varchar2) IS select t.*, t.rowid from TECMTRREAD t 
WHERE t.spt_id= (select y.spt_id from tecservicepoint y where y.spt_refe=v_spt_refe) 
ORDER BY MRD_DT ;

BEGIN
  for r in e loop
  for s in c(r.spt_refe) loop
  UPDATE TECMTRREAD t set t.mrd_previous_id=s.mrd_id
  where t.mrd_id=(select mrd_id from TECMTRREAD 
					where MRD_DT>s.MRD_DT  
                    and spt_id= (select y.spt_id from tecservicepoint y where y.spt_refe=r.spt_refe)
                   and rownum=1 )
  and  t.spt_id= (select y.spt_id from tecservicepoint y where y.spt_refe=r.spt_refe);
  /*update tecmtrread d set d.mrd_previous_id=null 
  where d.mrd_id=(select mrd_id from TECMTRREAD where MRD_DT<s.MRD_DT  
        and spt_id= (select y.spt_id from tecservicepoint y where y.spt_refe like '20163811%')
        and rownum=1 );*/
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
--select nvl(max(aac_id),0) into v_aac_id from AGRAVGCONSUM;

for s in c loop
select seq_AGRAVGCONSUM.nextval into v_aac_id from dual;
--v_aac_id:=v_aac_id+1;
insert into AGRAVGCONSUM
				(
				  aac_id          ,--1 NUMBER(10) not null,
				  sag_id          ,--2 NUMBER(10) not null,
				  meu_id          ,--3 NUMBER(10) not null,
				  aac_avgconsummrd,--4 NUMBER(17,10),
				  aac_avgconsumimp,--5 NUMBER(17,10),
				  aac_enddt       ,--6 DATE,
				  aac_credt       ,--7 DATE default sysdate,
				  aac_updtdt      ,--8 DATE,
				  aac_updtby       --9 NUMBER(10)
				 )
				values 
				(
				  v_aac_id		,--1 NUMBER(10) not null,
				  s.sag_id		,--2 NUMBER(10) not null,
				  5				,--3 NUMBER(10) not null,
				  s.mme_consum  ,--4 NUMBER(17,10),
				  null			,--5 NUMBER(17,10),
				  null			,--6 DATE,
				  null			,--7 DATE default sysdate,
				  null			,--8 DATE,
				  null			 --9 NUMBER(10)
				 );
end loop;
commit;
end;
/
SELECT to_char(sysdate, 'DD/MM/YY HH24:MI') heure FROM dual;
spo off;

 