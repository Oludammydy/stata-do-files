*\*********************************************************************
*Purpose: DHS Training practice
*Author: Oluwadamilola Olaniyi
*Date: 20th June 2023
*********************************************************************/
***Importing data file
clear all
cd "c:\FellowsWorkshop2"
set more off
use "NGKR7BFL.dta" , clear

*** to know the number used to code labels
numlabel, add

***Defining weight variables
gen wt= v005/100000
svyset [pw=wt], psu (v021) strata (v022) singleunit(centered) 

***Child factors***
**to generate child's age, eliminating dead children
gen child_age_group =.
replace child_age_group=. if b19==.
replace child_age_group=1 if b19>=0
replace child_age_group=2 if b19>=12
replace child_age_group=3 if b19>=24
replace child_age_group=4 if b19>=36
replace child_age_group=5 if b19>=48
replace child_age_group=. if b5==0
ta child_age_group
label define child_age_group 1 "0-11" 2 "12-23" 3 "24-35" 4 "36-47" 5 "48-59", replace
label values child_age_group child_age_group
tab child_age_group
tab child_age_group [iw=wt]

**sex of child
**to generate child's sex, eliminating dead children
gen child_sex =.
replace child_sex=. if b4==.
replace child_sex=1 if b4==1
replace child_sex=2 if b4==2
replace child_sex=. if b5==0
ta child_sex
label define child_sex 1 "male" 2 "female", replace
label values child_sex child_sex
tab child_sex
tab child_sex [iw=wt]

**birth weight of child in kg
ta m19
recode m19 (500/2400=1 "low") (2500/4000=2 "normal") (4009/6000=3 "high"),gen(birth_weight_group)
recode m14_1 (0 = 0 "None") (1 = 1 "1") (2/3 = 2 "2-3") (4/90 = 3 "4+")(98/99 = 9 "don't know/missing"), gen (ancvisits)

**multiple birth
ta b0
* binary for twin status
recode b0 (0=0 "single birth") (1/3=1 "Multiple births"), gen(twin_status)
ta twin_status

** birth order
**birth order recode using method 2
recode bord_01 (1=1 "1") (2/4=2 "2-4") (5/17=3 "5+"), gen (birth_order2)
ta birth_order2

***maternal factors***
**mother's age from IR
ta v013

**mother's education level
ta v106

**mother's occupation
ta v717

**mother's work status in the last 12months
ta v731 


***Outcome variable
**nutritional status of child
*Stunting for under five children using the KR recode
gen nt_ch_stunt= 0 
replace nt_ch_stunt=. if hw70>=9996
replace nt_ch_stunt=1 if hw70<-200 
label values nt_ch_stunt yesno
label var nt_ch_stunt "Stunted child under 5 years"
ta nt_ch_stunt

*Stunting for children less than 2 years 
gen nt_ch_stunt_2yrs= 0 
replace nt_ch_stunt_2yrs=. if hw70>=9996
replace nt_ch_stunt_2yrs=. if b19>23
replace nt_ch_stunt_2yrs=1 if hw70<-200 
label values nt_ch_stunt_2yrs yesno
label var nt_ch_stunt_2yrs "Stunted child under 2 years"

ta nt_ch_stunt_2yrs

*Stunting for infants
gen nt_ch_stunt_infant= 0 
replace nt_ch_stunt_infant=. if hw70>=9996
replace nt_ch_stunt_infant=. if b19>12
replace nt_ch_stunt_infant=1 if hw70<-200 
label values nt_ch_stunt_infant yesno
label var nt_ch_stunt_infant "Stunted infants"

*ta hw70
ta nt_ch_stunt_infant

*Wasting using the KR file
gen nt_ch_wast= 0 
replace nt_ch_wast=. if hw72>=9996
replace nt_ch_wast=1 if hw72<-200 
label values nt_ch_wast yesno
label var nt_ch_wast "Wasted child under 5 years"
ta nt_ch_wast

*Underweight using KR file
gen nt_ch_underw= 0 
replace nt_ch_underw=. if hw71>=9996
replace nt_ch_underw=1 if hw71<-200 
label values nt_ch_underw yesno
label var nt_ch_wast "Underweight child under 5 years"
ta nt_ch_underw

*BMI-for-age Zscores for under-five children
gen childbmi=hw73/100 if hw73<9998
*ta childbmi

*BMI-for-age categories
recode childbmi (-5/-2.01=1 "Thinness") (-2/1=2 "Normal") (1.01/2=3 "Overweight") (2.01/4.89=4 "Obesity"), gen (childbmi_cat)
ta childbmi_cat

*Recode BMI-for-age categories into 3
recode childbmi_cat (1=1 "Thinness") (2=2 "Normal") (3/4=3 "Overweight/Obese"), gen(childbmi_cat_3)
ta childbmi_cat_3

*recode for obesity status of under-five children
recode childbmi_cat (1/2=0 "otherwise") (3/4=1 "Obese"), gen(child_obesity)
ta child_obesity

*recode for Thinness status of under-five children
recode childbmi_cat (1=1 "Thin") (2/4=0 "Otherwise"), gen(child_Thinness)
ta child_Thinness

ta child_obesity
ta child_Thinness


***Dependent variable
** diet
* gave child bread, noodles, other made from grains (v414e) [food group=1] 
gen v414e_new=0
replace v414e_new=1 if v414e==1
ta v414e_new

* potatoes, cassava or other tubers (v414f) [food group=1]
gen v414f_new=0
replace v414f_new=1 if v414f==1
ta v414f_new

* gave child eggs (v414g) [food group=5]
gen v414g_new=0
replace v414g_new=1 if v414g==1
ta v414g_new

* gave child meat (v414h) [food group=4]
gen v414h_new=0
replace v414h_new=1 if v414h==1
ta v414h_new

* gave child Pumpkin, carrots, squash (yellow or orange inside)(v414i) [food group=6]
gen v414i_new=0
replace v414i_new=1 if v414i==1
ta v414i_new

* gave child Any dark green leafy vegetables (v414j) [food group=6]
gen v414j_new=0
replace v414j_new=1 if v414j==1
ta v414j_new

* gave child mangoes, papayas, other vitamin A fruits (v414k) [food group=6]
gen v414k_new=0
replace v414k_new=1 if v414k==1
ta v414k_new

* gave child Any other fruits or vegetables (v414l) [food group=7]
gen v414l_new=0
replace v414l_new=1 if v414l==1
ta v414l_new

* gave child Liver, heart, other organ meats (v414m) [food group=4]
gen v414m_new=0
replace v414m_new=1 if v414m==1
ta v414m_new

* gave child Fresh or dried fish or shellfish (v414n) [food group=4]
gen v414n_new=0
replace v414n_new=1 if v414n==1
ta v414n_new

* gave child Food made from beans, peas, lentils, nuts (v414o) [food group=2]
gen v414o_new=0
replace v414o_new=1 if v414o==1
ta v414o_new

* gave child Cheese yogurt or other milk products (v414p) [food group=3]
gen v414p_new=0
replace v414p_new=1 if v414p==1
ta v414p_new

**group 1 [Grains]
gen grain=0
replace grain=1 if v414e_new==1
replace grain=1 if v414f_new==1
ta grain

** group 2 [legumes and nuts]
gen legumes=0
replace legumes=1 if v414o_new==1
ta legumes

** group 3 [dairy products]
gen dairy=0
replace dairy=1 if v414p_new==1
ta dairy

** group 4 [flesh foods]
gen flesh=0
replace flesh=1 if v414h_new==1
replace flesh=1 if v414m_new==1
replace flesh=1 if v414n_new==1
ta flesh

** group 5 [eggs]
gen eggs=0
replace eggs=1 if v414g_new==1
ta eggs

** group 6 [vitA rich fruits and vegtables]
gen vitA=0
replace vitA=1 if v414i_new==1
replace vitA=1 if v414j_new==1
replace vitA=1 if v414k_new==1
ta vitA

** group 7 [other fruits and vegtables]
gen other=0
replace other=1 if v414l_new==1
ta other

*generate dds
gen dds=grain+legumes+dairy+flesh+eggs+vitA+other
tab dds 

*generate minimum dietary diversity
gen child_mdd=0
replace child_mdd=1 if dds >=4
ta child_mdd


* initiation of breastfeeding
* when child put to breast (v426)
* early initiation of breastfeeding (within 1 hour)
gen early_bf=0 
replace early_bf=1 if v426==0
ta early_bf


