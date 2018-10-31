-----branchement 
create index indx1_branchement 
on branchement(trim(categorie_actuel),trim(client_actuel),district,adresse);

create index indx2_branchement 
on branchement(lpad(trim(district),2,'0'),lpad(trim(police),5,'0'),lpad(trim(tourne),3,'0'),lpad(trim(ordre),3,'0'));

create index indx3_branchement 
on branchement(lpad(trim(district),2,'0'),lpad(trim(categorie_actuel),2,'0'),upper(trim(client_actuel)),spt_id);

create index indx4_branchement 
on branchement(spt_id);

create index indx5_branchement 
on branchement (lpad(trim(district),2,'0'),lpad(trim(tourne),3,'0'),lpad(trim(ordre),3,'0'),spt_id,mtc_id,equ_id);

create index indx6_branchement 
on branchement(lpad(trim(district),2,'0'),lpad(trim(categorie_actuel),2,'0'),upper(trim(client_actuel)));

create index indx7_branchement 
on branchement(lpad(trim(district),2,'0'),lpad(trim(tourne),3,'0'),lpad(trim(ordre),3,'0'),lpad(trim(police),5,'0'),sag_id );

-----client 
create index indx1_client
on client (par_id);

create index indx2_client
on client (lpad(trim(district),2,'0'),lpad(trim(categorie),2,'0'),upper(trim(code)));

create index indx3_client
on client (lpad(trim(district),2,'0'),lpad(trim(categorie),2,'0'),upper(trim(code)),par_id);


---src_abonnee
create index indx1_abonnees
on  src_abonnees (lpad(trim(dist),2,'0'), lpad(trim(pol),5,'0'),lpad(trim(tou),3,'0'),lpad(trim(ord),3,'0'));

----compteur
create index indx1_compteur
on compteur(lpad(trim(district),2,'0'),lpad(trim(code_marque),3,'0') ,lpad(trim(num_compteur),11,'0'));

----marque
create index indx1_marque
on  marque(lpad(trim(district),2,'0'),lpad(trim(code),3,'0'));

-----gestion compteur
create index indx1_gestion_compteur
on gestion_compteur (lpad(trim(district),2,'0'),lpad(trim(tournee),3,'0'),lpad(trim(ordre),3,'0'),trim(num_compteur));

----tourne 
create index indx1_tourne
on tourne (lpad(trim(district),2,'0'),lpad(trim(code),3,'0'));

---src_faire_suivre
create index indx1_faire_suivre
on src_faire_suivre (lpad(trim(dist),2,'0'),lpad(trim(pol),5,'0'),lpad(trim(tou),3,'0'),lpad(trim(ord),3,'0'));

-------src_rib
create index indx1_rib
on src_rib(rib);
-----fiche_releve
create index indx1_fiche_releve 
on fiche_releve (lpad(trim(district),2,'0'),lpad(trim(tourne),3,'0'),lpad(trim(ordre),3,'0'),trim(ncompteur),trim(codemarque));

------src_fiche_releve 
create index indx1_srcf_releve 
on src_fiche_releve (lpad(trim(district),2,'0'),lpad(trim(tourne),3,'0'),lpad(trim(tourne),3,'0'),mrd_id );

create index indx2_srcf_releve 
on src_fiche_releve(lpad(trim(district),2,'0'),lpad(trim(tourne),3,'0'));

---param_tourne
create index indx1_param_tournee 
on param_tournee (lpad(trim(district),2,'0'),trim,tier,six);   
-------SRC_facture_as400
create index indx1_src_fc400
on src_facture_as400(lpad(trim(dist),2,'0'),lpad(trim(tou),3,'0'),lpad(trim(ord),3,'0'),lpad(trim(pol),5,'0'));

create index indx2_src_fc400
on src_facture_as400(lpad(trim(dist),2,'0'),lpad(trim(tou),3,'0'),lpad(trim(ord),3,'0'),lpad(trim(pol),5,'0'),cle_role);

create index indx3_src_fc400 on src_facture_as400(bil_id);

create index idx4_src_fac400 
on src_facture_as400(lpad(trim(dist),2,'0'),lpad(trim(tou),3,'0'),lpad(trim(ord),3,'0'),lpad(trim(pol),5,'0'),deb_id,to_number(annee||periode));	

create index idx5_src_fac400
on src_facture_as400 (lpad(trim(dist),2,'0')||lpad(trim(tou),3,'0')||lpad(trim(ord),3,'0')||to_char(annee)||lpad(to_char(periode),2,'0')||'0'))

-----------src_facture_as400_2
create index indx1_src_fc400_2
on src_facture_as400_2(lpad(trim(dist),2,'0'),lpad(trim(tou),3,'0'),lpad(trim(ord),3,'0'),lpad(trim(pol),5,'0'));

create index indx2_src_fc400_2
on src_facture_as400_2(lpad(trim(dist),2,'0'),lpad(trim(tou),3,'0'),lpad(trim(ord),3,'0'),lpad(trim(pol),5,'0'),cle_role);

create index indx3_src_fc400_2
on src_facture_as400_2(bil_id);

-------SRC_role
create index indx1_src_role
on src_role(lpad(trim(distr),2,'0'),lpad(trim(tour),3,'0'),lpad(trim(ordr),3,'0'),lpad(trim(police),5,'0'),cle_role);
 

 
 create index indx_src_b1
 on src_b1('DISTRICT'||decode(lpad(trim(dist),2,'0'),'02','X',lpad(trim(dist),2,'0')));
 
  create index indx2_src_b1
 on src_b1(decode(lpad(trim(dist),2,'0'),'02','ORGSONEDE',lpad(trim(dist),2,'0')));
 
 create index indx_src_b2
 on src_b2('DISTRICT'||decode(lpad(trim(dist),2,'0'),'02','X',lpad(trim(dist),2,'0'))); 
   create index indx2_src_b2
 on src_b2(decode(lpad(trim(dist),2,'0'),'02','ORGSONEDE',lpad(trim(dist),2,'0')));
 
 
 create index indx01_migbli on genbilline(bil_id,ite_id);
  