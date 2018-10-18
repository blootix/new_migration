select distinct fdb.* , dmd.*, dvi.*, rgl.*
from   fdbt103 fdb,
       reglement_ds rgl,
       devis_ds dvi,
       demande_ds dmd
where  lpad(trim(fdb.dist),2,'0') = lpad(trim(rgl.district),2,'0')
and    lpad(trim(fdb.pol),5,'0') = lpad(trim(rgl.police),5,'0')
and    lpad(trim(dmd.district),2,'0') = lpad(trim(dvi.district),2,'0')
and    trim(dmd.localite) = trim(dvi.code_localite_ds)
and    dmd.annee = dvi.annee_ds 
and    dmd.num = dvi.num_ds
and    upper(trim(dvi.etat)) = 'V'
and    dvi.annee_ds = rgl.annee_ds
and    lpad(trim(dvi.district),2,'0') = lpad(trim(rgl.district),2,'0')
and    trim(dvi.code_localite_ds) = trim(rgl.code_localite_ds)
and    dvi.annee_ds = rgl.annee_ds
and    dvi.num_ds = rgl.num_ds
and    dvi.num = rgl.num_devis_ds
and    dmd.etat<6
and    dmd.annuler = 'N'
and    ((dmd.etat in (3,4,5) and dmd.annee>2016) or (dmd.etat>5))             
and not exists (select 1
                from   src_abonnees abn
                where  lpad(trim(fdb.dist),2,'0') = lpad(trim(abn.dist),2,'0')
                and    lpad(trim(fdb.pol),5,'0') = lpad(trim(abn.pol),5,'0')
               )
and not exists(select 1
               from   branchement br
               where  lpad(trim(fdb.dist),2,'0') = lpad(trim(br.district),2,'0')
               and    lpad(trim(fdb.pol),5,'0') = lpad(trim(br.police),5,'0')
            )
order by fdb.cbrt; --15 -existe dans dmd < 6 n'existe ni dans branchement ni dans abonnees
-------------------------------------------

select distinct fdb.*, dmd.*, dvi.*, rgl.* , br.*
from   fdbt103 fdb,
       reglement_ds rgl,
       devis_ds dvi,
       demande_ds dmd,
       branchement br
where  lpad(trim(fdb.dist),2,'0') = lpad(trim(rgl.district),2,'0')
and    lpad(trim(fdb.pol),5,'0') = lpad(trim(rgl.police),5,'0')
and    lpad(trim(dmd.district),2,'0') = lpad(trim(dvi.district),2,'0')
and    trim(dmd.localite) = trim(dvi.code_localite_ds)
and    dmd.annee = dvi.annee_ds 
and    dmd.num = dvi.num_ds
and    upper(trim(dvi.etat)) = 'V'
and    dvi.annee_ds = rgl.annee_ds
and    lpad(trim(dvi.district),2,'0') = lpad(trim(rgl.district),2,'0')
and    trim(dvi.code_localite_ds) = trim(rgl.code_localite_ds)
and    dvi.annee_ds = rgl.annee_ds
and    dvi.num_ds = rgl.num_ds
and    dvi.num = rgl.num_devis_ds
and    dmd.etat<6
and    dmd.annuler = 'N'
and    ((dmd.etat in (3,4,5) and dmd.annee>2016) or (dmd.etat>5))             
and not exists (select 1
                from   src_abonnees abn
                where  lpad(trim(fdb.dist),2,'0') = lpad(trim(abn.dist),2,'0')
                and    lpad(trim(fdb.pol),5,'0') = lpad(trim(abn.pol),5,'0')
               )
  
and    lpad(trim(fdb.dist),2,'0') = lpad(trim(br.district),2,'0')
and    lpad(trim(fdb.pol),5,'0') = lpad(trim(br.police),5,'0')
order by fdb.cbrt; --0 - existe dans dmd < 6 existe dans branchement et n'existe pas dans abonnees
-------------------------------------------------------------------------

select distinct fdb.*, dmd.*, dvi.*, rgl.* , abn.*
from   fdbt103 fdb,
       reglement_ds rgl,
       devis_ds dvi,
       demande_ds dmd,
       src_abonnees abn
where  lpad(trim(fdb.dist),2,'0') = lpad(trim(rgl.district),2,'0')
and    lpad(trim(fdb.pol),5,'0') = lpad(trim(rgl.police),5,'0')
and    lpad(trim(dmd.district),2,'0') = lpad(trim(dvi.district),2,'0')
and    trim(dmd.localite) = trim(dvi.code_localite_ds)
and    dmd.annee = dvi.annee_ds 
and    dmd.num = dvi.num_ds
and    upper(trim(dvi.etat)) = 'V'
and    dvi.annee_ds = rgl.annee_ds
and    lpad(trim(dvi.district),2,'0') = lpad(trim(rgl.district),2,'0')
and    trim(dvi.code_localite_ds) = trim(rgl.code_localite_ds)
and    dvi.annee_ds = rgl.annee_ds
and    dvi.num_ds = rgl.num_ds
and    dvi.num = rgl.num_devis_ds
and    dmd.etat<6
and    dmd.annuler = 'N'
and    ((dmd.etat in (3,4,5) and dmd.annee>2016) or (dmd.etat>5))             
and    lpad(trim(fdb.dist),2,'0') = lpad(trim(abn.dist),2,'0')
and    lpad(trim(fdb.pol),5,'0') = lpad(trim(abn.pol),5,'0')
and not exists(select 1
               from   branchement br
               where  lpad(trim(fdb.dist),2,'0') = lpad(trim(br.district),2,'0')
               and    lpad(trim(fdb.pol),5,'0') = lpad(trim(br.police),5,'0')
            )
order by fdb.cbrt; --0 - existe dans dmd < 6 n'existe pas dans branchement et existe dans abonnees
-------------------------------------------------------------------------

select distinct fdb.*, dmd.*, dvi.*, rgl.*, br.*, abn.* 
from   fdbt103 fdb,
       reglement_ds rgl,
       devis_ds dvi,
       demande_ds dmd,
       src_abonnees abn,
       branchement br
where  lpad(trim(fdb.dist),2,'0') = lpad(trim(rgl.district),2,'0')
and    lpad(trim(fdb.pol),5,'0') = lpad(trim(rgl.police),5,'0')
and    lpad(trim(dmd.district),2,'0') = lpad(trim(dvi.district),2,'0')
and    trim(dmd.localite) = trim(dvi.code_localite_ds)
and    dmd.annee = dvi.annee_ds 
and    dmd.num = dvi.num_ds
and    upper(trim(dvi.etat)) = 'V'
and    dvi.annee_ds = rgl.annee_ds
and    lpad(trim(dvi.district),2,'0') = lpad(trim(rgl.district),2,'0')
and    trim(dvi.code_localite_ds) = trim(rgl.code_localite_ds)
and    dvi.annee_ds = rgl.annee_ds
and    dvi.num_ds = rgl.num_ds
and    dvi.num = rgl.num_devis_ds
and    dmd.etat<6
and    dmd.annuler = 'N'
and    ((dmd.etat in (3,4,5) and dmd.annee>2016) or (dmd.etat>5))             
and    lpad(trim(fdb.dist),2,'0') = lpad(trim(abn.dist),2,'0')
and    lpad(trim(fdb.pol),5,'0') = lpad(trim(abn.pol),5,'0')
and    lpad(trim(fdb.dist),2,'0') = lpad(trim(br.district),2,'0')
and    lpad(trim(fdb.pol),5,'0') = lpad(trim(br.police),5,'0')
order by fdb.cbrt; --9 - existe dans dmd < 6  existe dans branchement et existe dans abonnees
-------------------------------------------------------------------------
------------------------------
------------------------------

select distinct fdb.*, dmd.*, dvi.*, rgl.*
from   fdbt103 fdb,
       reglement_ds rgl,
       devis_ds dvi,
       demande_ds dmd
where  lpad(trim(fdb.dist),2,'0') = lpad(trim(rgl.district),2,'0')
and    lpad(trim(fdb.pol),5,'0') = lpad(trim(rgl.police),5,'0')
and    lpad(trim(dmd.district),2,'0') = lpad(trim(dvi.district),2,'0')
and    trim(dmd.localite) = trim(dvi.code_localite_ds)
and    dmd.annee = dvi.annee_ds 
and    dmd.num = dvi.num_ds
and    upper(trim(dvi.etat)) = 'V'
and    dvi.annee_ds = rgl.annee_ds
and    lpad(trim(dvi.district),2,'0') = lpad(trim(rgl.district),2,'0')
and    trim(dvi.code_localite_ds) = trim(rgl.code_localite_ds)
and    dvi.annee_ds = rgl.annee_ds
and    dvi.num_ds = rgl.num_ds
and    dvi.num = rgl.num_devis_ds
and    dmd.etat=6
and    dmd.annuler = 'N'
and    ((dmd.etat in (3,4,5) and dmd.annee>2016) or (dmd.etat>5))             
and not exists (select 1
                from   src_abonnees abn
                where  lpad(trim(fdb.dist),2,'0') = lpad(trim(abn.dist),2,'0')
                and    lpad(trim(fdb.pol),5,'0') = lpad(trim(abn.pol),5,'0')
               )
and not exists(select 1
               from   branchement br
               where  lpad(trim(fdb.dist),2,'0') = lpad(trim(br.district),2,'0')
               and    lpad(trim(fdb.pol),5,'0') = lpad(trim(br.police),5,'0')
            )
order by fdb.cbrt; --10400 - existe dans dmd = 6 n'existe ni dans branchement ni dans abonnees
-------------------------------------------

select distinct fdb.*, dmd.*, dvi.*, rgl.*,br.*
from   fdbt103 fdb,
       reglement_ds rgl,
       devis_ds dvi,
       demande_ds dmd,
       branchement br
where  lpad(trim(fdb.dist),2,'0') = lpad(trim(rgl.district),2,'0')
and    lpad(trim(fdb.pol),5,'0') = lpad(trim(rgl.police),5,'0')
and    lpad(trim(dmd.district),2,'0') = lpad(trim(dvi.district),2,'0')
and    trim(dmd.localite) = trim(dvi.code_localite_ds)
and    dmd.annee = dvi.annee_ds 
and    dmd.num = dvi.num_ds
and    upper(trim(dvi.etat)) = 'V'
and    dvi.annee_ds = rgl.annee_ds
and    lpad(trim(dvi.district),2,'0') = lpad(trim(rgl.district),2,'0')
and    trim(dvi.code_localite_ds) = trim(rgl.code_localite_ds)
and    dvi.annee_ds = rgl.annee_ds
and    dvi.num_ds = rgl.num_ds
and    dvi.num = rgl.num_devis_ds
and    dmd.etat=6
and    dmd.annuler = 'N'
and    ((dmd.etat in (3,4,5) and dmd.annee>2016) or (dmd.etat>5))             
and not exists (select 1
                from   src_abonnees abn
                where  lpad(trim(fdb.dist),2,'0') = lpad(trim(abn.dist),2,'0')
                and    lpad(trim(fdb.pol),5,'0') = lpad(trim(abn.pol),5,'0')
               )
and    lpad(trim(fdb.dist),2,'0') = lpad(trim(br.district),2,'0')
and    lpad(trim(fdb.pol),5,'0') = lpad(trim(br.police),5,'0')
order by fdb.cbrt; --34 - existe dans dmd = 6 existe dans branchement et n'existe pas dans abonnees
-------------------------------------------

select distinct fdb.*, dmd.*, dvi.*, rgl.*, abn.*
from   fdbt103 fdb,
       reglement_ds rgl,
       devis_ds dvi,
       demande_ds dmd,
       src_abonnees abn
where  lpad(trim(fdb.dist),2,'0') = lpad(trim(rgl.district),2,'0')
and    lpad(trim(fdb.pol),5,'0') = lpad(trim(rgl.police),5,'0')
and    lpad(trim(dmd.district),2,'0') = lpad(trim(dvi.district),2,'0')
and    trim(dmd.localite) = trim(dvi.code_localite_ds)
and    dmd.annee = dvi.annee_ds 
and    dmd.num = dvi.num_ds
and    upper(trim(dvi.etat)) = 'V'
and    dvi.annee_ds = rgl.annee_ds
and    lpad(trim(dvi.district),2,'0') = lpad(trim(rgl.district),2,'0')
and    trim(dvi.code_localite_ds) = trim(rgl.code_localite_ds)
and    dvi.annee_ds = rgl.annee_ds
and    dvi.num_ds = rgl.num_ds
and    dvi.num = rgl.num_devis_ds
and    dmd.etat=6
and    dmd.annuler = 'N'
and    ((dmd.etat in (3,4,5) and dmd.annee>2016) or (dmd.etat>5))             
and    lpad(trim(fdb.dist),2,'0') = lpad(trim(abn.dist),2,'0')
and    lpad(trim(fdb.pol),5,'0') = lpad(trim(abn.pol),5,'0')
and not exists(select 1
               from   branchement br
               where  lpad(trim(fdb.dist),2,'0') = lpad(trim(br.district),2,'0')
               and    lpad(trim(fdb.pol),5,'0') = lpad(trim(br.police),5,'0')
            )
order by fdb.cbrt; --0 - existe dans dmd = 6 n'existe pas dans branchement et existe dans abonnees
-------------------------------------------
select distinct fdb.*, dmd.*, dvi.*, rgl.*,br.*,abn.*
from   fdbt103 fdb,
       reglement_ds rgl,
       devis_ds dvi,
       demande_ds dmd,
       branchement br,
       src_abonnees abn
where  lpad(trim(fdb.dist),2,'0') = lpad(trim(rgl.district),2,'0')
and    lpad(trim(fdb.pol),5,'0') = lpad(trim(rgl.police),5,'0')
and    lpad(trim(dmd.district),2,'0') = lpad(trim(dvi.district),2,'0')
and    trim(dmd.localite) = trim(dvi.code_localite_ds)
and    dmd.annee = dvi.annee_ds 
and    dmd.num = dvi.num_ds
and    upper(trim(dvi.etat)) = 'V'
and    dvi.annee_ds = rgl.annee_ds
and    lpad(trim(dvi.district),2,'0') = lpad(trim(rgl.district),2,'0')
and    trim(dvi.code_localite_ds) = trim(rgl.code_localite_ds)
and    dvi.annee_ds = rgl.annee_ds
and    dvi.num_ds = rgl.num_ds
and    dvi.num = rgl.num_devis_ds
and    dmd.etat=6
and    dmd.annuler = 'N'
and    ((dmd.etat in (3,4,5) and dmd.annee>2016) or (dmd.etat>5))             
and    lpad(trim(fdb.dist),2,'0') = lpad(trim(abn.dist),2,'0')
and    lpad(trim(fdb.pol),5,'0') = lpad(trim(abn.pol),5,'0')
and    lpad(trim(fdb.dist),2,'0') = lpad(trim(br.district),2,'0')
and    lpad(trim(fdb.pol),5,'0') = lpad(trim(br.police),5,'0')
order by fdb.cbrt; --1478 -  existe dans dmd = 6 existe dans branchement et existe dans abonnees
-------------------------------------------
-----------------------------------
-----------------------------------
               
select distinct fdb.*, dmd.*, dvi.*, rgl.*
from   fdbt103 fdb,
       reglement_ds rgl,
       devis_ds dvi,
       demande_ds dmd
where  lpad(trim(fdb.dist),2,'0') = lpad(trim(rgl.district),2,'0')
and    lpad(trim(fdb.pol),5,'0') = lpad(trim(rgl.police),5,'0')
and    lpad(trim(dmd.district),2,'0') = lpad(trim(dvi.district),2,'0')
and    trim(dmd.localite) = trim(dvi.code_localite_ds)
and    dmd.annee = dvi.annee_ds 
and    dmd.num = dvi.num_ds
and    upper(trim(dvi.etat)) = 'V'
and    dvi.annee_ds = rgl.annee_ds
and    lpad(trim(dvi.district),2,'0') = lpad(trim(rgl.district),2,'0')
and    trim(dvi.code_localite_ds) = trim(rgl.code_localite_ds)
and    dvi.annee_ds = rgl.annee_ds
and    dvi.num_ds = rgl.num_ds
and    dvi.num = rgl.num_devis_ds
and    dmd.etat=7
and    dmd.annuler = 'N'
and    ((dmd.etat in (3,4,5) and dmd.annee>2016) or (dmd.etat>5))
and not exists (select 1
                from   src_abonnees abn
                where  lpad(trim(fdb.dist),2,'0') = lpad(trim(abn.dist),2,'0')
                and    lpad(trim(fdb.pol),5,'0') = lpad(trim(abn.pol),5,'0')
               )
and not exists(select 1
               from   branchement br
               where  lpad(trim(fdb.dist),2,'0') = lpad(trim(br.district),2,'0')
               and    lpad(trim(fdb.pol),5,'0') = lpad(trim(br.police),5,'0')
              ) 
order by fdb.cbrt; --40 -  existe dans dmd = 7 n'existe ni sans branchement ni dans abonnees 
---------------------------------------------------------------

select distinct fdb.*, dmd.*, dvi.*, rgl.*, br.*
from   fdbt103 fdb,
       reglement_ds rgl,
       devis_ds dvi,
       demande_ds dmd,
       branchement br
where  lpad(trim(fdb.dist),2,'0') = lpad(trim(rgl.district),2,'0')
and    lpad(trim(fdb.pol),5,'0') = lpad(trim(rgl.police),5,'0')
and    lpad(trim(dmd.district),2,'0') = lpad(trim(dvi.district),2,'0')
and    trim(dmd.localite) = trim(dvi.code_localite_ds)
and    dmd.annee = dvi.annee_ds 
and    dmd.num = dvi.num_ds
and    upper(trim(dvi.etat)) = 'V'
and    dvi.annee_ds = rgl.annee_ds
and    lpad(trim(dvi.district),2,'0') = lpad(trim(rgl.district),2,'0')
and    trim(dvi.code_localite_ds) = trim(rgl.code_localite_ds)
and    dvi.annee_ds = rgl.annee_ds
and    dvi.num_ds = rgl.num_ds
and    dvi.num = rgl.num_devis_ds
and    dmd.etat=7
and    dmd.annuler = 'N'
and    ((dmd.etat in (3,4,5) and dmd.annee>2016) or (dmd.etat>5))
and not exists (select 1
                from   src_abonnees abn
                where  lpad(trim(fdb.dist),2,'0') = lpad(trim(abn.dist),2,'0')
                and    lpad(trim(fdb.pol),5,'0') = lpad(trim(abn.pol),5,'0')
               )
and    lpad(trim(fdb.dist),2,'0') = lpad(trim(br.district),2,'0')
and    lpad(trim(fdb.pol),5,'0') = lpad(trim(br.police),5,'0') 
order by fdb.cbrt; --9 -  existe dans dmd = 7 n'existe ni sans branchement ni dans abonnees 
---------------------------------------------------------------

select distinct fdb.*, dmd.*, dvi.*, rgl.*,abn.*
from   fdbt103 fdb,
       reglement_ds rgl,
       devis_ds dvi,
       demande_ds dmd,
       src_abonnees abn
where  lpad(trim(fdb.dist),2,'0') = lpad(trim(rgl.district),2,'0')
and    lpad(trim(fdb.pol),5,'0') = lpad(trim(rgl.police),5,'0')
and    lpad(trim(dmd.district),2,'0') = lpad(trim(dvi.district),2,'0')
and    trim(dmd.localite) = trim(dvi.code_localite_ds)
and    dmd.annee = dvi.annee_ds 
and    dmd.num = dvi.num_ds
and    upper(trim(dvi.etat)) = 'V'
and    dvi.annee_ds = rgl.annee_ds
and    lpad(trim(dvi.district),2,'0') = lpad(trim(rgl.district),2,'0')
and    trim(dvi.code_localite_ds) = trim(rgl.code_localite_ds)
and    dvi.annee_ds = rgl.annee_ds
and    dvi.num_ds = rgl.num_ds
and    dvi.num = rgl.num_devis_ds
and    dmd.etat=7
and    dmd.annuler = 'N'
and    ((dmd.etat in (3,4,5) and dmd.annee>2016) or (dmd.etat>5))
and    lpad(trim(fdb.dist),2,'0') = lpad(trim(abn.dist),2,'0')
and    lpad(trim(fdb.pol),5,'0') = lpad(trim(abn.pol),5,'0')
and not exists(select 1
               from   branchement br
               where  lpad(trim(fdb.dist),2,'0') = lpad(trim(br.district),2,'0')
               and    lpad(trim(fdb.pol),5,'0') = lpad(trim(br.police),5,'0')
              ) 
order by fdb.cbrt; --0 -  existe dans dmd = 7 n'existe pas dans branchement et existe pas dans abonnees 
---------------------------------------------------------------

select distinct fdb.*, dmd.*, dvi.*, rgl.*,br.*,abn.*
from   fdbt103 fdb,
       reglement_ds rgl,
       devis_ds dvi,
       demande_ds dmd,
       branchement br,
       src_abonnees abn
where  lpad(trim(fdb.dist),2,'0') = lpad(trim(rgl.district),2,'0')
and    lpad(trim(fdb.pol),5,'0') = lpad(trim(rgl.police),5,'0')
and    lpad(trim(dmd.district),2,'0') = lpad(trim(dvi.district),2,'0')
and    trim(dmd.localite) = trim(dvi.code_localite_ds)
and    dmd.annee = dvi.annee_ds 
and    dmd.num = dvi.num_ds
and    upper(trim(dvi.etat)) = 'V'
and    dvi.annee_ds = rgl.annee_ds
and    lpad(trim(dvi.district),2,'0') = lpad(trim(rgl.district),2,'0')
and    trim(dvi.code_localite_ds) = trim(rgl.code_localite_ds)
and    dvi.annee_ds = rgl.annee_ds
and    dvi.num_ds = rgl.num_ds
and    dvi.num = rgl.num_devis_ds
and    dmd.etat=7
and    dmd.annuler = 'N'
and    ((dmd.etat in (3,4,5) and dmd.annee>2016) or (dmd.etat>5))
and    lpad(trim(fdb.dist),2,'0') = lpad(trim(abn.dist),2,'0')
and    lpad(trim(fdb.pol),5,'0') = lpad(trim(abn.pol),5,'0')
and    lpad(trim(fdb.dist),2,'0') = lpad(trim(br.district),2,'0')
and    lpad(trim(fdb.pol),5,'0') = lpad(trim(br.police),5,'0')
order by fdb.cbrt; --933 - existe dans dmd = 7 existe dans branchement et existe dans abonnees 
---------------------------------------------------------------
---------------------------------
---------------------------------

select distinct fdb.*, dmd.*, dvi.*, rgl.*
from   fdbt103 fdb,
       reglement_ds rgl,
       devis_ds dvi,
       demande_ds dmd
where  lpad(trim(fdb.dist),2,'0') = lpad(trim(rgl.district),2,'0')
and    lpad(trim(fdb.pol),5,'0') = lpad(trim(rgl.police),5,'0')
and    lpad(trim(dmd.district),2,'0') = lpad(trim(dvi.district),2,'0')
and    trim(dmd.localite) = trim(dvi.code_localite_ds)
and    dmd.annee = dvi.annee_ds 
and    dmd.num = dvi.num_ds
and    upper(trim(dvi.etat)) = 'V'
and    dvi.annee_ds = rgl.annee_ds
and    lpad(trim(dvi.district),2,'0') = lpad(trim(rgl.district),2,'0')
and    trim(dvi.code_localite_ds) = trim(rgl.code_localite_ds)
and    dvi.annee_ds = rgl.annee_ds
and    dvi.num_ds = rgl.num_ds
and    dvi.num = rgl.num_devis_ds
and    dmd.etat=8
and    dmd.annuler = 'N'
and    ((dmd.etat in (3,4,5) and dmd.annee>2016) or (dmd.etat>5))
and not exists (select 1
                from   src_abonnees abn
                where  lpad(trim(fdb.dist),2,'0') = lpad(trim(abn.dist),2,'0')
                and    lpad(trim(fdb.pol),5,'0') = lpad(trim(abn.pol),5,'0')
               )
and not exists(select 1
               from   branchement br
               where  lpad(trim(fdb.dist),2,'0') = lpad(trim(br.district),2,'0')
               and    lpad(trim(fdb.pol),5,'0') = lpad(trim(br.police),5,'0')
              ) 
order by fdb.cbrt; --22456 - existe dans dmd = 8 n'existe ni sans branchement ni dans abonnees 
---------------------------------------------------------------

select distinct fdb.*, dmd.*, dvi.*, rgl.*, br.*
from   fdbt103 fdb,
       reglement_ds rgl,
       devis_ds dvi,
       demande_ds dmd,
       branchement br
where  lpad(trim(fdb.dist),2,'0') = lpad(trim(rgl.district),2,'0')
and    lpad(trim(fdb.pol),5,'0') = lpad(trim(rgl.police),5,'0')
and    lpad(trim(dmd.district),2,'0') = lpad(trim(dvi.district),2,'0')
and    trim(dmd.localite) = trim(dvi.code_localite_ds)
and    dmd.annee = dvi.annee_ds 
and    dmd.num = dvi.num_ds
and    upper(trim(dvi.etat)) = 'V'
and    dvi.annee_ds = rgl.annee_ds
and    lpad(trim(dvi.district),2,'0') = lpad(trim(rgl.district),2,'0')
and    trim(dvi.code_localite_ds) = trim(rgl.code_localite_ds)
and    dvi.annee_ds = rgl.annee_ds
and    dvi.num_ds = rgl.num_ds
and    dvi.num = rgl.num_devis_ds
and    dmd.etat=8
and    dmd.annuler = 'N'
and    ((dmd.etat in (3,4,5) and dmd.annee>2016) or (dmd.etat>5))
and not exists (select 1
                from   src_abonnees abn
                where  lpad(trim(fdb.dist),2,'0') = lpad(trim(abn.dist),2,'0')
                and    lpad(trim(fdb.pol),5,'0') = lpad(trim(abn.pol),5,'0')
               )
and    lpad(trim(fdb.dist),2,'0') = lpad(trim(br.district),2,'0')
and    lpad(trim(fdb.pol),5,'0') = lpad(trim(br.police),5,'0') 
order by fdb.cbrt; --1997 - existe dans dmd = 8 existe dans branchement et n'existe pas dans abonnees 
---------------------------------------------------------------

select distinct fdb.*, dmd.*, dvi.*, rgl.*,abn.*
from   fdbt103 fdb,
       reglement_ds rgl,
       devis_ds dvi,
       demande_ds dmd,
       src_abonnees abn
where  lpad(trim(fdb.dist),2,'0') = lpad(trim(rgl.district),2,'0')
and    lpad(trim(fdb.pol),5,'0') = lpad(trim(rgl.police),5,'0')
and    lpad(trim(dmd.district),2,'0') = lpad(trim(dvi.district),2,'0')
and    trim(dmd.localite) = trim(dvi.code_localite_ds)
and    dmd.annee = dvi.annee_ds 
and    dmd.num = dvi.num_ds
and    upper(trim(dvi.etat)) = 'V'
and    dvi.annee_ds = rgl.annee_ds
and    lpad(trim(dvi.district),2,'0') = lpad(trim(rgl.district),2,'0')
and    trim(dvi.code_localite_ds) = trim(rgl.code_localite_ds)
and    dvi.annee_ds = rgl.annee_ds
and    dvi.num_ds = rgl.num_ds
and    dvi.num = rgl.num_devis_ds
and    dmd.etat=8
and    dmd.annuler = 'N'
and    ((dmd.etat in (3,4,5) and dmd.annee>2016) or (dmd.etat>5))
and    lpad(trim(fdb.dist),2,'0') = lpad(trim(abn.dist),2,'0')
and    lpad(trim(fdb.pol),5,'0') = lpad(trim(abn.pol),5,'0')
and not exists(select 1
               from   branchement br
               where  lpad(trim(fdb.dist),2,'0') = lpad(trim(br.district),2,'0')
               and    lpad(trim(fdb.pol),5,'0') = lpad(trim(br.police),5,'0')
              ) 
order by fdb.cbrt; --8 - existe dans dmd = 8 n'existe pas dans branchement et existe pas dans abonnees 
---------------------------------------------------------------

select distinct fdb.*, dmd.*, dvi.*, rgl.*,br.*,abn.*
from   fdbt103 fdb,
       reglement_ds rgl,
       devis_ds dvi,
       demande_ds dmd,
       branchement br,
       src_abonnees abn
where  lpad(trim(fdb.dist),2,'0') = lpad(trim(rgl.district),2,'0')
and    lpad(trim(fdb.pol),5,'0') = lpad(trim(rgl.police),5,'0')
and    lpad(trim(dmd.district),2,'0') = lpad(trim(dvi.district),2,'0')
and    trim(dmd.localite) = trim(dvi.code_localite_ds)
and    dmd.annee = dvi.annee_ds 
and    dmd.num = dvi.num_ds
and    upper(trim(dvi.etat)) = 'V'
and    dvi.annee_ds = rgl.annee_ds
and    lpad(trim(dvi.district),2,'0') = lpad(trim(rgl.district),2,'0')
and    trim(dvi.code_localite_ds) = trim(rgl.code_localite_ds)
and    dvi.annee_ds = rgl.annee_ds
and    dvi.num_ds = rgl.num_ds
and    dvi.num = rgl.num_devis_ds
and    dmd.etat=8
and    dmd.annuler = 'N'
and    ((dmd.etat in (3,4,5) and dmd.annee>2016) or (dmd.etat>5))
and    lpad(trim(fdb.dist),2,'0') = lpad(trim(abn.dist),2,'0')
and    lpad(trim(fdb.pol),5,'0') = lpad(trim(abn.pol),5,'0')
and    lpad(trim(fdb.dist),2,'0') = lpad(trim(br.district),2,'0')
and    lpad(trim(fdb.pol),5,'0') = lpad(trim(br.police),5,'0')
order by fdb.cbrt; --150396 -  existe dans dmd = 8 existe dans branchement et existe dans abonnees 
---------------------------------------------------------------
--------------------------------
--------------------------------
select distinct fdb.* 
from   fdbt103 fdb
where  not exists (select 1
                   from   reglement_ds rgl,
                          devis_ds dvi,
                          demande_ds dmd
                   where  lpad(trim(dmd.district),2,'0') = lpad(trim(dvi.district),2,'0')
                   and    trim(dmd.localite) = trim(dvi.code_localite_ds)
                   and    dmd.annee = dvi.annee_ds 
                   and    dmd.num = dvi.num_ds
                   and    upper(trim(dvi.etat)) = 'V'
                   and    dvi.annee_ds = rgl.annee_ds
                   and    lpad(trim(dvi.district),2,'0') = lpad(trim(rgl.district),2,'0')
                   and    trim(dvi.code_localite_ds) = trim(rgl.code_localite_ds)
                   and    dvi.annee_ds = rgl.annee_ds
                   and    dvi.num_ds = rgl.num_ds
                   and    dvi.num = rgl.num_devis_ds
                   and    dmd.annuler = 'N'
                   and    ((dmd.etat in (3,4,5) and dmd.annee>2016) or (dmd.etat>5))
                   and    lpad(trim(fdb.dist),2,'0') = lpad(trim(rgl.district),2,'0')
                   and    lpad(trim(fdb.pol),5,'0') = lpad(trim(rgl.police),5,'0')
                   )
and not exists (select 1
                from   src_abonnees abn
                where  lpad(trim(fdb.dist),2,'0') = lpad(trim(abn.dist),2,'0')
                and    lpad(trim(fdb.pol),5,'0') = lpad(trim(abn.pol),5,'0')
               )
and not exists(select 1
               from   branchement br
               where  lpad(trim(fdb.dist),2,'0') = lpad(trim(br.district),2,'0')
               and    lpad(trim(fdb.pol),5,'0') = lpad(trim(br.police),5,'0')
            )
order by fdb.cbrt; --635  nexiste ni dans dmd ni dans br ni dans abn
----------------------------------------------
select distinct fdb.*, br.* 
from   fdbt103 fdb,
       branchement br
where  not exists (select 1
                   from   reglement_ds rgl,
                          devis_ds dvi,
                          demande_ds dmd
                   where  lpad(trim(dmd.district),2,'0') = lpad(trim(dvi.district),2,'0')
                   and    trim(dmd.localite) = trim(dvi.code_localite_ds)
                   and    dmd.annee = dvi.annee_ds 
                   and    dmd.num = dvi.num_ds
                   and    upper(trim(dvi.etat)) = 'V'
                   and    dvi.annee_ds = rgl.annee_ds
                   and    lpad(trim(dvi.district),2,'0') = lpad(trim(rgl.district),2,'0')
                   and    trim(dvi.code_localite_ds) = trim(rgl.code_localite_ds)
                   and    dvi.annee_ds = rgl.annee_ds
                   and    dvi.num_ds = rgl.num_ds
                   and    dvi.num = rgl.num_devis_ds
                   and    dmd.annuler = 'N'
                   and    ((dmd.etat in (3,4,5) and dmd.annee>2016) or (dmd.etat>5))
                   and    lpad(trim(fdb.dist),2,'0') = lpad(trim(rgl.district),2,'0')
                   and    lpad(trim(fdb.pol),5,'0') = lpad(trim(rgl.police),5,'0')
                   )
and not exists (select 1
                from   src_abonnees abn
                where  lpad(trim(fdb.dist),2,'0') = lpad(trim(abn.dist),2,'0')
                and    lpad(trim(fdb.pol),5,'0') = lpad(trim(abn.pol),5,'0')
               )
and    lpad(trim(fdb.dist),2,'0') = lpad(trim(br.district),2,'0')
and    lpad(trim(fdb.pol),5,'0') = lpad(trim(br.police),5,'0')
order by fdb.cbrt; --287  n'existe pas dans dmd existe dans br et n'existe pas dans abn
----------------------------------------------
select distinct fdb.*, abn.* 
from   fdbt103 fdb,
       src_abonnees abn
where  not exists (select 1
                   from   reglement_ds rgl,
                          devis_ds dvi,
                          demande_ds dmd
                   where  lpad(trim(dmd.district),2,'0') = lpad(trim(dvi.district),2,'0')
                   and    trim(dmd.localite) = trim(dvi.code_localite_ds)
                   and    dmd.annee = dvi.annee_ds 
                   and    dmd.num = dvi.num_ds
                   and    upper(trim(dvi.etat)) = 'V'
                   and    dvi.annee_ds = rgl.annee_ds
                   and    lpad(trim(dvi.district),2,'0') = lpad(trim(rgl.district),2,'0')
                   and    trim(dvi.code_localite_ds) = trim(rgl.code_localite_ds)
                   and    dvi.annee_ds = rgl.annee_ds
                   and    dvi.num_ds = rgl.num_ds
                   and    dvi.num = rgl.num_devis_ds
                   and    dmd.annuler = 'N'
                   and    ((dmd.etat in (3,4,5) and dmd.annee>2016) or (dmd.etat>5))
                   and    lpad(trim(fdb.dist),2,'0') = lpad(trim(rgl.district),2,'0')
                   and    lpad(trim(fdb.pol),5,'0') = lpad(trim(rgl.police),5,'0')
                   )
and    lpad(trim(fdb.dist),2,'0') = lpad(trim(abn.dist),2,'0')
and    lpad(trim(fdb.pol),5,'0') = lpad(trim(abn.pol),5,'0')
and not exists(select 1
               from   branchement br
               where  lpad(trim(fdb.dist),2,'0') = lpad(trim(br.district),2,'0')
               and    lpad(trim(fdb.pol),5,'0') = lpad(trim(br.police),5,'0')
            )
order by fdb.cbrt; --1  n'existe pas dans dmd et n'existe dans br et existe dans abn
----------------------------------------------
select distinct fdb.*, br.*, abn.* 
from   fdbt103 fdb,
       src_abonnees abn,
       branchement br
where  not exists (select 1
                   from   reglement_ds rgl,
                          devis_ds dvi,
                          demande_ds dmd
                   where  lpad(trim(dmd.district),2,'0') = lpad(trim(dvi.district),2,'0')
                   and    trim(dmd.localite) = trim(dvi.code_localite_ds)
                   and    dmd.annee = dvi.annee_ds 
                   and    dmd.num = dvi.num_ds
                   and    upper(trim(dvi.etat)) = 'V'
                   and    dvi.annee_ds = rgl.annee_ds
                   and    lpad(trim(dvi.district),2,'0') = lpad(trim(rgl.district),2,'0')
                   and    trim(dvi.code_localite_ds) = trim(rgl.code_localite_ds)
                   and    dvi.annee_ds = rgl.annee_ds
                   and    dvi.num_ds = rgl.num_ds
                   and    dvi.num = rgl.num_devis_ds
                   and    dmd.annuler = 'N'
                   and    ((dmd.etat in (3,4,5) and dmd.annee>2016) or (dmd.etat>5))
                   and    lpad(trim(fdb.dist),2,'0') = lpad(trim(rgl.district),2,'0')
                   and    lpad(trim(fdb.pol),5,'0') = lpad(trim(rgl.police),5,'0')
                   )
and    lpad(trim(fdb.dist),2,'0') = lpad(trim(abn.dist),2,'0')
and    lpad(trim(fdb.pol),5,'0') = lpad(trim(abn.pol),5,'0')
and    lpad(trim(fdb.dist),2,'0') = lpad(trim(br.district),2,'0')
and    lpad(trim(fdb.pol),5,'0') = lpad(trim(br.police),5,'0')
order by fdb.cbrt; --3735  n'existe pas dans dmd et existe dans br et existe dans abn
------------------------------------------------
-----------------------------
----------------------------
