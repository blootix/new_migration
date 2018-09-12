spo Gmf_2Adresses.lst;
SELECT to_char(sysdate, 'DD/MM/YY HH24:MI') heure FROM dual;
--delete from genadress ;
--delete from genstreet ;
--delete from gentown ;
--delete from gendistrict;

	Drop table NDES_COMPARE_COMMUNE;
	create table NDES_COMPARE_COMMUNE
	(
	  CP          VARCHAR2(100),
	  NOM_COMMUNE VARCHAR2(100),
	  ROWIDX      NUMBER
	);
	
-- Create table
drop table UTIL_ADRESSE_TRACE;

	create table UTIL_ADRESSE_TRACE
	(
	  TXT VARCHAR2(4000),
	  NUM NUMBER(10)
	);
Drop table UTIL_ADRESSE1 ;
-- Create table
	create table UTIL_ADRESSE1
	(
	  CODE_COMMUNE  VARCHAR2(50),
	  CODE_BRANCH   VARCHAR2(50),
	  CODE_ABONNE   VARCHAR2(50),
	  NOM_ABONNE    VARCHAR2(50),
	  PRENOM_ABONNE VARCHAR2(50),
	  LIEU_DESSERVI VARCHAR2(500),
	  PST_INSEE     VARCHAR2(50),
	  PST_NOMCOM    VARCHAR2(50),
	  INVERSE       VARCHAR2(500),
	  COMPACTE      VARCHAR2(500),
	  NUMERO        NUMBER(10),
	  RUE           VARCHAR2(500),
	  SEQUENCE      VARCHAR2(10),
	  CPLTADR       VARCHAR2(500),
	  ROWIDX        NUMBER(10)
	);

	DROP TABLE UTIL_ADRESSE;
	
	CREATE TABLE UTIL_ADRESSE(
	  CODE_COMMUNE   VARCHAR2(50),
	  CODE_BRANCH    VARCHAR2(50),
	  CODE_ABONNE    VARCHAR2(50),
	  NOM_ABONNE     VARCHAR2(50),
	  PRENOM_ABONNE  VARCHAR2(50),
	  LIEU_DESSERVI  VARCHAR2(500),
	  PST_INSEE      VARCHAR2(50),
	  PST_NOMCOM     VARCHAR2(50),
	  INVERSE        VARCHAR2(500),
	  COMPACTE       VARCHAR2(500),
	  NUMERO         NUMBER(10),
	  RUE            VARCHAR2(500),
	  SEQUENCE       VARCHAR2(10),
	  CPLTADR        VARCHAR2(500),
	  ROWIDX         NUMBER(10)
	);
	
CREATE INDEX NDES_ADRESSEIDX1 on UTIL_ADRESSE(PST_NOMCOM);
 
CREATE OR REPLACE PACKAGE PK_Util_Adresse
is
FUNCTION Compacter
  (
  p_chaine IN varchar2
  )
return varchar2;

FUNCTION Inverser
  (
  p_chaine IN varchar2
  )
return varchar2;

FUNCTION semblable
  (
  mot1 IN varchar2,
  mot2 IN varchar2
  )
  return integer;

FUNCTION Rue_Numero   (p_texte varchar2) return varchar2;
FUNCTION Rue_Sequence (p_texte varchar2) return varchar2;
FUNCTION Rue_Rue      (p_texte varchar2) return varchar2;
PROCEDURE lfic        (p_txt varchar2);

PROCEDURE Bilan_Rue
  (
  p_ville    varchar2,
  p_finesse  integer
  );

 PROCEDURE Bilan_Commune
  (
  p_ville      varchar2,
  p_finesse  integer
  );

end PK_Util_Adresse;
/
CREATE OR REPLACE PACKAGE BODY PK_Util_Adresse
AS
  v_pk_nl number(10);
PROCEDURE lfic
  (
  p_txt varchar2
  )
IS
begin
   insert into UTIL_ADRESSE_TRACE values (p_txt, v_pk_nl);
   v_pk_nl := v_pk_nl + 1;
end lfic;
----------------------------------------------------------------------------------
FUNCTION Compacter
  (
  p_chaine IN varchar2
  )
return varchar2
IS
  w_car      varchar2(1);
  car_ok     varchar2(36) := 'ABCDEFGHIJKLMNOPQRSTUVWXYZ1234567890';
  w_chaine   varchar2(2000);
  s_chaine   varchar2(2000);
  i         integer;
begin
  if p_chaine is null then return null; end if;

  s_chaine := NULL;
  -- Passe en majuscules
  w_chaine := upper(p_chaine);

  -- Remplace les caracteres accentués
  w_chaine := translate(w_chaine, upper('àâ??çèéêë?îï???ôùûü'),'AAAACEEEEIIINOOOUUU');

  -- Ne garde que les caracteres de 0 à 9 et de A à Z
  FOR i IN 1..length(w_chaine)
  loop
    w_car := substr(w_chaine,i,1);
    if instr(car_ok,w_car) != 0
    then
      s_chaine := s_chaine || w_car;
    end if;
  end loop;

  -- Renvoie la chaine compatctée ou - si la chaine était vide
  return nvl(s_chaine, '-');

end Compacter;
----------------------------------------------------------------------------------
FUNCTION Inverser
  (
  p_chaine IN varchar2
  )
return varchar2
IS
  article1 varchar2(15)  := 'D''#L''';
  article2 varchar2(15)  := 'DE # DU ';
  article3 varchar2(15)  := 'DES ';
  article4 varchar2(15)  := 'DE L''';
  article5 varchar2(15)  := 'DE LA ';
  wtype2   varchar2(50)  := 'BD #PL #SQ #PO #CR #CI #CO #FG #AV #BL #LE #LA ';
  wtype3   varchar2(200) := 'ALL #AVE #BRD #LES #IMP #DME #PCE #RLE #RTE #RUE #SQU #SQR #GAL #ILE #CHS #PAS #CHE #ECL #LDT #LOT #POR #ESP #QUA ';
  wtype4   varchar2(200) := 'CHEM #COUR #CLOS #PASS #QUAI #SENT #VOIE #ESPL #FAUB #ZONE ';
  wtype5   varchar2(50)  := 'ALLEE #PLACE #ROUTE #SENTE #VILLA #COURS ';
  wtype6   varchar2(50)  := 'AVENUE #CHEMIN #RUELLE #SQUARE ';
  wtype7   varchar2(50)  := 'IMPASSE #PASSAGE #SENTIER ';
  wtype9   varchar2(50)  := 'BOULEVARD ';
  w_mot    varchar2(15);
  w_lib    varchar2(500);
begin
  w_lib := upper(p_chaine);
  if instr(wtype9, substr(w_lib,1, 10)) > 0
  then
    w_mot := substr(w_lib,1, 10);
  elsif instr(wtype7, substr(w_lib,1, 8)) > 0
  then
    w_mot := substr(w_lib,1, 8);
  elsif instr(wtype6, substr(w_lib,1, 7)) > 0
  then
    w_mot := substr(w_lib,1, 7);
  elsif instr(wtype5, substr(w_lib,1, 6)) > 0
  then
    w_mot := substr(w_lib,1, 6);
  elsif instr(wtype4, substr(w_lib,1, 5)) > 0
  then
    w_mot := substr(w_lib,1, 5);
  elsif instr(wtype3, substr(w_lib,1, 4)) > 0
  then
    w_mot := substr(w_lib,1, 4);
  elsif instr(wtype2, substr(w_lib,1, 3)) > 0
  then
    w_mot := substr(w_lib,1, 3);
  end if;

  if length(w_mot) > 0
  then
    w_lib := ltrim(rtrim(substr(w_lib, length(w_mot) + 1))) || ' ' || rtrim(ltrim(w_mot));
    w_mot := '';
    if instr(article5, substr(w_lib,1, 6)) > 0
    then
      w_mot := substr(w_lib,1, 6);
    elsif instr(article4, substr(w_lib,1, 5)) > 0
    then
      w_mot := substr(w_lib,1, 5);
    elsif instr(article3, substr(w_lib,1, 4)) > 0
    then
      w_mot := substr(w_lib,1, 4);
    elsif instr(article2, substr(w_lib,1, 3)) > 0
    then
      w_mot := substr(w_lib,1, 3);
    elsif instr(article1, substr(w_lib,1, 2)) > 0
    then
      w_mot := substr(w_lib,1, 2);
    end if;

    if length(w_mot) > 0
    then
      w_lib := ltrim(rtrim(substr(w_lib, length(w_mot) + 1))) || ' ' || rtrim(ltrim(w_mot));
    end if;

  end if;
  return w_lib;
end Inverser;
----------------------------------------------------------------------------------
FUNCTION semblable
  (
  mot1 IN varchar2,
  mot2 IN varchar2
  )
  return integer
IS
  petit_mot       VARCHAR2(100);
  grand_mot       VARCHAR2(100);
  semblable       boolean;
  i               integer;
  lmax            integer;
  position_depart integer;
  trouve          integer;
  total           integer;
  coeff_semblable number(5,2);
begin
   petit_mot := mot1;
   grand_mot := mot2;
   if length(mot1) > length(mot2)
   then
     petit_mot := mot2;
     grand_mot := mot1;
   end if;
   lmax := length(petit_mot);
   i         := 1;
   total     := 0;
   semblable := true;
   while semblable AND i<lmax
   loop
     i:=i+1;
     position_depart := 0;
     trouve := 0;
     while position_depart <= lmax-i
     loop
       position_depart := position_depart + 1;
       -- if instr(grand_mot,substr(petit_mot,position_depart,i)) > 0 then total := total + i; end if;
       trouve := trouve + instr(grand_mot,substr(petit_mot,position_depart,i));
     end loop;
     if trouve > 0
     then
        semblable := true;
     else
        semblable := false;
     end if;
   end loop;
   if NOT semblable
   then
      i:=i-1;
   end if;
   if i=1
   then
     i:=0;
   end if;
   -- coeff_semblable := (i/lmax)*100*(length(petit_mot)/length(grand_mot));
   if instr(grand_mot,petit_mot)>0
   then
     coeff_semblable := 100;
   else
     coeff_semblable := ((i/length(petit_mot))+(i/length(grand_mot)))*50;
   end if;
   return coeff_semblable;
end semblable;
----------------------------------------------------------------------------------
FUNCTION Rue_Numero (p_texte varchar2) return varchar2
is
  v_texte   varchar2(2000);
  v_Numero  number(10);
  v_NumeroC varchar2(10);
  i         number;
begin
  v_texte := trim(p_texte);
  for i in 1..length(p_texte)
  loop
    if trim(translate(substr(v_texte,i,1),'0123456789','         ')) is null
    then
      v_NumeroC := v_NumeroC||substr(v_texte,i,1);
    else
      exit;
    end if;
  end loop;
  v_Numero := to_number(V_NumeroC);
  return v_NumeroC;
exception
  when others then return -1;
end Rue_Numero;
----------------------------------------------------------------------------------
FUNCTION Rue_Sequence (p_texte varchar2) return varchar2
is
  v_texte1   varchar2(2000) := 'BIS#TER#QUATER#A#B#C#D#E#F#G#H#I#J#K#L#M#N#O#P#Q#R#S#T#U#V#W#X#Y#Z#';
  v_texte    varchar2(2000);
  v_Numero   varchar2(10);
  v_Sequence varchar2(10);
  i          number;
begin
  v_texte  := trim(p_texte);
  v_Numero := Rue_Numero(v_texte);
  if v_Numero is not null
  then
  dbms_output.put_line('N°'||v_numero);
    v_texte := trim(substr(v_texte, length(v_Numero)+1));
    for i in 1..length(p_texte)
    loop
      if trim(translate(substr(v_texte,i,1),'0123456789','         ')) is not null
      then
        v_Sequence := v_Sequence||substr(v_texte,i,1);
      else
        exit;
      end if;
    end loop;
  end if;
  dbms_output.put_line('Sequence'||v_Sequence);

  --si la chaine n'est pas reconnue en temps que séquence on nullifie
  if instr(v_texte1, v_sequence||'#') = 0
  then
    v_Sequence := null;
  end if;
  return v_Sequence;

exception
  when others then return null;
end Rue_Sequence;
----------------------------------------------------------------------------------
FUNCTION Rue_Rue (p_texte varchar2) return varchar2
is
  v_texte    varchar2(2000);
  v_Numero   varchar2(10);
  v_Sequence varchar2(10);
  i          number;
  v_txtpivot varchar2(2000);
begin
  v_texte    := trim(p_texte);
  v_Numero   := Rue_Numero(v_texte);
  v_Sequence := Rue_Sequence(v_texte);
  v_txtpivot := NVL(v_Sequence, v_Numero);
  if v_txtpivot is not null
  then
    v_texte := substr(v_texte, instr(v_texte, v_txtpivot));
    i       := instr(v_texte, ' ');
    v_texte := substr(v_texte,i+1);
  end if;

  return trim(v_texte);
end;
--------------------------------------
PROCEDURE Bilan_Rue
  (
  p_ville      varchar2,
  p_finesse  integer
  )
is
  p_texte      varchar2(4000);
  v_un         number;
  i            number;
  j            number;


  CURSOR c0
  IS
    SELECT *
    FROM   util_adresse1
    WHERE  pst_nomcom = NVL(p_ville, pst_nomcom)
    order by rowidx
    ;

  CURSOR c1
    (
    p_rue_nomcompacte varchar2,
    p_ville           varchar2,
    p_idx             number
    )
  IS
    SELECT *
    FROM   util_adresse1
    WHERE  1=1
    AND    pst_nomcom = p_ville
    AND    semblable(compacte,p_rue_nomcompacte) > p_finesse
    AND    rowidx     > p_idx
    ORDER BY rowidx
    ;
  TYPE Tab_Util_Adresse IS TABLE OF util_adresse%ROWTYPE INDEX BY BINARY_INTEGER;
  T0 Tab_Util_Adresse;

BEGIN
  v_pk_nl := 1;
  --Initialisation du tableau
  for s0 in c0
  loop
    T0(s0.rowidx) := s0;
  end loop;
  lfic(';Commune;Branchement/Abonné;Lieu Desservi;INSEE;Commune;Idx ');
  i    := T0.first;
  while i is not null
  --for i in T0.first..T0.last
  loop
    v_un := 0;
    for s1 in c1(T0(i).compacte, T0(i).pst_nomcom, T0(i).rowidx)
    loop
      if v_un=0
      then
        lfic(' ');
        p_texte:= 'Traitement de ;'||T0(i).code_commune||';'||NVL(T0(i).code_branch,T0(i).code_abonne||' '||T0(i).nom_abonne)||';'||T0(i).lieu_desservi||';'||T0(i).pst_insee||';'||T0(i).PST_NOMCOM||';'||T0(i).rowidx;
        lfic (p_texte);
        v_un := 1;
      end if;
      p_texte:= '  Semblable ;'||s1.code_commune||';'||NVL(s1.code_branch,s1.code_abonne||' '||s1.nom_abonne)||';'||s1.lieu_desservi||';'||s1.pst_insee||';'||s1.PST_NOMCOM||';'||s1.rowidx;
      lfic( p_texte);
      delete from util_adresse1 where rowidx=s1.rowidx;
      T0.DELETE(s1.rowidx);
    end loop;
    if T0(i).compacte is null
    then
      lfic('Vide pour ;'||T0(i).code_commune||';'||NVL(T0(i).code_branch,T0(i).code_abonne||' '||T0(i).nom_abonne)||';'||T0(i).lieu_desservi||';'||T0(i).pst_insee||';'||T0(i).PST_NOMCOM||';'||T0(i).rowidx);
    end if;
    T0.DELETE(i);
    i := T0.first;
  end loop;

END Bilan_Rue;

PROCEDURE Bilan_Commune
  (
  p_ville      varchar2,
  p_finesse  integer
  )
is
  p_texte      varchar2(4000);
  v_un         number;
  i            number;
  j            number;


  CURSOR c0
  IS
    SELECT *
    FROM   NDES_COMPARE_COMMUNE
    WHERE  CP = NVL(p_ville, CP)
    order by rowidx    ;

  CURSOR c1
    (
    p_rue_nomcompacte varchar2,
    p_ville           varchar2,
    p_idx             number
    )
  IS
    SELECT *
    FROM   NDES_COMPARE_COMMUNE
    WHERE  1=1
    AND    CP = p_ville
    AND    PK_Util_Adresse.semblable(Compacter(nom_commune),Compacter(p_rue_nomcompacte)) > p_finesse
    AND    rowidx     > p_idx
    ORDER BY rowidx
    ;
  TYPE Tab_Util_Adresse IS TABLE OF NDES_COMPARE_COMMUNE%ROWTYPE INDEX BY BINARY_INTEGER;
  T0 Tab_Util_Adresse;

BEGIN
  v_pk_nl := 1;
  --Initialisation du tableau
  for s0 in c0
  loop
    T0(s0.rowidx) := s0;
  end loop;


  i    := T0.first;
  while i is not null loop
    PK_Util_Adresse.lfic(' ');
    p_texte:= 'Traitement de ;'||T0(i).CP||';'||T0(i).nom_commune;
    PK_Util_Adresse.lfic (p_texte);
    v_un := 0;
    for s1 in c1(T0(i).nom_commune, T0(i).CP, T0(i).rowidx)
    loop
     /* if v_un=0
      then
        PK_Util_Adresse.lfic(' ');
        p_texte:= 'Traitement de ;'||T0(i).CP||';'||T0(i).nom_commune;
        PK_Util_Adresse.lfic (p_texte);
        v_un := 1;
      end if;
      */
     -- p_texte:= '  Semblable ;'||s1.nom_commune||';'||s1.cp;
      p_texte:= s1.nom_commune;
     -- p_texte:= '  Semblable ;'||T0(i).CP||';'||T0(i).nom_commune||';'||s1.rowidx;
      PK_Util_Adresse.lfic( p_texte);
      delete from NDES_COMPARE_COMMUNE where rowidx=s1.rowidx;
      T0.DELETE(s1.rowidx);


    end loop;
       -- if T0(i).nom_commune is not  null then
       --   T0.delete(T0(i).rowidx) ;
       --     i := T0.first;
       --     end if;
    if T0(i).nom_commune is null
    then
      PK_Util_Adresse.lfic('Vide pour ;'||T0(i).CP);
    end if;
     delete from NDES_COMPARE_COMMUNE where rowidx=i;
    T0.DELETE(i);
    i := T0.first;
  end loop;

END Bilan_Commune;
--------------------------------------------------------------------------------
end PK_Util_Adresse;
/


PROMPT *******************************************************
PROMPT *** MIGRATION  / Création des villes    ***************
PROMPT *******************************************************
SET serveroutput on;
exec DBMS_OUTPUT.ENABLE( 1000000 ) ;
Declare 
Cursor Adresse is 
select 
  madr_source    ,
  madr_ref       ,
  madr_refrue    ,
  madr_nrue      ,
  madr_irue      ,
  substr(madr_rue1,0,50)madr_rue1      ,
  substr(madr_rue2,0,50)madr_rue2      ,
  madr_vill      ,
  madr_vilc      ,
  nvl(madr_cpos,0)  madr_cpos    ,
  madr_bpos      ,
  madr_pays      ,
  madr_bati      ,
  madr_esca      ,
  madr_etag      ,
  madr_appt      ,
  MADR_SEQ       ,
  madr_gpsx      ,
  madr_gpsy      ,
  madr_gpsz      ,
  madr_vilinsee  ,
  madr_rueinsee  ,
  LIV            ,
  Fac            ,
  branch		 ,
  null cite      ,
  null impasse   ,
  null resid  
 from mig_pivot_14.miwtadr  
 where ADR_ID is null 
and madr_ref>0;

 v_madr_source varchar2(20);
 New_Adr 		genadress%rowtype;
 New_Rue 		genstreet%rowtype;
 New_Vil 		gentown%rowtype;
 New_Qart       gendistrict%rowtype;
 Vil_Id         number default 0;
 Rue_Id         number default 0;
 Adr_Id         number default 0;
 DIS_Id         number default 0;
 v_ref_rue      number ;
 v_ref_vil      number ;
 v_ref_qart     number ;
 v_ref_adr      number ;
 
 
Procedure Genere_Ville(NewVil gentown%rowtype ,Vil_Id  in out 	number, ref_vil out  number) is

 BEGIN
	SELECT  TWN_ID INTO  ref_vil from gentown
		where 
		nvl(TWN_ZIPCODE,'0000') = nvl(NewVil.TWN_ZIPCODE,'0000') ;

Exception
  WHEN TOO_MANY_ROWS  THEN 
       SELECT  max(TWN_ID) INTO  ref_vil 
	   from gentown 
	   where   nvl(TWN_NAMEK,'*') = nvl(NewVil.TWN_NAMEK,'*') ;
  WHEN NO_DATA_FOUND THEN
    --Vil_Id:=Vil_Id+1;
    ref_vil:=Vil_Id ;
		insert into gentown (
							TWN_ID     , 
							TWN_CODE   ,
							TWN_NAME   ,
							TWN_NAMEK  ,
							TWN_NAMER  , 
							TWN_ZIPCODE,
							COY_ID     ,
							TWN_SERVED
							)
					values (
					        Vil_Id               ,
							NewVil.TWN_CODE      ,
							nvl(NewVil.TWN_NAME,NewVil.TWN_CODE),
							nvl(NewVil.TWN_NAMEK,NewVil.TWN_CODE),
							nvl(NewVil.TWN_NAMER,NewVil.TWN_CODE),
							NewVil.TWN_ZIPCODE   ,
							1					 ,
							1
							);
end Genere_Ville;



Procedure Genere_Rue(NewRue genstreet%rowtype ,Rue_Id  in out 	number ,ref_rue out number) is

 BEGIN
	SELECT  STR_ID INTO  ref_rue from genstreet
		where nvl(STR_NAMEK,'*') = nvl(NewRue.STR_NAMEK,'*')
		and   nvl(TWN_ID,6 ) = nvl(NewRue.TWN_ID,6) ;
Exception
	WHEN NO_DATA_FOUND THEN
    --Rue_Id:=Rue_Id+1;
    ref_rue:=Rue_Id; 
	
		insert into genstreet(
								STR_ID     ,
								TWN_ID     ,
								STR_CODE   ,
								STR_NAME   ,
							    STR_NAMEK  ,
								STR_NAMER  ,
								STR_ZIPCODE,
								STR_SERVED
							 )
		              values (
								Rue_Id,
								nvl(NewRue.TWN_ID,6),
								NewRue.STR_CODE,
								NewRue.STR_NAME,
								NewRue.STR_NAMEK,
								NewRue.STR_NAMER,
								NewRue.STR_ZIPCODE,
								1
								);
end Genere_Rue;



------------------------------------------------------------------------------------------------------------------------------------------------------
-------------------------------GENDISTRICT(Mise a jour des quartiers)-----------------------------------------------------------------
------------------------------------------------------------------------------------------------------------------------------------------------------
Procedure Genere_Quartier(NewQart gendistrict%rowtype ,DIS_Id  in out 	number ,ref_quartier out number) is

 BEGIN
	SELECT  DIS_ID INTO  ref_quartier from gendistrict
		where nvl(DIS_NAME,'*') = nvl(NewQart.DIS_NAME,'*');

Exception
	WHEN NO_DATA_FOUND THEN
    --Dis_Id:=Dis_Id+1;
    ref_quartier:=Dis_Id; 
		insert into gendistrict (
								DIS_ID ,
								DIS_CODE ,
								DIS_NAME
								)
					     values (
						         Dis_Id,
							     Dis_Id,
							     NewQart.DIS_NAME
							    );
		
		
end Genere_Quartier;



Procedure Genere_Adresse (NewAdr genadress%rowtype ,AdrId  in out 	number ,ref_adr out number) is
 BEGIN
	SELECT  ADR_ID INTO  ref_adr from genadress
		where nvl(ADR_NUMBER,'*')= nvl(NewAdr.ADR_NUMBER,'*')
		and nvl(ADR_CNAME,'*')   = nvl(NewAdr.ADR_CNAME,'*')
		and nvl(ADR_SEQ,'*' )    = nvl(NewAdr.ADR_SEQ,'*')
		and nvl(ADR_FLOOR,'*' )  = nvl(NewAdr.ADR_FLOOR,'*')
		and nvl(ADR_APPT,'*')    = nvl(NewAdr.ADR_APPT,'*') 
		and nvl(ADR_BUILDING,'*')= nvl(NewAdr.ADR_BUILDING,'*') 
		and nvl(ADR_STAIRS,'*')  = nvl(NewAdr.ADR_STAIRS,'*') 
		and nvl(ADR_POSTBOX,'*') = nvl(NewAdr.ADR_POSTBOX,'*') 
		and nvl(ADR_ZIPCODE,'*') = nvl(NewAdr.ADR_ZIPCODE,'*') 
		and nvl(STR_ID,0)        = nvl(NewAdr.STR_ID,0)  ;

Exception
	WHEN NO_DATA_FOUND THEN
    --AdrId:=AdrId+1;
    ref_adr:=AdrId; 
	
	
		insert into genadress (
		                       ADR_ID      ,
							   STR_ID      ,
							   ADR_NUMBER  ,
							   ADR_CNAME   ,
							   ADR_SEQ     ,
							   ADR_APPT    ,
							   ADR_BUILDING,
							   ADR_STAIRS  ,
							   ADR_POSTBOX ,
							   ADR_ZIPCODE ,
							   ADR_FLOOR
							   )
		                values (
						        AdrId			   ,
								NewAdr.STR_ID	   ,
								NewAdr.ADR_NUMBER  ,
								NewAdr.ADR_CNAME   ,
								NewAdr.ADR_SEQ     ,
								NewAdr.ADR_APPT    ,
								NewAdr.ADR_BUILDING,
								NewAdr.ADR_STAIRS  ,
								NewAdr.ADR_POSTBOX ,
								NewAdr.ADR_ZIPCODE ,
								NewAdr.ADR_FLOOR
								);
				 
				 
end Genere_Adresse;




begin
  --select nvl(max(TWN_ID),0) into Vil_Id from gentown;
  --select nvl(max(STR_ID),0) into Rue_Id from genstreet;
  --select nvl(max(ADR_ID),0) into Adr_Id from genadress;
  --select nvl(max(DIS_Id),0) into DIS_Id from gendistrict;
  
  For Adr in Adresse loop
  
  select  seq_gentown.nextval   into Vil_Id from dual ;
  select  seq_genstreet.nextval   into Rue_Id from dual ;
  select seq_gendistrict.nextval  into DIS_Id from dual ;
  select seq_genadress.nextval    into Adr_Id from dual ;
  
  v_madr_source:=adr.madr_source;
  New_Vil := null;
  New_Rue := null;
  New_Adr := null;
  New_Qart:= null;
  --------------------------------------------------------Traitement ville
  New_Vil.TWN_CODE    := Adr.madr_vilinsee;
  New_Vil.TWN_NAME    := Adr.madr_vill;
  New_Vil.TWN_NAMEK   := Adr.madr_vill ; --PK_Util_Adresse.Compacter(Adr.madr_vill);--nom compacte
  New_Vil.TWN_NAMER   := Adr.madr_vill ; -- PK_Util_Adresse.Inverser(Adr.madr_vill);--Nom inverse
  New_Vil.TWN_ZIPCODE := Adr.MADR_CPOS ;

  Genere_Ville(New_Vil ,Vil_Id  ,v_ref_vil) ;
  --------------------------------------------------------Traitement quartier
  New_Qart.dis_name := nvl(Adr.madr_vill,'-');
  Genere_Quartier(New_Qart,DIS_Id,v_ref_qart);
  --------------------------------------------------------Traitement Rues
  New_Rue.STR_CODE    := Adr.MADR_RUEINSEE;
  New_Rue.STR_NAME    := substr(Adr.MADR_RUE1||' '||Adr.MADR_RUE2||' '||Adr.impasse,1,50) ; 
  New_Rue.STR_NAMEK   := substr(Adr.MADR_RUE1||' '||Adr.MADR_RUE2||' '||Adr.impasse,1,50)   ;--PK_Util_Adresse.Compacter(Adr.MADR_RUE1);--nom compacte Adr. 
  New_Rue.STR_NAMER   := substr(Adr.MADR_RUE1||' '||Adr.MADR_RUE2||' '||Adr.impasse,1,50) ;---PK_Util_Adresse.Inverser(Adr.MADR_RUE1);--nom compacte Adr. 
  New_Rue.STR_ZIPCODE := Adr.MADR_CPOS ;
  New_Rue.TWN_ID      := nvl(v_ref_vil,6);
  New_Rue.DIS_ID      := v_ref_qart;
  Genere_Rue(New_Rue ,Rue_Id ,v_ref_rue ) ;
  --DBMS_OUTPUT.PUT_LINE( 'code'||v_ref_rue) ;
  --------------------------------------------------------Traitement Adresse
  New_Adr.ADR_NUMBER   := Adr.MADR_NRUE;
  New_Adr.ADR_CNAME    := Adr.branch ; 
  --New_Adr.ADR_SEQ    :=   Adr.MADR_SEQ  ; 
  New_Adr.ADR_FLOOR    := Adr.MADR_ETAG ; 
  New_Adr.ADR_APPT     := Adr.MADR_APPT ;  
  --New_Adr.ADR_BUILDING :=   Adr.MADR_BATI||'-'||adr.resid ;  
  New_Adr.ADR_STAIRS   := Adr.MADR_ESCA ;  
  New_Adr.ADR_POSTBOX  := Adr.MADR_BPOS ;  
  New_Adr.ADR_ZIPCODE  := Adr.MADR_CPOS ;  
  New_Adr.STR_ID       := v_ref_rue ;  

  Genere_Adresse(New_Adr ,Adr_Id ,v_ref_adr ) ;
  --DBMS_OUTPUT.PUT_LINE( 'code'||v_ref_rue) ;

  Update mig_pivot_14.miwtadr a set a.TWN_ID =nvl(v_ref_vil,6) ,
							   a.STR_ID =v_ref_rue ,
							   a.ADR_ID =v_ref_adr,
							   a.dis_id=v_ref_qart 
                           where  a.madr_ref = Adr.madr_ref 
						   and a.madr_source=v_madr_source;
Commit;
end loop ;

--exception when others then DBMS_OUTPUT.PUT_LINE( sqlerrm) ; 
end ;
/
SELECT to_char(sysdate, 'DD/MM/YY HH24:MI') heure FROM dual;
spo off;
