SELECT to_char(sysdate, 'DD/MM/YY HH24:MI') heure FROM dual;
declare
  cursor c1 
  is
     select a.par_id,t.PRE_ID,t.SPT_ID, a.CAG_STARTDT, a.CAG_ENDDT 
	from tecservicepoint t,agrcustomeragr a,mig_pivot_42.miwabn p
    where t.spt_id=p.spt_id
	and t.PRE_ID=a.PRE_ID
    and t.pre_id not in (select l.pre_id from TECPRESPTCONTACT l);
     
  v_PSC_ID number default 0;
begin
  --select nvl(max(PSC_ID),0) into v_PSC_ID from TECPRESPTCONTACT;
  for c in c1 loop
		 begin
        --v_PSC_ID:=v_PSC_ID+1;
		
		select seq_TECPRESPTCONTACT.nextval into v_PSC_ID  from dual;
		
        insert into TECPRESPTCONTACT
						(
						  PSC_ID          ,--1 NUMBER(10) not null,
						  PAR_ID          ,--2 NUMBER(10) not null,
						  PRE_ID		  ,--3 NUMBER(10) not null,
						  SPT_ID		  ,--4 NUMBER(10),
						  VOW_PRECONTACTTP,--5 NUMBER(10) not null,
						  PSC_STARTDT     ,--6 DATE not null,
						  PSC_ENDDT       ,--7 DATE,
						  PSC_RANK        ,--8 NUMBER(10) default 0 not null,
						  PSC_UPDTBY       --9 NUMBER(10)
						)
                values
						(
						  v_PSC_ID        ,--1 NUMBER(10) not null,
						  c.par_id	      ,--2 NUMBER(10) not null,
						  c.PRE_ID        ,--3 NUMBER(10) not null,
						  NULL            ,--4 NUMBER(10),
						  2890            ,--5 NUMBER(10) not null,
						  c.CAG_STARTDT   ,--6 DATE not null,
						  c.CAG_ENDDT     ,--7 DATE,
						  1               ,--8 NUMBER(10) default 0 not null,
						  1		           --9 NUMBER(10)
						);
        
        --v_PSC_ID:=v_PSC_ID+1;
		select   seq_TECPRESPTCONTACT.nextval into v_PSC_ID  from dual ;
		
        insert into TECPRESPTCONTACT
						(
						  PSC_ID          ,--1 NUMBER(10) not null,
						  PAR_ID          ,--2 NUMBER(10) not null,
						  PRE_ID          ,--3 NUMBER(10) not null,
						  SPT_ID          ,--4 NUMBER(10),
						  VOW_PRECONTACTTP,--5 NUMBER(10) not null,
						  PSC_STARTDT     ,--6 DATE not null,
						  PSC_ENDDT       ,--7 DATE,
						  PSC_RANK        ,--8 NUMBER(10) default 0 not null,
						  PSC_UPDTBY       --9 NUMBER(10)
						)
                 values
						(
						  v_PSC_ID        ,--1 NUMBER(10) not null,
						  c.par_id		  ,--2 NUMBER(10) not null,
						  c.PRE_ID        ,--3 NUMBER(10) not null,
						  c.SPT_ID        ,--4 NUMBER(10),
						  2890            ,--5 NUMBER(10) not null,
						  c.CAG_STARTDT   ,--6 DATE not null,
						  c.CAG_ENDDT     ,--7 DATE,
						  2               ,--8 NUMBER(10) default 0 not null,
						  1                --9 NUMBER(10)
						);
    exception when others then null;
    end;
COMMIT;
END LOOP;
END;
/
SELECT to_char(sysdate, 'DD/MM/YY HH24:MI') heure FROM dual;