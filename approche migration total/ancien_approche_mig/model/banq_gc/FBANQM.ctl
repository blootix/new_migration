load data
infile 'FBANQM.csv'
replace
into   table RIB_GR
fields terminated by ';' optionally enclosed by '"' 
( 
DIST, 
TOU, 
ORD, 
RIB, 
NOM, 
CPOS
)