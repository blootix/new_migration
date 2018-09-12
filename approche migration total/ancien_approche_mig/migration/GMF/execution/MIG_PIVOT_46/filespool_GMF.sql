set timing on ;
Spool C:\18\execution\MIG_PIVOT_46\file_gmf46.txt;
------exec create_seq;
@"C:\18\execution\MIG_PIVOT_46\01 Gmf_2Adresses.sql";
commit;
/
@"C:\18\execution\MIG_PIVOT_46\02 Gmf_3Party.sql";
commit;
/
@"C:\18\execution\MIG_PIVOT_46\03 Gmf_4Bra.sql";
commit;
/
@"C:\18\execution\MIG_PIVOT_46\04 Gmf_5Tour.sql";
commit;
/

@"C:\18\execution\MIG_PIVOT_46\05 Gmf_6Pdl_ndes.sql";
commit;
/

@"C:\18\execution\MIG_PIVOT_46\06 GMF_6TECSPTWATER.sql";
commit;
/
@"C:\18\execution\MIG_PIVOT_46\07 Gmf_7Pds_ndes.sql";
commit;
/
@"C:\18\execution\MIG_PIVOT_46\08 GMF_7PlaningAgr.sql";
commit;
/
@"C:\18\execution\MIG_PIVOT_46\09 GMF_7TECPRESPTCONTACT.SQL";
commit;
/
@"C:\18\execution\MIG_PIVOT_46\10 Gmf_8Compteur.sql";
commit;
/
@"C:\18\execution\MIG_PIVOT_46\19 Gmf_8Tecmtrcfg.sql";
commit;
/
@"C:\18\execution\MIG_PIVOT_46\11 Gmf_9Mtread_histequi.sql";
commit;
/
@"C:\18\execution\MIG_PIVOT_46\12 Gmf_9Mtread_miwtreleve.sql";
commit;
/

@"C:\18\execution\MIG_PIVOT_46\13 Gmf_9Mtread_miwtreleveTTTTTTTT.sql";
commit;
/
@"C:\18\execution\MIG_PIVOT_46\14 Gmf_9Mtread_miwtreleve_gc_1.sql";
commit;
/
@"C:\18\execution\MIG_PIVOT_46\15 Gmf_9Mtread_miwtreleve_gc.sql";
commit;
/
@"C:\18\execution\MIG_PIVOT_46\16 Gmf_20LigneFacture.sql";
commit;
/
@"C:\18\execution\MIG_PIVOT_46\17 Gmf_22RibParty.sql";
commit;
/
@"C:\18\execution\MIG_PIVOT_46\18 Gmf_23FaireSuivre.sql";
commit;
/



 Spool off;
 set timing off;