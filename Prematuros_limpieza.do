
						**********************************
						***LIMPIEZA BASE DE DATOS CASOS***
						**********************************
local dir `c(pwd)'
cd "`c(pwd)'"
capture log close

import excel "CASOS.xlsx", firstrow

*Modificación variables*
rename NUMERO codigo
rename SEXO sexo
rename EG edadgest
rename PESOALNACER pesonac
rename PESOACORDEALAEG pesoeg
rename PCNACER pc 
rename PERDIDADEPESOMAXIMA ppm
rename DIAPERDIOPESOMAXIMO ppm_d
rename DIARECUPEROPESOALNACER peso_rec
rename PESOALALTA peso_alta
rename Gananciadepesoalalta ganancia_pesoalta
rename devariaciondepeso variacion_peso
rename PercentilPESOALALTA peso_altaperc
rename DIASDEHOSPITALIZACION d_hosp
rename DIASQUEALCANZO100CCKAGDLM d_100cc
rename DIASQUEALCANZO150CCKGDLM d_150cc
rename DIASQUEINICIANUTRICIONENTERA d_enteral
rename LMaLD lechemat_ld
rename DIASQUESEINICIANPT dias_npt
rename NPT d_npt
rename DISTRESSRESPIRATORIO sdra
rename HORASDEDISTRESRESPIRATORIO sdra_h
rename Suspensióndeviaoral susp_vo
rename MOTIVODESUSPENSIÓNDEVO motivo_suspvo
rename Desnutricionseveraalalta dsn_severa
rename Algungradodedesnutricionala grado_dsn

*Modificación etiquetas*
label variable codigo "Codigo"
label variable sexo "Sexo"
label variable edadgest "Edad gestacional"
label variable pesonac "Peso al nacer"
label variable pesoeg "Peso acuerdo a la edad gestacional"
label variable pc "Perimetro cefalico"
label variable ppm "Perdida de peso maxima en %"
label variable ppm_d "Dias perdidas peso maximo"
label variable peso_rec "Dias recuperacion peso al nacer"
label variable peso_alta "Peso al alta"
label variable ganancia_pesoalta "Ganancia de peso al alta"
label variable variacion_peso "Porcentaje variacion de peso"
label variable peso_altaperc "Percentil peso al alta"
label variable d_hosp "Dias de hospitalizacion"
label variable d_100cc "Dias que alcanzo100cc/kag/d LM"
label variable d_150cc "Dias que alcanzo 150cc/kag/d LM"
label variable d_enteral "Dias que inicio nutricion enteral"
label variable lechemat_ld  "Leche materna a libre demanda"
label variable dias_npt "Dias que inicia npt"
label variable d_npt "Nutricion parenteral"
label variable sdra "Distress respiratorio"
label variable sdra_h "Horas de distress respiratorio"
label variable susp_vo "Suspension via oral"
label variable motivo_suspvo "Motivo de suspension via oral"
label variable dsn_severa "Desnutricion severa al alta"
label variable grado_dsn "algun grado de desnutricion al alta"

*Completar códigos*
replace codigo = _n

*Definir valores*
label def sexodef	0 "Femenino" 1 "Masculino"
lab val sexo sexodef

lab def edadgestdef	28 "28 sem" 29 "29 sem" 30 "30 sem" 31 "31 sem" 32 "32 sem" ///
					33 "33 sem" 34 "34 sem"
lab val edadgest edadgestdef

lab def pesoegdef 0 "grande para su edad gestacional" 1 "adecuado para su edad gestacional" 2 "pequeño para su edad gestacional"
lab val pesoeg pesoegdef

lab def ganancia_pesoaltadef 0 "No" 1 "Si"
lab val ganancia_pesoalta ganancia_pesoaltadef

label def peso_altapercdef	0 "<p3" 1 "p3-p10" 3 "p10-p90"
lab val peso_altaperc peso_altapercdef

label def lechemat_lddef 0 "No" 1 "Si"
lab val lechemat_ld lechemat_lddef

label def d_nptdef 0 "No" 1 "Si"
label val d_npt d_nptdef 

label def sdradef 0 "No" 1 "Si"
label val sdra sdradef

label def sdra_hdef 0 "Sin distress" 1 "<24 horas" 2 "24-48 horas" 3 "49-72 horas" /// 
					4 "73-96 horas"  5 ">96 horas"
lab val sdra_h sdra_hdef

label def susp_vodef 0 "No" 1 "Si"
label val susp_vo susp_vodef

label def motivo_suspvodef 0 "Ninguna" 1 "Apnea" 2 "Distres respiratorio" 3 "Depresion moderada" ///
						   4 "Paro cardiorespiratorio" 5 "Distension abdominal" 6 "Ausencia de ruidos hidroaereos" ///
						   7 "Disminucion de ruidos hidroaereos" 8 "Reflujo gastrico lacteo" 9 "Reflujo gastrico porraceo" ///
						   10 "Enterocolitis necrosante"
label val motivo_suspvo motivo_suspvodef

label def grado_dsndef 0 "p>10" 1 "p<10"
label val grado_dsn grado_dsndef

*Recodificar y añadir variables desnutricion*
recode edadgest (28 = 0)(29 = 1)(30 = 2)(31 = 3)(32 = 4)(33 = 5)(34 = 6)(35 = 7), gen (edadgest1)
label var edadgest1 "edadgest1"
label def edadgest1def 0 "28 sem" 1 "29 sem" 2 "30 sem" 3 "31 sem" 4 "32 sem" ///
					   5 "33 sem" 6 "34 sem" 7 "35 sem" 
label val edadgest1 edadgest1def
drop edadgest
rename edadgest1 edadgest

recode peso_altaperc (0 = 0)(1 = 1)(3 = 2), gen (peso_altaperc1)
label var peso_altaperc1 "peso_altaperc1"
label def peso_altaperc1def 0 "<p3" 1 "p3-p10" 2 "p10-p90"
label val peso_altaperc1 peso_altaperc1def
drop peso_altaperc
rename peso_altaperc1 peso_altaperc

gen desnutricion_severa=.
replace desnutricion_severa=0 if peso_altaperc==0 
replace desnutricion_severa=1 if peso_altaperc==1| peso_altaperc==2
label var desnutricion_severa "Desnutricion_severa" 
label def desnutricion_severadef 0 "<p3" 1 ">p3" 
label val desnutricion_severa desnutricion_severadef

gen desnutricion_extrauterina=.
label variable desnutricion_extrauterina "Desnutricion extrauterina"
replace desnutricion_extrauterina=0 if peso_altaperc ==0 | peso_altaperc ==1 
replace desnutricion_extrauterina=1 if peso_altaperc ==2 

label def desnutricion_extrauterinadef	0 "<p10" 1 ">p10" 
lab val desnutricion_extrauterina desnutricion_extrauterinadef

gen cc="caso"

save "casos.dta",replace
clear

					**************************************
					***LIMPIEZA BASE DE DATOS CONTROLES***
					**************************************
local dir `c(pwd)'
cd "`c(pwd)'"
capture log close

import excel "CONTROLES.xlsx", firstrow
drop R-Z
drop in 350/999

*Modificación variables*
rename NÚMERO codigo
rename EDADGESTACIONAL edadgest
rename PESOALNACER pesonac
rename PESOACUERDOALAEDADGESTACION pesoeg
rename SEXO sexo
rename PCALNACER pc 
rename PÉRDIDADEPESOMAXIMAEN ppm
rename DÍASPÉRDIDASPESOMÁXIMO ppm_d
rename DÍASRECUPERACIÓNPESOALNACER peso_rec
rename PESOALALTA peso_alta
rename PercentilPESOALALTA peso_altaperc
rename DÍASDEHOSPITALIZACIÓN d_hosp
rename DIASQUEALCANZO100CCKAGDLM d_100cc
rename DIASQUEALCANZO150CCKAGDLM d_150cc
rename DÍASQUEINICIONUTRICIONENTERA d_enteral
rename DISTRESSRESPIRATORIO sdra
rename HORASDEDISTRESSRESPIRATORIO sdra_h

*Modificación etiquetas*
label variable codigo "Codigo"
label variable edadgest "Edad gestacional"
label variable pesonac "Peso al nacer"
label variable pesoeg "Peso acuerdo a la edad gestacional"
label variable sexo "Sexo"
label variable pc "Perimetro cefalico"
label variable ppm "Perdida de peso maxima en %"
label variable ppm_d "Dias perdidas peso maximo"
label variable peso_rec "Dias recuperacion peso al nacer"
label variable peso_alta "Peso al alta"
label variable peso_altaperc "Percentil peso al alta"
label variable d_hosp "Dias de hospitalizacion"
label variable d_100cc "Dias que alcanzo100cc/kag/d LM"
label variable d_150cc "Dias que alcanzo 150cc/kag/d LM"
label variable d_enteral "Dias que inicio nutricion enteral "
label variable sdra "Distress respiratorio"
label variable sdra_h "Horas de distress respiratorio"

*Completar códigos*
replace codigo = _n

*Missings*
replace peso_rec=" " if peso_rec=="NO"
destring peso_rec, generate (peso_rec2)
drop peso_rec
rename peso_rec2 peso_rec

*Definir valores*
lab def edadgestdef	1 "28 sem" 2 "29 sem" 3 "30 sem" 4 "31 sem" 5 "32 sem" ///
					6 "33 sem" 7 "34 sem" 8 "35 sem"
lab val edadgest edadgestdef

lab def pesoegdef  1 "grande para su edad gestacional" 2 "adecuado para su edad gestacional" 3 "pequeño para su edad gestacional"
lab val pesoeg pesoegdef

label def sexodef	1 "Femenino" 2 "Masculino"
lab val sexo sexodef

label def peso_altapercdef	1 "<p3" 2 "p3-p10" 3 "p10-p90" 4 ">p90"
lab val peso_altaperc peso_altapercdef

label def d_enteraldef 1 "<24 hrs" 2 "24-48 hrs" 3 "73-96 hrs" 4 ">96hrs"
lab val d_enteral d_enteraldef

label def sdradef 1 "No" 2 "Si" 
lab val sdra sdradef

label def sdra_hdef 1 "Sin distress" 2 "<24 horas" 3 "24-48 horas" 4 "49-72 horas" /// 
					5 "73-96 horas" 6 ">96 horas"
lab val sdra_h sdra_hdef

*Recodificando y añadiendo variables desnutricion*
recode edadgest (1 = 0)(2 = 1)(3 = 2)(4 = 3)(5 = 4)(6 = 5)(7 = 6)(8 = 7), gen (edadgest1)
label var edadgest1 "edadgest1"
label def edadgest1def 0 "28 sem" 1 "29 sem" 2 "30 sem" 3 "31 sem" 4 "32 sem" ///
					   5 "33 sem" 6 "34 sem" 7 "35 sem" 
label val edadgest1 edadgest1def
drop edadgest
rename edadgest1 edadgest

recode pesoeg (1 = 0)(2 = 1)(3 = 2), gen (pesoeg1)
label var pesoeg1 "pesoeg1"
label def pesoeg1def 0 "grande para su edad gestacional" 1 "adecuado para su edad gestacional" 2 "pequeño para su edad gestacional"
label val pesoeg1 pesoeg1def
drop pesoeg
rename pesoeg1 pesoeg

recode sexo (1 = 0)(2 = 1), gen (sexo1)
label var sexo1 "sexo1"
label def sexo1def 0 "Femenino" 1 "Masculino"
label val sexo1 sexo1def
drop sexo
rename sexo1 sexo

recode peso_altaperc (1 = 0)(2 = 1)(3 = 2)(4 = 3), gen (peso_altaperc1)
label var peso_altaperc1 "peso_altaperc1"
label def peso_altaperc1def 0 "<p3" 1 "p3-p10" 2 "p10-p90" 3 ">p90"
label val peso_altaperc1 peso_altaperc1def
drop peso_altaperc
rename peso_altaperc1 peso_altaperc

recode d_enteral (1 = 0)(2 = 1)(3 = 2)(4 = 3), gen (d_enteral1)
label var d_enteral1 "d_enteral1"
label def d_enteral1def 0 "<24 hrs" 1 "24-48 hrs" 2 "73-96 hrs" 3 ">96hrs"
label val d_enteral1 d_enteral1def
drop d_enteral
rename d_enteral1 d_enteral

recode sdra (1 = 0)(2 = 1), gen (sdra1)
label var sdra1 "sdra1"
label def sdra1def 0 "No" 1 "Si" 
label val sdra1 sdra1def
drop sdra
rename sdra1 sdra

recode sdra_h (1 = 0)(2 = 1)(3 = 2)(4 = 3)(5 = 4)(6 = 5), gen (sdra_h1)
label var sdra_h1 "sdra1"
label def sdra_h1def 0 "Sin distress" 1 "<24 horas" 2 "24-48 horas" 3 "49-72 horas" /// 
					 4 "73-96 horas" 5 ">96 horas"
label val sdra_h1 sdra_h1def
drop sdra_h
rename sdra_h1 sdra_h

gen desnutricion_severa=.
replace desnutricion_severa=1 if peso_altaperc==1 
replace desnutricion_severa=2 if peso_altaperc==2| peso_altaperc==3 | peso_altaperc==4
label var desnutricion_severa "Desnutricion_severa"
label def desnutricion_severadef 1 "<p3" 2 ">p3" 
lab val desnutricion_severa desnutricion_severadef

recode desnutricion_severa (1 = 0)(2 = 1), gen (desnutricion_severa1)
label var desnutricion_severa1 "desnutricion_severa1"
label def desnutricion_severa1def 0 "<p3" 1 ">p3" 
label val desnutricion_severa1 desnutricion_severa1def
drop desnutricion_severa
rename desnutricion_severa1 desnutricion_severa

gen desnutricion_extrauterina=.
label var desnutricion_extrauterina "Desnutricion extrauterina"
replace desnutricion_extrauterina=0 if peso_altaperc ==1 | peso_altaperc ==2 
replace desnutricion_extrauterina=1 if peso_altaperc ==3 | peso_altaperc ==4

label def desnutricion_extrauterinadef	0 "<p10" 1 ">p10" 
lab val desnutricion_extrauterina desnutricion_extrauterinadef

gen cc="control"


save "controles.dta",replace
clear

		*******************************
		***CASOS Y CONTROLES LIMPIOS***
		*******************************
use "casos.dta", clear
append using "controles.dta"
encode cc, gen (cc2)
drop cc
rename cc2 cc
save "cc_prematuros.dta", replace

