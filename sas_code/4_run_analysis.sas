libname BA "C:\Users\YK Huang\Documents\UIC-2\201803_epid536\final_barium_hearingloss\Barium_hearingloss\data";
/*read**/
data d2;set ba.d2;run;

/*analysis*/
/*1. mean with survey*/
data d2;set ba.d2; if ridageyr>=20 then sel=1;else sel=2;if oto=1 then oto2=1;else oto2=0;run;

/*gm by group*/
proc surveymeans data=d2 stacking;
cluster sdmvpsu;strata sdmvstra;weight WTSA2YR;
domain sel sel*aux_hearloss sel*age_3 sel*sex sel*bmi_2 sel*race_4 sel*edu_3 sel*smoker sel*diabetes2 sel*hypertension sel*noise_fire sel*noise_re sel*noise_job;
class sex age_3 AUX_hearloss bmi_2;
var logbaca logba;
ods output domain=geomean;
data geomean;set geomean;
bacagm=round(10**logbaca_mean,0.01);
bacalcl=round(10**logbaca_lowerclmean,0.01);
bacaucl=round(10**logbaca_upperclmean,0.01);
/*bagm=round(10**logba_mean,0.01);
balcl=round(10**logba_lowerclmean,0.01);
baucl=round(10**logba_upperclmean,0.01);*/run;
proc print data=geomean;where sel=1;var domainlabel logbaca_n sel bacagm bacalcl bacaucl;run;

/*test diff*/
%macro testdiff(v);
proc surveyreg data=d2 nomcar;
cluster sdmvpsu;strata sdmvstra;weight WTSA2YR;domain sel;
model logbaca=&v/ vadjust=none;run;%mend testdiff;
%testdiff(AUX_hearloss);
%testdiff(sex);
%testdiff(age_3);
%testdiff(bmi_2);
%testdiff(race_4);
%testdiff(edu_3);
%testdiff(smoker);
%testdiff(hypertension);
%testdiff(diabetes2);
%testdiff(noise_fire);
%testdiff(noise_re);
%testdiff(noise_job);


proc freq data=d2;table (sex age_3 bmi_2 race_4 edu_3 smoker hypertension diabetes2 noise_fire noise_re noise_job)*AUX_hearloss/chisq;run;

proc univariate data=d2;var ubaca logbaca; histogram / normal;run;

proc surveymeans data=d2 stacking;
cluster sdmvpsu;strata sdmvstra;weight WTSA2YR;
domain sel sel*AUX_hearloss;
class riagendr age_3 AUX_hearloss;
var URXUBA ubaca inoAs inoASca;
run;

proc surveyfreq data=d2;
cluster sdmvpsu;strata sdmvstra;weight WTSA2YR;
table AUX_hearloss sex age_3 bmi_2 race_4 edu_3 smoker hypertension diabetes2 noise_fire noise_re noise_job;run;

proc surveymeans data=d2 quartiles percentile=(90,95);
cluster sdmvpsu;strata sdmvstra;weight wta;
domain sel sel*AUX_hearloss;
class riagendr age_3 AUX_hearloss;
var URXUBA ubaca inoAs inoASca;
run;

%macro dd (v);
proc univariate data=d2 noprint;
 var &v;
 output out=p pctlpre=P_
 pctlpts=20 40 60 80;
 weight WTSA2YR;
proc transpose data=p out=pt;
data pt2;set pt;COL2=round(COL1,0.01);
proc sort data=pt2
 nodupkey force noequals;
 by COL1;
proc print data=pt2;run;
%mend dd;
%dd(urxuba);
%dd(ubaca);
%dd(inoas);
%dd(inoasca);

%macro My_reg (mydata, myvar);
proc reg data=&mydata;
model y1=&myvar;
run;
%mend My_reg;


data d3;set d2;if AUX_PTA_NEG=1 then delete;
/*Q for UBA*/
if URXUBA lt 0.66 then UBA_4=0;
if 0.66 le URXUBA lt 1.26 then UBA_4=1;
if 1.26 le URXUBA lt 2.33 then UBA_4=2;
if URXUBA ge 2.33 then UBA_4=3;
if UBA_4=1 then UBAQ2=1;else UBAQ2=0;
if UBA_4=2 then UBAQ3=1;else UBAQ3=0;
if UBA_4=3 then UBAQ4=1;else UBAQ4=0;
if UBA_4 in(2,3) then UBAM=1;else UBAM=0;
if URXUBA ge 3.88 then UBA_90=1;else UBA_90=0;
if URXUBA ge 5.13 then UBA_95=1;else UBA_95=0;
/*Q for UBACA*/
if UBACA lt 0.80 then UBACA_4=0;
if 0.80 le UBACA lt 1.36 then UBACA_4=1;
if 1.36 le UBACA lt 2.19 then UBACA_4=2;
if UBACA ge 2.19 then UBACA_4=3;
if UBACA_4=1 then UBACAQ2=1;else UBACAQ2=0;
if UBACA_4=2 then UBACAQ3=1;else UBACAQ3=0;
if UBACA_4=3 then UBACAQ4=1;else UBACAQ4=0;
if UBACA_4 in(2,3) then UBACAM=1;else UBACAM=0;
if UBACA ge 3.85 then UBAca_90=1;else UBAca_90=0;
if UBACA ge 5.96 then UBAca_95=1;else UBAca_95=0;
if UBACA lt 0.69 then UBACA_5=0;
if 0.69 le UBACA lt 1.10 then UBACA_5=1;
if 1.10 le UBACA lt 1.64 then UBACA_5=2;
if 1.64 le UBACA lt 2.67 then UBACA_5=3;
if UBACA ge 2.67 then UBACA_5=4;
if UBACA_4=1 then UBACA5Q2=1;else UBACA5Q2=0;
if UBACA_4=2 then UBACA5Q3=1;else UBACA5Q3=0;
if UBACA_4=3 then UBACA5Q4=1;else UBACA5Q4=0;
if UBACA_4=4 then UBACA5Q5=1;else UBACA5Q5=0;
/*Q for inoAs*/
if inoAs lt 1.92 then uAs_4=0;
if 1.92 le inoAs lt 3.88 then uAs_4=1;
if 3.88 le inoAs lt 8.05 then uAs_4=2;
if inoAs ge 8.05 then uAs_4=3;
if uAs_4=1 then UasQ2=1;else UasQ2=0;
if uAs_4=2 then UasQ3=1;else UasQ3=0;
if uAs_4=3 then UasQ4=1;else UasQ4=0;
if uAs_4 in(2,3) then UasM=1;else UasM=0;
if inoAs ge 14.49 then Uas_90=1;else Uas_90=0;
if inoAs ge 19.98 then Uas_95=1;else Uas_95=0;
/*Q for inoAsCA*/
if inoAsca lt 2.20 then uAsCA_4=0;
if 2.20 le inoAsca lt 4.06 then uAsca_4=1;
if 4.06 le inoAsca lt 7.51 then uAsca_4=2;
if inoAsca ge 7.51 then uAsca_4=3;
if uAsca_4=1 then UascaQ2=1;else UascaQ2=0;
if uAsca_4=2 then UascaQ3=1;else UascaQ3=0;
if uAsca_4=3 then UascaQ4=1;else UascaQ4=0;
if uAsca_4 in(2,3) then UascaM=1;else UascaM=0;
if inoAsca ge 12.95 then Uasca_90=1;else Uasca_90=0;
if inoAsca ge 16.75 then Uasca_95=1;else Uasca_95=0;
logPTA=log10(AUX_PTA);
bacaiqr=urxuba/1.39;
logbacaiqr=log10(bacaiqr);
run;

/*model A1*/
proc surveylogistic data=d3 nomcar;
cluster sdmvpsu;strata sdmvstra;weight WTSA2YR;domain sel;
model AUX_hearloss (ref='0')=logbaca age_3 sex bmxbmi/ vadjust=none;run;
/*model B1*/
proc surveylogistic data=d3 nomcar;
cluster sdmvpsu;strata sdmvstra;weight WTSA2YR;domain sel;
model AUX_hearloss (ref='0')=logbaca age_3 sex bmxbmi edu_3 noise_job race_black race_ma race_other/ vadjust=none;run;
/*model C1*/
proc surveylogistic data=d3 nomcar;
cluster sdmvpsu;strata sdmvstra;weight WTSA2YR;domain sel;
model AUX_hearloss (ref='0')=logbaca age_3 sex bmxbmi edu_3 noise_job race_black race_ma race_other hypertension/ vadjust=none;run;

/*model A2*/
proc surveylogistic data=d3 nomcar;
cluster sdmvpsu;strata sdmvstra;weight WTSA2YR;domain sel;class ubaca_4(ref='0');
model AUX_hearloss (ref='0')=ubaca_4 age_3 sex bmxbmi;
CONTRAST 'ubaca linear' ubaca_4 -3 -1 1 3;
CONTRAST 'ubaca q' ubaca_4 -1 1 1 -1;
;run;

/*model B2*/
proc surveylogistic data=d3 nomcar;
cluster sdmvpsu;strata sdmvstra;weight WTSA2YR;domain sel;class ubaca_4(ref='0');
model AUX_hearloss (ref='0')=ubaca_4  age_3 sex bmxbmi edu_3 noise_job race_black race_ma race_other;
CONTRAST 'ubaca linear' ubaca_4 -3 -1 1 3;
CONTRAST 'ubaca q' ubaca_4 -1 1 1 -1;
;run;

/*model C2*/
proc surveylogistic data=d3 nomcar;
cluster sdmvpsu;strata sdmvstra;weight WTSA2YR;domain sel;class ubaca_4(ref='0');
model AUX_hearloss (ref='0')=ubaca_4 age_3 sex bmxbmi edu_3 noise_job race_black race_ma race_other hypertension logasca;
CONTRAST 'ubaca linear' ubaca_4 -3 -1 1 3;
CONTRAST 'ubaca q' ubaca_4 -1 1 1 -1;run;

proc surveylogistic data=d3 nomcar;
cluster sdmvpsu;strata sdmvstra;weight WTSA2YR;domain sel;class ubaca_5(ref='0');
model AUX_hearloss (ref='0')=ubaca_5 age_3 sex bmxbmi edu_3 noise_job race_black race_ma race_other hypertension;
CONTRAST 'ubaca linear' ubaca_5 -2 -1 0 1 2;
CONTRAST 'ubaca q' ubaca_5 2 -1 -2 -1 2;run;

/*reg*/
proc surveyreg data=d3 nomcar;
cluster sdmvpsu;strata sdmvstra;weight WTSA2YR;domain sel;
model AUX_PTA=logbaca age_3 sex bmxbmi/ solution;run;
/*model B1*/
proc surveyreg data=d3 nomcar;
cluster sdmvpsu;strata sdmvstra;weight WTSA2YR;domain sel;
model AUX_PTA=logbaca age_3 sex bmxbmi edu_3 noise_job race_black race_ma race_other/solution;run;
/*model C1*/
proc surveyreg data=d3 nomcar;
cluster sdmvpsu;strata sdmvstra;weight WTSA2YR;domain sel;
model AUX_PTA=logbaca age_3 sex bmxbmi edu_3 noise_job race_black race_ma race_other hypertension/solution;run;
/*a2*/
proc surveyreg data=d3 nomcar;
cluster sdmvpsu;strata sdmvstra;weight WTSA2YR;domain sel;
model AUX_PTA=ubacaq2 ubacaq3 ubacaq4 age_3 sex bmxbmi/ solution;run;
proc surveyreg data=d3 nomcar;
cluster sdmvpsu;strata sdmvstra;weight WTSA2YR;domain sel;class ubaca_4;
model AUX_PTA=ubaca_4 age_3 sex bmxbmi/ solution;
CONTRAST 'ubaca linear' ubaca_4 -3 -1 1 3; 
CONTRAST 'ubaca q' ubaca_4 -1 1 1 -1;run;

/*b2*/
proc surveyreg data=d3 nomcar;
cluster sdmvpsu;strata sdmvstra;weight WTSA2YR;domain sel;
model AUX_PTA=ubacaq2 ubacaq3 ubacaq4 age_3 sex bmxbmi edu_3 noise_job race_black race_ma race_other/ solution;run;
proc surveyreg data=d3 nomcar;
cluster sdmvpsu;strata sdmvstra;weight WTSA2YR;domain sel;class ubaca_4;
model AUX_PTA=ubaca_4 age_3 sex bmxbmi edu_3 noise_job race_black race_ma race_other/ solution;
CONTRAST 'ubaca linear' ubaca_4 -3 -1 1 3;
CONTRAST 'ubaca q' ubaca_4 -1 1 1 -1;run;
/*c2*/
proc surveyreg data=d3 nomcar;
cluster sdmvpsu;strata sdmvstra;weight WTSA2YR;domain sel;
model AUX_PTA=ubacaq2 ubacaq3 ubacaq4 age_3 sex bmxbmi edu_3 noise_job race_black race_ma race_other hypertension/ solution;run;

proc surveyreg data=d3 nomcar;
cluster sdmvpsu;strata sdmvstra;weight WTSA2YR;domain sel;
model AUX_PTA=ubacaq2 ubacaq3 ubacaq4 age_3 sex bmxbmi edu_3 noise_job race_black race_ma race_other hypertension loginoas/ solution;run;

proc surveyreg data=d3 nomcar;
cluster sdmvpsu;strata sdmvstra;weight WTSA2YR;domain sel;class ubaca_4;
model AUX_PTA=ubaca_4 age_3 sex bmxbmi edu_3 noise_job race_black race_ma race_other hypertension/ solution;
CONTRAST 'ubaca linear' ubaca_4 -3 -1 1 3;
CONTRAST 'ubaca q' ubaca_4 -1 1 1 -1;run;


/*
proc surveyreg data=d3 nomcar;
cluster sdmvpsu;strata sdmvstra;weight WTSA2YR;domain sel;class ubaca_5;
model AUX_PTA=ubaca_5 age_3 sex bmxbmi edu_3 noise_job race_black race_ma race_other hypertension/ solution;
CONTRAST 'ubaca linear' ubaca_5 -2 -1 0 1 2;
CONTRAST 'ubaca q' ubaca_5 2 -1 -2 -1 2;run;
*/

/*unweight*/
proc logistic data=d3;
model AUX_hearloss=logbaca age_3 sex bmxbmi;run;
proc logistic data=d3;
model AUX_hearloss=logbaca age_3 sex bmxbmi edu_3 noise_job race_black race_ma race_other;run;
proc logistic data=d3;
model AUX_hearloss=logbaca age_3 sex bmxbmi edu_3 noise_job race_black race_ma race_other hypertension;run;
proc logistic data=d3;class ubaca_4(ref='0');
model AUX_hearloss (ref='0')=ubaca_4 age_3 sex bmxbmi;run;
proc logistic data=d3;class ubaca_4(ref='0');
model AUX_hearloss (ref='0')=ubaca_4 age_3 sex bmxbmi edu_3 noise_job race_black race_ma race_other;run;
proc logistic data=d3;class ubaca_4(ref='0');
model AUX_hearloss (ref='0')=ubaca_4 age_3 sex bmxbmi edu_3 noise_job race_black race_ma race_other hypertension;run;

/*sup -6khz*/
proc surveyreg data=d3 nomcar;
cluster sdmvpsu;strata sdmvstra;weight WTSA2YR;domain sel;
model AUX_PTA6k=logbaca age_3 sex bmxbmi/ solution;run;
/*model B1*/
proc surveyreg data=d3 nomcar;
cluster sdmvpsu;strata sdmvstra;weight WTSA2YR;domain sel;
model AUX_PTA6k=logbaca age_3 sex bmxbmi edu_3 noise_job race_black race_ma race_other/solution;run;
/*model C1*/
proc surveyreg data=d3 nomcar;
cluster sdmvpsu;strata sdmvstra;weight WTSA2YR;domain sel;
model AUX_PTA6k=logbaca age_3 sex bmxbmi edu_3 noise_job race_black race_ma race_other hypertension/solution;run;
/*a2*/
proc surveyreg data=d3 nomcar;
cluster sdmvpsu;strata sdmvstra;weight WTSA2YR;domain sel;
model AUX_PTA6k=ubacaq2 ubacaq3 ubacaq4 age_3 sex bmxbmi/ solution;run;
proc surveyreg data=d3 nomcar;
cluster sdmvpsu;strata sdmvstra;weight WTSA2YR;domain sel;class ubaca_4;
model AUX_PTA6k=ubaca_4 age_3 sex bmxbmi/ solution;
CONTRAST 'ubaca linear' ubaca_4 -3 -1 1 3; 
CONTRAST 'ubaca q' ubaca_4 -1 1 1 -1;run;
/*b2*/
proc surveyreg data=d3 nomcar;
cluster sdmvpsu;strata sdmvstra;weight WTSA2YR;domain sel;
model AUX_PTA6k=ubacaq2 ubacaq3 ubacaq4 age_3 sex bmxbmi edu_3 noise_job race_black race_ma race_other/ solution;run;
proc surveyreg data=d3 nomcar;
cluster sdmvpsu;strata sdmvstra;weight WTSA2YR;domain sel;class ubaca_4;
model AUX_PTA6k=ubaca_4 age_3 sex bmxbmi edu_3 noise_job race_black race_ma race_other/ solution;
CONTRAST 'ubaca linear' ubaca_4 -3 -1 1 3;
CONTRAST 'ubaca q' ubaca_4 -1 1 1 -1;run;
/*c2*/
proc surveyreg data=d3 nomcar;
cluster sdmvpsu;strata sdmvstra;weight WTSA2YR;domain sel;
model AUX_PTA6k=ubacaq2 ubacaq3 ubacaq4 age_3 sex bmxbmi edu_3 noise_job race_black race_ma race_other hypertension/ solution;run;
proc surveyreg data=d3 nomcar;
cluster sdmvpsu;strata sdmvstra;weight WTSA2YR;domain sel;class ubaca_4;
model AUX_PTA6k=ubaca_4 age_3 sex bmxbmi edu_3 noise_job race_black race_ma race_other hypertension/ solution;
CONTRAST 'ubaca linear' ubaca_4 -3 -1 1 3;
CONTRAST 'ubaca q' ubaca_4 -1 1 1 -1;run;

/*sup -8khz*/
proc surveyreg data=d3 nomcar;
cluster sdmvpsu;strata sdmvstra;weight WTSA2YR;domain sel;
model AUX_PTA8k=logbaca age_3 sex bmxbmi/ solution;run;
/*model B1*/
proc surveyreg data=d3 nomcar;
cluster sdmvpsu;strata sdmvstra;weight WTSA2YR;domain sel;
model AUX_PTA8k=logbaca age_3 sex bmxbmi edu_3 noise_job race_black race_ma race_other/solution;run;
/*model C1*/
proc surveyreg data=d3 nomcar;
cluster sdmvpsu;strata sdmvstra;weight WTSA2YR;domain sel;
model AUX_PTA8k=logbaca age_3 sex bmxbmi edu_3 noise_job race_black race_ma race_other hypertension/solution;run;
/*a2*/
proc surveyreg data=d3 nomcar;
cluster sdmvpsu;strata sdmvstra;weight WTSA2YR;domain sel;
model AUX_PTA8k=ubacaq2 ubacaq3 ubacaq4 age_3 sex bmxbmi/ solution;run;
proc surveyreg data=d3 nomcar;
cluster sdmvpsu;strata sdmvstra;weight WTSA2YR;domain sel;class ubaca_4;
model AUX_PTA8k=ubaca_4 age_3 sex bmxbmi/ solution;
CONTRAST 'ubaca linear' ubaca_4 -3 -1 1 3; 
CONTRAST 'ubaca q' ubaca_4 -1 1 1 -1;run;
/*b2*/
proc surveyreg data=d3 nomcar;
cluster sdmvpsu;strata sdmvstra;weight WTSA2YR;domain sel;
model AUX_PTA8k=ubacaq2 ubacaq3 ubacaq4 age_3 sex bmxbmi edu_3 noise_job race_black race_ma race_other/ solution;run;
proc surveyreg data=d3 nomcar;
cluster sdmvpsu;strata sdmvstra;weight WTSA2YR;domain sel;class ubaca_4;
model AUX_PTA8k=ubaca_4 age_3 sex bmxbmi edu_3 noise_job race_black race_ma race_other/ solution;
CONTRAST 'ubaca linear' ubaca_4 -3 -1 1 3;
CONTRAST 'ubaca q' ubaca_4 -1 1 1 -1;run;
/*c2*/
proc surveyreg data=d3 nomcar;
cluster sdmvpsu;strata sdmvstra;weight WTSA2YR;domain sel;
model AUX_PTA8k=ubacaq2 ubacaq3 ubacaq4 age_3 sex bmxbmi edu_3 noise_job race_black race_ma race_other hypertension/ solution;run;
proc surveyreg data=d3 nomcar;
cluster sdmvpsu;strata sdmvstra;weight WTSA2YR;domain sel;class ubaca_4;
model AUX_PTA8k=ubaca_4 age_3 sex bmxbmi edu_3 noise_job race_black race_ma race_other hypertension/ solution;
CONTRAST 'ubaca linear' ubaca_4 -3 -1 1 3;
CONTRAST 'ubaca q' ubaca_4 -1 1 1 -1;run;



proc surveylogistic data=d3 nomcar;
cluster sdmvpsu;strata sdmvstra;weight WTA;domain sel;
model AUX_hearloss (ref='0')=ubacaq2 ubacaq3 ubacaq4 loginoasca RIAGENDR age_4 oto2 bmxbmi smoker/ vadjust=none;run;

proc surveylogistic data=d3 nomcar;
cluster sdmvpsu;strata sdmvstra;weight WTA;domain sel;
model AUX_hearloss (ref='0')=loginoAs urxuba urxucr age_4 bmxbmi edu_3 smoker oto2 noise_fire  race_black race_ma race_other hypertension/ vadjust=none;run;


proc surveylogistic data=d3 nomcar;
cluster sdmvpsu;strata sdmvstra;weight WTA;domain sel;
model AUX_hearloss (ref='0')= loginoASca RIAGENDR age_4 bmxbmi edu_3 diabetes2 noise_fire noise_re noise_job race_black race_ma race_other hypertension/ vadjust=none;run;

proc surveylogistic data=d3 nomcar;
cluster sdmvpsu;strata sdmvstra;weight WTA;domain sel;
model AUX_hearloss (ref='0')=logbaca loginoASca RIDAGEYR bmxbmi edu_3 diabetes2 noise_fire noise_re noise_job race_black race_ma race_other oto2/ vadjust=none;run;


proc surveylogistic data=d3 nomcar;
cluster sdmvpsu;strata sdmvstra;weight WTA;domain sel;
model AUX_hearloss (ref='0')= logbaca age_3 loginoASca bmxbmi edu_3 diabetes2 noise_fire noise_re noise_job race_black race_ma race_other/ vadjust=none;run;

proc surveyreg data=d3 nomcar;
cluster sdmvpsu;strata sdmvstra;weight wta;domain sel;
model AUX_PTA=logba loginoas urxucr ridageyr ridageyr*ridageyr riagendr bmxbmi edu_3 oto2 / vadjust=none;run;/ vadjust=none;run;

proc surveyreg data=d3 nomcar;
cluster sdmvpsu;strata sdmvstra;weight wta;domain sel;
model AUX_PTA=logbaca loginoasca ridageyr riagendr bmxbmi / vadjust=none;run;/ vadjust=none;run;
/**/

proc surveyreg data=d3 nomcar;
cluster sdmvpsu;strata sdmvstra;weight WTA;domain sel;
model AUX_PTA=loginoAsca logbaca age_4 bmxbmi edu_3 oto2 noise_fire  race_black race_ma race_other hypertension/ vadjust=none;run;

proc surveyreg data=d3 nomcar;
cluster sdmvpsu;strata sdmvstra;weight WTA;domain sel;
model AUX_PTA=loginoAs logba URXUCR age_4 RIAGENDR bmxbmi edu_3 oto2 smoker noise_fire noise_re race_black race_ma race_other/ vadjust=none;run;

proc surveyreg data=d3 nomcar;
cluster sdmvpsu;strata sdmvstra;weight WTA;domain sel;
model AUX_PTA=loginoAsca logba age_4 RIAGENDR bmxbmi edu_3 oto2 noise_fire noise_re race_black race_ma race_other/ vadjust=none;run;

proc surveylogistic data=d2 nomcar;
cluster sdmvpsu;strata sdmvstra;weight WTSA2YR;domain sel;
model hypertension= logbaca age_3 RIAGENDR edu_3 smoker diabetes3 BMXBMI/ vadjust=none;run;


proc surveylogistic data=d2 nomcar;
cluster sdmvpsu;strata sdmvstra;weight WTSA2YR;domain sel;
model hypertension= logbaca age_3 RIAGENDR edu_3 smoker BMXBMI/ vadjust=none;run;



proc glm data=d2;model AUX_PTA= logbaca age_3 RIAGENDR edu_3;run;

proc sort data=d2;by AUX_hearloss;

proc logistic data=d3;
 model AUX_hearloss (ref='0')= logbaca loginoas RIDAGEYR RIAGENDR bmxbmi oto2;run;

 proc sort data=d2 ;by AUX_hearloss ;
proc means data=d2 n mean std median p75 p90 p99 min max;var URXUBA UBACA urxuas inoas;run;


proc freq data=d3;table ubaca_4*AUX_hearloss ;run;



proc means data=ma09 min max p99;var RIDAGEYR;run;


proc univariate data=d3;var AUX_PTA logpta; histogram / normal;run;
