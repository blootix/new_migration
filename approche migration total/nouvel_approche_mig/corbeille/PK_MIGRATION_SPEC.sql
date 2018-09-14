CREATE OR REPLACE PACKAGE PK_MIGRATION
AS

PROCEDURE Migrer
  (
    p_pk_etape out varchar2,
    p_pk_exception out varchar2,
    p_param in number default 0
  );

end PK_MIGRATION;
