set timing on 
  
Spool 'C:\temp_ex\file_pivot_&&.txt';
 
 exec branch_resil('&&');
commit;
   /
  exec miwt_personne('&&');
   commit;
   /
  exec miwtabonne_trim ('&&');
  commit;
   /
  exec miwtabonne_gc('&&');
  commit;
  /
  exec miwt_compteur('&&');
  commit;
  /
  exec miwt_tournee('&&');
  commit;
   /
  exec miwt_hist_compteur('&&');
  commit;
   /
  exec miwt_releve_histcpt('&&');
  commit;
  /
  exec miwt_releve('&&');
  commit;
  /
  exec miwt_releve_t('&&');
  commit;
   /
  exec miwt_releve_gc_facture('&&');
  commit;
   /
  exec miwt_releve_gc('&&');
  commit;
  /
  exec miwt_fairesuivre('&&');
  commit;
  /
  exec miwt_rib ('&&');
  commit;
  /
  exec PCK_MIG_FACTURE_new.MIWT_FACTURE_aS400('&&');
  commit;
  /
  exec PCK_MIG_FACTURE_new.MIWT_FACTURE_aS400gc('&&');
  commit;
   /
  exec PCK_MIG_FACTURE_new.MIWT_FACTURE_DIST('&&');
  commit;
  /
   exec  PCK_MIG_FACTURE_new.MIWT_FACTURE_VERSION('&&');
   commit;
  /
  exec PCK_MIG_FACTURE_new.MIWT_FACTURE_IMPAYEE('&&');
  commit; 
  /
  spool off;

SET TIMING OFF;
 
   