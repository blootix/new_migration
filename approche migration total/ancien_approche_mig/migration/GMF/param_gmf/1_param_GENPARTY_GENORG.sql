create or replace procedure param_GENPARTY_GENORG(district_ varchar2)
is
 
V_PAR_ID number;
v_VOW_TYPSAG number;
v_VOW_PARTYTP number;
v_VOW_TIPLINE number;
v_VOW_BANKFMT number;
 begin

 V_VOW_TYPSAG:=4397 ;--Collectivités publiques
 V_VOW_PARTYTP:=2884;--Client
 V_VOW_TIPLINE:=4143;--TIP BANTEC
 V_VOW_BANKFMT:=2580;--Format
 
select seq_GENPARTY.nextval into V_PAR_ID from dual;
insert into GENPARTY (
                      PAR_ID,
                      PAR_REFE,
					  PAR_LNAME,
					  PAR_KNAME,
					  ADR_ID,
					  VOW_TYPSAG,
					  VOW_PARTYTP,
					  PAR_STATUS,
					  PAR_PROFEXOTVA,
					  PAR_SEARCH,
					  PAR_CREDT
					  )
              values (
			          V_PAR_ID,
			          district_,
					  'DISTRICT'||district_,
					  'DISTRICT'||district_,
					  0,
					  v_VOW_TYPSAG,
					  v_VOW_PARTYTP ,
					  1,
					  0,
					  1,
					  sysdate
					  );
					  
insert into genorganization (
							ORG_ID,
							ORG_CODE,
							ORG_NAME,
							ORG_TIPNNE,
							ORG_TIPCENTRE,
							ORG_TIPDOCUMENT,
							ORG_SEPAICS,
							BAP_CREDIT_ID,
							BAP_DEBIT_ID,
							VOW_BANKFMT,
							VOW_TIPLINE,
							CUR_ID,
							ORG_CREDT,
							ORG_NAME_A,
							VOW_TYPSTRUCT,
							ORG_ORMCPOST,
							ORG_ORMCCOLL
							)
				      values 
					       (V_PAR_ID,
						   district_,
						   'DISTRICT'||district_,
						   45,
						   12,
						   '5',
						   null,
						   2073,
						   2073,
						   v_VOW_BANKFMT,
						   v_VOW_TIPLINE,
						   4,
						   sysdate,
						  'DISTRICT'||district_,
						  4457,
						   null,
						   null
						   );
-------------------------------------------------------

select seq_GENPARTY.nextval into V_PAR_ID from dual;

		insert into GENPARTY (
							PAR_ID,
							PAR_REFE,
							PAR_LNAME,
							PAR_KNAME,
							ADR_ID,
							VOW_TYPSAG,
							VOW_PARTYTP,
							PAR_STATUS,
							PAR_PROFEXOTVA,
							PAR_SEARCH,
							PAR_CREDT)
					 values  
						   (V_PAR_ID,
						   'D.G.'||district_,
						   'DIRECTION GENERALE',
						   'DIRECTION GENERALE',
						   0,
						   null,
						   v_VOW_PARTYTP,
						   1,
						   0,
						   1,
						   sysdate);
				   
insert into  genorganization (
							ORG_ID,
							ORG_CODE,
							ORG_NAME,
							ORG_TIPNNE,
							ORG_TIPCENTRE,
							ORG_TIPDOCUMENT,
							ORG_SEPAICS,
							BAP_CREDIT_ID,
							BAP_DEBIT_ID,
							VOW_BANKFMT,
							VOW_TIPLINE,
							CUR_ID,
							ORG_CREDT,
							ORG_UPDTDT,
							ORG_UPDTBY,
							ORG_NAME_A,
							VOW_TYPSTRUCT,
							ORG_ORMCPOST,
							ORG_ORMCCOLL
							)
                     values 
						 (V_PAR_ID,
						 'D.G.'||district_,
						 'DIRECTION GENERALE',
						 null,
						 null,
						 null,
						 null,
						 null,
						 null,
						 null,
						 null, 
						 4,
						 sysdate,
						 null,
						 null,
						 'DIRECTION GENERALE',
						 null,
						 null,
						 null);
-----------------------------------------------

select seq_GENPARTY.nextval into V_PAR_ID from dual;
insert into GENPARTY (
						PAR_ID,
						PAR_REFE,
						PAR_LNAME,
						PAR_KNAME,
						ADR_ID,
						VOW_TYPSAG,
						VOW_PARTYTP,
						PAR_STATUS,
						PAR_PROFEXOTVA,
						PAR_SEARCH,
						PAR_CREDT
						)
				values (
						V_PAR_ID,
						'D.E.'||district_,
						'DIRECTION EXPLOITATION',
						'DIRECTION EXPLOITATION',
						0,
						null,
						v_VOW_PARTYTP,
						1,
						0,
						1,
						sysdate
						);
insert into genorganization (
								ORG_ID,
								ORG_CODE,
								ORG_NAME,
								ORG_TIPNNE,
								ORG_TIPCENTRE,
								ORG_TIPDOCUMENT,
								ORG_SEPAICS,
								BAP_CREDIT_ID,
								BAP_DEBIT_ID,
								VOW_BANKFMT,
								VOW_TIPLINE,
								CUR_ID,
								ORG_CREDT,
								ORG_UPDTDT,
								ORG_UPDTBY,
								ORG_NAME_A,
								VOW_TYPSTRUCT,
								ORG_ORMCPOST,
								ORG_ORMCCOLL
							)
					values (
					        V_PAR_ID,
							'D.E.'||district_,
							'DIRECTION EXPLOITATION',
							null,
							null,
							null,
							null,
							null,
							null,
							null,
							null,
							4,
							sysdate,
							null,
							null,
							'DIRECTION EXPLOITATION',
							null,
							null,
							null);

----------------------------------------------------
select seq_GENPARTY.nextval into V_PAR_ID from dual;
insert into GENPARTY (
						PAR_ID,
						PAR_REFE,
						PAR_LNAME,
						PAR_KNAME,
						ADR_ID,
						VOW_TYPSAG,
						VOW_PARTYTP,
						PAR_STATUS,
						PAR_PROFEXOTVA,
						PAR_SEARCH,
						PAR_CREDT
						)
				values (
						V_PAR_ID,
						'D.R.G.T.'||district_,
						'DIRECTION REGIONAL GRAND TUNIS',
						'DIRECTION REGIONAL GRAND TUNIS',
						0,
						null,
						v_VOW_PARTYTP,
						1,
						0,
						1,
						sysdate);
insert into  genorganization (
								ORG_ID,
								ORG_CODE,
								ORG_NAME,
								ORG_TIPNNE,
								ORG_TIPCENTRE,
								ORG_TIPDOCUMENT,
								ORG_SEPAICS,
								BAP_CREDIT_ID,
								BAP_DEBIT_ID,
								VOW_BANKFMT,
								VOW_TIPLINE,
								CUR_ID,
								ORG_CREDT,
								ORG_UPDTDT,
								ORG_UPDTBY,
								ORG_NAME_A,
								VOW_TYPSTRUCT,
								ORG_ORMCPOST,
								ORG_ORMCCOLL
							)
					values (
					        V_PAR_ID,
					        'D.R.G.T.'||district_,
							'DIRECTION REGIONAL GRAND TUNIS',
							null,
							null,
							null,
							null, 
							null,
							null,
							null,
							null,
							4,
							sysdate,
							null,
							null,
							'DIRECTION REGIONAL GRAND TUNIS',
							null,
							null,
							null);

--------------------------------------------------
select seq_GENPARTY.nextval into V_PAR_ID from dual;
insert into GENPARTY (
						PAR_ID,
						PAR_REFE,
						PAR_LNAME,
						PAR_KNAME,
						ADR_ID,
						VOW_TYPSAG,
						VOW_PARTYTP,
						PAR_STATUS,
						PAR_PROFEXOTVA,
						PAR_SEARCH,
						PAR_CREDT
					)
			values (
			        V_PAR_ID,
					'S.A.F.J.'||district_,
					'SERVICE ADM. FIN. JUR. (S.A.F.J)',
					'SERVICE ADM. FIN. JUR. (S.A.F.J)',
					0,
					null,
					V_VOW_PARTYTP,
					1,
					0,
					1,
					sysdate
					);
					
insert into  genorganization (
								ORG_ID,
								ORG_CODE,
								ORG_NAME,
								ORG_TIPNNE,
								ORG_TIPCENTRE,
								ORG_TIPDOCUMENT,
								ORG_SEPAICS,
								BAP_CREDIT_ID,
								BAP_DEBIT_ID,
								VOW_BANKFMT,
								VOW_TIPLINE,
								CUR_ID,
								ORG_CREDT,
								ORG_UPDTDT,
								ORG_UPDTBY,
								ORG_NAME_A,
								VOW_TYPSTRUCT,
								ORG_ORMCPOST,
								ORG_ORMCCOLL
								)
                        values (
						        V_PAR_ID,
								'S.A.F.J.'||district_,
								'SERVICE ADM. FIN. JUR. (S.A.F.J)',
								null,
								null,
								null,
								null,
								null,
								null,
								null,
								null,
								4,
								sysdate,
								null,
								null,
								'SERVICE ADM. FIN. JUR. (S.A.F.J)',
								null,
								null,
								null);

----------------------------------------------------
select seq_GENPARTY.nextval into V_PAR_ID  from dual;
insert into GENPARTY (
						PAR_ID,
						PAR_REFE,
						PAR_LNAME,
						PAR_KNAME,
						ADR_ID,
						VOW_TYPSAG,
						VOW_PARTYTP,
						PAR_STATUS,
						PAR_PROFEXOTVA,
						PAR_SEARCH,
						PAR_CREDT
						)
				values (
				        V_PAR_ID,
						'B.A.'||district_,
						'BUREAU ABONNE',
						'BUREAU ABONNE',
						0,
						null,
						V_VOW_PARTYTP,
						1,
						0,
						1,
						sysdate);
insert into  genorganization (
                              ORG_ID,
							  ORG_CODE,
							  ORG_NAME,
							  ORG_TIPNNE,
							  ORG_TIPCENTRE,
							  ORG_TIPDOCUMENT,
							  ORG_SEPAICS,
							  BAP_CREDIT_ID,
							  BAP_DEBIT_ID,
							  VOW_BANKFMT,
							  VOW_TIPLINE,
							  CUR_ID,
							  ORG_CREDT,
							  ORG_UPDTDT,
							  ORG_UPDTBY,
							  ORG_NAME_A,
							  VOW_TYPSTRUCT,
							  ORG_ORMCPOST,
							  ORG_ORMCCOLL
							  )
					values (
					        V_PAR_ID,
							'B.A.'||district_,
							'BUREAU ABONNE',
							null,
							null,
							null,
							null,
							null,
							null,
							null,
							null,
							4,
							sysdate,
							null,
							null,
							'BUREAU ABONNE',
							null,
							null,
							null
							);

--------------------------------------------------------
select seq_GENPARTY.nextval into V_PAR_ID from dual;
insert into GENPARTY (
                      PAR_ID,
					  PAR_REFE,
					  PAR_LNAME,
					  PAR_KNAME,
					  ADR_ID,
					  VOW_TYPSAG,
					  VOW_PARTYTP,
					  PAR_STATUS,
					  PAR_PROFEXOTVA,
					  PAR_SEARCH,
					  PAR_CREDT
					  )
              values (
			          V_PAR_ID,
					  'B.R.'||district_,
					  'BUREAU RELEVE',
					  'BUREAU RELEVE',
					  0,
					  null,
					  v_VOW_PARTYTP,
					  1,
					  0,
					  1,
					  sysdate
					  );
insert into  genorganization (
							  ORG_ID,
							  ORG_CODE,
							  ORG_NAME,
							  ORG_TIPNNE,
							  ORG_TIPCENTRE,
							  ORG_TIPDOCUMENT,
							  ORG_SEPAICS,
							  BAP_CREDIT_ID,
							  BAP_DEBIT_ID,
							  VOW_BANKFMT,
							  VOW_TIPLINE,
							  CUR_ID,
							  ORG_CREDT,
							  ORG_UPDTDT,
							  ORG_UPDTBY,
							  ORG_NAME_A,
							  VOW_TYPSTRUCT,
							  ORG_ORMCPOST,
							  ORG_ORMCCOLL
							  )
                      values (
					          V_PAR_ID,
							  'B.R.'||district_,
							  'BUREAU RELEVE',
							  2,
							  1,
							  '8',
							  null,
							  null,
							  null,
							  null,
							  null,
							  4,
							  sysdate,
							  null,
							  1,
							  'BUREAU RELEVE',
							  5050,
							  null,
							  null
							  );

------------------------------------
select seq_GENPARTY.nextval into V_PAR_ID from dual;
insert into GENPARTY (
                      PAR_ID,
					  PAR_REFE,
					  PAR_LNAME,
					  PAR_KNAME,
					  ADR_ID,
					  VOW_TYPSAG,
					  VOW_PARTYTP,
					  PAR_STATUS,
					  PAR_PROFEXOTVA,
					  PAR_SEARCH,
					  PAR_CREDT
					  )
              values (
			          V_PAR_ID,
					  'S.A.'||district_,
					  'SECTION ADMINISTRATIVE',
					  'SECTION ADMINISTRATIVE',
					  0,
					  null,
					  v_VOW_PARTYTP,
					  1,
					  0,
					  1,
					  sysdate);
					  
insert into  genorganization (
							  ORG_ID,
							  ORG_CODE,
							  ORG_NAME,
							  ORG_TIPNNE,
							  ORG_TIPCENTRE,
							  ORG_TIPDOCUMENT,
							  ORG_SEPAICS,
							  BAP_CREDIT_ID,
							  BAP_DEBIT_ID,
							  VOW_BANKFMT,
							  VOW_TIPLINE,
							  CUR_ID,
							  ORG_CREDT,
							  ORG_UPDTDT,
							  ORG_UPDTBY,
							  ORG_NAME_A,
							  VOW_TYPSTRUCT,
							  ORG_ORMCPOST,
							  ORG_ORMCCOLL
							  )
                      values (
					          V_PAR_ID,
							  'S.A.'||district_,
							  'SECTION ADMINISTRATIVE',
							  null,
							  null,
							  null,
							  null,
							  null,
							  null,
							  null,
							  null,
							  4,
							  sysdate,
							  null,
							  null,
							  'SECTION ADMINISTRATIVE',
							  null,
							  null,
							  null
							  );
--------------------------------------------------
select seq_GENPARTY.nextval into V_PAR_ID from dual;
insert into GENPARTY (
					  PAR_ID,
					  PAR_REFE,
					  PAR_LNAME,
					  PAR_KNAME,
					  ADR_ID,
					  VOW_TYPSAG,
					  VOW_PARTYTP,
					  PAR_STATUS,
					  PAR_PROFEXOTVA,
					  PAR_SEARCH,
					  PAR_CREDT
					  )
              values (
			          V_PAR_ID,
					  'S.E.'||district_,
					  'SERVICE ETUDES',
					  'SERVICE ETUDES',
					  0,
					  null,
					  v_VOW_PARTYTP,
					  1,
					  0,
					  1,
					  sysdate
					  );
insert into  genorganization (
                              ORG_ID,
							  ORG_CODE,
							  ORG_NAME,
							  ORG_TIPNNE,
							  ORG_TIPCENTRE,
							  ORG_TIPDOCUMENT,
							  ORG_SEPAICS,
							  BAP_CREDIT_ID,
							  BAP_DEBIT_ID,
							  VOW_BANKFMT,
							  VOW_TIPLINE,
							  CUR_ID,
							  ORG_CREDT,
							  ORG_UPDTDT,
							  ORG_UPDTBY,
							  ORG_NAME_A,
							  VOW_TYPSTRUCT,
							  ORG_ORMCPOST,
							  ORG_ORMCCOLL
							  )
                      values (
					          V_PAR_ID,
							  'SE.'||district_,
							  'SERVICE ETUDES',
							  null,
							  null,
							  null,
							  null,
							  null,
							  null,
							  null,
							  null,
							  4,
							  sysdate,
							  null,
							  null,
							  'SERVICE ETUDES',
							  null,
							  null,
							  null
							  );
----------------------------------------------------------

select seq_GENPARTY.nextval into V_PAR_ID from dual;
insert into GENPARTY (
                      PAR_ID,
					  PAR_REFE,
					  PAR_LNAME,
					  PAR_KNAME,
					  ADR_ID,
					  VOW_TYPSAG,
					  VOW_PARTYTP,
					  PAR_STATUS,
					  PAR_PROFEXOTVA,
					  PAR_SEARCH,
					  PAR_CREDT
					  )
              values (
			          V_PAR_ID,
					  'B.E.'||district_,
					  'BUREAU ETUDE',
					  'BUREAU ETUDE',
					  0,
					  null,
					  v_VOW_PARTYTP,
					  1,
					  0,
					  1,
					  sysdate
					  );
insert into  genorganization (
							  ORG_ID,
							  ORG_CODE,
							  ORG_NAME,
							  ORG_TIPNNE,
							  ORG_TIPCENTRE,
							  ORG_TIPDOCUMENT,
							  ORG_SEPAICS,
							  BAP_CREDIT_ID,
							  BAP_DEBIT_ID,
							  VOW_BANKFMT,
							  VOW_TIPLINE,
							  CUR_ID,
							  ORG_CREDT,
							  ORG_UPDTDT,
							  ORG_UPDTBY,
							  ORG_NAME_A,
							  VOW_TYPSTRUCT,
							  ORG_ORMCPOST,
							  ORG_ORMCCOLL
							  )
                      values (
					          V_PAR_ID,
							  'B.E.'||district_,
							  'BUREAU ETUDE',
							  null,
							  null,
							  null,
							  null,
							  null,
							  null,
							  null,
							  null,
							  4,
							  sysdate,
							  null,
							  null,
							  'BUREAU ETUDE',
							  null,
							  null,
							  null
							  );
--------------------------------------------

select seq_GENPARTY.nextval into V_PAR_ID from dual;
insert into GENPARTY (
					  PAR_ID,
					  PAR_REFE,
					  PAR_LNAME,
					  PAR_KNAME,
					  ADR_ID,
					  VOW_TYPSAG,
					  VOW_PARTYTP,
					  PAR_STATUS,
					  PAR_PROFEXOTVA,
					  PAR_SEARCH,
					  PAR_CREDT
					  )
			  values (
			          V_PAR_ID,
					  'S.R.'||district_,
					  'SECTION REGULATION',
					  'SECTION REGULATION',
					  0,
					  null,
					  v_VOW_PARTYTP,
					  1,
					  0,
					  1,
					  sysdate
					  );
					  
insert into  genorganization (
                              ORG_ID,
							  ORG_CODE,
							  ORG_NAME,
							  ORG_TIPNNE,
							  ORG_TIPCENTRE,
							  ORG_TIPDOCUMENT,
							  ORG_SEPAICS,
							  BAP_CREDIT_ID,
							  BAP_DEBIT_ID,
							  VOW_BANKFMT,
							  VOW_TIPLINE,
							  CUR_ID,
							  ORG_CREDT,
							  ORG_UPDTDT,
							  ORG_UPDTBY,
							  ORG_NAME_A,
							  VOW_TYPSTRUCT,
							  ORG_ORMCPOST,
							  ORG_ORMCCOLL
							  )
                      values (
					          V_PAR_ID,
							  'S.R.'||district_,
							  'SECTION REGULATION',
							  null,
							  null,
							  null,
							  null,
							  null,
							  null,
							  null,
							  null,
							  4,
							  sysdate,
							  null,
							  null,
							  'SECTION REGULATION',
							  null,
							  null,
							  null
							  );
--------------------------------------
select seq_GENPARTY.nextval into V_PAR_ID from dual;
insert into GENPARTY (
                      PAR_ID,
					  PAR_REFE,
					  PAR_LNAME,
					  PAR_KNAME,
					  ADR_ID,
					  VOW_TYPSAG,
					  VOW_PARTYTP,
					  PAR_STATUS,
					  PAR_PROFEXOTVA,
					  PAR_SEARCH,
					  PAR_CREDT
					  )
              values (
			          V_PAR_ID,
					  'S.EXP.'||district_,
					  'SERVICE EXPLOITATION',
					  'SERVICE EXPLOITATION',
					  0,
					  null,
					  v_VOW_PARTYTP,
					  1,
					  0,
					  1,
					  sysdate
					  );
insert into  genorganization (
							  ORG_ID,
							  ORG_CODE,
							  ORG_NAME,
							  ORG_TIPNNE,
							  ORG_TIPCENTRE,
							  ORG_TIPDOCUMENT,
							  ORG_SEPAICS,
							  BAP_CREDIT_ID,
							  BAP_DEBIT_ID,
							  VOW_BANKFMT,
							  VOW_TIPLINE,
							  CUR_ID,
							  ORG_CREDT,
							  ORG_UPDTDT,
							  ORG_UPDTBY,
							  ORG_NAME_A,
							  VOW_TYPSTRUCT,
							  ORG_ORMCPOST,
							  ORG_ORMCCOLL
							  )
                      values (
							  V_PAR_ID,
							  'S.EXP.'||district_,
							  'SERVICE EXPLOITATION',
							  null,
							  null,
							  null,
							  null,
							  null,
							  null,
							  null,
							  null,
							  4,
							  sysdate,
							  null,
							  null,
							  'SERVICE EXPLOITATION',
							  null,
							  null,
							  null
							  );
------------------------------------------

select seq_GENPARTY.nextval into V_PAR_ID  from dual;
insert into GENPARTY (
                      PAR_ID,
					  PAR_REFE,
					  PAR_LNAME,
					  PAR_KNAME,
					  ADR_ID,
					  VOW_TYPSAG,
					  VOW_PARTYTP,
					  PAR_STATUS,
					  PAR_PROFEXOTVA,
					  PAR_SEARCH,
					  PAR_CREDT
					  )
              values (
			          V_PAR_ID,
					  'U.T.1.'||district_,
					  'UNITE TRAVEAUX 1',
					  'UNITE TRAVEAUX 1',
					  0,
					  null,
					  v_VOW_PARTYTP,
					  1,
					  0,
					  1,
					  sysdate
					  );
insert into  genorganization (
                              ORG_ID,
							  ORG_CODE,
							  ORG_NAME,
							  ORG_TIPNNE,
							  ORG_TIPCENTRE,
							  ORG_TIPDOCUMENT,
							  ORG_SEPAICS,
							  BAP_CREDIT_ID,
							  BAP_DEBIT_ID,
							  VOW_BANKFMT,
							  VOW_TIPLINE,
							  CUR_ID,
							  ORG_CREDT,
							  ORG_UPDTDT,
							  ORG_UPDTBY,
							  ORG_NAME_A,
							  VOW_TYPSTRUCT,
							  ORG_ORMCPOST,
							  ORG_ORMCCOLL
							  )
                      values (
					          V_PAR_ID,
							  'U.T.1.'||district_,
							  'UNITE TRAVEAUX 1',
							  null,
							  null,
							  null,
							  null,
							  null,
							  null,
							  null,
							  null, 
							  4, 
							  sysdate,
							  null, 
							  null,
							  'UNITE TRAVEAUX 1',
							  null,
							  null,
							  null);
-------------------------------------------------------

select seq_GENPARTY.nextval into V_PAR_ID from dual;
insert into GENPARTY (
                      PAR_ID,
					  PAR_REFE,
					  PAR_LNAME,
					  PAR_KNAME,
					  ADR_ID,
					  VOW_TYPSAG,
					  VOW_PARTYTP,
					  PAR_STATUS,
					  PAR_PROFEXOTVA,
					  PAR_SEARCH,
					  PAR_CREDT
					  )
             values (
			         V_PAR_ID,
					 'U.T.2.'||district_,
					 'UNITE TRAVEAUX 2',
					 'UNITE TRAVEAUX 2',
					 0,
					 null,
					 v_VOW_PARTYTP,
					 1,
					 0,
					 1,
					 sysdate
					 );
insert into  genorganization (
							  ORG_ID,
							  ORG_CODE,
							  ORG_NAME,
							  ORG_TIPNNE,
							  ORG_TIPCENTRE,
							  ORG_TIPDOCUMENT,
							  ORG_SEPAICS,
							  BAP_CREDIT_ID,
							  BAP_DEBIT_ID,
							  VOW_BANKFMT,
							  VOW_TIPLINE,
							  CUR_ID,
							  ORG_CREDT,
							  ORG_UPDTDT,
							  ORG_UPDTBY,
							  ORG_NAME_A,
							  VOW_TYPSTRUCT,
							  ORG_ORMCPOST,
							  ORG_ORMCCOLL
							  )
                      values (
					          V_PAR_ID,
							  'U.T.2.'||district_,
							  'UNITE TRAVEAUX 2',
							  null,
							  null, 
							  null,
							  null,
							  null,
							  null,
							  null,
							  null,
							  4, 
							  sysdate,
							  null,
							  null,
							  'UNITE TRAVEAUX 2',
							  null,
							  null,
							  null
							  );
------------------------------------------------------------

select seq_GENPARTY.nextval into V_PAR_ID from dual;
insert into GENPARTY (PAR_ID,
					  PAR_REFE,
					  PAR_LNAME,
					  PAR_KNAME,
					  ADR_ID,
					  VOW_TYPSAG,
					  VOW_PARTYTP,
					  PAR_STATUS,
					  PAR_PROFEXOTVA,
					  PAR_SEARCH,
					  PAR_CREDT
					  )
              values (
			          V_PAR_ID,
					  'S.M.'||district_,
					  'SECTION MAINTENANCE',
					  'SECTION MAINTENANCE',
					  0,
					  null,
					  v_VOW_PARTYTP,
					  1,
					  0,
					  1,
					  sysdate
					  );
insert into  genorganization (
                              ORG_ID,
							  ORG_CODE,
							  ORG_NAME,
							  ORG_TIPNNE,
							  ORG_TIPCENTRE,
							  ORG_TIPDOCUMENT,
							  ORG_SEPAICS,
							  BAP_CREDIT_ID,
							  BAP_DEBIT_ID,
							  VOW_BANKFMT,
							  VOW_TIPLINE,
							  CUR_ID,
							  ORG_CREDT,
							  ORG_UPDTDT,
							  ORG_UPDTBY,
							  ORG_NAME_A,
							  VOW_TYPSTRUCT,
							  ORG_ORMCPOST,
							  ORG_ORMCCOLL
							  )
                      values (
					          V_PAR_ID,
							  'S.M.'||district_,
							  'SECTION MAINTENANCE',
							  null,
							  null,
							  null,
							  null,
							  null,
							  null,
							  null, 
							  null,
							  4,
							  sysdate,
							  null,
							  null,
							  'SECTION MAINTENANCE',
							  null,
							  null,
							  null
							  );
---------------------------------------------------------------

select seq_GENPARTY.nextval into V_PAR_ID from dual;
insert into GENPARTY (
                      PAR_ID,
					  PAR_REFE,
					  PAR_LNAME,
					  PAR_KNAME,
					  ADR_ID,
					  VOW_TYPSAG,
					  VOW_PARTYTP,
					  PAR_STATUS,
					  PAR_PROFEXOTVA,
					  PAR_SEARCH,
					  PAR_CREDT
					  )
              values (
			           V_PAR_ID,
					   'MAG.'||district_,
					   'MAGASIN',
					   'MAGASIN',
					   0,
					   null,
					   v_VOW_PARTYTP,
					   1,
					   0,
					   1,
					   sysdate
					   );
insert into  genorganization (
                               ORG_ID,
							   ORG_CODE,
							   ORG_NAME,
							   ORG_TIPNNE,
							   ORG_TIPCENTRE,
							   ORG_TIPDOCUMENT,
							   ORG_SEPAICS,
							   BAP_CREDIT_ID,
							   BAP_DEBIT_ID,
							   VOW_BANKFMT,
							   VOW_TIPLINE,
							   CUR_ID,
							   ORG_CREDT,
							   ORG_UPDTDT,
							   ORG_UPDTBY,
							   ORG_NAME_A,
							   VOW_TYPSTRUCT,
							   ORG_ORMCPOST,
							   ORG_ORMCCOLL
							   )
                       values (
					            V_PAR_ID,
								'MAG.'||district_,
								'MAGASIN',
								null,
								null,
								null, 
								null,
								null, 
								null, 
								null, 
								null, 
								4,
								sysdate,
								null,
								null,
								'MAGASIN', 
								null,
								null,
								null
								);
---------------------------------------------------------
end;
