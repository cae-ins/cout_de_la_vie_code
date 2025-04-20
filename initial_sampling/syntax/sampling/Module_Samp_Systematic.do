args menage CodReg
// 2. Calcul de la taille totale de la base
cap drop Taille_Base
gen Taille_Base = _N
sum Taille_Base
scalar define N = r(mean)
scalar define n = `menage'
scalar define pas = N/n
sort milieu pcexp
**********Sélection d'un nombre aléatoire entre 1 et le 'pas'
scalar define premier = int(runiform()*pas) + 1
**********définition d'un nouvel ID
cap drop ID
gen ID = _n
mat A = J(n,2,0) 
mat A[1,1] = premier
mat A[1,2] = runiform()*pas
forvalues i = 2/`menage' {
	mat A[`i',1] = round(premier + (`i' - 1) * pas)
	mat A[`i',2] = (premier + (`i' - 1) * pas)
}
if A[`menage',1] >= N{
	dis N
	mat A[`menage',1] = N
}
/* Checking */
dis pas
dis premier
**********Selection des unités tirées dans un nouveau dataset**********
mat colname A = ID
preserve 
clear
svmat A
rename A1 ID
save id_select_`CodReg'.dta, replace
restore
**********Selection des unités tirées dans un nouveau dataset**********
preserve
cap drop _merge
merge 1:1 ID using id_select_`CodReg'.dta
drop if _merge!=3
save base_group_`CodReg'.dta, replace
restore