load data
infile 'b2.csv'
replace
into   table b2
fields terminated by ';' optionally enclosed by '"' 
( 
CCAR,
CATE,
DIST,
ZPOL,
NDEVIS,
CADM,
CROL,
MDOV,
MATR,
FGEN,
DIVERS,
TRAVDIV,
VENTEAU,
CODOP,
MTOPER,
BL1,
DATPCH,
NET,
MTPA,
Z2,
DPAI,
CPAI,
Z3,
CNAT,
Z4
)