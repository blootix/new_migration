/*
spo Gmf_4Bra.lst;
SELECT to_char(sysdate, 'DD/MM/YY HH24:MI') heure FROM dual;

PROMPT *******************************************************
PROMPT *** MIGRATION  / Création Branchement *************
PROMPT ********************************************************/
SELECT to_char(sysdate, 'DD/MM/YY HH24:MI') heure FROM dual;
Declare 
  Cursor Branchement 
  is 
    select mbra_source         ,
           mbra_ref            ,
           mbra_refadr         ,
           mbra_type           ,
           mbra_etat           ,
           mbra_detat          ,
           mbra_refvocreseau   ,
           mbra_step           ,
           mbra_chateau        ,
           Voc_matbra          ,
           Voc_diabra          ,
           Voc_lgbra           ,
           a.adr_id            ,
           f.fld_id            ,
           MBRA_ETATASS        ,
           MBRA_DATEASS        ,
           MBRA_VANNEINDIV     ,
           MBRA_VANNEINNAC
     from   mig_pivot_15.miwtadr a ,
            mig_pivot_15.miwtbra p , 
           tecfluid f  
     where MBRA_REFADR = MADR_REF 
     and   fld_code    =  'PDC EAU'
     and   cnn_id is null  
     and   p.MBRA_SOURCE=a.MADR_SOURCE;
   
    New_Bra		TECCONNECTION%rowtype;
    BraId         number default 0;
    V_mbra_source varchar2(20);
begin
 --select nvl(max(cnn_id),0) into BraId from tecconnection;
  For Bra in Branchement loop
  
  select seq_TECCONNECTION.nextval into BraId  from dual ;
  
  
      --------------------------------------------------------Traitement Branchement 
      New_Bra.CNN_ID	  :=  BraId+1 ;
      New_Bra.adr_id      :=  Bra.adr_id ;
      New_Bra.CNN_REFE    :=  Bra.mbra_ref;
      New_Bra.FLD_ID      :=  Bra.fld_id ;
      New_Bra.CNN_STARTDT :=  Bra.mbra_detat;
      V_mbra_source       :=  Bra.mbra_source;
      --New_Bra.PAR_FNAME   :=   Bra.mbra_type ; 
      --New_Bra.PAR_LNAME   :=   Bra.mbra_etat ; 
      --New_Bra.PAR_CNAME   :=   Bra.mbra_etat ; 
	  
	  
      If Bra.Voc_lgbra is not null or Bra.Voc_diabra is not null or  Bra.MBRA_ETATASS is not null or Bra.MBRA_VANNEINDIV is not null then 
        select '<?xml version="1.0" encoding="ISO-8859-15"?>'||chr(10)||XMLAgg
                            (
                            XMLElement("parameters" ,
                            XMLElement("Longueur",Bra.Voc_lgbra),
                            XMLElement("NombreRoue",Bra.Voc_diabra),
                XMLElement("EtatAss",Bra.MBRA_ETATASS) ,
                XMLElement("DateAss",Bra.MBRA_DATEASS) ,
                XMLElement("VanneIndiv",Bra.MBRA_VANNEINDIV),
                XMLElement("Vaneinnac",Bra.MBRA_VANNEINNAC)
                            ))
							into New_Bra.CNN_TECHNIFO 
							from dual ;
      End if;		
          		
				
      Insert Into TECCONNECTION (
								  CNN_ID     ,
								  CNN_REFE   ,
								  ADR_ID     ,
								  FLD_ID     ,
								  CNN_STARTDT,
								  CNN_TECHNIFO
								)
                         Values(
						        New_Bra.CNN_ID      ,
						        New_Bra.CNN_REFE    ,
								nvl(New_Bra.adr_id,0)      ,
								New_Bra.FLD_ID      ,
								New_Bra.CNN_STARTDT ,
								New_Bra.CNN_TECHNIFO
								);
      
	  
	  Update  mig_pivot_15.miwtbra 
      set cnn_id = New_Bra.CNN_ID,
	      adr_id = New_Bra.adr_id,
	      FLD_ID =New_Bra.FLD_ID   
      where  mbra_ref = Bra.mbra_ref 
	  and mbra_source=V_mbra_source;
      
      --BraId:=BraId+1;
      Commit;
  end loop ;
end ;
/
--spo off;
SELECT to_char(sysdate, 'DD/MM/YY HH24:MI') heure FROM dual;