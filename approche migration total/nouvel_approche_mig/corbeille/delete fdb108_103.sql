declare
  cursor c1
  is
   select cag.cag_id, cag.pre_id, sag.sag_id, sag.spt_id, cot.cot_id, pay.paa_id
   from   agrserviceagr sag,
          agrcustomeragr cag,
          agrcustagrcontact cot,
          agrpayor pay
   where  sag.cag_id = cag.cag_id
   and    sag.sag_comment_a = 'MIGRATION FDB108'
   and    sag.sag_id = cot.sag_id
   and    cot.cot_id = pay.cot_id;
begin
  for s1 in c1 loop
   delete from agrhsagofr where sag_id = s1.sag_id;
   delete from agrsagaco where sag_id = s1.sag_id;
   delete from agrplanningagr where sag_id = s1.sag_id;
   delete from agrsettlement where sag_id = s1.sag_id;
   delete from agrpayor where cot_id = s1.cot_id;
   delete from genpartyparty where paa_id = s1.paa_id;
   delete from agrcustagrcontact where sag_id = s1.sag_id;
   delete from agrserviceagr where sag_id = s1.sag_id;
   delete from agrcustomeragr where cag_id = s1.cag_id;
   delete from gendivspt where spt_id = s1.spt_id;
   delete from tecsptorg where spt_id = s1.spt_id;
   delete from tecpresptcontact where spt_id = s1.pre_id;
   delete from tecservicepoint where spt_id = s1.spt_id
   delete from tecpremise where pre_id = s1.pre_id;
   commit;
  end loop
end;
