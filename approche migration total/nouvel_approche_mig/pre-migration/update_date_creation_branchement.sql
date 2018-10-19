 declare 
cursor c
is 
 select sag.sag_id,sag.cag_id,spt.spt_id,cot.cot_id,pay.paa_id,t.date_creation
 from agrserviceagr sag
   inner join tecservicepoint spt
    on spt.spt_id=sag.spt_id
   inner join agrcustagrcontact cot
    on cot.sag_id=sag.sag_id
   inner join agrpayor pay
    on  pay.cot_id=cot.cot_id
   inner join test.branchement_min t
    on t.ref_pdl=substr(spt.spt_refe,1,8);
begin
  for s1 in c loop
    
     update tecpresptcontact set psc_startdt=s1.date_creation
     where spt_id=s1.spt_id;
     
     update tecspstatus set sps_startdt=s1.date_creation----------------!!!!!!!!
     where spt_id=s1.spt_id;
     
     update techequipment set heq_startdt=s1.date_creation
     where spt_id=s1.spt_id;
     
     update agrcustomeragr set cag_startdt=s1.date_creation
     where cag_id=s1.cag_id;
     
     update agrserviceagr set sag_startdt=s1.date_creation
     where sag_id=s1.sag_id;
     
     update agrcustagrcontact set cot_startdt=s1.date_creation
     where sag_id=s1.sag_id;
     
     update genpartyparty set paa_startdt=s1.date_creation
     where paa_id=s1.paa_id;
     
     update agrsagaco set sco_startdt=s1.date_creation
     where sag_id=s1.sag_id;
     
     update agrsettlement set stl_startdt=s1.date_creation
     where sag_id=s1.sag_id;
     
     update agrbillingitem set bii_startdt=s1.date_creation
     where sag_id=s1.sag_id;
     
     update agrhsagofr set hsf_startdt=s1.date_creation
     where sag_id=s1.sag_id;
     
     update agrsubscription set asu_startdt=s1.date_creation
     where sag_id=s1.sag_id;
          
     commit;
  end loop;
end;