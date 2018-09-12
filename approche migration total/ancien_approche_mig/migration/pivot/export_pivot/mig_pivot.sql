-------------------------------------------------------
-- Export file for user MIG_PIVOT_61@MIG12C          --
-- Created by Administrateur on 09/05/2018, 15:25:45 --
-------------------------------------------------------

set define off
spool mig_pivot.log

prompt
prompt Creating table ABONNEES_SAVE
prompt ============================
prompt
create table ABONNEES_SAVE
(
  posit     VARCHAR2(1),
  categ     VARCHAR2(1),
  dist      VARCHAR2(2),
  pol       VARCHAR2(5),
  tou       VARCHAR2(3),
  ord       VARCHAR2(3),
  tier      VARCHAR2(1),
  adm       VARCHAR2(4),
  nomadr    VARCHAR2(90),
  codonas   VARCHAR2(1),
  usag      VARCHAR2(2),
  codctr    VARCHAR2(2),
  codmarq   VARCHAR2(3),
  numctr    VARCHAR2(11),
  codonan   VARCHAR2(1),
  zbl1      VARCHAR2(1),
  codpoll   VARCHAR2(3),
  zbl3      VARCHAR2(3),
  tarif     VARCHAR2(2),
  napt      VARCHAR2(3),
  datinteg  VARCHAR2(6),
  codbrt    VARCHAR2(1),
  echt      VARCHAR2(2),
  echr      VARCHAR2(2),
  brt       VARCHAR2(6),
  fac       VARCHAR2(4),
  ext       VARCHAR2(5),
  prf       VARCHAR2(5),
  aindex    VARCHAR2(6),
  codrlv    VARCHAR2(1),
  releve    VARCHAR2(6),
  prorata   VARCHAR2(4),
  reliqua   VARCHAR2(4),
  codctrt   VARCHAR2(1),
  codresil  VARCHAR2(1),
  fraipreav VARCHAR2(3),
  fraiferm  VARCHAR2(5),
  fraidepo  VARCHAR2(3),
  coddiv    VARCHAR2(1),
  divers    VARCHAR2(3),
  consmoy   VARCHAR2(5),
  codlocali VARCHAR2(2),
  echtonas  VARCHAR2(2),
  echronas  VARCHAR2(2),
  capitonas VARCHAR2(6),
  interonas VARCHAR2(5),
  codpostal VARCHAR2(4),
  codar     VARCHAR2(1),
  arrond    VARCHAR2(3),
  nom       VARCHAR2(100),
  adresse   VARCHAR2(100),
  police    VARCHAR2(5)
)
tablespace MIG61
  pctfree 10
  initrans 1
  maxtrans 255;

prompt
prompt Creating table ABONNES_GC_SAVE
prompt ==============================
prompt
create table ABONNES_GC_SAVE
(
  posit     VARCHAR2(1),
  categ     VARCHAR2(1),
  dist      VARCHAR2(2),
  pol       VARCHAR2(5),
  tou       VARCHAR2(3),
  ord       VARCHAR2(3),
  tier      VARCHAR2(1),
  adm       VARCHAR2(4),
  nom       VARCHAR2(100),
  adr       VARCHAR2(100),
  codonas   VARCHAR2(4),
  usag      VARCHAR2(2),
  codctr    VARCHAR2(2),
  codmarq   VARCHAR2(3),
  numctr    VARCHAR2(11),
  zf1       VARCHAR2(10),
  tarif     VARCHAR2(2),
  napt      VARCHAR2(3),
  datinteg  VARCHAR2(6),
  codbrt    VARCHAR2(1),
  echt      VARCHAR2(2),
  echr      VARCHAR2(2),
  brt       VARCHAR2(6),
  fac       VARCHAR2(4) not null,
  ext       VARCHAR2(5),
  prf       VARCHAR2(4),
  aindex    VARCHAR2(6),
  codrlv    VARCHAR2(1),
  releve    VARCHAR2(6),
  prorata   VARCHAR2(4),
  reliqua   VARCHAR2(4),
  codctrt   VARCHAR2(1),
  codresil  VARCHAR2(1),
  fraipreav VARCHAR2(3),
  fraiferm  VARCHAR2(5),
  fraidepo  VARCHAR2(3),
  coddiv    VARCHAR2(1),
  divers    VARCHAR2(3),
  consmoy   VARCHAR2(5),
  codlocali VARCHAR2(2),
  echtonas  VARCHAR2(2),
  echronas  VARCHAR2(2),
  capitonas VARCHAR2(6),
  interonas VARCHAR2(5),
  codpostal VARCHAR2(4),
  ar1       VARCHAR2(4),
  ar2       VARCHAR2(4),
  codonan   VARCHAR2(4)
)
tablespace MIG61
  pctfree 10
  initrans 1
  maxtrans 255;

prompt
prompt Creating table BRANCHEMENT_RES
prompt ==============================
prompt
create table BRANCHEMENT_RES
(
  periode  VARCHAR2(20),
  ref_pdl  VARCHAR2(20),
  etat     VARCHAR2(20),
  date_res VARCHAR2(20),
  dist     VARCHAR2(20)
)
tablespace MIG61
  pctfree 10
  initrans 1
  maxtrans 255
  storage
  (
    initial 64K
    next 1M
    minextents 1
    maxextents unlimited
  );
create index INDEX_RES1 on BRANCHEMENT_RES (ETAT, DIST)
  tablespace USERS
  pctfree 10
  initrans 2
  maxtrans 255
  storage
  (
    initial 64K
    next 1M
    minextents 1
    maxextents unlimited
  );
create index INDEX_RES2 on BRANCHEMENT_RES (SUBSTR(REF_PDL,1,3), SUBSTR(PERIODE,5,1), LENGTH(PERIODE), DIST)
  tablespace USERS
  pctfree 10
  initrans 2
  maxtrans 255
  storage
  (
    initial 64K
    next 1M
    minextents 1
    maxextents unlimited
  );
create index INDEX_RES3 on BRANCHEMENT_RES (DIST||REF_PDL, TO_DATE(DATE_RES,'dd/mm/yyyy'))
  tablespace USERS
  pctfree 10
  initrans 2
  maxtrans 255
  storage
  (
    initial 64K
    next 1M
    minextents 1
    maxextents unlimited
  );
create index INDEX_RES4 on BRANCHEMENT_RES (DIST||REF_PDL)
  tablespace USERS
  pctfree 10
  initrans 2
  maxtrans 255
  storage
  (
    initial 64K
    next 1M
    minextents 1
    maxextents unlimited
  );
create index INDEX_RES5 on BRANCHEMENT_RES (DIST, SUBSTR(REF_PDL,1,3), SUBSTR(PERIODE,5,1), LENGTH(PERIODE))
  tablespace USERS
  pctfree 10
  initrans 2
  maxtrans 255
  storage
  (
    initial 64K
    next 1M
    minextents 1
    maxextents unlimited
  );
create index INDEX_RES6 on BRANCHEMENT_RES (REF_PDL, ETAT, LENGTH(PERIODE), DIST)
  tablespace USERS
  pctfree 10
  initrans 2
  maxtrans 255
  storage
  (
    initial 64K
    next 1M
    minextents 1
    maxextents unlimited
  );
create index INDEX_RES7 on BRANCHEMENT_RES (ETAT, REF_PDL, LENGTH(PERIODE))
  tablespace USERS
  pctfree 10
  initrans 2
  maxtrans 255
  storage
  (
    initial 64K
    next 1M
    minextents 1
    maxextents unlimited
  );
create index INDEX_RES8 on BRANCHEMENT_RES (REF_PDL, TRIM(ETAT), LENGTH(PERIODE))
  tablespace USERS
  pctfree 10
  initrans 2
  maxtrans 255
  storage
  (
    initial 64K
    next 1M
    minextents 1
    maxextents unlimited
  );
create index INDEX_RES9 on BRANCHEMENT_RES (DIST, SUBSTR(REF_PDL,1,3), REF_PDL)
  tablespace USERS
  pctfree 10
  initrans 2
  maxtrans 255
  storage
  (
    initial 64K
    next 1M
    minextents 1
    maxextents unlimited
  );

prompt
prompt Creating table BRANCHEMENT_RES_MAX
prompt ==================================
prompt
create table BRANCHEMENT_RES_MAX
(
  periode  VARCHAR2(100),
  ref_pdl  VARCHAR2(100),
  etat     VARCHAR2(100),
  date_res VARCHAR2(100),
  dist     VARCHAR2(100)
)
tablespace MIG61
  pctfree 10
  initrans 1
  maxtrans 255
  storage
  (
    initial 64K
    next 1M
    minextents 1
    maxextents unlimited
  );
create index INDEX_ETAT_BRA_ on BRANCHEMENT_RES_MAX (ETAT)
  tablespace USERS
  pctfree 10
  initrans 2
  maxtrans 255
  storage
  (
    initial 64K
    next 1M
    minextents 1
    maxextents unlimited
  );
create index INDEX_PERIODE_BRA_ on BRANCHEMENT_RES_MAX (PERIODE)
  tablespace USERS
  pctfree 10
  initrans 2
  maxtrans 255
  storage
  (
    initial 64K
    next 1M
    minextents 1
    maxextents unlimited
  );
create index INDEX_REF_BRA_DIT on BRANCHEMENT_RES_MAX (DIST)
  tablespace USERS
  pctfree 10
  initrans 2
  maxtrans 255
  storage
  (
    initial 64K
    next 1M
    minextents 1
    maxextents unlimited
  );
create index INDEX_REF_BRA_RESI on BRANCHEMENT_RES_MAX (REF_PDL)
  tablespace USERS
  pctfree 10
  initrans 2
  maxtrans 255
  storage
  (
    initial 64K
    next 1M
    minextents 1
    maxextents unlimited
  );
create index INDEX_REF_BRA_RESI_DIT on BRANCHEMENT_RES_MAX (DIST, REF_PDL)
  tablespace USERS
  pctfree 10
  initrans 2
  maxtrans 255
  storage
  (
    initial 64K
    next 1M
    minextents 1
    maxextents unlimited
  );

prompt
prompt Creating table BRANCHEMENT_RES_MAX_SAVE
prompt =======================================
prompt
create table BRANCHEMENT_RES_MAX_SAVE
(
  periode  VARCHAR2(100),
  ref_pdl  VARCHAR2(100),
  etat     VARCHAR2(100),
  date_res VARCHAR2(100),
  dist     VARCHAR2(100)
)
tablespace MIG61
  pctfree 10
  initrans 1
  maxtrans 255;

prompt
prompt Creating table BRANCHEMENT_RES_SAVE
prompt ===================================
prompt
create table BRANCHEMENT_RES_SAVE
(
  periode  VARCHAR2(20),
  ref_pdl  VARCHAR2(20),
  etat     VARCHAR2(20),
  date_res VARCHAR2(20),
  dist     VARCHAR2(20)
)
tablespace MIG61
  pctfree 10
  initrans 1
  maxtrans 255;

prompt
prompt Creating table GEST_COMPT_ANOMALIE
prompt ==================================
prompt
create table GEST_COMPT_ANOMALIE
(
  ref_pdl   VARCHAR2(20),
  nbr_ligne NUMBER,
  ligne     NUMBER
)
tablespace MIG61
  pctfree 10
  initrans 1
  maxtrans 255;

prompt
prompt Creating table MIWCTRTYPE
prompt =========================
prompt
create table MIWCTRTYPE
(
  ctrtype_source  VARCHAR2(100) not null,
  ctrtype_ref     VARCHAR2(100) not null,
  ctrtype_nom     VARCHAR2(200),
  ctr_debut       DATE,
  ctr_fin         DATE,
  ctr_commentaire VARCHAR2(4000),
  ctrtype_refgrf  VARCHAR2(100),
  ctr_secteur_1   VARCHAR2(100),
  ctrtype_reforga VARCHAR2(100),
  ctrtype_refimp  VARCHAR2(100)
)
tablespace MIG61
  pctfree 10
  initrans 1
  maxtrans 255;
comment on table MIWCTRTYPE
  is 'Table de contrat type';
comment on column MIWCTRTYPE.ctrtype_source
  is 'Code source/origine de la donnée';
comment on column MIWCTRTYPE.ctrtype_ref
  is 'code du contrat type';
comment on column MIWCTRTYPE.ctrtype_nom
  is 'libelle du contrat type';
comment on column MIWCTRTYPE.ctr_debut
  is 'date de debut du contrat type';
comment on column MIWCTRTYPE.ctr_fin
  is 'date de fin du contrat type';
comment on column MIWCTRTYPE.ctr_commentaire
  is 'commentaire lie au contrat type';
comment on column MIWCTRTYPE.ctrtype_refgrf
  is 'identifient du group de facturation par defaut du contrat type';
alter table MIWCTRTYPE
  add constraint PK_MIWCTRTYPE primary key (CTRTYPE_SOURCE, CTRTYPE_REF)
  using index 
  tablespace USERS
  pctfree 10
  initrans 2
  maxtrans 255;

prompt
prompt Creating table MIWTBRA
prompt ======================
prompt
create table MIWTBRA
(
  mbra_source       VARCHAR2(100) not null,
  mbra_ref          VARCHAR2(100) not null,
  mbra_refadr       VARCHAR2(100) not null,
  mbra_type         VARCHAR2(1),
  mbra_etat         VARCHAR2(1),
  mbra_detat        DATE,
  mbra_refvocreseau VARCHAR2(100),
  mbra_step         VARCHAR2(100),
  mbra_chateau      VARCHAR2(100),
  voc_matbra        VARCHAR2(100),
  voc_diabra        VARCHAR2(100),
  voc_lgbra         VARCHAR2(100),
  mbra_etatass      VARCHAR2(100),
  mbra_dateass      DATE,
  mbra_vanneindiv   VARCHAR2(100),
  mbra_vanneinnac   VARCHAR2(100),
  commentaire       VARCHAR2(4000),
  cnn_id            NUMBER,
  fld_id            NUMBER,
  adr_id            NUMBER,
  mbra_datcreation  DATE
)
tablespace MIG61
  pctfree 10
  initrans 1
  maxtrans 255
  storage
  (
    initial 64K
    next 1M
    minextents 1
    maxextents unlimited
  );
comment on table MIWTBRA
  is 'Les branchements';
comment on column MIWTBRA.mbra_source
  is 'Identifiant de la source de données [OBL]';
comment on column MIWTBRA.mbra_ref
  is 'Référence du branchement dans le SI source (le couple source/référence doit être unique) [OBL]';
comment on column MIWTBRA.mbra_refadr
  is 'Référence de l''adresse dans le SI source [OBL]';
comment on column MIWTBRA.mbra_type
  is 'Type du branchement (U=unique;S=série;P=parallèle;C=composé)';
comment on column MIWTBRA.mbra_etat
  is 'Etat du branchement : 0=fermé, 1=Ouvert, 2=Supprimé';
comment on column MIWTBRA.mbra_detat
  is 'Date du dernier changement d''état';
comment on column MIWTBRA.mbra_refvocreseau
  is 'Référence du réseau auquel appartient le branchement (libellé ou code source dans la table des correspondances)';
comment on column MIWTBRA.voc_matbra
  is 'Composition physique';
comment on column MIWTBRA.voc_diabra
  is 'diametre';
comment on column MIWTBRA.voc_lgbra
  is 'longuer';
comment on column MIWTBRA.mbra_etatass
  is 'Date Etat raccordement Ass';
comment on column MIWTBRA.mbra_vanneindiv
  is 'Vanne Individuelle';
comment on column MIWTBRA.mbra_vanneinnac
  is 'Vanne Innacessible';
alter table MIWTBRA
  add constraint PK_MIWTBRA primary key (MBRA_SOURCE, MBRA_REF)
  using index 
  tablespace USERS
  pctfree 10
  initrans 2
  maxtrans 255
  storage
  (
    initial 64K
    next 1M
    minextents 1
    maxextents unlimited
  );

prompt
prompt Creating table MIWTPDL
prompt ======================
prompt
create table MIWTPDL
(
  pdl_source      VARCHAR2(100) not null,
  pdl_ref         VARCHAR2(100) not null,
  pdl_refbra      VARCHAR2(100),
  pdl_refadr      VARCHAR2(100) not null,
  pdl_reftou      VARCHAR2(100),
  pdl_refpde_pere VARCHAR2(100),
  pdl_type        VARCHAR2(1),
  pdl_touordre    NUMBER(10),
  pdl_refsite     VARCHAR2(100),
  voc_diffread    VARCHAR2(100),
  voc_access      VARCHAR2(100),
  voc_readinfo1   VARCHAR2(100),
  voc_readinfo2   VARCHAR2(100),
  voc_readinfo3   VARCHAR2(100),
  pdl_reffld      VARCHAR2(100),
  pdl_secteur_1   VARCHAR2(32),
  pdl_secteur_2   VARCHAR2(32),
  pdl_secteur_3   VARCHAR2(32),
  pdl_secteur_4   VARCHAR2(32),
  pdl_secteur_5   VARCHAR2(32),
  pdl_etat        VARCHAR2(1),
  pdl_detat       DATE,
  voc_methdep     VARCHAR2(100),
  pdl_comment     VARCHAR2(4000),
  pdl_refper_p    NUMBER(10),
  pdl_cbllenght   NUMBER(7,3),
  pdl_cblsection  NUMBER(6,3),
  voc_connat      VARCHAR2(100),
  voc_pmaxcon     VARCHAR2(100),
  pdl_riser       NUMBER(1),
  voc_constatus   VARCHAR2(10),
  spt_id          NUMBER,
  voc_premisetp   VARCHAR2(100),
  pre_id          NUMBER,
  adr_id          NUMBER,
  fld_id          NUMBER,
  rob_arret_av    VARCHAR2(1),
  rob_arret_ap    VARCHAR2(1),
  pdl_dfermeture  DATE,
  voc_frqfact     VARCHAR2(100) not null
)
tablespace MIG61
  pctfree 10
  initrans 1
  maxtrans 255
  storage
  (
    initial 64K
    next 1M
    minextents 1
    maxextents unlimited
  );
comment on table MIWTPDL
  is 'Les points de comptage';
comment on column MIWTPDL.pdl_source
  is 'Identifiant de la source de données [OBL]';
comment on column MIWTPDL.pdl_ref
  is 'Référence du point de comptage dans le SI source (le couple source/référence doit être unique) [OBL]';
comment on column MIWTPDL.pdl_refbra
  is 'Référence du branchement dans le SI source [OBL]';
comment on column MIWTPDL.pdl_refadr
  is 'Référence de l''adresse dans le SI source [OBL]';
comment on column MIWTPDL.pdl_reftou
  is 'Référence de la tournée dans la source du client';
comment on column MIWTPDL.pdl_touordre
  is 'Ordre du point de comptage dans la tournée';
comment on column MIWTPDL.pdl_refsite
  is 'Référence de la site dans le SI source ';
comment on column MIWTPDL.voc_diffread
  is 'Liste des Vocabulaires état de relève (Difficulté de relève, plaque de fonte, Egout...) ..difficulté releve';
comment on column MIWTPDL.voc_access
  is 'Liste des vocabulaire Accessibilité (Jardin, Limite propriété ...) ..accessibilite compteur ';
comment on column MIWTPDL.voc_readinfo1
  is 'Liste des Vocabulaires Inforamation 1 sur relève ...Emplacement compteur';
comment on column MIWTPDL.voc_readinfo2
  is 'Liste des Vocabulaires Inforamation 2 sur relève';
comment on column MIWTPDL.voc_readinfo3
  is 'Liste des Vocabulaires Inforamation 3 sur relève';
comment on column MIWTPDL.pdl_secteur_1
  is 'Secteur 1 administratif';
comment on column MIWTPDL.pdl_secteur_2
  is 'Secteur 2 intervention de terrain';
comment on column MIWTPDL.pdl_secteur_3
  is 'Secteur 3 ';
comment on column MIWTPDL.pdl_secteur_4
  is 'Secteur 4 ';
comment on column MIWTPDL.pdl_secteur_5
  is 'Secteur 5 ';
comment on column MIWTPDL.pdl_etat
  is 'Etat du point de comptage : 0=fermé, 1=Ouvert, 2=Supprimé';
comment on column MIWTPDL.pdl_detat
  is 'Date du dernier changement d''état';
comment on column MIWTPDL.pdl_refper_p
  is 'Ref Client Proprietaire';
comment on column MIWTPDL.pdl_cbllenght
  is 'Longueur du cable de raccordement au réseau';
comment on column MIWTPDL.pdl_cblsection
  is 'Section du cable de raccordement au réseau';
comment on column MIWTPDL.voc_connat
  is 'Nature de branchement électrique du PDL';
comment on column MIWTPDL.voc_pmaxcon
  is 'Puissance maximum supportée par le cable de raccordement ';
comment on column MIWTPDL.pdl_riser
  is '1=présence d''une colonne montante, 0=pas de colonne     ';
create index INDEX_PDL_REFPDE_PERE on MIWTPDL (PDL_REFPDE_PERE)
  tablespace USERS
  pctfree 10
  initrans 2
  maxtrans 255
  storage
  (
    initial 64K
    next 1M
    minextents 1
    maxextents unlimited
  );
alter table MIWTPDL
  add constraint PK_MIWTPDL primary key (PDL_SOURCE, PDL_REF)
  using index 
  tablespace USERS
  pctfree 10
  initrans 2
  maxtrans 255
  storage
  (
    initial 64K
    next 1M
    minextents 1
    maxextents unlimited
  );
alter table MIWTPDL
  add constraint FK_MIWTPDL_PDL_REFBRA foreign key (PDL_SOURCE, PDL_REFBRA)
  references MIWTBRA (MBRA_SOURCE, MBRA_REF);

prompt
prompt Creating table MIWTPFT
prompt ======================
prompt
create table MIWTPFT
(
  mpft_source     VARCHAR2(100) not null,
  mpft_refpft     VARCHAR2(100) not null,
  mpft_libelle    VARCHAR2(100),
  mpft_prestation VARCHAR2(100) default 'Migration',
  mpft_detail     NUMBER,
  mpft_calc       VARCHAR2(100)
)
tablespace MIG61
  pctfree 10
  initrans 1
  maxtrans 255
  storage
  (
    initial 64K
    next 1M
    minextents 1
    maxextents unlimited
  );
comment on table MIWTPFT
  is 'Table Pivot Profil type facturation';
comment on column MIWTPFT.mpft_source
  is 'Code source/origine de profil type facturation [OBL]';
comment on column MIWTPFT.mpft_refpft
  is 'Code de  profil type facturation';
comment on column MIWTPFT.mpft_libelle
  is 'libelle de profil type facturation';
comment on column MIWTPFT.mpft_prestation
  is 'Prestation de profil type facturation ';
comment on column MIWTPFT.mpft_calc
  is 'Code du calendrier';
alter table MIWTPFT
  add constraint PK_MIWTPFT primary key (MPFT_SOURCE, MPFT_REFPFT)
  using index 
  tablespace USERS
  pctfree 10
  initrans 2
  maxtrans 255
  storage
  (
    initial 64K
    next 1M
    minextents 1
    maxextents unlimited
  );

prompt
prompt Creating table MIWABN
prompt =====================
prompt
create table MIWABN
(
  abn_source         VARCHAR2(100) not null,
  abn_ref            VARCHAR2(100) not null,
  abn_refsite        VARCHAR2(100),
  abn_refpdl         VARCHAR2(100) not null,
  abn_refgrf         VARCHAR2(100),
  abn_refper_a       VARCHAR2(100),
  abn_dt_deb         DATE not null,
  abn_dt_fin         DATE,
  abn_ctrtype_ref    VARCHAR2(100),
  abn_modefact       NUMBER(1),
  abn_geler          NUMBER(1),
  abn_dtgeler        DATE,
  abn_exotva         NUMBER(1) default 0,
  voc_frozen         VARCHAR2(100),
  voc_typdurbill     VARCHAR2(100),
  voc_cutagree       VARCHAR2(100),
  voc_typsag         VARCHAR2(100),
  voc_usgsag         VARCHAR2(100),
  abn_refrel         VARCHAR2(100),
  abn_refpft         VARCHAR2(100),
  abn_norecovery     NUMBER(1),
  abn_dtfin_recovery DATE,
  abn_delaip         NUMBER(2),
  abn_commentaire    VARCHAR2(4000),
  abn_solde          NUMBER(17,10),
  migabn_cr          NUMBER(10,3),
  migabn_crdtfin     DATE,
  abn_refpft_detail  VARCHAR2(100),
  voc_nbbill         VARCHAR2(100),
  sag_id             NUMBER,
  ctt_id             NUMBER,
  pre_id             NUMBER,
  spt_id             NUMBER,
  ofr_code           VARCHAR2(20),
  ofr_code_second    VARCHAR2(20),
  ofr_id             NUMBER,
  ofr_detail_id      NUMBER,
  abn_datcreation    DATE
)
tablespace MIG61
  pctfree 10
  initrans 1
  maxtrans 255
  storage
  (
    initial 64K
    next 1M
    minextents 1
    maxextents unlimited
  );
comment on table MIWABN
  is 'abonnements et propriétaires successifs de l''''installation';
comment on column MIWABN.abn_ref
  is 'identifiant de l''abonnement : N° fourni par l''utilisateur (clé primaire)';
comment on column MIWABN.abn_refsite
  is 'Référence de l''installation (obligatoire)';
comment on column MIWABN.abn_refpdl
  is 'Référence du point de comptage dans le SI source';
comment on column MIWABN.abn_refgrf
  is 'Voir description du groupe de facturation';
comment on column MIWABN.abn_dt_deb
  is 'Date de début d''abonnement (obligatoire)';
comment on column MIWABN.abn_dt_fin
  is 'Date de fin d''abonnement';
comment on column MIWABN.abn_ctrtype_ref
  is 'Référence du contrat d''abonnement (police) (obligatoire)';
comment on column MIWABN.abn_modefact
  is '0=facturation par role, 1=facturation par planning';
comment on column MIWABN.abn_geler
  is '1:gel de contrat en facturation,0 Sinon ';
comment on column MIWABN.abn_dtgeler
  is 'date de gel de facturation ';
comment on column MIWABN.abn_exotva
  is ' 1: Exoneré de TVA,0 sinon  ';
comment on column MIWABN.voc_frozen
  is 'motif du gel [FROZEN] ';
comment on column MIWABN.voc_typdurbill
  is '1: Exoneré de TVA,0 sinon';
comment on column MIWABN.voc_cutagree
  is ' drois de coupure [CUTAGREE] ';
comment on column MIWABN.voc_typsag
  is 'type de service (professionnel, domestique) [TYPSAG] ';
comment on column MIWABN.voc_usgsag
  is 'Usage Res Principal, Local, Res. Secondaire [USGCAG] ';
comment on column MIWABN.abn_refrel
  is 'Référence du chaine de relance  dans le SI source';
comment on column MIWABN.abn_refpft
  is 'Référence du Profil type dans le SI source';
comment on column MIWABN.abn_norecovery
  is 'exonerer de relance (0=non, 1=oui)';
comment on column MIWABN.abn_delaip
  is 'Delai de paiement';
comment on column MIWABN.abn_commentaire
  is 'Commentaire libre PDS';
comment on column MIWABN.abn_solde
  is 'Solde de l''abonnement';
comment on column MIWABN.migabn_cr
  is 'consommation de référence par défaut';
comment on column MIWABN.migabn_crdtfin
  is 'fin de validité de la consommation de référence par défaut';
comment on column MIWABN.abn_refpft_detail
  is 'Référence du Profil type  Detaildans le SI source';
comment on column MIWABN.voc_nbbill
  is 'nombre d''exemplaires [NBBILL]';
create index IDX_MIWABN on MIWABN (SUBSTR(ABN_REFSITE,1,13))
  tablespace USERS
  pctfree 10
  initrans 2
  maxtrans 255
  storage
  (
    initial 64K
    next 1M
    minextents 1
    maxextents unlimited
  );
create index INDX_ABN_SAG on MIWABN (SAG_ID, ABN_SOURCE, ABN_REF)
  tablespace USERS
  pctfree 10
  initrans 2
  maxtrans 255
  storage
  (
    initial 64K
    next 1M
    minextents 1
    maxextents unlimited
  );
alter table MIWABN
  add constraint PK_MIWABN primary key (ABN_SOURCE, ABN_REF)
  using index 
  tablespace USERS
  pctfree 10
  initrans 2
  maxtrans 255
  storage
  (
    initial 64K
    next 1M
    minextents 1
    maxextents unlimited
  );
alter table MIWABN
  add constraint UK_MIWABN_ABN_REFPDL unique (ABN_SOURCE, ABN_REFPDL)
  using index 
  tablespace USERS
  pctfree 10
  initrans 2
  maxtrans 255
  storage
  (
    initial 64K
    next 1M
    minextents 1
    maxextents unlimited
  );
alter table MIWABN
  add constraint FK_MIWABN_ABN_CTRTYPE_REF foreign key (ABN_SOURCE, ABN_CTRTYPE_REF)
  references MIWCTRTYPE (CTRTYPE_SOURCE, CTRTYPE_REF);
alter table MIWABN
  add constraint FK_MIWABN_ABN_REFPDL foreign key (ABN_SOURCE, ABN_REFPDL)
  references MIWTPDL (PDL_SOURCE, PDL_REF);
alter table MIWABN
  add constraint FK_MIWABN_ABN_REFPFT foreign key (ABN_SOURCE, ABN_REFPFT)
  references MIWTPFT (MPFT_SOURCE, MPFT_REFPFT);

prompt
prompt Creating table MIWAGENT
prompt =======================
prompt
create table MIWAGENT
(
  age_source    VARCHAR2(100) not null,
  age_ref       VARCHAR2(100) not null,
  age_nom       VARCHAR2(4000) not null,
  age_prenom    VARCHAR2(4000),
  age_mdp       VARCHAR2(100),
  age_profil    VARCHAR2(100),
  age_e_mail    VARCHAR2(100),
  age_secteur_1 VARCHAR2(32),
  age_secteur_2 VARCHAR2(32),
  age_secteur_3 VARCHAR2(32),
  age_secteur_4 VARCHAR2(32),
  age_secteur_5 VARCHAR2(32),
  age_secteur   VARCHAR2(100)
)
tablespace MIG61
  pctfree 10
  initrans 1
  maxtrans 255;
comment on table MIWAGENT
  is 'Table des agents';
comment on column MIWAGENT.age_source
  is 'Identifiant agent';
comment on column MIWAGENT.age_ref
  is 'Nom agent';
comment on column MIWAGENT.age_nom
  is 'Nom agent';
comment on column MIWAGENT.age_prenom
  is 'Prenom agent';
comment on column MIWAGENT.age_mdp
  is 'Mot de passe agent';
comment on column MIWAGENT.age_profil
  is 'Profil/Groupe Agent';
comment on column MIWAGENT.age_e_mail
  is 'EMail Agent';
comment on column MIWAGENT.age_secteur_1
  is 'Secteur 1   type de secteur INTERVENTION';
comment on column MIWAGENT.age_secteur_2
  is 'Secteur 2   type de secteur INTERVENTION';
comment on column MIWAGENT.age_secteur_3
  is 'Secteur 3   type de secteur INTERVENTION';
comment on column MIWAGENT.age_secteur_4
  is 'Secteur 4   type de secteur INTERVENTION';
comment on column MIWAGENT.age_secteur_5
  is 'Secteur 5   type de secteur INTERVENTION';
alter table MIWAGENT
  add constraint PK_MIWAGENT primary key (AGE_SOURCE, AGE_REF)
  using index 
  tablespace USERS
  pctfree 10
  initrans 2
  maxtrans 255;

prompt
prompt Creating table MIGTCONTACT
prompt ==========================
prompt
create table MIGTCONTACT
(
  mtcontact_source          VARCHAR2(100) not null,
  mtcontact_refcontact      VARCHAR2(100) not null,
  mtcontact_ref_abnt        VARCHAR2(100) not null,
  mtcontact_libelle         VARCHAR2(100),
  mtcontact_ddeb            DATE not null,
  mtcontact_dfin            DATE,
  mtcontact_code_classement VARCHAR2(100),
  mtcontact_lib_classement  VARCHAR2(100),
  voc_origin                VARCHAR2(100),
  mtcontact_commentaire     VARCHAR2(4000),
  mtcontact_agesource       VARCHAR2(100),
  mtcontact_ageref          VARCHAR2(100)
)
tablespace MIG61
  pctfree 10
  initrans 1
  maxtrans 255;
comment on table MIGTCONTACT
  is 'Table historique contact';
comment on column MIGTCONTACT.mtcontact_source
  is 'Code source/origine de contacte contrat type [OBL]';
comment on column MIGTCONTACT.mtcontact_refcontact
  is 'Référence du contact dans le SI source  ';
comment on column MIGTCONTACT.mtcontact_ref_abnt
  is 'Référence du contact dans le SI source  ';
comment on column MIGTCONTACT.mtcontact_libelle
  is 'MTCONTACT_LIBELLE';
comment on column MIGTCONTACT.mtcontact_ddeb
  is 'Date de debut du contact historisé [OBL] ';
comment on column MIGTCONTACT.mtcontact_dfin
  is 'date de fin du contact historisé';
comment on column MIGTCONTACT.mtcontact_code_classement
  is 'Code classement ';
comment on column MIGTCONTACT.mtcontact_agesource
  is 'Identifiant agent ayant pris le contact';
comment on column MIGTCONTACT.mtcontact_ageref
  is 'Nom agent ayant pris le contact';
alter table MIGTCONTACT
  add constraint PK_MIGTCONTACT primary key (MTCONTACT_REFCONTACT)
  using index 
  tablespace USERS
  pctfree 10
  initrans 2
  maxtrans 255;
alter table MIGTCONTACT
  add constraint FK_MIGTCONTACT_REF_AGE foreign key (MTCONTACT_AGESOURCE, MTCONTACT_AGEREF)
  references MIWAGENT (AGE_SOURCE, AGE_REF);
alter table MIGTCONTACT
  add constraint FK_MTCONTACT_REF_ABNT foreign key (MTCONTACT_SOURCE, MTCONTACT_REF_ABNT)
  references MIWABN (ABN_SOURCE, ABN_REF);

prompt
prompt Creating table MIWABNGROUPE
prompt ===========================
prompt
create table MIWABNGROUPE
(
  bun_source VARCHAR2(100) not null,
  bun_ref    VARCHAR2(100) not null,
  bun_nom    VARCHAR2(4000) not null,
  bun_refabn NUMBER(10) not null,
  bun_pere   NUMBER(1) not null,
  voc_buntyp VARCHAR2(100) not null
)
tablespace MIG61
  pctfree 10
  initrans 1
  maxtrans 255;
comment on table MIWABNGROUPE
  is 'Table des groupements bundle';
comment on column MIWABNGROUPE.bun_ref
  is 'Identifiant du groupement';
comment on column MIWABNGROUPE.bun_nom
  is 'Nom du groupement';
comment on column MIWABNGROUPE.bun_refabn
  is 'Ref Abn';
comment on column MIWABNGROUPE.bun_pere
  is '1: pere du groupement, 0: fils';
comment on column MIWABNGROUPE.voc_buntyp
  is 'E: groupement edition, C: calcul';

prompt
prompt Creating table MIWABN_SAVE
prompt ==========================
prompt
create table MIWABN_SAVE
(
  abn_source         VARCHAR2(100) not null,
  abn_ref            VARCHAR2(100) not null,
  abn_refsite        VARCHAR2(100),
  abn_refpdl         VARCHAR2(100) not null,
  abn_refgrf         VARCHAR2(100),
  abn_refper_a       VARCHAR2(100),
  abn_dt_deb         DATE not null,
  abn_dt_fin         DATE,
  abn_ctrtype_ref    VARCHAR2(100),
  abn_modefact       NUMBER(1),
  abn_geler          NUMBER(1),
  abn_dtgeler        DATE,
  abn_exotva         NUMBER(1),
  voc_frozen         VARCHAR2(100),
  voc_typdurbill     VARCHAR2(100),
  voc_cutagree       VARCHAR2(100),
  voc_typsag         VARCHAR2(100),
  voc_usgsag         VARCHAR2(100),
  abn_refrel         VARCHAR2(100),
  abn_refpft         VARCHAR2(100),
  abn_norecovery     NUMBER(1),
  abn_dtfin_recovery DATE,
  abn_delaip         NUMBER(2),
  abn_commentaire    VARCHAR2(4000),
  abn_solde          NUMBER(17,10),
  migabn_cr          NUMBER(10,3),
  migabn_crdtfin     DATE,
  abn_refpft_detail  VARCHAR2(100),
  voc_nbbill         VARCHAR2(100),
  sag_id             NUMBER,
  ctt_id             NUMBER,
  pre_id             NUMBER,
  spt_id             NUMBER,
  ofr_code           VARCHAR2(20),
  ofr_code_second    VARCHAR2(20),
  ofr_id             NUMBER,
  ofr_detail_id      NUMBER,
  abn_datcreation    DATE
)
tablespace MIG61
  pctfree 10
  initrans 1
  maxtrans 255;

prompt
prompt Creating table MIWTART
prompt ======================
prompt
create table MIWTART
(
  mart_source   VARCHAR2(100) not null,
  mart_refart   VARCHAR2(100) not null,
  mart_nom      VARCHAR2(100) not null,
  voc_unit      VARCHAR2(100),
  voc_calctp    VARCHAR2(100),
  voc_calcstp   VARCHAR2(100),
  mart_fam1     VARCHAR2(100),
  mart_fam2     VARCHAR2(100),
  mart_fam3     VARCHAR2(100),
  mart_tva      VARCHAR2(100),
  mart_ttva     NUMBER(10,2),
  mart_voc_code VARCHAR2(100)
)
tablespace MIG61
  pctfree 10
  initrans 1
  maxtrans 255;
comment on table MIWTART
  is ' Table Pivot Article';
comment on column MIWTART.mart_source
  is 'Code source/origine de l''article [OBL]';
comment on column MIWTART.mart_refart
  is 'Identifiant unique de l''artilce [OBL]';
comment on column MIWTART.mart_nom
  is 'Nom de l''article';
comment on column MIWTART.voc_unit
  is 'Unite ';
comment on column MIWTART.voc_calctp
  is 'type de calcul [CALCTP](conso,releve,prime fix...)';
comment on column MIWTART.voc_calcstp
  is 'Sous type de calcul [CALCSTP](conso,releve,prime fix...)';
comment on column MIWTART.mart_fam1
  is 'Famille 1 de l''article';
comment on column MIWTART.mart_fam2
  is 'Famille 2 de l''article (sous famille/Produit)';
comment on column MIWTART.mart_fam3
  is 'Famille 3 de l''article (sous famille/Produit)';
alter table MIWTART
  add constraint PK_MIWTART primary key (MART_SOURCE, MART_REFART)
  using index 
  tablespace USERS
  pctfree 10
  initrans 2
  maxtrans 255;

prompt
prompt Creating table MIWARTTPFT
prompt =========================
prompt
create table MIWARTTPFT
(
  arttpft_source VARCHAR2(100) not null,
  arttpft_refpft VARCHAR2(100) not null,
  arttpft_refart VARCHAR2(100) not null,
  arttpft_cadran VARCHAR2(100)
)
tablespace MIG61
  pctfree 10
  initrans 1
  maxtrans 255;
comment on table MIWARTTPFT
  is 'Table Pivot  articles/rubriques profil type ';
comment on column MIWARTTPFT.arttpft_source
  is 'Code source/origine de PFT [OBL]';
comment on column MIWARTTPFT.arttpft_refpft
  is 'Référence de PFT dans le SI source  [OBL]';
comment on column MIWARTTPFT.arttpft_refart
  is 'Référence de l''''article  dans le SI source [OBL]';
comment on column MIWARTTPFT.arttpft_cadran
  is 'Code Cadran  par defaut ''EAU''';
alter table MIWARTTPFT
  add constraint FK_MIWARTTPFT_REFART foreign key (ARTTPFT_SOURCE, ARTTPFT_REFART)
  references MIWTART (MART_SOURCE, MART_REFART);
alter table MIWARTTPFT
  add constraint FK_MIWARTTPFT_TPFT_REFPFT foreign key (ARTTPFT_SOURCE, ARTTPFT_REFPFT)
  references MIWTPFT (MPFT_SOURCE, MPFT_REFPFT);

prompt
prompt Creating table MIWCONTACT_CTRTYPE
prompt =================================
prompt
create table MIWCONTACT_CTRTYPE
(
  mcctrtype_source     VARCHAR2(100) not null,
  mcctrtype_refctrtype VARCHAR2(100) not null,
  mcctrtype_secteur_1  VARCHAR2(100) not null,
  mcctrtype_refmper_1  VARCHAR2(100) not null,
  mcctrtype_secteur_2  VARCHAR2(100),
  mcctrtype_refmper_2  VARCHAR2(100),
  mcctrtype_secteur_3  VARCHAR2(100),
  mcctrtype_refmper_3  VARCHAR2(100),
  mcctrtype_secteur_4  VARCHAR2(100),
  mcctrtype_refmper_4  VARCHAR2(100),
  mcctrtype_secteur_5  VARCHAR2(100),
  mcctrtype_refmper_5  VARCHAR2(100)
)
tablespace MIG61
  pctfree 10
  initrans 1
  maxtrans 255;
comment on table MIWCONTACT_CTRTYPE
  is 'Table CONTACT CONTRAT TYPE';
comment on column MIWCONTACT_CTRTYPE.mcctrtype_source
  is 'Code source/origine de contacte contrat type [OBL]';
comment on column MIWCONTACT_CTRTYPE.mcctrtype_refctrtype
  is 'Référence du contrat type dans le SI source  ';
comment on column MIWCONTACT_CTRTYPE.mcctrtype_secteur_1
  is 'secteur de contacte 1';
comment on column MIWCONTACT_CTRTYPE.mcctrtype_refmper_1
  is 'contacte 1 ';
comment on column MIWCONTACT_CTRTYPE.mcctrtype_secteur_2
  is 'secteur de contacte 2';
comment on column MIWCONTACT_CTRTYPE.mcctrtype_refmper_2
  is 'contacte 2 ';
comment on column MIWCONTACT_CTRTYPE.mcctrtype_secteur_3
  is 'secteur de contacte 3';
comment on column MIWCONTACT_CTRTYPE.mcctrtype_refmper_3
  is 'contacte 3 ';
comment on column MIWCONTACT_CTRTYPE.mcctrtype_secteur_4
  is 'secteur de contacte 4';
comment on column MIWCONTACT_CTRTYPE.mcctrtype_refmper_4
  is 'contacte 4 ';
comment on column MIWCONTACT_CTRTYPE.mcctrtype_secteur_5
  is 'secteur de contacte 5';
comment on column MIWCONTACT_CTRTYPE.mcctrtype_refmper_5
  is 'contacte 5 ';
alter table MIWCONTACT_CTRTYPE
  add constraint PK_MIWCONTACT_CTRTYPE primary key (MCCTRTYPE_SOURCE, MCCTRTYPE_REFCTRTYPE)
  using index 
  tablespace USERS
  pctfree 10
  initrans 2
  maxtrans 255;
alter table MIWCONTACT_CTRTYPE
  add constraint FK_CTRTYPE_REFCTRTYPE foreign key (MCCTRTYPE_SOURCE, MCCTRTYPE_REFCTRTYPE)
  references MIWCTRTYPE (CTRTYPE_SOURCE, CTRTYPE_REF);

prompt
prompt Creating table MIWENGAGEMENT
prompt ============================
prompt
create table MIWENGAGEMENT
(
  sub_source  VARCHAR2(100) not null,
  sub_ref     VARCHAR2(100) not null,
  sub_nom     VARCHAR2(4000) not null,
  sub_comment VARCHAR2(100),
  sut_id      NUMBER
)
tablespace MIG61
  pctfree 10
  initrans 1
  maxtrans 255
  storage
  (
    initial 64K
    next 1M
    minextents 1
    maxextents unlimited
  );
comment on table MIWENGAGEMENT
  is 'Table des groupements bundle';
comment on column MIWENGAGEMENT.sub_ref
  is 'Identifiant de l''engagement';
comment on column MIWENGAGEMENT.sub_nom
  is 'Nom de l''engagement';
alter table MIWENGAGEMENT
  add constraint PK_MIWENGABN primary key (SUB_SOURCE, SUB_REF)
  using index 
  tablespace USERS
  pctfree 10
  initrans 2
  maxtrans 255
  storage
  (
    initial 64K
    next 1M
    minextents 1
    maxextents unlimited
  );

prompt
prompt Creating table MIWENGABN
prompt ========================
prompt
create table MIWENGABN
(
  asu_subsource   VARCHAR2(100) not null,
  asu_subref      VARCHAR2(100) not null,
  asu_refsource   VARCHAR2(100) not null,
  asu_refabn      VARCHAR2(100) not null,
  asu_value       VARCHAR2(100) not null,
  asu_dtdebut     DATE,
  asu_datcreation DATE,
  asu_dtfin       DATE
)
tablespace MIG61
  pctfree 10
  initrans 1
  maxtrans 255
  storage
  (
    initial 64K
    next 1M
    minextents 1
    maxextents unlimited
  );
comment on table MIWENGABN
  is 'Table des groupements bundle';
comment on column MIWENGABN.asu_subsource
  is 'Identifiant de l''engagement';
comment on column MIWENGABN.asu_subref
  is 'Nom de l''engagement';
comment on column MIWENGABN.asu_refsource
  is 'Reference Abonnement';
comment on column MIWENGABN.asu_refabn
  is 'Reference Abonnement';
comment on column MIWENGABN.asu_value
  is 'Valeur de l''engagement';
alter table MIWENGABN
  add constraint FK_MIWENGAGEMENT_REF_ABNT foreign key (ASU_REFSOURCE, ASU_REFABN)
  references MIWABN (ABN_SOURCE, ABN_REF);
alter table MIWENGABN
  add constraint FK_MIWENGAGEMENT_REF_SUB foreign key (ASU_SUBSOURCE, ASU_SUBREF)
  references MIWENGAGEMENT (SUB_SOURCE, SUB_REF);

prompt
prompt Creating table MIWENGABN_SAVE
prompt =============================
prompt
create table MIWENGABN_SAVE
(
  asu_subsource   VARCHAR2(100) not null,
  asu_subref      VARCHAR2(100) not null,
  asu_refsource   VARCHAR2(100) not null,
  asu_refabn      VARCHAR2(100) not null,
  asu_value       VARCHAR2(100) not null,
  asu_dtdebut     DATE,
  asu_datcreation DATE
)
tablespace MIG61
  pctfree 10
  initrans 1
  maxtrans 255;

prompt
prompt Creating table MIW_LOG
prompt ======================
prompt
create table MIW_LOG
(
  miw_log_tab   NVARCHAR2(100),
  miw_log_errur NVARCHAR2(1000)
)
tablespace MIG61
  pctfree 10
  initrans 1
  maxtrans 255;
comment on column MIW_LOG.miw_log_tab
  is 'TABLE ';
comment on column MIW_LOG.miw_log_errur
  is 'ERREUR ';

prompt
prompt Creating table MIWORGANIZATION
prompt ==============================
prompt
create table MIWORGANIZATION
(
  morga_source         VARCHAR2(100) not null,
  morga_reforga        VARCHAR2(100) not null,
  morga_libelle        VARCHAR2(100),
  morga_postecomptable VARCHAR2(12),
  morga_nne            VARCHAR2(6),
  morga_centre         VARCHAR2(2),
  morga_document       VARCHAR2(1),
  morga_lopfmt         VARCHAR2(100),
  morga_banque         VARCHAR2(100),
  morga_numcompte      VARCHAR2(100),
  morga_flux           VARCHAR2(2),
  morga_nne_rembours   VARCHAR2(6),
  morga_ligneoptique   VARCHAR2(6),
  morga_divers         VARCHAR2(6),
  morga_rmh            VARCHAR2(4),
  morga_bankfmt        VARCHAR2(100),
  morga_ics            VARCHAR2(100),
  morga_bic            VARCHAR2(100)
)
tablespace MIG61
  pctfree 10
  initrans 1
  maxtrans 255
  storage
  (
    initial 64K
    next 1M
    minextents 1
    maxextents unlimited
  );
comment on table MIWORGANIZATION
  is 'Table Pivot Oraganisation ';
comment on column MIWORGANIZATION.morga_source
  is 'Code source/origine Oraganisation [OBL]';
comment on column MIWORGANIZATION.morga_reforga
  is 'Code de  Oraganisation';
comment on column MIWORGANIZATION.morga_libelle
  is 'libelle de Oraganisation';
comment on column MIWORGANIZATION.morga_postecomptable
  is 'Poste comptable lié à l''établissement ';
comment on column MIWORGANIZATION.morga_nne
  is ' Numero national d''emetteur (pour TIP et prelevement)  ';
comment on column MIWORGANIZATION.morga_centre
  is ' Numero de centre emetteur (pour TIP)  ';
comment on column MIWORGANIZATION.morga_numcompte
  is ' Numero de compte bancaire (pour prelevement) ';
comment on column MIWORGANIZATION.morga_nne_rembours
  is ' Code NNE à appliquer pour les remboursements  ';
comment on column MIWORGANIZATION.morga_ligneoptique
  is ' Code NNE de la ligne optique TIP  ';
alter table MIWORGANIZATION
  add constraint PK_MIWORGANIZATION primary key (MORGA_SOURCE, MORGA_REFORGA)
  using index 
  tablespace USERS
  pctfree 10
  initrans 2
  maxtrans 255
  storage
  (
    initial 64K
    next 1M
    minextents 1
    maxextents unlimited
  );

prompt
prompt Creating table MIWORGANIZATION_SAVE
prompt ===================================
prompt
create table MIWORGANIZATION_SAVE
(
  morga_source         VARCHAR2(100) not null,
  morga_reforga        VARCHAR2(100) not null,
  morga_libelle        VARCHAR2(100),
  morga_postecomptable VARCHAR2(12),
  morga_nne            VARCHAR2(6),
  morga_centre         VARCHAR2(2),
  morga_document       VARCHAR2(1),
  morga_lopfmt         VARCHAR2(100),
  morga_banque         VARCHAR2(100),
  morga_numcompte      VARCHAR2(100),
  morga_flux           VARCHAR2(2),
  morga_nne_rembours   VARCHAR2(6),
  morga_ligneoptique   VARCHAR2(6),
  morga_divers         VARCHAR2(6),
  morga_rmh            VARCHAR2(4),
  morga_bankfmt        VARCHAR2(100),
  morga_ics            VARCHAR2(100),
  morga_bic            VARCHAR2(100)
)
tablespace MIG61
  pctfree 10
  initrans 1
  maxtrans 255;

prompt
prompt Creating table MIWROLAGENT
prompt ==========================
prompt
create table MIWROLAGENT
(
  rolagent_source     VARCHAR2(100) not null,
  rolagent_ref        VARCHAR2(100) not null,
  voc_rolecttage      VARCHAR2(100) not null,
  rolagent_refctrtype VARCHAR2(100) not null
)
tablespace MIG61
  pctfree 10
  initrans 1
  maxtrans 255;
comment on table MIWROLAGENT
  is 'Table Rol des agents';
comment on column MIWROLAGENT.rolagent_ref
  is 'Identifiant agent';
comment on column MIWROLAGENT.voc_rolecttage
  is ' Role (0: Dviers,1 : Resp Facture, 2 : Resp Releve, 3 : Plombier, 4 : Releveur, 5 :Chargé Clientèle,6: Agence commerciale )';
comment on column MIWROLAGENT.rolagent_refctrtype
  is 'Référence du contrat type dans le SI source  ';
alter table MIWROLAGENT
  add constraint FK_MIWROLAGENT_AGENT foreign key (ROLAGENT_SOURCE, ROLAGENT_REF)
  references MIWAGENT (AGE_SOURCE, AGE_REF);
alter table MIWROLAGENT
  add constraint FK_MIWROLAGENT_CTRTYPE foreign key (ROLAGENT_SOURCE, ROLAGENT_REFCTRTYPE)
  references MIWCTRTYPE (CTRTYPE_SOURCE, CTRTYPE_REF);

prompt
prompt Creating table MIWSECTEUR_CTRTYPE
prompt =================================
prompt
create table MIWSECTEUR_CTRTYPE
(
  mcctrtype_source     VARCHAR2(100) not null,
  mcctrtype_refctrtype VARCHAR2(100) not null,
  mcctrtype_secteur    VARCHAR2(100) not null,
  mcctrtype_prestation VARCHAR2(100) not null
)
tablespace MIG61
  pctfree 10
  initrans 1
  maxtrans 255;
comment on table MIWSECTEUR_CTRTYPE
  is 'Table CONTACT CONTRAT TYPE';
comment on column MIWSECTEUR_CTRTYPE.mcctrtype_source
  is 'Code source/origine de contacte contrat type [OBL]';
comment on column MIWSECTEUR_CTRTYPE.mcctrtype_refctrtype
  is 'Référence du contrat type dans le SI source  ';
comment on column MIWSECTEUR_CTRTYPE.mcctrtype_secteur
  is 'secteur Administratif';
comment on column MIWSECTEUR_CTRTYPE.mcctrtype_prestation
  is 'Libellé Prestation (Eau/Ass) ';
alter table MIWSECTEUR_CTRTYPE
  add constraint PK_MIWSECTEUR_CTRTYPE primary key (MCCTRTYPE_SOURCE, MCCTRTYPE_REFCTRTYPE, MCCTRTYPE_SECTEUR, MCCTRTYPE_PRESTATION)
  using index 
  tablespace USERS
  pctfree 10
  initrans 2
  maxtrans 255;
alter table MIWSECTEUR_CTRTYPE
  add constraint FK_CTRTYPE_REFCTRTYPE1 foreign key (MCCTRTYPE_SOURCE, MCCTRTYPE_REFCTRTYPE)
  references MIWCTRTYPE (CTRTYPE_SOURCE, CTRTYPE_REF);

prompt
prompt Creating table MIWTADR
prompt ======================
prompt
create table MIWTADR
(
  madr_source   VARCHAR2(100) not null,
  madr_ref      VARCHAR2(100) not null,
  madr_refrue   VARCHAR2(100),
  madr_nrue     VARCHAR2(8),
  madr_irue     VARCHAR2(10),
  madr_rue1     VARCHAR2(200),
  madr_rue2     VARCHAR2(200),
  madr_vill     VARCHAR2(200),
  madr_vilc     VARCHAR2(200),
  madr_cpos     VARCHAR2(5),
  madr_bpos     VARCHAR2(200),
  madr_pays     VARCHAR2(200),
  madr_bati     VARCHAR2(200),
  madr_esca     VARCHAR2(200),
  madr_etag     VARCHAR2(200),
  madr_appt     VARCHAR2(200),
  madr_seq      VARCHAR2(200),
  madr_gpsx     NUMBER,
  madr_gpsy     NUMBER,
  madr_gpsz     NUMBER,
  madr_vilinsee VARCHAR2(5),
  madr_rueinsee VARCHAR2(5),
  liv           VARCHAR2(100),
  fac           VARCHAR2(100),
  branch        VARCHAR2(100),
  adr_id        NUMBER,
  dis_id        NUMBER,
  str_id        NUMBER,
  twn_id        NUMBER,
  cite          VARCHAR2(50),
  resid         VARCHAR2(50),
  impasse       VARCHAR2(50),
  angle         VARCHAR2(50),
  place         VARCHAR2(50),
  type          VARCHAR2(50),
  adr_source    VARCHAR2(200)
)
tablespace MIG61
  pctfree 10
  initrans 1
  maxtrans 255
  storage
  (
    initial 64K
    next 1M
    minextents 1
    maxextents unlimited
  );
comment on table MIWTADR
  is 'Table pour la migration des adresses';
comment on column MIWTADR.madr_source
  is 'Identifiant de la source de données ';
comment on column MIWTADR.madr_ref
  is 'Référence de l''adresse dans le SI source (le couple source/référence adresse doit être unique) ';
comment on column MIWTADR.madr_refrue
  is 'Référence de la rue ville dans le SI source ';
comment on column MIWTADR.madr_nrue
  is 'Numéro dans la rue';
comment on column MIWTADR.madr_irue
  is 'Index dans la rue ';
comment on column MIWTADR.madr_rue1
  is 'Libellé Rue 1ère ligne ';
comment on column MIWTADR.madr_rue2
  is 'Libellé Rue 2ème ligne ';
comment on column MIWTADR.madr_vill
  is 'Nom de la ville ';
comment on column MIWTADR.madr_vilc
  is 'Complément au nom de la ville ';
comment on column MIWTADR.madr_cpos
  is 'Code postal';
comment on column MIWTADR.madr_bpos
  is 'Boîte postale ';
comment on column MIWTADR.madr_pays
  is 'Pays ';
comment on column MIWTADR.madr_bati
  is 'Batiment ';
comment on column MIWTADR.madr_esca
  is 'Escalier ';
comment on column MIWTADR.madr_etag
  is 'Etage ';
comment on column MIWTADR.madr_appt
  is 'Appartement ';
comment on column MIWTADR.madr_gpsx
  is 'Coordonnee GPS X ';
comment on column MIWTADR.madr_gpsy
  is 'Coordonnee GPS Y ';
comment on column MIWTADR.madr_gpsz
  is 'Coordonnee GPS Z ';
alter table MIWTADR
  add constraint MIWTADR primary key (MADR_SOURCE, MADR_REF)
  using index 
  tablespace USERS
  pctfree 10
  initrans 2
  maxtrans 255
  storage
  (
    initial 64K
    next 1M
    minextents 1
    maxextents unlimited
  );

prompt
prompt Creating table MIWTADR_SAVE
prompt ===========================
prompt
create table MIWTADR_SAVE
(
  madr_source   VARCHAR2(100) not null,
  madr_ref      VARCHAR2(100) not null,
  madr_refrue   VARCHAR2(100),
  madr_nrue     VARCHAR2(8),
  madr_irue     VARCHAR2(10),
  madr_rue1     VARCHAR2(200),
  madr_rue2     VARCHAR2(200),
  madr_vill     VARCHAR2(200),
  madr_vilc     VARCHAR2(200),
  madr_cpos     VARCHAR2(5),
  madr_bpos     VARCHAR2(200),
  madr_pays     VARCHAR2(200),
  madr_bati     VARCHAR2(200),
  madr_esca     VARCHAR2(200),
  madr_etag     VARCHAR2(200),
  madr_appt     VARCHAR2(200),
  madr_seq      VARCHAR2(200),
  madr_gpsx     NUMBER,
  madr_gpsy     NUMBER,
  madr_gpsz     NUMBER,
  madr_vilinsee VARCHAR2(5),
  madr_rueinsee VARCHAR2(5),
  liv           VARCHAR2(100),
  fac           VARCHAR2(100),
  branch        VARCHAR2(100),
  adr_id        NUMBER,
  dis_id        NUMBER,
  str_id        NUMBER,
  twn_id        NUMBER,
  cite          VARCHAR2(50),
  resid         VARCHAR2(50),
  impasse       VARCHAR2(50),
  angle         VARCHAR2(50),
  place         VARCHAR2(50),
  type          VARCHAR2(50),
  adr_source    VARCHAR2(200)
)
tablespace MIG61
  pctfree 10
  initrans 1
  maxtrans 255;
alter table MIWTADR_SAVE
  add constraint MIWTADR_SAVE primary key (MADR_SOURCE, MADR_REF)
  using index 
  tablespace USERS
  pctfree 10
  initrans 2
  maxtrans 255;

prompt
prompt Creating table MIWTBANQUE
prompt =========================
prompt
create table MIWTBANQUE
(
  bnq_source   VARCHAR2(100),
  bnq_code     VARCHAR2(2),
  bnq_agc_code VARCHAR2(3),
  bnq_lib      VARCHAR2(200)
)
tablespace MIG61
  pctfree 10
  initrans 1
  maxtrans 255;

prompt
prompt Creating table MIWTBRA_SAVE
prompt ===========================
prompt
create table MIWTBRA_SAVE
(
  mbra_source       VARCHAR2(100) not null,
  mbra_ref          VARCHAR2(100) not null,
  mbra_refadr       VARCHAR2(100) not null,
  mbra_type         VARCHAR2(1),
  mbra_etat         VARCHAR2(1),
  mbra_detat        DATE,
  mbra_refvocreseau VARCHAR2(100),
  mbra_step         VARCHAR2(100),
  mbra_chateau      VARCHAR2(100),
  voc_matbra        VARCHAR2(100),
  voc_diabra        VARCHAR2(100),
  voc_lgbra         VARCHAR2(100),
  mbra_etatass      VARCHAR2(100),
  mbra_dateass      DATE,
  mbra_vanneindiv   VARCHAR2(100),
  mbra_vanneinnac   VARCHAR2(100),
  commentaire       VARCHAR2(4000),
  cnn_id            NUMBER,
  fld_id            NUMBER,
  adr_id            NUMBER,
  mbra_datcreation  DATE
)
tablespace MIG61
  pctfree 10
  initrans 1
  maxtrans 255;

prompt
prompt Creating table MIWTCOMPTEUR
prompt ===========================
prompt
create table MIWTCOMPTEUR
(
  mcom_source        VARCHAR2(100) not null,
  mcom_ref           VARCHAR2(100) not null,
  mcom_reel          VARCHAR2(20),
  mcom_cle           VARCHAR2(5),
  voc_equstatus      VARCHAR2(100),
  mcom_comment       VARCHAR2(4000),
  mcom_refvocmarque  VARCHAR2(100),
  voc_model          VARCHAR2(100),
  voc_qn             VARCHAR2(100),
  mcom_nbphases      NUMBER,
  voc_mtrelectp      VARCHAR2(100),
  voc_diam           VARCHAR2(100),
  mcom_annee         NUMBER(4),
  mcom_refvocclasse  VARCHAR2(100),
  ncom_nbroue        NUMBER(5),
  mcom_longueur      VARCHAR2(50),
  mcom_radi_pose     DATE,
  mcom_radi_refe     VARCHAR2(15),
  mcom_radi_cons     VARCHAR2(30),
  mcom_radi_modele   VARCHAR2(30),
  mcom_radi_empl     VARCHAR2(30),
  ref_typeequi       VARCHAR2(100),
  mcom_radi_protcole VARCHAR2(100),
  mcom_radi_annee    NUMBER(4),
  mcom_radi_poidsimp VARCHAR2(100),
  mcom_radi_uniteimp VARCHAR2(100),
  mcom_radi_nbvoies  VARCHAR2(100),
  mcom_radi_indexdep VARCHAR2(100),
  mcom_brlpui        VARCHAR2(100),
  mcom_disinf        VARCHAR2(100),
  mcom_disnat        VARCHAR2(100),
  mcom_chgtrf        VARCHAR2(100),
  mcom_trfutl        VARCHAR2(100),
  mcom_trfpui        VARCHAR2(100),
  mcom_coeff         NUMBER(10,2),
  voc_dijpui         VARCHAR2(100),
  voc_divpui         VARCHAR2(100),
  voc_transmrq       VARCHAR2(100),
  voc_mtramp         VARCHAR2(100),
  voc_mtrtension     VARCHAR2(100),
  voc_owner          VARCHAR2(100),
  mcom_nbmeu         NUMBER(2),
  mtc_id             NUMBER,
  equ_id             NUMBER,
  equ_id_radio       NUMBER
)
tablespace MIG61
  pctfree 10
  initrans 1
  maxtrans 255
  storage
  (
    initial 64K
    next 1M
    minextents 1
    maxextents unlimited
  );
comment on table MIWTCOMPTEUR
  is 'Migration PIVOT : les compteurs';
comment on column MIWTCOMPTEUR.mcom_source
  is 'Identifiant de la source de données [OBL]';
comment on column MIWTCOMPTEUR.mcom_ref
  is 'Référence du compteur dans le SI source (le couple source/référence compteur doit être UNIQUE) [OBL]';
comment on column MIWTCOMPTEUR.mcom_reel
  is 'Numero réel du compteur  [TA 12]';
comment on column MIWTCOMPTEUR.mcom_cle
  is 'Clé du Numero réel du compteur';
comment on column MIWTCOMPTEUR.voc_equstatus
  is 'Liste[EQUSTATUS] :En service,Au rebus, En reparation';
comment on column MIWTCOMPTEUR.mcom_comment
  is 'Commentaire';
comment on column MIWTCOMPTEUR.mcom_refvocmarque
  is 'Marque du compteur';
comment on column MIWTCOMPTEUR.voc_model
  is 'Modèle du compteur [TA 30]';
comment on column MIWTCOMPTEUR.voc_diam
  is 'Diametre du compteur en mm [OBL]';
comment on column MIWTCOMPTEUR.mcom_annee
  is 'Année de fabrication';
comment on column MIWTCOMPTEUR.mcom_refvocclasse
  is 'Classe du compteur';
comment on column MIWTCOMPTEUR.mcom_longueur
  is 'Longueur du compteur';
comment on column MIWTCOMPTEUR.mcom_radi_pose
  is 'Module radio : date de pose du module';
comment on column MIWTCOMPTEUR.mcom_radi_refe
  is 'Module radio : référence tête radio';
comment on column MIWTCOMPTEUR.mcom_radi_cons
  is 'Module radio : constructeur  SA, AC, IV, CO,...';
comment on column MIWTCOMPTEUR.mcom_radi_modele
  is 'Module radio : modèle';
comment on column MIWTCOMPTEUR.mcom_radi_protcole
  is 'Module radio : Protcole (Telereleve, Radio Sappel)';
comment on column MIWTCOMPTEUR.mcom_radi_annee
  is 'Module radio : Millesisme';
comment on column MIWTCOMPTEUR.mcom_radi_poidsimp
  is 'Module radio : Poids Impulsion Radio';
comment on column MIWTCOMPTEUR.mcom_radi_uniteimp
  is 'Module radio : Unite Poids Impulsion Radio';
comment on column MIWTCOMPTEUR.mcom_radi_nbvoies
  is 'Module radio : Nombre de voies';
comment on column MIWTCOMPTEUR.mcom_radi_indexdep
  is 'Module radio : Index Départ Telereleve';
comment on column MIWTCOMPTEUR.mcom_brlpui
  is 'Puissance max supportée par le PDI';
comment on column MIWTCOMPTEUR.mcom_disinf
  is 'Localisation du disjoncteur';
comment on column MIWTCOMPTEUR.mcom_disnat
  is 'Nature/Protection de disjoncteur';
comment on column MIWTCOMPTEUR.mcom_chgtrf
  is 'Type de dispositif pour déclencher les chgts de plage horosaisonnière';
comment on column MIWTCOMPTEUR.mcom_trfutl
  is 'Configuration des transformateurs sur site';
comment on column MIWTCOMPTEUR.mcom_trfpui
  is 'Puissance des transformateurs electriques';
comment on column MIWTCOMPTEUR.mcom_coeff
  is 'Coefficient de conversion de la mesure en consommation ';
comment on column MIWTCOMPTEUR.voc_dijpui
  is 'vocab : puissance de transformateur';
comment on column MIWTCOMPTEUR.voc_divpui
  is ' Liste des vocabulaire de puissance vert';
comment on column MIWTCOMPTEUR.voc_transmrq
  is 'Liste des vocabulaires : marques de transformateur';
comment on column MIWTCOMPTEUR.mcom_nbmeu
  is 'Nombre des cadrans de compteur';
create index INDEX_CPT1 on MIWTCOMPTEUR (MCOM_REF)
  tablespace USERS
  pctfree 10
  initrans 2
  maxtrans 255
  storage
  (
    initial 64K
    next 1M
    minextents 1
    maxextents unlimited
  );
alter table MIWTCOMPTEUR
  add constraint PK_MIWTCOMPTEUR primary key (MCOM_SOURCE, MCOM_REF)
  using index 
  tablespace USERS
  pctfree 10
  initrans 2
  maxtrans 255
  storage
  (
    initial 64K
    next 1M
    minextents 1
    maxextents unlimited
  );

prompt
prompt Creating table MIWTCOMPTEURACTUEL
prompt =================================
prompt
create table MIWTCOMPTEURACTUEL
(
  etat_branchement CHAR(2 CHAR),
  compteur         VARCHAR2(16 CHAR),
  pdl_ref          VARCHAR2(13 CHAR)
)
tablespace MIG61
  pctfree 10
  initrans 1
  maxtrans 255;

prompt
prompt Creating table MIWTCOMPTEUR_MANQUANTE
prompt =====================================
prompt
create table MIWTCOMPTEUR_MANQUANTE
(
  mcom_source        VARCHAR2(100) not null,
  mcom_ref           VARCHAR2(100) not null,
  mcom_reel          VARCHAR2(20),
  mcom_cle           VARCHAR2(5),
  voc_equstatus      VARCHAR2(100),
  mcom_comment       VARCHAR2(4000),
  mcom_refvocmarque  VARCHAR2(100),
  voc_model          VARCHAR2(100),
  voc_qn             VARCHAR2(100),
  mcom_nbphases      NUMBER,
  voc_mtrelectp      VARCHAR2(100),
  voc_diam           VARCHAR2(100),
  mcom_annee         NUMBER(4),
  mcom_refvocclasse  VARCHAR2(100),
  ncom_nbroue        NUMBER(5),
  mcom_longueur      VARCHAR2(50),
  mcom_radi_pose     DATE,
  mcom_radi_refe     VARCHAR2(15),
  mcom_radi_cons     VARCHAR2(30),
  mcom_radi_modele   VARCHAR2(30),
  mcom_radi_empl     VARCHAR2(30),
  ref_typeequi       VARCHAR2(100),
  mcom_radi_protcole VARCHAR2(100),
  mcom_radi_annee    NUMBER(4),
  mcom_radi_poidsimp VARCHAR2(100),
  mcom_radi_uniteimp VARCHAR2(100),
  mcom_radi_nbvoies  VARCHAR2(100),
  mcom_radi_indexdep VARCHAR2(100),
  mcom_brlpui        VARCHAR2(100),
  mcom_disinf        VARCHAR2(100),
  mcom_disnat        VARCHAR2(100),
  mcom_chgtrf        VARCHAR2(100),
  mcom_trfutl        VARCHAR2(100),
  mcom_trfpui        VARCHAR2(100),
  mcom_coeff         NUMBER(10,2),
  voc_dijpui         VARCHAR2(100),
  voc_divpui         VARCHAR2(100),
  voc_transmrq       VARCHAR2(100),
  voc_mtramp         VARCHAR2(100),
  voc_mtrtension     VARCHAR2(100),
  voc_owner          VARCHAR2(100),
  mcom_nbmeu         NUMBER(2),
  mtc_id             NUMBER,
  equ_id             NUMBER,
  equ_id_radio       NUMBER
)
tablespace MIG61
  pctfree 10
  initrans 1
  maxtrans 255;

prompt
prompt Creating table MIWTCOMPTEUR_SAVE
prompt ================================
prompt
create table MIWTCOMPTEUR_SAVE
(
  mcom_source        VARCHAR2(100) not null,
  mcom_ref           VARCHAR2(100) not null,
  mcom_reel          VARCHAR2(20),
  mcom_cle           VARCHAR2(5),
  voc_equstatus      VARCHAR2(100),
  mcom_comment       VARCHAR2(4000),
  mcom_refvocmarque  VARCHAR2(100),
  voc_model          VARCHAR2(100),
  voc_qn             VARCHAR2(100),
  mcom_nbphases      NUMBER,
  voc_mtrelectp      VARCHAR2(100),
  voc_diam           VARCHAR2(100),
  mcom_annee         NUMBER(4),
  mcom_refvocclasse  VARCHAR2(100),
  ncom_nbroue        NUMBER(5),
  mcom_longueur      VARCHAR2(50),
  mcom_radi_pose     DATE,
  mcom_radi_refe     VARCHAR2(15),
  mcom_radi_cons     VARCHAR2(30),
  mcom_radi_modele   VARCHAR2(30),
  mcom_radi_empl     VARCHAR2(30),
  ref_typeequi       VARCHAR2(100),
  mcom_radi_protcole VARCHAR2(100),
  mcom_radi_annee    NUMBER(4),
  mcom_radi_poidsimp VARCHAR2(100),
  mcom_radi_uniteimp VARCHAR2(100),
  mcom_radi_nbvoies  VARCHAR2(100),
  mcom_radi_indexdep VARCHAR2(100),
  mcom_brlpui        VARCHAR2(100),
  mcom_disinf        VARCHAR2(100),
  mcom_disnat        VARCHAR2(100),
  mcom_chgtrf        VARCHAR2(100),
  mcom_trfutl        VARCHAR2(100),
  mcom_trfpui        VARCHAR2(100),
  mcom_coeff         NUMBER(10,2),
  voc_dijpui         VARCHAR2(100),
  voc_divpui         VARCHAR2(100),
  voc_transmrq       VARCHAR2(100),
  voc_mtramp         VARCHAR2(100),
  voc_mtrtension     VARCHAR2(100),
  voc_owner          VARCHAR2(100),
  mcom_nbmeu         NUMBER(2),
  mtc_id             NUMBER,
  equ_id             NUMBER,
  equ_id_radio       NUMBER
)
tablespace MIG61
  pctfree 10
  initrans 1
  maxtrans 255;

prompt
prompt Creating table MIWTCPTROUEDIAM
prompt ==============================
prompt
create table MIWTCPTROUEDIAM
(
  code_marque VARCHAR2(3),
  nom_marque  VARCHAR2(100),
  nbr_roue    NUMBER,
  diam        NUMBER,
  voc_roue    VARCHAR2(100),
  voc_diam    VARCHAR2(100),
  vow_roue    NUMBER,
  vow_diam    NUMBER
)
tablespace MIG61
  pctfree 10
  initrans 1
  maxtrans 255;

prompt
prompt Creating table MIWTCRIMPOSEE
prompt ============================
prompt
create table MIWTCRIMPOSEE
(
  crimposee_source    VARCHAR2(100) not null,
  crimposee_refimpose VARCHAR2(100) not null,
  crimposee_ref_abn   VARCHAR2(100) not null,
  crimposee_cadran    VARCHAR2(100) default 'EAU',
  crimposee_ddeb      DATE,
  crimposee_valeur    NUMBER(15,3),
  crpropose_valeur    NUMBER(15,3)
)
tablespace MIG61
  pctfree 10
  initrans 1
  maxtrans 255;
comment on table MIWTCRIMPOSEE
  is 'Table Pivot  Table des consommations de référence imposée des cadrans par abonnement ';
comment on column MIWTCRIMPOSEE.crimposee_source
  is 'Code source/origine de CRIMPOSEE [OBL]';
comment on column MIWTCRIMPOSEE.crimposee_refimpose
  is 'Référence de CRIMPOSEE dans le SI source  [OBL]';
comment on column MIWTCRIMPOSEE.crimposee_ref_abn
  is 'Référence PDS  dans le SI source [OBL]';
comment on column MIWTCRIMPOSEE.crimposee_cadran
  is 'Code Type Cadran  par defaut ''EAU''';
comment on column MIWTCRIMPOSEE.crimposee_ddeb
  is 'Date de début';
comment on column MIWTCRIMPOSEE.crimposee_valeur
  is 'Consommation de reference imposée ';
alter table MIWTCRIMPOSEE
  add constraint PK_MIWTCRIMPOSEE primary key (CRIMPOSEE_SOURCE, CRIMPOSEE_REFIMPOSE)
  using index 
  tablespace USERS
  pctfree 10
  initrans 2
  maxtrans 255;
alter table MIWTCRIMPOSEE
  add constraint FK_MIWTCRIMPOSEE_REF_ABN foreign key (CRIMPOSEE_SOURCE, CRIMPOSEE_REF_ABN)
  references MIWABN (ABN_SOURCE, ABN_REF);

prompt
prompt Creating table MIWTECHEANCE
prompt ===========================
prompt
create table MIWTECHEANCE
(
  mecheance_source       VARCHAR2(100) not null,
  mecheance_ref          VARCHAR2(100) not null,
  mecheance_montant      NUMBER(15,3) not null,
  mecheance_refcheancier VARCHAR2(100) not null,
  mecheance_restantdu    NUMBER(15,3) not null,
  mecheance_commentaire  VARCHAR2(4000),
  mecheance_date         DATE not null,
  miwtecheance_refmrib   VARCHAR2(100)
)
tablespace MIG61
  pctfree 10
  initrans 1
  maxtrans 255;
comment on table MIWTECHEANCE
  is 'Table Pivot échéance de paiement';
comment on column MIWTECHEANCE.mecheance_source
  is 'Code source/origine de la echeance [OBL]';
comment on column MIWTECHEANCE.mecheance_ref
  is 'Identifiant unique de l''échénce(obligatoire)';
comment on column MIWTECHEANCE.mecheance_montant
  is 'montant de l''échéance(obligatoire)';
comment on column MIWTECHEANCE.mecheance_refcheancier
  is 'Ref  de l''échéncier(obligatoire)';
comment on column MIWTECHEANCE.mecheance_restantdu
  is 'Restant dû sur l''échéance(obligatoire)';
comment on column MIWTECHEANCE.mecheance_date
  is 'Date de début de l''échéance(obligatoire)';
comment on column MIWTECHEANCE.miwtecheance_refmrib
  is 'Si RIB echeance prelevée ';
alter table MIWTECHEANCE
  add constraint PK_MIG_MIWTECHEANCE primary key (MECHEANCE_SOURCE, MECHEANCE_REF)
  using index 
  tablespace USERS
  pctfree 10
  initrans 2
  maxtrans 255;

prompt
prompt Creating table MIWTRIB
prompt ======================
prompt
create table MIWTRIB
(
  mrib_source    VARCHAR2(100) not null,
  mrib_ref       VARCHAR2(100) not null,
  mrib_banque    VARCHAR2(5),
  mrib_guichet   VARCHAR2(5),
  mrib_agence    VARCHAR2(100),
  mrib_compte    VARCHAR2(20),
  mrib_cle_rib   VARCHAR2(2),
  mrib_titulaire VARCHAR2(100),
  mrib_iso_iban  VARCHAR2(34),
  mrib_bic       VARCHAR2(11),
  mrib_rum       VARCHAR2(35),
  mrib_rumdt     DATE,
  ban_id         NUMBER
)
tablespace MIG61
  pctfree 10
  initrans 1
  maxtrans 255;
comment on table MIWTRIB
  is 'Table pivot des ribs';
comment on column MIWTRIB.mrib_source
  is 'Code source/origine de la donnée';
comment on column MIWTRIB.mrib_ref
  is 'Identifiant unique de la donnée pour la source';
comment on column MIWTRIB.mrib_banque
  is 'Code banque';
comment on column MIWTRIB.mrib_guichet
  is 'Code guichet';
comment on column MIWTRIB.mrib_agence
  is 'Nom agence bancaire [TA24]';
comment on column MIWTRIB.mrib_compte
  is 'N° compte bancaire payeur';
comment on column MIWTRIB.mrib_cle_rib
  is 'Clé du RIB';
comment on column MIWTRIB.mrib_titulaire
  is 'Nom du titulaire du compte [TA24]';
comment on column MIWTRIB.mrib_iso_iban
  is 'Code ISO norme IBAN';
comment on column MIWTRIB.mrib_bic
  is 'Code BIC pour Prel SEPA';
comment on column MIWTRIB.mrib_rumdt
  is 'date du mandat SEPA (RUM';
alter table MIWTRIB
  add constraint PK_MIWTRIB primary key (MRIB_SOURCE, MRIB_REF)
  using index 
  tablespace USERS
  pctfree 10
  initrans 2
  maxtrans 255;

prompt
prompt Creating table MIWTFACTUREENTETE
prompt ================================
prompt
create table MIWTFACTUREENTETE
(
  mfae_source             VARCHAR2(100) not null,
  mfae_ref                VARCHAR2(100) not null,
  mfae_reftrf             VARCHAR2(100),
  mfae_nume               NUMBER(10),
  mfae_rdet               VARCHAR2(15),
  mfae_ccmo               VARCHAR2(1),
  mfae_dedi               DATE not null,
  mfae_dlpai              DATE,
  mfae_dprel              DATE,
  mfae_tothte             NUMBER(15,3) not null,
  mfae_tottvae            NUMBER(15,3) not null,
  mfae_tothta             NUMBER(15,3) not null,
  mfae_tottvaa            NUMBER(15,3) not null,
  mfae_solde              NUMBER(15,3),
  mfae_type               VARCHAR2(3) default 'R' not null,
  mfae_reffaededu         VARCHAR2(100),
  mfae_refabn             VARCHAR2(100) not null,
  mfae_ref_codniv_relance VARCHAR2(100),
  mfae_rib_ref            VARCHAR2(100),
  mfae_rib_etat           NUMBER(1),
  mfae_compteaux          VARCHAR2(100),
  mfae_ref_origine        VARCHAR2(100),
  mfae_comment            VARCHAR2(4000),
  mfae_amountttcdec       NUMBER(17,10),
  voc_modefact            VARCHAR2(10),
  mfae_ref_deduc          VARCHAR2(100),
  mfae_reforga            VARCHAR2(100),
  mfae_exercice           NUMBER(4),
  mfae_numerorole         NUMBER(4),
  mfae_prel               NUMBER,
  mfae_arond              NUMBER,
  bil_id                  NUMBER,
  rec_id                  NUMBER,
  red_id                  NUMBER,
  deb_id                  NUMBER,
  mrel_ref                NUMBER
)
tablespace MIG61
  pctfree 10
  initrans 1
  maxtrans 255
  storage
  (
    initial 64K
    next 1M
    minextents 1
    maxextents unlimited
  );
comment on table MIWTFACTUREENTETE
  is 'Table Pivot Entete Facture';
comment on column MIWTFACTUREENTETE.mfae_source
  is 'Code source/origine de la facture [OBL]';
comment on column MIWTFACTUREENTETE.mfae_ref
  is 'Identifiant unique de la facture pour la source [OBL]';
comment on column MIWTFACTUREENTETE.mfae_reftrf
  is 'Identifiant du train de la facture';
comment on column MIWTFACTUREENTETE.mfae_nume
  is 'Numéro de la facture [OBL]';
comment on column MIWTFACTUREENTETE.mfae_rdet
  is 'RDET de la facture';
comment on column MIWTFACTUREENTETE.mfae_ccmo
  is 'Clé contrôle RDET de la facture';
comment on column MIWTFACTUREENTETE.mfae_dedi
  is 'Date d édition de la facture [OBL]';
comment on column MIWTFACTUREENTETE.mfae_dlpai
  is 'Date limite de paiement de la facture [OBL]';
comment on column MIWTFACTUREENTETE.mfae_dprel
  is 'Date de prélèvement de la facture [OBL]';
comment on column MIWTFACTUREENTETE.mfae_tothte
  is 'Total HT EAU de la facture [OBL]';
comment on column MIWTFACTUREENTETE.mfae_tottvae
  is 'Total TVA EAU de la facture [OBL]';
comment on column MIWTFACTUREENTETE.mfae_tothta
  is 'Total HT ASS de la facture [OBL]';
comment on column MIWTFACTUREENTETE.mfae_tottvaa
  is 'Total TVA ASS de la facture [OBL]';
comment on column MIWTFACTUREENTETE.mfae_solde
  is 'Solde TTC de la facture';
comment on column MIWTFACTUREENTETE.mfae_refabn
  is 'Identifiant du contrat de la facture [OBL]';
comment on column MIWTFACTUREENTETE.mfae_ref_codniv_relance
  is 'Référence Code niveau de chainde relance';
comment on column MIWTFACTUREENTETE.mfae_rib_ref
  is 'Référence Rib ';
comment on column MIWTFACTUREENTETE.mfae_rib_etat
  is 'Mode de payement (pr?l?vement 1 ou tip 2)';
comment on column MIWTFACTUREENTETE.mfae_compteaux
  is 'Compte auxilaire GENACCOUNT associé a la facture';
comment on column MIWTFACTUREENTETE.mfae_ref_origine
  is 'Facture origine';
comment on column MIWTFACTUREENTETE.mfae_comment
  is 'Commentaire libre Facture';
comment on column MIWTFACTUREENTETE.mfae_amountttcdec
  is 'Montant TTC à déduire';
comment on column MIWTFACTUREENTETE.mfae_exercice
  is 'Exercice du rôle de la facture';
comment on column MIWTFACTUREENTETE.mfae_numerorole
  is ' Numéro du rôle pour l''exercice';
create index IDX_MIWTFACTURE1 on MIWTFACTUREENTETE (MFAE_SOURCE, MFAE_REFABN, MFAE_REFORGA, BIL_ID, MFAE_EXERCICE)
  tablespace USERS
  pctfree 10
  initrans 2
  maxtrans 255
  storage
  (
    initial 64K
    next 1M
    minextents 1
    maxextents unlimited
  );
create index IDX_MIWTFACTURE2 on MIWTFACTUREENTETE (MFAE_COMMENT, MFAE_REFABN)
  tablespace USERS
  pctfree 10
  initrans 2
  maxtrans 163
  storage
  (
    initial 64K
    next 1M
    minextents 1
    maxextents unlimited
  );
create index IDX_MIWTFACTURE4 on MIWTFACTUREENTETE (MFAE_SOURCE, SUBSTR(MFAE_RDET,1,14))
  tablespace USERS
  pctfree 10
  initrans 2
  maxtrans 255
  storage
  (
    initial 64K
    next 1M
    minextents 1
    maxextents unlimited
  );
create index IDX_MIWTFACTURE5 on MIWTFACTUREENTETE (SUBSTR(MFAE_RDET,1,14))
  tablespace USERS
  pctfree 10
  initrans 2
  maxtrans 255
  storage
  (
    initial 64K
    next 1M
    minextents 1
    maxextents unlimited
  );
create index IDX_MIWTFACTURE6 on MIWTFACTUREENTETE (SUBSTR(MFAE_RDET,1,8), MFAE_SOURCE)
  tablespace USERS
  pctfree 10
  initrans 2
  maxtrans 255
  storage
  (
    initial 64K
    next 1M
    minextents 1
    maxextents unlimited
  );
create index IDX_MIWTFACTURE7 on MIWTFACTUREENTETE (MREL_REF)
  tablespace USERS
  pctfree 10
  initrans 2
  maxtrans 255
  storage
  (
    initial 64K
    next 1M
    minextents 1
    maxextents unlimited
  );
create index INDEX_MFAE_NUME on MIWTFACTUREENTETE (TO_CHAR(MFAE_NUME))
  tablespace USERS
  pctfree 10
  initrans 2
  maxtrans 255
  storage
  (
    initial 64K
    next 1M
    minextents 1
    maxextents unlimited
  );
create index INDEX_MFAE_NUME1 on MIWTFACTUREENTETE (MFAE_SOURCE, MFAE_RDET)
  tablespace USERS
  pctfree 10
  initrans 2
  maxtrans 255
  storage
  (
    initial 64K
    next 1M
    minextents 1
    maxextents unlimited
  );
create index INDEX_MFAE_NUME2 on MIWTFACTUREENTETE (MFAE_SOURCE, MFAE_REFTRF, SUBSTR(MFAE_RDET,1,8))
  tablespace USERS
  pctfree 10
  initrans 2
  maxtrans 255
  storage
  (
    initial 64K
    next 1M
    minextents 1
    maxextents unlimited
  );
create index INDEX_MFAE_NUME3 on MIWTFACTUREENTETE (MFAE_SOURCE, SUBSTR(MFAE_REFTRF,1,17), SUBSTR(MFAE_RDET,1,8))
  tablespace USERS
  pctfree 10
  initrans 2
  maxtrans 255
  storage
  (
    initial 64K
    next 1M
    minextents 1
    maxextents unlimited
  );
create index INDEX_MFAE_NUME4 on MIWTFACTUREENTETE (MFAE_REF_ORIGINE)
  tablespace USERS
  pctfree 10
  initrans 2
  maxtrans 255
  storage
  (
    initial 64K
    next 1M
    minextents 1
    maxextents unlimited
  );
create index IND_FACTUREENTETE_MFAE_REFABN on MIWTFACTUREENTETE (MFAE_SOURCE, MFAE_REFABN)
  tablespace USERS
  pctfree 10
  initrans 2
  maxtrans 255
  storage
  (
    initial 64K
    next 1M
    minextents 1
    maxextents unlimited
  );
create index INDX_FACT_GMF on MIWTFACTUREENTETE (MFAE_SOURCE, MFAE_REFABN, BIL_ID, MFAE_REFORGA)
  tablespace USERS
  pctfree 10
  initrans 2
  maxtrans 255
  storage
  (
    initial 64K
    next 1M
    minextents 1
    maxextents unlimited
  );
create index INDX_FACT_GMF1 on MIWTFACTUREENTETE (MFAE_REF)
  tablespace USERS
  pctfree 10
  initrans 2
  maxtrans 255
  storage
  (
    initial 64K
    next 1M
    minextents 1
    maxextents unlimited
  );
alter table MIWTFACTUREENTETE
  add constraint PK_MIWTFACTUREENTETE primary key (MFAE_SOURCE, MFAE_REF)
  using index 
  tablespace USERS
  pctfree 10
  initrans 2
  maxtrans 255
  storage
  (
    initial 64K
    next 1M
    minextents 1
    maxextents unlimited
  );
alter table MIWTFACTUREENTETE
  add constraint FK_MFAE_RIB_REF foreign key (MFAE_SOURCE, MFAE_RIB_REF)
  references MIWTRIB (MRIB_SOURCE, MRIB_REF);
alter table MIWTFACTUREENTETE
  add constraint FK_REFORGA foreign key (MFAE_SOURCE, MFAE_REFORGA)
  references MIWORGANIZATION (MORGA_SOURCE, MORGA_REFORGA);

prompt
prompt Creating table MIWTECHEANCIER
prompt =============================
prompt
create table MIWTECHEANCIER
(
  mecheancier_source      VARCHAR2(100) not null,
  mecheancier_ref         VARCHAR2(100) not null,
  mecheancier_refmrib     VARCHAR2(100),
  mecheancier_restantdu   NUMBER(15,3) not null,
  mecheancier_montant     NUMBER(15,3) not null,
  mecheancier_commentaire VARCHAR2(4000),
  mecheancier_date        DATE not null,
  mecheancier_reffae      VARCHAR2(100) not null
)
tablespace MIG61
  pctfree 10
  initrans 1
  maxtrans 255;
comment on table MIWTECHEANCIER
  is 'Table Pivot échéncier de paiement';
comment on column MIWTECHEANCIER.mecheancier_source
  is 'Code source/origine de la mensualisation [OBL]';
comment on column MIWTECHEANCIER.mecheancier_ref
  is 'Identifiant unique de l''échéncier(obligatoire)';
comment on column MIWTECHEANCIER.mecheancier_refmrib
  is 'Référence du RIB dans le SI source  ';
comment on column MIWTECHEANCIER.mecheancier_restantdu
  is 'Restant dû sur l''échéancier(obligatoire)';
comment on column MIWTECHEANCIER.mecheancier_montant
  is 'Montant de l''échéancier(obligatoire)';
comment on column MIWTECHEANCIER.mecheancier_date
  is 'Date de début de l''échéancier(obligatoire)';
comment on column MIWTECHEANCIER.mecheancier_reffae
  is 'Référence du FACTURE dans le SI source  ';
alter table MIWTECHEANCIER
  add constraint PK_MIG_ECHEANCIER primary key (MECHEANCIER_SOURCE, MECHEANCIER_REF, MECHEANCIER_REFFAE)
  using index 
  tablespace USERS
  pctfree 10
  initrans 2
  maxtrans 255;
alter table MIWTECHEANCIER
  add constraint FK_MIWTECHEANCIER_ME_REFMRIB foreign key (MECHEANCIER_SOURCE, MECHEANCIER_REFFAE)
  references MIWTFACTUREENTETE (MFAE_SOURCE, MFAE_REF);
alter table MIWTECHEANCIER
  add constraint FK_MIWTECHEANCIER_ME_REFMRIB1 foreign key (MECHEANCIER_SOURCE, MECHEANCIER_REFMRIB)
  references MIWTRIB (MRIB_SOURCE, MRIB_REF);

prompt
prompt Creating table MIWTPERSONNE
prompt ===========================
prompt
create table MIWTPERSONNE
(
  mper_source     VARCHAR2(100) not null,
  mper_ref        VARCHAR2(100) not null,
  mper_refe       VARCHAR2(100),
  mper_nom        VARCHAR2(100) not null,
  mper_prenom     VARCHAR2(100),
  mper_compl_nom  VARCHAR2(100),
  voc_title       VARCHAR2(100),
  mper_ref_adr    VARCHAR2(100),
  mper_tel        VARCHAR2(15),
  mper_tel_bureau VARCHAR2(15),
  mper_fax        VARCHAR2(15),
  mper_tel_mobil  VARCHAR2(15),
  mper_tel_mobil1 VARCHAR2(15),
  mper_mail       VARCHAR2(255),
  mper_mail1      VARCHAR2(255),
  voc_typsag      VARCHAR2(2),
  mper_comment    VARCHAR2(4000),
  mper_exon       VARCHAR2(1),
  mper_num_exon   VARCHAR2(20),
  mper_dtdeb_exon DATE,
  mper_dtfin_exon DATE,
  voc_partytp     NUMBER(10),
  adr_id          NUMBER,
  par_id          NUMBER,
  vow_id_partytp  NUMBER,
  vow_id_title    NUMBER,
  vow_id_typsag   NUMBER
)
tablespace MIG61
  pctfree 10
  initrans 1
  maxtrans 255
  storage
  (
    initial 64K
    next 1M
    minextents 1
    maxextents unlimited
  );
comment on table MIWTPERSONNE
  is 'Table pivot des personnes';
comment on column MIWTPERSONNE.mper_source
  is 'Code source/origine de la donnée';
comment on column MIWTPERSONNE.mper_ref
  is 'Identifiant unique de la donnée pour la source';
comment on column MIWTPERSONNE.mper_refe
  is 'Reference de la personne [TA20]';
comment on column MIWTPERSONNE.mper_nom
  is 'Nom de la personne [TA30]';
comment on column MIWTPERSONNE.mper_prenom
  is 'Prenom de la personne [TA38]';
comment on column MIWTPERSONNE.mper_compl_nom
  is 'Complement du nom [TA38]';
comment on column MIWTPERSONNE.voc_title
  is 'Cle source du titre d une personne dans la table des correspondances';
comment on column MIWTPERSONNE.mper_ref_adr
  is 'Cle source de l adresse de la personne';
comment on column MIWTPERSONNE.mper_tel
  is 'Numero de telephone de la personne';
comment on column MIWTPERSONNE.mper_tel_bureau
  is 'Numero de telephone du bureau de la personne';
comment on column MIWTPERSONNE.mper_fax
  is 'Numero de fax de la personne';
comment on column MIWTPERSONNE.mper_tel_mobil
  is 'Telephone mobile (ie portable) de la personne';
comment on column MIWTPERSONNE.mper_mail
  is 'Mail de la personne [TA255]';
comment on column MIWTPERSONNE.voc_typsag
  is 'type de profil (professionnelle, domestique..)';
comment on column MIWTPERSONNE.mper_exon
  is 'Le client est exonerer TVA (O/N)';
comment on column MIWTPERSONNE.mper_num_exon
  is 'Numéro de la piece justificatif de l exonération';
comment on column MIWTPERSONNE.mper_dtdeb_exon
  is 'Date de début du periode d exonération';
comment on column MIWTPERSONNE.mper_dtfin_exon
  is 'Date de fin du periode d exonération';
alter table MIWTPERSONNE
  add constraint PK_MIWTPERSONNE primary key (MPER_SOURCE, MPER_REF)
  using index 
  tablespace USERS
  pctfree 10
  initrans 2
  maxtrans 255
  storage
  (
    initial 64K
    next 1M
    minextents 1
    maxextents unlimited
  );
alter table MIWTPERSONNE
  add constraint FK_MIWTPERSONNE_REF_ADR foreign key (MPER_SOURCE, MPER_REF_ADR)
  references MIWTADR (MADR_SOURCE, MADR_REF);

prompt
prompt Creating table MIWTENC
prompt ======================
prompt
create table MIWTENC
(
  menc_source      VARCHAR2(100) not null,
  menc_ref         VARCHAR2(100) not null,
  menc_refper      VARCHAR2(100),
  menc_date        DATE not null,
  menc_montant     NUMBER(10,3) not null,
  menc_commentaire VARCHAR2(500),
  menc_modepay     VARCHAR2(10),
  menc_refechq     VARCHAR2(100),
  menc_refjournal  VARCHAR2(100),
  menc_typejournal VARCHAR2(100),
  menc_compte      VARCHAR2(100),
  cam_id           NUMBER,
  csh_id           NUMBER
)
tablespace MIG61
  pctfree 10
  initrans 1
  maxtrans 255;
comment on table MIWTENC
  is 'encaissement. Un encaissement correspond à l''opération physique (caisse, chèque, prélèvement, virement ?)';
comment on column MIWTENC.menc_source
  is 'Code source/origine de la echeance [OBL]';
comment on column MIWTENC.menc_ref
  is 'identifiant interne de l''encaissement pour la migration : N° fourni par l''utilisateur (obligatoire)';
comment on column MIWTENC.menc_refper
  is 'Ref Peronne (obligatoire)';
comment on column MIWTENC.menc_date
  is 'date de l''encaissement (obligatoire)';
comment on column MIWTENC.menc_montant
  is 'montant de l''encaissement (obligatoire)';
comment on column MIWTENC.menc_modepay
  is 'mode de payement de reglement';
comment on column MIWTENC.menc_typejournal
  is 'Type de Journal PAYTYPESLIP';
comment on column MIWTENC.menc_compte
  is 'Compte imputation associé à l''encaissement (530)';
alter table MIWTENC
  add constraint PK_MIWTENC primary key (MENC_SOURCE, MENC_REF)
  using index 
  tablespace USERS
  pctfree 10
  initrans 2
  maxtrans 255;
alter table MIWTENC
  add constraint FK_MIWTEN foreign key (MENC_SOURCE, MENC_REFPER)
  references MIWTPERSONNE (MPER_SOURCE, MPER_REF);

prompt
prompt Creating table MIWTFACTUREENTETE_DIST
prompt =====================================
prompt
create table MIWTFACTUREENTETE_DIST
(
  mfae_source             VARCHAR2(100) not null,
  mfae_ref                VARCHAR2(100) not null,
  mfae_reftrf             VARCHAR2(100),
  mfae_nume               NUMBER(10),
  mfae_rdet               VARCHAR2(20),
  mfae_ccmo               VARCHAR2(1),
  mfae_dedi               DATE not null,
  mfae_dlpai              DATE,
  mfae_dprel              DATE,
  mfae_tothte             NUMBER(10,2) not null,
  mfae_tottvae            NUMBER(10,2) not null,
  mfae_tothta             NUMBER(10,2) not null,
  mfae_tottvaa            NUMBER(10,2) not null,
  mfae_solde              NUMBER(10,2),
  mfae_type               VARCHAR2(2) default 'R' not null,
  mfae_reffaededu         VARCHAR2(100),
  mfae_refabn             VARCHAR2(100) not null,
  mfae_ref_codniv_relance VARCHAR2(100),
  mfae_rib_ref            VARCHAR2(100),
  mfae_rib_etat           NUMBER(1),
  mfae_compteaux          VARCHAR2(100),
  mfae_ref_origine        VARCHAR2(100),
  mfae_comment            VARCHAR2(4000),
  mfae_amountttcdec       NUMBER(17,10),
  voc_modefact            VARCHAR2(10),
  mfae_ref_deduc          VARCHAR2(100),
  mfae_reforga            VARCHAR2(100),
  mfae_exercice           NUMBER(4),
  mfae_numerorole         NUMBER(4),
  mfae_prel               NUMBER,
  mfae_arond              NUMBER,
  bil_id                  NUMBER,
  rec_id                  NUMBER,
  red_id                  NUMBER,
  deb_id                  NUMBER
)
tablespace MIG61
  pctfree 10
  initrans 1
  maxtrans 255;
comment on table MIWTFACTUREENTETE_DIST
  is 'Table Pivot Entete Facture';
comment on column MIWTFACTUREENTETE_DIST.mfae_source
  is 'Code source/origine de la facture [OBL]';
comment on column MIWTFACTUREENTETE_DIST.mfae_ref
  is 'Identifiant unique de la facture pour la source [OBL]';
comment on column MIWTFACTUREENTETE_DIST.mfae_reftrf
  is 'Identifiant du train de la facture';
comment on column MIWTFACTUREENTETE_DIST.mfae_nume
  is 'Numéro de la facture [OBL]';
comment on column MIWTFACTUREENTETE_DIST.mfae_rdet
  is 'RDET de la facture';
comment on column MIWTFACTUREENTETE_DIST.mfae_ccmo
  is 'Clé contrôle RDET de la facture';
comment on column MIWTFACTUREENTETE_DIST.mfae_dedi
  is 'Date d édition de la facture [OBL]';
comment on column MIWTFACTUREENTETE_DIST.mfae_dlpai
  is 'Date limite de paiement de la facture [OBL]';
comment on column MIWTFACTUREENTETE_DIST.mfae_dprel
  is 'Date de prélèvement de la facture [OBL]';
comment on column MIWTFACTUREENTETE_DIST.mfae_tothte
  is 'Total HT EAU de la facture [OBL]';
comment on column MIWTFACTUREENTETE_DIST.mfae_tottvae
  is 'Total TVA EAU de la facture [OBL]';
comment on column MIWTFACTUREENTETE_DIST.mfae_tothta
  is 'Total HT ASS de la facture [OBL]';
comment on column MIWTFACTUREENTETE_DIST.mfae_tottvaa
  is 'Total TVA ASS de la facture [OBL]';
comment on column MIWTFACTUREENTETE_DIST.mfae_solde
  is 'Solde TTC de la facture';
comment on column MIWTFACTUREENTETE_DIST.mfae_refabn
  is 'Identifiant du contrat de la facture [OBL]';
comment on column MIWTFACTUREENTETE_DIST.mfae_ref_codniv_relance
  is 'Référence Code niveau de chainde relance';
comment on column MIWTFACTUREENTETE_DIST.mfae_rib_ref
  is 'Référence Rib ';
comment on column MIWTFACTUREENTETE_DIST.mfae_rib_etat
  is 'Mode de payement (pr?l?vement 1 ou tip 2)';
comment on column MIWTFACTUREENTETE_DIST.mfae_compteaux
  is 'Compte auxilaire GENACCOUNT associé a la facture';
comment on column MIWTFACTUREENTETE_DIST.mfae_ref_origine
  is 'Facture origine';
comment on column MIWTFACTUREENTETE_DIST.mfae_comment
  is 'Commentaire libre Facture';
comment on column MIWTFACTUREENTETE_DIST.mfae_amountttcdec
  is 'Montant TTC à déduire';
comment on column MIWTFACTUREENTETE_DIST.mfae_exercice
  is 'Exercice du rôle de la facture';
comment on column MIWTFACTUREENTETE_DIST.mfae_numerorole
  is ' Numéro du rôle pour l''exercice';
alter table MIWTFACTUREENTETE_DIST
  add constraint PK_MIWTFACTUREENTETE_DIST primary key (MFAE_SOURCE, MFAE_REF)
  using index 
  tablespace USERS
  pctfree 10
  initrans 2
  maxtrans 255;

prompt
prompt Creating table MIWTFACTUREENTETE_IMP
prompt ====================================
prompt
create table MIWTFACTUREENTETE_IMP
(
  mfae_source             VARCHAR2(100) not null,
  mfae_ref                VARCHAR2(100) not null,
  mfae_reftrf             VARCHAR2(100),
  mfae_nume               NUMBER(10),
  mfae_rdet               VARCHAR2(15),
  mfae_ccmo               VARCHAR2(1),
  mfae_dedi               DATE not null,
  mfae_dlpai              DATE,
  mfae_dprel              DATE,
  mfae_tothte             NUMBER(10,2) not null,
  mfae_tottvae            NUMBER(10,2) not null,
  mfae_tothta             NUMBER(10,2) not null,
  mfae_tottvaa            NUMBER(10,2) not null,
  mfae_solde              NUMBER(10,2),
  mfae_type               VARCHAR2(2) default 'R' not null,
  mfae_reffaededu         VARCHAR2(100),
  mfae_refabn             VARCHAR2(100) not null,
  mfae_ref_codniv_relance VARCHAR2(100),
  mfae_rib_ref            VARCHAR2(100),
  mfae_rib_etat           NUMBER(1),
  mfae_compteaux          VARCHAR2(100),
  mfae_ref_origine        VARCHAR2(100),
  mfae_comment            VARCHAR2(4000),
  mfae_amountttcdec       NUMBER(17,10),
  voc_modefact            VARCHAR2(10),
  mfae_ref_deduc          VARCHAR2(100),
  mfae_reforga            VARCHAR2(100),
  mfae_exercice           NUMBER(4),
  mfae_numerorole         NUMBER(4),
  mfae_prel               NUMBER,
  mfae_arond              NUMBER,
  bil_id                  NUMBER,
  rec_id                  NUMBER,
  red_id                  NUMBER,
  deb_id                  NUMBER
)
tablespace MIG61
  pctfree 10
  initrans 1
  maxtrans 255;

prompt
prompt Creating table MIWTFACTUREENTETE_SAVE
prompt =====================================
prompt
create table MIWTFACTUREENTETE_SAVE
(
  mfae_source             VARCHAR2(100) not null,
  mfae_ref                VARCHAR2(100) not null,
  mfae_reftrf             VARCHAR2(100),
  mfae_nume               NUMBER(10),
  mfae_rdet               VARCHAR2(15),
  mfae_ccmo               VARCHAR2(1),
  mfae_dedi               DATE not null,
  mfae_dlpai              DATE,
  mfae_dprel              DATE,
  mfae_tothte             NUMBER(15,3) not null,
  mfae_tottvae            NUMBER(15,3) not null,
  mfae_tothta             NUMBER(15,3) not null,
  mfae_tottvaa            NUMBER(15,3) not null,
  mfae_solde              NUMBER(15,3),
  mfae_type               VARCHAR2(2) not null,
  mfae_reffaededu         VARCHAR2(100),
  mfae_refabn             VARCHAR2(100) not null,
  mfae_ref_codniv_relance VARCHAR2(100),
  mfae_rib_ref            VARCHAR2(100),
  mfae_rib_etat           NUMBER(1),
  mfae_compteaux          VARCHAR2(100),
  mfae_ref_origine        VARCHAR2(100),
  mfae_comment            VARCHAR2(4000),
  mfae_amountttcdec       NUMBER(17,10),
  voc_modefact            VARCHAR2(10),
  mfae_ref_deduc          VARCHAR2(100),
  mfae_reforga            VARCHAR2(100),
  mfae_exercice           NUMBER(4),
  mfae_numerorole         NUMBER(4),
  mfae_prel               NUMBER,
  mfae_arond              NUMBER,
  bil_id                  NUMBER,
  rec_id                  NUMBER,
  red_id                  NUMBER,
  deb_id                  NUMBER,
  mrel_ref                NUMBER
)
tablespace MIG61
  pctfree 10
  initrans 1
  maxtrans 255;

prompt
prompt Creating table MIWTFACTUREENTETE_SAVE2016
prompt =========================================
prompt
create table MIWTFACTUREENTETE_SAVE2016
(
  mfae_source             VARCHAR2(100) not null,
  mfae_ref                VARCHAR2(100) not null,
  mfae_reftrf             VARCHAR2(100),
  mfae_nume               NUMBER(10),
  mfae_rdet               VARCHAR2(15),
  mfae_ccmo               VARCHAR2(1),
  mfae_dedi               DATE not null,
  mfae_dlpai              DATE,
  mfae_dprel              DATE,
  mfae_tothte             NUMBER(10,2) not null,
  mfae_tottvae            NUMBER(10,2) not null,
  mfae_tothta             NUMBER(10,2) not null,
  mfae_tottvaa            NUMBER(10,2) not null,
  mfae_solde              NUMBER(10,2),
  mfae_type               VARCHAR2(2) not null,
  mfae_reffaededu         VARCHAR2(100),
  mfae_refabn             VARCHAR2(100) not null,
  mfae_ref_codniv_relance VARCHAR2(100),
  mfae_rib_ref            VARCHAR2(100),
  mfae_rib_etat           NUMBER(1),
  mfae_compteaux          VARCHAR2(100),
  mfae_ref_origine        VARCHAR2(100),
  mfae_comment            VARCHAR2(4000),
  mfae_amountttcdec       NUMBER(17,10),
  voc_modefact            VARCHAR2(10),
  mfae_ref_deduc          VARCHAR2(100),
  mfae_reforga            VARCHAR2(100),
  mfae_exercice           NUMBER(4),
  mfae_numerorole         NUMBER(4),
  mfae_prel               NUMBER,
  mfae_arond              NUMBER,
  bil_id                  NUMBER,
  rec_id                  NUMBER,
  red_id                  NUMBER,
  deb_id                  NUMBER
)
tablespace MIG61
  pctfree 10
  initrans 1
  maxtrans 255;

prompt
prompt Creating table MIWTFACTURELIGNE
prompt ===============================
prompt
create table MIWTFACTURELIGNE
(
  mfal_source     VARCHAR2(100) not null,
  mfal_reffae     VARCHAR2(100) not null,
  mfal_reftap     VARCHAR2(100) not null,
  mfal_refart     VARCHAR2(100),
  mfal_libe       VARCHAR2(200),
  mfal_num        NUMBER(4) not null,
  mfal_tran       NUMBER(1) default 1 not null,
  mfal_exer       NUMBER(4) not null,
  mfal_volu       NUMBER(15,3) not null,
  mfal_pu         NUMBER(12,6) not null,
  mfal_mtht       NUMBER(15,3) not null,
  mfal_mtva       NUMBER(15,3) not null,
  mfal_ttva       NUMBER(15,3) not null,
  mfal_mttc       NUMBER(15,3) not null,
  mfal_ddebperfac DATE,
  mfal_dfinperfac DATE,
  mfal_detail     NUMBER
)
tablespace MIG61
  pctfree 10
  initrans 1
  maxtrans 255
  storage
  (
    initial 64K
    next 1M
    minextents 1
    maxextents unlimited
  );
comment on table MIWTFACTURELIGNE
  is 'Table Pivot des lignes de facture';
comment on column MIWTFACTURELIGNE.mfal_source
  is 'Code source/origine de la ligne [OBL]';
comment on column MIWTFACTURELIGNE.mfal_reffae
  is 'Identifiant de la facture de la ligne [OBL]';
comment on column MIWTFACTURELIGNE.mfal_reftap
  is 'Identifiant de la période de tarif de la ligne [OBL]';
comment on column MIWTFACTURELIGNE.mfal_tran
  is 'Tranche de la ligne [OBL]';
comment on column MIWTFACTURELIGNE.mfal_exer
  is 'Année exercice de la ligne [OBL]';
comment on column MIWTFACTURELIGNE.mfal_volu
  is 'Volume facturé de la ligne [OBL]';
comment on column MIWTFACTURELIGNE.mfal_pu
  is 'P.U. facturé de la ligne [OBL]';
comment on column MIWTFACTURELIGNE.mfal_mtht
  is 'Montant HT de la ligne [OBL]';
comment on column MIWTFACTURELIGNE.mfal_mtva
  is 'Montant TVA de la ligne [OBL]';
comment on column MIWTFACTURELIGNE.mfal_ttva
  is 'Taux de TVA de la ligne [OBL]';
comment on column MIWTFACTURELIGNE.mfal_ddebperfac
  is 'Date de début de la période facturée de la ligne';
comment on column MIWTFACTURELIGNE.mfal_dfinperfac
  is 'Date de fin de la période facturée de la ligne';
create index INDEX_FACLIGNE_GMF on MIWTFACTURELIGNE (MFAL_REFFAE)
  tablespace USERS
  pctfree 10
  initrans 2
  maxtrans 255
  storage
  (
    initial 64K
    next 1M
    minextents 1
    maxextents unlimited
  );
create index INDEX_MFAL_DDEBPERFAC on MIWTFACTURELIGNE (MFAL_DDEBPERFAC)
  tablespace USERS
  pctfree 10
  initrans 2
  maxtrans 255
  storage
  (
    initial 64K
    next 1M
    minextents 1
    maxextents unlimited
  );
create index INDEX_MFAL_REFFAE on MIWTFACTURELIGNE (MFAL_REFFAE, MFAL_NUM, MFAL_REFART, MFAL_REFTAP)
  tablespace USERS
  pctfree 10
  initrans 2
  maxtrans 255
  storage
  (
    initial 64K
    next 1M
    minextents 1
    maxextents unlimited
  );
alter table MIWTFACTURELIGNE
  add constraint PK_MIWTFACTURELIGNE primary key (MFAL_SOURCE, MFAL_REFFAE, MFAL_NUM)
  using index 
  tablespace USERS
  pctfree 10
  initrans 2
  maxtrans 255
  storage
  (
    initial 64K
    next 1M
    minextents 1
    maxextents unlimited
  );

prompt
prompt Creating table MIWTFACTURELIGNE_SAVE
prompt ====================================
prompt
create table MIWTFACTURELIGNE_SAVE
(
  mfal_source     VARCHAR2(100) not null,
  mfal_reffae     VARCHAR2(100) not null,
  mfal_reftap     VARCHAR2(100) not null,
  mfal_refart     VARCHAR2(100),
  mfal_libe       VARCHAR2(200),
  mfal_num        NUMBER(4) not null,
  mfal_tran       NUMBER(1) not null,
  mfal_exer       NUMBER(4) not null,
  mfal_volu       NUMBER(15,3) not null,
  mfal_pu         NUMBER(12,6) not null,
  mfal_mtht       NUMBER(15,3) not null,
  mfal_mtva       NUMBER(15,3) not null,
  mfal_ttva       NUMBER(15,3) not null,
  mfal_mttc       NUMBER(15,3) not null,
  mfal_ddebperfac DATE,
  mfal_dfinperfac DATE,
  mfal_detail     NUMBER
)
tablespace MIG61
  pctfree 10
  initrans 1
  maxtrans 255;

prompt
prompt Creating table MIWTFACTURELIGNE_SAVE2016
prompt ========================================
prompt
create table MIWTFACTURELIGNE_SAVE2016
(
  mfal_source     VARCHAR2(100) not null,
  mfal_reffae     VARCHAR2(100) not null,
  mfal_reftap     VARCHAR2(100) not null,
  mfal_refart     VARCHAR2(100),
  mfal_libe       VARCHAR2(200),
  mfal_num        NUMBER(4) not null,
  mfal_tran       NUMBER(1) not null,
  mfal_exer       NUMBER(4) not null,
  mfal_volu       NUMBER(15,3) not null,
  mfal_pu         NUMBER(12,6) not null,
  mfal_mtht       NUMBER(15,2) not null,
  mfal_mtva       NUMBER(15,2) not null,
  mfal_ttva       NUMBER(15,2) not null,
  mfal_mttc       NUMBER(15,2) not null,
  mfal_ddebperfac DATE,
  mfal_dfinperfac DATE,
  mfal_detail     NUMBER
)
tablespace MIG61
  pctfree 10
  initrans 1
  maxtrans 255;

prompt
prompt Creating table MIWTFAIRESUIVRE
prompt ==============================
prompt
create table MIWTFAIRESUIVRE
(
  mfs_source  VARCHAR2(20) not null,
  mfs_ref     VARCHAR2(20) not null,
  mfs_refe    VARCHAR2(20),
  mfs_ref_adr VARCHAR2(20),
  par_id      NUMBER,
  paa_id      NUMBER,
  adr_id      NUMBER,
  mfs_refpdl  VARCHAR2(20)
)
tablespace MIG61
  pctfree 10
  initrans 1
  maxtrans 255
  storage
  (
    initial 64K
    next 1M
    minextents 1
    maxextents unlimited
  );

prompt
prompt Creating table MIWTGF
prompt =====================
prompt
create table MIWTGF
(
  mgf_source       VARCHAR2(100) not null,
  mgf_ref          VARCHAR2(100) not null,
  mgf_lib          VARCHAR2(100) not null,
  mgf_dat1         DATE,
  mgf_mod1         VARCHAR2(100),
  mgf_dat2         DATE,
  mgf_mod2         VARCHAR2(100),
  mgf_dat3         DATE,
  mgf_mod3         VARCHAR2(100),
  mgf_dat4         DATE,
  mgf_mod4         VARCHAR2(100),
  mgf_dat5         DATE,
  mgf_mod5         VARCHAR2(100),
  mgf_dat6         DATE,
  mgf_mod6         VARCHAR2(100),
  mgf_dat7         DATE,
  mgf_mod7         VARCHAR2(100),
  mgf_dat8         DATE,
  mgf_mod8         VARCHAR2(100),
  mgf_dat9         DATE,
  mgf_mod9         VARCHAR2(100),
  mgf_dat10        DATE,
  mgf_mod10        VARCHAR2(100),
  mgf_dat11        DATE,
  mgf_mod11        VARCHAR2(100),
  mgf_dat12        DATE,
  mgf_mod12        VARCHAR2(100),
  mgf_abndt1       DATE,
  mgf_abndt2       DATE,
  mgf_abndt3       DATE,
  mgf_abndt4       DATE,
  mgf_abndt5       DATE,
  mgf_abndt6       DATE,
  mgf_abndt7       DATE,
  mgf_abndt8       DATE,
  mgf_abndt9       DATE,
  mgf_abndt10      DATE,
  mgf_abndt11      DATE,
  mgf_abndt12      DATE,
  mgf_abnmensudt1  DATE,
  mgf_abnmensudt2  DATE,
  mgf_abnmensudt3  DATE,
  mgf_abnmensudt4  DATE,
  mgf_abnmensudt5  DATE,
  mgf_abnmensudt6  DATE,
  mgf_abnmensudt7  DATE,
  mgf_abnmensudt8  DATE,
  mgf_abnmensudt9  DATE,
  mgf_abnmensudt10 DATE,
  mgf_abnmensudt11 DATE,
  mgf_abnmensudt12 DATE,
  mgf_decmensu1    NUMBER(1),
  mgf_decmensu2    NUMBER(1),
  mgf_decmensu3    NUMBER(1),
  mgf_decmensu4    NUMBER(1),
  mgf_decmensu5    NUMBER(1),
  mgf_decmensu6    NUMBER(1),
  mgf_decmensu7    NUMBER(1),
  mgf_decmensu8    NUMBER(1),
  mgf_decmensu9    NUMBER(1),
  mgf_decmensu10   NUMBER(1),
  mgf_decmensu11   NUMBER(1),
  mgf_decmensu12   NUMBER(1)
)
tablespace MIG61
  pctfree 10
  initrans 1
  maxtrans 255;
comment on table MIWTGF
  is 'Table Pivot Groupe de Facturation';
comment on column MIWTGF.mgf_source
  is 'Code source/origine de groupe de  facturation [OBL]';
comment on column MIWTGF.mgf_ref
  is 'Identifiant unique de Groupe de facturaion  pour la source [OBL]';
comment on column MIWTGF.mgf_lib
  is 'Libellé groupe facturation';
comment on column MIWTGF.mgf_dat1
  is ' Date de facturation1';
comment on column MIWTGF.mgf_mod1
  is ' Mode de facturation 1';
comment on column MIWTGF.mgf_dat2
  is ' Date de facturation2';
comment on column MIWTGF.mgf_mod2
  is ' Mode de facturation é';
comment on column MIWTGF.mgf_dat3
  is ' Date de facturation3';
comment on column MIWTGF.mgf_mod3
  is ' Mode de facturation 3';
comment on column MIWTGF.mgf_dat4
  is ' Date de facturation4';
comment on column MIWTGF.mgf_mod4
  is ' Mode de facturation 4';
comment on column MIWTGF.mgf_dat5
  is ' Date de facturation5';
comment on column MIWTGF.mgf_mod5
  is ' Mode de facturation 5';
comment on column MIWTGF.mgf_dat6
  is ' Date de facturation6';
comment on column MIWTGF.mgf_mod6
  is ' Mode de facturation 6';
comment on column MIWTGF.mgf_dat7
  is ' Date de facturation7';
comment on column MIWTGF.mgf_mod7
  is ' Mode de facturation 7';
comment on column MIWTGF.mgf_dat8
  is ' Date de facturation8';
comment on column MIWTGF.mgf_mod8
  is ' Mode de facturation 8';
comment on column MIWTGF.mgf_dat9
  is ' Date de facturation9';
comment on column MIWTGF.mgf_mod9
  is ' Mode de facturation 9';
comment on column MIWTGF.mgf_dat10
  is ' Date de facturation10';
comment on column MIWTGF.mgf_mod10
  is ' Mode de facturation 10';
comment on column MIWTGF.mgf_dat11
  is ' Date de facturation11';
comment on column MIWTGF.mgf_mod11
  is ' Mode de facturation 11';
comment on column MIWTGF.mgf_dat12
  is ' Date de facturation12';
comment on column MIWTGF.mgf_mod12
  is ' Mode de facturation 12';
comment on column MIWTGF.mgf_abndt1
  is 'Date fin periode abonnement1';
comment on column MIWTGF.mgf_abndt2
  is 'Date fin periode abonnement2';
comment on column MIWTGF.mgf_abndt3
  is 'Date fin periode abonnement3';
comment on column MIWTGF.mgf_abndt4
  is 'Date fin periode abonnement4';
comment on column MIWTGF.mgf_abndt5
  is 'Date fin periode abonnement5';
comment on column MIWTGF.mgf_abndt6
  is 'Date fin periode abonnement6';
comment on column MIWTGF.mgf_abndt7
  is 'Date fin periode abonnement7';
comment on column MIWTGF.mgf_abndt8
  is 'Date fin periode abonnement8';
comment on column MIWTGF.mgf_abndt9
  is 'Date fin periode abonnement9';
comment on column MIWTGF.mgf_abndt10
  is 'Date fin periode abonnement10';
comment on column MIWTGF.mgf_abnmensudt1
  is 'Date fin periode abonnement1 mensu ';
comment on column MIWTGF.mgf_abnmensudt2
  is 'Date fin periode abonnement2 mensu';
comment on column MIWTGF.mgf_abnmensudt3
  is 'Date fin periode abonnement3 mensu';
comment on column MIWTGF.mgf_abnmensudt4
  is 'Date fin periode abonnement4 mensu ';
comment on column MIWTGF.mgf_abnmensudt5
  is 'Date fin periode abonnement5 mensu';
comment on column MIWTGF.mgf_abnmensudt6
  is 'Date fin periode abonnement6 mensu ';
comment on column MIWTGF.mgf_abnmensudt7
  is 'Date fin periode abonnement7 mensu';
comment on column MIWTGF.mgf_abnmensudt8
  is 'Date fin periode abonnement8 mensu';
comment on column MIWTGF.mgf_abnmensudt9
  is 'Date fin periode abonnement9 mensu';
comment on column MIWTGF.mgf_abnmensudt10
  is 'Date fin periode abonnement10 mensu';
comment on column MIWTGF.mgf_decmensu1
  is ' 1: Décompte Mensu à prévoir lors de la facturation,0 sinon';
comment on column MIWTGF.mgf_decmensu2
  is ' 1: Décompte Mensu à prévoir lors de la facturation,0 sinon';
comment on column MIWTGF.mgf_decmensu3
  is ' 1: Décompte Mensu à prévoir lors de la facturation,0 sinon';
comment on column MIWTGF.mgf_decmensu4
  is ' 1: Décompte Mensu à prévoir lors de la facturation,0 sinon';
comment on column MIWTGF.mgf_decmensu5
  is ' 1: Décompte Mensu à prévoir lors de la facturation,0 sinon';
comment on column MIWTGF.mgf_decmensu6
  is ' 1: Décompte Mensu à prévoir lors de la facturation,0 sinon';
comment on column MIWTGF.mgf_decmensu7
  is ' 1: Décompte Mensu à prévoir lors de la facturation,0 sinon';
comment on column MIWTGF.mgf_decmensu8
  is ' 1: Décompte Mensu à prévoir lors de la facturation,0 sinon';
comment on column MIWTGF.mgf_decmensu9
  is ' 1: Décompte Mensu à prévoir lors de la facturation,0 sinon';
comment on column MIWTGF.mgf_decmensu10
  is ' 1: Décompte Mensu à prévoir lors de la facturation,0 sinon';
comment on column MIWTGF.mgf_decmensu11
  is ' 1: Décompte Mensu à prévoir lors de la facturation,0 sinon';
comment on column MIWTGF.mgf_decmensu12
  is ' 1: Décompte Mensu à prévoir lors de la facturation,0 sinon';
alter table MIWTGF
  add constraint PK_MIWTGF primary key (MGF_SOURCE, MGF_REF)
  using index 
  tablespace USERS
  pctfree 10
  initrans 2
  maxtrans 255;

prompt
prompt Creating table MIWT_GROUPE_EDITION
prompt ==================================
prompt
create table MIWT_GROUPE_EDITION
(
  grp_source  VARCHAR2(100) not null,
  grp_code    VARCHAR2(64) not null,
  grp_ref_abn VARCHAR2(100) not null
)
tablespace MIG61
  pctfree 10
  initrans 1
  maxtrans 255;
comment on column MIWT_GROUPE_EDITION.grp_source
  is 'Source';
comment on column MIWT_GROUPE_EDITION.grp_code
  is 'libelle associe au regroupement de l abonnement pour son regroupement sur edition';
comment on column MIWT_GROUPE_EDITION.grp_ref_abn
  is 'Identifiant de l abonnement';
alter table MIWT_GROUPE_EDITION
  add constraint PK_MIWT_GROUPE_EDITION primary key (GRP_SOURCE, GRP_CODE, GRP_REF_ABN)
  using index 
  tablespace USERS
  pctfree 10
  initrans 2
  maxtrans 255;

prompt
prompt Creating table MIWTHISTOCPT
prompt ===========================
prompt
create table MIWTHISTOCPT
(
  mhpc_source    VARCHAR2(100) not null,
  mhpc_refcom    VARCHAR2(100) not null,
  mhpc_refpdl    VARCHAR2(100) not null,
  voc_reaspose   VARCHAR2(100),
  mhpc_agesource VARCHAR2(100),
  mhpc_ddeb      DATE not null,
  mhpc_dfin      DATE,
  voc_id         NUMBER,
  age_id         NUMBER,
  voc_reasdepose VARCHAR2(100),
  voc_dep_id     NUMBER,
  nb_ligne       NUMBER,
  index_depart   NUMBER,
  index_arret    NUMBER
)
tablespace MIG61
  pctfree 10
  initrans 1
  maxtrans 255
  storage
  (
    initial 64K
    next 1M
    minextents 1
    maxextents unlimited
  );
comment on table MIWTHISTOCPT
  is 'Migration PIVOT : les historiques pose-dépose compteurs';
comment on column MIWTHISTOCPT.mhpc_source
  is 'Identifiant de la source de données [OBL]';
comment on column MIWTHISTOCPT.mhpc_refcom
  is 'Référence du compteur dans le SI source [OBL]';
comment on column MIWTHISTOCPT.mhpc_refpdl
  is 'Référence du PDl dans le SI source (le triplet source/référence PDl/ compteur doit être UNIQUE) [OBL]';
comment on column MIWTHISTOCPT.mhpc_ddeb
  is 'Date de pose du compteur [OBL]';
comment on column MIWTHISTOCPT.mhpc_dfin
  is 'Date de dépose du compteur';
create index INDEX_H_CPT on MIWTHISTOCPT (SUBSTR(MHPC_REFPDL,1,8))
  tablespace USERS
  pctfree 10
  initrans 2
  maxtrans 255
  storage
  (
    initial 64K
    next 1M
    minextents 1
    maxextents unlimited
  );
create unique index I_U_MIWTHISTOCPT_PK on MIWTHISTOCPT (MHPC_SOURCE, MHPC_REFCOM, MHPC_REFPDL, MHPC_DDEB)
  tablespace USERS
  pctfree 10
  initrans 2
  maxtrans 255
  storage
  (
    initial 64K
    next 1M
    minextents 1
    maxextents unlimited
  );

prompt
prompt Creating table MIWTHISTOCPT_SAVE
prompt ================================
prompt
create table MIWTHISTOCPT_SAVE
(
  mhpc_source    VARCHAR2(100) not null,
  mhpc_refcom    VARCHAR2(100) not null,
  mhpc_refpdl    VARCHAR2(100) not null,
  voc_reaspose   VARCHAR2(100),
  mhpc_agesource VARCHAR2(100),
  mhpc_ddeb      DATE not null,
  mhpc_dfin      DATE,
  voc_id         NUMBER,
  age_id         NUMBER,
  voc_reasdepose VARCHAR2(100),
  voc_dep_id     NUMBER,
  nb_ligne       NUMBER,
  index_depart   NUMBER,
  index_arret    NUMBER
)
tablespace MIG61
  pctfree 10
  initrans 1
  maxtrans 255;

prompt
prompt Creating table MIWTHISTOCPT_SBO
prompt ===============================
prompt
create table MIWTHISTOCPT_SBO
(
  mhpc_source    VARCHAR2(100) not null,
  mhpc_refcom    VARCHAR2(100) not null,
  mhpc_refpdl    VARCHAR2(100) not null,
  voc_reaspose   VARCHAR2(100),
  mhpc_agesource VARCHAR2(100),
  mhpc_ddeb      DATE not null,
  mhpc_dfin      DATE,
  voc_id         NUMBER,
  age_id         NUMBER,
  voc_reasdepose VARCHAR2(100),
  voc_dep_id     NUMBER,
  nb_ligne       NUMBER,
  index_depart   NUMBER,
  index_arret    NUMBER,
  trim           NUMBER,
  annee          NUMBER,
  mhpc_comlib    VARCHAR2(200)
)
tablespace MIG61
  pctfree 10
  initrans 1
  maxtrans 255;
create index IDX_MIWTHISTOCPT_SBO on MIWTHISTOCPT_SBO (MHPC_SOURCE, VOC_REASPOSE)
  tablespace USERS
  pctfree 10
  initrans 2
  maxtrans 255;
create index IDX_MIWTHISTOCPT_SBO1 on MIWTHISTOCPT_SBO (TO_CHAR(ANNEE)||TO_CHAR(TRIM), MHPC_REFPDL, VOC_REASPOSE)
  tablespace USERS
  pctfree 10
  initrans 2
  maxtrans 255;
create index IDX_MIWTHISTOCPT_SBO2 on MIWTHISTOCPT_SBO (MHPC_SOURCE, VOC_REASDEPOSE)
  tablespace USERS
  pctfree 10
  initrans 2
  maxtrans 255;

prompt
prompt Creating table MIWTHISTOCPT_SBO1
prompt ================================
prompt
create table MIWTHISTOCPT_SBO1
(
  mhpc_source    VARCHAR2(100) not null,
  mhpc_refcom    VARCHAR2(100) not null,
  mhpc_refpdl    VARCHAR2(100) not null,
  voc_reaspose   VARCHAR2(100),
  mhpc_agesource VARCHAR2(100),
  mhpc_ddeb      DATE not null,
  mhpc_dfin      DATE,
  voc_id         NUMBER,
  age_id         NUMBER,
  voc_reasdepose VARCHAR2(100),
  voc_dep_id     NUMBER,
  nb_ligne       NUMBER,
  index_depart   NUMBER,
  index_arret    NUMBER,
  trim           NUMBER,
  annee          NUMBER
)
tablespace MIG61
  pctfree 10
  initrans 1
  maxtrans 255;

prompt
prompt Creating table MIWTHISTOCPT_SKA
prompt ===============================
prompt
create table MIWTHISTOCPT_SKA
(
  mhpc_source    VARCHAR2(100) not null,
  mhpc_refcom    VARCHAR2(100) not null,
  mhpc_refpdl    VARCHAR2(100) not null,
  voc_reaspose   VARCHAR2(100),
  mhpc_agesource VARCHAR2(100),
  mhpc_ddeb      DATE not null,
  mhpc_dfin      DATE,
  voc_id         NUMBER,
  age_id         NUMBER,
  voc_reasdepose VARCHAR2(100),
  voc_dep_id     NUMBER,
  nb_ligne       NUMBER,
  index_depart   NUMBER,
  index_arret    NUMBER,
  trim           NUMBER,
  annee          NUMBER,
  mhpc_comlib    VARCHAR2(200)
)
tablespace MIG61
  pctfree 10
  initrans 1
  maxtrans 255;

prompt
prompt Creating table MIWTHISTOPAYEUR
prompt ==============================
prompt
create table MIWTHISTOPAYEUR
(
  mhpa_source      VARCHAR2(100) not null,
  mhpa_ref_abnt    VARCHAR2(100) not null,
  mhpa_ref_payeur  VARCHAR2(100) not null,
  mhpa_mrib_ref    VARCHAR2(100),
  mhpa_ddeb        DATE not null,
  mhpa_dfin        DATE,
  voc_settlemode   VARCHAR2(100),
  par_id           NUMBER,
  adr_id           NUMBER,
  pay_id           NUMBER,
  bap_id           NUMBER,
  mhpa_datcreation DATE
)
tablespace MIG61
  pctfree 10
  initrans 1
  maxtrans 255
  storage
  (
    initial 64K
    next 1M
    minextents 1
    maxextents unlimited
  );
comment on table MIWTHISTOPAYEUR
  is 'Table pivot des historiques Abonnement - la personne payeur ';
comment on column MIWTHISTOPAYEUR.mhpa_source
  is 'Code source/origine de la donnée';
comment on column MIWTHISTOPAYEUR.mhpa_ref_abnt
  is 'Clé source, identifiant de ribe';
comment on column MIWTHISTOPAYEUR.mhpa_ref_payeur
  is 'Clé source, identifiant la personne qui est le payeur';
comment on column MIWTHISTOPAYEUR.mhpa_ddeb
  is 'Date de debut du lien historisé [OBL]';
comment on column MIWTHISTOPAYEUR.mhpa_dfin
  is 'date de fin du lien historisé';
comment on column MIWTHISTOPAYEUR.voc_settlemode
  is 'Mode:Cheque, Tip, Prelevement, Mensu';
create index INDX_PAY_GMF on MIWTHISTOPAYEUR (MHPA_REF_ABNT, MHPA_SOURCE)
  tablespace USERS
  pctfree 10
  initrans 2
  maxtrans 255
  storage
  (
    initial 64K
    next 1M
    minextents 1
    maxextents unlimited
  );
alter table MIWTHISTOPAYEUR
  add constraint PK_MIWTHISTOPAYEUR primary key (MHPA_SOURCE, MHPA_REF_ABNT, MHPA_REF_PAYEUR)
  using index 
  tablespace USERS
  pctfree 10
  initrans 2
  maxtrans 255
  storage
  (
    initial 64K
    next 1M
    minextents 1
    maxextents unlimited
  );

prompt
prompt Creating table MIWTHISTOPAYEUR_SAVE
prompt ===================================
prompt
create table MIWTHISTOPAYEUR_SAVE
(
  mhpa_source      VARCHAR2(100) not null,
  mhpa_ref_abnt    VARCHAR2(100) not null,
  mhpa_ref_payeur  VARCHAR2(100) not null,
  mhpa_mrib_ref    VARCHAR2(100),
  mhpa_ddeb        DATE not null,
  mhpa_dfin        DATE,
  voc_settlemode   VARCHAR2(100),
  par_id           NUMBER,
  adr_id           NUMBER,
  pay_id           NUMBER,
  bap_id           NUMBER,
  mhpa_datcreation DATE
)
tablespace MIG61
  pctfree 10
  initrans 1
  maxtrans 255;

prompt
prompt Creating table MIWTLTIGE
prompt ========================
prompt
create table MIWTLTIGE
(
  mltige_source   VARCHAR2(100) not null,
  mltige_reffae   VARCHAR2(100) not null,
  voc_contest     VARCHAR2(100) not null,
  mltige_exclurec NUMBER(1),
  mltige_exlusld  NUMBER(1),
  mltige_debut    DATE,
  mltige_fin      DATE
)
tablespace MIG61
  pctfree 10
  initrans 1
  maxtrans 255;
comment on table MIWTLTIGE
  is 'Table Pivot lITIGE';
comment on column MIWTLTIGE.mltige_source
  is 'Code source/origine de litige de la facture [OBL]';
comment on column MIWTLTIGE.mltige_reffae
  is 'Identifiant unique de litige pour la source [OBL]';
comment on column MIWTLTIGE.voc_contest
  is 'Liste des vocabulaires des litiges sur dettes (ex: Reclamation, surendettement temporaire...)';
comment on column MIWTLTIGE.mltige_exclurec
  is '1 :indicateur Exclu de relance, 0 si non';
comment on column MIWTLTIGE.mltige_exlusld
  is '1 :indicateur Exclu du rappel de solde, 0 si non';
comment on column MIWTLTIGE.mltige_debut
  is 'date de debut du litige';
comment on column MIWTLTIGE.mltige_fin
  is 'date de fin du litige';
alter table MIWTLTIGE
  add constraint PK_MIWTLTIGE primary key (MLTIGE_SOURCE, MLTIGE_REFFAE, VOC_CONTEST)
  using index 
  tablespace USERS
  pctfree 10
  initrans 2
  maxtrans 255;
alter table MIWTLTIGE
  add constraint FK_MIWTLTIGE_MLTIGE_REFFAE foreign key (MLTIGE_SOURCE, MLTIGE_REFFAE)
  references MIWTFACTUREENTETE (MFAE_SOURCE, MFAE_REF);

prompt
prompt Creating table MIWTMENSUALISATION
prompt =================================
prompt
create table MIWTMENSUALISATION
(
  mmensu_source      VARCHAR2(100) not null,
  mmensu_ref         VARCHAR2(100) not null,
  mmensu_refabn      VARCHAR2(100) not null,
  mmensu_num         NUMBER(2) not null,
  mmensu_montant     NUMBER(15,3) not null,
  mmensu_date        DATE not null,
  mmensu_commentaire VARCHAR2(4000),
  mmensu_restantdu   NUMBER(15,3) not null,
  mmensu_reffae      VARCHAR2(100),
  mmensu_type        VARCHAR2(1) default 'A'--decompte/Acompte
)
tablespace MIG61
  pctfree 10
  initrans 1
  maxtrans 255;
comment on table MIWTMENSUALISATION
  is 'Table Pivot MENSUALISATION';
comment on column MIWTMENSUALISATION.mmensu_source
  is 'Code source/origine de la mensualisation [OBL]';
comment on column MIWTMENSUALISATION.mmensu_ref
  is 'Identifiant unique de la mensualisation ';
comment on column MIWTMENSUALISATION.mmensu_refabn
  is 'Référence du ABN dans le SI source  ';
comment on column MIWTMENSUALISATION.mmensu_num
  is 'Ordre de l''échéance dans l''échéancier(obligatoire)';
comment on column MIWTMENSUALISATION.mmensu_montant
  is 'Montant de l''échéance(obligatoire)';
comment on column MIWTMENSUALISATION.mmensu_date
  is 'Date de l''échéance (obligatoire)';
comment on column MIWTMENSUALISATION.mmensu_restantdu
  is 'Restant dû de l''échéance(obligatoire)';
comment on column MIWTMENSUALISATION.mmensu_reffae
  is 'Référence du FACTURE dans le SI source  ';
alter table MIWTMENSUALISATION
  add constraint PK_MIG_MIWTMENSUALISATION primary key (MMENSU_SOURCE, MMENSU_REF)
  using index 
  tablespace USERS
  pctfree 10
  initrans 2
  maxtrans 255;
alter table MIWTMENSUALISATION
  add constraint FK_MIWTMENS_MMENSU_REFABN foreign key (MMENSU_SOURCE, MMENSU_REFABN)
  references MIWABN (ABN_SOURCE, ABN_REF);

prompt
prompt Creating table MIWTPDL_SAVE
prompt ===========================
prompt
create table MIWTPDL_SAVE
(
  pdl_source      VARCHAR2(100) not null,
  pdl_ref         VARCHAR2(100) not null,
  pdl_refbra      VARCHAR2(100),
  pdl_refadr      VARCHAR2(100) not null,
  pdl_reftou      VARCHAR2(100),
  pdl_refpde_pere VARCHAR2(100),
  pdl_type        VARCHAR2(1),
  pdl_touordre    NUMBER(10),
  pdl_refsite     VARCHAR2(100),
  voc_diffread    VARCHAR2(100),
  voc_access      VARCHAR2(100),
  voc_readinfo1   VARCHAR2(100),
  voc_readinfo2   VARCHAR2(100),
  voc_readinfo3   VARCHAR2(100),
  pdl_reffld      VARCHAR2(100),
  pdl_secteur_1   VARCHAR2(32),
  pdl_secteur_2   VARCHAR2(32),
  pdl_secteur_3   VARCHAR2(32),
  pdl_secteur_4   VARCHAR2(32),
  pdl_secteur_5   VARCHAR2(32),
  pdl_etat        VARCHAR2(1),
  pdl_detat       DATE,
  voc_methdep     VARCHAR2(100),
  pdl_comment     VARCHAR2(4000),
  pdl_refper_p    NUMBER(10),
  pdl_cbllenght   NUMBER(7,3),
  pdl_cblsection  NUMBER(6,3),
  voc_connat      VARCHAR2(100),
  voc_pmaxcon     VARCHAR2(100),
  pdl_riser       NUMBER(1),
  voc_constatus   VARCHAR2(10),
  spt_id          NUMBER,
  voc_premisetp   VARCHAR2(100),
  pre_id          NUMBER,
  adr_id          NUMBER,
  fld_id          NUMBER,
  rob_arret_av    VARCHAR2(1),
  rob_arret_ap    VARCHAR2(1),
  pdl_datcreation DATE
)
tablespace MIG61
  pctfree 10
  initrans 1
  maxtrans 255;

prompt
prompt Creating table MIWTPFA
prompt ======================
prompt
create table MIWTPFA
(
  mpfa_source      VARCHAR2(100) not null,
  mpfa_refpf       VARCHAR2(100) not null,
  mpfa_refabn      VARCHAR2(100) not null,
  mpfa_refart      VARCHAR2(100) not null,
  mpfa_corrvolume  NUMBER(10,2),
  mpfa_corrprix    NUMBER(10,2),
  mpfa_typecorr    NUMBER(10,2),
  mpfa_corrvolume1 NUMBER(10,2),
  mpfa_corrprix1   NUMBER(10,2),
  mpfa_typecorr1   NUMBER(10,2),
  pfa_commentaire  VARCHAR2(4000),
  pfa_codecadran   VARCHAR2(100) default 'EAU',
  pfa_corrtemp     NUMBER,
  pfa_temp         NUMBER,
  pfa_ddeb         DATE,
  pfa_dfin         DATE,
  pfa_corrpourvol  NUMBER(10,2),
  pfa_corrpourpri  NUMBER(10,2)
)
tablespace MIG61
  pctfree 10
  initrans 1
  maxtrans 255;
comment on table MIWTPFA
  is 'Table Pivot Profil  facturation';
comment on column MIWTPFA.mpfa_source
  is 'Code source/origine de profil  facturation [OBL]';
comment on column MIWTPFA.mpfa_refpf
  is 'Code de  profil  facturation';
comment on column MIWTPFA.mpfa_refabn
  is 'Référence du ABN dans le SI source  ';
comment on column MIWTPFA.mpfa_refart
  is 'Référence du article dans le SI source  ';
comment on column MIWTPFA.mpfa_corrvolume
  is 'Correction en volume de l''article pour cette profil facturation  ';
comment on column MIWTPFA.mpfa_corrprix
  is 'Correction en prix de l''article pour cette profil facturation  ';
comment on column MIWTPFA.mpfa_typecorr
  is 'type correctiobn (pourcentage ,impose,unitaire  ';
comment on column MIWTPFA.mpfa_corrvolume1
  is 'Correction en volume de l''article pour cette profil facturation  ';
comment on column MIWTPFA.mpfa_corrprix1
  is 'Correction en prix de l''article pour cette profil facturation  ';
comment on column MIWTPFA.mpfa_typecorr1
  is 'type correctiobn (pourcentage ,impose,unitaire  ';
comment on column MIWTPFA.pfa_commentaire
  is 'Commentaire libre Profil';
comment on column MIWTPFA.pfa_codecadran
  is 'Code cadran';
comment on column MIWTPFA.pfa_corrtemp
  is '0=permanante, 1=temporaire';
comment on column MIWTPFA.pfa_temp
  is ' 1: Article Temporaire; 0:Sinon ';
comment on column MIWTPFA.pfa_ddeb
  is 'date de debut Pour article Temp =1';
comment on column MIWTPFA.pfa_corrpourvol
  is 'Correction en Pourcentage sur volume ';
comment on column MIWTPFA.pfa_corrpourpri
  is 'Correction en Pourcentage sur prix';
alter table MIWTPFA
  add constraint PK_MIWTPFA primary key (MPFA_SOURCE, MPFA_REFPF)
  using index 
  tablespace USERS
  pctfree 10
  initrans 2
  maxtrans 255;
alter table MIWTPFA
  add constraint FK_MIWTPFA_MPFA_REFABN foreign key (MPFA_SOURCE, MPFA_REFABN)
  references MIWABN (ABN_SOURCE, ABN_REF);
alter table MIWTPFA
  add constraint FK_MIWTPFA_MPFA_REFART foreign key (MPFA_SOURCE, MPFA_REFART)
  references MIWTART (MART_SOURCE, MART_REFART);

prompt
prompt Creating table MIWTPRESTATION
prompt =============================
prompt
create table MIWTPRESTATION
(
  prst_source  VARCHAR2(100) not null,
  prst_refpres VARCHAR2(100) not null,
  prst_nom     VARCHAR2(100) not null,
  prst_fldcode VARCHAR2(100) not null,
  prst_fldname VARCHAR2(100),
  voc_fluid    VARCHAR2(100)
)
tablespace MIG61
  pctfree 10
  initrans 1
  maxtrans 255;
comment on table MIWTPRESTATION
  is ' Table Pivot Prestaion';
comment on column MIWTPRESTATION.prst_source
  is 'Code source/origine de Prestaion [OBL]';
comment on column MIWTPRESTATION.prst_refpres
  is 'Identifiant unique de Prestaion [OBL]';
comment on column MIWTPRESTATION.prst_nom
  is 'Nom de Prestaion';
comment on column MIWTPRESTATION.prst_fldcode
  is 'Code interne  type de fluide  ';
comment on column MIWTPRESTATION.prst_fldname
  is 'Nom de  type de fluide';
comment on column MIWTPRESTATION.voc_fluid
  is 'fluide';
alter table MIWTPRESTATION
  add constraint PK_MIWTPRESTATION primary key (PRST_SOURCE, PRST_REFPRES)
  using index 
  tablespace USERS
  pctfree 10
  initrans 2
  maxtrans 255;

prompt
prompt Creating table MIWTPRESART
prompt ==========================
prompt
create table MIWTPRESART
(
  prar_source  VARCHAR2(100) not null,
  prar_refpres VARCHAR2(100) not null,
  prar_refart  VARCHAR2(100) not null
)
tablespace MIG61
  pctfree 10
  initrans 1
  maxtrans 255;
comment on table MIWTPRESART
  is 'Table d''association Prestation/Article';
comment on column MIWTPRESART.prar_source
  is 'Identifiant de la source de données [OBL]';
comment on column MIWTPRESART.prar_refpres
  is 'Reference à la prestation';
comment on column MIWTPRESART.prar_refart
  is 'Reference à la prestation';
alter table MIWTPRESART
  add constraint PK_MIWTPRESART primary key (PRAR_REFPRES, PRAR_REFART)
  using index 
  tablespace USERS
  pctfree 10
  initrans 2
  maxtrans 255;
alter table MIWTPRESART
  add constraint FK__MIWTPRESARTREFART foreign key (PRAR_SOURCE, PRAR_REFART)
  references MIWTART (MART_SOURCE, MART_REFART);
alter table MIWTPRESART
  add constraint FK_MIWTPRESART_REFPRES foreign key (PRAR_SOURCE, PRAR_REFPRES)
  references MIWTPRESTATION (PRST_SOURCE, PRST_REFPRES);

prompt
prompt Creating table MIWTPROPRIETAIRE
prompt ===============================
prompt
create table MIWTPROPRIETAIRE
(
  pro_num         NUMBER(10) not null,
  pro_in_ins      VARCHAR2(20) not null,
  pro_cl_code     NVARCHAR2(20),
  pro_adm         VARCHAR2(4),
  pro_dt_debut    DATE not null,
  pro_dt_fin      DATE,
  pro_id          NUMBER(10),
  pro_datcreation DATE
)
tablespace MIG61
  pctfree 10
  initrans 1
  maxtrans 255
  storage
  (
    initial 64K
    next 1M
    minextents 1
    maxextents unlimited
  );
comment on table MIWTPROPRIETAIRE
  is 'Liste des proprietaires d''un site';
comment on column MIWTPROPRIETAIRE.pro_num
  is 'Identifiant unique';
comment on column MIWTPROPRIETAIRE.pro_in_ins
  is 'Identifiant de l''installation';
comment on column MIWTPROPRIETAIRE.pro_cl_code
  is 'Code du client ';
comment on column MIWTPROPRIETAIRE.pro_adm
  is 'Code du administration ';
comment on column MIWTPROPRIETAIRE.pro_dt_debut
  is 'date de début de propriété  (mettre une date bidon) (obligatoire)';
comment on column MIWTPROPRIETAIRE.pro_dt_fin
  is 'date de fin de propriété';

prompt
prompt Creating table MIWTPROPRIETAIRE_SAVE
prompt ====================================
prompt
create table MIWTPROPRIETAIRE_SAVE
(
  pro_num         NUMBER(10) not null,
  pro_in_ins      VARCHAR2(20) not null,
  pro_cl_code     NVARCHAR2(20),
  pro_adm         VARCHAR2(4),
  pro_dt_debut    DATE not null,
  pro_dt_fin      DATE,
  pro_id          NUMBER(10),
  pro_datcreation DATE
)
tablespace MIG61
  pctfree 10
  initrans 1
  maxtrans 255;

prompt
prompt Creating table MIWTRELANCE
prompt ==========================
prompt
create table MIWTRELANCE
(
  mrelance_source     VARCHAR2(100) not null,
  mrelance_refrel     VARCHAR2(100) not null,
  mrelance_libelle    VARCHAR2(100),
  mrelance_codeniveau VARCHAR2(20),
  mrelance_libniveau  VARCHAR2(100)
)
tablespace MIG61
  pctfree 10
  initrans 1
  maxtrans 255;
comment on table MIWTRELANCE
  is 'Table Pivot Chaine de relance';
comment on column MIWTRELANCE.mrelance_source
  is 'Code source/origine de chaine de relance [OBL]';
comment on column MIWTRELANCE.mrelance_refrel
  is 'Code de  chaine de relance ';
comment on column MIWTRELANCE.mrelance_libelle
  is 'libelle de chaine de relance ';
comment on column MIWTRELANCE.mrelance_codeniveau
  is 'Code niveau de chainde relance ';
comment on column MIWTRELANCE.mrelance_libniveau
  is 'libelle niveau de chainde relance ';
alter table MIWTRELANCE
  add constraint PK_MIWTRELANCE primary key (MRELANCE_SOURCE, MRELANCE_REFREL)
  using index 
  tablespace USERS
  pctfree 10
  initrans 2
  maxtrans 255;

prompt
prompt Creating table MIWTRELEVE
prompt =========================
prompt
create table MIWTRELEVE
(
  mrel_source        VARCHAR2(100) not null,
  mrel_ref           VARCHAR2(100) not null,
  mrel_refpdl        VARCHAR2(100),
  mrel_refcom        VARCHAR2(100),
  mrel_date          DATE not null,
  mrel_index1        NUMBER(10),
  mrel_index2        NUMBER(10),
  mrel_index3        NUMBER(10),
  mrel_index4        NUMBER(10),
  mrel_index5        NUMBER(10),
  mrel_index6        NUMBER(10),
  mrel_index7        NUMBER(10),
  mrel_index8        NUMBER(10),
  mrel_index9        NUMBER(10),
  mrel_index10       NUMBER(10),
  mrel_index11       NUMBER(10),
  mrel_index12       NUMBER(10),
  mrel_conso1        NUMBER(10),
  mrel_conso2        NUMBER(10),
  mrel_conso3        NUMBER(10),
  mrel_conso4        NUMBER(10),
  mrel_conso5        NUMBER(10),
  mrel_conso6        NUMBER(10),
  mrel_conso7        NUMBER(10),
  mrel_conso8        NUMBER(10),
  mrel_conso9        NUMBER(10),
  mrel_conso10       NUMBER(10),
  mrel_conso11       NUMBER(10),
  mrel_conso12       NUMBER(10),
  mrel_cadran1       VARCHAR2(6),
  mrel_cadran2       VARCHAR2(6),
  mrel_cadran3       VARCHAR2(6),
  mrel_cadran4       VARCHAR2(6),
  mrel_cadran5       VARCHAR2(6),
  mrel_cadran6       VARCHAR2(6),
  mrel_cadran7       VARCHAR2(6),
  mrel_cadran8       VARCHAR2(6),
  mrel_cadran9       VARCHAR2(6),
  mrel_cadran10      VARCHAR2(6),
  mrel_cadran11      VARCHAR2(6),
  mrel_cadran12      VARCHAR2(6),
  mrel_cadran_coff1  VARCHAR2(6),
  mrel_cadran_coff2  VARCHAR2(6),
  mrel_cadran_coff3  VARCHAR2(6),
  mrel_cadran_coff4  VARCHAR2(6),
  mrel_cadran_coff5  VARCHAR2(6),
  mrel_cadran_coff6  VARCHAR2(6),
  mrel_cadran_coff7  VARCHAR2(6),
  mrel_cadran_coff8  VARCHAR2(6),
  mrel_cadran_coff9  VARCHAR2(6),
  mrel_cadran_coff10 VARCHAR2(6),
  mrel_cadran_coff11 VARCHAR2(6),
  mrel_cadran_coff12 VARCHAR2(6),
  mrel_deduite       NUMBER(10),
  mrel_facturee      NUMBER(1) not null,
  voc_comm1          VARCHAR2(100),
  voc_comm2          VARCHAR2(100),
  voc_comm3          VARCHAR2(100),
  voc_readorig       VARCHAR2(100),
  voc_readcode       VARCHAR2(100),
  voc_readmeth       VARCHAR2(100),
  voc_readreason     VARCHAR2(100),
  mrel_agrtype       VARCHAR2(100),
  mrel_techtype      VARCHAR2(100),
  mrel_etatfact      VARCHAR2(100),
  mrel_comlibre      VARCHAR2(4000),
  mrel_agesource     VARCHAR2(100),
  mrel_ageref        VARCHAR2(100),
  mrel_fact1         VARCHAR2(100),
  mrel_fact2         VARCHAR2(100),
  mrel_subread       NUMBER default 0,
  mrel_conso_ref1    NUMBER,
  mrel_conso_ref2    NUMBER,
  mrel_conso_ref3    NUMBER,
  mrel_conso_ref4    NUMBER,
  mrel_conso_ref5    NUMBER,
  mrel_conso_ref6    NUMBER,
  mrel_conso_ref7    NUMBER,
  mrel_conso_ref8    NUMBER,
  mrel_conso_ref9    NUMBER,
  mrel_conso_ref10   NUMBER,
  mrel_conso_ref11   NUMBER,
  mrel_conso_ref12   NUMBER,
  mrel_ano_c1        VARCHAR2(2),
  mrel_ano_c2        VARCHAR2(2),
  mrel_ano_c3        VARCHAR2(2),
  mrel_ano_n1        VARCHAR2(2),
  mrel_ano_n2        VARCHAR2(2),
  mrel_ano_n3        VARCHAR2(2),
  mrel_ano_f1        VARCHAR2(2),
  mrel_ano_f2        VARCHAR2(2),
  mrel_ano_f3        VARCHAR2(2),
  periode            NUMBER,
  annee              NUMBER,
  mrd_id             NUMBER,
  mme_id1            NUMBER,
  mme_id2            NUMBER,
  mme_id3            NUMBER,
  mme_id4            NUMBER,
  mme_id5            NUMBER,
  mme_id6            NUMBER,
  meu_id1            NUMBER,
  meu_id2            NUMBER,
  meu_id3            NUMBER,
  meu_id4            NUMBER,
  meu_id5            NUMBER,
  meu_id6            NUMBER,
  mme_id             NUMBER,
  meu_id             NUMBER,
  spt_id             NUMBER,
  equ_id             NUMBER,
  age_id             NUMBER,
  mtc_id             NUMBER
)
tablespace MIG61
  pctfree 10
  initrans 1
  maxtrans 255
  storage
  (
    initial 64K
    next 1M
    minextents 1
    maxextents unlimited
  );
create index IDX_MIWTRELEVE on MIWTRELEVE (SUBSTR(MREL_REFPDL,1,8), MREL_REFPDL, MREL_FACT1, ANNEE, PERIODE)
  tablespace USERS
  pctfree 10
  initrans 2
  maxtrans 255
  storage
  (
    initial 64K
    next 1M
    minextents 1
    maxextents unlimited
  );
create index IDX_MIWTRELEVE1 on MIWTRELEVE (MREL_REFPDL, ANNEE, PERIODE)
  tablespace USERS
  pctfree 10
  initrans 2
  maxtrans 255
  storage
  (
    initial 64K
    next 1M
    minextents 1
    maxextents unlimited
  );
create index IDX_MIWTRELEVE2 on MIWTRELEVE (MREL_FACT1)
  tablespace USERS
  pctfree 10
  initrans 2
  maxtrans 255
  storage
  (
    initial 64K
    next 1M
    minextents 1
    maxextents unlimited
  );
create index IDX_MIWTRELEVE3 on MIWTRELEVE (EQU_ID)
  tablespace USERS
  pctfree 10
  initrans 2
  maxtrans 255
  storage
  (
    initial 64K
    next 1M
    minextents 1
    maxextents unlimited
  );
create index IDX_MIWTRELEVE4 on MIWTRELEVE (SUBSTR(MREL_REFPDL,1,8)||TO_CHAR(ANNEE)||LPAD(TO_CHAR(PERIODE),2,'0'))
  tablespace USERS
  pctfree 10
  initrans 2
  maxtrans 255
  storage
  (
    initial 64K
    next 1M
    minextents 1
    maxextents unlimited
  );
create index INDX_MIWTRELEVE10 on MIWTRELEVE (MREL_REF)
  tablespace USERS
  pctfree 10
  initrans 2
  maxtrans 255
  storage
  (
    initial 64K
    next 1M
    minextents 1
    maxextents unlimited
  );
create index INDX_MIWTRELEVE5 on MIWTRELEVE (SUBSTR(MREL_REFPDL,1,8), TO_CHAR(ANNEE), LPAD(TO_CHAR(PERIODE),2,'0'))
  tablespace USERS
  pctfree 10
  initrans 2
  maxtrans 255
  storage
  (
    initial 64K
    next 1M
    minextents 1
    maxextents unlimited
  );
create index INDX_MIWTRELEVE6 on MIWTRELEVE (MRD_ID, SPT_ID, EQU_ID)
  tablespace USERS
  pctfree 10
  initrans 2
  maxtrans 255
  storage
  (
    initial 64K
    next 1M
    minextents 1
    maxextents unlimited
  );
create index INDX_MIWTRELEVE7 on MIWTRELEVE (MEU_ID, MRD_ID)
  tablespace USERS
  pctfree 10
  initrans 2
  maxtrans 255
  storage
  (
    initial 64K
    next 1M
    minextents 1
    maxextents unlimited
  );
create index INDX_MIWTRELEVE8 on MIWTRELEVE (MREL_INDEX1)
  tablespace USERS
  pctfree 10
  initrans 2
  maxtrans 255
  storage
  (
    initial 64K
    next 1M
    minextents 1
    maxextents unlimited
  );
create index INDX_MIWTRELEVE9 on MIWTRELEVE (MME_ID, MRD_ID, MEU_ID)
  tablespace USERS
  pctfree 10
  initrans 2
  maxtrans 255
  storage
  (
    initial 64K
    next 1M
    minextents 1
    maxextents unlimited
  );

prompt
prompt Creating table MIWTRELEVE_GC
prompt ============================
prompt
create table MIWTRELEVE_GC
(
  mrel_source        VARCHAR2(100) not null,
  mrel_ref           VARCHAR2(100) not null,
  mrel_refpdl        VARCHAR2(100),
  mrel_refcom        VARCHAR2(100),
  mrel_date          DATE not null,
  mrel_index1        NUMBER(10),
  mrel_index2        NUMBER(10),
  mrel_index3        NUMBER(10),
  mrel_index4        NUMBER(10),
  mrel_index5        NUMBER(10),
  mrel_index6        NUMBER(10),
  mrel_index7        NUMBER(10),
  mrel_index8        NUMBER(10),
  mrel_index9        NUMBER(10),
  mrel_index10       NUMBER(10),
  mrel_conso1        NUMBER(10),
  mrel_conso2        NUMBER(10),
  mrel_conso3        NUMBER(10),
  mrel_conso4        NUMBER(10),
  mrel_conso5        NUMBER(10),
  mrel_conso6        NUMBER(10),
  mrel_conso7        NUMBER(10),
  mrel_conso8        NUMBER(10),
  mrel_conso9        NUMBER(10),
  mrel_conso10       NUMBER(10),
  mrel_cadran1       VARCHAR2(6),
  mrel_cadran2       VARCHAR2(6),
  mrel_cadran3       VARCHAR2(6),
  mrel_cadran4       VARCHAR2(6),
  mrel_cadran5       VARCHAR2(6),
  mrel_cadran6       VARCHAR2(6),
  mrel_cadran7       VARCHAR2(6),
  mrel_cadran8       VARCHAR2(6),
  mrel_cadran9       VARCHAR2(6),
  mrel_cadran10      VARCHAR2(6),
  mrel_cadran_coff1  VARCHAR2(6),
  mrel_cadran_coff2  VARCHAR2(6),
  mrel_cadran_coff3  VARCHAR2(6),
  mrel_cadran_coff4  VARCHAR2(6),
  mrel_cadran_coff5  VARCHAR2(6),
  mrel_cadran_coff6  VARCHAR2(6),
  mrel_cadran_coff7  VARCHAR2(6),
  mrel_cadran_coff8  VARCHAR2(6),
  mrel_cadran_coff9  VARCHAR2(6),
  mrel_cadran_coff10 VARCHAR2(6),
  mrel_deduite       NUMBER(10),
  mrel_facturee      NUMBER(1) not null,
  voc_comm1          VARCHAR2(100),
  voc_comm2          VARCHAR2(100),
  voc_comm3          VARCHAR2(100),
  voc_readorig       VARCHAR2(100),
  voc_readcode       VARCHAR2(100),
  voc_readmeth       VARCHAR2(100),
  voc_readreason     VARCHAR2(100),
  mrel_agrtype       VARCHAR2(100),
  mrel_techtype      VARCHAR2(100),
  mrel_etatfact      VARCHAR2(100),
  mrel_comlibre      VARCHAR2(4000),
  mrel_agesource     VARCHAR2(100),
  mrel_ageref        VARCHAR2(100),
  mrel_fact1         VARCHAR2(100),
  mrel_fact2         VARCHAR2(100),
  mrel_subread       NUMBER,
  mrel_conso_ref1    NUMBER,
  mrel_conso_ref2    NUMBER,
  mrel_conso_ref3    NUMBER,
  mrel_conso_ref4    NUMBER,
  mrel_conso_ref5    NUMBER,
  mrel_conso_ref6    NUMBER,
  mrel_conso_ref7    NUMBER,
  mrel_conso_ref8    NUMBER,
  mrel_conso_ref9    NUMBER,
  mrel_conso_ref10   NUMBER,
  annee              NUMBER,
  periode            NUMBER,
  equ_id             NUMBER,
  spt_id             NUMBER,
  mrd_id             NUMBER,
  meu_id             NUMBER,
  meu_id2            NUMBER,
  meu_id3            NUMBER,
  meu_id4            NUMBER,
  meu_id5            NUMBER,
  meu_id6            NUMBER,
  meu_id7            NUMBER,
  meu_id8            NUMBER,
  meu_id9            NUMBER,
  meu_id10           NUMBER,
  mme_id             NUMBER,
  mme_id2            NUMBER,
  mme_id3            NUMBER,
  mme_id4            NUMBER,
  mme_id5            NUMBER,
  mme_id6            NUMBER,
  mme_id7            NUMBER,
  mme_id8            NUMBER,
  mme_id9            NUMBER,
  mme_id10           NUMBER,
  age_id             NUMBER,
  mrel_cfg           VARCHAR2(100),
  mtc_id             NUMBER,
  id                 NUMBER,
  id_releve          NUMBER,
  mrel_ano_c1        VARCHAR2(2),
  mrel_ano_c2        VARCHAR2(2),
  mrel_ano_c3        VARCHAR2(2),
  mrel_ano_n1        VARCHAR2(2),
  mrel_ano_n2        VARCHAR2(2),
  mrel_ano_n3        VARCHAR2(2),
  mrel_ano_f1        VARCHAR2(2),
  mrel_ano_f2        VARCHAR2(2),
  mrel_ano_f3        VARCHAR2(2)
)
tablespace MIG61
  pctfree 10
  initrans 1
  maxtrans 255
  storage
  (
    initial 64K
    next 1M
    minextents 1
    maxextents unlimited
  );
create index INDX_REL_GC on MIWTRELEVE_GC (SUBSTR(MREL_REFPDL,1,8)||TO_CHAR(ANNEE)||LPAD(TO_CHAR(PERIODE),2,'0'))
  tablespace USERS
  pctfree 10
  initrans 2
  maxtrans 255
  storage
  (
    initial 64K
    next 1M
    minextents 1
    maxextents unlimited
  );
create index INDX_REL_GC2 on MIWTRELEVE_GC (SUBSTR(MREL_REFPDL,1,8), TO_CHAR(ANNEE), LPAD(TO_CHAR(PERIODE),2,'0'))
  tablespace USERS
  pctfree 10
  initrans 2
  maxtrans 255
  storage
  (
    initial 64K
    next 1M
    minextents 1
    maxextents unlimited
  );
create index INDX_REL_GC3 on MIWTRELEVE_GC (MRD_ID, SPT_ID, EQU_ID)
  tablespace USERS
  pctfree 10
  initrans 2
  maxtrans 255
  storage
  (
    initial 64K
    next 1M
    minextents 1
    maxextents unlimited
  );
create index INDX_REL_GC4 on MIWTRELEVE_GC (MEU_ID, MRD_ID)
  tablespace USERS
  pctfree 10
  initrans 2
  maxtrans 255
  storage
  (
    initial 64K
    next 1M
    minextents 1
    maxextents unlimited
  );
create index INDX_REL_GC5 on MIWTRELEVE_GC (MREL_INDEX1)
  tablespace USERS
  pctfree 10
  initrans 2
  maxtrans 255
  storage
  (
    initial 64K
    next 1M
    minextents 1
    maxextents unlimited
  );
create index INDX_REL_GC6 on MIWTRELEVE_GC (MME_ID, MRD_ID, MEU_ID)
  tablespace USERS
  pctfree 10
  initrans 2
  maxtrans 255
  storage
  (
    initial 64K
    next 1M
    minextents 1
    maxextents unlimited
  );

prompt
prompt Creating table MIWTRELEVE_GC_1
prompt ==============================
prompt
create table MIWTRELEVE_GC_1
(
  mrel_source        VARCHAR2(100) not null,
  mrel_ref           VARCHAR2(100) not null,
  mrel_refpdl        VARCHAR2(100),
  mrel_refcom        VARCHAR2(100),
  mrel_date          DATE not null,
  mrel_index1        NUMBER(10),
  mrel_index2        NUMBER(10),
  mrel_index3        NUMBER(10),
  mrel_index4        NUMBER(10),
  mrel_index5        NUMBER(10),
  mrel_index6        NUMBER(10),
  mrel_index7        NUMBER(10),
  mrel_index8        NUMBER(10),
  mrel_index9        NUMBER(10),
  mrel_index10       NUMBER(10),
  mrel_conso1        NUMBER(10),
  mrel_conso2        NUMBER(10),
  mrel_conso3        NUMBER(10),
  mrel_conso4        NUMBER(10),
  mrel_conso5        NUMBER(10),
  mrel_conso6        NUMBER(10),
  mrel_conso7        NUMBER(10),
  mrel_conso8        NUMBER(10),
  mrel_conso9        NUMBER(10),
  mrel_conso10       NUMBER(10),
  mrel_cadran1       VARCHAR2(6),
  mrel_cadran2       VARCHAR2(6),
  mrel_cadran3       VARCHAR2(6),
  mrel_cadran4       VARCHAR2(6),
  mrel_cadran5       VARCHAR2(6),
  mrel_cadran6       VARCHAR2(6),
  mrel_cadran7       VARCHAR2(6),
  mrel_cadran8       VARCHAR2(6),
  mrel_cadran9       VARCHAR2(6),
  mrel_cadran10      VARCHAR2(6),
  mrel_cadran_coff1  VARCHAR2(6),
  mrel_cadran_coff2  VARCHAR2(6),
  mrel_cadran_coff3  VARCHAR2(6),
  mrel_cadran_coff4  VARCHAR2(6),
  mrel_cadran_coff5  VARCHAR2(6),
  mrel_cadran_coff6  VARCHAR2(6),
  mrel_cadran_coff7  VARCHAR2(6),
  mrel_cadran_coff8  VARCHAR2(6),
  mrel_cadran_coff9  VARCHAR2(6),
  mrel_cadran_coff10 VARCHAR2(6),
  mrel_deduite       NUMBER,
  mrel_facturee      NUMBER(1) not null,
  voc_comm1          VARCHAR2(100),
  voc_comm2          VARCHAR2(100),
  voc_comm3          VARCHAR2(100),
  voc_readorig       VARCHAR2(100),
  voc_readcode       VARCHAR2(100),
  voc_readmeth       VARCHAR2(100),
  voc_readreason     VARCHAR2(100),
  mrel_agrtype       VARCHAR2(100),
  mrel_techtype      VARCHAR2(100),
  mrel_etatfact      VARCHAR2(100),
  mrel_comlibre      VARCHAR2(4000),
  mrel_agesource     VARCHAR2(100),
  mrel_ageref        VARCHAR2(100),
  mrel_fact1         VARCHAR2(100),
  mrel_fact2         VARCHAR2(100),
  mrel_subread       NUMBER,
  mrel_conso_ref1    NUMBER,
  mrel_conso_ref2    NUMBER,
  mrel_conso_ref3    NUMBER,
  mrel_conso_ref4    NUMBER,
  mrel_conso_ref5    NUMBER,
  mrel_conso_ref6    NUMBER,
  mrel_conso_ref7    NUMBER,
  mrel_conso_ref8    NUMBER,
  mrel_conso_ref9    NUMBER,
  mrel_conso_ref10   NUMBER,
  annee              NUMBER,
  periode            NUMBER,
  equ_id             NUMBER,
  spt_id             NUMBER,
  mrd_id             NUMBER,
  meu_id             NUMBER,
  meu_id2            NUMBER,
  meu_id3            NUMBER,
  meu_id4            NUMBER,
  meu_id5            NUMBER,
  meu_id6            NUMBER,
  meu_id7            NUMBER,
  meu_id8            NUMBER,
  meu_id9            NUMBER,
  meu_id10           NUMBER,
  mme_id             NUMBER,
  mme_id2            NUMBER,
  mme_id3            NUMBER,
  mme_id4            NUMBER,
  mme_id5            NUMBER,
  mme_id6            NUMBER,
  mme_id7            NUMBER,
  mme_id8            NUMBER,
  mme_id9            NUMBER,
  mme_id10           NUMBER,
  age_id             NUMBER,
  mrel_cfg           VARCHAR2(100),
  mtc_id             NUMBER,
  id                 NUMBER,
  id_releve          NUMBER,
  mrel_ano_c1        VARCHAR2(2),
  mrel_ano_c2        VARCHAR2(2),
  mrel_ano_c3        VARCHAR2(2),
  mrel_ano_n1        VARCHAR2(2),
  mrel_ano_n2        VARCHAR2(2),
  mrel_ano_n3        VARCHAR2(2),
  mrel_ano_f1        VARCHAR2(2),
  mrel_ano_f2        VARCHAR2(2),
  mrel_ano_f3        VARCHAR2(2)
)
tablespace MIG61
  pctfree 10
  initrans 1
  maxtrans 255
  storage
  (
    initial 64K
    next 1M
    minextents 1
    maxextents unlimited
  );
create index INDX_REL_GC1 on MIWTRELEVE_GC_1 (SUBSTR(MREL_REFPDL,1,8)||TO_CHAR(ANNEE)||LPAD(TO_CHAR(PERIODE),2,'0'))
  tablespace USERS
  pctfree 10
  initrans 2
  maxtrans 255
  storage
  (
    initial 64K
    next 1M
    minextents 1
    maxextents unlimited
  );
create index INDX_REL_GC1_2 on MIWTRELEVE_GC_1 (SUBSTR(MREL_REFPDL,1,8), TO_CHAR(ANNEE), LPAD(TO_CHAR(PERIODE),2,'0'))
  tablespace USERS
  pctfree 10
  initrans 2
  maxtrans 255
  storage
  (
    initial 64K
    next 1M
    minextents 1
    maxextents unlimited
  );
create index INDX_REL_GC1_3 on MIWTRELEVE_GC_1 (MRD_ID, SPT_ID, EQU_ID)
  tablespace USERS
  pctfree 10
  initrans 2
  maxtrans 255
  storage
  (
    initial 64K
    next 1M
    minextents 1
    maxextents unlimited
  );
create index INDX_REL_GC1_4 on MIWTRELEVE_GC_1 (MEU_ID, MRD_ID)
  tablespace USERS
  pctfree 10
  initrans 2
  maxtrans 255
  storage
  (
    initial 64K
    next 1M
    minextents 1
    maxextents unlimited
  );
create index INDX_REL_GC1_5 on MIWTRELEVE_GC_1 (MREL_INDEX1)
  tablespace USERS
  pctfree 10
  initrans 2
  maxtrans 255
  storage
  (
    initial 64K
    next 1M
    minextents 1
    maxextents unlimited
  );
create index NDX_REL_GC1_6 on MIWTRELEVE_GC_1 (MME_ID, MRD_ID, MEU_ID)
  tablespace USERS
  pctfree 10
  initrans 2
  maxtrans 255
  storage
  (
    initial 64K
    next 1M
    minextents 1
    maxextents unlimited
  );

prompt
prompt Creating table MIWTRELEVE_HISTOCPT
prompt ==================================
prompt
create table MIWTRELEVE_HISTOCPT
(
  mrel_source        VARCHAR2(100) not null,
  mrel_ref           VARCHAR2(100) not null,
  mrel_refpdl        VARCHAR2(100),
  mrel_refcom        VARCHAR2(100),
  mrel_date          DATE not null,
  mrel_index1        NUMBER(10),
  mrel_index2        NUMBER(10),
  mrel_index3        NUMBER(10),
  mrel_index4        NUMBER(10),
  mrel_index5        NUMBER(10),
  mrel_index6        NUMBER(10),
  mrel_index7        NUMBER(10),
  mrel_index8        NUMBER(10),
  mrel_index9        NUMBER(10),
  mrel_index10       NUMBER(10),
  mrel_index11       NUMBER(10),
  mrel_index12       NUMBER(10),
  mrel_conso1        NUMBER(10),
  mrel_conso2        NUMBER(10),
  mrel_conso3        NUMBER(10),
  mrel_conso4        NUMBER(10),
  mrel_conso5        NUMBER(10),
  mrel_conso6        NUMBER(10),
  mrel_conso7        NUMBER(10),
  mrel_conso8        NUMBER(10),
  mrel_conso9        NUMBER(10),
  mrel_conso10       NUMBER(10),
  mrel_conso11       NUMBER(10),
  mrel_conso12       NUMBER(10),
  mrel_cadran1       VARCHAR2(6),
  mrel_cadran2       VARCHAR2(6),
  mrel_cadran3       VARCHAR2(6),
  mrel_cadran4       VARCHAR2(6),
  mrel_cadran5       VARCHAR2(6),
  mrel_cadran6       VARCHAR2(6),
  mrel_cadran7       VARCHAR2(6),
  mrel_cadran8       VARCHAR2(6),
  mrel_cadran9       VARCHAR2(6),
  mrel_cadran10      VARCHAR2(6),
  mrel_cadran11      VARCHAR2(6),
  mrel_cadran12      VARCHAR2(6),
  mrel_cadran_coff1  VARCHAR2(6),
  mrel_cadran_coff2  VARCHAR2(6),
  mrel_cadran_coff3  VARCHAR2(6),
  mrel_cadran_coff4  VARCHAR2(6),
  mrel_cadran_coff5  VARCHAR2(6),
  mrel_cadran_coff6  VARCHAR2(6),
  mrel_cadran_coff7  VARCHAR2(6),
  mrel_cadran_coff8  VARCHAR2(6),
  mrel_cadran_coff9  VARCHAR2(6),
  mrel_cadran_coff10 VARCHAR2(6),
  mrel_cadran_coff11 VARCHAR2(6),
  mrel_cadran_coff12 VARCHAR2(6),
  mrel_deduite       NUMBER(10),
  mrel_facturee      NUMBER(1) not null,
  voc_comm1          VARCHAR2(100),
  voc_comm2          VARCHAR2(100),
  voc_comm3          VARCHAR2(100),
  voc_readorig       VARCHAR2(100),
  voc_readcode       VARCHAR2(100),
  voc_readmeth       VARCHAR2(100),
  voc_readreason     VARCHAR2(100),
  mrel_agrtype       VARCHAR2(100),
  mrel_techtype      VARCHAR2(100),
  mrel_etatfact      VARCHAR2(100),
  mrel_comlibre      VARCHAR2(4000),
  mrel_agesource     VARCHAR2(100),
  mrel_ageref        VARCHAR2(100),
  mrel_fact1         VARCHAR2(100),
  mrel_fact2         VARCHAR2(100),
  mrel_subread       NUMBER,
  mrel_conso_ref1    NUMBER,
  mrel_conso_ref2    NUMBER,
  mrel_conso_ref3    NUMBER,
  mrel_conso_ref4    NUMBER,
  mrel_conso_ref5    NUMBER,
  mrel_conso_ref6    NUMBER,
  mrel_conso_ref7    NUMBER,
  mrel_conso_ref8    NUMBER,
  mrel_conso_ref9    NUMBER,
  mrel_conso_ref10   NUMBER,
  mrel_conso_ref11   NUMBER,
  mrel_conso_ref12   NUMBER,
  mrel_ano_c1        VARCHAR2(2),
  mrel_ano_c2        VARCHAR2(2),
  mrel_ano_c3        VARCHAR2(2),
  mrel_ano_n1        VARCHAR2(2),
  mrel_ano_n2        VARCHAR2(2),
  mrel_ano_n3        VARCHAR2(2),
  mrel_ano_f1        VARCHAR2(2),
  mrel_ano_f2        VARCHAR2(2),
  mrel_ano_f3        VARCHAR2(2),
  periode            NUMBER,
  annee              NUMBER,
  mrd_id             NUMBER,
  mme_id1            NUMBER,
  mme_id2            NUMBER,
  mme_id3            NUMBER,
  mme_id4            NUMBER,
  mme_id5            NUMBER,
  mme_id6            NUMBER,
  meu_id1            NUMBER,
  meu_id2            NUMBER,
  meu_id3            NUMBER,
  meu_id4            NUMBER,
  meu_id5            NUMBER,
  meu_id6            NUMBER,
  mme_id             NUMBER,
  meu_id             NUMBER,
  spt_id             NUMBER,
  equ_id             NUMBER,
  age_id             NUMBER,
  mtc_id             NUMBER
)
tablespace MIG61
  pctfree 10
  initrans 1
  maxtrans 255
  storage
  (
    initial 64K
    next 1M
    minextents 1
    maxextents unlimited
  );
create index INDEX_REL_HCT1 on MIWTRELEVE_HISTOCPT (MRD_ID, SPT_ID, EQU_ID)
  tablespace USERS
  pctfree 10
  initrans 2
  maxtrans 255
  storage
  (
    initial 64K
    next 1M
    minextents 1
    maxextents unlimited
  );
create index INDEX_REL_HCT2 on MIWTRELEVE_HISTOCPT (MEU_ID, MRD_ID)
  tablespace USERS
  pctfree 10
  initrans 2
  maxtrans 255
  storage
  (
    initial 64K
    next 1M
    minextents 1
    maxextents unlimited
  );
create index INDEX_REL_HCT3 on MIWTRELEVE_HISTOCPT (MREL_INDEX1)
  tablespace USERS
  pctfree 10
  initrans 2
  maxtrans 255
  storage
  (
    initial 64K
    next 1M
    minextents 1
    maxextents unlimited
  );
create index INDEX_REL_HCT4 on MIWTRELEVE_HISTOCPT (MME_ID, MRD_ID, MEU_ID)
  tablespace USERS
  pctfree 10
  initrans 2
  maxtrans 255
  storage
  (
    initial 64K
    next 1M
    minextents 1
    maxextents unlimited
  );

prompt
prompt Creating table MIWTRELEVE_HISTOCPT_SAVE
prompt =======================================
prompt
create table MIWTRELEVE_HISTOCPT_SAVE
(
  mrel_source        VARCHAR2(100) not null,
  mrel_ref           VARCHAR2(100) not null,
  mrel_refpdl        VARCHAR2(100),
  mrel_refcom        VARCHAR2(100),
  mrel_date          DATE not null,
  mrel_index1        NUMBER(10),
  mrel_index2        NUMBER(10),
  mrel_index3        NUMBER(10),
  mrel_index4        NUMBER(10),
  mrel_index5        NUMBER(10),
  mrel_index6        NUMBER(10),
  mrel_index7        NUMBER(10),
  mrel_index8        NUMBER(10),
  mrel_index9        NUMBER(10),
  mrel_index10       NUMBER(10),
  mrel_index11       NUMBER(10),
  mrel_index12       NUMBER(10),
  mrel_conso1        NUMBER(10),
  mrel_conso2        NUMBER(10),
  mrel_conso3        NUMBER(10),
  mrel_conso4        NUMBER(10),
  mrel_conso5        NUMBER(10),
  mrel_conso6        NUMBER(10),
  mrel_conso7        NUMBER(10),
  mrel_conso8        NUMBER(10),
  mrel_conso9        NUMBER(10),
  mrel_conso10       NUMBER(10),
  mrel_conso11       NUMBER(10),
  mrel_conso12       NUMBER(10),
  mrel_cadran1       VARCHAR2(6),
  mrel_cadran2       VARCHAR2(6),
  mrel_cadran3       VARCHAR2(6),
  mrel_cadran4       VARCHAR2(6),
  mrel_cadran5       VARCHAR2(6),
  mrel_cadran6       VARCHAR2(6),
  mrel_cadran7       VARCHAR2(6),
  mrel_cadran8       VARCHAR2(6),
  mrel_cadran9       VARCHAR2(6),
  mrel_cadran10      VARCHAR2(6),
  mrel_cadran11      VARCHAR2(6),
  mrel_cadran12      VARCHAR2(6),
  mrel_cadran_coff1  VARCHAR2(6),
  mrel_cadran_coff2  VARCHAR2(6),
  mrel_cadran_coff3  VARCHAR2(6),
  mrel_cadran_coff4  VARCHAR2(6),
  mrel_cadran_coff5  VARCHAR2(6),
  mrel_cadran_coff6  VARCHAR2(6),
  mrel_cadran_coff7  VARCHAR2(6),
  mrel_cadran_coff8  VARCHAR2(6),
  mrel_cadran_coff9  VARCHAR2(6),
  mrel_cadran_coff10 VARCHAR2(6),
  mrel_cadran_coff11 VARCHAR2(6),
  mrel_cadran_coff12 VARCHAR2(6),
  mrel_deduite       NUMBER(10),
  mrel_facturee      NUMBER(1) not null,
  voc_comm1          VARCHAR2(100),
  voc_comm2          VARCHAR2(100),
  voc_comm3          VARCHAR2(100),
  voc_readorig       VARCHAR2(100),
  voc_readcode       VARCHAR2(100),
  voc_readmeth       VARCHAR2(100),
  voc_readreason     VARCHAR2(100),
  mrel_agrtype       VARCHAR2(100),
  mrel_techtype      VARCHAR2(100),
  mrel_etatfact      VARCHAR2(100),
  mrel_comlibre      VARCHAR2(4000),
  mrel_agesource     VARCHAR2(100),
  mrel_ageref        VARCHAR2(100),
  mrel_fact1         VARCHAR2(100),
  mrel_fact2         VARCHAR2(100),
  mrel_subread       NUMBER,
  mrel_conso_ref1    NUMBER,
  mrel_conso_ref2    NUMBER,
  mrel_conso_ref3    NUMBER,
  mrel_conso_ref4    NUMBER,
  mrel_conso_ref5    NUMBER,
  mrel_conso_ref6    NUMBER,
  mrel_conso_ref7    NUMBER,
  mrel_conso_ref8    NUMBER,
  mrel_conso_ref9    NUMBER,
  mrel_conso_ref10   NUMBER,
  mrel_conso_ref11   NUMBER,
  mrel_conso_ref12   NUMBER,
  mrel_ano_c1        VARCHAR2(2),
  mrel_ano_c2        VARCHAR2(2),
  mrel_ano_c3        VARCHAR2(2),
  mrel_ano_n1        VARCHAR2(2),
  mrel_ano_n2        VARCHAR2(2),
  mrel_ano_n3        VARCHAR2(2),
  mrel_ano_f1        VARCHAR2(2),
  mrel_ano_f2        VARCHAR2(2),
  mrel_ano_f3        VARCHAR2(2),
  periode            NUMBER,
  annee              NUMBER,
  mrd_id             NUMBER,
  mme_id1            NUMBER,
  mme_id2            NUMBER,
  mme_id3            NUMBER,
  mme_id4            NUMBER,
  mme_id5            NUMBER,
  mme_id6            NUMBER,
  meu_id1            NUMBER,
  meu_id2            NUMBER,
  meu_id3            NUMBER,
  meu_id4            NUMBER,
  meu_id5            NUMBER,
  meu_id6            NUMBER,
  mme_id             NUMBER,
  meu_id             NUMBER,
  spt_id             NUMBER,
  equ_id             NUMBER,
  age_id             NUMBER,
  mtc_id             NUMBER
)
tablespace MIG61
  pctfree 10
  initrans 1
  maxtrans 255;

prompt
prompt Creating table MIWTRELEVE_SAVE
prompt ==============================
prompt
create table MIWTRELEVE_SAVE
(
  mrel_source        VARCHAR2(100) not null,
  mrel_ref           VARCHAR2(100) not null,
  mrel_refpdl        VARCHAR2(100),
  mrel_refcom        VARCHAR2(100),
  mrel_date          DATE not null,
  mrel_index1        NUMBER(10),
  mrel_index2        NUMBER(10),
  mrel_index3        NUMBER(10),
  mrel_index4        NUMBER(10),
  mrel_index5        NUMBER(10),
  mrel_index6        NUMBER(10),
  mrel_index7        NUMBER(10),
  mrel_index8        NUMBER(10),
  mrel_index9        NUMBER(10),
  mrel_index10       NUMBER(10),
  mrel_index11       NUMBER(10),
  mrel_index12       NUMBER(10),
  mrel_conso1        NUMBER(10),
  mrel_conso2        NUMBER(10),
  mrel_conso3        NUMBER(10),
  mrel_conso4        NUMBER(10),
  mrel_conso5        NUMBER(10),
  mrel_conso6        NUMBER(10),
  mrel_conso7        NUMBER(10),
  mrel_conso8        NUMBER(10),
  mrel_conso9        NUMBER(10),
  mrel_conso10       NUMBER(10),
  mrel_conso11       NUMBER(10),
  mrel_conso12       NUMBER(10),
  mrel_cadran1       VARCHAR2(6),
  mrel_cadran2       VARCHAR2(6),
  mrel_cadran3       VARCHAR2(6),
  mrel_cadran4       VARCHAR2(6),
  mrel_cadran5       VARCHAR2(6),
  mrel_cadran6       VARCHAR2(6),
  mrel_cadran7       VARCHAR2(6),
  mrel_cadran8       VARCHAR2(6),
  mrel_cadran9       VARCHAR2(6),
  mrel_cadran10      VARCHAR2(6),
  mrel_cadran11      VARCHAR2(6),
  mrel_cadran12      VARCHAR2(6),
  mrel_cadran_coff1  VARCHAR2(6),
  mrel_cadran_coff2  VARCHAR2(6),
  mrel_cadran_coff3  VARCHAR2(6),
  mrel_cadran_coff4  VARCHAR2(6),
  mrel_cadran_coff5  VARCHAR2(6),
  mrel_cadran_coff6  VARCHAR2(6),
  mrel_cadran_coff7  VARCHAR2(6),
  mrel_cadran_coff8  VARCHAR2(6),
  mrel_cadran_coff9  VARCHAR2(6),
  mrel_cadran_coff10 VARCHAR2(6),
  mrel_cadran_coff11 VARCHAR2(6),
  mrel_cadran_coff12 VARCHAR2(6),
  mrel_deduite       NUMBER(10),
  mrel_facturee      NUMBER(1) not null,
  voc_comm1          VARCHAR2(100),
  voc_comm2          VARCHAR2(100),
  voc_comm3          VARCHAR2(100),
  voc_readorig       VARCHAR2(100),
  voc_readcode       VARCHAR2(100),
  voc_readmeth       VARCHAR2(100),
  voc_readreason     VARCHAR2(100),
  mrel_agrtype       VARCHAR2(100),
  mrel_techtype      VARCHAR2(100),
  mrel_etatfact      VARCHAR2(100),
  mrel_comlibre      VARCHAR2(4000),
  mrel_agesource     VARCHAR2(100),
  mrel_ageref        VARCHAR2(100),
  mrel_fact1         VARCHAR2(100),
  mrel_fact2         VARCHAR2(100),
  mrel_subread       NUMBER,
  mrel_conso_ref1    NUMBER,
  mrel_conso_ref2    NUMBER,
  mrel_conso_ref3    NUMBER,
  mrel_conso_ref4    NUMBER,
  mrel_conso_ref5    NUMBER,
  mrel_conso_ref6    NUMBER,
  mrel_conso_ref7    NUMBER,
  mrel_conso_ref8    NUMBER,
  mrel_conso_ref9    NUMBER,
  mrel_conso_ref10   NUMBER,
  mrel_conso_ref11   NUMBER,
  mrel_conso_ref12   NUMBER,
  mrel_ano_c1        VARCHAR2(2),
  mrel_ano_c2        VARCHAR2(2),
  mrel_ano_c3        VARCHAR2(2),
  mrel_ano_n1        VARCHAR2(2),
  mrel_ano_n2        VARCHAR2(2),
  mrel_ano_n3        VARCHAR2(2),
  mrel_ano_f1        VARCHAR2(2),
  mrel_ano_f2        VARCHAR2(2),
  mrel_ano_f3        VARCHAR2(2),
  periode            NUMBER,
  annee              NUMBER,
  mrd_id             NUMBER,
  mme_id1            NUMBER,
  mme_id2            NUMBER,
  mme_id3            NUMBER,
  mme_id4            NUMBER,
  mme_id5            NUMBER,
  mme_id6            NUMBER,
  meu_id1            NUMBER,
  meu_id2            NUMBER,
  meu_id3            NUMBER,
  meu_id4            NUMBER,
  meu_id5            NUMBER,
  meu_id6            NUMBER,
  mme_id             NUMBER,
  meu_id             NUMBER,
  spt_id             NUMBER,
  equ_id             NUMBER,
  age_id             NUMBER,
  mtc_id             NUMBER
)
tablespace MIG61
  pctfree 10
  initrans 1
  maxtrans 255
  storage
  (
    initial 64K
    next 1M
    minextents 1
    maxextents unlimited
  );

prompt
prompt Creating table MIWTRELEVET
prompt ==========================
prompt
create table MIWTRELEVET
(
  mrel_source        VARCHAR2(100) not null,
  mrel_ref           VARCHAR2(100) not null,
  mrel_refpdl        VARCHAR2(100) not null,
  mrel_refcom        VARCHAR2(100),
  mrel_date          DATE not null,
  mrel_index1        NUMBER(10),
  mrel_index2        NUMBER(10),
  mrel_index3        NUMBER(10),
  mrel_index4        NUMBER(10),
  mrel_index5        NUMBER(10),
  mrel_index6        NUMBER(10),
  mrel_index7        NUMBER(10),
  mrel_index8        NUMBER(10),
  mrel_index9        NUMBER(10),
  mrel_index10       NUMBER(10),
  mrel_index11       NUMBER(10),
  mrel_index12       NUMBER(10),
  mrel_conso1        NUMBER(10),
  mrel_conso2        NUMBER(10),
  mrel_conso3        NUMBER(10),
  mrel_conso4        NUMBER(10),
  mrel_conso5        NUMBER(10),
  mrel_conso6        NUMBER(10),
  mrel_conso7        NUMBER(10),
  mrel_conso8        NUMBER(10),
  mrel_conso9        NUMBER(10),
  mrel_conso10       NUMBER(10),
  mrel_conso11       NUMBER(10),
  mrel_conso12       NUMBER(10),
  mrel_cadran1       VARCHAR2(6),
  mrel_cadran2       VARCHAR2(6),
  mrel_cadran3       VARCHAR2(6),
  mrel_cadran4       VARCHAR2(6),
  mrel_cadran5       VARCHAR2(6),
  mrel_cadran6       VARCHAR2(6),
  mrel_cadran7       VARCHAR2(6),
  mrel_cadran8       VARCHAR2(6),
  mrel_cadran9       VARCHAR2(6),
  mrel_cadran10      VARCHAR2(6),
  mrel_cadran11      VARCHAR2(6),
  mrel_cadran12      VARCHAR2(6),
  mrel_cadran_coff1  VARCHAR2(6),
  mrel_cadran_coff2  VARCHAR2(6),
  mrel_cadran_coff3  VARCHAR2(6),
  mrel_cadran_coff4  VARCHAR2(6),
  mrel_cadran_coff5  VARCHAR2(6),
  mrel_cadran_coff6  VARCHAR2(6),
  mrel_cadran_coff7  VARCHAR2(6),
  mrel_cadran_coff8  VARCHAR2(6),
  mrel_cadran_coff9  VARCHAR2(6),
  mrel_cadran_coff10 VARCHAR2(6),
  mrel_cadran_coff11 VARCHAR2(6),
  mrel_cadran_coff12 VARCHAR2(6),
  mrel_deduite       NUMBER(10),
  mrel_facturee      NUMBER(1) not null,
  voc_comm1          VARCHAR2(100),
  voc_comm2          VARCHAR2(100),
  voc_comm3          VARCHAR2(100),
  voc_readorig       VARCHAR2(100),
  voc_readcode       VARCHAR2(100),
  voc_readmeth       VARCHAR2(100),
  voc_readreason     VARCHAR2(100),
  mrel_agrtype       VARCHAR2(100),
  mrel_techtype      VARCHAR2(100),
  mrel_etatfact      VARCHAR2(100),
  mrel_comlibre      VARCHAR2(4000),
  mrel_agesource     VARCHAR2(100),
  mrel_ageref        VARCHAR2(100),
  mrel_fact1         VARCHAR2(100),
  mrel_fact2         VARCHAR2(100),
  mrel_subread       NUMBER default 0,
  mrel_conso_ref1    NUMBER,
  mrel_conso_ref2    NUMBER,
  mrel_conso_ref3    NUMBER,
  mrel_conso_ref4    NUMBER,
  mrel_conso_ref5    NUMBER,
  mrel_conso_ref6    NUMBER,
  mrel_conso_ref7    NUMBER,
  mrel_conso_ref8    NUMBER,
  mrel_conso_ref9    NUMBER,
  mrel_conso_ref10   NUMBER,
  mrel_conso_ref11   NUMBER,
  mrel_conso_ref12   NUMBER,
  mrel_ano_c1        VARCHAR2(2),
  mrel_ano_c2        VARCHAR2(2),
  mrel_ano_c3        VARCHAR2(2),
  mrel_ano_n1        VARCHAR2(2),
  mrel_ano_n2        VARCHAR2(2),
  mrel_ano_n3        VARCHAR2(2),
  mrel_ano_f1        VARCHAR2(2),
  mrel_ano_f2        VARCHAR2(2),
  mrel_ano_f3        VARCHAR2(2),
  periode            NUMBER,
  annee              NUMBER,
  mrd_id             NUMBER,
  mme_id1            NUMBER,
  mme_id2            NUMBER,
  mme_id3            NUMBER,
  mme_id4            NUMBER,
  mme_id5            NUMBER,
  mme_id6            NUMBER,
  meu_id1            NUMBER,
  meu_id2            NUMBER,
  meu_id3            NUMBER,
  meu_id4            NUMBER,
  meu_id5            NUMBER,
  meu_id6            NUMBER,
  mme_id             NUMBER,
  meu_id             NUMBER,
  spt_id             NUMBER,
  equ_id             NUMBER,
  age_id             NUMBER,
  mtc_id             NUMBER
)
tablespace MIG61
  pctfree 10
  initrans 1
  maxtrans 255
  storage
  (
    initial 64K
    next 1M
    minextents 1
    maxextents unlimited
  );
create index INDX_RELT on MIWTRELEVET (SUBSTR(MREL_REFPDL,1,8)||TO_CHAR(ANNEE)||LPAD(TO_CHAR(PERIODE),2,'0'))
  tablespace USERS
  pctfree 10
  initrans 2
  maxtrans 255
  storage
  (
    initial 64K
    next 1M
    minextents 1
    maxextents unlimited
  );
create index INDX_RELT2 on MIWTRELEVET (SUBSTR(MREL_REFPDL,1,8), TO_CHAR(ANNEE), LPAD(TO_CHAR(PERIODE),2,'0'))
  tablespace USERS
  pctfree 10
  initrans 2
  maxtrans 255
  storage
  (
    initial 64K
    next 1M
    minextents 1
    maxextents unlimited
  );
create index INDX_RELT3 on MIWTRELEVET (MRD_ID, SPT_ID, EQU_ID)
  tablespace USERS
  pctfree 10
  initrans 2
  maxtrans 255
  storage
  (
    initial 64K
    next 1M
    minextents 1
    maxextents unlimited
  );
create index INDX_RELT4 on MIWTRELEVET (MEU_ID, MRD_ID)
  tablespace USERS
  pctfree 10
  initrans 2
  maxtrans 255
  storage
  (
    initial 64K
    next 1M
    minextents 1
    maxextents unlimited
  );
create index INDX_RELT5 on MIWTRELEVET (MREL_INDEX1)
  tablespace USERS
  pctfree 10
  initrans 2
  maxtrans 255
  storage
  (
    initial 64K
    next 1M
    minextents 1
    maxextents unlimited
  );
create index INDX_RELT6 on MIWTRELEVET (MME_ID, MRD_ID, MEU_ID)
  tablespace USERS
  pctfree 10
  initrans 2
  maxtrans 255
  storage
  (
    initial 64K
    next 1M
    minextents 1
    maxextents unlimited
  );
create index INDX_RELT7 on MIWTRELEVET (MREL_REF)
  tablespace USERS
  pctfree 10
  initrans 2
  maxtrans 255
  storage
  (
    initial 64K
    next 1M
    minextents 1
    maxextents unlimited
  );
create index INDX_RELT8 on MIWTRELEVET (MREL_FACT1)
  tablespace USERS
  pctfree 10
  initrans 2
  maxtrans 255
  storage
  (
    initial 64K
    next 1M
    minextents 1
    maxextents unlimited
  );

prompt
prompt Creating table MIWTRELEVET_SAVE
prompt ===============================
prompt
create table MIWTRELEVET_SAVE
(
  mrel_source        VARCHAR2(100) not null,
  mrel_ref           VARCHAR2(100) not null,
  mrel_refpdl        VARCHAR2(100) not null,
  mrel_refcom        VARCHAR2(100),
  mrel_date          DATE not null,
  mrel_index1        NUMBER(10),
  mrel_index2        NUMBER(10),
  mrel_index3        NUMBER(10),
  mrel_index4        NUMBER(10),
  mrel_index5        NUMBER(10),
  mrel_index6        NUMBER(10),
  mrel_index7        NUMBER(10),
  mrel_index8        NUMBER(10),
  mrel_index9        NUMBER(10),
  mrel_index10       NUMBER(10),
  mrel_index11       NUMBER(10),
  mrel_index12       NUMBER(10),
  mrel_conso1        NUMBER(10),
  mrel_conso2        NUMBER(10),
  mrel_conso3        NUMBER(10),
  mrel_conso4        NUMBER(10),
  mrel_conso5        NUMBER(10),
  mrel_conso6        NUMBER(10),
  mrel_conso7        NUMBER(10),
  mrel_conso8        NUMBER(10),
  mrel_conso9        NUMBER(10),
  mrel_conso10       NUMBER(10),
  mrel_conso11       NUMBER(10),
  mrel_conso12       NUMBER(10),
  mrel_cadran1       VARCHAR2(6),
  mrel_cadran2       VARCHAR2(6),
  mrel_cadran3       VARCHAR2(6),
  mrel_cadran4       VARCHAR2(6),
  mrel_cadran5       VARCHAR2(6),
  mrel_cadran6       VARCHAR2(6),
  mrel_cadran7       VARCHAR2(6),
  mrel_cadran8       VARCHAR2(6),
  mrel_cadran9       VARCHAR2(6),
  mrel_cadran10      VARCHAR2(6),
  mrel_cadran11      VARCHAR2(6),
  mrel_cadran12      VARCHAR2(6),
  mrel_cadran_coff1  VARCHAR2(6),
  mrel_cadran_coff2  VARCHAR2(6),
  mrel_cadran_coff3  VARCHAR2(6),
  mrel_cadran_coff4  VARCHAR2(6),
  mrel_cadran_coff5  VARCHAR2(6),
  mrel_cadran_coff6  VARCHAR2(6),
  mrel_cadran_coff7  VARCHAR2(6),
  mrel_cadran_coff8  VARCHAR2(6),
  mrel_cadran_coff9  VARCHAR2(6),
  mrel_cadran_coff10 VARCHAR2(6),
  mrel_cadran_coff11 VARCHAR2(6),
  mrel_cadran_coff12 VARCHAR2(6),
  mrel_deduite       NUMBER(10),
  mrel_facturee      NUMBER(1) not null,
  voc_comm1          VARCHAR2(100),
  voc_comm2          VARCHAR2(100),
  voc_comm3          VARCHAR2(100),
  voc_readorig       VARCHAR2(100),
  voc_readcode       VARCHAR2(100),
  voc_readmeth       VARCHAR2(100),
  voc_readreason     VARCHAR2(100),
  mrel_agrtype       VARCHAR2(100),
  mrel_techtype      VARCHAR2(100),
  mrel_etatfact      VARCHAR2(100),
  mrel_comlibre      VARCHAR2(4000),
  mrel_agesource     VARCHAR2(100),
  mrel_ageref        VARCHAR2(100),
  mrel_fact1         VARCHAR2(100),
  mrel_fact2         VARCHAR2(100),
  mrel_subread       NUMBER,
  mrel_conso_ref1    NUMBER,
  mrel_conso_ref2    NUMBER,
  mrel_conso_ref3    NUMBER,
  mrel_conso_ref4    NUMBER,
  mrel_conso_ref5    NUMBER,
  mrel_conso_ref6    NUMBER,
  mrel_conso_ref7    NUMBER,
  mrel_conso_ref8    NUMBER,
  mrel_conso_ref9    NUMBER,
  mrel_conso_ref10   NUMBER,
  mrel_conso_ref11   NUMBER,
  mrel_conso_ref12   NUMBER,
  mrel_ano_c1        VARCHAR2(2),
  mrel_ano_c2        VARCHAR2(2),
  mrel_ano_c3        VARCHAR2(2),
  mrel_ano_n1        VARCHAR2(2),
  mrel_ano_n2        VARCHAR2(2),
  mrel_ano_n3        VARCHAR2(2),
  mrel_ano_f1        VARCHAR2(2),
  mrel_ano_f2        VARCHAR2(2),
  mrel_ano_f3        VARCHAR2(2),
  periode            NUMBER,
  annee              NUMBER,
  mrd_id             NUMBER,
  mme_id1            NUMBER,
  mme_id2            NUMBER,
  mme_id3            NUMBER,
  mme_id4            NUMBER,
  mme_id5            NUMBER,
  mme_id6            NUMBER,
  meu_id1            NUMBER,
  meu_id2            NUMBER,
  meu_id3            NUMBER,
  meu_id4            NUMBER,
  meu_id5            NUMBER,
  meu_id6            NUMBER,
  mme_id             NUMBER,
  meu_id             NUMBER,
  spt_id             NUMBER,
  equ_id             NUMBER,
  age_id             NUMBER,
  mtc_id             NUMBER
)
tablespace MIG61
  pctfree 10
  initrans 1
  maxtrans 255
  storage
  (
    initial 64K
    next 1M
    minextents 1
    maxextents unlimited
  );

prompt
prompt Creating table MIWTRGL
prompt ======================
prompt
create table MIWTRGL
(
  mrgl_source      VARCHAR2(100) not null,
  mrgl_ref         VARCHAR2(100) not null,
  mrgl_refenc      VARCHAR2(100) not null,
  menc_refabn      VARCHAR2(100),
  menc_rfimp       VARCHAR2(100),
  mrgl_reffae      VARCHAR2(100),
  mrgl_montant     NUMBER(10,3) not null,
  mrgl_date        DATE,
  mrgl_commentaire VARCHAR2(500),
  mrgl_compteaux   VARCHAR2(100),
  pcd_id           NUMBER
)
tablespace MIG61
  pctfree 10
  initrans 1
  maxtrans 255;
comment on table MIWTRGL
  is 'Le règlement correspond à l''affectation d''un montant encaissé (ou une partie du montant) à une facture.';
comment on column MIWTRGL.mrgl_source
  is 'Code source/origine de la echeance [OBL]';
comment on column MIWTRGL.mrgl_ref
  is 'identifiant du règlement pour la migration : N° fourni par l''utilisateur (obligatoire)';
comment on column MIWTRGL.mrgl_refenc
  is 'identifiant interne de l''encaissement pour la migration (obligatoire)';
comment on column MIWTRGL.menc_refabn
  is 'Ref abn (obligatoire)';
comment on column MIWTRGL.menc_rfimp
  is 'Imputation comptable client 411 du reglement';
comment on column MIWTRGL.mrgl_reffae
  is 'facture concernée par le règlement (obligatoire)';
comment on column MIWTRGL.mrgl_montant
  is 'montant du règlement (obligatoire)';
comment on column MIWTRGL.mrgl_date
  is 'date d''affectation de la partie d''encaissement à la facture';
comment on column MIWTRGL.mrgl_commentaire
  is 'RGL_COMMENTAIRE';
comment on column MIWTRGL.mrgl_compteaux
  is 'Compte auxilaire GENACCOUNT associé au debit du règlement';
alter table MIWTRGL
  add constraint PK_MIWTRGL primary key (MRGL_SOURCE, MRGL_REF)
  using index 
  tablespace USERS
  pctfree 10
  initrans 2
  maxtrans 255;
alter table MIWTRGL
  add constraint FK_MIWTRGL_ENC_RGL_MIWTENC foreign key (MRGL_SOURCE, MRGL_REFENC)
  references MIWTENC (MENC_SOURCE, MENC_REF);
alter table MIWTRGL
  add constraint FK_MIWTRGL_FACRGL_MIG_FAC foreign key (MRGL_SOURCE, MRGL_REFFAE)
  references MIWTFACTUREENTETE (MFAE_SOURCE, MFAE_REF);

prompt
prompt Creating table MIWTSECTEUR
prompt ==========================
prompt
create table MIWTSECTEUR
(
  sec_source VARCHAR2(200) not null,
  ts_code    VARCHAR2(10) not null,
  sec_ref    VARCHAR2(10) not null,
  sec_lib    VARCHAR2(200),
  sec_credt  DATE
)
tablespace MIG61
  pctfree 10
  initrans 1
  maxtrans 255;
comment on table MIWTSECTEUR
  is 'Liste des Secteurs';
comment on column MIWTSECTEUR.sec_source
  is 'Code source/origine';
comment on column MIWTSECTEUR.ts_code
  is 'Code de type Secteur';
comment on column MIWTSECTEUR.sec_ref
  is 'Code de Secteur';
comment on column MIWTSECTEUR.sec_lib
  is 'Libelle des Secteurs';
comment on column MIWTSECTEUR.sec_credt
  is 'Date de creation de secteur';
alter table MIWTSECTEUR
  add constraint PK_MIWTSECTEUR primary key (SEC_SOURCE, TS_CODE, SEC_REF)
  using index 
  tablespace USERS
  pctfree 10
  initrans 2
  maxtrans 255;

prompt
prompt Creating table MIWTSITE
prompt =======================
prompt
create table MIWTSITE
(
  site_source      VARCHAR2(100) not null,
  site_refe        VARCHAR2(20) not null,
  site_ref_adr     VARCHAR2(100),
  voc_premisetp    VARCHAR2(100),
  site_comment     VARCHAR2(4000),
  site_annee       NUMBER(4),
  site_surface     NUMBER(8,2),
  site_datcreation DATE
)
tablespace MIG61
  pctfree 10
  initrans 1
  maxtrans 255
  storage
  (
    initial 64K
    next 1M
    minextents 1
    maxextents unlimited
  );
comment on table MIWTSITE
  is 'Table Propriete-Adresse de livraison. Permet de regrouper les PDL.
  Par exemple dans le cas d''un immeuble, on peut avoir un PDL par appartement
  , ensuite l''immeuble est la propriété et cet immeuble peut lui meme
  faire partie d''un ensemble d''immeuble geré par un syndic';
comment on column MIWTSITE.site_source
  is 'Identifiant de la source de données [OBL]';
comment on column MIWTSITE.site_refe
  is 'Reference propriete';
comment on column MIWTSITE.site_ref_adr
  is 'Identifiant de l''adresse';
comment on column MIWTSITE.voc_premisetp
  is 'Type d''habitation: F1,F2, Maison';
comment on column MIWTSITE.site_comment
  is 'Commentaire libre';
comment on column MIWTSITE.site_annee
  is 'Annee de construction';
comment on column MIWTSITE.site_surface
  is 'Surface en m2';
comment on column MIWTSITE.site_datcreation
  is 'Date de creation';
alter table MIWTSITE
  add constraint PK_MIWTSITE primary key (SITE_SOURCE, SITE_REFE)
  using index 
  tablespace USERS
  pctfree 10
  initrans 2
  maxtrans 255
  storage
  (
    initial 64K
    next 1M
    minextents 1
    maxextents unlimited
  );
alter table MIWTSITE
  add constraint FK_MIWTSITE_SITE_REF_ADR foreign key (SITE_SOURCE, SITE_REF_ADR)
  references MIWTADR (MADR_SOURCE, MADR_REF);

prompt
prompt Creating table MIWTSITE_SAVE
prompt ============================
prompt
create table MIWTSITE_SAVE
(
  site_source      VARCHAR2(100) not null,
  site_refe        VARCHAR2(20) not null,
  site_ref_adr     VARCHAR2(100),
  voc_premisetp    VARCHAR2(100),
  site_comment     VARCHAR2(4000),
  site_annee       NUMBER(4),
  site_surface     NUMBER(8,2),
  site_datcreation DATE
)
tablespace MIG61
  pctfree 10
  initrans 1
  maxtrans 255;

prompt
prompt Creating table MIWTSOCIAL
prompt =========================
prompt
create table MIWTSOCIAL
(
  mtsocial_source   VARCHAR2(100) not null,
  mtsocial_ref_abnt VARCHAR2(100) not null,
  mtsocial_ddeb     DATE not null,
  mtsocial_dfin     DATE,
  voc_social        VARCHAR2(100)
)
tablespace MIG61
  pctfree 10
  initrans 1
  maxtrans 255;
comment on table MIWTSOCIAL
  is 'Table historique des caractéristiques sociales d’un client.';
comment on column MIWTSOCIAL.mtsocial_source
  is 'Code source/origine de  caractéristique sociale  [OBL]';
comment on column MIWTSOCIAL.mtsocial_ref_abnt
  is 'Référence du  caractéristique sociale  dans le SI source  ';
comment on column MIWTSOCIAL.mtsocial_ddeb
  is 'Date de debut  caractéristique sociale  ';
comment on column MIWTSOCIAL.mtsocial_dfin
  is 'date de fin du caractéristique sociale  ';
comment on column MIWTSOCIAL.voc_social
  is 'Liste de vocabulaire [Motif de status] : TPN, En cessation, Liquidé, FSL en cours, Marié, célébataire';
alter table MIWTSOCIAL
  add constraint PK_MIWTSOCIAL primary key (MTSOCIAL_SOURCE, MTSOCIAL_REF_ABNT)
  using index 
  tablespace USERS
  pctfree 10
  initrans 2
  maxtrans 255;
alter table MIWTSOCIAL
  add constraint FK_MTSOCIAL_REF_ABNT foreign key (MTSOCIAL_SOURCE, MTSOCIAL_REF_ABNT)
  references MIWABN (ABN_SOURCE, ABN_REF);

prompt
prompt Creating table MIWTTARIF
prompt ========================
prompt
create table MIWTTARIF
(
  mtarif_source          VARCHAR2(100) not null,
  mtarif_ref             VARCHAR2(100) not null,
  mtarif_refart          VARCHAR2(100) not null,
  mtarif_ctrtype_ref     VARCHAR2(100),
  voc_diam               VARCHAR2(100),
  mtarif_secteur         VARCHAR2(32),
  mtarif_plafond1        NUMBER,
  mtarif_plafond2        NUMBER,
  mtarif_plafond3        NUMBER,
  mtarif_plafond4        NUMBER,
  mtarif_plafond5        NUMBER,
  mtarif_plafond6        NUMBER,
  mtarif_plafond7        NUMBER,
  mtarif_plafond8        NUMBER,
  mtarif_plafond9        NUMBER,
  mtarif_plafond10       NUMBER,
  mtarif_prixplafond1    NUMBER(17,10),
  mtarif_prixplafond2    NUMBER(17,10),
  mtarif_prixplafond3    NUMBER(17,10),
  mtarif_prixplafond4    NUMBER(17,10),
  mtarif_prixplafond5    NUMBER(17,10),
  mtarif_prixplafond6    NUMBER(17,10),
  mtarif_prixplafond7    NUMBER(17,10),
  mtarif_prixplafond8    NUMBER(17,10),
  mtarif_prixplafond9    NUMBER(17,10),
  mtarif_prixplafond10   NUMBER(17,10),
  mtarif_formula1        VARCHAR2(100),
  mtarif_formula2        VARCHAR2(100),
  mtarif_formula3        VARCHAR2(100),
  mtarif_formula4        VARCHAR2(100),
  mtarif_formula5        VARCHAR2(100),
  mtarif_formula6        VARCHAR2(100),
  mtarif_formula7        VARCHAR2(100),
  mtarif_formula8        VARCHAR2(100),
  mtarif_formula9        VARCHAR2(100),
  mtarif_formula10       VARCHAR2(100),
  mtarif_prorata         NUMBER(1),
  mtarif_aduree          VARCHAR2(100),
  voc_usag               VARCHAR2(100),
  mtarif_date            DATE,
  mtarif_compte_vente    VARCHAR2(20),
  mtarif_compte_anat     VARCHAR2(100),
  mtarif_compte_tva      NUMBER,
  voc_forfaitsaisie      VARCHAR2(100),
  voc_forfaitfraction    VARCHAR2(100),
  mtarif_compte_nv       VARCHAR2(100),
  mtarif_libelle         VARCHAR2(4000),
  mtarif_cal_nom         VARCHAR2(100),
  mtarif_phs_nom         VARCHAR2(100),
  mtarif_libcompte_vente VARCHAR2(100),
  mtarif_formula         VARCHAR2(100)
)
tablespace MIG61
  pctfree 10
  initrans 1
  maxtrans 255;
comment on table MIWTTARIF
  is 'tarifs .';
comment on column MIWTTARIF.mtarif_source
  is 'Code source/origine de la tarifs  [OBL]';
comment on column MIWTTARIF.mtarif_ref
  is 'identifiant du tarifs  pour la migration : N° fourni par l''utilisateur (obligatoire)';
comment on column MIWTTARIF.mtarif_refart
  is 'identifiant interne de Ref. Article';
comment on column MIWTTARIF.mtarif_ctrtype_ref
  is 'identifiant interne de  Ref. Contrat Type';
comment on column MIWTTARIF.voc_diam
  is 'Diamètre';
comment on column MIWTTARIF.mtarif_secteur
  is 'Ref. Secteur (Commune)';
comment on column MIWTTARIF.mtarif_plafond1
  is ' Plafond1';
comment on column MIWTTARIF.mtarif_plafond2
  is ' Plafond2';
comment on column MIWTTARIF.mtarif_plafond3
  is ' Plafond3';
comment on column MIWTTARIF.mtarif_plafond4
  is ' Plafond4';
comment on column MIWTTARIF.mtarif_plafond5
  is 'd Plafond5';
comment on column MIWTTARIF.mtarif_prixplafond1
  is 'PrixPlafond1';
comment on column MIWTTARIF.mtarif_prixplafond2
  is 'PrixPlafond2';
comment on column MIWTTARIF.mtarif_prixplafond3
  is 'PrixPlafond3';
comment on column MIWTTARIF.mtarif_prixplafond4
  is 'PrixPlafond4';
comment on column MIWTTARIF.mtarif_prixplafond5
  is 'PrixPlafond5';
comment on column MIWTTARIF.mtarif_prorata
  is ' Prorata O/N  1 = Oui ,0 =Non';
comment on column MIWTTARIF.mtarif_aduree
  is 'Application Durée (Synchro Relève, Par avance)';
comment on column MIWTTARIF.voc_usag
  is 'Application  tarif en fonction de l’usage (Professionnel, Domestique)';
comment on column MIWTTARIF.voc_forfaitsaisie
  is 'Saisie du prix pour les durées: A: année, S: Semestre, M:mois, J: jours';
comment on column MIWTTARIF.voc_forfaitfraction
  is 'Fraction de calcul pour les durées: A: année, S: Semestre, M:mois, J: jours';
comment on column MIWTTARIF.mtarif_compte_nv
  is 'Compte pour les passages en non valeurs';
alter table MIWTTARIF
  add constraint PK_MIWTTARIF primary key (MTARIF_SOURCE, MTARIF_REF)
  using index 
  tablespace USERS
  pctfree 10
  initrans 2
  maxtrans 255;
alter table MIWTTARIF
  add constraint FK_MTARIF_CTRTYPE_REF foreign key (MTARIF_SOURCE, MTARIF_CTRTYPE_REF)
  references MIWCTRTYPE (CTRTYPE_SOURCE, CTRTYPE_REF);
alter table MIWTTARIF
  add constraint FK_MTARIF_REFART foreign key (MTARIF_SOURCE, MTARIF_REFART)
  references MIWTART (MART_SOURCE, MART_REFART);

prompt
prompt Creating table MIWTTOURNEE
prompt ==========================
prompt
create table MIWTTOURNEE
(
  mtou_source    VARCHAR2(100) not null,
  mtou_ref       VARCHAR2(100) not null,
  mtou_code      VARCHAR2(20),
  mtou_libe      VARCHAR2(200) not null,
  mtou_sem1      VARCHAR2(10),
  mtou_sem2      VARCHAR2(10),
  mtou_sem3      VARCHAR2(10),
  mtou_sem4      VARCHAR2(10),
  mtou_sem5      VARCHAR2(10),
  mtou_sem6      VARCHAR2(10),
  mtou_sem7      VARCHAR2(10),
  mtou_sem8      VARCHAR2(10),
  mtou_sem9      VARCHAR2(10),
  mtou_sem10     VARCHAR2(10),
  mtou_sem11     VARCHAR2(10),
  mtou_sem12     VARCHAR2(10),
  mtou_agesource VARCHAR2(100),
  rou_id         NUMBER
)
tablespace MIG61
  pctfree 10
  initrans 1
  maxtrans 255
  storage
  (
    initial 64K
    next 1M
    minextents 1
    maxextents unlimited
  );
comment on table MIWTTOURNEE
  is 'Les tournées';
comment on column MIWTTOURNEE.mtou_source
  is 'Identifiant de la source de données [OBL]';
comment on column MIWTTOURNEE.mtou_ref
  is 'Référence de la tournée dans le SI source (le couple source/référence doit être unique) [OBL]';
comment on column MIWTTOURNEE.mtou_code
  is 'Code de la tournée (uniqument des chiffres) [TA 5] [OBL]';
comment on column MIWTTOURNEE.mtou_libe
  is 'Libellé de la tournée [TA 30] [OBL]';
comment on column MIWTTOURNEE.mtou_sem1
  is 'Numéro de semaine de la première relève';
comment on column MIWTTOURNEE.mtou_sem2
  is 'Numéro de semaine de la seconde relève';
comment on column MIWTTOURNEE.mtou_sem3
  is 'Numéro de semaine de la troisième relève';
comment on column MIWTTOURNEE.mtou_sem4
  is 'Numéro de semaine de la quatrième relève';
comment on column MIWTTOURNEE.mtou_agesource
  is 'Identifiant de l''agent affect? par defaut ? la tournee';
alter table MIWTTOURNEE
  add constraint PK_MIWTTOURNEE primary key (MTOU_SOURCE, MTOU_REF)
  using index 
  tablespace USERS
  pctfree 10
  initrans 2
  maxtrans 255
  storage
  (
    initial 64K
    next 1M
    minextents 1
    maxextents unlimited
  );

prompt
prompt Creating table MIWTTYPESECTEUR
prompt ==============================
prompt
create table MIWTTYPESECTEUR
(
  ts_source VARCHAR2(200) not null,
  ts_code   VARCHAR2(10) not null,
  ts_lib    VARCHAR2(200)
)
tablespace MIG61
  pctfree 10
  initrans 1
  maxtrans 255;
comment on table MIWTTYPESECTEUR
  is 'Liste des types Secteur';
comment on column MIWTTYPESECTEUR.ts_source
  is 'Code source/origine';
comment on column MIWTTYPESECTEUR.ts_code
  is 'Code de type Secteur';
comment on column MIWTTYPESECTEUR.ts_lib
  is 'Libelle de type Secteur';
alter table MIWTTYPESECTEUR
  add constraint PK_MIWTTYPESECTEUR primary key (TS_SOURCE, TS_CODE)
  using index 
  tablespace USERS
  pctfree 10
  initrans 2
  maxtrans 255;

prompt
prompt Creating table MIWTVOCABLE
prompt ==========================
prompt
create table MIWTVOCABLE
(
  mvoc_type VARCHAR2(100) not null,
  mvoc_ref  VARCHAR2(100) not null,
  mvoc_libe VARCHAR2(200) not null
)
tablespace MIG61
  pctfree 10
  initrans 1
  maxtrans 255;
comment on table MIWTVOCABLE
  is 'Table Pivot Vocabulaires Client';
comment on column MIWTVOCABLE.mvoc_type
  is 'Type de vocabulaire ';
comment on column MIWTVOCABLE.mvoc_ref
  is 'Identifiant unique de l élément de vocabulaire ';
comment on column MIWTVOCABLE.mvoc_libe
  is 'Libellé de l élément de vocabulaire ';
alter table MIWTVOCABLE
  add constraint PK_MIWTVOCABLE primary key (MVOC_TYPE, MVOC_REF)
  using index 
  tablespace USERS
  pctfree 10
  initrans 2
  maxtrans 255;

prompt
prompt Creating table PDL_ABSSENT
prompt ==========================
prompt
create table PDL_ABSSENT
(
  mrel_refpdl VARCHAR2(100)
)
tablespace MIG61
  pctfree 10
  initrans 1
  maxtrans 255;

prompt
prompt Creating table PROB_MIGRATION
prompt =============================
prompt
create table PROB_MIGRATION
(
  nom_table    VARCHAR2(100),
  val_ref      VARCHAR2(200),
  sql_err      VARCHAR2(200),
  date_pro     DATE,
  type_problem VARCHAR2(200)
)
tablespace MIG61
  pctfree 10
  initrans 1
  maxtrans 255
  storage
  (
    initial 64K
    next 1M
    minextents 1
    maxextents unlimited
  );

prompt
prompt Creating table PROB_MIGRATION_SAVE
prompt ==================================
prompt
create table PROB_MIGRATION_SAVE
(
  nom_table VARCHAR2(100),
  val_ref   VARCHAR2(200),
  sql_err   VARCHAR2(200),
  date_pro  DATE
)
tablespace MIG61
  pctfree 10
  initrans 1
  maxtrans 255;

prompt
prompt Creating table PROB_MIGRATION_SAVE1
prompt ===================================
prompt
create table PROB_MIGRATION_SAVE1
(
  nom_table VARCHAR2(100),
  val_ref   VARCHAR2(200),
  sql_err   VARCHAR2(200),
  date_pro  DATE
)
tablespace MIG61
  pctfree 10
  initrans 1
  maxtrans 255;

prompt
prompt Creating table PROB_MIGRATION_SAVE2
prompt ===================================
prompt
create table PROB_MIGRATION_SAVE2
(
  nom_table VARCHAR2(100),
  val_ref   VARCHAR2(200),
  sql_err   VARCHAR2(200),
  date_pro  DATE
)
tablespace MIG61
  pctfree 10
  initrans 1
  maxtrans 255;

prompt
prompt Creating table RELEVE_MANQ_CPT
prompt ==============================
prompt
create table RELEVE_MANQ_CPT
(
  mrel_source        VARCHAR2(100) not null,
  mrel_ref           VARCHAR2(100) not null,
  mrel_refpdl        VARCHAR2(100),
  mrel_refcom        VARCHAR2(100),
  mrel_date          DATE not null,
  mrel_index1        NUMBER(10),
  mrel_index2        NUMBER(10),
  mrel_index3        NUMBER(10),
  mrel_index4        NUMBER(10),
  mrel_index5        NUMBER(10),
  mrel_index6        NUMBER(10),
  mrel_index7        NUMBER(10),
  mrel_index8        NUMBER(10),
  mrel_index9        NUMBER(10),
  mrel_index10       NUMBER(10),
  mrel_index11       NUMBER(10),
  mrel_index12       NUMBER(10),
  mrel_conso1        NUMBER(10),
  mrel_conso2        NUMBER(10),
  mrel_conso3        NUMBER(10),
  mrel_conso4        NUMBER(10),
  mrel_conso5        NUMBER(10),
  mrel_conso6        NUMBER(10),
  mrel_conso7        NUMBER(10),
  mrel_conso8        NUMBER(10),
  mrel_conso9        NUMBER(10),
  mrel_conso10       NUMBER(10),
  mrel_conso11       NUMBER(10),
  mrel_conso12       NUMBER(10),
  mrel_cadran1       VARCHAR2(6),
  mrel_cadran2       VARCHAR2(6),
  mrel_cadran3       VARCHAR2(6),
  mrel_cadran4       VARCHAR2(6),
  mrel_cadran5       VARCHAR2(6),
  mrel_cadran6       VARCHAR2(6),
  mrel_cadran7       VARCHAR2(6),
  mrel_cadran8       VARCHAR2(6),
  mrel_cadran9       VARCHAR2(6),
  mrel_cadran10      VARCHAR2(6),
  mrel_cadran11      VARCHAR2(6),
  mrel_cadran12      VARCHAR2(6),
  mrel_cadran_coff1  VARCHAR2(6),
  mrel_cadran_coff2  VARCHAR2(6),
  mrel_cadran_coff3  VARCHAR2(6),
  mrel_cadran_coff4  VARCHAR2(6),
  mrel_cadran_coff5  VARCHAR2(6),
  mrel_cadran_coff6  VARCHAR2(6),
  mrel_cadran_coff7  VARCHAR2(6),
  mrel_cadran_coff8  VARCHAR2(6),
  mrel_cadran_coff9  VARCHAR2(6),
  mrel_cadran_coff10 VARCHAR2(6),
  mrel_cadran_coff11 VARCHAR2(6),
  mrel_cadran_coff12 VARCHAR2(6),
  mrel_deduite       NUMBER(10),
  mrel_facturee      NUMBER(1) not null,
  voc_comm1          VARCHAR2(100),
  voc_comm2          VARCHAR2(100),
  voc_comm3          VARCHAR2(100),
  voc_readorig       VARCHAR2(100),
  voc_readcode       VARCHAR2(100),
  voc_readmeth       VARCHAR2(100),
  voc_readreason     VARCHAR2(100),
  mrel_agrtype       VARCHAR2(100),
  mrel_techtype      VARCHAR2(100),
  mrel_etatfact      VARCHAR2(100),
  mrel_comlibre      VARCHAR2(4000),
  mrel_agesource     VARCHAR2(100),
  mrel_ageref        VARCHAR2(100),
  mrel_fact1         VARCHAR2(100),
  mrel_fact2         VARCHAR2(100),
  mrel_subread       NUMBER,
  mrel_conso_ref1    NUMBER,
  mrel_conso_ref2    NUMBER,
  mrel_conso_ref3    NUMBER,
  mrel_conso_ref4    NUMBER,
  mrel_conso_ref5    NUMBER,
  mrel_conso_ref6    NUMBER,
  mrel_conso_ref7    NUMBER,
  mrel_conso_ref8    NUMBER,
  mrel_conso_ref9    NUMBER,
  mrel_conso_ref10   NUMBER,
  mrel_conso_ref11   NUMBER,
  mrel_conso_ref12   NUMBER,
  mrel_ano_c1        VARCHAR2(2),
  mrel_ano_c2        VARCHAR2(2),
  mrel_ano_c3        VARCHAR2(2),
  mrel_ano_n1        VARCHAR2(2),
  mrel_ano_n2        VARCHAR2(2),
  mrel_ano_n3        VARCHAR2(2),
  mrel_ano_f1        VARCHAR2(2),
  mrel_ano_f2        VARCHAR2(2),
  mrel_ano_f3        VARCHAR2(2),
  periode            NUMBER,
  annee              NUMBER,
  mrd_id             NUMBER,
  mme_id1            NUMBER,
  mme_id2            NUMBER,
  mme_id3            NUMBER,
  mme_id4            NUMBER,
  mme_id5            NUMBER,
  mme_id6            NUMBER,
  meu_id1            NUMBER,
  meu_id2            NUMBER,
  meu_id3            NUMBER,
  meu_id4            NUMBER,
  meu_id5            NUMBER,
  meu_id6            NUMBER,
  mme_id             NUMBER,
  meu_id             NUMBER,
  spt_id             NUMBER,
  equ_id             NUMBER,
  age_id             NUMBER,
  mtc_id             NUMBER
)
tablespace MIG61
  pctfree 10
  initrans 1
  maxtrans 255;

prompt
prompt Creating table TEST
prompt ===================
prompt
create table TEST
(
  val VARCHAR2(100),
  ref VARCHAR2(100),
  tou VARCHAR2(100)
)
tablespace MIG61
  pctfree 10
  initrans 1
  maxtrans 255;

prompt
prompt Creating table XX
prompt =================
prompt
create table XX
(
  distirct    VARCHAR2(2),
  tourne      VARCHAR2(3),
  ordre       VARCHAR2(3),
  annee       VARCHAR2(4),
  periode     VARCHAR2(2),
  mfal_reffae VARCHAR2(100) not null,
  net_calc    NUMBER,
  net         NUMBER(10,3),
  diff        NUMBER,
  capit       NUMBER
)
tablespace MIG61
  pctfree 10
  initrans 1
  maxtrans 255
  storage
  (
    initial 64K
    next 1M
    minextents 1
    maxextents unlimited
  );

prompt
prompt Creating synonym ABN_CAT7
prompt =========================
prompt
create or replace synonym ABN_CAT7
  for DISTRICT61.ABN_CAT7;

prompt
prompt Creating synonym ABONNEES
prompt =========================
prompt
create or replace synonym ABONNEES
  for DISTRICT61.ABONNEES;

prompt
prompt Creating synonym ABONNEES_GR
prompt ============================
prompt
create or replace synonym ABONNEES_GR
  for DISTRICT61.ABONNEES_GR;

prompt
prompt Creating synonym ABONNES_GC
prompt ===========================
prompt
create or replace synonym ABONNES_GC
  for DISTRICT61.ABONNEES_GR;

prompt
prompt Creating synonym ABONNES_PART
prompt =============================
prompt
create or replace synonym ABONNES_PART
  for DISTRICT61.ABONNES_PART;

prompt
prompt Creating synonym ABONNESS
prompt =========================
prompt
create or replace synonym ABONNESS
  for DISTRICT61.ABONNEES;

prompt
prompt Creating synonym ADM
prompt ====================
prompt
create or replace synonym ADM
  for DISTRICT61.ADM;

prompt
prompt Creating synonym ADRESS_FACTURATION
prompt ===================================
prompt
create or replace synonym ADRESS_FACTURATION
  for DISTRICT61.ADRESS_FACTURATION;

prompt
prompt Creating synonym ANOMALIES_RELEVE
prompt =================================
prompt
create or replace synonym ANOMALIES_RELEVE
  for DISTRICT61.ANOMALIES_RELEVE;

prompt
prompt Creating synonym BRANCHEMENT
prompt ============================
prompt
create or replace synonym BRANCHEMENT
  for DISTRICT61.BRANCHEMENT;

prompt
prompt Creating synonym B2
prompt ===================
prompt
create or replace synonym B2
  for DISTRICT61.B2;

prompt
prompt Creating synonym CATEGORIE
prompt ==========================
prompt
create or replace synonym CATEGORIE
  for DISTRICT61.CATEGORIE;

prompt
prompt Creating synonym CCP
prompt ====================
prompt
create or replace synonym CCP
  for DISTRICT61.CCP;

prompt
prompt Creating synonym CLIENT
prompt =======================
prompt
create or replace synonym CLIENT
  for DISTRICT61.CLIENT;

prompt
prompt Creating synonym COMPTEUR
prompt =========================
prompt
create or replace synonym COMPTEUR
  for DISTRICT61.COMPTEUR;

prompt
prompt Creating synonym DOMICILIER_BANCAIRE
prompt ====================================
prompt
create or replace synonym DOMICILIER_BANCAIRE
  for DISTRICT61.DOMICILIER_BANCAIRE;

prompt
prompt Creating synonym FACTURE
prompt ========================
prompt
create or replace synonym FACTURE
  for DISTRICT61.FACTURE;

prompt
prompt Creating synonym FACTURE_AS400
prompt ==============================
prompt
create or replace synonym FACTURE_AS400
  for DISTRICT61.FACTURE_AS400;

prompt
prompt Creating synonym FACTURE_AS400GC
prompt ================================
prompt
create or replace synonym FACTURE_AS400GC
  for DISTRICT61.FACTURE_AS400GC;

prompt
prompt Creating synonym FACTURE_AS400GC_1
prompt ==================================
prompt
create or replace synonym FACTURE_AS400GC_1
  for DISTRICT61.FACTURE_AS400GC_1;

prompt
prompt Creating synonym FACTURE_AS400_2016
prompt ===================================
prompt
create or replace synonym FACTURE_AS400_2016
  for DIST20.FACTURE_AS400_2016;

prompt
prompt Creating synonym FAIRE_SUIVRE_GC
prompt ================================
prompt
create or replace synonym FAIRE_SUIVRE_GC
  for DISTRICT61.FAIRE_SUIVRE_GC;

prompt
prompt Creating synonym FAIRE_SUIVRE_PART
prompt ==================================
prompt
create or replace synonym FAIRE_SUIVRE_PART
  for DISTRICT61.FAIRE_SUIVRE_PART;

prompt
prompt Creating synonym FICHE_RELEVE
prompt =============================
prompt
create or replace synonym FICHE_RELEVE
  for DISTRICT61.FICHE_RELEVE;

prompt
prompt Creating synonym F_RELEVE
prompt =========================
prompt
create or replace synonym F_RELEVE
  for DISTRICT61.F_RELEVE;

prompt
prompt Creating synonym GESTION_COMPTEUR
prompt =================================
prompt
create or replace synonym GESTION_COMPTEUR
  for DISTRICT61.GESTION_COMPTEUR;

prompt
prompt Creating synonym IMPAYEES
prompt =========================
prompt
create or replace synonym IMPAYEES
  for DISTRICT61.IMPAYEES;

prompt
prompt Creating synonym IMPAYEES_GC
prompt ============================
prompt
create or replace synonym IMPAYEES_GC
  for DISTRICT61.IMPAYEES_GC;

prompt
prompt Creating synonym IMPAYEES_PART
prompt ==============================
prompt
create or replace synonym IMPAYEES_PART
  for DISTRICT61.IMPAYEES_PART;

prompt
prompt Creating synonym IMP_GC
prompt =======================
prompt
create or replace synonym IMP_GC
  for DISTRICT.IMP_GC;

prompt
prompt Creating synonym IMP_PART
prompt =========================
prompt
create or replace synonym IMP_PART
  for DISTRICT.IMP_PART;

prompt
prompt Creating synonym LISTEANOMALIES_RELEVE
prompt ======================================
prompt
create or replace synonym LISTEANOMALIES_RELEVE
  for DISTRICT61.LISTEANOMALIES_RELEVE;

prompt
prompt Creating synonym MARQUE
prompt =======================
prompt
create or replace synonym MARQUE
  for DISTRICT61.MARQUE;

prompt
prompt Creating synonym MVT_PUIT_ONAS
prompt ==============================
prompt
create or replace synonym MVT_PUIT_ONAS
  for DISTRICT61.MVT_PUIT_ONAS;

prompt
prompt Creating synonym PARAM_TOURNEE
prompt ==============================
prompt
create or replace synonym PARAM_TOURNEE
  for DISTRICT61.PARAM_TOURNEE;

prompt
prompt Creating synonym R_CPOSTAL
prompt ==========================
prompt
create or replace synonym R_CPOSTAL
  for DISTRICT61.R_CPOSTAL;

prompt
prompt Creating synonym RELEVEGC
prompt =========================
prompt
create or replace synonym RELEVEGC
  for DISTRICT61.RELEVEGC;

prompt
prompt Creating synonym RELEVET
prompt ========================
prompt
create or replace synonym RELEVET
  for DISTRICT61.RELEVET;

prompt
prompt Creating synonym RIB_GR
prompt =======================
prompt
create or replace synonym RIB_GR
  for DISTRICT61.RIB_GR;

prompt
prompt Creating synonym RIB_PART
prompt =========================
prompt
create or replace synonym RIB_PART
  for DISTRICT61.RIB_PART;

prompt
prompt Creating synonym ROLE_MENS
prompt ==========================
prompt
create or replace synonym ROLE_MENS
  for DISTRICT61.ROLE_MENS;

prompt
prompt Creating synonym ROLE_MONS
prompt ==========================
prompt
create or replace synonym ROLE_MONS
  for DISTRICT61.ROLE_MONS;

prompt
prompt Creating synonym ROLE_TRIM
prompt ==========================
prompt
create or replace synonym ROLE_TRIM
  for DISTRICT61.ROLE_TRIM;

prompt
prompt Creating synonym TOURNE
prompt =======================
prompt
create or replace synonym TOURNE
  for DISTRICT61.TOURNE;

prompt
prompt Creating package MIWTADRESSEPIVOT
prompt =================================
prompt
CREATE OR REPLACE PACKAGE miwtADRESSEPIVOT IS


    PROCEDURE MIG_ADR(V_ADRESSE_   IN VARCHAR2,
                      V_AD_VILRUE_ IN NUMBER,
                      V_CODE_POSTAL_ IN VARCHAR2,
                      v_district  in varchar2,
                       V_AD_NUM_    IN OUT NUMBER);

END miwtADRESSEPIVOT;
/

prompt
prompt Creating package PCK_MIG_FACTURE
prompt ================================
prompt
create or replace package PCK_MIG_FACTURE is
  -- Created : 15/03/2016 09:17:24
  --1---Transfert des facture particulier AS400
    PROCEDURE MIWT_FACTURE_aS400 (v_district in varchar2) ;
  --2---Transfert des facture gros consomateur AS400
    PROCEDURE MIWT_FACTURE_aS400gc (v_district in varchar2) ;
  --3---Transfert des facture Annuller et reprise DISTRICT6100
    PROCEDURE MIWT_FACTURE_DIST (v_district in varchar2);

    procedure miwt_fact_trav(v_district varchar2);
-----Transfert des Encassement CCP
    procedure MIWT_ENC (v_district in varchar2);
--4---Transfert des Encassement(Reglement qui n'existe dans la table impayées
    procedure MIWT_ENC_1 (v_district in varchar2);
 ---6--Generation des Encassement partiellement payées
procedure MIWT_ENC_2 (v_district in varchar2);
---5--Géneration des facture apartir de la table impayéés
    procedure MIWT_FACTURE_IMPAYEE (v_district in varchar2);
end PCK_MIG_FACTURE;
/

prompt
prompt Creating package PCK_MIG_FACTURE_NEW
prompt ====================================
prompt
create or replace package PCK_MIG_FACTURE_new is
  -- Created : 15/03/2016 09:17:24
  --1---Transfert des facture particulier AS400
    PROCEDURE MIWT_FACTURE_aS400 (v_district in varchar2) ;
  --2---Transfert des facture gros consomateur AS400
    PROCEDURE MIWT_FACTURE_aS400gc (v_district in varchar2) ;
  --3---Transfert des facture  DISTRICT2400
    PROCEDURE MIWT_FACTURE_DIST (v_district in varchar2);
--4---Transfert des facture Annuller et reprise DISTRICT2400
    PROCEDURE MIWT_FACTURE_VERSION (v_district in varchar2);
PROCEDURE MIWT_FACTURE_IMPAYEE (v_district in varchar2);


end PCK_MIG_FACTURE_new;
/

prompt
prompt Creating package PK_WORQUOTATION
prompt ================================
prompt
CREATE OR REPLACE PACKAGE "PK_WORQUOTATION"
AS
--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
PROCEDURE Quotation_Get_Chrono
  (
    p_quo_id  out WORQUOTATION.quo_id%type,
  p_quo_ref out WORQUOTATION.quo_ref%type
  );
--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
PROCEDURE Update_param_chrono_QUOT(p_quo_id number) ;
--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

PROCEDURE Add
  (
    p_quo_id        out WORQUOTATION.quo_id %type,
    p_quo_ref       in out WORQUOTATION.quo_ref %type,
    p_quo_libelle in out WORQUOTATION.quo_libelle %type,
    p_adr_id      in WORQUOTATION.adr_id %type,
    p_wot_id      in WORQUOTATION.wot_id %type,
    p_quo_dt_emis in WORQUOTATION.quo_dt_emis %type,
    p_quo_acompte   in WORQUOTATION.quo_acompte %type,
    p_quo_comment   in WORQUOTATION.quo_comment %type,
    p_quo_htamount  in WORQUOTATION.quo_htamount %type,
    p_quo_tvamount  in WORQUOTATION.quo_tvamount %type,
    p_quo_ttcamount in WORQUOTATION.quo_ttcamount %type,
    p_quo_credt in WORQUOTATION.quo_credt %type,
    p_quo_updtdt in WORQUOTATION.quo_updtdt %type,
    p_quo_updtby in WORQUOTATION.quo_updtby %type,
    p_pre_id     in WORQUOTATION.pre_id %type,
    p_par_id    in WORQUOTATION.par_id %type,
    p_tva_id     in WORQUOTATION.tva_id %type,
    p_ctt_id     in WORQUOTATION.ctt_id %type
  );
----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
PROCEDURE SetAmountWorquotation
  (
    p_quo_id        in WORQUOTATION.quo_id %type,
    p_quo_htamount  in out WORQUOTATION.quo_htamount %type,
    p_quo_tvamount  in out WORQUOTATION.quo_tvamount %type,
    p_quo_ttcamount in out WORQUOTATION.quo_ttcamount %type,
    p_quo_updtby    in WORQUOTATION.quo_updtby %type
  );
----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
PROCEDURE CreateQuotation
  (
      p_quo_id out worquotation.quo_id%type,
      p_pie_id in  tecpreinfoetude.pie_id%type,
      p_pre_id in  worquotation.pre_id%type,
      p_spt_id in  tecservicepoint.spt_id%type,
      p_par_id in  worquotation.par_id%type,
      p_adr_id in  worquotation.adr_id%type,
      p_wot_id in  worquotation.wot_id%type,
      p_ctt_id in  worquotation.ctt_id%type,
      p_age_id in  genagent.age_id    %type
  );
----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
FUNCTION HASTHESAMEVOW
  (
    p_pie_id tecpreinfoetude.pie_id%type,
    p_spt_id tecservicepoint.spt_id%type,
    p_vow_id genvocword.vow_id%type,
    p_tar_id genitemtarif.tar_id%type
  )return number;
---------------------------------------------------------------------------------------------------------------------------------
FUNCTION GETTARBYPRE
  (
    p_pie_id   tecpreinfoetude.pre_id %type,
    p_spt_id   tecservicepoint.spt_id%type,
    p_ite_id   genitem.ite_id%type
  ) return genitemtarif.tar_id%type;
---------------------------------------------------------------------------------------------------------------------------------
PROCEDURE RecalculQuotationDbs
  (
    p_quo_id worquotation.quo_id%type,
    p_age_id genagent.age_id%type
  );
PROCEDURE RemplirWorwortype
  (
    p_wot_id worwotype.wot_id%type,
    p_age_id genagent.age_id%type
  );
FUNCTION SelectItemByEtude
  (
    p_ite_id genitem.ite_id%type,
    p_pie_id  tecpreinfoetude.pie_id%type
  ) return number;
  function SelectQteByEtude
  (
    p_ite_id genitem.ite_id%type,
    p_pie_id  tecpreinfoetude.pie_id%type
  ) return number;
end PK_WORQUOTATION;
/

prompt
prompt Creating procedure BRANCH_RESIL
prompt ===============================
prompt
create or replace procedure branch_resil (v_district varchar2)
is


cursor c is (select distinct  periode, ref_pdl,etat from (
                select nvl(w.date_action,null) periode ,trim(t.tourne)||trim(t.ordre) ref_pdl,'G' etat
                from branchement t,gestion_compteur w
                where trim(t.etat_branchement)='9'
                and trim(t.compteur_actuel) is null
                and trim(w.tournee)||trim(w.ordre)=trim(t.tourne)||trim(t.ordre)
                and UPPER(TRIM(w.ACTION))='D'
                and t.district=v_district
                /*and w.rowid=(select n.rowid from gestion_compteur n
                              where trim(w.tournee)||trim(w.ordre)=trim(n.tournee)||trim(n.ordre)
                              and UPPER(TRIM(n.ACTION))='D'*/
                              and to_date(w.date_action,'dd/mm/yyyy') =
                                           ( select max(to_date(s.date_action,'dd/mm/yyyy'))
                                             from gestion_compteur s
                                             where trim(s.tournee)||trim(s.ordre)=trim(w.tournee)||trim(w.ordre)
                                             and UPPER(TRIM(s.ACTION))='D'
                                             ))x
              );
                            /*  and rownum=1)*/
--------------------------------------
cursor F is (select distinct  periode, ref_pdl,etat from (

                              select f.annee||f.periode periode,trim(f.tournee)||trim(f.ordre) ref_pdl,'F' etat
                              from branchement t,facture f
                              where trim(t.etat_branchement)='9'
                              and  trim(t.compteur_actuel) is null
                              and trim(f.tournee)||trim(f.ordre)=trim(t.tourne)||trim(t.ordre)
                              and f.district=v_district
                              and t.district=v_district
                              and f.rowid=(select n.rowid
                                            from facture n
                                            where trim(f.tournee)||trim(f.ordre)=trim(n.tournee)||trim(n.ordre)
                                            and to_number(n.annee)||to_number(n.periode) =
                                                        (select max(to_number(s.annee)||to_number(s.periode))
                                                         from facture s
                                                         where trim(s.tournee)||trim(s.ordre)=trim(n.tournee)||trim(n.ordre)
                                                         )
                                             and rownum=1))x);

--------------------------
cursor R is (select  periode, ref_pdl,etat from (
                            select sf.annee||trim(sf.trim) periode ,trim(sf.tourne)||trim(sf.ordre) ref_pdl,'R' etat
                            from fiche_releve  sf,branchement t
                            where trim(t.etat_branchement)='9'
                            and  trim(t.compteur_actuel) is null
                            and trim(sf.tourne)||trim(sf.ordre)=trim(t.tourne)||trim(t.ordre)
                            and sf.district=v_district
                            and t.district=v_district
                            and  sf.rowid = (select f.rowid
                                             from fiche_releve f
                                            where trim(f.tourne)||trim(f.ordre)=trim(sf.tourne)||trim(sf.ordre)
                                            and to_number(f.annee)||to_number(nvl(trim(f.trim),0)) =(select max(to_number(s.annee)||to_number(nvl(trim(s.trim),0)))
                                                                                                       from fiche_releve s
                                                                                                       where trim(s.tourne)||trim(s.ordre)=trim(f.tourne)||trim(f.ordre)
                                                                                                     )

                                and rownum=1))x);
 ------------rest branch_resil                               
cursor B is select distinct  trim(b.tourne)||trim(b.ordre) ref_pdl from branchement b where trim(b.etat_branchement)='9'
                 and trim(b.tourne)||trim(b.ordre) not in(select r.ref_pdl 
                 from branchement_res_max r   )       ;                       

err_code    varchar2(200);
err_msg     varchar2(200);
v_date      date;
v_trim      number;
v_periode    varchar2(10);
begin

   delete from  branchement_res m where m.dist=v_district;
   delete from branchement_res_max b where b.dist=v_district;
   delete from prob_migration p where p.nom_table in ('Branch_resil','Branch_res_date_res');
   insert into prob_migration (nom_table)values(SYSTIMESTAMP||'   START Branch_resil');
    commit;

 for x in c loop
    begin
 --------------insertion branchement resil (gestion_compteur)
insert into BRANCHEMENT_RES
  (PERIODE, REF_PDL, ETAT,dist)
values
  (trim(x.periode), x.ref_pdl, x.etat,v_district);
commit;
    exception
        when others then
          err_code := SQLCODE;
          err_msg  := SUBSTR(SQLERRM, 1, 200);

          insert into prob_migration
            (nom_table, val_ref, sql_err, date_pro,type_problem)
          values
            ('Branch_resil',
             x.ref_pdl || '--' || x.periode || '--' || x.etat,
             err_code || '--' || err_msg,sysdate,'insertion tab branchement_resil C');
 end;
 commit;

end loop;


for x in F loop
    begin
 --------------insertion branchement resil(facture)
insert into BRANCHEMENT_RES
  (PERIODE, REF_PDL, ETAT,dist)
values
  (trim(x.periode), x.ref_pdl, x.etat,v_district);
commit;
    exception
        when others then
          err_code := SQLCODE;
          err_msg  := SUBSTR(SQLERRM, 1, 200);

          insert into prob_migration
            (nom_table, val_ref, sql_err, date_pro,type_problem)
          values
            ('Branch_resil',
             x.ref_pdl || '--' || x.periode || '--' || x.etat,
             err_code || '--' || err_msg,sysdate,'insertion tab branchement_resil F');
 end;
 commit;

end loop;


 for x in R loop
    begin
 --------------insertion branchement resil(fiche_releve)
insert into BRANCHEMENT_RES
  (PERIODE, REF_PDL, ETAT,dist)
values
  (trim(x.periode), x.ref_pdl, x.etat,v_district);
commit;
    exception
        when others then
          err_code := SQLCODE;
          err_msg  := SUBSTR(SQLERRM, 1, 200);

          insert into prob_migration
            (nom_table, val_ref, sql_err, date_pro,type_problem)
          values
            ('Branch_resil',
             x.ref_pdl || '--' || x.periode || '--' || x.etat,
             err_code || '--' || err_msg,sysdate,'insertion tab branchement_resil  R');
 end;
 commit;

end loop;



-----------------update date_resil
begin
  for c in (select e.ref_pdl refpdl,e.periode,e.rowid,e.etat,e.dist
    from BRANCHEMENT_RES e
    where e.etat in ('F','R','G')
    and e.dist=v_district)loop
v_date:=null;
   begin
  if (length(c.periode)>6) then
         select '07/'|| LPAD(substr(c.periode,4, 2),2,'0') || '/' ||substr(c.periode,7, 4)
           into v_date
         from dual;

  elsif(length(c.periode)=5)then

        select '07/'|| LPAD(t.m3, 2,'0')||'/'||substr(c.periode,1, 4)
        into v_date
        from param_tournee t,tourne r
        where trim(r.ntiers)=trim(t.tier)
        and   trim(r.nsixieme)=triM(t.six)
        and   trim(t.district)=v_district
        and   c.dist=v_district
        and   r.code=substr(c.refpdl,1,3)
        and   trim(t.trim)=substr(c.periode,5,1)
        and   length(c.periode)=5;

        ------------------------------
 elsif (length(c.periode)=6)then
for v in  (select r.ref_pdl refpdl,r.periode,r.DIST,r.rowid
           from BRANCHEMENT_RES r
            where r.etat in ('F','R','G')
            and r.ref_pdl=c.refpdl
            and r.etat=c.etat
            and length(c.periode)=6
            and length(r.periode)=6
            and r.DIST=c.dist
            )
    loop

   v_periode:=substr(v.periode,5,2);
  if((v_periode)in('01','02','03')) then
  v_trim:=1;
  elsif((v_periode)in('04','05','06')) then
    v_trim:=2;
    elsif ((v_periode)in('7','8','9')) then
      v_trim:=3;
      elsif((v_periode)in('10','11','12')) then
      v_trim:=4;
      end if;

       select '07/'||LPAD(t.m3,2,'0')||'/'||substr(b.periode,1,4) into v_date
      from param_tournee t,tourne r,BRANCHEMENT_RES  b
      where trim(r.ntiers)=trim(t.tier)
      and   trim(r.nsixieme)=triM(t.six)
      and   trim(t.district)=v.DIST
      and   r.code=substr(v.refpdl,1,3)
      and   b.ref_pdl=v.refpdl
      and   trim(b.etat) in ('F','R','G')
      and   trim(t.trim)=v_trim
      and   length(b.periode)=6;
end loop;

end if;

  exception when others then v_date:='01/01/1900';
  err_code := SQLCODE;
  err_msg  := SUBSTR(SQLERRM, 1, 200);
  insert into PROB_MIGRATION
    (nom_table, -- VARCHAR2(100)
     val_ref, --   VARCHAR2(200)
     sql_err, --   VARCHAR2(200)
     date_pro, --  DATE
     type_problem)
  values
    ('Branch_res_date_res',
     c.refpdl || '--' || c.periode,
     err_code || '--' || err_msg,
     sysdate,
     'manque date resiliation ');
  end;

    update BRANCHEMENT_RES b
       set b.date_res = TO_CHAR(ADD_MONTHS(v_date, 1), 'DD/MM/YYYY')
       where b.rowid = c.rowid
       and etat in ('F', 'R', 'G');
    commit;
end loop;
end;


begin

-----------------insertion branchement resil_max
 insert into branchement_res_max (periode,ref_pdl,etat,date_res,dist)
 ( select m.periode,m.ref_pdl,m.etat,m.date_res,m.dist
 from branchement_res  m
 where m.rowid=(select k.rowid from branchement_res k
                        where  K.Dist||k.ref_pdl=m.dist||m.ref_pdl
                        and to_date(k.date_res,'dd/mm/yyyy')=
                                           (select max(to_date(d.date_res,'dd/mm/yyyy'))
                                           from branchement_res d
                                           where d.dist||d.ref_pdl=d.dist||k.ref_pdl )
                                          and rownum=1)
     );
commit;
end;



-- todo hkh : inserrer les pdl '9' qui ne sont pas dans branchement_res_max

for x in B loop
 insert into branchement_res_max (periode,ref_pdl,etat,date_res,dist)
 values
 ( sysdate ,x.ref_pdl,'B',sysdate ,v_district);
 commit;
end loop;

   insert into prob_migration (nom_table)values(SYSTIMESTAMP||'  END Branch_resil');
   commit;
end ;
/

prompt
prompt Creating procedure MIWTABONNE_GC
prompt ================================
prompt
create or replace procedure miwtabonne_GC(v_district_ varchar2) is
   -- AUteur : selim el kantaoui
    -- Date   : 05/05/2015
    -- Objet  : Chargement de la liste des installations
    --25 seconds
    seq_miwtprop      number default 0;
    v_msg             varchar2(800);
    v_nbr_trsf_inst   number default 0;
    v_nbr_rej_inst    number(10) default 0;
    v_nbr_trsf_abn    number(10) default 0;
    v_nbr_rej_abn     number(10) default 0;
    V_IN_INS          miwtsite.site_refe%type;
    v_nbr             number;
    v_ad_vilrue       number(10);
    v_ad_num          number(10);
    v_exist_dist      boolean := false;
    v_clt_code        varchar2(100);
    v_asu_value       varchar2(100);
    v_clt_nom         varchar2(200);
    V_SEQ_MIG_BRA_EAU number(10);
    V_SEQ_MIG_BRA_ASS number(10);
    V_SEQ_MIG_ABN     number(10);
    v_abn_contrat     varchar2(200);
    v_abn_ref         varchar2(200);
    v_VOC_FRQFACT     varchar2(200);
    v_tournee         varchar2(20);
    v_abn_mod_pay     number(1);
    v_date_creation   date;
    v_date            date;
    v_date_ferm       date;
    V_DTO             number;
    V_POLICE          number;
    V_COMPTEUR        number;
    err_code          varchar2(200);
    err_msg           varchar2(200);
    mnt_val_eng_      number;
    v_adm             varchar2(4);
    v_posit           varchar2(1);
    -- suivi traitement
    nbr_trt           number := 0;
    NBR_tot           number := 0;
    rindex            pls_integer := -1;
    slno              pls_integer;
    v_op_name         varchar2(200);
    v_abn_lib_usage   varchar2(120);
    nbr_abn           number default 0;
    v_adr_brut        number default 0;
    v_codpoll         varchar2(20);
    v_napt            varchar2(20);
    v_consmoy         varchar2(20);
    v_echtonas        varchar2(20);
    v_echronas        varchar2(20);
    v_capitonas       varchar2(20);
    v_interonas       varchar2(20);
    v_arrond          varchar2(20);
    v_periodicite     varchar2(1);
    v_CODONAS         varchar2(10);
    v_nombre          number;
    v_startdt         date;
    v_enddt           date;
  begin
    select sysdate into v_startdt from dual;
    dbms_output.put_line('miwtpersonne start = '||v_startdt);
DBMS_OUTPUT.ENABLE( 1000000 ) ;
execute immediate 'alter session set nls_date_format = ''dd/mm/yyyy''';
execute immediate 'alter session set NLS_NUMERIC_CHARACTERS = '',.''';


insert into prob_migration (nom_table)values(SYSTIMESTAMP||'   START miwtabonne_GC');
 commit;
    /*delete from miwabn;
    delete from miwtpdl;
    delete from MIWTPROPRIETAIRE;
    delete from    MIWTHISTOPAYEUR;
    delete from miwtsite;
     delete from miwtbra;*/

      -- pour le suivi d'avancement du traitement
      select count(*) into NBR_tot from branchement;
      v_op_name := to_char(sysdate, 'ddmmyyyyhh24miss');

V_AD_NUM:=null;
      --**************************************************
      -- reception de la liste des branchement
      for branch_ in (
        select b.district,b.police,b.tourne,b.ordre,gros_consommateur,
        b.adresse,date_creation,categorie_actuel,client_actuel,b.compteur_actuel,
        b.code_marque,b.code_postal,b.type_branchement,b.etat_branchement,b.aspect_branchement,b.usage,b.marche,ltrim(rtrim(b.tarif)) ofr_snd
         from branchement b
         where  upper(trim(b.gros_consommateur))='O'
         and   b.district = v_district_
          --test and b.tourne||b.ordre in(/*'209007'*/'209225')
         /*
(select distinct substr(t.mrel_refpdl,9,14) from MIWTRELEVE_gc t where t.spt_id is null)
                      and   upper(trim((b.gros_consommateur))='O'
                      and   b.district = v_district_*/

                      ) loop

            ---*************************************************------------------
          begin
            select nvl(min(date_), '01/01/1970')
              into v_date
              from (select min(to_date('01/' || lpad(trim(a.refc03), 2, '0') || '/20' ||
                                       trim(a.refc04),
                                       'dd/mm/yyyy')) date_
                      from facture_as400gc a, param_tournee p, tourne t
                     where lpad(trim(t.code), 3, '0') = lpad(trim(a.tou), 3, '0')
                       and lpad(trim(branch_.tourne), 3, '0') =
                           lpad(trim(t.code), 3, '0')
                       and lpad(trim(a.tou), 3, '0') =
                           lpad(trim(branch_.tourne), 3, '0')
                       and lpad(trim(a.ord), 3, '0') =
                           lpad(trim(branch_.ordre), 3, '0')
                       and trim(t.ntiers) = trim(p.tier)
                       and trim(t.nsixieme) = trim(p.six)
                       and trim(p.district) = trim(branch_.district)
                       and trim(p.district) = trim(a.dist)
                       and trim(branch_.district) = trim(a.dist)
                    union
                    select min(to_date('01/' || lpad(trim(p.m3), 2, '0') || '/' ||
                                       trim(f.annee),
                                       'dd/mm/yyyy')) date_
                      from facture f, param_tournee p, tourne t
                     where lpad(trim(t.code), 3, '0') = lpad(trim(f.tournee), 3, '0')
                       and lpad(trim(f.tournee), 3, '0') =
                           lpad(trim(branch_.tourne), 3, '0')
                       and lpad(trim(branch_.ordre), 3, '0') =
                           lpad(trim(f.ordre), 3, '0')
                       and lpad(trim(branch_.tourne), 3, '0') =
                           lpad(trim(t.code), 3, '0')
                       and trim(t.ntiers) = trim(p.tier)
                       and trim(t.nsixieme) = trim(p.six)
                       and trim(p.district) = trim(branch_.district)
                       and trim(p.district) = trim(f.district)
                       and trim(branch_.district) = trim(f.district)
                    union
                    select min(to_date('01/' || lpad(trim(p.m3), 2, '0') || '/' ||
                                       trim(r.annee),
                                       'dd/mm/yyyy')) date_
                      from fiche_releve r, param_tournee p, tourne t
                     where lpad(trim(branch_.tourne), 3, '0') =
                           lpad(trim(t.code), 3, '0')
                       and lpad(trim(r.tourne), 3, '0') =
                           lpad(trim(branch_.tourne), 3, '0')
                       and lpad(trim(t.code), 3, '0') = lpad(trim(r.tourne), 3, '0')
                       and lpad(trim(r.ordre), 3, '0') =
                           lpad(trim(branch_.ordre), 3, '0')
                       and trim(r.district) = trim(p.district)
                       and trim(branch_.district) = trim(p.district)
                       and trim(branch_.district) = trim(r.district)
                       and trim(t.ntiers) = trim(p.tier)
                       and trim(t.nsixieme) = trim(p.six)
                       and trim(r.annee) <> '0'  and     to_number(trim(r.annee))>'1900'
                    union
                    select min(to_date('01/' || lpad(trim(p.m3), 2, '0') || '/' ||
                                       trim(i.annee),
                                       'dd/mm/yyyy')) date_
                      from impayees i, param_tournee p, tourne t
                     where lpad(trim(branch_.tourne), 3, '0') =
                           lpad(trim(t.code), 3, '0')
                       and lpad(trim(i.tournee), 3, '0') =
                           lpad(trim(branch_.tourne), 3, '0')
                       and lpad(trim(t.code), 3, '0') = lpad(trim(i.tournee), 3, '0')
                       and lpad(trim(i.ordre), 3, '0') =
                           lpad(trim(branch_.ordre), 3, '0')
                       and trim(i.district) = trim(p.district)
                       and trim(branch_.district) = trim(p.district)
                       and trim(branch_.district) = trim(i.district)
                       and trim(t.ntiers) = trim(p.tier)
                       and trim(t.nsixieme) = trim(p.six)
                    union
                    select min(to_date('01/' || lpad(trim(p.m3), 2, '0') || '/' ||
                                       trim(c.annee),
                                       'dd/mm/yyyy')) date_
                      from gestion_compteur c, param_tournee p, tourne t
                     where lpad(trim(branch_.tourne), 3, '0') =
                           lpad(trim(t.code), 3, '0')
                       and lpad(trim(c.tournee), 3, '0') =
                           lpad(trim(branch_.tourne), 3, '0')
                       and lpad(trim(c.ordre), 3, '0') =
                           lpad(trim(branch_.ordre), 3, '0')
                       and lpad(trim(t.code), 3, '0') = lpad(trim(c.tournee), 3, '0')
                       and trim(branch_.district) = trim(p.district)
                       and trim(t.ntiers) = trim(p.tier)
                       and trim(t.nsixieme) = trim(p.six)
                       and trim(c.annee) <> '0' and  to_number(trim(c.annee))>'1900');
          exception
            when others then
              v_date := '01/01/1970';
          end;
 ---************************************************-------------------


        --**************************************************
        -- suivi en temps reel du traitement
        nbr_trt := nbr_trt + 1;
        --**************************************************
        v_abn_contrat := null;
        V_IN_INS      := null;
        -- reception du code client
        v_clt_code := null;
        for clt_ in (select a.mper_ref, a.mper_nom,mper_ref_adr
                       from miwtpersonne a
                      where a.mper_ref = v_district_||lpad(branch_.categorie_actuel,2,'0')||ltrim(rtrim(upper(branch_.client_actuel)))) loop
          v_clt_code := clt_.mper_ref;
          v_clt_nom  := clt_.mper_nom;
          begin
          select madr_ref into V_AD_NUM from miwtadr a
          where a.madr_ref=clt_.mper_ref_adr
          and a.madr_seq =branch_.adresse ;
          exception when others then V_AD_NUM:=null;
          end ;
        end loop;
        begin

          -- verfication si le code POLICE est dupplique
          V_POLICE := 0;
          select count(*)
            into V_POLICE
            from branchement t
           where  trim(branch_.district) =trim(t.district)
           and   lpad(trim(t.police),5,'0') = lpad(trim(branch_.police),5,'0')
           and   lpad(trim(t.tourne),3,'0') = lpad(trim(branch_.tourne),3,'0')
           and   lpad(trim(t.ordre),3,'0') = lpad(trim(branch_.ordre),3,'0')
           and   upper(trim(t.gros_consommateur)) = 'O';
          -- verfication si le COMPTEUR est dupplique
          V_COMPTEUR := 0;
          select count(*)
            into V_COMPTEUR
            from branchement t
           where lpad(trim(t.compteur_actuel),11,'0') = lpad(trim(branch_.compteur_actuel),11,'0')
             and trim(t.code_marque) = trim(branch_.code_marque);
          if /*V_DTO <= 1 and*/
           V_POLICE <= 1 /*and V_COMPTEUR <= 1*/
           then
            --********************************************************************
            -- insertion  SITE SITE SITE SITE SITE SITE SITE SITE SITE SITE SITE
            --********************************************************************
            -- generation du cosde site
            V_IN_INS := lpad(trim(branch_.district),2,'0') ||
                        lpad(trim(branch_.tourne),3,'0') ||
                        lpad(trim(branch_.ordre),3,'0') ||
                        lpad(to_char(trim(branch_.police)),5,'0');
          select count(*)
            into nbr_abn
            from miwabn a
           where a.abn_ref like ltrim(rtrim(branch_.district)) || '%' ||
                 lpad(to_char(trim(branch_.police)), 5, '0');
              v_abn_ref := ltrim(rtrim(branch_.district)) || nbr_abn ||
                           lpad(to_char(trim(branch_.police)),5,'0');
            -- insertion de la ville
            /*v_ad_vilrue := null;
            mig_vilrue(v_code_postal_ => ltrim(rtrim(branch_.code_postal)),
                       v_seq_vilrue_  => v_ad_vilrue);*/
            -- insertion de l'adresse

        /*    if ltrim(rtrim(branch_.nomadr)) is not null then
if V_AD_NUM is null then
  select count(*) into v_adr_brut from brut_sonede1 where district=v_district_
                                and lpad(police,5,'0') = lpad(branch_.police,5,'0')
                                and lpad(tou,3,'0')=lpad(branch_.tou,3,'0')
                                and lpad(ord,3,'0')=lpad(branch_.ord,3,'0');
if v_adr_brut>0 then
      MIG_ADRESSE_PIVOT.MIG_ADR(lpad(branch_.dist,2,'0'),
      lpad(to_char(branch_.pol),5,'0'),
      lpad(branch_.tou,3,'0'),
      lpad(branch_.ord,3,'0'),
      v_ad_num_    => v_ad_num);
else*/
      if branch_.adresse is not null then
            miwtADRESSEPIVOT.MIG_ADR(v_adresse_   => ltrim(rtrim(branch_.adresse)),
            v_ad_vilrue_ => NVL(V_AD_VILRUE,999999999),
            V_CODE_POSTAL_ =>branch_.CODE_POSTAL,
            v_district =>v_district_,
            v_ad_num_    => v_ad_num);
/*end if;
end if;*/
            else
              -- si l'adresse est null alors generation d'une adresse sous la forme
              -- 'Inconnu'||REFRENCE BRANCHEMENT
      /*miwtADRESSEPIVOT.MIG_ADR(v_adresse_   => 'Inconnu' || V_IN_INS,
                  v_ad_vilrue_ => NVL(V_AD_VILRUE,999999999),
          V_CODE_POSTAL_ =>branch_.CODE_POSTAL,
                  v_ad_num_    => v_ad_num);*/
v_ad_num:=0;
            end if;




 begin
     select   count(*)  into v_nbr
    from  branchement j
    WHERE  trim(branch_.district) =trim(j.district)
    and lpad(trim(branch_.tourne),3,'0')=lpad(trim(j.tourne),3,'0')
    and lpad(trim(branch_.ordre),3,'0')=lpad(trim(j.ordre),3,'0')
    and lpad(trim(branch_.police),5,'0')=lpad(trim(j.police),5,'0')
    and upper(trim(j.gros_consommateur))='N'
    and trim(branch_.etat_branchement)='0';


    select   count(*)  into v_nombre
    from  branchement j, miwabn p
    WHERE  trim(branch_.district) =trim(j.district)
    and lpad(trim(branch_.tourne),3,'0')=lpad(trim(j.tourne),3,'0')
    and lpad(trim(branch_.ordre),3,'0')=lpad(trim(j.ordre),3,'0')
    and lpad(trim(branch_.police),5,'0')=lpad(trim(j.police),5,'0')
    and upper(trim(j.gros_consommateur))='O'
    and substr(p.abn_refsite,3,3)=lpad(trim(j.tourne),3,'0')
    and substr(p.abn_refsite,6,3)=lpad(trim(j.ordre),3,'0')
    and  p.VOC_TYPSAG='G';
--and trim(j.client_actuel)=p.ABN_REFPER_A;
    if (v_nbr<>0)then
     update  miwabn p set p.VOC_TYPSAG='G',p.abn_refper_a=v_clt_code, ABN_DT_FIN=null
     where p.abn_refsite=v_district_||lpad(trim(branch_.tourne),3,'0')||lpad(trim(branch_.ordre),3,'0')||lpad(trim(branch_.police),5,'0');
    update miwtpdl l set l.pdl_etat='0' , l.pdl_dfermeture=null ,l.VOC_FRQFACT='30'
    where l.pdl_ref=v_district_||lpad(trim(branch_.tourne),3,'0')||lpad(trim(branch_.ordre),3,'0')||lpad(trim(branch_.police),5,'0');
    update MIWTPROPRIETAIRE s set s.pro_cl_code =v_clt_code , s.pro_dt_fin=null
    where s.pro_in_ins=v_district_||lpad(trim(branch_.tourne),3,'0')||lpad(trim(branch_.ordre),3,'0')||lpad(trim(branch_.police),5,'0');
    update miwthistopayeur s set s.mhpa_ref_payeur =v_clt_code ,s.mhpa_dfin =null
    where s.mhpa_ref_abnt=(select p.abn_ref
    from miwabn p where p.abn_refsite=v_district_||lpad(trim(branch_.tourne),3,'0')||lpad(trim(branch_.ordre),3,'0')||lpad(trim(branch_.police),5,'0'));
    elsif (v_nombre=0) then
begin
      insert into miwtsite
            (
            SITE_SOURCE     ,--1
            SITE_REFE       ,--2
            SITE_REF_ADR    ,--3
            SITE_DATCREATION --4
            )
             Values
            (
            'DIST'||v_district_,--1
            V_IN_INS           ,--2
            V_AD_NUM           ,--3
            sysdate             --4
            ) ;
 exception when others then
                  err_code := SQLCODE;
                  err_msg := SUBSTR(SQLERRM, 1, 200);
                  insert into prob_migration (nom_table,val_ref,sql_err , date_pro,type_problem )
                  values('miwtsite',V_IN_INS,err_code||'--'||err_msg, sysdate,'site existe deja avec cette reference'||V_IN_INS);
                end;
            --********************************************************************
            -- Insertion PROPRIETAIRE PROPRIETAIRE PROPRIETAIRE PROPRIETAIRE
            --********************************************************************
            -- reception de la date de creation du branchement
            -- tous les branchement du district 19 sont a la date 04/04/2002

            --SKA 28/11/2014

            seq_miwtprop:=seq_miwtprop+1;
            begin
              begin
                select adm into v_adm from abonnees t
                where lpad(trim(t.pol),5,'0')=lpad(trim(branch_.police),5,'0')
                      and   lpad(trim(t.tou),3,'0')= lpad(trim(branch_.tourne),3,'0')
                      and   lpad(trim(t.ord),3,'0')=lpad(trim(branch_.ordre),3,'0')
                      and   trim(t.dist)=trim(branch_.district)
                      and   upper(trim(branch_.gros_consommateur))='O'
                      and   trim(t.dist) = v_district_;
                exception when others then null;
                end;
                      v_date_ferm:=null;
        begin
        select m.date_res into v_date_ferm
        from branchement_res_max m
        where m.dist||m.ref_pdl=branch_.district||branch_.tourne||branch_.ORDre
        and trim(branch_.ETAT_BRANCHEMENT)='9';
       exception when no_data_found then null;
       end;
            insert into MIWTPROPRIETAIRE
            (
            PRO_NUM     ,--1
            PRO_IN_INS  ,--2
            PRO_CL_CODE ,--3
            pro_adm     ,--4
            PRO_DT_DEBUT,--5
            PRO_DT_FIN  ,--6
            PRO_DATCREATION--7
            )
            values
            (
            seq_miwtprop,--1 NUMBER(10)   N     Identifiant unique
            V_IN_INS    ,--2 VARCHAR2(20) N     Identifiant de l'installation
            v_clt_code  ,--3 NUMBER(10)   N     Code du client
            v_adm       ,--4
            v_date      ,--5 DATE         N     date de debut de propriete  (mettre une date bidon) (obligatoire)
            v_date_ferm ,--6 DATE         Y     date de fin de propriete
            sysdate      --7
            );
               exception when others then
                  err_code := SQLCODE;
                  err_msg := SUBSTR(SQLERRM, 1, 200);
                  insert into prob_migration (nom_table,val_ref,sql_err , date_pro,type_problem )
                  values('MIWTPROPRIETAIRE',V_IN_INS,err_code||'--'||err_msg, sysdate,'PROPRIETAIRE existe avec cette refrence'||V_IN_INS);
                end;
      begin

                      v_date_ferm:=null;
        begin
        select m.date_res into v_date_ferm
        from branchement_res_max m
        where m.dist||m.ref_pdl=branch_.district||branch_.tourne||branch_.ORDre
        and trim(branch_.ETAT_BRANCHEMENT)='9';
       exception when no_data_found then null;
       end;

            insert into MIWTHISTOPAYEUR
            (
            MHPA_SOURCE     ,--1
            MHPA_REF_ABNT   ,--2
            MHPA_REF_PAYEUR ,--3
            MHPA_MRIB_REF   ,--4
            MHPA_DDEB       ,--5
            MHPA_DFIN       ,--6
            VOC_SETTLEMODE  ,--7
            MHPA_DATCREATION--8
            )
            values
            (
            'DIST'||v_district_,--1
            v_abn_ref          ,--2
            v_clt_code         ,--3
            null               ,--4
            v_date             ,--5
            v_date_ferm        ,--6
            1                  ,--7
            sysdate            --8
            );
        exception when others then
                        err_code := SQLCODE;
                        err_msg := SUBSTR(SQLERRM, 1, 200);
                        insert into prob_migration (nom_table,val_ref,sql_err , date_pro,type_problem )
                        values('MIWTHISTOPAYEUR',V_IN_INS,err_code||'--'||err_msg, sysdate,'payeur existe avec cette refrence'||V_IN_INS);
                      end;



            --********************************************************************
            -- insertion BRANCHEMENT EAU BRANCHEMENT EAU BRANCHEMENT EAU
            --********************************************************************
            /*select SEQ_MIG_BRA_EAU.Nextval
              into V_SEQ_MIG_BRA_EAU
              from dual;*/
              begin
                select posit into v_posit from abonnees t
                where lpad(trim(t.pol),5,'0')=lpad(trim(branch_.police),5,'0')
                      and   lpad(trim(t.tou),3,'0')= lpad(trim(branch_.tourne),3,'0')
                      and   lpad(trim(t.ord),3,'0')=lpad(trim(branch_.ordre),3,'0')
                      and   trim(t.dist)=trim(branch_.district)
                      and   upper(trim(branch_.gros_consommateur))='O'
                      and   trim(t.dist) = v_district_;
                exception when others then null;
                end;
if v_posit <9 then
  v_posit:=0;
  end if;
  begin

           insert into miwtbra
                (
                  MBRA_SOURCE      ,--1  VARCHAR2(100)  N      Identifiant de la source de donnees [OBL]
                  MBRA_REF         ,--2  VARCHAR2(100)  N      Reference du branchement dans le SI source (le couple source/reference doit etre unique) [OBL]
                  MBRA_REFADR      ,--3  VARCHAR2(100)  N      Reference de l'adresse dans le SI source [OBL]
                  MBRA_TYPE        ,--4  VARCHAR2(1)    Y      Type du branchement (U=unique;S=serie;P=parallele;C=compose)
                  MBRA_ETAT        ,--5  VARCHAR2(1)    Y      Etat du branchement : 0=ferme, 1=Ouvert, 2=Supprime
                  MBRA_DETAT       ,--6  DATE           Y      Date du dernier changement d'etat
                  MBRA_REFVOCRESEAU,--7  VARCHAR2(100)  Y      Reference du reseau auquel appartient le branchement (libelle ou code source dans la table des correspondances)
                  MBRA_STEP        ,--8  VARCHAR2(100)  Y
                  MBRA_CHATEAU     ,--9  VARCHAR2(100)  Y
                  VOC_MATBRA       ,--10 VARCHAR2(100)  Y      Composition physique
                  VOC_DIABRA       ,--11 VARCHAR2(100)  Y      diametre
                  VOC_LGBRA        ,--12 VARCHAR2(100)  Y      longuer
                  MBRA_ETATASS     ,--13 VARCHAR2(100)  Y      Date Etat raccordement Ass
                  MBRA_DATEASS     ,--14 DATE           Y
                  MBRA_VANNEINDIV  ,--15 VARCHAR2(100)  Y      Vanne Individuelle
                  MBRA_VANNEINNAC  ,--16 VARCHAR2(100)  Y      Vanne Innacessible
                  COMMENTAIRE      ,--17 VARCHAR2(4000) Y
                  MBRA_DATCREATION  --18
                 )
                values
                (
                 'DIST'||v_district_,--1   VARCHAR2(100)  N      Identifiant de la source de donnees [OBL]
                  V_IN_INS          ,--2   VARCHAR2(100)  N      Reference du branchement dans le SI source (le couple source/reference doit etre unique) [OBL]
                  V_AD_NUM          ,--3   VARCHAR2(100)  N      Reference de l'adresse dans le SI source [OBL]
                  1                 ,--4   VARCHAR2(1)    Y      Type du branchement (U=unique;S=serie;P=parallele;C=compose)
                  v_posit           ,--5   VARCHAR2(1)    Y      Etat du branchement : 0=ferme, 1=Ouvert, 2=Supprime
                  v_date            ,--6   DATE           Y      Date du dernier changement d'etat
                  NULL              ,--7   VARCHAR2(100)  Y      Reference du reseau auquel appartient le branchement (libelle ou code source dans la table des correspondances)
                  NULL              ,--8   VARCHAR2(100)  Y
                  NULL              ,--9   VARCHAR2(100)  Y
                  NULL              ,--10  VARCHAR2(100)  Y      Composition physique
                  NULL              ,--11  VARCHAR2(100)  Y      diametre
                  NULL              ,--12  VARCHAR2(100)  Y      longuer
                  NULL              ,--13  VARCHAR2(100)  Y      Date Etat raccordement Ass
                  NULL              ,--14  DATE           Y
                  NULL              ,--15  VARCHAR2(100)  Y      Vanne Individuelle
                  NULL              ,--16  VARCHAR2(100)  Y      Vanne Innacessible
                  NULL              ,--17  VARCHAR2(4000) Y      Type de raccord assainissement
                  sysdate            --18
                  );
                exception when others then
                  err_code := SQLCODE;
                  err_msg := SUBSTR(SQLERRM, 1, 200);
                  insert into prob_migration (nom_table,val_ref,sql_err , date_pro,type_problem )
                  values('miwtbra',V_IN_INS,err_code||'--'||err_msg, sysdate,'branchement existe avec cette refrence'||V_IN_INS);
                end;
            --********************************************************************
            -- insertion PDI PDI PDI PDI PDI PDI PDI PDI PDI PDI PDI PDI PDI PDI
            --********************************************************************
      begin
           v_date_ferm:=null;
        begin
        select m.date_res into v_date_ferm
        from branchement_res_max m
        where m.dist||m.ref_pdl=branch_.district||branch_.tourne||branch_.ORDre
        and trim(branch_.ETAT_BRANCHEMENT)='9';
       exception when no_data_found then null;
       end;
       v_VOC_FRQFACT:=null;
          if(upper(trim(branch_.gros_consommateur))='N' )then
    v_VOC_FRQFACT:='90';
    else
      v_VOC_FRQFACT:='30';
      end if;


         if  (branch_.tourne='898' or branch_.tourne='899')then
       v_tournee:=v_district_||'_AS';
       else
       v_tournee:=branch_.tourne;
       end if;

      insert into miwtpdl
            (
            PDL_SOURCE      ,--1  VARCHAR2(100)  N      Identifiant de la source de donnees [OBL]
            PDL_REF         ,--2  VARCHAR2(100)  N      Reference du point de comptage dans le SI source (le couple source/reference doit etre unique) [OBL]
            PDL_REFBRA      ,--3  VARCHAR2(100)  Y      Reference du branchement dans le SI source [OBL]
            PDL_REFADR      ,--4  VARCHAR2(100)  N      Reference de l''adresse dans le SI source [OBL]
            PDL_REFTOU      ,--5  VARCHAR2(100)  Y      Reference de la tournee dans la source du client
            PDL_REFPDE_PERE ,--6  VARCHAR2(100)  Y
            PDL_TYPE        ,--7  VARCHAR2(1)    Y
            PDL_TOUORDRE    ,--8  NUMBER(10)     Y      Ordre du point de comptage dans la tournee
            PDL_REFSITE     ,--9  VARCHAR2(100)  Y      Reference de la site dans le SI source
            VOC_DIFFREAD    ,--10 VARCHAR2(100)  Y      Liste des Vocabulaires etat de releve (Difficulte de releve, plaque de fonte, Egout...) ..difficulte releve
            VOC_ACCESS      ,--11 VARCHAR2(100)  Y      Liste des vocabulaire Accessibilite (Jardin, Limite propriete ...) ..accessibilite compteur
            VOC_READINFO1   ,--12 VARCHAR2(100)  Y      Liste des Vocabulaires Inforamation 1 sur releve ...Emplacement compteur
            VOC_READINFO2   ,--13 VARCHAR2(100)  Y      Liste des Vocabulaires Inforamation 2 sur releve
            VOC_READINFO3   ,--14 VARCHAR2(100)  Y      Liste des Vocabulaires Inforamation 3 sur releve
            PDL_REFFLD      ,--15 VARCHAR2(100)  Y
            PDL_SECTEUR_1   ,--16 VARCHAR2(32)   Y      Secteur 1 administratif
            PDL_SECTEUR_2   ,--17 VARCHAR2(32)   Y      Secteur 2 intervention de terrain
            PDL_SECTEUR_3   ,--18 VARCHAR2(32)   Y      Secteur 3
            PDL_SECTEUR_4   ,--19 VARCHAR2(32)   Y      Secteur 4
            PDL_SECTEUR_5   ,--20 VARCHAR2(32)   Y      Secteur 5
            PDL_ETAT        ,--21 VARCHAR2(1)    Y      Etat du point de comptage : 0=ferme, 1=Ouvert, 2=Supprime
            PDL_DETAT       ,--22 DATE           Y      Date du dernier changement d''etat
            VOC_METHDEP     ,--23 VARCHAR2(100)  Y
            PDL_COMMENT     ,--24 VARCHAR2(4000) Y
            PDL_REFPER_P    ,--25 NUMBER(10)     Y      Ref Client Proprietaire
            VOC_CONNAT      ,--26
            VOC_CONSTATUS   ,--27
            PDL_DFERMETURE   ,--28
            VOC_FRQFACT
            )
            values
            (
            'DIST'||v_district_,--1
            V_IN_INS           ,--2 not null identifiant du branchement   -- PDI_REFERENCE
            V_IN_INS           ,--3 not null Reference de l'installation (mig_ins.ins_id)
            V_AD_NUM           ,--4 Numero d'adresse du branchement
             v_tournee     ,--5 Code de la tournee associee a ce PDI
            NULL               ,--6
            'E'                ,--7 not null 'E' type eau
            branch_.ORDre      ,--8 Numero d'ordre dans la tournee : Permet de commencer par tel pdi dans tel rue en 1er
            V_IN_INS           ,--9
            NULL               ,--10
            NULL               ,--11
            NULL               ,--12
            NULL               ,--13
            NULL               ,--14
            'PDC EAU'          ,--15
            v_district_        ,--16
            NULL               ,--17
            NULL               ,--18
            NULL               ,--19
            NULL               ,--20
            v_posit            ,--21 Code etat du branchement
            v_date             ,--22
            NULL               ,--23
            branch_.marche     ,--24 Commentaire point d'installation      -- PDI_LIBRE
            NULL               ,--25
            branch_.type_branchement,--26
            branch_.aspect_branchement,--27
            v_date_ferm         ,--28
            v_VOC_FRQFACT       --29
            ) ;
             exception when others then
                  err_code := SQLCODE;
                  err_msg := SUBSTR(SQLERRM, 1, 200);
                  insert into prob_migration (nom_table,val_ref,sql_err , date_pro,type_problem )
                  values('miwtpdl',V_IN_INS,err_code||'--'||err_msg, sysdate,'pdl existe avec cette refrence'||V_IN_INS);
                end;
--
           /* update branchement t
               set t.btrsf_inst = 'O'
             where t.district = branch_.district
               and t.gros_consommateur = branch_.gros_consommateur
               and t.tourne = branch_.tourne
               and t.ordre = branch_.ordre;*/
            --commit;
            --********************************************************************
            -- insertion ABONNEMENT ABONNEMENT ABONNEMENT ABONNEMENT ABONNEMENT
            --********************************************************************
            begin
              -- MAJ SUIVI MIGRATION
              --mig_progress('MIG_ABN', 'R', 0, 0);
              --select seq_mig_abn.nextval into v_seq_mig_abn from dual;
              --v_abn_contrat := branch_.district ||'0'||to_char(branch_.police);
              v_abn_contrat := branch_.district || lpad(to_char(trim(branch_.police)),5,'0') ||
                               lpad(trim(branch_.ordre),3,'0') || lpad(trim(branch_.tourne),3,'0');
              /*v_abn_mod_pay := 0;
              if ltrim(rtrim(branch_.num_compte)) is not null then
                v_abn_mod_pay := 1;
              end if;*/

              -- *****************************************************************************
              -- Ajoute par BEN MANSOUR ARAB SOFT le 21/05/2014 a la demande de HAMDI KHALDI
              -- prise en charge des usages
              --******************************************************************************
              -- reception du libelle de l'usage
             /* for usage_ in (select * from usage a where a.code = branch_.usage) loop
                v_abn_lib_usage := trim(usage_.desig);
              end loop;*/
              --******************************************************************************
begin
              begin
              select consmoy,'ONAS'||t.codonas  into v_consmoy, v_CODONAS
                from   abonnes_gc t
                where lpad(trim(t.pol),5,'0')=lpad(trim(branch_.police),5,'0')
                      and   lpad(trim(t.tou),3,'0')= lpad(trim(branch_.tourne),3,'0')
                      and   lpad(trim(t.ord),3,'0')=lpad(trim(branch_.ordre),3,'0')
                      and   trim(t.dist)=trim(branch_.district)
                      and   upper(trim(branch_.gros_consommateur))='O'
                      and   trim(t.dist) = v_district_;
                      exception when others then v_consmoy:=0;
                end;

                             v_date_ferm:=null;
        begin
        select m.date_res into v_date_ferm
        from branchement_res_max m
        where m.dist||m.ref_pdl=branch_.district||branch_.tourne||branch_.ORDre
        and trim(branch_.ETAT_BRANCHEMENT)='9';
       exception when no_data_found then null;
       end;

insert into miwabn
      (
        ABN_SOURCE        ,--1   VARCHAR2(100)  N
        ABN_REF           ,--2   VARCHAR2(100)  N      identifiant de l'abonnement : N? fourni par l'utilisateur (cle primaire)
        ABN_REFSITE       ,--3   VARCHAR2(100)  Y      Reference de l'installation (obligatoire)
        ABN_REFPDL        ,--4   VARCHAR2(100)  N      Reference du point de comptage dans le SI source
        ABN_REFGRF        ,--5   VARCHAR2(100)  Y      Voir description du groupe de facturation
        ABN_REFPER_A      ,--6   VARCHAR2(100)  Y
        ABN_DT_DEB        ,--7   DATE           N      Date de debut d'abonnement (obligatoire)
        ABN_DT_FIN        ,--8   DATE           Y      Date de fin d'abonnement
        ABN_CTRTYPE_REF   ,--9   VARCHAR2(100)  Y      Reference du contrat d'abonnement (police) (obligatoire)
        ABN_MODEFACT      ,--10  NUMBER(1)      Y      0=facturation par role, 1=facturation par planning
        ABN_GELER         ,--11  NUMBER(1)      Y      1:gel de contrat en facturation,0 Sinon
        ABN_DTGELER       ,--12  DATE           Y      date de gel de facturation
        ABN_EXOTVA        ,--13  NUMBER(1)      Y  0   1: Exonere de TVA,0 sinon
        VOC_FROZEN        ,--14  VARCHAR2(100)  Y      motif du gel [FROZEN]
        VOC_TYPDURBILL    ,--15  VARCHAR2(100)  Y      1: Exonere de TVA,0 sinon
        VOC_CUTAGREE      ,--16  VARCHAR2(100)  Y      drois de coupure [CUTAGREE]
        VOC_TYPSAG        ,--17  VARCHAR2(100)  Y      type de service (professionnel, domestique) [TYPSAG]
        VOC_USGSAG        ,--18  VARCHAR2(100)  Y      Usage Res Principal, Local, Res. Secondaire [USGCAG]
        ABN_REFREL        ,--19  VARCHAR2(100)  Y      Reference du chaine de relance  dans le SI source
        ABN_REFPFT        ,--20  VARCHAR2(100)  Y      Reference du Profil type dans le SI source
        ABN_NORECOVERY    ,--21  NUMBER(1)      Y      exonerer de relance (0=non, 1=oui)
        ABN_DTFIN_RECOVERY,--22  DATE           Y
        ABN_DELAIP        ,--23  NUMBER(2)      Y      Delai de paiement
        ABN_COMMENTAIRE   ,--24  VARCHAR2(4000) Y      Commentaire libre PDS
        ABN_SOLDE         ,--25  NUMBER(17,10)  Y      Solde de l'abonnement
        MIGABN_CR         ,--26  NUMBER(10,3)   Y      consommation de reference par defaut
        MIGABN_CRDTFIN    ,--27  DATE           Y      fin de validite de la consommation de reference par defaut
        ABN_REFPFT_DETAIL ,--28  VARCHAR2(100)  Y      Reference du Profil type  Detaildans le SI source
        ofr_code          ,--29
        ofr_code_second   ,--30
        ABN_DATCREATION    --31
        )
      Values
       (
       'DIST'||v_district_  ,--1
        v_abn_ref           ,--2
        V_IN_INS            ,--3
        V_IN_INS            ,--4
        '1'                 ,--5 groupe facturation
        v_clt_code          ,--6 Numero du client Abonne A
        v_date              ,--7
        v_date_ferm         ,--8
        null                ,--9
        0                   ,--10
        0                   ,--11
        null                ,--12
        0                   ,--13
        null                ,--14
        0                   ,--15
        0                   ,--16
        'G'                 ,--17
        branch_.usage       ,--18
        null                ,--19
        'OFRTEST'           ,--20
        0                   ,--21
        null                ,--22
        30                  ,--23
        null                ,--24
        0                   ,--25 avoir
        v_consmoy           ,--26
        null                ,--27
        null                ,--28
        branch_.ofr_snd     ,--29
        v_CODONAS           ,--30
        sysdate              --31
        ) ;
 exception when others then
                  err_code := SQLCODE;
                  err_msg := SUBSTR(SQLERRM, 1, 200);
                  insert into prob_migration (nom_table,val_ref,sql_err , date_pro,type_problem )
                  values('miwabn',V_IN_INS,err_code||'--'||err_msg,sysdate,'abonnement existe avec cette refrence'||V_IN_INS);
                end;
commit;
 begin
                select napt,consmoy,echronas,echtonas,capitonas,interonas,AR1,'0'
                into v_napt,v_consmoy,v_echronas,v_echtonas,v_capitonas,v_interonas,v_arrond,v_periodicite
                from abonnes_gc t
                where lpad(trim(t.pol),5,'0')=lpad(trim(branch_.police),5,'0')
                      and   lpad(trim(t.tou),3,'0')= lpad(trim(branch_.tourne),3,'0')
                      and   lpad(trim(t.ord),3,'0')=lpad(trim(branch_.ordre),3,'0')
                      and   trim(t.dist)=trim(branch_.district)
                      and   upper(trim(branch_.gros_consommateur))='O'
                      and   trim(t.dist) = v_district_;
                exception when others then null;
                end;
for c in (select  * from miwengagement) loop
  if to_number(nvl(v_codpoll,'0'))!=0 and c.sub_comment=upper('codpoll') then mnt_val_eng_:=v_codpoll;
    elsif to_number(nvl(v_napt,'0'))!=0 and c.sub_comment=upper('napt') then mnt_val_eng_:=v_napt;
      --elsif  v_consmoy is not null and c.sub_comment=upper('consmoy') then mnt_val_eng_:=v_consmoy;
        elsif to_number(nvl(v_echtonas,'0'))!=0 and c.sub_comment=upper('echtonas') then mnt_val_eng_:=to_number(v_echtonas);
          elsif to_number(nvl(v_echronas,'0'))!=0 and c.sub_comment=upper('echronas') then mnt_val_eng_:=to_number(v_echronas);
            elsif to_number(nvl(v_capitonas,'0'))!=0 and c.sub_comment=upper('capitonas') then mnt_val_eng_:=to_number(v_capitonas)/1000;
              elsif to_number(nvl(v_interonas,'0'))!=0 and c.sub_comment=upper('interonas') then mnt_val_eng_:=to_number(v_interonas)/1000;
                elsif  v_arrond is not null and c.sub_comment=upper('arrond') then mnt_val_eng_:=to_number(v_arrond)/1000;
                --elsif  v_periodicite is not null and c.sub_comment=upper('PERIODE') then mnt_val_eng_:=v_periodicite;

else goto xx;
end if;
        begin
        insert into miwengabn
        (
        asu_subsource,--1
        asu_subref   ,--2
        asu_refsource,--3
        asu_refabn   ,--4
        asu_value    ,--5
        asu_dtdebut  ,--6
        ASU_DATCREATION--7
        )
        values
        (
        c.sub_source,--1
        c.sub_ref   ,--2
        c.sub_source,--3
        v_abn_ref   ,--4
        mnt_val_eng_,--5
        v_date      ,--6 branch_.date_creation
        sysdate      --7
        );
        exception when others then
        err_code := SQLCODE;
                  err_msg := SUBSTR(SQLERRM, 1, 200);
                  insert into prob_migration (nom_table,val_ref,sql_err , date_pro,type_problem  )
                  values('miwengabn',v_abn_ref,err_code||'--'||err_msg, sysdate,'engagement existe avec cette refrence'||V_IN_INS);
        end;

  begin

          insert into miwengabn
          (
          asu_subsource,--1
          asu_subref   ,--2
          asu_refsource,--3
          asu_refabn   ,--4
          asu_value    ,--5
          asu_dtdebut   --6
          )
          values
          (
          c.sub_source,--1
          'GROS_CONSOMMATEUR'   ,--2
          c.sub_source,--3
          v_abn_ref   ,--4
          'Oui',--5
          null       --6
          );
          exception when others then
             err_code := SQLCODE;
                            err_msg := SUBSTR(SQLERRM, 1, 200);
                            insert into prob_migration (nom_table,val_ref,sql_err , date_pro,type_problem )
                            values('miwengabn_1',v_abn_ref,err_code||'--'||err_msg, sysdate,'engagement existe avec cette refrence'||V_IN_INS);
                          end;

commit;
<<xx>>
null;
end loop;




begin
for v in(
select distinct b.district, b.police,b.tourne,b.ordre,b.etat_branchement,b.gros_consommateur,g.gc
from branchement b ,gestion_compteur g
where trim(b.tourne)||trim(b.ordre) not in(select lpad(trim(t.tou),3,'0')||lpad(trim(t.ord),3,'0')
                                                      from abonnees t)
and trim(b.tourne)||trim(b.ordre) not in(select lpad(trim(r.tou),3,'0')||lpad(trim(r.ord),3,'0')
                                                    from abonnees_gr r)
and trim(b.tourne)||trim(b.ordre) = lpad(trim(g.tournee),3,'0')||lpad(trim(g.ordre),3,'0')
and lpad(trim(b.police),5,'0')=lpad(trim(branch_.police),5,'0')
and lpad(trim(b.tourne),3,'0')=lpad(trim(branch_.tourne),3,'0')
and lpad(trim(b.ordre),3,'0')=lpad(trim(branch_.ordre),3,'0')
and b.district=branch_.district
and lpad(trim(g.tournee),3,'0')=lpad(trim(b.tourne),3,'0')
and lpad(trim(g.ordre),3,'0')=lpad(trim(b.ordre),3,'0')
and to_date(g.date_action,'dd/mm/yyyy') =(select max(to_date(s.date_action,'dd/mm/yyyy'))
                                             from gestion_compteur s
                                             where trim(s.tournee)||trim(s.ordre)=trim(g.tournee)||trim(g.ordre) )
                     )loop

  begin

  select a.abn_ref into v_abn_ref
   from miwabn a where a.abn_refsite=trim(v.district)
                                       ||lpad(trim(v.tourne),3,'0')
                                       ||lpad(trim(v.ordre),3,'0')
                                       ||lpad(trim(v.police),5,'0');
   if upper(trim(v.gc))='O' then
     v_asu_value:='Oui';
   else
       v_asu_value:='Non';
                 end if;


          insert into miwengabn
          (
          asu_subsource,--1
          asu_subref   ,--2
          asu_refsource,--3
          asu_refabn   ,--4
          asu_value    ,--5
          asu_dtdebut   --6
          )
          values
          (
          'DIST'||v_district_,--1
          'GROS_CONSOMMATEUR',--2
          'DIST'||v_district_,--3
          v_abn_ref   ,--4
          v_asu_value ,--5
          null         --6
          );
          exception when others then
             err_code := SQLCODE;
                            err_msg := SUBSTR(SQLERRM, 1, 200);
                            insert into prob_migration (nom_table,val_ref,sql_err , date_pro,type_problem )
                            values('miwengabn_1',v_abn_ref,err_code||'--'||err_msg, sysdate,'engagement existe avec cette refrence'||V_IN_INS);
           end;

        commit;


    end loop;
    end;

             /* update branchement t
                 set t.btrsf_abn = 'O'
               where t.district = branch_.district
                 and t.gros_consommateur = branch_.gros_consommateur
                 and t.tourne = branch_.tourne
                 and t.ordre = branch_.ordre;*/
              --commit;
              v_nbr_trsf_abn := v_nbr_trsf_abn + 1;
              --SKA 28/11/2014
              -- SUPPRIME LES EXCEPTION
            /*exception
              when others then
                rollback;
                v_nbr_rej_abn := v_nbr_rej_abn + 1;
                v_msg         := sqlerrm;*/
               /* update branchement t
                   set t.btrsf_abn = 'R', t.cmsg_abn = v_msg
                 where t.district = branch_.district
                   and t.gros_consommateur = branch_.gros_consommateur
                   and t.tourne = branch_.tourne
                   and t.ordre = branch_.ordre;*/
                --commit;
            end;
            v_nbr_trsf_inst := v_nbr_trsf_inst + 1;

            v_msg := null;
            if V_DTO > 1 then
              v_msg := '(DISTRICT,TOURNEE,ORDRE) dupplique';
            end if;
            if V_POLICE > 1 then
              v_msg := v_msg || 'CODE POLICE dupplique)';
            end if;
            if V_COMPTEUR > 1 then
              v_msg := v_msg || 'COMPTEUR dupplique';
            end if;
           /* update branchement t
               set t.btrsf_inst = 'R', t.cmsg_abn = v_msg
             where t.district = branch_.district
               and t.gros_consommateur = branch_.gros_consommateur
               and t.tourne = branch_.tourne
               and t.ordre = branch_.ordre;*/
            --commit;
          end if;
          --SKA 28/11/2014
          --Supression de l'exeception
        /*exception
          when others then
            rollback;
            v_nbr_rej_inst := v_nbr_rej_inst + 1;
            v_msg          := sqlerrm;*/
           /* update branchement t
               set t.btrsf_inst = 'R', t.cmsg_inst = v_msg
             where t.district = branch_.district
               and t.gros_consommateur = branch_.gros_consommateur
               and t.tourne = branch_.tourne
               and t.ordre = branch_.ordre;*/
            --commit;
        end;
V_AD_NUM:=null;

end if;
end ;
end loop;
select sysdate into v_enddt from dual;
    dbms_output.put_line('miwtpersonne start = '||v_enddt);
      -- MAJ SUIVI MIGRATION
      --mig_progress('MIG_INST', 'M', v_nbr_trsf_inst, v_nbr_rej_inst);
      --mig_progress('MIG_ABN', 'M', v_nbr_trsf_abn, v_nbr_rej_abn);
   /* else*/
      -- mise a jour de la table de progression de transfert
     /* update mig_progression t
         set t.cmsg = 'District inexistant: Il faut ajouter le nouveau district pour pouvoir transferer les tournees'
       where t.ltable_name = 'MIG_INST';*/
      --commit;
      --SKA le 28/11/2014
        --Commente le boucle secteur administratif
    --end if;

    insert into prob_migration (nom_table)values(SYSTIMESTAMP||'   END miwtabonne_GC');
 commit;
  end;
/

prompt
prompt Creating procedure MIWTABONNE_TRIM
prompt ==================================
prompt
create or replace procedure miwtabonne_trim(v_district_ varchar2) is
   -- AUteur : selim el kantaoui
    -- Date   : 05/05/2015
    -- Objet  : Chargement de la liste des installations
    ---3202 seconds
    seq_miwtprop      number default 0;
    v_msg             varchar2(800);
    v_nbr_trsf_inst   number default 0;
    v_nbr_rej_inst    number(10) default 0;
    v_nbr_trsf_abn    number(10) default 0;
    v_nbr_rej_abn     number(10) default 0;
    V_IN_INS          miwtsite.site_refe%type;
    v_ad_vilrue       number(10);
    v_ad_num          number(10);
    v_exist_dist      boolean := false;
    v_clt_code        varchar2(100);
    v_clt_nom         varchar2(200);
    V_SEQ_MIG_BRA_EAU number(10);
    V_SEQ_MIG_BRA_ASS number(10);
    V_SEQ_MIG_ABN     number(10);
    v_abn_contrat     varchar2(200);
    v_abn_ref         varchar2(200);
    v_tournee         varchar2(10);
    v_VOC_FRQFACT     varchar2(200);
    v_abn_mod_pay     number(1);
    v_date_creation   date;
    v_date_ferm       date ;
    v_date            date;
    V_DTO             number;
    V_POLICE          number;
    V_COMPTEUR        number;
    err_code          varchar2(200);
    err_msg           varchar2(200);
    mnt_val_eng_      number ;
    v_adm             varchar2(4);
    v_posit           varchar2(1);
    -- suivi traitement
    nbr_trt           number := 0;
    NBR_tot           number := 0;
    rindex            pls_integer := -1;
    slno              pls_integer;
    v_op_name         varchar2(200);
    v_abn_lib_usage   varchar2(120);
    nbr_abn           number default 0;
    v_adr_brut        number default 0;
    v_codpoll         varchar2(20);
    v_napt            varchar2(20);
    v_consmoy         varchar2(20);
    v_echtonas        varchar2(20);
    v_echronas        varchar2(20);
    v_capitonas       varchar2(20);
    v_interonas       varchar2(20);
    v_arrond          varchar2(20);
    v_periodicite     varchar2(1);
    v_CODONAS         varchar2(10);
    v_asu_value       varchar2(10);
  begin

    delete from miwengabn a where a.asu_subsource='DIST'||v_district_  ;
    delete from miwabn a where a.abn_source='DIST'||v_district_;
    delete from miwtpdl l where l.pdl_source='DIST'||v_district_;
    delete from MIWTPROPRIETAIRE ;
    delete from MIWTHISTOPAYEUR h where h.mhpa_source='DIST'||v_district_;
    delete from miwtsite s where s.site_source='DIST'||v_district_;
    delete from miwabn a where a.abn_source='DIST'||v_district_;
    delete from miwtbra b where b.mbra_source='DIST'||v_district_;
    delete from prob_migration m where m.nom_table='miwtsite';
    delete from prob_migration m where m.nom_table='MIWTPROPRIETAIRE';
    delete from prob_migration m where m.nom_table='miwtbra';
    delete from prob_migration m where m.nom_table='miwtpdl';
    delete from prob_migration m where m.nom_table='MIWTHISTOPAYEUR';
    delete from prob_migration m where m.nom_table='miwabn';
    delete from prob_migration m where m.nom_table='miwengabn';
   commit;
execute immediate 'alter session set nls_date_format = ''dd/mm/yyyy''';
execute immediate 'alter session set NLS_NUMERIC_CHARACTERS = '',.''';


insert into prob_migration (nom_table)values(SYSTIMESTAMP||'   START miwtabonne_trim');
 commit;
      -- pour le suivi d'avancement du traitement
      select count(*) into NBR_tot from branchement;
      v_op_name := to_char(sysdate, 'ddmmyyyyhh24miss');

V_AD_NUM:=null;
      --**************************************************
      -- reception de la liste des branchement
      for branch_ in (select b.district,b.police,b.tourne,b.ordre,gros_consommateur,b.adresse,date_creation,
        categorie_actuel,client_actuel,b.compteur_actuel,b.code_marque,b.code_postal,b.ETAT_BRANCHEMENT,
        b.usage,b.type_branchement,b.aspect_branchement,b.marche, ltrim(rtrim(b.tarif)) ofr_snd, 'ONAS'||(ltrim(rtrim(b.onas))) ofr_onas
        from  branchement b
                      WHERE upper(trim(b.gros_consommateur))='N'
                      and trim(b.district) = v_district_
                      --and b.tourne||b.ordre in('608004','004123')
                      ) loop
        --**************************************************
        -- suivi en temps reel du traitement
        nbr_trt := nbr_trt + 1;
        --**************************************************
        v_abn_contrat := null;
        V_IN_INS      := null;
        -- reception du code client
        v_clt_code := null;
        ----*************************************************-------
        begin

         select nvl(min(date_),'01/01/1970')
         into v_date from (select  min(to_date('01/'||lpad(trim(a.refc01),2,'0')||'/20'||trim(a.refc04),'dd/mm/yyyy')) date_
                    from facture_as400 a,
                     param_tournee p,
                    tourne t
                    where lpad(trim(t.code),3,'0')=lpad(trim(a.tou),3,'0')
                    and lpad(trim(branch_.tourne),3,'0')=lpad(trim(t.code),3,'0')
                    and lpad(trim(a.tou),3,'0')=lpad(trim(branch_.tourne),3,'0')
                    and lpad(trim(a.ord),3,'0')=lpad(trim(branch_.ordre),3,'0')
                    and lpad(trim(a.pol),5,'0')=lpad(trim(branch_.police),5,'0')
                    and trim(t.ntiers)=trim(p.tier)
                    and trim(t.nsixieme)=trim(p.six)
                    and trim(p.district)=trim(branch_.district)
                    and trim(p.district)=trim(a.dist)
                    and trim(branch_.district)=trim(a.dist)
                    union
                    select  min(to_date('01/'||lpad(trim(p.m1),2,'0')||'/'||trim(f.annee),'dd/mm/yyyy')) date_
                    from   facture f,
                     param_tournee p,
                     tourne  t
                    where lpad(trim(t.code),3,'0')=lpad(trim(f.tournee),3,'0')
                    and lpad(trim(f.tournee),3,'0')=lpad(trim(branch_.tourne),3,'0')
                    and lpad(trim(branch_.ordre),3,'0')=lpad(trim(f.ordre),3,'0')
                    and lpad(trim(branch_.tourne),3,'0')=lpad(trim(t.code),3,'0')
                    and lpad(trim(f.police),5,'0')=lpad(trim(branch_.police),5,'0')
                    and trim(t.ntiers)=trim(p.tier)
                    and trim(t.nsixieme)=trim(p.six)
                    and trim(p.district)=trim(branch_.district)
                    and trim(p.district)=trim(f.district)
                    and trim(branch_.district)=trim(f.district)
                    union
                    select  min(to_date('01/'||lpad(trim(p.m1),2,'0')||'/'||trim(r.annee),'dd/mm/yyyy'))date_
                    from fiche_releve r,
                     param_tournee p,
                     tourne t
                    where  lpad(trim(branch_.tourne),3,'0')=lpad(trim(t.code),3,'0')
                    and lpad(trim(r.tourne),3,'0')=lpad(trim(branch_.tourne),3,'0')
                    and lpad(trim(t.code),3,'0')=lpad(trim(r.tourne),3,'0')
                    and lpad(trim(r.ordre),3,'0')=lpad(trim(branch_.ordre),3,'0')
                    and trim(r.district)=trim(p.district)
                    and trim(branch_.district)=trim(p.district)
                    and trim(branch_.district)=trim(r.district)
                    and trim(t.ntiers)=trim(p.tier)
                    and trim(t.nsixieme)=trim(p.six)
                    and trim(r.annee)<>'0'  and    trim(r.annee)>'1900'
                    union
                    select min(to_date('01/'||lpad(trim(p.m1),2,'0')||'/'||trim(i.annee),'dd/mm/yyyy'))date_
                    from  impayees i,
                     param_tournee p,
                     tourne t
                    where lpad(trim(branch_.tourne),3,'0')=lpad(trim(t.code),3,'0')
                    and lpad(trim(i.tournee),3,'0')=lpad(trim(branch_.tourne),3,'0')
                    and lpad(trim(t.code),3,'0')=lpad(trim(i.tournee),3,'0')
                    and lpad(trim(i.ordre),3,'0')=lpad(trim(branch_.ordre),3,'0')
                    and lpad(trim(i.police),5,'0')=lpad(trim(branch_.police),5,'0')
                    and trim(i.district)=trim(p.district)
                    and trim(branch_.district)=trim(p.district)
                    and trim(branch_.district)=trim(i.district)
                    and trim(t.ntiers)=trim(p.tier)
                    and trim(t.nsixieme)=trim(p.six)
                    union
                     select min(to_date('01/'||lpad(trim(p.m1),2,'0')||'/'||trim(c.annee),'dd/mm/yyyy'))date_
                    from  gestion_compteur c,
                     param_tournee p,
                     tourne t
                    where lpad(trim(branch_.tourne),3,'0')=lpad(trim(t.code),3,'0')
                    and lpad(trim(c.tournee),3,'0')=lpad(trim(branch_.tourne),3,'0')
                    and lpad(trim(c.ordre),3,'0')=lpad(trim(branch_.ordre),3,'0')
                    and lpad(trim(t.code),3,'0')=lpad(trim(c.tournee),3,'0')
                    and trim(branch_.district)=trim(p.district)
                    and trim(t.ntiers)=trim(p.tier)
                    and trim(t.nsixieme)=trim(p.six)
                    and trim(c.annee)<>'0' and     to_number(trim(c.annee))>'1900'
                    );
                    exception when others then v_date:='01/01/1969';
                    end;
--*****************************************************-----



        for clt_ in (select a.mper_ref, a.mper_nom,mper_ref_adr
                       from miwtpersonne a
                      where a.mper_ref = v_district_||lpad(branch_.categorie_actuel,2,'0')||ltrim(rtrim(upper(branch_.client_actuel)))) loop
          v_clt_code := clt_.mper_ref;
          v_clt_nom  := clt_.mper_nom;
          begin
          select madr_ref into V_AD_NUM from miwtadr a
          where a.madr_ref=clt_.mper_ref_adr
          and a.madr_seq =branch_.adresse ;
          exception when others then V_AD_NUM:=null;
          end ;
        end loop;
        begin

          -- verfication si le code POLICE est dupplique
          V_POLICE := 0;
          select count(*)
            into V_POLICE
            from  branchement t
           where lpad(trim(t.police),5,'0') = lpad(trim(branch_.police),5,'0')
           and   lpad(trim(t.tourne),3,'0') = lpad(trim(branch_.tourne),3,'0')
           and   lpad(trim(t.ordre),3,'0') = lpad(trim(branch_.ordre),3,'0')
           and   upper(trim(t.gros_consommateur)) = 'N';
          -- verfication si le COMPTEUR est dupplique
          V_COMPTEUR := 0;
          select count(*)
            into V_COMPTEUR
            from branchement t
           where  lpad(ltrim(rtrim(t.compteur_actuel)),11,'0') =lpad(ltrim(rtrim(branch_.compteur_actuel)),11,'0')
             and trim(t.code_marque) = trim(branch_.code_marque);
          if /*V_DTO <= 1 and*/
           V_POLICE <= 1 /*and V_COMPTEUR <= 1*/
           then
            --********************************************************************
            -- insertion  SITE SITE SITE SITE SITE SITE SITE SITE SITE SITE SITE
            --********************************************************************
            -- generation du cosde site
            V_IN_INS := lpad(trim(branch_.district),2,'0') ||
                        lpad(trim(branch_.tourne),3,'0') ||
                        lpad(trim(branch_.ordre),3,'0') ||
                        lpad(to_char(trim(branch_.police)),5,'0');
      select count(*) into nbr_abn
      from miwabn a where a.abn_ref like ltrim(rtrim(branch_.district)) || '%' ||
                           lpad(to_char(trim(branch_.police)),5,'0');
              v_abn_ref := ltrim(rtrim(branch_.district)) || nbr_abn ||
                           lpad(to_char(trim(branch_.police)),5,'0');
            -- insertion de la ville
            /*v_ad_vilrue := null;
            mig_vilrue(v_code_postal_ => ltrim(rtrim(branch_.code_postal)),
                       v_seq_vilrue_  => v_ad_vilrue);*/
            -- insertion de l'adresse

        /*    if ltrim(rtrim(branch_.nomadr)) is not null then
if V_AD_NUM is null then
  select count(*) into v_adr_brut from brut_sonede1 where district=v_district_
                                and lpad(police,5,'0') = lpad(branch_.police,5,'0')
                                and lpad(tou,3,'0')=lpad(branch_.tou,3,'0')
                                and lpad(ord,3,'0')=lpad(branch_.ord,3,'0');
if v_adr_brut>0 then
      MIG_ADRESSE_PIVOT.MIG_ADR(lpad(branch_.dist,2,'0'),
      lpad(to_char(branch_.pol),5,'0'),
      lpad(branch_.tou,3,'0'),
      lpad(branch_.ord,3,'0'),
      v_ad_num_    => v_ad_num);
else*/
if branch_.adresse is not null then
      miwtADRESSEPIVOT.MIG_ADR(v_adresse_   => ltrim(rtrim(branch_.adresse)),
      v_ad_vilrue_ => NVL(V_AD_VILRUE,999999999),
      V_CODE_POSTAL_ =>branch_.CODE_POSTAL,
      v_district =>v_district_,
      v_ad_num_    => v_ad_num);
/*end if;
end if;*/
            else
              -- si l'adresse est null alors generation d'une adresse sous la forme
              -- 'Inconnu'||REFRENCE BRANCHEMENT
      /*miwtADRESSEPIVOT.MIG_ADR(v_adresse_   => 'Inconnu' || V_IN_INS,
                  v_ad_vilrue_ => NVL(V_AD_VILRUE,999999999),
          V_CODE_POSTAL_ =>branch_.CODE_POSTAL,
                  v_ad_num_    => v_ad_num);*/
v_ad_num:=0;
            end if;
begin
      insert into miwtsite
            (
            SITE_SOURCE,--1
            SITE_REFE  ,--2
            SITE_REF_ADR--3
             )
                Values
            (
            'DIST'||v_district_,--1
            V_IN_INS ,--2
            V_AD_NUM--3
            ) ;
 exception when others then
                  err_code := SQLCODE;
                  err_msg := SUBSTR(SQLERRM, 1, 200);
                  insert into prob_migration (nom_table,val_ref,sql_err , date_pro,type_problem )
                  values('miwtsite',V_IN_INS,err_code||'--'||err_msg,sysdate,'le site existe deja avec cette valeur '||V_IN_INS);
                end;
            --********************************************************************
            -- Insertion PROPRIETAIRE PROPRIETAIRE PROPRIETAIRE PROPRIETAIRE
            --********************************************************************
            -- reception de la date de creation du branchement
            -- tous les branchement du district 19 sont a la date 04/04/2002
         /*   begin
              v_date_creation := null;
              v_date_creation := cast(to_timestamp(branch_.date_creation,
                                                   'yyyy-mm-dd hh24:mi:ss.FF3') as date);
            exception
              when others then
                v_date_creation := '04/04/2002';
            end;*/
            --SKA 28/11/2014

            seq_miwtprop:=seq_miwtprop+1;
            begin
              begin
                select adm into v_adm from  abonnees t
                where lpad(trim(t.pol),5,'0')=lpad(trim(branch_.police),5,'0')
                      and   lpad(trim(t.tou),3,'0')= lpad(trim(branch_.tourne),3,'0')
                      and   lpad(trim(t.ord),3,'0')=lpad(trim(branch_.ordre),3,'0')
                      and   trim(t.dist)=trim(branch_.district)
                      and   upper(trim(branch_.gros_consommateur))='N'
                      and   trim(t.dist) = v_district_;
                exception when others then null;
                end;

        v_date_ferm:=null;
        begin
        select m.date_res into v_date_ferm
        from branchement_res_max m
        where m.dist||m.ref_pdl=branch_.district||branch_.tourne||branch_.ORDre
        and trim(branch_.ETAT_BRANCHEMENT)='9';

       exception when no_data_found then null;

       end;

            insert into MIWTPROPRIETAIRE
            (
            PRO_NUM     ,--1
            PRO_IN_INS  ,--2
            PRO_CL_CODE ,--3
            pro_adm     ,--4
            PRO_DT_DEBUT,--5
            PRO_DT_FIN   --6
            )
            values
            (
            seq_miwtprop,--1 PRO_NUM NUMBER(10)  N     Identifiant unique
            V_IN_INS    ,--2 ||branch_.tier, PRO_IN_INS  VARCHAR2(20)  N     Identifiant de l'installation
            v_clt_code  ,--3 PRO_CL_CODE NUMBER(10)  N     Code du client
            v_adm       ,--4
            v_date      ,--5 nvl(v_date_creation, '01/01/1990'), -- PRO_DT_DEBUT  DATE  N     date de debut de propriete  (mettre une date bidon) (obligatoire)
            v_date_ferm  --6 PRO_DT_FIN  DATE  Y     date de fin de propriete
            );
               exception when others then
                  err_code := SQLCODE;
                  err_msg := SUBSTR(SQLERRM, 1, 200);
                  insert into prob_migration (nom_table,val_ref,sql_err , date_pro,type_problem )
                  values('MIWTPROPRIETAIRE',V_IN_INS,err_code||'--'||err_msg, sysdate,'PROPRIETAIRE existe avec cette refrence'||V_IN_INS );

               end;


               begin
                   v_date_ferm:=null;
        begin
        select m.date_res into v_date_ferm
        from branchement_res_max m
        where m.dist||m.ref_pdl=branch_.district||branch_.tourne||branch_.ORDre
          and trim(branch_.ETAT_BRANCHEMENT)='9';
       exception when no_data_found then null;
       end;

      insert into MIWTHISTOPAYEUR (
      MHPA_SOURCE     ,--1
      MHPA_REF_ABNT   ,--2
      MHPA_REF_PAYEUR ,--3
      MHPA_MRIB_REF   ,--4
      MHPA_DDEB       ,--5
      MHPA_DFIN       ,--6
      VOC_SETTLEMODE   --7
      )
      values
      (
      'DIST'||v_district_,--1
      v_abn_ref          ,--2
      v_clt_code         ,--3
      null               ,--4
      v_date             ,--5
      v_date_ferm        ,--6
      1                   --7
      );
  exception when others then
                  err_code := SQLCODE;
                  err_msg := SUBSTR(SQLERRM, 1, 200);
                  insert into prob_migration (nom_table,val_ref,sql_err , date_pro,type_problem)
                  values('MIWTHISTOPAYEUR',V_IN_INS,err_code||'--'||err_msg, sysdate,'payeur existe deja avec cette reference'||V_IN_INS);
                end;



            --********************************************************************
            -- insertion BRANCHEMENT EAU BRANCHEMENT EAU BRANCHEMENT EAU
            --********************************************************************
            /*select SEQ_MIG_BRA_EAU.Nextval
              into V_SEQ_MIG_BRA_EAU
              from dual;*/
              begin
                select posit into v_posit from  abonnees t
                where lpad(trim(t.pol),5,'0')=lpad(trim(branch_.police),5,'0')
                      and   lpad(trim(t.tou),3,'0')= lpad(trim(branch_.tourne),3,'0')
                      and   lpad(trim(t.ord),3,'0')=lpad(trim(branch_.ordre),3,'0')
                      and   trim(t.dist)=trim(branch_.district)
                      and   upper(trim(branch_.gros_consommateur))='N'
                      and   trim(t.dist) = v_district_;
                exception when others then null;
                end;
if v_posit <9 then
  v_posit:=0;
  end if;
  begin

           insert into miwtbra(
                  MBRA_SOURCE      ,--1  VARCHAR2(100)  N      Identifiant de la source de donnees [OBL]
                  MBRA_REF         ,--2  VARCHAR2(100)  N      Reference du branchement dans le SI source (le couple source/reference doit etre unique) [OBL]
                  MBRA_REFADR      ,--3  VARCHAR2(100)  N      Reference de l'adresse dans le SI source [OBL]
                  MBRA_TYPE        ,--4  VARCHAR2(1)    Y      Type du branchement (U=unique;S=serie;P=parallele;C=compose)
                  MBRA_ETAT        ,--5  VARCHAR2(1)    Y      Etat du branchement : 0=ferme, 1=Ouvert, 2=Supprime
                  MBRA_DETAT       ,--6  DATE           Y      Date du dernier changement d'etat
                  MBRA_REFVOCRESEAU,--7  VARCHAR2(100)  Y      Reference du reseau auquel appartient le branchement (libelle ou code source dans la table des correspondances)
                  MBRA_STEP        ,--8  VARCHAR2(100)  Y
                  MBRA_CHATEAU     ,--9  VARCHAR2(100)  Y
                  VOC_MATBRA       ,--10 VARCHAR2(100)  Y      Composition physique
                  VOC_DIABRA       ,--11 VARCHAR2(100)  Y      diametre
                  VOC_LGBRA        ,--12 VARCHAR2(100)  Y      longuer
                  MBRA_ETATASS     ,--13 VARCHAR2(100)  Y      Date Etat raccordement Ass
                  MBRA_DATEASS     ,--14 DATE           Y
                  MBRA_VANNEINDIV  ,--15 VARCHAR2(100)  Y      Vanne Individuelle
                  MBRA_VANNEINNAC  ,--16 VARCHAR2(100)  Y      Vanne Innacessible
                  COMMENTAIRE       --17 VARCHAR2(4000) Y
                  )
                values(
                 'DIST'||v_district_,--1  VARCHAR2(100)  N      Identifiant de la source de donnees [OBL]
                  V_IN_INS          ,--2  VARCHAR2(100)  N      Reference du branchement dans le SI source (le couple source/reference doit etre unique) [OBL]
                  V_AD_NUM          ,--3  VARCHAR2(100)  N      Reference de l'adresse dans le SI source [OBL]
                  1                 ,--4  VARCHAR2(1)    Y      Type du branchement (U=unique;S=serie;P=parallele;C=compose)
                  v_posit           ,--5  VARCHAR2(1)    Y      Etat du branchement : 0=ferme, 1=Ouvert, 2=Supprime
                  v_date            ,--6  DATE           Y      Date du dernier changement d'etat
                  NULL              ,--7  VARCHAR2(100)  Y      Reference du reseau auquel appartient le branchement (libelle ou code source dans la table des correspondances)
                  NULL              ,--8  VARCHAR2(100)  Y
                  NULL              ,--9  VARCHAR2(100)  Y
                  NULL              ,--10 VARCHAR2(100)  Y      Composition physique
                  NULL              ,--11 VARCHAR2(100)  Y      diametre
                  NULL              ,--12 VARCHAR2(100)  Y      longuer
                  NULL              ,--13 VARCHAR2(100)  Y      Date Etat raccordement Ass
                  NULL              ,--14 DATE           Y
                  NULL              ,--15 VARCHAR2(100)  Y      Vanne Individuelle
                  NULL              ,--16 VARCHAR2(100)  Y      Vanne Innacessible
                  NULL               --17 VARCHAR2(4000) Y      Type de raccord assainissement
                      );
                exception when others then
                  err_code := SQLCODE;
                  err_msg := SUBSTR(SQLERRM, 1, 200);
                  insert into prob_migration (nom_table,val_ref,sql_err , date_pro,type_problem )
                  values('miwtbra',V_IN_INS,err_code||'--'||err_msg, sysdate,'branchement existe deja avec cette reference'||V_IN_INS);
                end;
            --********************************************************************
            -- insertion PDI PDI PDI PDI PDI PDI PDI PDI PDI PDI PDI PDI PDI PDI
            --********************************************************************

 begin
   v_date_ferm:=null;
        begin
        select m.date_res into v_date_ferm
        from branchement_res_max m
        where m.dist||m.ref_pdl=branch_.district||branch_.tourne||branch_.ORDre
        and trim(branch_.ETAT_BRANCHEMENT)='9';
       exception when no_data_found then null;
       end;

  v_VOC_FRQFACT:=null;
 if(upper(trim(branch_.gros_consommateur))='N' )then
    v_VOC_FRQFACT:='90';
    else
      v_VOC_FRQFACT:='30';
      end if;
     if  (branch_.tourne='898' or branch_.tourne='899')then
       v_tournee:=v_district_||'_AS';
       else
       v_tournee:=branch_.tourne;
       end if;
      insert into miwtpdl
            (
            PDL_SOURCE    ,--1  VARCHAR2(100)  N      Identifiant de la source de donnees [OBL]
            PDL_REF       ,--2  VARCHAR2(100)  N      Reference du point de comptage dans le SI source (le couple source/reference doit etre unique) [OBL]
            PDL_REFBRA    ,--3  VARCHAR2(100)  Y      Reference du branchement dans le SI source [OBL]
            PDL_REFADR    ,--4  VARCHAR2(100)  N      Reference de l''adresse dans le SI source [OBL]
            PDL_REFTOU    ,--5  VARCHAR2(100)  Y      Reference de la tournee dans la source du client
            PDL_REFPDE_PERE,--6 VARCHAR2(100)  Y
            PDL_TYPE      ,--7  VARCHAR2(1)    Y
            PDL_TOUORDRE  ,--8  NUMBER(10)     Y      Ordre du point de comptage dans la tournee
            PDL_REFSITE   ,--9  VARCHAR2(100)  Y      Reference de la site dans le SI source
            VOC_DIFFREAD  ,--10 VARCHAR2(100)  Y      Liste des Vocabulaires etat de releve (Difficulte de releve, plaque de fonte, Egout...) ..difficulte releve
            VOC_ACCESS    ,--11 VARCHAR2(100)  Y      Liste des vocabulaire Accessibilite (Jardin, Limite propriete ...) ..accessibilite compteur
            VOC_READINFO1 ,--12 VARCHAR2(100)  Y      Liste des Vocabulaires Inforamation 1 sur releve ...Emplacement compteur
            VOC_READINFO2 ,--13 VARCHAR2(100)  Y      Liste des Vocabulaires Inforamation 2 sur releve
            VOC_READINFO3 ,--14 VARCHAR2(100)  Y      Liste des Vocabulaires Inforamation 3 sur releve
            PDL_REFFLD    ,--15 VARCHAR2(100)  Y
            PDL_SECTEUR_1 ,--16 VARCHAR2(32)   Y      Secteur 1 administratif
            PDL_SECTEUR_2 ,--17 VARCHAR2(32)   Y      Secteur 2 intervention de terrain
            PDL_SECTEUR_3 ,--18 VARCHAR2(32)   Y      Secteur 3
            PDL_SECTEUR_4 ,--19 VARCHAR2(32)   Y      Secteur 4
            PDL_SECTEUR_5 ,--20 VARCHAR2(32)   Y      Secteur 5
            PDL_ETAT      ,--21 VARCHAR2(1)    Y      Etat du point de comptage : 0=ferme, 1=Ouvert, 2=Supprime
            PDL_DETAT     ,--22 DATE           Y      Date du dernier changement d''etat
            VOC_METHDEP   ,--23 VARCHAR2(100)  Y
            PDL_COMMENT   ,--24 VARCHAR2(4000) Y
            PDL_REFPER_P  ,--25 NUMBER(10)     Y      Ref Client Proprietaire
            VOC_CONNAT    ,--26
            VOC_CONSTATUS ,--27
            PDL_DFERMETURE,--28
            VOC_FRQFACT
            )
            values
            (
            'DIST'||v_district_,--1
            V_IN_INS           ,--2 not null identifiant du branchement   -- PDI_REFERENCE
            V_IN_INS           ,--3 not null Reference de l'installation (mig_ins.ins_id)
            V_AD_NUM           ,--4 Numero d'adresse du branchement
           v_tournee     ,--5 Code de la tournee associee a ce PDI
            NULL               ,--6
            'E'                ,--7 not null 'E' type eau
            branch_.ORDre      ,--8 Numero d'ordre dans la tournee : Permet de commencer par tel pdi dans tel rue en 1er
            V_IN_INS           ,--9
            NULL               ,--10
            NULL               ,--11
            NULL               ,--12
            NULL               ,--13
            NULL               ,--14
            'PDC EAU'          ,--15
            v_district_        ,--16
            NULL               ,--17
            NULL               ,--18
            NULL               ,--19
            NULL               ,--20
            v_posit            ,--21 Code etat du branchement  -- 1
            v_date             ,--22 not null date etat branchement  -- date de pdi
            NULL               ,--23
            branch_.marche     ,--24 Commentaire point d'installation      -- PDI_LIBRE
            NULL               ,--25
            branch_.type_branchement,--26
            branch_.aspect_branchement,--27
            v_date_ferm        ,--28
            v_VOC_FRQFACT      --29
            ) ;
             exception when others then
                  err_code := SQLCODE;
                  err_msg := SUBSTR(SQLERRM, 1, 200);
                  insert into prob_migration (nom_table,val_ref,sql_err , date_pro,type_problem )
                  values('miwtpdl',V_IN_INS,err_code||'--'||err_msg, sysdate,'pdl existe deja avec cette reference'||V_IN_INS);
                end;



           /* update branchement t
               set t.btrsf_inst = 'O'
             where t.district = branch_.district
               and t.gros_consommateur = branch_.gros_consommateur
               and t.tourne = branch_.tourne
               and t.ordre = branch_.ordre;*/
            --commit;
            --********************************************************************
            -- insertion ABONNEMENT ABONNEMENT ABONNEMENT ABONNEMENT ABONNEMENT
            --********************************************************************
            begin
              -- MAJ SUIVI MIGRATION
              --mig_progress('MIG_ABN', 'R', 0, 0);
              --select seq_mig_abn.nextval into v_seq_mig_abn from dual;
              --v_abn_contrat := branch_.district ||'0'||to_char(branch_.police);
              v_abn_contrat := branch_.district || lpad(to_char(trim(branch_.police)),5,'0') ||
                               lpad(trim(branch_.ordre),3,'0') || lpad(trim(branch_.tourne),3,'0');
              /*v_abn_mod_pay := 0;
              if ltrim(rtrim(branch_.num_compte)) is not null then
                v_abn_mod_pay := 1;
              end if;*/

              -- *****************************************************************************
              -- Ajoute par BEN MANSOUR ARAB SOFT le 21/05/2014 a la demande de HAMDI KHALDI
              -- prise en charge des usages
              --******************************************************************************
              -- reception du libelle de l'usage
             /* for usage_ in (select * from usage a where a.code = branch_.usage) loop
                v_abn_lib_usage := trim(usage_.desig);
              end loop;*/
              --******************************************************************************
begin
    begin
  select consmoy,'ONAS'||CODONAN  into v_consmoy, v_CODONAS
                from  abonnees t
                where lpad(trim(t.pol),5,'0')=lpad(trim(branch_.police),5,'0')
                      and   lpad(trim(t.tou),3,'0')= lpad(trim(branch_.tourne),3,'0')
                      and   lpad(trim(t.ord),3,'0')=lpad(trim(branch_.ordre),3,'0')
                      and   trim(t.dist)=trim(branch_.district)
                      and   upper(trim(branch_.gros_consommateur))='O'
                      and   trim(t.dist) = v_district_;
                exception when others then v_consmoy:=0;
                end;



       v_date_ferm:=null;
        begin
        select m.date_res into v_date_ferm
        from branchement_res_max m
        where m.dist||m.ref_pdl=branch_.district||branch_.tourne||branch_.ORDre
        and trim(branch_.ETAT_BRANCHEMENT)='9';
       exception when no_data_found then null;
       end;

insert into miwabn
      (
        ABN_SOURCE        ,--1  VARCHAR2(100)  N
        ABN_REF           ,--2  VARCHAR2(100)  N      identifiant de l'abonnement : N? fourni par l'utilisateur (cle primaire)
        ABN_REFSITE       ,--3  VARCHAR2(100)  Y      Reference de l'installation (obligatoire)
        ABN_REFPDL        ,--4  VARCHAR2(100)  N      Reference du point de comptage dans le SI source
        ABN_REFGRF        ,--5  VARCHAR2(100)  Y      Voir description du groupe de facturation
        ABN_REFPER_A      ,--6  VARCHAR2(100)  Y
        ABN_DT_DEB        ,--7  DATE           N      Date de debut d'abonnement (obligatoire)
        ABN_DT_FIN        ,--8  DATE           Y      Date de fin d'abonnement
        ABN_CTRTYPE_REF   ,--9  VARCHAR2(100)  Y      Reference du contrat d'abonnement (police) (obligatoire)
        ABN_MODEFACT      ,--10 NUMBER(1)      Y      0=facturation par role, 1=facturation par planning
        ABN_GELER         ,--11 NUMBER(1)      Y      1:gel de contrat en facturation,0 Sinon
        ABN_DTGELER       ,--12 DATE           Y      date de gel de facturation
        ABN_EXOTVA        ,--13 NUMBER(1)      Y      0  1: Exonere de TVA,0 sinon
        VOC_FROZEN        ,--14 VARCHAR2(100)  Y      motif du gel [FROZEN]
        VOC_TYPDURBILL    ,--15 VARCHAR2(100)  Y      1: Exonere de TVA,0 sinon
        VOC_CUTAGREE      ,--16 VARCHAR2(100)  Y      drois de coupure [CUTAGREE]
        VOC_TYPSAG        ,--17 VARCHAR2(100)  Y      type de service (professionnel, domestique) [TYPSAG]
        VOC_USGSAG        ,--18 VARCHAR2(100)  Y      Usage Res Principal, Local, Res. Secondaire [USGCAG]
        ABN_REFREL        ,--19 VARCHAR2(100)  Y      Reference du chaine de relance  dans le SI source
        ABN_REFPFT        ,--20 VARCHAR2(100)  Y      Reference du Profil type dans le SI source
        ABN_NORECOVERY    ,--21 NUMBER(1)      Y      exonerer de relance (0=non, 1=oui)
        ABN_DTFIN_RECOVERY,--22 DATE           Y
        ABN_DELAIP        ,--23 NUMBER(2)      Y      Delai de paiement
        ABN_COMMENTAIRE   ,--24 VARCHAR2(4000) Y      Commentaire libre PDS
        ABN_SOLDE         ,--25 NUMBER(17,10)  Y      Solde de l'abonnement
        MIGABN_CR         ,--26 NUMBER(10,3)   Y      consommation de reference par defaut
        MIGABN_CRDTFIN    ,--27 DATE           Y      fin de validite de la consommation de reference par defaut
        ABN_REFPFT_DETAIL ,--28 VARCHAR2(100)  Y      Reference du Profil type  Detaildans le SI source
        ofr_code          ,--29
        ofr_code_second    --30
       )
       Values
       ('DIST'||v_district_,--1
        v_abn_ref          ,--2
        V_IN_INS           ,--3
        V_IN_INS           ,--4
        '1'                ,--5 groupe facturation
        v_clt_code         ,--6 Numero du client Abonne A
        v_date             ,--7
        v_date_ferm        ,--8
        null               ,--9
        0                  ,--10
        0                  ,--11
        null               ,--12
        0                  ,--13
        null               ,--14
        0                  ,--15
        0                  ,--16
        'P'                ,--17
        branch_.usage      ,--18
        null               ,--19
        'OFRTEST'          ,--20
        0                  ,--21
        null               ,--22
        30                 ,--23
        null               ,--24
        0                  ,--25 avoir
        v_consmoy          ,--26
        null               ,--27
        null               ,--28
        branch_.ofr_snd    ,--29
        v_CODONAS           --30
        ) ;
 exception when others then
                  err_code := SQLCODE;
                  err_msg := SUBSTR(SQLERRM, 1, 200);
                  insert into prob_migration (nom_table,val_ref,sql_err , date_pro,type_problem )
                  values('miwabn',V_IN_INS,err_code||'--'||err_msg, sysdate,'abonnement existe deja avec cette reference'||V_IN_INS );
                end;
                commit;


 begin
                select codpoll,napt,consmoy,echronas,echtonas,capitonas,interonas,arrond,'1'
                into v_codpoll,v_napt,v_consmoy,v_echronas,v_echtonas,v_capitonas,v_interonas,v_arrond,v_periodicite
                from  abonnees t
                where lpad(trim(t.pol),5,'0')=lpad(trim(branch_.police),5,'0')
                      and   lpad(trim(t.tou),3,'0')= lpad(trim(branch_.tourne),3,'0')
                      and   lpad(trim(t.ord),3,'0')=lpad(trim(branch_.ordre),3,'0')
                      and   trim(t.dist)=trim(branch_.district)
                      and   upper(trim(branch_.gros_consommateur))='N'
                      and   trim(t.dist) = v_district_;
                exception when others then null;
                end;

for c in (select  * from miwengagement) loop

  if to_number(nvl(v_codpoll,'0'))!=0 and c.sub_comment=upper('codpoll') then mnt_val_eng_:=v_codpoll;
    elsif to_number(nvl(v_napt,'0'))!=0 and c.sub_comment=upper('napt') then mnt_val_eng_:=v_napt;
     -- elsif  v_consmoy is not null and c.sub_comment=upper('consmoy') then mnt_val_eng_:=v_consmoy;
        elsif to_number(nvl(v_echtonas,'0'))!=0 and c.sub_comment=upper('echtonas') then mnt_val_eng_:=to_number(v_echtonas);
          elsif to_number(nvl(v_echronas,'0'))!=0 and c.sub_comment=upper('echronas') then mnt_val_eng_:=to_number(v_echronas);
            elsif to_number(nvl(v_capitonas,'0'))!=0 and c.sub_comment=upper('capitonas') then mnt_val_eng_:=to_number(v_capitonas)/1000;
              elsif to_number(nvl(v_interonas,'0'))!=0 and c.sub_comment=upper('interonas') then mnt_val_eng_:=to_number(v_interonas)/1000;
                elsif  v_arrond is not null and c.sub_comment=upper('arrond') then mnt_val_eng_:=to_number(v_arrond)/1000;
                   --elsif  v_periodicite is not null and c.sub_comment=upper('PERIODE') then mnt_val_eng_:=v_periodicite;

else goto xx;

end if;

begin

          insert into miwengabn
          (
          asu_subsource,--1
          asu_subref   ,--2
          asu_refsource,--3
          asu_refabn   ,--4
          asu_value    ,--5
          asu_dtdebut   --6
          )
          values
          (
          c.sub_source,--1
          c.sub_ref   ,--2
          c.sub_source,--3
          v_abn_ref   ,--4
          mnt_val_eng_,--5
          v_date       --6
          );
          exception when others then
             err_code := SQLCODE;
                            err_msg := SUBSTR(SQLERRM, 1, 200);
                            insert into prob_migration (nom_table,val_ref,sql_err , date_pro,type_problem )
                            values('miwengabn',v_abn_ref,err_code||'--'||err_msg, sysdate,' engagement existe deja avec cette reference'||V_IN_INS);
                           end;

        commit;

        v_codpoll:=null;
        v_napt:=null;
        v_consmoy:=null;
        v_echronas:=null;
        v_echtonas:=null;
        v_capitonas:=null;
        v_interonas:=null;
        v_arrond:=null;
        v_periodicite:=null;
        mnt_val_eng_:=null;




    <<xx>>
     null;
end loop;

begin

for v in(
select distinct b.district, b.police,b.tourne,b.ordre,b.etat_branchement,b.gros_consommateur,g.gc
from branchement b ,gestion_compteur g
where trim(b.tourne)||trim(b.ordre) not in(select lpad(trim(t.tou),3,'0')||lpad(trim(t.ord),3,'0')
                                                      from abonnees t)
and trim(b.tourne)||trim(b.ordre) not in(select lpad(trim(r.tou),3,'0')||lpad(trim(r.ord),3,'0')
                                                    from abonnees_gr r)
and trim(b.tourne)||trim(b.ordre) = lpad(trim(g.tournee),3,'0')||lpad(trim(g.ordre),3,'0')
and lpad(trim(b.police),5,'0')=lpad(trim(branch_.police),5,'0')
and lpad(trim(b.tourne),3,'0')=lpad(trim(branch_.tourne),3,'0')
and lpad(trim(b.ordre),3,'0')=lpad(trim(branch_.ordre),3,'0')
and b.district=branch_.district
and lpad(trim(g.tournee),3,'0')=lpad(trim(b.tourne),3,'0')
and lpad(trim(g.ordre),3,'0')=lpad(trim(b.ordre),3,'0')
and to_date(g.date_action,'dd/mm/yyyy') =(select max(to_date(s.date_action,'dd/mm/yyyy'))
                                             from gestion_compteur s
                                             where trim(s.tournee)||trim(s.ordre)=trim(g.tournee)||trim(g.ordre) )
                     )loop

  begin

  select a.abn_ref into v_abn_ref
   from miwabn a where a.abn_refsite=trim(v.district)
                                       ||lpad(trim(v.tourne),3,'0')
                                       ||lpad(trim(v.ordre),3,'0')
                                       ||lpad(trim(v.police),5,'0');
   if upper(trim(v.gc))='O' then
     v_asu_value:='Oui';
   else
       v_asu_value:='Non';
   end if;


          insert into miwengabn
          (
          asu_subsource,--1
          asu_subref   ,--2
          asu_refsource,--3
          asu_refabn   ,--4
          asu_value    ,--5
          asu_dtdebut   --6
          )
          values
          (
          'DIST'||v_district_,--1
          'GROS_CONSOMMATEUR',--2
          'DIST'||v_district_,--3
          v_abn_ref   ,--4
          v_asu_value ,--5
          null         --6
          );
          exception when others then
             err_code := SQLCODE;
                            err_msg := SUBSTR(SQLERRM, 1, 200);
                            insert into prob_migration (nom_table,val_ref,sql_err , date_pro,type_problem )
                            values('miwengabn_1',v_abn_ref,err_code||'--'||err_msg, sysdate,'engagement existe deja avec cette reference'||V_IN_INS);
           end;

        commit;


    end loop;
    end;

             /* update branchement t
                 set t.btrsf_abn = 'O'
               where t.district = branch_.district
                 and t.gros_consommateur = branch_.gros_consommateur
                 and t.tourne = branch_.tourne
                 and t.ordre = branch_.ordre;*/
              --commit;
              v_nbr_trsf_abn := v_nbr_trsf_abn + 1;
              --SKA 28/11/2014
              -- SUPPRIME LES EXCEPTION
            /*exception
              when others then
                rollback;
                v_nbr_rej_abn := v_nbr_rej_abn + 1;
                v_msg         := sqlerrm;*/
               /* update branchement t
                   set t.btrsf_abn = 'R', t.cmsg_abn = v_msg
                 where t.district = branch_.district
                   and t.gros_consommateur = branch_.gros_consommateur
                   and t.tourne = branch_.tourne
                   and t.ordre = branch_.ordre;*/
                --commit;
            end;
            v_nbr_trsf_inst := v_nbr_trsf_inst + 1;
          else
            v_msg := null;
            if V_DTO > 1 then
              v_msg := '(DISTRICT,TOURNEE,ORDRE) dupplique';
            end if;
            if V_POLICE > 1 then
              v_msg := v_msg || 'CODE POLICE dupplique)';
            end if;
            if V_COMPTEUR > 1 then
              v_msg := v_msg || 'COMPTEUR dupplique';
            end if;
           /* update branchement t
               set t.btrsf_inst = 'R', t.cmsg_abn = v_msg
             where t.district = branch_.district
               and t.gros_consommateur = branch_.gros_consommateur
               and t.tourne = branch_.tourne
               and t.ordre = branch_.ordre;*/
            --commit;
          end if;
          --SKA 28/11/2014
          --Supression de l'exeception
        /*exception
          when others then
            rollback;
            v_nbr_rej_inst := v_nbr_rej_inst + 1;
            v_msg          := sqlerrm;*/
           /* update branchement t
               set t.btrsf_inst = 'R', t.cmsg_inst = v_msg
             where t.district = branch_.district
               and t.gros_consommateur = branch_.gros_consommateur
               and t.tourne = branch_.tourne
               and t.ordre = branch_.ordre;*/
            --commit;
        end;
V_AD_NUM:=null;
      end loop;
      -- MAJ SUIVI MIGRATION
      --mig_progress('MIG_INST', 'M', v_nbr_trsf_inst, v_nbr_rej_inst);
      --mig_progress('MIG_ABN', 'M', v_nbr_trsf_abn, v_nbr_rej_abn);
   /* else*/
      -- mise a jour de la table de progression de transfert
     /* update mig_progression t
         set t.cmsg = 'District inexistant: Il faut ajouter le nouveau district pour pouvoir transferer les tournees'
       where t.ltable_name = 'MIG_INST';*/
      --commit;
      --SKA le 28/11/2014
        --Commente le boucle secteur administratif
    --end if;

insert into prob_migration (nom_table)values(SYSTIMESTAMP||'   END miwtabonne_trim');
 commit;
  end;
/

prompt
prompt Creating procedure MIWT_COMPTEUR
prompt ================================
prompt
create or replace procedure miwt_compteur(district_ varchar2)
is
  cursor c is select distinct
  ltrim(rtrim(x.num_compteur)) num_cpt,ltrim(rtrim(x.code_marque)) codemarque
      from
      (
      select lpad(trim(b.compteur_actuel),11,'0') num_compteur,lpad(trim(b.code_marque),3,'0') code_marque
      from branchement b
      where b.compteur_actuel is not null
      and   b.district=district_
      union
      select lpad(trim(g.num_compteur),11,'0') num_compteur,lpad(trim(g.code_marque),3,'0') code_marque
      from gestion_compteur g
      where trim(g.num_compteur) is not null
      union
      select lpad(trim(c.num_compteur),11,'0') num_compteur,lpad(trim(c.code_marque),3,'0') code_marque
       from compteur c
       where trim(c.num_compteur) is not null
      ) x;

  v_voc_model number;
  v_voc_diam  number;
  v_nbr_roues number;
  v_annee     number;
  v_voc_CLASS VARCHAR2(2);
  V_RL_CP_NUM_RL varchar2(60);
  ref_cpt     varchar2(20);
  v_lib_voc   varchar2(50);
  err_code    varchar2(200);
  err_msg     varchar2(200);

begin
execute immediate 'alter session set nls_date_format = ''dd/mm/yyyy''';
execute immediate 'alter session set NLS_NUMERIC_CHARACTERS = '',.''';
    --***
    delete miwtcompteur where mcom_ref = 'DIST' || district_;
    delete prob_migration
    where nom_table in ('miwtcompteur');
    insert into prob_migration (nom_table)values(SYSTIMESTAMP||'   START Miwt_compteur');
    commit;
  -------SKA 13/05/2015
  for cpt_ in c loop
  v_voc_model:=0;
  v_lib_voc:=v_lib_voc;
  v_voc_diam:=0;
  v_voc_CLASS:=0;
  v_nbr_roues:=0;
  v_annee:=0;
  ref_cpt:=district_||lpad(trim(cpt_.codemarque),3,'0')||lpad(ltrim(rtrim(cpt_.num_cpt)),11,'0');
if ref_cpt is not null then
  --recupere model de compteur
  /* BEGIN
 select v.MVOC_REF,v.mvoc_libe into v_voc_model,v_lib_voc from miwtvocable v,compteur c
where v.mvoc_type = 'VOW_MODEL'
and ltrim(rtrim(v.mvoc_libe)) = ltrim(rtrim(c.type_compteur))
and cpt_.ref_cpt = ltrim(rtrim(c.code_marque)) || ltrim(rtrim(c.NUM_COMPTEUR));
EXCEPTION WHEN no_data_found then v_voc_model:=0;v_lib_voc:=v_lib_voc; end;*/
  --recupere diam  de comteur
  begin
  select c.diam_compteur,c.nbr_roues,c.annee_fabrication into v_voc_diam,v_nbr_roues,v_annee
  from  compteur c
  where ref_cpt = district_||lpad(trim(c.code_marque),3,'0')||lpad(trim(c.NUM_COMPTEUR),11,'0');
  exception when others then v_voc_diam:=0;v_annee:=0;v_nbr_roues:=0; end;

----recupere class de compteur
  begin
    select  m.classe into v_voc_CLASS from compteur c,marque m
    where  c.code_marque = m.code
    and ref_cpt = district_||lpad(trim(c.code_marque),3,'0')||lpad(trim(c.NUM_COMPTEUR),11,'0')
    and rownum=1;
    EXCEPTION WHEN others then v_voc_CLASS:=0;
    end;
------ nbr roue
/*begin
select c.nbr_roues,c.annee_fabrication into v_nbr_roues from compteur c
where  cpt_.ref_cpt = ltrim(rtrim(c.code_marque)) || ltrim(rtrim(c.NUM_COMPTEUR));
exception when others then v_nbr_roues:=0; end;
------ annee
begin
select c.annee_fabrication into v_annee from compteur c
where  cpt_.ref_cpt = ltrim(rtrim(c.code_marque)) || ltrim(rtrim(c.NUM_COMPTEUR));
exception when others then v_annee:=0; end;*/
  begin
--    classe 100
        if cpt_.codemarque= 101 THEN v_nbr_roues:=0 ;
        elsif cpt_.codemarque= 102 THEN v_nbr_roues:=4 ;
        elsif cpt_.codemarque= 103 THEN v_nbr_roues:=4 ;
        elsif cpt_.codemarque= 104 AND v_voc_diam=15 THEN v_nbr_roues:=4 ;
        elsif cpt_.codemarque= 104 AND v_voc_diam=40 THEN v_nbr_roues:=5;
        elsif cpt_.codemarque= 105 THEN v_nbr_roues:=4 ;
        elsif cpt_.codemarque= 106 THEN v_nbr_roues:=6 ;
        elsif cpt_.codemarque= 107 THEN v_nbr_roues:=6 ;
        elsif cpt_.codemarque= 108 THEN v_nbr_roues:=6 ;
        elsif cpt_.codemarque= 109 THEN v_nbr_roues:=5 ;
        elsif cpt_.codemarque= 110 THEN v_nbr_roues:=4;
        elsif cpt_.codemarque= 111 THEN v_nbr_roues:=4;
        elsif cpt_.codemarque= 112 THEN v_nbr_roues:=0;
        elsif cpt_.codemarque= 113 THEN v_nbr_roues:=4;
        elsif cpt_.codemarque= 114 THEN v_nbr_roues:=4;
        elsif cpt_.codemarque= 115 AND v_voc_diam=15 THEN v_nbr_roues:=4 ;
        elsif cpt_.codemarque= 115 AND v_voc_diam=30 THEN v_nbr_roues:=5;
        elsif cpt_.codemarque= 116 THEN v_nbr_roues:=5 ;
        elsif cpt_.codemarque= 117 THEN v_nbr_roues:=5  ;
        elsif cpt_.codemarque= 118 THEN v_nbr_roues:=6;
        elsif cpt_.codemarque= 120 THEN v_nbr_roues:=4;
        elsif cpt_.codemarque= 121 THEN v_nbr_roues:=4;
        --    classe 200
        elsif cpt_.codemarque= 201 THEN v_nbr_roues:=4;
        elsif cpt_.codemarque= 202 THEN v_nbr_roues:=4;
        elsif cpt_.codemarque= 203 AND v_voc_diam=15 THEN v_nbr_roues:=4 ;
        elsif cpt_.codemarque= 203 AND v_voc_diam=40 THEN v_nbr_roues:=5 ;
        elsif cpt_.codemarque= 203 AND v_voc_diam>40 THEN v_nbr_roues:=6;
        elsif cpt_.codemarque= 204 THEN v_nbr_roues:=4;
        elsif cpt_.codemarque= 205 THEN v_nbr_roues:=4;
        elsif cpt_.codemarque= 206 THEN v_nbr_roues:=4;
        elsif cpt_.codemarque= 207 AND v_voc_diam=15 THEN v_nbr_roues:=4 ;
        elsif cpt_.codemarque= 207 AND v_voc_diam=20 THEN v_nbr_roues:=4;
        elsif cpt_.codemarque= 207 AND v_voc_diam=40 THEN v_nbr_roues:=5;
        elsif cpt_.codemarque= 208 THEN v_nbr_roues:=4;
        elsif cpt_.codemarque= 210 THEN v_nbr_roues:=5;
        elsif cpt_.codemarque= 211 THEN v_nbr_roues:=6;
        elsif cpt_.codemarque= 212 THEN v_nbr_roues:=5 ;
        --    classe 300
        elsif cpt_.codemarque= 306  THEN v_nbr_roues:=4;
        elsif cpt_.codemarque= 310 THEN v_nbr_roues:=4;
        ELSE
        v_nbr_roues:=4;
        END IF;
        
        insert into miwtcompteur
       (
        MCOM_SOURCE      ,--1
        MCOM_REF         ,--2
        MCOM_REEL        ,--3
        VOC_DIAM         ,--4
        MCOM_ANNEE       ,--5
        MCOM_REFVOCCLASSE,--6
        NCOM_NBROUE      ,--7
        VOC_MODEL        ,--8
        REF_TYPEEQUI     ,--9
        VOC_EQUSTATUS    ,--10
        MTC_ID            --11
       ) 
      values
      (
        'DIST'||district_   ,--1
        ref_cpt             ,--2
        lpad(trim(cpt_.num_cpt),11,'0'),--3
        nvl(v_voc_diam,0)   ,--4
        nvl(v_annee,1900)   ,--5
        v_voc_CLASS         ,--6
        nvl(v_nbr_roues,0)  ,--7
        lpad(trim(cpt_.codemarque),3,'0') ,--8
        'EAU'               ,--9
        1                   ,--10
        1                    --11
      );
  exception when others then
  err_code := SQLCODE;
  err_msg := SUBSTR(SQLERRM, 1, 200);
  insert into prob_migration (nom_table,val_ref,sql_err , date_pro,type_problem )
  values('miwtcompteur',ref_cpt,err_code||'--'||err_msg, sysdate,'erreur de confomité de type colonne pour le compteur suivante '||ref_cpt);
  end;
commit;
end if;
end loop;



for v in (select distinct lpad(trim(b.codemarque),3,'0') code_marque,
         lpad(trim(b.ncompteur),11,'0') compteur_actuel,
         b.diamctr,
         b.nbre_roues
       from fiche_releve b
       where trim(b.annee)||trim(b.trim)=(select max(trim(f.annee)||trim(f.trim)) from fiche_releve f
                                         where  trim(f.district)||lpad(trim(f.tourne),3,'0')||lpad(trim(f.ordre),3,'0')
                                                =trim(b.district)||lpad(trim(b.tourne),3,'0')||lpad(trim(b.ordre),3,'0')
                                                and trim(f.ncompteur) is not null and trim(f.codemarque)!='000')
       and trim(b.district)||trim(b.codemarque)||lpad(trim(b.ncompteur),11,'0')not in(select c.MCOM_REF from miwtcompteur c)
       and trim(b.ncompteur) is not null and trim(b.codemarque)!='000')loop


V_RL_CP_NUM_RL := district_||v.code_marque||v.compteur_actuel;
 begin
      insert into miwtcompteur
        (
        MCOM_SOURCE   ,--1
        MCOM_REF      ,--2
        MCOM_REEL     ,--3
        VOC_DIAM      ,--4
        MCOM_ANNEE    ,--5
        MCOM_REFVOCCLASSE,--6
        NCOM_NBROUE   ,--7
        VOC_MODEL     ,--8
        REF_TYPEEQUI  ,--9
        VOC_EQUSTATUS ,--10
        MTC_ID         --11
        )
        values
        (
        'DIST'||district_ ,--1
        V_RL_CP_NUM_RL    ,--2
        v.compteur_actuel ,--3
        nvl(v.diamctr,0)  ,--4
        nvl(v_annee,1900) ,--5
        'Inconnue'        ,--6
        nvl(v.nbre_roues,0),--7
        v.code_marque     ,--8
        'EAU'             ,--9
        1                 ,--10
        1                  --11
        );
  exception when others then
                  err_code := SQLCODE;
                  err_msg := SUBSTR(SQLERRM, 1, 200);
                  insert into prob_migration (nom_table,val_ref,sql_err , date_pro,type_problem )
                  values('miwtcompteur',V_RL_CP_NUM_RL,err_code||'--'||err_msg,
                  sysdate,'erreur de confomité de type colonne pour le compteur suivante '||V_RL_CP_NUM_RL);
  end;
commit;



end loop;
 insert into prob_migration (nom_table)values(SYSTIMESTAMP||'   END  Miwt_compteur');
  commit;
end;
/

prompt
prompt Creating procedure MIWT_FAIRESUIVRE
prompt ===================================
prompt
CREATE OR REPLACE PROCEDURE MIWT_FAIRESUIVRE(v_district varchar2)
 is

    -- variables de traitement
    v_ad_vilrue     number(10);
    v_ad_num        number(10);
    err_code        varchar2(200);
    err_msg         varchar2(200);
    -- suivi traitement
    NBR_tot         number := 0;
    rindex          pls_integer := -1;
    slno            pls_integer;
    v_op_name       varchar2(200);
    v_ref_pdl       varchar2(200);
  begin
    --**************************************************
    delete from MIWTFAIRESUIVRE;
     delete  prob_migration where nom_table in ('FAIRESUIVRE');

    commit;

    --**************************************************

     for adm_ in (select a.ad2,b.client_actuel,b.categorie_actuel,a.codpostal,a.dist,a.tou,a.ord,a.pol
                from faire_suivre_gc a,branchement b
                where lpad(ltrim(rtrim(a.dist)),2,'0')=trim(b.district)
                and   lpad(ltrim(rtrim(a.tou)),3,'0')=lpad(trim(b.tourne),3,'0')
                and   lpad(ltrim(rtrim(a.ord)),3,'0')=lpad(trim(b.ordre),3,'0')
                and   lpad(ltrim(rtrim(a.pol)),5,'0')=lpad(trim(b.police),5,'0')) loop

     v_ref_pdl:=lpad(ltrim(rtrim(adm_.dist)),2,'0')||
     lpad(ltrim(rtrim(adm_.tou)),3,'0')||
     lpad(ltrim(rtrim(adm_.ord)),3,'0')||
     lpad(ltrim(rtrim(adm_.pol)),5,'0');

      V_AD_VILRUE:='999999999';
      miwtADRESSEPIVOT.MIG_ADR(v_adresse_   => adm_.ad2,
                    v_ad_vilrue_ => v_ad_vilrue,
                     V_CODE_POSTAL_ =>adm_.codpostal,
                     v_district=> v_district,
                     v_ad_num_    => v_ad_num);
       begin

      INSERT INTO MIWTFAIRESUIVRE
        (
        MFS_SOURCE ,--1
        MFS_REF    ,--2
        MFS_REFE   ,--3
        MFS_REF_ADR,--4
        MFS_REFPDL  --5
        )
       VALUES
       (
        'DIST'||v_district, --1
        v_district||adm_.categorie_actuel|| adm_.client_actuel,--2
        v_district||adm_.categorie_actuel|| adm_.client_actuel,--3
        V_AD_NUM,--4
        v_ref_pdl--5
       );
        exception
          when others then
            err_code := SQLCODE;
            err_msg  := SUBSTR(SQLERRM, 1, 200);
            insert into prob_migration
              (nom_table, val_ref, sql_err, date_pro)
            values
              ('FAIRESUIVRE',
               v_district||adm_.categorie_actuel|| adm_.client_actuel,
               err_code || '--' || err_msg,sysdate);

        end;
      end loop;
      for adm_ in (select a.adr2,b.client_actuel,b.categorie_actuel,a.codpostal,a.dist,a.tou,a.ord,a.pol
                from faire_suivre_part a,branchement b
                where lpad(ltrim(rtrim(a.dist)),2,'0')=trim(b.district)
                and   lpad(ltrim(rtrim(a.tou)),3,'0')=lpad(trim(b.tourne),3,'0')
                and   lpad(ltrim(rtrim(a.ord)),3,'0')=lpad(trim(b.ordre),3,'0')
                and   lpad(ltrim(rtrim(a.pol)),5,'0')=lpad(trim(b.police),5,'0')) loop

     v_ref_pdl:=lpad(ltrim(rtrim(adm_.dist)),2,'0')||
     lpad(ltrim(rtrim(adm_.tou)),3,'0')||
     lpad(ltrim(rtrim(adm_.ord)),3,'0')||
     lpad(ltrim(rtrim(adm_.pol)),5,'0');

      V_AD_VILRUE:='999999999';
      miwtADRESSEPIVOT.MIG_ADR(v_adresse_   => adm_.adr2,
                    v_ad_vilrue_ => v_ad_vilrue,
                     V_CODE_POSTAL_ =>adm_.codpostal,
                     v_district=> v_district,
                     v_ad_num_    => v_ad_num);
       begin

      INSERT INTO MIWTFAIRESUIVRE
        (
        MFS_SOURCE ,--1
        MFS_REF    ,--2
        MFS_REFE   ,--3
        MFS_REF_ADR,--4
        MFS_REFPDL  --5
        )
       VALUES
       (
        'DIST'||v_district, --1
        v_district||adm_.categorie_actuel|| adm_.client_actuel,--2
        v_district||adm_.categorie_actuel|| adm_.client_actuel,--3
        V_AD_NUM,--4
        v_ref_pdl--5
       );
        exception
          when others then
            err_code := SQLCODE;
            err_msg  := SUBSTR(SQLERRM, 1, 200);
            insert into prob_migration
              (nom_table, val_ref, sql_err, date_pro)
            values
              ('FAIRESUIVRE',
               v_district||adm_.categorie_actuel|| adm_.client_actuel,
               err_code || '--' || err_msg,sysdate);

        end;
      end loop;
   commit;

  end;
/

prompt
prompt Creating procedure MIWT_HIST_COMPTEUR
prompt =====================================
prompt
create or replace procedure MIWT_HIST_COMPTEUR(v_district varchar2) is


v_NB_LIGNE     number default(0);
err_code       varchar2(200);
err_msg        varchar2(200);
v_code_marque  varchar2(50);
v_compteur_actuel  varchar2(50);
v_voc_pose     varchar2(50);
v_voc_depose   varchar2(50);
val            number default (0);
v_nbr_roues    number;
v_annee        number;
v_voc_diam     number;
V_RL_CP_NUM_RL varchar2(60);

begin
execute immediate 'alter session set nls_date_format = ''dd/mm/yyyy''';
execute immediate 'alter session set NLS_NUMERIC_CHARACTERS = '',.''';
delete from miwthistocpt t where t.mhpc_source = 'DIST' || v_district;
delete  prob_migration where nom_table like 'HISTO_CPT%';
insert into prob_migration (nom_table)values(SYSTIMESTAMP||'   START Miwt_hist_compteur');
commit;

for releve_ in (select * from miwtpdl  ) loop
  -------------------------------------------------------
--------------------------- RECHERCHE COMPTEUR
      begin
      select lpad(trim(w.code_marque),3,'0') code_marque,
      lpad(trim(w.compteur_actuel),11, '0') compteur_actuel
      into v_code_marque, v_compteur_actuel
      from branchement w
      where trim(w.district)||trim(w.tourne)||trim(w.ordre) =substr(releve_.pdl_ref,1,8)
      and lpad(trim(w.compteur_actuel),11, '0') <>'00000000000'  ;
      exception when others then
            begin
            select lpad(trim(b.codemarque),3,'0') code_marque ,lpad(trim(b.ncompteur),11,'0') compteur_actuel
            into v_code_marque, v_compteur_actuel
            from fiche_releve b
            where trim(b.district)||lpad(trim(b.tourne),3,'0')||lpad(trim(b.ordre),3,'0')=substr(releve_.pdl_ref,1,8)
            and trim(b.annee)||trim(b.trim)=(select max(trim(f.annee)||trim(f.trim)) from fiche_releve f
            where  trim(f.district)||lpad(trim(f.tourne),3,'0')||lpad(trim(f.ordre),3,'0')=substr(releve_.pdl_ref,1,8)
            and trim(f.ncompteur) is not null and trim(f.codemarque)!='000');
            exception when others then
                  begin
                  select lpad(trim(c.code_marque),3,'0') code_marque, lpad(trim(c.num_compteur),11,'0') compteur_actuel 
                  into v_code_marque,v_compteur_actuel
                  from gestion_compteur c
                  where v_district||lpad(trim(c.tournee),3,'0')||lpad(trim(c.ordre),3,'0')=substr(releve_.pdl_ref,1,8)
                  and trim(c.num_compteur) is not null
                  and trim(c.annee)||trim(c.trim) = (select max(trim(b.annee)||trim(b.trim)) from gestion_compteur b
                  where v_district||lpad(trim(b.tournee),3,'0')||lpad(trim(b.ordre),3,'0')=substr(releve_.pdl_ref,1,8));
            exception when others then
            v_compteur_actuel:='00000000000';
            v_code_marque:='000';
            end;
           end;
      end;


if (v_compteur_actuel='00000000000' 
     and  v_code_marque='000') then
     
   val:=val+1;
  V_RL_CP_NUM_RL := v_district ||'MIG'||lpad(val,11,'0');


  begin
      insert into miwtcompteur
        (
        MCOM_SOURCE   ,--1
        MCOM_REF      ,--2
        MCOM_REEL     ,--3
        VOC_DIAM      ,--4
        MCOM_ANNEE    ,--5
        MCOM_REFVOCCLASSE,--6
        NCOM_NBROUE   ,--7
        VOC_MODEL     ,--8
        REF_TYPEEQUI  ,--9
        VOC_EQUSTATUS ,--10
        MTC_ID         --11
        )
        values
        (
        'DIST'||v_district ,--1
        V_RL_CP_NUM_RL     ,--2
        lpad(val,11,'0')   ,--3
        nvl(v_voc_diam,0)  ,--4
        nvl(v_annee,1900)  ,--5
        'Inconnue'         ,--6
        nvl(v_nbr_roues,0) ,--7
        'MIG'              ,--8
        'EAU'              ,--9
        1                  ,--10
        1                   --11
        );
  exception when others then
                  err_code := SQLCODE;
                  err_msg := SUBSTR(SQLERRM, 1, 200);
                  insert into prob_migration (nom_table,val_ref,sql_err , date_pro,type_problem )
                  values('miwtcompteur_mig',V_RL_CP_NUM_RL,err_code||'--'||err_msg,
                  sysdate,'erreur de confomité de type colonne pour le compteur suivante '||releve_.pdl_ref);
                end;
commit;
else
      V_RL_CP_NUM_RL := v_district || v_code_marque || v_compteur_actuel;
end if ;

  select max(g.NB_LIGNE)
  into v_NB_LIGNE
  from miwthistocpt g;
   v_NB_LIGNE := v_NB_LIGNE + 1;

begin

      if(releve_.pdl_dfermeture is null)then
      v_voc_pose:='P';
      v_voc_depose:=null;
      else
      v_voc_pose:='P';
      v_voc_depose :='D';
      end if;

 insert into miwthistocpt
            (
             MHPC_SOURCE   ,--1 VARCHAR2(100) not null,
             MHPC_REFCOM   ,--2 VARCHAR2(100) not null,
             MHPC_REFPDL   ,--3 VARCHAR2(100) not null,
             VOC_REASPOSE  ,--4 VARCHAR2(100) Vocabulaire Raison de pose
             MHPC_AGESOURCE,--5 VARCHAR2(100) Identifiant agent ayant Pose la compteur
             MHPC_DDEB     ,--6 DATE not null
             MHPC_DFIN     ,--7 DATE
             VOC_REASDEPOSE,--8
             NB_LIGNE      ,--9
             INDEX_DEPART  ,--10
             INDEX_ARRET    --11
             )
          values
            (
            'DIST' || v_district  ,--1 VARCHAR2(100) not null,
             V_RL_CP_NUM_RL       ,--2 VARCHAR2(100) not null,
             releve_.pdl_ref      ,--3 VARCHAR2(100) not null,
             v_voc_pose           ,--4 VARCHAR2(100) Vocabulaire Raison de pose
             null                 ,--5 VARCHAR2(100) Identifiant agent ayant Pose la compteur
             releve_.pdl_detat    ,--6 DATE not null
             releve_.pdl_dfermeture,--7 DATE
             v_voc_depose         ,--8
             v_NB_LIGNE           ,--9
             0                    ,--10
             0                     --11
             );
    exception
    when others then
    err_code := SQLCODE;
    err_msg  := SUBSTR(SQLERRM, 1, 200);
    insert into prob_migration
    (nom_table, val_ref, sql_err, date_pro,type_problem)
    values
    ('HISTO_CPT',V_RL_CP_NUM_RL|| '--' || releve_.pdl_detat,err_code || '--' || err_msg,sysdate,'erreur de confomité de type colonne pour le pdl suivante '||releve_.pdl_ref);
    end;
    commit;
end loop;

 insert into prob_migration (nom_table)values(SYSTIMESTAMP||'   START Miwt_hist_compteur');
  commit;

end;
/

prompt
prompt Creating procedure MIWT_PERSONNE
prompt ================================
prompt
CREATE OR REPLACE PROCEDURE MIWT_PERSONNE(v_district varchar2)
 is
    -- AUteur : BEN MANSOUR ARAB SOFT
    -- Date   : 22/07/2013
    -- Objet  : Chargement de la liste des clients dans la
    --          table MIG_CLIENT

    -- adresse du premier branchement d'un client
    cursor adr_branch(categorie_ varchar2, code_ varchar2) is
      select a.code_postal, a.adresse
        from branchement a
       where a.categorie_actuel = categorie_
         and a.client_actuel = code_
         and a.adresse is not null;
    -- variables de traitement
    v_msg            varchar2(800);
    v_nbr_trsf       number(10) := 0;
    v_nbr_rej        number(10) := 0;
    v_ad_vilrue      number(10);
    v_ad_num         number(10);
    v_categ_client   varchar2(500);
    v_nom            varchar2(500);
    v_code_postal_br varchar2(500);
    v_adr_branch     varchar2(800);
    err_code         varchar2(200);
    err_msg          varchar2(200);
--v_district  varchar2(2);
--v_police    VARCHAR2(5);
--v_tou      VARCHAR2(3);
--v_ord      VARCHAR2(3);
    -- suivi traitement
    --nbr_trt   number := 0;
    NBR_tot   number := 0;
    rindex    pls_integer := -1;
    slno      pls_integer;
    v_op_name varchar2(200);
    v_startdt date;
    v_enddt   date;

  begin
    select sysdate into v_startdt from dual;
    dbms_output.put_line('miwtpersonne start = '||v_startdt);
    execute immediate 'alter session set nls_date_format = ''dd/mm/yyyy''';
    execute immediate 'alter session set NLS_NUMERIC_CHARACTERS = '',.''';
    insert into prob_migration (nom_table)values(SYSTIMESTAMP||'   START MIWT_PERSONNE');
 commit;
    --**************************************************
    -- MAJ SUIVI MIGRATION
   -- mig_progress('MIWTPERSONNE', 'R', 0, 0);
    -- REMISE A ZERO DE LA MIGRATION
    delete from MIWTPERSONNE p where p.mper_source='DIST'||v_district;
   -- delete from MIWTADR;
   -- update client a set a.btrsf = null, a.cmsg = null;
    commit;

    --**************************************************
    -- pour le suivi d'avancement du traitement
    select count(*) into NBR_tot from client;
    v_op_name := to_char(sysdate, 'ddmmyyyyhh24miss');
   -- update work_pfl a set a.op_name = v_op_name where a.bexec = 'O';
    commit;
    dbms_application_info.set_session_longops(RINDEX    => rindex,
                                              SLNO      => slno,
                                              target    => '1',
                                              OP_NAME   => v_op_name,
                                              SOFAR     => 0,
                                              TOTALWORK => NBR_tot);
    --**************************************************

    -- reception de la liste des clients
   -- for client_ in (select * from client) loop
   for client_ in (select * from CLIENT where categorie||code in (select t.categorie||t.code
 from CLIENT t
group by t.categorie||t.code
having count(*) = 1)) loop
  -- v_district:=null;
      begin
/*for adr_bra_ in (select * from brut_sonede1 a where a.adr_anc=client_.adresse and rownum=1) loop
                    v_district:=adr_bra_.district;
                    v_police:=adr_bra_.police;
                    v_tou := adr_bra_.tou;
                    v_ord := adr_bra_.ord;
 mig_ADRESSE_PIVOT.MIG_ADR (v_district, v_police ,v_tou,v_ord ,  V_AD_NUM);
 commit;
end loop;*/
if v_district is NOT null then


        -- insertion de l'adresse
        v_ad_num := null;
        if ltrim(rtrim(client_.adresse)) is not null then
          -- insertion de la ville
          v_ad_vilrue := null;
          v_nom       := null;

    miwtADRESSEPIVOT.MIG_ADR(v_adresse_   => ltrim(rtrim(client_.adresse)),
                            v_ad_vilrue_ => NVL(V_AD_VILRUE,999999999),
                            V_CODE_POSTAL_ =>CLIENT_.CODE_POSTAL,
                            v_district => v_district,
                            v_ad_num_    => v_ad_num);
        else

          v_code_postal_br := null;
          v_adr_branch     := null;
          for adr_ in adr_branch(trim(client_.categorie),
                                 trim(client_.code)) loop
            v_code_postal_br := to_char(trim(adr_.code_postal));
            v_adr_branch     := trim(adr_.adresse);
            exit;
          end loop;

          if v_adr_branch is not null then
            v_ad_num := null;
            -- insertion de la ville
            v_ad_vilrue := null;
            v_nom       := null;

      miwtADRESSEPIVOT.MIG_ADR(v_adresse_   => v_adr_branch,
                                v_ad_vilrue_ => v_ad_vilrue,
                                V_CODE_POSTAL_ =>CLIENT_.CODE_POSTAL,
                                v_district=> v_district,
                                v_ad_num_    => v_ad_num);
          else
            v_ad_num :=0;/* null;
            -- insertion de la ville
            v_ad_vilrue := null;
            v_nom       := null;
            begin
            miwtADRESSEPIVOT.MIG_ADR(v_adresse_   => 'Inconnu' || client_.categorie ||client_.code,
                    v_ad_vilrue_ => NVL(V_AD_VILRUE,999999999),
          V_CODE_POSTAL_ =>CLIENT_.CODE_POSTAL,
                    v_ad_num_    => v_ad_num);*/
             /*exception
          when others then
            err_code := SQLCODE;
            err_msg  := SUBSTR(SQLERRM, 1, 200);
            insert into prob_migration
              (nom_table, val_ref, sql_err, date_pro)
            values
              ('miwt adr',
               client_.categorie ||client_.code,
               err_code || '--' || err_msg,
               sysdate);*/
        --end;
          end if;
        end if;

        end if;
        -- reception du libelle de la categorie du client
        v_categ_client := null;
        for categ_ in (select *
                         from categorie a
                        where ltrim(rtrim(a.code)) =
                              ltrim(rtrim(client_.categorie))) loop
         v_categ_client := ltrim(rtrim(categ_.CODE));
        --v_categ_client := 1;
        end loop;
        -- insertion du client
        v_nom := nvl(ltrim(rtrim(client_.nom)), 'Inconnu');

    IF V_AD_NUM IS NULL THEN V_AD_NUM:=0; END IF;

   begin
    INSERT INTO MIWTPERSONNE
        (
        MPER_SOURCE    ,--1     VARCHAR2(100)  N      CODE SOURCE/ORIGINE DE LA DONNEE
        MPER_REF       ,--2     VARCHAR2(100)  N      IDENTIFIANT UNIQUE DE LA DONNEE POUR LA SOURCE
        MPER_REFE      ,--3     VARCHAR2(100)  Y      REFERENCE DE LA PERSONNE [TA20]
        MPER_NOM       ,--4     VARCHAR2(100)  Y      NOM DE LA PERSONNE [TA30]
        MPER_PRENOM    ,--5     VARCHAR2(100)  Y      PRENOM DE LA PERSONNE [TA38]
        MPER_COMPL_NOM ,--6     VARCHAR2(100)  Y      COMPLEMENT DU NOM [TA38]
        VOC_TITLE      ,--7     VARCHAR2(100)  Y      CLE SOURCE DU TITRE D UNE PERSONNE DANS LA TABLE DES CORRESPONDANCES
        MPER_REF_ADR   ,--8     VARCHAR2(100)  Y      CLE SOURCE DE L ADRESSE DE LA PERSONNE
        MPER_TEL       ,--9     VARCHAR2(15)   Y      NUMERO DE TELEPHONE DE LA PERSONNE
        MPER_TEL_BUREAU,--10    VARCHAR2(15)   Y      NUMERO DE TELEPHONE DU BUREAU DE LA PERSONNE
        MPER_FAX       ,--11    VARCHAR2(15)   Y      NUMERO DE FAX DE LA PERSONNE
        MPER_TEL_MOBIL ,--12    VARCHAR2(15)   Y      TELEPHONE MOBILE (IE PORTABLE) DE LA PERSONNE
        MPER_TEL_MOBIL1,--13    VARCHAR2(15)   Y
        MPER_MAIL      ,--14    VARCHAR2(255)  Y      MAIL DE LA PERSONNE [TA255]
        MPER_MAIL1     ,--15    VARCHAR2(255)  Y
        VOC_TYPSAG      --16    NUMBER(10)     Y      TYPE DE PROFIL (PROFESSIONNELLE, DOMESTIQUE..)
        )
       VALUES
       (
       'DIST'||v_district  ,--1
        v_district||LTRIM(rtrim(client_.categorie))||ltrim(rtrim(upper(client_.code))),--2
        v_district||LTRIM(rtrim(client_.categorie))||ltrim(rtrim(upper(client_.code))),--3
        ltrim(rtrim(v_nom)),--4
        ltrim(rtrim(v_nom)),--5
        NULL               ,--6
        '-'                ,--7
        V_AD_NUM           ,--8
        ltrim(rtrim(client_.tel)),--9
        ltrim(rtrim(client_.autre_tel)),--10
        ltrim(rtrim(client_.fax)),--11
        NULL               ,--12
        NULL               ,--13
        NULL               ,--14
        NULL               ,--15
        decode(lpad(ltrim(rtrim(v_categ_client)),2,'0'),'03','01','05','01','07','01','11','01','12','10','1','01','06','01',lpad(ltrim(rtrim(v_categ_client)),2,'0'))--16
        );
         exception
          when others then
            err_code := SQLCODE;
            err_msg  := SUBSTR(SQLERRM, 1, 200);
            insert into prob_migration
              (nom_table, val_ref, sql_err, date_pro,type_problem)
            values
              ('miwt adr pers',
               client_.categorie ||client_.code||'--'||V_AD_NUM,
               err_code || '--' || err_msg,sysdate,'manque adresse personne');
               commit;
               exit;
        end;
       /* update client t
           set t.btrsf = 'O'
         where t.code = client_.code
           and t.categorie = client_.categorie;*/
        commit;
        v_nbr_trsf := v_nbr_trsf + 1;
    --  exception
      --  when others then
       --   rollback;
          -- en cas d'erreur alors :
          -- suppression de l'adresse
         -- delete from MIWTADR  where ad_num = v_ad_num;
          v_nbr_rej := v_nbr_rej + 1;
          v_msg     := sqlerrm;
         /* update client t
             set t.btrsf = 'R', t.cmsg = v_msg
           where rtrim(t.code) = rtrim(client_.code)
             and rtrim(t.categorie) = rtrim(client_.categorie);*/
          commit;
      end;
    end loop;

    for adm_ in (select * from adm) loop

      miwtADRESSEPIVOT.MIG_ADR(v_adresse_   => adm_.adresse,
                               v_ad_vilrue_ => v_ad_vilrue,
                               V_CODE_POSTAL_ =>adm_.code_postal,
                               v_district=> v_district,
                               v_ad_num_    => v_ad_num);

          IF V_AD_NUM IS NULL THEN V_AD_NUM:=0; END IF;
 begin

    INSERT INTO MIWTPERSONNE
       (
        MPER_SOURCE   ,--1  VARCHAR2(100)  N     CODE SOURCE/ORIGINE DE LA DONNEE
        MPER_REF      ,--2  VARCHAR2(100)  N     IDENTIFIANT UNIQUE DE LA DONNEE POUR LA SOURCE
        MPER_REFE     ,--3  VARCHAR2(100)  Y     REFERENCE DE LA PERSONNE [TA20]
        MPER_NOM      ,--4  VARCHAR2(100)  Y     NOM DE LA PERSONNE [TA30]
        MPER_PRENOM   ,--5  VARCHAR2(100)  Y     PRENOM DE LA PERSONNE [TA38]
        MPER_COMPL_NOM,--6  VARCHAR2(100)  Y     COMPLEMENT DU NOM [TA38]
        VOC_TITLE     ,--7  VARCHAR2(100)  Y     CLE SOURCE DU TITRE D UNE PERSONNE DANS LA TABLE DES CORRESPONDANCES
        MPER_REF_ADR  ,--8  VARCHAR2(100)  Y     CLE SOURCE DE L ADRESSE DE LA PERSONNE
        MPER_TEL      ,--9  VARCHAR2(15)   Y     NUMERO DE TELEPHONE DE LA PERSONNE
        MPER_TEL_BUREAU,--10VARCHAR2(15)   Y     NUMERO DE TELEPHONE DU BUREAU DE LA PERSONNE
        MPER_FAX      ,--11 VARCHAR2(15)   Y     NUMERO DE FAX DE LA PERSONNE
        MPER_TEL_MOBIL,--12 VARCHAR2(15)   Y     TELEPHONE MOBILE (IE PORTABLE) DE LA PERSONNE
        MPER_TEL_MOBIL1,--13VARCHAR2(15)   Y
        MPER_MAIL     ,--14 VARCHAR2(255)  Y      MAIL DE LA PERSONNE [TA255]
        MPER_MAIL1    ,--15 VARCHAR2(255)  Y
        VOC_TYPSAG     --16 NUMBER(10)     Y      TYPE DE PROFIL (PROFESSIONNELLE, DOMESTIQUE..)
       )
       VALUES
       (
        'DIST'||v_district       ,--1           VARCHAR2(100)  N      CODE SOURCE/ORIGINE DE LA DONNEE
        lpad(ltrim(rtrim(adm_.code)),6,'0'),--2 VARCHAR2(100)  N      IDENTIFIANT UNIQUE DE LA DONNEE POUR LA SOURCE
        lpad(ltrim(rtrim(adm_.code)),6,'0'),--3 VARCHAR2(100)  Y      REFERENCE DE LA PERSONNE [TA20]
        LTRIM(RTRIM(adm_.desig)),--4            VARCHAR2(100)  Y      NOM DE LA PERSONNE [TA30]
        LTRIM(RTRIM(adm_.desig)),--5            VARCHAR2(100)  Y      PRENOM DE LA PERSONNE [TA38]
        NULL                    ,--6            VARCHAR2(100)  Y      COMPLEMENT DU NOM [TA38]
        '-'                     ,--7            VARCHAR2(100)  Y      CLE SOURCE DU TITRE D UNE PERSONNE DANS LA TABLE DES CORRESPONDANCES
        V_AD_NUM                ,--8            VARCHAR2(100)  Y      CLE SOURCE DE L ADRESSE DE LA PERSONNE
        null                    ,--9            VARCHAR2(15)   Y      NUMERO DE TELEPHONE DE LA PERSONNE
        null                    ,--10           VARCHAR2(15)   Y      NUMERO DE TELEPHONE DU BUREAU DE LA PERSONNE
        null                    ,--11           VARCHAR2(15)   Y      NUMERO DE FAX DE LA PERSONNE
        NULL                    ,--12           VARCHAR2(15)   Y      TELEPHONE MOBILE (IE PORTABLE) DE LA PERSONNE
        NULL                    ,--13           VARCHAR2(15)   Y
        NULL                    ,--14           VARCHAR2(255)  Y      MAIL DE LA PERSONNE [TA255]
        NULL                    ,--15           VARCHAR2(255)  Y
        lpad(ltrim(rtrim(v_categ_client)),2,'0')--16 NUMBER(10)Y      TYPE DE PROFIL (PROFESSIONNELLE, DOMESTIQUE..)
        );
        exception
          when others then
            err_code := SQLCODE;
            err_msg  := SUBSTR(SQLERRM, 1, 200);
            insert into prob_migration
              (nom_table, val_ref, sql_err, date_pro,type_problem)
            values
              ('ADM',
               adm_.code,
               err_code || '--' || err_msg,sysdate,'desingantion null dans la table adm');

  end;
      end loop;
select sysdate into v_enddt from dual;
    dbms_output.put_line('miwtpersonne start = '||v_enddt);
    insert into prob_migration (nom_table)values(SYSTIMESTAMP||'   END MIWT_PERSONNE');
 commit;

    --**********************************
    -- MAJ SUIVI MIGRATION
   -- mig_progress('MIG_CLIENT', 'M', v_nbr_trsf, v_nbr_rej);
    --**********************************
  end;
/

prompt
prompt Creating procedure MIWT_RELEVE
prompt ==============================
prompt
create or replace procedure miwt_RELEVE (v_district in varchar2) is

  v_NTIERS        number;
  v_NSIXIEME      number;
  V_COUNT_BR      number;
  v_MREL_DEDUITE  number;
  v_ref_releve_   number;
  V_DTE_RELEVE    date;
  err_code        varchar2(200);
  err_msg         varchar2(200);
  v_msg           varchar2(800);
  v_nbr_trsf      number(10):= 0;
  v_nbr_rej       number(10):= 0;
  V_RL_CP_NUM_BR  varchar2(60);
  V_RL_CP_NUM_RL  varchar2(60);
  V_RL_BR_NUM     varchar2(60);
  V_DTE_RL        varchar2(60);
  V_DTE_TIME_RL   varchar2(60);
  V_CODE_ANOMALIE varchar2(20);
  V_TYPE_ANOMALIE varchar2(10);
  V_DESIG_ANOM    varchar2(200);
  V_TYPE_ANOM     varchar2(10);
  V_RL_CODE1      varchar2(20);
  V_RL_LECIMP     varchar2(20);
  v_avisforte     varchar2(50);
  v_code_marque   varchar2(50);
  v_compteur_actuel varchar2(50);
  V_CODE_SI_ANOMALIE varchar2(20);
  -- suivi traitement
begin

execute immediate 'alter session set nls_date_format = ''dd/mm/yyyy''';
execute immediate 'alter session set NLS_NUMERIC_CHARACTERS = '',.''';
    --**************************************************
  delete MIWTRELEVE where MREL_SOURCE='DIST'||v_district;
  delete  prob_migration where nom_table in ('miwtreleve','miwtreleve11');
 insert into prob_migration (nom_table)values(SYSTIMESTAMP||'   START miwt_releve');
   commit;


   v_ref_releve_ := 0;
select nvl(max(to_number(MREL_REF)),0) into v_ref_releve_  from miwtreleve;

  for releve_ in (select district ,tourne ,ordre,annee,trim,releve,prorata,constrim4,marche,releve2,releve3,releve4,releve5,date_releve,
                          compteurt,consommation,lpad(ltrim(rtrim(anomalie)),18,0) anomalie,saisie,avisforte,message_temporaire,compteurchange,
                          n_tsp,matricule_releveur,date_controle,matricule_controle,index_controle,nbre_roues,derniere_releve,usage,
                          tarif,diamctr,cctr,codemarque,ncompteur,ancien_releve
                   from fiche_releve a
                   where trim(a.district) = v_district
                   and ltrim(rtrim(trim)) is not null
                   and ltrim(rtrim(a.annee))>=2015
                   ------- sans tenir en compte le donner de relevet------
                   and  to_number(trim(a.annee) || trim(a.trim)) <>
                                                (select max(to_number(trim(v.annee) || trim(v.trim)))
                                                 from fiche_releve v
                                                  where trim(v.tourne) = trim(a.tourne)
                                                  and trim(v.ordre) = trim(a.ordre))

                 ) loop

    V_RL_CP_NUM_BR  := NULL;
    V_RL_CP_NUM_RL  := NULL;
    V_RL_BR_NUM     := NULL;
    V_DTE_RL        := NULL;
    V_DTE_TIME_RL   := NULL;
    V_DTE_RELEVE    := NULL;
    V_CODE_ANOMALIE := NULL;
    V_TYPE_ANOMALIE := NULL;
    V_DESIG_ANOM    := NULL;
    V_TYPE_ANOM     := NULL;
    V_RL_CODE1      := NULL;
    V_RL_LECIMP     := NULL;
    V_COUNT_BR      := 0;

    begin

      -- reception du branchement associe
      for bra_ in (select *
                     from branchement a
                    where trim(a.district) = trim(releve_.district)
                      and lpad(trim(a.tourne),3,'0') = lpad(trim(releve_.tourne),3,'0')
                      and lpad(trim(a.ordre),3,'0') = lpad(trim(releve_.ordre),3,'0')

                      ) loop
        -- numero compteur (branchement)
        -- reception code point instalation PDI
        V_RL_BR_NUM := lpad(bra_.district, 2, '0') ||
                       lpad(trim(bra_.tourne), 3, '0') ||
                       lpad(trim(bra_.ordre), 3, '0') ||
                       lpad(to_char(trim(bra_.police)), 5, '0');
        V_COUNT_BR  := V_COUNT_BR + 1;
      end loop;

-------------------------------------------------------
--------------------------- RECHERCHE COMPTEUR

               begin
                  select   substr(p.mhpc_refcom,6,length(p.mhpc_refcom)), substr(p.mhpc_refcom,3,3)
                    into v_compteur_actuel,v_code_marque
                    from miwthistocpt p
                   where substr(p.mhpc_refpdl,1,8)=trim(releve_.district)||trim(releve_.tourne)||trim(releve_.ordre);

                   exception when others then
                    v_compteur_actuel:=null;
                    v_code_marque:=null;
                 end;


   V_RL_CP_NUM_RL := v_district||v_code_marque||v_compteur_actuel ;
 --------------------------------------------------------------

      V_DTE_RL     := substr(releve_.date_releve,
                             1,
                             instr(replace(replace(releve_.date_releve,
                                                   ' ',
                                                   '#'),
                                           ':',
                                           '#'),
                                   '#') - 1);
      V_DTE_RL     := replace(V_DTE_RL, '-', '/');
      
--      test date
------------------------------------------------------------------------------
  BEGIN
    select to_date(lpad(t.dateexp,8,'0'),'dd/mm/yyyy')- 7 into V_DTE_RELEVE from ROLE_TRIM t
    where lpad(LTRIM(RTRIM(t.distr)),2,'0') = trim(releve_.district)
    and   LTRIM(RTRIM(t.annee)) = trim(releve_.annee)
    and   LTRIM(RTRIM(t.trim)) =trim(releve_.trim)
    and   lpad(LTRIM(RTRIM(t.tour)),3,'0')= lpad(trim(releve_.tourne),3,'0')
    and   lpad(LTRIM(RTRIM(t.ordr)),3,'0')= lpad(trim(releve_.ordre),3,'0');

  EXCEPTION WHEN OTHERS THEN
      begin
      select to_date(lpad(t.dateexp,8,'0'),'dd/mm/yyyy')- 7 into V_DTE_RELEVE from ROLE_MENS t
    where lpad(LTRIM(RTRIM(t.distr)),2,'0') = trim(releve_.district)
    and   LTRIM(RTRIM(t.annee)) = trim(releve_.annee)
    and   LTRIM(RTRIM(t.mois)) =trim(releve_.trim)
    and   lpad(LTRIM(RTRIM(t.tour)),3,'0')= lpad(trim(releve_.tourne),3,'0')
    and   lpad(LTRIM(RTRIM(t.ordr)),3,'0')= lpad(trim(releve_.ordre),3,'0');
    exception when others then
         if substr(releve_.annee,3,2) != to_char(to_date(substr(releve_.date_releve,1,10),'dd/mm/yyyy hh24:mi:ss'),'YY')
          and releve_.trim in (1,2,3) then

            select t.ntiers, t.NSIXIEME
            into v_NTIERS,v_NSIXIEME
            from tourne t
            where t.code= releve_.tourne;

                    if v_NSIXIEME=1 THEN

                          IF releve_.TRIM=1 THEN
                             V_DTE_RELEVE:=to_date('08/0'||to_char(v_NTIERS)||'/'||releve_.annee,'dd/mm/yyyy');
                          ELSIF releve_.TRIM = 2 THEN
                                V_DTE_RELEVE:=to_date('08/0'||to_char(3+v_NTIERS)||'/'||releve_.annee,'dd/mm/yyyy');
                          ELSIF releve_.TRIM = 3 THEN
                                V_DTE_RELEVE:=to_date('08/0'||to_char(6+v_NTIERS)||'/'||releve_.annee,'dd/mm/yyyy');
                          ELSIF releve_.TRIM = 4 THEN
                                V_DTE_RELEVE:=to_date('08/'||to_char(9+v_NTIERS)||'/'||releve_.annee,'dd/mm/yyyy');
                          end if;
                    else
                          IF releve_.TRIM=1 THEN
                                V_DTE_RELEVE:=to_date('15/0'||to_char(v_NTIERS)||'/'||releve_.annee,'dd/mm/yyyy');
                          ELSIF releve_.TRIM = 2 THEN
                                V_DTE_RELEVE:=to_date('15/0'||to_char(3+v_NTIERS)||'/'||releve_.annee,'dd/mm/yyyy');
                          ELSIF releve_.TRIM = 3 THEN
                                V_DTE_RELEVE:=to_date('15/0'||to_char(6+v_NTIERS)||'/'||releve_.annee,'dd/mm/yyyy');
                          ELSIF releve_.TRIM = 4 THEN
                                V_DTE_RELEVE:=to_date('15/'||to_char(9+v_NTIERS)||'/'||releve_.annee,'dd/mm/yyyy');
                          end if;
                    end if;
                    else 
                      V_DTE_RELEVE := to_date(V_DTE_RL, 'dd/mm/yy');
           end if;

      END;
 END;


    if ltrim(rtrim(releve_.DATE_CONTROLE)) is null and (ltrim(rtrim(releve_.INDEX_CONTROLE)) is null or ltrim(rtrim(releve_.INDEX_CONTROLE))=0) then

     V_RL_LECIMP:='TOURNEE';

      ELSE
     V_RL_LECIMP:='CONTROLE';

      end if;

        v_ref_releve_ := v_ref_releve_ + 1;

        v_MREL_DEDUITE:=0;

        if to_number(releve_.prorata)>0 then
        v_MREL_DEDUITE:=nvl(to_number(trim(releve_.consommation)),0)-releve_.prorata;
        end if;
        
      begin
         if to_number(ltrim(rtrim(releve_.avisforte)))>0 then
          v_avisforte:='N°Avis Forte='||releve_.avisforte;
          end if;
      exception when others then 
       v_avisforte:=null;
      end  ;

        begin
          insert into Miwtreleve 
            (
             MREL_SOURCE   ,--1  Identifiant de la source de donnees [OBL]
             MREL_REF      ,--2  Reference de la releve dans le SI source (le couple source/reference releve doit etre UNIQUE) [OBL]
             MREL_REFPDL   ,--3  Reference du PDl dans le SI source
             MREL_REFCOM   ,--4  Reference du compteur dans le SI source
             MREL_DATE     ,--5  Date de la releve [OBL]
             MREL_INDEX1   ,--6  Index
             MREL_CONSO1   ,--7
             MREL_CADRAN1  ,--8
             MREL_CADRAN2  ,--9
             MREL_CADRAN3  ,--10
             MREL_CADRAN4  ,--11
             MREL_CADRAN5  ,--12
             MREL_CADRAN6  ,--13
             VOC_READORIG  ,--14    RL_ORIG
             VOC_READREASON,--15    RL_TYPLEC
             MREL_ETATFACT ,--16
             MREL_FACTUREE ,--17
             MREL_AGESOURCE,--18
             MREL_AGEREF   ,--19
             annee         ,--20
             periode       ,--21
             mrel_agrtype  ,--22
             mrel_techtype ,--23
             voc_comm1     ,--24
             VOC_READCODE  ,--25
             MREL_CONSO_REF1,--26
             mrel_ano_c1   ,--27
             mrel_ano_c2   ,--28
             mrel_ano_c3   ,--29
             mrel_ano_n1   ,--30
             mrel_ano_n2   ,--31
             mrel_ano_n3   ,--32
             mrel_ano_f1   ,--33
             mrel_ano_f2   ,--34
             mrel_ano_f3   ,--35
             MREL_DEDUITE  ,--36
             MREL_INDEX2   ,--37
             MREL_INDEX3   ,--38
             MREL_INDEX4   ,--39
             MREL_INDEX5   ,--40
             MREL_INDEX6   ,--41
             mrel_comlibre  --42
             )
          values
            (
             'DIST'||v_district,--1
             v_ref_releve_     ,--2
             V_RL_BR_NUM       ,--3
             V_RL_CP_NUM_RL    ,--4
             V_DTE_RELEVE      ,--5
             to_number(releve_.releve),--6
             nvl(to_number(trim(releve_.consommation)),0),--7
             'EAU'             ,--8
             'TENT1'           ,--9
             'TENT2'           ,--10
             'TENT3'           ,--11
             'TENT4'           ,--12
             'CPTTOU'          ,--13
             '03'              ,--14
             V_RL_LECIMP       ,--15
             0                 ,--16
             1                 ,--17
             releve_.MATRICULE_RELEVEUR,--18
             releve_.MATRICULE_RELEVEUR,--19
             to_number(releve_.annee),--20
             to_number(releve_.trim),--21
             0                 ,--22
             0                 ,--23
             V_CODE_ANOMALIE   ,--24
             V_CODE_SI_ANOMALIE,--25
             0                 ,--26
             substr(releve_.anomalie,1,2),--27
             substr(releve_.anomalie,3,2),--28
             substr(releve_.anomalie,5,2),--29
             substr(releve_.anomalie,7,2),--30
             substr(releve_.anomalie,9,2),--31
             substr(releve_.anomalie,11,2),--32
             substr(releve_.anomalie,13,2),--33
             substr(releve_.anomalie,15,2),--34
             substr(releve_.anomalie,17,2),--35
             v_MREL_DEDUITE               ,--36
             to_number(replace(releve_.releve2,'.',null)),--37
             to_number(replace(releve_.releve3,'.',null)),--38
             to_number(replace(releve_.releve4,'.',null)),--39
             to_number(replace(releve_.releve5,'.',null)),--40
             nvl(to_number(decode(ltrim(rtrim(releve_.compteurt)),'T','1','1','1','0')),0),--41
             ltrim(rtrim(releve_.message_temporaire))||v_avisforte--42
            );
        exception
          when others then
            err_code := SQLCODE;
            err_msg  := SUBSTR(SQLERRM, 1, 200);
            insert into prob_migration
              (nom_table, val_ref, sql_err, date_pro,type_problem)
            values
              ('miwtreleve',
              V_RL_BR_NUM||'--'||to_number(releve_.annee)||to_number(releve_.trim),
               err_code || '--' || err_msg,sysdate,'erreur de manque de date releve pour le pdl suivante'||V_RL_BR_NUM);
        end;
      v_nbr_trsf := v_nbr_trsf + 1;
    exception
          when others then
            err_code := SQLCODE;
            err_msg  := SUBSTR(SQLERRM, 1, 200);
            insert into prob_migration
              (nom_table, val_ref, sql_err, date_pro,type_problem)
            values
              ('miwtreleve11',
               V_RL_BR_NUM||'-'||releve_.date_releve,
               err_code || '--' || err_msg,sysdate,'erreur de confomité de type colonne pour le pdl suivante'||V_RL_BR_NUM);
        v_nbr_rej := v_nbr_rej + 1;
        v_msg := sqlerrm;
    end;
    COMMIT;
  end loop;
insert into prob_migration (nom_table)values(SYSTIMESTAMP||'   END miwt_releve');
   commit;

end;
/

prompt
prompt Creating procedure MIWT_RELEVE_GC
prompt =================================
prompt
create or replace procedure miwt_RELEVE_GC (v_district in varchar2) is

     --v_NTIERS number;
--v_NSIXIEME number;
  err_code        varchar2(200);
  err_msg         varchar2(200);
  v_msg           varchar2(800);
  v_nbr_trsf      number(10) := 0;
  v_annee         number;
  v_nbr_rej       number(10) := 0;
  V_RL_CP_NUM_BR  varchar2(60);
  V_RL_CP_NUM_RL  varchar2(60);
  V_RL_BR_NUM     varchar2(60);
  V_DTE_RL        varchar2(60);
  V_DTE_TIME_RL   varchar2(60);
  V_CODE_SI_ANOMALIE varchar2(20);
  V_CODE_ANOMALIE varchar2(20);
  V_TYPE_ANOMALIE varchar2(10);
  V_DESIG_ANOM    varchar2(200);
  V_TYPE_ANOM     varchar2(10);
  V_RL_CODE1      varchar2(20);
  V_RL_LECIMP     varchar2(20);
  V_COUNT_BR      number;
  v_MREL_DEDUITE  number;
  v_ref_releve    number;
  V_DTE_RELEVE    date;

  -- suivi traitement

begin

  execute immediate 'alter session set nls_date_format = ''dd/mm/yyyy''';
  execute immediate 'alter session set NLS_NUMERIC_CHARACTERS = '',.''';
    --**************************************************
   delete MIWTRELEVE_GC where MREL_SOURCE='DIST'||v_district;
   delete  prob_migration where nom_table in ('miwtreleve_GC','miwtreleve11_GC','miwtrelevegc_ref_cpt');
   insert into prob_migration (nom_table) values(SYSTIMESTAMP||'   START miwt_releve_gc');

   commit;

   v_ref_releve := 0;

   ------------------------
    select nvl(max(to_number(MREL_REF)), 0)
    into v_ref_releve
    from miwtreleve_gc_1;
   ----------------------

  for releve_ in ( select a.*
                   from  relevegc a
                   where  trim(a.district) = v_district
                   and trim(a.mois) is not null
                   ---and trim(a.annee)>='2014'
                  ) loop

    V_RL_CP_NUM_BR  := NULL;
    V_RL_CP_NUM_RL  := NULL;
    V_RL_BR_NUM     := NULL;
    V_DTE_RL        := NULL;
    V_DTE_TIME_RL   := NULL;
    V_DTE_RELEVE    := NULL;
    V_CODE_ANOMALIE := NULL;
    V_TYPE_ANOMALIE := NULL;
    V_DESIG_ANOM    := NULL;
    V_TYPE_ANOM     := NULL;
    V_RL_CODE1      := NULL;
    V_RL_LECIMP     := NULL;
    V_COUNT_BR      := 0;

    begin

      -- reception du branchement associe
      for bra_ in (select *
                    from branchement b
                    where b.district = trim(releve_.district)
                     --and lpad(trim(releve_.police),5,'0')=lpad(trim(b.police),5,'0')
                     and lpad(trim(releve_.tourne),3,'0')=lpad(trim(b.tourne),3,'0')
                     and lpad(trim(releve_.ordre),3,'0')=lpad(trim(b.ordre),3,'0')
                      ) loop
        -- numero compteur (branchement)
        -- reception code point instalation PDI
        V_RL_BR_NUM := lpad(trim(bra_.district),2, '0') ||
                       lpad(trim(bra_.tourne),3, '0') ||
                       lpad(trim(bra_.ordre),3, '0') ||
                       lpad(to_char(trim(bra_.police)),5,'0');
        V_COUNT_BR  := V_COUNT_BR + 1;
      end loop;

      -- verfication si le compteur existe deja au niveau de la table des compteurs
-------------------------------------------------------
------------------------------------------------------- RECHERCHE COMPTEUR
   begin

     select distinct  p.mhpc_refcom
      into V_RL_CP_NUM_RL
      from miwthistocpt p
     where  substr(p.mhpc_refpdl,1,8)
     =trim(releve_.district)||
     lpad(trim(releve_.tourne),3,'0')||
     lpad(trim(releve_.ordre),3,'0');--||lpad(trim(releve_.police),5,'0') ;
       exception when others then

       begin
             select distinct  p.mhpc_refcom
             into V_RL_CP_NUM_RL
             from miwthistocpt p
             where  p.mhpc_refpdl=trim(releve_.district)||
             lpad(trim(releve_.tourne),3,'0')||
             lpad(trim(releve_.ordre),3,'0')||lpad(trim(releve_.police),5,'0');

              exception when others then

                  err_code := SQLCODE;
                  err_msg  := SUBSTR(SQLERRM, 1, 200);
                  insert into prob_migration
                    (nom_table, val_ref, sql_err, date_pro,type_problem)
                  values
                    ('miwtrelevegc_ref_cpt',
                     releve_.tourne || '--' || releve_.ordre,
                     err_code || '--' || err_msg,sysdate,'problem recuperation compteur pour le pdl '||trim(releve_.district)||trim(releve_.tourne)||trim(releve_.ordre));
                     continue;
                     end;
        end;

-----------------------------------------------------
------------------------------------------------------
/* begin
  select to_date(lpad(trim(r.dateexp), 8, '0'), 'dd/mm/yyyy')-7
  into V_DTE_RELEVE
  from ROLE_MENS r
 where lpad(LTRIM(RTRIM(r.distr)), 2, '0') = releve_.district
   and LTRIM(RTRIM(r.annee)) =trim(releve_.annee)
   and LTRIM(RTRIM(r.mois)) = trim(releve_.mois)
   and lpad(LTRIM(RTRIM(r.tour)), 3, '0') = lpad(LTRIM(RTRIM(releve_.tourne)), 3, '0')
   and lpad(LTRIM(RTRIM(r.ordr)), 3, '0') = lpad(LTRIM(RTRIM(releve_.ordre)), 3, '0');

END;
*/
------------------------------------------------------

if ltrim(rtrim(releve_.indexr)) is null then
  for com_lectimp_ in (select *
                            from listeanomalies_releve a
                            where trim(a.DISTRICT) = trim(releve_.district)
                              and lpad(trim(a.TOURNE),3,'0')= lpad(trim(releve_.tourne),3,'0')
                              and lpad(trim(a.ORDRE),3,'0')= lpad(trim(releve_.ordre),3,'0')
                              and a.ANNEE = trim(releve_.annee)
                              and a.TRIM =  trim(releve_.mois)) loop
        V_CODE_SI_ANOMALIE := ltrim(rtrim(com_lectimp_.code_anomalie));
        V_TYPE_ANOMALIE := ltrim(rtrim(com_lectimp_.type_anomalie));
end loop ;
  else
    for com_lectimp_ in (select *
                         from listeanomalies_releve a
                         where trim(a.DISTRICT) = trim(releve_.district)
                              and lpad(trim(a.TOURNE),3,'0') =lpad(trim(releve_.tourne),3,'0')
                              and lpad(trim(a.ORDRE),3,'0') = lpad(trim(releve_.ordre),3,'0')
                              and a.ANNEE = trim(releve_.annee)
                              and a.TRIM =  trim(releve_.mois)) loop
        V_CODE_ANOMALIE := ltrim(rtrim(com_lectimp_.code_anomalie));
        V_TYPE_ANOMALIE := ltrim(rtrim(com_lectimp_.type_anomalie));
      end loop;
    end if;

      for com_lectimp_ in (select *
                             from listeanomalies_releve a
                            where trim(a.DISTRICT) = trim(releve_.district)
                              and lpad(trim(a.TOURNE),3,'0') =lpad(trim(releve_.tourne),3,'0')
                              and lpad(trim(a.ORDRE),3,'0') = lpad(trim(releve_.ordre),3,'0')
                              and a.ANNEE = trim(releve_.annee)
                              and a.TRIM = trim(releve_.mois)) loop
        V_CODE_ANOMALIE := ltrim(rtrim(com_lectimp_.code_anomalie));
        V_TYPE_ANOMALIE := ltrim(rtrim(com_lectimp_.type_anomalie));
      end loop;
      -- reception du libelle du commentaire
      for anom_rel_ in (select *
                        from ANOMALIES_RELEVE a
                        where ltrim(rtrim(a.code)) = V_CODE_ANOMALIE
                        and ltrim(rtrim(a.typea)) = V_TYPE_ANOMALIE
                           ) loop
        V_DESIG_ANOM := anom_rel_.desig;
        V_TYPE_ANOM  := anom_rel_.typea;

      end loop;

      if V_TYPE_ANOM = 'C' then
        for MIG_COMREL_ in (select *
                              from miwtvocable a
                             where a.mvoc_libe = V_DESIG_ANOM
                               and a.mvoc_type = 'COMM') loop
          V_RL_CODE1 := MIG_COMREL_.MVOC_REF;
        end loop;
      end if;

      if V_TYPE_ANOM = 'L' then
        for MIG_LECIMP_ in (select *
                              from miwtvocable a
                             where a.mvoc_libe = V_DESIG_ANOM
                               and a.mvoc_type = 'READCODE') loop
          V_RL_LECIMP := MIG_LECIMP_.MVOC_REF;
        end loop;
      end if;
    /*if ltrim(rtrim(releve_.DATE_CONTROLE)) is null and ltrim(rtrim(releve_.INDEX_CONTROLE)) is null then
      V_RL_LECIMP:='TOURNEE';
      ELSE
        V_RL_LECIMP:='CONTROLE';
        end if;*/

        v_ref_releve := v_ref_releve + 1;
        v_MREL_DEDUITE := 0;

      if to_number(releve_.prorata) > 0 then
        v_MREL_DEDUITE := nvl(to_number(trim(releve_.consommation)), 0)-releve_.prorata;
      end if;
  if to_number(trim(releve_.annee))='0' then
    v_annee:=2017;
    else
      v_annee:=to_number(trim(releve_.annee));
      end if;


        begin
          insert into miwtreleve_gc
            (
             MREL_SOURCE    , --1  Identifiant de la source de donnees [OBL]
             MREL_REF       , --2  Reference de la releve dans le SI source (le couple source/reference releve doit etre UNIQUE) [OBL]
             MREL_REFPDL    , --3  Reference du PDl dans le SI source
             MREL_REFCOM    , --4  Reference du compteur dans le SI source
             MREL_DATE      , -- 5 Date de la releve [OBL]
             MREL_INDEX1    , --6  Index
             MREL_CONSO1    , --7
             MREL_CADRAN1   , --8
             VOC_READORIG   , --9  R L_ORIG
             VOC_READREASON ,--10  RL_TYPLEC
             MREL_ETATFACT  ,--11
             MREL_FACTUREE  ,--12
             MREL_AGESOURCE ,--13
             MREL_AGEREF    ,--14
             annee          ,--15
             periode        ,--16
             mrel_agrtype   ,--17
             mrel_techtype  ,--18
             voc_comm1      ,--19
             VOC_READCODE   ,--20
             MREL_CONSO_REF1,--21
             mrel_fact1     ,--22
             MREL_DEDUITE    --23
             )
          values
            (
            'DIST'||v_district,--1
             v_ref_releve      ,--2
             V_RL_BR_NUM       ,--3
             V_RL_CP_NUM_RL    ,--4
             releve_.date_releve,--5
             to_number(releve_.indexr),--6
             nvl(to_number(trim(releve_.consommation)),0),--7
             'EAU'              , --8
             '03'               ,--9
             'TOURNEE'          ,--10
             0                  ,--11
             1                  ,--12
             releve_.etat       ,--13
             releve_.etat       ,--14
             to_number(trim(releve_.annee)),--15
             to_number(releve_.mois),--16
             0                  ,--17
             0                  ,--18
             V_CODE_ANOMALIE    ,--19
             V_CODE_SI_ANOMALIE ,--20
             0                  ,--21
             ltrim(rtrim(releve_.district)) ||
                                lpad(ltrim(rtrim(releve_.tourne)), 3, '0') ||
                                lpad(ltrim(rtrim(releve_.ordre)), 3, '0') || '20' ||
                                trim(releve_.annee) || lpad(trim(releve_.mois),2,'0') || '0',--22
            v_MREL_DEDUITE       --23
            );

        exception
          when others then
            err_code := SQLCODE;
            err_msg  := SUBSTR(SQLERRM, 1, 200);
            insert into prob_migration
              (nom_table, val_ref, sql_err, date_pro,type_problem)
            values
              ('miwtreleve_GC',V_RL_BR_NUM,err_code || '--' || err_msg,sysdate,'erreur de manque de date  pour le pdl suivante'||trim(releve_.district)||trim(releve_.tourne)||trim(releve_.ordre));
        end;

      v_nbr_trsf := v_nbr_trsf + 1;
    exception
          when others then
            err_code := SQLCODE;
            err_msg  := SUBSTR(SQLERRM, 1, 200);
            insert into prob_migration
              (nom_table, val_ref, sql_err,date_pro,type_problem)
            values
              ('miwtreleve11_GC', V_RL_BR_NUM||'-'||1,err_code || '--' || err_msg,sysdate,'erreur de confomité de type colonne pour le pdl suivante'||trim(releve_.district)||trim(releve_.tourne)||trim(releve_.ordre));

        v_nbr_rej := v_nbr_rej + 1;
        v_msg     := sqlerrm;

    end;
    COMMIT;
  end loop;

  insert into prob_migration (nom_table) values(SYSTIMESTAMP||'   END miwt_releve_gc');

   commit;
end;
/

prompt
prompt Creating procedure MIWT_RELEVE_GC_FACTURE
prompt =========================================
prompt
create or replace procedure miwt_RELEVE_GC_facture (v_district in varchar2) is

     --v_NTIERS number;
--v_NSIXIEME number;
  err_code        varchar2(200);
  err_msg         varchar2(200);
  v_ref_releve    number;
  v_annee         number;
  v_msg           varchar2(800);
  v_nbr_trsf      number(10) := 0;
  v_nbr_rej       number(10) := 0;
  V_RL_CP_NUM_BR  varchar2(60);
  V_RL_CP_NUM_RL  varchar2(60);
  V_RL_BR_NUM     varchar2(60);
  V_DTE_RL        varchar2(60);
  V_DTE_TIME_RL   varchar2(60);
  V_DTE_RELEVE    date;
  V_CODE_ANOMALIE varchar2(20);
  V_TYPE_ANOMALIE varchar2(10);
  V_DESIG_ANOM    varchar2(200);
  V_TYPE_ANOM     varchar2(10);
  V_RL_CODE1      varchar2(20);
  V_RL_LECIMP     varchar2(20);
  V_COUNT_BR      number;
  V_CODE_SI_ANOMALIE varchar2(20);
  -- suivi traitement

begin

execute immediate 'alter session set nls_date_format = ''dd/mm/yyyy''';
execute immediate 'alter session set NLS_NUMERIC_CHARACTERS = '',.''';
    --**************************************************
  delete MIWTRELEVE_GC_1 where MREL_SOURCE='DIST'||v_district;
  delete  prob_migration where nom_table in ('miwtreleve_GC_1','miwtreleve11_GC_1','miwtrelevegc_fact_cpt');
  insert into prob_migration (nom_table)values(SYSTIMESTAMP||'   START miwt_releve_gc_facture');
  commit;
   v_ref_releve := 0;
------------------------
 select nvl(max(to_number(MREL_REF)), 0)
    into v_ref_releve
    from miwtrelevet;
------------------------


  for releve_ in ( select distinct  a.nindex,
                                    a.prorata,
                                    a.cons,
                                    a.refc02,
                                    a.refc01,
                                    a.dist,
                                    a.tou,
                                    a.ord,
                                    a.pol,
                                    b.district,
                                    b.tourne,
                                    b.ordre
                     from  facture_as400gc a, branchement b
                    where trim(b.district) = trim(a.dist)
                     and lpad(trim(a.pol),5,'0')=lpad(trim(b.police),5,'0')
                     and lpad(trim(a.tou),3,'0')=lpad(trim(b.tourne),3,'0')
                     and lpad(trim(a.ord),3,'0')=lpad(trim(b.ordre),3,'0')
                     and trim(a.dist) = v_district
                     /*and (select count(*)
                     from branchement v
                     where lpad(trim(b.police),5,'0')=lpad(trim(v.police),5,'0')
                     and lpad(trim(b.tourne),3,'0')=lpad(trim(v.tourne),3,'0')
                     and lpad(trim(b.ordre),3,'0')=lpad(trim(v.ordre),3,'0'))=1*/

                 ) loop

    V_RL_CP_NUM_BR  := NULL;
    V_RL_CP_NUM_RL  := NULL;
    V_RL_BR_NUM     := NULL;
    V_DTE_RL        := NULL;
    V_DTE_TIME_RL   := NULL;
    V_DTE_RELEVE    := NULL;
    V_CODE_ANOMALIE := NULL;
    V_TYPE_ANOMALIE := NULL;
    V_DESIG_ANOM    := NULL;
    V_TYPE_ANOM     := NULL;
    V_RL_CODE1      := NULL;
    V_RL_LECIMP     := NULL;
    V_COUNT_BR      := 0;

    begin

      -- reception du branchement associe
      for bra_ in (select *
                     from branchement b
                    where b.district = releve_.dist
                     and lpad(trim(releve_.pol),5,'0')=lpad(trim(b.police),5,'0')
                     and lpad(trim(releve_.tou),3,'0')=lpad(trim(b.tourne),3,'0')
                     and lpad(trim(releve_.ord),3,'0')=lpad(trim(b.ordre),3,'0')
                   ) loop
        -- numero compteur (branchement)
        -- reception code point instalation PDI
        V_RL_BR_NUM := lpad(trim(bra_.district), 2, '0') ||
                       lpad(trim(bra_.tourne), 3, '0') ||
                       lpad(trim(bra_.ordre), 3, '0') ||
                       lpad(to_char(trim(bra_.police)), 5, '0');
        V_COUNT_BR  := V_COUNT_BR + 1;
      end loop;

      -- verfication si le compteur existe deja au niveau de la table des compteurs
  /*     V_RL_CP_NUM_RL := lpad(releve_.dist,2,'0')||ltrim(rtrim(releve_.code_marque )) ||
                          lpad(ltrim(rtrim(releve_.compteur_actuel)),11,'0');

*/



  begin
       select distinct  p.mhpc_refcom
        into V_RL_CP_NUM_RL
        from miwthistocpt p
       where  substr(p.mhpc_refpdl,1,8) =trim(releve_.district)||
       lpad(trim(releve_.tourne),3,'0')||
       lpad(trim(releve_.ordre),3,'0');
   exception when others then
          err_code := SQLCODE;
          err_msg  := SUBSTR(SQLERRM, 1, 200);
          insert into prob_migration
            (nom_table, val_ref, sql_err,date_pro,type_problem)
          values
            ('miwtrelevegc_fact_cpt',
             releve_.tourne || '--' || releve_.ordre,
             err_code || '--' || err_msg,sysdate,'problem recuperation compteur pour le pdl '||trim(releve_.district)||trim(releve_.tourne)||trim(releve_.ordre));
             continue;
    end;


  if (to_number(releve_.Refc01)='12') then
    V_DTE_RELEVE:='08/'||'01/'||'20'||to_char(to_number(trim(releve_.refc02))+1);
  else
    V_DTE_RELEVE:='08/'||lpad(releve_.refc01+1,2,'0')||'/20'||trim(releve_.refc02);
   end if ;


------------------------------------------------------

if ltrim(rtrim(releve_.nindex)) is null then
      for com_lectimp_ in (select *
                                 from listeanomalies_releve a
                                where trim(a.DISTRICT) = trim(releve_.dist)
                                  and lpad(trim(a.TOURNE),3,'0')= lpad(trim(releve_.tou),3,'0')
                                  and lpad(trim(a.ORDRE),3,'0')= lpad(trim(releve_.ord),3,'0')
                                  and a.ANNEE = '20' || trim(releve_.refc02)
                                  and a.TRIM = releve_.refc01) loop
            V_CODE_SI_ANOMALIE := ltrim(rtrim(com_lectimp_.code_anomalie));
            V_TYPE_ANOMALIE := ltrim(rtrim(com_lectimp_.type_anomalie));
       end loop ;
  else
        for com_lectimp_ in (select *
                                 from listeanomalies_releve a
                                where trim(a.DISTRICT) = trim(releve_.dist)
                                  and lpad(trim(a.TOURNE),3,'0') =lpad(trim(releve_.tou),3,'0')
                                  and lpad(trim(a.ORDRE),3,'0') = lpad(trim(releve_.ord),3,'0')
                                  and a.ANNEE = '20'||trim(releve_.refc02)
                                  and a.TRIM = releve_.refc01) loop
            V_CODE_ANOMALIE := ltrim(rtrim(com_lectimp_.code_anomalie));
            V_TYPE_ANOMALIE := ltrim(rtrim(com_lectimp_.type_anomalie));
          end loop;

    end if;

        for com_lectimp_ in (select *
                               from listeanomalies_releve a
                              where trim(a.DISTRICT) = trim(releve_.dist)
                                and lpad(trim(a.TOURNE),3,'0') =lpad(trim(releve_.tou),3,'0')
                                and lpad(trim(a.ORDRE),3,'0') = lpad(trim(releve_.ord),3,'0')
                                and a.ANNEE = '20' || trim(releve_.refc02)
                                and a.TRIM = releve_.refc01) loop
          V_CODE_ANOMALIE := ltrim(rtrim(com_lectimp_.code_anomalie));
          V_TYPE_ANOMALIE := ltrim(rtrim(com_lectimp_.type_anomalie));

        end loop;

      -- reception du libelle du commentaire
         for anom_rel_ in (select *
                            from ANOMALIES_RELEVE a
                            where ltrim(rtrim(a.code)) = V_CODE_ANOMALIE
                               and ltrim(rtrim(a.typea)) = V_TYPE_ANOMALIE
                               ) loop

            V_DESIG_ANOM := anom_rel_.desig;
            V_TYPE_ANOM  := anom_rel_.typea;

          end loop;

      if V_TYPE_ANOM = 'C' then
        for MIG_COMREL_ in (select *
                              from miwtvocable a
                             where a.mvoc_libe = V_DESIG_ANOM
                               and a.mvoc_type = 'COMM') loop
          V_RL_CODE1 := MIG_COMREL_.MVOC_REF;
        end loop;
      end if;

      if V_TYPE_ANOM = 'L' then
        for MIG_LECIMP_ in (select *
                              from miwtvocable a
                             where a.mvoc_libe = V_DESIG_ANOM
                               and a.mvoc_type = 'READCODE') loop
          V_RL_LECIMP := MIG_LECIMP_.MVOC_REF;
        end loop;
      end if;
    /*if ltrim(rtrim(releve_.DATE_CONTROLE)) is null and ltrim(rtrim(releve_.INDEX_CONTROLE)) is null then
      V_RL_LECIMP:='TOURNEE';
      ELSE
        V_RL_LECIMP:='CONTROLE';
        end if;*/

        v_ref_releve := v_ref_releve + 1;


        begin
          insert into miwtreleve_gc_1
            (
             MREL_SOURCE ,--1  Identifiant de la source de donnees [OBL]
             MREL_REF    ,--2  Reference de la releve dans le SI source (le couple source/reference releve doit etre UNIQUE) [OBL]
             MREL_REFPDL ,--3  Reference du PDl dans le SI source
             MREL_REFCOM ,--4  Reference du compteur dans le SI source
             MREL_DATE   ,--5  Date de la releve [OBL]
             MREL_INDEX1 ,--6  Index
             MREL_DEDUITE,--7  Index
             MREL_CONSO1 ,--8
             MREL_CADRAN1,--9
             VOC_READORIG,--10   RL_ORIG
             VOC_READREASON,--11 RL_TYPLEC
             MREL_ETATFACT,--12
             MREL_FACTUREE,--13
             MREL_AGESOURCE,--14
             MREL_AGEREF   ,--15
             annee         ,--16
             periode       ,--17
             mrel_agrtype  ,--18
             mrel_techtype ,--19
             voc_comm1     ,--20
             VOC_READCODE  ,--21
             MREL_CONSO_REF1,--22
             mrel_fact1      --23
            )
          values
            (
             'DIST'||v_district,--1
             v_ref_releve      ,--2
             V_RL_BR_NUM       ,--3
             V_RL_CP_NUM_RL    ,--4
             V_DTE_RELEVE      ,--5
             to_number(releve_.nindex),--6
             nvl(to_number(trim(releve_.prorata)),0)*-1,--7
             nvl(to_number(trim(releve_.cons)),0),--8
             'EAU'             ,--9
             '03'              ,--10
             '1'               ,--11 'tournee'
             0                 ,--12
             1                 ,--13
             '1'               ,--14
             '1'               ,--15
             to_number('20'||trim(releve_.refc02)),--16
             to_number(releve_.refc01),--17
             0                 ,--18
             0                 ,--19
             V_CODE_ANOMALIE   ,--20
             V_CODE_SI_ANOMALIE,--21
             0                 ,--22
             ltrim(rtrim(releve_.dist)) ||
                                lpad(ltrim(rtrim(releve_.tou)), 3, '0') ||
                                lpad(ltrim(rtrim(releve_.ord)), 3, '0') || '20' ||
                                trim(releve_.refc02) || lpad(trim(releve_.refc01),2,'0') || '0'--23

            );

        exception
          when others then
            err_code := SQLCODE;
            err_msg  := SUBSTR(SQLERRM, 1, 200);
            insert into prob_migration
              (nom_table, val_ref, sql_err, date_pro,type_problem)
            values
              ('miwtreleve_GC_1',
               V_RL_BR_NUM||'--'||trim(releve_.refc02)||'--'||releve_.refc01,
               err_code || '--' || err_msg, sysdate,'erreur de manque de date releve_gc_1 pour le pdl suivante'||trim(releve_.district)||trim(releve_.tourne)||trim(releve_.ordre));
        end;


      v_nbr_trsf := v_nbr_trsf + 1;
    exception
          when others then
            err_code := SQLCODE;
            err_msg  := SUBSTR(SQLERRM, 1, 200);
            insert into prob_migration
              (nom_table, val_ref, sql_err, date_pro,type_problem)
            values
              ('miwtreleve11_GC_1',
               V_RL_BR_NUM||'-'||'--'||trim(releve_.refc02)||'--'||releve_.refc01,
               err_code || '--' || err_msg,sysdate,'erreur de confomité de type colonne pour le pdl suivante'||trim(releve_.district)||trim(releve_.tourne)||trim(releve_.ordre));

        v_nbr_rej := v_nbr_rej + 1;
        v_msg     := sqlerrm;

    end;
    COMMIT;
  end loop;

 insert into prob_migration (nom_table)values(SYSTIMESTAMP||'   END miwt_releve_gc_facture');
  commit;

end;
/

prompt
prompt Creating procedure MIWT_RELEVE_HISTCPT
prompt ======================================
prompt
create or replace procedure miwt_RELEVE_histcpt(v_district in varchar2) is


  err_code           varchar2(200);
  err_msg            varchar2(200);
  v_msg              varchar2(800);
  V_RL_CP_NUM_BR     varchar2(60);
  V_RL_CP_NUM_RL     varchar2(60);
  V_RL_BR_NUM        varchar2(60);
  V_DTE_RL           varchar2(60);
  V_DTE_TIME_RL      varchar2(60);
  V_DTE_RELEVE       date;
  V_CODE_ANOMALIE    varchar2(20);
  V_TYPE_ANOMALIE    varchar2(10);
  V_DESIG_ANOM       varchar2(200);
  V_TYPE_ANOM        varchar2(10);
  V_RL_CODE1         varchar2(20);
  V_RL_LECIMP        varchar2(20);
  V_COUNT_BR         number;
  v_MREL_DEDUITE     number;
  v_periode          number;
  v_trim             number;
  v_annee            number;
  v_ref_releve_      number;
  v_nbr_trsf         number(10) := 0;
  v_nbr_rej          number(10) := 0;


begin

execute immediate 'alter session set nls_date_format = ''dd/mm/yyyy''';
execute immediate 'alter session set NLS_NUMERIC_CHARACTERS = '',.''';
    --**************************************************

  --delete MIWTRELEVE where MREL_SOURCE='DIST'||v_district;
  delete  prob_migration where nom_table in ('miwt_RELEVE_histcpt');
  DELETE FROM MIWTRELEVE_histocpt h where h.mrel_source='DIST'||v_district;
  insert into prob_migration (nom_table)values(SYSTIMESTAMP||'   START miwt_RELEVE_histcpt');
  commit;
  v_ref_releve_ := 0;

  select NVL(max(to_number(MREL_REF)),0)
    into v_ref_releve_
    from MIWTRELEVE_histocpt;
  ------------------------------------------
  -------------------------- Releve dans le cas de pose
  for releve_ in (
                  select
                         a.mhpc_source,
                         nvl(a.index_depart,0) index_depart,
                         a.mhpc_ddeb,
                         a.mhpc_refcom,
                         a.mhpc_refpdl
                   from MIWTHISTOCPT  a
                   where a.mhpc_source = 'DIST'||v_district
                   and a.voc_reaspose = 'P'
                   --and a.voc_reasdepose is null
                  ) loop

    V_RL_CP_NUM_BR  := NULL;
    V_RL_CP_NUM_RL  := NULL;
    V_RL_BR_NUM     := NULL;
    V_DTE_RL        := NULL;
    V_DTE_TIME_RL   := NULL;
    V_DTE_RELEVE    := NULL;
    V_CODE_ANOMALIE := NULL;
    V_TYPE_ANOMALIE := NULL;
    V_DESIG_ANOM    := NULL;
    V_TYPE_ANOM     := NULL;
    V_RL_CODE1      := NULL;
    V_RL_LECIMP     := NULL;
    V_COUNT_BR      := 0;

begin
  -- reception du branchement associe
  V_RL_BR_NUM := releve_.mhpc_refpdl;

  -- verfication si le compteur existe deja au niveau de la table des compteurs
  V_RL_CP_NUM_RL := releve_.mhpc_refcom;

  V_DTE_RELEVE := releve_.mhpc_ddeb;

  v_ref_releve_  := v_ref_releve_ + 1;

  v_MREL_DEDUITE := 0;

  v_annee:=substr(releve_.mhpc_ddeb,7,4);

    if(substr(releve_.mhpc_ddeb,4,2)in('01','02','03')) then
    v_trim:=1;
    elsif (substr(releve_.mhpc_ddeb,4,2)in('04','05','06')) then
    v_trim:=2;
    elsif (substr(releve_.mhpc_ddeb,4,2)in('07','08','09')) then
    v_trim:=3;
    elsif (substr(releve_.mhpc_ddeb,4,2)in('10','11','12')) then
    v_trim:=4;
    end if;

      begin
        insert into MIWTRELEVE_histocpt
          (
           MREL_SOURCE ,--1  Identifiant de la source de donnees [OBL]
           MREL_REF    ,--2  Reference de la releve dans le SI source (le couple source/reference releve doit etre UNIQUE) [OBL]
           MREL_REFPDL ,--3  Reference du PDl dans le SI source
           MREL_REFCOM ,--4  Reference du compteur dans le SI source
           MREL_DATE   ,--5  Date de la releve [OBL]
           MREL_INDEX1 ,--6  Index
           MREL_CONSO1 ,--7
           MREL_CADRAN1,--8
           MREL_CADRAN2,--9
           MREL_CADRAN3,--10
           MREL_CADRAN4,--11
           MREL_CADRAN5,--12
           MREL_CADRAN6,--13
           VOC_READORIG,--14
           VOC_READREASON,--15
           MREL_ETATFACT,--16
           MREL_FACTUREE,--17
           MREL_AGESOURCE,--18
           MREL_AGEREF   ,--19
           annee         ,--20
           periode       ,--21
           mrel_agrtype  ,--22
           mrel_techtype ,--23
           voc_comm1     ,--24
           VOC_READCODE  ,--25
           MREL_CONSO_REF1,--26
           mrel_ano_c1   ,--27
           mrel_ano_c2   ,--28
           mrel_ano_c3   ,--29
           mrel_ano_n1   ,--30
           mrel_ano_n2   ,--31
           mrel_ano_n3   ,--32
           mrel_ano_f1   ,--33
           mrel_ano_f2   ,--34
           mrel_ano_f3   ,--35
           MREL_DEDUITE  ,--36
           MREL_INDEX2   ,--37
           MREL_INDEX3   ,--38
           MREL_INDEX4   ,--39
           MREL_INDEX5   ,--40
           MREL_INDEX6   ,--41
           mrel_comlibre  --42
           )
        values
          (
           'DIST' || v_district,--1
           v_ref_releve_       ,--2
           V_RL_BR_NUM         ,--3
           V_RL_CP_NUM_RL      ,--4
           V_DTE_RELEVE        ,--5
           0                   ,--6
           0                   ,--7
           'EAU'               ,--8
           NULL                ,--9
           NULL                ,--10
           NULL                ,--11
           NULL                ,--12
           NULL                ,--13
           '03'                ,--14
           V_RL_LECIMP         ,--15
           0                   ,--16
           1                   ,--17
           NULL                ,--18
           NULL                ,--19
           to_number(v_annee)  ,--20
           to_number(v_trim)   ,--21
           0                   ,--22
           1                   ,--23
           NULL                ,--24
           NULL                ,--25
           0                   ,--26
           NULL                ,--27
           NULL                ,--28
           NULL                ,--29
           NULL                ,--30
           NULL                ,--31
           NULL                ,--32
           NULL                ,--33
           NULL                ,--34
           NULL                ,--35
           NULL                ,--36
           NULL                ,--37
           NULL                ,--38
           NULL                ,--39
           NULL                ,--40
           NULL                ,--41
           '0'                  --42
           );
      exception
        when others then
          err_code := SQLCODE;
          err_msg  := SUBSTR(SQLERRM, 1, 200);
          insert into prob_migration
            (nom_table, val_ref, sql_err, date_pro,type_problem)
          values
            ('miwt_RELEVE_histcpt',
             V_RL_BR_NUM || '--' || to_number(v_annee)||to_number(v_trim),
             err_code || '--' || err_msg,sysdate,'erreur de manque date releve pour le pdl suivante'||V_RL_BR_NUM);
      end;
      v_nbr_trsf := v_nbr_trsf + 1;
exception
when others then
  err_code := SQLCODE;
  err_msg  := SUBSTR(SQLERRM, 1, 200);
  insert into prob_migration
  (nom_table, val_ref, sql_err, date_pro,type_problem)
  values
  ('miwt_RELEVE_histcpt',
  V_RL_BR_NUM || '-' || releve_.mhpc_ddeb,
  err_code || '--' || err_msg,sysdate,'erreur de confomité de type colonne pour le pdl suivante'||V_RL_BR_NUM);
  v_nbr_rej := v_nbr_rej + 1;
  v_msg     := sqlerrm;
end;
    COMMIT;
end loop;

  ---------------------------------------------
  ----------------------- Releve dans le cas de depose
  for releve_ in (select
                         a.mhpc_source,
                         a.mhpc_dfin,
                         a.mhpc_refcom,
                         a.mhpc_refpdl,
                         a.mhpc_ddeb
                    from MIWTHISTOCPT  a
                   where a.mhpc_source = 'DIST'||v_district
                     --and a.voc_reaspose is null
                     and a.voc_reasdepose ='D'

                  ) loop

    V_RL_CP_NUM_BR  := NULL;
    V_RL_CP_NUM_RL  := NULL;
    V_RL_BR_NUM     := NULL;
    V_DTE_RL        := NULL;
    V_DTE_TIME_RL   := NULL;
    V_DTE_RELEVE    := NULL;
    V_CODE_ANOMALIE := NULL;
    V_TYPE_ANOMALIE := NULL;
    V_DESIG_ANOM    := NULL;
    V_TYPE_ANOM     := NULL;
    V_RL_CODE1      := NULL;
    V_RL_LECIMP     := NULL;
    V_COUNT_BR      := 0;

    begin

    -- reception du branchement associe
    V_RL_BR_NUM := releve_.mhpc_refpdl;

    -- verfication si le compteur existe deja au niveau de la table des compteurs
    V_RL_CP_NUM_RL := releve_.mhpc_refcom;

    -- Date de depose
    V_DTE_RELEVE := releve_.mhpc_dfin;

    --calcule de consomation avec l'ancienne releve

    v_annee:=substr(releve_.mhpc_dfin,7,4);

    if(substr(releve_.mhpc_dfin,4,2)in('01','02','03')) then
    v_trim:=1;
    elsif (substr(releve_.mhpc_dfin,4,2)in('04','05','06')) then
    v_trim:=2;
    elsif (substr(releve_.mhpc_dfin,4,2)in('07','08','09')) then
    v_trim:=3;
    elsif (substr(releve_.mhpc_dfin,4,2)in('10','11','12')) then
    v_trim:=4;
    end if;

    if v_trim=1 then
    v_periode:=to_char(v_annee-1)||'4';
    else
    v_periode:=to_char(v_annee)||v_trim-1;
    end if;

    v_ref_releve_  := v_ref_releve_ + 1;

    v_MREL_DEDUITE := 0;

      begin
        insert into MIWTRELEVE_histocpt
          (
           MREL_SOURCE   ,--1  Identifiant de la source de donnees [OBL]
           MREL_REF      ,--2  Reference de la releve dans le SI source (le couple source/reference releve doit etre UNIQUE) [OBL]
           MREL_REFPDL   ,--3  Reference du PDl dans le SI source
           MREL_REFCOM   ,--4  Reference du compteur dans le SI source
           MREL_DATE     ,--5  Date de la releve [OBL]
           MREL_INDEX1   ,--6  Index
           MREL_CONSO1   ,--7
           MREL_CADRAN1  ,--8
           MREL_CADRAN2  ,--9
           MREL_CADRAN3  ,--10
           MREL_CADRAN4  ,--11
           MREL_CADRAN5  ,--12
           MREL_CADRAN6  ,--13
           VOC_READORIG  ,--14
           VOC_READREASON,--15
           MREL_ETATFACT ,--16
           MREL_FACTUREE ,--17
           MREL_AGESOURCE,--18
           MREL_AGEREF   ,--19
           annee         ,--20
           periode       ,--21
           mrel_agrtype  ,--22
           mrel_techtype ,--23
           voc_comm1     ,--24
           VOC_READCODE  ,--25
           MREL_CONSO_REF1,--26
           mrel_ano_c1   ,--27
           mrel_ano_c2   ,--28
           mrel_ano_c3   ,--29
           mrel_ano_n1   ,--30
           mrel_ano_n2   ,--31
           mrel_ano_n3   ,--32
           mrel_ano_f1   ,--33
           mrel_ano_f2   ,--34
           mrel_ano_f3   ,--35
           MREL_DEDUITE  ,--36
           MREL_INDEX2   ,--37
           MREL_INDEX3   ,--38
           MREL_INDEX4   ,--39
           MREL_INDEX5   ,--40
           MREL_INDEX6   ,--41
           mrel_comlibre  --42
           )
        values
          (
           'DIST' || v_district,-- 1
           v_ref_releve_       ,--2
           V_RL_BR_NUM         ,--3
           V_RL_CP_NUM_RL      ,--4
           V_DTE_RELEVE        ,--5
           0                   ,--6
           0                   ,--7
           'EAU'               ,--8
           NULL                ,--9
           NULL                ,--10
           NULL                ,--11
           NULL                ,--12
           NULL                ,--13
           '03'                ,--14
           V_RL_LECIMP         ,--15
           0                   ,--16
           1                   ,--17
           NULL                ,--18
           NULL                ,--19
           to_number(v_annee)  ,--20
           to_number(v_trim)   ,--21
           0                   ,--22
           2                   ,--23
           NULL                ,--24
           NULL                ,--25
           0                   ,--26
           NULL                ,--27
           NULL                ,--28
           NULL                ,--29
           NULL                ,--30
           NULL                ,--31
           NULL                ,--32
           NULL                ,--33
           NULL                ,--34
           NULL                ,--35
           NULL                ,--36
           NULL                ,--37
           NULL                ,--38
           NULL                ,--39
           NULL                ,--40
           NULL                ,--41
           '0'                  --42
           );
    exception
    when others then
    err_code := SQLCODE;
    err_msg  := SUBSTR(SQLERRM, 1, 200);
    insert into prob_migration
    (nom_table, val_ref, sql_err, date_pro)
    values
    ('miwt_RELEVE_histcpt',
    V_RL_BR_NUM || '--'||to_number(v_annee)||to_number(v_trim),
    err_code || '--' || err_msg,
    sysdate);
    end;

v_nbr_trsf := v_nbr_trsf + 1;
exception
    when others then
    err_code := SQLCODE;
    err_msg  := SUBSTR(SQLERRM, 1, 200);
    insert into prob_migration
    (nom_table, val_ref, sql_err, date_pro)
    values
    ('miwt_RELEVE_histcpt',
    V_RL_BR_NUM || '-' || releve_.mhpc_dfin,
    err_code || '--' || err_msg,
    sysdate);
    v_nbr_rej := v_nbr_rej + 1;
    v_msg     := sqlerrm;
end;
COMMIT;
end loop;
insert into prob_migration (nom_table)values(SYSTIMESTAMP||'   END miwt_RELEVE_histcpt');
commit;
end;
/

prompt
prompt Creating procedure MIWT_RELEVE_T
prompt ================================
prompt
create or replace procedure miwt_RELEVE_T(v_district in varchar2) is

  v_NTIERS             number;
  v_NSIXIEME           number;
  v_annee              number;
  err_code             varchar2(200);
  err_msg              varchar2(200);
  v_msg                varchar2(800);
  v_nbr_trsf           number(10) := 0;
  v_nbr_rej            number(10) := 0;
  V_RL_CP_NUM_BR       varchar2(60);
  V_RL_CP_NUM_RL       varchar2(60);
  V_RL_BR_NUM          varchar2(60);
  V_DTE_RL             varchar2(60);
  V_DTE_TIME_RL        varchar2(60);
  V_DTE_RELEVE         date;
  V_CODE_ANOMALIE      varchar2(20);
  V_TYPE_ANOMALIE      varchar2(10);
  V_DESIG_ANOM         varchar2(200);
  V_TYPE_ANOM          varchar2(10);
  V_RL_CODE1           varchar2(20);
  V_RL_LECIMP          varchar2(20);
  V_COUNT_BR           number;
  V_CODE_SI_ANOMALIE   varchar2(20);
  v_MREL_DEDUITE       number;
  v_avisforte          varchar2(50);
  v_code_marque        varchar2(50);
  v_compteur_actuel    varchar2(50);
  v_date_controle      varchar2(30);
  v_index_controle     varchar2(20);
  v_message_temporaire varchar(200);
  -- suivi traitement
  v_trim               number;
  v_ref_releve_        number;
  v_compteurt          varchar2(5);
  v_releve2            varchar2(10);
  v_releve3            varchar2(10);
  v_releve4            varchar2(10);
  v_releve5            varchar2(10);
  v_anomalie           varchar2(30);
  v_MATRICULE_RELEVEUR varchar2(100);
  --v_rcpt varchar(200);
  --v_mcpt varchar(200);
  --val number default (0);

begin
execute immediate 'alter session set nls_date_format = ''dd/mm/yyyy''';
execute immediate 'alter session set NLS_NUMERIC_CHARACTERS = '',.''';

delete MIWTRELEVET where MREL_SOURCE = 'DIST' || v_district;
delete prob_migration
where nom_table in ('miwtreleveT', 'miwtreleveT11','miwtreleveT_ref_cpt');

insert into prob_migration (nom_table)values(SYSTIMESTAMP||'   START miw_treleve_T');
commit;

v_ref_releve_ := 0;

select nvl(max(to_number(MREL_REF)), 0)
into v_ref_releve_
from miwtreleve;

  for releve_ in (select decode(annee,0,indexa,indexr) index_releve,a.*
                  from releveT a
                 where trim(a.district) = v_district) loop


v_code_marque:=null;
v_compteur_actuel:=null;

    begin
        select s.trim,
               s.date_controle,
               s.index_controle,
               s.avisforte,
               s.message_temporaire,
               s.compteurt,
               s.releve2,
               s.releve3,
               s.releve4,
               s.releve5,
               s.anomalie,
               s.MATRICULE_RELEVEUR
          into v_trim,
               v_date_controle,
               v_index_controle,
               v_avisforte,
               v_message_temporaire,
               v_compteurt,
               v_releve2,
               v_releve3,
               v_releve4,
               v_releve5,
               v_anomalie,
               v_MATRICULE_RELEVEUR
          from fiche_releve s
         where trim(s.district) = v_district
           and trim(s.tourne) = trim(releve_.tourne)
           and trim(s.ordre) = trim(releve_.ordre)
           and trim(s.annee)||trim(s.trim) =(select max(trim(v.annee)||trim(v.trim))
                                             from fiche_releve v
                                             where trim(v.tourne) = trim(s.tourne)
                                             and trim(v.ordre) = trim(s.ordre));
      exception
            when others then
              err_code := SQLCODE;
              err_msg  := SUBSTR(SQLERRM, 1, 200);
              insert into prob_migration
                (nom_table, val_ref, sql_err, date_pro,type_problem)
              values
                ('miwtreleveT',
                 releve_.tourne || '--' || releve_.ordre,
                 err_code || '--' || err_msg,sysdate,'erreur de recupertion des donnees pour le relevet pour le pdl '||v_district|| releve_.tourne|| releve_.ordre );
                 continue;
       end;


-----------------------------------------------------------
-----------------------------------------------------------
    V_RL_CP_NUM_BR  := NULL;
    V_RL_CP_NUM_RL  := NULL;
    V_RL_BR_NUM     := NULL;
    V_DTE_RL        := NULL;
    V_DTE_TIME_RL   := NULL;
    V_DTE_RELEVE    := NULL;
    V_CODE_ANOMALIE := NULL;
    V_TYPE_ANOMALIE := NULL;
    V_DESIG_ANOM    := NULL;
    V_TYPE_ANOM     := NULL;
    V_RL_CODE1      := NULL;
    V_RL_LECIMP     := NULL;
    V_COUNT_BR      := 0;

    begin

      -- reception du branchement associe
      for bra_ in (select *
                     from branchement a
                    where trim(a.district) = trim(releve_.district)
                      and lpad(trim(a.tourne), 3, '0') =
                          lpad(trim(releve_.tourne), 3, '0')
                      and lpad(trim(a.ordre), 3, '0') =
                          lpad(trim(releve_.ordre), 3, '0')

                   ) loop
        -- numero compteur (branchement)
        -- reception code point instalation PDI
        V_RL_BR_NUM := lpad(bra_.district, 2, '0') ||
                       lpad(trim(bra_.tourne), 3, '0') ||
                       lpad(trim(bra_.ordre), 3, '0') ||
                       lpad(to_char(trim(bra_.police)), 5, '0');
        V_COUNT_BR  := V_COUNT_BR + 1;

      end loop;

      -- verfication si le compteur existe deja au niveau de la table des compteurs

 
-------------------------------------------------------
 ------------------------------------------------------- RECHERCHE COMPTEUR
begin
    select p.mhpc_refcom
    into V_RL_CP_NUM_RL
    from miwthistocpt p
    where substr(p.mhpc_refpdl,1,8)=trim(releve_.district)||trim(releve_.tourne)||trim(releve_.ordre);
    exception
    when others then
    err_code := SQLCODE;
    err_msg  := SUBSTR(SQLERRM, 1, 200);
    insert into prob_migration
    (nom_table, val_ref, sql_err, date_pro,type_problem)
    values
    ('miwtreleveT_ref_cpt',
    releve_.tourne || '--' || releve_.ordre,
    err_code || '--' || err_msg,sysdate,'problem recuperation compteur pour le pdl '||trim(releve_.district)||trim(releve_.tourne)||trim(releve_.ordre));
    continue;
end;

-----------------------------------------------------
      V_DTE_RL     := substr(releve_.date_releve,1,
      instr(replace(replace(releve_.date_releve,' ','#'),':','#'),'#') - 1);
      
      V_DTE_RL     := replace(V_DTE_RL, '-', '/');
              
      V_DTE_RELEVE := to_date(V_DTE_RL,'dd/mm/yy');      
      
      --      test date
      ------------------------------------------------------
      BEGIN
        select to_date(lpad(trim(t.dateexp),8,'0'), 'dd/mm/yyyy') - 7
          into V_DTE_RELEVE
          from ROLE_TRIM t
         where lpad(LTRIM(RTRIM(t.distr)),2,'0')= trim(releve_.district)
           and LTRIM(RTRIM(t.annee))= trim(releve_.annee)
           and LTRIM(RTRIM(t.trim))= trim(v_trim)
           and lpad(LTRIM(RTRIM(t.tour)),3,'0') =
               lpad(trim(releve_.tourne),3,'0')
           and lpad(LTRIM(RTRIM(t.ordr)),3,'0') =
               lpad(trim(releve_.ordre),3,'0');
      EXCEPTION
        WHEN OTHERS THEN
            begin
              select to_date(lpad(trim(t.dateexp),8,'0'),'dd/mm/yyyy') - 7
                into V_DTE_RELEVE
                from ROLE_MENS t
               where lpad(LTRIM(RTRIM(t.distr)),2,'0') = trim(releve_.district)
                 and LTRIM(RTRIM(t.annee)) = trim(releve_.annee)
                 and LTRIM(RTRIM(t.mois)) = trim(v_trim)
                 and lpad(LTRIM(RTRIM(t.tour)),3,'0') =
                     lpad(trim(releve_.tourne),3,'0')
                 and lpad(LTRIM(RTRIM(t.ordr)),3,'0') =
                     lpad(trim(releve_.ordre),3,'0');
            exception when others then
              
              if substr(releve_.annee,3,2) !=
                 to_char(to_date(substr(releve_.date_releve,1,10),
                                 'dd/mm/yyyy hh24:mi:ss'),
                         'YY') and v_trim in (1, 2, 3) then
                select t.ntiers, t.NSIXIEME
                  into v_NTIERS, v_NSIXIEME
                  from tourne t
                 where t.code = releve_.tourne;
                if v_NSIXIEME = 1 THEN
                  IF v_trim = 1 THEN
                    V_DTE_RELEVE := to_date('08/0' || to_char(v_NTIERS) || '/' ||
                                            releve_.annee,
                                            'dd/mm/yyyy');
                  ELSIF v_trim = 2 THEN
                    V_DTE_RELEVE := to_date('08/0' || to_char(3 + v_NTIERS) || '/' ||
                                            releve_.annee,
                                            'dd/mm/yyyy');
                  ELSIF v_trim = 3 THEN
                    V_DTE_RELEVE := to_date('08/0' || to_char(6 + v_NTIERS) || '/' ||
                                            releve_.annee,
                                            'dd/mm/yyyy');
                  ELSIF v_trim = 4 THEN
                    V_DTE_RELEVE := to_date('08/' || to_char(9 + v_NTIERS) || '/' ||
                                            releve_.annee,
                                            'dd/mm/yyyy');
                  end if;
                else
                  IF v_trim = 1 THEN
                    V_DTE_RELEVE := to_date('15/0' || to_char(v_NTIERS) || '/' ||
                                            releve_.annee,
                                            'dd/mm/yyyy');
                  ELSIF v_trim = 2 THEN
                    V_DTE_RELEVE := to_date('15/0' || to_char(3 + v_NTIERS) || '/' ||
                                            releve_.annee,
                                            'dd/mm/yyyy');
                  ELSIF v_trim = 3 THEN
                    V_DTE_RELEVE := to_date('15/0' || to_char(6 + v_NTIERS) || '/' ||
                                            releve_.annee,
                                            'dd/mm/yyyy');
                  ELSIF v_trim = 4 THEN
                    V_DTE_RELEVE := to_date('15/' || to_char(9 + v_NTIERS) || '/' ||
                                            releve_.annee,
                                            'dd/mm/yyyy');
                  end if;
                end if;
               end if;
      END;
      END;

      if ltrim(rtrim(v_date_controle)) is null and
         (ltrim(rtrim(v_index_controle)) is null or
          ltrim(rtrim(v_index_controle)) = 0) then
        V_RL_LECIMP := 'TOURNEE';
      ELSE
        V_RL_LECIMP := 'CONTROLE';
      end if;

      v_ref_releve_  := v_ref_releve_ + 1;
      v_MREL_DEDUITE := 0;
      if to_number(releve_.prorata) > 0 then
        v_MREL_DEDUITE := nvl(to_number(trim(releve_.consommation)), 0) -
                          releve_.prorata;
      end if;
      
    begin 
    if to_number(ltrim(rtrim(v_avisforte))) > 0 then
    v_avisforte := 'N°Avis Forte=' || v_avisforte;
    end if;
    exception when others then
    v_avisforte := null;
    end;
      
    if  to_number(releve_.annee)=0 then
    v_annee:=2017;
    else
    v_annee:=to_number(releve_.annee);
    end if;

      begin
        insert into Miwtrelevet
          (
           MREL_SOURCE      ,--1  Identifiant de la source de donnees [OBL]
           MREL_REF         ,--2  Reference de la releve dans le SI source (le couple source/reference releve doit etre UNIQUE) [OBL]
           MREL_REFPDL      ,--3  Reference du PDl dans le SI source
           MREL_REFCOM      ,--4  Reference du compteur dans le SI source
           MREL_DATE        ,--5  Date de la releve [OBL]
           MREL_INDEX1      ,--6  Index
           MREL_CONSO1      ,--7
           MREL_CADRAN1     ,--8
           MREL_CADRAN2     ,--9
           MREL_CADRAN3     ,--10
           MREL_CADRAN4     ,--11
           MREL_CADRAN5     ,--12
           MREL_CADRAN6     ,--13
           VOC_READORIG     ,--14
           VOC_READREASON   ,--15
           MREL_ETATFACT    ,--16
           MREL_FACTUREE    ,--17
           MREL_AGESOURCE   ,--18
           MREL_AGEREF      ,--19
           annee            ,--20
           periode          ,--21
           mrel_agrtype     ,--22
           mrel_techtype    ,--23
           voc_comm1        ,--24
           VOC_READCODE     ,--25
           MREL_CONSO_REF1  ,--26
           mrel_ano_c1      ,--27
           mrel_ano_c2      ,--28
           mrel_ano_c3      ,--29
           mrel_ano_n1      ,--30
           mrel_ano_n2      ,--31
           mrel_ano_n3      ,--32
           mrel_ano_f1      ,--33
           mrel_ano_f2      ,--34
           mrel_ano_f3      ,--35
           MREL_DEDUITE     ,--36
           MREL_INDEX2      ,--37
           MREL_INDEX3      ,--38
           MREL_INDEX4      ,--39
           MREL_INDEX5      ,--40
           MREL_INDEX6      ,--41
           mrel_comlibre     --42
          )
         values
          (
          'DIST' || v_district ,-- 1
           v_ref_releve_       ,--2
           V_RL_BR_NUM         ,--3
           V_RL_CP_NUM_RL      ,--4
           releve_.date_releve ,--5
           to_number(releve_.index_releve),--6
           nvl(to_number(trim(releve_.consommation)), 0),--7
           'EAU'               ,--8
           'TENT1'             ,--9
           'TENT2'             ,--10
           'TENT3'             ,--11
           'TENT4'             ,--12
           'CPTTOU'            ,--13
           '03'                ,--14
           V_RL_LECIMP         ,--15
           0                   ,--16
           1                   ,--17
           v_MATRICULE_RELEVEUR,--18
           v_MATRICULE_RELEVEUR,--19
           v_annee             ,--20
           to_number(v_trim)   ,--21
           0                   ,--22
           0                   ,--23
           V_CODE_ANOMALIE     ,--24
           V_CODE_SI_ANOMALIE  ,--25
           0                   ,--26
           substr(v_anomalie, 1, 2),--27
           substr(v_anomalie, 3, 2),--28
           substr(v_anomalie, 5, 2),--29
           substr(v_anomalie, 7, 2),--30
           substr(v_anomalie, 9, 2),--31
           substr(v_anomalie, 11, 2),--32
           substr(v_anomalie, 13, 2),--33
           substr(v_anomalie, 15, 2),--34
           substr(v_anomalie, 17, 2),--35
           v_MREL_DEDUITE           ,--36
           to_number(replace(v_releve2, '.', null)),--37
           to_number(replace(v_releve3, '.', null)),--38
           to_number(replace(v_releve4, '.', null)),--39
           to_number(replace(v_releve5, '.', null)),--40
           nvl(to_number(decode(ltrim(rtrim(v_compteurt)),
                                'T',
                                '1',
                                '1',
                                '1',
                                '0')),
               0)                       ,--41
           ltrim(rtrim(v_message_temporaire)) || v_avisforte --42
           );
      exception
        when others then
          err_code := SQLCODE;
          err_msg  := SUBSTR(SQLERRM, 1, 200);
          insert into prob_migration
            (nom_table, val_ref, sql_err, date_pro,type_problem)
          values
            ('miwtreleveT',
             V_RL_BR_NUM || '--' || to_number(releve_.annee) ||
             to_number(v_trim),
             err_code || '--' || err_msg,sysdate,'erreur de manque de date relevet pour le pdl suivante'||trim(releve_.district)||trim(releve_.tourne)||trim(releve_.ordre));
      end;
      v_nbr_trsf := v_nbr_trsf + 1;
    exception
      when others then
        err_code := SQLCODE;
        err_msg  := SUBSTR(SQLERRM, 1, 200);
        insert into prob_migration
          (nom_table, val_ref, sql_err, date_pro,type_problem)
        values
          ('miwtreleveT11',
           V_RL_BR_NUM || '-' || releve_.date_releve,
           err_code || '--' || err_msg,sysdate,'erreur de confomité de type colonne pour le pdl suivante'||trim(releve_.district)||trim(releve_.tourne)||trim(releve_.ordre));
        v_nbr_rej := v_nbr_rej + 1;
        v_msg     := sqlerrm;
    end;
    COMMIT;
  end loop;
  insert into prob_migration (nom_table)values(SYSTIMESTAMP||'   END miw_treleve_T');
   commit;
end;
/

prompt
prompt Creating procedure MIWT_RIB
prompt ===========================
prompt
create or replace procedure miwt_rib(v_district varchar2)
is

begin

execute immediate 'alter session set nls_date_format = ''dd/mm/yyyy''';
execute immediate 'alter session set NLS_NUMERIC_CHARACTERS = '',.''';
    --**************************************************
   delete MIWTRIB where MRIB_SOURCE='DIST'||v_district;
    insert into prob_migration (nom_table)values(SYSTIMESTAMP||'   START Miwtrib');
   commit;



for rib_ in (select ltrim(rtrim(t.banque))||ltrim(rtrim(t.agence))||ltrim(rtrim(t.num_compte))||ltrim(rtrim(t.cle_rib)) rib,t.district,t.tourne,t.ordre
  from branchement t,abonnees a
  where lpad(trim(a.dist),2,'0')=trim(t.district)
  and   lpad(trim(a.tou),3,'0')=lpad(trim(t.tourne),3,'0')
  and   lpad(trim(a.ord),3,'0')=lpad(trim(t.ordre),3,'0')
  and   trim(a.categ)=5
  and ltrim(rtrim(t.banque))||ltrim(rtrim(t.agence))||ltrim(rtrim(t.num_compte))||ltrim(rtrim(t.cle_rib)) in (select ltrim(rtrim(p.rib)) from rib_part p)  ) loop

        insert into MIWTRIB
         (
          MRIB_SOURCE   ,--1
          MRIB_REF      ,--2
          MRIB_BANQUE   ,--3
          MRIB_GUICHET  ,--4
          MRIB_AGENCE   ,--5
          MRIB_COMPTE   ,--6
          MRIB_CLE_RIB  ,--7
          MRIB_TITULAIRE,--8
          MRIB_ISO_IBAN ,--9
          MRIB_BIC      ,--10
          MRIB_RUM      ,--11
          MRIB_RUMDT     --12
         )
        values
        (
         'DIST'||v_district,--1
         lpad(rib_.district,2,'0')||lpad(trim(rib_.tourne),3,'0')||lpad(trim(rib_.ordre),3,'0'),--2
         substr(rib_.rib,1,2),--3
         substr(rib_.rib,3,3),--4
         NULL                ,--5
         rib_.rib            ,--6
         substr(rib_.rib,19,2),--7
         null                ,--8
         null                ,--9
         null                ,--10
         null                ,--11
         null                 --12
        );
end loop;

for rib_ in (select ltrim(rtrim(t.banque))||ltrim(rtrim(t.agence))||ltrim(rtrim(t.num_compte))||ltrim(rtrim(t.cle_rib)) rib,t.district,t.tourne,t.ordre
  from branchement t,abonnees_gr a
  where lpad(trim(a.dist),2,'0')=trim(t.district)
  and   lpad(trim(a.tou),3,'0')=lpad(trim(t.tourne),3,'0')
  and   lpad(trim(a.ord),3,'0')=lpad(trim(t.ordre),3,'0')
  and   trim(a.categ)=5
  and ltrim(rtrim(t.banque))||ltrim(rtrim(t.agence))||ltrim(rtrim(t.num_compte))||ltrim(rtrim(t.cle_rib)) in (select ltrim(rtrim(p.rib)) from rib_gr p)
             ) loop
      insert into MIWTRIB
      (
        MRIB_SOURCE  ,--1
        MRIB_REF     ,--2
        MRIB_BANQUE  ,--3
        MRIB_GUICHET ,--4
        MRIB_AGENCE  ,--5
        MRIB_COMPTE  ,--6
        MRIB_CLE_RIB ,--7
        MRIB_TITULAIRE,--8
        MRIB_ISO_IBAN,--9
        MRIB_BIC     ,--10
        MRIB_RUM     ,--11
        MRIB_RUMDT    --12
       )
      values
      (
       'DIST'||v_district  ,--1
       lpad(rib_.district,2,'0')||lpad(trim(rib_.tourne),3,'0')||lpad(trim(rib_.ordre),3,'0'),--2
       substr(rib_.rib,1,2),--3
       substr(rib_.rib,3,3),--4
       NULL                ,--5
       rib_.rib            ,--6
       substr(rib_.rib,19,2),--7
       null                ,--8
       null                ,--9
       null                ,--10
       null                ,--11
       null                 --12
      );
end loop;
insert into prob_migration (nom_table)values(SYSTIMESTAMP||'   END Miwtrib');

commit;
end;
/

prompt
prompt Creating procedure MIWT_TOURNEE
prompt ===============================
prompt
create or replace procedure miwt_tournee(district_ varchar2)
is

begin
  delete  from MIWTTOURNEE t where t.mtou_source='DIST'||district_;
for c in (select * from tourne) loop
insert into MIWTTOURNEE (MTOU_SOURCE,MTOU_REF,MTOU_CODE,MTOU_LIBE)
values('DIST'||district_,c.code,c.code,c.code);
end loop;
insert into MIWTTOURNEE (MTOU_SOURCE,MTOU_REF,MTOU_CODE,MTOU_LIBE)
values('DIST'||district_,district_||'_AS',district_||'_AS',district_||'_AS');
commit;
end;
/

prompt
prompt Creating package body MIWTADRESSEPIVOT
prompt ======================================
prompt
CREATE OR REPLACE PACKAGE BODY miwtADRESSEPIVOT IS


  --********************************************************************--
  --         MIGRATIONS DES VILLES ET RUES
  --********************************************************************--
  PROCEDURE MIG_ADR(V_ADRESSE_   IN VARCHAR2,
                    V_AD_VILRUE_ IN NUMBER,
                    V_CODE_POSTAL_ IN VARCHAR2,
                    v_district IN VARCHAR2,
                    V_AD_NUM_    IN OUT NUMBER) IS
    V_MSG        VARCHAR2(800);
  V_NOM_VIL    VARCHAR2(500);
      err_code        varchar2(200);
  err_msg         varchar2(200);
  BEGIN
     V_NOM_VIL := NULL;
         FOR POSTAL_ IN (SELECT A.LIBELLE FROM R_CPOSTAL A WHERE TO_CHAR(A.KCPOST) = TRIM(V_CODE_POSTAL_)) LOOP
           V_NOM_VIL := POSTAL_.LIBELLE;
         END LOOP;
     IF V_AD_VILRUE_ IS NOT NULL THEN
       BEGIN
         if V_NOM_VIL is null then V_NOM_VIL:=0000; end if;
         SELECT NVL(MAX(to_number(MADR_REF)),0 )+1 INTO V_AD_NUM_ FROM MIWTADR;
         INSERT INTO MIWTADR
              (
                MADR_SOURCE,--   VARCHAR2(100) NOT NULL,
                MADR_REF,--      VARCHAR2(100) NOT NULL,
                MADR_REFRUE,--   VARCHAR2(100),
                MADR_NRUE,--     VARCHAR2(8),
                MADR_IRUE,--     VARCHAR2(10),
                MADR_RUE1,--     VARCHAR2(200),
                MADR_RUE2,--     VARCHAR2(200),
                MADR_VILL,--     VARCHAR2(200),
                MADR_VILC,--     VARCHAR2(200),
                MADR_CPOS,--     VARCHAR2(5),
                MADR_BPOS,--     VARCHAR2(200),
                MADR_PAYS,--     VARCHAR2(200),
                MADR_BATI,--     VARCHAR2(200),
                MADR_ESCA,--     VARCHAR2(200),
                MADR_ETAG,--     VARCHAR2(200),
                MADR_APPT,--     VARCHAR2(200),
                MADR_SEQ,--      VARCHAR2(200),
                MADR_GPSX,--     NUMBER,
                MADR_GPSY,--     NUMBER,
                MADR_GPSZ,--     NUMBER,
                MADR_VILINSEE,-- VARCHAR2(5),
                MADR_RUEINSEE,-- VARCHAR2(5),
                LIV,--           VARCHAR2(100),
                FAC,--           VARCHAR2(100),
                BRANCH--         VARCHAR2(100)
              )
         VALUES(      'DIST'||v_district,
              V_AD_NUM_,                         -- AD_NUM  NUMBER(10)  N      IDENTIFIANT DE L'ADRESSE POUR LA MIGRATION
              NULL,                              --MADR_REFRUE   VARCHAR2(100),
              NULL,                              --MADR_NRUE     VARCHAR2(8),
              NULL,                              --MADR_IRUE     VARCHAR2(10),
              V_ADRESSE_,                        --MADR_RUE1     VARCHAR2(200),
              NULL,                              --MADR_RUE2     VARCHAR2(200),
              V_NOM_VIL,               --MADR_VILL     VARCHAR2(200),
              NULL,                              --MADR_VILC     VARCHAR2(200),
              V_CODE_POSTAL_,                    --MADR_CPOS     VARCHAR2(5),
              NULL,                              --MADR_BPOS     VARCHAR2(200),
              'TUNISIE',                          --MADR_PAYS     VARCHAR2(200),
              NULL,                              --MADR_BATI     VARCHAR2(200),
              NULL,                              --MADR_ESCA     VARCHAR2(200),
              NULL,                              --MADR_ETAG     VARCHAR2(200),
              NULL,                              --MADR_APPT     VARCHAR2(200),
              NULL,                              --MADR_SEQ      VARCHAR2(200),
              NULL,                              --MADR_GPSX     NUMBER,
              NULL,                              --MADR_GPSY     NUMBER,
              NULL,                              --MADR_GPSZ     NUMBER,
              NULL,                              --MADR_VILINSEE VARCHAR2(5),
              NULL,                              --MADR_RUEINSEE VARCHAR2(5),
              NULL,                              --LIV           VARCHAR2(100),
              NULL,                              --FAC           VARCHAR2(100),
              NULL                              --BRANCH        VARCHAR2(100)
              );
               COMMIT;
exception
          when others then
            err_code := SQLCODE;
            err_msg  := SUBSTR(SQLERRM, 1, 200);
            insert into prob_migration
              (nom_table, val_ref, sql_err, date_pro)
            values
              (1,
               1,
               err_code || '--' || err_msg,
               sysdate);

        end;
     ELSE
       V_AD_NUM_ := NULL;
     END IF;
     commit;
  END;
  END miwtADRESSEPIVOT;
/

prompt
prompt Creating package body PCK_MIG_FACTURE
prompt =====================================
prompt
create or replace package body PCK_MIG_FACTURE is

  -- Private type declarations
   procedure MIWT_FACTURE_AS400 (v_district in varchar2) is

    err_code        varchar2(200);
    err_msg         varchar2(200);
    x  number;
    V_FAC_NUM       number;
    V_FAC_RESTANTDU  number;
    V_FAC_DATECALCUL date;
    V_FAC_DATELIM date;
    V_FAC_ABN_NUM    number(20);
    v_ref_releve      number;
    V_TRAIN_FACT       varchar2(200);
    V_REF_ABN          varchar2(200);
    nbr_trt            number := 0;
    v_ID_FACTURE       varchar2(20);
    annee_             number(4);
    periode_           number;
    version            number(1) := 0;
    date_              date;
    tiers_             varchar2(1);
    six_               varchar2(1);
  begin

    --**************************************************
     delete prob_migration where
              nom_table in
              ('miwtfacture','SEQ_RELEVE','miwtfactureligne');
    V_FAC_NUM        := 0;
      update  miwtreleve  set mrel_fact1 = null
                         where mrel_fact1  is not null;
    select max(to_number(MFAE_REF))  into V_FAC_NUM from miwtfactureentete WHERE MFAE_SOURCE= 'DIST'||v_district;
    select max(to_number(MREL_REF)) into v_ref_releve FROM miwtreleve where MREL_SOURCE = 'DIST'||v_district;
    COMMIT;

    for facture_ in (select * from facture_as400 WHERE dist=v_district) loop
     V_FAC_NUM        := nvl(V_FAC_NUM,0) +1;
      -- reception de date Facturation
       select last_day(to_date('01'||lpad(facture_.refc03,2,0)||facture_.refc04,'ddmmyy')) into date_
                              from dual;
       begin
       select TRIM,tier,six into periode_,tiers_,six_ from param_tournee where DISTRICT=facture_.dist
                                                     And m1 =facture_.refc01
                                                     And m2 = facture_.refc02
                                                     And m3 = facture_.refc03
                              and (TIER,SIX) in (select NTIERS,NSIXIEME from tourne
                                                 where code=lpad(facture_.tou,3,'0'));
        exception
          when others then
            err_code := SQLCODE;
            err_msg  := SUBSTR(SQLERRM, 1, 200);
            insert into prob_migration
              (nom_table, val_ref, sql_err, date_pro)
            values
              ('miwtfacture','Tourne '||facture_.tou||'M1 :'||facture_.refc01||'M2 :'||facture_.refc02||'M3:'||facture_.refc03,
                 err_msg ||'-- periode ',sysdate);
          periode_ := 1;
        end;

      annee_ :=to_char(date_,'yyyy');
      V_FAC_RESTANTDU  := null;
      V_FAC_DATECALCUL := null;
      V_FAC_DATELIM    :=null;
      V_FAC_ABN_NUM    := null;
      begin
          select to_date(lpad(ltrim(rtrim(DATEEXP)),8,'0'),'ddmmyyyy'),
                 to_date(lpad(ltrim(rtrim(DATL)),8,'0'),'ddmmyyyy')    into
                 V_FAC_DATECALCUL,V_FAC_DATELIM from role_trim
                     where to_number(facture_.pol)=POLICE
                     AND ltrim(rtrim(fACTURE_.Dist)) = ltrim(rtrim(DISTR))
                     And ltrim(rtrim(facture_.tou )) =ltrim(rtrim(TOUR))
                     And ltrim(rtrim(facture_.ord))  =ltrim(rtrim(ORDR))
                     And ltrim(rtrim(facture_.cat))  =ltrim(rtrim(categ))
                     And ltrim(rtrim(tiers_)) = nvl(ltrim(rtrim(tiers)),ltrim(rtrim(tiers_)))
                     And ltrim(rtrim(periode_)) = nvl(ltrim(rtrim(trim)), ltrim(rtrim(periode_)))
                     And ltrim(rtrim(six_ )) = nvl(ltrim(rtrim(six)),ltrim(rtrim(six_ )))
                     AND annee between annee_ - 1 and annee_
                     AND rownum = 1;
            exception
          when others then
            err_code := SQLCODE;
            err_msg  := SUBSTR(SQLERRM, 1, 200);
            insert into prob_migration
              (nom_table, val_ref, sql_err, date_pro)
            values
              ('miwtfacture','Date facture  pol:'||facture_.pol||'tour:'||facture_.tou||'M1 :'
               ||facture_.refc01||'M2 :'||facture_.refc02||'M3:'||facture_.refc03||'A:'||facture_.refc04||
               'ord :'||facture_.ord||'cat:'||facture_.cat||'tier:'||tiers_||'trim:'||periode_||'sim:'||six_,
                 err_msg ||'-- periode ',sysdate);

      end;
      if V_FAC_DATECALCUL is null then
      BEGIN
      select (r.mrel_date+1) INTO  V_FAC_DATECALCUL from  miwtreleve r
             where r.mrel_refpdl =
              lpad(facture_.DIST,2,'0')||
              lpad(facture_.tou,3,'0')||
              lpad(facture_.ORD,3,'0')||
              lpad(facture_.POL,5,'0')
              And mrel_refpdl is not null
               and   r.annee = annee_
               and   r.periode = periode_
               And rownum=1;
               Exception  when others then
               V_FAC_DATECALCUL := date_;
            end;
       V_FAC_DATELIM := V_FAC_DATECALCUL;
      end if;
        -- reception de l'identfiant de l'abonnement
        V_REF_ABN := ltrim(rtrim(facture_.DIST)) ||
                     lpad(to_char(facture_.pol),5,'0') ||
                     lpad(ltrim(rtrim(facture_.tou)),3,'0') ||
                     lpad(ltrim(rtrim(facture_.ORD)),3,'0');
        V_TRAIN_FACT :=  ltrim(rtrim(annee_)) ||
                         lpad(to_char(periode_),2,'0');
        v_ID_FACTURE:=ltrim(rtrim(facture_.DIST)) ||
                    lpad(ltrim(rtrim(facture_.tou)),3,'0') ||
                     lpad(ltrim(rtrim(facture_.ORD)),3,'0')||
                     to_char(annee_) ||
                     lpad(to_char(periode_),2,'0')||to_char(version);
         select count(*) into nbr_trt from miwtfactureentete where MFAE_RDET = v_ID_FACTURE
                                                               And MFAE_SOURCE = 'DIST'||v_district;
         if nbr_trt=1 then goto xx;  end if;
        for ref_abn_ in (select *
                           from miwabn a
                          where substr(a.abn_refsite,1,13) = lpad(facture_.dist,2,'0') ||
                        lpad(facture_.tou,3,'0') ||
                        lpad(facture_.ord,3,'0') ||
                        lpad(to_char(facture_.pol),5,'0')) loop
          V_FAC_ABN_NUM := ref_abn_.abn_ref;
        end loop;
        if V_FAC_ABN_NUM  is null then V_FAC_ABN_NUM := lpad(facture_.dist,2,'0') ||
                        lpad(facture_.tou,3,'0') ||
                        lpad(facture_.ord,3,'0') ||
                        lpad(facture_.pol,5,'0');
         end if;
        -- Insertion de la facture
        if facture_.ctarif='21' then facture_.tva:='0';    facture_.taxe:='0';  end if;
     --   if facture_.CAT='7'    then facture_.capit:='0';  facture_.inter:='0'; end if;
        begin
        insert into miwtfactureentete
        (
        MFAE_SOURCE,--1         VARCHAR2(100)  N      Code source/origine de la facture [OBL]
        MFAE_REF,   --2       VARCHAR2(100)  N      Identifiant unique de la facture pour la source [OBL]
        MFAE_REFTRF,--3     VARCHAR2(100)  Y      Identifiant du train de la facture
        MFAE_NUME,  --4       NUMBER(10)  Y      Numero de la facture [OBL]
        MFAE_RDET,  --5       VARCHAR2(15)  Y      RDET de la facture
        MFAE_CCMO,  --6       VARCHAR2(1)  Y      Cle controle RDET de la facture
        MFAE_DEDI,  --7       DATE  N      Date d edition de la facture [OBL]
        MFAE_DLPAI, --8     DATE  Y      Date limite de paiement de la facture [OBL]
        MFAE_DPREL,--9     DATE  Y      Date de prelevement de la facture [OBL]
        MFAE_TOTHTE,--10   NUMBER(10,2)  N      Total HT EAU de la facture [OBL]
        MFAE_TOTTVAE,--11   NUMBER(10,2)  N      Total TVA EAU de la facture [OBL]
        MFAE_TOTHTA,--12   NUMBER(10,2)  N      Total HT ASS de la facture [OBL]
        MFAE_TOTTVAA,--13   NUMBER(10,2)  N      Total TVA ASS de la facture [OBL]
        MFAE_SOLDE,--14     NUMBER(10,2)  Y      Solde TTC de la facture
        MFAE_TYPE,--15     VARCHAR2(2)  N  'R'
        MFAE_REFFAEDEDU,--16  VARCHAR2(100)  Y
        MFAE_REFABN,--17      VARCHAR2(100)  N      Identifiant du contrat de la facture [OBL]
        MFAE_REF_CODNIV_RELANCE,--18  VARCHAR2(100)  Y      Reference Code niveau de chainde relance
        MFAE_RIB_REF,--19              VARCHAR2(100)  Y      Reference Rib
        MFAE_RIB_ETAT,--20            NUMBER(1)  Y      Mode de payement (pr?l?vement 1 ou tip 2)
        MFAE_COMPTEAUX,--21            VARCHAR2(100)  Y      Compte auxilaire GENACCOUNT associe a la facture
        MFAE_REF_ORIGINE,--22          VARCHAR2(100)  Y      Facture origine
        MFAE_COMMENT,--23              VARCHAR2(4000)  Y      Commentaire libre Facture
        MFAE_AMOUNTTTCDEC,--24        NUMBER(17,10)  Y      Montant TTC a deduire
        VOC_MODEFACT,--25              VARCHAR2(10)  Y
        MFAE_REF_DEDUC,--26            VARCHAR2(100)  Y
        MFAE_REFORGA,--27              VARCHAR2(100)  Y
        MFAE_EXERCICE,--28            NUMBER(4)  Y      Exercice du role de la facture
        MFAE_NUMEROROLE,--29          NUMBER(4)  Y       Numero du role pour l exercice
        MFAE_PREL--30                  NUMBER  Y
         )
       values
       (
        'DIST'||v_district,               --1
        V_FAC_NUM,            --2
        V_TRAIN_FACT,         --3
        V_FAC_NUM,            --4
        v_ID_FACTURE,         --5
        NULL,                 --6
        V_FAC_DATECALCUL,     --7
        V_FAC_DATELIM,     --8
        V_FAC_DATECALCUL,     --9
        (facture_.net-(facture_.tva+facture_.taxe+facture_.arriere))/1000,   --10
        (facture_.tva+facture_.taxe)/1000,   --11
        0,                   --12
        0,                   --13
        (facture_.net-facture_.arriere)/1000,     --14
        'FC',                --15
        NULL,                --16
        V_FAC_ABN_NUM,       --17
        'INCONNUE',                --18
         null,                --19
        4,                --20
        'IMP_MIG',           --21
        null,                 --22
        V_REF_ABN,                 --23
        NULL,                 --24
        4,                   --25
        NULL,                 --26
        v_district,            --27
        annee_,               --28
        periode_,              --29
        1                  --30
        );
        exception
          when others then
            err_code := SQLCODE;
            err_msg  := SUBSTR(SQLERRM, 1, 200);
            insert into prob_migration
              (nom_table, val_ref, sql_err, date_pro)
            values
              ('miwtfacture',
               lpad(facture_.dist,2,'0') ||
               lpad(facture_.tou,3,'0') ||
               lpad(facture_.ord,3,'0') ||
               lpad(facture_.pol,5,'0'),
               err_code || '--' || err_msg,
               sysdate);
        end;
-------------------------------------------------------------------------------

--------------------------------------------------- LIGNE FACTURE CONSOMMATION SONNEDE
if to_number(facture_.montt1) <> 0 then
         begin
         insert into miwtfactureligne (
                MFAL_SOURCE,--  VARCHAR2(100)  N      Code source/origine de la ligne [OBL]
                MFAL_REFFAE,--  VARCHAR2(100)  N      Identifiant de la facture de la ligne [OBL]
                MFAL_REFTAP,--  VARCHAR2(100)  N      Identifiant de la periode de tarif de la ligne [OBL]
                MFAL_REFART,--  VARCHAR2(100)  Y
                MFAL_LIBE,--  VARCHAR2(200)  Y
                MFAL_NUM,--  NUMBER(4)  N
                MFAL_TRAN,--  NUMBER(1)  N  1    Tranche de la ligne [OBL]
                MFAL_EXER,--  NUMBER(4)  N      Annee exercice de la ligne [OBL]
                MFAL_VOLU,--  NUMBER(15,3)  N      Volume facture de la ligne [OBL]
                MFAL_PU,--  NUMBER(12,6)  N      P.U. facture de la ligne [OBL]
                MFAL_MTHT,--  NUMBER(15,2)  N      Montant HT de la ligne [OBL]
                MFAL_MTVA,--  NUMBER(15,2)  N      Montant TVA de la ligne [OBL]
                MFAL_TTVA,--  NUMBER(15,2)  N      Taux de TVA de la ligne [OBL]
                MFAL_MTTC,--  NUMBER(15,2)  N
                MFAL_DDEBPERFAC,--  DATE  Y      Date de debut de la periode facturee de la ligne
                MFAL_DFINPERFAC,--  DATE  Y      Date de fin de la periode facturee de la ligne
                MFAL_DETAIL--  NUMBER  Y
                )
                values
               ('DIST'||v_district,
                V_FAC_NUM,
                1,
                'CSM_STD',
                'consommation sonede 1ere Tranche',
                1,
                1,
                annee_,
                facture_.const1,
                facture_.tauxt1/1000,
                facture_.montt1/1000,
                facture_.taxe/1000,
                18,
                facture_.montt1/1000+(facture_.taxe/1000),
                null,
                DATE_,
                null );
           exception
          when others then
            err_code := SQLCODE;
            err_msg  := SUBSTR(SQLERRM, 1, 200);
            insert into prob_migration
              (nom_table, val_ref, sql_err, date_pro)
            values
              ('miwtfactureligne',
               V_FAC_NUM,
               err_code || '--' || err_msg,
               sysdate);
        end;
    end if;
if to_number(facture_.montt2) <> 0 then
         begin
         insert into miwtfactureligne (
                MFAL_SOURCE,--  VARCHAR2(100)  N      Code source/origine de la ligne [OBL]
                MFAL_REFFAE,--  VARCHAR2(100)  N      Identifiant de la facture de la ligne [OBL]
                MFAL_REFTAP,--  VARCHAR2(100)  N      Identifiant de la periode de tarif de la ligne [OBL]
                MFAL_REFART,--  VARCHAR2(100)  Y
                MFAL_LIBE,--  VARCHAR2(200)  Y
                MFAL_NUM,--  NUMBER(4)  N
                MFAL_TRAN,--  NUMBER(1)  N  1    Tranche de la ligne [OBL]
                MFAL_EXER,--  NUMBER(4)  N      Annee exercice de la ligne [OBL]
                MFAL_VOLU,--  NUMBER(15,3)  N      Volume facture de la ligne [OBL]
                MFAL_PU,--  NUMBER(12,6)  N      P.U. facture de la ligne [OBL]
                MFAL_MTHT,--  NUMBER(15,2)  N      Montant HT de la ligne [OBL]
                MFAL_MTVA,--  NUMBER(15,2)  N      Montant TVA de la ligne [OBL]
                MFAL_TTVA,--  NUMBER(15,2)  N      Taux de TVA de la ligne [OBL]
                MFAL_MTTC,--  NUMBER(15,2)  N
                MFAL_DDEBPERFAC,--  DATE  Y      Date de debut de la periode facturee de la ligne
                MFAL_DFINPERFAC,--  DATE  Y      Date de fin de la periode facturee de la ligne
                MFAL_DETAIL--  NUMBER  Y
                )
                values
               ('DIST'||v_district,
                V_FAC_NUM,
                1,
                'CSM_STD',
                'consommation sonede 2eme Tranche',
                2,
                2,
                annee_,
                 facture_.const2,
                facture_.tauxt2/1000,
                facture_.montt2/1000,
                 facture_.taxe/1000,
                18,
                facture_.montt2/1000+(facture_.taxe/1000),
                null,
                DATE_,
                null );
           exception
          when others then
            err_code := SQLCODE;
            err_msg  := SUBSTR(SQLERRM, 1, 200);
            insert into prob_migration
              (nom_table, val_ref, sql_err, date_pro)
            values
              ('miwtfactureligne',
               V_FAC_NUM,
               err_code || '--' || err_msg,
               sysdate);
        end;
    end if;
    if to_number(facture_.montt3) <> 0 then
         begin
         insert into miwtfactureligne (
                MFAL_SOURCE,--  VARCHAR2(100)  N      Code source/origine de la ligne [OBL]
                MFAL_REFFAE,--  VARCHAR2(100)  N      Identifiant de la facture de la ligne [OBL]
                MFAL_REFTAP,--  VARCHAR2(100)  N      Identifiant de la periode de tarif de la ligne [OBL]
                MFAL_REFART,--  VARCHAR2(100)  Y
                MFAL_LIBE,--  VARCHAR2(200)  Y
                MFAL_NUM,--  NUMBER(4)  N
                MFAL_TRAN,--  NUMBER(1)  N  1    Tranche de la ligne [OBL]
                MFAL_EXER,--  NUMBER(4)  N      Annee exercice de la ligne [OBL]
                MFAL_VOLU,--  NUMBER(15,3)  N      Volume facture de la ligne [OBL]
                MFAL_PU,--  NUMBER(12,6)  N      P.U. facture de la ligne [OBL]
                MFAL_MTHT,--  NUMBER(15,2)  N      Montant HT de la ligne [OBL]
                MFAL_MTVA,--  NUMBER(15,2)  N      Montant TVA de la ligne [OBL]
                MFAL_TTVA,--  NUMBER(15,2)  N      Taux de TVA de la ligne [OBL]
                MFAL_MTTC,--  NUMBER(15,2)  N
                MFAL_DDEBPERFAC,--  DATE  Y      Date de debut de la periode facturee de la ligne
                MFAL_DFINPERFAC,--  DATE  Y      Date de fin de la periode facturee de la ligne
                MFAL_DETAIL--  NUMBER  Y
                )
                values
               ('DIST'||v_district,
                V_FAC_NUM,
                1,
                'CSM_STD',
                'consommation sonede 3eme Tranche',
                3,
                3,
                annee_,
                 facture_.const3,
                facture_.tauxt3/1000,
                facture_.montt3/1000,
                 facture_.taxe/1000,
                18,
                facture_.montt3/1000+(facture_.taxe/1000),
                null,
                DATE_,
                null );
           exception
          when others then
            err_code := SQLCODE;
            err_msg  := SUBSTR(SQLERRM, 1, 200);
            insert into prob_migration
              (nom_table, val_ref, sql_err, date_pro)
            values
              ('miwtfactureligne',
               V_FAC_NUM,
               err_code || '--' || err_msg,
               sysdate);
        end;
    end if;
    --------------------------------------------------- LIGNE FACTURE CONSOMMATION ONAS
if to_number(facture_.mon1) <> 0 then
         begin
         insert into miwtfactureligne (
                MFAL_SOURCE,--  VARCHAR2(100)  N      Code source/origine de la ligne [OBL]
                MFAL_REFFAE,--  VARCHAR2(100)  N      Identifiant de la facture de la ligne [OBL]
                MFAL_REFTAP,--  VARCHAR2(100)  N      Identifiant de la periode de tarif de la ligne [OBL]
                MFAL_REFART,--  VARCHAR2(100)  Y
                MFAL_LIBE,--  VARCHAR2(200)  Y
                MFAL_NUM,--  NUMBER(4)  N
                MFAL_TRAN,--  NUMBER(1)  N  1    Tranche de la ligne [OBL]
                MFAL_EXER,--  NUMBER(4)  N      Annee exercice de la ligne [OBL]
                MFAL_VOLU,--  NUMBER(15,3)  N      Volume facture de la ligne [OBL]
                MFAL_PU,--  NUMBER(12,6)  N      P.U. facture de la ligne [OBL]
                MFAL_MTHT,--  NUMBER(15,2)  N      Montant HT de la ligne [OBL]
                MFAL_MTVA,--  NUMBER(15,2)  N      Montant TVA de la ligne [OBL]
                MFAL_TTVA,--  NUMBER(15,2)  N      Taux de TVA de la ligne [OBL]
                MFAL_MTTC,--  NUMBER(15,2)  N
                MFAL_DDEBPERFAC,--  DATE  Y      Date de debut de la periode facturee de la ligne
                MFAL_DFINPERFAC,--  DATE  Y      Date de fin de la periode facturee de la ligne
                MFAL_DETAIL--  NUMBER  Y
                )
                values
               ('DIST'||v_district,
                V_FAC_NUM,
                2,
                'VAR_ONAS_1',
                'Redevance onas 1ere Tranche',
                4,
                1,
                annee_,
                facture_.volon1,
                facture_.tauon1/1000,
                facture_.mon1/1000,
                0,
                0,
                facture_.mon1/1000,
                null,
                DATE_,
                null );
           exception
          when others then
            err_code := SQLCODE;
            err_msg  := SUBSTR(SQLERRM, 1, 200);
            insert into prob_migration
              (nom_table, val_ref, sql_err, date_pro)
            values
              ('miwtfactureligne',
               V_FAC_NUM,
               err_code || '--' || err_msg,
               sysdate);
        end;
    end if;
if to_number(facture_.mon2) <> 0 then
         begin
         insert into miwtfactureligne (
                MFAL_SOURCE,--  VARCHAR2(100)  N      Code source/origine de la ligne [OBL]
                MFAL_REFFAE,--  VARCHAR2(100)  N      Identifiant de la facture de la ligne [OBL]
                MFAL_REFTAP,--  VARCHAR2(100)  N      Identifiant de la periode de tarif de la ligne [OBL]
                MFAL_REFART,--  VARCHAR2(100)  Y
                MFAL_LIBE,--  VARCHAR2(200)  Y
                MFAL_NUM,--  NUMBER(4)  N
                MFAL_TRAN,--  NUMBER(1)  N  1    Tranche de la ligne [OBL]
                MFAL_EXER,--  NUMBER(4)  N      Annee exercice de la ligne [OBL]
                MFAL_VOLU,--  NUMBER(15,3)  N      Volume facture de la ligne [OBL]
                MFAL_PU,--  NUMBER(12,6)  N      P.U. facture de la ligne [OBL]
                MFAL_MTHT,--  NUMBER(15,2)  N      Montant HT de la ligne [OBL]
                MFAL_MTVA,--  NUMBER(15,2)  N      Montant TVA de la ligne [OBL]
                MFAL_TTVA,--  NUMBER(15,2)  N      Taux de TVA de la ligne [OBL]
                MFAL_MTTC,--  NUMBER(15,2)  N
                MFAL_DDEBPERFAC,--  DATE  Y      Date de debut de la periode facturee de la ligne
                MFAL_DFINPERFAC,--  DATE  Y      Date de fin de la periode facturee de la ligne
                MFAL_DETAIL--  NUMBER  Y
                )
                values
               ('DIST'||v_district,
                V_FAC_NUM,
                2,
                'VAR_ONAS_1',
                'Redevance onas 2eme Tranche',
                5,
                2,
                annee_,
                facture_.volon2,
                facture_.tauon2/1000,
                facture_.mon2/1000,
                0,
                0,
                facture_.mon2/1000,
                null,
                DATE_,
                null );
           exception
          when others then
            err_code := SQLCODE;
            err_msg  := SUBSTR(SQLERRM, 1, 200);
            insert into prob_migration
              (nom_table, val_ref, sql_err, date_pro)
            values
              ('miwtfactureligne',
               V_FAC_NUM,
               err_code || '--' || err_msg,
               sysdate);
        end;
    end if;
    if to_number(facture_.mon3) <> 0 then
         begin
         insert into miwtfactureligne (
                MFAL_SOURCE,--  VARCHAR2(100)  N      Code source/origine de la ligne [OBL]
                MFAL_REFFAE,--  VARCHAR2(100)  N      Identifiant de la facture de la ligne [OBL]
                MFAL_REFTAP,--  VARCHAR2(100)  N      Identifiant de la periode de tarif de la ligne [OBL]
                MFAL_REFART,--  VARCHAR2(100)  Y
                MFAL_LIBE,--  VARCHAR2(200)  Y
                MFAL_NUM,--  NUMBER(4)  N
                MFAL_TRAN,--  NUMBER(1)  N  1    Tranche de la ligne [OBL]
                MFAL_EXER,--  NUMBER(4)  N      Annee exercice de la ligne [OBL]
                MFAL_VOLU,--  NUMBER(15,3)  N      Volume facture de la ligne [OBL]
                MFAL_PU,--  NUMBER(12,6)  N      P.U. facture de la ligne [OBL]
                MFAL_MTHT,--  NUMBER(15,2)  N      Montant HT de la ligne [OBL]
                MFAL_MTVA,--  NUMBER(15,2)  N      Montant TVA de la ligne [OBL]
                MFAL_TTVA,--  NUMBER(15,2)  N      Taux de TVA de la ligne [OBL]
                MFAL_MTTC,--  NUMBER(15,2)  N
                MFAL_DDEBPERFAC,--  DATE  Y      Date de debut de la periode facturee de la ligne
                MFAL_DFINPERFAC,--  DATE  Y      Date de fin de la periode facturee de la ligne
                MFAL_DETAIL--  NUMBER  Y
                )
                values
               ('DIST'||v_district,
                V_FAC_NUM,
                2,
                'VAR_ONAS_1',
                'Redevance onas 3eme Tranche',
                6,
                3,
                annee_,
                 facture_.volon3,
                facture_.tauon3/1000,
                facture_.mon3/1000,
                0,
                0,
                facture_.mon3/1000,
                null,
                DATE_,
                null );
           exception
          when others then
            err_code := SQLCODE;
            err_msg  := SUBSTR(SQLERRM, 1, 200);
            insert into prob_migration
              (nom_table, val_ref, sql_err, date_pro)
            values
              ('miwtfactureligne',
               V_FAC_NUM,
               err_code || '--' || err_msg,
               sysdate);
        end;
    end if;
     if to_number(facture_.fixonas) <> 0 then
         begin
         insert into miwtfactureligne (
                MFAL_SOURCE,--  VARCHAR2(100)  N      Code source/origine de la ligne [OBL]
                MFAL_REFFAE,--  VARCHAR2(100)  N      Identifiant de la facture de la ligne [OBL]
                MFAL_REFTAP,--  VARCHAR2(100)  N      Identifiant de la periode de tarif de la ligne [OBL]
                MFAL_REFART,--  VARCHAR2(100)  Y
                MFAL_LIBE,--  VARCHAR2(200)  Y
                MFAL_NUM,--  NUMBER(4)  N
                MFAL_TRAN,--  NUMBER(1)  N  1    Tranche de la ligne [OBL]
                MFAL_EXER,--  NUMBER(4)  N      Annee exercice de la ligne [OBL]
                MFAL_VOLU,--  NUMBER(15,3)  N      Volume facture de la ligne [OBL]
                MFAL_PU,--  NUMBER(12,6)  N      P.U. facture de la ligne [OBL]
                MFAL_MTHT,--  NUMBER(15,2)  N      Montant HT de la ligne [OBL]
                MFAL_MTVA,--  NUMBER(15,2)  N      Montant TVA de la ligne [OBL]
                MFAL_TTVA,--  NUMBER(15,2)  N      Taux de TVA de la ligne [OBL]
                MFAL_MTTC,--  NUMBER(15,2)  N
                MFAL_DDEBPERFAC,--  DATE  Y      Date de debut de la periode facturee de la ligne
                MFAL_DFINPERFAC,--  DATE  Y      Date de fin de la periode facturee de la ligne
                MFAL_DETAIL--  NUMBER  Y
                )
                values
               ('DIST'||v_district,
                V_FAC_NUM,
                2,
                'FIXE_ONAS_1',
                'Frais fixe onas',
                7,
                1,
                annee_,
                1,
                facture_.fixonas/1000,
                facture_.fixonas/1000,
                0,
                0,
                facture_.fixonas/1000,
                null,
                DATE_,
                null );
           exception
          when others then
            err_code := SQLCODE;
            err_msg  := SUBSTR(SQLERRM, 1, 200);
            insert into prob_migration
              (nom_table, val_ref, sql_err, date_pro)
            values
              ('miwtfactureligne',
               V_FAC_NUM,
               err_code || '--' || err_msg,
               sysdate);
        end;
    end if;
     if to_number(facture_.FRLETTRE) <> 0 then
         begin
         insert into miwtfactureligne (
                MFAL_SOURCE,--  VARCHAR2(100)  N      Code source/origine de la ligne [OBL]
                MFAL_REFFAE,--  VARCHAR2(100)  N      Identifiant de la facture de la ligne [OBL]
                MFAL_REFTAP,--  VARCHAR2(100)  N      Identifiant de la periode de tarif de la ligne [OBL]
                MFAL_REFART,--  VARCHAR2(100)  Y
                MFAL_LIBE,--  VARCHAR2(200)  Y
                MFAL_NUM,--  NUMBER(4)  N
                MFAL_TRAN,--  NUMBER(1)  N  1    Tranche de la ligne [OBL]
                MFAL_EXER,--  NUMBER(4)  N      Annee exercice de la ligne [OBL]
                MFAL_VOLU,--  NUMBER(15,3)  N      Volume facture de la ligne [OBL]
                MFAL_PU,--  NUMBER(12,6)  N      P.U. facture de la ligne [OBL]
                MFAL_MTHT,--  NUMBER(15,2)  N      Montant HT de la ligne [OBL]
                MFAL_MTVA,--  NUMBER(15,2)  N      Montant TVA de la ligne [OBL]
                MFAL_TTVA,--  NUMBER(15,2)  N      Taux de TVA de la ligne [OBL]
                MFAL_MTTC,--  NUMBER(15,2)  N
                MFAL_DDEBPERFAC,--  DATE  Y      Date de debut de la periode facturee de la ligne
                MFAL_DFINPERFAC,--  DATE  Y      Date de fin de la periode facturee de la ligne
                MFAL_DETAIL--  NUMBER  Y
                )
                values
               ('DIST'||v_district,
                V_FAC_NUM,
                1,
                'FRS_R_C_NN_PAY',
                'Frais lettre ',
                8,
                1,
                annee_,
                1,
                1.900,
                1.900,
                0,
                0,
                1.900,
                null,
                DATE_,
                null );
           exception
          when others then
            err_code := SQLCODE;
            err_msg  := SUBSTR(SQLERRM, 1, 200);
            insert into prob_migration
              (nom_table, val_ref, sql_err, date_pro)
            values
              ('miwtfactureligne',
               V_FAC_NUM,
               err_code || '--' || err_msg,
               sysdate);
        end;
    end if;
      if to_number(facture_.fraisctr) <> 0 then
         begin
         insert into miwtfactureligne (
                MFAL_SOURCE,--  VARCHAR2(100)  N      Code source/origine de la ligne [OBL]
                MFAL_REFFAE,--  VARCHAR2(100)  N      Identifiant de la facture de la ligne [OBL]
                MFAL_REFTAP,--  VARCHAR2(100)  N      Identifiant de la periode de tarif de la ligne [OBL]
                MFAL_REFART,--  VARCHAR2(100)  Y
                MFAL_LIBE,--  VARCHAR2(200)  Y
                MFAL_NUM,--  NUMBER(4)  N
                MFAL_TRAN,--  NUMBER(1)  N  1    Tranche de la ligne [OBL]
                MFAL_EXER,--  NUMBER(4)  N      Annee exercice de la ligne [OBL]
                MFAL_VOLU,--  NUMBER(15,3)  N      Volume facture de la ligne [OBL]
                MFAL_PU,--  NUMBER(12,6)  N      P.U. facture de la ligne [OBL]
                MFAL_MTHT,--  NUMBER(15,2)  N      Montant HT de la ligne [OBL]
                MFAL_MTVA,--  NUMBER(15,2)  N      Montant TVA de la ligne [OBL]
                MFAL_TTVA,--  NUMBER(15,2)  N      Taux de TVA de la ligne [OBL]
                MFAL_MTTC,--  NUMBER(15,2)  N
                MFAL_DDEBPERFAC,--  DATE  Y      Date de debut de la periode facturee de la ligne
                MFAL_DFINPERFAC,--  DATE  Y      Date de fin de la periode facturee de la ligne
                MFAL_DETAIL--  NUMBER  Y
                )
                values
               ('DIST'||v_district,
                V_FAC_NUM,
                1,
                'FRS_FIX_CSM',
                'Frais fixe sonnede',
                9,
                1,
                annee_,
                1,
                facture_.fraisctr/1000,
                facture_.fraisctr/1000,
                facture_.TVA/1000,
                18,
                facture_.fraisctr/1000+(facture_.TVA/1000),
                null,
                DATE_,
                null );
           exception
          when others then
            err_code := SQLCODE;
            err_msg  := SUBSTR(SQLERRM, 1, 200);
            insert into prob_migration
              (nom_table, val_ref, sql_err, date_pro)
            values
              ('miwtfactureligne',
               V_FAC_NUM,
               err_code || '--' || err_msg,
               sysdate);
        end;
    end if;
     if to_number(facture_.FRferm) <> 0 then
         begin
         insert into miwtfactureligne (
                MFAL_SOURCE,--  VARCHAR2(100)  N      Code source/origine de la ligne [OBL]
                MFAL_REFFAE,--  VARCHAR2(100)  N      Identifiant de la facture de la ligne [OBL]
                MFAL_REFTAP,--  VARCHAR2(100)  N      Identifiant de la periode de tarif de la ligne [OBL]
                MFAL_REFART,--  VARCHAR2(100)  Y
                MFAL_LIBE,--  VARCHAR2(200)  Y
                MFAL_NUM,--  NUMBER(4)  N
                MFAL_TRAN,--  NUMBER(1)  N  1    Tranche de la ligne [OBL]
                MFAL_EXER,--  NUMBER(4)  N      Annee exercice de la ligne [OBL]
                MFAL_VOLU,--  NUMBER(15,3)  N      Volume facture de la ligne [OBL]
                MFAL_PU,--  NUMBER(12,6)  N      P.U. facture de la ligne [OBL]
                MFAL_MTHT,--  NUMBER(15,2)  N      Montant HT de la ligne [OBL]
                MFAL_MTVA,--  NUMBER(15,2)  N      Montant TVA de la ligne [OBL]
                MFAL_TTVA,--  NUMBER(15,2)  N      Taux de TVA de la ligne [OBL]
                MFAL_MTTC,--  NUMBER(15,2)  N
                MFAL_DDEBPERFAC,--  DATE  Y      Date de debut de la periode facturee de la ligne
                MFAL_DFINPERFAC,--  DATE  Y      Date de fin de la periode facturee de la ligne
                MFAL_DETAIL--  NUMBER  Y
                )
                values
               ('DIST'||v_district,
                V_FAC_NUM,
                1,
                'FRS_FIX_PAVI_CPR',
                'Frais FERMETURE',
                10,
                1,
                annee_,
                1,
                facture_.FRFERM/1000,
                facture_.FRFERM/1000,
                0,
                0,
                facture_.FRFERM/1000,
                null,
                DATE_,
                null );
           exception
          when others then
            err_code := SQLCODE;
            err_msg  := SUBSTR(SQLERRM, 1, 200);
            insert into prob_migration
              (nom_table, val_ref, sql_err, date_pro)
            values
              ('miwtfactureligne',
               V_FAC_NUM,
               err_code || '--' || err_msg,
               sysdate);
        end;
    end if;
     if to_number(facture_.CAPIT) <> 0 then
         begin
         insert into miwtfactureligne (
                MFAL_SOURCE,--  VARCHAR2(100)  N      Code source/origine de la ligne [OBL]
                MFAL_REFFAE,--  VARCHAR2(100)  N      Identifiant de la facture de la ligne [OBL]
                MFAL_REFTAP,--  VARCHAR2(100)  N      Identifiant de la periode de tarif de la ligne [OBL]
                MFAL_REFART,--  VARCHAR2(100)  Y
                MFAL_LIBE,--  VARCHAR2(200)  Y
                MFAL_NUM,--  NUMBER(4)  N
                MFAL_TRAN,--  NUMBER(1)  N  1    Tranche de la ligne [OBL]
                MFAL_EXER,--  NUMBER(4)  N      Annee exercice de la ligne [OBL]
                MFAL_VOLU,--  NUMBER(15,3)  N      Volume facture de la ligne [OBL]
                MFAL_PU,--  NUMBER(12,6)  N      P.U. facture de la ligne [OBL]
                MFAL_MTHT,--  NUMBER(15,2)  N      Montant HT de la ligne [OBL]
                MFAL_MTVA,--  NUMBER(15,2)  N      Montant TVA de la ligne [OBL]
                MFAL_TTVA,--  NUMBER(15,2)  N      Taux de TVA de la ligne [OBL]
                MFAL_MTTC,--  NUMBER(15,2)  N
                MFAL_DDEBPERFAC,--  DATE  Y      Date de debut de la periode facturee de la ligne
                MFAL_DFINPERFAC,--  DATE  Y      Date de fin de la periode facturee de la ligne
                MFAL_DETAIL--  NUMBER  Y
                )
                values
               ('DIST'||v_district,
                V_FAC_NUM,
                2,
                'CAPITAL',
                'Montant capital',
                11,
                1,
                annee_,
                1,
                facture_.CAPIT/1000,
                facture_.CAPIT/1000,
                0,
                0,
                facture_.CAPIT/1000,
                null,
                DATE_,
                null );
           exception
          when others then
            err_code := SQLCODE;
            err_msg  := SUBSTR(SQLERRM, 1, 200);
            insert into prob_migration
              (nom_table, val_ref, sql_err, date_pro)
            values
              ('miwtfactureligne',
               V_FAC_NUM,
               err_code || '--' || err_msg,
               sysdate);
        end;
    end if;
     if to_number(facture_.INTER) <> 0 then
         begin
         insert into miwtfactureligne (
                MFAL_SOURCE,--  VARCHAR2(100)  N      Code source/origine de la ligne [OBL]
                MFAL_REFFAE,--  VARCHAR2(100)  N      Identifiant de la facture de la ligne [OBL]
                MFAL_REFTAP,--  VARCHAR2(100)  N      Identifiant de la periode de tarif de la ligne [OBL]
                MFAL_REFART,--  VARCHAR2(100)  Y
                MFAL_LIBE,--  VARCHAR2(200)  Y
                MFAL_NUM,--  NUMBER(4)  N
                MFAL_TRAN,--  NUMBER(1)  N  1    Tranche de la ligne [OBL]
                MFAL_EXER,--  NUMBER(4)  N      Annee exercice de la ligne [OBL]
                MFAL_VOLU,--  NUMBER(15,3)  N      Volume facture de la ligne [OBL]
                MFAL_PU,--  NUMBER(12,6)  N      P.U. facture de la ligne [OBL]
                MFAL_MTHT,--  NUMBER(15,2)  N      Montant HT de la ligne [OBL]
                MFAL_MTVA,--  NUMBER(15,2)  N      Montant TVA de la ligne [OBL]
                MFAL_TTVA,--  NUMBER(15,2)  N      Taux de TVA de la ligne [OBL]
                MFAL_MTTC,--  NUMBER(15,2)  N
                MFAL_DDEBPERFAC,--  DATE  Y      Date de debut de la periode facturee de la ligne
                MFAL_DFINPERFAC,--  DATE  Y      Date de fin de la periode facturee de la ligne
                MFAL_DETAIL--  NUMBER  Y
                )
                values
               ('DIST'||v_district,
                V_FAC_NUM,
                2,
                'INTERET',
                'Montant Interet',
                12,
                1,
                annee_,
                1,
                facture_.INTER/1000,
                facture_.INTER/1000,
                0,
                0,
                facture_.INTER/1000,
                null,
                DATE_,
                null );
           exception
          when others then
            err_code := SQLCODE;
            err_msg  := SUBSTR(SQLERRM, 1, 200);
            insert into prob_migration
              (nom_table, val_ref, sql_err, date_pro)
            values
              ('miwtfactureligne',
               V_FAC_NUM,
               err_code || '--' || err_msg,
               sysdate);
        end;
    end if;

     if to_number(facture_.RBRANCHE) <> 0 then
         begin
         insert into miwtfactureligne (
                MFAL_SOURCE,--  VARCHAR2(100)  N      Code source/origine de la ligne [OBL]
                MFAL_REFFAE,--  VARCHAR2(100)  N      Identifiant de la facture de la ligne [OBL]
                MFAL_REFTAP,--  VARCHAR2(100)  N      Identifiant de la periode de tarif de la ligne [OBL]
                MFAL_REFART,--  VARCHAR2(100)  Y
                MFAL_LIBE,--  VARCHAR2(200)  Y
                MFAL_NUM,--  NUMBER(4)  N
                MFAL_TRAN,--  NUMBER(1)  N  1    Tranche de la ligne [OBL]
                MFAL_EXER,--  NUMBER(4)  N      Annee exercice de la ligne [OBL]
                MFAL_VOLU,--  NUMBER(15,3)  N      Volume facture de la ligne [OBL]
                MFAL_PU,--  NUMBER(12,6)  N      P.U. facture de la ligne [OBL]
                MFAL_MTHT,--  NUMBER(15,2)  N      Montant HT de la ligne [OBL]
                MFAL_MTVA,--  NUMBER(15,2)  N      Montant TVA de la ligne [OBL]
                MFAL_TTVA,--  NUMBER(15,2)  N      Taux de TVA de la ligne [OBL]
                MFAL_MTTC,--  NUMBER(15,2)  N
                MFAL_DDEBPERFAC,--  DATE  Y      Date de debut de la periode facturee de la ligne
                MFAL_DFINPERFAC,--  DATE  Y      Date de fin de la periode facturee de la ligne
                MFAL_DETAIL--  NUMBER  Y
                )
                values
               ('DIST'||v_district,
                V_FAC_NUM,
                1,
                'COURETABBR',
                'Montant branchement',
                13,
                1,
                annee_,
                1,
                facture_.RBRANCHE/1000,
                facture_.RBRANCHE/1000,
                0,
                0,
                facture_.RBRANCHE/1000,
                null,
                DATE_,
                null );
           exception
          when others then
            err_code := SQLCODE;
            err_msg  := SUBSTR(SQLERRM, 1, 200);
            insert into prob_migration
              (nom_table, val_ref, sql_err, date_pro)
            values
              ('miwtfactureligne',
               V_FAC_NUM,
               err_code || '--' || err_msg,
               sysdate);
        end;
    end if;
     if to_number(facture_.RFACADE) <> 0 then
         begin
         insert into miwtfactureligne (
                MFAL_SOURCE,--  VARCHAR2(100)  N      Code source/origine de la ligne [OBL]
                MFAL_REFFAE,--  VARCHAR2(100)  N      Identifiant de la facture de la ligne [OBL]
                MFAL_REFTAP,--  VARCHAR2(100)  N      Identifiant de la periode de tarif de la ligne [OBL]
                MFAL_REFART,--  VARCHAR2(100)  Y
                MFAL_LIBE,--  VARCHAR2(200)  Y
                MFAL_NUM,--  NUMBER(4)  N
                MFAL_TRAN,--  NUMBER(1)  N  1    Tranche de la ligne [OBL]
                MFAL_EXER,--  NUMBER(4)  N      Annee exercice de la ligne [OBL]
                MFAL_VOLU,--  NUMBER(15,3)  N      Volume facture de la ligne [OBL]
                MFAL_PU,--  NUMBER(12,6)  N      P.U. facture de la ligne [OBL]
                MFAL_MTHT,--  NUMBER(15,2)  N      Montant HT de la ligne [OBL]
                MFAL_MTVA,--  NUMBER(15,2)  N      Montant TVA de la ligne [OBL]
                MFAL_TTVA,--  NUMBER(15,2)  N      Taux de TVA de la ligne [OBL]
                MFAL_MTTC,--  NUMBER(15,2)  N
                MFAL_DDEBPERFAC,--  DATE  Y      Date de debut de la periode facturee de la ligne
                MFAL_DFINPERFAC,--  DATE  Y      Date de fin de la periode facturee de la ligne
                MFAL_DETAIL--  NUMBER  Y
                )
                values
               ('DIST'||v_district,
                V_FAC_NUM,
                1,
                'FACADE',
                'Montant facade',
                14,
                1,
                annee_,
                1,
                facture_.RFACADE/1000,
                facture_.RFACADE/1000,
                0,
                0,
                facture_.RFACADE/1000,
                null,
                DATE_,
                null );
           exception
          when others then
            err_code := SQLCODE;
            err_msg  := SUBSTR(SQLERRM, 1, 200);
            insert into prob_migration
              (nom_table, val_ref, sql_err, date_pro)
            values
              ('miwtfactureligne',
               V_FAC_NUM,
               err_code || '--' || err_msg,
               sysdate);
        end;
    end if;
     if to_number(facture_.REXTENSION) <> 0 then
         begin
         insert into miwtfactureligne (
                MFAL_SOURCE,--  VARCHAR2(100)  N      Code source/origine de la ligne [OBL]
                MFAL_REFFAE,--  VARCHAR2(100)  N      Identifiant de la facture de la ligne [OBL]
                MFAL_REFTAP,--  VARCHAR2(100)  N      Identifiant de la periode de tarif de la ligne [OBL]
                MFAL_REFART,--  VARCHAR2(100)  Y
                MFAL_LIBE,--  VARCHAR2(200)  Y
                MFAL_NUM,--  NUMBER(4)  N
                MFAL_TRAN,--  NUMBER(1)  N  1    Tranche de la ligne [OBL]
                MFAL_EXER,--  NUMBER(4)  N      Annee exercice de la ligne [OBL]
                MFAL_VOLU,--  NUMBER(15,3)  N      Volume facture de la ligne [OBL]
                MFAL_PU,--  NUMBER(12,6)  N      P.U. facture de la ligne [OBL]
                MFAL_MTHT,--  NUMBER(15,2)  N      Montant HT de la ligne [OBL]
                MFAL_MTVA,--  NUMBER(15,2)  N      Montant TVA de la ligne [OBL]
                MFAL_TTVA,--  NUMBER(15,2)  N      Taux de TVA de la ligne [OBL]
                MFAL_MTTC,--  NUMBER(15,2)  N
                MFAL_DDEBPERFAC,--  DATE  Y      Date de debut de la periode facturee de la ligne
                MFAL_DFINPERFAC,--  DATE  Y      Date de fin de la periode facturee de la ligne
                MFAL_DETAIL--  NUMBER  Y
                )
                values
               ('DIST'||v_district,
                V_FAC_NUM,
                1,
                'REXTENSION',
                'Montant extension',
                15,
                1,
                annee_,
                1,
                facture_.REXTENSION/1000,
                facture_.REXTENSION/1000,
                0,
                0,
                facture_.REXTENSION/1000,
                null,
                DATE_,
                null );
           exception
          when others then
            err_code := SQLCODE;
            err_msg  := SUBSTR(SQLERRM, 1, 200);
            insert into prob_migration
              (nom_table, val_ref, sql_err, date_pro)
            values
              ('miwtfactureligne',
               V_FAC_NUM,
               err_code || '--' || err_msg,
               sysdate);
        end;
    end if;
     if to_number(facture_.PFINANCIER) <> 0 then
         begin
         insert into miwtfactureligne (
                MFAL_SOURCE,--  VARCHAR2(100)  N      Code source/origine de la ligne [OBL]
                MFAL_REFFAE,--  VARCHAR2(100)  N      Identifiant de la facture de la ligne [OBL]
                MFAL_REFTAP,--  VARCHAR2(100)  N      Identifiant de la periode de tarif de la ligne [OBL]
                MFAL_REFART,--  VARCHAR2(100)  Y
                MFAL_LIBE,--  VARCHAR2(200)  Y
                MFAL_NUM,--  NUMBER(4)  N
                MFAL_TRAN,--  NUMBER(1)  N  1    Tranche de la ligne [OBL]
                MFAL_EXER,--  NUMBER(4)  N      Annee exercice de la ligne [OBL]
                MFAL_VOLU,--  NUMBER(15,3)  N      Volume facture de la ligne [OBL]
                MFAL_PU,--  NUMBER(12,6)  N      P.U. facture de la ligne [OBL]
                MFAL_MTHT,--  NUMBER(15,2)  N      Montant HT de la ligne [OBL]
                MFAL_MTVA,--  NUMBER(15,2)  N      Montant TVA de la ligne [OBL]
                MFAL_TTVA,--  NUMBER(15,2)  N      Taux de TVA de la ligne [OBL]
                MFAL_MTTC,--  NUMBER(15,2)  N
                MFAL_DDEBPERFAC,--  DATE  Y      Date de debut de la periode facturee de la ligne
                MFAL_DFINPERFAC,--  DATE  Y      Date de fin de la periode facturee de la ligne
                MFAL_DETAIL--  NUMBER  Y
                )
                values
               ('DIST'||v_district,
                V_FAC_NUM,
                1,
                'PFINANCIER',
                'PRODUIT FINANCIER',
                16,
                1,
                annee_,
                1,
                facture_.PFINANCIER/1000,
                facture_.PFINANCIER/1000,
                0,
                0,
                facture_.PFINANCIER/1000,
                null,
                DATE_,
                null );
           exception
          when others then
            err_code := SQLCODE;
            err_msg  := SUBSTR(SQLERRM, 1, 200);
            insert into prob_migration
              (nom_table, val_ref, sql_err, date_pro)
            values
              ('miwtfactureligne',
               V_FAC_NUM,
               err_code || '--' || err_msg,
               sysdate);
        end;
    end if;
  ---------------
   if to_number(facture_.AREPOR) <> 0 then
         begin
         insert into miwtfactureligne (
                MFAL_SOURCE,--  VARCHAR2(100)  N      Code source/origine de la ligne [OBL]
                MFAL_REFFAE,--  VARCHAR2(100)  N      Identifiant de la facture de la ligne [OBL]
                MFAL_REFTAP,--  VARCHAR2(100)  N      Identifiant de la periode de tarif de la ligne [OBL]
                MFAL_REFART,--  VARCHAR2(100)  Y
                MFAL_LIBE,--  VARCHAR2(200)  Y
                MFAL_NUM,--  NUMBER(4)  N
                MFAL_TRAN,--  NUMBER(1)  N  1    Tranche de la ligne [OBL]
                MFAL_EXER,--  NUMBER(4)  N      Annee exercice de la ligne [OBL]
                MFAL_VOLU,--  NUMBER(15,3)  N      Volume facture de la ligne [OBL]
                MFAL_PU,--  NUMBER(12,6)  N      P.U. facture de la ligne [OBL]
                MFAL_MTHT,--  NUMBER(15,2)  N      Montant HT de la ligne [OBL]
                MFAL_MTVA,--  NUMBER(15,2)  N      Montant TVA de la ligne [OBL]
                MFAL_TTVA,--  NUMBER(15,2)  N      Taux de TVA de la ligne [OBL]
                MFAL_MTTC,--  NUMBER(15,2)  N
                MFAL_DDEBPERFAC,--  DATE  Y      Date de debut de la periode facturee de la ligne
                MFAL_DFINPERFAC,--  DATE  Y      Date de fin de la periode facturee de la ligne
                MFAL_DETAIL--  NUMBER  Y
                )
                values
               ('DIST'||v_district,
                V_FAC_NUM,
                1,
                'AREPOR',
                'Montant report',
                17,
                1,
                annee_,
                1,
                decode(facture_.caron,'1',1,-1)* (facture_.AREPOR/1000),
                decode(facture_.caron,'1',1,-1)* (facture_.AREPOR/1000),
                0,
                0,
                 decode(facture_.caron,'1',1,-1)* (facture_.AREPOR/1000),
                null,
                DATE_,
                null );
           exception
          when others then
            err_code := SQLCODE;
            err_msg  := SUBSTR(SQLERRM, 1, 200);
            insert into prob_migration
              (nom_table, val_ref, sql_err, date_pro)
            values
              ('miwtfactureligne',
               V_FAC_NUM,
               err_code || '--' || err_msg,
               sysdate);
        end;
    end if;
     if to_number(facture_.NAROND) <> 0 then
         begin
         insert into miwtfactureligne (
                MFAL_SOURCE,--  VARCHAR2(100)  N      Code source/origine de la ligne [OBL]
                MFAL_REFFAE,--  VARCHAR2(100)  N      Identifiant de la facture de la ligne [OBL]
                MFAL_REFTAP,--  VARCHAR2(100)  N      Identifiant de la periode de tarif de la ligne [OBL]
                MFAL_REFART,--  VARCHAR2(100)  Y
                MFAL_LIBE,--  VARCHAR2(200)  Y
                MFAL_NUM,--  NUMBER(4)  N
                MFAL_TRAN,--  NUMBER(1)  N  1    Tranche de la ligne [OBL]
                MFAL_EXER,--  NUMBER(4)  N      Annee exercice de la ligne [OBL]
                MFAL_VOLU,--  NUMBER(15,3)  N      Volume facture de la ligne [OBL]
                MFAL_PU,--  NUMBER(12,6)  N      P.U. facture de la ligne [OBL]
                MFAL_MTHT,--  NUMBER(15,2)  N      Montant HT de la ligne [OBL]
                MFAL_MTVA,--  NUMBER(15,2)  N      Montant TVA de la ligne [OBL]
                MFAL_TTVA,--  NUMBER(15,2)  N      Taux de TVA de la ligne [OBL]
                MFAL_MTTC,--  NUMBER(15,2)  N
                MFAL_DDEBPERFAC,--  DATE  Y      Date de debut de la periode facturee de la ligne
                MFAL_DFINPERFAC,--  DATE  Y      Date de fin de la periode facturee de la ligne
                MFAL_DETAIL--  NUMBER  Y
                )
                values
               ('DIST'||v_district,
                V_FAC_NUM,
                1,
                'NAROND',
                'Arrondissement',
                18,
                1,
                annee_,
                1,
                decode(facture_.caron,'1',-1,1)*(facture_.NAROND/1000),
                decode(facture_.caron,'1',-1,1)*(facture_.NAROND/1000),
                0,
                0,
                decode(facture_.caron,'1',-1,1)*(facture_.NAROND/1000),
                null,
                DATE_,
                null );
           exception
          when others then
            err_code := SQLCODE;
            err_msg  := SUBSTR(SQLERRM, 1, 200);
            insert into prob_migration
              (nom_table, val_ref, sql_err, date_pro)
            values
              ('miwtfactureligne',
               V_FAC_NUM,
               err_code || '--' || err_msg,
               sysdate);
        end;
    end if;
       if to_number(facture_.DIVERS) <> 0 then
         begin
         insert into miwtfactureligne (
                MFAL_SOURCE,--  VARCHAR2(100)  N      Code source/origine de la ligne [OBL]
                MFAL_REFFAE,--  VARCHAR2(100)  N      Identifiant de la facture de la ligne [OBL]
                MFAL_REFTAP,--  VARCHAR2(100)  N      Identifiant de la periode de tarif de la ligne [OBL]
                MFAL_REFART,--  VARCHAR2(100)  Y
                MFAL_LIBE,--  VARCHAR2(200)  Y
                MFAL_NUM,--  NUMBER(4)  N
                MFAL_TRAN,--  NUMBER(1)  N  1    Tranche de la ligne [OBL]
                MFAL_EXER,--  NUMBER(4)  N      Annee exercice de la ligne [OBL]
                MFAL_VOLU,--  NUMBER(15,3)  N      Volume facture de la ligne [OBL]
                MFAL_PU,--  NUMBER(12,6)  N      P.U. facture de la ligne [OBL]
                MFAL_MTHT,--  NUMBER(15,2)  N      Montant HT de la ligne [OBL]
                MFAL_MTVA,--  NUMBER(15,2)  N      Montant TVA de la ligne [OBL]
                MFAL_TTVA,--  NUMBER(15,2)  N      Taux de TVA de la ligne [OBL]
                MFAL_MTTC,--  NUMBER(15,2)  N
                MFAL_DDEBPERFAC,--  DATE  Y      Date de debut de la periode facturee de la ligne
                MFAL_DFINPERFAC,--  DATE  Y      Date de fin de la periode facturee de la ligne
                MFAL_DETAIL--  NUMBER  Y
                )
                values
               ('DIST'||v_district,
                V_FAC_NUM,
                1,
                'AUTREFRAIS',
                'Frais Divers ',
                20,
                1,
                annee_,
                1,
                (facture_.DIVERS)/1000,
                (facture_.DIVERS)/1000,
                0,
                0,
                (facture_.DIVERS)/1000,
                null,
                DATE_,
                null );
           exception
          when others then
            err_code := SQLCODE;
            err_msg  := SUBSTR(SQLERRM, 1, 200);
            insert into prob_migration
              (nom_table, val_ref, sql_err, date_pro)
            values
              ('miwtfactureligne',
               V_FAC_NUM,
               err_code || '--' || err_msg,
               sysdate);
        end;
    end if;
         select count(*) into  nbr_trt from  miwtreleve
             where mrel_refpdl =
              lpad(facture_.DIST,2,'0')||
              lpad(facture_.tou,3,'0')||
              lpad(facture_.ORD,3,'0')||
              lpad(facture_.POL,5,'0')
              And mrel_refpdl is not null
               and   annee = annee_
               and   periode = periode_
               And rownum=1;
       if nbr_trt <> 0 then
        update  miwtreleve  set mrel_fact1 = v_ID_FACTURE
             where mrel_refpdl =
              lpad(facture_.DIST,2,'0')||
              lpad(facture_.tou,3,'0')||
              lpad(facture_.ORD,3,'0')||
              lpad(facture_.POL,5,'0')
              And mrel_refpdl is not null
               and   annee = annee_
               and   periode = periode_
               And rownum=1;

          end if;
   <<XX>>
        commit;

    end loop;
        delete xx;
       insert into xx  select  substr(s.mfae_rdet,1,2) distirct,substr(s.mfae_rdet,3,3) tourne,substr(s.mfae_rdet,6,3) ordre ,substr(s.mfae_rdet,9,4)annee,
        substr(s.mfae_rdet,13,2) periode,t.mfal_reffae,sum(t.mfal_mttc) net_calc,s.mfae_solde net,sum(t.mfal_mttc)-s.mfae_solde diff,
        sum(decode(t.mfal_refart,'CAPITAL',t.mfal_mttc,'INTERET',t.mfal_mttc,0)) capit
         from miwtfactureligne t,miwtfactureentete s
         where t.mfal_reffae=s.mfae_ref
         group by t.mfal_reffae,s.mfae_solde,substr(s.mfae_rdet,1,2),substr(s.mfae_rdet,3,3),substr(s.mfae_rdet,6,3),substr(s.mfae_rdet,9,4),substr(s.mfae_rdet,13,2)
         having ((abs(sum(t.mfal_mttc)-s.mfae_solde) <>0)) ;
        commit;
         for c in (select t.*, t.rowid from xx t where diff = capit)
          loop
          delete miwtfactureligne s where s.mfal_source = 'DIST'||c.distirct and c.mfal_reffae=s.mfal_reffae
                                   And s.mfal_refart in('CAPITAL','INTERET');
          delete xx where c.distirct=distirct and c.mfal_reffae=mfal_reffae;
          end loop;
          commit;
            for c in (select t.*, t.rowid,diff-capit from xx t where capit <> 0 and diff-(diff-capit) =capit and (diff-capit) > 0.001)
            loop
            delete miwtfactureligne s where s.mfal_source = 'DIST'||c.distirct and c.mfal_reffae=s.mfal_reffae
                                   And s.mfal_refart in('CAPITAL','INTERET');
          end loop;
          commit;
       delete xx;
       insert into xx  select  substr(s.mfae_rdet,1,2) distirct,substr(s.mfae_rdet,3,3) tourne,substr(s.mfae_rdet,6,3) ordre ,substr(s.mfae_rdet,9,4)annee,
        substr(s.mfae_rdet,13,2) periode,t.mfal_reffae,sum(t.mfal_mttc) net_calc,s.mfae_solde net,sum(t.mfal_mttc)-s.mfae_solde diff,
        sum(decode(t.mfal_refart,'CAPITAL',t.mfal_mttc,'INTERET',t.mfal_mttc,0)) capit
         from miwtfactureligne t,miwtfactureentete s
         where t.mfal_reffae=s.mfae_ref
         group by t.mfal_reffae,s.mfae_solde,substr(s.mfae_rdet,1,2),substr(s.mfae_rdet,3,3),substr(s.mfae_rdet,6,3),substr(s.mfae_rdet,9,4),substr(s.mfae_rdet,13,2)
         having ((abs(sum(t.mfal_mttc)-s.mfae_solde) <>0)) ;
       commit;
          for c in (select t.*, t.rowid from XX t WHERE diff >= 0.001)
   loop
     select count(*) into x from miwtfactureligne s where s.mfal_reffae=c.mfal_reffae and s.mfal_refart='NAROND'
                                                      And 'DIST'||c.distirct=s.mfal_source;
     if x = 0 then
       insert into miwtfactureligne (
                MFAL_SOURCE,--  VARCHAR2(100)  N      Code source/origine de la ligne [OBL]
                MFAL_REFFAE,--  VARCHAR2(100)  N      Identifiant de la facture de la ligne [OBL]
                MFAL_REFTAP,--  VARCHAR2(100)  N      Identifiant de la periode de tarif de la ligne [OBL]
                MFAL_REFART,--  VARCHAR2(100)  Y
                MFAL_LIBE,--  VARCHAR2(200)  Y
                MFAL_NUM,--  NUMBER(4)  N
                MFAL_TRAN,--  NUMBER(1)  N  1    Tranche de la ligne [OBL]
                MFAL_EXER,--  NUMBER(4)  N      Annee exercice de la ligne [OBL]
                MFAL_VOLU,--  NUMBER(15,3)  N      Volume facture de la ligne [OBL]
                MFAL_PU,--  NUMBER(12,6)  N      P.U. facture de la ligne [OBL]
                MFAL_MTHT,--  NUMBER(15,2)  N      Montant HT de la ligne [OBL]
                MFAL_MTVA,--  NUMBER(15,2)  N      Montant TVA de la ligne [OBL]
                MFAL_TTVA,--  NUMBER(15,2)  N      Taux de TVA de la ligne [OBL]
                MFAL_MTTC,--  NUMBER(15,2)  N
                MFAL_DDEBPERFAC,--  DATE  Y      Date de debut de la periode facturee de la ligne
                MFAL_DFINPERFAC,--  DATE  Y      Date de fin de la periode facturee de la ligne
                MFAL_DETAIL--  NUMBER  Y
                )
                values
               ('DIST'||c.distirct,
                c.mfal_reffae,
                1,
                'NAROND',
                'Arrondissement',
                18,
                1,
                c.annee,
                1,
                (-1)*(c.diff),
                 (-1)*(c.diff),
                0,
                0,
                 (-1)*(c.diff),
                null,
                null,
                null );
             else
               update miwtfactureligne set MFAL_PU=MFAL_PU-c.diff,
                                           MFAL_MTHT=MFAL_MTHT-c.diff,
                                           MFAL_MTTC=MFAL_MTTC-c.diff
                                           where
                                           mfal_reffae=c.mfal_reffae and mfal_refart='NAROND'
                                            And 'DIST'||c.distirct=mfal_source;
             end if;


          end loop;
          commit;
        delete xx;
       insert into xx  select  substr(s.mfae_rdet,1,2) distirct,substr(s.mfae_rdet,3,3) tourne,substr(s.mfae_rdet,6,3) ordre ,substr(s.mfae_rdet,9,4)annee,
        substr(s.mfae_rdet,13,2) periode,t.mfal_reffae,sum(t.mfal_mttc) net_calc,s.mfae_solde net,sum(t.mfal_mttc)-s.mfae_solde diff,
        sum(decode(t.mfal_refart,'CAPITAL',t.mfal_mttc,'INTERET',t.mfal_mttc,0)) capit
         from miwtfactureligne t,miwtfactureentete s
         where t.mfal_reffae=s.mfae_ref
         group by t.mfal_reffae,s.mfae_solde,substr(s.mfae_rdet,1,2),substr(s.mfae_rdet,3,3),substr(s.mfae_rdet,6,3),substr(s.mfae_rdet,9,4),substr(s.mfae_rdet,13,2)
         having ((abs(sum(t.mfal_mttc)-s.mfae_solde) <>0)) ;
       commit;
         delete  miwtfactureligne t where MFAL_REFFAE in (select MFAL_REFFAE from xx  where abs(diff)=abs(t.mfal_mttc)) and t.mfal_refart='NAROND';
          commit;
         delete xx;
       insert into xx  select  substr(s.mfae_rdet,1,2) distirct,substr(s.mfae_rdet,3,3) tourne,substr(s.mfae_rdet,6,3) ordre ,substr(s.mfae_rdet,9,4)annee,
        substr(s.mfae_rdet,13,2) periode,t.mfal_reffae,sum(t.mfal_mttc) net_calc,s.mfae_solde net,sum(t.mfal_mttc)-s.mfae_solde diff,
        sum(decode(t.mfal_refart,'CAPITAL',t.mfal_mttc,'INTERET',t.mfal_mttc,0)) capit
         from miwtfactureligne t,miwtfactureentete s
         where t.mfal_reffae=s.mfae_ref
         group by t.mfal_reffae,s.mfae_solde,substr(s.mfae_rdet,1,2),substr(s.mfae_rdet,3,3),substr(s.mfae_rdet,6,3),substr(s.mfae_rdet,9,4),substr(s.mfae_rdet,13,2)
         having ((abs(sum(t.mfal_mttc)-s.mfae_solde) <>0)) ;
         commit;
       -----
        for c in (select t.*, t.rowid,trunc(diff/capit) nbr ,capit*trunc(diff/capit) from xx t where capit <> 0)
         loop
          update miwtfactureligne  set MFAL_VOLU=MFAL_VOLU+(c.nbr*-1) where MFAL_REFART in ('INTERET','CAPITAL') and MFAL_REFFAE=c.mfal_reffae;
         end loop;
         update miwtfactureligne set MFAL_MTHT=MFAL_VOLU*mfal_pu,
                                  MFAL_MTTC=MFAL_VOLU*mfal_pu
                                  where MFAL_REFART in ('INTERET','CAPITAL');
            commit;
         delete xx;
       insert into xx  select  substr(s.mfae_rdet,1,2) distirct,substr(s.mfae_rdet,3,3) tourne,substr(s.mfae_rdet,6,3) ordre ,substr(s.mfae_rdet,9,4)annee,
        substr(s.mfae_rdet,13,2) periode,t.mfal_reffae,sum(t.mfal_mttc) net_calc,s.mfae_solde net,sum(t.mfal_mttc)-s.mfae_solde diff,
        sum(decode(t.mfal_refart,'CAPITAL',t.mfal_mttc,'INTERET',t.mfal_mttc,0)) capit
         from miwtfactureligne t,miwtfactureentete s
         where t.mfal_reffae=s.mfae_ref
         group by t.mfal_reffae,s.mfae_solde,substr(s.mfae_rdet,1,2),substr(s.mfae_rdet,3,3),substr(s.mfae_rdet,6,3),substr(s.mfae_rdet,9,4),substr(s.mfae_rdet,13,2)
         having ((abs(sum(t.mfal_mttc)-s.mfae_solde) <>0)) ;
         commit;
  end;

----------
 procedure MIWT_FACTURE_AS400GC (v_district in varchar2) is

    err_code        varchar2(200);
    err_msg         varchar2(200);
    V_FAC_NUM       number;
    V_FAC_RESTANTDU  number;
    V_FAC_DATECALCUL date;
    V_FAC_DATELIM    date;
    V_FAC_ABN_NUM    number(20);
    v_ref_releve      number;
    V_TRAIN_FACT       varchar2(200);
    V_REF_ABN        varchar2(200);
    nbr_trt   number := 0;
    x  number;
    v_ID_FACTURE   varchar2(20);

  annee_ number(4);
  periode_ number;
  version number(1) := 0;
   date_          date;
  begin

    --**************************************************
     delete prob_migration where
              nom_table in
              ('miwtfacture','SEQ_RELEVE','miwtfactureligne');
    V_FAC_NUM        := 0;

    select max(to_number(MFAE_REF))  into V_FAC_NUM from miwtfactureentete WHERE MFAE_SOURCE= 'DIST'||v_district;
    select max(to_number(MREL_REF)) into v_ref_releve FROM miwtreleve where MREL_SOURCE = 'DIST'||v_district;
    COMMIT;

    for facture_ in (select * from facture_as400gc WHERE dist=v_district) loop
     V_FAC_NUM        := nvl(V_FAC_NUM,0) +1;
      --**************************************************
       select last_day(to_date('01'||lpad(facture_.refc01,2,0)||facture_.refc02,'ddmmyy')) into date_
                              from dual;

      periode_ := facture_.refc01;
      annee_ :=to_char(date_,'yyyy');

      V_FAC_RESTANTDU  := null;
      V_FAC_DATECALCUL := null;
      V_FAC_ABN_NUM    := null;

       begin
          select to_date(lpad(ltrim(rtrim(DATEEXP)),8,'0'),'ddmmyyyy'),
                 to_date(lpad(ltrim(rtrim(DATL)),8,'0'),'ddmmyyyy')    into
                 V_FAC_DATECALCUL,V_FAC_DATELIM from role_mens
                     where to_number(facture_.pol)=POLICE
                     AND fACTURE_.Dist = ltrim(rtrim(DISTR))
                     And facture_.refc01 = ltrim(rtrim(MOIS))
                     AND rownum = 1;
            exception
          when others then
            err_code := SQLCODE;
            err_msg  := SUBSTR(SQLERRM, 1, 200);
            insert into prob_migration
              (nom_table, val_ref, sql_err, date_pro)
            values
              ('miwtfacture','Date facture pol '||facture_.pol||'M1 :'||facture_.refc01||'M2 :'||facture_.refc02,
                 err_msg ||'-- periode ',sysdate);

      end;
      if V_FAC_DATECALCUL is null then
      BEGIN

      select (r.mrel_date+1) INTO  V_FAC_DATECALCUL from  miwtreleve r
             where r.mrel_refpdl =
              lpad(facture_.DIST,2,'0')||
              lpad(facture_.tou,3,'0')||
              lpad(facture_.ORD,3,'0')||
              lpad(facture_.POL,5,'0')
              And mrel_refpdl is not null
               and   r.annee = annee_
               and   r.periode = periode_
               And rownum=1;
               Exception  when others then
               V_FAC_DATECALCUL := date_;
               V_FAC_DATELIM :=date_;
            end;
       end if;
        -- reception de l'identfiant de l'abonnement
        V_REF_ABN := ltrim(rtrim(facture_.DIST)) ||
                     lpad(to_char(facture_.pol),5,'0') ||
                     lpad(ltrim(rtrim(facture_.tou)),3,'0') ||
                     lpad(ltrim(rtrim(facture_.ORD)),3,'0');
        V_TRAIN_FACT :=  ltrim(rtrim(annee_)) ||
                     lpad(to_char(periode_),2,0 );
        v_ID_FACTURE:=ltrim(rtrim(facture_.DIST)) ||
                    lpad(ltrim(rtrim(facture_.tou)),3,'0') ||
                     lpad(ltrim(rtrim(facture_.ORD)),3,'0')||
                     to_char(annee_) ||
                     lpad(to_char(periode_),2,0)||to_char(version);
         select count(*) into nbr_trt from miwtfactureentete where MFAE_RDET = v_ID_FACTURE
                                                               And MFAE_SOURCE = 'DIST'||v_district;
         if nbr_trt=1 then goto xx;  end if;
        for ref_abn_ in (select *
                           from miwabn a
                          where substr(a.abn_refsite,1,13) = lpad(facture_.dist,2,'0') ||
                        lpad(facture_.tou,3,'0') ||
                        lpad(facture_.ord,3,'0') ||
                        lpad(to_char(facture_.pol),5,'0')) loop
          V_FAC_ABN_NUM := ref_abn_.abn_ref;
        end loop;
        if V_FAC_ABN_NUM  is null then V_FAC_ABN_NUM := lpad(facture_.dist,2,'0') ||
                        lpad(facture_.tou,3,'0') ||
                        lpad(facture_.ord,3,'0') ||
                        lpad(facture_.pol,5,'0');
         end if;
        -- Insertion de la facture
        begin
        insert into miwtfactureentete
        (
        MFAE_SOURCE,--1         VARCHAR2(100)  N      Code source/origine de la facture [OBL]
        MFAE_REF,   --2       VARCHAR2(100)  N      Identifiant unique de la facture pour la source [OBL]
        MFAE_REFTRF,--3     VARCHAR2(100)  Y      Identifiant du train de la facture
        MFAE_NUME,  --4       NUMBER(10)  Y      Numero de la facture [OBL]
        MFAE_RDET,  --5       VARCHAR2(15)  Y      RDET de la facture
        MFAE_CCMO,  --6       VARCHAR2(1)  Y      Cle controle RDET de la facture
        MFAE_DEDI,  --7       DATE  N      Date d edition de la facture [OBL]
        MFAE_DLPAI, --8     DATE  Y      Date limite de paiement de la facture [OBL]
        MFAE_DPREL,--9     DATE  Y      Date de prelevement de la facture [OBL]
        MFAE_TOTHTE,--10   NUMBER(10,2)  N      Total HT EAU de la facture [OBL]
        MFAE_TOTTVAE,--11   NUMBER(10,2)  N      Total TVA EAU de la facture [OBL]
        MFAE_TOTHTA,--12   NUMBER(10,2)  N      Total HT ASS de la facture [OBL]
        MFAE_TOTTVAA,--13   NUMBER(10,2)  N      Total TVA ASS de la facture [OBL]
        MFAE_SOLDE,--14     NUMBER(10,2)  Y      Solde TTC de la facture
        MFAE_TYPE,--15     VARCHAR2(2)  N  'R'
        MFAE_REFFAEDEDU,--16  VARCHAR2(100)  Y
        MFAE_REFABN,--17      VARCHAR2(100)  N      Identifiant du contrat de la facture [OBL]
        MFAE_REF_CODNIV_RELANCE,--18  VARCHAR2(100)  Y      Reference Code niveau de chainde relance
        MFAE_RIB_REF,--19              VARCHAR2(100)  Y      Reference Rib
        MFAE_RIB_ETAT,--20            NUMBER(1)  Y      Mode de payement (pr?l?vement 1 ou tip 2)
        MFAE_COMPTEAUX,--21            VARCHAR2(100)  Y      Compte auxilaire GENACCOUNT associe a la facture
        MFAE_REF_ORIGINE,--22          VARCHAR2(100)  Y      Facture origine
        MFAE_COMMENT,--23              VARCHAR2(4000)  Y      Commentaire libre Facture
        MFAE_AMOUNTTTCDEC,--24        NUMBER(17,10)  Y      Montant TTC a deduire
        VOC_MODEFACT,--25              VARCHAR2(10)  Y
        MFAE_REF_DEDUC,--26            VARCHAR2(100)  Y
        MFAE_REFORGA,--27              VARCHAR2(100)  Y
        MFAE_EXERCICE,--28            NUMBER(4)  Y      Exercice du role de la facture
        MFAE_NUMEROROLE,--29          NUMBER(4)  Y       Numero du role pour l exercice
        MFAE_PREL--30                  NUMBER  Y
         )
       values
       (
        'DIST'||v_district,               --1
        V_FAC_NUM,            --2
        V_TRAIN_FACT,         --3
        V_FAC_NUM,            --4
        v_ID_FACTURE,         --5
        NULL,                 --6
        V_FAC_DATECALCUL,     --7
        V_FAC_DATELIM,     --8
        V_FAC_DATECALCUL,     --9
        (facture_.monttrim-(facture_.tva+facture_.taxe))/1000,   --10
        (facture_.tva+facture_.taxe)/1000,   --11
        0,                   --12
        0,                   --13
        facture_.monttrim/1000,     --14
        'FC',                --15
        NULL,                --16
        V_FAC_ABN_NUM,       --17
        'INCONNUE',                --18
         null,                --19
        4,                --20
        'IMP_MIG',           --21
        null,                 --22
        V_REF_ABN,                 --23
        NULL,                 --24
        4,                   --25
        NULL,                 --26
        v_district,            --27
        annee_,               --28
        periode_,              --29
        1                  --30
        );
        exception
          when others then
            err_code := SQLCODE;
            err_msg  := SUBSTR(SQLERRM, 1, 200);
            insert into prob_migration
              (nom_table, val_ref, sql_err, date_pro)
            values
              ('miwtfacture',
               lpad(facture_.dist,2,'0') ||
               lpad(facture_.tou,3,'0') ||
               lpad(facture_.ord,3,'0') ||
               lpad(facture_.pol,5,'0'),
               err_code || '--' || err_msg,
               sysdate);
        end;
-------------------------------------------------------------------------------
--------------------------------------------------- LIGNE FACTURE CONSOMMATION SONNEDE
if to_number(facture_.montt1) <> 0 then
         begin
         insert into miwtfactureligne (
                MFAL_SOURCE,--  VARCHAR2(100)  N      Code source/origine de la ligne [OBL]
                MFAL_REFFAE,--  VARCHAR2(100)  N      Identifiant de la facture de la ligne [OBL]
                MFAL_REFTAP,--  VARCHAR2(100)  N      Identifiant de la periode de tarif de la ligne [OBL]
                MFAL_REFART,--  VARCHAR2(100)  Y
                MFAL_LIBE,--  VARCHAR2(200)  Y
                MFAL_NUM,--  NUMBER(4)  N
                MFAL_TRAN,--  NUMBER(1)  N  1    Tranche de la ligne [OBL]
                MFAL_EXER,--  NUMBER(4)  N      Annee exercice de la ligne [OBL]
                MFAL_VOLU,--  NUMBER(15,3)  N      Volume facture de la ligne [OBL]
                MFAL_PU,--  NUMBER(12,6)  N      P.U. facture de la ligne [OBL]
                MFAL_MTHT,--  NUMBER(15,2)  N      Montant HT de la ligne [OBL]
                MFAL_MTVA,--  NUMBER(15,2)  N      Montant TVA de la ligne [OBL]
                MFAL_TTVA,--  NUMBER(15,2)  N      Taux de TVA de la ligne [OBL]
                MFAL_MTTC,--  NUMBER(15,2)  N
                MFAL_DDEBPERFAC,--  DATE  Y      Date de debut de la periode facturee de la ligne
                MFAL_DFINPERFAC,--  DATE  Y      Date de fin de la periode facturee de la ligne
                MFAL_DETAIL--  NUMBER  Y
                )
                values
               ('DIST'||v_district,
                V_FAC_NUM,
                1,
                'CSM_STD',
                'consommation sonede 1ere Tranche',
                1,
                1,
                annee_,
                facture_.const1,
                facture_.tauxt1/1000,
                facture_.montt1/1000,
                facture_.taxe/1000,
                18,
                facture_.montt1/1000+(facture_.taxe/1000),
                null,
                DATE_,
                null );
           exception
          when others then
            err_code := SQLCODE;
            err_msg  := SUBSTR(SQLERRM, 1, 200);
            insert into prob_migration
              (nom_table, val_ref, sql_err, date_pro)
            values
              ('miwtfactureligne',
               V_FAC_NUM,
               err_code || '--' || err_msg,
               sysdate);
        end;
    end if;
if to_number(facture_.montt2) <> 0 then
         begin
         insert into miwtfactureligne (
                MFAL_SOURCE,--  VARCHAR2(100)  N      Code source/origine de la ligne [OBL]
                MFAL_REFFAE,--  VARCHAR2(100)  N      Identifiant de la facture de la ligne [OBL]
                MFAL_REFTAP,--  VARCHAR2(100)  N      Identifiant de la periode de tarif de la ligne [OBL]
                MFAL_REFART,--  VARCHAR2(100)  Y
                MFAL_LIBE,--  VARCHAR2(200)  Y
                MFAL_NUM,--  NUMBER(4)  N
                MFAL_TRAN,--  NUMBER(1)  N  1    Tranche de la ligne [OBL]
                MFAL_EXER,--  NUMBER(4)  N      Annee exercice de la ligne [OBL]
                MFAL_VOLU,--  NUMBER(15,3)  N      Volume facture de la ligne [OBL]
                MFAL_PU,--  NUMBER(12,6)  N      P.U. facture de la ligne [OBL]
                MFAL_MTHT,--  NUMBER(15,2)  N      Montant HT de la ligne [OBL]
                MFAL_MTVA,--  NUMBER(15,2)  N      Montant TVA de la ligne [OBL]
                MFAL_TTVA,--  NUMBER(15,2)  N      Taux de TVA de la ligne [OBL]
                MFAL_MTTC,--  NUMBER(15,2)  N
                MFAL_DDEBPERFAC,--  DATE  Y      Date de debut de la periode facturee de la ligne
                MFAL_DFINPERFAC,--  DATE  Y      Date de fin de la periode facturee de la ligne
                MFAL_DETAIL--  NUMBER  Y
                )
                values
               ('DIST'||v_district,
                V_FAC_NUM,
                1,
                'CSM_STD',
                'consommation sonede 2eme Tranche',
                2,
                2,
                annee_,
                 facture_.const2,
                facture_.tauxt2/1000,
                facture_.montt2/1000,
                 facture_.taxe/1000,
                18,
                facture_.montt2/1000+(facture_.taxe/1000),
                null,
                DATE_,
                null );
           exception
          when others then
            err_code := SQLCODE;
            err_msg  := SUBSTR(SQLERRM, 1, 200);
            insert into prob_migration
              (nom_table, val_ref, sql_err, date_pro)
            values
              ('miwtfactureligne',
               V_FAC_NUM,
               err_code || '--' || err_msg,
               sysdate);
        end;
    end if;
    if to_number(facture_.montt3) <> 0 then
         begin
         insert into miwtfactureligne (
                MFAL_SOURCE,--  VARCHAR2(100)  N      Code source/origine de la ligne [OBL]
                MFAL_REFFAE,--  VARCHAR2(100)  N      Identifiant de la facture de la ligne [OBL]
                MFAL_REFTAP,--  VARCHAR2(100)  N      Identifiant de la periode de tarif de la ligne [OBL]
                MFAL_REFART,--  VARCHAR2(100)  Y
                MFAL_LIBE,--  VARCHAR2(200)  Y
                MFAL_NUM,--  NUMBER(4)  N
                MFAL_TRAN,--  NUMBER(1)  N  1    Tranche de la ligne [OBL]
                MFAL_EXER,--  NUMBER(4)  N      Annee exercice de la ligne [OBL]
                MFAL_VOLU,--  NUMBER(15,3)  N      Volume facture de la ligne [OBL]
                MFAL_PU,--  NUMBER(12,6)  N      P.U. facture de la ligne [OBL]
                MFAL_MTHT,--  NUMBER(15,2)  N      Montant HT de la ligne [OBL]
                MFAL_MTVA,--  NUMBER(15,2)  N      Montant TVA de la ligne [OBL]
                MFAL_TTVA,--  NUMBER(15,2)  N      Taux de TVA de la ligne [OBL]
                MFAL_MTTC,--  NUMBER(15,2)  N
                MFAL_DDEBPERFAC,--  DATE  Y      Date de debut de la periode facturee de la ligne
                MFAL_DFINPERFAC,--  DATE  Y      Date de fin de la periode facturee de la ligne
                MFAL_DETAIL--  NUMBER  Y
                )
                values
               ('DIST'||v_district,
                V_FAC_NUM,
                1,
                'CSM_STD',
                'consommation sonede 3eme Tranche',
                3,
                3,
                annee_,
                 facture_.const3,
                facture_.tauxt3/1000,
                facture_.montt3/1000,
                 facture_.taxe/1000,
                18,
                facture_.montt3/1000+(facture_.taxe/1000),
                null,
                DATE_,
                null );
           exception
          when others then
            err_code := SQLCODE;
            err_msg  := SUBSTR(SQLERRM, 1, 200);
            insert into prob_migration
              (nom_table, val_ref, sql_err, date_pro)
            values
              ('miwtfactureligne',
               V_FAC_NUM,
               err_code || '--' || err_msg,
               sysdate);
        end;
    end if;
    --------------------------------------------------- LIGNE FACTURE CONSOMMATION ONAS
if to_number(facture_.mon1) <> 0 then
         begin
         insert into miwtfactureligne (
                MFAL_SOURCE,--  VARCHAR2(100)  N      Code source/origine de la ligne [OBL]
                MFAL_REFFAE,--  VARCHAR2(100)  N      Identifiant de la facture de la ligne [OBL]
                MFAL_REFTAP,--  VARCHAR2(100)  N      Identifiant de la periode de tarif de la ligne [OBL]
                MFAL_REFART,--  VARCHAR2(100)  Y
                MFAL_LIBE,--  VARCHAR2(200)  Y
                MFAL_NUM,--  NUMBER(4)  N
                MFAL_TRAN,--  NUMBER(1)  N  1    Tranche de la ligne [OBL]
                MFAL_EXER,--  NUMBER(4)  N      Annee exercice de la ligne [OBL]
                MFAL_VOLU,--  NUMBER(15,3)  N      Volume facture de la ligne [OBL]
                MFAL_PU,--  NUMBER(12,6)  N      P.U. facture de la ligne [OBL]
                MFAL_MTHT,--  NUMBER(15,2)  N      Montant HT de la ligne [OBL]
                MFAL_MTVA,--  NUMBER(15,2)  N      Montant TVA de la ligne [OBL]
                MFAL_TTVA,--  NUMBER(15,2)  N      Taux de TVA de la ligne [OBL]
                MFAL_MTTC,--  NUMBER(15,2)  N
                MFAL_DDEBPERFAC,--  DATE  Y      Date de debut de la periode facturee de la ligne
                MFAL_DFINPERFAC,--  DATE  Y      Date de fin de la periode facturee de la ligne
                MFAL_DETAIL--  NUMBER  Y
                )
                values
               ('DIST'||v_district,
                V_FAC_NUM,
                2,
                'VAR_ONAS_1',
                'Redevance onas 1ere Tranche',
                4,
                1,
                annee_,
                facture_.volon1,
                facture_.tauon1/1000,
                facture_.mon1/1000,
                0,
                0,
                facture_.mon1/1000,
                null,
                DATE_,
                null );
           exception
          when others then
            err_code := SQLCODE;
            err_msg  := SUBSTR(SQLERRM, 1, 200);
            insert into prob_migration
              (nom_table, val_ref, sql_err, date_pro)
            values
              ('miwtfactureligne',
               V_FAC_NUM,
               err_code || '--' || err_msg,
               sysdate);
        end;
    end if;
if to_number(facture_.mon2) <> 0 then
         begin
         insert into miwtfactureligne (
                MFAL_SOURCE,--  VARCHAR2(100)  N      Code source/origine de la ligne [OBL]
                MFAL_REFFAE,--  VARCHAR2(100)  N      Identifiant de la facture de la ligne [OBL]
                MFAL_REFTAP,--  VARCHAR2(100)  N      Identifiant de la periode de tarif de la ligne [OBL]
                MFAL_REFART,--  VARCHAR2(100)  Y
                MFAL_LIBE,--  VARCHAR2(200)  Y
                MFAL_NUM,--  NUMBER(4)  N
                MFAL_TRAN,--  NUMBER(1)  N  1    Tranche de la ligne [OBL]
                MFAL_EXER,--  NUMBER(4)  N      Annee exercice de la ligne [OBL]
                MFAL_VOLU,--  NUMBER(15,3)  N      Volume facture de la ligne [OBL]
                MFAL_PU,--  NUMBER(12,6)  N      P.U. facture de la ligne [OBL]
                MFAL_MTHT,--  NUMBER(15,2)  N      Montant HT de la ligne [OBL]
                MFAL_MTVA,--  NUMBER(15,2)  N      Montant TVA de la ligne [OBL]
                MFAL_TTVA,--  NUMBER(15,2)  N      Taux de TVA de la ligne [OBL]
                MFAL_MTTC,--  NUMBER(15,2)  N
                MFAL_DDEBPERFAC,--  DATE  Y      Date de debut de la periode facturee de la ligne
                MFAL_DFINPERFAC,--  DATE  Y      Date de fin de la periode facturee de la ligne
                MFAL_DETAIL--  NUMBER  Y
                )
                values
               ('DIST'||v_district,
                V_FAC_NUM,
                2,
                'VAR_ONAS_1',
                'Redevance onas 2eme Tranche',
                5,
                2,
                annee_,
                facture_.volon2,
                facture_.tauon2/1000,
                facture_.mon2/1000,
                0,
                0,
                facture_.mon2/1000,
                null,
                DATE_,
                null );
           exception
          when others then
            err_code := SQLCODE;
            err_msg  := SUBSTR(SQLERRM, 1, 200);
            insert into prob_migration
              (nom_table, val_ref, sql_err, date_pro)
            values
              ('miwtfactureligne',
               V_FAC_NUM,
               err_code || '--' || err_msg,
               sysdate);
        end;
    end if;
    if to_number(facture_.mon3) <> 0 then
         begin
         insert into miwtfactureligne (
                MFAL_SOURCE,--  VARCHAR2(100)  N      Code source/origine de la ligne [OBL]
                MFAL_REFFAE,--  VARCHAR2(100)  N      Identifiant de la facture de la ligne [OBL]
                MFAL_REFTAP,--  VARCHAR2(100)  N      Identifiant de la periode de tarif de la ligne [OBL]
                MFAL_REFART,--  VARCHAR2(100)  Y
                MFAL_LIBE,--  VARCHAR2(200)  Y
                MFAL_NUM,--  NUMBER(4)  N
                MFAL_TRAN,--  NUMBER(1)  N  1    Tranche de la ligne [OBL]
                MFAL_EXER,--  NUMBER(4)  N      Annee exercice de la ligne [OBL]
                MFAL_VOLU,--  NUMBER(15,3)  N      Volume facture de la ligne [OBL]
                MFAL_PU,--  NUMBER(12,6)  N      P.U. facture de la ligne [OBL]
                MFAL_MTHT,--  NUMBER(15,2)  N      Montant HT de la ligne [OBL]
                MFAL_MTVA,--  NUMBER(15,2)  N      Montant TVA de la ligne [OBL]
                MFAL_TTVA,--  NUMBER(15,2)  N      Taux de TVA de la ligne [OBL]
                MFAL_MTTC,--  NUMBER(15,2)  N
                MFAL_DDEBPERFAC,--  DATE  Y      Date de debut de la periode facturee de la ligne
                MFAL_DFINPERFAC,--  DATE  Y      Date de fin de la periode facturee de la ligne
                MFAL_DETAIL--  NUMBER  Y
                )
                values
               ('DIST'||v_district,
                V_FAC_NUM,
                2,
                'VAR_ONAS_1',
                'Redevance onas 3eme Tranche',
                6,
                3,
                annee_,
                 facture_.volon3,
                facture_.tauon3/1000,
                facture_.mon3/1000,
                0,
                0,
                facture_.mon3/1000,
                null,
                DATE_,
                null );
           exception
          when others then
            err_code := SQLCODE;
            err_msg  := SUBSTR(SQLERRM, 1, 200);
            insert into prob_migration
              (nom_table, val_ref, sql_err, date_pro)
            values
              ('miwtfactureligne',
               V_FAC_NUM,
               err_code || '--' || err_msg,
               sysdate);
        end;
    end if;
     if to_number(facture_.fixonas) <> 0 then
         begin
         insert into miwtfactureligne (
                MFAL_SOURCE,--  VARCHAR2(100)  N      Code source/origine de la ligne [OBL]
                MFAL_REFFAE,--  VARCHAR2(100)  N      Identifiant de la facture de la ligne [OBL]
                MFAL_REFTAP,--  VARCHAR2(100)  N      Identifiant de la periode de tarif de la ligne [OBL]
                MFAL_REFART,--  VARCHAR2(100)  Y
                MFAL_LIBE,--  VARCHAR2(200)  Y
                MFAL_NUM,--  NUMBER(4)  N
                MFAL_TRAN,--  NUMBER(1)  N  1    Tranche de la ligne [OBL]
                MFAL_EXER,--  NUMBER(4)  N      Annee exercice de la ligne [OBL]
                MFAL_VOLU,--  NUMBER(15,3)  N      Volume facture de la ligne [OBL]
                MFAL_PU,--  NUMBER(12,6)  N      P.U. facture de la ligne [OBL]
                MFAL_MTHT,--  NUMBER(15,2)  N      Montant HT de la ligne [OBL]
                MFAL_MTVA,--  NUMBER(15,2)  N      Montant TVA de la ligne [OBL]
                MFAL_TTVA,--  NUMBER(15,2)  N      Taux de TVA de la ligne [OBL]
                MFAL_MTTC,--  NUMBER(15,2)  N
                MFAL_DDEBPERFAC,--  DATE  Y      Date de debut de la periode facturee de la ligne
                MFAL_DFINPERFAC,--  DATE  Y      Date de fin de la periode facturee de la ligne
                MFAL_DETAIL--  NUMBER  Y
                )
                values
               ('DIST'||v_district,
                V_FAC_NUM,
                2,
                'FIXE_ONAS_1',
                'Frais fixe onas',
                7,
                1,
                annee_,
                1,
                facture_.fixonas/1000,
                facture_.fixonas/1000,
                0,
                0,
                facture_.fixonas/1000,
                null,
                DATE_,
                null );
           exception
          when others then
            err_code := SQLCODE;
            err_msg  := SUBSTR(SQLERRM, 1, 200);
            insert into prob_migration
              (nom_table, val_ref, sql_err, date_pro)
            values
              ('miwtfactureligne',
               V_FAC_NUM,
               err_code || '--' || err_msg,
               sysdate);
        end;
    end if;
     if to_number(facture_.FRLETTRE) <> 0 then
         begin
         insert into miwtfactureligne (
                MFAL_SOURCE,--  VARCHAR2(100)  N      Code source/origine de la ligne [OBL]
                MFAL_REFFAE,--  VARCHAR2(100)  N      Identifiant de la facture de la ligne [OBL]
                MFAL_REFTAP,--  VARCHAR2(100)  N      Identifiant de la periode de tarif de la ligne [OBL]
                MFAL_REFART,--  VARCHAR2(100)  Y
                MFAL_LIBE,--  VARCHAR2(200)  Y
                MFAL_NUM,--  NUMBER(4)  N
                MFAL_TRAN,--  NUMBER(1)  N  1    Tranche de la ligne [OBL]
                MFAL_EXER,--  NUMBER(4)  N      Annee exercice de la ligne [OBL]
                MFAL_VOLU,--  NUMBER(15,3)  N      Volume facture de la ligne [OBL]
                MFAL_PU,--  NUMBER(12,6)  N      P.U. facture de la ligne [OBL]
                MFAL_MTHT,--  NUMBER(15,2)  N      Montant HT de la ligne [OBL]
                MFAL_MTVA,--  NUMBER(15,2)  N      Montant TVA de la ligne [OBL]
                MFAL_TTVA,--  NUMBER(15,2)  N      Taux de TVA de la ligne [OBL]
                MFAL_MTTC,--  NUMBER(15,2)  N
                MFAL_DDEBPERFAC,--  DATE  Y      Date de debut de la periode facturee de la ligne
                MFAL_DFINPERFAC,--  DATE  Y      Date de fin de la periode facturee de la ligne
                MFAL_DETAIL--  NUMBER  Y
                )
                values
               ('DIST'||v_district,
                V_FAC_NUM,
                1,
                'FRAIS_FRM_DEP',
                'Frais lettre ',
                8,
                1,
                annee_,
                1,
                1.900,
                1.900,
                0,
                0,
                1.900,
                null,
                DATE_,
                null );
           exception
          when others then
            err_code := SQLCODE;
            err_msg  := SUBSTR(SQLERRM, 1, 200);
            insert into prob_migration
              (nom_table, val_ref, sql_err, date_pro)
            values
              ('miwtfactureligne',
               V_FAC_NUM,
               err_code || '--' || err_msg,
               sysdate);
        end;
    end if;
      if to_number(facture_.fraisctr) <> 0 then
         begin
         insert into miwtfactureligne (
                MFAL_SOURCE,--  VARCHAR2(100)  N      Code source/origine de la ligne [OBL]
                MFAL_REFFAE,--  VARCHAR2(100)  N      Identifiant de la facture de la ligne [OBL]
                MFAL_REFTAP,--  VARCHAR2(100)  N      Identifiant de la periode de tarif de la ligne [OBL]
                MFAL_REFART,--  VARCHAR2(100)  Y
                MFAL_LIBE,--  VARCHAR2(200)  Y
                MFAL_NUM,--  NUMBER(4)  N
                MFAL_TRAN,--  NUMBER(1)  N  1    Tranche de la ligne [OBL]
                MFAL_EXER,--  NUMBER(4)  N      Annee exercice de la ligne [OBL]
                MFAL_VOLU,--  NUMBER(15,3)  N      Volume facture de la ligne [OBL]
                MFAL_PU,--  NUMBER(12,6)  N      P.U. facture de la ligne [OBL]
                MFAL_MTHT,--  NUMBER(15,2)  N      Montant HT de la ligne [OBL]
                MFAL_MTVA,--  NUMBER(15,2)  N      Montant TVA de la ligne [OBL]
                MFAL_TTVA,--  NUMBER(15,2)  N      Taux de TVA de la ligne [OBL]
                MFAL_MTTC,--  NUMBER(15,2)  N
                MFAL_DDEBPERFAC,--  DATE  Y      Date de debut de la periode facturee de la ligne
                MFAL_DFINPERFAC,--  DATE  Y      Date de fin de la periode facturee de la ligne
                MFAL_DETAIL--  NUMBER  Y
                )
                values
               ('DIST'||v_district,
                V_FAC_NUM,
                1,
                'FRS_FIX_CSM',
                'Frais fixe sonnede',
                9,
                1,
                annee_,
                1,
                facture_.fraisctr/1000,
                facture_.fraisctr/1000,
                facture_.TVA/1000,
                18,
                facture_.fraisctr/1000+(facture_.TVA/1000),
                null,
                DATE_,
                null );
           exception
          when others then
            err_code := SQLCODE;
            err_msg  := SUBSTR(SQLERRM, 1, 200);
            insert into prob_migration
              (nom_table, val_ref, sql_err, date_pro)
            values
              ('miwtfactureligne',
               V_FAC_NUM,
               err_code || '--' || err_msg,
               sysdate);
        end;
    end if;
     if to_number(facture_.FRferm) <> 0 then
         begin
         insert into miwtfactureligne (
                MFAL_SOURCE,--  VARCHAR2(100)  N      Code source/origine de la ligne [OBL]
                MFAL_REFFAE,--  VARCHAR2(100)  N      Identifiant de la facture de la ligne [OBL]
                MFAL_REFTAP,--  VARCHAR2(100)  N      Identifiant de la periode de tarif de la ligne [OBL]
                MFAL_REFART,--  VARCHAR2(100)  Y
                MFAL_LIBE,--  VARCHAR2(200)  Y
                MFAL_NUM,--  NUMBER(4)  N
                MFAL_TRAN,--  NUMBER(1)  N  1    Tranche de la ligne [OBL]
                MFAL_EXER,--  NUMBER(4)  N      Annee exercice de la ligne [OBL]
                MFAL_VOLU,--  NUMBER(15,3)  N      Volume facture de la ligne [OBL]
                MFAL_PU,--  NUMBER(12,6)  N      P.U. facture de la ligne [OBL]
                MFAL_MTHT,--  NUMBER(15,2)  N      Montant HT de la ligne [OBL]
                MFAL_MTVA,--  NUMBER(15,2)  N      Montant TVA de la ligne [OBL]
                MFAL_TTVA,--  NUMBER(15,2)  N      Taux de TVA de la ligne [OBL]
                MFAL_MTTC,--  NUMBER(15,2)  N
                MFAL_DDEBPERFAC,--  DATE  Y      Date de debut de la periode facturee de la ligne
                MFAL_DFINPERFAC,--  DATE  Y      Date de fin de la periode facturee de la ligne
                MFAL_DETAIL--  NUMBER  Y
                )
                values
               ('DIST'||v_district,
                V_FAC_NUM,
                1,
                'FRAIS-FERM',
                'Frais FERMETURE',
                10,
                1,
                annee_,
                1,
                facture_.FRFERM/1000,
                facture_.FRFERM/1000,
                0,
                0,
                facture_.FRFERM/1000,
                null,
                DATE_,
                null );
           exception
          when others then
            err_code := SQLCODE;
            err_msg  := SUBSTR(SQLERRM, 1, 200);
            insert into prob_migration
              (nom_table, val_ref, sql_err, date_pro)
            values
              ('miwtfactureligne',
               V_FAC_NUM,
               err_code || '--' || err_msg,
               sysdate);
        end;
    end if;
     if to_number(facture_.CAPIT) <> 0 then
         begin
         insert into miwtfactureligne (
                MFAL_SOURCE,--  VARCHAR2(100)  N      Code source/origine de la ligne [OBL]
                MFAL_REFFAE,--  VARCHAR2(100)  N      Identifiant de la facture de la ligne [OBL]
                MFAL_REFTAP,--  VARCHAR2(100)  N      Identifiant de la periode de tarif de la ligne [OBL]
                MFAL_REFART,--  VARCHAR2(100)  Y
                MFAL_LIBE,--  VARCHAR2(200)  Y
                MFAL_NUM,--  NUMBER(4)  N
                MFAL_TRAN,--  NUMBER(1)  N  1    Tranche de la ligne [OBL]
                MFAL_EXER,--  NUMBER(4)  N      Annee exercice de la ligne [OBL]
                MFAL_VOLU,--  NUMBER(15,3)  N      Volume facture de la ligne [OBL]
                MFAL_PU,--  NUMBER(12,6)  N      P.U. facture de la ligne [OBL]
                MFAL_MTHT,--  NUMBER(15,2)  N      Montant HT de la ligne [OBL]
                MFAL_MTVA,--  NUMBER(15,2)  N      Montant TVA de la ligne [OBL]
                MFAL_TTVA,--  NUMBER(15,2)  N      Taux de TVA de la ligne [OBL]
                MFAL_MTTC,--  NUMBER(15,2)  N
                MFAL_DDEBPERFAC,--  DATE  Y      Date de debut de la periode facturee de la ligne
                MFAL_DFINPERFAC,--  DATE  Y      Date de fin de la periode facturee de la ligne
                MFAL_DETAIL--  NUMBER  Y
                )
                values
               ('DIST'||v_district,
                V_FAC_NUM,
                2,
                'CAPITAL',
                'Montant capital',
                11,
                1,
                annee_,
                1,
                facture_.CAPIT/1000,
                facture_.CAPIT/1000,
                0,
                0,
                facture_.CAPIT/1000,
                null,
                DATE_,
                null );
           exception
          when others then
            err_code := SQLCODE;
            err_msg  := SUBSTR(SQLERRM, 1, 200);
            insert into prob_migration
              (nom_table, val_ref, sql_err, date_pro)
            values
              ('miwtfactureligne',
               V_FAC_NUM,
               err_code || '--' || err_msg,
               sysdate);
        end;
    end if;
     if to_number(facture_.INTER) <> 0 then
         begin
         insert into miwtfactureligne (
                MFAL_SOURCE,--  VARCHAR2(100)  N      Code source/origine de la ligne [OBL]
                MFAL_REFFAE,--  VARCHAR2(100)  N      Identifiant de la facture de la ligne [OBL]
                MFAL_REFTAP,--  VARCHAR2(100)  N      Identifiant de la periode de tarif de la ligne [OBL]
                MFAL_REFART,--  VARCHAR2(100)  Y
                MFAL_LIBE,--  VARCHAR2(200)  Y
                MFAL_NUM,--  NUMBER(4)  N
                MFAL_TRAN,--  NUMBER(1)  N  1    Tranche de la ligne [OBL]
                MFAL_EXER,--  NUMBER(4)  N      Annee exercice de la ligne [OBL]
                MFAL_VOLU,--  NUMBER(15,3)  N      Volume facture de la ligne [OBL]
                MFAL_PU,--  NUMBER(12,6)  N      P.U. facture de la ligne [OBL]
                MFAL_MTHT,--  NUMBER(15,2)  N      Montant HT de la ligne [OBL]
                MFAL_MTVA,--  NUMBER(15,2)  N      Montant TVA de la ligne [OBL]
                MFAL_TTVA,--  NUMBER(15,2)  N      Taux de TVA de la ligne [OBL]
                MFAL_MTTC,--  NUMBER(15,2)  N
                MFAL_DDEBPERFAC,--  DATE  Y      Date de debut de la periode facturee de la ligne
                MFAL_DFINPERFAC,--  DATE  Y      Date de fin de la periode facturee de la ligne
                MFAL_DETAIL--  NUMBER  Y
                )
                values
               ('DIST'||v_district,
                V_FAC_NUM,
                2,
                'INTERET',
                'Montant Interet',
                12,
                1,
                annee_,
                1,
                facture_.INTER/1000,
                facture_.INTER/1000,
                0,
                0,
                facture_.INTER/1000,
                null,
                DATE_,
                null );
           exception
          when others then
            err_code := SQLCODE;
            err_msg  := SUBSTR(SQLERRM, 1, 200);
            insert into prob_migration
              (nom_table, val_ref, sql_err, date_pro)
            values
              ('miwtfactureligne',
               V_FAC_NUM,
               err_code || '--' || err_msg,
               sysdate);
        end;
    end if;

     if to_number(facture_.RBRANCHE) <> 0 then
         begin
         insert into miwtfactureligne (
                MFAL_SOURCE,--  VARCHAR2(100)  N      Code source/origine de la ligne [OBL]
                MFAL_REFFAE,--  VARCHAR2(100)  N      Identifiant de la facture de la ligne [OBL]
                MFAL_REFTAP,--  VARCHAR2(100)  N      Identifiant de la periode de tarif de la ligne [OBL]
                MFAL_REFART,--  VARCHAR2(100)  Y
                MFAL_LIBE,--  VARCHAR2(200)  Y
                MFAL_NUM,--  NUMBER(4)  N
                MFAL_TRAN,--  NUMBER(1)  N  1    Tranche de la ligne [OBL]
                MFAL_EXER,--  NUMBER(4)  N      Annee exercice de la ligne [OBL]
                MFAL_VOLU,--  NUMBER(15,3)  N      Volume facture de la ligne [OBL]
                MFAL_PU,--  NUMBER(12,6)  N      P.U. facture de la ligne [OBL]
                MFAL_MTHT,--  NUMBER(15,2)  N      Montant HT de la ligne [OBL]
                MFAL_MTVA,--  NUMBER(15,2)  N      Montant TVA de la ligne [OBL]
                MFAL_TTVA,--  NUMBER(15,2)  N      Taux de TVA de la ligne [OBL]
                MFAL_MTTC,--  NUMBER(15,2)  N
                MFAL_DDEBPERFAC,--  DATE  Y      Date de debut de la periode facturee de la ligne
                MFAL_DFINPERFAC,--  DATE  Y      Date de fin de la periode facturee de la ligne
                MFAL_DETAIL--  NUMBER  Y
                )
                values
               ('DIST'||v_district,
                V_FAC_NUM,
                1,
                'COURETABBR',
                'Montant branchement',
                13,
                1,
                annee_,
                1,
                facture_.RBRANCHE/1000,
                facture_.RBRANCHE/1000,
                0,
                0,
                facture_.RBRANCHE/1000,
                null,
                DATE_,
                null );
           exception
          when others then
            err_code := SQLCODE;
            err_msg  := SUBSTR(SQLERRM, 1, 200);
            insert into prob_migration
              (nom_table, val_ref, sql_err, date_pro)
            values
              ('miwtfactureligne',
               V_FAC_NUM,
               err_code || '--' || err_msg,
               sysdate);
        end;
    end if;
     if to_number(facture_.RFACADE) <> 0 then
         begin
         insert into miwtfactureligne (
                MFAL_SOURCE,--  VARCHAR2(100)  N      Code source/origine de la ligne [OBL]
                MFAL_REFFAE,--  VARCHAR2(100)  N      Identifiant de la facture de la ligne [OBL]
                MFAL_REFTAP,--  VARCHAR2(100)  N      Identifiant de la periode de tarif de la ligne [OBL]
                MFAL_REFART,--  VARCHAR2(100)  Y
                MFAL_LIBE,--  VARCHAR2(200)  Y
                MFAL_NUM,--  NUMBER(4)  N
                MFAL_TRAN,--  NUMBER(1)  N  1    Tranche de la ligne [OBL]
                MFAL_EXER,--  NUMBER(4)  N      Annee exercice de la ligne [OBL]
                MFAL_VOLU,--  NUMBER(15,3)  N      Volume facture de la ligne [OBL]
                MFAL_PU,--  NUMBER(12,6)  N      P.U. facture de la ligne [OBL]
                MFAL_MTHT,--  NUMBER(15,2)  N      Montant HT de la ligne [OBL]
                MFAL_MTVA,--  NUMBER(15,2)  N      Montant TVA de la ligne [OBL]
                MFAL_TTVA,--  NUMBER(15,2)  N      Taux de TVA de la ligne [OBL]
                MFAL_MTTC,--  NUMBER(15,2)  N
                MFAL_DDEBPERFAC,--  DATE  Y      Date de debut de la periode facturee de la ligne
                MFAL_DFINPERFAC,--  DATE  Y      Date de fin de la periode facturee de la ligne
                MFAL_DETAIL--  NUMBER  Y
                )
                values
               ('DIST'||v_district,
                V_FAC_NUM,
                1,
                'RFACADE',
                'Montant facade',
                14,
                1,
                annee_,
                1,
                facture_.RFACADE/1000,
                facture_.RFACADE/1000,
                0,
                0,
                facture_.RFACADE/1000,
                null,
                DATE_,
                null );
           exception
          when others then
            err_code := SQLCODE;
            err_msg  := SUBSTR(SQLERRM, 1, 200);
            insert into prob_migration
              (nom_table, val_ref, sql_err, date_pro)
            values
              ('miwtfactureligne',
               V_FAC_NUM,
               err_code || '--' || err_msg,
               sysdate);
        end;
    end if;
     if to_number(facture_.REXTENSION) <> 0 then
         begin
         insert into miwtfactureligne (
                MFAL_SOURCE,--  VARCHAR2(100)  N      Code source/origine de la ligne [OBL]
                MFAL_REFFAE,--  VARCHAR2(100)  N      Identifiant de la facture de la ligne [OBL]
                MFAL_REFTAP,--  VARCHAR2(100)  N      Identifiant de la periode de tarif de la ligne [OBL]
                MFAL_REFART,--  VARCHAR2(100)  Y
                MFAL_LIBE,--  VARCHAR2(200)  Y
                MFAL_NUM,--  NUMBER(4)  N
                MFAL_TRAN,--  NUMBER(1)  N  1    Tranche de la ligne [OBL]
                MFAL_EXER,--  NUMBER(4)  N      Annee exercice de la ligne [OBL]
                MFAL_VOLU,--  NUMBER(15,3)  N      Volume facture de la ligne [OBL]
                MFAL_PU,--  NUMBER(12,6)  N      P.U. facture de la ligne [OBL]
                MFAL_MTHT,--  NUMBER(15,2)  N      Montant HT de la ligne [OBL]
                MFAL_MTVA,--  NUMBER(15,2)  N      Montant TVA de la ligne [OBL]
                MFAL_TTVA,--  NUMBER(15,2)  N      Taux de TVA de la ligne [OBL]
                MFAL_MTTC,--  NUMBER(15,2)  N
                MFAL_DDEBPERFAC,--  DATE  Y      Date de debut de la periode facturee de la ligne
                MFAL_DFINPERFAC,--  DATE  Y      Date de fin de la periode facturee de la ligne
                MFAL_DETAIL--  NUMBER  Y
                )
                values
               ('DIST'||v_district,
                V_FAC_NUM,
                1,
                'REXTENSION',
                'Montant extension',
                15,
                1,
                annee_,
                1,
                facture_.REXTENSION/1000,
                facture_.REXTENSION/1000,
                0,
                0,
                facture_.REXTENSION/1000,
                null,
                DATE_,
                null );
           exception
          when others then
            err_code := SQLCODE;
            err_msg  := SUBSTR(SQLERRM, 1, 200);
            insert into prob_migration
              (nom_table, val_ref, sql_err, date_pro)
            values
              ('miwtfactureligne',
               V_FAC_NUM,
               err_code || '--' || err_msg,
               sysdate);
        end;
    end if;
     if to_number(facture_.REXTENSION) <> 0 then
         begin
         insert into miwtfactureligne (
                MFAL_SOURCE,--  VARCHAR2(100)  N      Code source/origine de la ligne [OBL]
                MFAL_REFFAE,--  VARCHAR2(100)  N      Identifiant de la facture de la ligne [OBL]
                MFAL_REFTAP,--  VARCHAR2(100)  N      Identifiant de la periode de tarif de la ligne [OBL]
                MFAL_REFART,--  VARCHAR2(100)  Y
                MFAL_LIBE,--  VARCHAR2(200)  Y
                MFAL_NUM,--  NUMBER(4)  N
                MFAL_TRAN,--  NUMBER(1)  N  1    Tranche de la ligne [OBL]
                MFAL_EXER,--  NUMBER(4)  N      Annee exercice de la ligne [OBL]
                MFAL_VOLU,--  NUMBER(15,3)  N      Volume facture de la ligne [OBL]
                MFAL_PU,--  NUMBER(12,6)  N      P.U. facture de la ligne [OBL]
                MFAL_MTHT,--  NUMBER(15,2)  N      Montant HT de la ligne [OBL]
                MFAL_MTVA,--  NUMBER(15,2)  N      Montant TVA de la ligne [OBL]
                MFAL_TTVA,--  NUMBER(15,2)  N      Taux de TVA de la ligne [OBL]
                MFAL_MTTC,--  NUMBER(15,2)  N
                MFAL_DDEBPERFAC,--  DATE  Y      Date de debut de la periode facturee de la ligne
                MFAL_DFINPERFAC,--  DATE  Y      Date de fin de la periode facturee de la ligne
                MFAL_DETAIL--  NUMBER  Y
                )
                values
               ('DIST'||v_district,
                V_FAC_NUM,
                1,
                'PFINANCIER',
                'PRODUIT FINANCIER',
                16,
                1,
                annee_,
                1,
                facture_.PFINANCIER/1000,
                facture_.PFINANCIER/1000,
                0,
                0,
                facture_.PFINANCIER/1000,
                null,
                DATE_,
                null );
           exception
          when others then
            err_code := SQLCODE;
            err_msg  := SUBSTR(SQLERRM, 1, 200);
            insert into prob_migration
              (nom_table, val_ref, sql_err, date_pro)
            values
              ('miwtfactureligne',
               V_FAC_NUM,
               err_code || '--' || err_msg,
               sysdate);
        end;
    end if;
  ---------------
   if to_number(facture_.AREPOR) <> 0 then
         begin
         insert into miwtfactureligne (
                MFAL_SOURCE,--  VARCHAR2(100)  N      Code source/origine de la ligne [OBL]
                MFAL_REFFAE,--  VARCHAR2(100)  N      Identifiant de la facture de la ligne [OBL]
                MFAL_REFTAP,--  VARCHAR2(100)  N      Identifiant de la periode de tarif de la ligne [OBL]
                MFAL_REFART,--  VARCHAR2(100)  Y
                MFAL_LIBE,--  VARCHAR2(200)  Y
                MFAL_NUM,--  NUMBER(4)  N
                MFAL_TRAN,--  NUMBER(1)  N  1    Tranche de la ligne [OBL]
                MFAL_EXER,--  NUMBER(4)  N      Annee exercice de la ligne [OBL]
                MFAL_VOLU,--  NUMBER(15,3)  N      Volume facture de la ligne [OBL]
                MFAL_PU,--  NUMBER(12,6)  N      P.U. facture de la ligne [OBL]
                MFAL_MTHT,--  NUMBER(15,2)  N      Montant HT de la ligne [OBL]
                MFAL_MTVA,--  NUMBER(15,2)  N      Montant TVA de la ligne [OBL]
                MFAL_TTVA,--  NUMBER(15,2)  N      Taux de TVA de la ligne [OBL]
                MFAL_MTTC,--  NUMBER(15,2)  N
                MFAL_DDEBPERFAC,--  DATE  Y      Date de debut de la periode facturee de la ligne
                MFAL_DFINPERFAC,--  DATE  Y      Date de fin de la periode facturee de la ligne
                MFAL_DETAIL--  NUMBER  Y
                )
                values
               ('DIST'||v_district,
                V_FAC_NUM,
                1,
                'AREPOR',
                'Montant report',
                17,
                1,
                annee_,
                1,
                decode(facture_.caron,'1',1,-1)* (facture_.AREPOR/1000),
                decode(facture_.caron,'1',1,-1)* (facture_.AREPOR/1000),
                0,
                0,
                decode(facture_.caron,'1',1,-1)* (facture_.AREPOR/1000),
                null,
                DATE_,
                null );
           exception
          when others then
            err_code := SQLCODE;
            err_msg  := SUBSTR(SQLERRM, 1, 200);
            insert into prob_migration
              (nom_table, val_ref, sql_err, date_pro)
            values
              ('miwtfactureligne',
               V_FAC_NUM,
               err_code || '--' || err_msg,
               sysdate);
        end;
    end if;
     if to_number(facture_.NAROND) <> 0 then
         begin
         insert into miwtfactureligne (
                MFAL_SOURCE,--  VARCHAR2(100)  N      Code source/origine de la ligne [OBL]
                MFAL_REFFAE,--  VARCHAR2(100)  N      Identifiant de la facture de la ligne [OBL]
                MFAL_REFTAP,--  VARCHAR2(100)  N      Identifiant de la periode de tarif de la ligne [OBL]
                MFAL_REFART,--  VARCHAR2(100)  Y
                MFAL_LIBE,--  VARCHAR2(200)  Y
                MFAL_NUM,--  NUMBER(4)  N
                MFAL_TRAN,--  NUMBER(1)  N  1    Tranche de la ligne [OBL]
                MFAL_EXER,--  NUMBER(4)  N      Annee exercice de la ligne [OBL]
                MFAL_VOLU,--  NUMBER(15,3)  N      Volume facture de la ligne [OBL]
                MFAL_PU,--  NUMBER(12,6)  N      P.U. facture de la ligne [OBL]
                MFAL_MTHT,--  NUMBER(15,2)  N      Montant HT de la ligne [OBL]
                MFAL_MTVA,--  NUMBER(15,2)  N      Montant TVA de la ligne [OBL]
                MFAL_TTVA,--  NUMBER(15,2)  N      Taux de TVA de la ligne [OBL]
                MFAL_MTTC,--  NUMBER(15,2)  N
                MFAL_DDEBPERFAC,--  DATE  Y      Date de debut de la periode facturee de la ligne
                MFAL_DFINPERFAC,--  DATE  Y      Date de fin de la periode facturee de la ligne
                MFAL_DETAIL--  NUMBER  Y
                )
                values
               ('DIST'||v_district,
                V_FAC_NUM,
                1,
                'NAROND',
                'Arrondissement',
                18,
                1,
                annee_,
                1,
                decode(facture_.caron,'1',-1,1)*(facture_.NAROND/1000),
                decode(facture_.caron,'1',-1,1)*(facture_.NAROND/1000),
                0,
                0,
                decode(facture_.caron,'1',-1,1)*(facture_.NAROND/1000),
                null,
                DATE_,
                null );
           exception
          when others then
            err_code := SQLCODE;
            err_msg  := SUBSTR(SQLERRM, 1, 200);
            insert into prob_migration
              (nom_table, val_ref, sql_err, date_pro)
            values
              ('miwtfactureligne',
               V_FAC_NUM,
               err_code || '--' || err_msg,
               sysdate);
        end;
    end if;


     if to_number(facture_.DIVERS) <> 0 then
         begin
         insert into miwtfactureligne (
                MFAL_SOURCE,--  VARCHAR2(100)  N      Code source/origine de la ligne [OBL]
                MFAL_REFFAE,--  VARCHAR2(100)  N      Identifiant de la facture de la ligne [OBL]
                MFAL_REFTAP,--  VARCHAR2(100)  N      Identifiant de la periode de tarif de la ligne [OBL]
                MFAL_REFART,--  VARCHAR2(100)  Y
                MFAL_LIBE,--  VARCHAR2(200)  Y
                MFAL_NUM,--  NUMBER(4)  N
                MFAL_TRAN,--  NUMBER(1)  N  1    Tranche de la ligne [OBL]
                MFAL_EXER,--  NUMBER(4)  N      Annee exercice de la ligne [OBL]
                MFAL_VOLU,--  NUMBER(15,3)  N      Volume facture de la ligne [OBL]
                MFAL_PU,--  NUMBER(12,6)  N      P.U. facture de la ligne [OBL]
                MFAL_MTHT,--  NUMBER(15,2)  N      Montant HT de la ligne [OBL]
                MFAL_MTVA,--  NUMBER(15,2)  N      Montant TVA de la ligne [OBL]
                MFAL_TTVA,--  NUMBER(15,2)  N      Taux de TVA de la ligne [OBL]
                MFAL_MTTC,--  NUMBER(15,2)  N
                MFAL_DDEBPERFAC,--  DATE  Y      Date de debut de la periode facturee de la ligne
                MFAL_DFINPERFAC,--  DATE  Y      Date de fin de la periode facturee de la ligne
                MFAL_DETAIL--  NUMBER  Y
                )
                values
               ('DIST'||v_district,
                V_FAC_NUM,
                1,
                'AUTREFRAIS',
                'Frais Divers ',
                20,
                1,
                annee_,
                1,
                (facture_.DIVERS)/1000,
                (facture_.DIVERS)/1000,
                0,
                0,
                (facture_.DIVERS)/1000,
                null,
                DATE_,
                null );
           exception
          when others then
            err_code := SQLCODE;
            err_msg  := SUBSTR(SQLERRM, 1, 200);
            insert into prob_migration
              (nom_table, val_ref, sql_err, date_pro)
            values
              ('miwtfactureligne',
               V_FAC_NUM,
               err_code || '--' || err_msg,
               sysdate);
        end;
    end if;
     if to_number(facture_.EAUPUIT) <> 0 then
         begin
         insert into miwtfactureligne (
                MFAL_SOURCE,--  VARCHAR2(100)  N      Code source/origine de la ligne [OBL]
                MFAL_REFFAE,--  VARCHAR2(100)  N      Identifiant de la facture de la ligne [OBL]
                MFAL_REFTAP,--  VARCHAR2(100)  N      Identifiant de la periode de tarif de la ligne [OBL]
                MFAL_REFART,--  VARCHAR2(100)  Y
                MFAL_LIBE,--  VARCHAR2(200)  Y
                MFAL_NUM,--  NUMBER(4)  N
                MFAL_TRAN,--  NUMBER(1)  N  1    Tranche de la ligne [OBL]
                MFAL_EXER,--  NUMBER(4)  N      Annee exercice de la ligne [OBL]
                MFAL_VOLU,--  NUMBER(15,3)  N      Volume facture de la ligne [OBL]
                MFAL_PU,--  NUMBER(12,6)  N      P.U. facture de la ligne [OBL]
                MFAL_MTHT,--  NUMBER(15,2)  N      Montant HT de la ligne [OBL]
                MFAL_MTVA,--  NUMBER(15,2)  N      Montant TVA de la ligne [OBL]
                MFAL_TTVA,--  NUMBER(15,2)  N      Taux de TVA de la ligne [OBL]
                MFAL_MTTC,--  NUMBER(15,2)  N
                MFAL_DDEBPERFAC,--  DATE  Y      Date de debut de la periode facturee de la ligne
                MFAL_DFINPERFAC,--  DATE  Y      Date de fin de la periode facturee de la ligne
                MFAL_DETAIL--  NUMBER  Y
                )
                values
               ('DIST'||v_district,
                V_FAC_NUM,
                1,
                'VAR_ONAS_C',
                'Eau de puit ',
                21,
                1,
                annee_,
                1,
                (facture_.EAUPUIT)/1000,
                (facture_.EAUPUIT)/1000,
                0,
                0,
                (facture_.EAUPUIT)/1000,
                null,
                DATE_,
                null );
           exception
          when others then
            err_code := SQLCODE;
            err_msg  := SUBSTR(SQLERRM, 1, 200);
            insert into prob_migration
              (nom_table, val_ref, sql_err, date_pro)
            values
              ('miwtfactureligne',
               V_FAC_NUM,
               err_code || '--' || err_msg,
               sysdate);
        end;
    end if;

         select count(*) into  nbr_trt from  miwtreleve
             where mrel_refpdl =
              lpad(facture_.DIST,2,'0')||
              lpad(facture_.tou,3,'0')||
              lpad(facture_.ORD,3,'0')||
              lpad(facture_.POL,5,'0')
              And mrel_refpdl is not null
               and   annee = annee_
               and   periode = periode_
               And rownum=1;
       if nbr_trt <> 0 then
        update  miwtreleve  set mrel_fact1 = v_ID_FACTURE
             where mrel_refpdl =
              lpad(facture_.DIST,2,'0')||
              lpad(facture_.tou,3,'0')||
              lpad(facture_.ORD,3,'0')||
              lpad(facture_.POL,5,'0')
              And mrel_refpdl is not null
               and   annee = annee_
               and   periode = periode_
               And rownum=1;

          end if;
   <<XX>>

        commit;

    end loop;
      delete xx;
       insert into xx  select  substr(s.mfae_rdet,1,2) distirct,substr(s.mfae_rdet,3,3) tourne,substr(s.mfae_rdet,6,3) ordre ,substr(s.mfae_rdet,9,4)annee,
        substr(s.mfae_rdet,13,2) periode,t.mfal_reffae,sum(t.mfal_mttc) net_calc,s.mfae_solde net,sum(t.mfal_mttc)-s.mfae_solde diff,
        sum(decode(t.mfal_refart,'CAPITAL',t.mfal_mttc,'INTERET',t.mfal_mttc,0)) capit
         from miwtfactureligne t,miwtfactureentete s
         where t.mfal_reffae=s.mfae_ref
         group by t.mfal_reffae,s.mfae_solde,substr(s.mfae_rdet,1,2),substr(s.mfae_rdet,3,3),substr(s.mfae_rdet,6,3),substr(s.mfae_rdet,9,4),substr(s.mfae_rdet,13,2)
         having ((abs(sum(t.mfal_mttc)-s.mfae_solde) <>0)) ;
       commit;
          for c in (select t.*, t.rowid from XX t WHERE diff >= 0.001)
   loop
     select count(*) into x from miwtfactureligne s where s.mfal_reffae=c.mfal_reffae and s.mfal_refart='NAROND'
                                                      And 'DIST'||c.distirct=s.mfal_source;
     if x = 0 then
       insert into miwtfactureligne (
                MFAL_SOURCE,--  VARCHAR2(100)  N      Code source/origine de la ligne [OBL]
                MFAL_REFFAE,--  VARCHAR2(100)  N      Identifiant de la facture de la ligne [OBL]
                MFAL_REFTAP,--  VARCHAR2(100)  N      Identifiant de la periode de tarif de la ligne [OBL]
                MFAL_REFART,--  VARCHAR2(100)  Y
                MFAL_LIBE,--  VARCHAR2(200)  Y
                MFAL_NUM,--  NUMBER(4)  N
                MFAL_TRAN,--  NUMBER(1)  N  1    Tranche de la ligne [OBL]
                MFAL_EXER,--  NUMBER(4)  N      Annee exercice de la ligne [OBL]
                MFAL_VOLU,--  NUMBER(15,3)  N      Volume facture de la ligne [OBL]
                MFAL_PU,--  NUMBER(12,6)  N      P.U. facture de la ligne [OBL]
                MFAL_MTHT,--  NUMBER(15,2)  N      Montant HT de la ligne [OBL]
                MFAL_MTVA,--  NUMBER(15,2)  N      Montant TVA de la ligne [OBL]
                MFAL_TTVA,--  NUMBER(15,2)  N      Taux de TVA de la ligne [OBL]
                MFAL_MTTC,--  NUMBER(15,2)  N
                MFAL_DDEBPERFAC,--  DATE  Y      Date de debut de la periode facturee de la ligne
                MFAL_DFINPERFAC,--  DATE  Y      Date de fin de la periode facturee de la ligne
                MFAL_DETAIL--  NUMBER  Y
                )
                values
               ('DIST'||c.distirct,
                c.mfal_reffae,
                1,
                'NAROND',
                'Arrondissement',
                18,
                1,
                c.annee,
                1,
                (-1)*(c.diff),
                 (-1)*(c.diff),
                0,
                0,
                 (-1)*(c.diff),
                null,
                null,
                null );
             else
               update miwtfactureligne set MFAL_PU=MFAL_PU-c.diff,
                                           MFAL_MTHT=MFAL_MTHT-c.diff,
                                           MFAL_MTTC=MFAL_MTTC-c.diff
                                           where
                                           mfal_reffae=c.mfal_reffae and mfal_refart='NAROND'
                                            And 'DIST'||c.distirct=mfal_source;
             end if;


          end loop;
          commit;


  end;
-------- Traitement des facture District
 procedure MIWT_FACTURE_DIST (v_district in varchar2) is
     --********************************* TRAITEMENT DES FACTURES  A PARTIR TABLE facture
    err_code        varchar2(200);
    err_msg         varchar2(200);
    V_FAC_NUM       number;
    V_FAC_RESTANTDU  number;
    V_FAC_DATECALCUL date;
    V_FAC_ABN_NUM    number(20);
    V_TRAIN_FACT       varchar2(200);
    V_REF_ABN        varchar2(200);
    nbr_trt   number := 0;


  v_ID_FACTURE   varchar2(20);
  v_ID_FACTURE_orig varchar2(20);
  annee_ number(4);
  periode_ number;
  version number(1) := 1;
  mois_ number;
   date_          date;
   WMFAE_REF      number;
  begin

    --**************************************************
   delete prob_migration where
              nom_table in
              ('miwtfacture-DIST','SEQ_RELEVE','miwtfactureligne');
    commit;
     --**************************************************
    -- reception de la liste des releves
    select max(nvl(to_number(MFAE_REF),0)) into  V_FAC_NUM from miwtfactureentete where MFAE_SOURCE = 'DIST'||v_district;
       if V_FAC_NUM is null then
             V_FAC_NUM        := 0;    end if;
    for facture_ in (select * from facture  where etat in ('A','P')  and
                      exists (select 'X' from miwtfactureentete where MFAE_SOURCE='DIST'||v_district
                      And MFAE_REFTRF = to_char(annee)||lpad(ltrim(rtrim(periode)),2,'0')
                      and substr(mfae_rdet,1,8) = (ltrim(rtrim(DISTRICT))||lpad(ltrim(rtrim(tournee)),3,'0')||
                      lpad(ltrim(rtrim(ORDRE)),3,'0')))) loop
     V_FAC_NUM        := V_FAC_NUM +1;
      --**************************************************
       periode_ := facture_.periode;
       IF facture_.periodicite <> 'G' then
       begin
       select m3  into mois_ from param_tournee where DISTRICT=facture_.district
                                                     And TRIM =facture_.periode
                                                     And TIER = facture_.TIERS
                                      and (TIER,SIX) in (select NTIERS,NSIXIEME from tourne
                                                 where code=lpad(ltrim(rtrim(facture_.tournee)),3,'0'));
        exception
          when others then
            err_code := SQLCODE;
            err_msg  := SUBSTR(SQLERRM, 1, 200);
            insert into prob_migration
              (nom_table, val_ref, sql_err, date_pro)
            values
              ('miwtfacture-DIST','Tou:'||lpad(ltrim(rtrim(facture_.tournee)),3,'0')||'ORD:'||lpad(ltrim(rtrim(facture_.Ordre)),3,'0')||'TRIM :'||facture_.periode||'TIER :'||facture_.TIERS||'AA:'||facture_.ANNEE||'POL:'||lpad(ltrim(rtrim(facture_.POLICE)),5,'0'),
                 err_msg ||'-- periode ',sysdate);
          periode_ := facture_.periode;
           IF periode_ = 1 THEN
             mois_:='01';
            ELSIF periode_ = 2 THEN
            mois_:='04';
            ELSIF periode_ = 3 THEN
            MOIS_:='07';
            ELSIF periode_ = 4 THEN
            mois_:='10';
           end if;
        end;
        else
        mois_ := facture_.periode;
        end if;
        BEGIN
         select last_day(to_date('01'||lpad(mois_,2,0)||facture_.ANNEE,'ddmmyyyy')) into date_ from dual;
         EXCEPTION WHEN OTHERS THEN insert into prob_migration
              (nom_table, val_ref, sql_err, date_pro)
            values
              ('miwtfacture-DIST','MOIS:'||mois_||'ANNEE:'||facture_.ANNEE||'TRIM :'||facture_.periode||'TIER :'||facture_.TIERS||'POL:'||lpad(ltrim(rtrim(facture_.POLICE)),5,'0'),
                 err_msg ||'-- DATE ',sysdate);

        END;
         annee_ :=to_char(date_,'yyyy');
      -- suivi en temps reel du traitement
      nbr_trt := nbr_trt + 1;
      --************************************************
      V_FAC_RESTANTDU  := null;
      V_FAC_DATECALCUL := null;
      V_FAC_ABN_NUM    := null;
      V_REF_ABN        := null;

      BEGIN

      select (r.mrel_date+1) INTO  V_FAC_DATECALCUL from  miwtreleve r
             where r.mrel_refpdl =
              lpad(facture_.DISTRICT,2,'0')||
              lpad(ltrim(rtrim(facture_.tournee)),3,'0')||
              lpad(ltrim(rtrim(facture_.Ordre)),3,'0')||
              lpad(ltrim(rtrim(facture_.POLICE)),5,'0')
              And mrel_refpdl is not null
               and   r.annee = annee_
               and   r.periode = periode_
               And rownum=1;
               Exception  when others then
               V_FAC_DATECALCUL := date_;
            end;
begin
        -- reception de l'identfiant de l'abonnement
        V_TRAIN_FACT :=  ltrim(rtrim(annee_)) ||
                         lpad(to_char(periode_),2,'0');
        v_ID_FACTURE:=ltrim(rtrim(facture_.DISTRICT)) ||
                      lpad(ltrim(rtrim(facture_.tournee)),3,'0') ||
                      lpad(ltrim(rtrim(facture_.ORDRE)),3,'0')||
                      to_char(annee_) ||
                    lpad(to_char(periode_),2,'0')||to_char(facture_.version);
        v_ID_FACTURE_orig:=ltrim(rtrim(facture_.DISTRICT)) ||
                     lpad(ltrim(rtrim(facture_.tournee)),3,'0') ||
                     lpad(ltrim(rtrim(facture_.ORDRE)),3,'0')||
                     to_char(annee_) ||
                     lpad(to_char(periode_),2,'0')||to_char(facture_.version);
        for ref_abn_ in (select *
                           from miwabn a
                          where substr(a.abn_refsite,1,8) = lpad(facture_.DISTRICT,2,'0') ||
                        lpad(ltrim(rtrim(facture_.tournee)),3,'0') ||
                        lpad(ltrim(rtrim(facture_.Ordre)),3,'0')) loop
          V_FAC_ABN_NUM := ref_abn_.abn_ref;
          V_REF_ABN := ref_abn_.ABN_REFPER_A;
        end loop;
        if V_FAC_ABN_NUM  is null then V_FAC_ABN_NUM := lpad(facture_.DISTRICT,2,'0') ||
                        lpad(ltrim(rtrim(facture_.tournee)),3,'0') ||
                        lpad(ltrim(rtrim(facture_.Ordre)),3,'0') ||
                        lpad(ltrim(rtrim(facture_.POLICE)),5,'0');
         end if;
         exception
          when others then
            err_code := SQLCODE;
            err_msg  := SUBSTR(SQLERRM, 1, 200);
            insert into prob_migration
              (nom_table, val_ref, sql_err, date_pro)
            values
              ('miwtfactureAA-DIST','Tou:'||lpad(ltrim(rtrim(facture_.tournee)),3,'0')||'ORD:'||lpad(ltrim(rtrim(facture_.Ordre)),3,'0')||'TRIM :'||facture_.periode||'TIER :'||facture_.TIERS||'AA:'||facture_.ANNEE||'POL:'||lpad(ltrim(rtrim(facture_.POLICE)),5,'0'),
                 err_msg ||'-- periode ',sysdate);
                 end;
        -- Insertion de la facture
        if facture_.etat='A' then
          ----
           select MFAE_REF into wMFAE_REF from miwtfactureentete where
            (ltrim(rtrim(facture_.DISTRICT))||lpad(ltrim(rtrim(facture_.tournee)),3,'0')||lpad(ltrim(rtrim(facture_.ORDRE)),3,'0')||
                      to_char(facture_.annee) ||lpad(ltrim(rtrim(facture_.periode)),2,'0')||'0')
                      = mfae_rdet and MFAE_SOURCE='DIST'||v_district;
         ---
        begin
        insert into miwtfactureentete
        (
        MFAE_SOURCE,--1       VARCHAR2(100) N     Code source/origine de la facture [OBL]
        MFAE_REF,   --2      VARCHAR2(100)  N     Identifiant unique de la facture pour la source [OBL]
        MFAE_REFTRF,--3    VARCHAR2(100)  Y     Identifiant du train de la facture
        MFAE_NUME,  --4      NUMBER(10) Y     Numero de la facture [OBL]
        MFAE_RDET,  --5      VARCHAR2(15) Y     RDET de la facture
        MFAE_CCMO,  --6      VARCHAR2(1)  Y     Cle controle RDET de la facture
        MFAE_DEDI,  --7      DATE N     Date d edition de la facture [OBL]
        MFAE_DLPAI, --8    DATE Y     Date limite de paiement de la facture [OBL]
        MFAE_DPREL,--9     DATE Y     Date de prelevement de la facture [OBL]
        MFAE_TOTHTE,--10   NUMBER(10,2) N     Total HT EAU de la facture [OBL]
        MFAE_TOTTVAE,--11  NUMBER(10,2) N     Total TVA EAU de la facture [OBL]
        MFAE_TOTHTA,--12   NUMBER(10,2) N     Total HT ASS de la facture [OBL]
        MFAE_TOTTVAA,--13  NUMBER(10,2) N     Total TVA ASS de la facture [OBL]
        MFAE_SOLDE,--14    NUMBER(10,2) Y     Solde TTC de la facture
        MFAE_TYPE,--15     VARCHAR2(2)  N 'R'
        MFAE_REFFAEDEDU,--16  VARCHAR2(100) Y
        MFAE_REFABN,--17      VARCHAR2(100) N     Identifiant du contrat de la facture [OBL]
        MFAE_REF_CODNIV_RELANCE,--18  VARCHAR2(100) Y     Reference Code niveau de chainde relance
        MFAE_RIB_REF,--19             VARCHAR2(100) Y     Reference Rib
        MFAE_RIB_ETAT,--20            NUMBER(1) Y     Mode de payement (pr?l?vement 1 ou tip 2)
        MFAE_COMPTEAUX,--21           VARCHAR2(100) Y     Compte auxilaire GENACCOUNT associe a la facture
        MFAE_REF_ORIGINE,--22         VARCHAR2(100) Y     Facture origine
        MFAE_COMMENT,--23             VARCHAR2(4000)  Y     Commentaire libre Facture
        MFAE_AMOUNTTTCDEC,--24        NUMBER(17,10) Y     Montant TTC a deduire
        VOC_MODEFACT,--25             VARCHAR2(10)  Y
        MFAE_REF_DEDUC,--26           VARCHAR2(100) Y
        MFAE_REFORGA,--27             VARCHAR2(100) Y
        MFAE_EXERCICE,--28            NUMBER(4) Y     Exercice du role de la facture
        MFAE_NUMEROROLE,--29          NUMBER(4) Y      Numero du role pour l exercice
        MFAE_PREL,      --30          NUMBER  Y
        MFAE_AROND--31                NUMBER  Y
         )

       (
        SELECT
        'DIST'||v_district,               --1
        V_FAC_NUM,            --2
        V_TRAIN_FACT,         --3
        V_FAC_NUM,            --4
        v_ID_FACTURE,         --5
        MFAE_CCMO,                 --6
        V_FAC_DATECALCUL,     --7
        V_FAC_DATECALCUL,     --8
        V_FAC_DATECALCUL,     --9
        MFAE_TOTHTE,   --10
        MFAE_TOTTVAE,                   --11
        MFAE_TOTHTA,                   --12
        MFAE_TOTTVAA,                   --13
        MFAE_SOLDE,     --14
        'FA',                --15
        MFAE_REFFAEDEDU,                --16
        V_FAC_ABN_NUM,       --17
        'INCONNUE',                --18
        MFAE_RIB_REF,                --19
        4,                --20
        'IMP_MIG',           --21
        MFAE_RDET,    --22
        MFAE_COMMENT,                 --23
        MFAE_AMOUNTTTCDEC,                 --24
        4,                   --25
        NULL,                 --26
        v_district,            --27
        annee_,               --28
        periode_,              --29
        MFAE_PREL ,                 --30
        MFAE_AROND   --31
        from miwtfactureentete where
        MFAE_REF = wMFAE_REF and MFAE_SOURCE='DIST'||v_district
        );
        exception
          when others then
            err_code := SQLCODE;
            err_msg  := SUBSTR(SQLERRM, 1, 200);
            insert into prob_migration
              (nom_table, val_ref, sql_err, date_pro)
            values
              ('miwtfacture-DIST',
               lpad(facture_.district,2,'0') ||
               lpad(ltrim(rtrim(facture_.tournee)),3,'0') ||
               lpad(ltrim(rtrim(facture_.Ordre)),3,'0') ||
               lpad(ltrim(rtrim(facture_.POLICE)),5,'0'),
               err_code || '--' || err_msg,
               sysdate);
        end;
              update miwtfactureentete set MFAE_REF_ORIGINE=v_ID_FACTURE  where
                  MFAE_REF = wMFAE_REF and MFAE_SOURCE='DIST'||v_district;
        -----------
           begin
           insert into miwtfactureligne (
                MFAL_SOURCE,--  VARCHAR2(100)  N      Code source/origine de la ligne [OBL]
                MFAL_REFFAE,--  VARCHAR2(100)  N      Identifiant de la facture de la ligne [OBL]
                MFAL_REFTAP,--  VARCHAR2(100)  N      Identifiant de la periode de tarif de la ligne [OBL]
                MFAL_REFART,--  VARCHAR2(100)  Y
                MFAL_LIBE,--  VARCHAR2(200)  Y
                MFAL_NUM,--  NUMBER(4)  N
                MFAL_TRAN,--  NUMBER(1)  N  1    Tranche de la ligne [OBL]
                MFAL_EXER,--  NUMBER(4)  N      Annee exercice de la ligne [OBL]
                MFAL_VOLU,--  NUMBER(15,3)  N      Volume facture de la ligne [OBL]
                MFAL_PU,--  NUMBER(12,6)  N      P.U. facture de la ligne [OBL]
                MFAL_MTHT,--  NUMBER(15,2)  N      Montant HT de la ligne [OBL]
                MFAL_MTVA,--  NUMBER(15,2)  N      Montant TVA de la ligne [OBL]
                MFAL_TTVA,--  NUMBER(15,2)  N      Taux de TVA de la ligne [OBL]
                MFAL_MTTC,--  NUMBER(15,2)  N
                MFAL_DDEBPERFAC,--  DATE  Y      Date de debut de la periode facturee de la ligne
                MFAL_DFINPERFAC,--  DATE  Y      Date de fin de la periode facturee de la ligne
                MFAL_DETAIL--  NUMBER  Y
                )
                ( select MFAL_SOURCE,--  VARCHAR2(100)  N      Code source/origine de la ligne [OBL]
                V_FAC_NUM,--  VARCHAR2(100)  N      Identifiant de la facture de la ligne [OBL]
                MFAL_REFTAP,--  VARCHAR2(100)  N      Identifiant de la periode de tarif de la ligne [OBL]
                MFAL_REFART,--  VARCHAR2(100)  Y
                MFAL_LIBE,--  VARCHAR2(200)  Y
                MFAL_NUM,--  NUMBER(4)  N
                MFAL_TRAN,--  NUMBER(1)  N  1    Tranche de la ligne [OBL]
                MFAL_EXER,--  NUMBER(4)  N      Annee exercice de la ligne [OBL]
                MFAL_VOLU,--  NUMBER(15,3)  N      Volume facture de la ligne [OBL]
                MFAL_PU,--  NUMBER(12,6)  N      P.U. facture de la ligne [OBL]
                MFAL_MTHT,--  NUMBER(15,2)  N      Montant HT de la ligne [OBL]
                MFAL_MTVA,--  NUMBER(15,2)  N      Montant TVA de la ligne [OBL]
                MFAL_TTVA,--  NUMBER(15,2)  N      Taux de TVA de la ligne [OBL]
                MFAL_MTTC,--  NUMBER(15,2)  N
                MFAL_DDEBPERFAC,--  DATE  Y      Date de debut de la periode facturee de la ligne
                MFAL_DFINPERFAC,--  DATE  Y      Date de fin de la periode facturee de la ligne
                MFAL_DETAIL from miwtfactureligne where  MFAL_REFFAE = wMFAE_REF
                and MFAL_SOURCE='DIST'||v_district);
           exception
          when others then
            err_code := SQLCODE;
            err_msg  := SUBSTR(SQLERRM, 1, 200);
            insert into prob_migration
              (nom_table, val_ref, sql_err, date_pro)
            values
              ('miwtfactureligne-DIST',
               V_FAC_NUM,
               err_code || '--' || err_msg,
               sysdate);
        end;
        else
            v_ID_FACTURE_orig:=ltrim(rtrim(facture_.DISTRICT)) ||
                     lpad(ltrim(rtrim(facture_.tournee)),3,'0') ||
                     lpad(ltrim(rtrim(facture_.ORDRE)),3,'0')||
                     to_char(annee_) ||
                     lpad(to_char(periode_),2,'0')||to_char(version);
        begin
         insert into miwtfactureentete
        (
        MFAE_SOURCE,--1       VARCHAR2(100) N     Code source/origine de la facture [OBL]
        MFAE_REF,   --2      VARCHAR2(100)  N     Identifiant unique de la facture pour la source [OBL]
        MFAE_REFTRF,--3    VARCHAR2(100)  Y     Identifiant du train de la facture
        MFAE_NUME,  --4      NUMBER(10) Y     Numero de la facture [OBL]
        MFAE_RDET,  --5      VARCHAR2(15) Y     RDET de la facture
        MFAE_CCMO,  --6      VARCHAR2(1)  Y     Cle controle RDET de la facture
        MFAE_DEDI,  --7      DATE N     Date d edition de la facture [OBL]
        MFAE_DLPAI, --8    DATE Y     Date limite de paiement de la facture [OBL]
        MFAE_DPREL,--9     DATE Y     Date de prelevement de la facture [OBL]
        MFAE_TOTHTE,--10   NUMBER(10,2) N     Total HT EAU de la facture [OBL]
        MFAE_TOTTVAE,--11  NUMBER(10,2) N     Total TVA EAU de la facture [OBL]
        MFAE_TOTHTA,--12   NUMBER(10,2) N     Total HT ASS de la facture [OBL]
        MFAE_TOTTVAA,--13  NUMBER(10,2) N     Total TVA ASS de la facture [OBL]
        MFAE_SOLDE,--14    NUMBER(10,2) Y     Solde TTC de la facture
        MFAE_TYPE,--15     VARCHAR2(2)  N 'R'
        MFAE_REFFAEDEDU,--16  VARCHAR2(100) Y
        MFAE_REFABN,--17      VARCHAR2(100) N     Identifiant du contrat de la facture [OBL]
        MFAE_REF_CODNIV_RELANCE,--18  VARCHAR2(100) Y     Reference Code niveau de chainde relance
        MFAE_RIB_REF,--19             VARCHAR2(100) Y     Reference Rib
        MFAE_RIB_ETAT,--20            NUMBER(1) Y     Mode de payement (pr?l?vement 1 ou tip 2)
        MFAE_COMPTEAUX,--21           VARCHAR2(100) Y     Compte auxilaire GENACCOUNT associe a la facture
        MFAE_REF_ORIGINE,--22         VARCHAR2(100) Y     Facture origine
        MFAE_COMMENT,--23             VARCHAR2(4000)  Y     Commentaire libre Facture
        MFAE_AMOUNTTTCDEC,--24        NUMBER(17,10) Y     Montant TTC a deduire
        VOC_MODEFACT,--25             VARCHAR2(10)  Y
        MFAE_REF_DEDUC,--26           VARCHAR2(100) Y
        MFAE_REFORGA,--27             VARCHAR2(100) Y
        MFAE_EXERCICE,--28            NUMBER(4) Y     Exercice du role de la facture
        MFAE_NUMEROROLE,--29          NUMBER(4) Y      Numero du role pour l exercice
        MFAE_PREL,      --30                  NUMBER  Y
        MFAE_AROND--31                  NUMBER  Y
         )
       values
       (
        'DIST'||v_district,               --1
        V_FAC_NUM,            --2
        V_TRAIN_FACT,         --3
        V_FAC_NUM,            --4
        v_ID_FACTURE,         --5
        NULL,                 --6
        V_FAC_DATECALCUL,     --7
        V_FAC_DATECALCUL,     --8
        V_FAC_DATECALCUL,     --9
        facture_.net_a_payer/1000,   --10
        0,                   --11
        0,                   --12
        0,                   --13
         facture_.net_a_payer/1000,     --14
        decode(facture_.etat,'P','RF','O','FC','C','FHC','FC'),                --15
        NULL,                --16
        V_FAC_ABN_NUM,       --17
        'INCONNUE',                --18
         null,                --19
        4,                --20
        'IMP_MIG',           --21
        decode(facture_.etat,'A',v_ID_FACTURE_orig,null),    --22
        V_REF_ABN,                 --23
        NULL,                 --24
        4,                   --25
        NULL,                 --26
        v_district,            --27
        annee_,               --28
        periode_,              --29
        1 ,                 --30
        0   --31
        );
        exception
          when others then
            err_code := SQLCODE;
            err_msg  := SUBSTR(SQLERRM, 1, 200);
            insert into prob_migration
              (nom_table, val_ref, sql_err, date_pro)
            values
              ('miwtfacture-DIST',
               lpad(facture_.district,2,'0') ||
               lpad(ltrim(rtrim(facture_.tournee)),3,'0') ||
               lpad(ltrim(rtrim(facture_.Ordre)),3,'0') ||
               lpad(ltrim(rtrim(facture_.POLICE)),5,'0'),
               err_code || '--' || err_msg,
               sysdate);
        end;
        -----------

        end if;
          select count(*) into  nbr_trt from  miwtreleve
             where mrel_refpdl =
              lpad(facture_.DISTRICT,2,'0')||
              lpad(ltrim(rtrim(facture_.tournee)),3,'0')||
              lpad(ltrim(rtrim(facture_.Ordre)),3,'0')||
              lpad(ltrim(rtrim(facture_.POLICE)),5,'0')
              And mrel_refpdl is not null
               and   annee = annee_
               and   periode = periode_
               And rownum=1;
       if nbr_trt <> 0 then
        update  miwtreleve  set mrel_fact1 = v_ID_FACTURE
             where mrel_refpdl =
              lpad(facture_.DISTRICT,2,'0')||
              lpad(ltrim(rtrim(facture_.tournee)),3,'0')||
              lpad(ltrim(rtrim(facture_.Ordre)),3,'0')||
              lpad(ltrim(rtrim(facture_.POLICE)),5,'0')
              And mrel_refpdl is not null
               and   annee = annee_
               and   periode = periode_
               And rownum=1;
                 end if;

        commit;

    end loop;

  end;

-----
-----
procedure MIWT_ENC (v_district in varchar2) is
    --********************************* TRAITEMENT DES FACTURES  A PARTIR TABLE IMPAYEES_PART
    err_code        varchar2(200);
    err_msg         varchar2(200);
  --  v_msg            varchar2(800);

    V_FAC_NUM       number;

   v_ID_FACTURE  varchar2(200);
    V_FAC_ABN_NUM    number(20);
    V_REF_FACT       varchar2(200);
    V_TRAIN_FACT       varchar2(200);
    V_REF_ABN        varchar2(200);
    V_ENC_NUM        number;
     periode_ number;
  begin

    --**************************************************
     delete prob_migration where
              nom_table in
              ('miwtrgl','miwtenc');

    select max(to_number(MENC_REF))  into V_ENC_NUM from miwtenc WHERE Menc_SOURCE= 'DIST'||v_district;
    --**************************************************
    -- reception de la liste des releves
    if v_enc_num is null then
     V_ENC_NUM := 0;  end if;
    for facture_ in (select * from CCP WHERE district=v_district ) loop
        if ltrim(rtrim(facture_.categorie)) <> '9' then
        periode_ := substr(facture_.periode,2,1);
        else
        periode_ := facture_.periode;
        end if;

        V_TRAIN_FACT :=  ltrim(rtrim(facture_.DISTRICT)) ||ltrim(rtrim(facture_.annee)) ||
                         lpad(to_char(periode_),2,'0');
         v_ID_FACTURE:=ltrim(rtrim(facture_.DISTRICT)) ||
                      lpad(ltrim(rtrim(facture_.tournee)),3,'0') ||
                      lpad(ltrim(rtrim(facture_.ORDRE)),3,'0')||
                      to_char(facture_.annee) ||
                    lpad(to_char(periode_),2,'0');
        for ref_abn_ in (select *
                           from miwabn a
                          where substr(a.abn_refsite,1,8) = lpad(facture_.DISTRICT,2,'0') ||
                        lpad(facture_.tournee,3,'0') ||
                        lpad(facture_.ordre,3,'0')) loop
          V_FAC_ABN_NUM := ref_abn_.abn_ref;
          V_REF_ABN := ref_abn_.ABN_REFPER_A;
        end loop;
        if V_FAC_ABN_NUM  is null then V_FAC_ABN_NUM := lpad(facture_.DISTRICT,2,'0') ||
                        lpad(facture_.tournee,3,'0') ||
                        lpad(facture_.ordre,3,'0') ||
                        lpad(facture_.police,5,'0');
         end if;
        -- Insertion de la facture
             v_fac_num:=null;
           for cc in (
           select MFAE_REF, MFAE_REF_ORIGINE from miwtfactureentete where MFAE_SOURCE='DIST'||v_district
                                                               And MFAE_REFTRF=V_TRAIN_FACT
                                                               And MFAE_REFABN=V_FAC_ABN_NUM
                                                               And mfae_TYPe <>'FA'
                                                               and  MFAE_RDET like v_ID_FACTURE||'%')
           loop
           if  cc.MFAE_REF_ORIGINE is null then v_fac_num:=cc.MFAE_REF;  exit; end if;
           end loop;


         if  to_number(facture_.montant) <> 0
           then
              V_ENC_NUM := V_ENC_NUM + 1;
             begin
        insert into MIWTENC
               (
                  MENC_SOURCE,      --1
                  MENC_REF,         --2
                  MENC_REFPER,      --3
                  MENC_DATE ,       --4
                  MENC_MONTANT,     --5
                  MENC_COMMENTAIRE, --6
                  MENC_MODEPAY,     --7
                  MENC_REFECHQ,     --8
                  MENC_REFJOURNAL,  --9
                  MENC_TYPEJOURNAL, --10
                  MENC_COMPTE,      --11
                  CSH_ID,           --12
                  CAM_ID            --13
                 )
            values
                 (
                  'DIST'||v_district,      --1
                  V_ENC_NUM,         --2
                  V_REF_ABN,      --3
                  facture_.datemvt ,       --4
                  to_number(facture_.montant)/1000,     --5
                  V_FAC_ABN_NUM, --6
                  5,     --7
                  V_TRAIN_FACT,     --8
                  null,  --9
                  null, --10
                  null,      --11
                  null,           --12
                  null            --13
                 );
                          exception
          when others then
            err_code := SQLCODE;
            err_msg  := SUBSTR(SQLERRM, 1, 200);
            insert into prob_migration
              (nom_table, val_ref, sql_err, date_pro)
            values
              ('miwtenc',
               V_REF_FACT,
               err_code || '--' || err_msg,
               sysdate);
        end;
        begin
             insert into  MIWTRGL
                (
                  MRGL_SOURCE,      --1
                  MRGL_REF,         --2
                  MRGL_REFENC,     --3
                  MENC_REFABN,      --4
                  MENC_RFIMP,       --5
                  MRGL_REFFAE ,     --6
                  MRGL_MONTANT,     --7
                  MRGL_DATE ,       --8
                  MRGL_COMMENTAIRE, --9
                  MRGL_COMPTEAUX,   --10
                  PCD_ID            --11
                )
             values
                (
                  'DIST'||v_district,      --1
                  V_ENC_NUM,         --2
                  V_ENC_NUM,     --3
                  V_REF_ABN,      --4
                  null,      --5
                  V_FAC_NUM,     --6
                  to_number(facture_.montant)/1000,     --7
                  facture_.datemvt ,       --8
                  v_ID_FACTURE, --9
                  null,   --10
                  null            --11
                );

                          exception
          when others then
            err_code := SQLCODE;
            err_msg  := SUBSTR(SQLERRM, 1, 200);
            insert into prob_migration
              (nom_table, val_ref, sql_err, date_pro)
            values   ('miwtrgl', V_FAC_NUM,  err_code || '--' || err_msg, sysdate);
        end;

              commit;
           end if;
      ------------

    end loop;

  end;


-----
procedure miwt_fact_trav(v_district varchar2) is
v_ID_FACTURE   varchar2(20);
V_FAC_NUM       number;
err_code        varchar2(200);
err_msg         varchar2(200);
begin
     select max(nvl(to_number(MFAE_REF),0)) into  V_FAC_NUM from miwtfactureentete where MFAE_SOURCE = 'DIST'||v_district;
       if V_FAC_NUM is null then
             V_FAC_NUM        := 0;
       end if;
  for c in (select * from b2) loop
    v_ID_FACTURE:=ltrim(rtrim(c.DISTRICT)) ||
                      lpad(ltrim(rtrim(c.num)),2,'0') ||
                      lpad(ltrim(rtrim(c.num_devis)),6,'0')||
                      to_char(c.etat);
               V_FAC_NUM :=V_FAC_NUM+1;
  BEGIN
   insert into miwtfactureentete
        (
        MFAE_SOURCE,--1         VARCHAR2(100)  N      Code source/origine de la facture [OBL]
        MFAE_REF,   --2       VARCHAR2(100)  N      Identifiant unique de la facture pour la source [OBL]
        MFAE_REFTRF,--3     VARCHAR2(100)  Y      Identifiant du train de la facture
        MFAE_NUME,  --4       NUMBER(10)  Y      Numero de la facture [OBL]
        MFAE_RDET,  --5       VARCHAR2(15)  Y      RDET de la facture
        MFAE_CCMO,  --6       VARCHAR2(1)  Y      Cle controle RDET de la facture
        MFAE_DEDI,  --7       DATE  N      Date d edition de la facture [OBL]
        MFAE_DLPAI, --8     DATE  Y      Date limite de paiement de la facture [OBL]
        MFAE_DPREL,--9     DATE  Y      Date de prelevement de la facture [OBL]
        MFAE_TOTHTE,--10   NUMBER(10,2)  N      Total HT EAU de la facture [OBL]
        MFAE_TOTTVAE,--11   NUMBER(10,2)  N      Total TVA EAU de la facture [OBL]
        MFAE_TOTHTA,--12   NUMBER(10,2)  N      Total HT ASS de la facture [OBL]
        MFAE_TOTTVAA,--13   NUMBER(10,2)  N      Total TVA ASS de la facture [OBL]
        MFAE_SOLDE,--14     NUMBER(10,2)  Y      Solde TTC de la facture
        MFAE_TYPE,--15     VARCHAR2(2)  N  'R'
        MFAE_REFFAEDEDU,--16  VARCHAR2(100)  Y
        MFAE_REFABN,--17      VARCHAR2(100)  N      Identifiant du contrat de la facture [OBL]
        MFAE_REF_CODNIV_RELANCE,--18  VARCHAR2(100)  Y      Reference Code niveau de chainde relance
        MFAE_RIB_REF,--19              VARCHAR2(100)  Y      Reference Rib
        MFAE_RIB_ETAT,--20            NUMBER(1)  Y      Mode de payement (pr?l?vement 1 ou tip 2)
        MFAE_COMPTEAUX,--21            VARCHAR2(100)  Y      Compte auxilaire GENACCOUNT associe a la facture
        MFAE_REF_ORIGINE,--22          VARCHAR2(100)  Y      Facture origine
        MFAE_COMMENT,--23              VARCHAR2(4000)  Y      Commentaire libre Facture
        MFAE_AMOUNTTTCDEC,--24        NUMBER(17,10)  Y      Montant TTC a deduire
        VOC_MODEFACT,--25              VARCHAR2(10)  Y
        MFAE_REF_DEDUC,--26            VARCHAR2(100)  Y
        MFAE_REFORGA,--27              VARCHAR2(100)  Y
        MFAE_EXERCICE,--28            NUMBER(4)  Y      Exercice du role de la facture
        MFAE_NUMEROROLE,--29          NUMBER(4)  Y       Numero du role pour l exercice
        MFAE_PREL,      --30                  NUMBER  Y
        MFAE_AROND--31                  NUMBER  Y
         )
       values
       (
        'DIST'||v_district,               --1
        V_FAC_NUM,            --2
        null,         --3
        V_FAC_NUM,            --4
        v_ID_FACTURE,         --5
        NULL,                 --6
        c.date_b2,     --7
        c.date_b2,     --8
        c.date_b2,     --9
        c.net_a_payer/1000,   --10
        0,                   --11
        0,                   --12
        0,                   --13
        null,     --14
        'FT',                --15
        NULL,                --16
        null,       --17
        'INCONNUE',                --18
        NULL,                --19
        4,                --20
        'IMP_MIG',           --21
        null,    --22
        NULL,                 --23
        NULL,                 --24
        4,                   --25
        NULL,                 --26
        v_district,            --27
        to_char(c.date_b2,'yyyy'),               --28
        NULL,              --29
        1 ,                 --30
        0   --31
        );
        exception
          when others then
            err_code := SQLCODE;
            err_msg  := SUBSTR(SQLERRM, 1, 200);
            insert into prob_migration
              (nom_table, val_ref, sql_err, date_pro)
            values
              ('miwtfacture_b2',
               ltrim(rtrim(c.DISTRICT)) ||
                      lpad(ltrim(rtrim(c.num)),2,'0') ||
                      lpad(ltrim(rtrim(c.num_devis)),6,'0')||
                      to_char(c.etat),
               err_code || '--' || err_msg,
               sysdate);
        end;

-----------------------------------------------------------------------------------
----------------------------------------------------------------------------------- ligne facture

---------------------------------------------------------------------
---------------------------------------------------------------------Main d'oeuvre
insert into miwtfactureligne (
                MFAL_SOURCE,--1  VARCHAR2(100)  N      Code source/origine de la ligne [OBL]
                MFAL_REFFAE,--2  VARCHAR2(100)  N      Identifiant de la facture de la ligne [OBL]
                MFAL_REFTAP,--3  VARCHAR2(100)  N      Identifiant de la periode de tarif de la ligne [OBL]
                MFAL_REFART,--4  VARCHAR2(100)  Y
                MFAL_LIBE,--5  VARCHAR2(200)  Y
                MFAL_NUM,--6  NUMBER(4)  N
                MFAL_TRAN,--7  NUMBER(1)  N  1    Tranche de la ligne [OBL]
                MFAL_EXER,--8  NUMBER(4)  N      Annee exercice de la ligne [OBL]
                MFAL_VOLU,--9  NUMBER(15,3)  N      Volume facture de la ligne [OBL]
                MFAL_PU,--10  NUMBER(12,6)  N      P.U. facture de la ligne [OBL]
               MFAL_MTHT,--11  NUMBER(15,2)  N      Montant HT de la ligne [OBL]
               MFAL_MTVA,--12  NUMBER(15,2)  N      Montant TVA de la ligne [OBL]
               MFAL_TTVA,--13  NUMBER(15,2)  N      Taux de TVA de la ligne [OBL]
                MFAL_MTTC,--14  NUMBER(15,2)  N
                MFAL_DDEBPERFAC,--15  DATE  Y      Date de debut de la periode facturee de la ligne
                MFAL_DFINPERFAC,--16  DATE  Y      Date de fin de la periode facturee de la ligne
               MFAL_DETAIL--17  NUMBER  Y
                )
                values
               ('DIST'||v_district,--1
                V_FAC_NUM,--2
                1,--3
                'MO_T',--4
                'Main d oeuvre',--5
                1,--6
                1,--7
                to_char(c.date_b2,'YYYY'),--8
                c.main_oeuvre,--9
               c.main_oeuvre/1000,--10
                c.main_oeuvre/1000,--11
                c.main_oeuvre/1000,--12
                 0,--13
                c.main_oeuvre/1000,--14
                c.date_b2,--15
                c.date_b2,--16
               null--17
                 );
---------------------------------------------------------------------------------
---------------------------------------------------------------------------------Matiere
insert into miwtfactureligne (
                MFAL_SOURCE,--1  VARCHAR2(100)  N      Code source/origine de la ligne [OBL]
                MFAL_REFFAE,--2  VARCHAR2(100)  N      Identifiant de la facture de la ligne [OBL]
                MFAL_REFTAP,--3  VARCHAR2(100)  N      Identifiant de la periode de tarif de la ligne [OBL]
                MFAL_REFART,--4  VARCHAR2(100)  Y
                MFAL_LIBE,--5  VARCHAR2(200)  Y
                MFAL_NUM,--6  NUMBER(4)  N
                MFAL_TRAN,--7  NUMBER(1)  N  1    Tranche de la ligne [OBL]
                MFAL_EXER,--8  NUMBER(4)  N      Annee exercice de la ligne [OBL]
                MFAL_VOLU,--9  NUMBER(15,3)  N      Volume facture de la ligne [OBL]
                MFAL_PU,--10  NUMBER(12,6)  N      P.U. facture de la ligne [OBL]
               MFAL_MTHT,--11  NUMBER(15,2)  N      Montant HT de la ligne [OBL]
               MFAL_MTVA,--12  NUMBER(15,2)  N      Montant TVA de la ligne [OBL]
               MFAL_TTVA,--13  NUMBER(15,2)  N      Taux de TVA de la ligne [OBL]
                MFAL_MTTC,--14  NUMBER(15,2)  N
                MFAL_DDEBPERFAC,--15  DATE  Y      Date de debut de la periode facturee de la ligne
                MFAL_DFINPERFAC,--16  DATE  Y      Date de fin de la periode facturee de la ligne
               MFAL_DETAIL--17  NUMBER  Y
                )
                values
               ('DIST'||v_district,--1
                V_FAC_NUM,--2
                1,--3
                'MATIER',--4
                'Matier',--5
                2,--6
                2,--7
                to_char(c.date_b2,'YYYY'),--8
                c.matiere,--9
               c.matiere/1000,--10
                c.matiere/1000,--11
                c.matiere/1000,--12
                 0,--13
                c.matiere/1000,--14
                c.date_b2,--15
                c.date_b2,--16
               null--17
                 );

---------------------------------------------------------------------------------
---------------------------------------------------------------------------------ventes_diverses
insert into miwtfactureligne (
                MFAL_SOURCE,--1  VARCHAR2(100)  N      Code source/origine de la ligne [OBL]
                MFAL_REFFAE,--2  VARCHAR2(100)  N      Identifiant de la facture de la ligne [OBL]
                MFAL_REFTAP,--3  VARCHAR2(100)  N      Identifiant de la periode de tarif de la ligne [OBL]
                MFAL_REFART,--4  VARCHAR2(100)  Y
                MFAL_LIBE,--5  VARCHAR2(200)  Y
                MFAL_NUM,--6  NUMBER(4)  N
                MFAL_TRAN,--7  NUMBER(1)  N  1    Tranche de la ligne [OBL]
                MFAL_EXER,--8  NUMBER(4)  N      Annee exercice de la ligne [OBL]
                MFAL_VOLU,--9  NUMBER(15,3)  N      Volume facture de la ligne [OBL]
                MFAL_PU,--10  NUMBER(12,6)  N      P.U. facture de la ligne [OBL]
               MFAL_MTHT,--11  NUMBER(15,2)  N      Montant HT de la ligne [OBL]
               MFAL_MTVA,--12  NUMBER(15,2)  N      Montant TVA de la ligne [OBL]
               MFAL_TTVA,--13  NUMBER(15,2)  N      Taux de TVA de la ligne [OBL]
                MFAL_MTTC,--14  NUMBER(15,2)  N
                MFAL_DDEBPERFAC,--15  DATE  Y      Date de debut de la periode facturee de la ligne
                MFAL_DFINPERFAC,--16  DATE  Y      Date de fin de la periode facturee de la ligne
               MFAL_DETAIL--17  NUMBER  Y
                )
                values
               ('DIST'||v_district,--1
                V_FAC_NUM,--2
                1,--3
                'ventes_diverses',--4
                'Ventes diverses',--5
                3,--6
                3,--7
                to_char(c.date_b2,'YYYY'),--8
                c.ventes_diverses,--9
               c.ventes_diverses/1000,--10
                c.ventes_diverses/1000,--11
                c.ventes_diverses/1000,--12
                 0,--13
                c.ventes_diverses/1000,--14
                c.date_b2,--15
                c.date_b2,--16
               null--17
                 );

---------------------------------------------------------------------------------
---------------------------------------------------------------------------------travaux_divers
insert into miwtfactureligne (
                MFAL_SOURCE,--1  VARCHAR2(100)  N      Code source/origine de la ligne [OBL]
                MFAL_REFFAE,--2  VARCHAR2(100)  N      Identifiant de la facture de la ligne [OBL]
                MFAL_REFTAP,--3  VARCHAR2(100)  N      Identifiant de la periode de tarif de la ligne [OBL]
                MFAL_REFART,--4  VARCHAR2(100)  Y
                MFAL_LIBE,--5  VARCHAR2(200)  Y
                MFAL_NUM,--6  NUMBER(4)  N
                MFAL_TRAN,--7  NUMBER(1)  N  1    Tranche de la ligne [OBL]
                MFAL_EXER,--8  NUMBER(4)  N      Annee exercice de la ligne [OBL]
                MFAL_VOLU,--9  NUMBER(15,3)  N      Volume facture de la ligne [OBL]
                MFAL_PU,--10  NUMBER(12,6)  N      P.U. facture de la ligne [OBL]
               MFAL_MTHT,--11  NUMBER(15,2)  N      Montant HT de la ligne [OBL]
               MFAL_MTVA,--12  NUMBER(15,2)  N      Montant TVA de la ligne [OBL]
               MFAL_TTVA,--13  NUMBER(15,2)  N      Taux de TVA de la ligne [OBL]
                MFAL_MTTC,--14  NUMBER(15,2)  N
                MFAL_DDEBPERFAC,--15  DATE  Y      Date de debut de la periode facturee de la ligne
                MFAL_DFINPERFAC,--16  DATE  Y      Date de fin de la periode facturee de la ligne
               MFAL_DETAIL--17  NUMBER  Y
                )
                values
               ('DIST'||v_district,--1
                V_FAC_NUM,--2
                1,--3
                'travaux_divers',--4
                'Travaux divers',--5
                4,--6
                4,--7
                to_char(c.date_b2,'YYYY'),--8
                c.travaux_divers,--9
               c.travaux_divers/1000,--10
                c.travaux_divers/1000,--11
                c.travaux_divers/1000,--12
                 0,--13
                c.travaux_divers/1000,--14
                c.date_b2,--15
                c.date_b2,--16
               null--17
                 );
---------------------------------------------------------------------------------
---------------------------------------------------------------------------------vente_eau_potence
insert into miwtfactureligne (
                MFAL_SOURCE,--1  VARCHAR2(100)  N      Code source/origine de la ligne [OBL]
                MFAL_REFFAE,--2  VARCHAR2(100)  N      Identifiant de la facture de la ligne [OBL]
                MFAL_REFTAP,--3  VARCHAR2(100)  N      Identifiant de la periode de tarif de la ligne [OBL]
                MFAL_REFART,--4  VARCHAR2(100)  Y
                MFAL_LIBE,--5  VARCHAR2(200)  Y
                MFAL_NUM,--6  NUMBER(4)  N
                MFAL_TRAN,--7  NUMBER(1)  N  1    Tranche de la ligne [OBL]
                MFAL_EXER,--8  NUMBER(4)  N      Annee exercice de la ligne [OBL]
                MFAL_VOLU,--9  NUMBER(15,3)  N      Volume facture de la ligne [OBL]
                MFAL_PU,--10  NUMBER(12,6)  N      P.U. facture de la ligne [OBL]
               MFAL_MTHT,--11  NUMBER(15,2)  N      Montant HT de la ligne [OBL]
               MFAL_MTVA,--12  NUMBER(15,2)  N      Montant TVA de la ligne [OBL]
               MFAL_TTVA,--13  NUMBER(15,2)  N      Taux de TVA de la ligne [OBL]
                MFAL_MTTC,--14  NUMBER(15,2)  N
                MFAL_DDEBPERFAC,--15  DATE  Y      Date de debut de la periode facturee de la ligne
                MFAL_DFINPERFAC,--16  DATE  Y      Date de fin de la periode facturee de la ligne
               MFAL_DETAIL--17  NUMBER  Y
                )
                values
               ('DIST'||v_district,--1
                V_FAC_NUM,--2
                1,--3
                'vente_eau_potence',--4
                'Vente eau potence',--5
                5,--6
                5,--7
                to_char(c.date_b2,'YYYY'),--8
                c.travaux_divers,--9
               c.travaux_divers/1000,--10
                c.travaux_divers/1000,--11
                c.travaux_divers/1000,--12
                 0,--13
                c.travaux_divers/1000,--14
                c.date_b2,--15
                c.date_b2,--16
               null--17
                 );
---------------------------------------------------------------------------------
---------------------------------------------------------------------------------vente_eau_potence
insert into miwtfactureligne (
                MFAL_SOURCE,--1  VARCHAR2(100)  N      Code source/origine de la ligne [OBL]
                MFAL_REFFAE,--2  VARCHAR2(100)  N      Identifiant de la facture de la ligne [OBL]
                MFAL_REFTAP,--3  VARCHAR2(100)  N      Identifiant de la periode de tarif de la ligne [OBL]
                MFAL_REFART,--4  VARCHAR2(100)  Y
                MFAL_LIBE,--5  VARCHAR2(200)  Y
                MFAL_NUM,--6  NUMBER(4)  N
                MFAL_TRAN,--7  NUMBER(1)  N  1    Tranche de la ligne [OBL]
                MFAL_EXER,--8  NUMBER(4)  N      Annee exercice de la ligne [OBL]
                MFAL_VOLU,--9  NUMBER(15,3)  N      Volume facture de la ligne [OBL]
                MFAL_PU,--10  NUMBER(12,6)  N      P.U. facture de la ligne [OBL]
               MFAL_MTHT,--11  NUMBER(15,2)  N      Montant HT de la ligne [OBL]
               MFAL_MTVA,--12  NUMBER(15,2)  N      Montant TVA de la ligne [OBL]
               MFAL_TTVA,--13  NUMBER(15,2)  N      Taux de TVA de la ligne [OBL]
                MFAL_MTTC,--14  NUMBER(15,2)  N
                MFAL_DDEBPERFAC,--15  DATE  Y      Date de debut de la periode facturee de la ligne
                MFAL_DFINPERFAC,--16  DATE  Y      Date de fin de la periode facturee de la ligne
               MFAL_DETAIL--17  NUMBER  Y
                )
                values
               ('DIST'||v_district,--1
                V_FAC_NUM,--2
                1,--3
                'vente_eau_potence',--4
                'Vente eau potence',--5
                6,--6
                6,--7
                to_char(c.date_b2,'YYYY'),--8
                c.travaux_divers,--9
               c.travaux_divers/1000,--10
                c.travaux_divers/1000,--11
                c.travaux_divers/1000,--12
                 0,--13
                c.travaux_divers/1000,--14
                c.date_b2,--15
                c.date_b2,--16
               null--17
                 );
---------------------------------------------------------------------------------
---------------------------------------------------------------------------------f_timbre
insert into miwtfactureligne (
                MFAL_SOURCE,--1  VARCHAR2(100)  N      Code source/origine de la ligne [OBL]
                MFAL_REFFAE,--2  VARCHAR2(100)  N      Identifiant de la facture de la ligne [OBL]
                MFAL_REFTAP,--3  VARCHAR2(100)  N      Identifiant de la periode de tarif de la ligne [OBL]
                MFAL_REFART,--4  VARCHAR2(100)  Y
                MFAL_LIBE,--5  VARCHAR2(200)  Y
                MFAL_NUM,--6  NUMBER(4)  N
                MFAL_TRAN,--7  NUMBER(1)  N  1    Tranche de la ligne [OBL]
                MFAL_EXER,--8  NUMBER(4)  N      Annee exercice de la ligne [OBL]
                MFAL_VOLU,--9  NUMBER(15,3)  N      Volume facture de la ligne [OBL]
                MFAL_PU,--10  NUMBER(12,6)  N      P.U. facture de la ligne [OBL]
               MFAL_MTHT,--11  NUMBER(15,2)  N      Montant HT de la ligne [OBL]
               MFAL_MTVA,--12  NUMBER(15,2)  N      Montant TVA de la ligne [OBL]
               MFAL_TTVA,--13  NUMBER(15,2)  N      Taux de TVA de la ligne [OBL]
                MFAL_MTTC,--14  NUMBER(15,2)  N
                MFAL_DDEBPERFAC,--15  DATE  Y      Date de debut de la periode facturee de la ligne
                MFAL_DFINPERFAC,--16  DATE  Y      Date de fin de la periode facturee de la ligne
               MFAL_DETAIL--17  NUMBER  Y
                )
                values
               ('DIST'||v_district,--1
                V_FAC_NUM,--2
                1,--3
                'f_timbre',--4
                'Frais Timbre',--5
                7,--6
                7,--7
                to_char(c.date_b2,'YYYY'),--8
                c.f_timbre,--9
               c.f_timbre/1000,--10
                c.f_timbre/1000,--11
                c.f_timbre/1000,--12
                 0,--13
                c.f_timbre/1000,--14
                c.date_b2,--15
                c.date_b2,--16
               null--17
                 );
---------------------------------------------------------------------------------
---------------------------------------------------------------------------------participation_extension
insert into miwtfactureligne (
                MFAL_SOURCE,--1  VARCHAR2(100)  N      Code source/origine de la ligne [OBL]
                MFAL_REFFAE,--2  VARCHAR2(100)  N      Identifiant de la facture de la ligne [OBL]
                MFAL_REFTAP,--3  VARCHAR2(100)  N      Identifiant de la periode de tarif de la ligne [OBL]
                MFAL_REFART,--4  VARCHAR2(100)  Y
                MFAL_LIBE,--5  VARCHAR2(200)  Y
                MFAL_NUM,--6  NUMBER(4)  N
                MFAL_TRAN,--7  NUMBER(1)  N  1    Tranche de la ligne [OBL]
                MFAL_EXER,--8  NUMBER(4)  N      Annee exercice de la ligne [OBL]
                MFAL_VOLU,--9  NUMBER(15,3)  N      Volume facture de la ligne [OBL]
                MFAL_PU,--10  NUMBER(12,6)  N      P.U. facture de la ligne [OBL]
               MFAL_MTHT,--11  NUMBER(15,2)  N      Montant HT de la ligne [OBL]
               MFAL_MTVA,--12  NUMBER(15,2)  N      Montant TVA de la ligne [OBL]
               MFAL_TTVA,--13  NUMBER(15,2)  N      Taux de TVA de la ligne [OBL]
                MFAL_MTTC,--14  NUMBER(15,2)  N
                MFAL_DDEBPERFAC,--15  DATE  Y      Date de debut de la periode facturee de la ligne
                MFAL_DFINPERFAC,--16  DATE  Y      Date de fin de la periode facturee de la ligne
               MFAL_DETAIL--17  NUMBER  Y
                )
                values
               ('DIST'||v_district,--1
                V_FAC_NUM,--2
                1,--3
                'participation_extension',--4
                'Participation extension',--5
                8,--6
                8,--7
                to_char(c.date_b2,'YYYY'),--8
                c.participation_extension,--9
               c.participation_extension/1000,--10
                c.participation_extension/1000,--11
                c.participation_extension/1000,--12
                 0,--13
                c.participation_extension/1000,--14
                c.date_b2,--15
                c.date_b2,--16
               null--17
                 );
---------------------------------------------------------------------------------
---------------------------------------------------------------------------------refection_chaussee
insert into miwtfactureligne (
                MFAL_SOURCE,--1  VARCHAR2(100)  N      Code source/origine de la ligne [OBL]
                MFAL_REFFAE,--2  VARCHAR2(100)  N      Identifiant de la facture de la ligne [OBL]
                MFAL_REFTAP,--3  VARCHAR2(100)  N      Identifiant de la periode de tarif de la ligne [OBL]
                MFAL_REFART,--4  VARCHAR2(100)  Y
                MFAL_LIBE,--5  VARCHAR2(200)  Y
                MFAL_NUM,--6  NUMBER(4)  N
                MFAL_TRAN,--7  NUMBER(1)  N  1    Tranche de la ligne [OBL]
                MFAL_EXER,--8  NUMBER(4)  N      Annee exercice de la ligne [OBL]
                MFAL_VOLU,--9  NUMBER(15,3)  N      Volume facture de la ligne [OBL]
                MFAL_PU,--10  NUMBER(12,6)  N      P.U. facture de la ligne [OBL]
               MFAL_MTHT,--11  NUMBER(15,2)  N      Montant HT de la ligne [OBL]
               MFAL_MTVA,--12  NUMBER(15,2)  N      Montant TVA de la ligne [OBL]
               MFAL_TTVA,--13  NUMBER(15,2)  N      Taux de TVA de la ligne [OBL]
                MFAL_MTTC,--14  NUMBER(15,2)  N
                MFAL_DDEBPERFAC,--15  DATE  Y      Date de debut de la periode facturee de la ligne
                MFAL_DFINPERFAC,--16  DATE  Y      Date de fin de la periode facturee de la ligne
               MFAL_DETAIL--17  NUMBER  Y
                )
                values
               ('DIST'||v_district,--1
                V_FAC_NUM,--2
                1,--3
                'refection_chaussee',--4
                'Refection chaussee',--5
                9,--6
                9,--7
                to_char(c.date_b2,'YYYY'),--8
                c.refection_chaussee,--9
               c.refection_chaussee/1000,--10
                c.refection_chaussee/1000,--11
                c.refection_chaussee/1000,--12
                 0,--13
                c.refection_chaussee/1000,--14
                c.date_b2,--15
                c.date_b2,--16
               null--17
                 );
---------------------------------------------------------------------------------
---------------------------------------------------------------------------------avance_consommation
insert into miwtfactureligne (
                MFAL_SOURCE,--1  VARCHAR2(100)  N      Code source/origine de la ligne [OBL]
                MFAL_REFFAE,--2  VARCHAR2(100)  N      Identifiant de la facture de la ligne [OBL]
                MFAL_REFTAP,--3  VARCHAR2(100)  N      Identifiant de la periode de tarif de la ligne [OBL]
                MFAL_REFART,--4  VARCHAR2(100)  Y
                MFAL_LIBE,--5  VARCHAR2(200)  Y
                MFAL_NUM,--6  NUMBER(4)  N
                MFAL_TRAN,--7  NUMBER(1)  N  1    Tranche de la ligne [OBL]
                MFAL_EXER,--8  NUMBER(4)  N      Annee exercice de la ligne [OBL]
                MFAL_VOLU,--9  NUMBER(15,3)  N      Volume facture de la ligne [OBL]
                MFAL_PU,--10  NUMBER(12,6)  N      P.U. facture de la ligne [OBL]
               MFAL_MTHT,--11  NUMBER(15,2)  N      Montant HT de la ligne [OBL]
               MFAL_MTVA,--12  NUMBER(15,2)  N      Montant TVA de la ligne [OBL]
               MFAL_TTVA,--13  NUMBER(15,2)  N      Taux de TVA de la ligne [OBL]
                MFAL_MTTC,--14  NUMBER(15,2)  N
                MFAL_DDEBPERFAC,--15  DATE  Y      Date de debut de la periode facturee de la ligne
                MFAL_DFINPERFAC,--16  DATE  Y      Date de fin de la periode facturee de la ligne
               MFAL_DETAIL--17  NUMBER  Y
                )
                values
               ('DIST'||v_district,--1
                V_FAC_NUM,--2
                1,--3
                'avance_consommation',--4
                'avance_consommation',--5
                10,--6
                1,--7
                to_char(c.date_b2,'YYYY'),--8
                c.avance_consommation,--9
               c.avance_consommation/1000,--10
                c.avance_consommation/1000,--11
                c.avance_consommation/1000,--12
                 0,--13
                c.avance_consommation/1000,--14
                c.date_b2,--15
                c.date_b2,--16
               null--17
                 );
    end loop;

end;
-------
procedure MIWT_ENC_1 (v_district in varchar2) is

    err_code        varchar2(200);
    err_msg         varchar2(200);
    V_FAC_NUM       number;
    v_ID_FACTURE     varchar2(200);
    V_REF_FACT       varchar2(200);
    V_ENC_NUM        number;
    x                number;
    v_abn_refper  varchar2(20);
  begin

    --**************************************************
     delete prob_migration where
              nom_table in
              ('miwtrgl','miwtenc');

    select max(to_number(MENC_REF))  into V_ENC_NUM from miwtenc WHERE Menc_SOURCE= 'DIST'||v_district;
    --**************************************************
    -- reception de la liste des releves
    if v_enc_num is null then
     V_ENC_NUM := 0;  end if;
    for facture_ in (select * from miwtfactureentete WHERE MFAE_SOURCE='DIST'||v_district ) loop
            select count(*) into x from impayees i
               where   facture_.MFAE_REFTRF = to_char(i.annee)||lpad(ltrim(rtrim(i.periode)),2,'0')
                       and substr(facture_.mfae_rdet,1,8) = (ltrim(rtrim(i.DISTRICT))||lpad(ltrim(rtrim(i.tournee)),3,'0')|
                          |lpad(ltrim(rtrim(i.ORDRE)),3,'0'))
                        and nvl(facture_.MFAE_REF_ORIGINE,9)='9'
                        And ltrim(rtrim(i.DISTRICT))=v_district;
      if x = 0 then goto TRAIT1; else
                    goto F_TRAIT; end if;
     <<TRAIT1>>
              V_ENC_NUM := V_ENC_NUM + 1;
begin
select w.abn_refper_a into v_abn_refper from miwabn w where
w.abn_ref=facture_.MFAE_REFABN;
exception when others then
  err_code := SQLCODE;
            err_msg  := SUBSTR(SQLERRM, 1, 200);
            insert into prob_migration
              (nom_table, val_ref, sql_err, date_pro)
            values
              ('miwtenc miwabn',
               'no data'||facture_.MFAE_REFABN,
               err_code || '--' || err_msg,
               sysdate);
               v_abn_refper:=-1;
  end;
             begin
        insert into MIWTENC
               (
                  MENC_SOURCE,      --1
                  MENC_REF,         --2
                  MENC_REFPER,      --3
                  MENC_DATE ,       --4
                  MENC_MONTANT,     --5
                  MENC_COMMENTAIRE, --6
                  MENC_MODEPAY,     --7
                  MENC_REFECHQ,     --8
                  MENC_REFJOURNAL,  --9
                  MENC_TYPEJOURNAL, --10
                  MENC_COMPTE,      --11
                  CSH_ID,           --12
                  CAM_ID            --13
                 )
            values
                 (
                  'DIST'||v_district,      --1
                  V_ENC_NUM,         --2
                  v_abn_refper,      --3
                  facture_.MFAE_DLPAI ,       --4
                  facture_.MFAE_SOLDE,     --5
                  facture_.MFAE_REFABN, --6
                  5,     --7
                  facture_.MFAE_REFTRF,     --8
                  null,  --9
                  null, --10
                  null,      --11
                  null,           --12
                  null            --13
                 );
                          exception
          when others then
            err_code := SQLCODE;
            err_msg  := SUBSTR(SQLERRM, 1, 200);
            insert into prob_migration
              (nom_table, val_ref, sql_err, date_pro)
            values
              ('miwtenc',
               V_REF_FACT,
               err_code || '--' || err_msg,
               sysdate);
        end;
        begin
             insert into  MIWTRGL
                (
                  MRGL_SOURCE,      --1
                  MRGL_REF,         --2
                  MRGL_REFENC,     --3
                  MENC_REFABN,      --4
                  MENC_RFIMP,       --5
                  MRGL_REFFAE ,     --6
                  MRGL_MONTANT,     --7
                  MRGL_DATE ,       --8
                  MRGL_COMMENTAIRE, --9
                  MRGL_COMPTEAUX,   --10
                  PCD_ID            --11
                )
             values
                (
                  'DIST'||v_district,      --1
                  V_ENC_NUM,         --2
                  V_ENC_NUM,     --3
                  facture_.MFAE_COMMENT,      --4
                  null,      --5
                  facture_.MFAE_REF,     --6
                  facture_.MFAE_SOLDE,     --7
                  facture_.MFAE_DLPAI ,       --8
                  v_ID_FACTURE, --9
                  null,   --10
                  null            --11
                );

                          exception
          when others then
            err_code := SQLCODE;
            err_msg  := SUBSTR(SQLERRM, 1, 200);
            insert into prob_migration
              (nom_table, val_ref, sql_err, date_pro)
            values   ('miwtrgl', V_FAC_NUM,  err_code || '--' || err_msg, sysdate);
        end;

              commit;

      <<F_TRAIT>>
              null;
    end loop;

  end;
-------
procedure MIWT_FACTURE_IMPAYEE (v_district in varchar2) is
    --********************************* TRAITEMENT DES FACTURES  A PARTIR TABLE IMPAYEE
    err_code        varchar2(200);
    err_msg         varchar2(200);
    V_FAC_NUM       number;
    V_FAC_RESTANTDU  number;
    V_FAC_DATECALCUL date;
    V_FAC_ABN_NUM    number(20);
    V_TRAIN_FACT       varchar2(200);
    V_REF_ABN        varchar2(200);
    nbr_trt   number := 0;


  v_ID_FACTURE   varchar2(20);
  v_ID_FACTURE_orig varchar2(20);
  annee_ number(4);
  periode_ number;
  version number(1) := 1;
  mois_ number;
   date_          date;
   begin

    --**************************************************
   delete prob_migration where
              nom_table in
              ('miwtfacture','SEQ_RELEVE','miwtfactureAA-imp');
    commit;
     --**************************************************
    -- reception de la liste des releves
    select max(nvl(to_number(MFAE_REF),0)) into  V_FAC_NUM from miwtfactureentete where MFAE_SOURCE = 'DIST'||v_district;
       if V_FAC_NUM is null then
             V_FAC_NUM        := 0;    end if;
    for facture_ in (select * from impayees  where
                      not exists (select 'X' from miwtfactureentete where MFAE_SOURCE='DIST'||v_district
                      And MFAE_REFTRF = to_char(annee)||lpad(ltrim(rtrim(periode)),2,'0')
                      and substr(mfae_rdet,1,8) = (ltrim(rtrim(DISTRICT))||lpad(ltrim(rtrim(tournee)),3,'0')||
                      lpad(ltrim(rtrim(ORDRE)),3,'0')))) loop
     V_FAC_NUM        := V_FAC_NUM +1;
      --**************************************************
       periode_ := facture_.periode;
         begin
       select m3  into mois_ from param_tournee where DISTRICT=facture_.district
                                                     And TRIM =facture_.periode
                                      and (TIER,SIX) in (select NTIERS,NSIXIEME from tourne
                                                 where code=lpad(ltrim(rtrim(facture_.TOURNEE)),3,'0'));
        exception
          when others then
            err_code := SQLCODE;
            err_msg  := SUBSTR(SQLERRM, 1, 200);
            insert into prob_migration
              (nom_table, val_ref, sql_err, date_pro)
            values
              ('miwtfactureAA-imp','Tou:'||lpad(ltrim(rtrim(facture_.TOURNEE)),3,'0')||'ORD:'||facture_.Ordre||'TRIM :'||facture_.periode||'AA:'||facture_.ANNEE||'POL:'||facture_.police,
                 err_msg ||'-- periode ',sysdate);
          periode_ := facture_.periode;
           IF periode_ = 1 THEN
             mois_:='01';
            ELSIF periode_ = 2 THEN
            mois_:='04';
            ELSIF periode_ = 3 THEN
            MOIS_:='07';
            ELSIF periode_ = 4 THEN
            mois_:='10';
           end if;
        end;
        BEGIN
         select last_day(to_date('01'||lpad(mois_,2,0)||facture_.ANNEE,'ddmmyyyy')) into date_ from dual;
         EXCEPTION WHEN OTHERS THEN insert into prob_migration
              (nom_table, val_ref, sql_err, date_pro)
            values
              ('miwtfactureAA-imp','MOIS:'||mois_||'ANNEE:'||facture_.ANNEE||'TRIM :'||facture_.periode||'POL:'||facture_.police,
                 err_msg ||'-- DATE ',sysdate);

        END;
         annee_ :=to_char(date_,'yyyy');
      -- suivi en temps reel du traitement
      nbr_trt := nbr_trt + 1;
      --************************************************
      V_FAC_RESTANTDU  := null;
      V_FAC_DATECALCUL := null;
      V_FAC_ABN_NUM    := null;
      V_REF_ABN        := null;

      BEGIN

      select (r.mrel_date+1) INTO  V_FAC_DATECALCUL from  miwtreleve r
             where r.mrel_refpdl =
              lpad(facture_.DISTRICT,2,'0')||
              lpad(ltrim(rtrim(facture_.tournee)),3,'0')||
              lpad(ltrim(rtrim(facture_.ORDRE)),3,'0')||
              lpad(ltrim(rtrim(facture_.POLICE)),5,'0')
              And mrel_refpdl is not null
               and   r.annee = annee_
               and   r.periode = periode_
               And rownum=1;
               Exception  when others then
               V_FAC_DATECALCUL := date_;
            end;
begin
        -- reception de l'identfiant de l'abonnement
        V_TRAIN_FACT :=  ltrim(rtrim(annee_)) ||
                         lpad(to_char(periode_),2,'0');
        v_ID_FACTURE:=ltrim(rtrim(facture_.DISTRICT)) ||
                      lpad(ltrim(rtrim(facture_.tournee)),3,'0') ||
                      lpad(ltrim(rtrim(facture_.ORDRE)),3,'0')||
                      to_char(annee_) ||
                    lpad(to_char(periode_),2,'0')||'0';
        v_ID_FACTURE_orig:=ltrim(rtrim(facture_.DISTRICT)) ||
                     lpad(ltrim(rtrim(facture_.tournee)),3,'0') ||
                     lpad(ltrim(rtrim(facture_.ORDRE)),3,'0')||
                     to_char(annee_) ||
                     lpad(to_char(periode_),2,'0')||'0';
        for ref_abn_ in (select *
                           from miwabn a
                          where substr(a.abn_refsite,1,8) = lpad(facture_.DISTRICT,2,'0') ||
                        lpad(ltrim(rtrim(facture_.tournee)),3,'0') ||
                        lpad(ltrim(rtrim(facture_.ordre)),3,'0')) loop
          V_FAC_ABN_NUM := ref_abn_.abn_ref;
          V_REF_ABN := ref_abn_.ABN_REFPER_A;
        end loop;
        if V_FAC_ABN_NUM  is null then V_FAC_ABN_NUM := lpad(facture_.DISTRICT,2,'0') ||
                        lpad(ltrim(rtrim(facture_.tournee)),3,'0') ||
                        lpad(ltrim(rtrim(facture_.ordre)),3,'0') ||
                        lpad(ltrim(rtrim(facture_.police)),5,'0');
         end if;
         exception
          when others then
            err_code := SQLCODE;
            err_msg  := SUBSTR(SQLERRM, 1, 200);
            insert into prob_migration
              (nom_table, val_ref, sql_err, date_pro)
            values
              ('miwtfactureAA-imp','Tou:'||lpad(ltrim(rtrim(facture_.tournee)),3,'0')||'ORD:'||facture_.Ordre||'TRIM :'||facture_.periode||'AA:'||facture_.ANNEE||'POL:'||facture_.police,
                 err_msg ||'-- periode ',sysdate);
                 end;
        -- Insertion de la facture

            v_ID_FACTURE_orig:=ltrim(rtrim(facture_.DISTRICT)) ||
                     lpad(ltrim(rtrim(facture_.tournee)),3,'0') ||
                     lpad(ltrim(rtrim(facture_.ORDRE)),3,'0')||
                     to_char(annee_) ||
                     lpad(to_char(periode_),2,'0')||to_char(version);
        begin
         insert into miwtfactureentete
        (
        MFAE_SOURCE,--1       VARCHAR2(100) N     Code source/origine de la facture [OBL]
        MFAE_REF,   --2      VARCHAR2(100)  N     Identifiant unique de la facture pour la source [OBL]
        MFAE_REFTRF,--3    VARCHAR2(100)  Y     Identifiant du train de la facture
        MFAE_NUME,  --4      NUMBER(10) Y     Numero de la facture [OBL]
        MFAE_RDET,  --5      VARCHAR2(15) Y     RDET de la facture
        MFAE_CCMO,  --6      VARCHAR2(1)  Y     Cle controle RDET de la facture
        MFAE_DEDI,  --7      DATE N     Date d edition de la facture [OBL]
        MFAE_DLPAI, --8    DATE Y     Date limite de paiement de la facture [OBL]
        MFAE_DPREL,--9     DATE Y     Date de prelevement de la facture [OBL]
        MFAE_TOTHTE,--10   NUMBER(10,2) N     Total HT EAU de la facture [OBL]
        MFAE_TOTTVAE,--11  NUMBER(10,2) N     Total TVA EAU de la facture [OBL]
        MFAE_TOTHTA,--12   NUMBER(10,2) N     Total HT ASS de la facture [OBL]
        MFAE_TOTTVAA,--13  NUMBER(10,2) N     Total TVA ASS de la facture [OBL]
        MFAE_SOLDE,--14    NUMBER(10,2) Y     Solde TTC de la facture
        MFAE_TYPE,--15     VARCHAR2(2)  N 'R'
        MFAE_REFFAEDEDU,--16  VARCHAR2(100) Y
        MFAE_REFABN,--17      VARCHAR2(100) N     Identifiant du contrat de la facture [OBL]
        MFAE_REF_CODNIV_RELANCE,--18  VARCHAR2(100) Y     Reference Code niveau de chainde relance
        MFAE_RIB_REF,--19             VARCHAR2(100) Y     Reference Rib
        MFAE_RIB_ETAT,--20            NUMBER(1) Y     Mode de payement (pr?l?vement 1 ou tip 2)
        MFAE_COMPTEAUX,--21           VARCHAR2(100) Y     Compte auxilaire GENACCOUNT associe a la facture
        MFAE_REF_ORIGINE,--22         VARCHAR2(100) Y     Facture origine
        MFAE_COMMENT,--23             VARCHAR2(4000)  Y     Commentaire libre Facture
        MFAE_AMOUNTTTCDEC,--24        NUMBER(17,10) Y     Montant TTC a deduire
        VOC_MODEFACT,--25             VARCHAR2(10)  Y
        MFAE_REF_DEDUC,--26           VARCHAR2(100) Y
        MFAE_REFORGA,--27             VARCHAR2(100) Y
        MFAE_EXERCICE,--28            NUMBER(4) Y     Exercice du role de la facture
        MFAE_NUMEROROLE,--29          NUMBER(4) Y      Numero du role pour l exercice
        MFAE_PREL,      --30                  NUMBER  Y
        MFAE_AROND--31                  NUMBER  Y
         )
       values
       (
        'DIST'||v_district,               --1
        V_FAC_NUM,            --2
        V_TRAIN_FACT,         --3
        V_FAC_NUM,            --4
        v_ID_FACTURE,         --5
        NULL,                 --6
        V_FAC_DATECALCUL,     --7
        V_FAC_DATECALCUL,     --8
        V_FAC_DATECALCUL,     --9
        facture_.net_a_payer/1000,   --10
        0,                   --11
        0,                   --12
        0,                   --13
         facture_.net_a_payer/1000,     --14
        'FC',                --15
        NULL,                --16
        V_FAC_ABN_NUM,       --17
        'INCONNUE',                --18
         null,                --19
        4,                --20
        'IMP_MIG',           --21
        null,    --22
        V_REF_ABN,                 --23
        NULL,                 --24
        4,                   --25
        NULL,                 --26
        v_district,            --27
        annee_,               --28
        periode_,              --29
        1 ,                 --30
        0   --31
        );
        exception
          when others then
            err_code := SQLCODE;
            err_msg  := SUBSTR(SQLERRM, 1, 200);
            insert into prob_migration
              (nom_table, val_ref, sql_err, date_pro)
            values
              ('miwtfacture',
               lpad(facture_.district,2,'0') ||
               lpad(ltrim(rtrim(facture_.tournee)),3,'0') ||
               lpad(ltrim(rtrim(facture_.ordre)),3,'0') ||
               lpad(ltrim(rtrim(facture_.police)),5,'0'),
               err_code || '--' || err_msg,
               sysdate);
        end;
        -----------


          select count(*) into  nbr_trt from  miwtreleve
             where mrel_refpdl =
              lpad(facture_.DISTRICT,2,'0')||
              lpad(ltrim(rtrim(facture_.tournee)),3,'0')||
              lpad(ltrim(rtrim(facture_.ordre)),3,'0')||
              lpad(ltrim(rtrim(facture_.police)),5,'0')
              And mrel_refpdl is not null
               and   annee = annee_
               and   periode = periode_
               And rownum=1;
       if nbr_trt <> 0 then
        update  miwtreleve  set mrel_fact1 = v_ID_FACTURE
             where mrel_refpdl =
              lpad(facture_.DISTRICT,2,'0')||
              lpad(ltrim(rtrim(facture_.tournee)),3,'0')||
              lpad(ltrim(rtrim(facture_.ordre)),3,'0')||
              lpad(ltrim(rtrim(facture_.police)),5,'0')
              And mrel_refpdl is not null
               and   annee = annee_
               and   periode = periode_
               And rownum=1;
                 end if;

        commit;

    end loop;

  end;
---------------   ENCAISSEMENT PARTIEL
procedure MIWT_ENC_2(v_district in varchar2) is

    err_code        varchar2(200);
    err_msg         varchar2(200);
    V_FAC_NUM       number;
    v_ID_FACTURE     varchar2(200);
    V_REF_FACT       varchar2(200);
    V_ENC_NUM        number;

  begin

    --**************************************************
     delete prob_migration where
              nom_table in
              ('miwtrgl','miwtenc');

    select max(to_number(MENC_REF))  into V_ENC_NUM from miwtenc WHERE Menc_SOURCE= 'DIST'||v_district;
    --**************************************************
    -- reception de la liste des releves
    if v_enc_num is null then
     V_ENC_NUM := 0;  end if;
    for facture_ in (select t.*,f.* from impayees  t , miwtfactureentete f where  MFAE_SOURCE='DIST'||v_district
                      And MFAE_REFTRF = to_char(annee)||lpad(ltrim(rtrim(periode)),2,'0')
                      and substr(mfae_rdet,1,8) = (ltrim(rtrim(DISTRICT))||lpad(ltrim(rtrim(tournee)),3,'0')||
                      lpad(ltrim(rtrim(ORDRE)),3,'0'))
                      and t.DISTRICT=v_district and t.montant <> 0 ) loop
              V_ENC_NUM := V_ENC_NUM + 1;
             begin
        insert into MIWTENC
               (
                  MENC_SOURCE,      --1
                  MENC_REF,         --2
                  MENC_REFPER,      --3
                  MENC_DATE ,       --4
                  MENC_MONTANT,     --5
                  MENC_COMMENTAIRE, --6
                  MENC_MODEPAY,     --7
                  MENC_REFECHQ,     --8
                  MENC_REFJOURNAL,  --9
                  MENC_TYPEJOURNAL, --10
                  MENC_COMPTE,      --11
                  CSH_ID,           --12
                  CAM_ID            --13
                 )
            values
                 (
                  'DIST'||v_district,      --1
                  V_ENC_NUM,         --2
                  facture_.MFAE_COMMENT,      --3
                  facture_.MFAE_DLPAI ,       --4
                  facture_.MONTANT/1000,     --5
                  facture_.MFAE_REFABN, --6
                  5,     --7
                  facture_.MFAE_REFTRF,     --8
                  null,  --9
                  null, --10
                  null,      --11
                  null,           --12
                  null            --13
                 );
                          exception
          when others then
            err_code := SQLCODE;
            err_msg  := SUBSTR(SQLERRM, 1, 200);
            insert into prob_migration
              (nom_table, val_ref, sql_err, date_pro)
            values
              ('miwtenc',
               V_REF_FACT,
               err_code || '--' || err_msg,
               sysdate);
        end;
        begin
             insert into  MIWTRGL
                (
                  MRGL_SOURCE,      --1
                  MRGL_REF,         --2
                  MRGL_REFENC,     --3
                  MENC_REFABN,      --4
                  MENC_RFIMP,       --5
                  MRGL_REFFAE ,     --6
                  MRGL_MONTANT,     --7
                  MRGL_DATE ,       --8
                  MRGL_COMMENTAIRE, --9
                  MRGL_COMPTEAUX,   --10
                  PCD_ID            --11
                )
             values
                (
                  'DIST'||v_district,      --1
                  V_ENC_NUM,         --2
                  V_ENC_NUM,     --3
                  facture_.MFAE_COMMENT,      --4
                  null,      --5
                  facture_.MFAE_REF,     --6
                  facture_.montant/1000,     --7
                  facture_.MFAE_DLPAI ,       --8
                  v_ID_FACTURE, --9
                  null,   --10
                  null            --11
                );

                          exception
          when others then
            err_code := SQLCODE;
            err_msg  := SUBSTR(SQLERRM, 1, 200);
            insert into prob_migration
              (nom_table, val_ref, sql_err, date_pro)
            values   ('miwtrgl', V_FAC_NUM,  err_code || '--' || err_msg, sysdate);
        end;

              commit;

    end loop;

  end;
-------
end PCK_MIG_FACTURE;
/

prompt
prompt Creating package body PCK_MIG_FACTURE_NEW
prompt =========================================
prompt
create or replace package body PCK_MIG_FACTURE_new is

  -- Private type declarations
  --********************************************
   procedure MIWT_FACTURE_AS400 (v_district in varchar2) is
  --********************************************

    err_code         varchar2(200);
    err_msg          varchar2(200);
    x                number;
    V_FAC_NUM        number;
    V_FAC_RESTANTDU  number;
    V_FAC_DATECALCUL date;
    V_FAC_DATELIM    date;
    V_FAC_ABN_NUM    number(20);
    v_ref_releve     number;
    v_mrel_ref       varchar2(20);
    V_TRAIN_FACT     varchar2(200);
    V_REF_ABN        varchar2(200);
    nbr_trt          number := 0;
    nbr_trt_rt       number := 0;
    v_ID_FACTURE     varchar2(20);
    periode_         number;
    version          number(1) := 0;
    date_            date;
    tiers_           varchar2(1);
    six_             varchar2(1);
    anneereel_       varchar2(4);

  begin

execute immediate 'alter session set nls_date_format = ''dd/mm/yyyy''';
execute immediate 'alter session set NLS_NUMERIC_CHARACTERS = '',.''';
    --**************************************************
     delete prob_migration where
              nom_table in
              ('miwtfacture','SEQ_RELEVE','miwtfactureligne');
 insert into prob_migration (nom_table)values(SYSTIMESTAMP||'   START MIWT_FACTURE_AS400');

    V_FAC_NUM        := 0;

    select max(to_number(MFAE_REF))  into V_FAC_NUM from miwtfactureentete WHERE MFAE_SOURCE= 'DIST'||v_district;
   -- select max(to_number(MREL_REF)) into v_ref_releve FROM miwtreleve where MREL_SOURCE = 'DIST'||v_district;
    COMMIT;

    for facture_ in (select * from facture_as400 WHERE dist=v_district) loop
     V_FAC_NUM        := nvl(V_FAC_NUM,0) + 1;
      -- reception de date Facturation

       select last_day(to_date('01'||lpad(facture_.refc03,2,'0')||facture_.refc04,'ddmmyy')) into date_
                              from dual;


        begin
         --Calcul de l'année réel (exercice réel)
       if(to_number(facture_.refc01)<to_number(facture_.refc03))then
        anneereel_ := '20'||facture_.refc04;
       else
        anneereel_ := '20'||to_char((to_number(facture_.refc04)-1));
       end if;

       select TRIM,tier,six
       into periode_,tiers_,six_
       from param_tournee
       where DISTRICT=facture_.dist
       And m1 =facture_.refc01
       And m2 = facture_.refc02
       And m3 = facture_.refc03
           and (TIER,SIX) in (select NTIERS,NSIXIEME
                              from tourne
                              where  code=lpad(facture_.tou,3,'0'));
        exception
          when others then
            err_code := SQLCODE;
            err_msg  := SUBSTR(SQLERRM, 1, 200);
            insert into prob_migration
              (nom_table, val_ref, sql_err, date_pro,type_problem)
            values
              ('miwtfacture','Tourne '||facture_.tou||'M1 :'||facture_.refc01||'M2 :'||facture_.refc02||'M3:'||facture_.refc03,
                 err_msg ||'-- periode ',sysdate,'erreur recuperation de periode -- tiers--six');
          periode_ := 1;
        end;

      --annee_ :=to_char(date_,'yyyy');
      V_FAC_RESTANTDU  := null;
      V_FAC_DATECALCUL := null;
      V_FAC_DATELIM    :=null;
      V_FAC_ABN_NUM    := null;
      begin
          select to_date(lpad(ltrim(rtrim(DATEEXP)),8,'0'),'ddmmyyyy'),
                 to_date(lpad(ltrim(rtrim(DATL)),8,'0'),'ddmmyyyy')    into
                 V_FAC_DATECALCUL,V_FAC_DATELIM
                  from role_trim
                     where to_number(facture_.pol)=POLICE
                     AND ltrim(rtrim(fACTURE_.Dist)) = ltrim(rtrim(DISTR))
                     And ltrim(rtrim(facture_.tou )) =ltrim(rtrim(TOUR))
                     And ltrim(rtrim(facture_.ord))  =ltrim(rtrim(ORDR))
                     And ltrim(rtrim(tiers_)) = nvl(ltrim(rtrim(tiers)),ltrim(rtrim(tiers_)))
                     And ltrim(rtrim(periode_)) = nvl(ltrim(rtrim(trim)), ltrim(rtrim(periode_)))
                     And ltrim(rtrim(six_ )) = nvl(ltrim(rtrim(six)),ltrim(rtrim(six_ )))
                     AND annee = anneereel_
                     AND rownum = 1;
            exception
          when others then
            err_code := SQLCODE;
            err_msg  := SUBSTR(SQLERRM, 1, 200);
            insert into prob_migration
              (nom_table, val_ref, sql_err, date_pro,type_problem )
            values
              ('miwtfacture','Date facture  pol:'||facture_.pol||' tour:'||facture_.tou||' M1 :'
               ||facture_.refc01||' M2 :'||facture_.refc02||' M3:'||facture_.refc03||'A:'||anneereel_||
               ' ord :'||facture_.ord||' cat:'||facture_.cat||' tier:'||tiers_||' trim:'||periode_||' sim:'||six_,
                 err_msg ||'-- periode ',sysdate,'erreur de recuperation date de facture dans la table role_trim');

      end;

      if V_FAC_DATECALCUL is null then
      BEGIN
         select (r.mrel_date + 7) INTO  V_FAC_DATECALCUL
               from  miwtreleve r
               where r.mrel_refpdl =
               lpad(facture_.DIST,2,'0')||
               lpad(facture_.tou,3,'0')||
               lpad(facture_.ORD,3,'0')||
               lpad(facture_.POL,5,'0')
              And mrel_refpdl is not null
               and   r.annee = anneereel_
               and   r.periode = periode_
               And rownum=1;
               Exception  when others then
               V_FAC_DATECALCUL := date_;
            end;
       V_FAC_DATELIM := '01/01/2000';--V_FAC_DATECALCUL;
      end if;
        -- reception de l'identfiant de l'abonnement
        V_REF_ABN := ltrim(rtrim(facture_.DIST)) ||
                     lpad(to_char(facture_.pol),5,'0') ||
                     lpad(ltrim(rtrim(facture_.tou)),3,'0') ||
                     lpad(ltrim(rtrim(facture_.ORD)),3,'0');
        V_TRAIN_FACT :=  'ANNEE:'||ltrim(rtrim(anneereel_)) ||
                         ' TRIM:'||ltrim(rtrim(periode_)) ||
             ' TIER:'||ltrim(rtrim(tiers_))||
             ' SIX:'||ltrim(rtrim(six_ ));
        v_ID_FACTURE:=ltrim(rtrim(facture_.DIST)) ||
                    lpad(ltrim(rtrim(facture_.tou)),3,'0') ||
                     lpad(ltrim(rtrim(facture_.ORD)),3,'0')||
                     to_char(anneereel_) ||
                     lpad(to_char(periode_),2,'0')||to_char(version);

         select count(*) into nbr_trt from miwtfactureentete where MFAE_RDET = v_ID_FACTURE
                                                               And MFAE_SOURCE = 'DIST'||v_district;

         if nbr_trt=1 then goto xx;  end if;

        for ref_abn_ in (select *
                           from miwabn a
                          where substr(a.abn_refsite,1,13) = lpad(facture_.dist,2,'0') ||
                        lpad(facture_.tou,3,'0') ||
                        lpad(facture_.ord,3,'0') ||
                        lpad(to_char(facture_.pol),5,'0')) loop
          V_FAC_ABN_NUM := ref_abn_.abn_ref;
        end loop;

        if V_FAC_ABN_NUM  is null then
          V_FAC_ABN_NUM := lpad(facture_.dist,2,'0') ||
                        lpad(facture_.tou,3,'0') ||
                        lpad(facture_.ord,3,'0') ||
                        lpad(facture_.pol,5,'0');
         end if;
        -- Insertion de la facture
        if facture_.ctarif='21' then facture_.tva:='0';    facture_.taxe:='0';  end if;
     --   if facture_.CAT='7'    then facture_.capit:='0';  facture_.inter:='0'; end if;

      v_mrel_ref:=null;
      begin
         select r.mrel_ref into v_mrel_ref
         from miwtreleve r
         where substr(r.mrel_refpdl,1,8)=substr(v_ID_FACTURE,1,8)
         and  TO_CHAR(r.annee)=substr(v_ID_FACTURE,9,4)
         and lpad(TO_CHAR(r.periode),2,'0')=substr(v_ID_FACTURE,13,2);
       exception when others then
            begin
             select t.mrel_ref into v_mrel_ref
             from miwtrelevet t
             where substr(t.mrel_refpdl,1,8)=substr(v_ID_FACTURE,1,8)
             and  TO_CHAR(t.annee)=substr(v_ID_FACTURE,9,4)
             and lpad(TO_CHAR(t.periode),2,'0')=substr(v_ID_FACTURE,13,2);
           exception when others then
            v_mrel_ref:=null;
           end ;
       end;

    begin

        insert into miwtfactureentete
        (
        MFAE_SOURCE      ,--1   VARCHAR2(100)  N      Code source/origine de la facture [OBL]
        MFAE_REF         ,--2   VARCHAR2(100)  N      Identifiant unique de la facture pour la source [OBL]
        MFAE_REFTRF      ,--3   VARCHAR2(100)  Y      Identifiant du train de la facture
        MFAE_NUME        ,--4   NUMBER(10)     Y      Numero de la facture [OBL]
        MFAE_RDET        ,--5   VARCHAR2(15)   Y      RDET de la facture
        MFAE_CCMO        ,--6   VARCHAR2(1)    Y      Cle controle RDET de la facture
        MFAE_DEDI        ,--7   DATE           N      Date d edition de la facture [OBL]
        MFAE_DLPAI       ,--8   DATE           Y      Date limite de paiement de la facture [OBL]
        MFAE_DPREL       ,--9   DATE           Y      Date de prelevement de la facture [OBL]
        MFAE_TOTHTE      ,--10  NUMBER(10,2)   N      Total HT EAU de la facture [OBL]
        MFAE_TOTTVAE     ,--11  NUMBER(10,2)   N      Total TVA EAU de la facture [OBL]
        MFAE_TOTHTA      ,--12  NUMBER(10,2)   N      Total HT ASS de la facture [OBL]
        MFAE_TOTTVAA     ,--13  NUMBER(10,2)   N      Total TVA ASS de la facture [OBL]
        MFAE_SOLDE       ,--14  NUMBER(10,2)   Y      Solde TTC de la facture
        MFAE_TYPE        ,--15  VARCHAR2(2)    N  'R'
        MFAE_REFFAEDEDU  ,--16  VARCHAR2(100)  Y
        MFAE_REFABN      ,--17  VARCHAR2(100)  N      Identifiant du contrat de la facture [OBL]
        MFAE_REF_CODNIV_RELANCE,--18 VARCHAR2(100)  Y Reference Code niveau de chainde relance
        MFAE_RIB_REF     ,--19  VARCHAR2(100)  Y      Reference Rib
        MFAE_RIB_ETAT    ,--20  NUMBER(1)      Y      Mode de payement (pr?l?vement 1 ou tip 2)
        MFAE_COMPTEAUX   ,--21  VARCHAR2(100)  Y      Compte auxilaire GENACCOUNT associe a la facture
        MFAE_REF_ORIGINE ,--22  VARCHAR2(100)  Y      Facture origine
        MFAE_COMMENT     ,--23  VARCHAR2(4000) Y      Commentaire libre Facture
        MFAE_AMOUNTTTCDEC,--24  NUMBER(17,10)  Y      Montant TTC a deduire
        VOC_MODEFACT     ,--25  VARCHAR2(10)   Y
        MFAE_REF_DEDUC   ,--26  VARCHAR2(100)  Y
        MFAE_REFORGA     ,--27  VARCHAR2(100)  Y
        MFAE_EXERCICE    ,--28  NUMBER(4)      Y      Exercice du role de la facture
        MFAE_NUMEROROLE  ,--29  NUMBER(4)      Y      Numero du role pour l exercice
        MFAE_PREL        ,--30  NUMBER         Y
        MREL_REF          --31
        )
       values
       (
        'DIST'||v_district   ,--1
        V_FAC_NUM            ,--2
        V_TRAIN_FACT         ,--3
        V_FAC_NUM            ,--4
        v_ID_FACTURE         ,--5
        NULL                 ,--6
        V_FAC_DATECALCUL     ,--7
        V_FAC_DATELIM        ,--8
        V_FAC_DATECALCUL     ,--9
        (facture_.net-(facture_.tva+facture_.taxe+facture_.arriere))/1000,--10
        (facture_.tva+facture_.taxe)/1000,--11
        0                    ,--12
        0                    , --13
        (facture_.net-facture_.arriere)/1000,--14
        'FC'                 ,--15
        NULL                 ,--16
        V_FAC_ABN_NUM        ,--17
        'INCONNUE'           ,--18
         null                ,--19
        4                    ,--20
        'IMP_MIG'            ,--21
        null                 ,--22
        V_REF_ABN            ,--23
        NULL                 ,--24
        'MIG'                ,--25
        NULL                 ,--26
        v_district           ,--27
        anneereel_           ,--28
        periode_             ,--29
        1                    ,--30
        v_mrel_ref            --31
        );
        exception
          when others then
            err_code := SQLCODE;
            err_msg  := SUBSTR(SQLERRM, 1, 200);
            insert into prob_migration
              (nom_table, val_ref, sql_err, date_pro,type_problem )
            values
              ('miwtfacture',
               lpad(facture_.dist,2,'0') ||
               lpad(facture_.tou,3,'0') ||
               lpad(facture_.ord,3,'0') ||
               lpad(facture_.pol,5,'0'),
               err_code || '--' || err_msg,
               sysdate,'erreur de confomité de type colonne');
        end;
----------------------------------------------------------------------------------------------------------

--------------------------------------------------- LIGNE FACTURE CONSOMMATION SONNEDE
if to_number(facture_.montt1) <> 0 then

         begin
         insert into miwtfactureligne
              (
                MFAL_SOURCE    ,--1   VARCHAR2(100) N      Code source/origine de la ligne [OBL]
                MFAL_REFFAE    ,--2   VARCHAR2(100) N      Identifiant de la facture de la ligne [OBL]
                MFAL_REFTAP    ,--3   VARCHAR2(100) N      Identifiant de la periode de tarif de la ligne [OBL]
                MFAL_REFART    ,--4   VARCHAR2(100) Y
                MFAL_LIBE      ,--5   VARCHAR2(200) Y
                MFAL_NUM       ,--6   NUMBER(4)     N
                MFAL_TRAN      ,--7   NUMBER(1)     N  1   Tranche de la ligne [OBL]
                MFAL_EXER      ,--8   NUMBER(4)     N      Annee exercice de la ligne [OBL]
                MFAL_VOLU      ,--9   NUMBER(15,3)  N      Volume facture de la ligne [OBL]
                MFAL_PU        ,--10  NUMBER(12,6)  N      P.U. facture de la ligne [OBL]
                MFAL_MTHT      ,--11  NUMBER(15,2)  N      Montant HT de la ligne [OBL]
                MFAL_MTVA      ,--12  NUMBER(15,2)  N      Montant TVA de la ligne [OBL]
                MFAL_TTVA      ,--13  NUMBER(15,2)  N      Taux de TVA de la ligne [OBL]
                MFAL_MTTC      ,--14  NUMBER(15,2)  N
                MFAL_DDEBPERFAC,--15  DATE          Y      Date de debut de la periode facturee de la ligne
                MFAL_DFINPERFAC,--16  DATE          Y      Date de fin de la periode facturee de la ligne
                MFAL_DETAIL     --17  NUMBER        Y
               )
                values
              (
               'DIST'||v_district,--1
                V_FAC_NUM        ,--2
                1                ,--3
                'CSM_STD'        ,--4
                'consommation sonede 1ere Tranche',--5
                1                ,--6
                1                ,--7
                anneereel_       ,--8
                facture_.const1  ,--9
                facture_.tauxt1/1000,--10
                facture_.montt1/1000,--11
                facture_.taxe/1000,--12
                18               ,--13
                facture_.montt1/1000+(facture_.taxe/1000),--14
                null             ,--15
                DATE_            ,--16
                null              --17
               );
           exception
          when others then
            err_code := SQLCODE;
            err_msg  := SUBSTR(SQLERRM, 1, 200);
            insert into prob_migration
              (nom_table, val_ref, sql_err, date_pro,type_problem)
            values
              ('miwtfactureligne',
               V_FAC_NUM,
               err_code || '--' || err_msg,
               sysdate,'erreur de confomité de type colonne');
        end;
end if;

if to_number(facture_.montt2) <> 0 then
         begin
         insert into miwtfactureligne
              (
                MFAL_SOURCE,--1  VARCHAR2(100)  N      Code source/origine de la ligne [OBL]
                MFAL_REFFAE,--2  VARCHAR2(100)  N      Identifiant de la facture de la ligne [OBL]
                MFAL_REFTAP,--3  VARCHAR2(100)  N      Identifiant de la periode de tarif de la ligne [OBL]
                MFAL_REFART,--4  VARCHAR2(100)  Y
                MFAL_LIBE  ,--5  VARCHAR2(200)  Y
                MFAL_NUM   ,--6  NUMBER(4)      N
                MFAL_TRAN  ,--7  NUMBER(1)      N  1   Tranche de la ligne [OBL]
                MFAL_EXER  ,--8  NUMBER(4)      N      Annee exercice de la ligne [OBL]
                MFAL_VOLU  ,--9  NUMBER(15,3)   N      Volume facture de la ligne [OBL]
                MFAL_PU    ,--10 NUMBER(12,6)   N      P.U. facture de la ligne [OBL]
                MFAL_MTHT  ,--11 NUMBER(15,2)   N      Montant HT de la ligne [OBL]
                MFAL_MTVA  ,--12 NUMBER(15,2)   N      Montant TVA de la ligne [OBL]
                MFAL_TTVA  ,--13 NUMBER(15,2)   N      Taux de TVA de la ligne [OBL]
                MFAL_MTTC  ,--14 NUMBER(15,2)   N
                MFAL_DDEBPERFAC,--15  DATE      Y      Date de debut de la periode facturee de la ligne
                MFAL_DFINPERFAC,--16  DATE      Y      Date de fin de la periode facturee de la ligne
                MFAL_DETAIL --17 NUMBER         Y
               )
                values
               (
               'DIST'||v_district ,--1
                V_FAC_NUM         ,--2
                1                 ,--3
                'CSM_STD'         ,--4
                'consommation sonede 2eme Tranche',--5
                2                 ,--6
                2                 ,--7
                anneereel_        ,--8
                facture_.const2   ,--9
                facture_.tauxt2/1000,--10
                facture_.montt2/1000,--11
                facture_.taxe/1000,--12
                18                ,--13
                facture_.montt2/1000+(facture_.taxe/1000),--14
                null              ,--15
                DATE_             ,--16
                null               --17
                );
           exception
          when others then
            err_code := SQLCODE;
            err_msg  := SUBSTR(SQLERRM, 1, 200);
            insert into prob_migration
              (nom_table, val_ref, sql_err, date_pro,type_problem)
            values
              ('miwtfactureligne',
               V_FAC_NUM,
               err_code || '--' || err_msg,sysdate,'erreur de confomité de type colonne');
        end;
end if;

    if to_number(facture_.montt3) <> 0 then
         begin
         insert into miwtfactureligne
             (
                MFAL_SOURCE    ,--1  VARCHAR2(100)  N      Code source/origine de la ligne [OBL]
                MFAL_REFFAE    ,--2 VARCHAR2(100)   N      Identifiant de la facture de la ligne [OBL]
                MFAL_REFTAP    ,--3  VARCHAR2(100)  N      Identifiant de la periode de tarif de la ligne [OBL]
                MFAL_REFART    ,--4  VARCHAR2(100)  Y
                MFAL_LIBE      ,--5  VARCHAR2(200)  Y
                MFAL_NUM       ,--6  NUMBER(4)      N
                MFAL_TRAN      ,--7  NUMBER(1)      N  1   Tranche de la ligne [OBL]
                MFAL_EXER      ,--8  NUMBER(4)      N      Annee exercice de la ligne [OBL]
                MFAL_VOLU      ,--9  NUMBER(15,3)   N      Volume facture de la ligne [OBL]
                MFAL_PU        ,--10  NUMBER(12,6)  N      P.U. facture de la ligne [OBL]
                MFAL_MTHT      ,--11  NUMBER(15,2)  N      Montant HT de la ligne [OBL]
                MFAL_MTVA      ,--12  NUMBER(15,2)  N      Montant TVA de la ligne [OBL]
                MFAL_TTVA      ,--13  NUMBER(15,2)  N      Taux de TVA de la ligne [OBL]
                MFAL_MTTC      ,--14  NUMBER(15,2)  N
                MFAL_DDEBPERFAC,--15  DATE          Y      Date de debut de la periode facturee de la ligne
                MFAL_DFINPERFAC,--16  DATE          Y      Date de fin de la periode facturee de la ligne
                MFAL_DETAIL     --17  NUMBER        Y
                )
                values
               (
               'DIST'||v_district,--1
                V_FAC_NUM        ,--2
                1                ,--3
                'CSM_STD'        ,--4
                'consommation sonede 3eme Tranche',--5
                3                ,--6
                3                ,--7
                anneereel_       ,--8
                facture_.const3  ,--9
                facture_.tauxt3/1000,--10
                facture_.montt3/1000,--11
                facture_.taxe/1000,--12
                18                ,--13
                facture_.montt3/1000+(facture_.taxe/1000),--14
                null              ,--15
                DATE_             ,--16
                null               --17
                );
           exception
          when others then
            err_code := SQLCODE;
            err_msg  := SUBSTR(SQLERRM, 1, 200);
            insert into prob_migration
              (nom_table, val_ref, sql_err, date_pro,type_problem)
            values
              ('miwtfactureligne',
               V_FAC_NUM,
               err_code || '--' || err_msg,sysdate,'erreur de confomité de type colonne');
        end;
end if;
    --------------------------------------------------- LIGNE FACTURE CONSOMMATION ONAS
if to_number(facture_.mon1) <> 0 then
         begin
         insert into miwtfactureligne
              (
                MFAL_SOURCE    ,--1  VARCHAR2(100)  N     Code source/origine de la ligne [OBL]
                MFAL_REFFAE    ,--2  VARCHAR2(100)  N     Identifiant de la facture de la ligne [OBL]
                MFAL_REFTAP    ,--3  VARCHAR2(100)  N     Identifiant de la periode de tarif de la ligne [OBL]
                MFAL_REFART    ,--4  VARCHAR2(100)  Y
                MFAL_LIBE      ,--5  VARCHAR2(200)  Y
                MFAL_NUM       ,--6  NUMBER(4)      N
                MFAL_TRAN      ,--7  NUMBER(1)      N  1  Tranche de la ligne [OBL]
                MFAL_EXER      ,--8  NUMBER(4)      N     Annee exercice de la ligne [OBL]
                MFAL_VOLU      ,--9  NUMBER(15,3)   N     Volume facture de la ligne [OBL]
                MFAL_PU        ,--10 NUMBER(12,6)   N     P.U. facture de la ligne [OBL]
                MFAL_MTHT      ,--11 NUMBER(15,2)   N     Montant HT de la ligne [OBL]
                MFAL_MTVA      ,--12 NUMBER(15,2)   N     Montant TVA de la ligne [OBL]
                MFAL_TTVA      ,--13 NUMBER(15,2)   N     Taux de TVA de la ligne [OBL]
                MFAL_MTTC      ,--14 NUMBER(15,2)   N
                MFAL_DDEBPERFAC,--15 DATE           Y     Date de debut de la periode facturee de la ligne
                MFAL_DFINPERFAC,--16 DATE           Y     Date de fin de la periode facturee de la ligne
                MFAL_DETAIL     --17 NUMBER         Y
                )
                values
               (
               'DIST'||v_district ,--1
                V_FAC_NUM         ,--2
                2                 ,--3
                'VAR_ONAS_1'      ,--4
                'Redevance onas 1ere Tranche',--5
                4                 ,--6
                1                 ,--7
                anneereel_        ,--8
                facture_.volon1   ,--9
                facture_.tauon1/1000,--10
                facture_.mon1/1000,--11
                0                 ,--12
                0                 ,--13
                facture_.mon1/1000,--14
                null              ,--15
                DATE_             ,--16
                null               --17
                );
           exception
          when others then
            err_code := SQLCODE;
            err_msg  := SUBSTR(SQLERRM, 1, 200);
            insert into prob_migration
              (nom_table, val_ref, sql_err, date_pro,type_problem)
            values
              ('miwtfactureligne',
               V_FAC_NUM,
               err_code || '--' || err_msg,sysdate,'erreur de confomité de type colonne');
        end;
end if;

if to_number(facture_.mon2) <> 0 then
         begin
         insert into miwtfactureligne
             (
                MFAL_SOURCE,--1  VARCHAR2(100)  N      Code source/origine de la ligne [OBL]
                MFAL_REFFAE,--2  VARCHAR2(100)  N      Identifiant de la facture de la ligne [OBL]
                MFAL_REFTAP,--3  VARCHAR2(100)  N      Identifiant de la periode de tarif de la ligne [OBL]
                MFAL_REFART,--4  VARCHAR2(100)  Y
                MFAL_LIBE  ,--5  VARCHAR2(200)  Y
                MFAL_NUM   ,--6  NUMBER(4)      N
                MFAL_TRAN  ,--7  NUMBER(1)      N  1   Tranche de la ligne [OBL]
                MFAL_EXER  ,--8  NUMBER(4)      N      Annee exercice de la ligne [OBL]
                MFAL_VOLU  ,--9  NUMBER(15,3)   N      Volume facture de la ligne [OBL]
                MFAL_PU    ,--10  NUMBER(12,6)  N      P.U. facture de la ligne [OBL]
                MFAL_MTHT  ,--11  NUMBER(15,2)  N      Montant HT de la ligne [OBL]
                MFAL_MTVA  ,--12  NUMBER(15,2)  N      Montant TVA de la ligne [OBL]
                MFAL_TTVA  ,--13  NUMBER(15,2)  N      Taux de TVA de la ligne [OBL]
                MFAL_MTTC  ,--14  NUMBER(15,2)  N
                MFAL_DDEBPERFAC,--15  DATE      Y      Date de debut de la periode facturee de la ligne
                MFAL_DFINPERFAC,--16  DATE      Y      Date de fin de la periode facturee de la ligne
                MFAL_DETAIL --17  NUMBER        Y
               )
                values
               (
                'DIST'||v_district,--1
                V_FAC_NUM         ,--2
                2                 ,--3
                'VAR_ONAS_1'      ,--4
                'Redevance onas 2eme Tranche',--5
                5                 ,--6
                2                 ,--7
                anneereel_        ,--8
                facture_.volon2   ,--9
                facture_.tauon2/1000,--10
                facture_.mon2/1000,--11
                0                 ,--12
                0                 ,--13
                facture_.mon2/1000,--14
                null              ,--15
                DATE_             ,--16
                null               --17
                 );
           exception
          when others then
            err_code := SQLCODE;
            err_msg  := SUBSTR(SQLERRM, 1, 200);
            insert into prob_migration
              (nom_table, val_ref, sql_err, date_pro,type_problem)
            values
              ('miwtfactureligne',
               V_FAC_NUM,
               err_code || '--' || err_msg,sysdate,'erreur de confomité de type colonne');
        end;
end if;

if to_number(facture_.mon3) <> 0 then
         begin
         insert into miwtfactureligne
              (
                MFAL_SOURCE,--1  VARCHAR2(100)  N      Code source/origine de la ligne [OBL]
                MFAL_REFFAE,--2  VARCHAR2(100)  N      Identifiant de la facture de la ligne [OBL]
                MFAL_REFTAP,--3  VARCHAR2(100)  N      Identifiant de la periode de tarif de la ligne [OBL]
                MFAL_REFART,--4  VARCHAR2(100)  Y
                MFAL_LIBE  ,--5  VARCHAR2(200)  Y
                MFAL_NUM   ,--6  NUMBER(4)      N
                MFAL_TRAN  ,--7  NUMBER(1)      N  1   Tranche de la ligne [OBL]
                MFAL_EXER  ,--8  NUMBER(4)      N      Annee exercice de la ligne [OBL]
                MFAL_VOLU  ,--9  NUMBER(15,3)   N      Volume facture de la ligne [OBL]
                MFAL_PU    ,--10  NUMBER(12,6)  N      P.U. facture de la ligne [OBL]
                MFAL_MTHT  ,--11  NUMBER(15,2)  N      Montant HT de la ligne [OBL]
                MFAL_MTVA  ,--12  NUMBER(15,2)  N      Montant TVA de la ligne [OBL]
                MFAL_TTVA  ,--13  NUMBER(15,2)  N      Taux de TVA de la ligne [OBL]
                MFAL_MTTC  ,--14  NUMBER(15,2)  N
                MFAL_DDEBPERFAC,--15  DATE      Y      Date de debut de la periode facturee de la ligne
                MFAL_DFINPERFAC,--16  DATE      Y      Date de fin de la periode facturee de la ligne
                MFAL_DETAIL --17  NUMBER        Y
                )
                values
               (
               'DIST'||v_district ,--1
                V_FAC_NUM         ,--2
                2                 ,--3
                'VAR_ONAS_1'      ,--4
                'Redevance onas 3eme Tranche',--5
                6                 ,--6
                3                 ,--7
                anneereel_        ,--8
                facture_.volon3   ,--9
                facture_.tauon3/1000,--10
                facture_.mon3/1000,--11
                0                 ,--12
                0                 ,--13
                facture_.mon3/1000,--14
                null              ,--15
                DATE_             ,--16
                null               --17
                );
           exception
          when others then
            err_code := SQLCODE;
            err_msg  := SUBSTR(SQLERRM, 1, 200);
            insert into prob_migration
              (nom_table, val_ref, sql_err, date_pro,type_problem)
            values
              ('miwtfactureligne',
               V_FAC_NUM,
               err_code || '--' || err_msg,sysdate,'erreur de confomité de type colonne');
        end;
end if;

if to_number(facture_.fixonas) <> 0 then
         begin
         insert into miwtfactureligne
              (
                MFAL_SOURCE,--1  VARCHAR2(100)  N      Code source/origine de la ligne [OBL]
                MFAL_REFFAE,--2  VARCHAR2(100)  N      Identifiant de la facture de la ligne [OBL]
                MFAL_REFTAP,--3  VARCHAR2(100)  N      Identifiant de la periode de tarif de la ligne [OBL]
                MFAL_REFART,--4  VARCHAR2(100)  Y
                MFAL_LIBE  ,--5  VARCHAR2(200)  Y
                MFAL_NUM   ,--6  NUMBER(4)      N
                MFAL_TRAN  ,--7  NUMBER(1)      N  1   Tranche de la ligne [OBL]
                MFAL_EXER  ,--8  NUMBER(4)      N      Annee exercice de la ligne [OBL]
                MFAL_VOLU  ,--9  NUMBER(15,3)   N      Volume facture de la ligne [OBL]
                MFAL_PU    ,--10  NUMBER(12,6)  N      P.U. facture de la ligne [OBL]
                MFAL_MTHT  ,--11  NUMBER(15,2)  N      Montant HT de la ligne [OBL]
                MFAL_MTVA  ,--12  NUMBER(15,2)  N      Montant TVA de la ligne [OBL]
                MFAL_TTVA  ,--13  NUMBER(15,2)  N      Taux de TVA de la ligne [OBL]
                MFAL_MTTC  ,--14  NUMBER(15,2)  N
                MFAL_DDEBPERFAC,--15  DATE      Y      Date de debut de la periode facturee de la ligne
                MFAL_DFINPERFAC,--16  DATE      Y      Date de fin de la periode facturee de la ligne
                MFAL_DETAIL --17  NUMBER        Y
                )
                values
               (
               'DIST'||v_district ,--1
                V_FAC_NUM         ,--2
                2                 ,--3
                'FIXE_ONAS_1'     ,--4
                'Frais fixe onas' ,--5
                7                 ,--6
                1                 ,--7
                anneereel_        ,--8
                1                 ,--9
                facture_.fixonas/1000,--10
                facture_.fixonas/1000,--11
                0                 ,--12
                0                 ,--13
                facture_.fixonas/1000,--14
                null              ,--15
                DATE_             ,--16
                null               --17
                );
           exception
          when others then
            err_code := SQLCODE;
            err_msg  := SUBSTR(SQLERRM, 1, 200);
            insert into prob_migration
              (nom_table, val_ref, sql_err, date_pro,type_problem)
            values
              ('miwtfactureligne',
               V_FAC_NUM,
               err_code || '--' || err_msg,sysdate,'erreur de confomité de type colonne');
        end;
end if;

if to_number(facture_.FRLETTRE) <> 0 then
         begin
         insert into miwtfactureligne
              (
                MFAL_SOURCE    ,--1   VARCHAR2(100)  N      Code source/origine de la ligne [OBL]
                MFAL_REFFAE    ,--2   VARCHAR2(100)  N      Identifiant de la facture de la ligne [OBL]
                MFAL_REFTAP    ,--3   VARCHAR2(100)  N      Identifiant de la periode de tarif de la ligne [OBL]
                MFAL_REFART    ,--4   VARCHAR2(100)  Y
                MFAL_LIBE      ,--5   VARCHAR2(200)  Y
                MFAL_NUM       ,--6   NUMBER(4)      N
                MFAL_TRAN      ,--7   NUMBER(1)      N  1   Tranche de la ligne [OBL]
                MFAL_EXER      ,--8   NUMBER(4)      N      Annee exercice de la ligne [OBL]
                MFAL_VOLU      ,--9   NUMBER(15,3)   N      Volume facture de la ligne [OBL]
                MFAL_PU        ,--10  NUMBER(12,6)   N      P.U. facture de la ligne [OBL]
                MFAL_MTHT      ,--11  NUMBER(15,2)   N      Montant HT de la ligne [OBL]
                MFAL_MTVA      ,--12  NUMBER(15,2)   N      Montant TVA de la ligne [OBL]
                MFAL_TTVA      ,--13  NUMBER(15,2)   N      Taux de TVA de la ligne [OBL]
                MFAL_MTTC      ,--14  NUMBER(15,2)   N
                MFAL_DDEBPERFAC,--15  DATE           Y      Date de debut de la periode facturee de la ligne
                MFAL_DFINPERFAC,--16  DATE           Y      Date de fin de la periode facturee de la ligne
                MFAL_DETAIL     --17  NUMBER         Y
                )
                values
               (
               'DIST'||v_district ,--1
                V_FAC_NUM         ,--2
                1                 ,--3
                'FRS_R_C_NN_PAY'  ,--4
                'Frais lettre '   ,--5
                8                 ,--6
                1                 ,--7
                anneereel_        ,--8
                1                 ,--9
                1.900             ,--10
                1.900             ,--11
                0                 ,--12
                0                 ,--13
                1.900             ,--14
                null              ,--15
                DATE_             ,--16
                null               --17
                );
           exception
          when others then
            err_code := SQLCODE;
            err_msg  := SUBSTR(SQLERRM, 1, 200);
            insert into prob_migration
              (nom_table, val_ref, sql_err, date_pro,type_problem)
            values
              ('miwtfactureligne',
               V_FAC_NUM,
               err_code || '--' || err_msg,sysdate,'erreur de confomité de type colonne');
        end;
end if;

if to_number(facture_.fraisctr) <> 0 then
         begin
         insert into miwtfactureligne
              (
                MFAL_SOURCE     ,--1  VARCHAR2(100)  N      Code source/origine de la ligne [OBL]
                MFAL_REFFAE     ,--2  VARCHAR2(100)  N      Identifiant de la facture de la ligne [OBL]
                MFAL_REFTAP     ,--3  VARCHAR2(100)  N      Identifiant de la periode de tarif de la ligne [OBL]
                MFAL_REFART     ,--4  VARCHAR2(100)  Y
                MFAL_LIBE       ,--5  VARCHAR2(200)  Y
                MFAL_NUM        ,--6  NUMBER(4)      N
                MFAL_TRAN       ,--7  NUMBER(1)      N  1    Tranche de la ligne [OBL]
                MFAL_EXER       ,--8  NUMBER(4)      N      Annee exercice de la ligne [OBL]
                MFAL_VOLU       ,--9  NUMBER(15,3)   N      Volume facture de la ligne [OBL]
                MFAL_PU         ,--10 NUMBER(12,6)   N      P.U. facture de la ligne [OBL]
                MFAL_MTHT       ,--11 NUMBER(15,2)   N      Montant HT de la ligne [OBL]
                MFAL_MTVA       ,--12 NUMBER(15,2)   N      Montant TVA de la ligne [OBL]
                MFAL_TTVA       ,--13 NUMBER(15,2)   N      Taux de TVA de la ligne [OBL]
                MFAL_MTTC       ,--14 NUMBER(15,2)   N
                MFAL_DDEBPERFAC ,--15 DATE           Y      Date de debut de la periode facturee de la ligne
                MFAL_DFINPERFAC ,--16 DATE           Y      Date de fin de la periode facturee de la ligne
                MFAL_DETAIL      --17 NUMBER         Y
                )
                values
               (
               'DIST'||v_district,--1
                V_FAC_NUM        ,--2
                1                ,--3
                'FRS_FIX_CSM'    ,--4
                'Frais fixe sonnede',--5
                9                ,--6
                1                ,--7
                anneereel_       ,--8
                1                ,--9
                facture_.fraisctr/1000,--10
                facture_.fraisctr/1000,--11
                facture_.TVA/1000,--12
                18               ,--13
                facture_.fraisctr/1000+(facture_.TVA/1000),--14
                null             ,--15
                DATE_            ,--16
                null              --17
               );
           exception
          when others then
            err_code := SQLCODE;
            err_msg  := SUBSTR(SQLERRM, 1, 200);
            insert into prob_migration
              (nom_table, val_ref, sql_err, date_pro,type_problem)
            values
              ('miwtfactureligne',
               V_FAC_NUM,
               err_code || '--' || err_msg,sysdate,'erreur de confomité de type colonne');
        end;

end if;

if to_number(facture_.FRferm) <> 0 then
         begin
         insert into miwtfactureligne
              (
                MFAL_SOURCE    ,--1  VARCHAR2(100)  N    Code source/origine de la ligne [OBL]
                MFAL_REFFAE    ,--2  VARCHAR2(100)  N    Identifiant de la facture de la ligne [OBL]
                MFAL_REFTAP    ,--3  VARCHAR2(100)  N    Identifiant de la periode de tarif de la ligne [OBL]
                MFAL_REFART    ,--4  VARCHAR2(100)  Y
                MFAL_LIBE      ,--5  VARCHAR2(200)  Y
                MFAL_NUM       ,--6  NUMBER(4)      N
                MFAL_TRAN      ,--7  NUMBER(1)      N  1  Tranche de la ligne [OBL]
                MFAL_EXER      ,--8  NUMBER(4)      N     Annee exercice de la ligne [OBL]
                MFAL_VOLU      ,--9  NUMBER(15,3)   N     Volume facture de la ligne [OBL]
                MFAL_PU        ,--10 NUMBER(12,6)   N     P.U. facture de la ligne [OBL]
                MFAL_MTHT      ,--11 NUMBER(15,2)   N     Montant HT de la ligne [OBL]
                MFAL_MTVA      ,--12 NUMBER(15,2)   N     Montant TVA de la ligne [OBL]
                MFAL_TTVA      ,--13 NUMBER(15,2)   N     Taux de TVA de la ligne [OBL]
                MFAL_MTTC      ,--14 NUMBER(15,2)   N
                MFAL_DDEBPERFAC,--15 DATE           Y     Date de debut de la periode facturee de la ligne
                MFAL_DFINPERFAC,--16 DATE           Y     Date de fin de la periode facturee de la ligne
                MFAL_DETAIL     --17 NUMBER         Y
                )
                values
               (
                'DIST'||v_district,--1
                V_FAC_NUM         ,--2
                1                 ,--3
                'FRS_FIX_PAVI_CPR',--4
                'Frais FERMETURE' ,--5
                10                ,--6
                1                 ,--7
                anneereel_        ,--8
                1                 ,--9
                facture_.FRFERM/1000,--10
                facture_.FRFERM/1000,--11
                0                 ,--12
                0                 ,--13
                facture_.FRFERM/1000,--14
                null              ,--15
                DATE_             ,--16
                null               --17
                 );
           exception
          when others then
            err_code := SQLCODE;
            err_msg  := SUBSTR(SQLERRM, 1, 200);
            insert into prob_migration
              (nom_table, val_ref, sql_err, date_pro,type_problem)
            values
              ('miwtfactureligne',
               V_FAC_NUM,
               err_code || '--' || err_msg,sysdate,'erreur de confomité de type colonne');
        end;
end if;

if to_number(facture_.CAPIT) <> 0 then
         begin
         insert into miwtfactureligne
              (
                MFAL_SOURCE     ,--1  VARCHAR2(100)  N      Code source/origine de la ligne [OBL]
                MFAL_REFFAE     ,--2  VARCHAR2(100)  N      Identifiant de la facture de la ligne [OBL]
                MFAL_REFTAP     ,--3  VARCHAR2(100)  N      Identifiant de la periode de tarif de la ligne [OBL]
                MFAL_REFART     ,--4  VARCHAR2(100)  Y
                MFAL_LIBE       ,--5  VARCHAR2(200)  Y
                MFAL_NUM        ,--6  NUMBER(4)      N
                MFAL_TRAN       ,--7  NUMBER(1)      N  1   Tranche de la ligne [OBL]
                MFAL_EXER       ,--8  NUMBER(4)      N      Annee exercice de la ligne [OBL]
                MFAL_VOLU       ,--9  NUMBER(15,3)   N      Volume facture de la ligne [OBL]
                MFAL_PU         ,--10 NUMBER(12,6)   N      P.U. facture de la ligne [OBL]
                MFAL_MTHT       ,--11 NUMBER(15,2)   N      Montant HT de la ligne [OBL]
                MFAL_MTVA       ,--12 NUMBER(15,2)   N      Montant TVA de la ligne [OBL]
                MFAL_TTVA       ,--13 NUMBER(15,2)   N      Taux de TVA de la ligne [OBL]
                MFAL_MTTC       ,--14 NUMBER(15,2)   N
                MFAL_DDEBPERFAC ,--15 DATE           Y      Date de debut de la periode facturee de la ligne
                MFAL_DFINPERFAC ,--16 DATE           Y      Date de fin de la periode facturee de la ligne
                MFAL_DETAIL      --17 NUMBER         Y
                )
                values
               (
               'DIST'||v_district,--1
                V_FAC_NUM        ,--2
                2                ,--3
                'CAPITAL'        ,--4
                'Montant capital',--5
                11               ,--6
                1                ,--7
                anneereel_       ,--8
                1                ,--9
                facture_.CAPIT/1000,--10
                facture_.CAPIT/1000,--11
                0                ,--12
                0                ,--13
                facture_.CAPIT/1000,--14
                null             ,--15
                DATE_            ,--16
                null              --17
                 );
           exception
          when others then
            err_code := SQLCODE;
            err_msg  := SUBSTR(SQLERRM, 1, 200);
            insert into prob_migration
              (nom_table, val_ref, sql_err, date_pro,type_problem)
            values
              ('miwtfactureligne',
               V_FAC_NUM,
               err_code || '--' || err_msg,sysdate,'erreur de confomité de type colonne');
        end;
end if;

if to_number(facture_.INTER) <> 0 then
         begin
         insert into miwtfactureligne
              (
                MFAL_SOURCE     ,--1  VARCHAR2(100)  N      Code source/origine de la ligne [OBL]
                MFAL_REFFAE     ,--2  VARCHAR2(100)  N      Identifiant de la facture de la ligne [OBL]
                MFAL_REFTAP     ,--3  VARCHAR2(100)  N      Identifiant de la periode de tarif de la ligne [OBL]
                MFAL_REFART     ,--4  VARCHAR2(100)  Y
                MFAL_LIBE       ,--5  VARCHAR2(200)  Y
                MFAL_NUM        ,--6  NUMBER(4)      N
                MFAL_TRAN       ,--7  NUMBER(1)      N  1   Tranche de la ligne [OBL]
                MFAL_EXER       ,--8  NUMBER(4)      N      Annee exercice de la ligne [OBL]
                MFAL_VOLU       ,--9  NUMBER(15,3)   N      Volume facture de la ligne [OBL]
                MFAL_PU         ,--10 NUMBER(12,6)   N      P.U. facture de la ligne [OBL]
                MFAL_MTHT       ,--11 NUMBER(15,2)   N      Montant HT de la ligne [OBL]
                MFAL_MTVA       ,--12 NUMBER(15,2)   N      Montant TVA de la ligne [OBL]
                MFAL_TTVA       ,--13 NUMBER(15,2)   N      Taux de TVA de la ligne [OBL]
                MFAL_MTTC       ,--14 NUMBER(15,2)   N
                MFAL_DDEBPERFAC ,--15 DATE           Y      Date de debut de la periode facturee de la ligne
                MFAL_DFINPERFAC ,--16 DATE           Y      Date de fin de la periode facturee de la ligne
                MFAL_DETAIL      --17 NUMBER         Y
                )
                values
               (
               'DIST'||v_district,--1
                V_FAC_NUM        ,--2
                2                ,--3
                'INTERET'        ,--4
                'Montant Interet',--5
                12               ,--6
                1                ,--7
                anneereel_       ,--8
                1                ,--9
                facture_.INTER/1000,--10
                facture_.INTER/1000,--11
                0                ,--12
                0                ,--13
                facture_.INTER/1000,--14
                null             ,--15
                DATE_            ,--16
                null              --17
                );
           exception
          when others then
            err_code := SQLCODE;
            err_msg  := SUBSTR(SQLERRM, 1, 200);
            insert into prob_migration
              (nom_table, val_ref, sql_err, date_pro,type_problem)
            values
              ('miwtfactureligne',
               V_FAC_NUM,
               err_code || '--' || err_msg,sysdate,'erreur de confomité de type colonne');
        end;
end if;

if to_number(facture_.RBRANCHE) <> 0 then
         begin
         insert into miwtfactureligne
              (
                MFAL_SOURCE    ,--1  VARCHAR2(100)  N      Code source/origine de la ligne [OBL]
                MFAL_REFFAE    ,--2  VARCHAR2(100)  N      Identifiant de la facture de la ligne [OBL]
                MFAL_REFTAP    ,--3  VARCHAR2(100)  N      Identifiant de la periode de tarif de la ligne [OBL]
                MFAL_REFART    ,--4  VARCHAR2(100)  Y
                MFAL_LIBE      ,--5  VARCHAR2(200)  Y
                MFAL_NUM       ,--6  NUMBER(4)      N
                MFAL_TRAN      ,--7  NUMBER(1)      N  1   Tranche de la ligne [OBL]
                MFAL_EXER      ,--8  NUMBER(4)      N      Annee exercice de la ligne [OBL]
                MFAL_VOLU      ,--9  NUMBER(15,3)   N      Volume facture de la ligne [OBL]
                MFAL_PU        ,--10 NUMBER(12,6)   N      P.U. facture de la ligne [OBL]
                MFAL_MTHT      ,--11 NUMBER(15,2)   N      Montant HT de la ligne [OBL]
                MFAL_MTVA      ,--12 NUMBER(15,2)   N      Montant TVA de la ligne [OBL]
                MFAL_TTVA      ,--13 NUMBER(15,2)   N      Taux de TVA de la ligne [OBL]
                MFAL_MTTC      ,--14 NUMBER(15,2)   N
                MFAL_DDEBPERFAC,--15 DATE           Y      Date de debut de la periode facturee de la ligne
                MFAL_DFINPERFAC,--16 DATE           Y      Date de fin de la periode facturee de la ligne
                MFAL_DETAIL     --17 NUMBER         Y
                )
                values
               (
               'DIST'||v_district,--1
                V_FAC_NUM        ,--2
                1                ,--3
                'COURETABBR'     ,--4
                'Montant branchement',--5
                13               ,--6
                1                ,--7
                anneereel_       ,--8
                1                ,--9
                facture_.RBRANCHE/1000,--10
                facture_.RBRANCHE/1000,--11
                0                ,--12
                0                ,--13
                facture_.RBRANCHE/1000,--14
                null             ,--15
                DATE_            ,--16
                null              --17
                );
           exception
          when others then
            err_code := SQLCODE;
            err_msg  := SUBSTR(SQLERRM, 1, 200);
            insert into prob_migration
              (nom_table, val_ref, sql_err, date_pro,type_problem)
            values
              ('miwtfactureligne',
               V_FAC_NUM,
               err_code || '--' || err_msg,sysdate,'erreur de confomité de type colonne');
        end;
end if;

if to_number(facture_.RFACADE) <> 0 then
         begin
         insert into miwtfactureligne
              (
                MFAL_SOURCE    ,--1  VARCHAR2(100)  N      Code source/origine de la ligne [OBL]
                MFAL_REFFAE    ,--2  VARCHAR2(100)  N      Identifiant de la facture de la ligne [OBL]
                MFAL_REFTAP    ,--3  VARCHAR2(100)  N      Identifiant de la periode de tarif de la ligne [OBL]
                MFAL_REFART    ,--4  VARCHAR2(100)  Y
                MFAL_LIBE      ,--5  VARCHAR2(200)  Y
                MFAL_NUM       ,--6  NUMBER(4)      N
                MFAL_TRAN      ,--7  NUMBER(1)      N  1   Tranche de la ligne [OBL]
                MFAL_EXER      ,--8  NUMBER(4)      N      Annee exercice de la ligne [OBL]
                MFAL_VOLU      ,--9  NUMBER(15,3)   N      Volume facture de la ligne [OBL]
                MFAL_PU        ,--10 NUMBER(12,6)   N      P.U. facture de la ligne [OBL]
                MFAL_MTHT      ,--11 NUMBER(15,2)   N      Montant HT de la ligne [OBL]
                MFAL_MTVA      ,--12 NUMBER(15,2)   N      Montant TVA de la ligne [OBL]
                MFAL_TTVA      ,--13 NUMBER(15,2)   N      Taux de TVA de la ligne [OBL]
                MFAL_MTTC      ,--14 NUMBER(15,2)   N
                MFAL_DDEBPERFAC,--15 DATE           Y      Date de debut de la periode facturee de la ligne
                MFAL_DFINPERFAC,--16 DATE           Y      Date de fin de la periode facturee de la ligne
                MFAL_DETAIL     --17 NUMBER         Y
                )
                values
               (
               'DIST'||v_district,--1
                V_FAC_NUM        ,--2
                1                ,--3
                'FACADE'         ,--4
                'Montant facade' ,--5
                14               ,--6
                1                ,--7
                anneereel_       ,--8
                1                ,--9
                facture_.RFACADE/1000,--10
                facture_.RFACADE/1000,--11
                0                ,--12
                0                ,--13
                facture_.RFACADE/1000,--14
                null             ,--15
                DATE_            ,--16
                null              --17
                );
           exception
          when others then
            err_code := SQLCODE;
            err_msg  := SUBSTR(SQLERRM, 1, 200);
            insert into prob_migration
              (nom_table, val_ref, sql_err, date_pro,type_problem)
            values
              ('miwtfactureligne',
               V_FAC_NUM,
               err_code || '--' || err_msg,sysdate,'erreur de confomité de type colonne');
        end;
end if;

if to_number(facture_.REXTENSION) <> 0 then
         begin
         insert into miwtfactureligne
              (
                MFAL_SOURCE    ,--1  VARCHAR2(100)  N      Code source/origine de la ligne [OBL]
                MFAL_REFFAE    ,--2  VARCHAR2(100)  N      Identifiant de la facture de la ligne [OBL]
                MFAL_REFTAP    ,--3  VARCHAR2(100)  N      Identifiant de la periode de tarif de la ligne [OBL]
                MFAL_REFART    ,--4  VARCHAR2(100)  Y
                MFAL_LIBE      ,--5  VARCHAR2(200)  Y
                MFAL_NUM       ,--6  NUMBER(4)      N
                MFAL_TRAN      ,--7  NUMBER(1)      N  1   Tranche de la ligne [OBL]
                MFAL_EXER      ,--8  NUMBER(4)      N      Annee exercice de la ligne [OBL]
                MFAL_VOLU      ,--9  NUMBER(15,3)   N      Volume facture de la ligne [OBL]
                MFAL_PU        ,--10 NUMBER(12,6)   N      P.U. facture de la ligne [OBL]
                MFAL_MTHT      ,--11 NUMBER(15,2)   N      Montant HT de la ligne [OBL]
                MFAL_MTVA      ,--12 NUMBER(15,2)   N      Montant TVA de la ligne [OBL]
                MFAL_TTVA      ,--13 NUMBER(15,2)   N      Taux de TVA de la ligne [OBL]
                MFAL_MTTC      ,--14 NUMBER(15,2)   N
                MFAL_DDEBPERFAC,--15 DATE           Y      Date de debut de la periode facturee de la ligne
                MFAL_DFINPERFAC,--16 DATE           Y      Date de fin de la periode facturee de la ligne
                MFAL_DETAIL     --17 NUMBER         Y
                )
                values
               (
               'DIST'||v_district,--1
                V_FAC_NUM        ,--2
                1                ,--3
                'REXTENSION'     ,--4
                'Montant extension',--5
                15               ,--6
                1                ,--7
                anneereel_       ,--8
                1                ,--9
                facture_.REXTENSION/1000,--10
                facture_.REXTENSION/1000,--11
                0                ,--12
                0                ,--13
                facture_.REXTENSION/1000,--14
                null             ,--15
                DATE_            ,--16
                null              --17
                 );
           exception
          when others then
            err_code := SQLCODE;
            err_msg  := SUBSTR(SQLERRM, 1, 200);
            insert into prob_migration
              (nom_table, val_ref, sql_err, date_pro,type_problem)
            values
              ('miwtfactureligne',
               V_FAC_NUM,
               err_code || '--' || err_msg,sysdate,'erreur de confomité de type colonne');
        end;
end if;

if to_number(facture_.PFINANCIER) <> 0 then
         begin
         insert into miwtfactureligne
              (
                MFAL_SOURCE    ,--1  VARCHAR2(100)  N      Code source/origine de la ligne [OBL]
                MFAL_REFFAE    ,--2  VARCHAR2(100)  N      Identifiant de la facture de la ligne [OBL]
                MFAL_REFTAP    ,--3  VARCHAR2(100)  N      Identifiant de la periode de tarif de la ligne [OBL]
                MFAL_REFART    ,--4  VARCHAR2(100)  Y
                MFAL_LIBE      ,--5  VARCHAR2(200)  Y
                MFAL_NUM       ,--6  NUMBER(4)      N
                MFAL_TRAN      ,--7  NUMBER(1)      N  1   Tranche de la ligne [OBL]
                MFAL_EXER      ,--8  NUMBER(4)      N      Annee exercice de la ligne [OBL]
                MFAL_VOLU      ,--9  NUMBER(15,3)   N      Volume facture de la ligne [OBL]
                MFAL_PU        ,--10 NUMBER(12,6)   N      P.U. facture de la ligne [OBL]
                MFAL_MTHT      ,--11 NUMBER(15,2)   N      Montant HT de la ligne [OBL]
                MFAL_MTVA      ,--12 NUMBER(15,2)   N      Montant TVA de la ligne [OBL]
                MFAL_TTVA      ,--13 NUMBER(15,2)   N      Taux de TVA de la ligne [OBL]
                MFAL_MTTC      ,--14 NUMBER(15,2)   N
                MFAL_DDEBPERFAC,--15 DATE           Y      Date de debut de la periode facturee de la ligne
                MFAL_DFINPERFAC,--16 DATE           Y      Date de fin de la periode facturee de la ligne
                MFAL_DETAIL     --17 NUMBER         Y
                )
                values
               (
               'DIST'||v_district  ,--1
                V_FAC_NUM          ,--2
                1                  ,--3
                'PFINANCIER'       ,--4
                'PRODUIT FINANCIER',--5
                16                 ,--6
                1                  ,--7
                anneereel_         ,--8
                1                  ,--9
                facture_.PFINANCIER/1000,--10
                facture_.PFINANCIER/1000,--11
                0                  ,--12
                0                  ,--13
                facture_.PFINANCIER/1000,--14
                null               ,--15
                DATE_              ,--16
                null                --17
                );
           exception
          when others then
            err_code := SQLCODE;
            err_msg  := SUBSTR(SQLERRM, 1, 200);
            insert into prob_migration
              (nom_table, val_ref, sql_err, date_pro,type_problem)
            values
              ('miwtfactureligne',
               V_FAC_NUM,
               err_code || '--' || err_msg,sysdate,'erreur de confomité de type colonne');
        end;
end if;

---------------
if to_number(facture_.AREPOR) <> 0 then
         begin
         insert into miwtfactureligne
              (
                MFAL_SOURCE    ,--  VARCHAR2(100)  N      Code source/origine de la ligne [OBL]
                MFAL_REFFAE    ,--  VARCHAR2(100)  N      Identifiant de la facture de la ligne [OBL]
                MFAL_REFTAP    ,--  VARCHAR2(100)  N      Identifiant de la periode de tarif de la ligne [OBL]
                MFAL_REFART    ,--  VARCHAR2(100)  Y
                MFAL_LIBE      ,--  VARCHAR2(200)  Y
                MFAL_NUM       ,--  NUMBER(4)      N
                MFAL_TRAN      ,--  NUMBER(1)      N  1   Tranche de la ligne [OBL]
                MFAL_EXER      ,--  NUMBER(4)      N      Annee exercice de la ligne [OBL]
                MFAL_VOLU      ,--  NUMBER(15,3)   N      Volume facture de la ligne [OBL]
                MFAL_PU        ,--  NUMBER(12,6)   N      P.U. facture de la ligne [OBL]
                MFAL_MTHT      ,--  NUMBER(15,2)   N      Montant HT de la ligne [OBL]
                MFAL_MTVA      ,--  NUMBER(15,2)   N      Montant TVA de la ligne [OBL]
                MFAL_TTVA      ,--  NUMBER(15,2)   N      Taux de TVA de la ligne [OBL]
                MFAL_MTTC      ,--  NUMBER(15,2)   N
                MFAL_DDEBPERFAC,--  DATE           Y      Date de debut de la periode facturee de la ligne
                MFAL_DFINPERFAC,--  DATE           Y      Date de fin de la periode facturee de la ligne
                MFAL_DETAIL     --  NUMBER         Y
                )
                values
               (
               'DIST'||v_district,
                V_FAC_NUM        ,
                1                ,
                'AREPOR'         ,
                'Montant report' ,
                17               ,
                1                ,
                anneereel_       ,
                1                ,
                decode(facture_.caron,'1',1,-1)* (facture_.AREPOR/1000),
                decode(facture_.caron,'1',1,-1)* (facture_.AREPOR/1000),
                0                ,
                0                ,
                decode(facture_.caron,'1',1,-1)* (facture_.AREPOR/1000),
                null             ,
                DATE_            ,
                null
                );
           exception
          when others then
            err_code := SQLCODE;
            err_msg  := SUBSTR(SQLERRM, 1, 200);
            insert into prob_migration
              (nom_table, val_ref, sql_err, date_pro,type_problem)
            values
              ('miwtfactureligne',
               V_FAC_NUM,
               err_code || '--' || err_msg,sysdate,'erreur de confomité de type colonne');
        end;
end if;

if to_number(facture_.NAROND) <> 0 then
         begin
         insert into miwtfactureligne
              (
                MFAL_SOURCE    ,--  VARCHAR2(100)  N      Code source/origine de la ligne [OBL]
                MFAL_REFFAE    ,--  VARCHAR2(100)  N      Identifiant de la facture de la ligne [OBL]
                MFAL_REFTAP    ,--  VARCHAR2(100)  N      Identifiant de la periode de tarif de la ligne [OBL]
                MFAL_REFART    ,--  VARCHAR2(100)  Y
                MFAL_LIBE      ,--  VARCHAR2(200)  Y
                MFAL_NUM       ,--  NUMBER(4)      N
                MFAL_TRAN      ,--  NUMBER(1)      N  1   Tranche de la ligne [OBL]
                MFAL_EXER      ,--  NUMBER(4)      N      Annee exercice de la ligne [OBL]
                MFAL_VOLU      ,--  NUMBER(15,3)   N      Volume facture de la ligne [OBL]
                MFAL_PU        ,--  NUMBER(12,6)   N      P.U. facture de la ligne [OBL]
                MFAL_MTHT      ,--  NUMBER(15,2)   N      Montant HT de la ligne [OBL]
                MFAL_MTVA      ,--  NUMBER(15,2)   N      Montant TVA de la ligne [OBL]
                MFAL_TTVA      ,--  NUMBER(15,2)   N      Taux de TVA de la ligne [OBL]
                MFAL_MTTC      ,--  NUMBER(15,2)   N
                MFAL_DDEBPERFAC,--  DATE           Y      Date de debut de la periode facturee de la ligne
                MFAL_DFINPERFAC,--  DATE           Y      Date de fin de la periode facturee de la ligne
                MFAL_DETAIL     --  NUMBER         Y
                )
                values
               (
               'DIST'||v_district,
                V_FAC_NUM        ,
                1                ,
                'NAROND'         ,
                'Arrondissement' ,
                18               ,
                1                ,
                anneereel_       ,
                1                ,
                decode(facture_.caron,'1',-1,1)*(facture_.NAROND/1000),
                decode(facture_.caron,'1',-1,1)*(facture_.NAROND/1000),
                0                ,
                0                ,
                decode(facture_.caron,'1',-1,1)*(facture_.NAROND/1000),
                null             ,
                DATE_            ,
                null
                );
           exception
          when others then
            err_code := SQLCODE;
            err_msg  := SUBSTR(SQLERRM, 1, 200);
            insert into prob_migration
              (nom_table, val_ref, sql_err, date_pro,type_problem)
            values
              ('miwtfactureligne',
               V_FAC_NUM,
               err_code || '--' || err_msg,sysdate,'erreur de confomité de type colonne');
        end;
end if;

if to_number(facture_.DIVERS) <> 0 then
         begin
         insert into miwtfactureligne
              (
                MFAL_SOURCE    ,--  VARCHAR2(100)  N      Code source/origine de la ligne [OBL]
                MFAL_REFFAE    ,--  VARCHAR2(100)  N      Identifiant de la facture de la ligne [OBL]
                MFAL_REFTAP    ,--  VARCHAR2(100)  N      Identifiant de la periode de tarif de la ligne [OBL]
                MFAL_REFART    ,--  VARCHAR2(100)  Y
                MFAL_LIBE      ,--  VARCHAR2(200)  Y
                MFAL_NUM       ,--  NUMBER(4)      N
                MFAL_TRAN      ,--  NUMBER(1)      N  1   Tranche de la ligne [OBL]
                MFAL_EXER      ,--  NUMBER(4)      N      Annee exercice de la ligne [OBL]
                MFAL_VOLU      ,--  NUMBER(15,3)   N      Volume facture de la ligne [OBL]
                MFAL_PU        ,--  NUMBER(12,6)   N      P.U. facture de la ligne [OBL]
                MFAL_MTHT      ,--  NUMBER(15,2)   N      Montant HT de la ligne [OBL]
                MFAL_MTVA      ,--  NUMBER(15,2)   N      Montant TVA de la ligne [OBL]
                MFAL_TTVA      ,--  NUMBER(15,2)   N      Taux de TVA de la ligne [OBL]
                MFAL_MTTC      ,--  NUMBER(15,2)   N
                MFAL_DDEBPERFAC,--  DATE           Y      Date de debut de la periode facturee de la ligne
                MFAL_DFINPERFAC,--  DATE           Y      Date de fin de la periode facturee de la ligne
                MFAL_DETAIL     --  NUMBER         Y
                )
                values
               (
               'DIST'||v_district,
                V_FAC_NUM        ,
                1                ,
                'AUTREFRAIS'     ,
                'Frais Divers '  ,
                20               ,
                1                ,
                anneereel_       ,
                1                ,
                (facture_.DIVERS)/1000,
                (facture_.DIVERS)/1000,
                0                ,
                0                ,
                (facture_.DIVERS)/1000,
                null             ,
                DATE_            ,
                null
                );
           exception
          when others then
            err_code := SQLCODE;
            err_msg  := SUBSTR(SQLERRM, 1, 200);
            insert into prob_migration
              (nom_table, val_ref, sql_err, date_pro,type_problem)
            values
              ('miwtfactureligne',
               V_FAC_NUM,
               err_code || '--' || err_msg,sysdate,'erreur de confomité de type colonne');
        end;
 end if;
    -----------------------------------miwtreleve
         select count(*) into  nbr_trt from  miwtreleve
             where mrel_refpdl =
              lpad(facture_.DIST,2,'0')||
              lpad(facture_.tou,3,'0')||
              lpad(facture_.ORD,3,'0')||
              lpad(facture_.POL,5,'0')
              And mrel_refpdl is not null
               and   annee = anneereel_
               and   periode = periode_
               And rownum=1;
       if nbr_trt <> 0 then
        update  miwtreleve  set mrel_fact1 = v_ID_FACTURE
             where mrel_refpdl =
              lpad(facture_.DIST,2,'0')||
              lpad(facture_.tou,3,'0')||
              lpad(facture_.ORD,3,'0')||
              lpad(facture_.POL,5,'0')
              And mrel_refpdl is not null
               and   annee = anneereel_
               and   periode = periode_
               And rownum=1;

          end if;

         -----------------------------------miwtrelevet
         select count(*) into nbr_trt_rt  from  miwtrelevet
             where mrel_refpdl =
              lpad(facture_.DIST,2,'0')||
              lpad(facture_.tou,3,'0')||
              lpad(facture_.ORD,3,'0')||
              lpad(facture_.POL,5,'0')
              And mrel_refpdl is not null
               and   annee = anneereel_
               and   periode = periode_
               And rownum=1;
       if nbr_trt_rt <> 0 then
        update  miwtrelevet  set mrel_fact1 = v_ID_FACTURE
             where mrel_refpdl =
              lpad(facture_.DIST,2,'0')||
              lpad(facture_.tou,3,'0')||
              lpad(facture_.ORD,3,'0')||
              lpad(facture_.POL,5,'0')
              And mrel_refpdl is not null
               and   annee = anneereel_
               and   periode = periode_
               And rownum=1;

          end if;

   <<XX>>
        commit;

end loop;
        delete xx;
       insert into xx  select  substr(s.mfae_rdet,1,2) distirct,substr(s.mfae_rdet,3,3) tourne,substr(s.mfae_rdet,6,3) ordre ,substr(s.mfae_rdet,9,4)annee,
        substr(s.mfae_rdet,13,2) periode,t.mfal_reffae,sum(t.mfal_mttc) net_calc,s.mfae_solde net,sum(t.mfal_mttc)-s.mfae_solde diff,
        sum(decode(t.mfal_refart,'CAPITAL',t.mfal_mttc,'INTERET',t.mfal_mttc,0)) capit
         from miwtfactureligne t,miwtfactureentete s
         where t.mfal_reffae=s.mfae_ref
         group by t.mfal_reffae,s.mfae_solde,substr(s.mfae_rdet,1,2),substr(s.mfae_rdet,3,3),substr(s.mfae_rdet,6,3),substr(s.mfae_rdet,9,4),substr(s.mfae_rdet,13,2)
         having ((abs(sum(t.mfal_mttc)-s.mfae_solde) <>0)) ;
        commit;

         for c in (select t.*, t.rowid from xx t where diff = capit)
          loop
             delete miwtfactureligne s where s.mfal_source = 'DIST'||c.distirct and c.mfal_reffae=s.mfal_reffae
                                   And s.mfal_refart in('CAPITAL','INTERET');
              delete xx where c.distirct=distirct and c.mfal_reffae=mfal_reffae;
          end loop;
          commit;

            for c in (select t.*, t.rowid,diff-capit from xx t where capit <> 0 and diff-(diff-capit) =capit and (diff-capit) > 0.001)
            loop
            delete miwtfactureligne s where s.mfal_source = 'DIST'||c.distirct and c.mfal_reffae=s.mfal_reffae
                                   And s.mfal_refart in('CAPITAL','INTERET');
            end loop;
          commit;
       delete xx;
       insert into xx  select  substr(s.mfae_rdet,1,2) distirct,substr(s.mfae_rdet,3,3) tourne,substr(s.mfae_rdet,6,3) ordre ,substr(s.mfae_rdet,9,4)annee,
        substr(s.mfae_rdet,13,2) periode,t.mfal_reffae,sum(t.mfal_mttc) net_calc,s.mfae_solde net,sum(t.mfal_mttc)-s.mfae_solde diff,
        sum(decode(t.mfal_refart,'CAPITAL',t.mfal_mttc,'INTERET',t.mfal_mttc,0)) capit
         from miwtfactureligne t,miwtfactureentete s
         where t.mfal_reffae=s.mfae_ref
         group by t.mfal_reffae,s.mfae_solde,substr(s.mfae_rdet,1,2),substr(s.mfae_rdet,3,3),substr(s.mfae_rdet,6,3),substr(s.mfae_rdet,9,4),substr(s.mfae_rdet,13,2)
         having ((abs(sum(t.mfal_mttc)-s.mfae_solde) <>0)) ;
       commit;


for c in (select t.*, t.rowid from XX t WHERE diff >= 0.001)
   loop
   select count(*) into x from miwtfactureligne s where s.mfal_reffae=c.mfal_reffae and s.mfal_refart='NAROND'
                                                      And 'DIST'||c.distirct=s.mfal_source;
  if x = 0 then
       insert into miwtfactureligne
              (
                MFAL_SOURCE     ,--  VARCHAR2(100)  N      Code source/origine de la ligne [OBL]
                MFAL_REFFAE     ,--  VARCHAR2(100)  N      Identifiant de la facture de la ligne [OBL]
                MFAL_REFTAP     ,--  VARCHAR2(100)  N      Identifiant de la periode de tarif de la ligne [OBL]
                MFAL_REFART     ,--  VARCHAR2(100)  Y
                MFAL_LIBE       ,--  VARCHAR2(200)  Y
                MFAL_NUM        ,--  NUMBER(4)      N
                MFAL_TRAN       ,--  NUMBER(1)      N  1   Tranche de la ligne [OBL]
                MFAL_EXER       ,--  NUMBER(4)      N      Annee exercice de la ligne [OBL]
                MFAL_VOLU       ,--  NUMBER(15,3)   N      Volume facture de la ligne [OBL]
                MFAL_PU         ,--  NUMBER(12,6)   N      P.U. facture de la ligne [OBL]
                MFAL_MTHT       ,--  NUMBER(15,2)   N      Montant HT de la ligne [OBL]
                MFAL_MTVA       ,--  NUMBER(15,2)   N      Montant TVA de la ligne [OBL]
                MFAL_TTVA       ,--  NUMBER(15,2)   N      Taux de TVA de la ligne [OBL]
                MFAL_MTTC       ,--  NUMBER(15,2)   N
                MFAL_DDEBPERFAC ,--  DATE           Y      Date de debut de la periode facturee de la ligne
                MFAL_DFINPERFAC ,--  DATE           Y      Date de fin de la periode facturee de la ligne
                MFAL_DETAIL      --  NUMBER         Y
                )
                values
               (
               'DIST'||c.distirct,
                c.mfal_reffae    ,
                1                ,
                'NAROND'         ,
                'Arrondissement' ,
                18               ,
                1                ,
                c.annee          ,
                1                ,
                (-1)*(c.diff)    ,
                (-1)*(c.diff)    ,
                0                ,
                0                ,
                (-1)*(c.diff)    ,
                null             ,
                null             ,
                null
                );
             else
               update miwtfactureligne set MFAL_PU=MFAL_PU-c.diff,
                                           MFAL_MTHT=MFAL_MTHT-c.diff,
                                           MFAL_MTTC=MFAL_MTTC-c.diff
                                           where
                                           mfal_reffae=c.mfal_reffae and mfal_refart='NAROND'
                                            And 'DIST'||c.distirct=mfal_source;
    end if;


end loop;
   commit;

        delete xx;
       insert into xx  select  substr(s.mfae_rdet,1,2) distirct,substr(s.mfae_rdet,3,3) tourne,substr(s.mfae_rdet,6,3) ordre ,substr(s.mfae_rdet,9,4)annee,
        substr(s.mfae_rdet,13,2) periode,t.mfal_reffae,sum(t.mfal_mttc) net_calc,s.mfae_solde net,sum(t.mfal_mttc)-s.mfae_solde diff,
        sum(decode(t.mfal_refart,'CAPITAL',t.mfal_mttc,'INTERET',t.mfal_mttc,0)) capit
         from miwtfactureligne t,miwtfactureentete s
         where t.mfal_reffae=s.mfae_ref
         group by t.mfal_reffae,s.mfae_solde,substr(s.mfae_rdet,1,2),substr(s.mfae_rdet,3,3),substr(s.mfae_rdet,6,3),substr(s.mfae_rdet,9,4),substr(s.mfae_rdet,13,2)
         having ((abs(sum(t.mfal_mttc)-s.mfae_solde) <>0)) ;
       commit;
         delete  miwtfactureligne t where MFAL_REFFAE in (select MFAL_REFFAE from xx  where abs(diff)=abs(t.mfal_mttc)) and t.mfal_refart='NAROND';
          commit;
         delete xx;
       insert into xx  select  substr(s.mfae_rdet,1,2) distirct,substr(s.mfae_rdet,3,3) tourne,substr(s.mfae_rdet,6,3) ordre ,substr(s.mfae_rdet,9,4)annee,
        substr(s.mfae_rdet,13,2) periode,t.mfal_reffae,sum(t.mfal_mttc) net_calc,s.mfae_solde net,sum(t.mfal_mttc)-s.mfae_solde diff,
        sum(decode(t.mfal_refart,'CAPITAL',t.mfal_mttc,'INTERET',t.mfal_mttc,0)) capit
         from miwtfactureligne t,miwtfactureentete s
         where t.mfal_reffae=s.mfae_ref
         group by t.mfal_reffae,s.mfae_solde,substr(s.mfae_rdet,1,2),substr(s.mfae_rdet,3,3),substr(s.mfae_rdet,6,3),substr(s.mfae_rdet,9,4),substr(s.mfae_rdet,13,2)
         having ((abs(sum(t.mfal_mttc)-s.mfae_solde) <>0)) ;
         commit;
       -----
        for c in (select t.*, t.rowid,trunc(diff/capit) nbr ,capit*trunc(diff/capit) from xx t where capit <> 0)
         loop
          update miwtfactureligne  set MFAL_VOLU=MFAL_VOLU+(c.nbr*-1) where MFAL_REFART in ('INTERET','CAPITAL') and MFAL_REFFAE=c.mfal_reffae;
         end loop;
         update miwtfactureligne set MFAL_MTHT=MFAL_VOLU*mfal_pu,
                                  MFAL_MTTC=MFAL_VOLU*mfal_pu
                                  where MFAL_REFART in ('INTERET','CAPITAL');
            commit;
         delete xx;
       insert into xx  select  substr(s.mfae_rdet,1,2) distirct,substr(s.mfae_rdet,3,3) tourne,substr(s.mfae_rdet,6,3) ordre ,substr(s.mfae_rdet,9,4)annee,
        substr(s.mfae_rdet,13,2) periode,t.mfal_reffae,sum(t.mfal_mttc) net_calc,s.mfae_solde net,sum(t.mfal_mttc)-s.mfae_solde diff,
        sum(decode(t.mfal_refart,'CAPITAL',t.mfal_mttc,'INTERET',t.mfal_mttc,0)) capit
         from miwtfactureligne t,miwtfactureentete s
         where t.mfal_reffae=s.mfae_ref
         group by t.mfal_reffae,s.mfae_solde,substr(s.mfae_rdet,1,2),substr(s.mfae_rdet,3,3),substr(s.mfae_rdet,6,3),substr(s.mfae_rdet,9,4),substr(s.mfae_rdet,13,2)
         having ((abs(sum(t.mfal_mttc)-s.mfae_solde) <>0)) ;

insert into prob_migration (nom_table)values(SYSTIMESTAMP||'   END MIWT_FACTURE_AS400');
commit;

end;

----------
--********************************************
 procedure MIWT_FACTURE_AS400GC (v_district in varchar2) is
--********************************************
    err_code         varchar2(200);
    err_msg          varchar2(200);
    V_FAC_NUM        number;
    V_FAC_RESTANTDU  number;
    V_FAC_DATECALCUL date;
    V_FAC_DATELIM    date;
    V_FAC_ABN_NUM    number(20);
    v_ref_releve     number;
    V_TRAIN_FACT     varchar2(200);
    V_REF_ABN        varchar2(200);
    v_mrel_ref       varchar2(200);
    nbr_trt          number := 0;
    nbr_trt_rt       number := 0;
    x                number;
    v_ID_FACTURE     varchar2(20);
    annee_           number(4);
    periode_         number;
    version          number(1) := 0;
    date_            date;
  begin
execute immediate 'alter session set nls_date_format = ''dd/mm/yyyy''';
execute immediate 'alter session set NLS_NUMERIC_CHARACTERS = '',.''';
    --**************************************************
     delete prob_migration where
              nom_table in('miwtfacture-gc','SEQ_RELEVE','miwtfactureligne-gc');

  insert into prob_migration (nom_table)values(SYSTIMESTAMP||'   START MIWT_FACTURE_AS400GC');

    V_FAC_NUM        := 0;

    select max(to_number(MFAE_REF))  into V_FAC_NUM from miwtfactureentete WHERE MFAE_SOURCE= 'DIST'||v_district;
    select max(to_number(MREL_REF)) into v_ref_releve FROM miwtreleve where MREL_SOURCE = 'DIST'||v_district;
    COMMIT;

    for facture_ in (select * from facture_as400gc WHERE dist=v_district) loop
     V_FAC_NUM        := nvl(V_FAC_NUM,0) +1;
      --**************************************************
       select last_day(to_date('01'||lpad(facture_.refc01,2,'0')||facture_.refc02,'ddmmyy')) into date_
                              from dual;

      periode_ := facture_.refc01;
      annee_ :=to_char(date_,'yyyy');

      V_FAC_RESTANTDU  := null;
      V_FAC_DATECALCUL := null;
      V_FAC_ABN_NUM    := null;

       begin
          select to_date(lpad(ltrim(rtrim(DATEEXP)),8,'0'),'ddmmyyyy'),
                 to_date(lpad(ltrim(rtrim(DATL)),8,'0'),'ddmmyyyy')    into
                 V_FAC_DATECALCUL,V_FAC_DATELIM from role_mens
                     where to_number(facture_.pol)=POLICE
                     AND fACTURE_.Dist = ltrim(rtrim(DISTR))
                     And facture_.refc01 = ltrim(rtrim(MOIS))
                     AND rownum = 1;
            exception
          when others then
            err_code := SQLCODE;
            err_msg  := SUBSTR(SQLERRM, 1, 200);
            insert into prob_migration
              (nom_table, val_ref, sql_err,date_pro,type_problem )
            values
              ('miwtfacture-gc','Date facture pol '||facture_.pol||'M1 :'||facture_.refc01||'M2 :'||facture_.refc02,
                 err_msg ||'-- periode-',sysdate,'ce pas anomalie :erreur recuperation de date a partire la table role_mens');

      end;
    if V_FAC_DATECALCUL is null then
         BEGIN
             select (r.mrel_date+1) INTO  V_FAC_DATECALCUL from  miwtreleve_gc r
                 where r.mrel_refpdl =
                  lpad(facture_.DIST,2,'0')||
                  lpad(facture_.tou,3,'0')||
                  lpad(facture_.ORD,3,'0')||
                  lpad(facture_.POL,5,'0')
                  And mrel_refpdl is not null
                  and   r.annee = annee_
                  and   r.periode = periode_
                  And rownum=1;
        Exception  when others then
                 begin
                   select (r.mrel_date+1) INTO  V_FAC_DATECALCUL from  miwtreleve_gc_1 r
                   where r.mrel_refpdl =
                    lpad(facture_.DIST,2,'0')||
                    lpad(facture_.tou,3,'0')||
                    lpad(facture_.ORD,3,'0')||
                    lpad(facture_.POL,5,'0')
                    And mrel_refpdl is not null
                    and   r.annee = annee_
                    and   r.periode = periode_
                    And rownum=1;
                      Exception  when others then
                         V_FAC_DATECALCUL := date_;
                         V_FAC_DATELIM :=date_;
                         end;
         end;

       end if;
        -- reception de l'identfiant de l'abonnement
        V_REF_ABN := ltrim(rtrim(facture_.DIST)) ||
                     lpad(to_char(facture_.pol),5,'0') ||
                     lpad(ltrim(rtrim(facture_.tou)),3,'0') ||
                     lpad(ltrim(rtrim(facture_.ORD)),3,'0');
      V_TRAIN_FACT :=  'ANNEE:'||ltrim(rtrim(annee_)) ||
                         ' MOIS:'||ltrim(rtrim(periode_));
        v_ID_FACTURE:=ltrim(rtrim(facture_.DIST)) ||
                    lpad(ltrim(rtrim(facture_.tou)),3,'0') ||
                     lpad(ltrim(rtrim(facture_.ORD)),3,'0')||
                     to_char(annee_) ||
                     lpad(to_char(periode_),2,0)||to_char(version);

         select count(*) into nbr_trt from miwtfactureentete where MFAE_RDET = v_ID_FACTURE
                                                               And MFAE_SOURCE = 'DIST'||v_district;
         if nbr_trt=1 then goto xx;  end if;
        for ref_abn_ in (select *
                           from miwabn a
                          where substr(a.abn_refsite,1,13) = lpad(facture_.dist,2,'0') ||
                        lpad(facture_.tou,3,'0') ||
                        lpad(facture_.ord,3,'0') ||
                        lpad(to_char(facture_.pol),5,'0')) loop
          V_FAC_ABN_NUM := ref_abn_.abn_ref;
        end loop;
        if V_FAC_ABN_NUM  is null then V_FAC_ABN_NUM := lpad(facture_.dist,2,'0') ||
                        lpad(facture_.tou,3,'0') ||
                        lpad(facture_.ord,3,'0') ||
                        lpad(facture_.pol,5,'0');
         end if;

      v_mrel_ref:=null;
     begin
         select r.mrel_ref into v_mrel_ref
         from miwtreleve_gc_1 r
         where substr(r.mrel_refpdl,1,8)=substr(v_ID_FACTURE,1,8)
         and TO_CHAR(r.annee)=substr(v_ID_FACTURE,9,4)
         and lpad(TO_CHAR(r.periode),2,'0')=substr(v_ID_FACTURE,13,2);
      exception when others then
           begin
               select t.mrel_ref into v_mrel_ref
               from miwtreleve_gc t
               where substr(t.mrel_refpdl,1,8)=substr(v_ID_FACTURE,1,8)
               and TO_CHAR(t.annee)=substr(v_ID_FACTURE,9,4)
               and lpad(TO_CHAR(t.periode),2,'0')=substr(v_ID_FACTURE,13,2);
          exception when others then
                    v_mrel_ref:=null;
          end ;
      end;

        -- Insertion de la facture
        begin
        insert into miwtfactureentete
        (
        MFAE_SOURCE            ,--1  VARCHAR2(100)  N      Code source/origine de la facture [OBL]
        MFAE_REF               ,--2  VARCHAR2(100)  N      Identifiant unique de la facture pour la source [OBL]
        MFAE_REFTRF            ,--3  VARCHAR2(100)  Y      Identifiant du train de la facture
        MFAE_NUME              ,--4  NUMBER(10)     Y      Numero de la facture [OBL]
        MFAE_RDET              ,--5  VARCHAR2(15)   Y      RDET de la facture
        MFAE_CCMO              ,--6  VARCHAR2(1)    Y      Cle controle RDET de la facture
        MFAE_DEDI              ,--7  DATE           N      Date d edition de la facture [OBL]
        MFAE_DLPAI             ,--8  DATE           Y      Date limite de paiement de la facture [OBL]
        MFAE_DPREL             ,--9  DATE           Y      Date de prelevement de la facture [OBL]
        MFAE_TOTHTE            ,--10 NUMBER(10,2)   N      Total HT EAU de la facture [OBL]
        MFAE_TOTTVAE           ,--11 NUMBER(10,2)   N      Total TVA EAU de la facture [OBL]
        MFAE_TOTHTA            ,--12 NUMBER(10,2)   N      Total HT ASS de la facture [OBL]
        MFAE_TOTTVAA           ,--13 NUMBER(10,2)   N      Total TVA ASS de la facture [OBL]
        MFAE_SOLDE             ,--14 NUMBER(10,2)   Y      Solde TTC de la facture
        MFAE_TYPE              ,--15 VARCHAR2(2)    N  'R'
        MFAE_REFFAEDEDU        ,--16 VARCHAR2(100)  Y
        MFAE_REFABN            ,--17 VARCHAR2(100)  N      Identifiant du contrat de la facture [OBL]
        MFAE_REF_CODNIV_RELANCE,--18 VARCHAR2(100)  Y      Reference Code niveau de chainde relance
        MFAE_RIB_REF           ,--19 VARCHAR2(100)  Y      Reference Rib
        MFAE_RIB_ETAT          ,--20 NUMBER(1)      Y      Mode de payement (pr?l?vement 1 ou tip 2)
        MFAE_COMPTEAUX         ,--21 VARCHAR2(100)  Y      Compte auxilaire GENACCOUNT associe a la facture
        MFAE_REF_ORIGINE       ,--22 VARCHAR2(100)  Y      Facture origine
        MFAE_COMMENT           ,--23 VARCHAR2(4000) Y      Commentaire libre Facture
        MFAE_AMOUNTTTCDEC      ,--24 NUMBER(17,10)  Y      Montant TTC a deduire
        VOC_MODEFACT           ,--25 VARCHAR2(10)   Y
        MFAE_REF_DEDUC         ,--26 VARCHAR2(100)  Y
        MFAE_REFORGA           ,--27 VARCHAR2(100)  Y
        MFAE_EXERCICE          ,--28 NUMBER(4)      Y      Exercice du role de la facture
        MFAE_NUMEROROLE        ,--29 NUMBER(4)      Y      Numero du role pour l exercice
        MFAE_PREL              ,--30 NUMBER         Y
        MREL_REF                --31
        )
       values
       (
        'DIST'||v_district,--1
        V_FAC_NUM         ,--2
        V_TRAIN_FACT      ,--3
        V_FAC_NUM         ,--4
        v_ID_FACTURE      ,--5
        NULL              ,--6
        V_FAC_DATECALCUL  ,--7
        V_FAC_DATELIM     ,--8
        V_FAC_DATECALCUL  ,--9
        (facture_.monttrim-(facture_.tva+facture_.taxe))/1000,--10
        (facture_.tva+facture_.taxe)/1000,--11
        0                 ,--12
        0                 ,--13
        facture_.monttrim/1000,--14
        'FC'              ,--15
        NULL              ,--16
        V_FAC_ABN_NUM     ,--17
        'INCONNUE'        ,--18
         null             ,--19
        4                 ,--20
        'IMP_MIG'         ,--21
        null              ,--22
        V_REF_ABN         ,--23
        NULL              ,--24
        4                 ,--25
        NULL              ,--26
        v_district        ,--27
        annee_            ,--28
        periode_          ,--29
        1                 ,--30
        v_mrel_ref         --31
        );
        exception
          when others then
            err_code := SQLCODE;
            err_msg  := SUBSTR(SQLERRM, 1, 200);
            insert into prob_migration
              (nom_table, val_ref, sql_err, date_pro,type_problem)
            values
              ('miwtfacture-gc',
               lpad(facture_.dist,2,'0') ||
               lpad(facture_.tou,3,'0') ||
               lpad(facture_.ord,3,'0') ||
               lpad(facture_.pol,5,'0'),
               err_code || '--' || err_msg,
               sysdate,'erreur de confomité de type colonne'
               );
        end;
-------------------------------------------------------------------------------
--------------------------------------------------- LIGNE FACTURE CONSOMMATION SONNEDE
if to_number(facture_.montt1) <> 0 then
         begin
         insert into miwtfactureligne
             (
                MFAL_SOURCE    ,--  VARCHAR2(100)  N      Code source/origine de la ligne [OBL]
                MFAL_REFFAE    ,--  VARCHAR2(100)  N      Identifiant de la facture de la ligne [OBL]
                MFAL_REFTAP    ,--  VARCHAR2(100)  N      Identifiant de la periode de tarif de la ligne [OBL]
                MFAL_REFART    ,--  VARCHAR2(100)  Y
                MFAL_LIBE      ,--  VARCHAR2(200)  Y
                MFAL_NUM       ,--  NUMBER(4)      N
                MFAL_TRAN      ,--  NUMBER(1)      N  1   Tranche de la ligne [OBL]
                MFAL_EXER      ,--  NUMBER(4)      N      Annee exercice de la ligne [OBL]
                MFAL_VOLU      ,--  NUMBER(15,3)   N      Volume facture de la ligne [OBL]
                MFAL_PU        ,--  NUMBER(12,6)   N      P.U. facture de la ligne [OBL]
                MFAL_MTHT      ,--  NUMBER(15,2)   N      Montant HT de la ligne [OBL]
                MFAL_MTVA      ,--  NUMBER(15,2)   N      Montant TVA de la ligne [OBL]
                MFAL_TTVA      ,--  NUMBER(15,2)   N      Taux de TVA de la ligne [OBL]
                MFAL_MTTC      ,--  NUMBER(15,2)   N
                MFAL_DDEBPERFAC,--  DATE           Y      Date de debut de la periode facturee de la ligne
                MFAL_DFINPERFAC,--  DATE           Y      Date de fin de la periode facturee de la ligne
                MFAL_DETAIL     --  NUMBER         Y
                )
                values
               (
               'DIST'||v_district,
                V_FAC_NUM        ,
                1                ,
                'CSM_STD'        ,
                'consommation sonede 1ere Tranche',
                1                ,
                1                ,
                annee_           ,
                facture_.const1  ,
                facture_.tauxt1/1000,
                facture_.montt1/1000,
                facture_.taxe/1000,
                18                ,
                facture_.montt1/1000+(facture_.taxe/1000),
                null              ,
                DATE_             ,
                null
                );
           exception
          when others then
            err_code := SQLCODE;
            err_msg  := SUBSTR(SQLERRM, 1, 200);
            insert into prob_migration
              (nom_table, val_ref, sql_err, date_pro,type_problem)
            values
              ('miwtfactureligne-gc',
               V_FAC_NUM,
               err_code || '--' || err_msg,
               sysdate,
               'erreur de confomité de type colonne');
        end;
end if;

if to_number(facture_.montt2) <> 0 then
         begin
         insert into miwtfactureligne
               (
                MFAL_SOURCE     ,--  VARCHAR2(100)  N  Code source/origine de la ligne [OBL]
                MFAL_REFFAE     ,--  VARCHAR2(100)  N  Identifiant de la facture de la ligne [OBL]
                MFAL_REFTAP     ,--  VARCHAR2(100)  N  Identifiant de la periode de tarif de la ligne [OBL]
                MFAL_REFART     ,--  VARCHAR2(100)  Y
                MFAL_LIBE       ,--  VARCHAR2(200)  Y
                MFAL_NUM        ,--  NUMBER(4)      N
                MFAL_TRAN       ,--  NUMBER(1)      N 1 Tranche de la ligne [OBL]
                MFAL_EXER       ,--  NUMBER(4)      N   Annee exercice de la ligne [OBL]
                MFAL_VOLU       ,--  NUMBER(15,3)   N   Volume facture de la ligne [OBL]
                MFAL_PU         ,--  NUMBER(12,6)   N   P.U. facture de la ligne [OBL]
                MFAL_MTHT       ,--  NUMBER(15,2)   N   Montant HT de la ligne [OBL]
                MFAL_MTVA       ,--  NUMBER(15,2)   N   Montant TVA de la ligne [OBL]
                MFAL_TTVA       ,--  NUMBER(15,2)   N   Taux de TVA de la ligne [OBL]
                MFAL_MTTC       ,--  NUMBER(15,2)   N
                MFAL_DDEBPERFAC ,--  DATE           Y   Date de debut de la periode facturee de la ligne
                MFAL_DFINPERFAC ,--  DATE           Y   Date de fin de la periode facturee de la ligne
                MFAL_DETAIL      --  NUMBER         Y
                )
                values
               (
               'DIST'||v_district,
                V_FAC_NUM        ,
                1                ,
                'CSM_STD'        ,
                'consommation sonede 2eme Tranche',
                2                ,
                2                ,
                annee_           ,
                facture_.const2  ,
                facture_.tauxt2/1000,
                facture_.montt2/1000,
                facture_.taxe/1000,
                18               ,
                facture_.montt2/1000+(facture_.taxe/1000),
                null             ,
                DATE_            ,
                null
                );
           exception
          when others then
            err_code := SQLCODE;
            err_msg  := SUBSTR(SQLERRM, 1, 200);
            insert into prob_migration
              (nom_table, val_ref, sql_err, date_pro,type_problem)
            values
              ('miwtfactureligne-gc',
               V_FAC_NUM,
               err_code || '--' || err_msg,
               sysdate,
               'erreur de confomité de type colonne');
        end;
end if;

if to_number(facture_.montt3) <> 0 then
         begin
         insert into miwtfactureligne
             (
                MFAL_SOURCE    ,--  VARCHAR2(100)  N  Code source/origine de la ligne [OBL]
                MFAL_REFFAE    ,--  VARCHAR2(100)  N  Identifiant de la facture de la ligne [OBL]
                MFAL_REFTAP    ,--  VARCHAR2(100)  N  Identifiant de la periode de tarif de la ligne [OBL]
                MFAL_REFART    ,--  VARCHAR2(100)  Y
                MFAL_LIBE      ,--  VARCHAR2(200)  Y
                MFAL_NUM       ,--  NUMBER(4)      N
                MFAL_TRAN      ,--  NUMBER(1)      N 1 Tranche de la ligne [OBL]
                MFAL_EXER      ,--  NUMBER(4)      N   Annee exercice de la ligne [OBL]
                MFAL_VOLU      ,--  NUMBER(15,3)   N   Volume facture de la ligne [OBL]
                MFAL_PU        ,--  NUMBER(12,6)   N   P.U. facture de la ligne [OBL]
                MFAL_MTHT      ,--  NUMBER(15,2)   N   Montant HT de la ligne [OBL]
                MFAL_MTVA      ,--  NUMBER(15,2)   N   Montant TVA de la ligne [OBL]
                MFAL_TTVA      ,--  NUMBER(15,2)   N   Taux de TVA de la ligne [OBL]
                MFAL_MTTC      ,--  NUMBER(15,2)   N
                MFAL_DDEBPERFAC,--  DATE           Y   Date de debut de la periode facturee de la ligne
                MFAL_DFINPERFAC,--  DATE           Y   Date de fin de la periode facturee de la ligne
                MFAL_DETAIL     --  NUMBER         Y
                )
                values
               (
               'DIST'||v_district,
                V_FAC_NUM        ,
                1                ,
                'CSM_STD'        ,
                'consommation sonede 3eme Tranche',
                3                ,
                3                ,
                annee_           ,
                facture_.const3  ,
                facture_.tauxt3/1000,
                facture_.montt3/1000,
                facture_.taxe/1000,
                18               ,
                facture_.montt3/1000+(facture_.taxe/1000),
                null             ,
                DATE_            ,
                null
                );
           exception
          when others then
            err_code := SQLCODE;
            err_msg  := SUBSTR(SQLERRM, 1, 200);
            insert into prob_migration
              (nom_table, val_ref, sql_err, date_pro,type_problem)
            values
              ('miwtfactureligne-gc',
               V_FAC_NUM,
               err_code || '--' || err_msg,
               sysdate,
               'erreur de confomité de type colonne');
        end;
end if;

    --------------------------------------------------- LIGNE FACTURE CONSOMMATION ONAS
if to_number(facture_.mon1) <> 0 then
         begin
         insert into miwtfactureligne
              (
                MFAL_SOURCE    ,--  VARCHAR2(100)  N   Code source/origine de la ligne [OBL]
                MFAL_REFFAE    ,--  VARCHAR2(100)  N   Identifiant de la facture de la ligne [OBL]
                MFAL_REFTAP    ,--  VARCHAR2(100)  N   Identifiant de la periode de tarif de la ligne [OBL]
                MFAL_REFART    ,--  VARCHAR2(100)  Y
                MFAL_LIBE      ,--  VARCHAR2(200)  Y
                MFAL_NUM       ,--  NUMBER(4)      N
                MFAL_TRAN      ,--  NUMBER(1)      N 1  Tranche de la ligne [OBL]
                MFAL_EXER      ,--  NUMBER(4)      N    Annee exercice de la ligne [OBL]
                MFAL_VOLU      ,--  NUMBER(15,3)   N    Volume facture de la ligne [OBL]
                MFAL_PU        ,--  NUMBER(12,6)   N    P.U. facture de la ligne [OBL]
                MFAL_MTHT      ,--  NUMBER(15,2)   N    Montant HT de la ligne [OBL]
                MFAL_MTVA      ,--  NUMBER(15,2)   N    Montant TVA de la ligne [OBL]
                MFAL_TTVA      ,--  NUMBER(15,2)   N    Taux de TVA de la ligne [OBL]
                MFAL_MTTC      ,--  NUMBER(15,2)   N
                MFAL_DDEBPERFAC,--  DATE           Y    Date de debut de la periode facturee de la ligne
                MFAL_DFINPERFAC,--  DATE           Y    Date de fin de la periode facturee de la ligne
                MFAL_DETAIL     --  NUMBER         Y
                )
                values
               (
               'DIST'||v_district,
                V_FAC_NUM        ,
                2                ,
                'VAR_ONAS_1'     ,
                'Redevance onas 1ere Tranche',
                4                ,
                1                ,
                annee_           ,
                facture_.volon1  ,
                facture_.tauon1/1000,
                facture_.mon1/1000,
                0                ,
                0                ,
                facture_.mon1/1000,
                null             ,
                DATE_            ,
                null
                );
           exception
          when others then
            err_code := SQLCODE;
            err_msg  := SUBSTR(SQLERRM, 1, 200);
            insert into prob_migration
              (nom_table, val_ref, sql_err, date_pro,type_problem)
            values
              ('miwtfactureligne-gc',
               V_FAC_NUM,
               err_code || '--' || err_msg,
               sysdate,
               'erreur de confomité de type colonne');
        end;
end if;

if to_number(facture_.mon2) <> 0 then
         begin
         insert into miwtfactureligne
              (
                MFAL_SOURCE    ,--  VARCHAR2(100)  N  Code source/origine de la ligne [OBL]
                MFAL_REFFAE    ,--  VARCHAR2(100)  N  Identifiant de la facture de la ligne [OBL]
                MFAL_REFTAP    ,--  VARCHAR2(100)  N  Identifiant de la periode de tarif de la ligne [OBL]
                MFAL_REFART    ,--  VARCHAR2(100)  Y
                MFAL_LIBE      ,--  VARCHAR2(200)  Y
                MFAL_NUM       ,--  NUMBER(4)      N
                MFAL_TRAN      ,--  NUMBER(1)      N 1 Tranche de la ligne [OBL]
                MFAL_EXER      ,--  NUMBER(4)      N   Annee exercice de la ligne [OBL]
                MFAL_VOLU      ,--  NUMBER(15,3)   N   Volume facture de la ligne [OBL]
                MFAL_PU        ,--  NUMBER(12,6)   N   P.U. facture de la ligne [OBL]
                MFAL_MTHT      ,--  NUMBER(15,2)   N   Montant HT de la ligne [OBL]
                MFAL_MTVA      ,--  NUMBER(15,2)   N   Montant TVA de la ligne [OBL]
                MFAL_TTVA      ,--  NUMBER(15,2)   N   Taux de TVA de la ligne [OBL]
                MFAL_MTTC      ,--  NUMBER(15,2)   N
                MFAL_DDEBPERFAC,--  DATE           Y   Date de debut de la periode facturee de la ligne
                MFAL_DFINPERFAC,--  DATE           Y   Date de fin de la periode facturee de la ligne
                MFAL_DETAIL     --  NUMBER         Y
                )
                values
               (
               'DIST'||v_district,
                V_FAC_NUM        ,
                2                ,
                'VAR_ONAS_1'     ,
                'Redevance onas 2eme Tranche',
                5                ,
                2                ,
                annee_           ,
                facture_.volon2  ,
                facture_.tauon2/1000,
                facture_.mon2/1000,
                0                ,
                0                ,
                facture_.mon2/1000,
                null             ,
                DATE_            ,
                null
                );
           exception
          when others then
            err_code := SQLCODE;
            err_msg  := SUBSTR(SQLERRM, 1, 200);
            insert into prob_migration
              (nom_table, val_ref, sql_err, date_pro,type_problem)
            values
              ('miwtfactureligne-gc',
               V_FAC_NUM,
               err_code || '--' || err_msg,
               sysdate,
               'erreur de confomité de type colonne');
        end;
end if;

if to_number(facture_.mon3) <> 0 then
         begin
         insert into miwtfactureligne
            (
                MFAL_SOURCE     ,--  VARCHAR2(100) N   Code source/origine de la ligne [OBL]
                MFAL_REFFAE     ,--  VARCHAR2(100) N   Identifiant de la facture de la ligne [OBL]
                MFAL_REFTAP     ,--  VARCHAR2(100) N   Identifiant de la periode de tarif de la ligne [OBL]
                MFAL_REFART     ,--  VARCHAR2(100) Y
                MFAL_LIBE       ,--  VARCHAR2(200) Y
                MFAL_NUM        ,--  NUMBER(4)     N
                MFAL_TRAN       ,--  NUMBER(1)     N  1 Tranche de la ligne [OBL]
                MFAL_EXER       ,--  NUMBER(4)     N   Annee exercice de la ligne [OBL]
                MFAL_VOLU       ,--  NUMBER(15,3)  N   Volume facture de la ligne [OBL]
                MFAL_PU         ,--  NUMBER(12,6)  N   P.U. facture de la ligne [OBL]
                MFAL_MTHT       ,--  NUMBER(15,2)  N   Montant HT de la ligne [OBL]
                MFAL_MTVA       ,--  NUMBER(15,2)  N   Montant TVA de la ligne [OBL]
                MFAL_TTVA       ,--  NUMBER(15,2)  N   Taux de TVA de la ligne [OBL]
                MFAL_MTTC       ,--  NUMBER(15,2)  N
                MFAL_DDEBPERFAC ,--  DATE          Y   Date de debut de la periode facturee de la ligne
                MFAL_DFINPERFAC ,--  DATE          Y   Date de fin de la periode facturee de la ligne
                MFAL_DETAIL      --  NUMBER        Y
                )
                values
               (
               'DIST'||v_district,
                V_FAC_NUM        ,
                2                ,
                'VAR_ONAS_1'     ,
                'Redevance onas 3eme Tranche',
                6                ,
                3                ,
                annee_           ,
                facture_.volon3  ,
                facture_.tauon3/1000,
                facture_.mon3/1000,
                0                ,
                0                ,
                facture_.mon3/1000,
                null             ,
                DATE_            ,
                null
                );
           exception
          when others then
            err_code := SQLCODE;
            err_msg  := SUBSTR(SQLERRM, 1, 200);
            insert into prob_migration
              (nom_table, val_ref, sql_err, date_pro,type_problem)
            values
              ('miwtfactureligne-gc',
               V_FAC_NUM,
               err_code || '--' || err_msg,
               sysdate,
               'erreur de confomité de type colonne');
        end;
end if;

if to_number(facture_.fixonas) <> 0 then
         begin
         insert into miwtfactureligne
              (
                MFAL_SOURCE,--  VARCHAR2(100) N    Code source/origine de la ligne [OBL]
                MFAL_REFFAE,--  VARCHAR2(100) N    Identifiant de la facture de la ligne [OBL]
                MFAL_REFTAP,--  VARCHAR2(100) N    Identifiant de la periode de tarif de la ligne [OBL]
                MFAL_REFART,--  VARCHAR2(100) Y
                MFAL_LIBE  ,--  VARCHAR2(200) Y
                MFAL_NUM   ,--  NUMBER(4)     N
                MFAL_TRAN  ,--  NUMBER(1)     N  1 Tranche de la ligne [OBL]
                MFAL_EXER  ,--  NUMBER(4)     N    Annee exercice de la ligne [OBL]
                MFAL_VOLU  ,--  NUMBER(15,3)  N    Volume facture de la ligne [OBL]
                MFAL_PU    ,--  NUMBER(12,6)  N    P.U. facture de la ligne [OBL]
                MFAL_MTHT  ,--  NUMBER(15,2)  N    Montant HT de la ligne [OBL]
                MFAL_MTVA  ,--  NUMBER(15,2)  N    Montant TVA de la ligne [OBL]
                MFAL_TTVA  ,--  NUMBER(15,2)  N    Taux de TVA de la ligne [OBL]
                MFAL_MTTC  ,--  NUMBER(15,2)  N
                MFAL_DDEBPERFAC,--  DATE  Y      Date de debut de la periode facturee de la ligne
                MFAL_DFINPERFAC,--  DATE  Y      Date de fin de la periode facturee de la ligne
                MFAL_DETAIL --  NUMBER  Y
                )
                values
               (
               'DIST'||v_district,
                V_FAC_NUM        ,
                2                ,
                'FIXE_ONAS_1'    ,
                'Frais fixe onas',
                7                ,
                1                ,
                annee_           ,
                1                ,
                facture_.fixonas/1000,
                facture_.fixonas/1000,
                0                ,
                0                ,
                facture_.fixonas/1000,
                null             ,
                DATE_            ,
                null
                );
           exception
          when others then
            err_code := SQLCODE;
            err_msg  := SUBSTR(SQLERRM, 1, 200);
            insert into prob_migration
              (nom_table, val_ref, sql_err, date_pro,type_problem)
            values
              ('miwtfactureligne-gc',
               V_FAC_NUM,
               err_code || '--' || err_msg,
               sysdate,
               'erreur de confomité de type colonne');
        end;
end if;

if to_number(facture_.FRLETTRE) <> 0 then
         begin
         insert into miwtfactureligne
              (
                MFAL_SOURCE,--  VARCHAR2(100) N    Code source/origine de la ligne [OBL]
                MFAL_REFFAE,--  VARCHAR2(100) N    Identifiant de la facture de la ligne [OBL]
                MFAL_REFTAP,--  VARCHAR2(100) N    Identifiant de la periode de tarif de la ligne [OBL]
                MFAL_REFART,--  VARCHAR2(100) Y
                MFAL_LIBE  ,--  VARCHAR2(200) Y
                MFAL_NUM   ,--  NUMBER(4)     N
                MFAL_TRAN  ,--  NUMBER(1)     N  1 Tranche de la ligne [OBL]
                MFAL_EXER  ,--  NUMBER(4)     N    Annee exercice de la ligne [OBL]
                MFAL_VOLU  ,--  NUMBER(15,3)  N    Volume facture de la ligne [OBL]
                MFAL_PU    ,--  NUMBER(12,6)  N    P.U. facture de la ligne [OBL]
                MFAL_MTHT  ,--  NUMBER(15,2)  N    Montant HT de la ligne [OBL]
                MFAL_MTVA  ,--  NUMBER(15,2)  N    Montant TVA de la ligne [OBL]
                MFAL_TTVA  ,--  NUMBER(15,2)  N    Taux de TVA de la ligne [OBL]
                MFAL_MTTC  ,--  NUMBER(15,2)  N
                MFAL_DDEBPERFAC,--  DATE  Y      Date de debut de la periode facturee de la ligne
                MFAL_DFINPERFAC,--  DATE  Y      Date de fin de la periode facturee de la ligne
                MFAL_DETAIL--  NUMBER  Y
                )
                values
               (
               'DIST'||v_district,
                V_FAC_NUM        ,
                1                ,
                'FRAIS_FRM_DEP'  ,
                'Frais lettre '  ,
                8                ,
                1                ,
                annee_           ,
                1                ,
                1.900            ,
                1.900            ,
                0                ,
                0                ,
                1.900            ,
                null             ,
                DATE_            ,
                null
               );
           exception
          when others then
            err_code := SQLCODE;
            err_msg  := SUBSTR(SQLERRM, 1, 200);
            insert into prob_migration
              (nom_table, val_ref, sql_err, date_pro,type_problem)
            values
              ('miwtfactureligne-gc',
               V_FAC_NUM,
               err_code || '--' || err_msg,
               sysdate,
               'erreur de confomité de type colonne');
        end;
end if;

if to_number(facture_.fraisctr) <> 0 then
         begin
         insert into miwtfactureligne
              (
                MFAL_SOURCE,--  VARCHAR2(100) N     Code source/origine de la ligne [OBL]
                MFAL_REFFAE,--  VARCHAR2(100) N     Identifiant de la facture de la ligne [OBL]
                MFAL_REFTAP,--  VARCHAR2(100) N     Identifiant de la periode de tarif de la ligne [OBL]
                MFAL_REFART,--  VARCHAR2(100) Y
                MFAL_LIBE  ,--  VARCHAR2(200) Y
                MFAL_NUM   ,--  NUMBER(4)     N
                MFAL_TRAN  ,--  NUMBER(1)     N  1  Tranche de la ligne [OBL]
                MFAL_EXER  ,--  NUMBER(4)     N     Annee exercice de la ligne [OBL]
                MFAL_VOLU  ,--  NUMBER(15,3)  N     Volume facture de la ligne [OBL]
                MFAL_PU    ,--  NUMBER(12,6)  N     P.U. facture de la ligne [OBL]
                MFAL_MTHT  ,--  NUMBER(15,2)  N     Montant HT de la ligne [OBL]
                MFAL_MTVA  ,--  NUMBER(15,2)  N     Montant TVA de la ligne [OBL]
                MFAL_TTVA  ,--  NUMBER(15,2)  N     Taux de TVA de la ligne [OBL]
                MFAL_MTTC  ,--  NUMBER(15,2)  N
                MFAL_DDEBPERFAC,--  DATE  Y      Date de debut de la periode facturee de la ligne
                MFAL_DFINPERFAC,--  DATE  Y      Date de fin de la periode facturee de la ligne
                MFAL_DETAIL--  NUMBER  Y
                )
                values
               (
               'DIST'||v_district,
                V_FAC_NUM        ,
                1                ,
                'FRS_FIX_CSM'    ,
                'Frais fixe sonnede',
                9                ,
                1                ,
                annee_           ,
                1                ,
                facture_.fraisctr/1000,
                facture_.fraisctr/1000,
                facture_.TVA/1000,
                18               ,
                facture_.fraisctr/1000+(facture_.TVA/1000),
                null             ,
                DATE_            ,
                null
                );
           exception
          when others then
            err_code := SQLCODE;
            err_msg  := SUBSTR(SQLERRM, 1, 200);
            insert into prob_migration
              (nom_table, val_ref, sql_err, date_pro,type_problem)
            values
              ('miwtfactureligne-gc',
               V_FAC_NUM,
               err_code || '--' || err_msg,
               sysdate,
               'erreur de confomité de type colonne');
        end;
end if;

if to_number(facture_.FRferm) <> 0 then
         begin
         insert into miwtfactureligne
               (
                MFAL_SOURCE,--  VARCHAR2(100) N    Code source/origine de la ligne [OBL]
                MFAL_REFFAE,--  VARCHAR2(100) N   Identifiant de la facture de la ligne [OBL]
                MFAL_REFTAP,--  VARCHAR2(100) N   Identifiant de la periode de tarif de la ligne [OBL]
                MFAL_REFART,--  VARCHAR2(100) Y
                MFAL_LIBE  ,--  VARCHAR2(200) Y
                MFAL_NUM   ,--  NUMBER(4)     N
                MFAL_TRAN  ,--  NUMBER(1)     N  1    Tranche de la ligne [OBL]
                MFAL_EXER  ,--  NUMBER(4)     N  Annee exercice de la ligne [OBL]
                MFAL_VOLU  ,--  NUMBER(15,3)  N  Volume facture de la ligne [OBL]
                MFAL_PU    ,--  NUMBER(12,6)  N  P.U. facture de la ligne [OBL]
                MFAL_MTHT  ,--  NUMBER(15,2)  N  Montant HT de la ligne [OBL]
                MFAL_MTVA  ,--  NUMBER(15,2)  N  Montant TVA de la ligne [OBL]
                MFAL_TTVA  ,--  NUMBER(15,2)  N  Taux de TVA de la ligne [OBL]
                MFAL_MTTC  ,--  NUMBER(15,2)  N
                MFAL_DDEBPERFAC,--  DATE  Y      Date de debut de la periode facturee de la ligne
                MFAL_DFINPERFAC,--  DATE  Y      Date de fin de la periode facturee de la ligne
                MFAL_DETAIL--  NUMBER  Y
                )
                values
               (
               'DIST'||v_district,
                V_FAC_NUM        ,
                1                ,
                'FRAIS-FERM'     ,
                'Frais FERMETURE',
                10               ,
                1                ,
                annee_           ,
                1                ,
                facture_.FRFERM/1000,
                facture_.FRFERM/1000,
                0                ,
                0                ,
                facture_.FRFERM/1000,
                null             ,
                DATE_            ,
                null
                );
           exception
          when others then
            err_code := SQLCODE;
            err_msg  := SUBSTR(SQLERRM, 1, 200);
            insert into prob_migration
              (nom_table, val_ref, sql_err, date_pro,type_problem)
            values
              ('miwtfactureligne-gc',
               V_FAC_NUM,
               err_code || '--' || err_msg,
               sysdate,'erreur de confomité de type colonne');
        end;
end if;

if to_number(facture_.CAPIT) <> 0 then
         begin
         insert into miwtfactureligne
              (
                MFAL_SOURCE,--  VARCHAR2(100) N      Code source/origine de la ligne [OBL]
                MFAL_REFFAE,--  VARCHAR2(100) N      Identifiant de la facture de la ligne [OBL]
                MFAL_REFTAP,--  VARCHAR2(100) N      Identifiant de la periode de tarif de la ligne [OBL]
                MFAL_REFART,--  VARCHAR2(100) Y
                MFAL_LIBE  ,--  VARCHAR2(200) Y
                MFAL_NUM   ,--  NUMBER(4)     N
                MFAL_TRAN  ,--  NUMBER(1)     N  1    Tranche de la ligne [OBL]
                MFAL_EXER  ,--  NUMBER(4)     N      Annee exercice de la ligne [OBL]
                MFAL_VOLU  ,--  NUMBER(15,3)  N      Volume facture de la ligne [OBL]
                MFAL_PU    ,--  NUMBER(12,6)  N      P.U. facture de la ligne [OBL]
                MFAL_MTHT  ,--  NUMBER(15,2)  N      Montant HT de la ligne [OBL]
                MFAL_MTVA  ,--  NUMBER(15,2)  N      Montant TVA de la ligne [OBL]
                MFAL_TTVA  ,--  NUMBER(15,2)  N      Taux de TVA de la ligne [OBL]
                MFAL_MTTC  ,--  NUMBER(15,2)  N
                MFAL_DDEBPERFAC,--  DATE  Y      Date de debut de la periode facturee de la ligne
                MFAL_DFINPERFAC,--  DATE  Y      Date de fin de la periode facturee de la ligne
                MFAL_DETAIL--  NUMBER  Y
                )
                values
               (
               'DIST'||v_district,
                V_FAC_NUM        ,
                2                ,
                'CAPITAL'        ,
                'Montant capital',
                11               ,
                1                ,
                annee_           ,
                1                ,
                facture_.CAPIT/1000,
                facture_.CAPIT/1000,
                0                ,
                0                ,
                facture_.CAPIT/1000,
                null             ,
                DATE_            ,
                null
                );
           exception
          when others then
            err_code := SQLCODE;
            err_msg  := SUBSTR(SQLERRM, 1, 200);
            insert into prob_migration
              (nom_table, val_ref, sql_err, date_pro,type_problem)
            values
              ('miwtfactureligne-gc',
               V_FAC_NUM,
               err_code || '--' || err_msg,
               sysdate,
               'erreur de confomité de type colonne');
        end;
end if;

if to_number(facture_.INTER) <> 0 then
         begin
         insert into miwtfactureligne
              (
                MFAL_SOURCE,--  VARCHAR2(100)  N      Code source/origine de la ligne [OBL]
                MFAL_REFFAE,--  VARCHAR2(100)  N      Identifiant de la facture de la ligne [OBL]
                MFAL_REFTAP,--  VARCHAR2(100)  N      Identifiant de la periode de tarif de la ligne [OBL]
                MFAL_REFART,--  VARCHAR2(100)  Y
                MFAL_LIBE  ,--  VARCHAR2(200)  Y
                MFAL_NUM   ,--  NUMBER(4)  N
                MFAL_TRAN  ,--  NUMBER(1)  N  1    Tranche de la ligne [OBL]
                MFAL_EXER  ,--  NUMBER(4)  N      Annee exercice de la ligne [OBL]
                MFAL_VOLU  ,--  NUMBER(15,3)  N      Volume facture de la ligne [OBL]
                MFAL_PU    ,--  NUMBER(12,6)  N      P.U. facture de la ligne [OBL]
                MFAL_MTHT  ,--  NUMBER(15,2)  N      Montant HT de la ligne [OBL]
                MFAL_MTVA  ,--  NUMBER(15,2)  N      Montant TVA de la ligne [OBL]
                MFAL_TTVA  ,--  NUMBER(15,2)  N      Taux de TVA de la ligne [OBL]
                MFAL_MTTC  ,--  NUMBER(15,2)  N
                MFAL_DDEBPERFAC,--  DATE  Y      Date de debut de la periode facturee de la ligne
                MFAL_DFINPERFAC,--  DATE  Y      Date de fin de la periode facturee de la ligne
                MFAL_DETAIL--  NUMBER  Y
                )
                values
               (
               'DIST'||v_district,
                V_FAC_NUM        ,
                2                ,
                'INTERET'        ,
                'Montant Interet',
                12               ,
                1                ,
                annee_           ,
                1                ,
                facture_.INTER/1000,
                facture_.INTER/1000,
                0                ,
                0                ,
                facture_.INTER/1000,
                null             ,
                DATE_            ,
                null
                );
           exception
          when others then
            err_code := SQLCODE;
            err_msg  := SUBSTR(SQLERRM, 1, 200);
            insert into prob_migration
              (nom_table, val_ref, sql_err, date_pro,type_problem)
            values
              ('miwtfactureligne-gc',
               V_FAC_NUM,
               err_code || '--' || err_msg,
               sysdate,
               'erreur de confomité de type colonne');
        end;
end if;

if to_number(facture_.RBRANCHE) <> 0 then
         begin
         insert into miwtfactureligne
              (
                MFAL_SOURCE,--  VARCHAR2(100) N      Code source/origine de la ligne [OBL]
                MFAL_REFFAE,--  VARCHAR2(100) N      Identifiant de la facture de la ligne [OBL]
                MFAL_REFTAP,--  VARCHAR2(100) N      Identifiant de la periode de tarif de la ligne [OBL]
                MFAL_REFART,--  VARCHAR2(100) Y
                MFAL_LIBE  ,--  VARCHAR2(200) Y
                MFAL_NUM   ,--  NUMBER(4)     N
                MFAL_TRAN  ,--  NUMBER(1)     N  1    Tranche de la ligne [OBL]
                MFAL_EXER  ,--  NUMBER(4)     N      Annee exercice de la ligne [OBL]
                MFAL_VOLU  ,--  NUMBER(15,3)  N      Volume facture de la ligne [OBL]
                MFAL_PU    ,--  NUMBER(12,6)  N      P.U. facture de la ligne [OBL]
                MFAL_MTHT  ,--  NUMBER(15,2)  N      Montant HT de la ligne [OBL]
                MFAL_MTVA  ,--  NUMBER(15,2)  N      Montant TVA de la ligne [OBL]
                MFAL_TTVA  ,--  NUMBER(15,2)  N      Taux de TVA de la ligne [OBL]
                MFAL_MTTC  ,--  NUMBER(15,2)  N
                MFAL_DDEBPERFAC,--  DATE      Y      Date de debut de la periode facturee de la ligne
                MFAL_DFINPERFAC,--  DATE      Y      Date de fin de la periode facturee de la ligne
                MFAL_DETAIL--  NUMBER         Y
                )
                values
               (
               'DIST'||v_district,
                V_FAC_NUM        ,
                1                ,
                'COURETABBR'     ,
                'Montant branchement',
                13               ,
                1                ,
                annee_           ,
                1                ,
                facture_.RBRANCHE/1000,
                facture_.RBRANCHE/1000,
                0                ,
                0                ,
                facture_.RBRANCHE/1000,
                null             ,
                DATE_            ,
                null
                );
           exception
          when others then
            err_code := SQLCODE;
            err_msg  := SUBSTR(SQLERRM, 1, 200);
            insert into prob_migration
              (nom_table, val_ref, sql_err, date_pro,type_problem)
            values
              ('miwtfactureligne-gc',
               V_FAC_NUM,
               err_code || '--' || err_msg,
               sysdate,
               'erreur de confomité de type colonne');
        end;
end if;

if to_number(facture_.RFACADE) <> 0 then
         begin
         insert into miwtfactureligne
               (
                MFAL_SOURCE,--  VARCHAR2(100) N      Code source/origine de la ligne [OBL]
                MFAL_REFFAE,--  VARCHAR2(100) N      Identifiant de la facture de la ligne [OBL]
                MFAL_REFTAP,--  VARCHAR2(100) N      Identifiant de la periode de tarif de la ligne [OBL]
                MFAL_REFART,--  VARCHAR2(100) Y
                MFAL_LIBE  ,--  VARCHAR2(200) Y
                MFAL_NUM   ,--  NUMBER(4)     N
                MFAL_TRAN  ,--  NUMBER(1)     N  1   Tranche de la ligne [OBL]
                MFAL_EXER  ,--  NUMBER(4)     N      Annee exercice de la ligne [OBL]
                MFAL_VOLU  ,--  NUMBER(15,3)  N      Volume facture de la ligne [OBL]
                MFAL_PU    ,--  NUMBER(12,6)  N      P.U. facture de la ligne [OBL]
                MFAL_MTHT  ,--  NUMBER(15,2)  N      Montant HT de la ligne [OBL]
                MFAL_MTVA  ,--  NUMBER(15,2)  N      Montant TVA de la ligne [OBL]
                MFAL_TTVA  ,--  NUMBER(15,2)  N      Taux de TVA de la ligne [OBL]
                MFAL_MTTC  ,--  NUMBER(15,2)  N
                MFAL_DDEBPERFAC,--  DATE  Y      Date de debut de la periode facturee de la ligne
                MFAL_DFINPERFAC,--  DATE  Y      Date de fin de la periode facturee de la ligne
                MFAL_DETAIL--  NUMBER  Y
                )
                values
               (
               'DIST'||v_district,
                V_FAC_NUM        ,
                1                ,
                'RFACADE'        ,
                'Montant facade' ,
                14               ,
                1                ,
                annee_           ,
                1                ,
                facture_.RFACADE/1000,
                facture_.RFACADE/1000,
                0                ,
                0                ,
                facture_.RFACADE/1000,
                null             ,
                DATE_            ,
                null
                );
           exception
          when others then
            err_code := SQLCODE;
            err_msg  := SUBSTR(SQLERRM, 1, 200);
            insert into prob_migration
              (nom_table, val_ref, sql_err, date_pro,type_problem)
            values
              ('miwtfactureligne-gc',
               V_FAC_NUM,
               err_code || '--' || err_msg,
               sysdate,
               'erreur de confomité de type colonne');
        end;
end if;

if to_number(facture_.REXTENSION) <> 0 then
         begin
         insert into miwtfactureligne
              (
                MFAL_SOURCE,--  VARCHAR2(100)  N      Code source/origine de la ligne [OBL]
                MFAL_REFFAE,--  VARCHAR2(100)  N      Identifiant de la facture de la ligne [OBL]
                MFAL_REFTAP,--  VARCHAR2(100)  N      Identifiant de la periode de tarif de la ligne [OBL]
                MFAL_REFART,--  VARCHAR2(100)  Y
                MFAL_LIBE  ,--  VARCHAR2(200)  Y
                MFAL_NUM   ,--  NUMBER(4)  N
                MFAL_TRAN  ,--  NUMBER(1)  N  1    Tranche de la ligne [OBL]
                MFAL_EXER  ,--  NUMBER(4)  N      Annee exercice de la ligne [OBL]
                MFAL_VOLU  ,--  NUMBER(15,3)  N      Volume facture de la ligne [OBL]
                MFAL_PU    ,--  NUMBER(12,6)  N      P.U. facture de la ligne [OBL]
                MFAL_MTHT  ,--  NUMBER(15,2)  N      Montant HT de la ligne [OBL]
                MFAL_MTVA  ,--  NUMBER(15,2)  N      Montant TVA de la ligne [OBL]
                MFAL_TTVA  ,--  NUMBER(15,2)  N      Taux de TVA de la ligne [OBL]
                MFAL_MTTC  ,--  NUMBER(15,2)  N
                MFAL_DDEBPERFAC,--  DATE  Y      Date de debut de la periode facturee de la ligne
                MFAL_DFINPERFAC,--  DATE  Y      Date de fin de la periode facturee de la ligne
                MFAL_DETAIL--  NUMBER  Y
                )
                values
               (
               'DIST'||v_district,
                V_FAC_NUM        ,
                1                ,
                'REXTENSION'     ,
                'Montant extension',
                15               ,
                1                ,
                annee_           ,
                1                ,
                facture_.REXTENSION/1000,
                facture_.REXTENSION/1000,
                0                ,
                0                ,
                facture_.REXTENSION/1000,
                null             ,
                DATE_            ,
                null
                );
           exception
          when others then
            err_code := SQLCODE;
            err_msg  := SUBSTR(SQLERRM, 1, 200);
            insert into prob_migration
              (nom_table, val_ref, sql_err, date_pro,type_problem)
            values
              ('miwtfactureligne-gc',
               V_FAC_NUM,
               err_code || '--' || err_msg,
               sysdate,
               'erreur de confomité de type colonne');
        end;
end if;

if to_number(facture_.REXTENSION) <> 0 then
         begin
         insert into miwtfactureligne
               (
                MFAL_SOURCE,--  VARCHAR2(100)  N      Code source/origine de la ligne [OBL]
                MFAL_REFFAE,--  VARCHAR2(100)  N      Identifiant de la facture de la ligne [OBL]
                MFAL_REFTAP,--  VARCHAR2(100)  N      Identifiant de la periode de tarif de la ligne [OBL]
                MFAL_REFART,--  VARCHAR2(100)  Y
                MFAL_LIBE  ,--  VARCHAR2(200)  Y
                MFAL_NUM   ,--  NUMBER(4)  N
                MFAL_TRAN  ,--  NUMBER(1)  N  1    Tranche de la ligne [OBL]
                MFAL_EXER  ,--  NUMBER(4)  N      Annee exercice de la ligne [OBL]
                MFAL_VOLU  ,--  NUMBER(15,3)  N      Volume facture de la ligne [OBL]
                MFAL_PU    ,--  NUMBER(12,6)  N      P.U. facture de la ligne [OBL]
                MFAL_MTHT  ,--  NUMBER(15,2)  N      Montant HT de la ligne [OBL]
                MFAL_MTVA  ,--  NUMBER(15,2)  N      Montant TVA de la ligne [OBL]
                MFAL_TTVA  ,--  NUMBER(15,2)  N      Taux de TVA de la ligne [OBL]
                MFAL_MTTC  ,--  NUMBER(15,2)  N
                MFAL_DDEBPERFAC,--  DATE  Y      Date de debut de la periode facturee de la ligne
                MFAL_DFINPERFAC,--  DATE  Y      Date de fin de la periode facturee de la ligne
                MFAL_DETAIL--  NUMBER  Y
                )
                values
               (
               'DIST'||v_district,
                V_FAC_NUM        ,
                1                ,
                'PFINANCIER'     ,
                'PRODUIT FINANCIER',
                16               ,
                1                ,
                annee_           ,
                1                ,
                facture_.PFINANCIER/1000,
                facture_.PFINANCIER/1000,
                0                ,
                0                ,
                facture_.PFINANCIER/1000,
                null             ,
                DATE_            ,
                null
                );
           exception
          when others then
            err_code := SQLCODE;
            err_msg  := SUBSTR(SQLERRM, 1, 200);
            insert into prob_migration
              (nom_table, val_ref, sql_err, date_pro)
            values
              ('miwtfactureligne-gc',
               V_FAC_NUM,
               err_code || '--' || err_msg,
               sysdate);
        end;
end if;
  ---------------
if to_number(facture_.AREPOR) <> 0 then
         begin
         insert into miwtfactureligne
               (
                MFAL_SOURCE,--  VARCHAR2(100)  N      Code source/origine de la ligne [OBL]
                MFAL_REFFAE,--  VARCHAR2(100)  N      Identifiant de la facture de la ligne [OBL]
                MFAL_REFTAP,--  VARCHAR2(100)  N      Identifiant de la periode de tarif de la ligne [OBL]
                MFAL_REFART,--  VARCHAR2(100)  Y
                MFAL_LIBE  ,--  VARCHAR2(200)  Y
                MFAL_NUM   ,--  NUMBER(4)  N
                MFAL_TRAN  ,--  NUMBER(1)  N  1    Tranche de la ligne [OBL]
                MFAL_EXER  ,--  NUMBER(4)  N      Annee exercice de la ligne [OBL]
                MFAL_VOLU  ,--  NUMBER(15,3)  N      Volume facture de la ligne [OBL]
                MFAL_PU    ,--  NUMBER(12,6)  N      P.U. facture de la ligne [OBL]
                MFAL_MTHT  ,--  NUMBER(15,2)  N      Montant HT de la ligne [OBL]
                MFAL_MTVA  ,--  NUMBER(15,2)  N      Montant TVA de la ligne [OBL]
                MFAL_TTVA  ,--  NUMBER(15,2)  N      Taux de TVA de la ligne [OBL]
                MFAL_MTTC  ,--  NUMBER(15,2)  N
                MFAL_DDEBPERFAC,--  DATE  Y      Date de debut de la periode facturee de la ligne
                MFAL_DFINPERFAC,--  DATE  Y      Date de fin de la periode facturee de la ligne
                MFAL_DETAIL--  NUMBER  Y
                )
                values
               (
               'DIST'||v_district,
                V_FAC_NUM        ,
                1                ,
                'AREPOR'         ,
                'Montant report' ,
                17               ,
                1                ,
                annee_           ,
                1                ,
                decode(facture_.caron,'1',1,-1)* (facture_.AREPOR/1000),
                decode(facture_.caron,'1',1,-1)* (facture_.AREPOR/1000),
                0                ,
                0                ,
                decode(facture_.caron,'1',1,-1)* (facture_.AREPOR/1000),
                null             ,
                DATE_            ,
                null
                );
           exception
          when others then
            err_code := SQLCODE;
            err_msg  := SUBSTR(SQLERRM, 1, 200);
            insert into prob_migration
              (nom_table, val_ref, sql_err, date_pro,type_problem)
            values
              ('miwtfactureligne-gc',
               V_FAC_NUM,
               err_code || '--' || err_msg,
               sysdate,
               'erreur de confomité de type colonne');
        end;
end if;

if to_number(facture_.NAROND) <> 0 then
         begin
         insert into miwtfactureligne
              (
                MFAL_SOURCE,--  VARCHAR2(100)  N      Code source/origine de la ligne [OBL]
                MFAL_REFFAE,--  VARCHAR2(100)  N      Identifiant de la facture de la ligne [OBL]
                MFAL_REFTAP,--  VARCHAR2(100)  N      Identifiant de la periode de tarif de la ligne [OBL]
                MFAL_REFART,--  VARCHAR2(100)  Y
                MFAL_LIBE  ,--  VARCHAR2(200)  Y
                MFAL_NUM   ,--  NUMBER(4)  N
                MFAL_TRAN  ,--  NUMBER(1)  N  1    Tranche de la ligne [OBL]
                MFAL_EXER  ,--  NUMBER(4)  N      Annee exercice de la ligne [OBL]
                MFAL_VOLU  ,--  NUMBER(15,3)  N      Volume facture de la ligne [OBL]
                MFAL_PU    ,--  NUMBER(12,6)  N      P.U. facture de la ligne [OBL]
                MFAL_MTHT  ,--  NUMBER(15,2)  N      Montant HT de la ligne [OBL]
                MFAL_MTVA  ,--  NUMBER(15,2)  N      Montant TVA de la ligne [OBL]
                MFAL_TTVA  ,--  NUMBER(15,2)  N      Taux de TVA de la ligne [OBL]
                MFAL_MTTC  ,--  NUMBER(15,2)  N
                MFAL_DDEBPERFAC,--  DATE  Y      Date de debut de la periode facturee de la ligne
                MFAL_DFINPERFAC,--  DATE  Y      Date de fin de la periode facturee de la ligne
                MFAL_DETAIL--  NUMBER  Y
                )
                values
               (
               'DIST'||v_district,
                V_FAC_NUM        ,
                1                ,
                'NAROND'         ,
                'Arrondissement' ,
                18               ,
                1                ,
                annee_           ,
                1                ,
                decode(facture_.caron,'1',-1,1)*(facture_.NAROND/1000),
                decode(facture_.caron,'1',-1,1)*(facture_.NAROND/1000),
                0                ,
                0                ,
                decode(facture_.caron,'1',-1,1)*(facture_.NAROND/1000),
                null             ,
                DATE_            ,
                null
                );
           exception
          when others then
            err_code := SQLCODE;
            err_msg  := SUBSTR(SQLERRM, 1, 200);
            insert into prob_migration
              (nom_table, val_ref, sql_err, date_pro,type_problem)
            values
              ('miwtfactureligne-gc',
               V_FAC_NUM,
               err_code || '--' || err_msg,
               sysdate,
               'erreur de confomité de type colonne');
        end;
end if;

if to_number(facture_.DIVERS) <> 0 then
         begin
         insert into miwtfactureligne
              (
                MFAL_SOURCE,--  VARCHAR2(100)  N      Code source/origine de la ligne [OBL]
                MFAL_REFFAE,--  VARCHAR2(100)  N      Identifiant de la facture de la ligne [OBL]
                MFAL_REFTAP,--  VARCHAR2(100)  N      Identifiant de la periode de tarif de la ligne [OBL]
                MFAL_REFART,--  VARCHAR2(100)  Y
                MFAL_LIBE  ,--  VARCHAR2(200)  Y
                MFAL_NUM   ,--  NUMBER(4)  N
                MFAL_TRAN  ,--  NUMBER(1)  N  1    Tranche de la ligne [OBL]
                MFAL_EXER  ,--  NUMBER(4)  N      Annee exercice de la ligne [OBL]
                MFAL_VOLU  ,--  NUMBER(15,3)  N      Volume facture de la ligne [OBL]
                MFAL_PU    ,--  NUMBER(12,6)  N      P.U. facture de la ligne [OBL]
                MFAL_MTHT  ,--  NUMBER(15,2)  N      Montant HT de la ligne [OBL]
                MFAL_MTVA  ,--  NUMBER(15,2)  N      Montant TVA de la ligne [OBL]
                MFAL_TTVA  ,--  NUMBER(15,2)  N      Taux de TVA de la ligne [OBL]
                MFAL_MTTC  ,--  NUMBER(15,2)  N
                MFAL_DDEBPERFAC,--  DATE  Y      Date de debut de la periode facturee de la ligne
                MFAL_DFINPERFAC,--  DATE  Y      Date de fin de la periode facturee de la ligne
                MFAL_DETAIL--  NUMBER  Y
                )
                values
               (
               'DIST'||v_district,
                V_FAC_NUM        ,
                1                ,
                'AUTREFRAIS'     ,
                'Frais Divers '  ,
                20               ,
                1                ,
                annee_           ,
                1                ,
                (facture_.DIVERS)/1000,
                (facture_.DIVERS)/1000,
                0                ,
                0                ,
                (facture_.DIVERS)/1000,
                null             ,
                DATE_            ,
                null
                );
           exception
          when others then
            err_code := SQLCODE;
            err_msg  := SUBSTR(SQLERRM, 1, 200);
            insert into prob_migration
              (nom_table, val_ref, sql_err, date_pro,type_problem)
            values
              ('miwtfactureligne-gc',
               V_FAC_NUM,
               err_code || '--' || err_msg,
               sysdate,
               'erreur de confomité de type colonne');
        end;
end if;

if to_number(facture_.EAUPUIT) <> 0 then
         begin
         insert into miwtfactureligne
               (
                MFAL_SOURCE,--  VARCHAR2(100)  N      Code source/origine de la ligne [OBL]
                MFAL_REFFAE,--  VARCHAR2(100)  N      Identifiant de la facture de la ligne [OBL]
                MFAL_REFTAP,--  VARCHAR2(100)  N      Identifiant de la periode de tarif de la ligne [OBL]
                MFAL_REFART,--  VARCHAR2(100)  Y
                MFAL_LIBE  ,--  VARCHAR2(200)  Y
                MFAL_NUM   ,--  NUMBER(4)  N
                MFAL_TRAN  ,--  NUMBER(1)  N  1    Tranche de la ligne [OBL]
                MFAL_EXER  ,--  NUMBER(4)  N      Annee exercice de la ligne [OBL]
                MFAL_VOLU  ,--  NUMBER(15,3)  N      Volume facture de la ligne [OBL]
                MFAL_PU    ,--  NUMBER(12,6)  N      P.U. facture de la ligne [OBL]
                MFAL_MTHT  ,--  NUMBER(15,2)  N      Montant HT de la ligne [OBL]
                MFAL_MTVA  ,--  NUMBER(15,2)  N      Montant TVA de la ligne [OBL]
                MFAL_TTVA  ,--  NUMBER(15,2)  N      Taux de TVA de la ligne [OBL]
                MFAL_MTTC  ,--  NUMBER(15,2)  N
                MFAL_DDEBPERFAC,--  DATE  Y      Date de debut de la periode facturee de la ligne
                MFAL_DFINPERFAC,--  DATE  Y      Date de fin de la periode facturee de la ligne
                MFAL_DETAIL--  NUMBER  Y
                )
                values
               (
               'DIST'||v_district,
                V_FAC_NUM        ,
                1                ,
                'VAR_ONAS_C'     ,
                'Eau de puit '   ,
                21               ,
                1                ,
                annee_           ,
                1                ,
                (facture_.EAUPUIT)/1000,
                (facture_.EAUPUIT)/1000,
                0                ,
                0                ,
                (facture_.EAUPUIT)/1000,
                null             ,
                DATE_            ,
                null
                );
           exception
          when others then
            err_code := SQLCODE;
            err_msg  := SUBSTR(SQLERRM, 1, 200);
            insert into prob_migration
              (nom_table, val_ref, sql_err, date_pro,type_problem)
            values
              ('miwtfactureligne-gc',
               V_FAC_NUM,
               err_code || '--' || err_msg,
               sysdate,
               'erreur de confomité de type colonne');
        end;
end if;
-----------------------------------miwtreleve_gc
         select count(*) into  nbr_trt from  miwtreleve_gc
             where mrel_refpdl =
              lpad(facture_.DIST,2,'0')||
              lpad(facture_.tou,3,'0')||
              lpad(facture_.ORD,3,'0')||
              lpad(facture_.POL,5,'0')
              And mrel_refpdl is not null
               and   annee = annee_
               and   periode = periode_
               And rownum=1;
       if nbr_trt <> 0 then
        update  miwtreleve_gc  set mrel_fact1 = v_ID_FACTURE
             where mrel_refpdl =
              lpad(facture_.DIST,2,'0')||
              lpad(facture_.tou,3,'0')||
              lpad(facture_.ORD,3,'0')||
              lpad(facture_.POL,5,'0')
              And mrel_refpdl is not null
               and   annee = annee_
               and   periode = periode_
               And rownum=1;

          end if;

         -----------------------------------miwtreleve_gc_1
         select count(*) into nbr_trt_rt  from  miwtreleve_gc_1
             where mrel_refpdl =
              lpad(facture_.DIST,2,'0')||
              lpad(facture_.tou,3,'0')||
              lpad(facture_.ORD,3,'0')||
              lpad(facture_.POL,5,'0')
              And mrel_refpdl is not null
               and   annee = annee_
               and   periode = periode_
               And rownum=1;
       if nbr_trt_rt <> 0 then
        update  miwtreleve_gc_1  set mrel_fact1 = v_ID_FACTURE
             where mrel_refpdl =
              lpad(facture_.DIST,2,'0')||
              lpad(facture_.tou,3,'0')||
              lpad(facture_.ORD,3,'0')||
              lpad(facture_.POL,5,'0')
              And mrel_refpdl is not null
               and   annee = annee_
               and   periode = periode_
               And rownum=1;

          end if;



   <<XX>>

        commit;

end loop;
      delete xx;
       insert into xx  select  substr(s.mfae_rdet,1,2) distirct,substr(s.mfae_rdet,3,3) tourne,substr(s.mfae_rdet,6,3) ordre ,substr(s.mfae_rdet,9,4)annee,
        substr(s.mfae_rdet,13,2) periode,t.mfal_reffae,sum(t.mfal_mttc) net_calc,s.mfae_solde net,sum(t.mfal_mttc)-s.mfae_solde diff,
        sum(decode(t.mfal_refart,'CAPITAL',t.mfal_mttc,'INTERET',t.mfal_mttc,0)) capit
         from miwtfactureligne t,miwtfactureentete s
         where t.mfal_reffae=s.mfae_ref
         group by t.mfal_reffae,s.mfae_solde,substr(s.mfae_rdet,1,2),substr(s.mfae_rdet,3,3),substr(s.mfae_rdet,6,3),substr(s.mfae_rdet,9,4),substr(s.mfae_rdet,13,2)
         having ((abs(sum(t.mfal_mttc)-s.mfae_solde) <>0)) ;
       commit;

          for c in (select t.*, t.rowid from XX t WHERE diff >= 0.001)
   loop
     select count(*) into x from miwtfactureligne s where s.mfal_reffae=c.mfal_reffae and s.mfal_refart='NAROND'
                                                      And 'DIST'||c.distirct=s.mfal_source;
  if x = 0 then
       insert into miwtfactureligne
               (
                MFAL_SOURCE,--  VARCHAR2(100)  N      Code source/origine de la ligne [OBL]
                MFAL_REFFAE,--  VARCHAR2(100)  N      Identifiant de la facture de la ligne [OBL]
                MFAL_REFTAP,--  VARCHAR2(100)  N      Identifiant de la periode de tarif de la ligne [OBL]
                MFAL_REFART,--  VARCHAR2(100)  Y
                MFAL_LIBE  ,--  VARCHAR2(200)  Y
                MFAL_NUM   ,--  NUMBER(4)  N
                MFAL_TRAN  ,--  NUMBER(1)  N  1    Tranche de la ligne [OBL]
                MFAL_EXER  ,--  NUMBER(4)  N      Annee exercice de la ligne [OBL]
                MFAL_VOLU  ,--  NUMBER(15,3)  N      Volume facture de la ligne [OBL]
                MFAL_PU    ,--  NUMBER(12,6)  N      P.U. facture de la ligne [OBL]
                MFAL_MTHT  ,--  NUMBER(15,2)  N      Montant HT de la ligne [OBL]
                MFAL_MTVA  ,--  NUMBER(15,2)  N      Montant TVA de la ligne [OBL]
                MFAL_TTVA  ,--  NUMBER(15,2)  N      Taux de TVA de la ligne [OBL]
                MFAL_MTTC  ,--  NUMBER(15,2)  N
                MFAL_DDEBPERFAC,--  DATE  Y      Date de debut de la periode facturee de la ligne
                MFAL_DFINPERFAC,--  DATE  Y      Date de fin de la periode facturee de la ligne
                MFAL_DETAIL--  NUMBER  Y
                )
                values
               (
               'DIST'||c.distirct,
                c.mfal_reffae    ,
                1                ,
                'NAROND'         ,
                'Arrondissement' ,
                18               ,
                1                ,
                c.annee          ,
                1                ,
                (-1)*(c.diff)    ,
                (-1)*(c.diff)    ,
                0                ,
                0                ,
                (-1)*(c.diff)    ,
                null             ,
                null             ,
                null
                );
       else
               update miwtfactureligne set MFAL_PU=MFAL_PU-c.diff,
                                           MFAL_MTHT=MFAL_MTHT-c.diff,
                                           MFAL_MTTC=MFAL_MTTC-c.diff
                                           where
                                           mfal_reffae=c.mfal_reffae and mfal_refart='NAROND'
                                            And 'DIST'||c.distirct=mfal_source;
   end if;


  end loop;
           insert into prob_migration (nom_table)values(SYSTIMESTAMP||'   END MIWT_FACTURE_AS400GC');
          commit;


  end;




--******************************************** Traitement des facture District
 procedure MIWT_FACTURE_DIST (v_district in varchar2) is
--********************************* TRAITEMENT DES FACTURES  A PARTIR TABLE facture
    err_code         varchar2(200);
    err_msg          varchar2(200);
    V_FAC_NUM        number;
    V_FAC_RESTANTDU  number;
    V_FAC_DATECALCUL date;
    V_FAC_ABN_NUM    number(20);
    V_TRAIN_FACT     varchar2(200);
    V_REF_ABN        varchar2(200);
    nbr_trt          number := 0;
    v_date_origine   date;
    v_MFAE_RDET      varchar2(100);
    v_ID_FACTURE     varchar2(20);
    v_ID_FACTURE_orig varchar2(20);
     v_mrel_ref       varchar2(200);
    annee_            number(4);
    periode_          number;
    version           number(1) := 0;
    mois_             number;
    date_             date;
    wMFAE_REF         varchar2(100);
        tiers_           varchar2(1);
    six_             varchar2(1);

  begin
execute immediate 'alter session set nls_date_format = ''dd/mm/yyyy''';
execute immediate 'alter session set NLS_NUMERIC_CHARACTERS = '',.''';
    --**************************************************
   delete prob_migration where
              nom_table in
              ('miwtfacture-DIST');
  insert into prob_migration (nom_table)values(SYSTIMESTAMP||'   START MIWT_FACTURE_DIST');
    commit;
     --**************************************************


    -- reception de la liste des releves
    select max(nvl(to_number(MFAE_REF),0)) into  V_FAC_NUM from miwtfactureentete where MFAE_SOURCE = 'DIST'||v_district;
       if V_FAC_NUM is null then
             V_FAC_NUM        := 0;
             end if;

    for facture_ in ( select * from facture f
                      where trim(f.annee)||trim(f.periode) not in ( select j.mfae_exercice||j.mfae_numerorole
                                                                    from miwtfactureentete j
                                                                    where substr(j.mfae_rdet,1,8)= ltrim(rtrim(f.DISTRICT))||lpad(ltrim(rtrim(f.tournee)),3,'0')||
                                                                    lpad(ltrim(rtrim(f.ORDRE)),3,'0')
                                                                    and j.MFAE_SOURCE='DIST'||v_district
                                                                --test and substr(j.mfae_rdet,1,8)='20308144'
                                                                   )
                      and f.annee in('2015')
                      and f.district=v_district
                     -- test and f.tournee||f.ordre='308144'

                      ) loop


     V_FAC_NUM        := V_FAC_NUM +1;
      --**************************************************
      --Determiner la facture d'origine facture AS400
      v_MFAE_RDET := ltrim(rtrim(facture_.district)) ||
                    lpad(ltrim(rtrim(facture_.tournee)),3,'0') ||
                     lpad(ltrim(rtrim(facture_.ordre)),3,'0')||
                     to_char(facture_.annee) ||
                     lpad(to_char(facture_.periode),2,0)||to_char(version);


      periode_ := facture_.periode;

      select last_day(to_date('01'||lpad(trim(facture_.periode),2,'0')||facture_.annee,'dd/mm/yy'))
        into date_
         from dual;
 ------------------
   BEGIN

      select (r.mrel_date+6) INTO  V_FAC_DATECALCUL from  miwtreleve r
             where r.mrel_refpdl =
              lpad(facture_.DISTRICT,2,'0')||
              lpad(ltrim(rtrim(facture_.tournee)),3,'0')||
              lpad(ltrim(rtrim(facture_.ORDRE)),3,'0')||
              lpad(ltrim(rtrim(facture_.POLICE)),5,'0')
              And mrel_refpdl is not null
               and   r.annee = annee_
               and   r.periode = periode_
               And rownum=1;
               Exception  when others then
               V_FAC_DATECALCUL := date_;
            end;

     annee_ :=facture_.annee;

      -- suivi en temps reel du traitement
      nbr_trt := nbr_trt + 1;
      --************************************************
      V_FAC_RESTANTDU  := null;
      --V_FAC_DATECALCUL := null;
      V_FAC_ABN_NUM    := null;
      V_REF_ABN        := null;

     /* BEGIN
      V_FAC_DATECALCUL := v_date_origine + 5;

            end;*/
begin
        -- reception de l'identfiant de l'abonnement

        v_ID_FACTURE:=ltrim(rtrim(facture_.DISTRICT)) ||
                      lpad(ltrim(rtrim(facture_.tournee)),3,'0') ||
                      lpad(ltrim(rtrim(facture_.ORDRE)),3,'0')||
                      to_char(annee_) ||lpad(to_char(periode_),2,'0')||'0';

        for ref_abn_ in (select *
                          from miwabn a
                          where substr(a.abn_refsite,1,8) = lpad(facture_.DISTRICT,2,'0') ||
                        lpad(ltrim(rtrim(facture_.tournee)),3,'0') ||
                        lpad(ltrim(rtrim(facture_.Ordre)),3,'0')) loop
          V_FAC_ABN_NUM := ref_abn_.abn_ref;
          V_REF_ABN := ref_abn_.ABN_REFPER_A;

          if ref_abn_.voc_typsag='G' then

    V_TRAIN_FACT :=  'ANNEE:'||ltrim(rtrim(facture_.annee))||' MOIS:'||ltrim(rtrim(facture_.periode));

    else


          select NTIERS,NSIXIEME
           into tiers_,six_
           from tourne
           where  code=lpad(facture_.tournee,3,'0');


        V_TRAIN_FACT :=  'ANNEE:'||ltrim(rtrim(facture_.annee)) ||
                         ' TRIM:'||ltrim(rtrim(facture_.periode)) ||
                         ' TIER:'||ltrim(rtrim(tiers_))||
                         ' SIX:'||ltrim(rtrim(six_ ));
    end if;
        end loop;

        if V_FAC_ABN_NUM  is null then
          V_FAC_ABN_NUM := lpad(facture_.DISTRICT,2,'0') ||
                        lpad(ltrim(rtrim(facture_.tournee)),3,'0') ||
                        lpad(ltrim(rtrim(facture_.Ordre)),3,'0') ||
                        lpad(ltrim(rtrim(facture_.POLICE)),5,'0');
         end if;
         exception
          when others then
            err_code := SQLCODE;
            err_msg  := SUBSTR(SQLERRM, 1, 200);
            insert into prob_migration
              (nom_table, val_ref, sql_err, date_pro,type_problem)
            values
              ('miwtfactureAA-DIST','Tou:'||lpad(ltrim(rtrim(facture_.tournee)),3,'0')||'ORD:'||lpad(ltrim(rtrim(facture_.Ordre)),3,'0')||'TRIM :'||facture_.periode||'TIER :'||facture_.TIERS||'AA:'||facture_.ANNEE||'POL:'||lpad(ltrim(rtrim(facture_.POLICE)),5,'0'),
                 err_msg ||'-- periode ',sysdate,' ce pas anomalie :erreur recuperation ref abonner');
                 end;


     v_mrel_ref:=null;
      begin
         select r.mrel_ref into v_mrel_ref
         from miwtreleve r
         where substr(r.mrel_refpdl,1,8)=substr(v_ID_FACTURE,1,8)
         and  TO_CHAR(r.annee)=substr(v_ID_FACTURE,9,4)
         and lpad(TO_CHAR(r.periode),2,'0')=substr(v_ID_FACTURE,13,2);
       exception when others then
            begin
             select t.mrel_ref into v_mrel_ref
             from miwtrelevet t
             where substr(t.mrel_refpdl,1,8)=substr(v_ID_FACTURE,1,8)
             and  TO_CHAR(t.annee)=substr(v_ID_FACTURE,9,4)
             and lpad(TO_CHAR(t.periode),2,'0')=substr(v_ID_FACTURE,13,2);
           exception when others then
             begin
         select r.mrel_ref into v_mrel_ref
         from miwtreleve_gc_1 r
         where substr(r.mrel_refpdl,1,8)=substr(v_ID_FACTURE,1,8)
         and TO_CHAR(r.annee)=substr(v_ID_FACTURE,9,4)
         and lpad(TO_CHAR(r.periode),2,'0')=substr(v_ID_FACTURE,13,2);
      exception when others then
           begin
               select t.mrel_ref into v_mrel_ref
               from miwtreleve_gc t
               where substr(t.mrel_refpdl,1,8)=substr(v_ID_FACTURE,1,8)
               and TO_CHAR(t.annee)=substr(v_ID_FACTURE,9,4)
               and lpad(TO_CHAR(t.periode),2,'0')=substr(v_ID_FACTURE,13,2);
          exception when others then
                    v_mrel_ref:=null;
          end ;
      end;
    end;
    end;



        begin
         insert into miwtfactureentete
          (
            MFAE_SOURCE         ,--1   VARCHAR2(100)  N     Code source/origine de la facture [OBL]
            MFAE_REF            ,--2   VARCHAR2(100)  N     Identifiant unique de la facture pour la source [OBL]
            MFAE_REFTRF         ,--3   VARCHAR2(100)  Y     Identifiant du train de la facture
            MFAE_NUME           ,--4   NUMBER(10)     Y     Numero de la facture [OBL]
            MFAE_RDET           ,--5   VARCHAR2(15)   Y     RDET de la facture
            MFAE_CCMO           ,--6   VARCHAR2(1)    Y     Cle controle RDET de la facture
            MFAE_DEDI           ,--7   DATE           N     Date d edition de la facture [OBL]
            MFAE_DLPAI          ,--8   DATE           Y     Date limite de paiement de la facture [OBL]
            MFAE_DPREL          ,--9   DATE           Y     Date de prelevement de la facture [OBL]
            MFAE_TOTHTE         ,--10  NUMBER(10,2)   N     Total HT EAU de la facture [OBL]
            MFAE_TOTTVAE        ,--11  NUMBER(10,2)   N     Total TVA EAU de la facture [OBL]
            MFAE_TOTHTA         ,--12  NUMBER(10,2)   N     Total HT ASS de la facture [OBL]
            MFAE_TOTTVAA        ,--13  NUMBER(10,2)   N     Total TVA ASS de la facture [OBL]
            MFAE_SOLDE          ,--14  NUMBER(10,2)   Y     Solde TTC de la facture
            MFAE_TYPE           ,--15  VARCHAR2(2)    N 'R'
            MFAE_REFFAEDEDU     ,--16  VARCHAR2(100)  Y
            MFAE_REFABN         ,--17  VARCHAR2(100)  N     Identifiant du contrat de la facture [OBL]
            MFAE_REF_CODNIV_RELANCE,--18VARCHAR2(100) Y     Reference Code niveau de chainde relance
            MFAE_RIB_REF        ,--19  VARCHAR2(100)  Y     Reference Rib
            MFAE_RIB_ETAT       ,--20  NUMBER(1)      Y     Mode de payement (pr?l?vement 1 ou tip 2)
            MFAE_COMPTEAUX      ,--21  VARCHAR2(100)  Y     Compte auxilaire GENACCOUNT associe a la facture
            MFAE_REF_ORIGINE    ,--22  VARCHAR2(100)  Y     Facture origine
            MFAE_COMMENT        ,--23  VARCHAR2(4000) Y     Commentaire libre Facture
            MFAE_AMOUNTTTCDEC   ,--24  NUMBER(17,10)  Y     Montant TTC a deduire
            VOC_MODEFACT        ,--25  VARCHAR2(10)   Y
            MFAE_REF_DEDUC      ,--26  VARCHAR2(100)  Y
            MFAE_REFORGA        ,--27  VARCHAR2(100)  Y
            MFAE_EXERCICE       ,--28  NUMBER(4)      Y     Exercice du role de la facture
            MFAE_NUMEROROLE     ,--29  NUMBER(4)      Y     Numero du role pour l exercice
            MFAE_PREL           ,--30  NUMBER         Y
            MFAE_AROND          ,--31  NUMBER         Y
            mrel_ref            --32
          )
        values
         (
          'DIST'||v_district,--1
          V_FAC_NUM         ,--2
          V_TRAIN_FACT      ,--3
          V_FAC_NUM         ,--4
          v_ID_FACTURE      ,--5
          NULL              ,--6
          V_FAC_DATECALCUL  ,--7
          V_FAC_DATECALCUL  ,--8
          V_FAC_DATECALCUL  ,--9
          facture_.net_a_payer/1000,--10
          0                 ,--11
          0                 ,--12
          0                 ,--13
          facture_.net_a_payer/1000,--14
          decode(facture_.etat,'P','RF','O','FC','C','FHC','FC'),--15
          NULL              ,--16
          V_FAC_ABN_NUM     ,--17
          'INCONNUE'        ,--18
           null             ,--19
          4                 ,--20
          'IMP_MIG'         ,--21
          v_MFAE_RDET       ,--22
          V_REF_ABN         ,--23
          NULL              ,--24
          4                 ,--25
          NULL              ,--26
          v_district        ,--27
          annee_            ,--28
          periode_          ,--29
          1                 ,--30
          0                 ,--31
          v_mrel_ref
         );
        exception
          when others then
            err_code := SQLCODE;
            err_msg  := SUBSTR(SQLERRM, 1, 200);
            insert into prob_migration
              (nom_table, val_ref, sql_err, date_pro,type_problem)
            values
              ('miwtfacture-DIST',
               lpad(facture_.district,2,'0') ||
               lpad(ltrim(rtrim(facture_.tournee)),3,'0') ||
               lpad(ltrim(rtrim(facture_.Ordre)),3,'0') ||
               lpad(ltrim(rtrim(facture_.POLICE)),5,'0'),
               err_code || '--' || err_msg,
               sysdate,
               'erreur de confomité de type colonne'
               );
        end;




--------------update miwtreleve_histocpt

          select count(*) into  nbr_trt from  miwtreleve_histocpt
             where mrel_refpdl =
              lpad(facture_.DISTRICT,2,'0')||
              lpad(ltrim(rtrim(facture_.tournee)),3,'0')||
              lpad(ltrim(rtrim(facture_.Ordre)),3,'0')||
              lpad(ltrim(rtrim(facture_.POLICE)),5,'0')
              And mrel_refpdl is not null
               and   annee = annee_
               and   periode = periode_
               And rownum=1;
       if nbr_trt <> 0 then
        update  miwtreleve_histocpt  set mrel_fact1 = v_ID_FACTURE
             where mrel_refpdl =
              lpad(facture_.DISTRICT,2,'0')||
              lpad(ltrim(rtrim(facture_.tournee)),3,'0')||
              lpad(ltrim(rtrim(facture_.Ordre)),3,'0')||
              lpad(ltrim(rtrim(facture_.POLICE)),5,'0')
              And mrel_refpdl is not null
              and mrel_fact1 is null
               and   annee = annee_
               and   periode = periode_
               And rownum=1;
         end if;

         commit;

    end loop;
    insert into prob_migration (nom_table)values(SYSTIMESTAMP||'   END MIWT_FACTURE_DIST');
        commit;

end;

---------------------------------------------------------------------------

--******************************************** Traitement des facture District
 procedure MIWT_FACTURE_VERSION (v_district in varchar2) is
--********************************* TRAITEMENT DES FACTURES  A PARTIR TABLE facture
    err_code         varchar2(200);
    err_msg          varchar2(200);
    V_FAC_NUM        number;
    V_FAC_RESTANTDU  number;
    V_FAC_DATECALCUL date;
    V_FAC_ABN_NUM    number(20);
    V_TRAIN_FACT     varchar2(200);
    V_REF_ABN        varchar2(200);
    nbr_trt          number := 0;
    v_date_origine   date;
    v_MFAE_RDET      varchar2(100);
    v_ID_FACTURE     varchar2(20);
    v_ID_FACTURE_orig varchar2(20);
     v_mrel_ref       varchar2(200);
    annee_            number(4);
    periode_          number;
    version           number(1) := 1;
    mois_             number;
    date_             date;
    wMFAE_REF         varchar2(100);

  begin
execute immediate 'alter session set nls_date_format = ''dd/mm/yyyy''';
execute immediate 'alter session set NLS_NUMERIC_CHARACTERS = '',.''';
    --**************************************************
   delete prob_migration where
              nom_table in
              ('miwtfacture-VERSION','SEQ_RELEVE','miwtfactureligne');
  insert into prob_migration (nom_table)values(SYSTIMESTAMP||'   START MIWT_FACTURE_VERSION');
    commit;
     --**************************************************


    -- reception de la liste des releves
    select max(nvl(to_number(MFAE_REF),0)) into  V_FAC_NUM from miwtfactureentete where MFAE_SOURCE = 'DIST'||v_district;
       if V_FAC_NUM is null then
             V_FAC_NUM        := 0;
             end if;

    for facture_ in ( select distinct mf.MFAE_RDET, mf.MFAE_DEDI,f.*
                      from facture f,
                           miwtfactureentete mf
                      where f.etat in ('A','P')
                      and   mf.MFAE_SOURCE='DIST'||v_district
                      and mf.mfae_rdet = (ltrim(rtrim(f.DISTRICT))||lpad(ltrim(rtrim(f.tournee)),3,'0')||
                      lpad(ltrim(rtrim(f.ORDRE)),3,'0')||to_char(f.annee)||lpad(ltrim(rtrim(f.periode)),2,'0')||'0')
                      ) loop
     V_FAC_NUM        := V_FAC_NUM +1;
      --**************************************************
      --Determiner la facture d'origine facture AS400
      v_MFAE_RDET := facture_.MFAE_RDET;
      v_date_origine := facture_.MFAE_DEDI;


       periode_ := facture_.periode;

    IF facture_.periodicite <> 'G' then
          begin
             select m3  into mois_ from param_tournee where DISTRICT=facture_.district
                                                           And TRIM =facture_.periode
                                                           And TIER = facture_.TIERS
                                                           and (TIER,SIX) in (select NTIERS,NSIXIEME from tourne
                                                                              where code=lpad(ltrim(rtrim(facture_.tournee)),3,'0'));
              exception
               when others then
                 err_code := SQLCODE;
                 err_msg  := SUBSTR(SQLERRM, 1, 200);
                    insert into prob_migration
                      (nom_table, val_ref, sql_err, type_problem,date_pro)
                    values
                      ('miwtfacture-VERSION',
                      'Tou:'||lpad(ltrim(rtrim(facture_.tournee)),3,'0')||'ORD:'||lpad(ltrim(rtrim(facture_.Ordre)),3,'0')||'TRIM :'||facture_.periode||'TIER :'||facture_.TIERS||'AA:'||facture_.ANNEE||'POL:'||lpad(ltrim(rtrim(facture_.POLICE)),5,'0'),
                         err_msg ||'-- periode','ce pas anomalie:erreur recuperation mois a partire de la table param_tournee',sysdate);

                          periode_ := facture_.periode;
                          IF periode_ = 1 THEN
                             mois_:='01';
                          ELSIF periode_ = 2 THEN
                             mois_:='04';
                          ELSIF periode_ = 3 THEN
                             mois_:='07';
                          ELSIF periode_ = 4 THEN
                             mois_:='10';
                          end if;
                          end;
        else
        mois_ := facture_.periode;
        end if;


      annee_ :=facture_.annee;
      -- suivi en temps reel du traitement
      nbr_trt := nbr_trt + 1;
      --************************************************
      V_FAC_RESTANTDU  := null;
      V_FAC_DATECALCUL := null;
      V_FAC_ABN_NUM    := null;
      V_REF_ABN        := null;

      BEGIN
      V_FAC_DATECALCUL := v_date_origine + 5;
    /*
      select (r.mrel_date+1) INTO  V_FAC_DATECALCUL from  miwtreleve r
             where r.mrel_refpdl =
              lpad(facture_.DISTRICT,2,'0')||
              lpad(ltrim(rtrim(facture_.tournee)),3,'0')||
              lpad(ltrim(rtrim(facture_.Ordre)),3,'0')||
              lpad(ltrim(rtrim(facture_.POLICE)),5,'0')
              And mrel_refpdl is not null
               and   r.annee = annee_
               and   r.periode = periode_
               And rownum=1;
               Exception  when others then
               V_FAC_DATECALCUL := date_;
         */
            end;
begin
        -- reception de l'identfiant de l'abonnement
    /*
        V_TRAIN_FACT :=  ltrim(rtrim(annee_)) ||
                         lpad(to_char(periode_),2,'0'); */
        v_ID_FACTURE:=ltrim(rtrim(facture_.DISTRICT)) ||
                      lpad(ltrim(rtrim(facture_.tournee)),3,'0') ||
                      lpad(ltrim(rtrim(facture_.ORDRE)),3,'0')||
                      to_char(annee_) ||
                    lpad(to_char(periode_),2,'0')||to_char(facture_.version);

        for ref_abn_ in (select *
                           from miwabn a
                          where substr(a.abn_refsite,1,8) = lpad(facture_.DISTRICT,2,'0') ||
                        lpad(ltrim(rtrim(facture_.tournee)),3,'0') ||
                        lpad(ltrim(rtrim(facture_.Ordre)),3,'0')) loop
          V_FAC_ABN_NUM := ref_abn_.abn_ref;
          V_REF_ABN := ref_abn_.ABN_REFPER_A;
        end loop;
        if V_FAC_ABN_NUM  is null then V_FAC_ABN_NUM := lpad(facture_.DISTRICT,2,'0') ||
                        lpad(ltrim(rtrim(facture_.tournee)),3,'0') ||
                        lpad(ltrim(rtrim(facture_.Ordre)),3,'0') ||
                        lpad(ltrim(rtrim(facture_.POLICE)),5,'0');
         end if;
         exception
          when others then
            err_code := SQLCODE;
            err_msg  := SUBSTR(SQLERRM, 1, 200);
            insert into prob_migration
              (nom_table, val_ref, sql_err, date_pro,type_problem)
            values
              ('miwtfactureAA-VERSION','Tou:'||lpad(ltrim(rtrim(facture_.tournee)),3,'0')||'ORD:'||lpad(ltrim(rtrim(facture_.Ordre)),3,'0')||'TRIM :'||facture_.periode||'TIER :'||facture_.TIERS||'AA:'||facture_.ANNEE||'POL:'||lpad(ltrim(rtrim(facture_.POLICE)),5,'0'),
                 err_msg ||'-- periode ',sysdate,' ce pas anomalie :erreur recuperation ref abonner');
                 end;

    V_TRAIN_FACT :=  'ANNEE:'||ltrim(rtrim(annee_)) ||' MOIS:'||ltrim(rtrim(periode_));
     v_mrel_ref:=null;
      begin
         select r.mrel_ref into v_mrel_ref
         from miwtreleve r
         where substr(r.mrel_refpdl,1,8)=substr(v_ID_FACTURE,1,8)
         and  TO_CHAR(r.annee)=substr(v_ID_FACTURE,9,4)
         and lpad(TO_CHAR(r.periode),2,'0')=substr(v_ID_FACTURE,13,2);
       exception when others then
            begin
             select t.mrel_ref into v_mrel_ref
             from miwtrelevet t
             where substr(t.mrel_refpdl,1,8)=substr(v_ID_FACTURE,1,8)
             and  TO_CHAR(t.annee)=substr(v_ID_FACTURE,9,4)
             and lpad(TO_CHAR(t.periode),2,'0')=substr(v_ID_FACTURE,13,2);
           exception when others then
             begin
         select r.mrel_ref into v_mrel_ref
         from miwtreleve_gc_1 r
         where substr(r.mrel_refpdl,1,8)=substr(v_ID_FACTURE,1,8)
         and TO_CHAR(r.annee)=substr(v_ID_FACTURE,9,4)
         and lpad(TO_CHAR(r.periode),2,'0')=substr(v_ID_FACTURE,13,2);
      exception when others then
           begin
               select t.mrel_ref into v_mrel_ref
               from miwtreleve_gc t
               where substr(t.mrel_refpdl,1,8)=substr(v_ID_FACTURE,1,8)
               and TO_CHAR(t.annee)=substr(v_ID_FACTURE,9,4)
               and lpad(TO_CHAR(t.periode),2,'0')=substr(v_ID_FACTURE,13,2);
          exception when others then
                    v_mrel_ref:=null;
          end ;
      end;
    end;
    end;


  -- Insertion de la facture
  if facture_.etat='A' then
        begin
        insert into miwtfactureentete
         (
            MFAE_SOURCE,--1    VARCHAR2(100)  N     Code source/origine de la facture [OBL]
            MFAE_REF   ,--2    VARCHAR2(100)  N     Identifiant unique de la facture pour la source [OBL]
            MFAE_REFTRF,--3    VARCHAR2(100)  Y     Identifiant du train de la facture
            MFAE_NUME  ,--4    NUMBER(10) Y     Numero de la facture [OBL]
            MFAE_RDET  ,--5    VARCHAR2(15) Y     RDET de la facture
            MFAE_CCMO  ,--6    VARCHAR2(1)  Y     Cle controle RDET de la facture
            MFAE_DEDI  ,--7    DATE N     Date d edition de la facture [OBL]
            MFAE_DLPAI ,--8    DATE Y     Date limite de paiement de la facture [OBL]
            MFAE_DPREL ,--9    DATE Y     Date de prelevement de la facture [OBL]
            MFAE_TOTHTE,--10   NUMBER(10,2) N     Total HT EAU de la facture [OBL]
            MFAE_TOTTVAE,--11  NUMBER(10,2) N     Total TVA EAU de la facture [OBL]
            MFAE_TOTHTA,--12   NUMBER(10,2) N     Total HT ASS de la facture [OBL]
            MFAE_TOTTVAA,--13  NUMBER(10,2) N     Total TVA ASS de la facture [OBL]
            MFAE_SOLDE ,--14   NUMBER(10,2) Y     Solde TTC de la facture
            MFAE_TYPE  ,--15   VARCHAR2(2)  N 'R'
            MFAE_REFFAEDEDU,--16  VARCHAR2(100) Y
            MFAE_REFABN,--17   VARCHAR2(100)  N     Identifiant du contrat de la facture [OBL]
            MFAE_REF_CODNIV_RELANCE,--18  VARCHAR2(100) Y     Reference Code niveau de chainde relance
            MFAE_RIB_REF  ,--19 VARCHAR2(100) Y     Reference Rib
            MFAE_RIB_ETAT ,--20 NUMBER(1) Y     Mode de payement (pr?l?vement 1 ou tip 2)
            MFAE_COMPTEAUX,--21 VARCHAR2(100) Y     Compte auxilaire GENACCOUNT associe a la facture
            MFAE_REF_ORIGINE,--22 VARCHAR2(100) Y     Facture origine
            MFAE_COMMENT  ,--23   VARCHAR2(4000)  Y     Commentaire libre Facture
            MFAE_AMOUNTTTCDEC,--24 NUMBER(17,10)  Y     Montant TTC a deduire
            VOC_MODEFACT  ,--25   VARCHAR2(10)  Y
            MFAE_REF_DEDUC,--26   VARCHAR2(100) Y
            MFAE_REFORGA  ,--27   VARCHAR2(100) Y
            MFAE_EXERCICE ,--28   NUMBER(4) Y     Exercice du role de la facture
            MFAE_NUMEROROLE,--29  NUMBER(4) Y      Numero du role pour l exercice
            MFAE_PREL     ,--30   NUMBER  Y
            MFAE_AROND    ,--31   NUMBER  Y
            mrel_ref      --30
           )
          (
            SELECT
            'DIST'||v_district,--1
            V_FAC_NUM         ,--2
            V_TRAIN_FACT      ,--3
            V_FAC_NUM         ,--4
            v_ID_FACTURE      ,--5
            MFAE_CCMO         ,--6
            V_FAC_DATECALCUL  ,--7
            V_FAC_DATECALCUL  ,--8
            V_FAC_DATECALCUL  ,--9
            -MFAE_TOTHTE      ,--10
            -MFAE_TOTTVAE     ,--11
            0                 ,--12
            0                 ,--13
            0                 ,--14
            'FA'              ,--15
            MFAE_REFFAEDEDU   ,--16
            V_FAC_ABN_NUM     ,--17
            'INCONNUE'        ,--18
            MFAE_RIB_REF      ,--19
            4                 ,--20
            'IMP_MIG'         ,--21
            MFAE_RDET         ,--22
            MFAE_COMMENT      ,--23
            MFAE_AMOUNTTTCDEC ,--24
            4                 ,--25
            NULL              ,--26
            v_district        ,--27
            annee_            ,--28
            periode_          ,--29
            MFAE_PREL         ,--30
            MFAE_AROND         ,--31
            mrel_ref
            from miwtfactureentete where
            MFAE_RDET = v_MFAE_RDET and MFAE_SOURCE='DIST'||v_district
           );
        exception
          when others then
            err_code := SQLCODE;
            err_msg  := SUBSTR(SQLERRM, 1, 200);
            insert into prob_migration
              (nom_table, val_ref, sql_err, date_pro,type_problem)
            values
              ('miwtfacture-VERSION',
               lpad(facture_.district,2,'0') ||
               lpad(ltrim(rtrim(facture_.tournee)),3,'0') ||
               lpad(ltrim(rtrim(facture_.Ordre)),3,'0') ||
               lpad(ltrim(rtrim(facture_.POLICE)),5,'0'),
               err_code || '--' || err_msg,
               sysdate,
               'erreur de confomité de type colonne');
        end;

         /* update miwtfactureentete set MFAE_REF_ORIGINE=v_ID_FACTURE  where
                  MFAE_REF = wMFAE_REF and MFAE_SOURCE='DIST'||v_district;*/
        -----------
           begin
           insert into miwtfactureligne
             (
                MFAL_SOURCE,--  VARCHAR2(100)  N      Code source/origine de la ligne [OBL]
                MFAL_REFFAE,--  VARCHAR2(100)  N      Identifiant de la facture de la ligne [OBL]
                MFAL_REFTAP,--  VARCHAR2(100)  N      Identifiant de la periode de tarif de la ligne [OBL]
                MFAL_REFART,--  VARCHAR2(100)  Y
                MFAL_LIBE  ,--  VARCHAR2(200)  Y
                MFAL_NUM   ,--  NUMBER(4)      N
                MFAL_TRAN  ,--  NUMBER(1)      N  1   Tranche de la ligne [OBL]
                MFAL_EXER  ,--  NUMBER(4)      N      Annee exercice de la ligne [OBL]
                MFAL_VOLU  ,--  NUMBER(15,3)   N      Volume facture de la ligne [OBL]
                MFAL_PU    ,--  NUMBER(12,6)   N      P.U. facture de la ligne [OBL]
                MFAL_MTHT  ,--  NUMBER(15,2)   N      Montant HT de la ligne [OBL]
                MFAL_MTVA  ,--  NUMBER(15,2)   N      Montant TVA de la ligne [OBL]
                MFAL_TTVA  ,--  NUMBER(15,2)   N      Taux de TVA de la ligne [OBL]
                MFAL_MTTC  ,--  NUMBER(15,2)   N
                MFAL_DDEBPERFAC,--  DATE       Y      Date de debut de la periode facturee de la ligne
                MFAL_DFINPERFAC,--  DATE       Y      Date de fin de la periode facturee de la ligne
                MFAL_DETAIL--  NUMBER          Y
                )
                ( select MFAL_SOURCE,--  VARCHAR2(100)  N      Code source/origine de la ligne [OBL]
                V_FAC_NUM  ,--  VARCHAR2(100)  N      Identifiant de la facture de la ligne [OBL]
                MFAL_REFTAP,--  VARCHAR2(100)  N      Identifiant de la periode de tarif de la ligne [OBL]
                MFAL_REFART,--  VARCHAR2(100)  Y
                MFAL_LIBE  ,--  VARCHAR2(200)  Y
                MFAL_NUM   ,--  NUMBER(4)  N
                MFAL_TRAN  ,--  NUMBER(1)  N  1    Tranche de la ligne [OBL]
                MFAL_EXER  ,--  NUMBER(4)  N      Annee exercice de la ligne [OBL]
                MFAL_VOLU  ,--  NUMBER(15,3)  N      Volume facture de la ligne [OBL]
                MFAL_PU    ,--  NUMBER(12,6)  N      P.U. facture de la ligne [OBL]
                MFAL_MTHT  ,--  NUMBER(15,2)  N      Montant HT de la ligne [OBL]
                MFAL_MTVA  ,--  NUMBER(15,2)  N      Montant TVA de la ligne [OBL]
                MFAL_TTVA  ,--  NUMBER(15,2)  N      Taux de TVA de la ligne [OBL]
                MFAL_MTTC  ,--  NUMBER(15,2)  N
                MFAL_DDEBPERFAC,--  DATE  Y      Date de debut de la periode facturee de la ligne
                MFAL_DFINPERFAC,--  DATE  Y      Date de fin de la periode facturee de la ligne
                MFAL_DETAIL from miwtfactureligne where  MFAL_REFFAE = wMFAE_REF
                and MFAL_SOURCE='DIST'||v_district);
           exception
          when others then
            err_code := SQLCODE;
            err_msg  := SUBSTR(SQLERRM, 1, 200);
            insert into prob_migration
              (nom_table, val_ref, sql_err, date_pro,type_problem )
            values
              ('miwtfactureligne-VERSION',
               V_FAC_NUM,
               err_code || '--' || err_msg,
               sysdate,
               'erreur de confomité de type colonne');
        end;

 else

        begin
         insert into miwtfactureentete
          (
            MFAE_SOURCE         ,--1   VARCHAR2(100)  N     Code source/origine de la facture [OBL]
            MFAE_REF            ,--2   VARCHAR2(100)  N     Identifiant unique de la facture pour la source [OBL]
            MFAE_REFTRF         ,--3   VARCHAR2(100)  Y     Identifiant du train de la facture
            MFAE_NUME           ,--4   NUMBER(10)     Y     Numero de la facture [OBL]
            MFAE_RDET           ,--5   VARCHAR2(15)   Y     RDET de la facture
            MFAE_CCMO           ,--6   VARCHAR2(1)    Y     Cle controle RDET de la facture
            MFAE_DEDI           ,--7   DATE           N     Date d edition de la facture [OBL]
            MFAE_DLPAI          ,--8   DATE           Y     Date limite de paiement de la facture [OBL]
            MFAE_DPREL          ,--9   DATE           Y     Date de prelevement de la facture [OBL]
            MFAE_TOTHTE         ,--10  NUMBER(10,2)   N     Total HT EAU de la facture [OBL]
            MFAE_TOTTVAE        ,--11  NUMBER(10,2)   N     Total TVA EAU de la facture [OBL]
            MFAE_TOTHTA         ,--12  NUMBER(10,2)   N     Total HT ASS de la facture [OBL]
            MFAE_TOTTVAA        ,--13  NUMBER(10,2)   N     Total TVA ASS de la facture [OBL]
            MFAE_SOLDE          ,--14  NUMBER(10,2)   Y     Solde TTC de la facture
            MFAE_TYPE           ,--15  VARCHAR2(2)    N 'R'
            MFAE_REFFAEDEDU     ,--16  VARCHAR2(100)  Y
            MFAE_REFABN         ,--17  VARCHAR2(100)  N     Identifiant du contrat de la facture [OBL]
            MFAE_REF_CODNIV_RELANCE,--18VARCHAR2(100) Y     Reference Code niveau de chainde relance
            MFAE_RIB_REF        ,--19  VARCHAR2(100)  Y     Reference Rib
            MFAE_RIB_ETAT       ,--20  NUMBER(1)      Y     Mode de payement (pr?l?vement 1 ou tip 2)
            MFAE_COMPTEAUX      ,--21  VARCHAR2(100)  Y     Compte auxilaire GENACCOUNT associe a la facture
            MFAE_REF_ORIGINE    ,--22  VARCHAR2(100)  Y     Facture origine
            MFAE_COMMENT        ,--23  VARCHAR2(4000) Y     Commentaire libre Facture
            MFAE_AMOUNTTTCDEC   ,--24  NUMBER(17,10)  Y     Montant TTC a deduire
            VOC_MODEFACT        ,--25  VARCHAR2(10)   Y
            MFAE_REF_DEDUC      ,--26  VARCHAR2(100)  Y
            MFAE_REFORGA        ,--27  VARCHAR2(100)  Y
            MFAE_EXERCICE       ,--28  NUMBER(4)      Y     Exercice du role de la facture
            MFAE_NUMEROROLE     ,--29  NUMBER(4)      Y     Numero du role pour l exercice
            MFAE_PREL           ,--30  NUMBER         Y
            MFAE_AROND          ,--31  NUMBER         Y
            mrel_ref            --32
         )
        values
         (
        'DIST'||v_district,--1
        V_FAC_NUM         ,--2
        V_TRAIN_FACT      ,--3
        V_FAC_NUM         ,--4
        v_ID_FACTURE      ,--5
        NULL              ,--6
        V_FAC_DATECALCUL  ,--7
        V_FAC_DATECALCUL  ,--8
        V_FAC_DATECALCUL  ,--9
        facture_.net_a_payer/1000,--10
        0                 ,--11
        0                 ,--12
        0                 ,--13
         facture_.net_a_payer/1000,--14
        decode(facture_.etat,'P','RF','O','FC','C','FHC','FC'),--15
        NULL              ,--16
        V_FAC_ABN_NUM     ,--17
        'INCONNUE'        ,--18
         null             ,--19
        4                 ,--20
        'IMP_MIG'         ,--21
        v_MFAE_RDET       ,--22
        V_REF_ABN         ,--23
        NULL              ,--24
        4                 ,--25
        NULL              ,--26
        v_district        ,--27
        annee_            ,--28
        periode_          ,--29
        1                 ,--30
        0                 ,--31
        v_mrel_ref
        );
        exception
          when others then
            err_code := SQLCODE;
            err_msg  := SUBSTR(SQLERRM, 1, 200);
            insert into prob_migration
              (nom_table, val_ref, sql_err, date_pro,type_problem)
            values
              ('miwtfacture-VERSION',
               lpad(facture_.district,2,'0') ||
               lpad(ltrim(rtrim(facture_.tournee)),3,'0') ||
               lpad(ltrim(rtrim(facture_.Ordre)),3,'0') ||
               lpad(ltrim(rtrim(facture_.POLICE)),5,'0'),
               err_code || '--' || err_msg,
               sysdate,
               'erreur de confomité de type colonne'
               );
        end;


     -----------update mfae_reftrf
/*   update miwtfactureentete e  set e.mfae_reftrf =(select m.mfae_reftrf
   from miwtfactureentete m
   where m.mfae_rdet=e.mfae_ref_origine )
   where e.mfae_ref_origine is not null ;*/
     -----------
end if;

--------------update miwtreleve_histocpt

          select count(*) into  nbr_trt from  miwtreleve_histocpt
             where mrel_refpdl =
              lpad(facture_.DISTRICT,2,'0')||
              lpad(ltrim(rtrim(facture_.tournee)),3,'0')||
              lpad(ltrim(rtrim(facture_.Ordre)),3,'0')||
              lpad(ltrim(rtrim(facture_.POLICE)),5,'0')
              And mrel_refpdl is not null
               and   to_number(trim(annee) )= annee_
               and   to_number(periode) = periode_
               And rownum=1;
       if nbr_trt <> 0 then
        update  miwtreleve_histocpt  set mrel_fact1 = v_ID_FACTURE
             where mrel_refpdl =
              lpad(facture_.DISTRICT,2,'0')||
              lpad(ltrim(rtrim(facture_.tournee)),3,'0')||
              lpad(ltrim(rtrim(facture_.Ordre)),3,'0')||
              lpad(ltrim(rtrim(facture_.POLICE)),5,'0')
              And mrel_refpdl is not null
              and mrel_fact1 is null
               and   to_number(trim(annee)) = annee_
               and   to_number(periode) = periode_
               And rownum=1;
         end if;

         commit;

    end loop;
    insert into prob_migration (nom_table)values(SYSTIMESTAMP||'   END MIWT_FACTURE_VERSION');
        commit;

end;


--******************************************************************
procedure MIWT_FACTURE_IMPAYEE (v_district in varchar2) is
--********************************* TRAITEMENT DES FACTURES  A PARTIR TABLE IMPAYEE
    err_code         varchar2(200);
    err_msg          varchar2(200);
    V_FAC_NUM        number;
    V_FAC_RESTANTDU  number;
    V_FAC_DATECALCUL date;
    V_FAC_DATEDLPAI  date;
    V_FAC_ABN_NUM    number(20);
    V_TRAIN_FACT     varchar2(200);
    V_REF_ABN        varchar2(200);
    v_mrel_ref       varchar2(200);
    nbr_trt          number := 0;
    v_ID_FACTURE     varchar2(20);
    v_ID_FACTURE_orig varchar2(20);
    annee_           number(4);
    periode_         number;
    version          number(1) := 1;
    mois_            number;
    date_            date;

   begin
execute immediate 'alter session set nls_date_format = ''dd/mm/yyyy''';
execute immediate 'alter session set NLS_NUMERIC_CHARACTERS = '',.''';
    --**************************************************
   delete prob_migration where
              nom_table in
              ('miwtfacture','SEQ_RELEVE','miwtfactureAA-imp');
  insert into prob_migration (nom_table)values(SYSTIMESTAMP||'   START MIWT_FACTURE_impayee');
    commit;
     --**************************************************
    -- reception de la liste des releves
    select max(nvl(to_number(MFAE_REF),0)) into  V_FAC_NUM
    from miwtfactureentete
    where MFAE_SOURCE = 'DIST'||v_district;

       if V_FAC_NUM is null then
             V_FAC_NUM        := 0;    end if;
    for facture_ in (select * from  impayees_part p where
                      not exists (select 'X' from miwtfactureentete where MFAE_SOURCE='DIST'||v_district
                      --And MFAE_REFTRF = to_char(annee)||lpad(ltrim(rtrim(periode)),2,'0')
                      and mfae_rdet = (ltrim(rtrim(DISTRICT))||lpad(ltrim(rtrim(tournee)),3,'0')||
                      lpad(ltrim(rtrim(ORDRE)),3,'0')||to_char(annee)||lpad(ltrim(rtrim(p.mois)),2,'0')||0))
                      and  trim(net)<>trim(mtpaye)) loop
     V_FAC_NUM        := V_FAC_NUM +1;
      --**************************************************
       periode_ := facture_.mois;
       annee_ :=facture_.ANNEE;
      -- suivi en temps reel du traitement
      nbr_trt := nbr_trt + 1;
      --************************************************
      V_FAC_RESTANTDU  := null;
      V_FAC_DATECALCUL := null;
      V_FAC_ABN_NUM    := null;
      V_REF_ABN        := null;
-------------------
 select last_day(to_date('01'||lpad(facture_.mois,2,0)||facture_.annee,'ddmmyy')) into date_
                              from dual;
 ------------------
   BEGIN

      select (r.mrel_date+1) INTO  V_FAC_DATECALCUL from  miwtreleve r
             where r.mrel_refpdl =
              lpad(facture_.DISTRICT,2,'0')||
              lpad(ltrim(rtrim(facture_.tournee)),3,'0')||
              lpad(ltrim(rtrim(facture_.ORDRE)),3,'0')||
              lpad(ltrim(rtrim(facture_.POLICE)),5,'0')
              And mrel_refpdl is not null
               and   r.annee = annee_
               and   r.periode = periode_
               And rownum=1;
               Exception  when others then
               V_FAC_DATECALCUL := date_;
            end;
begin
        -- reception de l'identfiant de l'abonnement
        /*
        V_TRAIN_FACT :=  ltrim(rtrim(annee_)) ||
                         lpad(to_char(periode_),2,'0');*/
        v_ID_FACTURE:=ltrim(rtrim(facture_.DISTRICT)) ||
                      lpad(ltrim(rtrim(facture_.tournee)),3,'0') ||
                      lpad(ltrim(rtrim(facture_.ORDRE)),3,'0')||
                      to_char(annee_) ||
                    lpad(to_char(periode_),2,'0')||'0';


    V_TRAIN_FACT :=  'ANNEE:'||ltrim(rtrim(annee_)) ||' MOIS:'||ltrim(rtrim(periode_));

        for ref_abn_ in (select *
                           from miwabn a
                          where substr(a.abn_refsite,1,8) = lpad(facture_.DISTRICT,2,'0') ||
                                lpad(ltrim(rtrim(facture_.tournee)),3,'0') ||
                                lpad(ltrim(rtrim(facture_.ordre)),3,'0')) loop
          V_FAC_ABN_NUM := ref_abn_.abn_ref;
          V_REF_ABN := ref_abn_.ABN_REFPER_A;
        end loop;

        if V_FAC_ABN_NUM  is null then
           V_FAC_ABN_NUM := lpad(facture_.DISTRICT,2,'0') ||
                        lpad(ltrim(rtrim(facture_.tournee)),3,'0') ||
                        lpad(ltrim(rtrim(facture_.ordre)),3,'0') ||
                        lpad(ltrim(rtrim(facture_.police)),5,'0');
         end if;
         exception
          when others then
            err_code := SQLCODE;
            err_msg  := SUBSTR(SQLERRM, 1, 200);
            insert into prob_migration
              (nom_table, val_ref, sql_err, date_pro,type_problem)
            values
              ('miwtfactureAA-imp','Tou:'||lpad(ltrim(rtrim(facture_.tournee)),3,'0')||'ORD:'||facture_.Ordre||'TRIM :'||facture_.mois||'AA:'||facture_.ANNEE||'POL:'||facture_.police,
                 err_msg ||'-- periode ',sysdate,'ce pas anomalie erreur recuperation refrenece abonnement');
                 end;

          v_mrel_ref:=null;
      begin
         select r.mrel_ref into v_mrel_ref
         from miwtreleve r
         where substr(r.mrel_refpdl,1,8)=substr(v_ID_FACTURE,1,8)
         and  TO_CHAR(r.annee)=substr(v_ID_FACTURE,9,4)
         and lpad(TO_CHAR(r.periode),2,'0')=substr(v_ID_FACTURE,13,2);
       exception when others then
            begin
             select t.mrel_ref into v_mrel_ref
             from miwtrelevet t
             where substr(t.mrel_refpdl,1,8)=substr(v_ID_FACTURE,1,8)
             and  TO_CHAR(t.annee)=substr(v_ID_FACTURE,9,4)
             and lpad(TO_CHAR(t.periode),2,'0')=substr(v_ID_FACTURE,13,2);
           exception when others then
             begin
         select r.mrel_ref into v_mrel_ref
         from miwtreleve_gc_1 r
         where substr(r.mrel_refpdl,1,8)=substr(v_ID_FACTURE,1,8)
         and TO_CHAR(r.annee)=substr(v_ID_FACTURE,9,4)
         and lpad(TO_CHAR(r.periode),2,'0')=substr(v_ID_FACTURE,13,2);
      exception when others then
           begin
               select t.mrel_ref into v_mrel_ref
               from miwtreleve_gc t
               where substr(t.mrel_refpdl,1,8)=substr(v_ID_FACTURE,1,8)
               and TO_CHAR(t.annee)=substr(v_ID_FACTURE,9,4)
               and lpad(TO_CHAR(t.periode),2,'0')=substr(v_ID_FACTURE,13,2);
          exception when others then
               v_mrel_ref:=null;
          end ;
      end;
    end;
    end;

          V_FAC_DATEDLPAI:= V_FAC_DATECALCUL +25;
        begin
         insert into miwtfactureentete
        (
          MFAE_SOURCE            ,--1   VARCHAR2(100) N     Code source/origine de la facture [OBL]
          MFAE_REF               ,--2   VARCHAR2(100) N     Identifiant unique de la facture pour la source [OBL]
          MFAE_REFTRF            ,--3   VARCHAR2(100) Y     Identifiant du train de la facture
          MFAE_NUME              ,--4   NUMBER(10)    Y     Numero de la facture [OBL]
          MFAE_RDET              ,--5   VARCHAR2(15)  Y     RDET de la facture
          MFAE_CCMO              ,--6   VARCHAR2(1)   Y     Cle controle RDET de la facture
          MFAE_DEDI              ,--7   DATE          N     Date d edition de la facture [OBL]
          MFAE_DLPAI             ,--8   DATE          Y     Date limite de paiement de la facture [OBL]
          MFAE_DPREL             ,--9   DATE          Y     Date de prelevement de la facture [OBL]
          MFAE_TOTHTE            ,--10  NUMBER(10,2)  N     Total HT EAU de la facture [OBL]
          MFAE_TOTTVAE           ,--11  NUMBER(10,2)  N     Total TVA EAU de la facture [OBL]
          MFAE_TOTHTA            ,--12  NUMBER(10,2)  N     Total HT ASS de la facture [OBL]
          MFAE_TOTTVAA           ,--13  NUMBER(10,2)  N     Total TVA ASS de la facture [OBL]
          MFAE_SOLDE             ,--14  NUMBER(10,2)  Y     Solde TTC de la facture
          MFAE_TYPE              ,--15  VARCHAR2(2)   N 'R'
          MFAE_REFFAEDEDU        ,--16  VARCHAR2(100) Y
          MFAE_REFABN            ,--17  VARCHAR2(100) N     Identifiant du contrat de la facture [OBL]
          MFAE_REF_CODNIV_RELANCE,--18  VARCHAR2(100) Y     Reference Code niveau de chainde relance
          MFAE_RIB_REF           ,--19  VARCHAR2(100) Y     Reference Rib
          MFAE_RIB_ETAT          ,--20  NUMBER(1)     Y     Mode de payement (pr?l?vement 1 ou tip 2)
          MFAE_COMPTEAUX         ,--21  VARCHAR2(100) Y     Compte auxilaire GENACCOUNT associe a la facture
          MFAE_REF_ORIGINE       ,--22  VARCHAR2(100) Y     Facture origine
          MFAE_COMMENT           ,--23  VARCHAR2(4000)Y     Commentaire libre Facture
          MFAE_AMOUNTTTCDEC      ,--24  NUMBER(17,10) Y     Montant TTC a deduire
          VOC_MODEFACT           ,--25  VARCHAR2(10)  Y
          MFAE_REF_DEDUC         ,--26  VARCHAR2(100) Y
          MFAE_REFORGA           ,--27  VARCHAR2(100) Y
          MFAE_EXERCICE          ,--28  NUMBER(4)     Y     Exercice du role de la facture
          MFAE_NUMEROROLE        ,--29  NUMBER(4)     Y     Numero du role pour l exercice
          MFAE_PREL              ,--30  NUMBER        Y
          MFAE_AROND             ,--31  NUMBER        Y
          mrel_ref                --32
        )
       values
       (
        'DIST'||v_district,--1
        V_FAC_NUM         ,--2
        V_TRAIN_FACT      ,--3
        V_FAC_NUM         ,--4
        v_ID_FACTURE      ,--5
        NULL              ,--6
        V_FAC_DATECALCUL  ,--7
        V_FAC_DATEDLPAI  ,--8
        V_FAC_DATECALCUL  ,--9
        (to_number(trim(facture_.net)))/1000,--10
        0                 ,--11
        0                 ,--12
        0                 ,--13
        (to_number(trim(facture_.net)))/1000 ,--14
        'FC'              ,--15
        NULL              ,--16
        V_FAC_ABN_NUM     ,--17
        'INCONNUE'        ,--18
         null             ,--19
        4                 ,--20
        'IMP_MIG'         ,--21
        null              ,--22
        V_REF_ABN         ,--23
        NULL              ,--24
        4                 ,--25
        NULL              ,--26
        v_district        ,--27
        annee_            ,--28
        periode_          ,--29
        1                 ,--30
        0                 ,--31
        v_mrel_ref         --32
        );
        exception
          when others then
            err_code := SQLCODE;
            err_msg  := SUBSTR(SQLERRM, 1, 200);
            insert into prob_migration
              (nom_table, val_ref, sql_err, date_pro,type_problem)
            values
              ('miwtfacture_impayee',
               lpad(facture_.district,2,'0') ||
               lpad(ltrim(rtrim(facture_.tournee)),3,'0') ||
               lpad(ltrim(rtrim(facture_.ordre)),3,'0') ||
               lpad(ltrim(rtrim(facture_.police)),5,'0'),
               err_code || '--' || err_msg,
               sysdate,
               'erreur de confomité de type colonne');
        end;
        -----------
          select count(*) into  nbr_trt from  miwtreleve
             where mrel_refpdl =
              lpad(facture_.DISTRICT,2,'0')||
              lpad(ltrim(rtrim(facture_.tournee)),3,'0')||
              lpad(ltrim(rtrim(facture_.ordre)),3,'0')||
              lpad(ltrim(rtrim(facture_.police)),5,'0')
              And mrel_refpdl is not null
               and   annee = annee_
               and   periode = periode_
               And rownum=1;

       if nbr_trt <> 0 then
        update  miwtreleve  set mrel_fact1 = v_ID_FACTURE
             where mrel_refpdl =
              lpad(facture_.DISTRICT,2,'0')||
              lpad(ltrim(rtrim(facture_.tournee)),3,'0')||
              lpad(ltrim(rtrim(facture_.ordre)),3,'0')||
              lpad(ltrim(rtrim(facture_.police)),5,'0')
              And mrel_refpdl is not null
               and   annee = annee_
               and   periode = periode_
               And rownum=1;
                 end if;

        commit;

insert into miwtfactureligne
               (
                MFAL_SOURCE   ,--1  VARCHAR2(100)  N  Code source/origine de la ligne [OBL]
                MFAL_REFFAE   ,--2  VARCHAR2(100)  N  Identifiant de la facture de la ligne [OBL]
                MFAL_REFTAP   ,--3  VARCHAR2(100)  N  Identifiant de la periode de tarif de la ligne [OBL]
                MFAL_REFART   ,--4  VARCHAR2(100)  Y
                MFAL_LIBE     ,--5  VARCHAR2(200)  Y
                MFAL_NUM      ,--6  NUMBER(4)      N
                MFAL_TRAN     ,--7  NUMBER(1)      N  Tranche de la ligne [OBL]
                MFAL_EXER     ,--8  NUMBER(4)      N  Annee exercice de la ligne [OBL]
                MFAL_VOLU     ,--9  NUMBER(15,3)   N  Volume facture de la ligne [OBL]
                MFAL_PU       ,--10 NUMBER(12,6)   N  P.U. facture de la ligne [OBL]
                MFAL_MTHT     ,--11 NUMBER(15,2)   N  Montant HT de la ligne [OBL]
                MFAL_MTVA     ,--12 NUMBER(15,2)   N  Montant TVA de la ligne [OBL]
                MFAL_TTVA     ,--13 NUMBER(15,2)   N  Taux de TVA de la ligne [OBL]
                MFAL_MTTC     ,--14 NUMBER(15,2)   N
                MFAL_DDEBPERFAC ,--15 DATE         Y  Date de debut de la periode facturee de la ligne
                MFAL_DFINPERFAC ,--16 DATE         Y  Date de fin de la periode facturee de la ligne
                MFAL_DETAIL      --17 NUMBER       Y
                )
                values
               (
               'DIST'||v_district          ,--1
                V_FAC_NUM                  ,--2
                1                          ,--3
                'REPRISE-SONEDE'           ,--4
                'Article de reprise SONEDE',--5
                1                          ,--6
                1                          ,--7
                annee_                     ,--8
                0                          ,--9
                0                          ,--10
                (to_number(trim(facture_.net))-to_number(trim(facture_.mtonas)))/1000 ,--11---
                0                          ,--12
                0                          ,--13
                (to_number(trim(facture_.net))-to_number(trim(facture_.mtonas)))/1000 ,--14
                null                       ,--15
                date_                      ,--16
                null                        --17
                 );

insert into miwtfactureligne
               (
                MFAL_SOURCE   ,--1  VARCHAR2(100)  N      Code source/origine de la ligne [OBL]
                MFAL_REFFAE   ,--2  VARCHAR2(100)  N      Identifiant de la facture de la ligne [OBL]
                MFAL_REFTAP   ,--3  VARCHAR2(100)  N      Identifiant de la periode de tarif de la ligne [OBL]
                MFAL_REFART   ,--4  VARCHAR2(100)  Y
                MFAL_LIBE     ,--5  VARCHAR2(200)  Y
                MFAL_NUM      ,--6  NUMBER(4)      N
                MFAL_TRAN     ,--7  NUMBER(1)      N  1   Tranche de la ligne [OBL]
                MFAL_EXER     ,--8  NUMBER(4)      N      Annee exercice de la ligne [OBL]
                MFAL_VOLU     ,--9  NUMBER(15,3)   N      Volume facture de la ligne [OBL]
                MFAL_PU       ,--10 NUMBER(12,6)   N      P.U. facture de la ligne [OBL]
                MFAL_MTHT     ,--11 NUMBER(15,2)   N      Montant HT de la ligne [OBL]
                MFAL_MTVA     ,--12 NUMBER(15,2)   N      Montant TVA de la ligne [OBL]
                MFAL_TTVA     ,--13 NUMBER(15,2)   N      Taux de TVA de la ligne [OBL]
                MFAL_MTTC     ,--14 NUMBER(15,2)   N
                MFAL_DDEBPERFAC ,--15 DATE         Y      Date de debut de la periode facturee de la ligne
                MFAL_DFINPERFAC ,--16 DATE         Y      Date de fin de la periode facturee de la ligne
                MFAL_DETAIL    --17 NUMBER         Y
                )
                values
               (
                'DIST'||v_district       ,--1
                V_FAC_NUM                ,--2
                2                        ,--3
                'REPRISE-ONAS'           ,--4
                'Article de reprise ONAS',--5
                2                        ,--6
                1                        ,--7
                annee_                   ,--8
                0                        ,--9 ---------
                0                        ,--10
               (to_number(trim(facture_.mtonas))/1000),--11---------
                0                        ,--12
                0                        ,--13
                (to_number(trim(facture_.mtonas))/1000),--14
                null                     ,--15
                date_                    ,--16
                null                      --17
                 );


commit;

    end loop;



    --*************************************************************************
    -------------------------
    -------------------------IMPAYEEEEEEEEEEEEE GC-------------------------------
    ------------------------
    --*************************************************************************



       for facture_ in (select * from impayees_gc  where
                      not exists (select 'X' from miwtfactureentete where MFAE_SOURCE='DIST'||v_district
                      --And MFAE_REFTRF = to_char(annee)||lpad(ltrim(rtrim(periode)),2,'0')
                      and mfae_rdet = (ltrim(rtrim(DISTRICT))||lpad(ltrim(rtrim(tournee)),3,'0')||
                      lpad(ltrim(rtrim(ORDRE)),3,'0')||to_char(annee)||lpad(ltrim(rtrim(mois)),2,'0')||0))
                      and trim(net)<>trim(mtpaye)  ) loop

     V_FAC_NUM        := V_FAC_NUM +1;
      --**************************************************
       periode_ := facture_.mois;
       annee_ :=facture_.ANNEE;
      -- suivi en temps reel du traitement
      nbr_trt := nbr_trt + 1;
      --************************************************
      V_FAC_RESTANTDU  := null;
      V_FAC_DATECALCUL := null;
      V_FAC_ABN_NUM    := null;
      V_REF_ABN        := null;
-------------------
 select last_day(to_date('01'||lpad(facture_.mois,2,0)||facture_.annee,'ddmmyy'))
 into date_
from dual;
 ------------------
   BEGIN

      select (r.mrel_date+1) INTO  V_FAC_DATECALCUL from  miwtreleve r
             where r.mrel_refpdl =
              lpad(facture_.DISTRICT,2,'0')||
              lpad(ltrim(rtrim(facture_.tournee)),3,'0')||
              lpad(ltrim(rtrim(facture_.ORDRE)),3,'0')||
              lpad(ltrim(rtrim(facture_.POLICE)),5,'0')
              And mrel_refpdl is not null
               and   r.annee = annee_
               and   r.periode = periode_
               And rownum=1;
               Exception  when others then
               V_FAC_DATECALCUL := date_;
            end;
begin
        -- reception de l'identfiant de l'abonnement
        /*
        V_TRAIN_FACT :=  ltrim(rtrim(annee_)) ||
                         lpad(to_char(periode_),2,'0');*/
        v_ID_FACTURE:=ltrim(rtrim(facture_.DISTRICT)) ||
                      lpad(ltrim(rtrim(facture_.tournee)),3,'0') ||
                      lpad(ltrim(rtrim(facture_.ORDRE)),3,'0')||
                      to_char(annee_) ||
                    lpad(to_char(periode_),2,'0')||'0';


    V_TRAIN_FACT :=  'ANNEE:'||ltrim(rtrim(annee_)) ||' MOIS:'||ltrim(rtrim(periode_));

        for ref_abn_ in (select *
                           from miwabn a
                          where substr(a.abn_refsite,1,8) = lpad(facture_.DISTRICT,2,'0') ||
                        lpad(ltrim(rtrim(facture_.tournee)),3,'0') ||
                        lpad(ltrim(rtrim(facture_.ordre)),3,'0')) loop

          V_FAC_ABN_NUM := ref_abn_.abn_ref;
          V_REF_ABN := ref_abn_.ABN_REFPER_A;
        end loop;

        if V_FAC_ABN_NUM  is null then
          V_FAC_ABN_NUM := lpad(facture_.DISTRICT,2,'0') ||
           lpad(ltrim(rtrim(facture_.tournee)),3,'0') ||
           lpad(ltrim(rtrim(facture_.ordre)),3,'0') ||
           lpad(ltrim(rtrim(facture_.police)),5,'0');
         end if;
         exception
          when others then
            err_code := SQLCODE;
            err_msg  := SUBSTR(SQLERRM, 1, 200);
            insert into prob_migration
              (nom_table, val_ref, sql_err, date_pro,type_problem)
            values
              ('miwtfactureAA-imp','Tou:'||lpad(ltrim(rtrim(facture_.tournee)),3,'0')||'ORD:'||facture_.Ordre||'TRIM :'||facture_.mois||'AA:'||facture_.ANNEE||'POL:'||facture_.police,
                 err_msg ||'-- periode ',sysdate,'ce pas anomalie erreur recuperation refrenece abonnement');
                 end;

          v_mrel_ref:=null;
      begin
         select r.mrel_ref into v_mrel_ref
         from miwtreleve r
         where substr(r.mrel_refpdl,1,8)=substr(v_ID_FACTURE,1,8)
         and  TO_CHAR(r.annee)=substr(v_ID_FACTURE,9,4)
         and lpad(TO_CHAR(r.periode),2,'0')=substr(v_ID_FACTURE,13,2);
       exception when others then
            begin
             select t.mrel_ref into v_mrel_ref
             from miwtrelevet t
             where substr(t.mrel_refpdl,1,8)=substr(v_ID_FACTURE,1,8)
             and  TO_CHAR(t.annee)=substr(v_ID_FACTURE,9,4)
             and lpad(TO_CHAR(t.periode),2,'0')=substr(v_ID_FACTURE,13,2);
           exception when others then
             begin
           select r.mrel_ref into v_mrel_ref
           from miwtreleve_gc_1 r
           where substr(r.mrel_refpdl,1,8)=substr(v_ID_FACTURE,1,8)
           and TO_CHAR(r.annee)=substr(v_ID_FACTURE,9,4)
           and lpad(TO_CHAR(r.periode),2,'0')=substr(v_ID_FACTURE,13,2);
      exception when others then
           begin
               select t.mrel_ref into v_mrel_ref
               from miwtreleve_gc t
               where substr(t.mrel_refpdl,1,8)=substr(v_ID_FACTURE,1,8)
               and TO_CHAR(t.annee)=substr(v_ID_FACTURE,9,4)
               and lpad(TO_CHAR(t.periode),2,'0')=substr(v_ID_FACTURE,13,2);
          exception when others then
                    v_mrel_ref:=null;
          end ;
      end;
    end;
    end;

          V_FAC_DATEDLPAI:= V_FAC_DATECALCUL +25;

        begin
         insert into miwtfactureentete
        (
        MFAE_SOURCE            ,--1   VARCHAR2(100) N     Code source/origine de la facture [OBL]
        MFAE_REF               ,--2   VARCHAR2(100) N     Identifiant unique de la facture pour la source [OBL]
        MFAE_REFTRF            ,--3   VARCHAR2(100) Y     Identifiant du train de la facture
        MFAE_NUME              ,--4   NUMBER(10)    Y     Numero de la facture [OBL]
        MFAE_RDET              ,--5   VARCHAR2(15)  Y     RDET de la facture
        MFAE_CCMO              ,--6   VARCHAR2(1)   Y     Cle controle RDET de la facture
        MFAE_DEDI              ,--7   DATE          N     Date d edition de la facture [OBL]
        MFAE_DLPAI             ,--8   DATE          Y     Date limite de paiement de la facture [OBL]
        MFAE_DPREL             ,--9   DATE          Y     Date de prelevement de la facture [OBL]
        MFAE_TOTHTE            ,--10  NUMBER(10,2)  N     Total HT EAU de la facture [OBL]
        MFAE_TOTTVAE           ,--11  NUMBER(10,2)  N     Total TVA EAU de la facture [OBL]
        MFAE_TOTHTA            ,--12  NUMBER(10,2)  N     Total HT ASS de la facture [OBL]
        MFAE_TOTTVAA           ,--13  NUMBER(10,2)  N     Total TVA ASS de la facture [OBL]
        MFAE_SOLDE             ,--14  NUMBER(10,2)  Y     Solde TTC de la facture
        MFAE_TYPE              ,--15  VARCHAR2(2)   N 'R'
        MFAE_REFFAEDEDU        ,--16  VARCHAR2(100) Y
        MFAE_REFABN            ,--17  VARCHAR2(100) N     Identifiant du contrat de la facture [OBL]
        MFAE_REF_CODNIV_RELANCE,--18  VARCHAR2(100) Y     Reference Code niveau de chainde relance
        MFAE_RIB_REF           ,--19  VARCHAR2(100) Y     Reference Rib
        MFAE_RIB_ETAT          ,--20  NUMBER(1)     Y     Mode de payement (pr?l?vement 1 ou tip 2)
        MFAE_COMPTEAUX         ,--21  VARCHAR2(100) Y     Compte auxilaire GENACCOUNT associe a la facture
        MFAE_REF_ORIGINE       ,--22  VARCHAR2(100) Y     Facture origine
        MFAE_COMMENT           ,--23  VARCHAR2(4000)Y     Commentaire libre Facture
        MFAE_AMOUNTTTCDEC      ,--24  NUMBER(17,10) Y     Montant TTC a deduire
        VOC_MODEFACT           ,--25  VARCHAR2(10)  Y
        MFAE_REF_DEDUC         ,--26  VARCHAR2(100) Y
        MFAE_REFORGA           ,--27  VARCHAR2(100) Y
        MFAE_EXERCICE          ,--28  NUMBER(4)     Y     Exercice du role de la facture
        MFAE_NUMEROROLE        ,--29  NUMBER(4)     Y     Numero du role pour l exercice
        MFAE_PREL              ,--30  NUMBER        Y
        MFAE_AROND             ,--31  NUMBER        Y
        mrel_ref                --32
        )
       values
       (
        'DIST'||v_district,--1
        V_FAC_NUM         ,--2
        V_TRAIN_FACT      ,--3
        V_FAC_NUM         ,--4
        v_ID_FACTURE      ,--5
        NULL              ,--6
        V_FAC_DATECALCUL  ,--7
        V_FAC_DATEDLPAI   ,--8
        V_FAC_DATECALCUL  ,--9
        (to_number(trim(facture_.net)))/1000 ,--10
        0                 ,--11
        0                 ,--12
        0                 ,--13
        (to_number(trim(facture_.net)))/1000 ,--14
        'FC'              ,--15
        NULL              ,--16
        V_FAC_ABN_NUM     ,--17
        'INCONNUE'        ,--18
         null             ,--19
        4                 ,--20
        'IMP_MIG'         ,--21
        null              ,--22
        V_REF_ABN         ,--23
        NULL              ,--24
        4                 ,--25
        NULL              ,--26
        v_district        ,--27
        annee_            ,--28
        periode_          ,--29
        1                 ,--30
        0                 ,--31
        v_mrel_ref         --32
        );
        exception
          when others then
            err_code := SQLCODE;
            err_msg  := SUBSTR(SQLERRM, 1, 200);
            insert into prob_migration
              (nom_table, val_ref, sql_err, date_pro,type_problem)
            values
              ('miwtfacture_impayee',
               lpad(facture_.district,2,'0') ||
               lpad(ltrim(rtrim(facture_.tournee)),3,'0') ||
               lpad(ltrim(rtrim(facture_.ordre)),3,'0') ||
               lpad(ltrim(rtrim(facture_.police)),5,'0'),
               err_code || '--' || err_msg,
               sysdate,'erreur de confomité de type colonne');
        end;
        -----------


          select count(*) into  nbr_trt from  miwtreleve
             where mrel_refpdl =
              lpad(facture_.DISTRICT,2,'0')||
              lpad(ltrim(rtrim(facture_.tournee)),3,'0')||
              lpad(ltrim(rtrim(facture_.ordre)),3,'0')||
              lpad(ltrim(rtrim(facture_.police)),5,'0')
              And mrel_refpdl is not null
               and   annee = annee_
               and   periode = periode_
               And rownum=1;

       if nbr_trt <> 0 then
        update  miwtreleve  set mrel_fact1 = v_ID_FACTURE
             where mrel_refpdl =
              lpad(facture_.DISTRICT,2,'0')||
              lpad(ltrim(rtrim(facture_.tournee)),3,'0')||
              lpad(ltrim(rtrim(facture_.ordre)),3,'0')||
              lpad(ltrim(rtrim(facture_.police)),5,'0')
              And mrel_refpdl is not null
               and   annee = annee_
               and   periode = periode_
               And rownum=1;
                 end if;

        commit;


insert into miwtfactureligne
               (
                MFAL_SOURCE   ,--1  VARCHAR2(100)  N  Code source/origine de la ligne [OBL]
                MFAL_REFFAE   ,--2  VARCHAR2(100)  N  Identifiant de la facture de la ligne [OBL]
                MFAL_REFTAP   ,--3  VARCHAR2(100)  N  Identifiant de la periode de tarif de la ligne [OBL]
                MFAL_REFART   ,--4  VARCHAR2(100)  Y
                MFAL_LIBE     ,--5  VARCHAR2(200)  Y
                MFAL_NUM      ,--6  NUMBER(4)      N
                MFAL_TRAN     ,--7  NUMBER(1)      N  Tranche de la ligne [OBL]
                MFAL_EXER     ,--8  NUMBER(4)      N  Annee exercice de la ligne [OBL]
                MFAL_VOLU     ,--9  NUMBER(15,3)   N  Volume facture de la ligne [OBL]
                MFAL_PU       ,--10 NUMBER(12,6)   N  P.U. facture de la ligne [OBL]
                MFAL_MTHT     ,--11 NUMBER(15,2)   N  Montant HT de la ligne [OBL]
                MFAL_MTVA     ,--12 NUMBER(15,2)   N  Montant TVA de la ligne [OBL]
                MFAL_TTVA     ,--13 NUMBER(15,2)   N  Taux de TVA de la ligne [OBL]
                MFAL_MTTC     ,--14 NUMBER(15,2)   N
                MFAL_DDEBPERFAC ,--15 DATE           Y  Date de debut de la periode facturee de la ligne
                MFAL_DFINPERFAC ,--16 DATE           Y  Date de fin de la periode facturee de la ligne
                MFAL_DETAIL      --17 NUMBER         Y
                )
                values
               (
               'DIST'||v_district          ,--1
                V_FAC_NUM                  ,--2
                1                          ,--3
                'REPRISE-SONEDE'           ,--4
                'Article de reprise SONEDE',--5
                1                          ,--6
                1                          ,--7
                annee_                     ,--8
                0                          ,--9
                0                          ,--10
                (to_number(trim(facture_.net))-to_number(trim(facture_.mtonas)))/1000 ,--11----------
                0                          ,--12
                0                          ,--13
                (to_number(trim(facture_.net))-to_number(trim(facture_.mtonas)))/1000 ,--14
                null                       ,--15
                date_                      ,--16
                null                        --17
                 );

insert into miwtfactureligne
               (
                MFAL_SOURCE   ,--1  VARCHAR2(100)  N      Code source/origine de la ligne [OBL]
                MFAL_REFFAE   ,--2  VARCHAR2(100)  N      Identifiant de la facture de la ligne [OBL]
                MFAL_REFTAP   ,--3  VARCHAR2(100)  N      Identifiant de la periode de tarif de la ligne [OBL]
                MFAL_REFART   ,--4  VARCHAR2(100)  Y
                MFAL_LIBE     ,--5  VARCHAR2(200)  Y
                MFAL_NUM      ,--6  NUMBER(4)      N
                MFAL_TRAN     ,--7  NUMBER(1)      N  1   Tranche de la ligne [OBL]
                MFAL_EXER     ,--8  NUMBER(4)      N      Annee exercice de la ligne [OBL]
                MFAL_VOLU     ,--9  NUMBER(15,3)   N      Volume facture de la ligne [OBL]
                MFAL_PU       ,--10 NUMBER(12,6)   N      P.U. facture de la ligne [OBL]
                MFAL_MTHT     ,--11 NUMBER(15,2)   N      Montant HT de la ligne [OBL]
                MFAL_MTVA     ,--12 NUMBER(15,2)   N      Montant TVA de la ligne [OBL]
                MFAL_TTVA     ,--13 NUMBER(15,2)   N      Taux de TVA de la ligne [OBL]
                MFAL_MTTC     ,--14 NUMBER(15,2)   N
                MFAL_DDEBPERFAC ,--15 DATE           Y      Date de debut de la periode facturee de la ligne
                MFAL_DFINPERFAC ,--16 DATE           Y      Date de fin de la periode facturee de la ligne
                MFAL_DETAIL    --17 NUMBER         Y
                )
                values
               (
                'DIST'||v_district       ,--1
                V_FAC_NUM                ,--2
                2                        ,--3
                'REPRISE-ONAS'           ,--4
                'Article de reprise ONAS',--5
                2                        ,--6
                1                        ,--7
                annee_                   ,--8
                0                        ,--9 ---------
                0                        ,--10
               (to_number(trim(facture_.mtonas))/1000),--11---------
                0                        ,--12
                0                        ,--13
                (to_number(trim(facture_.mtonas))/1000),--14
                null                     ,--15
                date_                    ,--16
                null                      --17
                 );



commit;


    end loop;


insert into prob_migration (nom_table)values(SYSTIMESTAMP||'   END MIWT_FACTURE_impayee');
commit;
end;

end PCK_MIG_FACTURE_new;
/


spool off
