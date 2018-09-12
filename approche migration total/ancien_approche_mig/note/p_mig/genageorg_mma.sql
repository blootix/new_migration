 declare 
 cursor v is select v.vow_id from v_genvocword v 
where v.voc_code ='VOW_ROLECTTAGE' 
and vow_id in (select VOW_ROLECTTAGE from genageorg where age_id='1' and org_id='54943');

v_ago_id number;
v_org_id number;
 begin
 for x in v loop 
 select max(f.ago_id)+1 into v_ago_id from GENAGEORG f;
 
 insert into GENAGEORG
  (
 ago_id,
 age_id,
 org_id,
 vow_rolecttage,
 ago_credt)
 values
 (v_ago_id,
 1,
 271901,
 x.vow_id,
 sysdate);
 end loop;
 end;