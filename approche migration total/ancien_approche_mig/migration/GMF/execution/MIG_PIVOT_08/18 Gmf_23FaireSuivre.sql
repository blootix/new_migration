
declare
v_paa_id number default 0;
v_adr_id number default 0;
v_par_id number default 0;
v_date_start date;
d1 number;
d2 number;
begin
  d1 := dbms_utility.get_time();
--select max(t.paa_id) into v_paa_id from genpartyparty t;
for c in ( select * from  mig_pivot_08.miwtfairesuivre 
           where adr_id is null 
		   and paa_id is null 
		   and par_id is null) loop
		   
		   
  select seq_genpartyparty.NEXTVAL into v_paa_id from dual;
  
  
  select a.adr_id into v_adr_id 
  from  mig_pivot_08.miwtadr a 
  where a.madr_ref=c.mfs_ref_adr;
  
  select p.par_id into v_par_id 
  from  mig_pivot_08.miwtpersonne p 
  where upper(p.mper_ref)=upper(c.mfs_ref);
  begin
  select t.paa_startdt into v_date_start 
  from genpartyparty t 
  where t.par_parent_id=v_par_id 
  and rownum = 1;
  exception when others then v_date_start:=sysdate;
  end;
 -- begin
  insert into genpartyparty
  (paa_id,
  par_parent_id,
  VOW_PARTYTP,
  ADR_ID,
  PAA_STARTDT
  )
  values
  (v_paa_id,
  v_par_id,
  pk_genvocword.getidbycode('VOW_PARTYTP','4',null) ,
  v_adr_id,  
  v_date_start
  );
  update  mig_pivot_08.miwtfairesuivre s 
  set s.adr_id=v_adr_id, s.par_id=v_par_id, s.paa_id=v_par_id
  where s.mfs_ref=c.mfs_ref;
  
  commit;
end loop;
  d2 := dbms_utility.get_time();
dbms_output.put_line((d2-d1)/100);
end;
/
