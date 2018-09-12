/*SPO GMF_5TOURNE.LST;
SELECT TO_CHAR(SYSDATE, 'DD/MM/YY HH24:MI') HEURE FROM DUAL;

PROMPT ****************************************************************
PROMPT *** MIGRATION  /  CREATION DES TOURNEES       ******************
PROMPT ****************************************************************

SET SERVEROUTPUT ON;*/
SELECT to_char(sysdate, 'DD/MM/YY HH24:MI') heure FROM dual;
DECLARE
CURSOR CURS_TOURNEE
 IS
   SELECT   ROU_ID        ,
      MTOU_SOURCE         ,
      MTOU_REF            ,
      MTOU_CODE           ,
      MTOU_LIBE           ,
      MTOU_SEM1           ,
      MTOU_SEM2           ,
      MTOU_SEM3           ,
      MTOU_SEM4           ,
      MTOU_SEM5           ,
      MTOU_SEM6           ,
      MTOU_SEM7           ,
      MTOU_SEM8           ,
      MTOU_SEM9           ,
      MTOU_SEM10          ,
      MTOU_SEM11          ,
      MTOU_SEM12,
      rowid
   FROM   mig_pivot_54.MIWTTOURNEE T
   where rou_id is null;
  -- WHERE NOT EXISTS  (SELECT ROU_ID FROM TECROUTE R WHERE T.ROU_ID = R.ROU_ID );
  cursor c1(district varchar2)
  is
   SELECT TR.ROU_ID,TR.ROU_CODE,T.NTIERS,T.NSIXIEME, district DISTRICT
   FROM district54.TOURNE T, TECROUTE TR
   WHERE TR.ROU_CODE=district||'-'||T.CODE; 
   
   V_MTOU_SOURCE   VARCHAR2(20);
   v_dist          VARCHAR2(2);
   V_DEBUT_ID_MIW  NUMBER;
   V_DEBUT_ID_PLAN NUMBER ;
   DATE_PLAN       DATE ;
   CS_FILTRE       INTEGER;
   ROWS_PROCESSED  INTEGER;
   CHAINE          NUMBER ;
   VAL             NUMBER ;
   v_div_id        number;
   LECURS          VARCHAR2(1500);
   V_GRF_ID AGRGRPFACT.GRF_ID %TYPE;
   

FUNCTION SEMAINE(SEM IN INTEGER) RETURN DATE
IS
  PREMIER_JEUDI_ANNEE INTEGER ;
  JOUR INTEGER;
BEGIN
	PREMIER_JEUDI_ANNEE := -1;
	JOUR := 0;
  WHILE JOUR <> 5     -- 5 OU 4 SUIVANT LA VALEUR DE JEUDI DANS VOTRE NLS
  LOOP
    PREMIER_JEUDI_ANNEE := PREMIER_JEUDI_ANNEE + 1;
    JOUR := TO_CHAR(TO_DATE('0101', 'MMDD') + PREMIER_JEUDI_ANNEE, 'D');
  END LOOP;
  RETURN TO_DATE('0101', 'MMDD')+(PREMIER_JEUDI_ANNEE  + (7 * (SEM - 2)) +4);
END SEMAINE;

BEGIN
    --UPDATE MIWTTOURNEE M
   -- SET    ROU_ID = (SELECT MAX (ROU_ID)
   -- FROM   TECROUTE
   -- WHERE  UPPER(ROU_CODE) = UPPER(M.MTOU_CODE)
  --  )WHERE  ROU_ID IS NULL ;
    
   --SELECT NVL(MAX(PRO_ID),0)+1 INTO V_DEBUT_ID_PLAN FROM TECROUTEPLAN ;
  
   
	--UPDATE MIWTTOURNEE
	--SET    ROU_ID = ROWNUM + V_DEBUT_ID_MIW
--	WHERE  ROU_ID IS NULL ;

 
   --SELECT NVL(MAX(ROU_ID),0) INTO V_DEBUT_ID_MIW FROM TECROUTE ;
   
   FOR S1 IN CURS_TOURNEE
   LOOP
     V_MTOU_SOURCE:=S1.MTOU_SOURCE;
     v_dist:=substr(V_MTOU_SOURCE,5,2);
	 
     select div_id into v_div_id from GENDIVISION where div_code=v_dist;
     --V_DEBUT_ID_MIW:=V_DEBUT_ID_MIW+1;
	 select  seq_TECROUTE.nextval into V_DEBUT_ID_MIW from dual;
       INSERT
       INTO   TECROUTE
			   (
				 ROU_ID            ,
				 ROU_SECT          ,
				 ROU_CODE          ,
				 ROU_NAME         
				)
       VALUES
			   (
				 V_DEBUT_ID_MIW           ,
				 v_div_id                 ,
				 v_dist||'-'||S1.MTOU_CODE,
				 S1.MTOU_LIBE
			   );
	   
       update  mig_pivot_54.MIWTTOURNEE 
	   set rou_id=V_DEBUT_ID_MIW 
	   where rowid=s1.rowid;
	   
       COMMIT;
    END LOOP;
		DBMS_OUTPUT.PUT_LINE('************************************');
		DBMS_OUTPUT.PUT_LINE('******* INSERTIONS TERMINEES *******');
		DBMS_OUTPUT.PUT_LINE('************************************');

-----------------------------------------------------------------------------------------------------------------------------------------------------------------
-----------------------------------------------------------------------------------------------------------------------------------------------------------------
-----------------------------------------------------------------------------------------------------------------------------------------------------------------INSERTION DANS LA TABLE TECROUTE

   FOR S1 IN c1(v_dist) LOOP
      V_GRF_ID := NULL;
    
      SELECT MAX(G.GRF_ID) INTO V_GRF_ID 
	  FROM AGRGRPFACT G 
	  WHERE G.GRF_CODE=S1.DISTRICT||S1.NTIERS||S1.NSIXIEME;
	  
      IF V_GRF_ID IS NULL THEN
        null;
      END IF;
      
      UPDATE TECROUTE 
	  SET GRF_ID=V_GRF_ID 
	  WHERE ROU_ID=S1.ROU_ID;
	  
	  
      INSERT INTO TECROUCUT(
							ROU_ID,
							RCU_THIRD,
							RCU_SIXTH
							) 
	                VALUES 
					       (
						    S1.ROU_ID,
					        S1.NTIERS,
							S1.NSIXIEME
							);
      COMMIT;
    END LOOP; 
    
END;
/	  
SELECT to_char(sysdate, 'DD/MM/YY HH24:MI') heure FROM dual;
/*
COMMIT;
SET SERVEROUTPUT OFF;
SELECT TO_CHAR(SYSDATE, 'DD/MM/YY HH24:MI') HEURE FROM DUAL;
SPO OFF;*/
