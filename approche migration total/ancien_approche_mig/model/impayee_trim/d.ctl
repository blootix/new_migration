load data
infile 'd.csv'
replace
into   table IMPAYEES_PART
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