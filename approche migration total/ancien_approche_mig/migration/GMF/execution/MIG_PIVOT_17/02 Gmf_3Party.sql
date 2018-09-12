--\\192.168.1.148\Sauvegarde HP
spo Gmf_3Party.lst;
/*
PROMPT *******************************************************
PROMPT *** MIGRATION  / Initialisation         ***************
PROMPT *******************************************************
declare
  Per_Id number;
  v_vow_id number;
  Update MIWTPERSONNE set VOC_TYPSAG =1 where VOC_TYPSAG is null ;
  Update MIWTPERSONNE set VOC_PARTYTP =1 where VOC_PARTYTP is null ;
  update miwtpersonne set mper_mail  = substr(ltrim(rtrim (mper_mail)),0,50) where length(ltrim(rtrim (mper_mail))) > 55 ;

*/
SELECT to_char(sysdate, 'DD/MM/YY HH24:MI') heure FROM dual;
PROMPT *******************************************************
PROMPT *** MIGRATION  / Création des clients    ***************
PROMPT *******************************************************
SET serveroutput on;
exec DBMS_OUTPUT.ENABLE( 1000000 ) ;
Declare 
Cursor Client 
is 
  select MPER_SOURCE     ,
         MPER_REF        ,
         MPER_REFE       ,
         nvl(SUBSTR(MPER_NOM ,0,50),'-')MPER_NOM ,
         nvl(SUBSTR(MPER_PRENOM ,0,30),'-')MPER_PRENOM,
         MPER_COMPL_NOM  ,
         VOC_TITLE       ,
         MPER_REF_ADR    ,
         MPER_TEL        ,
         MPER_TEL_BUREAU ,
         MPER_FAX        ,
         MPER_TEL_MOBIL  ,
         MPER_TEL_MOBIL1 ,
         MPER_MAIL       ,
         MPER_MAIL1      ,
         VOC_TYPSAG      ,
         VOC_PARTYTP     ,
         nvl(a.ADR_ID,0) adr_id        ,
         MPER_COMMENT
   from   mig_pivot_17.miwtadr a ,
          mig_pivot_17.miwtpersonne p
   where MPER_REF_ADR = MADR_REF 
   and   PAR_ID is null 
   and   mper_refe is not null 
   and   a.madr_source = p.MPER_SOURCE
   and p.MPER_REFE not in (select PAR_REFE from genparty);
 
 New_Per		genparty%rowtype;
 Per_Id         number default 0;
 v_ref_per      number ;
 v_MPER_SOURCE  varchar2(20);
 
 
Procedure Genere_Personne (NewPer genparty%rowtype ,PerId  in out 	number ,ref_per out number) is
BEGIN
	SELECT  PAR_ID INTO  ref_per from genparty
		where nvl(PAR_FNAME,'*')   = nvl(NewPer.PAR_FNAME,'*')
		  and nvl(PAR_REFE,'*')    = nvl(NewPer.PAR_REFE,'*')
		  and nvl(PAR_FNAME,'*')   = nvl(NewPer.PAR_FNAME,'*')
		  and nvl(PAR_LNAME,'*' )  = nvl(NewPer.PAR_LNAME,'*')
		  and nvl(PAR_CNAME,'*')   = nvl(NewPer.PAR_CNAME,'*') 
		  and nvl(PAR_KNAME,'*')   = nvl(NewPer.PAR_KNAME,'*') 
		  and nvl(PAR_TELW,'*')    = nvl(NewPer.PAR_TELW,'*') 
		  and nvl(PAR_TELP,'*')    = nvl(NewPer.PAR_TELP,'*') 
		  and nvl(PAR_TELF,'*')    = nvl(NewPer.PAR_TELF,'*') 
		  and nvl(PAR_EMAIL,'*')   = nvl(NewPer.PAR_EMAIL,'*') 
		  and nvl(ADR_ID,'0')      = nvl(NewPer.ADR_ID,'0')  ;
Exception
	WHEN NO_DATA_FOUND THEN
	            --NewVil.TWN_ID:= Vil_Id + 1;
				--PerId:=PerId+1;
				ref_per:=PerId; 
		insert into genparty (
							PAR_ID     ,
							ADR_ID     ,
							PAR_REFE   , 
							PAR_FNAME  , 
							PAR_LNAME  , 
							PAR_CNAME  ,
							PAR_KNAME  ,
							PAR_TELW   ,
							PAR_TELP   ,
							PAR_TELF   ,
							PAR_EMAIL  ,
							VOW_PARTYTP,
							VOW_TITLE  ,
							VOW_TYPSAG ,
							PAR_INFO   ,
							PAR_TELM 
							)
		            values (
					        PerId             ,
							NewPer.ADR_ID     ,
							NewPer.PAR_REFE   ,
							NewPer.PAR_FNAME  ,
							NewPer.PAR_LNAME  ,
							NewPer.PAR_CNAME  ,
							NewPer.PAR_KNAME  ,
							NewPer.PAR_TELW   ,
							NewPer.PAR_TELP   ,
							NewPer.PAR_TELF   ,
							NewPer.PAR_EMAIL  ,
							NewPer.VOW_PARTYTP,
							NewPer.VOW_TITLE  ,
							NewPer.VOW_TYPSAG ,
							NewPer.PAR_INFO   ,
							New_Per.PAR_TELM 
							);		 
end Genere_Personne;


begin
  Update  mig_pivot_17.MIWTPERSONNE set VOC_TYPSAG =1  where VOC_TYPSAG is null ;
  Update  mig_pivot_17.MIWTPERSONNE set VOC_PARTYTP =1 where VOC_PARTYTP is null ;
  update  mig_pivot_17.miwtpersonne 
          set mper_mail  = substr(ltrim(rtrim (mper_mail)),0,50) 
          where length(ltrim(rtrim (mper_mail))) > 55 ;
  
  --select nvl(max(PAR_ID),0) into Per_Id from genparty;
  
  For Per in Client loop
  
  select seq_genparty.nextval into Per_Id  from dual ;
    --------------------------------------------------------Voc ne pas traiter 
    PK_Util_Vocabulaire.Genere_voc( New_Per.VOW_TYPSAG,'VOW_TYPSAG',Per.VOC_TYPSAG) ;
    PK_Util_Vocabulaire.Genere_voc( New_Per.VOW_TITLE,'VOW_TITLE',Per.VOC_TITLE) ;
    PK_Util_Vocabulaire.Genere_voc( New_Per.VOW_PARTYTP,'VOW_PARTYTP',Per.VOC_PARTYTP) ;
    
    --------------------------------------------------------Traitement Personne
    New_Per.PAR_REFE    :=   Per.MPER_REFE;
    New_Per.PAR_FNAME   :=   null;--Per.MPER_PRENOM ; 
    New_Per.PAR_LNAME   :=   Per.MPER_NOM  ; 
    New_Per.PAR_CNAME   :=   Per.MPER_COMPL_NOM ; 
    New_Per.PAR_KNAME   :=   replace(Per.MPER_NOM,' ',null);--PK_Util_Adresse.Compacter(Per.MPER_NOM||Per.MPER_PRENOM||Per.MPER_COMPL_NOM);--nom compacte Adr. 
    New_Per.PAR_TELW    :=   Per.MPER_TEL_BUREAU ;  
    New_Per.PAR_TELM    :=   Per.MPER_TEL_MOBIL ;  
    New_Per.PAR_TELP    :=   Per.MPER_TEL ;  
    New_Per.PAR_TELF    :=   Per.MPER_FAX ;  
    New_Per.PAR_EMAIL   :=   Per.MPER_MAIL ;  
    New_Per.ADR_ID      :=   Per.ADR_ID ;  
    New_Per.PAR_INFO    :=   Per.MPER_COMMENT ;  
    v_MPER_SOURCE       :=   Per.MPER_SOURCE;
    Genere_Personne(New_Per ,Per_Id ,v_ref_per ) ;

    Update  mig_pivot_17.miwtpersonne set PAR_ID= v_ref_per ,ADR_ID =Per.ADR_ID ,
									  VOW_ID_TYPSAG   = New_Per.VOW_TYPSAG ,
									  VOW_ID_TITLE    = New_Per.VOW_TITLE  ,
									  VOW_ID_PARTYTP  = New_Per.VOW_PARTYTP
								  where  MPER_REF = Per.MPER_REF
								  and    MPER_SOURCE=v_MPER_SOURCE;
     Commit;	
  end loop ;
end ;
/
SELECT to_char(sysdate, 'DD/MM/YY HH24:MI') heure FROM dual;
spo off;
