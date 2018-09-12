/*--agrsagbun
spo Gmf_7Pds_ndes.lst;
SELECT to_char(sysdate, 'DD/MM/YY HH24:MI') heure FROM dual;*/
/*
PROMPT *******************************************************
PROMPT *** MIGRATION  / Création Contrat type    *************
PROMPT *******************************************************
---- Add/modify columns 

Update MIWCTRTYPE set CTRTYPE_REFGRF='INCONNUE' where CTRTYPE_REFGRF is null ;
Update MIWCTRTYPE set ctrtype_refimp = '411' WHERE ctrtype_refimp IS NULL;
Update MIWCTRTYPE set CTR_DEBUT=sysdate  where CTR_DEBUT is null ;
Update MIWSECTEUR_CTRTYPE set sdl_id =(select  sdl_id from  GENSERVICEDELIVERY where MCCTRTYPE_PRESTATION = SDL_CODE  ) ;
commit;
Declare 
Cursor ContratType is 
select
		distinct CTRTYPE_SOURCE         ,
		CTRTYPE_REF            ,
		CTRTYPE_NOM            ,
		CTR_DEBUT              ,
		CTR_FIN                ,
		CTR_COMMENTAIRE        ,
		CTRTYPE_REFGRF         ,
        g.org_id		       ,
		REC_ID                 ,
		PAR_ID                 ,
		CTRTYPE_REFIMP  
 from   MIWCTRTYPE  ,miworganization g ,MIWTRELANCE R
 Where 
          CTRTYPE_REFORGA   = MORGA_REFORGA 
 and      R.CTR_RELANCE       = MRELANCE_REFREL
 and      CTT_ID is null;
 
 Cursor SEC( W_REFCTR varchar2) is 
select
	  MCCTRTYPE_SOURCE        ,--VARCHAR2(100) not null,
	  MCCTRTYPE_REFCTRTYPE    ,--VARCHAR2(100) not null,
	  MCCTRTYPE_SECTEUR       ,--VARCHAR2(100) not null,
	  MCCTRTYPE_PRESTATION    ,--VARCHAR2(100) not null
	  MCCTRTYPE_TYPE          ,
	  MCCTRTYPE_NOM           ,
	  SDL_ID
 from   MIWSECTEUR_CTRTYPE
 Where 
     MCCTRTYPE_REFCTRTYPE = W_REFCTR 
	 and sdl_id is not null;
	 
		New_Ctr		     agrcontrattype%rowtype;
		Ctr_Id           Number ;
		ref_Ctr          Number ;
		New_Grf          agrgrpfact%rowtype  ;
		Grf_Id           Number ;
		ref_Grf          Number ;
		Type_sec1       number ;
		divspt_id       number ;
		divspt_ref       number ;
		New_division     gendivision%rowtype ;
		New_gendivctt    gendivctt%rowtype ;
		gendivctt_id     number ;
		gendivctt_ref    number ;
		New_genimp       genimp%rowtype ;
		genimp_id        number ;
		genimp_ref       number ;
		
		New_genaccount    genaccount%rowtype ;
		genaccount_id     number ;
		genaccount_ref    number ;
		

 Procedure Genere_ContratType (NewCtr agrcontrattype%rowtype ,CtrId  in out 	number ,ref_Ctr out number) is
 BEGIN
			SELECT  CTT_ID INTO  ref_Ctr 
			from    agrcontrattype
			where   nvl(CTT_CODE,'*')      = nvl(NewCtr.CTT_CODE ,'*') 
			and     nvl(ORG_ID,'0')        = nvl(NewCtr.ORG_ID ,'0') ;
Exception
	WHEN NO_DATA_FOUND THEN
				CtrId   := CtrId+1;
				ref_Ctr := CtrId; 
			insert into agrcontrattype (CTT_ID,CTT_CODE,CTT_NAME,CTT_STARTDT,CTT_ENDDT,CTT_COMMENT,GRF_ID,REC_ID,ORG_ID,ACO_ID_AGR,DLP_ID)
	        values                      (CtrId,NewCtr.CTT_CODE,NewCtr.CTT_NAME,NewCtr.CTT_STARTDT,NewCtr.CTT_ENDDT,NewCtr.CTT_COMMENT,
		                               NewCtr.GRF_ID,NewCtr.REC_ID,NewCtr.ORG_ID,NewCtr.ACO_ID_AGR,NewCtr.DLP_ID);
end Genere_ContratType;

Procedure Genere_Groupe_Facturation (NewGrf agrgrpfact%rowtype ,GrfId  in out 	number ,ref_Grf out number) is
 BEGIN
			SELECT  GRF_ID INTO  ref_Grf 
			from    agrgrpfact
			where   nvl(GRF_CODE,'*')      = nvl(NewGrf.GRF_CODE,'*')	;	  
			--and     nvl(GRF_NAME,'*')      = nvl(NewGrf.GRF_NAME,'*')  ;
Exception
	WHEN NO_DATA_FOUND THEN
				GrfId   :=GrfId+1;
				ref_Grf :=GrfId; 
			insert into agrgrpfact (GRF_ID,GRF_CODE,GRF_NAME)
	        values                 (GrfId,NewGrf.GRF_CODE,NewGrf.GRF_NAME);
end Genere_Groupe_Facturation;
--prompt **********************************************************
--prompt **** MIGRATION  / SECTEUR /contrat               *********
---prompt **********************************************************
Procedure Genere_Type_secteur(TypeNom Varchar2,Nom Varchar2,Ref_DIT_ID in out number  ) is
 BEGIN
			SELECT  DIT_ID INTO  ref_DIT_ID 
			from    gendivisiontype
			where   upper(nvl(DIT_CODE,'*'))   = nvl(TypeNom,'*')	;	 
		    update 	gendivisiontype set DIT_NAME = Nom where DIT_ID = ref_DIT_ID ;
Exception
	WHEN NO_DATA_FOUND THEN
	            --NewVil.TWN_ID:= Vil_Id + 1;
			select nvl(max(DIT_ID),0)+ 1 into Ref_DIT_ID from GENDIVISIONTYPE ;
			insert into GENDIVISIONTYPE (DIT_ID,DIT_CODE,DIT_NAME,DIT_CREDT) 
			values (Ref_DIT_ID, TypeNom,Nom,sysdate);	                        
end Genere_Type_secteur;

Procedure Genere_Secteur (Newsec gendivision%rowtype  ,Id_type number ,DVTID out number) is
SecId number ;
 BEGIN
       Begin
		      SELECT  DIV_ID INTO  SecId
		      from     GENDIVISION
		      where
		              upper(nvl(DIV_CODE,'*'))    =  upper(nvl(Newsec.DIV_CODE,'*')) ;
		          -- upper(nvl(DIV_NAME,'*'))     = upper(nvl(Newsec.DIV_NAME,'*')) ;
		 Exception
		 WHEN NO_DATA_FOUND THEN
				select nvl(max(DIV_ID),0)+1  into SecId from GENDIVISION ;
				select nvl(max(DVT_ID),0)+1  INTO DVTID  from GENDIVDIT ;
				insert into GENDIVISION (DIV_ID,DIV_CODE,DIV_NAME)
				values                  (SecId,Newsec.DIV_CODE,Newsec.DIV_NAME) ;
				insert into GENDIVDIT (DVT_ID,DIV_ID,DIT_ID)
				values                (DVTID,SecId,Id_type) ;
				
		end ;
				select max(DVT_ID) into DVTID from GENDIVDIT
				where   DIV_ID = SecId
				AND     DIT_ID = Id_type ;
			if nvl(DVTID,0) = 0 then
			    select nvl(max(DVT_ID),0)+1  INTO DVTID  from GENDIVDIT ;
				insert into GENDIVDIT (DVT_ID,DIV_ID,DIT_ID)
				values              (DVTID,SecId,Id_type) ;
			end if ;
			
end Genere_Secteur;

Procedure Genere_gendivctt (Newgendivctt gendivctt%rowtype  ,Id_gendivctt in out number ,Ref_gendivctt out number) is
 BEGIN
		      SELECT  dtt_id INTO  Ref_gendivctt
		      from     gendivctt
		      where
		            nvl(ctt_id,0)    = nvl(Newgendivctt.ctt_id,0) 
				and nvl(dvt_id,0)     = nvl(Newgendivctt.dvt_id,0) 
				and nvl(sdl_id,0)    = nvl(Newgendivctt.sdl_id,0)  ;
		 Exception
		 WHEN NO_DATA_FOUND THEN
		        Id_gendivctt:=Id_gendivctt +1;
				Ref_gendivctt:=Id_gendivctt ;
				insert into gendivctt (dtt_id,ctt_id,dvt_id,sdl_id)
				values                (Id_gendivctt,Newgendivctt.ctt_id,Newgendivctt.dvt_id,Newgendivctt.sdl_id) ;
end Genere_gendivctt;

--prompt **********************************************************
--prompt **** MIGRATION  / Imputaion                                           *********
---prompt **********************************************************
Procedure Genere_genimp (Newgenimp genimp%rowtype ,genimpId  in out 	number ,ref_genimp out number) is
 BEGIN
			SELECT  imp_id INTO  ref_genimp 
			from    genimp
			where   nvl(imp_code,'*')      = nvl(Newgenimp.imp_code ,'*') 
			and     nvl(ORG_ID,0)        = nvl(Newgenimp.ORG_ID ,0) ;
Exception
	WHEN NO_DATA_FOUND THEN
				genimpId   := genimpId+1;
				ref_genimp := genimpId; 
			insert into genimp (imp_id,imp_code,imp_name,vow_budgtp,org_id)
	        values                  (genimpId,Newgenimp.imp_code,Newgenimp.imp_name,Newgenimp.vow_budgtp,Newgenimp.org_id) ;
		                             
end Genere_genimp;
/*
Procedure Genere_genaccount (Newgenaccount genaccount%rowtype ,genaccountId  in out 	number ,ref_genaccount out number) is
 BEGIN
   
			SELECT  aco_id INTO  ref_genaccount 
			from    genaccount
			where   nvl(aco_status,0)      = nvl(Newgenaccount.aco_status ,0) 
			and     nvl(imp_id,0)        = nvl(Newgenaccount.imp_id ,0) ;
       			
Exception
	WHEN NO_DATA_FOUND THEN
      genaccountId   := genaccountId+1;
      ref_genaccount := genaccountId; 
			insert into genaccount (aco_id,par_id,imp_id,vow_acotp ,rec_id,aco_status ,ACO_COMMENT)
	        values                  (genaccountId,Newgenaccount.par_id,Newgenaccount.imp_id,Newgenaccount.vow_acotp,Newgenaccount.rec_id,Newgenaccount.aco_status ,Newgenaccount.ACO_COMMENT) ;
		                             
end Genere_genaccount;*/

/*
 begin
--select nvl(max(CTT_ID),0) into Ctr_Id from agrcontrattype;
--select nvl(max(GRF_ID),0) into Grf_Id from agrgrpfact;
--Genere_Type_secteur('ADM','Administratif',Type_sec1) ;
--Genere_Type_secteur('COMMUNE','COMMUNE',Type_sec1) ;
--select nvl(max(DPR_ID),0) into divspt_id from gendivspt;
--select nvl(max(dtt_id),0) into gendivctt_id from gendivctt;

select nvl(max(aco_id),0) into genaccount_id from genaccount;
--select nvl(max(imp_id),0) into genimp_id from genimp;
For ctr in ContratType loop

		--------------------------------------------------------Traitement Contrat Type 		
		New_Ctr.CTT_CODE       :=  ctr.CTRTYPE_REF ;
		New_Ctr.CTT_NAME       :=  ctr.CTRTYPE_NOM;
		New_Ctr.CTT_STARTDT    :=  ctr.CTR_DEBUT ;
        New_Ctr.CTT_STARTDT    :=  ctr.CTR_DEBUT ;	
        New_Ctr.CTT_COMMENT    :=  ctr.CTR_COMMENTAIRE ;
		New_Ctr.REC_ID         :=  ctr.REC_ID ;
		New_Ctr.ORG_ID		   :=  ctr.ORG_ID ;	
		--New_Ctr.DLP_ID		   :=  100000 ;	
		select t.dlp_id into New_Ctr.DLP_ID from gendelaypayment t where dlp_code = '30' ;
		--------------------------------------------------------Traitement GENT ACOUNT  
		
		--New_genimp.imp_id      :=  ctr.REC_ID ;
		New_genimp.imp_code    :=  ctr.CTRTYPE_REFIMP ;
		New_genimp.imp_name    :=  ctr.CTRTYPE_REFIMP ;
		New_genimp.vow_budgtp  :=  pk_genvocword.getidbycode('VOW_BUDGTP','EA',null);
		New_genimp.org_id      :=  ctr.org_id ;
		Genere_genimp (New_genimp ,genimp_id,genimp_ref) ;
		--New_genaccount.PAR_ID     :=  ctr.PAR_ID ;
		New_genaccount.IMP_ID     :=  genimp_ref ;
		New_genaccount.VOW_ACOTP  :=  pk_genvocword.getidbycode('VOW_ACOTP','1',null);
		New_genaccount.REC_ID     :=  ctr.REC_ID ;
		New_genaccount.aco_status := 1 ;
        New_genaccount.ACO_COMMENT := ctr.ctrtype_ref ;
		Genere_genaccount (New_genaccount ,genaccount_id ,genaccount_ref) ;
		New_Ctr.ACO_ID_AGR	   :=  genaccount_ref ;
		
		--------------------------------------------------------Traitement Grupe facturation(GRF)
		New_Grf.GRF_CODE        := ctr.CTRTYPE_REFGRF ;
		New_Grf.GRF_NAME        := ctr.CTRTYPE_REFGRF ;
		Genere_Groupe_Facturation(New_Grf ,Grf_Id ,ref_Grf ) ;
        New_Ctr.GRF_ID          := ref_Grf ;
		Genere_ContratType(New_Ctr ,Ctr_Id ,ref_Ctr ) ;
		Update miwctrtype  set CTT_ID = ref_Ctr  where  CTRTYPE_REF = ctr.CTRTYPE_REF ;

--------------------------------------------------------Traitement  SECTUER CONTRAT 
For SEC_ in SEC (ctr.CTRTYPE_REF)loop
        New_division.DIV_CODE :=SEC_.MCCTRTYPE_SECTEUR  ;
		New_division.DIV_NAME :=SEC_.MCCTRTYPE_NOM  ;
		Genere_Secteur (New_division  ,Type_sec1 ,divspt_ref);
		
		New_gendivctt.ctt_id :=	ref_Ctr ;
		New_gendivctt.dvt_id :=	divspt_ref ;
		New_gendivctt.sdl_id :=	SEC_.SDL_ID ;		---MCCTRTYPE_PRESTATION
		Genere_gendivctt (New_gendivctt  ,gendivctt_id ,gendivctt_ref) ;
end loop ;		
end loop ;
--Commit;
end ;
/
*/
/*
PROMPT *******************************************************
PROMPT *** MIGRATION  / INSERTION genagectt           ********
PROMPT *******************************************************

Declare 
Cursor Rol is 
	select
				ROLAGENT_SOURCE     ,--VARCHAR2(100)                                                                                                             
				ROLAGENT_REF        ,--VARCHAR2(100)                  Identifiant agent                                                                          
				VOC_ROLECTTAGE      ,--VARCHAR2(100)                   Role (1 : Resp Facture, 2 : Resp Releve, 3 : Plombier, 4 : Releveur, 5 :Chargé Clientèle) 
				ROLAGENT_REFCTRTYPE ,--VARCHAR2(100)                  Référence du contrat type dans le SI source                                                
				A.AGE_ID            ,--NUMBER        Y                                                                                                           
				T.CTT_ID              --NUMBER        Y   
 from   MIWROLAGENT R  ,MIWCTRTYPE T ,MIWAGENT A
 Where 
          ROLAGENT_REF      = AGE_REF 
 and      CTRTYPE_REF       = ROLAGENT_REFCTRTYPE
 and       T.CTT_ID is not  null
 and       A.AGE_ID is not null ;
 
 
        New_genagectt    genagectt%rowtype ;
		genagectt_id     number ;
		genagectt_ref    number ;
Procedure Genere_genagectt (Newgenagectt genagectt%rowtype ,genagecttId  in out 	number ,ref_genagectt out number) is
 BEGIN
			SELECT  agt_id INTO  ref_genagectt 
			from    genagectt
			where   nvl(age_id,0)                = nvl(Newgenagectt.age_id ,0) 
			and     nvl(ctt_id,0)                = nvl(Newgenagectt.ctt_id ,0)
			and     nvl(vow_rolecttage,0)        = nvl(Newgenagectt.vow_rolecttage ,0)
       			;
Exception
	WHEN NO_DATA_FOUND THEN
				genagecttId   := genagecttId+1;
				ref_genagectt := genagecttId; 
			insert into genagectt (agt_id,age_id,ctt_id ,vow_rolecttage)
	        values                  (genagecttId,Newgenagectt.age_id,Newgenagectt.ctt_id,Newgenagectt.vow_rolecttage) ;
		                             
end Genere_genagectt;
 
 Begin
 select nvl(max(agt_id),0) into genagectt_id from genagectt;
 For Rol_ in Rol loop

		--------------------------------------------------------Traitement Contrat Type 		
		New_genagectt.age_id       :=  Rol_.age_id ;
		New_genagectt.ctt_id       :=  Rol_.ctt_id;
        PK_Util_Vocabulaire.Genere_voc( New_genagectt.vow_rolecttage ,'VOW_ROLECTTAGE',  Rol_.VOC_ROLECTTAGE) ;
 	    Genere_genagectt(New_genagectt ,genagectt_id ,genagectt_ref ) ;
		Update MIWROLAGENT  set CTT_ID = Rol_.ctt_id , age_id = Rol_.age_id  where  ROLAGENT_REF = Rol_.ROLAGENT_REF and  ROLAGENT_REFCTRTYPE = Rol_.ROLAGENT_REFCTRTYPE  ;
End loop ;
Commit ;		
 end ;
/
*/
/*
PROMPT *******************************************************
PROMPT *** MIGRATION  / Modification pds              ********
PROMPT ********************************************************/
--update  mig_pivot_24.miwabn a set CTT_ID = (select c.ctt_id from  mig_pivot_24.miwctrtype c where c.ctrtype_ref = a.ABN_CTRTYPE_REF ) where CTT_ID is null ;
/*ANALYZE TABLE miwtpersonne COMPUTE STATISTICS;
ANALYZE TABLE MIWTHISTOPAYEUR COMPUTE STATISTICS;
ANALYZE TABLE miwabn COMPUTE STATISTICS;
PROMPT *******************************************************
PROMPT *** MIGRATION  / Création pds             *************
PROMPT *******************************************************
SET serveroutput on;*/
SELECT to_char(sysdate, 'DD/MM/YY HH24:MI') heure FROM dual;
Declare 
Cursor Abonnement 
is 
  select  ABN_source        ,
          ABN_REF           ,---ref abonne
          ABN_REFSITE       ,
          ABN_REFPDL        ,
          ABN_REFGRF        ,--commune+SECTEUR GEOGRAPHIQUE
          ABN_DT_DEB        ,--SAG_STARTDT
          ABN_DT_FIN        ,
          ABN_CTRTYPE_REF   ,--REF CONRAT TYPE
          ABN_MODEFACT      ,-- 0       0=facturation par role, 1=facturation par planning  .... "par defaut 0"
          ABN_GELER         ,-- 0       1:gel de contrat en facturation,0 Sinon
          ABN_DTGELER       ,--         date de gel de facturation                                      ---"date de fin "
          ABN_EXOTVA        ,-- 0       1: Exoneré de TVA,0 sinon
          VOC_FROZEN        ,--motif du gel [FROZEN]      ----- commentaire de gel
          VOC_TYPDURBILL    ,-- type de duree de facturation [TYPDURBILL]
          VOC_CUTAGREE      ,          
      --  drois de coupure [CUTAGREE]
          A.VOC_TYPSAG      , --M T      --  type de service (professionnel, domestique) [TYPSAG] ----- categorie abonne
          VOC_USGSAG        ,            --   Usage Res Principal, Local, Res. Secondaire [USGCAG]       --
          PRE_ID            ,
          SPT_ID            ,
          p.PAR_ID          ,
          CTT_ID            ,
          ABN_COMMENTAIRE   ,
          abn_delaip		,
          a.migabn_cr		,
          p.adr_id
   from    mig_pivot_24.miwabn A,
           mig_pivot_24.MIWTPERSONNE p 
   where  MPER_SOURCE  =ABN_SOURCE
   and    ABN_REFPER_A =MPER_REF --(+)
   and    SAG_ID is null  
   and    PAR_ID is not null  ;
 
Cursor Payeur (ABN_ID VARCHAR )
is 
  select MHPA_SOURCE        ,
         MHPA_REF_ABNT      ,
         MHPA_REF_PAYEUR    ,
         MHPA_MRIB_REF      ,
         MHPA_DDEB          ,
         MHPA_DFIN          ,
         P.PAR_ID           ,
         VOC_SETTLEMODE
  from    mig_pivot_24.MIWTHISTOPAYEUR,
          mig_pivot_24.MIWTPERSONNE  P 
  where  MHPA_REF_ABNT   = ABN_ID 
  and    MHPA_REF_PAYEUR =  MPER_REF;
   
   New_pds		  	agrserviceagr%rowtype;
   New_avgcons      AGRAVGCONSUM%rowtype;
   New_agrcust      agrcustomeragr%rowtype;
   New_Grf          agrgrpfact%rowtype;
   New_agrcu        agrcustagrcontact%rowtype;
   New_Pay          agrpayor%rowtype  ;
   New_aco          genaccount%rowtype;
   New_sagaco       agrsagaco%rowtype;
   PDSID            Number ;
   Ref_Agr          Number ;
   Agr_Id           Number ;
   Grf_Id           Number ;
   ref_Grf          Number ;
   ref_agrcu        Number ;
   Agrcust_Id       Number ;
   ref_Pay          Number ;
   PayID            Number ;
   aacid            Number ;
   New_Agrsettlement            agrsettlement%rowtype;
   Agrsettlement_Id             Number ;
   ref_Agrsettlement            Number ;
   v_aco_id         number;
   v_imp_id         number;
   v_sco_id         number;
   v_paa_id         number;
   v_hsf_id         number;
   v_grf_id         number;
   V_OFR_ID         number;
 
Procedure Genere_Abonne (Newagrcust agrcustomeragr%rowtype ,AgrId  in out 	number ,ref_Agr out number) is
BEGIN
			SELECT  CAG_ID INTO  ref_Agr 
			from    agrcustomeragr
			where   nvl(PRE_ID,0)      = nvl(Newagrcust.PRE_ID,0)		  
			and     nvl(PAR_ID,0)      = nvl(Newagrcust.PAR_ID,0)  ;
Exception
	WHEN NO_DATA_FOUND THEN
      --AgrId:=AgrId+1;
      ref_Agr:=AgrId; 
	  
			insert into agrcustomeragr (
										CAG_ID     ,
										PRE_ID     ,
										PAR_ID     ,
										CAG_REFE   ,
										CAG_STARTDT,
										CAG_ENDDT
										)
	                            values 
								       (
								        AgrId                 ,
										Newagrcust.PRE_ID     ,
										Newagrcust.PAR_ID     ,
										Newagrcust.CAG_REFE	  ,
		                                Newagrcust.CAG_STARTDT,
										Newagrcust.CAG_ENDDT
										);
end Genere_Abonne;





Procedure Genere_Agrcustagrcontact (Newagrcust Agrcustagrcontact%rowtype ,AgrcustId  in out 	number ,ref_agrcu out number) is
Rang  number ;
BEGIN
			SELECT  COT_ID INTO  ref_agrcu 
			from    Agrcustagrcontact
			where   nvl(sag_id,0)          	 = nvl(Newagrcust.sag_id,0)		  
			and     nvl(par_id,0)          	 = nvl(Newagrcust.par_id,0)
			and     nvl(cag_id,0)            = nvl(Newagrcust.cag_id,0)
			and     nvl(cot_startdt,sysdate) = nvl(Newagrcust.cot_startdt,sysdate) 
      and     vow_agrcontacttp         = Newagrcust.VOW_AGRCONTACTTP ;
Exception
	WHEN NO_DATA_FOUND THEN
      --AgrcustId:=AgrcustId+1;
	  select seq_agrcustagrcontact.nextval into AgrcustId from dual;
      ref_agrcu:=AgrcustId;
      select nvl(max(COT_RANK),0)+1 INTO  Rang 
      from 	Agrcustagrcontact 
			where  nvl(cag_id,0)  = nvl(Newagrcust.cag_id,0);		  	
      		
	insert into Agrcustagrcontact (
	                               COT_ID          ,
								   CAG_ID          ,
								   SAG_ID		   ,
								   PAR_ID          ,
								   COT_STARTDT     ,
								   COT_ENDDT       ,
								   VOW_AGRCONTACTTP,
								   COT_RANK
								  )
	                       values 
						         (
								   AgrcustId,
								   Newagrcust.CAG_ID,
								   Newagrcust.SAG_ID,
								   Newagrcust.PAR_ID,
		                           Newagrcust.COT_STARTDT,
								   Newagrcust.COT_ENDDT,
								   Newagrcust.VOW_AGRCONTACTTP,
								   Rang
								 );
end Genere_Agrcustagrcontact;




Procedure Genere_Payeur(NewPayeur agrpayor%rowtype ,PayId  in out 	number ,ref_Pay out number) is
BEGIN
			SELECT  PAY_ID INTO  ref_Pay  
			from    agrpayor
			where   nvl(COT_ID,0) = nvl(NewPayeur.COT_ID,0)  ;
Exception
	WHEN NO_DATA_FOUND THEN
      --PayId:=PayId+1;
      ref_Pay:=PayId; 
			insert into agrpayor(
								PAY_ID,
								COT_ID,
								PAA_ID 
								)
	                     values (
						         PayId,
								 NewPayeur.COT_ID,
								 NewPayeur.PAA_ID
								 );                       
end Genere_Payeur;



Procedure Genere_Groupe_Facturation (NewGrf agrgrpfact%rowtype ,GrfId  in out 	number ,ref_Grf out number) is
BEGIN
    SELECT  GRF_ID INTO  ref_Grf 
    from    agrgrpfact
    where   nvl(GRF_CODE,'*') = nvl(NewGrf.GRF_CODE,'*') ;		  
Exception
	WHEN NO_DATA_FOUND THEN
      --GrfId   :=GrfId+1;
      ref_Grf :=GrfId; 
			insert into agrgrpfact (
									GRF_ID  ,
									GRF_CODE,
									GRF_NAME
									)
	                        values (
							        GrfId		   ,
									NewGrf.GRF_CODE,
									NewGrf.GRF_NAME
									);
end Genere_Groupe_Facturation;

Procedure Genere_agrsettlement (NewAgr agrsettlement%rowtype ,AgrId  in out 	number ,ref_Agr out number) is
 BEGIN
			SELECT  stl_id INTO  ref_Agr 
			from    agrsettlement
			where   nvl(sag_id,0)          = nvl(NewAgr.sag_id ,0) 
			and     nvl(stl_startdt,null)  = nvl(NewAgr.stl_startdt ,null) 
			and     nvl(vow_settlemode,0)  = nvl(NewAgr.vow_settlemode ,0) ;
Exception
	WHEN NO_DATA_FOUND THEN
      --AgrId   := AgrId+1;
      ref_Agr := AgrId; 
	  
			insert into agrsettlement (
			                           stl_id     ,
									   sag_id     ,
									   stl_startdt,
									   vow_settlemode,
									   vow_nbbill ,
									   dlp_id
									   )
	                            values (
								        AgrId,
										NewAgr.sag_id,
										NewAgr.stl_startdt,
										NewAgr.vow_settlemode,
										NewAgr.vow_nbbill,
										NewAgr.dlp_id
										);                   
end Genere_agrsettlement;



Procedure Genere_genaccount (Newgenaccount genaccount%rowtype) is
 BEGIN
    insert into genaccount (
	                        aco_id     ,
							par_id     ,
							imp_id     ,
							vow_acotp  ,
							rec_id     ,
							aco_status ,
							ACO_COMMENT
							)
                     values(
							Newgenaccount.aco_id     ,
							Newgenaccount.par_id     ,
							Newgenaccount.imp_id     ,
							Newgenaccount.vow_acotp  ,
							Newgenaccount.rec_id     ,
							Newgenaccount.aco_status ,
							Newgenaccount.ACO_COMMENT
							) ;
		                             
end Genere_genaccount;


Procedure Genere_sagaco (Newsagaco agrsagaco%rowtype) is
 BEGIN
        insert into agrsagaco(
		                      sco_id     ,
							  sco_startdt,
							  sco_enddt  ,
							  sag_id     ,
							  aco_id
							  )
                       values(
						      Newsagaco.sco_id     ,
							  Newsagaco.sco_startdt,
							  Newsagaco.sco_enddt  ,
							  Newsagaco.sag_id     ,
							  Newsagaco.aco_id
							  );
  end Genere_sagaco;

BEGIN
  update  mig_pivot_24.MIWABN set PRE_ID =(select PRE_ID from  mig_pivot_24.miwtpdl where ABN_REFPDL = PDL_REF ) where PRE_ID  is null ;  
  update  mig_pivot_24.MIWABN set SPT_ID =(select SPT_ID from  mig_pivot_24.miwtpdl where ABN_REFPDL = PDL_REF ) where SPT_ID  is null ;
  ---- Affecte delete le payeur que ne pas le dernier
  update   mig_pivot_24.MIWABN set ABN_REFPER_A =(select MHPA_REF_PAYEUR from  mig_pivot_24.MIWTHISTOPAYEUR where MHPA_REF_ABNT = ABN_REF ) where ABN_REFPER_A  is null ; 
  update   mig_pivot_24.MIWTHISTOPAYEUR set PAR_ID  =(select PAR_ID from  mig_pivot_24.miwtpersonne where MHPA_REF_PAYEUR = MPER_REF ) where MHPA_REF_PAYEUR  is not null ; 
  update   mig_pivot_24.MIWTHISTOPAYEUR set ADR_ID  =(select ADR_ID from  mig_pivot_24.miwtpersonne where MHPA_REF_PAYEUR = MPER_REF ) where MHPA_REF_PAYEUR  is not null ;

  --select nvl(max(SAG_ID),0) into PdsId 	  from agrserviceagr;
  --select nvl(max(aac_id),0) into aacid 	  from AGRAVGCONSUM;
  --select nvl(max(CAG_ID),0) into Agr_Id 	  from agrcustomeragr;
  --select nvl(max(GRF_ID),0) into Grf_Id 	  from agrgrpfact;
  --select nvl(max(COT_ID),0) into Agrcust_Id from agrcustagrcontact;
  --select nvl(max(Pay_ID),0) into PayID      from agrpayor;

  select imp_id into v_imp_id from genimp where imp_code = 'IMP_MIG';
  select ofr_id into v_ofr_id from agroffer where ofr_code = 'OM';
  
  For Pds in Abonnement loop
    select seq_Agrsettlement.nextval  into Agrsettlement_Id  from dual;
  
  select seq_agrcustomeragr.nextval    into Agr_Id     from dual;
  --select seq_agrcustagrcontact.nextval into Agrcust_Id from dual;
  select seq_agrpayor.nextval          into PayID      from dual;
  select seq_agrgrpfact.nextval 	   into Grf_Id     from dual;
  select seq_agrserviceagr.nextval     into PdsId      from dual;
  select seq_AGRAVGCONSUM.nextval      into aacid      from dual;
    -------selection du groupe de facturation selon la tournée du pdl
    
    --------------------------------------------------------Voc ne pas traiter 
		PK_Util_Vocabulaire.Genere_voc( New_pds.VOW_FROZEN,'VOW_FROZEN',  Pds.VOC_FROZEN) ;
		PK_Util_Vocabulaire.Genere_voc( New_pds.VOW_TYPDURBILL,  'VOW_TYPDURBILL',    Pds.VOC_TYPDURBILL) ;
		PK_Util_Vocabulaire.Genere_voc( New_pds.VOW_CUTAGREE,'VOW_CUTAGREE', Pds.VOC_CUTAGREE) ;
		--PK_Util_Vocabulaire.Genere_voc( New_pds.VOW_TYPSAG,'VOW_TYPSAG', Pds.VOC_TYPSAG) ;
		PK_Util_Vocabulaire.Genere_voc( New_pds.VOW_USGSAG,'VOW_USGSAG', Pds.VOC_USGSAG) ;
		--pk_genvocword.getidbycode('VOW_AGRCONTACTTP','2',null) test
		--------------------------------------------------------Traitement Abonnement 
		--PdsId:=PdsId+1;
		New_pds.SAG_ID		   :=  PdsId ;
		New_pds.SAG_REFE       :=  Pds.abn_ref ;
		New_pds.SAG_STARTDT    :=  Pds.ABN_DT_DEB;
		New_pds.SAG_ENDDT      :=  Pds.ABN_DT_FIN ;		
		New_pds.SPT_ID         :=  Pds.SPT_ID;-----
		New_pds.CTT_ID         :=  1;--Pds.CTT_ID ;--REF CONRAT TYPE
		New_pds.SAG_FACTMODE   :=  Pds.ABN_MODEFACT;
		New_pds.SAG_FROZEN     :=  Pds.ABN_GELER;
		New_pds.SAG_EXOTVA     :=  Pds.ABN_EXOTVA;
		New_pds.SAG_COMMENT    :=  Pds.ABN_COMMENTAIRE;
		--------------------------------------------------------Traitement moyen consomation 
		--AACID:=AACID+1;
		NEW_AVGCONS.AAC_ID:=AACID;
		NEW_AVGCONS.SAG_ID:=PDSID ;
		NEW_AVGCONS.MEU_ID:=5;
		NEW_AVGCONS.AAC_AVGCONSUMMRD:=PDS.MIGABN_CR;
		if PDS.VOC_TYPSAG ='P' then
		NEW_AVGCONS.aac_avgconsumimp:=PDS.MIGABN_CR/90;
		else
		NEW_AVGCONS.aac_avgconsumimp:=PDS.MIGABN_CR/30;
		end if;
		--New_pds.SAG_FROZEN     :=  Pds.mbra_detat;
		--New_agrcust.CAG_ID
		New_agrcust.CAG_REFE:=  Pds.abn_ref ;
		--------------------------------------------------------Traitement CONTACTE(abonne) 
		New_agrcust.CAG_STARTDT := Pds.ABN_DT_DEB;
		New_agrcust.CAG_ENDDT	:= Pds.abn_dt_fin;
		New_agrcust.PRE_ID      := Pds.PRE_ID;
		New_agrcust.PAR_ID      := Pds.PAR_ID;
		Genere_Abonne (New_agrcust,Agr_Id ,Ref_Agr) ;  ---contact site 
		New_pds.CAG_ID          := Ref_Agr ;
		--commit;
		--------------------------------------------------------Traitement Grupe facturation(GRF)
    select max(rou.grf_id)
    into   v_grf_id
    from   tecservicepoint spt,
           tecroute rou
    where  spt.spt_id = Pds.spt_id
    and    spt.rou_id = rou.rou_id;
    New_pds.grf_id := v_grf_id;
    /*
		New_Grf.GRF_CODE        :=Pds.ABN_REFGRF ;
		New_Grf.GRF_NAME        :=Pds.ABN_REFGRF ;
		Genere_Groupe_Facturation(New_Grf ,Grf_Id ,ref_Grf ) ;
		New_pds.GRF_ID          := ref_Grf ;*/
		--------------------------------------------------------Insert  agrserviceagr
		Insert into agrserviceagr(
		                          sag_id      ,
								  sag_refe    ,
								  sag_startdt ,
								  sag_enddt   , 
								  cag_id      ,
								  spt_id      ,
								  grf_id	  ,
								  ctt_id	  , 
                                  sag_factmode,
								  sag_frozen  ,
								  sag_frozendt,
								  sag_exotva  ,
								  vow_frozen  ,
								  vow_typdurbill, 
                                  vow_cutagree,
								  vow_typsag  ,
								  vow_usgsag  ,
								  sag_comment ,
								  sag_credt   ,
								  sag_updtdt  ,
								  sag_updtby
								  )
		                   Values(
						          New_pds.SAG_ID      ,
								  New_pds.sag_refe    ,
								  New_pds.sag_startdt ,
								  New_pds.sag_enddt   , 
								  New_pds.cag_id      , 
								  New_pds.spt_id      ,
								  New_pds.grf_id      ,
								  New_pds.ctt_id      ,
								  New_pds.sag_factmode,
								  New_pds.sag_frozen  ,  
								  New_pds.sag_frozendt,
								  New_pds.sag_exotva  ,
								  New_pds.vow_frozen  ,
								  New_pds.vow_typdurbill,
								  New_pds.vow_cutagree,
		                          New_pds.vow_typsag  ,
								  New_pds.vow_usgsag  ,
								  New_pds.sag_comment ,
								  New_pds.sag_credt   ,
								  New_pds.sag_updtdt  ,
								  New_pds.sag_updtby
								  );
		------------------------------------------------------------------Insert consomation moyenne
		--insert into AGRAVGCONSUM(aac_id,sag_id,meu_id,aac_avgconsummrd,aac_avgconsumimp,aac_enddt,aac_credt,aac_updtdt,aac_updtby)
		--values (NEW_AVGCONS.AAC_ID,NEW_AVGCONS.AAC_ID,NEW_AVGCONS.MEU_ID,NEW_AVGCONS.AAC_AVGCONSUMMRD,NEW_AVGCONS.aac_avgconsumimp,null,  null,  null,  null);
        --------------------------------------------------------Traitement AGRCUSTAGRCONTACT(abonne) 
		New_agrcu.sag_id           := New_pds.SAG_ID ;
		New_agrcu.par_id           := Pds.PAR_ID;
		New_agrcu.cag_id           := New_pds.CAG_ID ;
		New_agrcu.cot_startdt      := New_pds.sag_startdt ;
		New_agrcu.cot_enddt        := New_pds.sag_enddt ;	
		New_agrcu.vow_agrcontacttp :=pk_genvocword.getidbycode('VOW_AGRCONTACTTP','2',null) ;	
		
		Genere_Agrcustagrcontact (New_agrcu ,Agrcust_Id ,ref_agrcu) ;	
		
		Update  mig_pivot_24.miwabn  
		set SAG_ID = New_pds.SAG_ID  
		where  ABN_REF = Pds.ABN_REF ;
        --------------------------------------------------------Traitement AGRSETTELEMENT
		New_Agrsettlement.VOW_SETTLEMODE  := pk_genvocword.getidbycode('VOW_SETTLEMODE','4',null) ;
		New_Agrsettlement.SAG_ID          := New_pds.SAG_ID ;
		New_Agrsettlement.STL_STARTDT     := New_pds.SAG_STARTDT ;
		New_Agrsettlement.STL_ENDDT       := New_pds.SAG_ENDDT ;
		New_Agrsettlement.VOW_NBBILL      := pk_genvocword.getidbycode('VOW_NBBILL','1',null) ; 
		
		--New_Agrsettlement.DLP_ID:=2;
		
		
		if Pds.VOC_TYPSAG ='G' then
		New_Agrsettlement.DLP_ID:=3;
		else 
		New_Agrsettlement.DLP_ID:=2;
	    end if;
		Genere_agrsettlement (New_Agrsettlement ,Agrsettlement_Id ,ref_Agrsettlement) ;
		
		For Pay in Payeur(Pds.ABN_REF ) loop
				--------------------------------------------------------Traitement AGRCUSTAGRCONTACT(Payeur) 
				New_agrcu.sag_id           := New_pds.SAG_ID ;
				New_agrcu.par_id       	   := Pay.PAR_ID;
				New_agrcu.cag_id           := New_pds.CAG_ID ;
				New_agrcu.cot_startdt      := Pay.MHPA_DDEB;
				New_agrcu.cot_enddt        := Pay.MHPA_DFIN;
				New_agrcu.vow_agrcontacttp := pk_genvocword.getidbycode('VOW_AGRCONTACTTP','PAY',null) ;	
				Genere_Agrcustagrcontact (New_agrcu ,Agrcust_Id ,ref_agrcu) ;	
				New_agrcu.COT_ID           := ref_agrcu ;
        --------------------------------------------------------Traitement de genpartyparty
        /*select nvl(max(paa_id),0) into v_paa_id from GENPARTYPARTY;
        v_paa_id := v_paa_id + 1;*/
		
		select seq_GENPARTYPARTY.nextval into v_paa_id from dual;
		  
        insert into GENPARTYPARTY
                     (PAA_ID		,
                      PAR_PARENT_ID ,
                      adr_id 		,
                      VOW_PARTYTP 	,
                      PAA_STARTDT	,
                      PAA_ENDDT
                      )
               values(
                      v_paa_id	 ,
                      Pds.PAR_ID ,
                      Pds.adr_id ,
                      pk_genvocword.getidbycode('VOW_PARTYTP','4',null),
                      Pay.MHPA_DDEB,
                      Pay.MHPA_DFIN
                       ) ;
				--------------------------------------------------------Traitement agrpayor(Payeur) 
				New_Pay.COT_ID := New_agrcu.COT_ID;
                New_Pay.PAA_ID := v_paa_id;
				Genere_Payeur (New_Pay ,PayID ,ref_Pay ) ;
				
				Update  mig_pivot_24.miwthistopayeur  
				set pay_id =  ref_pay 
				where  mhpa_ref_abnt = pds.abn_ref ;
        ----------------------------------------------------------------------------------
        
        -------------------------------------------------------Traitement compte client
        /*select nvl(max(aco_id),0) into v_aco_id from genaccount;
        v_aco_id := v_aco_id + 1;*/
		
		select seq_genaccount.nextval into v_aco_id from dual;
		
        New_aco.aco_id     := v_aco_id;
        New_aco.par_id 	   := Pay.PAR_ID;
        New_aco.imp_id 	   := v_imp_id;
        New_aco.ACO_STATUS := 0;
        New_aco.vow_acotp  := pk_genvocword.GetIdByCode('VOW_ACOTP','1',null);
        New_aco.ACO_COMMENT := 'Migration';
        Genere_genaccount(New_aco);
        
        /*select nvl(max(sco_id),0) into v_sco_id from agrsagaco;
        v_sco_id := v_sco_id + 1;*/
		select seq_agrsagaco.nextval into v_sco_id from dual;
		
        New_sagaco.sco_id := v_sco_id;
        New_sagaco.aco_id := v_aco_id;
        New_sagaco.sag_id := New_pds.SAG_ID;
        New_sagaco.sco_startdt := Pay.MHPA_DDEB;
        New_sagaco.sco_enddt := Pay.MHPA_DFIN;
        Genere_sagaco(New_sagaco);
        ----------------------------------------------------------------------------------
		end loop ;
    
    ---------------------------------------------------------------- Traitement de l'offre par defaut
    /*select nvl(max(hsf_id),0) into v_hsf_id from agrhsagofr;
    v_hsf_id := v_hsf_id + 1;*/
	
	 select seq_agrhsagofr.nextval into v_hsf_id from dual;
	 
    insert into agrhsagofr(
	                      hsf_id,
						  sag_id,
						  ofr_id,
						  hsf_startdt,
						  hsf_enddt
						  )
                    values(
					       v_hsf_id,
						   New_pds.SAG_ID,
						   v_ofr_id,
						   New_pds.sag_startdt,
						   New_pds.sag_enddt
						   ); 
    --------------------------------------------------------------------------------------
    
    -------------------------------------------------------------- Traitement du groupe de facturation
    
	Commit;	
end loop ;
--exception when others then dbms_output.put_line('************************************'||Ref_Agr);
end ;
/
SELECT to_char(sysdate, 'DD/MM/YY HH24:MI') heure FROM dual;
spo off;
