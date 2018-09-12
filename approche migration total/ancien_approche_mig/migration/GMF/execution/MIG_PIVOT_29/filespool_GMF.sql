set timing on ;
Spool C:\18\execution\MIG_PIVOT_29\file_gmf29.txt;
------exec create_seq;
@"C:\18\execution\MIG_PIVOT_29\01 Gmf_2Adresses.sql";
commit;
/
@"C:\18\execution\MIG_PIVOT_29\02 Gmf_3Party.sql";
commit;
/
@"C:\18\execution\MIG_PIVOT_29\03 Gmf_4Bra.sql";
commit;
/
@"C:\18\execution\MIG_PIVOT_29\04 Gmf_5Tour.sql";
commit;
/

@"C:\18\execution\MIG_PIVOT_29\05 Gmf_6Pdl_ndes.sql";
commit;
/

@"C:\18\execution\MIG_PIVOT_29\06 GMF_6TECSPTWATER.sql";
commit;
/
@"C:\18\execution\MIG_PIVOT_29\07 Gmf_7Pds_ndes.sql";
commit;
/
@"C:\18\execution\MIG_PIVOT_29\08 GMF_7PlaningAgr.sql";
commit;
/
@"C:\18\execution\MIG_PIVOT_29\09 GMF_7TECPRESPTCONTACT.SQL";
commit;
/
@"C:\18\execution\MIG_PIVOT_29\10 Gmf_8Compteur.sql";
commit;
/
@"C:\18\execution\MIG_PIVOT_29\19 Gmf_8Tecmtrcfg.sql";
commit;
/
@"C:\18\execution\MIG_PIVOT_29\11 Gmf_9Mtread_histequi.sql";
commit;
/
@"C:\18\execution\MIG_PIVOT_29\12 Gmf_9Mtread_miwtreleve.sql";
commit;
/

@"C:\18\execution\MIG_PIVOT_29\13 Gmf_9Mtread_miwtreleveTTTTTTTT.sql";
commit;
/
@"C:\18\execution\MIG_PIVOT_29\14 Gmf_9Mtread_miwtreleve_gc_1.sql";
commit;
/
@"C:\18\execution\MIG_PIVOT_29\15 Gmf_9Mtread_miwtreleve_gc.sql";
commit;
/
@"C:\18\execution\MIG_PIVOT_29\16 Gmf_20LigneFacture.sql";
commit;
/
@"C:\18\execution\MIG_PIVOT_29\17 Gmf_22RibParty.sql";
commit;
/
@"C:\18\execution\MIG_PIVOT_29\18 Gmf_23FaireSuivre.sql";
commit;
/



 Spool off;
 set timing off;