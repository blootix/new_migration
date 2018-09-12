load data
infile 'impgc_d.csv'
replace
into   table IMPAYEES_GC
fields terminated by ';' optionally enclosed by '"' 
( 
  district  ,
  police    ,
  tournee   ,
  ordre     ,
  categorie ,
  adm       ,
  z1        ,
  consfac   ,
  consred   ,
  tarifonas ,
  mtonas    ,
  net       ,
  mtpaye    ,
  z2        ,
  datepaye  ,
  codpaye   ,
  ar1       ,
  codarr    ,
  ar2       ,
  annee     ,
  mois      
)