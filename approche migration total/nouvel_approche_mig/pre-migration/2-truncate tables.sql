    update WFLISTITC t set t.par_id=null;
    update WFLISTAGE w set w.age_id=null;
    update WFMETAPE w set w.age_id = null;
    COMMIT;

    truncate table WFTMODFOLDER;
    commit;  
    truncate table AGRADDDETAIL;
    commit;
    truncate table AGRADDENDUM;
    commit;
    truncate table AGRAVGCONSUM;
    commit;
    truncate table AGRCGHBILL;  
    commit; 
    truncate table AGRCUSTOMERAGR;  
    commit;
    truncate table AGRHSAGOFR;  
    commit;
    truncate table AGRMONTHPAY;  
    commit;
    truncate table AGRMONTHPAYSCHED;  
    commit;
    truncate table AGRPAYOR;  
    commit;
    truncate table AGRCUSTAGRCONTACT;  
    commit;
    truncate table AGRPLANNINGAGR;  
    commit;
    truncate table AGRSAGACO;  
    commit;
    truncate table AGRSAGBUN;  
    commit;
    truncate table AGRSERVICEAGR;  
    commit;
    truncate table AGRSETTLEMENT;  
	commit;
	truncate table AGRBILL;  
	commit;
	truncate table AGRBILLINGITEM;  
	commit;
	truncate table GENDEBT;  
	commit;
	truncate table GENDEBTDISC;
	commit;
	truncate table GENBILLINE;  
	commit;
	truncate table TECMTRREAD;  
    commit;
    truncate table AGRSUBSCRIPTION;  
    commit;
    truncate table AGRSUBSCRIPTIONVALUE;  
    commit;
    truncate table AGRTMPITEBILL;  
    commit;
    truncate table AGRTMPTARIF;  
    commit;
    truncate table AGRTMPTRACE;  
    commit;
    truncate table AGRTMPWORBILL;  
    commit;
    truncate table AGRTMPWORFACT;  
    commit;
    truncate table BILTMPBILLINGITEM;  
    commit;
    truncate table BILTMPCONSUMACO;  
    commit;
    truncate table BILTMPLASTBILL;  
    commit;
    truncate table BILTMPNEXTMRD;  
    commit;
    truncate table BILTMPSAG;  
    commit;
    truncate table BILTMPSUBSCRIPTIONVALUE;  
    commit;
    truncate table BILTMPTARIF;  
    commit;
    truncate table DEFALCROUTE;  
    commit;
    truncate table DEFALCROUTEHIST;  
    commit;
    truncate table GENACCESS;  
    commit;
    truncate table GENACTIVERECO;  
    commit;
    truncate table GENACTIVERECODETAIL;
    commit;
    truncate table GENACTIVITY;
    commit;
    truncate table GENANOMALY;  
    commit;
    truncate table GENAUDIT;  
    commit;
    truncate table GENAVGCONSUM;  
    commit;
    truncate table GENBILL;   
    commit;
    truncate table GENBUNDLE;  
    commit;
    truncate table GENCAD;  
    commit;
    truncate table GENCADPRESPT;  
    commit;
    truncate table GENCONTEST;  
    commit;
    truncate table GENCTRANOMALY;  
    commit;
    truncate table GENDATADYN;  
    commit;
    truncate table GENDATADYNDFT;  
    commit;
    truncate table GENDEBIMP;  
    commit;
    truncate table GENDEBREC;  
    commit;
    truncate table GENDIVSPT;  
    commit;
    truncate table GENDOCISSUE;  
    commit;
    truncate table GENEDSTATUS;  
    commit;
    truncate table GENFILE;  
    commit;
    truncate table GENHCTRL;  
    commit;
    truncate table GENHIMPCTT;  
    commit;
    truncate table GENHTREATMENT;  
    commit;
    truncate table GENHTREATPARAM;  
    commit;
    truncate table GENLETTDEBT;  
    commit;
    truncate table GENLETTDEBTDETAIL;  
    commit;
    truncate table GENNEWS;  
    commit;
    truncate table GENPAREXNTVA;  
    commit;
    commit;
    truncate table GENPASDEB;
    commit;
    truncate table GENPAYSCHED;
    commit;
    truncate table GENPAYSCHEDBR;
    commit;
    truncate table GENPAYSCHEDBRDETAIL;
    commit;
    truncate table GENPAYSCHEDDETAIL;
    commit;
    truncate table GENPROJECT;
    commit;
    truncate table GENPROVIDER;
    commit;
    truncate table GENREFEXT;  
    commit;
    truncate table GENRUN;  
    commit;
    truncate table GENRUNCTT;  
    commit;
    truncate table GENRUNAGR;  
    commit;
    truncate table GENRUNDETAIL;  
    commit;
    truncate table GENRUNDVT;  
    commit;
    truncate table GENRUNGRF;   
    commit;
    truncate table GENRUNITE;   
    commit;
    truncate table GENSOCIALSTATUS;  
    commit; 
    truncate table GENTMPBILLINE;  
    commit;
    truncate table GENTMPEDDEBT;  
    commit;
    truncate table GENTMPHGED;  
    commit;
    truncate table GENTMPITEMTARIF;  
    commit;
    truncate table GENTMPSEPA;  
    commit; 
    truncate table GENWORKSTATE;  
    commit;
    truncate table LIGNE_PLGREL;
    commit;
    truncate table LIGNE_PLGRELHIST;
    commit;
    truncate table PAYCASHBLI;  
    commit;
    truncate table PAYCASHDEBT;  
    commit;
    truncate table PAYCASHDESKMOVE;  
    commit;
    truncate table PAYCASHDESKSESSIONCALC;  
    commit;
    truncate table PAYCASHIMP;  
    commit;
    truncate table PAYCASHING;  
    commit;
    truncate table PAYJOURNAL;  
    commit;
    truncate table PAYSLIP;  
    commit;
    truncate table PLGREL;
    commit;
    truncate table PLGRELHIST;
    commit;
    truncate table TECCONNECTION;  
    commit;
    truncate table TECCONNHIER;
    commit;
    truncate table TECDEVICE;
    commit;
    truncate table TECEQUIPMENT;  
    commit;
    truncate table TECHCONSPT;  
    commit;
    truncate table TECHEQUCOM;  
    commit;
    truncate table TECHEQUIPMENT;  
    commit;
    truncate table TECHEQUMTRCFG;  
    commit;
    truncate table TECIMPORTDETAIL;  
    commit;
    truncate table TECIMPORTMODEL;  
    commit;
    truncate table TECMETER;  
    commit;
    truncate table TECMTRELEC;  
    commit;
    truncate table TECMTRGAS;  
    commit;
    truncate table TECMTRMEASURE;  
    commit;
    truncate table TECMTRMEASURECHARGE;  
    commit;
    truncate table TECMTRREAD;  
    commit;
    truncate table TECMTRWATER;  
    commit;
    truncate table TECMTRWASTE;
    commit;
    truncate table TECOPERATIONTSP;
    commit;
    truncate table TECPLGREL;
    commit;
    truncate table TECPLGRELHIST;
    commit;
    truncate table TECPREINFOETUDE;
    commit;
    truncate table TECPREMISE;  
    commit;
    truncate table TECPREMISEHIER;  
    commit;
    truncate table TECPREREJECT;  
    commit;
    truncate table TECPRESPTCONTACT;  
    commit;
    truncate table TECREADITEBILL;  
    commit;
    truncate table TECROUTEDEFALC;  
    commit;
    truncate table TECROUTEDEFALCDETAIL;  
    commit;
    truncate table TECROUTELOAD;  
    commit;
    truncate table TECROUTELOADDETAIL;  
    commit;
    truncate table TECROUTEPLAN;  
    commit;
    truncate table TECROUTEUNLOAD;  
    commit;
    truncate table TECSERVICEPOINT;  
    commit;
    truncate table TECSPSTATUS;  
    commit;
    truncate table TECSPTELECTRIC;  
    commit;
    truncate table TECSPTGAS;  
    commit;
    truncate table TECSPTHIER;  
    commit;
    truncate table TECSPTORG;  
    commit;
    truncate table TECSPTREJECT;  
    commit;
    truncate table TECSPTWASTE;  
    commit;
    truncate table TECSPTWATER;  
    commit;
    truncate table WFDOCTAG;
    commit;
    truncate table WFDOCUMENTLIE;
    commit;
    truncate table WFFIELD;
    commit;
    truncate table WFFIELDARCH;
    commit;
    truncate table WFFOLDER;
    commit;
    truncate table WFFVALID;
    commit;
    truncate table WFFVALIDARCH;
    commit;
	truncate table WFHPROCESS;
    commit;
    truncate table WFLOTDEDEPENDANCE;
    commit;
    truncate table WFMOTIF;
    commit;
    truncate table WFSCREAN;
    commit;
    truncate table WFSCREANARCH;
    commit;
    truncate table WFSTEP;
    commit;
    truncate table WFTAFFECTATION;
    commit;
    truncate table WFTASSISTANT;
    commit;
    truncate table WFTCONDITION;
    commit;
    truncate table WFTCOURRIER;
    commit;
    truncate table WFTDEMANDE;
    commit;
    truncate table WFTIMPRESSION;
    commit;
    truncate table WFTINTERVENTION;
    commit;
    truncate table WFTITERATIF;
    commit;
    truncate table WFTOBJETMETIER;
    commit;
    truncate table WFTROLLBACK;
    commit;
    truncate table WFTTRAITEMENT;
    commit;
    truncate table WFTTRAVAUX;
    commit;
    truncate table WORASSIGNMENT;  
    commit;
    truncate table WORBILL;  
    commit;
    truncate table WORBILLINTERV;
    commit;
    truncate table WORLINEQUOTATION;  
    commit;
    truncate table WORQUOTATION;  
    commit;
    truncate table WORREPORTORDER;   
    commit;
    truncate table WORTEMPJER;  
    commit;
    truncate table WORWOPLAN;
    commit;
    truncate table WORWORKORDER;  
    commit;
    truncate table WORWORKSHEET;  
    commit;
    truncate table WORWORKSHEETITEM;  
    commit;
