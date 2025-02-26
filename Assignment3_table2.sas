/********************************************************** 
PROGRAM NAME: SAS Studio
PROGAMMER: X
CREATION DATE: February 26rd, 2025
PURPOSE: Reproducibility Assignment 3
***********************************************************/
Title1 'Reproducibility Assignment 3';
/* Set LIB Ref and Upload 2021 Adult CHIS dataset and Formats and Labels downloaded from:
https://healthpolicy.ucla.edu/our-work/california-health-interview-survey-chis/access-chis-data */
LIBNAME CON '/home/u61668959/EPI207/Assignment 3';
/* Verify Correct Dataset */
proc contents data=CON.Adult;
run;

/**** Research Question Specific Formatting and Corresponding Labels from CHIS 2021
ADULT_LABEL and ADULT_FORMAT ***********************/
/* Note: If desired, run all CHIS 2021 Adult labels and formats for full dataset */
PROC FORMAT;
VALUE  OMBSRREOP2X
     1                      = "Hispanic"
     2                      = "White, Non-Hispanic"
     3                      = "African American, Not Hispanic"
     4                      = "American Indian/Alaskan Native, Non-Hispanic "
     5                      = "Asian, Non-Hispanic "
     6                      = "Other"
;
VALUE  SRSEX
     1                      = "Male"
     2                      = "Female"
;
VALUE  MARITF
     -9                     = "NOT ASCERTAINED"
     1                      = "Married"
     2                      = "Other/Sep/Div/Living W/Partner"
     3                      = "Never Married"
;
VALUE  SPK_ENGF
     -9                     = "NOT ASCERTAINED"
     1                      = "Speak Only English"
     2                      = "Very Well/Well"
     3                      = "Not Well/Not At All"
;
VALUE	Stability
	1			     = "Very Stable"
	2 			     = "Fairly Stable"
	3			     = "Somewhat Stable"
	4 			     = "Fairly Unstable"
	5			     = "Very Unstable"
;
VALUE  SREDUC
     0                      = "< 18 YRS OLD"
     1                      = "< High School Education"
     2                      = "High School Education"
     3                      = "Some College"
     4                      = "College Degree Or Above"
;
VALUE  POVLLF
     1                      = "0-99% FPL"
     2                      = "100-199% FPL"
     3                      = "200-299% FPL"
     4                      = "300% FPL and Above"
;
VALUE  UR_CLRT4F
     -9                     = "NOT ASCERTAINED"
     -8                     = "DON'T KNOW"
     -7                     = "REFUSED"
     -5                     = "ADULT/HOUSEHOLD INFO NOT COLLECTED"
     -2                     = "PROXY SKIPPED"
     -1                     = "INAPPLICABLE"
     1                      = "Urban"
     2                      = "Mixed"
     3                      = "Suburban"
     4                      = "Rural"
;
VALUE  AK28X
     -9                     = "NOT ASCERTAINED"
     -8                     = "DON'T KNOW"
     -7                     = "REFUSED"
     -2                     = "PROXY SKIPPED"
     -1                     = "INAPPLICABLE"
     1                      = "All Of The Time"
     2                      = "Most Of The Time"
     3                      = "Some Of The Time"
     4                      = "None Of The Time"
;
VALUE  AGREE
     -9                     = "NOT ASCERTAINED"
     -8                     = "DON'T KNOW"
     -7                     = "REFUSED"
     -2                     = "PROXY SKIPPED"
     -1                     = "INAPPLICABLE"
     1                      = "Strongly Agree"
     2                      = "Agree"
     3                      = "Disagree"
     4                      = "Strongly Disagree"
;
VALUE  YESNO
     -9                     = "NOT ASCERTAINED"
     -8                     = "DON'T KNOW"
     -7                     = "REFUSED"
     -5                     = "ADULT/HOUSEHOLD INFO NOT COLLECTED"
     -2                     = "PROXY SKIPPED"
     -1                     = "INAPPLICABLE"
     1                      = "Yes"
     2                      = "No"
;
run;
/* Check AM183 and Age labels, formats, and data type (character or numeric) */
proc freq data=CON.ADULT;
TABLES AM183 SRAGE_P1;
run;
/*Recode Numeric Age variable (SRAGE_P1) to new binned AGE_GROUP */
DATA CON.CF;
  SET CON.ADULT;
	   /* Condense the age variable into the desired age groups */
	   IF SRAGE_P1 >= 18 AND SRAGE_P1 <= 29 THEN AGE_GROUP = '18–29 Years';
	   ELSE IF SRAGE_P1 >= 30 AND SRAGE_P1 <= 39 THEN AGE_GROUP = '30–39 Years';
	   ELSE IF SRAGE_P1 >= 40 AND SRAGE_P1 <= 49 THEN AGE_GROUP = '40–49 Years';
	   ELSE IF SRAGE_P1 >= 50 AND SRAGE_P1 <= 64 THEN AGE_GROUP = '50–64 Years';
	   ELSE IF SRAGE_P1 >= 65 THEN AGE_GROUP = '65 or older';
	   
	  ARRAY RAKEDW(81) RAKEDW0-RAKEDW80; 
  /* Add Label for the new age group variable to existing CHIS labels and formats */
  	  LABEL AGE_GROUP 	= "Age"
			OMBSRR_P1	= "Race"
			SRSEX		= "Sex"
			MARIT		= "Marital Status"
			SPK_ENG		= "English Proficiency"
			SREDUC		= "Education"
			POVLL		= "Poverty Level"
			UR_CLRT4	= "Urbanicity"
			AF113		= "Property Damage"
			AM183		= "Housing Stability"
			AM19		= "People in Neighborhood Willing to Help Each Other"
			AM20		= "People in Neighborhood Do Not Get Along"
			AM21		= "Trusts Neighborhood"
			AK28		= "Feels Safe in Neighborhood"
			AM39		= "Volunteered In Past 12 Months"
			AF110		= "The next set of questions are about potentially hazardous weather-related events that are increasing in California, including extreme heat waves, flooding, wildfires, smoke from wildfires, and the public safety power shutoffs of electricity to prevent a wildfire. In the past two years, have you or members of your household personally experienced any of these events?"
			AF112		= "Was your mental health (or the mental health of members of your household) harmed by any of these [extreme weather] events?"
			;
  format	OMBSRR_P1	OMBSRREOP2X. /*Attach level labels*/
	   		SRSEX		SRSEX.
	   		MARIT		MARITF.
	   		SPK_ENG		SPK_ENGF.
	   		SREDUC		SREDUC.
	   		POVLL		POVLLF.
	   		UR_CLRT4	UR_CLRT4F.
	   		AF113		YESNO.	
	   		AM183 		Stability.
			AM19		AGREE.
			AM20		AGREE.
			AM21		AGREE.
			AK28		AK28X.
			AM39		YESNO.
			AF110		YESNO.
	   		AF112		YESNO.
	   		AGE_GROUP	$CHAR20.
  			;
			if AF112 ne -1;	/*remove the inapplicable answers*/
RUN;
proc contents data=Con.CF varnum;
run;
/* Conduct Additional Variable Specific Formatting */
/* Format Housing Stability Response Values */
proc format;
value
Stability
	1 = "Very Stable"
	2 = "Fairly Stable"
	3 = "Somewhat Stable"
	4 = "Fairly Unstable"
	5 = "Very Unstable";
run;
data CON.CF;
	set CON.CF;
	FORMAT
AM183 Stability.;
run;
/* The step below is optional, but decreases processing time in SAS */
/* Make a smaller analytic dataset for ease of use from original CHIS Adult */
data CON.CF;
   set CON.CF(keep= AGE_GROUP OMBSRR_P1 SRSEX MARIT SPK_ENG SREDUC POVLL
                   UR_CLRT4 AF113 AM183 AM19 AM20 AM21 AK28 AM39 AF110 AF112 RAKEDW0-RAKEDW80);
run;
/* Verify correct dataset included  */
proc contents data=CON.CF;
   title "CHIS Dataset with Selected Variables";
run;
/* Verify total observations and variable frequencies among analytic sample (N=12,955) */
proc freq data=Con.CF;
tables AF112 Age_Group OMBSRR_P1 SRSEX SPK_ENG SREDUC POVLL UR_CLRT4
MARIT AF113 AM183 AM19 AM20 AM21 AK28 AM39 AM20;
run; 
/* Set responses "PROXY SKIPPED" to missing for covariates included in model */
DATA CON.CF;
   SET CON.CF;
  
   ARRAY vars {*} AF113 AM183 AM19 AM20 AM21 AK28 AM39 AM20;
  
   DO i = 1 TO DIM(vars);
       IF vars[i] = -2 THEN vars[i] = .;
   END;
  
   DROP i; /* Clean up the temporary index variable */
RUN;
/* Create Data Dictionary and Codebook */
/* Data Dictionary of Variables Used in Analysis/Analytic Sample */
proc contents data=CON.CF out=Data_Dictionary(keep=varnum name length label format);
run;


/* Create Table 1 */
/*Creating Table 1, run macro code from UCSF
!!!!!! Make sure to have code ran for append.sas checkvar.sas NPar1way.sas Table1.sas
Table1Print.sas Univariate.sas Varlist.sas words.sas !!!!! */
/* Table 1 contains UNWEIGHTED Descriptive Stats */
%Table1(DSName=CON.CF,
GroupVar=AF112,
NumVars=,
FreqVars=AGE_GROUP OMBSRR_P1 SRSEX MARIT SPK_ENG SREDUC POVLL UR_CLRT4 AF113 AM183 AM19 AM20
AM21 AK28 AM39,
Mean=N,
Median=N,
Total=N,
P=N,
Fisher=,
KW=,
FreqCell=N(CP),
Missing=N,
Print=Y,
Dec=A,
Sig=2,
Label=L,
Out=dir.a, /*output for the Table1print */
Out1way=b);
ODS RTF FILE = '/home/u61668959/EPI207/Assignment 3/Table1_A2.rtf' STYLE= journal; /*creates journal-style formatted table*/
%Table1print(DSname=CON.CF,Space=N);
ODS RTF CLOSE
/* Run unadjusted models with Survey Weights */
PROC SURVEYLOGISTIC DATA = CON.CF VARMETHOD=JACKKNIFE;
WEIGHT rakedw0;
REPWEIGHTS rakedw1-rakedw80/JKCOEFS=1;
CLASS 	AM19 (REF = "Strongly Disagree") AF112 (REF ="No") / PARAM=REF;
MODEL AF112 = AM19;
RUN;
PROC SURVEYLOGISTIC DATA = CON.CF VARMETHOD=JACKKNIFE;
WEIGHT rakedw0;
REPWEIGHTS rakedw1-rakedw80/JKCOEFS=1;
CLASS 	AM21 (REF = "Strongly Disagree") AF112 (REF ="No") /PARAM=REF;
MODEL AF112 = AM21;
RUN;
PROC SURVEYLOGISTIC DATA = CON.CF VARMETHOD=JACKKNIFE;
WEIGHT rakedw0;
REPWEIGHTS rakedw1-rakedw80/JKCOEFS=1;
CLASS 	AK28 (REF = "None Of The Time") AF112 (REF ="No") /PARAM=REF;
MODEL AF112 = AK28;
RUN;
PROC SURVEYLOGISTIC DATA = CON.CF VARMETHOD=JACKKNIFE;
WEIGHT rakedw0;
REPWEIGHTS rakedw1-rakedw80/JKCOEFS=1;
CLASS 	AM39 (REF = "No") AF112 (REF ="No") /PARAM=REF;
MODEL AF112 = AM39;
RUN;
PROC SURVEYLOGISTIC DATA = CON.CF VARMETHOD=JACKKNIFE;
WEIGHT rakedw0;
REPWEIGHTS rakedw1-rakedw80/JKCOEFS=1;
CLASS 	AM20 (REF = "Strongly Agree") AF112 (REF ="No") /PARAM=REF;
MODEL AF112 = AM20;
RUN;
/* Run Adjusted Model 1 For Each Social Cohesion Exposure */
PROC SURVEYLOGISTIC DATA = CON.CF VARMETHOD=JACKKNIFE;
WEIGHT rakedw0;
REPWEIGHTS rakedw1-rakedw80/JKCOEFS=1;
CLASS 	AGE_GROUP (REF = "65 or older")
		OMBSRR_P1 (REF = "White, Non-Hispanic")
		SRSEX (REF = "Male")
		MARIT (REF = "Married")
		SPK_ENG (REF = "Not Well/Not At All")
		SREDUC (REF = "High School Education")
		POVLL (REF = "0-99% FPL")
		UR_CLRT4 (REF = "Urban")
		AF113 (REF = "No")
		AM183 (REF = "Very Stable")	
		AM19 (REF = "Strongly Disagree")
		AF112 (REF ="No")/PARAM=REF;
MODEL AF112 = AM19 AGE_GROUP OMBSRR_P1 SRSEX MARIT SPK_ENG SREDUC POVLL UR_CLRT4 AF113 AM183;
RUN;
PROC SURVEYLOGISTIC DATA = CON.CF VARMETHOD=JACKKNIFE;
WEIGHT rakedw0;
REPWEIGHTS rakedw1-rakedw80/JKCOEFS=1;
CLASS 	AGE_GROUP (REF = "65 or older")
		OMBSRR_P1 (REF = "White, Non-Hispanic")
		SRSEX (REF = "Male")
		MARIT (REF = "Married")
		SPK_ENG (REF = "Not Well/Not At All")
		SREDUC (REF = "High School Education")
		POVLL (REF = "0-99% FPL")
		UR_CLRT4 (REF = "Urban")
		AF113 (REF = "No")
		AM183 (REF = "Very Stable")	
		AM21 (REF = "Strongly Disagree")
		AF112 (REF ="No")/PARAM=REF;
MODEL AF112 = AM21 AGE_GROUP OMBSRR_P1 SRSEX MARIT SPK_ENG SREDUC POVLL UR_CLRT4 AF113 AM183;
RUN;
PROC SURVEYLOGISTIC DATA = CON.CF VARMETHOD=JACKKNIFE;
WEIGHT rakedw0;
REPWEIGHTS rakedw1-rakedw80/JKCOEFS=1;
CLASS 	AGE_GROUP (REF = "65 or older")
		OMBSRR_P1 (REF = "White, Non-Hispanic")
		SRSEX (REF = "Male")
		MARIT (REF = "Married")
		SPK_ENG (REF = "Not Well/Not At All")
		SREDUC (REF = "High School Education")
		POVLL (REF = "0-99% FPL")
		UR_CLRT4 (REF = "Urban")
		AF113 (REF = "No")
		AM183 (REF = "Very Stable")	
		AK28 (REF = "None Of The Time")
		AF112 (REF ="No")/PARAM=REF;
MODEL AF112 = AK28 AGE_GROUP OMBSRR_P1 SRSEX MARIT SPK_ENG SREDUC POVLL UR_CLRT4 AF113 AM183;
RUN;
PROC SURVEYLOGISTIC DATA = CON.CF VARMETHOD=JACKKNIFE;
WEIGHT rakedw0;
REPWEIGHTS rakedw1-rakedw80/JKCOEFS=1;
CLASS 	AGE_GROUP (REF = "65 or older")
		OMBSRR_P1 (REF = "White, Non-Hispanic")
		SRSEX (REF = "Male")
		MARIT (REF = "Married")
		SPK_ENG (REF = "Not Well/Not At All")
		SREDUC (REF = "High School Education")
		POVLL (REF = "0-99% FPL")
		UR_CLRT4 (REF = "Urban")
		AF113 (REF = "No")
		AM183 (REF = "Very Stable")	
		AM39 (REF = "No")
		AF112 (REF ="No")/PARAM=REF;
MODEL AF112 = AM39 AGE_GROUP OMBSRR_P1 SRSEX MARIT SPK_ENG SREDUC POVLL UR_CLRT4 AF113 AM183;
RUN;
PROC SURVEYLOGISTIC DATA = CON.CF VARMETHOD=JACKKNIFE;
WEIGHT rakedw0;
REPWEIGHTS rakedw1-rakedw80/JKCOEFS=1;
CLASS 	AGE_GROUP (REF = "65 or older")
		OMBSRR_P1 (REF = "White, Non-Hispanic")
		SRSEX (REF = "Male")
		MARIT (REF = "Married")
		SPK_ENG (REF = "Not Well/Not At All")
		SREDUC (REF = "High School Education")
		POVLL (REF = "0-99% FPL")
		UR_CLRT4 (REF = "Urban")
		AF113 (REF = "No")
		AM183 (REF = "Very Stable")	
		AM20 (REF = "Strongly Agree")
		AF112 (REF ="No")/PARAM=REF;
MODEL AF112 = AM20 AGE_GROUP OMBSRR_P1 SRSEX MARIT SPK_ENG SREDUC POVLL UR_CLRT4 AF113 AM183;
RUN;
/* Run Adjusted Model 2 Including all Covariates and Social Cohesion Variables */
PROC SURVEYLOGISTIC DATA = CON.CF VARMETHOD=JACKKNIFE;
WEIGHT rakedw0;
REPWEIGHTS rakedw1-rakedw80/JKCOEFS=1;
CLASS 	AGE_GROUP (REF = "65 or older")
		OMBSRR_P1 (REF = "White, Non-Hispanic")
		SRSEX (REF = "Male")
		MARIT (REF = "Married")
		SPK_ENG (REF = "Not Well/Not At All")
		SREDUC (REF = "High School Education")
		POVLL (REF = "0-99% FPL")
		UR_CLRT4 (REF = "Urban")
		AF113 (REF = "No")
		AM183 (REF = "Very Stable")
		AM19 (REF = "Strongly Disagree")
		AM20 (REF = "Strongly Agree")
		AM21 (REF = "Strongly Disagree")
		AK28 (REF = "None Of The Time")
		AM39 (REF = "No")
		AF112 (REF ="No")/PARAM=REF;
MODEL AF112 = AGE_GROUP OMBSRR_P1 SRSEX MARIT SPK_ENG SREDUC POVLL UR_CLRT4 AF113 AM183 AM19 AM20 AM21 AK28 AM39;
RUN;
