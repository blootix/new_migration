    declare 
    v_ID_FACTURE     varchar2(20);
    periode_         number;
    version          number(1) := 0;
    date_            date;
    anneereel_       varchar2(4);
    annee_          varchar2(4);
	v_nbr	 number;
   begin
for facture_ in (select * from facture_as400 ) loop
 select last_day(to_date('01'||lpad(facture_.refc03,2,'0')||facture_.refc04,'ddmmyy')) 
       into date_
       from dual;
  if(to_number(facture_.refc01)<to_number(facture_.refc03))then
        anneereel_ := '20'||facture_.refc04;
       else
        anneereel_ := '20'||to_char((to_number(facture_.refc04)-1));
       end if;
begin
        select TRIM 
                into periode_
                from param_tournee p
                where p.DISTRICT=facture_.dist
                And p.m1 =facture_.refc01
                And p.m2 = facture_.refc02
                And p.m3 = facture_.refc03
                And (p.TIER,p.SIX) in (select t.NTIERS,t.NSIXIEME
                                   from tourne t
                                   where trim(t.code)=lpad(facture_.tou,3,'0')
                                   and trim(t.district)=trim(p.DISTRICT)
                                   and trim(t.district)=facture_.dist);
        exception
          when others then
               periode_ := 1;
        end;
        v_ID_FACTURE:=lpad(trim(facture_.DIST),2,'0') ||
                      lpad(trim(facture_.tou),3,'0') ||
                      lpad(trim(facture_.ORD),3,'0')||
                      to_char(anneereel_) ||
                      lpad(to_char(periode_),2,'0')||to_char(version);
insert into test_migration values (v_ID_FACTURE,'facture_as400',null);
commit;  
end loop ; 
  for facture_ in (select * from facture_as400gc ) loop
      select last_day(to_date('01'||lpad(facture_.refc01,2,'0')||facture_.refc02,'ddmmyy')) 
       into date_
       from dual;
      periode_ := facture_.refc01;
      annee_ :=to_char(date_,'yyyy');
	  
          v_ID_FACTURE:=lpad(trim(facture_.DIST),2,'0') ||
                    lpad(trim(facture_.tou)),3,'0') ||
                     lpad(trim(facture_.ORD)),3,'0')||
                     to_char(annee_) || lpad(to_char(periode_),2,0)||to_char(version);


      insert into test_migration  values (v_ID_FACTURE,'facture_as400gc',null);
      commit;
	  
end loop;
/*for facture_ in ( select  distinct   ltrim(rtrim(f.district)) ||
                        lpad(ltrim(rtrim(f.tournee)),3,'0') ||
                        lpad(ltrim(rtrim(f.ordre)),3,'0')||
                        trim(f.annee) ||
                        lpad(trim(f.PERIODE),2,0)||0 ref,ltrim(rtrim(f.district)) dist
                    from DISTRICT09.facture f
                    where trim(f.ANNEE)>='2015'
                    and trim(f.annee)||trim(f.periode) not in ( select  substr(j.reference,9,4)||substr(j.reference,14,1)
                                                                from test_migration j
                                                                where substr(j.reference,1,8)= 
                                                                trim(f.DISTRICT)||
                                                                lpad(trim(f.tournee),3,'0')||
                                                                lpad(trim(f.ORDRE),3,'0')
                                                                and j.type in ('facture_as400','facture_as400gc')
                                                                and j.CODE_DIST=f.DISTRICT
                                                              )
       ) loop
 
                     
    insert into test_migration values ( facture_.ref,'facture_');     
commit;
end loop;*/
end ;
 ------------------
 -----------facture_as400 
 update  VERIF_CALC_MIGRATION m 
  set m.FACT_AS400_S=(select  count(distinct m.REFERENCE)
                      from test_migration m 
                      where m.type='facture_as400'
                       and m.CODE_DIST='01')
 where m.DIV_CODE='01';
 
  update  VERIF_CALC_MIGRATION m 
  set m.FACT_AS400_P= (select count(*) 
                       from genbill b
                       where b.bil_code in (select   distinct m.REFERENCE
                                            from test_migration m 
                                            where m.type='facture_as400'
                                            and m.CODE_DIST='01'))
 where m.DIV_CODE='01';
 
---------------------------------------facture_as400gc 
 
 update  VERIF_CALC_MIGRATION m 
  set m.FACT_AS400gc_S=(select  count(distinct m.REFERENCE)
                      from test_migration m 
                      where m.type='facture_as400gc'
                       and m.CODE_DIST='01')
 where m.DIV_CODE='01';
 
 
  update  VERIF_CALC_MIGRATION m 
  set m.FACT_AS400gc_P= (
                       select count(*) from genbill b
                       where b.bil_code in (select   distinct m.REFERENCE
                                            from test_migration m 
                                            where m.type='facture_as400gc'
                                             and m.CODE_DIST='01'))
 where m.DIV_CODE='01';
 ---------------------------------------facture_
 
 update  VERIF_CALC_MIGRATION m 
  set m.FACT_VERS_S=(select  count(distinct m.REFERENCE)
                      from test_migration m 
                      where m.type='facture_'
                      and m.CODE_DIST='01' )
 where m.DIV_CODE='01';
 
  update  VERIF_CALC_MIGRATION m 
  set m.FACT_VERS_P= (select count (*) from genbill 
                      where bil_code in(
                        select substr(trim(m.REFERENCE),1,12)||'0'||substr(trim(m.REFERENCE),13,1)||'0' 
                        from TEST_MIGRATION m 
                        where m.CODE_DIST='01'
                        and m.TYPE='facture_' )
                                            
                    )
 where m.DIV_CODE='01';
 
 -----------------------------************************************************************-------
 ----------------------------------------/////////////releve//////////////----------------------------
 -----------------------------************************************************************-------
update VERIF_CALC_MIGRATION t
set t.F_RELEVE_S=( select count(*) 
                    from district09.FICHE_RELEVE f 
                    where  trim(f.annee)>=2015)
where t.DIV_CODE='09';

update VERIF_CALC_MIGRATION t
set t.F_RELEVE_P=( select count(distinct d.mrd_id)  
                  from TECMTRREAD d
                  where d.spt_id in (select s.spt_id from  TECSERVICEPOINT s where substr(s.spt_refe,1,2)='09')
                  and mrd_id in (select v.mrd_id from miwtreleve v )
                )
where t.DIV_CODE='09';
---------------------relevet  
update VERIF_CALC_MIGRATION t
set t.RELEVET_S=(select count(*) 
                 from district09.relevet)
  where t.div_code='09';
  
 update VERIF_CALC_MIGRATION t
set t.RELEVET_P=( select count(distinct d.mrd_id) 
                  from TECMTRREAD d
                  where d.spt_id in (select s.spt_id from  TECSERVICEPOINT s where substr(s.spt_refe,1,2)='09')
                  and mrd_id in (select v.mrd_id from mig_pivot_09.miwtrelevet v )
  )
  where t.div_code='09';
  
 -----------------releve_gc
 update VERIF_CALC_MIGRATION t
set t.RELEVEGC_S=(select count(*)
                from district09.RELEVEGC
                )
   where t.div_code='09';
   
update VERIF_CALC_MIGRATION t
set t.RELEVEGC_P=( select count(distinct d.mrd_id) 
                  from TECMTRREAD d
                  where d.spt_id in (select s.spt_id from  TECSERVICEPOINT s where substr(s.spt_refe,1,2)='09')
                  and d.mrd_id not in (select g.mrd_id from mig_pivot_09.miwtreleve_gc g)
                  )
    
where t.div_code='09'; 
  
----***********************************************impayees***************************----------------------  

 ----------------------------impayees_part-------------------------
 update VERIF_CALC_MIGRATION t
 set t.IMPAYEES_PART_S=(
                         select count(distinct trim(p.DISTRICT)||
                        lpad(trim(p.tournee),3,'0') ||
                        lpad(trim(p.ORDRE),3,'0')||
                        to_char(p.ANNEE) ||
                        lpad(to_char(mois),2,'0')||'0')
                        from  district01.impayees_part p 
                        where  trim(net)<>trim(mtpaye)
                        )
  where t.div_code='01';   

 update VERIF_CALC_MIGRATION t
 set t.IMPAYEES_PART_P=(select count(*) 
                        from genbill b 
                        where b.bil_code in( select  trim(p.DISTRICT)||
                                              lpad(trim(p.tournee),3,'0') ||
                                              lpad(trim(p.ORDRE),3,'0')||
                                              to_char(p.ANNEE) ||
                                              lpad(to_char(mois),2,'0')||'0'
                                              from  district01.impayees_part p 
                                              where  trim(net)<>trim(mtpaye)
                                              )
                      )
  where t.div_code='01';                    
 ------------------impayees_gc-------------------------------------------
  update VERIF_CALC_MIGRATION t
 set t.impayees_gc_S=(
                         select count(distinct trim(p.DISTRICT)||
                        lpad(trim(p.tournee),3,'0') ||
                        lpad(trim(p.ORDRE),3,'0')||
                        to_char(p.ANNEE) ||
                        lpad(to_char(mois),2,'0')||'0')
                        from  district01.impayees_gc p 
                        where  trim(net)<>trim(mtpaye)
                        )
  where t.div_code='01';   

 update VERIF_CALC_MIGRATION t
 set t.impayees_gc_P=(select count(*) 
                        from genbill b 
                        where b.bil_code in( select  trim(p.DISTRICT)||
                                              lpad(trim(p.tournee),3,'0') ||
                                              lpad(trim(p.ORDRE),3,'0')||
                                              to_char(p.ANNEE) ||
                                              lpad(to_char(mois),2,'0')||'0'
                                              from  district01.impayees_gc p 
                                              where  trim(net)<>trim(mtpaye)
                                              )
                      )
  where t.div_code='01';    