Declare 
Cursor groupfact is 
SELECT TR.ROU_ID,TR.ROU_CODE,T.NTIERS,T.NSIXIEME 
FROM TOURNE T, TECROUTE TR
WHERE TR.ROU_CODE='20'||'-'||T.CODE; 
   
  New_Grf          agrgrpfact%rowtype  ;
  Grf_Id           Number ;
  ref_Grf          Number ; 
Procedure Genere_Groupe_Facturation (NewGrf agrgrpfact%rowtype ,GrfId  in out   number ,ref_Grf out number) is
 BEGIN
      SELECT  GRF_ID 
      INTO  ref_Grf 
      from agrgrpfact_save
      where nvl(GRF_CODE,'*')= nvl(NewGrf.GRF_CODE,'*') ;   
Exception
  WHEN NO_DATA_FOUND THEN
        GrfId   :=GrfId+1;
        ref_Grf :=GrfId; 
        
      insert into agrgrpfact(GRF_ID,GRF_CODE,GRF_NAME,grf_name_a,grf_credt,grf_updtdt)
          values (GrfId,NewGrf.GRF_CODE,NewGrf.GRF_NAME,NewGrf.GRF_NAME,sysdate,sysdate);
          
end Genere_Groupe_Facturation;

begin  
For gf in groupfact loop
-----Traitement Grupe facturation(GRF)
select seq_agrgrpfact.nextval 	 
into Grf_Id    
from dual;
 
New_Grf.GRF_CODE := '20'||gf.NTIERS||gf.NSIXIEME;
    
if gf.NTIERS||gf.NSIXIEME='00' then 
New_Grf.GRF_NAME :='Groupe facturation '||'20M';
else    
New_Grf.GRF_NAME :='Groupe facturation '||'20'||gf.NTIERS||gf.NSIXIEME;
end if;   

Genere_Groupe_Facturation(New_Grf,Grf_Id ,ref_Grf);   



update tecroute s
set s.grf_id=( Select g.grf_id 
               from agrgrpfact  g
               where g.grf_code in (select '20'||t.NTIERS||t.NSIXIEME 
                                    from  DISTRICT20.TOURNE t 
                                    where s.ROU_NAME=t.code 
                                    and substr(s.rou_code,1,2)='20'
                                     )
               )
where s.rou_id=gf.rou_id;

update tecroute s
set s.grf_id=(Select g.grf_id 
               from agrgrpfact  g
               where g.GRF_NAME='Groupe facturation '||'20M')
               where s.grf_id is null ;

Commit;   
end loop ;
end ;
/

