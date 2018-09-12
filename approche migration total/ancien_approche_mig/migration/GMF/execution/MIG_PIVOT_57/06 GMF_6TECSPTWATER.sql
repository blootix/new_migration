------------------------------------------------------------------------
-----------------------------------------------------------------------
------------------------------Tecsptwater
----------------------------------------------
------------------------------------------------------------------------
update  mig_pivot_57.miwtpdl l set l.VOC_CONSTATUS='I' where upper(trim(l.VOC_CONSTATUS)) not in('B','M','I');
update mig_pivot_57.miwtpdl l set l.VOC_CONNAT=0 where  to_char(trim(l.VOC_CONNAT)) not in('0','1','2','3');

SELECT to_char(sysdate, 'DD/MM/YY HH24:MI') heure FROM dual;
declare
cursor c1
is 
  select t.spt_id,decode(m.VOC_CONSTATUS,'B','B','M','M','I','I','I')VOC_CONSTATUS,decode(m.VOC_CONNAT,0,0,1,1,2,2,3,3,0)VOC_CONNAT 
  from tecservicepoint t,  mig_pivot_57.miwtpdl m where m.spt_id=t.spt_id;
  
  v_CONSTATUS number;
  v_CONNAT number;
begin
	for c in c1 loop
		select vow_id 
		into v_CONSTATUS from v_genvocword v
		where v.voc_code='VOW_CONSTATUS'
		and v.vow_code=c.VOC_CONSTATUS;
		
		select vow_id into v_CONNAT 
		from v_genvocword v
		where v.voc_code='VOW_CONNAT'
		and v.vow_code=to_char(c.VOC_CONNAT);
		
		insert into tecsptwater(
								spt_id,
								VOW_CONNAT,
								VOW_CONSTATUS
								)
		                 values
						       (
								c.spt_id,
								v_CONNAT,
								v_CONSTATUS
								);
	end loop;
	commit;
end;
/
SELECT to_char(sysdate, 'DD/MM/YY HH24:MI') heure FROM dual;