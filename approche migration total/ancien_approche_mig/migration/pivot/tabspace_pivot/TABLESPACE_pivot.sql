--PREPARATION DES TABLE SPACES
CREATE  TABLESPACE MIG03
  DATAFILE 'MIG09.dbf' SIZE 1024M AUTOEXTEND ON;
  
  CREATE TABLESPACE MIG03_INDEX
  DATAFILE'MIG09_INDEX.dbf' SIZE 1024M AUTOEXTEND ON;
  
--- SCRIPT DE REMAP DES INDEX  
  
select 'ALTER TABLE '|| v.TABLE_NAME ||' MOVE TABLESPACE MIG09;' from tabs v;
select 'alter INDEX '||N.INDEX_NAME||'  REBUILD tablespace MIG09_INDEX;'
from all_indexes N
where owner = 'MIG_PIVOT_09';

--select 'ALTER INDEX ' || index_name || '  REBUILD ONLINE;' from  user_indexes where status='UNUSABLE';
 