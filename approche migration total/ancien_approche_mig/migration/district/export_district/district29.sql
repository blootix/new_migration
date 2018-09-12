-------------------------------------------------------
-- Export file for user DISTRICT29@MIG12C            --
-- Created by Administrateur on 28/03/2018, 10:17:52 --
-------------------------------------------------------

set define off
spool district29.log

prompt
prompt Creating table ABONNEES
prompt =======================
prompt
create table DISTRICT29.ABONNEES
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
  codar     VARCHAR2(2),
  arrond    VARCHAR2(3),
  nom       VARCHAR2(100),
  adresse   VARCHAR2(100),
  police    VARCHAR2(5)
)
tablespace MIG29
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
create index DISTRICT29.IDXABONNE on DISTRICT29.ABONNEES (TRIM(RTRIM(DIST))||LPAD(LTRIM(RTRIM(TOU)),3,'0')||LPAD(LTRIM(RTRIM(ORD)),3,'0')||LPAD(LTRIM(RTRIM(POL)),5,'0'))
  tablespace MIG29_INDEX
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
create index DISTRICT29.IDX_COMPTEUR_MARQUE on DISTRICT29.ABONNEES (LTRIM(RTRIM(CODMARQ)), LTRIM(RTRIM(NUMCTR)))
  tablespace MIG29_INDEX
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
create index DISTRICT29.IDX_DIS_TOUR_ORDER_POLI_ABN on DISTRICT29.ABONNEES (LPAD(POL,5,'0'), LPAD(TOU,3,'0'), LPAD(ORD,3,'0'), DIST)
  tablespace MIG29_INDEX
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
prompt Creating table ABONNEES_GR
prompt ==========================
prompt
create table DISTRICT29.ABONNEES_GR
(
  posit     VARCHAR2(5),
  categ     VARCHAR2(10),
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
  tarif     VARCHAR2(3),
  napt      VARCHAR2(50),
  datinteg  VARCHAR2(6),
  codbrt    VARCHAR2(2),
  echt      VARCHAR2(2),
  echr      VARCHAR2(2),
  brt       VARCHAR2(6),
  fac       VARCHAR2(4),
  ext       VARCHAR2(5),
  prf       VARCHAR2(40),
  aindex    VARCHAR2(60),
  codrlv    VARCHAR2(10),
  releve    VARCHAR2(60),
  prorata   VARCHAR2(40),
  reliqua   VARCHAR2(40),
  codctrt   VARCHAR2(10),
  codresil  VARCHAR2(10),
  fraipreav VARCHAR2(30),
  fraiferm  VARCHAR2(50),
  fraidepo  VARCHAR2(3),
  coddiv    VARCHAR2(1),
  divers    VARCHAR2(30),
  consmoy   VARCHAR2(50),
  codlocali VARCHAR2(20),
  echtonas  VARCHAR2(20),
  echronas  VARCHAR2(20),
  capitonas VARCHAR2(60),
  interonas VARCHAR2(50),
  codpostal VARCHAR2(80),
  zf1       VARCHAR2(10),
  ar1       VARCHAR2(40),
  ar2       VARCHAR2(40)
)
tablespace MIG29
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
create index DISTRICT29.IDX_DIS_TOUR_ORDER_POLI_ABNGR on DISTRICT29.ABONNEES_GR (LPAD(POL,5,'0'), LPAD(TOU,3,'0'), LPAD(ORD,3,'0'), DIST)
  tablespace MIG29_INDEX
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
create index DISTRICT29.IDX_MARQUE_COMPTEUR on DISTRICT29.ABONNEES_GR (LTRIM(RTRIM(CODMARQ)), LTRIM(RTRIM(NUMCTR)))
  tablespace MIG29_INDEX
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
prompt Creating table ADM
prompt ==================
prompt
create table DISTRICT29.ADM
(
  code        CHAR(4 CHAR),
  desig       VARCHAR2(80 CHAR),
  adresse     VARCHAR2(80 CHAR),
  code_postal NUMBER(10)
)
tablespace MIG29
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
prompt Creating table ADM_AS400
prompt ========================
prompt
create table DISTRICT29.ADM_AS400
(
  coadm  VARCHAR2(200),
  libel  VARCHAR2(200),
  adradm VARCHAR2(200),
  disadm VARCHAR2(200),
  crubgt VARCHAR2(200)
)
tablespace MIG29
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
prompt Creating table ANOMALIES_RELEVE
prompt ===============================
prompt
create table DISTRICT29.ANOMALIES_RELEVE
(
  code  CHAR(3 CHAR),
  desig VARCHAR2(80 CHAR),
  typea CHAR(1 CHAR)
)
tablespace MIG29
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
prompt Creating table ARTICLE
prompt ======================
prompt
create table DISTRICT29.ARTICLE
(
  code            CHAR(8 CHAR),
  type_code       CHAR(1 CHAR),
  desig           VARCHAR2(80 CHAR),
  date_entree     DATE,
  prix_achat      NUMBER(38,2),
  prix_fact       NUMBER(38,2),
  diametre        VARCHAR2(4 CHAR),
  unite           VARCHAR2(2 CHAR),
  nature          CHAR(1 CHAR),
  prix_pose       NUMBER(38,2),
  nature_conduite CHAR(1 CHAR)
)
tablespace MIG29
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
prompt Creating table ARTICLE_DS
prompt =========================
prompt
create table DISTRICT29.ARTICLE_DS
(
  annee             NUMBER(10),
  district          CHAR(2 CHAR),
  localite          CHAR(2 CHAR),
  num               NUMBER(10),
  code_article      CHAR(8 CHAR),
  quantite_demandee NUMBER(38,2),
  quantite_executee NUMBER(38,2),
  prix_total_ttc    NUMBER(38,2),
  par_defaut        CHAR(1 CHAR)
)
tablespace MIG29
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
prompt Creating table BON_COMMANDEDS
prompt =============================
prompt
create table DISTRICT29.BON_COMMANDEDS
(
  annee_ds     NUMBER(10),
  district     CHAR(2 CHAR),
  localite     CHAR(2 CHAR),
  num_ds       NUMBER(10),
  numcde       NUMBER(10),
  datesaisie   DATE,
  datecommande DATE,
  montantcde   NUMBER(38,2)
)
tablespace MIG29
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
prompt Creating table BRANCHEMENT
prompt ==========================
prompt
create table DISTRICT29.BRANCHEMENT
(
  district              CHAR(2 CHAR),
  police                NUMBER(10),
  code_postal           NUMBER(10),
  adresse               VARCHAR2(80 CHAR),
  date_creation         DATE,
  onas                  CHAR(2 CHAR),
  tarif                 CHAR(2 CHAR),
  nombre_appartements   NUMBER(10),
  usage                 CHAR(2 CHAR),
  gros_consommateur     CHAR(1 CHAR),
  num_faire_suivre      NUMBER(10),
  banque                CHAR(2 CHAR),
  agence                CHAR(3 CHAR),
  num_compte            CHAR(13 CHAR),
  cle_rib               CHAR(2 CHAR),
  nom_titulaire_compte  VARCHAR2(60 CHAR),
  nombre_annees         NUMBER(10),
  capital_creditht      NUMBER(38,2),
  echeance_total        NUMBER(10),
  echeance_restante     NUMBER(10),
  annee_ds              NUMBER(10),
  localite_ds           CHAR(2 CHAR),
  num_ds                NUMBER(10),
  client_actuel         VARCHAR2(15 CHAR),
  categorie_actuel      CHAR(2 CHAR),
  compteur_actuel       VARCHAR2(13 CHAR),
  code_marque           CHAR(3 CHAR),
  etat_branchement      CHAR(2 CHAR),
  etat_credit           CHAR(2 CHAR),
  categorie_reelle      CHAR(3 CHAR),
  tourne                CHAR(3 CHAR),
  ordre                 CHAR(3 CHAR),
  credit_onas           NUMBER(38,2),
  echeance_restanteonas NUMBER(10),
  aspect_branchement    CHAR(1 CHAR),
  type_branchement      CHAR(2 CHAR),
  datepose_cptactuel    CHAR(10 CHAR),
  volume_puit_onas      NUMBER(10),
  marche                CHAR(32 CHAR),
  boucheacle            CHAR(1 CHAR),
  rarretavctr           CHAR(1 CHAR),
  rarretapctr           CHAR(1 CHAR),
  type_niche            CHAR(1 CHAR),
  aspect_niche          CHAR(1 CHAR),
  nature_niche          CHAR(1 CHAR),
  etat_niche            CHAR(1 CHAR),
  police_niche          CHAR(1 CHAR)
)
tablespace MIG29
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
create index DISTRICT29.IDX on DISTRICT29.BRANCHEMENT (ADRESSE)
  tablespace MIG29_INDEX
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
create index DISTRICT29.IDX_BRANCHEMENT on DISTRICT29.BRANCHEMENT (TOURNE, DISTRICT, ORDRE)
  tablespace MIG29_INDEX
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
create index DISTRICT29.IDX_BRANCHEMENT10 on DISTRICT29.BRANCHEMENT (DISTRICT||TOURNE||ORDRE)
  tablespace MIG29_INDEX
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
create index DISTRICT29.IDX_BRANCHEMENT11 on DISTRICT29.BRANCHEMENT (TRIM(DISTRICT), TRIM(TOURNE), TRIM(ORDRE), LPAD(TRIM(COMPTEUR_ACTUEL),11,'0'), TRIM(DISTRICT)||TRIM(CODE_MARQUE)||LPAD(TRIM(COMPTEUR_ACTUEL),11,'0'))
  tablespace MIG29_INDEX
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
create index DISTRICT29.IDX_BRANCHEMENT12 on DISTRICT29.BRANCHEMENT (TRIM(ETAT_BRANCHEMENT), TRIM(COMPTEUR_ACTUEL), TRIM(TOURNE)||TRIM(ORDRE), DISTRICT)
  tablespace MIG29_INDEX
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
create index DISTRICT29.IDX_BRANCHEMENT13 on DISTRICT29.BRANCHEMENT (TRIM(ETAT_BRANCHEMENT), TRIM(COMPTEUR_ACTUEL), DISTRICT, TRIM(TOURNE)||TRIM(ORDRE))
  tablespace MIG29_INDEX
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
create index DISTRICT29.IDX_BRANCHEMENT2 on DISTRICT29.BRANCHEMENT (DISTRICT, LPAD(TRIM(ORDRE),3,'0'), LPAD(TRIM(TOURNE),3,'0'))
  tablespace MIG29_INDEX
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
create index DISTRICT29.IDX_BRANCHEMENT3 on DISTRICT29.BRANCHEMENT (TRIM(ORDRE), TRIM(TOURNE))
  tablespace MIG29_INDEX
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
create index DISTRICT29.IDX_BRANCHEMENT4 on DISTRICT29.BRANCHEMENT (LPAD(TRIM(TO_CHAR(POLICE)),5,'0'), TRIM(ORDRE), TRIM(TOURNE))
  tablespace MIG29_INDEX
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
create index DISTRICT29.IDX_BRANCHEMENT7 on DISTRICT29.BRANCHEMENT (LPAD(TRIM(TO_CHAR(POLICE)),5,'0'), TRIM(ORDRE), TRIM(TOURNE), LPAD(TRIM(COMPTEUR_ACTUEL),11,'0'))
  tablespace MIG29_INDEX
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
create index DISTRICT29.IDX_BRANCHEMENT8 on DISTRICT29.BRANCHEMENT (TRIM(DISTRICT)||TRIM(TOURNE)||TRIM(ORDRE), LPAD(TRIM(COMPTEUR_ACTUEL),11,'0'))
  tablespace MIG29_INDEX
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
create index DISTRICT29.IDX_BRANCHEMENT9 on DISTRICT29.BRANCHEMENT (TOURNE||ORDRE)
  tablespace MIG29_INDEX
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
create index DISTRICT29.IDX_CODE_CATEG_CLIENT on DISTRICT29.BRANCHEMENT (CATEGORIE_ACTUEL, CLIENT_ACTUEL)
  tablespace MIG29_INDEX
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
create index DISTRICT29.IDX_CODE_CATEG_CLIENT_CONCAT on DISTRICT29.BRANCHEMENT (LTRIM(RTRIM(CATEGORIE_ACTUEL))||LTRIM(RTRIM(CLIENT_ACTUEL)))
  tablespace MIG29_INDEX
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
create index DISTRICT29.IDX_CPT on DISTRICT29.BRANCHEMENT (COMPTEUR_ACTUEL, DISTRICT)
  tablespace MIG29_INDEX
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
create index DISTRICT29.IDX_DIS_POLI_TOUR_ORDER on DISTRICT29.BRANCHEMENT (LPAD(TO_CHAR(POLICE),5,'0'), LPAD(TOURNE,3,'0'), LPAD(ORDRE,3,'0'), DISTRICT, LPAD(CATEGORIE_ACTUEL,5,'0'), CLIENT_ACTUEL)
  tablespace MIG29_INDEX
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
create index DISTRICT29.IDX_DIST_TOU_ORD on DISTRICT29.BRANCHEMENT (DISTRICT, TOURNE, ORDRE)
  tablespace MIG29_INDEX
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
create index DISTRICT29.IDX_DIST_TOU_ORD1 on DISTRICT29.BRANCHEMENT (LPAD(LTRIM(RTRIM(TOURNE)),3,'0'), LPAD(LTRIM(RTRIM(ORDRE)),3,'0'), DISTRICT)
  tablespace MIG29_INDEX
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
create index DISTRICT29.IDX_TOUR_ORDER_DIS on DISTRICT29.BRANCHEMENT (LPAD(TRIM(TOURNE),3,'0'), LPAD(TRIM(ORDRE),3,'0'), DISTRICT)
  tablespace MIG29_INDEX
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
create index DISTRICT29.IDX2000 on DISTRICT29.BRANCHEMENT (LPAD(LTRIM(RTRIM(DISTRICT)),2,'0')||LPAD(LTRIM(RTRIM(TOURNE)),3,'0')||LPAD(LTRIM(RTRIM(ORDRE)),3,'0')||LPAD(LTRIM(RTRIM(TO_CHAR(POLICE))),5,'0'))
  tablespace MIG29_INDEX
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
prompt Creating table B1
prompt =================
prompt
create table DISTRICT29.B1
(
  ccar    VARCHAR2(100),
  cate    VARCHAR2(100),
  dist    VARCHAR2(100),
  poli    VARCHAR2(100),
  zonn    VARCHAR2(100),
  cadm    VARCHAR2(100),
  crol    VARCHAR2(100),
  mdov    VARCHAR2(100),
  matr    VARCHAR2(100),
  fgen    VARCHAR2(100),
  faca    VARCHAR2(100),
  exte    VARCHAR2(100),
  cprf    VARCHAR2(100),
  prfi    VARCHAR2(100),
  rcha    VARCHAR2(100),
  acon    VARCHAR2(100),
  z1      VARCHAR2(100),
  dpch    VARCHAR2(100),
  net     VARCHAR2(100),
  mtpa    VARCHAR2(100),
  z2      VARCHAR2(100),
  dpai    VARCHAR2(100),
  cpai    VARCHAR2(100),
  z3      VARCHAR2(100),
  dexe    VARCHAR2(100),
  cexe    VARCHAR2(100),
  z4      VARCHAR2(100),
  dfac    VARCHAR2(100),
  cfac    VARCHAR2(100),
  tour    VARCHAR2(100),
  ordr    VARCHAR2(100),
  cnat    VARCHAR2(100),
  foncage VARCHAR2(100),
  credit  VARCHAR2(100)
)
tablespace MIG29
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
prompt Creating table B2
prompt =================
prompt
create table DISTRICT29.B2
(
  ccar    VARCHAR2(100),
  cate    VARCHAR2(100),
  dist    VARCHAR2(100),
  zpol    VARCHAR2(100),
  ndevis  VARCHAR2(100),
  cadm    VARCHAR2(100),
  crol    VARCHAR2(100),
  mdov    VARCHAR2(100),
  matr    VARCHAR2(100),
  fgen    VARCHAR2(100),
  divers  VARCHAR2(100),
  travdiv VARCHAR2(100),
  venteau VARCHAR2(100),
  codop   VARCHAR2(100),
  mtoper  VARCHAR2(100),
  bl1     VARCHAR2(100),
  datpch  VARCHAR2(100),
  net     VARCHAR2(100),
  mtpa    VARCHAR2(100),
  z2      VARCHAR2(100),
  dpai    VARCHAR2(100),
  cpai    VARCHAR2(100),
  z3      VARCHAR2(100),
  cnat    VARCHAR2(100),
  z4      VARCHAR2(100)
)
tablespace MIG29
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
prompt Creating table CATEGORIE
prompt ========================
prompt
create table DISTRICT29.CATEGORIE
(
  code  CHAR(2 CHAR),
  desig VARCHAR2(80 CHAR)
)
tablespace MIG29
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
prompt Creating table CLIENT
prompt =====================
prompt
create table DISTRICT29.CLIENT
(
  code                 VARCHAR2(15 CHAR),
  categorie            CHAR(2 CHAR),
  categorie_sonede     VARCHAR2(2 CHAR),
  nom                  VARCHAR2(60 CHAR),
  tel                  VARCHAR2(16 CHAR),
  autre_tel            VARCHAR2(16 CHAR),
  fax                  VARCHAR2(16 CHAR),
  matricule            VARCHAR2(5 CHAR),
  adresse              VARCHAR2(80 CHAR),
  code_postal          NUMBER(10),
  exonerer_tva         CHAR(1 CHAR),
  num_exoneration      NUMBER(10),
  date_exoneration     DATE,
  date_fin_exoneration DATE,
  nbr_demande          NUMBER(10),
  abonne               CHAR(1 CHAR),
  num_groupe           VARCHAR2(15 CHAR),
  categorie_groupe     CHAR(2 CHAR)
)
tablespace MIG29
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
create index DISTRICT29.INDX_CODE_CATEG on DISTRICT29.CLIENT (LTRIM(RTRIM(CATEGORIE))||LTRIM(RTRIM(CODE)))
  tablespace MIG29_INDEX
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
create index DISTRICT29.INDX_CODE_CATEG1 on DISTRICT29.CLIENT ('29'||LTRIM(RTRIM(CATEGORIE))||LTRIM(RTRIM(UPPER(CODE))))
  tablespace MIG29_INDEX
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
prompt Creating table COMPTEUR
prompt =======================
prompt
create table DISTRICT29.COMPTEUR
(
  num_compteur      VARCHAR2(13 CHAR),
  annee_fabrication NUMBER(10),
  nbr_roues         NUMBER(10),
  diam_compteur     VARCHAR2(4 CHAR),
  type_compteur     VARCHAR2(30 CHAR),
  code_marque       CHAR(3 CHAR),
  aspect_exterieur  CHAR(1 CHAR)
)
tablespace MIG29
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
create index DISTRICT29.IDX_COMPTEUR on DISTRICT29.COMPTEUR (LTRIM(RTRIM(CODE_MARQUE))||LTRIM(RTRIM(NUM_COMPTEUR)))
  tablespace MIG29_INDEX
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
create index DISTRICT29.IDX_COMPTEUR1 on DISTRICT29.COMPTEUR (LTRIM(RTRIM(CODE_MARQUE))||LPAD(LTRIM(RTRIM(NUM_COMPTEUR)),11,'0'))
  tablespace MIG29_INDEX
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
create index DISTRICT29.IDX_COMPTEUR2 on DISTRICT29.COMPTEUR (CODE_MARQUE, LTRIM(RTRIM(CODE_MARQUE))||LPAD(LTRIM(RTRIM(NUM_COMPTEUR)),11,'0'))
  tablespace MIG29_INDEX
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
create index DISTRICT29.IDX_COMPTEUR3 on DISTRICT29.COMPTEUR (TRIM(NUM_COMPTEUR))
  tablespace MIG29_INDEX
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
prompt Creating table CREDITS
prompt ======================
prompt
create table DISTRICT29.CREDITS
(
  annee_ds         NUMBER(10),
  district         CHAR(2 CHAR),
  code_localite_ds CHAR(2 CHAR),
  num_ds           NUMBER(10),
  num_devis_ds     NUMBER(10),
  it               NUMBER(38,2),
  trimes           NUMBER(38,2),
  caprest          NUMBER(38,2),
  intptrimht       NUMBER(38,2),
  intptrimttc      NUMBER(38,2),
  capptrimht       NUMBER(38,2),
  capptrimttc      NUMBER(38,2),
  capplusintttc    NUMBER(38,2),
  numecheance      NUMBER(10),
  echetotal        NUMBER(10),
  credit           NUMBER(38,2)
)
tablespace MIG29
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
prompt Creating table DEMANDE_DS
prompt =========================
prompt
create table DISTRICT29.DEMANDE_DS
(
  annee              NUMBER(10),
  district           CHAR(2 CHAR),
  localite           CHAR(2 CHAR),
  num                NUMBER(10),
  code_postal        NUMBER(10),
  adresse_brt        VARCHAR2(80 CHAR),
  onas               CHAR(2 CHAR),
  bloquer            CHAR(1 CHAR),
  client             VARCHAR2(15 CHAR),
  categorie          CHAR(2 CHAR),
  num_faire_suivre   NUMBER(10),
  banque             CHAR(2 CHAR),
  agence             CHAR(3 CHAR),
  num_compte         CHAR(13 CHAR),
  nom_titulaire      VARCHAR2(60 CHAR),
  cle_rib            CHAR(2 CHAR),
  annee_dmr          NUMBER(10),
  district_dmr       CHAR(2 CHAR),
  localite_dmr       CHAR(2 CHAR),
  delegation_dmr     CHAR(2 CHAR),
  num_dmr            NUMBER(10),
  annee_dc           NUMBER(10),
  district_dc        CHAR(2 CHAR),
  localite_dc        CHAR(2 CHAR),
  delegation_dc      CHAR(2 CHAR),
  num_dc             NUMBER(10),
  provisoire         CHAR(1 CHAR),
  date_creation      DATE,
  date_validation    DATE,
  police_voisine     NUMBER(10),
  etat               NUMBER(10),
  annuler            CHAR(1 CHAR),
  remarque_exploiter VARCHAR2(160 CHAR),
  remarque           VARCHAR2(160 CHAR),
  piece              VARCHAR2(7 CHAR),
  usage              CHAR(2 CHAR),
  qualite            CHAR(1 CHAR),
  convoque           CHAR(1 CHAR),
  date_convocation   DATE,
  nbr_inst           NUMBER(10),
  nbr_tic            NUMBER(10),
  nbr_cof            NUMBER(10)
)
tablespace MIG29
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
prompt Creating table DEVIS_DS
prompt =======================
prompt
create table DISTRICT29.DEVIS_DS
(
  annee_ds                    NUMBER(10),
  district                    CHAR(2 CHAR),
  code_localite_ds            CHAR(2 CHAR),
  num_ds                      NUMBER(10),
  num                         NUMBER(10),
  etat                        CHAR(1 CHAR),
  date_valorisation           DATE,
  date_effet_tva              DATE,
  montant_matiere             NUMBER(38,2),
  montant_main_oeuvre         NUMBER(38,2),
  montant_foncage             NUMBER(38,2),
  montant_frais_generaux      NUMBER(38,2),
  montant_extension           NUMBER(38,2),
  montant_facade              NUMBER(38,2),
  montant_tva                 NUMBER(38,2),
  montant_refection           NUMBER(38,2),
  montant_avance_consommation NUMBER(38,2),
  prix_global_ds_ht           NUMBER(38,2),
  prix_global_ds_ttc          NUMBER(38,2),
  facilite                    CHAR(1 CHAR),
  remarque                    VARCHAR2(160 CHAR),
  montant_voirie              NUMBER(38,2)
)
tablespace MIG29
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
prompt Creating table DONNEE_TECHNIQUES_DS
prompt ===================================
prompt
create table DISTRICT29.DONNEE_TECHNIQUES_DS
(
  annee             NUMBER(10),
  district          VARCHAR2(100),
  localite          VARCHAR2(100),
  num               NUMBER(10),
  diam_conduite     VARCHAR2(100),
  date_instruction  DATE,
  date_saisie       DATE,
  facade            NUMBER(38,2),
  foncage           NUMBER(38,2),
  avec_foncage      VARCHAR2(100),
  montant_foncage   NUMBER(38,2),
  montant_refection NUMBER(38,2),
  montant_divers    NUMBER(38,2),
  usage             VARCHAR2(100),
  frais_generaux    DATE,
  diam_compteur     VARCHAR2(100),
  diam_poly         VARCHAR2(100),
  gros_consommateur VARCHAR2(100),
  remarque          VARCHAR2(160 CHAR),
  type_technique    VARCHAR2(100),
  montant_voirie    NUMBER(38,2)
)
tablespace MIG29
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
prompt Creating table FACTURE
prompt ======================
prompt
create table DISTRICT29.FACTURE
(
  district         VARCHAR2(100),
  police           NUMBER(10),
  annee            NUMBER(10),
  periode          VARCHAR2(100),
  version          NUMBER(10),
  periodicite      VARCHAR2(100),
  tournee          VARCHAR2(100),
  ordre            VARCHAR2(100),
  tiers            VARCHAR2(100),
  net_a_payer      NUMBER(38,2),
  etat             VARCHAR2(100),
  etat_original    VARCHAR2(100),
  code_report      VARCHAR2(100),
  ancien_report    NUMBER(10),
  nouveau_report   NUMBER(10),
  consommation     NUMBER(10),
  preavis          VARCHAR2(100),
  fem_dep_def      VARCHAR2(100),
  fem_ouv_dem      VARCHAR2(100),
  res_def_dem      VARCHAR2(100),
  onas             VARCHAR2(100),
  tarif            VARCHAR2(100),
  nbr_appartement  NUMBER(10),
  code_branchement VARCHAR2(100),
  code_compteur    VARCHAR2(100),
  credit_sonede    NUMBER(38,2),
  extension        NUMBER(38,2),
  facade           NUMBER(38,2),
  produit_financ   NUMBER(38,2),
  credit_onas      NUMBER(38,2),
  categorie        VARCHAR2(100),
  nbr_mois         NUMBER(10),
  volume_puit_onas NUMBER(10),
  coef_onas        VARCHAR2(100),
  date_edition     VARCHAR2(100)
)
tablespace MIG29
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
create index DISTRICT29.IDX_FACTURE on DISTRICT29.FACTURE (LTRIM(RTRIM(DISTRICT))||LPAD(LTRIM(RTRIM(TOURNEE)),3,'0')||LPAD(LTRIM(RTRIM(ORDRE)),3,'0')||LPAD(LTRIM(RTRIM(TO_CHAR(POLICE))),5,'0'))
  tablespace MIG29_INDEX
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
create index DISTRICT29.IDX_FACTURE001 on DISTRICT29.FACTURE (DISTRICT, PERIODE, TIERS)
  tablespace MIG29_INDEX
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
create index DISTRICT29.IDX_FACTURE01 on DISTRICT29.FACTURE (TRIM(TOURNEE)||TRIM(ORDRE), DISTRICT)
  tablespace MIG29_INDEX
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
create index DISTRICT29.IDX_FACTURE02 on DISTRICT29.FACTURE (TRIM(TOURNEE)||TRIM(ORDRE))
  tablespace MIG29_INDEX
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
create index DISTRICT29.IDX_FACTURE03 on DISTRICT29.FACTURE (TRIM(TOURNEE)||TRIM(ORDRE), TO_CHAR(TO_NUMBER(TO_CHAR(ANNEE)))||TO_CHAR(TO_NUMBER(PERIODE)))
  tablespace MIG29_INDEX
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
create index DISTRICT29.IDX_FACTURE04 on DISTRICT29.FACTURE (TO_CHAR(TO_NUMBER(TO_CHAR(ANNEE)))||TO_CHAR(TO_NUMBER(PERIODE)))
  tablespace MIG29_INDEX
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
create index DISTRICT29.IDX_FACTURE05 on DISTRICT29.FACTURE (TRIM(TO_CHAR(ANNEE))||TRIM(PERIODE), ANNEE, DISTRICT)
  tablespace MIG29_INDEX
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
create index DISTRICT29.IDX_FACTURE06 on DISTRICT29.FACTURE (LTRIM(RTRIM(DISTRICT))||LPAD(LTRIM(RTRIM(TOURNEE)),3,'0')||LPAD(LTRIM(RTRIM(ORDRE)),3,'0'))
  tablespace MIG29_INDEX
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
create index DISTRICT29.IDX_FACTURE07 on DISTRICT29.FACTURE (TRIM(TO_CHAR(ANNEE))||TRIM(PERIODE))
  tablespace MIG29_INDEX
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
create index DISTRICT29.IDX_FACTURE13 on DISTRICT29.FACTURE (LTRIM(RTRIM(DISTRICT))||LPAD(LTRIM(RTRIM(TOURNEE)),3,'0')||LPAD(LTRIM(RTRIM(ORDRE)),3,'0')||LPAD(LTRIM(RTRIM(TO_CHAR(POLICE))),5,'0'), LTRIM(RTRIM(ONAS)), LTRIM(RTRIM(TARIF)))
  tablespace MIG29_INDEX
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
create index DISTRICT29.IDX_FACTURE23 on DISTRICT29.FACTURE (LTRIM(RTRIM(TOURNEE))||LTRIM(RTRIM(ORDRE)))
  tablespace MIG29_INDEX
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
create index DISTRICT29.IDX_FACTURE33 on DISTRICT29.FACTURE (DISTRICT, LPAD(TRIM(TOURNEE),3,'0'), LPAD(TRIM(ORDRE),3,'0'))
  tablespace MIG29_INDEX
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
create index DISTRICT29.IDX_FACTURE43 on DISTRICT29.FACTURE (LPAD(DISTRICT,2,'0')||LPAD(LTRIM(RTRIM(TOURNEE)),3,'0')||LPAD(LTRIM(RTRIM(ORDRE)),3,'0'))
  tablespace MIG29_INDEX
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
create index DISTRICT29.IDX_FACTURE53 on DISTRICT29.FACTURE (LTRIM(RTRIM(DISTRICT))||LPAD(LTRIM(RTRIM(TOURNEE)),3,'0')||LPAD(LTRIM(RTRIM(ORDRE)),3,'0')||TO_CHAR(ANNEE)||LPAD(LTRIM(RTRIM(PERIODE)),2,'0')||'0')
  tablespace MIG29_INDEX
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
create index DISTRICT29.IDX_FACTURE63 on DISTRICT29.FACTURE (LPAD(LTRIM(RTRIM(TOURNEE)),3,'0'))
  tablespace MIG29_INDEX
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
create index DISTRICT29.IDX_FACTURE6373 on DISTRICT29.FACTURE (LTRIM(RTRIM(DISTRICT))||LPAD(LTRIM(RTRIM(TOURNEE)),3,'0')||LPAD(LTRIM(RTRIM(ORDRE)),3,'0'), ANNEE)
  tablespace MIG29_INDEX
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
create index DISTRICT29.IDX_TOU_ORD on DISTRICT29.FACTURE (LPAD(TRIM(TOURNEE),3,'0'), LPAD(TRIM(ORDRE),3,'0'), DISTRICT)
  tablespace MIG29_INDEX
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
create index DISTRICT29.I_FACT_ORDRE on DISTRICT29.FACTURE (ORDRE)
  tablespace MIG29_INDEX
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
create index DISTRICT29.I_FACT_POLICE on DISTRICT29.FACTURE (POLICE)
  tablespace MIG29_INDEX
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
create index DISTRICT29.I_FACT_TOURNEE on DISTRICT29.FACTURE (TOURNEE)
  tablespace MIG29_INDEX
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
prompt Creating table FACTURE_AS400
prompt ============================
prompt
create table DISTRICT29.FACTURE_AS400
(
  cat        VARCHAR2(10),
  dist       VARCHAR2(10),
  pol        VARCHAR2(10),
  tou        VARCHAR2(10),
  ord        VARCHAR2(10),
  cfac       VARCHAR2(10),
  z1         VARCHAR2(10),
  nomadr     VARCHAR2(100),
  usag       VARCHAR2(10),
  codonas    VARCHAR2(10),
  mtonas     VARCHAR2(10),
  fraisctr   VARCHAR2(10),
  raisbrt    VARCHAR2(10),
  ctarif     VARCHAR2(10),
  tauxt1     VARCHAR2(10),
  tauxt2     VARCHAR2(10),
  tauxt3     VARCHAR2(10),
  nbreapp    VARCHAR2(10),
  partcon    VARCHAR2(10),
  codbrt     VARCHAR2(10),
  echtot     VARCHAR2(10),
  echrest    VARCHAR2(10),
  rbranche   VARCHAR2(10),
  rfacade    VARCHAR2(10),
  rextension VARCHAR2(10),
  pfinancier VARCHAR2(10),
  aindex     VARCHAR2(10),
  nindex     VARCHAR2(10),
  cons       VARCHAR2(10),
  prorata    VARCHAR2(10),
  const1     VARCHAR2(10),
  montt1     VARCHAR2(10),
  const2     VARCHAR2(10),
  montt2     VARCHAR2(10),
  const3     VARCHAR2(10),
  montt3     VARCHAR2(10),
  z3         VARCHAR2(10),
  mtctot     VARCHAR2(10),
  tva        VARCHAR2(10),
  frlettre   VARCHAR2(10),
  frferm     VARCHAR2(10),
  codctr     VARCHAR2(10),
  cods       VARCHAR2(10),
  divers     VARCHAR2(10),
  cleref     VARCHAR2(10),
  monttrim   VARCHAR2(10),
  clemt      VARCHAR2(10),
  restpc     VARCHAR2(10),
  cbo        VARCHAR2(10),
  eto        VARCHAR2(10),
  ero        VARCHAR2(10),
  capit      VARCHAR2(10),
  inter      VARCHAR2(10),
  codeso     VARCHAR2(10),
  echtos     VARCHAR2(10),
  codptt     VARCHAR2(10),
  reston     VARCHAR2(10),
  fixonas    VARCHAR2(10),
  z5         VARCHAR2(10),
  taxe       VARCHAR2(10),
  qonas      VARCHAR2(10),
  volon1     VARCHAR2(10),
  tauon1     VARCHAR2(10),
  mon1       VARCHAR2(10),
  volon2     VARCHAR2(10),
  tauon2     VARCHAR2(10),
  mon2       VARCHAR2(10),
  refc01     VARCHAR2(10),
  refc02     VARCHAR2(10),
  refc03     VARCHAR2(10),
  refc04     VARCHAR2(10),
  volon3     VARCHAR2(10),
  tauon3     VARCHAR2(10),
  mon3       VARCHAR2(10),
  caron      VARCHAR2(10),
  arepor     VARCHAR2(10),
  narond     VARCHAR2(10),
  net        VARCHAR2(10),
  arriere    VARCHAR2(10),
  volon4     VARCHAR2(10),
  tauon4     VARCHAR2(10),
  mttonas    VARCHAR2(10)
)
tablespace MIG29
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
create index DISTRICT29.IDX_FACTUREN4 on DISTRICT29.FACTURE_AS400 (POL, LTRIM(RTRIM(DIST)), LTRIM(RTRIM(TOU)), LTRIM(RTRIM(ORD)))
  tablespace MIG29_INDEX
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
create index DISTRICT29.IDX_FACTURE1 on DISTRICT29.FACTURE_AS400 (LPAD(DIST,2,'0')||LPAD(TOU,3,'0')||LPAD(ORD,3,'0'), REFC01, REFC02, REFC03, '20'||REFC04)
  tablespace MIG29_INDEX
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
create index DISTRICT29.IDX_FACTURE2 on DISTRICT29.FACTURE_AS400 (REFC01, REFC02, REFC03)
  tablespace MIG29_INDEX
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
create index DISTRICT29.IDX_FACTURE3 on DISTRICT29.FACTURE_AS400 (LPAD(TRIM(TOU),3,'0'), LPAD(TRIM(ORD),3,'0'), DIST)
  tablespace MIG29_INDEX
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
create index DISTRICT29.IDX_FACTURE_5 on DISTRICT29.FACTURE_AS400 (LPAD(DIST,2,'0')||LPAD(TOU,3,'0')||LPAD(ORD,3,'0')||LPAD(POL,5,'0'))
  tablespace MIG29_INDEX
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
create index DISTRICT29.IDX_FACTURE_6 on DISTRICT29.FACTURE_AS400 (LPAD(TRIM(TOU),3,'0')||LPAD(TRIM(ORD),3,'0'))
  tablespace MIG29_INDEX
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
create index DISTRICT29.IDX_FACTURE_7 on DISTRICT29.FACTURE_AS400 (DIST, REFC01, REFC02, REFC03)
  tablespace MIG29_INDEX
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
create index DISTRICT29.IDX_FACTURE_8 on DISTRICT29.FACTURE_AS400 (LPAD(TOU,3,'0'))
  tablespace MIG29_INDEX
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
create index DISTRICT29.I_FACTAS400_DISTRICT on DISTRICT29.FACTURE_AS400 (DIST)
  tablespace MIG29_INDEX
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
prompt Creating table FACTURE_AS400GC
prompt ==============================
prompt
create table DISTRICT29.FACTURE_AS400GC
(
  cat        VARCHAR2(10),
  dist       VARCHAR2(10),
  pol        VARCHAR2(10),
  tou        VARCHAR2(10),
  ord        VARCHAR2(10),
  cfac       VARCHAR2(10),
  z1         VARCHAR2(10),
  nomadr     VARCHAR2(100),
  usag       VARCHAR2(10),
  codonas    VARCHAR2(10),
  mtonas     VARCHAR2(10),
  fraisctr   VARCHAR2(10),
  raisbrt    VARCHAR2(10),
  ctarif     VARCHAR2(10),
  tauxt1     VARCHAR2(10),
  tauxt2     VARCHAR2(10),
  tauxt3     VARCHAR2(10),
  nbreapp    VARCHAR2(10),
  partcon    VARCHAR2(10),
  codbrt     VARCHAR2(10),
  echtot     VARCHAR2(10),
  echrest    VARCHAR2(10),
  rbranche   VARCHAR2(10),
  rfacade    VARCHAR2(10),
  rextension VARCHAR2(10),
  pfinancier VARCHAR2(10),
  aindex     VARCHAR2(10),
  nindex     VARCHAR2(10),
  cons       VARCHAR2(10),
  prorata    VARCHAR2(10),
  const1     VARCHAR2(10),
  montt1     VARCHAR2(10),
  const2     VARCHAR2(10),
  montt2     VARCHAR2(10),
  const3     VARCHAR2(10),
  montt3     VARCHAR2(10),
  z3         VARCHAR2(10),
  mtctot     VARCHAR2(10),
  tva        VARCHAR2(10),
  frlettre   VARCHAR2(10),
  frferm     VARCHAR2(10),
  codctr     VARCHAR2(10),
  cods       VARCHAR2(10),
  divers     VARCHAR2(10),
  cleref     VARCHAR2(10),
  monttrim   VARCHAR2(10),
  clemt      VARCHAR2(10),
  restpc     VARCHAR2(10),
  cbo        VARCHAR2(10),
  eto        VARCHAR2(10),
  ero        VARCHAR2(10),
  capit      VARCHAR2(10),
  inter      VARCHAR2(10),
  codeso     VARCHAR2(10),
  echtos     VARCHAR2(10),
  codptt     VARCHAR2(10),
  reston     VARCHAR2(10),
  fixonas    VARCHAR2(10),
  z5         VARCHAR2(10),
  taxe       VARCHAR2(10),
  qonas      VARCHAR2(10),
  volon1     VARCHAR2(10),
  tauon1     VARCHAR2(10),
  mon1       VARCHAR2(10),
  volon2     VARCHAR2(10),
  tauon2     VARCHAR2(10),
  mon2       VARCHAR2(10),
  refc01     VARCHAR2(10),
  refc02     VARCHAR2(10),
  refc03     VARCHAR2(10),
  refc04     VARCHAR2(10),
  volon3     VARCHAR2(10),
  tauon3     VARCHAR2(10),
  mon3       VARCHAR2(10),
  caron      VARCHAR2(10),
  arepor     VARCHAR2(10),
  narond     VARCHAR2(10),
  volon4     VARCHAR2(10),
  tauon4     VARCHAR2(10),
  mon4       VARCHAR2(10),
  mttonas    VARCHAR2(10),
  eaupuit    VARCHAR2(10)
)
tablespace MIG29
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
create index DISTRICT29.INDX_FACTURE_GC_1 on DISTRICT29.FACTURE_AS400GC (POL, DIST, REFC01)
  tablespace MIG29_INDEX
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
create index DISTRICT29.INDX_FACTURE_GC_2 on DISTRICT29.FACTURE_AS400GC (LPAD(DIST,2,'0')||LPAD(TOU,3,'0')||LPAD(ORD,3,'0')||LPAD(POL,5,'0'))
  tablespace MIG29_INDEX
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
create index DISTRICT29.INDX_FACTURE_GC_3 on DISTRICT29.FACTURE_AS400GC (DIST, REFC01)
  tablespace MIG29_INDEX
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
prompt Creating table FAIRE_SUIVRE_GC
prompt ==============================
prompt
create table DISTRICT29.FAIRE_SUIVRE_GC
(
  posit     VARCHAR2(200),
  categ     VARCHAR2(200),
  dist      VARCHAR2(200),
  pol       VARCHAR2(200),
  tou       VARCHAR2(200),
  ord       VARCHAR2(200),
  tier      VARCHAR2(200),
  adm       VARCHAR2(200),
  ad1       VARCHAR2(200),
  ad2       VARCHAR2(200),
  ad3       VARCHAR2(200),
  codonas   VARCHAR2(200),
  usag      VARCHAR2(200),
  codctr    VARCHAR2(200),
  codmarq   VARCHAR2(200),
  numctr    VARCHAR2(200),
  tarif     VARCHAR2(200),
  napt      VARCHAR2(200),
  datinteg  VARCHAR2(200),
  codbrt    VARCHAR2(200),
  echt      VARCHAR2(200),
  echr      VARCHAR2(200),
  brt       VARCHAR2(200),
  fac       VARCHAR2(200),
  ext       VARCHAR2(200),
  prf       VARCHAR2(200),
  aindex    VARCHAR2(200),
  codrlv    VARCHAR2(200),
  releve    VARCHAR2(200),
  prorata   VARCHAR2(200),
  reliqua   VARCHAR2(200),
  codctrt   VARCHAR2(200),
  codresil  VARCHAR2(200),
  fraipreav VARCHAR2(200),
  fraiferm  VARCHAR2(200),
  fraidepo  VARCHAR2(200),
  coddiv    VARCHAR2(200),
  divers    VARCHAR2(200),
  consmoy   VARCHAR2(200),
  codlocali VARCHAR2(200),
  echtonas  VARCHAR2(200),
  echronas  VARCHAR2(200),
  capitonas VARCHAR2(200),
  interonas VARCHAR2(200),
  codpostal VARCHAR2(200),
  zf1       VARCHAR2(200),
  ar1       VARCHAR2(200),
  ar2       VARCHAR2(200)
)
tablespace MIG29
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
prompt Creating table FAIRE_SUIVRE_PART
prompt ================================
prompt
create table DISTRICT29.FAIRE_SUIVRE_PART
(
  posit     VARCHAR2(100),
  categ     VARCHAR2(100),
  dist      VARCHAR2(100),
  pol       VARCHAR2(100),
  tou       VARCHAR2(100),
  ord       VARCHAR2(100),
  tier      VARCHAR2(100),
  adm       VARCHAR2(100),
  adr1      VARCHAR2(100),
  adr2      VARCHAR2(100),
  adr3      VARCHAR2(100),
  codonas   VARCHAR2(100),
  usag      VARCHAR2(100),
  codctr    VARCHAR2(100),
  codmarq   VARCHAR2(100),
  numctr    VARCHAR2(100),
  codonan   VARCHAR2(100),
  zbl1      VARCHAR2(100),
  codpoll   VARCHAR2(100),
  zbl3      VARCHAR2(100),
  tarif     VARCHAR2(100),
  napt      VARCHAR2(100),
  datinteg  VARCHAR2(100),
  codbrt    VARCHAR2(100),
  echt      VARCHAR2(100),
  echr      VARCHAR2(100),
  brt       VARCHAR2(100),
  fac       VARCHAR2(100),
  ext       VARCHAR2(100),
  prf       VARCHAR2(100),
  aindex    VARCHAR2(100),
  codrlv    VARCHAR2(100),
  releve    VARCHAR2(100),
  prorata   VARCHAR2(100),
  reliqua   VARCHAR2(100),
  codctrt   VARCHAR2(100),
  codresil  VARCHAR2(100),
  fraipreav VARCHAR2(100),
  fraiferm  VARCHAR2(100),
  fraidepo  VARCHAR2(100),
  coddiv    VARCHAR2(100),
  divers    VARCHAR2(100),
  consmoy   VARCHAR2(100),
  codlocali VARCHAR2(100),
  echtonas  VARCHAR2(100),
  echronas  VARCHAR2(100),
  capitonas VARCHAR2(100),
  interonas VARCHAR2(100),
  codpostal VARCHAR2(100),
  codar     VARCHAR2(100),
  arrond    VARCHAR2(100)
)
tablespace MIG29
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
prompt Creating table FICHE_RELEVE
prompt ===========================
prompt
create table DISTRICT29.FICHE_RELEVE
(
  district           CHAR(2 CHAR) not null,
  tourne             CHAR(3 CHAR) not null,
  ordre              CHAR(3 CHAR) not null,
  annee              CHAR(4 CHAR) not null,
  trim               CHAR(1 CHAR) not null,
  releve             CHAR(6 CHAR),
  prorata            CHAR(6 CHAR),
  constrim4          CHAR(6 CHAR),
  marche             CHAR(32 CHAR),
  releve2            CHAR(6 CHAR),
  releve3            CHAR(6 CHAR),
  releve4            CHAR(6 CHAR),
  releve5            CHAR(6 CHAR),
  date_releve        CHAR(16 CHAR),
  compteurt          CHAR(1 CHAR),
  consommation       CHAR(6 CHAR),
  anomalie           CHAR(18 CHAR),
  saisie             CHAR(2 CHAR),
  avisforte          CHAR(8 CHAR),
  message_temporaire CHAR(20 CHAR),
  compteurchange     CHAR(1 CHAR),
  n_tsp              CHAR(10 CHAR),
  matricule_releveur CHAR(5 CHAR),
  date_controle      CHAR(16 CHAR),
  matricule_controle CHAR(5 CHAR),
  index_controle     CHAR(6 CHAR),
  nbre_roues         CHAR(1 CHAR),
  derniere_releve    CHAR(1 CHAR),
  usage              CHAR(2 CHAR),
  tarif              CHAR(2 CHAR),
  diamctr            CHAR(2 CHAR),
  cctr               CHAR(2 CHAR),
  codemarque         CHAR(3 CHAR),
  ncompteur          CHAR(11 CHAR),
  ancien_releve      CHAR(40 CHAR)
)
tablespace MIG29
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
create index DISTRICT29.IDX_FICHE_RELEVE on DISTRICT29.FICHE_RELEVE (DISTRICT, TRIM(ANNEE), TRIM(TRIM))
  tablespace MIG29_INDEX
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
create index DISTRICT29.IDX_FICHE_RELEVE009 on DISTRICT29.FICHE_RELEVE (LPAD(TRIM(TOURNE),3,'0')||LPAD(TRIM(ORDRE),3,'0'))
  tablespace MIG29_INDEX
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
create index DISTRICT29.IDX_FICHE_RELEVE10 on DISTRICT29.FICHE_RELEVE (TRIM(DISTRICT)||LPAD(TRIM(TOURNE),3,'0')||LPAD(TRIM(ORDRE),3,'0'), TRIM(NCOMPTEUR), TRIM(CODEMARQUE))
  tablespace MIG29_INDEX
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
create index DISTRICT29.IDX_FICHE_RELEVE11 on DISTRICT29.FICHE_RELEVE (TRIM(DISTRICT), LPAD(TRIM(TOURNE),3,'0'), LPAD(TRIM(ORDRE),3,'0'), TRIM(ANNEE), TRIM(TRIM), LPAD(TRIM(NCOMPTEUR),11,'0'), TRIM(DISTRICT)||TRIM(CODEMARQUE)||LPAD(TRIM(NCOMPTEUR),11,'0'))
  tablespace MIG29_INDEX
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
create index DISTRICT29.IDX_FICHE_RELEVE12 on DISTRICT29.FICHE_RELEVE (TRIM(ANNEE)||TRIM(TRIM))
  tablespace MIG29_INDEX
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
create index DISTRICT29.IDX_FICHE_RELEVE13 on DISTRICT29.FICHE_RELEVE (DISTRICT, TRIM(TOURNE)||TRIM(ORDRE))
  tablespace MIG29_INDEX
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
create index DISTRICT29.IDX_FICHE_RELEVE14 on DISTRICT29.FICHE_RELEVE (TRIM(TOURNE)||TRIM(ORDRE), TO_CHAR(TO_NUMBER(ANNEE))||TO_CHAR(TO_NUMBER(NVL(TRIM(TRIM),'0'))))
  tablespace MIG29_INDEX
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
create index DISTRICT29.IDX_FICHE_RELEVE15 on DISTRICT29.FICHE_RELEVE (TRIM(TOURNE)||TRIM(ORDRE), DISTRICT)
  tablespace MIG29_INDEX
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
create index DISTRICT29.IDX_FICHE_RELEVE2 on DISTRICT29.FICHE_RELEVE (TRIM(ANNEE)||TRIM(TRIM), DISTRICT||TOURNE||ORDRE)
  tablespace MIG29_INDEX
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
create index DISTRICT29.IDX_FICHE_RELEVE3 on DISTRICT29.FICHE_RELEVE (TRIM(TOURNE)||TRIM(ORDRE))
  tablespace MIG29_INDEX
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
create index DISTRICT29.IDX_FICHE_RELEVE4 on DISTRICT29.FICHE_RELEVE (TRIM(DISTRICT), TRIM(TOURNE), TRIM(ORDRE), TRIM(ANNEE)||TRIM(TRIM))
  tablespace MIG29_INDEX
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
create index DISTRICT29.IDX_FICHE_RELEVE5 on DISTRICT29.FICHE_RELEVE (DISTRICT, LPAD(TRIM(TOURNE),3,'0'), LPAD(TRIM(ORDRE),3,'0'))
  tablespace MIG29_INDEX
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
create index DISTRICT29.IDX_FICHE_RELEVE6 on DISTRICT29.FICHE_RELEVE (TRIM(DISTRICT)||LPAD(TRIM(TOURNE),3,'0')||LPAD(TRIM(ORDRE),3,'0'), TRIM(ANNEE)||TRIM(TRIM))
  tablespace MIG29_INDEX
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
create index DISTRICT29.IDX_FICHE_RELEVE7 on DISTRICT29.FICHE_RELEVE (TRIM(DISTRICT)||LPAD(TRIM(TOURNE),3,'0')||LPAD(TRIM(ORDRE),3,'0'), TRIM(DISTRICT)||TRIM(CODEMARQUE)||LPAD(TRIM(NCOMPTEUR),11,'0'), TRIM(ANNEE)||TRIM(TRIM))
  tablespace MIG29_INDEX
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
create index DISTRICT29.IDX_FICHE_RELEVE8 on DISTRICT29.FICHE_RELEVE (TRIM(ANNEE)||TRIM(TRIM), TRIM(DISTRICT)||TRIM(CODEMARQUE)||LPAD(TRIM(NCOMPTEUR),11,'0'), TRIM(NCOMPTEUR), TRIM(CODEMARQUE))
  tablespace MIG29_INDEX
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
create index DISTRICT29.IDX_FICHE_RELEVE9 on DISTRICT29.FICHE_RELEVE (TRIM(DISTRICT)||LPAD(TRIM(TOURNE),3,'0')||LPAD(TRIM(ORDRE),3,'0'))
  tablespace MIG29_INDEX
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
create index DISTRICT29.IDX_F_RELEVE11 on DISTRICT29.FICHE_RELEVE (LTRIM(RTRIM(CODEMARQUE)))
  tablespace MIG29_INDEX
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
create index DISTRICT29.IDX_F_RELEVE21 on DISTRICT29.FICHE_RELEVE (LTRIM(RTRIM(NCOMPTEUR)))
  tablespace MIG29_INDEX
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
create index DISTRICT29.IDX_F_RELEVE41 on DISTRICT29.FICHE_RELEVE (ANNEE||TRIM(TRIM), DISTRICT||TOURNE||ORDRE)
  tablespace MIG29_INDEX
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
create index DISTRICT29.IDX_F_RELEVE51 on DISTRICT29.FICHE_RELEVE (DISTRICT, TRIM(TOURNE), TRIM(ORDRE))
  tablespace MIG29_INDEX
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
create index DISTRICT29.IDX_F_RELEVE61 on DISTRICT29.FICHE_RELEVE (DISTRICT, LPAD(TRIM(TOURNE),3,'0'), LPAD(TRIM(ORDRE),3,'0'), TRIM(ANNEE))
  tablespace MIG29_INDEX
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
create index DISTRICT29.IDX_F_RELEVE81 on DISTRICT29.FICHE_RELEVE (TRIM(TOURNE), TRIM(ORDRE))
  tablespace MIG29_INDEX
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
create index DISTRICT29.IDX_TOU_ORD_DIS on DISTRICT29.FICHE_RELEVE (LPAD(TRIM(TOURNE),3,'0'), LPAD(TRIM(ORDRE),3,'0'), DISTRICT, TRIM(ANNEE))
  tablespace MIG29_INDEX
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
prompt Creating table GESTION_COMPTEUR
prompt ===============================
prompt
create table DISTRICT29.GESTION_COMPTEUR
(
  date_action      CHAR(10 CHAR),
  tournee          CHAR(3 CHAR),
  ordre            CHAR(3 CHAR),
  action           CHAR(1 CHAR),
  num_action       NUMBER(10),
  gc               CHAR(1 CHAR),
  code_compteur    CHAR(2 CHAR),
  num_compteur     CHAR(20 CHAR),
  diam_compteur    VARCHAR2(4 CHAR),
  type_compteur    VARCHAR2(30 CHAR),
  code_marque      CHAR(4 CHAR),
  index_arret      CHAR(6 CHAR),
  index_depart     CHAR(6 CHAR),
  date_changement  CHAR(10 CHAR),
  motif_changement CHAR(50 CHAR),
  trim             CHAR(1 CHAR),
  annee            CHAR(4 CHAR),
  prorata          NUMBER(10)
)
tablespace MIG29
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
create index DISTRICT29.IDX_GESTION_COMPTEUR on DISTRICT29.GESTION_COMPTEUR (UPPER(LTRIM(RTRIM(ACTION))), TOURNEE, ORDRE)
  tablespace MIG29_INDEX
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
create index DISTRICT29.IDX_GESTION_COMPTEUR10 on DISTRICT29.GESTION_COMPTEUR (TRIM(TOURNEE)||TRIM(ORDRE), UPPER(TRIM(ACTION)), TO_DATE(DATE_ACTION,'dd/mm/yyyy'))
  tablespace MIG29_INDEX
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
create index DISTRICT29.IDX_GESTION_COMPTEUR11 on DISTRICT29.GESTION_COMPTEUR (TRIM(TOURNEE)||TRIM(ORDRE))
  tablespace MIG29_INDEX
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
create index DISTRICT29.IDX_GESTION_COMPTEUR12 on DISTRICT29.GESTION_COMPTEUR (LPAD(TRIM(TOURNEE),3,'0')||LPAD(TRIM(ORDRE),3,'0'))
  tablespace MIG29_INDEX
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
create index DISTRICT29.IDX_GESTION_COMPTEUR26 on DISTRICT29.GESTION_COMPTEUR (LPAD(TRIM(TOURNEE),3,'0')||LPAD(TRIM(ORDRE),3,'0'), TRIM(NUM_COMPTEUR), TRIM(ANNEE)||TRIM(TRIM))
  tablespace MIG29_INDEX
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
create index DISTRICT29.IDX_GESTION_COMPTEUR5 on DISTRICT29.GESTION_COMPTEUR (LPAD(TRIM(TOURNEE),3,'0'), LPAD(TRIM(ORDRE),3,'0'), TRIM(ANNEE)||TRIM(TRIM))
  tablespace MIG29_INDEX
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
create index DISTRICT29.IDX_GESTION_COMPTEUR6 on DISTRICT29.GESTION_COMPTEUR (LPAD(TRIM(TOURNEE),3,'0'), LPAD(TRIM(ORDRE),3,'0'), TO_DATE(DATE_ACTION,'dd/mm/yyyy'))
  tablespace MIG29_INDEX
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
create index DISTRICT29.IDX_GESTION_COMPTEUR7 on DISTRICT29.GESTION_COMPTEUR (LPAD(TRIM(TOURNEE),3,'0'), LPAD(TRIM(ORDRE),3,'0'), TRIM(ANNEE), TRIM(TRIM), TRIM(NUM_COMPTEUR), TRIM(CODE_MARQUE)||LPAD(TRIM(NUM_COMPTEUR),11,'0'))
  tablespace MIG29_INDEX
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
create index DISTRICT29.IDX_GESTION_COMPTEUR8 on DISTRICT29.GESTION_COMPTEUR (TRIM(NUM_COMPTEUR))
  tablespace MIG29_INDEX
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
create index DISTRICT29.IDX_GESTION_COMPTEUR9 on DISTRICT29.GESTION_COMPTEUR (TRIM(TOURNEE)||TRIM(ORDRE), UPPER(TRIM(ACTION)))
  tablespace MIG29_INDEX
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
prompt Creating table IMPAYEES
prompt =======================
prompt
create table DISTRICT29.IMPAYEES
(
  district      CHAR(2 CHAR),
  police        CHAR(5 CHAR),
  tournee       CHAR(3 CHAR),
  ordre         CHAR(3 CHAR),
  periode       CHAR(1 CHAR),
  annee         CHAR(4 CHAR),
  net_a_payer   CHAR(9 CHAR),
  montant       CHAR(9 CHAR),
  code_paiement CHAR(1 CHAR),
  categorie     CHAR(1 CHAR),
  code_adm      CHAR(4 CHAR)
)
tablespace MIG29
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
create index DISTRICT29.ID on DISTRICT29.IMPAYEES (ANNEE||LPAD(LTRIM(RTRIM(PERIODE)),2,'0'))
  tablespace MIG29_INDEX
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
create index DISTRICT29.IDX_ on DISTRICT29.IMPAYEES (LTRIM(RTRIM(DISTRICT))||LPAD(LTRIM(RTRIM(TOURNEE)),3,'0')||LPAD(LTRIM(RTRIM(ORDRE)),3,'0')||ANNEE||LPAD(LTRIM(RTRIM(PERIODE)),2,'0'))
  tablespace MIG29_INDEX
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
create index DISTRICT29.IDX_IMPAYE_01 on DISTRICT29.IMPAYEES (DISTRICT, MONTANT, LTRIM(RTRIM(DISTRICT))||LPAD(LTRIM(RTRIM(TOURNEE)),3,'0')||LPAD(LTRIM(RTRIM(ORDRE)),3,'0'), ANNEE||LPAD(LTRIM(RTRIM(PERIODE)),2,'0'))
  tablespace MIG29_INDEX
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
create index DISTRICT29.IDX_IMPAYE_02 on DISTRICT29.IMPAYEES (LPAD(DISTRICT,2,'0')||LPAD(LTRIM(RTRIM(TOURNEE)),3,'0')||LPAD(LTRIM(RTRIM(ORDRE)),3,'0')||LPAD(LTRIM(RTRIM(POLICE)),5,'0'))
  tablespace MIG29_INDEX
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
create index DISTRICT29.IDX_TOU_ORD_DIS001 on DISTRICT29.IMPAYEES (LPAD(TRIM(TOURNEE),3,'0'), LPAD(TRIM(ORDRE),3,'0'), DISTRICT)
  tablespace MIG29_INDEX
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
create index DISTRICT29.ID00 on DISTRICT29.IMPAYEES (LTRIM(RTRIM(DISTRICT))||LPAD(LTRIM(RTRIM(TOURNEE)),3,'0')||LPAD(LTRIM(RTRIM(ORDRE)),3,'0'))
  tablespace MIG29_INDEX
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
prompt Creating table IMPAYEES_GC
prompt ==========================
prompt
create table DISTRICT29.IMPAYEES_GC
(
  district  VARCHAR2(2),
  police    VARCHAR2(5),
  tournee   VARCHAR2(3),
  ordre     VARCHAR2(3),
  categorie VARCHAR2(3),
  adm       VARCHAR2(4),
  z1        VARCHAR2(4),
  consfac   NUMBER,
  consred   NUMBER,
  tarifonas NUMBER,
  mtonas    NUMBER,
  net       NUMBER,
  mtpaye    NUMBER,
  z2        NUMBER,
  datepaye  VARCHAR2(8),
  codpaye   NUMBER,
  ar1       NUMBER,
  codarr    NUMBER,
  ar2       NUMBER,
  annee     NUMBER,
  mois      NUMBER
)
tablespace MIG29
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
prompt Creating table IMPAYEES_PART
prompt ============================
prompt
create table DISTRICT29.IMPAYEES_PART
(
  district  VARCHAR2(2),
  police    VARCHAR2(5),
  tournee   VARCHAR2(3),
  ordre     VARCHAR2(3),
  categorie VARCHAR2(3),
  adm       VARCHAR2(4),
  z1        VARCHAR2(4),
  consfac   NUMBER,
  consred   NUMBER,
  tarifonas NUMBER,
  mtonas    NUMBER,
  net       NUMBER,
  mtpaye    NUMBER,
  z2        NUMBER,
  datepaye  VARCHAR2(8),
  codpaye   NUMBER,
  ar1       NUMBER,
  codarr    NUMBER,
  ar2       NUMBER,
  annee     NUMBER,
  mois      NUMBER
)
tablespace MIG29
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
prompt Creating table LISTEANOMALIES_RELEVE
prompt ====================================
prompt
create table DISTRICT29.LISTEANOMALIES_RELEVE
(
  district      CHAR(2 CHAR),
  tourne        CHAR(3 CHAR),
  ordre         CHAR(3 CHAR),
  annee         CHAR(4 CHAR),
  trim          CHAR(1 CHAR),
  code_anomalie CHAR(3 CHAR),
  type_anomalie CHAR(1 CHAR)
)
tablespace MIG29
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
prompt Creating table MARQUE
prompt =====================
prompt
create table DISTRICT29.MARQUE
(
  code          CHAR(3 CHAR),
  diam_compteur VARCHAR2(4 CHAR),
  type_compteur VARCHAR2(30 CHAR),
  marque        VARCHAR2(20 CHAR),
  genre         CHAR(1 CHAR),
  classe        VARCHAR2(2 CHAR)
)
tablespace MIG29
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
create index DISTRICT29.INDX_MARQUE on DISTRICT29.MARQUE (CODE)
  tablespace MIG29_INDEX
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
prompt Creating table MIWENGAGEMENT
prompt ============================
prompt
create table DISTRICT29.MIWENGAGEMENT
(
  sub_source  VARCHAR2(100) not null,
  sub_ref     VARCHAR2(100) not null,
  sub_nom     VARCHAR2(4000) not null,
  sub_comment VARCHAR2(100),
  sut_id      NUMBER
)
tablespace MIG29
  pctfree 10
  initrans 1
  maxtrans 255;

prompt
prompt Creating table MVT_B1
prompt =====================
prompt
create table DISTRICT29.MVT_B1
(
  datemvt        CHAR(10 CHAR),
  num            NUMBER(10),
  emis           CHAR(1 CHAR),
  datep          CHAR(6 CHAR),
  zon2           CHAR(3 CHAR),
  na             CHAR(2 CHAR),
  zero1          CHAR(1 CHAR),
  no             CHAR(4 CHAR),
  zero11         CHAR(11 CHAR),
  blan4          CHAR(4 CHAR),
  zero12         CHAR(2 CHAR),
  credi          CHAR(4 CHAR),
  fonca          CHAR(7 CHAR),
  codbrt         CHAR(2 CHAR),
  bla4           CHAR(1 CHAR),
  sup            CHAR(1 CHAR),
  cmvt           CHAR(2 CHAR),
  cat            CHAR(1 CHAR),
  cent           CHAR(2 CHAR),
  zero           CHAR(1 CHAR),
  pol            CHAR(5 CHAR),
  adm            CHAR(4 CHAR),
  anpc           CHAR(1 CHAR),
  mmaa           CHAR(4 CHAR),
  m1             CHAR(7 CHAR),
  m2             CHAR(7 CHAR),
  fa             CHAR(6 CHAR),
  ex             CHAR(8 CHAR),
  cp             CHAR(1 CHAR),
  rech           CHAR(6 CHAR),
  av             CHAR(7 CHAR),
  nt             CHAR(8 CHAR),
  cnat           CHAR(1 CHAR),
  ctvas          CHAR(1 CHAR),
  blanc          CHAR(2 CHAR),
  datef          CHAR(6 CHAR),
  montant_voirie CHAR(6 CHAR)
)
tablespace MIG29
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
prompt Creating table PARAM_TOURNEE
prompt ============================
prompt
create table DISTRICT29.PARAM_TOURNEE
(
  district VARCHAR2(2) not null,
  trim     NUMBER not null,
  tier     NUMBER not null,
  six      NUMBER not null,
  m1       NUMBER not null,
  m2       NUMBER not null,
  m3       NUMBER not null
)
tablespace MIG29
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
create index DISTRICT29.IDX_PARAM_TOURN on DISTRICT29.PARAM_TOURNEE (DISTRICT, TRIM, TIER, SIX)
  tablespace MIG29_INDEX
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
create index DISTRICT29.IDX_PARAM_TOURNEE on DISTRICT29.PARAM_TOURNEE (DISTRICT, TRIM, TO_CHAR(TIER), TO_CHAR(SIX), M1, M2, M3)
  tablespace MIG29_INDEX
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
create index DISTRICT29.IDX_PARAM_TOURN1 on DISTRICT29.PARAM_TOURNEE (DISTRICT, M1, M2, M3)
  tablespace MIG29_INDEX
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
create index DISTRICT29.IDX_PARAM_TOURN2 on DISTRICT29.PARAM_TOURNEE (DISTRICT, TRIM(TO_CHAR(TIER)), TRIM(TO_CHAR(SIX)))
  tablespace MIG29_INDEX
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
create index DISTRICT29.IDX_PARAM_TOURN_3 on DISTRICT29.PARAM_TOURNEE (DISTRICT, M1, M2, M3, TIER, SIX)
  tablespace MIG29_INDEX
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
create index DISTRICT29.IDX_PARAM_TOURN_4 on DISTRICT29.PARAM_TOURNEE (TRIM(DISTRICT), TRIM(TO_CHAR(TRIM)), TRIM(TO_CHAR(TIER)), TRIM(TO_CHAR(SIX)))
  tablespace MIG29_INDEX
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
create index DISTRICT29.IDX_PARAM_TOURN_5 on DISTRICT29.PARAM_TOURNEE (TRIM(TO_CHAR(TRIM)), TRIM(TO_CHAR(SIX)), TRIM(DISTRICT), TRIM(TO_CHAR(TIER)))
  tablespace MIG29_INDEX
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
create index DISTRICT29.IDX_PARAM_TOURN_6 on DISTRICT29.PARAM_TOURNEE (TRIM(TO_CHAR(TIER)), TRIM(TO_CHAR(SIX)), TRIM(DISTRICT), TRIM(TO_CHAR(TRIM)))
  tablespace MIG29_INDEX
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
prompt Creating table POSTAL
prompt =====================
prompt
create table DISTRICT29.POSTAL
(
  code  NUMBER(10),
  desig VARCHAR2(80 CHAR)
)
tablespace MIG29
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
prompt Creating table R_CPOSTAL
prompt ========================
prompt
create table DISTRICT29.R_CPOSTAL
(
  kcpost  NUMBER(4) not null,
  libelle VARCHAR2(300) not null
)
tablespace MIG29
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
prompt Creating table REFECTION_DS
prompt ===========================
prompt
create table DISTRICT29.REFECTION_DS
(
  annee          NUMBER(10),
  district       CHAR(2 CHAR),
  localite       CHAR(2 CHAR),
  num            NUMBER(10),
  code_refection NUMBER(10),
  longueur       NUMBER(38,2),
  prix_ht        NUMBER(38,2)
)
tablespace MIG29
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
prompt Creating table REGLEMENT_DS
prompt ===========================
prompt
create table DISTRICT29.REGLEMENT_DS
(
  annee_ds                NUMBER(10),
  district                CHAR(2 CHAR),
  code_localite_ds        CHAR(2 CHAR),
  num_ds                  NUMBER(10),
  num_devis_ds            NUMBER(10),
  police                  NUMBER(10),
  paiement                CHAR(1 CHAR),
  date_paiementb2         DATE,
  trimestrialite          NUMBER(38,2),
  montant_pr_vers_ds      NUMBER(38,2),
  montant_credit_max      NUMBER(38,2),
  montant_total_cpt       NUMBER(38,2),
  montant_extension       NUMBER(38,2),
  partextensionpayee      CHAR(1 CHAR),
  avanceconsommationpayee CHAR(1 CHAR),
  nbrannee                NUMBER(10),
  prise_charge            CHAR(1 CHAR),
  date_prise_charge       DATE,
  nbr_echeance_total      NUMBER(10),
  nbr_echeance_restante   NUMBER(10),
  accompte                NUMBER(38,2),
  remarque                VARCHAR2(160 CHAR),
  nbrcopiesbva            NUMBER(10),
  dmrfac                  CHAR(1 CHAR),
  tournee                 CHAR(3 CHAR),
  ordre                   CHAR(3 CHAR),
  prise_chargeb2          CHAR(1 CHAR),
  montantdmrttc           NUMBER(38,2),
  montantdmrpaye          NUMBER(38,2),
  montantdmrventile       NUMBER(38,2),
  num                     NUMBER(10)
)
tablespace MIG29
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
prompt Creating table RELEVEGC
prompt =======================
prompt
create table DISTRICT29.RELEVEGC
(
  district          CHAR(2 CHAR),
  police            NUMBER(10),
  annee             NUMBER(10),
  mois              CHAR(2 CHAR),
  indexr            NUMBER(10),
  indexa            NUMBER(10),
  tourne            CHAR(3 CHAR),
  ordre             CHAR(3 CHAR),
  prorata           NUMBER(10),
  cpt_tourne        CHAR(1 CHAR),
  etat              CHAR(30 CHAR),
  codefermeture     CHAR(1 CHAR),
  codeouverture     CHAR(1 CHAR),
  coderesiliation   CHAR(1 CHAR),
  anomalie_niche    CHAR(2 CHAR),
  anomalie_compteur CHAR(2 CHAR),
  anomalie_fuite    CHAR(2 CHAR),
  consommation      NUMBER(10),
  date_releve       DATE
)
tablespace MIG29
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
create index DISTRICT29.INDEX_REL_GC on DISTRICT29.RELEVEGC (TRIM(DISTRICT), LPAD(TRIM(TO_CHAR(POLICE)),5,'0'), LPAD(TRIM(TOURNE),3,'0'), LPAD(TRIM(ORDRE),3,'0'), TRIM(MOIS), TRIM(TO_CHAR(ANNEE)))
  tablespace MIG29_INDEX
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
create index DISTRICT29.INDEX_REL_GC2 on DISTRICT29.RELEVEGC (TRIM(DISTRICT), LPAD(TRIM(TO_CHAR(POLICE)),5,'0'), LPAD(TRIM(TOURNE),3,'0'), LPAD(TRIM(ORDRE),3,'0'))
  tablespace MIG29_INDEX
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
prompt Creating table RELEVET
prompt ======================
prompt
create table DISTRICT29.RELEVET
(
  district          CHAR(2 CHAR),
  police            NUMBER(10),
  annee             NUMBER(10),
  trimestre         CHAR(1 CHAR),
  indexr            NUMBER(10),
  indexa            NUMBER(10),
  tourne            CHAR(3 CHAR),
  ordre             CHAR(3 CHAR),
  prorata           NUMBER(10),
  cpt_tourne        CHAR(1 CHAR),
  etat              CHAR(30 CHAR),
  codefermeture     CHAR(1 CHAR),
  codeouverture     CHAR(1 CHAR),
  coderesiliation   CHAR(1 CHAR),
  anomalie_niche    CHAR(2 CHAR),
  anomalie_compteur CHAR(2 CHAR),
  anomalie_fuite    CHAR(2 CHAR),
  consommation      NUMBER(10),
  date_releve       DATE
)
tablespace MIG29
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
create index DISTRICT29.INDX_RELEVET1 on DISTRICT29.RELEVET (TRIM(DISTRICT), UPPER(TRIM(CODERESILIATION)))
  tablespace MIG29_INDEX
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
create index DISTRICT29.INDX_RELEVET2 on DISTRICT29.RELEVET (TRIM(TOURNE)||TRIM(ORDRE))
  tablespace MIG29_INDEX
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
create index DISTRICT29.INDX_RELEVET3 on DISTRICT29.RELEVET (LPAD(TRIM(TOURNE),3,'0'), LPAD(TRIM(ORDRE),3,'0'))
  tablespace MIG29_INDEX
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
create index DISTRICT29.INDX_RELEVET4 on DISTRICT29.RELEVET (TRIM(DISTRICT), LPAD(TRIM(TOURNE),3,'0'), LPAD(TRIM(ORDRE),3,'0'))
  tablespace MIG29_INDEX
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
create index DISTRICT29.INDX_RELEVET5 on DISTRICT29.RELEVET (TRIM(DISTRICT), TRIM(TO_CHAR(ANNEE)), LPAD(TRIM(TOURNE),3,'0'), LPAD(TRIM(ORDRE),3,'0'))
  tablespace MIG29_INDEX
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
create index DISTRICT29.INDX_RELEVET6 on DISTRICT29.RELEVET (TOURNE)
  tablespace MIG29_INDEX
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
prompt Creating table RIB_GR
prompt =====================
prompt
create table DISTRICT29.RIB_GR
(
  dist VARCHAR2(2),
  tou  VARCHAR2(3),
  ord  VARCHAR2(3),
  rib  VARCHAR2(22),
  nom  VARCHAR2(100),
  cpos VARCHAR2(4)
)
tablespace MIG29
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
prompt Creating table RIBM
prompt ===================
prompt
create table DISTRICT29.RIBM
(
  dist   VARCHAR2(2 CHAR),
  tou    VARCHAR2(3 CHAR),
  ord    VARCHAR2(3 CHAR),
  banque VARCHAR2(20 CHAR)
)
tablespace MIG29
  pctfree 10
  initrans 1
  maxtrans 255;

prompt
prompt Creating table RIB_PART
prompt =======================
prompt
create table DISTRICT29.RIB_PART
(
  dist VARCHAR2(2),
  tou  VARCHAR2(3),
  ord  VARCHAR2(3),
  rib  VARCHAR2(22),
  nom  VARCHAR2(100),
  cpos VARCHAR2(4)
)
tablespace MIG29
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
prompt Creating table RIBT
prompt ===================
prompt
create table DISTRICT29.RIBT
(
  dist   VARCHAR2(2 CHAR),
  tou    VARCHAR2(3 CHAR),
  ord    VARCHAR2(3 CHAR),
  banque VARCHAR2(20 CHAR)
)
tablespace MIG29
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
prompt Creating table ROLE_MENS
prompt ========================
prompt
create table DISTRICT29.ROLE_MENS
(
  dateexp CHAR(8 CHAR),
  distr   CHAR(2 CHAR) not null,
  police  NUMBER(10) not null,
  annee   NUMBER(10) not null,
  mois    CHAR(2 CHAR) not null,
  six     CHAR(1 CHAR),
  net     NUMBER(38,2) not null,
  datl    CHAR(8 CHAR),
  codr    CHAR(1 CHAR),
  ancrep  NUMBER(10) not null,
  nourep  NUMBER(10) not null,
  tcons   NUMBER(10) not null,
  cpreav  CHAR(3 CHAR),
  cfer    CHAR(3 CHAR),
  cob     CHAR(3 CHAR),
  cay     CHAR(3 CHAR),
  conas   CHAR(3 CHAR),
  tarifs  CHAR(2 CHAR),
  nappr   NUMBER(10) not null,
  cbrch   CHAR(2 CHAR),
  cctr    CHAR(2 CHAR),
  branch  NUMBER(38,2) not null,
  partco  NUMBER(38,2) not null,
  extens  NUMBER(38,2) not null,
  facade  NUMBER(38,2) not null,
  pfina   NUMBER(38,2) not null,
  echres  NUMBER(10) not null,
  ecgro   NUMBER(10) not null,
  categ   CHAR(2 CHAR),
  tour    CHAR(3 CHAR) not null,
  ordr    CHAR(3 CHAR) not null,
  coef_q  CHAR(5 CHAR)
)
tablespace MIG29
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
create index DISTRICT29.IDX_P on DISTRICT29.ROLE_MENS (POLICE, LTRIM(RTRIM(DISTR)), LTRIM(RTRIM(MOIS)))
  tablespace MIG29_INDEX
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
create index DISTRICT29.IDX_R on DISTRICT29.ROLE_MENS (LPAD(LTRIM(RTRIM(DISTR)),2,'0')||LPAD(LTRIM(RTRIM(TOUR)),3,'0')||LPAD(LTRIM(RTRIM(ORDR)),3,'0')||LPAD(LTRIM(RTRIM(TO_CHAR(POLICE))),5,'0'), LTRIM(RTRIM(TO_CHAR(ANNEE))), LTRIM(RTRIM(MOIS)))
  tablespace MIG29_INDEX
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
create index DISTRICT29.IDXX on DISTRICT29.ROLE_MENS (LPAD(LTRIM(RTRIM(DISTR)),2,'0'), LTRIM(RTRIM(TO_CHAR(ANNEE))), LTRIM(RTRIM(MOIS)), LPAD(LTRIM(RTRIM(TOUR)),3,'0'), LPAD(LTRIM(RTRIM(ORDR)),3,'0'))
  tablespace MIG29_INDEX
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
create index DISTRICT29.IXD_ROL_MENS1 on DISTRICT29.ROLE_MENS (LPAD(TRIM(DISTR),2,'0'), TRIM(TO_CHAR(ANNEE)), TRIM(MOIS), LPAD(TRIM(TOUR),3,'0'), LPAD(TRIM(ORDR),3,'0'))
  tablespace MIG29_INDEX
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
prompt Creating table ROLE_TRIM
prompt ========================
prompt
create table DISTRICT29.ROLE_TRIM
(
  dateexp CHAR(8 CHAR),
  distr   CHAR(10 CHAR) not null,
  police  VARCHAR2(10) not null,
  annee   VARCHAR2(10) not null,
  trim    CHAR(1 CHAR) not null,
  tiers   CHAR(1 CHAR),
  six     CHAR(1 CHAR),
  net     NUMBER(38,2) not null,
  datl    CHAR(8 CHAR),
  codr    CHAR(1 CHAR),
  ancrep  NUMBER(10) not null,
  nourep  NUMBER(10) not null,
  tcons   NUMBER(10) not null,
  cpreav  CHAR(3 CHAR),
  cfer    CHAR(3 CHAR),
  cob     CHAR(3 CHAR),
  cay     CHAR(3 CHAR),
  conas   CHAR(3 CHAR),
  tarifs  CHAR(2 CHAR),
  nappr   NUMBER(10) not null,
  cbrch   CHAR(2 CHAR),
  cctr    CHAR(2 CHAR),
  branch  NUMBER(38,2) not null,
  partco  NUMBER(38,2) not null,
  extens  NUMBER(38,2),
  facade  NUMBER(38,2) not null,
  pfina   NUMBER(38,2) not null,
  echres  NUMBER(10) not null,
  ecgro   NUMBER(10) not null,
  categ   CHAR(2 CHAR),
  tour    CHAR(3 CHAR) not null,
  ordr    CHAR(3 CHAR) not null,
  coef_q  CHAR(5 CHAR),
  xxx     CHAR(5 CHAR)
)
tablespace MIG29
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
create index DISTRICT29.IDX_ROLE_MENS on DISTRICT29.ROLE_TRIM (LPAD(LTRIM(RTRIM(DISTR)),2,'0')||LPAD(LTRIM(RTRIM(TOUR)),3,'0')||LPAD(LTRIM(RTRIM(ORDR)),3,'0')||LPAD(LTRIM(RTRIM(POLICE)),5,'0'), LTRIM(RTRIM(ANNEE)), LTRIM(RTRIM(TRIM)))
  tablespace MIG29_INDEX
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
create index DISTRICT29.IDX_ROLE_MENS2 on DISTRICT29.ROLE_TRIM (LPAD(LTRIM(RTRIM(DISTR)),2,'0'), LTRIM(RTRIM(ANNEE)), LTRIM(RTRIM(TRIM)), LPAD(LTRIM(RTRIM(TOUR)),3,'0'), LPAD(LTRIM(RTRIM(ORDR)),3,'0'))
  tablespace MIG29_INDEX
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
create index DISTRICT29.IDX_ROLE_MENS3 on DISTRICT29.ROLE_TRIM (POLICE, LTRIM(RTRIM(DISTR)), LTRIM(RTRIM(TOUR)), LTRIM(RTRIM(ORDR)), RTRIM(CATEG), LTRIM(RTRIM(TIERS)), LTRIM(RTRIM(TRIM)), LTRIM(RTRIM(SIX)))
  tablespace MIG29_INDEX
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
create index DISTRICT29.IDX_ROLE_MENS4 on DISTRICT29.ROLE_TRIM (POLICE, LTRIM(RTRIM(DISTR)), LTRIM(RTRIM(TOUR)), LTRIM(RTRIM(ORDR)), LTRIM(RTRIM(CATEG)), LTRIM(RTRIM(TIERS)), LTRIM(RTRIM(TRIM)), LTRIM(RTRIM(SIX)), ANNEE)
  tablespace MIG29_INDEX
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
create index DISTRICT29.IDX_ROLE_TRIM4 on DISTRICT29.ROLE_TRIM (POLICE, LTRIM(RTRIM(DISTR)), LTRIM(RTRIM(TOUR)), LTRIM(RTRIM(ORDR)), LTRIM(RTRIM(TIERS)), LTRIM(RTRIM(TRIM)), LTRIM(RTRIM(SIX)), ANNEE)
  tablespace MIG29_INDEX
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
create index DISTRICT29.IXD_ROL_TRIM on DISTRICT29.ROLE_TRIM (LPAD(TRIM(DISTR),2,'0'), TRIM(ANNEE), TRIM(TRIM), LPAD(TRIM(TOUR),3,'0'), LPAD(TRIM(ORDR),3,'0'))
  tablespace MIG29_INDEX
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
prompt Creating table TOURNE
prompt =====================
prompt
create table DISTRICT29.TOURNE
(
  code     CHAR(3 CHAR),
  desig    VARCHAR2(80 CHAR),
  ntiers   NUMBER(10),
  nsixieme NUMBER(10)
)
tablespace MIG29
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
create index DISTRICT29.INDX_TOURNE on DISTRICT29.TOURNE (TRIM(CODE), TRIM(TO_CHAR(NTIERS)), TRIM(TO_CHAR(NSIXIEME)))
  tablespace MIG29_INDEX
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
create index DISTRICT29.INDX_TOURNE_1 on DISTRICT29.TOURNE (LPAD(TRIM(CODE),3,'0'), TRIM(TO_CHAR(NTIERS)), TRIM(TO_CHAR(NSIXIEME)))
  tablespace MIG29_INDEX
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
create index DISTRICT29.INDX_TOURNE_2 on DISTRICT29.TOURNE (CODE)
  tablespace MIG29_INDEX
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
create index DISTRICT29.INDX_TOURNE_3 on DISTRICT29.TOURNE (CODE, TRIM(TO_CHAR(NTIERS)), TRIM(TO_CHAR(NSIXIEME)))
  tablespace MIG29_INDEX
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
create index DISTRICT29.INDX_TOURNE_4 on DISTRICT29.TOURNE (TRIM(TO_CHAR(NTIERS)), TRIM(TO_CHAR(NSIXIEME)), CODE)
  tablespace MIG29_INDEX
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


spool off
