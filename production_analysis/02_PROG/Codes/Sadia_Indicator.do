***ouverture de la base 

/* Il s'agit d'exécuter le dofile de tabulation des indicateurs*/

***********
***Milieu, region, global,
 
 ******Situation_fin Situation_eco score_dette score_rev score_Cherte_vie score_dep score_evolution_prix score_dynamique_prix

*cap drop milieu_
*encode milieu,gen(milieu_)

cap drop quintile
xtile quintile = pcexp [pw=hhweight], n(5)
pctile quintile_s = pcexp [pw=hhweight], n(5)
label var quintile "quintile global" /*Il s'agit de la situation Eco des ménages parmi les 12965*/

cap drop quintile_2
xtile quintile_2 = pcexp [pw=hhweight] if mois_2==1, n(5) /*Il s'agit de la situation Eco des ménages dans l'échantillon en cours d'interrogation*/

label var quintile_2 "quintile enquete"

cap drop quintile_3
xtile quintile_3 = pcexp [pw=new_pond2], n(5) /*Il s'agit de la situation Eco des ménages parmi les repondants (consent= "a repondu")*/

label var quintile_3 "quintile repondants"

local vars score_Cherte_vie bscore_Cherte_vie score_fin bscore_fin score_eco bscore_eco score_rev bscore_rev score_dep bscore_dep score_evolution_prix bscore_evolution_prix score_dynamique_prix bscore_dynamique_prix score_dette bscore_dette

	
*keep if _merge==3
	
	svyset[pw=new_pond2]
foreach var of local vars {
		/*Global*/
 svy:mean `var'
 mat list r(table)
    mat define RESU_global_b = (r(table)[rownumb(r(table),"b"), 1])'
    mat define RESU_global_se = (r(table)[rownumb(r(table),"se"), 1])'
    mat define RESU_global_p = (r(table)[rownumb(r(table),"pvalue"), 1])'

    mat define RESU_global = RESU_global_b, RESU_global_se,RESU_global_p	

	
    /* Milieu de résidence */
 svy:mean `var', over(milieu)
    mat list r(table)
    mat define RESU_milieu_b = (r(table)[rownumb(r(table),"b"), 1..2])'
    mat define RESU_milieu_se = (r(table)[rownumb(r(table),"se"), 1..2])'
    mat define RESU_milieu_p = (r(table)[rownumb(r(table),"pvalue"), 1..2])'

    mat define RESU_milieu = RESU_milieu_b, RESU_milieu_se,RESU_milieu_p

    /* Region */
  svy:mean `var', over(region_2)
    mat list r(table)
    mat define RESU_region_b = (r(table)[rownumb(r(table),"b"), 1..33])'
    mat define RESU_region_se = (r(table)[rownumb(r(table),"se"), 1..33])'
    mat define RESU_region_p = (r(table)[rownumb(r(table),"pvalue"), 1..33])'

    mat define RESU_region = RESU_region_b, RESU_region_se,RESU_region_p

    /* Décile */
  svy:mean `var', over(quintile)
    mat list r(table)
    mat define RESU_quintile_b = (r(table)[rownumb(r(table),"b"), 1..5])'
    mat define RESU_quintile_se = (r(table)[rownumb(r(table),"se"), 1..5])'
    mat define RESU_quintile_p = (r(table)[rownumb(r(table),"pvalue"), 1..5])'

    mat define RESU_quintile = RESU_quintile_b, RESU_quintile_se,RESU_quintile_p

  svy:mean `var', over(quintile_2)
    mat list r(table)
    mat define RESU_quintile_2_b = (r(table)[rownumb(r(table),"b"), 1..5])'
    mat define RESU_quintile_2_se = (r(table)[rownumb(r(table),"se"), 1..5])'
    mat define RESU_quintile_2_p = (r(table)[rownumb(r(table),"pvalue"), 1..5])'

    mat define RESU_quintile_2 = RESU_quintile_2_b, RESU_quintile_2_se,RESU_quintile_2_p

	
	 svy:mean `var', over(quintile_3)
    mat list r(table)
    mat define RESU_quintile_3_b = (r(table)[rownumb(r(table),"b"), 1..5])'
    mat define RESU_quintile_3_se = (r(table)[rownumb(r(table),"se"), 1..5])'
    mat define RESU_quintile_3_p = (r(table)[rownumb(r(table),"pvalue"), 1..5])'

    mat define RESU_quintile_3 = RESU_quintile_3_b, RESU_quintile_3_se,RESU_quintile_3_p
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
	*break_2
	
    /* Exportation vers Excel */
	
	global resultat C:\Users\SADIA\Desktop\Cherte_vie\Indice_cherte_vie\Resultat
	
    putexcel set "$resultat\output_Avril.xlsx", sheet("`var'") modify 

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
