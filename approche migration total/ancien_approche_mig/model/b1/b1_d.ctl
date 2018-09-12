load data
infile 'b1_d.csv'
replace
into   table b1
fields terminated by ';' optionally enclosed by '"' 
( 
CCAR,
CATE,
DIST,
POLI,
ZONN,
CADM,
CROL,
MDOV,
MATR,
FGEN,
FACA,
EXTE,
CPRF,
PRFI,
RCHA,
ACON,
Z1,
DPCH,
NET,
MTPA,
Z2,
DPAI,
CPAI,
Z3,
DEXE,
CEXE,
Z4,
DFAC,
CFAC,
TOUR,
ORDR,
CNAT,
FONCAGE,
CREDIT
)