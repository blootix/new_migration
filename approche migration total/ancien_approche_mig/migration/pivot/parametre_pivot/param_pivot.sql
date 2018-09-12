----inserer des lignes vide pour parametrage 

insert into miwtpft (MPFT_SOURCE, MPFT_REFPFT, MPFT_LIBELLE, MPFT_PRESTATION, MPFT_DETAIL, MPFT_CALC)
values ('DIST'||&&, 'OFRTEST', 'OFRTEST', 'Migration', null, null);
insert into miworganization (MORGA_SOURCE, MORGA_REFORGA, MORGA_LIBELLE, MORGA_POSTECOMPTABLE, MORGA_NNE, MORGA_CENTRE, MORGA_DOCUMENT, MORGA_LOPFMT, MORGA_BANQUE, MORGA_NUMCOMPTE, MORGA_FLUX, MORGA_NNE_REMBOURS, MORGA_LIGNEOPTIQUE, MORGA_DIVERS, MORGA_RMH, MORGA_BANKFMT, MORGA_ICS, MORGA_BIC)
values ('DIST'||&&, &&, null, null, null, null, null, null, null, null, null, null, null, null, null, null, null, null);
insert into miwtadr (MADR_SOURCE, MADR_REF, MADR_REFRUE, MADR_NRUE, MADR_IRUE, MADR_RUE1, MADR_RUE2, MADR_VILL, MADR_VILC, MADR_CPOS, MADR_BPOS, MADR_PAYS, MADR_BATI, MADR_ESCA, MADR_ETAG, MADR_APPT, MADR_SEQ, MADR_GPSX, MADR_GPSY, MADR_GPSZ, MADR_VILINSEE, MADR_RUEINSEE, LIV, FAC, BRANCH, ADR_ID, DIS_ID, STR_ID, TWN_ID, CITE, RESID, IMPASSE, ANGLE, PLACE, TYPE, ADR_SOURCE)
values ('DIST'||&&, '0', null, null, null, null, null, null, null, null, null, null, null, null, null, null, null, null, null, null, null, null, null, null, null, null, null, null, null, null, null, null, null, null, null, null);
commit;
 
 --verifier les districts [1..9] 'DIST'||&&==>''DIST01' au lieu 'DIST1'