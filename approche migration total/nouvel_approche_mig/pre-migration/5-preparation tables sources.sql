
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

----------------------------src_facture_as400_2 
insert into src_facture_as400_2 
select dist,pol,tou,ord,caron,refc01,refc02,refc03,refc04,tvacons,tva_ff,tvaferm,tva_preav,
       tvadeplac,tvadepose_dem,tvadepose_def,tva_capit,tva_pfin,arriere,rbranche,rfacade,
       net,monttrim,montt1,montt2,montt3 ,const1,const2,const3,tauxt1,tauxt2,tauxt3 ,mon1,
       volon1,tauon1,mon2,volon2,tauon2,mon3,volon3,tauon3,fixonas,fraisctr,fermeture,preavis,
       deplacement,depose_dem,depose_def,pfinancier,capit,inter,arepor,nindex,cons,prorata,
       narond,annee,trimestre periode ,tiers,six,to_char(annee)||to_char(trimestre)||to_char(tiers)||to_char(six) cle_role,'TRIM' type,null,null,null
from fich24_trim_suit@migration12  f;
 
 
   insert into src_facture_as400_2 
 (DIST,POL,TOU,ORD,CARON,REFC01,REFC02,REFC03,REFC04,TVACONS,TVA_FF,TVAFERM,TVA_PREAV,
  TVADEPLAC,TVADEPOSE_DEM,TVADEPOSE_DEF,TVA_CAPIT,TVA_PFIN,ARRIERE,RBRANCHE,RFACADE,
  NET,MONTTRIM,MONTT1,MONTT2,MONTT3,CONST1,CONST2,CONST3,TAUXT1,TAUXT2,TAUXT3,MON1,
  VOLON1,TAUON1,MON2,VOLON2,TAUON2,MON3,VOLON3,TAUON3,FIXONAS,FRAISCTR,FERMETURE,PREAVIS,
  DEPLACEMENT,DEPOSE_DEM,DEPOSE_DEF,PFINANCIER,CAPIT,INTER,AREPOR,NINDEX,CONS,PRORATA,
  NAROND,ANNEE,PERIODE,TIERS,SIX,CLE_ROLE,TYPE,BIL_ID,DEB_ID,MRD_ID)
  ( select dist,pol,tou,ord,caron,refc01,refc02,refc03,refc04,tvacons,tva_ff,tvaferm,tva_preav,
       tvadeplac,tvadepose_dem,tvadepose_def,tva_capit,tva_pfin, 0 arriere,rbranche,rfacade,
       monttrim net,monttrim,montt1,montt2,montt3 ,const1,const2,const3,tauxt1,tauxt2,tauxt3 ,mon1,
       volon1,tauon1,mon2,volon2,tauon2,mon3,volon3,tauon3,fixonas,fraisctr,fermeture,preavis,
       deplacement,depose_dem,depose_def,pfinancier,capit,inter,arepor,nindex,cons,prorata,
       narond,refc02 annee,refc01 periode,null tiers,null six,to_char('20'||refc02)||to_char(refc01) cle_role,'MENS' type,null,null,null
from fich24_gc@migration12  
)


----creation des facture
create table src_facture as
select * from facture f
where to_number(f.annee) >=2015;

---creation facture impayee
create table src_impayees
as
select lpad(trim(it.DISTRICT),2,'0') district,lpad(trim(it.POLICE),5,'0') police,lpad(trim(it.TOURNEE),3,0) tourne,lpad(trim(it.ORDRE),3,'0') ordre,lpad(trim(it.CATEGORIE),2,0) categorie,
       it.ADM,it.CONSFAC,it.CONSRED,it.TARIFONAS,it.MTONAS,it.NET,it.MTPAYE,it.DATEPAYE,it.CODPAYE,it.ANNEE,it.TRIMESTRE periode,it.USAG,it.TARIF,it.MTSON,it.MTIMPAYE MTIMPAYE,
       it.MTIMPSON,it.MTIMPONAS,it.CATEGORIE_SIC,it.GROS_CONSOMMATEUR
from   imp_trim@migration12 it
union
select lpad(trim(ig.DISTRICT),2,'0') district,lpad(trim(ig.POLICE),5,'0') police,lpad(trim(ig.TOURNEE),3,0) tourne,lpad(trim(ig.ORDRE),3,'0') ordre,lpad(trim(ig.CATEGORIE),2,0) categorie,
       ig.ADM,ig.CONSFAC,ig.CONSRED,ig.TARIFONAS,ig.MTONAS,ig.NET,ig.MTPAYE,ig.DATEPAYE,ig.CODPAYE,ig.ANNEE,ig.MOIS periode,ig.USAG,ig.TARIF,ig.MTSON,ig.MTIMP MTIMPAYE,
       ig.MTIMPSON,ig.MTIMPONAS,ig.CATEGORIE_SIC,ig.GROS_CONSOMMATEUR
from   imp_gc@migration12 ig;
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
--
create table src_deb_facture
as
select *
from   src_facture_as400
where  deb_id is not null
union
select *
from   src_facture_as400_2
where  deb_id is not null
union
select *
from   src_facture_as400_3
where  deb_id is not null

--compte d'attente as400
create table src_compte_attente
as 
select * 
from   compte_attente@migration12;
--anomalie eau as400
create table src_ano_eau_as400
as
select *
from   anomalie_eauas400@migration12;
--anomalie trv as400
create table src_ano_trv_as400
as
select *
from   anomalie_trvas400@migration12;

--facture annuler et facture districtcreate table src_fac_annule
create table src_fac_annule
as 
select *
from   fac_annule@migration12;

--fiche 24 suit 3
create table src_facture_as400_4
as
select dist,pol,tou,ord,caron,refc01,refc02,refc03,refc04,tvacons,tva_ff,tvaferm,tva_preav,
       tvadeplac,tvadepose_dem,tvadepose_def,tva_capit,tva_pfin,arriere,rbranche,rfacade,
       net,monttrim,montt1,montt2,montt3 ,const1,const2,const3,tauxt1,tauxt2,tauxt3 ,mon1,
       volon1,tauon1,mon2,volon2,tauon2,mon3,volon3,tauon3,fixonas,fraisctr,fermeture,preavis,
       deplacement,depose_dem,depose_def,pfinancier,capit,inter,arepor,nindex,cons,prorata,
       narond,annee,trimestre periode ,tiers,six,to_char(annee)||to_char(trimestre)||to_char(tiers)||to_char(six) cle_role,'TRIM' type
from FICH24_TRIM_SUIT3@Migration12

---creation fiche_releve corriger
create table src_fiche_releve_corrig as
select r.* from fiche_releve_corrig@migration12 r
where trim(r.annee)>=2015;

--fiche 24 suit 4
create table src_facture_as400_5
as
select dist,pol,tou,ord,caron,refc01,refc02,refc03,refc04,tvacons,tva_ff,tvaferm,tva_preav,
       tvadeplac,tvadepose_dem,tvadepose_def,tva_capit,tva_pfin,arriere,rbranche,rfacade,
       net,monttrim,montt1,montt2,montt3 ,const1,const2,const3,tauxt1,tauxt2,tauxt3 ,mon1,
       volon1,tauon1,mon2,volon2,tauon2,mon3,volon3,tauon3,fixonas,fraisctr,fermeture,preavis,
       deplacement,depose_dem,depose_def,pfinancier,capit,inter,arepor,nindex,cons,prorata,
       narond,annee,trimestre periode ,tiers,six,to_char(annee)||to_char(trimestre)||to_char(tiers)||to_char(six) cle_role,'TRIM' type
from FICH24_TRIM_SUIT4@Migration12;

--fiche 24 suit 5
create table src_facture_as400_6
as
select dist,pol,tou,ord,caron,refc01,refc02,refc03,refc04,tvacons,tva_ff,tvaferm,tva_preav,
       tvadeplac,tvadepose_dem,tvadepose_def,tva_capit,tva_pfin,arriere,rbranche,rfacade,
       net,monttrim,montt1,montt2,montt3 ,const1,const2,const3,tauxt1,tauxt2,tauxt3 ,mon1,
       volon1,tauon1,mon2,volon2,tauon2,mon3,volon3,tauon3,fixonas,fraisctr,fermeture,preavis,
       deplacement,depose_dem,depose_def,pfinancier,capit,inter,arepor,nindex,cons,prorata,
       narond,annee,trimestre periode ,tiers,six,to_char(annee)||to_char(trimestre)||to_char(tiers)||to_char(six) cle_role,'TRIM' type
from FICH24_TRIM_SUIT5@Migration12

--impayees 2 
create table src_impayees_2
as
select lpad(trim(ig.DISTRICT),2,'0') district,lpad(trim(ig.POLICE),5,'0') police,lpad(trim(ig.TOURNEE),3,0) tourne,lpad(trim(ig.ORDRE),3,'0') ordre,lpad(trim(ig.CATEGORIE),2,0) categorie,
       ig.ADM,ig.CONSFAC,ig.CONSRED,ig.TARIFONAS,ig.MTONAS,ig.NET,ig.MTPAYE,ig.DATEPAYE,ig.CODPAYE,ig.ANNEE,ig.MOIS periode,ig.USAG,ig.TARIF,ig.MTSON,ig.MTIMP MTIMPAYE,
       ig.MTIMPSON,ig.MTIMPONAS,ig.CATEGORIE_SIC,ig.GROS_CONSOMMATEUR
from   imp_gc_complement@migration12 ig;
