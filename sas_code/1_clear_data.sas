/* C:\Users\yhuan25\Desktop\epid536\rawdata */
libname BA "C:\Users\YK Huang\Documents\UIC-2\201803_epid536\final_barium_hearingloss\Barium_hearingloss\data";

/*import data from rawdata folder*/
libname AUX09 xport "C:\Users\YK Huang\Documents\UIC-2\201803_epid536\final_barium_hearingloss\Barium_hearingloss\raw_data\AUX_F.xpt";
libname AUX11 xport "C:\Users\YK Huang\Documents\UIC-2\201803_epid536\final_barium_hearingloss\Barium_hearingloss\raw_data\AUX_G.xpt";
libname UHM09 xport "C:\Users\YK Huang\Documents\UIC-2\201803_epid536\final_barium_hearingloss\Barium_hearingloss\raw_data\UHM_F.xpt";
libname UHM11 xport "C:\Users\YK Huang\Documents\UIC-2\201803_epid536\final_barium_hearingloss\Barium_hearingloss\raw_data\UHM_G.xpt";
libname DEM09 xport "C:\Users\YK Huang\Documents\UIC-2\201803_epid536\final_barium_hearingloss\Barium_hearingloss\raw_data\DEMO_F.xpt";
libname DEM11 xport "C:\Users\YK Huang\Documents\UIC-2\201803_epid536\final_barium_hearingloss\Barium_hearingloss\raw_data\DEMO_G.xpt";
libname PDG09 xport "C:\Users\YK Huang\Documents\UIC-2\201803_epid536\final_barium_hearingloss\Barium_hearingloss\raw_data\RXQ_RX_F.xpt";
libname PDG11 xport "C:\Users\YK Huang\Documents\UIC-2\201803_epid536\final_barium_hearingloss\Barium_hearingloss\raw_data\RXQ_RX_G.xpt";
libname BMX09 xport "C:\Users\YK Huang\Documents\UIC-2\201803_epid536\final_barium_hearingloss\Barium_hearingloss\raw_data\BMX_F.xpt";
libname BMX11 xport "C:\Users\YK Huang\Documents\UIC-2\201803_epid536\final_barium_hearingloss\Barium_hearingloss\raw_data\BMX_G.xpt";
libname SMQ09 xport "C:\Users\YK Huang\Documents\UIC-2\201803_epid536\final_barium_hearingloss\Barium_hearingloss\raw_data\SMQ_F.xpt";
libname SMQ11 xport "C:\Users\YK Huang\Documents\UIC-2\201803_epid536\final_barium_hearingloss\Barium_hearingloss\raw_data\SMQ_G.xpt";
libname DIQ09 xport "C:\Users\YK Huang\Documents\UIC-2\201803_epid536\final_barium_hearingloss\Barium_hearingloss\raw_data\DIQ_F.xpt";
libname DIQ11 xport "C:\Users\YK Huang\Documents\UIC-2\201803_epid536\final_barium_hearingloss\Barium_hearingloss\raw_data\DIQ_G.xpt";
libname BPQ09 xport "C:\Users\YK Huang\Documents\UIC-2\201803_epid536\final_barium_hearingloss\Barium_hearingloss\raw_data\BPQ_F.xpt";
libname BPQ11 xport "C:\Users\YK Huang\Documents\UIC-2\201803_epid536\final_barium_hearingloss\Barium_hearingloss\raw_data\BPQ_G.xpt";
libname BPX09 xport "C:\Users\YK Huang\Documents\UIC-2\201803_epid536\final_barium_hearingloss\Barium_hearingloss\raw_data\BPX_F.xpt";
libname BPX11 xport "C:\Users\YK Huang\Documents\UIC-2\201803_epid536\final_barium_hearingloss\Barium_hearingloss\raw_data\BPX_G.xpt";
libname GHB09 xport "C:\Users\YK Huang\Documents\UIC-2\201803_epid536\final_barium_hearingloss\Barium_hearingloss\raw_data\GHB_F.xpt";
libname GHB11 xport "C:\Users\YK Huang\Documents\UIC-2\201803_epid536\final_barium_hearingloss\Barium_hearingloss\raw_data\GHB_G.xpt";
libname OCQ09 xport "C:\Users\YK Huang\Documents\UIC-2\201803_epid536\final_barium_hearingloss\Barium_hearingloss\raw_data\OCQ_F.xpt";
libname OCQ11 xport "C:\Users\YK Huang\Documents\UIC-2\201803_epid536\final_barium_hearingloss\Barium_hearingloss\raw_data\OCQ_G.xpt";
libname UAS09 xport "C:\Users\YK Huang\Documents\UIC-2\201803_epid536\final_barium_hearingloss\Barium_hearingloss\raw_data\UAS_F.xpt";
libname UAS11 xport "C:\Users\YK Huang\Documents\UIC-2\201803_epid536\final_barium_hearingloss\Barium_hearingloss\raw_data\UAS_G.xpt";
libname AUQ09 xport "C:\Users\YK Huang\Documents\UIC-2\201803_epid536\final_barium_hearingloss\Barium_hearingloss\raw_data\AUQ_F.xpt";
libname AUQ11 xport "C:\Users\YK Huang\Documents\UIC-2\201803_epid536\final_barium_hearingloss\Barium_hearingloss\raw_data\AUQ_G.xpt";


/* put file in NH*/
proc copy in=AUX09 out=BA;
proc copy in=AUX11 out=BA;
proc copy in=UHM09 out=BA;
proc copy in=UHM11 out=BA;
proc copy in=DEM09 out=BA;
proc copy in=DEM11 out=BA;
proc copy in=PDG09 out=BA;
proc copy in=PDG11 out=BA;
proc copy in=BMX09 out=BA;
proc copy in=BMX11 out=BA;
proc copy in=SMQ09 out=BA;
proc copy in=SMQ11 out=BA;
proc copy in=DIQ09 out=BA;
proc copy in=DIQ11 out=BA;
proc copy in=BPQ09 out=BA;
proc copy in=BPQ11 out=BA;
proc copy in=BPX09 out=BA;
proc copy in=BPX11 out=BA;
proc copy in=GHB09 out=BA;
proc copy in=GHB11 out=BA;
proc copy in=OCQ09 out=BA;
proc copy in=OCQ11 out=BA;
proc copy in=UAS09 out=BA;
proc copy in=UAS11 out=BA;
proc copy in=AUQ09 out=BA;
proc copy in=AUQ11 out=BA;
run;

/*09**/
data DEM09;
set BA.DEMO_F (keep=seqn RIAGENDR  RIDAGEYR RIDRETH1  DMDEDUC2  INDFMPIR INDHHIN2 WTINT2YR WTMEC2YR SDMVPSU SDMVSTRA);
data AUX09;set BA.AUX_F;
data UHM09;set BA.UHM_F (keep=seqn WTSA2YR URXUBA URXUCR URDUBALC);
data PDG09;set BA.RXQ_RX_F;
data BMX09;set BA.BMX_F (keep=seqn bmxbmi);
data SMQ09;set BA.SMQ_F (keep=seqn smq020 smq040);
data DIQ09;set BA.DIQ_F (keep=seqn diq010);
data BPQ09;set BA.BPQ_F (keep=seqn BPQ020);
data BPX09;set BA.BPX_F (keep=seqn BPXSY1 BPXDI1);
data GHB09;set BA.GHB_F (keep=seqn lbxgh);
data OCQ09;set BA.OCQ_F (keep=seqn OCd241 OCd270 OCd392 OCd395);
data UAS09;set BA.UAS_F (keep=seqn  URXUAS URXUAB URXUAC URDUASLC URDUABLC URDUACLC);
data AUQ09;set BA.AUQ_F (keep=seqn AUQ211 AUQ290 AUQ231);
run;

/*11**/
data DEM11;
set BA.DEMO_G (keep=seqn RIAGENDR  RIDAGEYR RIDRETH1  DMDEDUC2  INDFMPIR INDHHIN2 WTINT2YR WTMEC2YR SDMVPSU SDMVSTRA);
data AUX11;set BA.AUX_G;
data UHM11;set BA.UHM_G (keep=seqn WTSA2YR URXUBA URXUCR URDUBALC );
data PDG11;set BA.RXQ_RX_G;
data BMX11;set BA.BMX_G (keep=seqn bmxbmi);
data SMQ11;set BA.SMQ_G (keep=seqn smq020 smq040);
data DIQ11;set BA.DIQ_G (keep=seqn diq010);
data BPQ11;set BA.BPQ_G (keep=seqn BPQ020);
data BPX11;set BA.BPX_G (keep=seqn BPXSY1 BPXDI1);
data GHB11;set BA.GHB_G (keep=seqn lbxgh);
data OCQ11;set BA.OCQ_G (keep=seqn ocd241 ocd270 ocd392 ocd395);
data UAS11;set BA.UAS_G (keep=seqn  URXUAS URXUAB URXUAC URDUASLC URDUABLC URDUACLC);
data AUQ11;set BA.AUQ_G (keep=seqn AUQ300 AUQ330 AUQ370);
run;

/*join by year*/
data MA09;merge DEM09 UHM09 AUX09 BMX09 SMQ09 DIQ09 BPQ09 BPX09 GHB09 OCQ09 UAS09 AUQ09;by seqn;run;
data MA11;merge DEM11 UHM11 AUX11 BMX11 SMQ11 DIQ11 BPQ11 BPX11 GHB11 OCQ11 UAS11 AUQ11;by seqn;run;

/*select 2009-2012*/
data work;set MA09 MA11;run;

/*save temp*/
data BA.work;set work;run;

/*one side*/
data MC;set MA11;
if AUXU500L ne . AND AUXU500R ne . then AUXAVA=1;else AUXAVA=0;
if URXUBA ne . then UHMAVA=1;else UHMAVA=0;
proc freq data=Mc;table AUXAVA*UHMAVA;run;

data BA.work;set work;run;
