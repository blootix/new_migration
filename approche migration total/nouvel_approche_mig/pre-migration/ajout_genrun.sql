 declare 
cursor c
is
select distinct t.dist,t.annee,t.periode
from TEST.src_facture_as400 t;
v_run_id number;
v_org_id number;
v_mois number;
v_fac_datecalcul date;
v_periode varchar2(10);
v_train_fact varchar2(10);
begin
  for s1 in c loop
    select decode(s1.periode,1,3,2,6,3,9,12) into v_mois from dual;
    if (v_mois=12) then
      v_fac_datecalcul :=to_date('08/'||'01'||'/'||to_char(s1.annee+1),'dd/mm/yyyy');
    else
      v_fac_datecalcul :=to_date('08/'||lpad(v_mois+1,2,'0')||'/'||to_char(s1.annee),'dd/mm/yyyy');
    end if; 
   v_periode:=lpad(trim(s1.periode),2,'0'); 
   v_train_fact :=trim(s1.annee)||'-'||trim(v_periode);
---v_train_fact:='Annee:'||trim(v_anneereel)||' Mois:'||trim(v_periode);
    select max(org_id)
    into   v_org_id
    from   genorganization
    where  org_code = lpad(trim(s1.dist),2,'0'); 
    begin
      select t.run_id
      into   v_run_id
      from genrun t 
      where t.run_exercice=s1.annee
      and   t.run_number  =v_periode
      and   t.org_id=v_org_id;
    exception when others then 			  
      select seq_genrun.nextval into v_run_id from dual;				
      insert into genrun(run_id,run_exercice,run_number,org_id,run_startdt,run_comment,run_name,run_dtcalc,run_enddt)
                  values(v_run_id,s1.annee,to_number(trim(s1.periode)),v_org_id,v_fac_datecalcul,'Role migré',v_train_fact,v_fac_datecalcul,v_fac_datecalcul);
    end;
  end loop;
end;