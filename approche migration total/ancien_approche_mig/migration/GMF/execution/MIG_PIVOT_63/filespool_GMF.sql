set timing on ;
Spool C:\18\execution\MIG_PIVOT_63\file_gmf63.txt;
------exec create_seq;
@"C:\18\execution\MIG_PIVOT_63\01 Gmf_2Adresses.sql";
commit;
/
@"C:\18\execution\MIG_PIVOT_63\02 Gmf_3Party.sql";
commit;
/
@"C:\18\execution\MIG_PIVOT_63\03 Gmf_4Bra.sql";
commit;
/
@"C:\18\execution\MIG_PIVOT_63\04 Gmf_5Tour.sql";
commit;
/

@"C:\18\execution\MIG_PIVOT_63\05 Gmf_6Pdl_ndes.sql";
commit;
/

@"C:\18\execution\MIG_PIVOT_63\06 GMF_6TECSPTWATER.sql";
commit;
/
@"C:\18\execution\MIG_PIVOT_63\07 Gmf_7Pds_ndes.sql";
commit;
/
@"C:\18\execution\MIG_PIVOT_63\08 GMF_7PlaningAgr.sql";
commit;
/
@"C:\18\execution\MIG_PIVOT_63\09 GMF_7TECPRESPTCONTACT.SQL";
commit;
/
@"C:\18\execution\MIG_PIVOT_63\10 Gmf_8Compteur.sql";
commit;
/
@"C:\18\execution\MIG_PIVOT_63\19 Gmf_8Tecmtrcfg.sql";
commit;
/
@"C:\18\execution\MIG_PIVOT_63\11 Gmf_9Mtread_histequi.sql";
commit;
/
@"C:\18\execution\MIG_PIVOT_63\12 Gmf_9Mtread_miwtreleve.sql";
commit;
/

@"C:\18\execution\MIG_PIVOT_63\13 Gmf_9Mtread_miwtreleveTTTTTTTT.sql";
commit;
/
@"C:\18\execution\MIG_PIVOT_63\14 Gmf_9Mtread_miwtreleve_gc_1.sql";
commit;
/
@"C:\18\execution\MIG_PIVOT_63\15 Gmf_9Mtread_miwtreleve_gc.sql";
commit;
/
@"C:\18\execution\MIG_PIVOT_63\16 Gmf_20LigneFacture.sql";
commit;
/
@"C:\18\execution\MIG_PIVOT_63\17 Gmf_22RibParty.sql";
commit;
/
@"C:\18\execution\MIG_PIVOT_63\18 Gmf_23FaireSuivre.sql";
commit;
/



 Spool off;
 set timing off;