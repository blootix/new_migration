declare
  cursor c1
  is
    select sag.sag_refe , bil.bil_id, deb.deb_date
    from   gendebt deb,
           genbill bil,
           agrbill abi,
           agrserviceagr sag,
           genvocword vow,
           genvoc voc
    where  deb.deb_id = bil.deb_id
    and    bil.bil_id = abi.bil_id
    and    abi.vow_agrbilltype = vow.vow_id
    and    vow.voc_id = voc.voc_id
    and    voc.voc_code = 'VOW_AGRBILLTYPE'
    and    vow.vow_code = 'FDEVIS'
    and    deb.sag_id = sag.sag_id;
    
  v_nbre number; 
  v_police varchar2(10);
  v_district varchar2(10);
  v_bli_num number;
begin
  for s1 in c1 loop
    select count(*)
    into   v_nbre
    from   genbilline bli
    where  bli.bil_id = s1.bil_id;
    
    if v_nbre=0 then
      v_district := substr(s1.sag_refe,0,2);
      v_police := substr(s1.sag_refe,-5,5);
       insert into genbilline
          select   s1.bil_id,null,rownum,null,i.ite_name,extract(year from deb.deb_dt),   
                   i.ite_id,s.pta_id,1,null,
                   decode(i.ite_code,'MNT_MTBR',dvi.montant_matiere/1000,
                                     'MNT_MOBR',dvi.montant_main_oeuvre/1000,
                                     'FRAIS_GEN_FON',dvi.montant_frais_generaux/1000,
                                     'PART_CONTRIB',dvi.montant_extension/1000,
                                     'FACADE',dvi.montant_facade/1000,
                                     'REFECTION',dvi.montant_refection/1000,
                                     'AVANCE_CONSO',dvi.montant_avance_consommation/1000,
                                     'DROIT_VOIE',dvi.montant_voirie/1000,
                                     0) base,
                   decode(i.ite_code,'MNT_MTBR',dvi.montant_matiere/1000,
                                     'MNT_MOBR',dvi.montant_main_oeuvre/1000,
                                     'FRAIS_GEN_FON',dvi.montant_frais_generaux/1000,
                                     'PART_CONTRIB',dvi.montant_extension/1000,
                                     'FACADE',dvi.montant_facade/1000,
                                     'REFECTION',dvi.montant_refection/1000,
                                     'AVANCE_CONSO',dvi.montant_avance_consommation/1000,
                                     'DROIT_VOIE',dvi.montant_voirie/1000,
                                     0) factr,
                   1,
                   p.tva_id,
                   decode(i.ite_code,'MNT_MTBR',dvi.montant_matiere/1000 - round(dvi.montant_matiere/1180,3),
                                     'MNT_MOBR',dvi.montant_main_oeuvre/1000 - round(dvi.montant_main_oeuvre/1180,3),
                                     'FRAIS_GEN_FON',dvi.montant_frais_generaux/1000 - round(dvi.montant_frais_generaux/1180,3),
                                     'PART_CONTRIB',dvi.montant_extension/1000 - round(dvi.montant_extension/1180,3),
                                     'FACADE',dvi.montant_facade/1000 - round(dvi.montant_facade/1180,3),
                                     'REFECTION',dvi.montant_refection/1000 - round(dvi.montant_refection/1180,3),
                                     'AVANCE_CONSO',dvi.montant_avance_consommation/1000 - round(dvi.montant_avance_consommation/1180,3),
                                     'DROIT_VOIE',dvi.montant_voirie/1000 - round(dvi.montant_voirie/1180,3),
                                     0) mht,
                   decode(i.ite_code,'MNT_MTBR',round(dvi.montant_matiere/1180,3),
                                     'MNT_MOBR',round(dvi.montant_main_oeuvre/1180,3),
                                     'FRAIS_GEN_FON',round(dvi.montant_frais_generaux/1180,3),
                                     'PART_CONTRIB',round(dvi.montant_extension/1180,3),
                                     'FACADE',round(dvi.montant_facade/1180,3),
                                     'REFECTION',round(dvi.montant_refection/1180,3),
                                     'AVANCE_CONSO',round(dvi.montant_avance_consommation/1180,3),
                                     'DROIT_VOIE',round(dvi.montant_voirie/1180,3),
                                     0) mtva,
                   decode(i.ite_code,'MNT_MTBR',dvi.montant_matiere/1000,
                                     'MNT_MOBR',dvi.montant_main_oeuvre/1000,
                                     'FRAIS_GEN_FON',dvi.montant_frais_generaux/1000,
                                     'PART_CONTRIB',dvi.montant_extension/1000,
                                     'FACADE',dvi.montant_facade/1000,
                                     'REFECTION',dvi.montant_refection/1000,
                                     'AVANCE_CONSO',dvi.montant_avance_consommation/1000,
                                     'DROIT_VOIE',dvi.montant_voirie/1000,
                                     0) mttc,       
                   rgl.date_prise_charge,rgl.date_prise_charge,i.vow_unit,null,0,0,null,null,null,null,null,sysdate,null,0,
                   null,null,null,null,null,0
            from   test.reglement_ds rgl,
                   test.devis_ds dvi,
                   genitem i,
                   genitemtarif t,
                   genitemperiodtarif p,
                   genptaslice s
            where  rgl.police = v_police
            and    rgl.district = v_district
            and    dvi.annee_ds = rgl.annee_ds
            and    dvi.district = rgl.district
            and    dvi.code_localite_ds = rgl.code_localite_ds
            and    dvi.num_ds = rgl.num_ds
            and    dvi.num = rgl.num_devis_ds
            and    i.ite_code in ('MNT_MTBR','MNT_MOBR','FRAIS_GEN_FON','PART_CONTRIB','FACADE','REFECTION','AVANCE_CONSO','DROIT_VOIE' )
            and    i.ite_id = t.ite_id
            and    t.tar_id = p.tar_id
            and    t.tar_id  = (select max(t2.tar_id) from genitemtarif t2 where t2.ite_id = i.ite_id)
            and    p.pta_enddt is null
            and    p.pta_id = s.pta_id
            and    s.psl_rank = 1;
     
      commit;	
    end if;
  end loop;
end;
