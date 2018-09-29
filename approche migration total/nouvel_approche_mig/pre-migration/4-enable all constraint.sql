declare
  cursor c1 
  is 
         select * 
         from all_constraints 
         where owner = 'SIC_SONEDE' 
         and constraint_type = 'R' ;
begin
    for s1 in c1 loop
        execute immediate 'alter table '|| s1.table_name ||' enable constraint '||s1.constraint_name;
    end loop;
end;