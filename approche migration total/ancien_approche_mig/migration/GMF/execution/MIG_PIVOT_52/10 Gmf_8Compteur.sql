spo Gmf_8Compteur.lst;
SELECT to_char(sysdate, 'DD/MM/YY HH24:MI') heure FROM dual;
update   mig_pivot_52.miwtcompteur set MCOM_REFVOCMARQUE = '-' where MCOM_REFVOCMARQUE is null ;
update   mig_pivot_52.miwtcompteur set VOC_MODEL = '-' where VOC_MODEL is null ;
update   mig_pivot_52.miwtcompteur set VOC_DIAM ='-'  where VOC_DIAM is null ;
update   mig_pivot_52.miwtcompteur set VOC_MTRELECTP ='-'  where VOC_MTRELECTP is null ;
update   mig_pivot_52.miwtcompteur set MCOM_REFVOCCLASSE ='-'  where MCOM_REFVOCCLASSE  is null ;
update   mig_pivot_52.miwtcompteur set mcom_annee =to_char(sysdate ,'yyyy')  where mcom_annee  is null ;
update   mig_pivot_52.miwtcompteur set MCOM_RADI_CONS = '-' where MCOM_RADI_CONS is null ;
update   mig_pivot_52.miwtcompteur set MCOM_RADI_MODELE = '-' where MCOM_RADI_MODELE is null ;
update   mig_pivot_52.miwtcompteur set mcom_radi_annee = 2014 where mcom_radi_annee is null ;
update   mig_pivot_52.miwtcompteur set VOC_OWNER = 'ELD' where VOC_OWNER is null ;
UPDATE  mig_pivot_52.miwtcompteur SET mcom_annee=2000 where length(mcom_annee)<4;
--tecequipment,tecmeter,tecmtrread,tecmtrcfg,tecmtrcfgdetail
--techequipment,
PROMPT *******************************************************
PROMPT *** MIGRATION  / Création miwtcompteur ****************
PROMPT *******************************************************
SET serveroutput on;
Declare 
Cursor Compteur  is select
		mcom_source        ,
		substr(mcom_ref,1,5)||lpad(substr(mcom_ref,6,20),11,'0') mcom_ref,
		substr(mcom_ref,1,5)||lpad(substr(mcom_ref,6,20),11,'0') mcom_reel,--EQU_SERIALNUMBER         ,
		mcom_cle           ,
		VOC_EQUSTATUS      ,
		mcom_COMMENT       ,
		mcom_refvocmarque  ,
		--mcom_modele        varchar2(200)          ,
		VOC_MODEL          ,
		voc_diam           ,
		to_date('01/01'||decode(mcom_annee,0,1900,mcom_annee)) mcom_annee,
		mcom_refvocclasse  ,
		ncom_nbroue        ,
		mcom_longueur      ,
		REF_TYPEEQUI       ,
		mcom_radi_pose     ,
		mcom_radi_refe     ,
		mcom_radi_cons     ,--????? voc voire avec David  quel table GMF
		mcom_radi_modele   ,--????? voc voire avec David quel table GMF
		mcom_radi_empl     ,--???? voc voire avec David quel table GMF
		mcom_radi_protcole ,
		to_date('01/01'||mcom_radi_annee) mcom_radi_annee,
		mcom_radi_poidsimp ,
		mcom_radi_uniteimp ,
		mcom_radi_nbvoies  ,
		mcom_radi_indexdep ,
		VOC_QN             ,
		nvl(MCOM_NBPHASES,1)MCOM_NBPHASES,
		VOC_MTRELECTP      ,
        VOC_MTRAMP         ,--          VOC_MTRAMP   ,
        VOC_MTRTENSION     ,--          VOC_MTRTENSION,
        VOC_OWNER          ,--          vow_owner    ,
        MCOM_NBMEU         ,
		mtc_id
        from     mig_pivot_52.miwtcompteur 
		where REF_TYPEEQUI not in ('DISJ','TRANSFO','TELEREPORT') 
		and  equ_id is null ;
 
		New_Equi		       tecequipment%rowtype;
		Equi_Id                Number ;
		ref_Equi               Number ;
		
		New_tecmtrwater		   tecmtrwater%rowtype;
		New_tecmtrelec		   tecmtrelec%rowtype;
		
		New_Equi_Radio		   tecequipment%rowtype;
		Equi_Id_Radio          Number ;
		ref_Equi_Radio         Number ;
		
		New_Tecmtrcfg          tecmtrcfg%rowtype;
		Tecmtrcfg_Id           Number ;
		ref_Tecmtrcfg          Number ;
		
		New_tecequmodel        tecequmodel%rowtype;
		tecequmodel_Id         Number ;
		ref_tecequmodel        Number ;
		
		New_tecequtype         tecequtype%rowtype;
		tecequtype_Id          Number ;
		ref_tecequtype         Number ;
		err_mess               varchar2(150) ;
		
		
Procedure Genere_Compteur (NewEqui tecequipment%rowtype ,EquiId  in out 	number ,ref_Equi out number) is
 BEGIN
			SELECT  equ_id INTO  ref_Equi 
			from    tecequipment
			where   nvl(equ_realnumber,'*')      = nvl(NewEqui.equ_realnumber ,'*') ;
			
Exception
	WHEN NO_DATA_FOUND THEN
		    --EquiId   := EquiId+1;
			ref_Equi := EquiId; 
				
			insert into tecequipment (
			                          equ_id          ,
									  equ_realnumber  ,
									  equ_key         ,
									  equ_serialnumber,
									  vow_equstatus   ,
									  equ_lot         ,
									  equ_year        ,
									  EQU_TECHINFO    ,
									  mmo_id          ,
									  EQY_ID          ,
									  vow_owner
									  )
	                          values (
							          EquiId                  ,
									  NewEqui.equ_realnumber  ,
									  NewEqui.equ_key         ,
									  NewEqui.equ_serialnumber,
									  NewEqui.vow_equstatus   ,
			                          NewEqui.equ_lot         ,
									  NewEqui.equ_year        ,
									  NewEqui.EQU_TECHINFO    ,
									  NewEqui.mmo_id          ,
									  NewEqui.EQY_ID          ,
									  NewEqui.vow_owner
									  );
end Genere_Compteur;



Procedure Genere_tecequtype (Newtecequtype tecequtype%rowtype ,tecequtypeId  in out 	number ,ref_tecequtype out number) is
 BEGIN
			SELECT  eqy_id INTO  ref_tecequtype 
			from    tecequtype
			where   nvl(EQY_CODE,'*') = nvl(Newtecequtype.EQY_CODE ,'*') ;
			
Exception
	WHEN NO_DATA_FOUND THEN
				 --tecequtypeId := tecequtypeId+1; 
				ref_tecequtype := tecequtypeId;
								
			        insert into tecequtype (
					                         eqy_id  , 
											 eqy_code,
											 eqy_name,
											 eqy_type
											 )
	                                 values (
									          tecequtypeId,
											  Newtecequtype.eqy_code,
											  Newtecequtype.eqy_name,
											  1
											  );
			                    
end Genere_tecequtype;

Procedure Genere_tecmtrcfg (NewTecmtrcfg tecmtrcfg%rowtype ,TecmtrcfgId  in out 	number ,ref_Tecmtrcfg out number) is
 BEGIN
			SELECT  mtc_id INTO  ref_Tecmtrcfg 
			from    tecmtrcfg
			where   nvl(mtc_code,'*')        = nvl(NewTecmtrcfg.mtc_code ,'*') 
			and     nvl(vow_manufact,0)      = nvl(NewTecmtrcfg.vow_manufact ,0) 
			and     nvl(vow_model,0)         = nvl(NewTecmtrcfg.vow_model ,0);
			
Exception
	WHEN NO_DATA_FOUND THEN
				 --TecmtrcfgId   := TecmtrcfgId+1;
				ref_Tecmtrcfg := TecmtrcfgId;  
				
			insert into tecmtrcfg(
			                       mtc_id,
								   mtc_code,
								   mtc_name,
								   vow_manufact,
								   vow_model,
								   FLD_ID
							      )
	                       values (
							        TecmtrcfgId              ,
									NewTecmtrcfg.mtc_code    ,
									NewTecmtrcfg.mtc_name    ,
									NewTecmtrcfg.vow_manufact,
									NewTecmtrcfg.vow_model   ,
									NewTecmtrcfg.FLD_ID
									);
			                     
end Genere_tecmtrcfg;


Procedure Genere_tecequmodel (Newtecequmodel tecequmodel%rowtype ,tecequmodelId  in out 	number ,ref_tecequmodel out number) is
 BEGIN
			SELECT  mmo_id INTO  ref_tecequmodel 
			from    tecequmodel
			where   nvl(eqy_id,0)            = nvl(Newtecequmodel.eqy_id ,0) 
			and     nvl(vow_manufact,0)      = nvl(Newtecequmodel.vow_manufact ,0) 
			and     nvl(vow_model,0)         = nvl(Newtecequmodel.vow_model ,0) ;
			
Exception
	WHEN NO_DATA_FOUND THEN
				--tecequmodelId   := tecequmodelId+1;
				ref_tecequmodel := tecequmodelId;  
				 
			  insert into tecequmodel (
			                           mmo_id,
									   eqy_id,
									   vow_manufact,
									   vow_model
									   )
							   values (
							           tecequmodelId,
									   Newtecequmodel.eqy_id,
									   Newtecequmodel.vow_manufact,
									   Newtecequmodel.vow_model
									   );
			                     
end Genere_tecequmodel;


 begin
--select nvl(max(equ_id),0) into Equi_Id           from tecequipment;
--select nvl(max(mtc_id),0) into Tecmtrcfg_Id      from tecmtrcfg;
--select nvl(max(mmo_id),0) into tecequmodel_Id    from tecequmodel;
--select nvl(max(eqy_id),0) into tecequtype_Id     from tecequtype;

	For Equi in Compteur loop

		select SEQ_TECEQUIPMENT.NEXTVAL into Equi_Id        from dual;
		select seq_tecmtrcfg.NEXTVAL    into Tecmtrcfg_Id   from dual;
		select seq_tecequtype.NEXTVAL   into tecequtype_Id  from dual;
		select seq_tecequmodel.NEXTVAL  into tecequmodel_Id from dual;

         New_Equi:= null;
		 err_mess := null;
		--------------------------------------------------------Traitement tecequipment  compteur	
        --------------------------------------------------------Traitement tecequipment  compteur	
        --------------------------------------------------------Traitement tecequipment  compteur			
		New_Equi.EQU_REALNUMBER       :=  Equi.mcom_ref ;
		New_Equi.EQU_KEY              :=  Equi.mcom_cle;
		New_Equi.EQU_SERIALNUMBER     :=  Equi.mcom_reel ;
		PK_Util_Vocabulaire.Genere_voc( New_Equi.VOW_EQUSTATUS,'VOW_EQUSTATUS', Equi.VOC_EQUSTATUS) ;
		--New_Equi.VOW_EQUSTATUS        :=  pk_genvocword.getidbycode('VOW_EQUSTATUS','1',null) ;	
		New_tecequtype.EQY_CODE       :=  Equi.REF_TYPEEQUI ;
		New_tecequtype.EQY_NAME       :=  Equi.REF_TYPEEQUI ;
		Genere_tecequtype (New_tecequtype,tecequtype_Id,ref_tecequtype) ;
		New_Equi.EQY_ID               :=  ref_tecequtype;
		--select t.eqy_id into New_Equi.EQY_ID from tecequtype t where eqy_code = 'CPTEAU' ;--REF_TYPEEQUI
		New_Equi.EQU_YEAR             :=  Equi.mcom_annee;
		--New_Equi.EQU_OFFDT            :=  Equi.MRIB_BIC ;
	    PK_Util_Vocabulaire.Genere_voc( New_Equi.VOW_OWNER,'VOW_OWNER', Equi.VOC_OWNER)  ;
		--pk_genvocword.getidbycode('VOW_OWNER','1',null) ;	--ELD..1
		New_tecequmodel.EQY_ID        :=  New_Equi.EQY_ID  ;
		PK_Util_Vocabulaire.Genere_voc( New_tecequmodel.VOW_MANUFACT,'VOW_MANUFACT', Equi.MCOM_REFVOCMARQUE) ;--ocabulaire Fabricant[MANUFACT]
		PK_Util_Vocabulaire.Genere_voc( New_tecequmodel.VOW_MODEL ,  'VOW_MODEL',    Equi.VOC_MODEL) ;--Vocabulaire Model[MODEL]
		Genere_tecequmodel (New_tecequmodel ,tecequmodel_Id  ,ref_tecequmodel) ;
		New_Equi.MMO_ID               :=  ref_tecequmodel ;
		--New_Equi.EQU_TECHINFO         :=  Equi.MRIB_BIC ;
		New_Equi.EQU_COMMENT          :=  Equi.mcom_COMMENT ;
		If Equi.ncom_nbroue is not null or Equi.mcom_longueur is not null then 
		select '<?xml version="1.0" encoding="ISO-8859-15"?>'||chr(10)||XMLAgg
                        (
                        XMLElement("parameters" ,
                        XMLElement("Longueur'",Equi.ncom_nbroue),
                        XMLElement("NombreRoue",Equi.mcom_longueur)
                        ))into New_Equi.EQU_TECHINFO from dual ;
		End if;			

		Genere_Compteur (New_Equi ,Equi_Id  ,ref_Equi ) ;
		--------------------------------------------------------Traitement TECMTRCFG Compteur

		PK_Util_Vocabulaire.Genere_voc( New_Tecmtrcfg.VOW_MANUFACT,'VOW_MANUFACT', Equi.MCOM_REFVOCMARQUE) ;--ocabulaire Fabricant[MANUFACT]
		PK_Util_Vocabulaire.Genere_voc( New_Tecmtrcfg.VOW_MODEL,  'VOW_MODEL',    Equi.VOC_MODEL) ;--Vocabulaire Model[MODEL]
       -- select f.fld_id into New_Tecmtrcfg.FLD_ID  from tecfluid f where fld_code ='PDC EAU' ;  --fld_code = 'EAU' ;
		--New_Tecmtrcfg.MTC_CODE     :=  'Eau'  ;
		--New_Tecmtrcfg.MTC_NAME     :=  'Eau' ;
		--Genere_tecmtrcfg (New_Tecmtrcfg,Tecmtrcfg_Id ,ref_Tecmtrcfg ) ;
		         begin
		              Insert into tecmeter(
										   equ_id,
					                       mtc_id 
										   )
								    values(
         								   ref_Equi,
										   Equi.mtc_id
										   );
				   exception when dup_val_on_index then 
				   err_mess := sqlerrm ;
				   --insert into  mig_pivot_52.MIW_LOG(MIW_LOG_TAB,MIW_LOG_ERRUR)
				   --values('tecmeter',err_mess||' '||'code :'||Equi.MCOM_REF) ;           			
				end ;
		If Equi.REF_TYPEEQUI ='EAU' then 
		New_tecmtrwater.EQU_ID     := ref_Equi  ;
		PK_Util_Vocabulaire.Genere_voc( New_tecmtrwater.VOW_DIAM ,'VOW_DIAM', Equi.VOC_DIAM) ;--ocabulaire Fabricant[MANUFACT]
		PK_Util_Vocabulaire.Genere_voc( New_tecmtrwater.VOW_CLASS ,'VOW_CLASS', Equi.MCOM_REFVOCCLASSE) ;--ocabulaire Fabricant[MANUFACT]
        PK_Util_Vocabulaire.Genere_voc( New_tecmtrwater.VOW_QN ,'VOW_QN', Equi.VOC_QN) ;--ocabulaire Fabricant[MANUFACT]	
                       begin		
						Insert into tecmtrwater
											 (
												 EQU_ID                    ,
												 VOW_DIAM                  ,
												 VOW_CLASS                 ,
												 VOW_QN
											 ) 
											 values
											 (
												New_tecmtrwater.EQU_ID       ,
												New_tecmtrwater.VOW_DIAM     ,
												New_tecmtrwater.VOW_CLASS    ,
												New_tecmtrwater.VOW_QN 
											 );
					   exception when dup_val_on_index then 
					   err_mess := sqlerrm ;
				   --insert into MIW_LOG(MIW_LOG_TAB,MIW_LOG_ERRUR)
				   --values('tecmtrwater',err_mess||' '||'code :'||Equi.MCOM_REF) ;           			
				end ;
		end if ;
		If Equi.REF_TYPEEQUI ='EDEC' then 
		
		New_tecmtrelec.EQU_ID         :=  ref_Equi  ;
		PK_Util_Vocabulaire.Genere_voc( New_tecmtrelec.VOW_MTRELECTP ,'VOW_MTRELECTP', Equi.VOC_MTRELECTP) ;--ocabulaire Fabricant[MANUFACT]
		PK_Util_Vocabulaire.Genere_voc( New_tecmtrelec.VOW_PHASE ,'VOW_PHASE', Equi.MCOM_NBPHASES) ;
		PK_Util_Vocabulaire.Genere_voc( New_tecmtrelec.VOW_MTRAMP ,'VOW_MTRAMP', Equi.VOC_MTRAMP) ;
		PK_Util_Vocabulaire.Genere_voc( New_tecmtrelec.VOW_MTRTENSION ,'VOW_MTRTENSION', Equi.VOC_MTRTENSION) ;
		New_tecmtrelec.MEL_NBMEU  := Equi.MCOM_NBMEU ;
		
		
		--New_tecmtrelec.VOW_PHASE      := Equi.VOW_PHASE ;
		         begin
					Insert into tecmtrelec
										 (
											 EQU_ID                     ,
											 VOW_PHASE                  ,
											 VOW_MTRELECTP              ,
											 VOW_MTRAMP                 ,
											 VOW_MTRTENSION             ,
											 MEL_NBMEU
										 ) 
										 values
										 (
											New_tecmtrelec.EQU_ID        ,
											New_tecmtrelec.VOW_PHASE     ,
											New_tecmtrelec.VOW_MTRELECTP , 
											New_tecmtrelec.VOW_MTRAMP    ,
											New_tecmtrelec.VOW_MTRTENSION, 
											New_tecmtrelec.MEL_NBMEU
										);
						   exception when dup_val_on_index then 
						   err_mess := sqlerrm ;
				   --insert into MIW_LOG(MIW_LOG_TAB,MIW_LOG_ERRUR)
				   --values('tecmtrelec',err_mess||' '||'code :'||Equi.MCOM_REF) ;           			
				end ;
		
		end if ;
		
		Update   mig_pivot_52.miwtcompteur 
		set equ_id =ref_Equi  
		  where MCOM_REF = Equi.MCOM_REF ;
		
		--------------------------------------------------------Traitement tecequipment Tete Radio	
        --------------------------------------------------------Traitement tecequipment Tete Radio			
		--------------------------------------------------------Traitement tecequipment Tete Radio	
	IF Equi.mcom_radi_refe Is not null then 
		
		New_Equi_Radio.EQU_REALNUMBER       :=  Equi.mcom_radi_refe ;
		--New_Equi_Radio.EQU_KEY              :=  Equi.mcom_radi_refe;
		New_Equi_Radio.EQU_SERIALNUMBER     :=  Equi.mcom_radi_refe ;
		New_Equi_Radio.VOW_EQUSTATUS        :=  pk_genvocword.getidbycode('VOW_EQUSTATUS','1',null) ;	
		--New_tecequtype.EQY_CODE             :=  'Radio' ;--Radio
		--New_tecequtype.EQY_NAME             :=  'Radio' ;--mcom_radi_refe
		PK_Util_Vocabulaire.Genere_voc( New_tecequmodel.VOW_MANUFACT,'VOW_MANUFACT', Equi.MCOM_RADI_CONS) ;--ocabulaire Fabricant[MANUFACT]
		PK_Util_Vocabulaire.Genere_voc( New_tecequmodel.VOW_MODEL ,  'VOW_MODEL',    Equi.MCOM_RADI_MODELE) ;--Vocabulaire Model[MODEL]
		CASE     pk_genvocword.GetPrintNameByCode('VOW_MANUFACT',Equi.MCOM_RADI_CONS)
		      WHEN 'CORONIS'    THEN 
		          New_tecequtype.EQY_CODE             :=  'CO' ;
		          New_tecequtype.EQY_NAME             :=  'Radio Coronis' ;
		      WHEN 'SAPPEL'     THEN 
		          New_tecequtype.EQY_CODE             :=  'R3'  ;
		          New_tecequtype.EQY_NAME             :=  'Radio Sappel  R3' ;
		      WHEN 'RADIO-TECH' THEN 
		          New_tecequtype.EQY_CODE             :=  'RTEC' ;
		          New_tecequtype.EQY_NAME             :=  'Télérelève RadioTech' ;
		      WHEN 'SENSUS'     THEN 
		          New_tecequtype.EQY_CODE             :=  'CO' ;
		          New_tecequtype.EQY_NAME             :=  'Radio Coronis' ;
		      ELSE   New_tecequtype.EQY_CODE             :=  'CO' ;
		          New_tecequtype.EQY_NAME             :=  'Radio Coronis' ;
		END CASE;
		Genere_tecequtype (New_tecequtype,tecequtype_Id,ref_tecequtype) ;
		New_Equi_Radio.EQY_ID               :=  ref_tecequtype;
		--select t.eqy_id into New_Equi.EQY_ID from tecequtype t where eqy_code = 'CPTEAU' ;--REF_TYPEEQUI
		New_Equi_Radio.EQU_YEAR             :=  Equi.mcom_radi_annee;
		--New_Equi.EQU_OFFDT                :=  Equi.MRIB_BIC ;
		New_Equi_Radio.vow_owner            :=  pk_genvocword.getidbycode('VOW_OWNER','1',null) ;	
		New_tecequmodel.EQY_ID              :=  New_Equi.EQY_ID  ;

		Genere_tecequmodel (New_tecequmodel ,tecequmodel_Id  ,ref_tecequmodel) ;
		New_Equi_Radio.MMO_ID               :=  ref_tecequmodel ;
		--New_Equi.EQU_TECHINFO             :=  Equi.MRIB_BIC ;
		New_Equi_Radio.EQU_COMMENT          :=  Equi.mcom_COMMENT ;
		If Equi.MCOM_RADI_POIDSIMP is not null or Equi.MCOM_RADI_UNITEIMP is not null or Equi.MCOM_RADI_NBVOIES is not null 
		or Equi.MCOM_RADI_INDEXDEP is not null or Equi.MCOM_RADI_PROTCOLE is not null  then 
		select '<?xml version="1.0" encoding="ISO-8859-15"?>'||chr(10)||XMLAgg
                        (
                        XMLElement("parameters" ,
                        XMLElement("Poids",Equi.MCOM_RADI_POIDSIMP),
                        XMLElement("Unite",Equi.MCOM_RADI_UNITEIMP),
						XMLElement("NombreVoies",Equi.MCOM_RADI_NBVOIES),
						XMLElement("IndexTelereleve",Equi.MCOM_RADI_INDEXDEP),
						XMLElement("Protcole",Equi.MCOM_RADI_PROTCOLE)
                        ))into New_Equi_Radio.EQU_TECHINFO from dual ;
		End if;			
		--------------------------------------------------------Traitement TECMTRCFG Radio
		
        PK_Util_Vocabulaire.Genere_voc( New_Tecmtrcfg.VOW_MANUFACT,'VOW_MANUFACT', Equi.MCOM_REFVOCMARQUE) ;--ocabulaire Fabricant[MANUFACT]
		PK_Util_Vocabulaire.Genere_voc( New_Tecmtrcfg.VOW_MODEL,  'VOW_MODEL',    Equi.VOC_MODEL) ;--Vocabulaire Model[MODEL]
       -- select f.fld_id into New_Tecmtrcfg.FLD_ID  from tecfluid f where fld_code ='PDC EAU' ;  --fld_code = 'EAU' ;
		--New_Tecmtrcfg.MTC_CODE     :=  'Eau'  ;
		--New_Tecmtrcfg.MTC_NAME     :=  'Eau' ;
		--Genere_tecmtrcfg (New_Tecmtrcfg,Tecmtrcfg_Id ,ref_Tecmtrcfg ) ;
		
		Genere_Compteur (New_Equi_Radio ,Equi_Id  ,ref_Equi_Radio ) ;
		
					Update   mig_pivot_52.miwtcompteur 
					set equ_id_radio =ref_Equi_Radio  
					where MCOM_REF = Equi.MCOM_REF ;
		
    End if;
end loop ;
--exception  when others then dbms_output.put_line('************************************'||Ref_Agr);
Commit;
end ;
/


		update  mig_pivot_52.miwthistocpt  
		set MHPC_AGESOURCE ='INCONNUE' 
		where  MHPC_AGESOURCE is null;

	UPDATE  mig_pivot_52.miwthistocpt m
		SET    AGE_ID =
				   (
					   SELECT AGE_ID 
					   FROM    mig_pivot_52.miwagent c 
					   WHERE   AGE_REF    = m.MHPC_AGESOURCE
					   and    AGE_SOURCE  = MHPC_SOURCE
					)
		WHERE AGE_ID is null;

Declare 
 w_voc_id Number ;
 w_voc_dep_id Number ;
Begin
For voc in  (select VOC_REASPOSE ,MHPC_REFCOM,MHPC_REFPDL,VOC_REASDEPOSE from   mig_pivot_52.miwthistocpt )
loop 
PK_Util_Vocabulaire.Genere_voc( w_voc_id,'VOW_REASPOSE', Voc.VOC_REASPOSE) ;
PK_Util_Vocabulaire.Genere_voc( w_voc_dep_id,'VOW_REASDEPOSE', Voc.VOC_REASDEPOSE) ;

		update   mig_pivot_52.miwthistocpt
		 set  voc_id = w_voc_id,
			  voc_dep_id=w_voc_dep_id  
		 where   MHPC_REFCOM =voc.MHPC_REFCOM 
		 and MHPC_REFPDL = voc.MHPC_REFPDL ;
end loop ;
end ;
/
prompt **********************************************************************
prompt **** MIGRATION  / Création des historiques compteurs   ***************
prompt **********************************************************************
ANALYZE TABLE  mig_pivot_52.miwthistocpt COMPUTE STATISTICS;
ANALYZE TABLE   mig_pivot_52.miwtcompteur COMPUTE STATISTICS;
ANALYZE TABLE   mig_pivot_52.miwtpdl COMPUTE STATISTICS;

DECLARE
 v_debut_id number;

BEGIN
 
 select nvl(max(HEQ_ID),0)
 into   v_debut_id 
 from   TECHEQUIPMENT ; 
   --select seq_TECHEQUIPMENT.NEXTVAL into v_debut_id from dual;
   
 INSERT INTO TECHEQUIPMENT
 (
   HEQ_ID            ,
   EQU_ID            , 
   SPT_ID            , 
   AGE_POSE          ,  
   HEQ_STARTDT       ,
   HEQ_ENDDT         ,
   VOW_REASPOSE      ,
   VOW_REASDEPOSE
   )
  (
    select v_debut_id + rownum, 
           c.EQU_ID           ,
           p.SPT_ID           ,
           nvl(AGE_ID,1)      ,
           h.MHPC_DDEB        ,    
           h.MHPC_DFIN        ,
           voc_id             ,
		   voc_dep_id
    from     mig_pivot_52.miwtcompteur  c  ,
             mig_pivot_52.miwthistocpt h   ,
             mig_pivot_52.miwtpdl  p
    where 1 = 1
    and   h.MHPC_REFCOM = c.MCOM_REF
    and   h.MHPC_REFPDL = p.PDL_REF
	and   EQU_ID is not null
	and   SPT_ID is not null 
  and   spt_id not in (select spt_id from techequipment)
  )  ;
  
  
  COMMIT ;
--exec CREATE_SEQ;
  END;
/
prompt *******************************************************
prompt **** MIGRATION  / POse Radio          *****************
prompt *******************************************************

DECLARE
 v_debut_id number;

BEGIN
 
 /*select nvl(max(ECO_ID),0)
 into   v_debut_id 
 from   techequcom ;*/
 
 select seq_techequcom.NEXTVAL into v_debut_id from dual;
 
 INSERT INTO TECHEQUCOM
 (
   ECO_ID               ,
   EQU_ID               , 
   EQU_COMM_ID          ,  
   EQY_PROTOCOL         ,
   ECO_STARTDT   
   )
  (
    select v_debut_id + rownum, 
           EQU_ID        ,
           EQU_ID_RADIO  ,
           (select '<?xml version="1.0" encoding="ISO-8859-15"?>'||chr(10)||XMLAgg
                        (
                        XMLElement("parameters" ,
                        XMLElement("Poids",Equi.MCOM_RADI_POIDSIMP),
                        XMLElement("Unite",Equi.MCOM_RADI_UNITEIMP),
						XMLElement("NombreVoies",Equi.MCOM_RADI_NBVOIES),
						XMLElement("IndexTelereleve",Equi.MCOM_RADI_INDEXDEP),
						XMLElement("Protcole",Equi.MCOM_RADI_PROTCOLE)
                        ))from dual ),
           MCOM_RADI_POSE    
    from     mig_pivot_52.miwtcompteur   Equi
    where 1 = 1
	and   EQU_ID        is not null
	and   EQU_ID_RADIO  is not null 
  )
  ;
  COMMIT ;
  END;
/
SELECT to_char(sysdate, 'DD/MM/YY HH24:MI') heure FROM dual;
spo off;


