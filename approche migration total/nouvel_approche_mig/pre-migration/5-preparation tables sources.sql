
--Dans la base source
--Creation clients
create table src_clients as
(
select lpad(trim(district),2,'0') district, lpad(trim(categorie),2,'0') categorie, trim(upper(code)) code, tel, autre_tel, fax, nom, adresse, to_number(code_postal) code_postal,
       lpad(trim(district),2,'0')||lpad(trim(categorie),2,'0')||trim(upper(code)) code_cli
       from   client c
	   where c.lpad(trim(categorie),2,'0') <> '02'
union all
       
from   abn_gccat1
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
select dist,pol,tou,ord,cfac,z1,nomadr,usag,codonas,mtonas,fraisctr,tva_ff,fraisbrt,ctarif,tauxt1,tauxt2,tauxt3,nbreapp,partcon,codbrt, 
echtot,echrest,rbranche,rfacade,tva_capit,pfinancier,tva_pfin,aindex,nindex,cons,prorata,const1,montt1,const2,montt2,const3,montt3,z3,mtctot,
tvacons,preavis,tva_preav,codctr,cods,cleref,monttrim,clemt,restpc,cbo,eto,ero,capit,inter,codeso,echtos,codptt,reston,fixonas,z5,qonas,volon1,
tauon1,mon1,volon2,tauon2,mon2,refc01,refc02,refc03,refc04,volon3,tauon3,mon3,caron,arepor,narond,volon4,tauon4,mttonas,fermeture,tvaferm,
deplacement,tvadeplac,depose_dem,tvadepose_dem,depose_def,tvadepose_def,net,arriere ,'TRIM' type
from facture_as400 
union
select  dist,pol,tou,ord,cfac,z1,nomadr,usag,codonas,mtonas,fraisctr,tva_ff,fraisbrt,ctarif,tauxt1,tauxt2,tauxt3,nbreapp,partcon,codbrt, 
echtot,echrest,rbranche,rfacade,tva_capit,pfinancier,tva_pfin,aindex,nindex,cons,prorata,const1,montt1,const2,montt2,const3,montt3,z3,mtctot,
tvacons,preavis,tva_preav,codctr,cods,cleref,monttrim,clemt,restpc,cbo,eto,ero,capit,inter,codeso,echtos,codptt,reston,fixonas,z5,qonas,volon1,
tauon1,mon1,volon2,tauon2,mon2,refc01,refc02,refc03,refc04,volon3,tauon3,mon3,caron,arepor,narond,volon4,tauon4,mttonas,fermeture,tvaferm,
deplacement,tvadeplac,depose_dem,tvadepose_dem,depose_def,tvadepose_def, null net, null arriere ,'MENS' type
from fich24_gc ;

---creation facture impayee
create table src_impayee
as 
select district,police,tournee,ordre,adm,consfac,consred,tarifonas,mtonas,net,mtpaye,datepaye,codpaye,annee,trimestre,
mtson,mtimpson,mtimponas,categorie,gros_consommateur,mtimpaye,tiers
from imp_sic
where trim(net)<>trim(mtpaye)
union 
select district,police,tournee,ordre,adm,consfac,consred,tarifonas,mtonas,net,mtpaye,datepaye,codpaye,annee,mois trimestre,
mtson,mtimpson,mtimponas,categorie,gros_consommateur,mtimp mtimpaye, null tiers
from impgc_sic
where trim(net)<>trim(mtpaye);
----creation role
create table src_role as
select  DISTR,TOUR,ORDR,POLICE,DATEXP,ANNEE,TRIM,TIER,SIX,NET,DATL,CODR,ANCREP,NOUREP,TCONS,CPREAV,CFER,COB,CAY,
      CONAS,TARIFS,NAPPR,CBRCH,CCTR,BRANCH,PARTCO,EXTENS,FACADE,PFINA,ECHRES,ECGRO,CATEG,QPOLL
from role_trim 
 union
select DISTR,TOUR,ORDR,POLICE,DATEXP,ANNEE,MOIS TRIM,null TIER,SIX,NET,DATL,CODR,ANCREP,NOUREP,TCONS,CPREAV,CFER,COB,CAY,
      CONAS,TARIFS,NAPPR,CBRCH,CCTR,BRANCH,PARTCO,EXTENS,FACADE,PFINA,ECHRES,ECGRO,CATEG,QPOLL
from role_gc ;

---creation fiche_releve
create table src_fiche_releve as
select r.* from fiche_releve r
where trim(r.annee)>=2015;
---creation releveT
create table src_releveT as
select DISTRICT,TOURNE,ORDRE,POLICE,ANNEE,TRIMESTRE,INDEXR,INDEXA,PRORATA,CPT_TOURNE,ETAT,
CODEFERMETURE,CODEOUVERTURE,CODERESILIATION,ANOMALIE_NICHE,ANOMALIE_COMPTEUR,ANOMALIE_FUITE,CONSOMMATION,DATE_RELEVE ,'TRIM' type
from relevet
union
 select DISTRICT,TOURNE,ORDRE,POLICE,ANNEE,MOIS TRIMESTRE,INDEXR,INDEXA,PRORATA,CPT_TOURNE,ETAT,
CODEFERMETURE,CODEOUVERTURE,CODERESILIATION,ANOMALIE_NICHE,ANOMALIE_COMPTEUR,ANOMALIE_FUITE,CONSOMMATION,DATE_RELEVE,'MENS' type
 from relevegc
 
--Creation table tournee
create table src_tourne as
select distinct district, code,ntiers,nsixieme
from tourne;