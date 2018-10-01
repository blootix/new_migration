create table prob_mig_client(obj_refe varchar2(400),code_except varchar2(400),message_except varchar2(400),pk_etape varchar2(400),date_except date);
create table prob_mig_pdl(obj_refe varchar2(400),code_except varchar2(400),message_except varchar2(400),pk_etape varchar2(400),date_except date);
create table prob_mig_contrat(obj_refe varchar2(400),code_except varchar2(400),message_except varchar2(400),pk_etape varchar2(400),date_except date);
create table prob_mig_releve(obj_refe varchar2(400),code_except varchar2(400),message_except varchar2(400),pk_etape varchar2(400),date_except date);
create table prob_mig_facture(obj_refe varchar2(400),code_except varchar2(400),message_except varchar2(400),pk_etape varchar2(400),date_except date);


alter table genstreet modify str_name varchar2(400);
alter table genstreet modify str_namek varchar2(400);
alter table genstreet modify str_namer varchar2(400);

alter table client add par_id number(10);
alter table branchement add spt_id number(10);
alter table branchement add sag_id(number(10);

update client set par_id = null where par_id is not null;
update branchement set sag_id = null, spt_id = null where spt_id is not null;