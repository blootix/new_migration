set timing on ;
Spool C:\18\execution\MIG_PIVOT_17\file_gmf17.txt;
------exec create_seq;
@"C:\18\execution\MIG_PIVOT_17\01 Gmf_2Adresses.sql";
commit;
/
@"C:\18\execution\MIG_PIVOT_17\02 Gmf_3Party.sql";
commit;
/
@"C:\18\execution\MIG_PIVOT_17\03 Gmf_4Bra.sql";
commit;
/
@"C:\18\execution\MIG_PIVOT_17\04 Gmf_5Tour.sql";
commit;
/

@"C:\18\execution\MIG_PIVOT_17\05 Gmf_6Pdl_ndes.sql";
commit;
/

@"C:\18\execution\MIG_PIVOT_17\06 GMF_6TECSPTWATER.sql";
commit;
/
@"C:\18\execution\MIG_PIVOT_17\07 Gmf_7Pds_ndes.sql";
commit;
/
@"C:\18\execution\MIG_PIVOT_17\08 GMF_7PlaningAgr.sql";
commit;
/
@"C:\18\execution\MIG_PIVOT_17\09 GMF_7TECPRESPTCONTACT.SQL";
commit;
/
@"C:\18\execution\MIG_PIVOT_17\10 Gmf_8Compteur.sql";
commit;
/
@"C:\18\execution\MIG_PIVOT_17\19 Gmf_8Tecmtrcfg.sql";
commit;
/
@"C:\18\execution\MIG_PIVOT_17\11 Gmf_9Mtread_histequi.sql";
commit;
/
@"C:\18\execution\MIG_PIVOT_17\12 Gmf_9Mtread_miwtreleve.sql";
commit;
/

@"C:\18\execution\MIG_PIVOT_17\13 Gmf_9Mtread_miwtreleveTTTTTTTT.sql";
commit;
/
@"C:\18\execution\MIG_PIVOT_17\14 Gmf_9Mtread_miwtreleve_gc_1.sql";
commit;
/
@"C:\18\execution\MIG_PIVOT_17\15 Gmf_9Mtread_miwtreleve_gc.sql";
commit;
/
@"C:\18\execution\MIG_PIVOT_17\16 Gmf_20LigneFacture.sql";
commit;
/
@"C:\18\execution\MIG_PIVOT_17\17 Gmf_22RibParty.sql";
commit;
/
@"C:\18\execution\MIG_PIVOT_17\18 Gmf_23FaireSuivre.sql";
commit;
/



 Spool off;
 set timing off;