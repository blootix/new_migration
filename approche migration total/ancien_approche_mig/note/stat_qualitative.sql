-------------------nbr mensuel code9---------------------------
select count(*) from district01.branchement b 
where upper(trim(b.gros_consommateur))='O';---Mensuel

select *
from agrserviceagr s 
where s.sag_refe like'01%'
and s.sag_id in (select a.sag_id
from  AGRPLANNINGAGR a
where a.vow_frqfact='2788');
-------------------------------------------------------
---------------nbr resilier-----------------------
select count(distinct
     lpad(trim(b.tourne),3,'0')||
      lpad(trim(b.ordre),3,'0')||
      lpad(trim(b.police),5,'0'))
 from DISTRICT01.branchement b 
 where trim(b.etat_branchement)='9'
 
 
select count(*)
from agrserviceagr a  
where a.sag_refe like '01%'
and a.sag_startdt = (select max(p.sag_startdt) 
                    from agrserviceagr p 
                    where p.sag_id=a.sag_id
                    and p.sag_refe like '01%'
                    )
and a.sag_enddt is not null ;
 
------------------------------
-----------------nbr pdl avec compteur --------------------

select count(distinct ref) from (select distinct trim(h.district)||trim(h.tourne)||trim(h.ordre) ref
from district01.branchement w,district01.branchement h
where trim(w.district)||trim(w.tourne)||trim(w.ordre) =trim(h.district)||trim(h.tourne)||trim(h.ordre)
and lpad(trim(w.compteur_actuel), 11, '0') <>'00000000000'  
union
select distinct trim(h.district)||trim(h.tourne)||trim(h.ordre) ref
from district01.fiche_releve b,district01.branchement h
where trim(b.district)||lpad(trim(b.tourne),3,'0')||lpad(trim(b.ordre),3,'0')=trim(h.district)||trim(h.tourne)||trim(h.ordre)
and trim(b.annee)||trim(b.trim)=(select max(trim(f.annee)||trim(f.trim)) from district01.fiche_releve f
where  trim(f.district)||lpad(trim(f.tourne),3,'0')||lpad(trim(f.ordre),3,'0')=trim(h.district)||trim(h.tourne)||trim(h.ordre)
and trim(f.ncompteur) is not null and trim(f.codemarque)!='000')
union     
select  distinct trim(h.district)||trim(h.tourne)||trim(h.ordre) ref
from district01.gestion_compteur c,district01.branchement h
where '01'||lpad(trim(c.tournee),3,'0')||lpad(trim(c.ordre),3,'0')=trim(h.district)||trim(h.tourne)||trim(h.ordre)
and trim(c.num_compteur) is not null
and trim(c.annee)||trim(c.trim) = (select max(trim(b.annee)||trim(b.trim)) 
                                  from district01.gestion_compteur b
                                  where '01'||lpad(trim(b.tournee),3,'0')||lpad(trim(b.ordre),3,'0')=trim(h.district)||trim(h.tourne)||trim(h.ordre)
                                  )
    )x
	
	
select count(distinct mhpc_refpdl) 
 from MIG_PIVOT_01.miwthistocpt c 
	
select  count(*)
 from tecservicepoint p 
 where p.spt_id  in (select e.spt_id  from techequipment e)
 and p.spt_refe like'01%';
 
 
 
-----------------------------------------------------------
----------------pdl sans compteur---------------------

select count(distinct l.pdl_ref)  
from mig_pivot_01.miwtpdl l 
where l.pdl_ref not in (select h.mhpc_refpdl
 from MIG_PIVOT_01.miwthistocpt h)
 
select  count(*)
 from tecservicepoint p 
 where p.spt_id  not in (select e.spt_id  from techequipment e)
 and p.spt_refe like'01%';
 ----------------------------------------

 -------------pdl avec compteur correct----------------------
 select count(distinct mhpc_refpdl) 
 from MIG_PIVOT_01.miwthistocpt c 
 where  c.mhpc_refcom not like '%MIG%';
 select  count(*)
 from tecservicepoint p ,techequipment h
 where p.spt_id = h.spt_id  
 and p.spt_refe like'01%'
 and h.equ_id in (select e.equ_id from tecequipment e where e.equ_realnumber not like '%MIG%')
  
 -----------------------------------------------------------
 ------------------pdl avec compteur MIG--------------------
  select count(distinct mhpc_refpdl) 
 from MIG_PIVOT_01.miwthistocpt c 
 where  c.mhpc_refcom not like '%MIG%';
 select  count(*)
 from tecservicepoint p ,techequipment h
 where p.spt_id = h.spt_id  
 and p.spt_refe like'01%'
 and h.equ_id in (select e.equ_id from tecequipment e where e.equ_realnumber not like '%MIG%')
 -------------------------------------------------------------
 
 
 ------------------categorie client ----------------
  select count(*),  decode(lpad(ltrim(rtrim(c.categorie)),2,'0'),'03','01','05','01','07','01','11','01','12','10','1','01','06','01'
 ,lpad(ltrim(rtrim(c.categorie)),2,'0'))--16
 from district01.client c
  group by   decode(lpad(ltrim(rtrim(c.categorie)),2,'0'),'03','01','05','01','07','01','11','01','12','10','1','01','06','01',lpad(ltrim(rtrim(c.categorie)),2,'0'))
 order by   decode(lpad(ltrim(rtrim(c.categorie)),2,'0'),'03','01','05','01','07','01','11','01','12','10','1','01','06','01',lpad(ltrim(rtrim(c.categorie)),2,'0'));
 
 --select * from v_genvocword v where v.voc_code='VOW_TYPSAG';
 
 select count(*),p.VOW_TYPSAG
 from genparty p 
 where p.par_refe like'01%'
 group by VOW_TYPSAG;
 ------------------------------------------------------------------
 
 ---------------cordonnes bancaire----------------------
 select sum ( tot)
from  ( select count(*) tot
  from district01.branchement t,district01.abonnees_gr a
  where lpad(trim(a.dist),2,'0')=trim(t.district)
  and   lpad(trim(a.tou),3,'0')=lpad(trim(t.tourne),3,'0')
  and   lpad(trim(a.ord),3,'0')=lpad(trim(t.ordre),3,'0')
  and   trim(a.categ)=5
  and ltrim(rtrim(t.banque))||ltrim(rtrim(t.agence))||ltrim(rtrim(t.num_compte))||ltrim(rtrim(t.cle_rib)) in (select ltrim(rtrim(p.rib)) from district01.rib_gr p)
union
select count(*) tot
  from district01.branchement t,district01.abonnees a
  where lpad(trim(a.dist),2,'0')=trim(t.district)
  and   lpad(trim(a.tou),3,'0')=lpad(trim(t.tourne),3,'0')
  and   lpad(trim(a.ord),3,'0')=lpad(trim(t.ordre),3,'0')
  and   trim(a.categ)=5
  and ltrim(rtrim(t.banque))||ltrim(rtrim(t.agence))||ltrim(rtrim(t.num_compte))||ltrim(rtrim(t.cle_rib)) in (select ltrim(rtrim(p.rib)) 
                                                                                    from district01.rib_part p) 
                                                                                    )x
 select * from genbankparty p 
 where p.par_id in (select par_id from genparty p where p.par_refe like '01%');
 -------------------------------------------------------
 ----------------------faire suivre----------------------------
 select sum(tot) from (select count(*) tot from DISTRICT01.faire_suivre_part
						union 
						select count(*) tot from DISTRICT01.faire_suivre_gc
					  )x
						 
select count(*) from genpartyparty p 
where p.par_id is null
and p.paa_id in (select e.paa_id from MIG_PIVOT_01.miwtfairesuivre e);
						 
 --------------------------------------------------------------
 ---------------tarif--------------------------------------
  select count(*),b.tarif
 from district01.branchement  b
 group by b.tarif;
 
 select count(*),r.ofr_id
 from AGRHSAGOFR r where r.sag_id in (select a.sag_id from agrserviceagr a where a.sag_refe like'01%')
 group by r.ofr_id;
 
 --------------------------------------------------------
 
 -----------------somme de consomation releve--------------
 select sum (tot) from (select sum(nvl(to_number(trim(a.consommation)),0)) tot from DISTRICT01.fiche_releve a
where trim(a.district) = '01'
and ltrim(rtrim(trim)) is not null
and ltrim(rtrim(a.annee))>=2015
and  to_number(trim(a.annee) || trim(a.trim)) <>
(select max(to_number(trim(v.annee) || trim(v.trim)))
from DISTRICT01.fiche_releve v
where trim(v.tourne) = trim(a.tourne)
and trim(v.ordre) = trim(a.ordre))
union
select sum ( nvl(to_number(trim(t.consommation)),0)) tot
from DISTRICT01.releveT t
union                         
select sum ( nvl(to_number(trim(a.consommation)),0)) tot
from  DISTRICT01.relevegc a
where  trim(a.district) = '01'
and trim(a.mois) is not null
union
select sum( nvl(to_number(trim(a.cons)),0)) tot
from  DISTRICT01.facture_as400gc a, DISTRICT01.branchement b
where trim(b.district) = trim(a.dist)
and lpad(trim(a.pol),5,'0')=lpad(trim(b.police),5,'0')
and lpad(trim(a.tou),3,'0')=lpad(trim(b.tourne),3,'0')
and lpad(trim(a.ord),3,'0')=lpad(trim(b.ordre),3,'0')
and trim(a.dist) = '01')x
                  
	--****************************			  
select sum(e.mme_consum)
from tecmtrmeasure e
where e.mrd_id in (select r.mrd_id from tecmtrread r where r.spt_id in (select s.spt_id from tecservicepoint s where s.spt_refe like '01%'))

				  
 ----------------------------------------------------------
 
 ------------------somme prorata releve --------------------------
 select sum (tot) from (select sum(nvl(to_number(trim(a.consommation)),0)-a.prorata) tot from DISTRICT01.fiche_releve a
where trim(a.district) = '01'
and ltrim(rtrim(trim)) is not null
and ltrim(rtrim(a.annee))>=2015
and  to_number(trim(a.annee) || trim(a.trim)) <>
(select max(to_number(trim(v.annee) || trim(v.trim)))
from DISTRICT01.fiche_releve v
where trim(v.tourne) = trim(a.tourne)
and trim(v.ordre) = trim(a.ordre))
and  to_number(a.prorata)>0

union

select sum ( nvl(to_number(trim(t.consommation)), 0) - t.prorata) tot
from DISTRICT01.releveT t
where to_number(t.prorata) > 0 

union                         
select sum ( nvl(to_number(trim(a.consommation)), 0) - a.prorata) tot
from  DISTRICT01.relevegc a
where  trim(a.district) = '01'
and trim(a.mois) is not null
and  to_number(a.prorata)>0
union

select sum( nvl(to_number(trim(a.prorata)),0)*-1) tot
from  DISTRICT01.facture_as400gc a, DISTRICT01.branchement b
where trim(b.district) = trim(a.dist)
and lpad(trim(a.pol),5,'0')=lpad(trim(b.police),5,'0')
and lpad(trim(a.tou),3,'0')=lpad(trim(b.tourne),3,'0')
and lpad(trim(a.ord),3,'0')=lpad(trim(b.ordre),3,'0')
and trim(a.dist) = '01')x
                  
-----**************************
  select sum(e.MME_DEDUCEMANUAL)
  from tecmtrmeasure e
  where e.mrd_id in (select r.mrd_id from tecmtrread r where r.spt_id in (select s.spt_id from tecservicepoint s where s.spt_refe like '01%'));
 -----------------------------------------------------------------
 --------------------somme index releve----------------------
 select sum (tot) from (select sum( to_number(replace(a.releve,'.',null))+to_number(replace(a.releve2,'.',null))+
             to_number(replace(a.releve3,'.',null))+
             to_number(replace(a.releve4,'.',null))+
             to_number(replace(a.releve5,'.',null)))
             tot from DISTRICT01.fiche_releve a
where trim(a.district) = '01'
and ltrim(rtrim(trim)) is not null
and ltrim(rtrim(a.annee))>=2015
and  to_number(trim(a.annee) || trim(a.trim)) <>
(select max(to_number(trim(v.annee) || trim(v.trim)))
from DISTRICT01.fiche_releve v
where trim(v.tourne) = trim(a.tourne)
and trim(v.ordre) = trim(a.ordre))
and  to_number(a.prorata)>0

union

select sum( decode(t.annee,0,t.indexa,t.indexr)) tot
from DISTRICT01.releveT t
where to_number(t.prorata) > 0 

union                         
select sum( to_number(a.indexr)) tot
from  DISTRICT01.relevegc a
where  trim(a.district) = '01'
and trim(a.mois) is not null
and  to_number(a.prorata)>0
union

select sum( to_number(a.nindex)) tot
from  DISTRICT01.facture_as400gc a, DISTRICT01.branchement b
where trim(b.district) = trim(a.dist)
and lpad(trim(a.pol),5,'0')=lpad(trim(b.police),5,'0')
and lpad(trim(a.tou),3,'0')=lpad(trim(b.tourne),3,'0')
and lpad(trim(a.ord),3,'0')=lpad(trim(b.ordre),3,'0')
and trim(a.dist) = '01')x
 ---********************
  select sum(e.mme_value)
  from tecmtrmeasure e
  where e.mrd_id in (select r.mrd_id from tecmtrread r where r.spt_id in (select s.spt_id from tecservicepoint s where s.spt_refe like '01%')) 
-------------------------------------------------------------- 

--------------------anomalie niche=>releve
 select count(distinct ref) from ( select distinct   substr( lpad(ltrim(rtrim(a.anomalie)),18,0), 1, 2) ref
              from DISTRICT01.fiche_releve a
where trim(a.district) = '01'
and ltrim(rtrim(trim)) is not null
and ltrim(rtrim(a.annee))>=2015
and  to_number(trim(a.annee) || trim(a.trim)) <>
(select max(to_number(trim(v.annee) || trim(v.trim)))
from DISTRICT01.fiche_releve v
where trim(v.tourne) = trim(a.tourne)
and trim(v.ordre) = trim(a.ordre))
union
select  distinct substr( lpad(ltrim(rtrim(s.anomalie)),18,0), 1, 2) ref
from DISTRICT01.fiche_releve s ,DISTRICT01.releveT releve_
where trim(s.district) = '01'
and trim(s.tourne) = trim(releve_.tourne)
and trim(s.ordre) = trim(releve_.ordre)
and trim(s.annee)||trim(s.trim) =
                               (select max(trim(v.annee)||trim(v.trim))
                                from DISTRICT01.fiche_releve v
                                where trim(v.tourne) = trim(s.tourne)
                                 and trim(v.ordre) = trim(s.ordre)))x;

 
 select count( distinct r.vow_comm1)
 from tecmtrread r where r.spt_id in (select s.spt_id from tecservicepoint s where s.spt_refe like '01%');

 -------------------------- anomalie fuite releve 
  select count(distinct ref) from ( select distinct  substr( a.anomalie,13,2) ref
              from DISTRICT01.fiche_releve a
where trim(a.district) = '01'
and ltrim(rtrim(trim)) is not null
and ltrim(rtrim(a.annee))>=2015
and  to_number(trim(a.annee) || trim(a.trim)) <>
(select max(to_number(trim(v.annee) || trim(v.trim)))
from DISTRICT01.fiche_releve v
where trim(v.tourne) = trim(a.tourne)
and trim(v.ordre) = trim(a.ordre))
union

select  distinct substr(s.anomalie,13,2) ref
from DISTRICT01.fiche_releve s ,DISTRICT01.releveT releve_
where trim(s.district) = '01'
and trim(s.tourne) = trim(releve_.tourne)
and trim(s.ordre) = trim(releve_.ordre)
and trim(s.annee)||trim(s.trim) =
                               (select max(trim(v.annee)||trim(v.trim))
                                from DISTRICT01.fiche_releve v
                                where trim(v.tourne) = trim(s.tourne)
                                 and trim(v.ordre) = trim(s.ordre)))x;
								 
								 
 select count( distinct r.vow_comm2)
 from tecmtrread r where r.spt_id in (select s.spt_id from tecservicepoint s where s.spt_refe like '01%');

 ---------------------------------------------------------
 ------------------------------anomalie compteur =>releve
 select count(distinct ref) from ( select distinct   substr( lpad(ltrim(rtrim(a.anomalie)),18,0), 1, 2) ref
              from DISTRICT01.fiche_releve a
where trim(a.district) = '01'
and ltrim(rtrim(trim)) is not null
and ltrim(rtrim(a.annee))>=2015
and  to_number(trim(a.annee) || trim(a.trim)) <>
(select max(to_number(trim(v.annee) || trim(v.trim)))
from DISTRICT01.fiche_releve v
where trim(v.tourne) = trim(a.tourne)
and trim(v.ordre) = trim(a.ordre))
union

  select  distinct substr( lpad(ltrim(rtrim(s.anomalie)),18,0), 1, 2) ref
from DISTRICT01.fiche_releve s ,DISTRICT01.releveT releve_
where trim(s.district) = '01'
and trim(s.tourne) = trim(releve_.tourne)
and trim(s.ordre) = trim(releve_.ordre)
and trim(s.annee)||trim(s.trim) =
                               (select max(trim(v.annee)||trim(v.trim))
                                from DISTRICT01.fiche_releve v
                                where trim(v.tourne) = trim(s.tourne)
                                 and trim(v.ordre) = trim(s.ordre)))x;
  select count( distinct r.vow_comm3)
 from tecmtrread r where r.spt_id in (select s.spt_id from tecservicepoint s where s.spt_refe like '01%');

 
 ---------------------------somme ttc facture --------------------------
 
 select  sum(f.MFAE_TOTHTE+ f.MFAE_TOTTVAE+ f.MFAE_TOTHTA+ f.MFAE_TOTTVAA )
from mig_pivot_01.miwtfactureentete f;

select sum(b.bil_amountttc) from genbill b where b.bil_code like '01%';
 -------------------------------------------------
 ---------------somme montont ttc sonede-------------
select sum(e.mfal_mttc)
from MIG_PIVOT_01.miwtfactureligne e where e.MFAL_REFART in ('CSM_STD');
 
select sum(bli_mttc) from genbilline w
where w.ite_id in (select i.ite_id from genitem i where i.ite_code='CSM_STD') 
and w.bil_id in (select b.bil_id from genbill b where b.bil_code like'01%')
 ---------------------------------------
 
 
  ---------------somme montont ttc sonede-------------
select sum(e.mfal_mttc)
from MIG_PIVOT_01.miwtfactureligne e where e.MFAL_REFART in ('VAR_ONAS_1');
 
select sum(bli_mttc) from genbilline w
where w.ite_id in (select i.ite_id from genitem i where i.ite_code='VAR_ONAS_1') 
and w.bil_id in (select b.bil_id from genbill b where b.bil_code like'01%')
 ---------------------------------------
 
 -------------------somme Frais fixe sonede ---------------
 select sum(e.mfal_mttc)
from MIG_PIVOT_01.miwtfactureligne e where e.MFAL_REFART in ('FRS_FIX_CSM');

select sum(bli_mttc) from genbilline w
where w.ite_id in (select i.ite_id from genitem i where i.ite_code='FRS_FIX_CSM') 
and w.bil_id in (select b.bil_id from genbill b where b.bil_code like'01%');
---------------------------------------------------
------------------somme Frais fixe onas--------------------
select sum(e.mfal_mttc)
from MIG_PIVOT_01.miwtfactureligne e where e.MFAL_REFART in ('FIXE_ONAS_1');

select sum(bli_mttc) from genbilline w
where w.ite_id in (select i.ite_id from genitem i where i.ite_code='FIXE_ONAS_1') 
and w.bil_id in (select b.bil_id from genbill b where b.bil_code like'01%');
-------------------------------------
--------------------somme impayes---------------------
select sum(tot) from 
(select  sum((to_number(trim(t.net)))/1000) tot
from  district01.impayees_part t
where  trim(net)<>trim(mtpaye)
union 
select sum((to_number(trim(p.net)))/1000 ) tot
from  district01.impayees_gc p 
where  trim(net)<>trim(mtpaye))


 select sum(tot) from (select sum(b.bil_amountttc) tot
from genbill b 
where b.bil_code in( select  trim(p.DISTRICT)||
                      lpad(trim(p.tournee),3,'0') ||
                      lpad(trim(p.ORDRE),3,'0')||
                      to_char(p.ANNEE) ||
                      lpad(to_char(mois),2,'0')||'0'
                      from  district01.impayees_part p 
                      where  trim(net)<>trim(mtpaye)
                      ) 
union
 select sum(b.bil_amountttc) tot 
from genbill b 
where b.bil_code in( select  trim(p.DISTRICT)||
                      lpad(trim(p.tournee),3,'0') ||
                      lpad(trim(p.ORDRE),3,'0')||
                      to_char(p.ANNEE) ||
                      lpad(to_char(mois),2,'0')||'0'
                      from  district01.impayees_gc p 
                      where  trim(net)<>trim(mtpaye)
                      ) )x

------------------------------------------------------