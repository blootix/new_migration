 declare 
cursor dist is select z.org_id ,x.vow_rolecttage
from genorganization z ,(select  distinct o.vow_rolecttage  
from  genageorg o ,genorganization org
where o.org_id <>271901 
and age_id<>1
and o.org_id=org.org_id
and  org.org_name='DISTRICT29') x 
where z.org_name='DISTRICT29'
and z.org_code like'%29%';

cursor BA is select z.org_id ,x.vow_rolecttage
from genorganization z ,(select  distinct o.vow_rolecttage  
from  genageorg o ,genorganization org
where o.org_id <>271901 
and age_id<>1
and o.org_id=org.org_id
and  org.org_name='BUREAU ABONNE') x 
where z.org_name='BUREAU ABONNE'
and z.org_code like'%29%';

cursor BE is select z.org_id ,x.vow_rolecttage
from genorganization z ,(select  distinct o.vow_rolecttage  
from  genageorg o ,genorganization org
where o.org_id <>271901 
and age_id<>1
and o.org_id=org.org_id
and  org.org_name='BUREAU ETUDE') x 
where z.org_name='BUREAU ETUDE'
and z.org_code like'%29%';

cursor BR is select z.org_id ,x.vow_rolecttage
from genorganization z ,(select  distinct o.vow_rolecttage  
from  genageorg o ,genorganization org
where o.org_id <>271901 
and age_id<>1
and o.org_id=org.org_id
and  org.org_name='BUREAU RELEVE') x 
where z.org_name='BUREAU RELEVE'
and z.org_code like'%29%';

cursor MAG is select z.org_id ,x.vow_rolecttage
from genorganization z ,(select  distinct o.vow_rolecttage  
from  genageorg o ,genorganization org
where o.org_id <>271901 
and age_id<>1
and o.org_id=org.org_id
and  org.org_name='MAGASIN') x 
where z.org_name='MAGASIN'
and z.org_code like'%29%';
 
cursor SAD is select z.org_id ,x.vow_rolecttage
from genorganization z ,(select  distinct o.vow_rolecttage  
from  genageorg o ,genorganization org
where o.org_id <>271901 
and age_id<>1
and o.org_id=org.org_id
and  org.org_name='SECTION ADMINISTRATIVE') x 
where z.org_name='SECTION ADMINISTRATIVE'
and z.org_code like'%29%';

cursor  SM is select z.org_id ,x.vow_rolecttage
from genorganization z ,(select  distinct o.vow_rolecttage  
from  genageorg o ,genorganization org
where o.org_id <>271901 
and age_id<>1
and o.org_id=org.org_id
and  org.org_name='SECTION MAINTENANCE') x 
where z.org_name='SECTION MAINTENANCE'
and z.org_code like'%29%';
 
cursor SA is select z.org_id ,x.vow_rolecttage
from genorganization z ,(select  distinct o.vow_rolecttage  
from  genageorg o ,genorganization org
where o.org_id <>271901 
and age_id<>1
and o.org_id=org.org_id
and  org.org_name='SERVICE ADM. FIN. JUR. (S.A.F.J)') x 
where z.org_name='SERVICE ADM. FIN. JUR. (S.A.F.J)'
and z.org_code like'%29%';
 
 cursor UT1 is select z.org_id ,x.vow_rolecttage
from genorganization z ,(select  distinct o.vow_rolecttage  
from  genageorg o ,genorganization org
where o.org_id <>271901 
and age_id<>1
and o.org_id=org.org_id
and  org.org_name='UNITE TRAVEAUX 1') x 
where z.org_name='UNITE TRAVEAUX 1'
and z.org_code like'%29%';

cursor UT2 is select z.org_id ,x.vow_rolecttage
from genorganization z ,(select  distinct o.vow_rolecttage  
from  genageorg o ,genorganization org
where o.org_id <>271901 
and age_id<>1
and o.org_id=org.org_id
and  org.org_name='UNITE TRAVEAUX 2') x 
where z.org_name='UNITE TRAVEAUX 2'
and z.org_code like'%29%';
 
v_ago_id number;
v_org_id number;
 begin
 for x in dist loop 
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
 x.org_id,
 x.vow_rolecttage,
 sysdate);
 end loop;
 
 -------------
  for x in BA loop 
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
 x.org_id,
 x.vow_rolecttage,
 sysdate);
 end loop;
 --------
  for x in BE loop 
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
 x.org_id,
 x.vow_rolecttage,
 sysdate);
 end loop;
 -----------------------------------
  for x in BR loop 
 select max(f.ago_id)+1 
 into v_ago_id 
 from GENAGEORG f;
 
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
 x.org_id,
 x.vow_rolecttage,
 sysdate);
 end loop;
 -------------------------
  for x in MAG loop 
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
 x.org_id,
 x.vow_rolecttage,
 sysdate);
 end loop;
 -----------------------------------
 for x in SAD loop 
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
 x.org_id,
 x.vow_rolecttage,
 sysdate);
 end loop;
  -----------------------------------
 for x in UT1 loop 
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
 x.org_id,
 x.vow_rolecttage,
 sysdate);
 end loop;
 
  -----------------------------------
 for x in UT2 loop 
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
 x.org_id,
 x.vow_rolecttage,
 sysdate);
 end loop;
 end;