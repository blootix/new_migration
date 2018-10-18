 PROCEDURE MigrationCorrectionReleve
   (
     p_param in number default 0
   )
   IS   
   cursor c1
   is 
    select t.spt_id
    from  tecservicepoint t
    inner join agrserviceagr a
    on a.spt_id =t.spt_id
    inner join agrplanningagr p
    on p.sag_id=a.sag_id
    and vow_frqfact=2790;---TRIM

   cursor c2(v_spt_id number)
   is 
   select r.*
   from tecmtrread r
   where r.spt_id=v_spt_id
   order by r.mrd_year,r.mrd_multicad;
   
   cursor c3
   is 
    select t.spt_id 
    from  tecservicepoint t
    inner join agrserviceagr a
    on a.spt_id =t.spt_id
    inner join agrplanningagr p
    on p.sag_id=a.sag_id
    and vow_frqfact=2788;---MENS  
   v_min number;
   v_annee number;
   v_periode number;
   v_mrd_id number;
   v_index number;
   v_conso number;
   v_prorata    number;
   v_fac_datecalcul date;
   p_pk_etape     varchar2(400);
   p_pk_exception varchar2(400);
   BEGIN
     for s1 in c1 loop
       for s2 in c2 (s1.spt_id)loop
         begin
           v_min    :=null;
           v_annee  :=null;
           v_periode:=null;
           v_mrd_id :=null;
           v_fac_datecalcul:=null;
           v_min:=to_number(s2.mrd_year||s2.mrd_multicad);        
           while v_min<=20182 loop
              v_annee  :=null;
              v_periode:=null;
              if s2.mrd_multicad=4 then 
                v_annee:=s2.mrd_year+1;
                v_periode:=1;  
              else 
                v_annee:=s2.mrd_year;
                v_periode:=s2.mrd_multicad+1;
              end if;
              p_pk_etape := 'Initialisation pour creation correction_releve';
              v_index   :=0;
              v_conso   :=0;
              v_prorata :=0;
              v_fac_datecalcul:=s2.mrd_dt+90;
              p_pk_etape := 'Creation releve de correction';
              MigrationReleve(p_pk_etape,p_pk_exception,v_mrd_id,v_annee,v_periode,v_index,v_conso,v_prorata,
                              null,null,null,null,null,null,v_fac_datecalcul,
                              null,null,null,null,'correction_releve',v_g_vow_readreason_t,v_g_vow_readmeth,1,
                              s2.equ_id,s2.mtc_id,s2.spt_id,v_g_age_id);              
              v_min:=to_number(v_annee||v_periode)+1;                 
           end loop; 
           update tecmtrread t set t.mrd_previous_id=s2.mrd_id
           where t.spt_id=s2.spt_id
           and to_number(t.mrd_year||t.mrd_multicad)>to_number(s2.mrd_year||s2.mrd_multicad); 
         exception when others then
           rollback;
           p_pk_exception := SQLCODE|| ' : '||SUBSTR(SQLERRM, 1, 200);
           EXCEPTION_RELEVE(s2.spt_id||'-'||s2.mrd_id||'-'||v_annee||'-'||v_periode,null,p_pk_exception,p_pk_etape);
           continue;
         end;     
       end loop;
     end loop; 
     ---------------MENS
     for s3 in c3 loop
       for s2 in c2 (s3.spt_id)loop
         begin
           v_min    :=null;
           v_annee  :=null;
           v_periode:=null;
           v_mrd_id :=null;
           v_fac_datecalcul:=null;
           v_min:=to_number(s2.mrd_year||s2.mrd_multicad); 
           while v_min<=20188 loop
              v_annee  :=null;
              v_periode:=null;
              if (s2.mrd_multicad=12) then
                v_annee:=s2.mrd_year+1;
                v_periode:=1;
              else
                v_annee  :=s2.mrd_year;
                v_periode:=s2.mrd_multicad+1;
              end if;
              p_pk_etape := 'Initialisation pour creation correction_releve';
              v_index   :=0;
              v_conso   :=0;
              v_prorata :=0;
              v_fac_datecalcul:=s2.mrd_dt+30;
              p_pk_etape := 'Creation releve de correction';
              MigrationReleve(p_pk_etape,p_pk_exception,v_mrd_id,v_annee,v_periode,v_index,v_conso,v_prorata,
                              null,null,null,null,null,null,v_fac_datecalcul,
                              null,null,null,null,'correction_releve',v_g_vow_readreason_t,v_g_vow_readmeth,1,
                              s2.equ_id,s2.mtc_id,s2.spt_id,v_g_age_id);              
              v_min:=to_number(v_annee||v_periode)+1;                 
           end loop;
           update tecmtrread t set t.mrd_previous_id=s2.mrd_id
           where t.spt_id=s2.spt_id
           and to_number(t.mrd_year||t.mrd_multicad)>to_number(s2.mrd_year||s2.mrd_multicad);
           exception when others then
             rollback;
             p_pk_exception := SQLCODE || ' : ' ||SUBSTR(SQLERRM, 1, 200);
             EXCEPTION_RELEVE(s2.spt_id||'-'||s2.mrd_id||'-'||v_annee||'-'||v_periode,null,p_pk_exception,p_pk_etape);
             continue;
           end;        
       end loop;        
     end loop;  
   END; 