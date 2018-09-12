load data
infile 'rolg_d.csv'
replace
into   table ROLE_MENS
fields terminated by ';' optionally enclosed by '"' 
( 
  dateexp ,
  distr ,
  police ,
  annee    ,
  mois     ,
  six     ,
  net      ,
  datl    ,
  codr    ,
  ancrep   ,
  nourep   ,
  tcons    ,
  cpreav  ,
  cfer    ,
  cob     ,
  cay     ,
  conas   ,
  tarifs  ,
  nappr    ,
  cbrch   ,
  cctr    ,
  branch   ,
  partco   ,
  extens   ,
  facade   ,
  pfina    ,
  echres   ,
  ecgro    ,
  categ   ,
  tour     ,
  ordr     ,
  coef_q   
)