 create or replace 
procedure branch_resil (v_district varchar2)
is


cursor c is (select distinct  periode, ref_pdl,etat from (
                select nvl(w.date_action,null) periode ,trim(t.tourne)||trim(t.ordre) ref_pdl,'G' etat
                from branchement t,gestion_compteur w
                where trim(t.etat_branchement)='9'
                and trim(t.compteur_actuel) is null
                and w.district||trim(w.tournee)||trim(w.ordre)=t.district||trim(t.tourne)||trim(t.ordre)
                and UPPER(TRIM(w.ACTION))='D'
                and t.district=v_district
                and w.district=v_district
                and to_date(w.date_action,'dd/mm/yyyy') =
                                           ( select max(to_date(s.date_action,'dd/mm/yyyy'))
                                             from gestion_compteur s
                                             where s.district||trim(s.tournee)||trim(s.ordre)=w.district||trim(w.tournee)||trim(w.ordre)
                                             and UPPER(TRIM(s.ACTION))='D'
                                             ))x
              );
                            
--------------------------------------
cursor F is (select distinct  periode, ref_pdl,etat from(

                              select f.annee||f.periode periode,trim(f.tournee)||trim(f.ordre) ref_pdl,'F' etat
                              from branchement t,facture f
                              where trim(t.etat_branchement)='9'
                              and  trim(t.compteur_actuel) is null
                              and f.district||trim(f.tournee)||trim(f.ordre)=t.district||trim(t.tourne)||trim(t.ordre)
                              and f.district=v_district
                              and t.district=v_district
                              and f.rowid=(select n.rowid
                                            from facture n
                                            where f.district||trim(f.tournee)||trim(f.ordre)=n.district||trim(n.tournee)||trim(n.ordre)
                                            and to_number(n.annee)||to_number(n.periode) =
                                                        (select max(to_number(s.annee)||to_number(s.periode))
                                                         from facture s
                                                         where s.district||trim(s.tournee)||trim(s.ordre)=n.district||trim(n.tournee)||trim(n.ordre)
                                                         )
                                             and rownum=1)
											            )x
	        );

--------------------------
cursor R is (select  periode, ref_pdl,etat from (
													select sf.annee||trim(sf.trim) periode ,trim(sf.tourne)||trim(sf.ordre) ref_pdl,'R' etat
													from fiche_releve  sf,branchement t
													where trim(t.etat_branchement)='9'
													and  trim(t.compteur_actuel) is null
													and sf.district||trim(sf.tourne)||trim(sf.ordre)=t.district||trim(t.tourne)||trim(t.ordre)
													and sf.district=v_district
													and t.district=v_district
													and  sf.rowid = (select f.rowid
																	 from fiche_releve f
																	where trim(f.district)||trim(f.tourne)||trim(f.ordre)=trim(sf.district)||trim(sf.tourne)||trim(sf.ordre)
																	and to_number(f.annee)||to_number(nvl(trim(f.trim),0)) =(select max(to_number(s.annee)||to_number(nvl(trim(s.trim),0)))
																															   from fiche_releve s
																															   where trim(s.district)||trim(s.tourne)||trim(s.ordre)=trim(f.district)||trim(f.tourne)||trim(f.ordre)
																															 )

                                                                    and rownum=1)
											
											    )x
			);
 ------------rest branch_resil
cursor B is select distinct  trim(b.tourne)||trim(b.ordre) ref_pdl 
             from branchement b 
             where trim(b.etat_branchement)='9'
             and b.district=v_district
             and trim(b.tourne)||trim(b.ordre) not in(select r.ref_pdl
                                                           from branchement_res_max r 
                                                           where r.DIST=b.district  )       ;

err_code    varchar2(200);
err_msg     varchar2(200);
v_date      date;
v_trim      number;
v_periode   varchar2(10);
begin

   --delete from  branchement_res m where m.dist=v_district;
   --delete from branchement_res_max b where b.dist=v_district;
   --delete from prob_migration p where p.nom_table in ('Branch_resil','Branch_res_date_res');
   insert into prob_migration (nom_table,val_ref)values(SYSTIMESTAMP||'   START Branch_resil',v_district);
   commit;

  for x in c loop
		begin
		--------------insertion branchement resil (gestion_compteur)
			insert into BRANCHEMENT_RES
			(PERIODE, REF_PDL, ETAT,dist)
			values
			(trim(x.periode), x.ref_pdl, x.etat,v_district);
			commit;
		exception
			when others then
			err_code := SQLCODE;
			err_msg  := SUBSTR(SQLERRM, 1, 200);
			insert into prob_migration
			(nom_table, val_ref, sql_err, date_pro,type_problem)
			values
			('Branch_resil',
			v_district||x.ref_pdl || '--' || x.periode || '--' || x.etat,
			err_code || '--' || err_msg,sysdate,'insertion tab branchement_resil C');
		end;
    commit;

 end loop;


for x in F loop
		begin
		--------------insertion branchement resil(facture)
			insert into BRANCHEMENT_RES
			(PERIODE, REF_PDL, ETAT,dist)
			values
			(trim(x.periode), x.ref_pdl, x.etat,v_district);
			commit;
		exception
		when others then
			err_code := SQLCODE;
			err_msg  := SUBSTR(SQLERRM, 1, 200);

			insert into prob_migration
			(nom_table, val_ref, sql_err, date_pro,type_problem)
			values
			('Branch_resil',
			v_district||x.ref_pdl || '--' || x.periode || '--' || x.etat,
			err_code || '--' || err_msg,sysdate,'insertion tab branchement_resil F');
		end;
		commit;

end loop;


for x in R loop
		begin
		--------------insertion branchement resil(fiche_releve)
			insert into BRANCHEMENT_RES
			(PERIODE, REF_PDL, ETAT,dist)
			values
			(trim(x.periode), x.ref_pdl, x.etat,v_district);
			commit;
		exception
		when others then
			err_code := SQLCODE;
			err_msg  := SUBSTR(SQLERRM, 1, 200);

			insert into prob_migration
			(nom_table, val_ref, sql_err, date_pro,type_problem)
			values
			('Branch_resil',
			v_district||x.ref_pdl || '--' || x.periode || '--' || x.etat,
			err_code || '--' || err_msg,sysdate,'insertion tab branchement_resil  R');
		end;
		commit;

end loop;



-----------------update date_resil
begin
	for c in (select e.ref_pdl refpdl,e.periode,e.rowid,e.etat,e.dist
				from BRANCHEMENT_RES e
				where e.etat in ('F','R','G')
				and e.dist=v_district
			 )
	loop
		v_date:=null;
	  begin
		if (length(c.periode)>6) then
			select '07/'|| LPAD(substr(c.periode,4, 2),2,'0') || '/' ||substr(c.periode,7, 4)
			into v_date
			from dual;

	    elsif(length(c.periode)=5)then

			select '07/'|| LPAD(t.m3, 2,'0')||'/'||substr(c.periode,1, 4)
			into v_date
			from param_tournee t,tourne r
			where trim(r.ntiers)=trim(t.tier)
			and   trim(r.nsixieme)=triM(t.six)
			and   trim(t.district)=v_district
			and   c.dist=v_district
			and   r.district=v_district
			and   r.code=substr(c.refpdl,1,3)
			and   trim(t.trim)=substr(c.periode,5,1)
			and   length(c.periode)=5;

	------------------------------
	    elsif (length(c.periode)=6)then
			for v in  (select r.ref_pdl refpdl,r.periode,r.DIST,r.rowid
			from BRANCHEMENT_RES r
			where r.etat in ('F','R','G')
			and r.ref_pdl=c.refpdl
			and r.etat=c.etat
			and length(c.periode)=6
			and length(r.periode)=6
			and r.DIST=c.dist
			)
			loop

				v_periode:=substr(v.periode,5,2);
				if((v_periode)in('01','02','03')) then
				v_trim:=1;
				elsif((v_periode)in('04','05','06')) then
				v_trim:=2;
				elsif ((v_periode)in('7','8','9')) then
				v_trim:=3;
				elsif((v_periode)in('10','11','12')) then
				v_trim:=4;
				end if;

				select '07/'||LPAD(t.m3,2,'0')||'/'||substr(b.periode,1,4) into v_date
				from param_tournee t,tourne r,BRANCHEMENT_RES  b
				where trim(r.ntiers)=trim(t.tier)
				and   trim(r.nsixieme)=triM(t.six)
				and   trim(t.district)=v.DIST
				and   trim(r.district)=v.DIST
				and trim(t.district)=trim(r.district)
				and   r.code=substr(v.refpdl,1,3)
				and   b.ref_pdl=v.refpdl
				and   trim(b.etat) in ('F','R','G')
				and   trim(t.trim)=v_trim
				and   length(b.periode)=6;
			end loop;

		end if;

	  exception when others then v_date:='01/01/1900';
		err_code := SQLCODE;
		err_msg  := SUBSTR(SQLERRM, 1, 200);
		insert into PROB_MIGRATION
		(nom_table, -- VARCHAR2(100)
		val_ref, --   VARCHAR2(200)
		sql_err, --   VARCHAR2(200)
		date_pro, --  DATE
		type_problem)
		values
		('Branch_res_date_res',
		c.refpdl || '--' || c.periode,
		err_code || '--' || err_msg,
		sysdate,
		'manque date resiliation ');
	  end;

		update BRANCHEMENT_RES b
		set b.date_res = TO_CHAR(ADD_MONTHS(v_date, 1), 'DD/MM/YYYY')
		where b.rowid = c.rowid
		and etat in ('F', 'R', 'G');
		commit;
	end loop;
end;


begin

-----------------insertion branchement resil_max
 insert into branchement_res_max (periode,ref_pdl,etat,date_res,dist)
		 (select m.periode,m.ref_pdl,m.etat,m.date_res,m.dist
		 from branchement_res m
		 where m.dist=v_district
		 and  m.rowid=(select k.rowid from branchement_res k
								where K.Dist||k.ref_pdl=m.dist||m.ref_pdl
								and K.Dist=v_district
								and to_date(k.date_res,'dd/mm/yyyy')=
												   (select max(to_date(d.date_res,'dd/mm/yyyy'))
												   from branchement_res d
												   where d.dist||d.ref_pdl=k.dist||k.ref_pdl )
												   and rownum=1)
        );
commit;
end;



-- todo hkh : inserrer les pdl '9' qui ne sont pas dans branchement_res_max

	for x in B loop
		 insert into branchement_res_max (periode,ref_pdl,etat,date_res,dist)
		 values
		 (sysdate ,x.ref_pdl,'B',sysdate ,v_district);
		 commit;
	end loop;

   insert into prob_migration (nom_table,val_ref)values(SYSTIMESTAMP||'  END Branch_resil',v_district);
   commit;
end ;