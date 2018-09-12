declare 
DIV_CODE VARCHAR2(20 BYTE);
DIV_NAME VARCHAR2(200 BYTE);
nbr_abn_actif integer ;
nbr_bran_actif integer;
nbr_abn_fermer integer;
nbr_bran_inactif integer;
nbr_pdl_cpt integer;
nbr_bran_cpt_r integer;
verif integer;
 CURSOR c1 is 
      SELECT distinct  dvt_id  FROM gendivspt; 
begin

	for x in c1  LOOP
		Verif:=0;
		select count(*) 
		into Verif 
		from gendivision div,gendivdit dit 
		where dit.DVT_ID=x.dvt_id 
		and dit.div_id=div.div_id;
				
        if(Verif>0) then 
			select distinct div.DIV_CODE, div.DIV_NAME 
			into DIV_CODE, DIV_NAME 
			from gendivision div ,gendivdit dit 
			where   dit.DVT_ID=x.dvt_id 
			and dit.div_id=div.div_id;

			select count(*) 
			into nbr_abn_actif 
			from agrserviceagr sag,
			tecservicepoint spt, 
			gendivspt dsp 
			where  sag.spt_id = spt.spt_id
			and    spt.spt_id = dsp.spt_id 
			and    dsp.dvt_id = x.dvt_id
			and sag.sag_enddt is null ;



			select count(*) 
			into nbr_abn_fermer
			from agrserviceagr sag,
			tecservicepoint spt, 
			gendivspt dsp 
			where  sag.spt_id = spt.spt_id
			and    spt.spt_id = dsp.spt_id 
			and    dsp.dvt_id=x.dvt_id
			and sag.sag_enddt is not null ;



			select count(*) 
			into nbr_pdl_cpt
			from tecequipment equ,
				 techequipment  hiq,
			     tecservicepoint spt, 
			     gendivspt dsp 
			where equ.equ_id=hiq.equ_id
			and  hiq.spt_id=spt.spt_id
			and spt.spt_id = dsp.spt_id 
			and dsp.dvt_id=x.dvt_id  
			and   hiq.HEQ_STARTDT=(Select max(hiq2.HEQ_STARTDT) 
								   from techequipment  hiq2
								   where hiq2.equ_id=hiq.equ_id)  
			and equ.EQU_REALNUMBER not like'%MIG%'; 
   
				insert into  stat_source_prod 
				values  (div_code,div_name,nbr_abn_actif,0,nbr_abn_fermer,0,nbr_pdl_cpt,0,0);
   
		end if;

commit;


end loop;
	  
end;

update stat_source_prod set nbr_bran_actif = (select count(*) from district01.branchement where trim(etat_branchement) ='0' ) where div_code='01';
update stat_source_prod set nbr_bran_actif = (select count(*) from district03.branchement where trim(etat_branchement) ='0' ) where div_code='03';
update stat_source_prod set nbr_bran_actif = (select count(*) from district04.branchement where trim(etat_branchement) ='0' ) where div_code='04';
update stat_source_prod set nbr_bran_actif = (select count(*) from district05.branchement where trim(etat_branchement) ='0' ) where div_code='05';
update stat_source_prod set nbr_bran_actif = (select count(*) from district06.branchement where trim(etat_branchement) ='0' ) where div_code='06';
update stat_source_prod set nbr_bran_actif = (select count(*) from district07.branchement where trim(etat_branchement) ='0' ) where div_code='07';
update stat_source_prod set nbr_bran_actif = (select count(*) from district08.branchement where trim(etat_branchement) ='0' ) where div_code='08';
update stat_source_prod set nbr_bran_actif = (select count(*) from district09.branchement where trim(etat_branchement) ='0' ) where div_code='09';
update stat_source_prod set nbr_bran_actif = (select count(*) from district13.branchement where trim(etat_branchement) ='0' ) where div_code='13';
update stat_source_prod set nbr_bran_actif = (select count(*) from district14.branchement where trim(etat_branchement) ='0' ) where div_code='14';
update stat_source_prod set nbr_bran_actif = (select count(*) from district15.branchement where trim(etat_branchement) ='0' ) where div_code='15';
update stat_source_prod set nbr_bran_actif = (select count(*) from district16.branchement where trim(etat_branchement) ='0' ) where div_code='16';
update stat_source_prod set nbr_bran_actif = (select count(*) from district17.branchement where trim(etat_branchement) ='0' ) where div_code='17';
update stat_source_prod set nbr_bran_actif = (select count(*) from district19.branchement where trim(etat_branchement) ='0' ) where div_code='19';
update stat_source_prod set nbr_bran_actif = (select count(*) from district20.branchement where trim(etat_branchement) ='0' ) where div_code='20';
update stat_source_prod set nbr_bran_actif = (select count(*) from district21.branchement where trim(etat_branchement) ='0' ) where div_code='21';
update stat_source_prod set nbr_bran_actif = (select count(*) from district22.branchement where trim(etat_branchement) ='0' ) where div_code='22';
update stat_source_prod set nbr_bran_actif = (select count(*) from district24.branchement where trim(etat_branchement) ='0' ) where div_code='24';
update stat_source_prod set nbr_bran_actif = (select count(*) from district25.branchement where trim(etat_branchement) ='0' ) where div_code='25';
update stat_source_prod set nbr_bran_actif = (select count(*) from district26.branchement where trim(etat_branchement) ='0' ) where div_code='26';
update stat_source_prod set nbr_bran_actif = (select count(*) from district27.branchement where trim(etat_branchement) ='0' ) where div_code='27';
update stat_source_prod set nbr_bran_actif = (select count(*) from district28.branchement where trim(etat_branchement) ='0' ) where div_code='28';
update stat_source_prod set nbr_bran_actif = (select count(*) from district29.branchement where trim(etat_branchement) ='0' ) where div_code='29';
update stat_source_prod set nbr_bran_actif = (select count(*) from district31.branchement where trim(etat_branchement) ='0' ) where div_code='31';
update stat_source_prod set nbr_bran_actif = (select count(*) from district32.branchement where trim(etat_branchement) ='0' ) where div_code='32';
update stat_source_prod set nbr_bran_actif = (select count(*) from district33.branchement where trim(etat_branchement) ='0' ) where div_code='33';
update stat_source_prod set nbr_bran_actif = (select count(*) from district34.branchement where trim(etat_branchement) ='0' ) where div_code='34';
update stat_source_prod set nbr_bran_actif = (select count(*) from district36.branchement where trim(etat_branchement) ='0' ) where div_code='36';
update stat_source_prod set nbr_bran_actif = (select count(*) from district37.branchement where trim(etat_branchement) ='0' ) where div_code='37';
update stat_source_prod set nbr_bran_actif = (select count(*) from district42.branchement where trim(etat_branchement) ='0' ) where div_code='42';
update stat_source_prod set nbr_bran_actif = (select count(*) from district44.branchement where trim(etat_branchement) ='0' ) where div_code='44';
update stat_source_prod set nbr_bran_actif = (select count(*) from district45.branchement where trim(etat_branchement) ='0' ) where div_code='45';
update stat_source_prod set nbr_bran_actif = (select count(*) from district46.branchement where trim(etat_branchement) ='0' ) where div_code='46';
update stat_source_prod set nbr_bran_actif = (select count(*) from district48.branchement where trim(etat_branchement) ='0' ) where div_code='48';
update stat_source_prod set nbr_bran_actif = (select count(*) from district49.branchement where trim(etat_branchement) ='0' ) where div_code='49';
update stat_source_prod set nbr_bran_actif = (select count(*) from district52.branchement where trim(etat_branchement) ='0' ) where div_code='52';
update stat_source_prod set nbr_bran_actif = (select count(*) from district53.branchement where trim(etat_branchement) ='0' ) where div_code='53';
update stat_source_prod set nbr_bran_actif = (select count(*) from district54.branchement where trim(etat_branchement) ='0' ) where div_code='54';
update stat_source_prod set nbr_bran_actif = (select count(*) from district55.branchement where trim(etat_branchement) ='0' ) where div_code='55';
update stat_source_prod set nbr_bran_actif = (select count(*) from district56.branchement where trim(etat_branchement) ='0' ) where div_code='56';
update stat_source_prod set nbr_bran_actif = (select count(*) from district57.branchement where trim(etat_branchement) ='0' ) where div_code='57';
update stat_source_prod set nbr_bran_actif = (select count(*) from district58.branchement where trim(etat_branchement) ='0' ) where div_code='58';
update stat_source_prod set nbr_bran_actif = (select count(*) from district59.branchement where trim(etat_branchement) ='0' ) where div_code='59';
update stat_source_prod set nbr_bran_actif = (select count(*) from district60.branchement where trim(etat_branchement) ='0' ) where div_code='60';
update stat_source_prod set nbr_bran_actif = (select count(*) from district61.branchement where trim(etat_branchement) ='0' ) where div_code='61';
update stat_source_prod set nbr_bran_actif = (select count(*) from district63.branchement where trim(etat_branchement) ='0' ) where div_code='63';


-------------------------------------- nbr des branchements inactif etat 9--------------
update stat_source_prod set nbr_bran_inactif = (select count(*) from district01.branchement where trim(etat_branchement) ='9' ) where div_code='01';
update stat_source_prod set nbr_bran_inactif = (select count(*) from district03.branchement where trim(etat_branchement) ='9' ) where div_code='03';
update stat_source_prod set nbr_bran_inactif = (select count(*) from district04.branchement where trim(etat_branchement) ='9' ) where div_code='04';
update stat_source_prod set nbr_bran_inactif = (select count(*) from district05.branchement where trim(etat_branchement) ='9' ) where div_code='05';
update stat_source_prod set nbr_bran_inactif = (select count(*) from district06.branchement where trim(etat_branchement) ='9' ) where div_code='06';
update stat_source_prod set nbr_bran_inactif = (select count(*) from district07.branchement where trim(etat_branchement) ='9' ) where div_code='07';
update stat_source_prod set nbr_bran_inactif = (select count(*) from district08.branchement where trim(etat_branchement) ='9' ) where div_code='08';
update stat_source_prod set nbr_bran_inactif = (select count(*) from district09.branchement where trim(etat_branchement) ='9' ) where div_code='09';
update stat_source_prod set nbr_bran_inactif = (select count(*) from district13.branchement where trim(etat_branchement) ='9' ) where div_code='13';
update stat_source_prod set nbr_bran_inactif = (select count(*) from district14.branchement where trim(etat_branchement) ='9' ) where div_code='14';
update stat_source_prod set nbr_bran_inactif = (select count(*) from district15.branchement where trim(etat_branchement) ='9' ) where div_code='15';
update stat_source_prod set nbr_bran_inactif = (select count(*) from district16.branchement where trim(etat_branchement) ='9' ) where div_code='16';
update stat_source_prod set nbr_bran_inactif = (select count(*) from district17.branchement where trim(etat_branchement) ='9' ) where div_code='17';
update stat_source_prod set nbr_bran_inactif = (select count(*) from district19.branchement where trim(etat_branchement) ='9' ) where div_code='19';
update stat_source_prod set nbr_bran_inactif = (select count(*) from district20.branchement where trim(etat_branchement) ='9' ) where div_code='20';
update stat_source_prod set nbr_bran_inactif = (select count(*) from district21.branchement where trim(etat_branchement) ='9' ) where div_code='21';
update stat_source_prod set nbr_bran_inactif = (select count(*) from district22.branchement where trim(etat_branchement) ='9' ) where div_code='22';
update stat_source_prod set nbr_bran_inactif = (select count(*) from district24.branchement where trim(etat_branchement) ='9' ) where div_code='24';
update stat_source_prod set nbr_bran_inactif = (select count(*) from district25.branchement where trim(etat_branchement) ='9' ) where div_code='25';
update stat_source_prod set nbr_bran_inactif = (select count(*) from district26.branchement where trim(etat_branchement) ='9' ) where div_code='26';
update stat_source_prod set nbr_bran_inactif = (select count(*) from district27.branchement where trim(etat_branchement) ='9' ) where div_code='27';
update stat_source_prod set nbr_bran_inactif = (select count(*) from district28.branchement where trim(etat_branchement) ='9' ) where div_code='28';
update stat_source_prod set nbr_bran_inactif = (select count(*) from district29.branchement where trim(etat_branchement) ='9' ) where div_code='29';
update stat_source_prod set nbr_bran_inactif = (select count(*) from district31.branchement where trim(etat_branchement) ='9' ) where div_code='31';
update stat_source_prod set nbr_bran_inactif = (select count(*) from district32.branchement where trim(etat_branchement) ='9' ) where div_code='32';
update stat_source_prod set nbr_bran_inactif = (select count(*) from district33.branchement where trim(etat_branchement) ='9' ) where div_code='33';
update stat_source_prod set nbr_bran_inactif = (select count(*) from district34.branchement where trim(etat_branchement) ='9' ) where div_code='34';
update stat_source_prod set nbr_bran_inactif = (select count(*) from district36.branchement where trim(etat_branchement) ='9' ) where div_code='36';
update stat_source_prod set nbr_bran_inactif = (select count(*) from district37.branchement where trim(etat_branchement) ='9' ) where div_code='37';
update stat_source_prod set nbr_bran_inactif = (select count(*) from district42.branchement where trim(etat_branchement) ='9' ) where div_code='42';
update stat_source_prod set nbr_bran_inactif = (select count(*) from district44.branchement where trim(etat_branchement) ='9' ) where div_code='44';
update stat_source_prod set nbr_bran_inactif = (select count(*) from district45.branchement where trim(etat_branchement) ='9' ) where div_code='45';
update stat_source_prod set nbr_bran_inactif = (select count(*) from district46.branchement where trim(etat_branchement) ='9' ) where div_code='46';
update stat_source_prod set nbr_bran_inactif = (select count(*) from district48.branchement where trim(etat_branchement) ='9' ) where div_code='48';
update stat_source_prod set nbr_bran_inactif = (select count(*) from district49.branchement where trim(etat_branchement) ='9' ) where div_code='49';
update stat_source_prod set nbr_bran_inactif = (select count(*) from district52.branchement where trim(etat_branchement) ='9' ) where div_code='52'; 
update stat_source_prod set nbr_bran_inactif = (select count(*) from district53.branchement where trim(etat_branchement) ='9' ) where div_code='53'; 
update stat_source_prod set nbr_bran_inactif = (select count(*) from district54.branchement where trim(etat_branchement) ='9' ) where div_code='54'; 
update stat_source_prod set nbr_bran_inactif = (select count(*) from district55.branchement where trim(etat_branchement) ='9' ) where div_code='55'; 
update stat_source_prod set nbr_bran_inactif = (select count(*) from district56.branchement where trim(etat_branchement) ='9' ) where div_code='56'; 
update stat_source_prod set nbr_bran_inactif = (select count(*) from district57.branchement where trim(etat_branchement) ='9' ) where div_code='57'; 
update stat_source_prod set nbr_bran_inactif = (select count(*) from district58.branchement where trim(etat_branchement) ='9' ) where div_code='58';
update stat_source_prod set nbr_bran_inactif = (select count(*) from district59.branchement where trim(etat_branchement) ='9' ) where div_code='59'; 
update stat_source_prod set nbr_bran_inactif = (select count(*) from district60.branchement where trim(etat_branchement) ='9' ) where div_code='60'; 
update stat_source_prod set nbr_bran_inactif = (select count(*) from district61.branchement where trim(etat_branchement) ='9' ) where div_code='61'; 
update stat_source_prod set nbr_bran_inactif = (select count(*) from district63.branchement where trim(etat_branchement) ='9' ) where div_code='63'; 
    
commit;
----------------------------------------------------------------------------------------------------------------------------------------------------
--***********************************************************************************************--------------------------------
----------------------------------------------------------------------------------------------------------------------------------------------------
   
DECLARE 
   pdl gendivspt.dvt_id%type; 
   site gendivspt.dvt_id%type; 
   contact_site_pdl gendivspt.dvt_id%type; 
   abonnement gendivspt.dvt_id%type; 
   contact_abonnement gendivspt.dvt_id%type;
   payeur gendivspt.dvt_id%type;
   adresse_facturation gendivspt.dvt_id%type;
   adresse gendivspt.dvt_id%type;
   historique_pose_compteur gendivspt.dvt_id%type;
   compteur gendivspt.dvt_id%type;
   histor_profil_facturation gendivspt.dvt_id%type;
   etat_pdl gendivspt.dvt_id%type;
   planning_facturation gendivspt.dvt_id%type;
   SECTORISATION gendivspt.dvt_id%type;
   affictation_pdl_organisation gendivspt.dvt_id%type;
   modilite_de_paiment gendivspt.dvt_id%type;
   compte_abonnement gendivspt.dvt_id%type;
   DIV_CODE VARCHAR2(20 BYTE);
   DIV_NAME VARCHAR2(200 BYTE);
   verif_contact_abonnement varchar(20);
   Verif integer;
   verif_contact_site_pdl varchar(20);
   verif_e varchar(20);
   
CURSOR c1 is 
SELECT distinct  dvt_id  FROM gendivspt; 
BEGIN 

 for x in c1  LOOP 
   Verif:=0;
   select count(*) 
   into Verif 
   from gendivision div,gendivdit dit 
   where  dit.DVT_ID=x.dvt_id 
   and    dit.div_id=div.div_id;
   
   if(Verif>0) then 
		select distinct div.DIV_CODE, div.DIV_NAME 
		into DIV_CODE, DIV_NAME 
		from gendivision div ,gendivdit dit 
		where  dit.DVT_ID=x.dvt_id 
		and    dit.div_id=div.div_id;

		select count(*)
		into pdl
		from tecservicepoint spt, 
		gendivspt dsp 
		where  spt.spt_id = dsp.spt_id 
		and    dsp.dvt_id=x.dvt_id;

		select count(*) 
		into site
		from tecpremise pre,
		tecservicepoint spt, 
		gendivspt dsp 
		where  pre.pre_id = spt.pre_id
		and    spt.spt_id = dsp.spt_id 
		and    dsp.dvt_id=x.dvt_id;

		select count(*) 
		into contact_site_pdl
		from TECPRESPTCONTACT psc,
		tecservicepoint spt, 
		tecpremise pre,
		gendivspt dsp 
		where  pre.pre_id = spt.pre_id
		and    psc.pre_id = pre.pre_id
		and    spt.spt_id = dsp.spt_id 
		and    dsp.dvt_id=x.dvt_id;

		select count(*) 
		into abonnement
		from agrserviceagr sag,
		tecservicepoint spt, 
		gendivspt dsp 
		where  sag.spt_id = spt.spt_id
		and    spt.spt_id = dsp.spt_id 
		and    dsp.dvt_id=x.dvt_id;

		select count(*) 
		into contact_abonnement
		from agrcustagrcontact cot,
		agrserviceagr sag,
		tecservicepoint spt, 
		gendivspt dsp 
		where  cot.sag_id =sag.sag_id
		and    sag.spt_id = spt.spt_id
		and    spt.spt_id = dsp.spt_id 
		and    dsp.dvt_id=x.dvt_id; 

		select count(*) 
		into payeur
		from agrpayor   pay,
		agrcustagrcontact cot,
		agrserviceagr sag,
		tecservicepoint spt, 
		gendivspt dsp 
		where  pay.cot_id=cot.cot_id
		and    cot.sag_id =sag.sag_id
		and    sag.spt_id = spt.spt_id
		and    spt.spt_id = dsp.spt_id 
		and    dsp.dvt_id=x.dvt_id;  

		select count(*) 
		into adresse_facturation
		from genpartyparty paa,
		agrpayor   pay,
		agrcustagrcontact cot,
		agrserviceagr sag,
		tecservicepoint spt, 
		gendivspt dsp 
		where  paa.paa_id=pay.paa_id 
		and    pay.cot_id=cot.cot_id
		and    cot.sag_id =sag.sag_id
		and    sag.spt_id = spt.spt_id
		and    spt.spt_id = dsp.spt_id 
		and    dsp.dvt_id=x.dvt_id; 

		select count(*) 
		into adresse
		from genadress adr,
		tecservicepoint spt, 
		gendivspt dsp 
		where  adr.adr_id=spt.adr_id
		and    spt.spt_id = dsp.spt_id 
		and    dsp.dvt_id=x.dvt_id; 

		select count(*) 
		into historique_pose_compteur
		from techequipment  hiq,
		tecservicepoint spt, 
		gendivspt dsp 
		where  hiq.spt_id=spt.spt_id
		and    spt.spt_id = dsp.spt_id 
		and    dsp.dvt_id=x.dvt_id;

		select count(*) 
		into compteur
		from tecequipment equ,
		techequipment  hiq,
		tecservicepoint spt, 
		gendivspt dsp 
		where  equ.equ_id=hiq.equ_id
		and    hiq.spt_id=spt.spt_id
		and    spt.spt_id = dsp.spt_id 
		and    dsp.dvt_id=x.dvt_id; 

		select count(*) 
		into histor_profil_facturation
		from AGRHSAGOFR hsf,
		agrserviceagr sag,
		tecservicepoint spt, 
		gendivspt dsp 
		where  hsf.sag_id=sag.sag_id
		and    sag.spt_id = spt.spt_id
		and    spt.spt_id = dsp.spt_id 
		and    dsp.dvt_id=x.dvt_id;

		select count(*) 
		into etat_pdl
		from TECSPSTATUS sps,
		     tecservicepoint spt, 
		     gendivspt dsp 
		where  sps.spt_id=spt.spt_id
		and    spt.spt_id = dsp.spt_id 
		and    dsp.dvt_id=x.dvt_id 
		and    sps.SPS_ENDDT is null;

		select count(*) 
		into planning_facturation
		from AGRPLANNINGAGR agp,
		agrserviceagr sag,
		tecservicepoint spt, 
		gendivspt dsp 
		where  agp.sag_id=sag.sag_id
		and    sag.spt_id = spt.spt_id
		and    spt.spt_id = dsp.spt_id 
		and    dsp.dvt_id=x.dvt_id;

		select count(*) 
		into SECTORISATION 
		from tecservicepoint spt  
		where  spt.spt_id in (select spt_id 
							  from gendivspt 
							  where  dvt_id=x.dvt_id);

		select count(*) 
		into affictation_pdl_organisation
		from TECSPTORG spo,
		tecservicepoint spt, 
		gendivspt dsp 
		where  spo.spt_id = spt.spt_id
		and    spt.spt_id = dsp.spt_id 
		and    dsp.dvt_id=x.dvt_id;

		select count(*)  
		into modilite_de_paiment
		from AGRSETTLEMENT stl,
		agrserviceagr sag,
		tecservicepoint spt, 
		gendivspt dsp 
		where  stl.sag_id=sag.sag_id
		and    sag.spt_id = spt.spt_id
		and    spt.spt_id = dsp.spt_id 
		and    dsp.dvt_id=x.dvt_id;

		select count(*)  
		into compte_abonnement
		from genaccount aco,
		AGRSAGACO sco,
		agrserviceagr sag,
		tecservicepoint spt, 
		gendivspt dsp 
		where  aco.aco_id=sco.ACO_ID
		and    sco.sag_id=sag.sag_id
		and    sag.spt_id = spt.spt_id
		and    spt.spt_id = dsp.spt_id 
		and    dsp.dvt_id=x.dvt_id;

		if(site*2!=contact_site_pdl) then
		verif_contact_site_pdl:='NOK';
		else
		verif_contact_site_pdl:='OK';
		end if ;



		if(abonnement*2!=contact_abonnement) then
		verif_contact_abonnement:='NOK';
		else
		verif_contact_abonnement:='OK';
		end if ;

		if(pdl=site 
		and pdl=abonnement 
		and pdl=payeur 
		and pdl=adresse_facturation 
		and pdl= historique_pose_compteur 
		and pdl= histor_profil_facturation 
		and pdl= SECTORISATION 
		and pdl=affictation_pdl_organisation 
		and pdl= modilite_de_paiment 
		and pdl= compte_abonnement
		) then 

		verif_e:='OK';
		else
		verif_e:='NOK';
		end if;
			
insert into VERIF_CAlC_MIGRATION 
(  DIV_CODE  , --1
  DIV_NAME , --2
  DVT_ID ,--3
  PDL , --4
  BRANCHEMENT ,--5
  DEF_SOURCE_PROD , --6
  SITE , --7
  CONTACT_SITE_PDL , --8
  ABONNEMENT , --9
  CONTACT_ABONNEMENT ,--10
  PAYEUR , --11
  ADRESSE_FACTURATION , --12
  ADRESSE ,--13
  HISTORIQUE_POSE_COMPTEUR ,--14
  COMPTEUR , --15
  HISTOR_PROFIL_FACTURATION , --16
  ETAT_PDL , --17
  PLANNING_FACTURATION ,--18
  SECTORISATION ,--19
  AFFICTATION_PDL_ORGANISATION , --20
  MODILITE_DE_PAIMENT , --21
  COMPTE_ABONNEMENT , --22
  VERIF_CONTACT_SITE_PDL ,--23
  VERIF_CONTACT_ABONNEMENT , --24
  VERIF  --25
)
values 
(  DIV_CODE ,--1
   DIV_NAME,--2
   x.dvt_id,--3
   pdl , --4
   0,--5
   0,--6
   site , --7
   contact_site_pdl , --8
   abonnement , --9
   contact_abonnement ,--10
   payeur ,--11
   adresse_facturation ,--12
   adresse ,--13
   historique_pose_compteur ,--14
   compteur ,--15
   histor_profil_facturation ,--16
   etat_pdl ,--17
   planning_facturation ,--18
   SECTORISATION ,--19
   affictation_pdl_organisation ,--20
   modilite_de_paiment ,--21
   compte_abonnement,--22
   verif_contact_site_pdl,--23
   verif_contact_abonnement ,--24
   verif_e   --25
   );
 commit; 
 end if;
 
END LOOP; 

update VERIF_CAlC_MIGRATION set branchement = (select count(*) from district01.branchement ) where div_code='01';
update VERIF_CAlC_MIGRATION set branchement = (select count(*) from district03.branchement ) where div_code='03';
update VERIF_CAlC_MIGRATION set branchement = (select count(*) from district04.branchement ) where div_code='04';
update VERIF_CAlC_MIGRATION set branchement = (select count(*) from district05.branchement ) where div_code='05';
update VERIF_CAlC_MIGRATION set branchement = (select count(*) from district06.branchement ) where div_code='06';
update VERIF_CAlC_MIGRATION set branchement = (select count(*) from district07.branchement ) where div_code='07';
update VERIF_CAlC_MIGRATION set branchement = (select count(*) from district08.branchement ) where div_code='08';
update VERIF_CAlC_MIGRATION set branchement = (select count(*) from district09.branchement ) where div_code='09';
update VERIF_CAlC_MIGRATION set branchement = (select count(*) from district13.branchement ) where div_code='13';
update VERIF_CAlC_MIGRATION set branchement = (select count(*) from district14.branchement ) where div_code='14';
update VERIF_CAlC_MIGRATION set branchement = (select count(*) from district15.branchement ) where div_code='15';
update VERIF_CAlC_MIGRATION set branchement = (select count(*) from district16.branchement ) where div_code='16';
update VERIF_CAlC_MIGRATION set branchement = (select count(*) from district17.branchement ) where div_code='17';
update VERIF_CAlC_MIGRATION set branchement = (select count(*) from district19.branchement ) where div_code='19';
update VERIF_CAlC_MIGRATION set branchement = (select count(*) from district20.branchement ) where div_code='20'; 
update VERIF_CAlC_MIGRATION set branchement = (select count(*) from district21.branchement ) where div_code='21';
update VERIF_CAlC_MIGRATION set branchement = (select count(*) from district22.branchement ) where div_code='22';
update VERIF_CAlC_MIGRATION set branchement = (select count(*) from district24.branchement ) where div_code='24';  
update VERIF_CAlC_MIGRATION set branchement = (select count(*) from district25.branchement ) where div_code='25';
update VERIF_CAlC_MIGRATION set branchement = (select count(*) from district26.branchement ) where div_code='26';
update VERIF_CAlC_MIGRATION set branchement = (select count(*) from district27.branchement ) where div_code='27';
update VERIF_CAlC_MIGRATION set branchement = (select count(*) from district28.branchement ) where div_code='28';    
update VERIF_CAlC_MIGRATION set branchement = (select count(*) from district29.branchement ) where div_code='29';
update VERIF_CAlC_MIGRATION set branchement = (select count(*) from district31.branchement ) where div_code='31';
update VERIF_CAlC_MIGRATION set branchement = (select count(*) from district32.branchement ) where div_code='32';
update VERIF_CAlC_MIGRATION set branchement = (select count(*) from district33.branchement ) where div_code='33';
update VERIF_CAlC_MIGRATION set branchement = (select count(*) from district34.branchement ) where div_code='34';
update VERIF_CAlC_MIGRATION set branchement = (select count(*) from district36.branchement ) where div_code='36';
update VERIF_CAlC_MIGRATION set branchement = (select count(*) from district37.branchement ) where div_code='37';
update VERIF_CAlC_MIGRATION set branchement = (select count(*) from district42.branchement ) where div_code='42';
update VERIF_CAlC_MIGRATION set branchement = (select count(*) from district44.branchement ) where div_code='44';
update VERIF_CAlC_MIGRATION set branchement = (select count(*) from district45.branchement ) where div_code='45';
update VERIF_CAlC_MIGRATION set branchement = (select count(*) from district46.branchement ) where div_code='46';
update VERIF_CAlC_MIGRATION set branchement = (select count(*) from district48.branchement ) where div_code='48';
update VERIF_CAlC_MIGRATION set branchement = (select count(*) from district49.branchement ) where div_code='49';
update VERIF_CAlC_MIGRATION set branchement = (select count(*) from district52.branchement ) where div_code='52';
update VERIF_CAlC_MIGRATION set branchement = (select count(*) from district53.branchement ) where div_code='53';
update VERIF_CAlC_MIGRATION set branchement = (select count(*) from district54.branchement ) where div_code='54';
update VERIF_CAlC_MIGRATION set branchement = (select count(*) from district55.branchement ) where div_code='55';
update VERIF_CAlC_MIGRATION set branchement = (select count(*) from district56.branchement ) where div_code='56';
update VERIF_CAlC_MIGRATION set branchement = (select count(*) from district57.branchement ) where div_code='57';
update VERIF_CAlC_MIGRATION set branchement = (select count(*) from district58.branchement ) where div_code='58';
update VERIF_CAlC_MIGRATION set branchement = (select count(*) from district59.branchement ) where div_code='59';
update VERIF_CAlC_MIGRATION set branchement = (select count(*) from district60.branchement ) where div_code='60';
update VERIF_CAlC_MIGRATION set branchement = (select count(*) from district61.branchement ) where div_code='61';
update VERIF_CAlC_MIGRATION set branchement = (select count(*) from district63.branchement ) where div_code='63';
   
update VERIF_CALC_MIGRATION t set t.def_source_prod=t.branchement-t.pdl;
commit; 
 END;  
