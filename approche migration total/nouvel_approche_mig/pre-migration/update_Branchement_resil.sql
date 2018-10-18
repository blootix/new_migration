 declare 
cursor c
is 
 select sag.sag_id,sag.cag_id,spt.spt_id,cot.cot_id,pay.paa_id,t.date_res
 from agrserviceagr sag
   inner join tecservicepoint spt
    on spt.spt_id=sag.spt_id
   inner join agrcustagrcontact cot
    on cot.sag_id=sag.sag_id
   inner join agrpayor pay
    on  pay.cot_id=cot.cot_id
   inner join test.branchement_res_max t
    on t.ref_pdl=substr(spt.spt_refe,1,8)
 where sag.sag_enddt is not null;
begin
  for s1 in c loop
    
     update tecpresptcontact set psc_enddt=s1.date_res
     where spt_id=s1.spt_id;
     
     update tecspstatus set sps_startdt=s1.date_res
     where spt_id=s1.spt_id;
     
     update techequipment set heq_enddt=s1.date_res
     where spt_id=s1.spt_id;
     
     update agrcustomeragr set cag_enddt=s1.date_res
     where cag_id=s1.cag_id;
     
     update agrserviceagr set sag_enddt=s1.date_res
     where sag_id=s1.sag_id;
     
     update agrcustagrcontact set cot_enddt=s1.date_res
     where sag_id=s1.sag_id;
     
     update genpartyparty set paa_enddt=s1.date_res
     where paa_id=s1.paa_id;
     
     update agrsagaco set sco_enddt=s1.date_res
     where sag_id=s1.sag_id;
     
     update agrsettlement set stl_enddt=s1.date_res
     where sag_id=s1.sag_id;
     
     update agrbillingitem set bii_enddt=s1.date_res
     where sag_id=s1.sag_id;
     
     update agrhsagofr set hsf_enddt=s1.date_res
     where sag_id=s1.sag_id;
     
     update agrsubscription set asu_enddt=s1.date_res
     where sag_id=s1.sag_id;
          
     commit;
  end loop;
end;