***ouverture de la base 

*use "C:\Users\Utilisateur\Downloads\a_transmettre_EJ.dta", clear

***********
***Milieu, region, global,
 
 ******Situation_fin Situation_eco score_dette score_rev score_Cherte_vie score_dep score_evolution_prix score_dynamique_prix

cap drop milieu_
encode milieu,gen(milieu_)

cap drop quintile
xtile quintile = pcexp [aw=hhweight], n(5)

label var quintile "quintile global"

cap drop quintile_2
xtile quintile_2 = pcexp [aw=hhweight] if mois_1==1, n(5)

label var quintile_2 "quintile enquete"

cap drop quintile_3
xtile quintile_3 = pcexp [aw=pondvf], n(5)

label var quintile_3 "quintile repondants"

local vars score_Cherte_vie bscore_Cherte_vie score_fin bscore_fin score_eco bscore_eco score_rev bscore_rev score_dep bscore_dep score_evolution_prix bscore_evolution_prix score_dynamique_prix bscore_dynamique_prix score_dette bscore_dette

/*
mean score_dynamique_prix
 mat list r(table)
    mat define RESU_global_b = (r(table)[rownumb(r(table),"b"), 1])'
    mat define RESU_global_se = (r(table)[rownumb(r(table),"se"), 1])'

    mat define RESU_global = RESU_global_b, RESU_global_se	
	
mat list 	RESU_global
mat list RESU_milieu
*/
	
keep if _merge==3
	
	svyset[pw=pondvf]
foreach var of local vars {
		/*Global*/
 svy:mean `var'
 mat list r(table)
    mat define RESU_global_b = (r(table)[rownumb(r(table),"b"), 1])'
    mat define RESU_global_se = (r(table)[rownumb(r(table),"se"), 1])'

    mat define RESU_global = RESU_global_b, RESU_global_se	

	
    /* Milieu de résidence */
 svy:mean `var', over(milieu_)
    mat list r(table)
    mat define RESU_milieu_b = (r(table)[rownumb(r(table),"b"), 1..2])'
    mat define RESU_milieu_se = (r(table)[rownumb(r(table),"se"), 1..2])'

    mat define RESU_milieu = RESU_milieu_b, RESU_milieu_se

    /* Region */
  svy:mean `var', over(Region_update)
    mat list r(table)
    mat define RESU_region_b = (r(table)[rownumb(r(table),"b"), 1..33])'
    mat define RESU_region_se = (r(table)[rownumb(r(table),"se"), 1..33])'

    mat define RESU_region = RESU_region_b, RESU_region_se

    /* Décile */
  svy:mean `var', over(quintile)
    mat list r(table)
    mat define RESU_quintile_b = (r(table)[rownumb(r(table),"b"), 1..5])'
    mat define RESU_quintile_se = (r(table)[rownumb(r(table),"se"), 1..5])'

    mat define RESU_quintile = RESU_quintile_b, RESU_quintile_se

  svy:mean `var', over(quintile_2)
    mat list r(table)
    mat define RESU_quintile_2_b = (r(table)[rownumb(r(table),"b"), 1..5])'
    mat define RESU_quintile_2_se = (r(table)[rownumb(r(table),"se"), 1..5])'

    mat define RESU_quintile_2 = RESU_quintile_2_b, RESU_quintile_2_se

	
	 svy:mean `var', over(quintile_3)
    mat list r(table)
    mat define RESU_quintile_3_b = (r(table)[rownumb(r(table),"b"), 1..5])'
    mat define RESU_quintile_3_se = (r(table)[rownumb(r(table),"se"), 1..5])'

    mat define RESU_quintile_3 = RESU_quintile_3_b, RESU_quintile_3_se
	/* Total */
	
	
	
    /* Création du tableau complet */
    mat define RESUglobale = (RESU_global) \(J(1, colsof(RESU_milieu), .)) \ (RESU_milieu) \ (J(1, colsof(RESU_region), .)) \ (RESU_region) \ (J(1, colsof(RESU_quintile), .)) \ (RESU_quintile)\ (J(1, colsof(RESU_quintile_2), .)) \ (RESU_quintile_2)\ (J(1, colsof(RESU_quintile_3), .)) \ (RESU_quintile_3)

    matrix colnames RESUglobale = "Moyenne" "Standard Error"

    matrix rownames RESUglobale = "Global" "Milieu de residence"  "Urbain" "Rural" "Region" ///
                                  "ABIDJAN" "AGNEBY-TIASSA" "BAFING" "BAGOUE" "BELIER" ///
                                  "BERE" "BOUNKANI" "CAVALLY" "FOLON" "GBEKE" "GBOKLE" ///
                                  "GOH" "GONTOUGO" "GRANDS-PONTS" "GUEMON" "HAMBOL" ///
                                  "HAUT-SASSANDRA" "IFFOU" "INDENIE-DJUABLIN" "KABADOUGOU" ///
                                  "LA ME" "LOH-DJIBOUA" "MARAHOUE" "MORONOU" "N'ZI" "NAWA" ///
                                  "PORO" "SAN-PEDRO" "SUD-COMOE" "TCHOLOGO" "TONKPI" ///
                                  "WORODOUGOU" "YAMOUSSOUKRO" "quintile" "1" "2" "3" "4" ///
                                  "5" "quintile_2" "1" "2" "3" "4" ///
                                  "5" "quintile_3" "1" "2" "3" "4" ///
                                  "5" 			  							  								  
								  
    /* Exportation vers Excel */
	
	global resultat C:\Users\SADIA\Desktop\Cherte_vie\ponderation_calibrage\Final_pond
	
    putexcel set "$resultat\output_3.xlsx", sheet("`var'") modify 

    putexcel B5 = matrix(RESUglobale), nformat(number_d2)
    putexcel B4 = matrix(RESUglobale), colnames nformat(number_d2)
    putexcel B4, bold border(bottom)
    putexcel A5 = matrix(RESUglobale), rownames

    putexcel B1 = "Tableau 1 : Calcul moyenne et standard error"
    putexcel B1, bold border(bottom)

    putexcel A3 = "Niveau de désagrégation"
    putexcel A3, bold border(bottom)

    putexcel C4, bold border(bottom)

    /* Sauvegarde et fermeture */
    putexcel save
    putexcel close
}
