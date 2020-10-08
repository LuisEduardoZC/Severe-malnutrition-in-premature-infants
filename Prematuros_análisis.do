		*******************************
		***CASOS Y CONTROLES LIMPIOS***
		*******************************
use "casos.dta", clear
append using "controles.dta"
encode cc, gen (cc2)
drop cc
rename cc2 cc
save "cc_prematuros.dta", replace

*Var según def Neonatología*
recode edadgest (0 = 0)(1 = 0)(2 = 0)(3 = 0)(4 = 1)(5 = 1)(6 = 1)(7 = 1), gen (pretermino_edadgest)
label var pretermino_edadgest "Pretermino segun edad gestacional"
label def pretermino_edadgestdef 0 "pretermino muy prematuro" 1 "pretérmino moderado a tardío" 
label val pretermino_edadgest pretermino_edadgestdef

		***********************************
		**ANALISIS DESCRIPTIVO UNIVARIADO**
		***********************************

*Variables Numericas*
#delimit;
global numericas="
pesonac  pc  ppm  ppm_d  peso_rec peso_alta variacion_peso  d_hosp  d_100cc  d_150cc d_enteral dias_npt
";
#delimit cr;

graph drop _all
foreach i in 	$numericas {
	sum `i', d
	histogram `i', name(`i') kdensity
	swilk `i'
}
graph combine $numericas 

*Variables Categóricas*
#delimit;
global categoricas="
sexo edadgest pesoeg peso_altaperc sdra ///
sdra_h desnutricion_severa desnutricion_extrauterina pretermino_edadgest   
";
#delimit cr;

graph drop _all
foreach i in 	$categoricas {
	tab `i'
}
*Tabla de proporciones*
prop $categoricas

		***********************************
		*******ANALISIS BIVARIADO**********
		***********************************

*Añadiendo y recodificando variables binarias*
gen pesonacbinar1=.
replace pesonacbinar1=0 if pesonac<2500
replace pesonacbinar1=1 if pesonac>=2500
label var pesonacbinar1 "Bajo peso al nacer 2500"
label def pesonacbinar1def 0 "<2500" 1 ">=2500" 
label val pesonacbinar1 pesonacbinar1def 

gen pesonacbinar2=.
replace pesonacbinar2=0 if pesonac<1500
replace pesonacbinar2=1 if pesonac>=1500
label var pesonacbinar2 "Peso extremadamente bajo 1500"
label def pesonacbinar2def 0 "<1500" 1 ">=1500" 
label val pesonacbinar2 pesonacbinar2def 

gen pesonacbinar3=.
replace pesonacbinar3=0 if pesonac<2000
replace pesonacbinar3=1 if pesonac>=2000
label var pesonacbinar3 "Peso bajo 2000"
label def pesonacbinar3def 0 "<2000" 1 ">=2000" 
label val pesonacbinar3 pesonacbinar3def 

gen pcbinar=.
replace pcbinar=0 if pc<34
replace pcbinar=1 if pc>=34
label var pcbinar "Perimetro cefálico 34"
label def pcbinardef 0 "pc<34" 1 "pc>=34" 
label val pcbinar pcbinardef 

gen ppmbinar=.
replace ppmbinar=0 if ppm<100
replace ppmbinar=1 if ppm>=100
label var ppmbinar "Pérdida máxima de peso en %"
label def ppmbinardef 0 "<100" 1 ">=100" 
label val ppmbinar ppmbinardef 

*ppm: 14-21*
gen ppm_dbinar1=.
replace ppm_dbinar1=0 if ppm_d<14
replace ppm_dbinar1=1 if ppm_d>=14
label var ppm_dbinar1 "Dias perdidos peso max 14d"
label def ppm_dbinar1def 0 "d<14" 1 "d>=14" 
label val ppm_dbinar1 ppm_dbinar1def 

gen ppm_dbinar2=.
replace ppm_dbinar2=0 if ppm_d<21 
replace ppm_dbinar2=1 if ppm_d>=21
label var ppm_dbinar2 "Dias perdidos peso max 21d"
label def ppm_dbinar2def 0 "d<21" 1 "d>=21" 
label val ppm_dbinar2 ppm_dbinar2def 

*peso_rec: 7-10*
gen peso_recbinar1=.
replace peso_recbinar1=0 if peso_rec<7
replace peso_recbinar1=1 if peso_rec>=7
label var peso_recbinar1 "Dias recuperacion peso al nacer 7d"
label def peso_recbinar1def 0 "<7" 1 ">=7" 
label val peso_recbinar1 peso_recbinar1def

gen peso_recbinar2=.
replace peso_recbinar2=0 if peso_rec<10
replace peso_recbinar2=1 if peso_rec>=10
label var peso_recbinar2 "Dias recuperacion peso al nacer 10d"
label def peso_recbinar2def 0 "<10" 1 ">=10" 
label val peso_recbinar2 peso_recbinar2def

*peso_alta: 2000-2500*
gen peso_altabinar1=.
replace peso_altabinar1=0 if peso_alta<2000  
replace peso_altabinar1=1 if peso_alta>=2000
label var peso_altabinar1 "Peso al alta 2000g"
label def peso_altabinar1def 0 "<2000 " 1 ">=2000" 
label val peso_altabinar1 peso_altabinar1def

gen peso_altabinar2=.
replace peso_altabinar2=0 if peso_alta<2500
replace peso_altabinar2=1 if peso_alta>=2500
label var peso_altabinar2 "Peso al alta 2500g"
label def peso_altabinar2def 0 "<2500" 1 ">=2500" 
label val peso_altabinar2 peso_altabinar2def

*d_hosp: 30-49d"
gen d_hospbinar1=.
replace d_hospbinar1=0 if d_hosp<30
replace d_hospbinar1=1 if d_hosp>=30
label var d_hospbinar1 "Dias hospitalizacion 30d"
label def d_hospbinar1def 0 "<30" 1 ">=30" 
label val d_hospbinar1 d_hospbinar1def

gen d_hospbinar2=.
replace d_hospbinar2=0 if d_hosp<49
replace d_hospbinar2=1 if d_hosp>=49
label var d_hospbinar2 "Dias hospitalizacion 49d"
label def d_hospbinar2def 0 "<49" 1 ">=49" 
label val d_hospbinar2 d_hospbinar2def

*d_100cc: 11d*
gen d_100ccbinar=.
replace d_100ccbinar=0 if d_100cc<11
replace d_100ccbinar=1 if d_100cc>=11
label var d_100ccbinar "Dias que alcanzo100cc/kag/d LM"
label def d_100ccbinardef 0 "<11" 1 ">=11" 
label val d_100ccbinar d_100ccbinardef

*d_150cc: 16d*
gen d_150ccbinar=.
replace d_150ccbinar=0 if d_150cc<16
replace d_150ccbinar=1 if d_150cc>=16
label var d_150ccbinar "Dias que alcanzo 150cc/kag/d LM"
label def d_150ccbinardef 0 "<16" 1 ">=16" 
label val d_150ccbinar d_150ccbinardef

*d_enteral: 2d*
gen d_enteralbinar=.
replace d_enteralbinar=0 if d_enteral<2
replace d_enteralbinar=1 if d_enteral>=2
label var d_enteralbinar "Dias que inicio nutricion enteral 2d"
label def d_enteralbinardef 0 "<2" 1 ">=2" 
label val d_enteralbinar d_enteralbinardef

*Crear var de sdra_h*
recode sdra_h (1 = 0)(2 = 0)(3 = 1)(4 = 1)(5 = 1), gen (sdra_h2)
label var sdra_h2 "horas de sdra2 bivariado"
label def sdra_h2def 0 "<=48 horas" 1 ">48 horas" 
label val sdra_h2 sdra_h2def

*Variable normal de horas con sdra*
recode sdra_h (2 = 0)(3 = 1)(4 = 2)(5 = 3)(6 = 3), gen (sdra_h3)
label var sdra_h3 "sdra3"
label def sdra_h3def 0 "<24 horas" 1 "24-48 horas" 2 "49-72 horas" /// 
					 3 ">72 horas"
label val sdra_h3 sdra_h3def

*Añadiendo correcciones*
replace pesonac=1850 if pesonac==18502

*Tabla bivariada variables binarias numéricas*
cc desnutricion_severa pesonacbinar3
cc desnutricion_severa pcbinar
cc desnutricion_severa ppmbinar
cc desnutricion_severa ppm_dbinar2
cc desnutricion_severa peso_recbinar2
cc desnutricion_severa peso_altabinar2
cc desnutricion_severa d_hospbinar2
cc desnutricion_severa d_100ccbinar
cc desnutricion_severa d_150ccbinar
cc desnutricion_severa d_enteralbinar

*Tabla bivariada variables binarias categóricas*
cc desnutricion_severa sexo
cc desnutricion_severa sdra
cc desnutricion_severa sdra_h2
cc desnutricion_severa pretermino_edadgest

		***********************************
		****ANALISIS MODELO DE REGRESION***
		***********************************

*Creación*
global prematuros1 "sexo pesonacbinar3 peso_recbinar2 pretermino_edadgest pcbinar ppm_dbinar2"            
global prematuros2 "sdra sdra_h3 d_enteralbinar d_150ccbinar d_hospbinar2"
global prematuros3 "ppmbinar peso_altabinar2"

*Modelo crudo*
glm desnutricion_severa ib1.sexo, link(log) family(poisson) eform vce(robust) nolog
glm desnutricion_severa ib0.pesonacbinar3, link(log) family(poisson) eform vce(robust) nolog
glm desnutricion_severa ib1.peso_recbinar2, link(log) family(poisson) eform vce(robust) nolog
glm desnutricion_severa ib1.pretermino_edadgest, link(log) family(poisson) eform vce(robust) nolog
glm desnutricion_severa ib0.pcbinar, link(log) family(poisson) eform vce(robust) nolog
glm desnutricion_severa ib0.ppm_dbinar2, link(log) family(poisson) eform vce(robust) nolog
glm desnutricion_severa ib0.sdra, link(log) family(poisson) eform vce(robust) nolog
glm desnutricion_severa ib0.sdra_h3, link(log) family(poisson) eform vce(robust) nolog
glm desnutricion_severa ib1.d_enteralbinar, link(log) family(poisson) eform vce(robust) nolog
glm desnutricion_severa ib1.d_150ccbinar, link(log) family(poisson) eform vce(robust) nolog
glm desnutricion_severa ib0.d_hospbinar2, link(log) family(poisson) eform vce(robust) nolog
glm desnutricion_severa ib1.ppmbinar, link(log) family(poisson) eform vce(robust) nolog
glm desnutricion_severa ib0.peso_altabinar2, link(log) family(poisson) eform vce(robust) nolog

*Modelo ajustado1 peso2000
logistic desnutricion_severa 	ib1.sexo ib0.pesonacbinar3 ib1.peso_recbinar2 ib1.pretermino_edadgest ib0.pcbinar ib0.ppm_dbinar2 ///
								ib0.sdra ib0.sdra_h3 ib1.d_enteralbinar ib1.d_150ccbinar ib0.d_hospbinar2 ///
								ib1.ppmbinar ib0.peso_altabinar2, nolog

