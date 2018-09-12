--drop table  mig_pivot_24.miwtrib;
--create table  mig_pivot_24.miwtrib as (select * from  mig_pivot_24. mig_pivot_24.miwtrib);
declare
  cursor c 
  is 
    select t.ban_id,m.par_id,t.mrib_titulaire,t.mrib_compte,m.mper_nom 
	from  mig_pivot_24.miwtrib t, mig_pivot_24.miwabn p, mig_pivot_24.miwtpersonne m
    where  p.abn_refsite like t.mrib_ref||'%'
    and    p.abn_refper_a=m.mper_ref
    and    t.ban_id is null;
    
  nbr_ban_id number;
  nbr_BAP_ID number;
  nbr_BAP_NUM number;
  lib_bank varchar2(100);
  V_VOW_ID NUMBER DEFAULT 0;
begin
  --select nvl(max(BAP_ID),0) into nbr_BAP_ID from genbankparty;

  
  for i in c loop
    --select nvl(max(ban_id),0) into nbr_ban_id from genbank;
	
	
    if i.ban_id is null then
      --nbr_ban_id:=nbr_ban_id+1;
	   select seq_genbank.nextval into nbr_ban_id  from dual ;
      begin
        select ban_name,ban_id into lib_bank,nbr_ban_id from genbank where substr(ban_code,1,5)=substr(i.mrib_compte,1,5);
      exception when no_data_found then lib_bank:='a identifier';
      end;
      
      if lib_bank = 'a identifier' then
         insert into genbank(BAN_ID,BAN_CODE,BAN_NAME) values(nbr_ban_id,substr(i.mrib_compte,1,5),substr(i.mrib_compte,1,2));
      end if;
    else
      nbr_ban_id:=i.ban_id;
    end if;
    --nbr_BAP_ID:=nbr_BAP_ID+1;
	
    select seq_genbankparty.nextval into nbr_BAP_ID  from dual ;
	
    select nvl(max(BAP_NUM),0)+1 into nbr_BAP_NUM from genbankparty where PAR_ID=i.PAR_ID;
    insert into genbankparty(
    BAP_ID,--1
    BAP_NUM ,--
    BAP_NAME,--
    PAR_ID ,--
    BAN_ID ,--
    BAP_ACCOUNTNUMBER,--
    bap_accountkey,--
    BAP_STATUS,--
    bap_ibannumber--
    )
    values (
    nbr_BAP_ID,--
    nbr_BAP_NUM,--
    nvl(i.mrib_titulaire,i.mper_nom),--
    i.PAR_ID,--
    nbr_ban_id,--
    i.mrib_compte,--
    substr(i.mrib_compte,19,2),--
    1,
    substr(i.mrib_compte,6,13)--
    );
    update  mig_pivot_24.miwtrib a set a.ban_id = nbr_BAP_ID;
    
    V_VOW_ID:=pk_genvocword.getidbycode('VOW_SETTLEMODE',2,null) ;
    update agrsettlement t set t.VOW_SETTLEMODE=V_VOW_ID, t.bap_id = nbr_BAP_ID
    where t.sag_id in(select distinct(f.sag_id) 
                      from agrpayor r,
                           agrcustagrcontact f 
                      where r.cot_id=f.cot_id
                      and   f.cot_enddt is null
                      and   f.par_id=i.PAR_ID);
    commit;
  end loop;
end;
/
