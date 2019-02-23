libname BA "C:\Users\YK Huang\Documents\UIC-2\201803_epid536\final_barium_hearingloss\Barium_hearingloss\data";

data work;set BA.work;run;

/*1. delete NR and unreliable (between 2 test of 1khz>10db in each ear)**/
/*2. made PTA*/
/*3. made hearing loss*/
data df_outcome;set work;
/*AUX_NR=0 good; AUX_NR=1 unreliable; AUX_NR=. missing at least one*/
	AUX_NR=0;
	if AUXU1K1R - AUXU1K2R <-10 or AUXU1K1R - AUXU1K2R >10 
	or AUXU1K1L - AUXU1K2L <-10 or AUXU1K1L - AUXU1K2L >10 then AUX_NR=1;
	if AUXU1K1R =. or AUXU1K1R >199. or
	AUXU500R =. or AUXU500R >199 or
	AUXU1K2R =. or AUXU1K2R >199 or
	AUXU2KR =. or AUXU2KR >199 or
	AUXU3KR =. or AUXU3KR >199 or
	AUXU4KR =. or AUXU4KR >199 or
	AUXU6KR =. or AUXU6KR >199 or
	AUXU8KR =. or AUXU8KR >199 or
	AUXU1K1L =. or AUXU1K1L >199 or
	AUXU500L =. or AUXU500L >199 or
	AUXU1K2L =. or AUXU1K2L >199 or
	AUXU2KL =. or AUXU2KL >199 or
	AUXU3KL =. or AUXU3KL >199 or
	AUXU4KL =. or AUXU4KL >199 or
	AUXU6KL =. or AUXU6KL >199 or
	AUXU8KL =. or AUXU8KL >199 then AUX_NR=.;
/*AUX_PTA*/
	AUX_PTAR=(AUXU500R+AUXU1K1R+AUXU2KR+AUXU4KR)/4;
	AUX_PTAL=(AUXU500L+AUXU1K1L+AUXU2KL+AUXU4KL)/4;
	AUX_PTA=(AUX_PTAR+AUX_PTAL)/2;
/*AUX_HEARLOSS=0 normal; AUX_HEARLOSS=1 loss in either ear; AUX_HEARLOSS=-1 in one ear(unilateral)*/
	AUX_hearLOSS=0;
	if AUX_PTAR>=25 OR AUX_PTAL>=25 then AUX_hearLOSS=-1;	
	if AUX_PTAR>=25 AND AUX_PTAL>=25 then AUX_hearLOSS=1;
	if AUX_NR=. then AUX_hearLOSS=.;
/*high 6,8*/
	aux_pta6k=(AUXU6KL+AUXU6KR)/2;
	aux_pta8k=(AUXU8KL+AUXU8KR)/2;
run;

/*input below LOD**/
data df_exposure;set df_outcome;
if URDUBALC=1 then URXUBA=(0.1)**0.5; /*ug/L*/
UBACA=URXUBA/URXUCR*100;/*ug/g*/
logBA=log10(URXUBA);
logBAca=log10(UBACA);
run;

/*clean cov*/
data df_cov;set df_exposure;
/*sex*/
if RIAGENDR=1 then sex=1;
if RIAGENDR=2 then sex=0;
/**age_3*/
	if RIDAGEYR<40 and RIDAGEYR>=20 then age_3=0;
	if RIDAGEYR<60 and RIDAGEYR>=40 then age_3=1;
	if RIDAGEYR<70 and RIDAGEYR>=60 then age_3=2;
	if RIDAGEYR<20 OR RIDAGEYR>=70 then age_3=.;
/**age_4*/
	if RIDAGEYR<=40 and RIDAGEYR>=20 then age_4=1;
	if RIDAGEYR<=60 and RIDAGEYR>=40 then age_4=2;
	if RIDAGEYR<=80 and RIDAGEYR>=60 then age_4=3;
	if RIDAGEYR<=20 and RIDAGEYR>=12 then age_4=0;
	if RIDAGEYR<12 and RIDAGEYR>80 then age_4=.;
/*bmi*/
	if bmxbmi>=30 then bmi_2=1;
	if bmxbmi<30 then bmi_2=0;
	if bmxbmi<10 then bmi_2=.;
/*race*/
	/*0 NH white; 1 NH black; 2 MA ; 3 other*/
	if RIDRETH1=3 then race_4=0;
	if RIDRETH1=4 then race_4=1;
	if RIDRETH1=1 then race_4=2;
	if RIDRETH1=2 OR RIDRETH1=5 then race_4=3;
	if race_4=1 then race_black=1;if race_4 in (0,2,3) then race_black=0;
	if race_4=2 then race_ma=1;if race_4 in (0,1,3) then race_ma=0;
	if race_4=3 then race_other=1;if race_4 in (0,1,2) then race_other=0;
/*education*/
	/*0 <HS; 1 HS; 2 >HS*/
	if DMDEDUC2<3 then edu_3=0;
	if DMDEDUC2=3 then edu_3=1;
	if DMDEDUC2>3 then edu_3=2;
	if DMDEDUC2>=7 then edu_3=.;
/*ototoxic*/
/*smoking*/
	if smq040 in(1,2) then smoker=1;
	if smq040=3 then smoker=0;
	if smq040 in(7,9) then smoker=.;
	if smq020=2 then smoker=0;
	if smq020=. then smoker=.;
	if smq020 in(7,9) then smoker=.;
/*diabetes*/
	/*diabetes3 0=none, 1=pre 2=diabetes*/
	if diq010=1 or lbxgh ge 6.5 then diabetes3=2;
	else if diq010=3 or 5.7 le lbxgh lt 6.5 then diabetes3=1;
	else if diq010=2 or lbxgh lt 5.7 then diabetes3=0;
	if diq010=9 and lbxgh=. then diabetes3=.;
	/*diabetes2 0=none(+pre) 1=diabetes*/
	if diabetes3 in(0,1) then diabetes2=0;
	if diabetes3 =2 then diabetes2=1;
	if diabetes3=. then diabetes2=.;
/*hypertesion*/
	if BPQ020=1 then hypertension=1;
	else if BPXSY1 > 140 or BPXDI1 > 90 then hypertension=1;
	else if BPQ020=2 then hypertension=0;
	if BPQ020=9 then hypertension=.;
/*occupation*/
	/*kickout 23, (4,12,13,18,19,20,22)=high onet, else not highonet*/
	if OCD395 in (0,77777,99999,.) then onethigh=.;
	else if OCD392 in (4,12,13,18,19,20,22) then onethigh=1;
	else if OCD392 in (1,2,3,5,6,7,8,9,10,11,14,15,16,17,21)then onethigh=0;
/*firearm*/
	if AUQ300=1 then noise_fire=1;
	else if AUQ300=2 then noise_fire=0;
	else if AUQ211=1 then noise_fire=1;
	else if AUQ211=2 then noise_fire=0;
/*recreational*/
	if AUQ370=1 then noise_re=1;
	else if AUQ370=2 then noise_re=0;
	else if AUQ231=1 then noise_re=1;
	else if AUQ231=2 then noise_re=0;
/*onjob*/
	if AUQ330=1 then noise_job=1;
	else if AUQ330=2 then noise_job=0;
	else if AUQ290=1 then noise_job=1;
	else if AUQ290=2 then noise_job=0;
/*ARSENIC*/
	if URDUASLC=1 then URXUAS=(0.88)**0.5; /*ug/L*/
	if URDUABLC=1 then URXUAB=(0.84)**0.5; /*ug/L*/
	if URDUACLC=1 then URXUAC=(0.2)**0.5; /*ug/L*/
	if (URXUAS-URXUAB-URXUAC)<=0 then inoAs=0.01; /*or0.01*/
	if (URXUAS-URXUAB-URXUAC)>0  then inoAs=URXUAS-URXUAB-URXUAC;
	if URXUAS=. or URXUAB=. or URXUAC=. then inoAs=.;
	inoAsCA=inoAs/URXUCR*100;/*ug/g*/
	loginoAs=log10(inoAs);	
	loginoAsCA=log10(inoAsCA);	
	logas=log10(URXUAS);	
	UASca=URXUAS/URXUCR*100;
	logasca=log10(uasca);
run;

proc freq data=df_cov; table AUXU500R*age_3;run;

proc sort data=df_cov;by seqn;run;
data dfa;merge df_cov ba.drugoto;run;
data dfa;set dfa;if seqn<62161 then delete;run;

data d1;set dfa;if AUX_NR=. OR AUX_NR=1 then delete;
if age_3=. then delete; run;

data d1;set d1; if AUX_hearLOSS=-1 then delete;run;
data d1;set d1; if URXUBA=. then delete;run;
data d1;set d1; if inoAs=. then delete;run;
data d1;set d1; if BMXBMI=. or race_4=. or hypertension=. or diabetes3=. then delete;run;
data d2;set d1; if noise_job=. or noise_fire=. or noise_re=. then delete;
if AUX_PTA<0 then AUX_PTA_NEG=1;
if AUX_PTA>=0 then AUX_PTA_NEG=0;
run;

proc freq data=d2;table URDUBALC AUX_hearloss;run;

/*analyzing d2**/
data ba.d2;set d2;run;
