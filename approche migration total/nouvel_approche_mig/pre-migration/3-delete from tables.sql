
    delete from  GENACCOUNT where vow_acotp in(2558,2559,2562,5802) ;  
    commit;
    
    delete from  GENBANKPARTY where bap_id not in (select * from (select NVL(o.bap_credit_id,o.bap_debit_id) bap_id
     from genorganization o union select NVL(o.bap_debit_id,o.bap_credit_id) bap_id
      from genorganization o)
      where bap_id is not null); 
    commit;
    
    
    delete from  GENPARTYPARTY where par_parent_id not in(select par_id from GENPARTY where par_id in(select org_id from genorganization 
                                                                                                      union  all
                                                                                                      select 1 from dual 
                                                                                                      union all
                                                                                                      select par.par_id
                                                                                                      from  genparty par,
                                                                                                          genrefext rex, 
                                                                                                          genrefextdft ref,
                                                                                                          genvocword vow
                                                                                                      where par.par_id = rex.rex_idorig 
                                                                                                      and   ref.ref_id = rex.rex_id
                                                                                                      and   ref.ref_table = 'GENPARTY'
                                                                                                      and   ref.ref_column = 'PAR_REFE'
                                                                                                      and   ref.vow_soft = vow.vow_id 
                                                                                                      and   vow.vow_code in ('RHUI','REXP')
                                                                                                      union all
                                                                                                      select par_id
                                                                                                      from   genparty
                                                                                                      where  par_refe like 'DISTRICT%'
                                                                                                      )
                                                           );
    commit;
    
    delete from  GENPARTY where par_id not in(select org_id from genorganization 
                                            union 
                        select 1 from dual 
                        union all
                        select par.par_id
                        from  genparty par,
                            genrefext rex, 
                            genrefextdft ref,
                            genvocword vow
                        where par.par_id = rex.rex_idorig 
                        and   ref.ref_id = rex.rex_id
                        and   ref.ref_table = 'GENPARTY'
                        and   ref.ref_column = 'PAR_REFE'
                        and   ref.vow_soft = vow.vow_id 
                        and   vow.vow_code in ('RHUI','REXP')
                        union all
                        select par_id
                        from   genparty
                        where  par_refe like 'DISTRICT%'
                        );  
    commit;
    
    delete from  GENADRESS where adr_id <>0;
    commit;
  
    delete from genstreet where str_id <>0;
    commit;
    
    delete from  PAYCASHDESKSESSION WHERE CSS_ID not in (select css_id from paycashdesk where cah_code = '01');--  CAISSE
    commit;
    
    delete from WFCONDOS where con_id in (select con_id from wfcontact where con_mcon_id is not null);
    commit;
    delete from  WFCONTACT where con_mcon_id is not null;
    commit;
    
    delete from  WFDOSSIER where dos_mdos_id is not null;
    commit;
    delete from  WFETAPE where dos_id in (select dos_id from WFDOSSIER where dos_mdos_id is not null);
    commit;
    
    delete from  WFHPROCESS where dos_id in (select dos_id from WFDOSSIER where dos_mdos_id is not null);
    commit;
    delete from  WFLIST where lst_id in (select lag_id from wfcontact where con_mcon_id is not null
                                        union  
                      select lit_id from wfcontact where con_mcon_id is not null
                      union
                      select lob_id from wfcontact where con_mcon_id is not null
                      union
                      select lag_id from wfdossier where dos_mdos_id is not null
                                        union  
                      select lit_id from wfdossier where dos_mdos_id is not null
                      union
                      select lob_id from wfdossier where dos_mdos_id is not null);
    commit;
    delete from  WFLISTAGE where lag_id in (select lag_id from wfcontact where con_mcon_id is not null
                         union
                         select lag_id from wfdossier where dos_mdos_id is not null);
    commit;
    delete from  WFLISTITC where lit_id in (select lit_id from wfcontact where con_mcon_id is not null
                         union
                         select lit_id from wfdossier where dos_mdos_id is not null);
    commit;
    delete from  WFLISTOBJECT where lob_id in (select lob_id from wfcontact where con_mcon_id is not null
                            union
                            select lob_id from wfdossier where dos_mdos_id is not null);
    commit;
    
