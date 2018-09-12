 declare
  v_par_id number;
  v_VOW_TYPSAG number;
  v_VOW_PARTYTP number;
  v_VOW_TYPSTRUCT number;
  begin 
  v_VOW_TYPSAG:=4401;--ADM autonome décentralisé
  v_VOW_PARTYTP:=2884;---Client
  v_VOW_TYPSTRUCT:=4215;--Société
  
  
  select seq_GENPARTY.nextval  into v_par_id from dual;
				insert into genparty(
									PAR_ID,
									PAR_REFE,
									PAR_FNAME,
									PAR_LNAME,
									PAR_CNAME,
									PAR_KNAME,
									PAR_INFO,
									VOW_TITLE,
									ADR_ID,
									PAR_TELW,
									PAR_TELM,
									PAR_TELP,
									PAR_TELF,
									PAR_EMAIL,
									VOW_TYPSAG,
									VOW_NATIONALITY,
									VOW_PARTYTP,
									PAR_BIRTHDT,
									PAR_BIRTHPLACE,
									PAR_STATUS,
									PAR_PROFSIRET,
									PAR_PROFSIREN,
									PAR_PROFTVAINTRA,
									PAR_PROFAPE,
									PAR_PROFNAF,
									PAR_PROFCAPITAL,
									PAR_PROFEXOTVA,
									PAR_SEARCH,
									PAR_CREDT,
									PAR_UPDTDT,
									PAR_UPDTBY,
									PAR_FNAME_A,
									PAR_LNAME_A,
									PAR_CNAME_A,
									PAR_KNAME_A,
									PAR_INFO_A,
									PAR_LOGO,
									VOW_TYPPROFIL
									)
									values 
									(
									v_par_id,
									'ORGSONEDE',
									null,
									'SONEDE',
									null,
									'SONEDE',
									null,
									null,
									0,
									null,
									null,
									null,
									null,
									null,
									v_VOW_TYPSAG,
									null,
									v_VOW_PARTYTP,
									null,
									null,
									1,
									null,
									null,
									null,
									null,
									null,
									null,
									0,
									1,
									sysdate,
									null,
									null,
									null,
									null,
									null,
									null,
									null,
									null,
									null
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
                               values 
							    (
								   v_par_id,
								   'ORGSONEDE',
								   'SONEDE',
								   0,
								   0,
								   '0',
								   null,
								   null,
								   null,
								   null,
								   null,
								   4,
								   sysdate,
								   null,
								   null,
								   'SONEDE',
								   v_VOW_TYPSTRUCT,
								   null,
								   null
								);
 
 ----tab tes contient les diff distrct
 for x in(select t.dist from test t where t.dist not in('57','58','60','61','63' )  loop
   param_GENPARTY_GENORG(x.dist);--1_param_GENPARTY_GENORG
   commit;
   param_GENPARTYPARTY(x.dist);--2_param_genpartyparty
   commit;
  end loop;

end ;
