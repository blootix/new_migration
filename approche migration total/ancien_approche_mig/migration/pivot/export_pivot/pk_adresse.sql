CREATE OR REPLACE PACKAGE BODY miwtADRESSEPIVOT IS


  --********************************************************************--
  --         MIGRATIONS DES VILLES ET RUES
  --********************************************************************--
  PROCEDURE MIG_ADR(V_ADRESSE_   IN VARCHAR2,
                    V_AD_VILRUE_ IN NUMBER,
                    V_CODE_POSTAL_ IN VARCHAR2,
                    v_district IN VARCHAR2,
                    V_AD_NUM_    IN OUT NUMBER) IS
    V_MSG        VARCHAR2(800);
  V_NOM_VIL    VARCHAR2(500);
      err_code        varchar2(200);
  err_msg         varchar2(200);
  BEGIN
     V_NOM_VIL := NULL;
         FOR POSTAL_ IN (SELECT A.LIBELLE FROM R_CPOSTAL A WHERE TO_CHAR(A.KCPOST) = TRIM(V_CODE_POSTAL_)) LOOP
           V_NOM_VIL := POSTAL_.LIBELLE;
         END LOOP;
     IF V_AD_VILRUE_ IS NOT NULL THEN
       BEGIN
         if V_NOM_VIL is null then V_NOM_VIL:=0000; end if;
         select SEQ_MIWTADR.Nextval into V_AD_NUM_ from dual;
         INSERT INTO MIWTADR
              (
                MADR_SOURCE,--   VARCHAR2(100) NOT NULL,
                MADR_REF,--      VARCHAR2(100) NOT NULL,
                MADR_REFRUE,--   VARCHAR2(100),
                MADR_NRUE,--     VARCHAR2(8),
                MADR_IRUE,--     VARCHAR2(10),
                MADR_RUE1,--     VARCHAR2(200),
                MADR_RUE2,--     VARCHAR2(200),
                MADR_VILL,--     VARCHAR2(200),
                MADR_VILC,--     VARCHAR2(200),
                MADR_CPOS,--     VARCHAR2(5),
                MADR_BPOS,--     VARCHAR2(200),
                MADR_PAYS,--     VARCHAR2(200),
                MADR_BATI,--     VARCHAR2(200),
                MADR_ESCA,--     VARCHAR2(200),
                MADR_ETAG,--     VARCHAR2(200),
                MADR_APPT,--     VARCHAR2(200),
                MADR_SEQ,--      VARCHAR2(200),
                MADR_GPSX,--     NUMBER,
                MADR_GPSY,--     NUMBER,
                MADR_GPSZ,--     NUMBER,
                MADR_VILINSEE,-- VARCHAR2(5),
                MADR_RUEINSEE,-- VARCHAR2(5),
                LIV,--           VARCHAR2(100),
                FAC,--           VARCHAR2(100),
                BRANCH--         VARCHAR2(100)
              )
         VALUES(      'DIST'||v_district,
              V_AD_NUM_,                         -- AD_NUM  NUMBER(10)  N      IDENTIFIANT DE L'ADRESSE POUR LA MIGRATION
              NULL,                              --MADR_REFRUE   VARCHAR2(100),
              NULL,                              --MADR_NRUE     VARCHAR2(8),
              NULL,                              --MADR_IRUE     VARCHAR2(10),
              V_ADRESSE_,                        --MADR_RUE1     VARCHAR2(200),
              NULL,                              --MADR_RUE2     VARCHAR2(200),
              V_NOM_VIL,               --MADR_VILL     VARCHAR2(200),
              NULL,                              --MADR_VILC     VARCHAR2(200),
              V_CODE_POSTAL_,                    --MADR_CPOS     VARCHAR2(5),
              NULL,                              --MADR_BPOS     VARCHAR2(200),
              'TUNISIE',                          --MADR_PAYS     VARCHAR2(200),
              NULL,                              --MADR_BATI     VARCHAR2(200),
              NULL,                              --MADR_ESCA     VARCHAR2(200),
              NULL,                              --MADR_ETAG     VARCHAR2(200),
              NULL,                              --MADR_APPT     VARCHAR2(200),
              NULL,                              --MADR_SEQ      VARCHAR2(200),
              NULL,                              --MADR_GPSX     NUMBER,
              NULL,                              --MADR_GPSY     NUMBER,
              NULL,                              --MADR_GPSZ     NUMBER,
              NULL,                              --MADR_VILINSEE VARCHAR2(5),
              NULL,                              --MADR_RUEINSEE VARCHAR2(5),
              NULL,                              --LIV           VARCHAR2(100),
              NULL,                              --FAC           VARCHAR2(100),
              NULL                              --BRANCH        VARCHAR2(100)
              );
               COMMIT;
exception
          when others then
            err_code := SQLCODE;
            err_msg  := SUBSTR(SQLERRM, 1, 200);
            insert into prob_migration
              (nom_table, val_ref, sql_err, date_pro)
            values
              (1,
               1,
               err_code || '--' || err_msg,
               sysdate);

        end;
     ELSE
       V_AD_NUM_ := NULL;
     END IF;
     commit;
  END;
  END miwtADRESSEPIVOT;

