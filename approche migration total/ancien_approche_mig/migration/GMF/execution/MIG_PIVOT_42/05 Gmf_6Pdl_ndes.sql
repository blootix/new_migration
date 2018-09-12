                /*spo Gmf_6Pdl_ndes.lst;
SELECT to_char(sysdate, 'DD/MM/YY HH24:MI') heure FROM dual;
update  miwtpdl t  set PDL_TOUORDRE  = substr(PDL_TOUORDRE,0,5) where length(ltrim(rtrim (PDL_TOUORDRE))) > 5 ;
PROMPT *******************************************************
PROMPT *** MIGRATION  / Initialisation PointLivraison ********
PROMPT ********************************************************/
SELECT to_char(sysdate, 'DD/MM/YY HH24:MI') heure FROM dual;
update   mig_pivot_42.miwtpdl set VOC_PREMISETP ='MA' where VOC_PREMISETP is null ;
--Update miwtpdl set 
--tecpresptcontact
/*PROMPT *******************************************************
PROMPT *** MIGRATION  / Création PointLivraison *************
PROMPT *******************************************************
SET serveroutput on;*/
Declare 
  Cursor PointLivraison is 
  select PDL_source         ,
         PDL_ref            ,
         PDL_refbra         ,
         PDL_refadr         ,
         PDL_reftou         ,
         PDL_refpde_pere    ,-- ref du pere
         PDL_type           ,-- I ou D : decompteur Indicatif ou Deductif
         PDL_touordre       ,
         PDL_REFSITE        ,
         VOC_DIFFREAD       ,--Y                Liste des Vocabulaires état de relève (Difficulté de relève, plaque de fonte, Egout...)     
         VOC_ACCESS         ,--Y                Liste des vocabulaire Accessibilité (Jardin, Limite propriété ...)                          
         VOC_READINFO1      ,--Y                Liste des Vocabulaires Inforamation 1 sur relève                                            
         VOC_READINFO2      ,--Y                Liste des Vocabulaires Inforamation 2 sur relève                                            
         VOC_READINFO3      ,--Y                Liste des Vocabulaires Inforamation 3 sur relève                                            
         PDL_REFFLD         ,--                 Identifiant de table TECFLUID      
         PDL_SECTEUR_1      ,
         PDL_SECTEUR_2      ,
         PDL_SECTEUR_3      ,
         PDL_SECTEUR_4      ,
         PDL_SECTEUR_5      ,
         decode(nvl(PDL_etat,0),0,1,2) PDL_ETAT, -- O F S
         PDL_detat          , 
         VOC_METHDEP        ,
         PDL_comment        ,
         a.adr_id           ,
         nvl(a.TWN_ID,1364239) TWN_ID          ,
         f.fld_id           ,
         t.rou_id           ,
         VOC_PREMISETP		,
		 p.PDL_DFERMETURE 
   from   mig_pivot_42.miwtadr a,
          mig_pivot_42.miwtpdl p, 
          mig_pivot_42.miwttournee t, 
         tecfluid f  
   where MADR_SOURCE  = PDL_SOURCE
   and   PDL_refadr   = MADR_REF 
   and   p.pdl_source = t.mtou_source
   and   mtou_ref (+) = PDL_reftou 
   and   fld_code     = PDL_REFFLD
   and   SPT_ID   is null ;
   
    New_pdl		    tecservicepoint%rowtype;
	New_site	    tecpremise%rowtype;
	New_divspt      gendivspt%rowtype;
	New_division    gendivision%rowtype ;
	v_ref_site      number ;
	PdlId           number default 0;
	Site_Id         number default 0;
	Type_sec1       number ;
    Type_sec2       number ;
	Type_sec3       number ;
    Type_sec4       number ;
	divspt_id       number ;
	New_gendvtstr	gendvtstr%rowtype;
	gendvtstr_Id    Number ;
    ref_gendvtstr   Number ;
	New_tecspstatus	tecspstatus%rowtype;
	tecspstatus_Id  Number ;
    ref_tecspstatus Number ;
    V_PDL_source    Varchar2(20);
    v_org_id        number;
    v_spo_id        number;
 
 
Procedure Genere_Site (Newsite tecpremise%rowtype ,SiteId  in out 	number ,ref_site out number) is
 
 BEGIN
    SELECT  PRE_ID INTO  ref_site 
    from    tecpremise
    where   nvl(PRE_REFE,'*') = nvl(Newsite.PRE_REFE,'*');		  
Exception
	WHEN NO_DATA_FOUND THEN
      --SiteId:=SiteId+1;
      ref_site:=SiteId; 
	  
			insert into tecpremise (
									PRE_ID       ,
									PRE_REFE     ,
									ADR_ID       ,
									VOW_PREMISETP,
			                        PRE_COMMENT  ,
									PRE_YEAR     ,
									PRE_SURFACE  ,
									PRE_CREDT
								   )
	                        values
							       (
									SiteId               ,
									Newsite.PRE_REFE     ,
									nvl(Newsite.ADR_ID,0)		 ,
									Newsite.VOW_PREMISETP,
		                            Newsite.PRE_COMMENT  ,
									Newsite.PRE_YEAR	 ,
									Newsite.PRE_SURFACE  ,
									Newsite.PRE_CREDT
									);
end Genere_Site;

Procedure Genere_Type_secteur(TypeNom Varchar2,Nom Varchar2,Ref_DIT_ID in out number  ) is
 BEGIN
			SELECT  DIT_ID 
			INTO    ref_DIT_ID 
			from    gendivisiontype
			where   upper(nvl(DIT_CODE,'*'))   = nvl(TypeNom,'*')	;	 
      
		  update gendivisiontype set DIT_NAME = Nom where DIT_ID = ref_DIT_ID ;
Exception
	WHEN NO_DATA_FOUND THEN
			select nvl(max(DIT_ID),0)+ 1 into Ref_DIT_ID from GENDIVISIONTYPE ;
			
			insert into GENDIVISIONTYPE (
										DIT_ID  ,
										DIT_CODE,
										DIT_NAME,
										DIT_CREDT
										) 
			                     values
								       (
								        Ref_DIT_ID,
										TypeNom   ,
										Nom       ,
										sysdate
										);	  
								 
end Genere_Type_secteur;


Procedure Genere_Secteur (Newsec gendivision%rowtype,Id_type number ,DVTID out number) is
SecId number ;

BEGIN
   Begin
        SELECT DIV_ID INTO  SecId
        from   GENDIVISION
        where upper(nvl(DIV_CODE,'*'))  =  upper(nvl(Newsec.DIV_CODE,'*')) ;
   Exception
   WHEN NO_DATA_FOUND THEN
      --select nvl(max(DIV_ID),0)+1  into SecId from GENDIVISION ;
      --select nvl(max(DVT_ID),0)+1  INTO DVTID  from GENDIVDIT ;
	  
	   select   seq_GENDIVISION.nextval into SecId from dual;
	   select   seq_GENDIVDIT.nextval   into DVTID from dual;
	  
	  
      insert into GENDIVISION (
								DIV_ID,
								DIV_CODE,
								DIV_NAME
							  )
                        values
					          (
								SecId,
								Newsec.DIV_CODE,
								Newsec.DIV_NAME
							  );
					   
      insert into GENDIVDIT (
							 DVT_ID,
							 DIV_ID,
							 DIT_ID
							 )
                       values 
					        (
							 DVTID,
							 SecId,
							 Id_type
							 ) ;
   end ;
   
   select max(DVT_ID) into DVTID 
   from GENDIVDIT
   where   DIV_ID = SecId
   AND     DIT_ID = Id_type ;
   if nvl(DVTID,0) = 0 then
    --select nvl(max(DVT_ID),0)+1  INTO DVTID  from GENDIVDIT ;
	 select   seq_GENDIVDIT.nextval into DVTID from dual;
	 
           insert into GENDIVDIT (
									DVT_ID,
									DIV_ID,
									DIT_ID
								 )
                         values 
						       (
						        DVTID,
								SecId,
								Id_type
								);
   end if ;
   
end Genere_Secteur;



Procedure Genere_gendvtstr (Newgendvtstr gendvtstr%rowtype ,gendvtstrId  in out 	number ,ref_gendvtstr out number) is
 BEGIN
  SELECT  dvr_id INTO  ref_gendvtstr 
  from    gendvtstr
  where   nvl(dvt_id,0)      = nvl(Newgendvtstr.dvt_id,0)		  
  and     nvl(twn_id,0)      = nvl(Newgendvtstr.twn_id,0)  ;
Exception
	WHEN NO_DATA_FOUND THEN
				--gendvtstrId   :=gendvtstrId+1;
				ref_gendvtstr :=gendvtstrId; 
				
			insert into gendvtstr (
									dvr_id,
									dvt_id,
									twn_id
								  )
	                       values 
						          (
						           gendvtstrId,
								   Newgendvtstr.dvt_id,
								   Newgendvtstr.twn_id
								   );
end Genere_gendvtstr;

begin
  --select nvl(max(SPT_ID),0) into PdlId from tecservicepoint;
  --select nvl(max(PRE_ID),0) into Site_Id from tecpremise;
  --select nvl(max(DPR_ID),0) into divspt_id from gendivspt;
  --select nvl(max(dvr_id),0) into gendvtstr_Id from gendvtstr;
  --select nvl(max(SPS_ID),0) into tecspstatus_Id from tecspstatus;

  --DBMS_OUTPUT.ENABLE( 1000000 ) ;

  For Pdl in PointLivraison loop
  
  select   seq_tecservicepoint.nextval into PdlId from dual;
  select   seq_tecpremise.nextval      into Site_Id from dual;
  select   seq_gendivspt.nextval       into divspt_id from dual;
  select   seq_gendvtstr.nextval       into gendvtstr_Id from dual;
  select   seq_tecspstatus.nextval     into tecspstatus_Id from dual;
	  
  
    New_pdl:= null;
    New_tecspstatus := null;
    --------------------------------------------------------Voc ne pas traiter 
		PK_Util_Vocabulaire.Genere_voc( New_pdl.VOW_DIFFREAD  ,'VOW_DIFFREAD' , Pdl.VOC_DIFFREAD) ;
		PK_Util_Vocabulaire.Genere_voc( New_pdl.VOW_ACCESS    ,'VOW_ACCESS'   ,Pdl.VOC_ACCESS) ;
		PK_Util_Vocabulaire.Genere_voc( New_pdl.VOW_READINFO1 ,'VOW_READINFO1',Pdl.VOC_READINFO1) ;
		PK_Util_Vocabulaire.Genere_voc( New_pdl.VOW_READINFO2 ,'VOW_READINFO2',Pdl.VOC_READINFO2) ;
		PK_Util_Vocabulaire.Genere_voc( New_pdl.VOW_READINFO3 ,'VOW_READINFO3',Pdl.VOC_READINFO3) ;
		PK_Util_Vocabulaire.Genere_voc( New_site.VOW_PREMISETP,'VOW_PREMISETP',Pdl.VOC_PREMISETP) ;
		--PK_Util_Vocabulaire.Genere_voc( ,'VOW_PARTYTP',Per.VOC_METHDEP) ;  voir david 
        --------------------------------------------------------Traitement SIte
		--New_site.PRE_REFE     :=  Pdl.PDL_REF;		
		New_site.PRE_REFE       :=  Pdl.PDL_REFSITE;
		New_site.ADR_ID         :=  Pdl.adr_id ;
		 
		Genere_Site (New_site ,Site_Id,v_ref_site ) ;
		
		--------------------------------------------------------Traitement Branchement 
		New_pdl.SPT_ID		   :=  PdlId;--PdlId+1 ;
		New_pdl.adr_id         :=  Pdl.adr_id ;
		New_pdl.SPT_REFE       :=  Pdl.PDL_REF;
		New_pdl.ROU_ID         :=  Pdl.rou_id ;
		New_pdl.FLD_ID         :=  Pdl.fld_id ;
		New_pdl.SPT_ROUTEORDER :=  Pdl.PDL_touordre;
		New_pdl.SPT_COMMENT	   :=  Pdl.PDL_comment ;
		New_pdl.SPT_NEEDRDV    :=  0;
		New_pdl.PRE_ID         :=  v_ref_site ;
		New_pdl.SPT_CREDT      :=  Pdl.PDL_detat ;
		--New_Bra.PAR_FNAME   :=   Bra.mbra_type ; 
		--New_Bra.PAR_LNAME   :=   Bra.mbra_etat ; 
		--New_Bra.PAR_CNAME   :=   Bra.mbra_etat ; 
		
		
		
		Insert Into tecservicepoint (
									SPT_ID        ,
									SPT_REFE      ,
									ROU_ID        ,
									SPT_ROUTEORDER,
									SPT_COMMENT   ,
									SPT_NEEDRDV   ,
		                            VOW_DIFFREAD  ,
									VOW_ACCESS    ,
									VOW_READINFO1 ,
									VOW_READINFO2 ,
									VOW_READINFO3 ,
									FLD_ID        ,
									PRE_ID        ,
									ADR_ID        ,
									SPT_CREDT
									) 
		                    Values 
							       (
									New_pdl.SPT_ID        ,
									New_pdl.SPT_REFE      ,
									New_pdl.ROU_ID        ,
									New_pdl.SPT_ROUTEORDER,
									New_pdl.SPT_COMMENT	  ,
									New_pdl.SPT_NEEDRDV	  ,
		                            New_pdl.VOW_DIFFREAD  ,
									New_pdl.VOW_ACCESS    ,
									New_pdl.VOW_READINFO1 ,
									New_pdl.VOW_READINFO2 ,
									New_pdl.VOW_READINFO3 ,
									New_pdl.FLD_ID        ,
									New_pdl.PRE_ID        ,
									nvl(New_pdl.ADR_ID,0)        ,
									New_pdl.SPT_CREDT
									) ;
									
		--Update miwtpdl set cnn_id = New_Bra.CNN_ID,adr_id = New_Bra.adr_id ,FLD_ID =New_Bra.FLD_ID   
		--where  mbra_ref = Bra.mbra_ref;
		
		New_tecspstatus.SPS_ID        := tecspstatus_Id ;--tecspstatus_Id+1;
		New_tecspstatus.SPT_ID        := New_pdl.SPT_ID ;
		New_tecspstatus.VOW_SPSTATUS  := pk_genvocword.getidbycode('VOW_SPSTATUS',Pdl.PDL_ETAT,null) ;	
		New_tecspstatus.SPS_STARTDT   := Pdl.PDL_detat ;
		New_tecspstatus.sps_enddt     := Pdl.PDL_DFERMETURE ;
		
		if pdl.PDL_DFERMETURE is not null then 
		New_tecspstatus.VOW_SPSTATUS  := pk_genvocword.getidbycode('VOW_SPSTATUS',1,null) ;	
	   Insert Into tecspstatus (
								 SPS_ID        ,  
								 SPT_ID        ,
								 VOW_SPSTATUS  ,
								 SPS_STARTDT   ,
								 sps_enddt
								)
							Values
								(
								 New_tecspstatus.SPS_ID       ,
								 New_tecspstatus.SPT_ID       ,
								 New_tecspstatus.VOW_SPSTATUS , 
								 New_tecspstatus.SPS_STARTDT  ,
								 New_tecspstatus.sps_enddt 
								);	
	New_tecspstatus.VOW_SPSTATUS := pk_genvocword.getidbycode('VOW_SPSTATUS',2,null) ;	
	
	select seq_tecspstatus.nextval into tecspstatus_Id from dual;
 New_tecspstatus.SPS_ID  :=tecspstatus_Id;
	 --select nvl(max(SPS_ID),0) into tecspstatus_Id from tecspstatus;
	 --New_tecspstatus.SPS_ID       := tecspstatus_Id+1 ;
	   Insert Into tecspstatus (
						         SPS_ID       ,  
								 SPT_ID       ,
								 VOW_SPSTATUS ,
								 SPS_STARTDT
								 )
								 Values
								 (
								 New_tecspstatus.SPS_ID       ,
								 New_tecspstatus.SPT_ID       ,
								 New_tecspstatus.VOW_SPSTATUS , 
								 New_tecspstatus.sps_enddt 
								 ) ;		
								 
				 else
		New_tecspstatus.VOW_SPSTATUS  := pk_genvocword.getidbycode('VOW_SPSTATUS',1,null) ;	
	   Insert Into tecspstatus (
							     SPS_ID        ,  
								 SPT_ID        ,
								 VOW_SPSTATUS  ,
								 SPS_STARTDT
								)
						Values
								(
								 New_tecspstatus.SPS_ID       ,
								 New_tecspstatus.SPT_ID       ,
								 New_tecspstatus.VOW_SPSTATUS , 
								 New_tecspstatus.SPS_STARTDT
								);
			end if;
								  
		--------------------------------------------------------Traitement Secteur
		if Pdl.PDL_SECTEUR_1 is not null then 
      New_divspt.DPR_ID     := divspt_id ;--divspt_id+1 ;
      New_divspt.SPT_ID     := New_pdl.SPT_ID ;
      New_division.DIV_NAME := Pdl.PDL_SECTEUR_1 ;
      New_division.DIV_CODE := Pdl.PDL_SECTEUR_1 ;
      Genere_Secteur (New_division  ,1 ,New_divspt.DVT_ID);
	  
          Insert into gendivspt(   
								 DPR_ID,
								 DVT_ID,
								 SPT_ID
								)
                         values
						       (
								New_divspt.DPR_ID,
								New_divspt.DVT_ID,
								New_divspt.SPT_ID 
								);
	  
	  
      --divspt_id :=  divspt_id +1;	
  		
      New_gendvtstr.DVT_ID :=New_divspt.DVT_ID ;
      New_gendvtstr.TWN_ID :=Pdl.TWN_ID ;
      Genere_gendvtstr (New_gendvtstr ,gendvtstr_Id ,ref_gendvtstr) ;
      
      --HKH : 19/09/2017 : Ajouter l'organisation qui a le code du secteur 1
      select max(org_id)
      into   v_org_id
      from   genorganization 
      where  org_code = Pdl.PDL_SECTEUR_1;
      if v_org_id is not null then
        /*select nvl(max(spo.spo_id),0) into v_spo_id from tecsptorg spo;
        v_spo_id := v_spo_id + 1;*/
		
		 select seq_tecsptorg.nextval into v_spo_id from dual;
		 
        insert into tecsptorg(
							 spo_id,
							 spt_id,
							 org_id,
							 spo_comment
							 )
                       values
					        (
					         v_spo_id,
							 New_pdl.SPT_ID,
							 v_org_id,
							 'Migration'
							 );
      end if;
      --------------------------------------------------------------------------
		end if;
		
	 if Pdl.PDL_SECTEUR_2 is not null then 
      New_divspt.DPR_ID :=  divspt_id  ;--divspt_id+1 ;
      New_divspt.SPT_ID :=  New_pdl.SPT_ID ;
      New_division.DIV_CODE :=Pdl.PDL_SECTEUR_2 ;
      New_division.DIV_NAME :=Pdl.PDL_SECTEUR_2 ;
      Genere_Secteur (New_division  ,Type_sec2 ,New_divspt.DVT_ID);
	  
            Insert into gendivspt(
								  DPR_ID,
								  DVT_ID,
								  SPT_ID
								 )
                           values
						         (
						          New_divspt.DPR_ID,
								  New_divspt.DVT_ID,
								  New_divspt.SPT_ID 
								  );
      --divspt_id :=  divspt_id +1;
  		
      New_gendvtstr.DVT_ID :=New_divspt.DVT_ID ;
      New_gendvtstr.TWN_ID :=Pdl.TWN_ID ;
      Genere_gendvtstr (New_gendvtstr ,gendvtstr_Id ,ref_gendvtstr) ;
	  
	 end if;
		
    if Pdl.PDL_SECTEUR_3 is not null then 
      New_divspt.DPR_ID     :=divspt_id;--divspt_id+1 ;
      New_divspt.SPT_ID     :=New_pdl.SPT_ID;
      New_division.DIV_CODE :=Pdl.PDL_SECTEUR_3 ;
      New_division.DIV_NAME :=Pdl.PDL_SECTEUR_3 ;
      Genere_Secteur (New_division,Type_sec3 ,New_divspt.DVT_ID);
	   
	       Insert into gendivspt(
								  DPR_ID,
								  DVT_ID,
								  SPT_ID
								 )
                           values
						         (
						          New_divspt.DPR_ID,
								  New_divspt.DVT_ID,
								  New_divspt.SPT_ID 
								  );
	  
	  
	  
	  
	  
      --divspt_id :=  divspt_id +1;
  		
      New_gendvtstr.DVT_ID :=New_divspt.DVT_ID ;
      New_gendvtstr.TWN_ID :=Pdl.TWN_ID ;
      Genere_gendvtstr (New_gendvtstr ,gendvtstr_Id ,ref_gendvtstr) ;
		end if;
		
        
		if Pdl.PDL_SECTEUR_4 is not null then 
      New_divspt.DPR_ID :=  divspt_id  ;--divspt_id+1 ;
      New_divspt.SPT_ID :=  New_pdl.SPT_ID ;
      New_division.DIV_CODE :=Pdl.PDL_SECTEUR_4 ;
      New_division.DIV_NAME :=Pdl.PDL_SECTEUR_4 ;
      Genere_Secteur (New_division  ,Type_sec4 ,New_divspt.DVT_ID);
       	  
	  Insert into gendivspt(
							DPR_ID,
							DVT_ID,
							SPT_ID
							)
                    values
					       (
					         New_divspt.DPR_ID,
					         New_divspt.DVT_ID,
							 New_divspt.SPT_ID 
						   );
      --divspt_id :=  divspt_id +1;
  		
      New_gendvtstr.DVT_ID :=New_divspt.DVT_ID ;
      New_gendvtstr.TWN_ID :=Pdl.TWN_ID ;
      Genere_gendvtstr (New_gendvtstr,gendvtstr_Id ,ref_gendvtstr) ;
		end if;
		
    V_PDL_source:=pdl.PDL_source;
	
			update	 mig_pivot_42.miwtpdl 
			set SPT_ID =  New_pdl.SPT_ID ,
				  PRE_ID = New_pdl.PRE_ID  
			where PDL_REF = pdl.PDL_REF 
			and PDL_source=pdl.PDL_source;	
	
		--PdlId:=PdlId+1;
		--tecspstatus_Id := tecspstatus_Id+1 ;
    Commit;
 end loop ;
 /*
 dbms_output.put_line('************************************');
 dbms_output.put_line('******* INSERTIONS TERMINEES *******'||Type_sec1);
 dbms_output.put_line('************************************');
 */
end ;
/
/*
prompt *******************************************************************
prompt **** MIGRATION  / Création des Pere Fils  Par defauls fils*********
prompt *******************************************************************
*/
Declare
  V_debut_id Number ;
  
  cursor c1
  is
    SELECT V_debut_id , p1.SPT_ID,nvl(p2.SPT_ID,p1.SPT_ID) pere,d.vow_id ,p1.PDL_DETAT
    FROM    mig_pivot_42.miwtpdl p1,
            mig_pivot_42.miwtpdl p2 ,
           genvoc t ,
           genvocword d
     WHERE p1.PDL_REFPDE_PERE = p2.PDL_REF --(+)
     and   voc_code    = 'VOW_SPTTYPE'
     and   t.voc_id    = d.voc_id
     and   d.vow_code  =nvl(p1.PDL_type,'I') 
     and   p1.SPT_ID is not null ;--- verif parametrage avec david            
Begin
  for s1 in c1 loop
    --select nvl(max(SPH_ID),0) into V_debut_id from tecspthier ;
    --V_debut_id := V_debut_id + 1;
	
	select   seq_tecspthier.nextval into V_debut_id from dual;
	
    insert into tecspthier
			   (
				  SPH_ID       ,
				  SPT_CHILD_ID ,
				  SPT_PARENT_ID,
				  VOW_SPTTYPE  ,
				  SPH_STARTDT
				)
			Values
				(
				  V_debut_id,
				  s1.SPT_ID ,
				  s1.pere	,
				  s1.vow_id	,
				  s1.PDL_DETAT
				);
	  
   
   COMMIT;
  end loop;
  
end ;
/
/*
prompt *******************************************************************
prompt **** MIGRATION  / Création de liason PDL /BRA**********************
prompt *******************************************************************
*/
Declare
   v_hcs_id Number ;
  v_count Number ;
  cursor c1 
  is
     SELECT pdl.SPT_ID,Bra.CNN_ID,pdl.PDL_DETAT
     FROM    mig_pivot_42.miwtpdl Pdl,
             mig_pivot_42.miwtbra Bra
     WHERE  pdl.PDL_REFBRA = Bra.MBRA_REF 
     and    Pdl.SPT_ID is not null  ;
Begin
  for s1 in c1 loop
    --select nvl(max(HCS_ID),0) into V_debut_id from TECHCONSPT ;
    --V_debut_id := V_debut_id + 1;
	
	select   seq_TECHCONSPT.nextval into v_hcs_id from dual;
	  
	select count(*) into v_count 
	from TECHCONSPT t 
	where t.spt_id=s1.spt_id
	and t.CON_ID=s1.cnn_id
	and trunc (t.HCS_STARTDT)=trunc(s1.PDL_DETAT) ;
	  
	if (v_count = 0) then 
		insert into TECHCONSPT
					(
					  HCS_ID ,
					  SPT_ID ,
					  CON_ID ,
					  HCS_STARTDT
					)
				values
					( 
					  v_hcs_id,
					  s1.spt_id ,
					  s1.CNN_ID	,
					  s1.PDL_DETAT
					);
	end if;
    COMMIT ;
  end loop;
end ;
/
SELECT to_char(sysdate, 'DD/MM/YY HH24:MI') heure FROM dual;
/*
SELECT to_char(sysdate, 'DD/MM/YY HH24:MI') heure FROM dual;
spo off;*/


