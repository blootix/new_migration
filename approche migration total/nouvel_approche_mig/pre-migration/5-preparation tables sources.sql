
--Dans la base source
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