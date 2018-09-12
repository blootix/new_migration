load data
infile 'adm_as400.csv'
replace
into   table ADM_AS400
fields terminated by ';' optionally enclosed by '"' 
(

COADM  ,	
LIBEL ,
ADRADM ,
DISADM ,
CRUBGT	
)		
