create or replace procedure miwt_rib
is
begin
execute immediate 'alter session set nls_date_format = ''dd/mm/yyyy''';
execute immediate 'alter session set NLS_NUMERIC_CHARACTERS = '',.''';
    --**************************************************
delete MIWTRIB ;
insert into prob_migration (nom_table)values(SYSTIMESTAMP||'   START Miwtrib');
commit;
	for rib_ in (select trim(t.banque)||trim(t.agence)||trim(t.num_compte)||trim(t.cle_rib) rib,t.district,t.tourne,t.ordre
				  from branchement t,abonnees a
				  where lpad(trim(a.dist),2,'0')=lpad(trim(t.district),2,'0')
				  and   lpad(trim(a.tou),3,'0') =lpad(trim(t.tourne),3,'0')
				  and   lpad(trim(a.ord),3,'0') =lpad(trim(t.ordre),3,'0')
				  and   trim(a.categ)=5
				  and   trim(t.banque)||trim(t.agence)||trim(t.num_compte)||trim(t.cle_rib) in (select trim(p.rib) 
																							 from rib_part p)  
				)
 	loop

			insert into MIWTRIB
			 (
			  MRIB_SOURCE   ,--1
			  MRIB_REF      ,--2
			  MRIB_BANQUE   ,--3
			  MRIB_GUICHET  ,--4
			  MRIB_AGENCE   ,--5
			  MRIB_COMPTE   ,--6
			  MRIB_CLE_RIB  ,--7
			  MRIB_TITULAIRE,--8
			  MRIB_ISO_IBAN ,--9
			  MRIB_BIC      ,--10
			  MRIB_RUM      ,--11
			  MRIB_RUMDT     --12
			 )
			values
			(
			 'DIST'||lpad(rib_.district,2,'0'),--1
			 lpad(rib_.district,2,'0')||lpad(trim(rib_.tourne),3,'0')||lpad(trim(rib_.ordre),3,'0'),--2
			 substr(rib_.rib,1,2),--3
			 substr(rib_.rib,3,3),--4
			 NULL                ,--5
			 rib_.rib            ,--6
			 substr(rib_.rib,19,2),--7
			 null                ,--8
			 null                ,--9
			 null                ,--10
			 null                ,--11
			 null                 --12
			);
	end loop;

	for rib_ in (select ltrim(rtrim(t.banque))||ltrim(rtrim(t.agence))||ltrim(rtrim(t.num_compte))||ltrim(rtrim(t.cle_rib)) rib,t.district,t.tourne,t.ordre
				  from branchement t,abonnees_gr a
				  where lpad(trim(a.dist),2,'0')=trim(t.district)
				  and   lpad(trim(a.tou),3,'0') =lpad(trim(t.tourne),3,'0')
				  and   lpad(trim(a.ord),3,'0') =lpad(trim(t.ordre),3,'0')
				  and   trim(a.categ)=5
				  and   trim(t.banque)||trim(t.agence)||trim(t.num_compte)||trim(t.cle_rib) in (select trim(p.rib) from rib_gr p)
				) 
	loop
			insert into MIWTRIB
			(
				MRIB_SOURCE  ,--1
				MRIB_REF     ,--2
				MRIB_BANQUE  ,--3
				MRIB_GUICHET ,--4
				MRIB_AGENCE  ,--5
				MRIB_COMPTE  ,--6
				MRIB_CLE_RIB ,--7
				MRIB_TITULAIRE,--8
				MRIB_ISO_IBAN,--9
				MRIB_BIC     ,--10
				MRIB_RUM     ,--11
				MRIB_RUMDT    --12
			)
		   values
		   (
			'DIST'||lpad(rib_.district,2,'0')  ,--1
			lpad(rib_.district,2,'0')||lpad(trim(rib_.tourne),3,'0')||lpad(trim(rib_.ordre),3,'0'),--2
			substr(rib_.rib,1,2),--3
			substr(rib_.rib,3,3),--4
			NULL                ,--5
			rib_.rib            ,--6
			substr(rib_.rib,19,2),--7
			null                ,--8
			null                ,--9
			null                ,--10
			null                ,--11
			null                 --12
			);
	end loop;	
insert into prob_migration (nom_table)values(SYSTIMESTAMP||'   END Miwtrib');
commit;
end;

