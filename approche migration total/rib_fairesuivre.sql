declare
	cursor C_rib_part is select trim(t.banque)||trim(t.agence)||trim(t.num_compte)||trim(t.cle_rib) rib,t.*
						 from branchement t,abonnees a
						 where lpad(trim(a.dist),2,'0')=trim(t.district)
						 and   lpad(trim(a.tou),3,'0')=lpad(trim(t.tourne),3,'0')
						 and   lpad(trim(a.ord),3,'0')=lpad(trim(t.ordre),3,'0')
						 and   trim(a.categ)=5
						 and trim(t.banque)||trim(t.agence)||trim(t.num_compte)||trim(t.cle_rib) in (select trim(p.rib) from rib_part p);
	cursor C_rib_GC   is select trim(t.banque)||trim(t.agence)||trim(t.num_compte)||trim(t.cle_rib) rib,t.*
						 from branchement t,abonnees_gr a
					     where lpad(trim(a.dist),2,'0')=trim(t.district)
					     and   lpad(trim(a.tou),3,'0')=lpad(trim(t.tourne),3,'0')
					     and   lpad(trim(a.ord),3,'0')=lpad(trim(t.ordre),3,'0')
					     and   trim(a.categ)=5
					     and trim(t.banque)||trim(t.agence)||trim(t.num_compte)||trim(t.cle_rib) in (select trim(p.rib) from rib_gr p);
				 																							 
	cursor branch_(district_ varchar2, tourne_ varchar2, ordre_ varchar2) is 
	select  b.*
	from branchement b
	where  lpad(trim(b.district),2,'0')=district_
	and lpad(trim(b.tourne),3,'0') = tourne_
	and lpad(trim(b.ordre),3,'0') = ordre_;
	 
	cursor c_party(val_pdl varchar2(50))is select * 
										   from genparty p 
										   where p.par_id in(select r.par_id 
															 from AGRCUSTOMERAGR r
															  where r.cag_id in (select s.cag_id 
																				  from agrserviceagr s 
																				  where s.spt_id in (select t.spt_id 
																									 from tecservicepoint t 
																									 where spt_refe = val_pdl;
																									)
																				)
	cursor C_FPART is select a.adr2,a.codpostal,a.dist,a.tou,a.ord,a.pol,b.*
					  from faire_suivre_part a,branchement b
					  where lpad(ltrim(rtrim(a.dist)),2,'0')=trim(b.district)
					  and   lpad(ltrim(rtrim(a.tou)),3,'0')=lpad(trim(b.tourne),3,'0')
					  and   lpad(ltrim(rtrim(a.ord)),3,'0')=lpad(trim(b.ordre),3,'0')
					  and   lpad(ltrim(rtrim(a.pol)),5,'0')=lpad(trim(b.police),5,'0');
						
	cursor C_FGC is select a.ad2,a.codpostal,a.dist,a.tou,a.ord,a.pol,b.*
					from faire_suivre_gc a,branchement b
					where lpad(trim(a.dist),2,'0')=trim(b.district)
					and   lpad(trim(a.tou),3,'0')=lpad(trim(b.tourne),3,'0')
					and   lpad(trim(a.ord)),3,'0')=lpad(trim(b.ordre),3,'0')
					and   lpad(trim(a.pol),5,'0')=lpad(trim(b.police),5,'0');														);
	nbr_ban_id number;
	nbr_BAP_ID number;
	nbr_BAP_NUM number;
	v_nbr       number;
	pdl_ref varchar2(50);
	lib_bank varchar2(100);
	V_VOW_ID NUMBER DEFAULT 0;
	v_paa_id number default 0;
	v_adr_id number default 0;
	v_par_id number default 0;
	v_pdl_ref number;
	v_date_start date;
	d1 number;
	d2 number;
  
begin
    for i in C_rib_part loop
	
	    FOR x in branch_(lpad(i.district,2,'0'),lpad(trim(i.tourne),3,'0'),lpad(trim(i.ordre),3,'0'))LOOP	
			v_pdl_ref:=lpad(i.district,2,'0')||lpad(trim(i.tourne),3,'0')||lpad(trim(i.ordre),3,'0')||lpad(trim(i.police),5,'0');
		    select count(*) 
			into v_nbr 
			from from genbank 
			where substr(ban_code,1,5)=substr(i.rib,1,5);
			
			if v_nbr=0 then 
			select seq_genbank.nextval into nbr_ban_id  from dual ;
			insert into genbank(BAN_ID,BAN_CODE,BAN_NAME) 
			values(nbr_ban_id,substr(i.rib,1,5),substr(i.rib,1,2));
			else
			select ban_name,ban_id 
			into lib_bank,nbr_ban_id 
			from genbank where substr(ban_code,1,5)=substr(i.rib,1,5);
			end if ;
	 
	 	    select seq_genbankparty.nextval 
			into nbr_BAP_ID  
			from dual ;
			for x in c_party(v_pdl_ref) loop
				select nvl(max(BAP_NUM),0)+1 
				into nbr_BAP_NUM 
				from genbankparty 
				where PAR_ID=x.par_id 
		
			insert into genbankparty(BAP_ID,BAP_NUM,BAP_NAME,PAR_ID,BAN_ID,BAP_ACCOUNTNUMBER,bap_accountkey,BAP_STATUS,bap_ibannumber)
			values (nbr_BAP_ID,nbr_BAP_NUM,nvl(x.par_LNME),x.PAR_ID,nbr_ban_id,i.rib,substr(i.rib,19,2),1,substr(i.rib,6,13));
    
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
	    end loop;
  end loop;
  
  
  for i in C_rib_GC loop
	
	    FOR x in branch_(lpad(i.district,2,'0'),lpad(trim(i.tourne),3,'0'),lpad(trim(i.ordre),3,'0'))LOOP	
			pdl_ref:=lpad(i.district,2,'0')||lpad(trim(i.tourne),3,'0')||lpad(trim(i.ordre),3,'0')||lpad(trim(i.police),5,'0');
		    select count(*) 
			into v_nbr 
			from from genbank 
			where substr(ban_code,1,5)=substr(i.rib,1,5);
			
			if v_nbr=0 then 
			select seq_genbank.nextval into nbr_ban_id  from dual ;
			insert into genbank(BAN_ID,BAN_CODE,BAN_NAME) 
			values(nbr_ban_id,substr(i.rib,1,5),substr(i.rib,1,2));
			else
			select ban_name,ban_id 
			into lib_bank,nbr_ban_id 
			from genbank where substr(ban_code,1,5)=substr(i.rib,1,5);
			end if ;
	 
	 	    select seq_genbankparty.nextval 
			into nbr_BAP_ID  
			from dual ;
			for x in c_party(pdl_ref) loop
				select nvl(max(BAP_NUM),0)+1 
				into nbr_BAP_NUM 
				from genbankparty 
				where PAR_ID=x.par_id 
		
			insert into genbankparty(BAP_ID,BAP_NUM,BAP_NAME,PAR_ID,BAN_ID,BAP_ACCOUNTNUMBER,bap_accountkey,BAP_STATUS,bap_ibannumber)
			values (nbr_BAP_ID,nbr_BAP_NUM,nvl(x.par_LNME),x.PAR_ID,nbr_ban_id,i.rib,substr(i.rib,19,2),1,substr(i.rib,6,13));
    
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
	    end loop;
  end loop;
 
for c in C_FPART loop
			
	FOR x in branch_(lpad(c.district,2,'0'),lpad(trim(c.tourne),3,'0'),lpad(trim(c.ordre),3,'0'))LOOP	   
		
		select seq_genpartyparty.NEXTVAL into v_paa_id from dual;
        select d.adr_id 
		into v_adr_id 
		from genadress d 
		where d.str_id=(select t.str_id
					from genstreet t
					where t.str_name= c.adr2
					and t.str_zipcode=c.codpostal);
		v_pdl_ref =null;			
        v_pdl_ref:=lpad(c.district,2,'0')||lpad(trim(c.tourne),3,'0')||lpad(trim(c.ordre),3,'0')||lpad(trim(c.police),5,'0');
        
		for x in c_party(v_pdl_ref)loop
		v_par_id:=x.par_id
        end loop;		
			 
		begin
		  select t.paa_startdt 
		  into v_date_start 
		  from genpartyparty t 
		  where t.par_parent_id=v_par_id 
		  and rownum = 1;
		 exception when others then v_date_start:=sysdate;
		end;
 
         insert into genpartyparty(paa_id,par_parent_id,VOW_PARTYTP,ADR_ID,PAA_STARTDT)
                           values(v_paa_id,v_par_id,pk_genvocword.getidbycode('VOW_PARTYTP','4',null),v_adr_id,v_date_start);
        commit;
		end loop;
end loop;

v_adr_id=null;
v_par_id=null;
v_date_start=null;

for c in C_FGC loop
			
	FOR x in branch_(lpad(c.district,2,'0'),lpad(trim(c.tourne),3,'0'),lpad(trim(c.ordre),3,'0'))LOOP	   
		
		select seq_genpartyparty.NEXTVAL into v_paa_id from dual;
        select d.adr_id 
		into v_adr_id 
		from genadress d 
		where d.str_id=(select t.str_id
					from genstreet t
					where t.str_name= c.adr2
					and t.str_zipcode=c.codpostal);
		v_pdl_ref =null;			
        v_pdl_ref:=lpad(c.district,2,'0')||lpad(trim(c.tourne),3,'0')||lpad(trim(c.ordre),3,'0')||lpad(trim(c.police),5,'0');
        
		for x in c_party(v_pdl_ref)loop
		v_par_id:=x.par_id
        end loop;		
			 
		begin
		  select t.paa_startdt 
		  into v_date_start 
		  from genpartyparty t 
		  where t.par_parent_id=v_par_id 
		  and rownum = 1;
		 exception when others then v_date_start:=sysdate;
		end;
 
         insert into genpartyparty(paa_id,par_parent_id,VOW_PARTYTP,ADR_ID,PAA_STARTDT)
                            values(v_paa_id,v_par_id,pk_genvocword.getidbycode('VOW_PARTYTP','4',null),v_adr_id,v_date_start);
        commit;
		end loop;
end loop; 
end;
/
