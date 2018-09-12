 declare
     cursor c1
     is
       select sag_id, sag_refe, lpad(z.tarif,2,'0') tarif, abn.codonan onas,/* t.ntiers, t.nsixieme,*/  p.spt_id,p.rou_id, z.district, sag.sag_enddt, sag.sag_startdt
       from   tecservicepoint p,
              district20.branchement z,
              district20.abonnees abn,
              agrserviceagr sag
       where  abn.dist(+) = z.district
       and    abn.tou(+) = to_number(z.tourne)
       and    abn.ord(+) = to_number(z.ordre)
       and    p.spt_refe = trim(rtrim(z.district))||lpad(ltrim(rtrim(z.tourne)),3,'0')||lpad(ltrim(rtrim(z.ordre)),3,'0')||lpad(ltrim(rtrim(z.police)),5,'0')
       and    p.spt_id = sag.spt_id
       and    sag.sag_startdt = (select max(a2.sag_startdt) from agrserviceagr a2 where a2.spt_id = p.spt_id)
       union
       select sag_id, sag_refe, lpad(z.tarif,2,'0') tarif, trim(abg.codonas) onas,/* t.ntiers, t.nsixieme,*/ p.spt_id,p.rou_id, z.district, sag.sag_enddt, sag.sag_startdt
       from   tecservicepoint p,
              district20.branchement z,
              district20.abonnees_gr abg,
              agrserviceagr sag
       where  abg.dist = z.district
       and    abg.tou = to_number(z.tourne)
       and    abg.ord = to_number(z.ordre)
       and    p.spt_refe = trim(rtrim(z.district))||lpad(ltrim(rtrim(z.tourne)),3,'0')||lpad(ltrim(rtrim(z.ordre)),3,'0')||lpad(ltrim(rtrim(z.police)),5,'0')
       and    p.spt_id = sag.spt_id
       and    sag.sag_startdt = (select max(a2.sag_startdt) from agrserviceagr a2 where a2.spt_id = p.spt_id)
       /*and    sag.sag_id = 11059*/;
     cursor c2 (ofrid agroffer.ofr_id%type)
     is
        select i.meu_id, i.ite_id
        from   agrofferitem i
        where  i.ofr_id = ofrid;
     


     v_ofr_id agroffer.ofr_id      %type;
     v_ofr_onas_id  agroffer.ofr_id %type;
     v_grf_id agrgrpfact.grf_id    %type;
     v_bii_id agrbillingitem.bii_id%type;
     v_hsf_id agrhsagofr.hsf_id    %type;
     v_dt     date ;
     i        number;
     v_last_bil_id number;
     v_dt2 date;
     nb_agrbill number;
begin
  delete tempo_ex_hkh;
  commit;
  for s1 in c1 loop
    --initialisation
    v_ofr_id := null;
    v_grf_id := null;
    v_hsf_id := null;
    v_ofr_onas_id := null;
    
    --Trouver l'offre type de facturation
    select max(o.ofr_id)
    into   v_ofr_id
    from   agroffer o,
           genservicedelivery d
    where  o.ofr_code = s1.tarif
    and    o.sdl_id = d.sdl_id
    and    d.sdl_code = 'PRSEAU';

    --On ne trouve pas l'offre type
    if v_ofr_id is null then
       insert into tempo_ex_hkh(message)values('EXCP1 : On ne trouve pas l''offre type correspondant pour le code tarif SONEDE: '||s1.tarif||' ,pour le branchement :'||s1.sag_refe);
       continue;
    end if;
    
    --Trouver l'offre type de facturation ONAS
    select max(o.ofr_id)
    into   v_ofr_onas_id
    from   agroffer o,
           genservicedelivery d
    where  o.ofr_code = 'ONAS'||s1.onas
    and    o.sdl_id = d.sdl_id
    and    d.sdl_code = 'PRSASSAIN';
   
    --On ne trouve pas l'offre type ONAS
    if v_ofr_onas_id is null then
       insert into tempo_ex_hkh(message)values('WARNING : On ne trouve pas l''offre type correspondant pour le code tarif ONAS: '||'ONAS'||s1.onas||' ,pour le branchement :'||s1.sag_refe);
       select max(o.ofr_id)
       into   v_ofr_onas_id
       from   agroffer o,
              genservicedelivery d
       where  o.ofr_code = 'ONAS0'
       and    o.sdl_id = d.sdl_id
       and    d.sdl_code = 'PRSASSAIN';
    end if;
    
    --Initialisation de l'abonnement
    v_dt := s1.sag_startdt;
    
    
    --Ajouter les lignes de l'offre de facturation  SONEDE selon l'offre type
    select count(ite.ite_id) 
    into nb_agrbill 
    from agrbillingitem bii,
         genitem ite,
         genitesdl itl,
         genservicedelivery sdl
    where bii.sag_id=s1.sag_id
    and   bii.ite_id = ite.ite_id
    and   ite.ite_id = itl.ite_id
    and   itl.sdl_id = sdl.sdl_id
    and   sdl_code = 'PRSEAU';
    if nb_agrbill=0 then 
      for s2 in c2(v_ofr_id) loop
        select seq_agrbillingitem.nextval into v_bii_id from dual;
        insert into agrbillingitem(bii_id,
                                   meu_id,
                                   ite_id,
                                   bii_startdt,
                                   bii_enddt,
                                   sag_id,
                                   ofr_id
                                   )
                            values(v_bii_id,
                                   s2.meu_id,
                                   s2.ite_id,
                                   v_dt,
                                   s1.sag_enddt,
                                   s1.sag_id,
                                   v_ofr_id
                                   );

      end loop;
    end if;
   --delete agrbillingitem where sag_id = s1.sag_id;
	 --Ajouter les lignes de l'offre de facturation  ONAS selon l'offre type
    select count(ite.ite_id) 
    into nb_agrbill 
    from agrbillingitem bii,
         genitem ite,
         genitesdl itl,
         genservicedelivery sdl
    where bii.sag_id=s1.sag_id
    and   bii.ite_id = ite.ite_id
    and   ite.ite_id = itl.ite_id
    and   itl.sdl_id = sdl.sdl_id
    and   sdl_code = 'PRSASSAIN';
    if nb_agrbill=0 then 
      for s3 in c2(v_ofr_onas_id) loop
        select seq_agrbillingitem.nextval into v_bii_id from dual;
        insert into agrbillingitem(bii_id,
                                   meu_id,
                                   ite_id,
                                   bii_startdt,
                                   bii_enddt,
                                   sag_id,
                                   ofr_id
                                   )
                            values(v_bii_id,
                                   s3.meu_id,
                                   s3.ite_id,
                                   v_dt,
                                   s1.sag_enddt,
                                   s1.sag_id,
                                   v_ofr_onas_id
                                   );
      end loop;
    end if;

    --Ajouter l'historique d'offre
    select max(hsf_id)
    into   v_hsf_id
    from   agrhsagofr
    where  sag_id = s1.sag_id
    and    trunc(hsf_startdt) = (select max(trunc(hsf2.hsf_startdt))
                                 from   agrhsagofr hsf2
                                 where  hsf2.sag_id = s1.sag_id);

    if v_hsf_id is null then
      pk_agrhsagofr.Add(v_hsf_id,s1.sag_id,v_ofr_id,null,s1.sag_startdt,s1.sag_enddt,null);
    else
      update agrhsagofr h
      set    h.ofr_id = v_ofr_id,
             h.ofr_detail_id = v_ofr_onas_id,
             h.hsf_updtdt = sysdate
      where  h.hsf_id = v_hsf_id;
    end if;
    
    

    insert into tempo_ex_hkh(message)values('INFO : Branchement effectuer avec succés : '||s1.sag_refe);

    i := i+1;

    if i = 100 then
       i := 0;
       commit;
    end if;

  end loop;

  commit;
end;