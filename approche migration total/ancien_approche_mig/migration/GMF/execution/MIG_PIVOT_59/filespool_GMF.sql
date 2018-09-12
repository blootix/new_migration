set timing on ;
Spool C:\18\execution\MIG_PIVOT_59\file_gmf59.txt;
------exec create_seq;
@"C:\18\execution\MIG_PIVOT_59\01 Gmf_2Adresses.sql";
commit;
/
@"C:\18\execution\MIG_PIVOT_59\02 Gmf_3Party.sql";
commit;
/
@"C:\18\execution\MIG_PIVOT_59\03 Gmf_4Bra.sql";
commit;
/
@"C:\18\execution\MIG_PIVOT_59\04 Gmf_5Tour.sql";
commit;
/

@"C:\18\execution\MIG_PIVOT_59\05 Gmf_6Pdl_ndes.sql";
commit;
/

@"C:\18\execution\MIG_PIVOT_59\06 GMF_6TECSPTWATER.sql";
commit;
/
@"C:\18\execution\MIG_PIVOT_59\07 Gmf_7Pds_ndes.sql";
commit;
/
@"C:\18\execution\MIG_PIVOT_59\08 GMF_7PlaningAgr.sql";
commit;
/
@"C:\18\execution\MIG_PIVOT_59\09 GMF_7TECPRESPTCONTACT.SQL";
commit;
/
@"C:\18\execution\MIG_PIVOT_59\10 Gmf_8Compteur.sql";
commit;
/
@"C:\18\execution\MIG_PIVOT_59\19 Gmf_8Tecmtrcfg.sql";
commit;
/
@"C:\18\execution\MIG_PIVOT_59\11 Gmf_9Mtread_histequi.sql";
commit;
/
@"C:\18\execution\MIG_PIVOT_59\12 Gmf_9Mtread_miwtreleve.sql";
commit;
/

@"C:\18\execution\MIG_PIVOT_59\13 Gmf_9Mtread_miwtreleveTTTTTTTT.sql";
commit;
/
@"C:\18\execution\MIG_PIVOT_59\14 Gmf_9Mtread_miwtreleve_gc_1.sql";
commit;
/
@"C:\18\execution\MIG_PIVOT_59\15 Gmf_9Mtread_miwtreleve_gc.sql";
commit;
/
@"C:\18\execution\MIG_PIVOT_59\16 Gmf_20LigneFacture.sql";
commit;
/
@"C:\18\execution\MIG_PIVOT_59\17 Gmf_22RibParty.sql";
commit;
/
@"C:\18\execution\MIG_PIVOT_59\18 Gmf_23FaireSuivre.sql";
commit;
/



 Spool off;
 set timing off;