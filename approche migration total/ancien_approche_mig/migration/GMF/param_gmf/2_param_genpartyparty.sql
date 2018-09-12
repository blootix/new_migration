create or replace procedure param_GENPARTYPARTY(district_ varchar2)
is
 
v_paa_id number;
v_vow_partytp number;
-------------------------
 cursor Dgen is select p.par_id 
 from genparty p 
 where p.par_lname='DIRECTION GENERALE'
 and p.par_refe='D.G.'||district_;
 
cursor Dexp is select p.par_id 
from genparty p 
where p.par_lname='DIRECTION EXPLOITATION' 
and p.par_refe='D.E.'||district_;

 ----------------------------------------
  cursor Setud is select p.par_id 
  from genparty p 
  where p.par_lname= 'SERVICE ETUDES'
  and  p.par_refe='S.E.'||district_;

 cursor betud is select p.par_id 
 from genparty p 
 where p.par_lname='BUREAU ETUDE'
 and p.par_refe='B.E.'||district_;
 
  cursor SREG is select p.par_id 
 from genparty p 
  where p.par_lname='SECTION REGULATION'
   and p.par_refe='S.R.'||district_;
  
  -------------
  cursor dist is select p.par_id 
  from genparty p 
  where p.par_lname= 'DISTRICT'||district_
  and  p.par_refe=district_;
  
  
  cursor SADM is select p.par_id 
  from genparty p 
  where p.par_lname= 'SERVICE ADM. FIN. JUR. (S.A.F.J)'
  and  p.par_refe='S.A.F.J.'||district_;
  
  --------------------
    
 cursor BUA is select p.par_id 
  from genparty p 
  where p.par_lname='BUREAU ABONNE'
   and  p.par_refe='B.A.'||district_;

 cursor BUR is select p.par_id 
  from genparty p 
  where p.par_lname='BUREAU RELEVE'
and  p.par_refe='B.R.'||district_;

cursor SAD is select p.par_id 
  from genparty p 
  where p.par_lname='SECTION ADMINISTRATIVE'
  AND p.par_refe='S.A.'||district_;
  
  ----------------------------
  cursor SON is select p.par_id 
  from genparty p 
  where p.par_lname='SONEDE';
  ----------------------------------
  cursor DIRG is select p.par_id 
  from genparty p 
  where p.par_lname='DIRECTION REGIONAL GRAND TUNIS'
  AND p.par_refe='D.R.G.T.'||district_;
  --------------------------------------
  
   cursor SEXP is select p.par_id 
  from genparty p 
  where p.par_lname='SERVICE EXPLOITATION'
  AND p.par_refe='S.EXP.'||district_;
  
  cursor UTR1 is select p.par_id 
  from genparty p 
  where p.par_lname='UNITE TRAVEAUX 1'
  AND p.par_refe='U.T.1.'||district_;
      
  cursor UTR2 is select p.par_id 
  from genparty p 
  where p.par_lname='UNITE TRAVEAUX 2'
  and 	p.par_refe='U.T.2.'||district_;
  
cursor SMA is select p.par_id 
  from genparty p 
  where p.par_lname='SECTION MAINTENANCE'
  and 	p.par_refe='S.M.'||district_;

cursor MAG is select p.par_id 
  from genparty p 
  where p.par_lname='MAGASIN'
  and	p.par_refe='MAG.'||district_;

 begin
 v_vow_partytp:=2888;
 
 for x in Dgen loop
     for j in Dexp loop
  select seq_GENPARTYPARTY.nextval into v_paa_id from dual;
  
  insert into GENPARTYPARTY
							(
							  paa_id        ,
							  par_parent_id ,
							  par_id        ,
							  vow_partytp   ,
							  paa_startdt   ,
							  paa_enddt     ,
							  paa_credt     
							) 
						values
							(
							  v_paa_id,
							  x.par_id,
							  j.par_id,
							  v_vow_partytp,
							  '01/01/2015',
							  null,
							  sysdate
							);
           commit;
		end loop;
end loop;

for x in Setud loop
  
	for a in betud loop
	select seq_GENPARTYPARTY.nextval  into v_paa_id from dual;
	insert into GENPARTYPARTY
						( 
						  paa_id        ,
						  par_parent_id ,
						  par_id        ,
						  vow_partytp   ,
						  paa_startdt   ,
						  paa_enddt     ,
						  paa_credt     
						) 
						values
						( 
						  v_paa_id,
						  x.par_id,
						  a.par_id,
						  v_vow_partytp,
						  '01/01/2015',
						  null,
						  sysdate
						);
           commit;

  end loop;
  for b in SREG loop 
     select seq_GENPARTYPARTY.nextval  into v_paa_id from dual;
	  insert into GENPARTYPARTY
				( 
				  paa_id        ,
				  par_parent_id ,
				  par_id        ,
				  vow_partytp   ,
				  paa_startdt   ,
				  paa_enddt     ,
				  paa_credt     
				) 
			values
				( 
				  v_paa_id,
				  x.par_id,
				  b.par_id,
				  v_vow_partytp,
				  '01/01/2015',
				  null,
				  sysdate
				);
           commit;
		end loop;

end loop;

for x in dist loop
    for a in SADM loop
	   select seq_GENPARTYPARTY.nextval  into v_paa_id from dual;
	  insert into GENPARTYPARTY
				( 
				  paa_id        ,
				  par_parent_id ,
				  par_id        ,
				  vow_partytp   ,
				  paa_startdt   ,
				  paa_enddt     ,
				  paa_credt     
				) 
			values
				( 
				  v_paa_id,
				  x.par_id,
				  a.par_id,
				  v_vow_partytp,
				  '01/01/2015',
				  null,
				  sysdate
				);
			   commit;
          end loop;
 for b in Setud loop 
     select seq_GENPARTYPARTY.nextval  into v_paa_id from dual;
		  insert into GENPARTYPARTY
								( 
								  paa_id        ,
								  par_parent_id ,
								  par_id        ,
								  vow_partytp   ,
								  paa_startdt   ,
								  paa_enddt     ,
								  paa_credt     
								  ) 
								values
								 ( 
								  v_paa_id,
								  x.par_id,
								  b.par_id,
								  v_vow_partytp,
								  '01/01/2015',
								  null,
								  sysdate
								);
           commit;
		end loop;

  for c in Dexp loop 
     select seq_GENPARTYPARTY.nextval  into v_paa_id from dual;
	 
	  insert into GENPARTYPARTY
						( 
						  paa_id        ,
						  par_parent_id ,
						  par_id        ,
						  vow_partytp   ,
						  paa_startdt   ,
						  paa_enddt     ,
						  paa_credt     
						) 
				values
						( 
						  v_paa_id,
						  x.par_id,
						  c.par_id,
						  v_vow_partytp,
						  '01/01/2015',
						  null,
						  sysdate
						);
           commit;
		end loop;
end loop;

for x in SADM loop
	for a in BUA loop
		   select seq_GENPARTYPARTY.nextval  into v_paa_id from dual;
		  insert into GENPARTYPARTY
				 (
				  paa_id        ,
				  par_parent_id ,
				  par_id        ,
				  vow_partytp   ,
				  paa_startdt   ,
				  paa_enddt     ,
				  paa_credt     
				  ) 
				values
				 (
				  v_paa_id,
				  x.par_id,
				  a.par_id,
				  v_vow_partytp,
				  '01/01/2015',
				  null,
				  sysdate
				  );
				   commit;
                end loop;
		  
			  for b in BUR loop 
	 select seq_GENPARTYPARTY.nextval into v_paa_id from dual;
			  insert into GENPARTYPARTY
					( 
					  paa_id        ,
					  par_parent_id ,
					  par_id        ,
					  vow_partytp   ,
					  paa_startdt   ,
					  paa_enddt     ,
					  paa_credt     
					 ) 
					values
					(
					  v_paa_id,
					  x.par_id,
					  b.par_id,
					  v_vow_partytp,
					  '01/01/2015',
					  null,
					  sysdate
					);
					   commit;
			end loop;

  for c in SAD loop 
     select seq_GENPARTYPARTY.nextval into v_paa_id from dual;
		  insert into GENPARTYPARTY
				( 
				  paa_id        ,
				  par_parent_id ,
				  par_id        ,
				  vow_partytp   ,
				  paa_startdt   ,
				  paa_enddt     ,
				  paa_credt     
				) 
				values
				(
				  v_paa_id,
				  x.par_id,
				  c.par_id,
				  v_vow_partytp,
				  '01/01/2015',
				  null,
				  sysdate
				);
				   commit;
end loop;
end loop;



for x in SON loop
     for j in dist loop
  select seq_GENPARTYPARTY.nextval  into v_paa_id from dual;
  
  insert into GENPARTYPARTY
						( 
						  paa_id        ,
						  par_parent_id ,
						  par_id        ,
						  vow_partytp   ,
						  paa_startdt   ,
						  paa_enddt     ,
						  paa_credt     
						) 
					values
						( 
						  v_paa_id,
						  x.par_id,
						  j.par_id,
						  v_vow_partytp,
						  '01/01/2015',
						  null,
						  sysdate
						);
           commit;
end loop;
end loop;


for x in Dexp loop
     for j in DIRG loop
  select seq_GENPARTYPARTY.nextval  into v_paa_id from dual;
  
  insert into GENPARTYPARTY
						(
						  paa_id        ,
						  par_parent_id ,
						  par_id        ,
						  vow_partytp   ,
						  paa_startdt   ,
						  paa_enddt     ,
						  paa_credt     
						 ) 
					values
						 (
						  v_paa_id,
						  x.par_id,
						  j.par_id,
						  v_vow_partytp,
						  '01/01/2015',
						  null,
						  sysdate
						 );
           commit;
end loop;
end loop;


for x in DIRG loop
     for j in dist loop
		select seq_GENPARTYPARTY.nextval  into v_paa_id from dual;
		  
		  insert into GENPARTYPARTY
				(
				  paa_id        ,
				  par_parent_id ,
				  par_id        ,
				  vow_partytp   ,
				  paa_startdt   ,
				  paa_enddt     ,
				  paa_credt     
				 ) 
				values
				 (
				  v_paa_id,
				  x.par_id,
				  j.par_id,
				  v_vow_partytp,
				  '01/01/2015',
				  null,
				  sysdate
                 );
           commit;
	end loop;
end loop;

for x in SEXP loop
   for a in UTR1 loop
		   select seq_GENPARTYPARTY.nextval  into v_paa_id from dual;
		  insert into GENPARTYPARTY
				 (
				  paa_id        ,
				  par_parent_id ,
				  par_id        ,
				  vow_partytp   ,
				  paa_startdt   ,
				  paa_enddt     ,
				  paa_credt     
				  ) 
				values
				 (
				  v_paa_id,
				  x.par_id,
				  a.par_id,
				  v_vow_partytp,
				  '01/01/2015',
				  null,
				  sysdate
				  );
				   commit;

		  end loop;
		  for b in UTR2 loop 
			 select seq_GENPARTYPARTY.nextval  into v_paa_id from dual;
		  insert into GENPARTYPARTY
				 ( 
				  paa_id        ,
				  par_parent_id ,
				  par_id        ,
				  vow_partytp   ,
				  paa_startdt   ,
				  paa_enddt     ,
				  paa_credt     
				  ) 
				values
				(
				  v_paa_id,
				  x.par_id,
				  b.par_id,
				  v_vow_partytp,
				  '01/01/2015',
				  null,
				  sysdate
				 );
				   commit;
		end loop;

		  for c in SMA loop 
			 select seq_GENPARTYPARTY.nextval  into v_paa_id from dual;
		  insert into GENPARTYPARTY
				( 
				  paa_id        ,
				  par_parent_id ,
				  par_id        ,
				  vow_partytp   ,
				  paa_startdt   ,
				  paa_enddt     ,
				  paa_credt     
				) 
				values
				(
				  v_paa_id,
				  x.par_id,
				  c.par_id,
				  v_vow_partytp,
				  '01/01/2015',
				  null,
				  sysdate
				);
				   commit;
		end loop;
		  for d in  MAG loop 
			 select seq_GENPARTYPARTY.nextval  into v_paa_id from dual;
		  insert into GENPARTYPARTY
				 (
				  paa_id        ,
				  par_parent_id ,
				  par_id        ,
				  vow_partytp   ,
				  paa_startdt   ,
				  paa_enddt     ,
				  paa_credt     
				  ) 
				values
				 (
				  v_paa_id,
				  x.par_id,
				  d.par_id,
				  v_vow_partytp,
				  '01/01/2015',
				  null,
				  sysdate
				 );
				   commit;
		end loop;
end loop;

end;
/
