
--Dans la base source
--Creation clients
create table src_clients as
(
select lpad(trim(district),2,'0') district, lpad(trim(categorie),2,'0') categorie, trim(upper(code)) code,
       tel, autre_tel, fax, nom, nvl(trim(adresse),'-') adresse, lpad(trim(code_postal),4,'0') code_postal,
       lpad(trim(district),2,'0')||lpad(trim(categorie),2,'0')||trim(upper(code)) code_cli
       from   client c
where  lpad(trim(categorie),2,'0') <> '02'
union all
select null district,'02' categorie, lpad(trim(adm.coadm),4,'0') code,
       null tel, null autre_tel, null fax, nvl(trim(adm.libel),'-') nom, nvl(trim(adm.admadr),'-') adresse, null code_postal,
       lpad(trim(adm.coadm),4,'0') code_cli
from   repertoire_adm adm
);
--Creation abonnees
create table src_abonnees as
(
select posit,dist,pol,tou,ord,to_char(codonan) tarif_onas,codpoll,
       tarif,echt,echr,brt,echronas,echtonas,capitonas,interonas,codar,
       aindex,prorata,arrond,categ,gros_consommateur,'TRM' frq
from   abn_trimcat1
union all
select posit,dist,pol,tou,ord,to_char(codonas) tarif_onas, null codpoll,
       tarif,echt,echr,brt,echronas,echtonas,capitonas,interonas,to_number(substr(to_char(ar1),1,1)) codar,
       aindex,prorata,ar2 arrond,categ,gros_consommateur,'MNS' frq
from   abn_gccat1
);

--Creation faire suivre
create table src_faire_suivre as
select dist,pol,tou,ord,adr1,adr2,adr3,codpostal 
from abn_trimcat7
union all
select dist,pol,tou,ord,ad1 adr1,ad2 adr2,ad3 adr3, codpostal 
from abn_gccat7;

--Creation RIB
create table src_rib as
select r.*, 'TRM' frq 
from   rib_part r
union all
select r.*, 'MNS' frq
from   rib_gr r;

---creation facture_as400
create table  src_facture_as400  as
select dist,pol,tou,ord,caron,refc01,refc02,refc03,refc04,tvacons,tva_ff,tvaferm,tva_preav,
       tvadeplac,tvadepose_dem,tvadepose_def,tva_capit,tva_pfin,arriere,rbranche,rfacade,
       net,monttrim,montt1,montt2,montt3 ,const1,const2,const3,tauxt1,tauxt2,tauxt3 ,mon1,
       volon1,tauon1,mon2,volon2,tauon2,mon3,volon3,tauon3,fixonas,fraisctr,fermeture,preavis,
       deplacement,depose_dem,depose_def,pfinancier,capit,inter,arepor,nindex,cons,prorata,
       narond,annee,trimestre periode ,tiers,six,to_char(annee)||to_char(trimestre)||to_char(tiers)||to_char(six) cle_role,'TRIM' type
from FICH24_TRIM  f
union
select dist,pol,tou,ord,caron,refc01,refc02,refc03,refc04,tvacons,tva_ff,tvaferm,tva_preav,
       tvadeplac,tvadepose_dem,tvadepose_def,tva_capit,tva_pfin, 0 arriere,rbranche,rfacade,
       monttrim net,monttrim,montt1,montt2,montt3 ,const1,const2,const3,tauxt1,tauxt2,tauxt3 ,mon1,
       volon1,tauon1,mon2,volon2,tauon2,mon3,volon3,tauon3,fixonas,fraisctr,fermeture,preavis,
       deplacement,depose_dem,depose_def,pfinancier,capit,inter,arepor,nindex,cons,prorata,
       narond,refc02 annee,refc01 periode,tiers,six,to_char('20'||refc02)||to_char(refc01) cle_role,'MENS' type
from fich24_gc  f

----creation des facture
create table src_facture as
select * from facture f
where to_number(f.annee) >=2015;

---creation facture impayee
create table src_impayee
as 
select district,police,tournee,ordre,adm,consfac,consred,tarifonas,mtonas,net,mtpaye,datepaye,codpaye,annee,trimestre periode,
mtson,mtimpson,mtimponas,categorie,gros_consommateur,mtimpaye,tiers
from imp_sic
where trim(net)<>trim(mtpaye)
union 
select district,police,tournee,ordre,adm,consfac,consred,tarifonas,mtonas,net,mtpaye,datepaye,codpaye,annee,mois periode,
mtson,mtimpson,mtimponas,categorie,gros_consommateur,mtimp mtimpaye, null tiers
from impgc_sic
where trim(net)<>trim(mtpaye);
----creation role 
create  table src_role as
select  distinct lpad(to_char(trim(distr)),2,'0') DISTR,lpad(to_char(police),5,'0') police,lpad(to_char(tour),3,'0') tour,lpad(to_char(ordr),3,'0') ordr,
        to_number(annee) annee,to_number(trim) trim,to_number(tier) tier ,to_number(six) six,to_char(datexp) datexp,to_char(datl) datl,
        to_number(annee)||to_number(trim)||to_number(tier)||to_number(six) cle_role ,'TRIM' type
from role_trim 
union 
select distinct lpad(to_char(trim(distr)),2,'0') DISTR,lpad(to_char(police),5,'0') police,lpad(to_char(tour),3,'0') tour,lpad(to_char(ordr),3,'0') ordr,
       to_number(annee) annee,to_number(MOIS) TRIM, null tier,to_number(six) six,to_char(datexp) datexp,to_char(datl) datl,
       to_number(annee)||to_number(mois) cle_role,'MENS' type
from role_gc ;

---creation fiche_releve
create table src_fiche_releve as
select r.* from fiche_releve r
where trim(r.annee)>=2015;
 
--Creation table tournee
create table src_tourne as
select distinct district, code,ntiers,nsixieme
from tourne;
--------b1
create table src_b1 as select * from b1_sic;
--------b2
create table src_b2 as select * from b2_sic;