 declare
v_type_cons varchar2(1) default null;
v_VOW_FRQFACT number default 0;
begin
for c in (select a.sag_id,spt_refe,s.spt_id,
pk_genvocword.GetIdByCode(p_voc_code => 'VOW_FRQFACT',p_vow_code => p.VOC_FRQFACT,p_ageconnection => null) v_VOW_FRQFACT
from tecservicepoint s , 
agrserviceagr a,
 mig_pivot_49.miwtpdl p
where s.spt_id=a.spt_id 
and p.spt_id=s.spt_id
and a.sag_id not in (select sag_id from AGRPLANNINGAGR)
) loop


insert into AGRPLANNINGAGR
(
  SAG_ID,--1             NUMBER(10) not null,
  VOW_FRQFACT,--2        NUMBER(10) not null,
  AGP_FACTDAY,--3        NUMBER(2) not null,
  AGP_FACTMTMAX,--4      NUMBER(17,10),
  AGP_FACTMTMIN,--5      NUMBER(17,10),
  AGP_NEXTFACTDT,--6     DATE not null,
  AGP_NEXTREADDT,--7     DATE,
  VOW_MODEFACTNEXT,--8   NUMBER(10) not null,
  AGP_NEXTFACTDTOLD,--9  DATE,
  AGP_FACTNEXTRELOLD,--10 NUMBER(1),
  VOW_MODEFACTOLD,--11    NUMBER(10),
  AGP_CREDT,--12          DATE default sysdate,
  AGP_UPDTBY,--13         NUMBER(10),
  AGP_UPDTDT,--14         DATE,
  AGP_SAGDT,--15          DATE,
  AGP_SAGDTOLD--16       DATE
)values 
(
  c.sag_id,--1             NUMBER(10) not null,
  C.v_VOW_FRQFACT,--2        NUMBER(10) not null,
  10,--3        NUMBER(2) not null,
  NULL,--4      NUMBER(17,10),
  NULL,--5      NUMBER(17,10),
  SYSDATE,--6     DATE not null,
  NULL,--7     DATE,
  2844,--8   NUMBER(10) not null,
  NULL,--9  DATE,
  NULL,--10 NUMBER(1),
  NULL,--11    NUMBER(10),
  SYSDATE,--12          DATE default sysdate,
  1,--13         NUMBER(10),
  NULL,--14         DATE,
  sysdate,--15          DATE,
  NULL--16       DATE
)
;commit;
end loop;
end;
/