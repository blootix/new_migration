load data
infile 'FBANQT.csv'
replace
into   table RIB_PART
fields terminated by ';' optionally enclosed by '"' 
( 
DIST, 
TOU, 
ORD, 
RIB, 
NOM, 
CPOS
)