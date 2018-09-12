update gendebt d
set    d.DEB_AMOUNT_CASH = d.DEB_AMOUNTINIT
where  d.deb_refe like '01%'
and    d.deb_refe not in (select ltrim(rtrim(facture_.district)) ||
                     lpad(ltrim(rtrim(facture_.tournee)),3,'0') ||
                     lpad(ltrim(rtrim(facture_.ordre)),3,'0')||
                     to_char(facture_.annee) ||
                     lpad(to_char(facture_.mois),2,0)||'0'
                     from mig_pivot_01.impayees_part facture_
                     );
					 
					 
update gendebt d
set    d.DEB_AMOUNT_CASH = d.DEB_AMOUNTINIT
where  d.deb_refe like '01%'
and    d.deb_refe not in (select ltrim(rtrim(facture_.DISTRICT))||
                          lpad(ltrim(rtrim(facture_.tournee)),3,'0')||
                      lpad(ltrim(rtrim(facture_.ORDRE)),3,'0')||
                      to_char(facture_.annee)||
                      lpad(ltrim(rtrim(facture_.mois)),2,'0')||0 
                     from mig_pivot_01.impayees_gc facture_
                          where trim(facture_.net)<>trim(facture_.mtpaye)
                          )
                          
and    d.deb_refe not in (select ltrim(rtrim(facture_.district)) ||
                     lpad(ltrim(rtrim(facture_.tournee)),3,'0') ||
                     lpad(ltrim(rtrim(facture_.ordre)),3,'0')||
                     to_char(facture_.annee) ||
                     lpad(to_char(facture_.mois),2,0)||'0'
                     from mig_pivot_01.impayees_part facture_
                     ) ;
                     
 ------------------------------------------------
  select  d.DEB_AMOUNTINIT ,d.DEB_AMOUNT_CASH ,d.*
 from gendebt d
where  d.deb_refe like '01%'
and  d.DEB_AMOUNTINIT=d.DEB_AMOUNT_CASH
and    d.deb_refe  in(
 select ltrim(rtrim(facture_.district)) ||
                     lpad(ltrim(rtrim(facture_.tournee)),3,'0') ||
                     lpad(ltrim(rtrim(facture_.ordre)),3,'0')||
                     to_char(facture_.annee) ||
                     lpad(to_char(facture_.mois),2,0)||'0' 
                     from mig_pivot_01.impayees_gc facture_
                     where  
                         trim(facture_.net)<>trim(facture_.mtpaye));
                     
 ---------------------------------------
 select  d.DEB_AMOUNTINIT,d.DEB_AMOUNT_CASH,trim(facture_.net),trim(facture_.mtpaye)
 from gendebt d, mig_pivot_20.impayees_part facture_
where  d.deb_refe like '20%'
and  d.deb_refe  = ltrim(rtrim(facture_.district)) ||
                     lpad(ltrim(rtrim(facture_.tournee)),3,'0') ||
                     lpad(ltrim(rtrim(facture_.ordre)),3,'0')||
                     to_char(facture_.annee) ||
                     lpad(to_char(facture_.mois),2,0)||'0' 
and  d.deb_refe like'201600212017%'
and  ltrim(rtrim(facture_.district)) ||
                     lpad(ltrim(rtrim(facture_.tournee)),3,'0') ||
                     lpad(ltrim(rtrim(facture_.ordre)),3,'0')||
                     to_char(facture_.annee) ='201600212017'
  and trim(facture_.net)=trim(facture_.mtpaye);
                 