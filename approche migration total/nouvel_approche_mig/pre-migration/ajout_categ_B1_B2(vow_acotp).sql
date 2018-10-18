---------------------------ajout categorie vow_acotp
 declare 
  v_vow_id number;
begin
---------------CateG B1
select max(v.vow_id)+1
into v_vow_id
from genvocword v;
-----
insert into genvocword (vow_id,voc_id,vow_code,vow_name,vow_printname,vow_icode,vow_status,vow_internal)
                 values(v_vow_id,169,'B101','B1 Categorie 01','B1 Categorie 01',null,1,1);           
select max(v.vow_id)+1
into v_vow_id
from genvocword v;
insert into genvocword (vow_id,voc_id,vow_code,vow_name,vow_printname,vow_icode,vow_status,vow_internal)
                 values(v_vow_id,169,'B102','B1 Categorie 02','B1 Categorie 02',null,1,1);  
select max(v.vow_id)+1
into v_vow_id
from genvocword v;  
insert into genvocword (vow_id,voc_id,vow_code,vow_name,vow_printname,vow_icode,vow_status,vow_internal)
                 values(v_vow_id,169,'B110','B1 Categorie 03','B1 Categorie 10',null,1,1);           
 select max(v.vow_id)+1
into v_vow_id
from genvocword v;               
insert into genvocword (vow_id,voc_id,vow_code,vow_name,vow_printname,vow_icode,vow_status,vow_internal)
                values(v_vow_id,169,'B104','B1 Categorie 04','B1 Categorie 04',null,1,1);   
select max(v.vow_id)+1
into v_vow_id
from genvocword v;
insert into genvocword (vow_id,voc_id,vow_code,vow_name,vow_printname,vow_icode,vow_status,vow_internal)
                 values(v_vow_id,169,'B106','B1 Categorie 06','B1 Categorie 06',null,1,1);           
select max(v.vow_id)+1
into v_vow_id
from genvocword v;
insert into genvocword (vow_id,voc_id,vow_code,vow_name,vow_printname,vow_icode,vow_status,vow_internal)
                 values(v_vow_id,169,'B108','B1 Categorie 08','B1 Categorie 08',null,1,1);   
---------------CateG B2
select max(v.vow_id)+1
into v_vow_id
from genvocword v;
insert into genvocword (vow_id,voc_id,vow_code,vow_name,vow_printname,vow_icode,vow_status,vow_internal)
                 values(v_vow_id,169,'B201','B2 Categorie 01','B2 Categorie 01',null,1,1);           
select max(v.vow_id)+1
into v_vow_id
from genvocword v;
insert into genvocword (vow_id,voc_id,vow_code,vow_name,vow_printname,vow_icode,vow_status,vow_internal)
                 values(v_vow_id,169,'B202','B2 Categorie 02','B2 Categorie 02',null,1,1);  
 select max(v.vow_id)+1
into v_vow_id
from genvocword v; 
insert into genvocword (vow_id,voc_id,vow_code,vow_name,vow_printname,vow_icode,vow_status,vow_internal)
                 values(v_vow_id,169,'B210','B2 Categorie 03','B2 Categorie 10',null,1,1);           
select max(v.vow_id)+1
into v_vow_id
from genvocword v;
insert into genvocword (vow_id,voc_id,vow_code,vow_name,vow_printname,vow_icode,vow_status,vow_internal)
                 values(v_vow_id,169,'B204','B2 Categorie 04','B2 Categorie 04',null,1,1);   
 select max(v.vow_id)+1
into v_vow_id
from genvocword v;
insert into genvocword (vow_id,voc_id,vow_code,vow_name,vow_printname,vow_icode,vow_status,vow_internal)
                 values(v_vow_id,169,'B206','B2 Categorie 06','B2 Categorie 06',null,1,1);           
select max(v.vow_id)+1
into v_vow_id
from genvocword v;
insert into genvocword (vow_id,voc_id,vow_code,vow_name,vow_printname,vow_icode,vow_status,vow_internal)
                 values(v_vow_id,169,'B208','B2 Categorie 08','B2 Categorie 08',null,1,1);   
end;
----------------------------- add gennacount avec vow_acotp categorie B1 et B2
declare
cursor c
is 
select par_id
from genparty 
where par_refe like'DISTRICT%';
cursor v 
is 
select vow_id
from genvocword
where voc_id=169
and vow_name like'B%';
 
v_aco_id number;
begin
for s1 in c loop
  for x in v loop
      select max(aco_id)+1
      into v_aco_id
      from genaccount;
      
      insert into genaccount(aco_id,aco_amount,par_id,imp_id,rec_id,aco_norecovery,
                             vow_acotp,aco_status,ACO_UPDTBY)
                       values(v_aco_id,0,s1.par_id,5,4,1,x.vow_id,0,0); 
   end loop;              
end loop;
end;

