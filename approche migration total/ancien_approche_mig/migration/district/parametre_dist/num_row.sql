select
   table_name,
   to_number(
   extractvalue(
      xmltype(
         dbms_xmlgen.getxml('select count(*) c from '||table_name))
    ,'/ROWSET/ROW/C')) count
from 
   user_tables
order by 
   table_name;