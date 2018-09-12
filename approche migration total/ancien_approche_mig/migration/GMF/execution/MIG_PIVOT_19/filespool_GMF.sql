set timing on ;
Spool C:\18\execution\MIG_PIVOT_19\file_gmf19.txt;
------exec create_seq;
@"C:\18\execution\MIG_PIVOT_19\01 Gmf_2Adresses.sql";
commit;
/
@"C:\18\execution\MIG_PIVOT_19\02 Gmf_3Party.sql";
commit;
/
@"C:\18\execution\MIG_PIVOT_19\03 Gmf_4Bra.sql";
commit;
/
@"C:\18\execution\MIG_PIVOT_19\04 Gmf_5Tour.sql";
commit;
/

@"C:\18\execution\MIG_PIVOT_19\05 Gmf_6Pdl_ndes.sql";
commit;
/

@"C:\18\execution\MIG_PIVOT_19\06 GMF_6TECSPTWATER.sql";
commit;
/
@"C:\18\execution\MIG_PIVOT_19\07 Gmf_7Pds_ndes.sql";
commit;
/
@"C:\18\execution\MIG_PIVOT_19\08 GMF_7PlaningAgr.sql";
commit;
/
@"C:\18\execution\MIG_PIVOT_19\09 GMF_7TECPRESPTCONTACT.SQL";
commit;
/
@"C:\18\execution\MIG_PIVOT_19\10 Gmf_8Compteur.sql";
commit;
/
@"C:\18\execution\MIG_PIVOT_19\19 Gmf_8Tecmtrcfg.sql";
commit;
/
@"C:\18\execution\MIG_PIVOT_19\11 Gmf_9Mtread_histequi.sql";
commit;
/
@"C:\18\execution\MIG_PIVOT_19\12 Gmf_9Mtread_miwtreleve.sql";
commit;
/

@"C:\18\execution\MIG_PIVOT_19\13 Gmf_9Mtread_miwtreleveTTTTTTTT.sql";
commit;
/
@"C:\18\execution\MIG_PIVOT_19\14 Gmf_9Mtread_miwtreleve_gc_1.sql";
commit;
/
@"C:\18\execution\MIG_PIVOT_19\15 Gmf_9Mtread_miwtreleve_gc.sql";
commit;
/
@"C:\18\execution\MIG_PIVOT_19\16 Gmf_20LigneFacture.sql";
commit;
/
@"C:\18\execution\MIG_PIVOT_19\17 Gmf_22RibParty.sql";
commit;
/
@"C:\18\execution\MIG_PIVOT_19\18 Gmf_23FaireSuivre.sql";
commit;
/



 Spool off;
 set timing off;