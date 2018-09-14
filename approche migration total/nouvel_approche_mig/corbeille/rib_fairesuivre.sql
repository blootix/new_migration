declare
	CURSOR C_RIB_PART is select trim(t.banque)||trim(t.agence)||trim(t.num_compte)||trim(t.cle_rib) rib,t.*
						 from branchement t,abonnees a
						 where lpad(trim(a.dist),2,'0')=lpad(trim(t.district),2,'0')
						 and   lpad(trim(a.tou),3,'0') =lpad(trim(t.tourne),3,'0')
						 and   lpad(trim(a.ord),3,'0') =lpad(trim(t.ordre),3,'0')
						 and   trim(a.categ)=5
						 and   trim(t.banque)||trim(t.agence)||trim(t.num_compte)||trim(t.cle_rib) in (select trim(p.rib) from rib_part p);
	CURSOR C_RIB_GC is select trim(t.banque)||trim(t.agence)||trim(t.num_compte)||trim(t.cle_rib) rib,t.*
					   from branchement t,abonnees_gr a
					   where lpad(trim(a.dist),2,'0')=lpad(trim(t.district),2,'0')
					   and   lpad(trim(a.tou),3,'0')=lpad(trim(t.tourne),3,'0')
					   and   lpad(trim(a.ord),3,'0')=lpad(trim(t.ordre),3,'0')
					   and   trim(a.categ)=5
					   and   trim(t.banque)||trim(t.agence)||trim(t.num_compte)||trim(t.cle_rib) in (select trim(p.rib) from rib_gr p);
				 																							 
	CURSOR branch_(district_ varchar2,tourne_ varchar2,ordre_ varchar2) is 
	select  b.*
	from branchement b
	where lpad(trim(b.district),2,'0')= district_
	and   lpad(trim(b.tourne),3,'0')  = tourne_
	and   lpad(trim(b.ordre),3,'0')   = ordre_;
	 
	CURSOR C_PARTY(val_pdl varchar2(50))is select * 
										   from genparty p 
										   where p.par_id in(select r.par_id 
															 from AGRCUSTOMERAGR r
															  where r.cag_id in (select s.cag_id 
																				  from agrserviceagr s 
																				  where s.spt_id in (select t.spt_id 
																									 from tecservicepoint t 
																									 where spt_refe = val_pdl
																									)
																				)
															);					
	cursor C_FPART is select a.adr2,a.codpostal,a.dist,a.tou,a.ord,a.pol,b.*
					  from faire_suivre_part a,branchement b
					  where lpad(trim(a.dist),2,'0')=lpad(trim(b.district),2,'0')
					  and   lpad(trim(a.tou),3,'0')=lpad(trim(b.tourne),3,'0')
					  and   lpad(trim(a.ord),3,'0')=lpad(trim(b.ordre),3,'0')
					  and   lpad(trim(a.pol),5,'0')=lpad(trim(b.police),5,'0');
						
	cursor C_FGC is select a.ad2,a.codpostal,a.dist,a.tou,a.ord,a.pol,b.*
					from faire_suivre_gc a,branchement b
					where lpad(trim(a.dist),2,'0')=lpad(trim(b.district),2,'0')
					and   lpad(trim(a.tou),3,'0') =lpad(trim(b.tourne),3,'0')
					and   lpad(trim(a.ord)),3,'0')=lpad(trim(b.ordre),3,'0')
					and   lpad(trim(a.pol),5,'0') =lpad(trim(b.police),5,'0');
	V_BAN_ID    NUMBER;
	V_BAP_ID    NUMBER;
	V_BAP_NUM   NUMBER;
	V_NBR       NUMBER;
	V_VOW_ID    NUMBER DEFAULT 0;
	V_PAA_ID 	NUMBER DEFAULT 0;
	V_ADR_ID 	NUMBER DEFAULT 0;
	V_PAR_ID 	NUMBER DEFAULT 0;
	V_PDL_REF 	NUMBER;
	V_DATE_START DATE;
  
BEGIN
    FOR i in C_rib_part LOOP
	    FOR B in branch_(lpad(i.district,2,'0'),lpad(trim(i.tourne),3,'0'),lpad(trim(i.ordre),3,'0'))LOOP	
			V_PDL_REF:=lpad(trim(i.district),2,'0')||lpad(trim(i.tourne),3,'0')||lpad(trim(i.ordre),3,'0')||lpad(trim(i.police),5,'0');
		    select count(*) 
			into V_NBR 
			from from genbank 
			where substr(ban_code,1,5)=substr(i.rib,1,5);
			
			if V_NBR=0 then 
				select seq_genbank.nextval 
				into V_BAN_ID  
				from dual;
				insert into genbank(BAN_ID,BAN_CODE,BAN_NAME) 
				values(V_BAN_ID,substr(i.rib,1,5),substr(i.rib,1,2));
			else
				select ban_id 
				into V_BAN_ID 
				from genbank 
				where substr(ban_code,1,5)=substr(i.rib,1,5);
			end if;
	        FOR x in C_PARTY(V_PDL_REF) LOOP
				select seq_genbankparty.nextval 
				into V_BAP_ID  
				from dual;
				
				select nvl(max(BAP_NUM),0)+1 
				into V_BAP_NUM 
				from genbankparty 
				where PAR_ID=x.par_id;
				
				INSERT INTO genbankparty(BAP_ID,BAP_NUM,BAP_NAME,PAR_ID,BAN_ID,BAP_ACCOUNTNUMBER,bap_accountkey,BAP_STATUS,bap_ibannumber)
								  VALUES(V_BAP_ID,V_BAP_NUM,nvl(x.PAR_LNME),x.PAR_ID,V_BAN_ID,i.rib,substr(i.rib,19,2),1,substr(i.rib,6,13));
				V_VOW_ID:=pk_genvocword.getidbycode('VOW_SETTLEMODE',2,null);
				update agrsettlement t 
				set t.VOW_SETTLEMODE=V_VOW_ID,t.bap_id = V_BAP_ID
				where t.sag_id in(select distinct(f.sag_id) 
								  from agrpayor r,
									   agrcustagrcontact f 
								  where r.cot_id=f.cot_id
								  and   f.cot_enddt is null
								  and   f.par_id=i.PAR_ID);
				commit;
			END LOOP;
	    END LOOP;
    END LOOP;
    FOR i in C_rib_GC LOOP
	    FOR B in branch_(lpad(trim(i.district),2,'0'),lpad(trim(i.tourne),3,'0'),lpad(trim(i.ordre),3,'0'))LOOP	
			V_PDL_REF:=lpad(trim(i.district),2,'0')||lpad(trim(i.tourne),3,'0')||lpad(trim(i.ordre),3,'0')||lpad(trim(i.police),5,'0');
		    select count(*) 
			into V_NBR 
			from from genbank 
			where substr(ban_code,1,5)=substr(i.rib,1,5);
			
			if V_NBR=0 then 
				select seq_genbank.nextval 
				into V_BAN_ID  
				from dual;
				insert into genbank(BAN_ID,BAN_CODE,BAN_NAME) 
							 values(V_BAN_ID,substr(i.rib,1,5),substr(i.rib,1,2));
			else
				select ban_id 
				into V_BAN_ID 
				from genbank where substr(ban_code,1,5)=substr(i.rib,1,5);
			end if;
	     
			FOR x in C_PARTY(V_PDL_REF) LOOP
				select seq_genbankparty.nextval 
				into V_BAP_ID  
				from dual;
				select nvl(max(BAP_NUM),0)+1 
				into V_BAP_NUM 
				from genbankparty 
				where PAR_ID=x.par_id;
				insert into genbankparty(BAP_ID,BAP_NUM,BAP_NAME,PAR_ID,BAN_ID,BAP_ACCOUNTNUMBER,bap_accountkey,BAP_STATUS,bap_ibannumber)
								  values(V_BAP_ID,V_BAP_NUM,nvl(x.par_LNME),x.PAR_ID,V_ban_id,i.rib,substr(i.rib,19,2),1,substr(i.rib,6,13));
				V_VOW_ID:=pk_genvocword.getidbycode('VOW_SETTLEMODE',2,null);
				UPDATE agrsettlement t 
				SET t.VOW_SETTLEMODE=V_VOW_ID,t.bap_id = V_BAP_ID
				WHERE t.sag_id in(select distinct(f.sag_id) 
								  from agrpayor r,
									   agrcustagrcontact f 
								  where r.cot_id=f.cot_id
								  and   f.cot_enddt is null
								  and   f.par_id=i.PAR_ID);
				commit;
			END LOOP;
	    END LOOP;
    END LOOP;
----------------------------------------------------------
FOR C in C_FPART LOOP
	FOR x in branch_(lpad(trim(c.district),2,'0'),lpad(trim(c.tourne),3,'0'),lpad(trim(c.ordre),3,'0'))LOOP	   
		select seq_genpartyparty.NEXTVAL 
		into V_PAA_ID 
		from dual;
		
        select d.adr_id 
		into V_ADR_ID 
		from genadress d 
		where d.str_id=(select t.str_id
						from genstreet t
						where t.str_name= c.adr2
						and t.str_zipcode=c.codpostal);			
        V_PDL_REF:=lpad(trim(c.district),2,'0')||lpad(trim(c.tourne),3,'0')||lpad(trim(c.ordre),3,'0')||lpad(trim(c.police),5,'0');
        FOR v in C_PARTY(V_PDL_REF)LOOP
			V_PAR_ID:=v.par_id
        END LOOP;		
		BEGIN
		  select t.paa_startdt 
		  into V_DATE_START 
		  from genpartyparty t 
		  where t.par_parent_id=V_PAR_ID 
		  and rownum = 1;
		EXCEPTION WHEN OTHERS THEN 
		V_DATE_START:=SYSDATE;
		END;
		V_VOW_ID:=pk_genvocword.getidbycode('VOW_PARTYTP','4',null);
        INSERT into genpartyparty(paa_id,par_parent_id,VOW_PARTYTP,ADR_ID,PAA_STARTDT)
                           values(V_PAA_ID,V_PAR_ID,V_VOW_ID,V_ADR_ID,V_DATE_START);
        commit;
	END LOOP;
END LOOP;
V_ADR_ID    =null;
V_PAR_ID    =null;
V_DATE_START=null;
V_VOW_ID    =null;
FOR c in C_FGC LOOP
	FOR x in branch_(lpad(c.district,2,'0'),lpad(trim(c.tourne),3,'0'),lpad(trim(c.ordre),3,'0'))LOOP	   
		select seq_genpartyparty.NEXTVAL into V_PAA_ID from dual;
        select d.adr_id 
		into V_ADR_ID 
		from genadress d 
		where d.str_id=(select t.str_id
						from genstreet t
						where t.str_name= c.adr2
						and t.str_zipcode=c.codpostal); 			
        V_PDL_REF:=lpad(trim(c.district),2,'0')||lpad(trim(c.tourne),3,'0')||lpad(trim(c.ordre),3,'0')||lpad(trim(c.police),5,'0');
        FOR v in C_PARTY(V_PDL_REF)LOOP
		  V_PAR_ID:=v.par_id
        END LOOP;		
		BEGIN
		  select t.paa_startdt 
		  into V_DATE_START 
		  from genpartyparty t 
		  where t.par_parent_id=V_PAR_ID 
		  and rownum = 1;
		EXCEPTION WHEN OTHERS THEN
		 V_DATE_START:=SYSDATE;
		END;
		V_VOW_ID:=pk_genvocword.getidbycode('VOW_PARTYTP','4',null);
        INSERT INTO genpartyparty(paa_id,par_parent_id,VOW_PARTYTP,ADR_ID,PAA_STARTDT)
                           VALUES(V_PAA_ID,V_PAR_ID,V_VOW_ID,v_adr_id,V_DATE_START);
        commit;
		END LOOP;
END LOOP; 
end;
/
