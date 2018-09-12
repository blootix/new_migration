prompt Importing table MIWENGAGEMENT...
set feedback off
set define off
insert into MIWENGAGEMENT (SUB_SOURCE, SUB_REF, SUB_NOM, SUB_COMMENT, SUT_ID)
values ('DIST20', 'GROS_CONSOMMATEUR', 'Gros consommateur', 'Gros consommateur', 100033);

insert into MIWENGAGEMENT (SUB_SOURCE, SUB_REF, SUB_NOM, SUB_COMMENT, SUT_ID)
values ('DIST20', 'EAU_NBREAPP', 'Nombre d''appartement', 'NAPT', null);

insert into MIWENGAGEMENT (SUB_SOURCE, SUB_REF, SUB_NOM, SUB_COMMENT, SUT_ID)
values ('DIST20', 'GEN_MONTANTCAPITAL', 'Montant Capital', 'CAPITONAS', null);

insert into MIWENGAGEMENT (SUB_SOURCE, SUB_REF, SUB_NOM, SUB_COMMENT, SUT_ID)
values ('DIST20', 'EAU_CREJ', 'Coefficient de Rejet', null, null);

insert into MIWENGAGEMENT (SUB_SOURCE, SUB_REF, SUB_NOM, SUB_COMMENT, SUT_ID)
values ('DIST20', 'EAU_CPOL', 'Coefficient de Pollution', 'CODPOLL', null);

insert into MIWENGAGEMENT (SUB_SOURCE, SUB_REF, SUB_NOM, SUB_COMMENT, SUT_ID)
values ('DIST20', 'GEN_MONTANTINTERET', 'Montant Interet', 'INTERONAS', null);

insert into MIWENGAGEMENT (SUB_SOURCE, SUB_REF, SUB_NOM, SUB_COMMENT, SUT_ID)
values ('DIST20', 'GEN_NBHAB', 'Nb Habitant', null, null);

insert into MIWENGAGEMENT (SUB_SOURCE, SUB_REF, SUB_NOM, SUB_COMMENT, SUT_ID)
values ('DIST20', 'GEN_NBRECHEANCESRESTANTES', 'Nombre d''echeances restantes', 'ECHTONAS', null);

insert into MIWENGAGEMENT (SUB_SOURCE, SUB_REF, SUB_NOM, SUB_COMMENT, SUT_ID)
values ('DIST20', 'GEN_NBRECHEANCESTOTALES', 'Nombre d''echeances totales', 'ECHTONAS', null);

insert into MIWENGAGEMENT (SUB_SOURCE, SUB_REF, SUB_NOM, SUB_COMMENT, SUT_ID)
values ('DIST20', 'GEN_PLAFCONSO', 'Plafond de consommation', 'CONSMOY', 100003);

insert into MIWENGAGEMENT (SUB_SOURCE, SUB_REF, SUB_NOM, SUB_COMMENT, SUT_ID)
values ('DIST20', 'GEN_RESIDUAL', 'Montant residuel de l''abonnement', 'ARROND', 100030);

insert into MIWENGAGEMENT (SUB_SOURCE, SUB_REF, SUB_NOM, SUB_COMMENT, SUT_ID)
values ('DIST20', 'GEN_VOLUMEEAUNONCONV', 'Volumes des eaux non conventinnels', 'VOLNCON', 100025);

insert into MIWENGAGEMENT (SUB_SOURCE, SUB_REF, SUB_NOM, SUB_COMMENT, SUT_ID)
values ('DIST20', 'TYP_DEP', 'Type de dépassement', null, 100001);

insert into MIWENGAGEMENT (SUB_SOURCE, SUB_REF, SUB_NOM, SUB_COMMENT, SUT_ID)
values ('DIST20', 'GEN_PERIODE', 'Periodicite', 'PERIODE', 100032);

prompt Done.
