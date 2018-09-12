    -------------------nbr mensuel code9---------------------------
select count( distinct lpad(trim(b.district),2,'0') ||
                        lpad(trim(b.tourne),3,'0') ||
                        lpad(trim(b.ordre),3,'0') ||
                        lpad(to_char(trim(b.police)),5,'0') ) ref 
						from branchement b 
where lpad(trim(b.tourne),3,'0')='379';

select count(distinct s.sag_id)
from agrserviceagr s ,AGRPLANNINGAGR a
where s.sag_id =a.sag_id
and a.vow_frqfact='2788';
-------------------------------------------------------
---------------nbr resilier-----------------------
select count(*) 
from miwtpdl l
where l.PDL_DFERMETURE is not null ;
 
 
select count(*)
from agrserviceagr a  
where a.sag_startdt = (select max(p.sag_startdt) 
						from agrserviceagr p 
						where p.sag_id=a.sag_id
					  )
and a.sag_enddt is not null ;
 
------------------------------
-----------------nbr pdl avec compteur --------------------
select count(*) 
from miwthistocpt c;
select  count(*)
 from tecservicepoint p 
 where p.spt_id  in (select e.spt_id  from techequipment e);

-----------------------------------------------------------
----------------pdl sans compteur---------------------
select count(distinct l.pdl_ref)  
from miwtpdl l 
where l.pdl_ref not in (select h.mhpc_refpdl
                        from miwthistocpt h);
 
select  count(*)
 from tecservicepoint p 
 where p.spt_id  not in (select e.spt_id  
                         from techequipment e);
 ----------------------------------------

 -------------pdl avec compteur correct----------------------
 select  count(distinct mhpc_refpdl) 
 from miwthistocpt c 
 where  c.mhpc_refcom not like '%MIG%';
 select  count(*)
 from tecservicepoint p ,techequipment h
 where p.spt_id = h.spt_id 
 and h.equ_id in (select e.equ_id 
                  from tecequipment e 
				  where e.equ_realnumber not like '%MIG%');
  
 -----------------------------------------------------------
 ------------------pdl avec compteur MIG--------------------
  select count(distinct mhpc_refpdl) 
 from mig_pivot_37.miwthistocpt c 
 where  c.mhpc_refcom  like '%MIG%';
 select  count(*)
 from tecservicepoint p ,techequipment h
 where p.spt_id = h.spt_id  
 and p.spt_refe like'37%'
 and h.equ_id in (select e.equ_id from tecequipment e where e.equ_realnumber  like '%MIG%');
 -------------------------------------------------------------
 
 ------------------categorie client ----------------
  select count(*),  decode(lpad(ltrim(rtrim(c.categorie)),2,'0'),'03','01','05','01','07','01','11','01','12','10','1','01','06','01'
 ,lpad(ltrim(rtrim(c.categorie)),2,'0')) rerfe
 from client c
  group by   decode(lpad(ltrim(rtrim(c.categorie)),2,'0'),'03','01','05','01','07','01','11','01','12','10','1','01','06','01',lpad(ltrim(rtrim(c.categorie)),2,'0'))
 order by   decode(lpad(ltrim(rtrim(c.categorie)),2,'0'),'03','01','05','01','07','01','11','01','12','10','1','01','06','01',lpad(ltrim(rtrim(c.categorie)),2,'0'));
 
 select count(*),p.VOW_TYPSAG
 from genparty p 
 group by VOW_TYPSAG;
 ------------------------------------------------------------------
 
 ---------------cordonnes bancaire----------------------
 select sum ( tot)
  from  ( select count(*) tot
		  from branchement t,abonnees_gr a
		  where lpad(trim(a.dist),2,'0')=trim(t.district)
		  and   lpad(trim(a.tou),3,'0')=lpad(trim(t.tourne),3,'0')
		  and   lpad(trim(a.ord),3,'0')=lpad(trim(t.ordre),3,'0')
		  and   trim(a.categ)=5
          and trim(t.banque)||trim(t.agence)||trim(t.num_compte)||trim(t.cle_rib) in(select trim(p.rib) from rib_gr p)
union
select count(*) tot
  from branchement t,abonnees a
  where lpad(trim(a.dist),2,'0')=trim(t.district)
  and   lpad(trim(a.tou),3,'0')=lpad(trim(t.tourne),3,'0')
  and   lpad(trim(a.ord),3,'0')=lpad(trim(t.ordre),3,'0')
  and   trim(a.categ)=5
  and trim(t.banque)||trim(t.agence)||trim(t.num_compte)||trim(t.cle_rib) in (select trim(p.rib)from rib_part p))x;
 select count(*) 
 from genbankparty p 
 where p.par_id in (select par_id from genparty p );
 -------------------------------------------------------
 ----------------------faire suivre----------------------------
  
  select sum(tot) from (select count(distinct b.categorie_actuel|| b.client_actuel) tot 
						from faire_suivre_part a,branchement b
						where lpad(trim(a.dist),2,'0')=trim(b.district)
						and   lpad(trim(a.tou),3,'0')=lpad(trim(b.tourne),3,'0')
						and   lpad(trim(a.ord),3,'0')=lpad(trim(b.ordre),3,'0')
						and   lpad(trim(a.pol),5,'0')=lpad(trim(b.police),5,'0')
                       union 
			            select count(distinct b.categorie_actuel|| b.client_actuel) tot 
						from  faire_suivre_gc a,d branchement b
						where lpad(trim(a.dist),2,'0')=trim(b.district)
						and   lpad(trim(a.tou),3,'0')=lpad(trim(b.tourne),3,'0')
						and   lpad(trim(a.ord),3,'0')=lpad(trim(b.ordre),3,'0')
						and   lpad(trim(a.pol),5,'0')=lpad(trim(b.police),5,'0')
                       )x;
            
select count(*) 
from genpartyparty p 
where p.par_id is null
and p.paa_id in (select e.paa_id from  miwtfairesuivre e);
						 
 --------------------------------------------------------------
 ---------------tarif--------------------------------------
  select count(*),b.tarif
 from branchement  b
 group by b.tarif 
 order by tarif;
 
 select count(*),r.ofr_id
 from AGRHSAGOFR r 
 where r.sag_id in (select a.sag_id from agrserviceagr a )
 group by r.ofr_id;
 --------------------------------------------------------
 
 -----------------somme de consomation releve--------------
 select sum (tot) from (select sum(nvl(to_number(trim(a.consommation)),0)) tot 
						 from fiche_releve a
						where  ltrim(rtrim(trim)) is not null
						and ltrim(rtrim(a.annee))>=2015
						and  to_number(trim(a.annee) || trim(a.trim)) <>
																		(select max(to_number(trim(v.annee) || trim(v.trim)))
																		from fiche_releve v
																		where trim(v.tourne) = trim(a.tourne)
																		and trim(v.ordre) = trim(a.ordre))
						union
						select sum ( nvl(to_number(trim(t.anomalie_fuite)),0)) tot
						from releveT t
						union                         
						select sum ( nvl(to_number(trim(a.consommation)),0)) tot
						from  relevegc a
						where trim(a.mois) is not null
						union
						select sum( nvl(to_number(trim(a.cons)),0)) tot
						from  facture_as400gc a,branchement b
						where trim(b.district) = trim(a.dist)
						and lpad(trim(a.pol),5,'0')=lpad(trim(b.police),5,'0')
						and lpad(trim(a.tou),3,'0')=lpad(trim(b.tourne),3,'0')
						and lpad(trim(a.ord),3,'0')=lpad(trim(b.ordre),3,'0')
						)x;                  
	--****************************			  
select sum(e.mme_consum)
from tecmtrmeasure e
where e.mrd_id in (select r.mrd_id 
				   from tecmtrread r 
                   where r.spt_id in (select s.spt_id 
                                      from tecservicepoint s ));
 ----------------------------------------------------------
 ------------------somme prorata releve --------------------------
 select sum (tot) from (select sum(nvl(to_number(trim(a.consommation)),0)-a.prorata) tot 
 from fiche_releve a
where  trim(trim) is not null
and trim(a.annee)>=2015
and  to_number(trim(a.annee)||trim(a.trim)) <>(select max(to_number(trim(v.annee)||trim(v.trim)))
												from fiche_releve v
												where trim(v.tourne) = trim(a.tourne)
												and trim(v.ordre) = trim(a.ordre))
and  to_number(a.prorata)>0
union
select sum (nvl(to_number(trim(t.anomalie_fuite)), 0) - t.prorata) tot
from releveT t
where to_number(t.prorata) > 0 
union                         
select sum (nvl(to_number(trim(a.consommation)), 0) - a.prorata) tot
from relevegc a
where trim(a.mois) is not null
and  to_number(a.prorata)>0
union
select sum( nvl(to_number(trim(a.prorata)),0)*-1) tot
from facture_as400gc a,branchement b
where trim(b.district)     = trim(a.dist)
and lpad(trim(a.pol),5,'0')=lpad(trim(b.police),5,'0')
and lpad(trim(a.tou),3,'0')=lpad(trim(b.tourne),3,'0')
and lpad(trim(a.ord),3,'0')=lpad(trim(b.ordre),3,'0'))x;                  
-----**************************
  select sum(e.MME_DEDUCEMANUAL)
  from tecmtrmeasure e
  where e.mrd_id in (select r.mrd_id 
                     from tecmtrread r 
					 where r.spt_id in (select s.spt_id from tecservicepoint s ));
 -----------------------------------------------------------------
 --------------------somme index releve----------------------
 select sum (tot) from (select sum( to_number(replace(trim(a.releve),'.',null)))tot 
                        from fiche_releve a
						where  trim(trim) is not null
						and trim(a.annee)>=2015
						and  to_number(trim(a.annee) || trim(a.trim)) <>(select max(to_number(trim(v.annee) || trim(v.trim)))
																		from fiche_releve v
																		where trim(v.tourne) = trim(a.tourne)
																		and trim(v.ordre) = trim(a.ordre))
						union
						select sum(decode(t.annee,0,t.indexa,t.indexr)) tot
						from releveT t
						union                         
						select sum( to_number(a.indexr)) tot
						from  relevegc a
						where trim(a.mois) is not null
						union
						select sum( to_number(a.nindex)) tot
						from  facture_as400gc a,branchement b
						where trim(b.district) = trim(a.dist)
						and lpad(trim(a.pol),5,'0')=lpad(trim(b.police),5,'0')
						and lpad(trim(a.tou),3,'0')=lpad(trim(b.tourne),3,'0')
						and lpad(trim(a.ord),3,'0')=lpad(trim(b.ordre),3,'0'))x;
 ---********************
  select sum(e.mme_value)
  from tecmtrmeasure e
  where e.mrd_id in (select r.mrd_id 
                     from tecmtrread r 
					 where r.spt_id in (select s.spt_id 
					                    from tecservicepoint s )) ;
-------------------------------------------------------------- 
--------------------anomalie niche=>releve
 select count(distinct ref) from (select distinct substr(lpad(ltrim(rtrim(a.anomalie)),18,0),1,2) ref
                                  from fiche_releve a
                                  where trim(trim) is not null
                                  and trim(a.annee)>=2015
                                  and  to_number(trim(a.annee)||trim(a.trim)) <>(select max(to_number(trim(v.annee)||trim(v.trim)))
																				   from fiche_releve v
																				   where trim(v.tourne) = trim(a.tourne)
																				   and trim(v.ordre) = trim(a.ordre))
union
select  distinct substr( lpad(ltrim(rtrim(s.anomalie)),18,0), 1, 2) ref
from fiche_releve s ,releveT releve_
where  trim(s.tourne) = trim(releve_.tourne)
and trim(s.ordre) = trim(releve_.ordre)
and trim(s.annee)||trim(s.trim) =
                               (select max(trim(v.annee)||trim(v.trim))
                                from fiche_releve v
                                where trim(v.tourne) = trim(s.tourne)
                                 and trim(v.ordre) = trim(s.ordre)))x;
 select count( distinct r.vow_comm1)
 from tecmtrread r 
 where r.spt_id in (select s.spt_id from tecservicepoint s);

 -------------------------- anomalie fuite releve 
  select count(distinct ref) from ( select distinct substr( a.anomalie,13,2) ref
              from district37.fiche_releve a
where  trim(trim) is not null
and ltrim(rtrim(a.annee))>=2015
and  to_number(trim(a.annee) || trim(a.trim)) <>(select max(to_number(trim(v.annee) || trim(v.trim)))
												from fiche_releve v
												where trim(v.tourne) = trim(a.tourne)
												and trim(v.ordre) = trim(a.ordre))
union
select  distinct substr(s.anomalie,13,2) ref
from fiche_releve s,releveT releve_
where  trim(s.tourne) = trim(releve_.tourne)
and trim(s.ordre) = trim(releve_.ordre)
and trim(s.annee)||trim(s.trim) =(select max(trim(v.annee)||trim(v.trim))
                                from fiche_releve v
                                where trim(v.tourne) = trim(s.tourne)
                                 and trim(v.ordre) = trim(s.ordre)))x;							 								 
 select count( distinct r.vow_comm2)
 from tecmtrread r
 where r.spt_id in (select s.spt_id from tecservicepoint s );
 ---------------------------------------------------------
 ------------------------------anomalie compteur =>releve
 select count(distinct ref) from ( select distinct  substr( lpad(trim(a.anomalie),18,0), 1, 2) ref
              from fiche_releve a
where  trim(trim) is not null
and trim(a.annee)>=2015
and  to_number(trim(a.annee) ||trim(a.trim)) <>
(select max(to_number(trim(v.annee) || trim(v.trim)))
from fiche_releve v
where trim(v.tourne) = trim(a.tourne)
and trim(v.ordre) = trim(a.ordre))
union
select  distinct substr( lpad(trim(s.anomalie),18,0), 1, 2) ref
from fiche_releve s,releveT releve_
where  trim(s.tourne) = trim(releve_.tourne)
and trim(s.ordre)     = trim(releve_.ordre)
and trim(s.annee)||trim(s.trim) =
                               (select max(trim(v.annee)||trim(v.trim))
                                from fiche_releve v
                                where trim(v.tourne) = trim(s.tourne)
                                 and trim(v.ordre) = trim(s.ordre)))x;
  select count( distinct r.vow_comm3)
 from tecmtrread r 
 where r.spt_id in (select s.spt_id from tecservicepoint s);

 ---------------------------somme ttc facture --------------------------
 select  sum(f.MFAE_TOTHTE+ f.MFAE_TOTTVAE+ f.MFAE_TOTHTA+ f.MFAE_TOTTVAA ) TTC_f
 from miwtfactureentete f;
select sum(b.bil_amountttc) from genbill b;
 -------------------------------------------------
 ---------------somme montont ttc sonede-------------
select sum(e.mfal_mttc)
from miwtfactureligne e where e.MFAL_REFART in ('CSM_STD');
 
select sum(bli_mttc) from genbilline w
where w.ite_id =320--in (select i.ite_id from genitem i where i.ite_code='CSM_STD') 
and w.bil_id in (select b.bil_id from genbill b );
 ---------------------------------------
  ---------------somme montont ttc onas-------------
select sum(e.mfal_mttc)
from miwtfactureligne e where e.MFAL_REFART in ('VAR_ONAS_1');
 
select sum(bli_mttc) 
from genbilline w
where w.ite_id =350--in (select i.ite_id from genitem i where i.ite_code='VAR_ONAS_1') 
and w.bil_id in (select b.bil_id from genbill b );
------------------------------------
 -------------------somme Frais fixe sonede ---------------
select sum(e.mfal_mttc)
from miwtfactureligne e where e.MFAL_REFART in ('FRS_FIX_CSM');

select sum(bli_mttc) from genbilline w
where w.ite_id =326--in (select i.ite_id from genitem i where i.ite_code='FRS_FIX_CSM') 
and w.bil_id in (select b.bil_id from genbill b );
---------------------------------------------------
------------------somme Frais fixe onas--------------------
select sum(e.mfal_mttc)
from miwtfactureligne e where e.MFAL_REFART in ('FIXE_ONAS_1');

select sum(bli_mttc) from genbilline w
where w.ite_id =351--in (select i.ite_id from genitem i where i.ite_code='FIXE_ONAS_1') 
and w.bil_id in (select b.bil_id from genbill b );
-------------------------------------
--------------------somme impayes---------------------
select sum(e.mfal_mttc)
from miwtfactureligne e where e.MFAL_REFART in ('REPRISE-ONAS','REPRISE-SONEDE');
--------------------------------------
select sum(tot) from (
select sum(bli_mttc) tot from genbilline w
where w.ite_id =329
and w.bil_id in (select b.bil_id from genbill b where b.bil_code like'37%')
union
select sum(bli_mttc) tot from genbilline w
where w.ite_id =330
and w.bil_id in (select b.bil_id from genbill b where b.bil_code like'37%'))x;
--------------------------------------------------