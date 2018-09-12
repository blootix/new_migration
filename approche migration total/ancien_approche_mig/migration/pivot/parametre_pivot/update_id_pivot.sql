update  miwtadr a set a.adr_id=null,a.dis_id=null,a.str_id=null,a.twn_id=null;
update  miwtpersonne  p set p.adr_id=null, p.par_id=null ;
update  miwtcompteur c set c.equ_id=null;
update  miwthistocpt h set h.voc_id=null ,h.age_id=null ;  
update  miwabn a set a.sag_id=null,a.ctt_id=null,a.pre_id=null,a.spt_id=null;
update  miwtpdl p set p.spt_id=null,p.pre_id=null,p.adr_id=null;
update  MIWTPROPRIETAIRE u set u.pro_id=null;
update  MIWTHISTOPAYEUR m set m.par_id=null,m.adr_id=null,m.pay_id=null;
update  miwtbra b set b.cnn_id=null,b.fld_id=null,b.adr_id=null;
update  miwttournee e set e.rou_id=null;
update  miwtreleve_histocpt h set h.mme_id=null,h.meu_id=null,h.spt_id=null,h.equ_id=null, h.age_id=null ,h.mrd_id=null;
update  miwtreleve h set h.mme_id=null,h.meu_id=null,h.spt_id=null,h.equ_id=null, h.age_id=null ,h.mrd_id=null; 
update  miwtrelevet h set h.mme_id=null,h.meu_id=null,h.spt_id=null,h.equ_id=null, h.age_id=null ,h.mrd_id=null; 
update  miwtreleve_gc h set h.mme_id=null,h.meu_id=null,h.spt_id=null,h.equ_id=null, h.age_id=null ,h.mrd_id=null; 
update  miwtreleve_gc_1 h set h.mme_id=null,h.meu_id=null,h.spt_id=null,h.equ_id=null, h.age_id=null ,h.mrd_id=null;  
update  miwtfactureentete f set f.bil_id=null,f.rec_id=null,f.red_id=null,f.deb_id=null
update  miwtrib t set  t.ban_id is null;
update miwtfairesuivre s   set s.adr_id=null, s.par_id=null, s.paa_id=null;
