----------------liste table restante a metttre dans le pivot
create table PARAM_TOURNEE
(
  district VARCHAR2(2) not null,
  trim     NUMBER not null,
  tier     NUMBER not null,
  six      NUMBER not null,
  m1       NUMBER not null,
  m2       NUMBER not null,
  m3       NUMBER not null
);

create table R_CPOSTAL
( kcpost  NUMBER(4) not null,
  libelle VARCHAR2(300) not null
);

create table MIWENGAGEMENT
(
  sub_source  VARCHAR2(100) not null,
  sub_ref     VARCHAR2(100) not null,
  sub_nom     VARCHAR2(4000) not null,
  sub_comment VARCHAR2(100),
  sut_id      NUMBER
);