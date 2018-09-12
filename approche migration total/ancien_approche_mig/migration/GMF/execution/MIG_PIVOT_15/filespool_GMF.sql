set timing on ;
Spool C:\18\execution\MIG_PIVOT_15\file_gmf15.txt;
------exec create_seq;
@"C:\18\execution\MIG_PIVOT_15\01 Gmf_2Adresses.sql";
commit;
/
@"C:\18\execution\MIG_PIVOT_15\02 Gmf_3Party.sql";
commit;
/
@"C:\18\execution\MIG_PIVOT_15\03 Gmf_4Bra.sql";
commit;
/
@"C:\18\execution\MIG_PIVOT_15\04 Gmf_5Tour.sql";
commit;
/

@"C:\18\execution\MIG_PIVOT_15\05 Gmf_6Pdl_ndes.sql";
commit;
/

@"C:\18\execution\MIG_PIVOT_15\06 GMF_6TECSPTWATER.sql";
commit;
/
@"C:\18\execution\MIG_PIVOT_15\07 Gmf_7Pds_ndes.sql";
commit;
/
@"C:\18\execution\MIG_PIVOT_15\08 GMF_7PlaningAgr.sql";
commit;
/
@"C:\18\execution\MIG_PIVOT_15\09 GMF_7TECPRESPTCONTACT.SQL";
commit;
/
@"C:\18\execution\MIG_PIVOT_15\10 Gmf_8Compteur.sql";
commit;
/
@"C:\18\execution\MIG_PIVOT_15\19 Gmf_8Tecmtrcfg.sql";
commit;
/
@"C:\18\execution\MIG_PIVOT_15\11 Gmf_9Mtread_histequi.sql";
commit;
/
@"C:\18\execution\MIG_PIVOT_15\12 Gmf_9Mtread_miwtreleve.sql";
commit;
/

@"C:\18\execution\MIG_PIVOT_15\13 Gmf_9Mtread_miwtreleveTTTTTTTT.sql";
commit;
/
@"C:\18\execution\MIG_PIVOT_15\14 Gmf_9Mtread_miwtreleve_gc_1.sql";
commit;
/
@"C:\18\execution\MIG_PIVOT_15\15 Gmf_9Mtread_miwtreleve_gc.sql";
commit;
/
@"C:\18\execution\MIG_PIVOT_15\16 Gmf_20LigneFacture.sql";
commit;
/
@"C:\18\execution\MIG_PIVOT_15\17 Gmf_22RibParty.sql";
commit;
/
@"C:\18\execution\MIG_PIVOT_15\18 Gmf_23FaireSuivre.sql";
commit;
/



 Spool off;
 set timing off;