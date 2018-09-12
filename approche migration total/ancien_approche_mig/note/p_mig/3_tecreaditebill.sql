declare
-------------cursor releve
cursor c1
is
select l.bil_id,
l.ite_id,
t.mrd_id,
b.bil_calcdt
from MIG_PIVOT_.miwtreleve t,MIG_PIVOT_.miwtfactureentete f,genbill b,genbilline l
where t.mrel_fact1=f.mfae_rdet
and   t.mrel_source=f.mfae_source
and   f.bil_id=b.bil_id
and   b.bil_id=l.bil_id
and   l.ite_id = 320
-- and   l.bli_exercice >= 2015
and   mrd_id is not null
and t.mrel_fact1 is not null;

-------------cursor relevet
cursor c2
is
select l.bil_id,
l.ite_id,
t.mrd_id,
b.bil_calcdt
from MIG_PIVOT_.miwtrelevet t,MIG_PIVOT_.miwtfactureentete f,genbill b,genbilline l
where t.mrel_fact1=f.mfae_rdet
and   t.mrel_source=f.mfae_source
and   f.bil_id=b.bil_id
and   b.bil_id=l.bil_id
and   l.ite_id = 320
-- and   l.bli_exercice >= 2015
and   mrd_id is not null
and t.mrel_fact1 is not null;

-------------cursor releve_gc_1
cursor c3
is
select l.bil_id,
l.ite_id,
t.mrd_id,
b.bil_calcdt
from MIG_PIVOT_.miwtreleve_gc_1 t,MIG_PIVOT_.miwtfactureentete f,genbill b,genbilline l
where t.mrel_fact1=f.mfae_rdet
and   t.mrel_source=f.mfae_source
and   f.bil_id=b.bil_id
and   b.bil_id=l.bil_id
and   l.ite_id = 320
-- and   l.bli_exercice >= 2015
and   mrd_id is not null
and t.mrel_fact1 is not null;


-------------cursor releve_gc
cursor c4
is
select l.bil_id,
l.ite_id,
t.mrd_id,
b.bil_calcdt
from MIG_PIVOT_.miwtreleve_gc t,MIG_PIVOT_.miwtfactureentete f,genbill b,genbilline l
where t.mrel_fact1=f.mfae_rdet
and   t.mrel_source=f.mfae_source
and   f.bil_id=b.bil_id
and   b.bil_id=l.bil_id
and   l.ite_id = 320
-- and   l.bli_exercice >= 2015
and   mrd_id is not null
and t.mrel_fact1 is not null;



v_i number;
v_count number;
begin
-----------------miwtreleve
  v_i := 0;
  for s1 in c1 loop
    select count(*)
    into   v_count
    from   TECREADITEBILL t
    where  t.bil_id = s1.bil_id
    and    t.ite_id = s1.ite_id
    and    t.mrd_id = s1.mrd_id;
    if v_count = 0 then 
        insert into TECREADITEBILL(BIL_ID,
                                   ITE_ID,
                                   MRD_ID,
                                   RIB_CREDT,
                                   RIB_UPDTBY
                                   )
                            values(s1.bil_id,
                                   s1.ite_id,
                                   s1.mrd_id,
                                   sysdate,
                                   0
                                   );
        v_i := v_i + 1;
    end if;
    if(v_i=500)then
      v_i := 0;
      commit;
    end if;
  end loop;
  commit;
-----------------miwtrelevet
    v_i := 0;
  for s1 in c2 loop
    select count(*)
    into   v_count
    from   TECREADITEBILL t
    where  t.bil_id = s1.bil_id
    and    t.ite_id = s1.ite_id
    and    t.mrd_id = s1.mrd_id;
    if v_count = 0 then 
        insert into TECREADITEBILL(BIL_ID,
                                   ITE_ID,
                                   MRD_ID,
                                   RIB_CREDT,
                                   RIB_UPDTBY
                                   )
                            values(s1.bil_id,
                                   s1.ite_id,
                                   s1.mrd_id,
                                   sysdate,
                                   0
                                   );
        v_i := v_i + 1;
    end if;
    if(v_i=500)then
      v_i := 0;
      commit;
    end if;
  end loop;
  commit;
---------------------miwtreleve_gc_1
    v_i := 0;
  for s1 in c3 loop
    select count(*)
    into   v_count
    from   TECREADITEBILL t
    where  t.bil_id = s1.bil_id
    and    t.ite_id = s1.ite_id
    and    t.mrd_id = s1.mrd_id;
    if v_count = 0 then 
        insert into TECREADITEBILL(BIL_ID,
                                   ITE_ID,
                                   MRD_ID,
                                   RIB_CREDT,
                                   RIB_UPDTBY
                                   )
                            values(s1.bil_id,
                                   s1.ite_id,
                                   s1.mrd_id,
                                   sysdate,
                                   0
                                   );
        v_i := v_i + 1;
    end if;
    if(v_i=500)then
      v_i := 0;
      commit;
    end if;
  end loop;
  commit;
  
 ----------------------------miwtreleve_gc 
   v_i := 0;
  for s1 in c4 loop
    select count(*)
    into   v_count
    from   TECREADITEBILL t
    where  t.bil_id = s1.bil_id
    and    t.ite_id = s1.ite_id
    and    t.mrd_id = s1.mrd_id;
    if v_count = 0 then 
        insert into TECREADITEBILL(BIL_ID,
                                   ITE_ID,
                                   MRD_ID,
                                   RIB_CREDT,
                                   RIB_UPDTBY
                                   )
                            values(s1.bil_id,
                                   s1.ite_id,
                                   s1.mrd_id,
                                   sysdate,
                                   0
                                   );
        v_i := v_i + 1;
    end if;
    if(v_i=500)then
      v_i := 0;
      commit;
    end if;
  end loop;
  commit; 
  
end;
