libname BA "C:\Users\YK Huang\Documents\UIC-2\201803_epid536\final_barium_hearingloss\Barium_hearingloss\data";
/*09-12**/
data rxq_rx;
set /*ba.rxq_rx_f*/ ba.rxq_rx_g;
proc sort;by rxddrgid;
run;

proc sort;by rxddrgid;
run;

data drugs;
merge rxq_drug rxq_rx;
by rxddrgid;if seqn=. then delete;
if rxddci1b=20 or rxddci2b=20 or rxddci3b=20 or rxddci4b=20 
or rxddci1c=154 or rxddci2c=154 or rxddci3c=154 or rxddci4c=154
or rxddci1a=20 or rxddci2a=20 or rxddci3a=20 or rxddci4a=20 
or rxddci1c=61 or rxddci2c=61 or rxddci3c=61 or rxddci4c=61 then oto=1;
run;

proc sort;
by rxddrug;
proc print;where oto=1;var seqn rxddrug oto;run;

data drugoto;set drugs(keep=seqn oto);
if oto ne 1 then delete;
proc sort nodupkey;
by seqn;run;

data ba.drugoto;set drugoto;run;

/**/
data work;merge work drugoto;by seqn;run;

