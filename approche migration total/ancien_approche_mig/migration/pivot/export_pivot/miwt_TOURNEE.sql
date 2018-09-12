create or replace procedure miwt_tournee
is

begin
delete  from MIWTTOURNEE t ;
for c in (select distinct t.district,t.code from tourne t) loop
	insert into MIWTTOURNEE (MTOU_SOURCE,MTOU_REF,MTOU_CODE,MTOU_LIBE)
	values('DIST'||c.district,c.code,c.code,c.code);
end loop;
for c in (select distinct t.district from test t) loop
	insert into MIWTTOURNEE (MTOU_SOURCE,MTOU_REF,MTOU_CODE,MTOU_LIBE)
	values('DIST'||c.district,c.district||'_AS',c.district||'_AS',c.district||'_AS');
commit;
end loop;
end;

