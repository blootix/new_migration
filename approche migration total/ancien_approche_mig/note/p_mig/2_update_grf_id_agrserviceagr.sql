 declare
code_grf varchar2(4);
v_grf_id number;
begin
  for cur in (select * from mig_pivot_54.miwabn a ) loop
  select distinct '54'||to_number(c.ntiers)||to_number(c.nsixieme) 
  into code_grf 
  from district54.tourne c 
  where lpad(trim(c.code),3,'0')=substr(cur.abn_refpdl,3,3);
  begin
  select w.grf_id 
  into v_grf_id 
  from agrgrpfact w 
  where w.grf_code=code_grf;
  
  if substr(cur.abn_refpdl,3,3) = '54'||'9'then
    update agrserviceagr a 
    set a.grf_id=null
    where a.sag_id=cur.sag_id
    and a.grf_id is null ;
   else
  update agrserviceagr a set a.grf_id=v_grf_id where a.sag_id=cur.sag_id;
  end if;
  exception when others then null;
  end;
  end loop;
  end;
