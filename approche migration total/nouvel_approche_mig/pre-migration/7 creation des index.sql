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
on branchement(lpad(trim(district),2,'0'),lpad(trim(categorie_actuel),2,'0'),upper(trim(client_actuel)));create index indx6_branchement 
on branchement(lpad(trim(district),2,'0'),lpad(trim(categorie_actuel),2,'0'),upper(trim(client_actuel)));
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



 