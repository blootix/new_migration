declare 
cursor c is 
select NCOM_NBROUE ,
       VOC_MODEL,
       equ_id
from MIG_PIVOT_09.miwtcompteur;

v_vow_model number;
v_vow_manufact number := 4414;
v_mtc_id number;
v_mcd_id number;
v_fld_id number := 14;
v_meu_id number := 5;
v_mcd_num number := 1;
v_mcd_coeff number := 1;

begin
for x in c loop 
  PK_Util_Vocabulaire.Genere_voc( v_vow_model ,  'VOW_MODEL',    x.VOC_MODEL) ;
  select max(mtc.mtc_id)
  into v_mtc_id
  from tecmtrcfg mtc,
       tecmtrcfgdetail mcd
  where mtc.vow_model = v_vow_model
  and   mtc.vow_manufact = v_vow_manufact
  and   mtc.mtc_id = mcd.mtc_id
  and   mcd.meu_id = v_meu_id
  and   mcd.mcd_wheel = x.NCOM_NBROUE;

  if(v_mtc_id is null) then
       select seq_tecmtrcfg.NEXTVAL    into v_mtc_id   from dual;
      insert into tecmtrcfg
        (mtc_id, mtc_code, mtc_name, vow_manufact, vow_model, FLD_ID)
      values
        (v_mtc_id,
         x.VOC_MODEL || '- X' || x.NCOM_NBROUE,
         x.VOC_MODEL || '- X' || x.NCOM_NBROUE,
         v_vow_manufact,
         v_vow_model,
         v_fld_id);
       
        select seq_tecmtrcfgdetail.NEXTVAL    into v_mcd_id   from dual;
    insert into tecmtrcfgdetail
      (mcd_id, mcd_num, mtc_id, meu_id, mcd_wheel, mcd_coeff)
    values
      (v_mcd_id, v_mcd_num, v_mtc_id, v_meu_id, x.NCOM_NBROUE, v_mcd_coeff);
    
  end if;
    update  tecmeter m set m.mtc_id=v_mtc_id where x.equ_id=m.EQU_ID;
    commit;
end loop;
end;