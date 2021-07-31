// Exercise 2

cd "/Users/michelequaranta/Documents"
use "/Users/michelequaranta/Desktop/Introduction to Econometrics/data/female_lf.dta", clear

probit laborf husb_inc educ exper expersq age kidslt6 kidsge6, vce(robust) nolog
est store ProbitModel
predict laborf_predict, pr

// Margins of husb_inc with margin command
mfx, varlist(husb_inc)
margins, dydx(husb_inc) atmeans 


// Margins of education
margins, dydx(exper)at(exper=11) atmeans
margins, dydx(educ)

// LPM model
reg laborf husb_inc educ exper expersq age kidslt6 kidsge6, robust 
est store LPModel
predict laborff_predict, xb
label variable laborf_predict "Probit Model"
label variable laborff_predict "Linear Probability Model"
scatter laborf_predict laborff_predict

// Exercise 3

use "/Users/michelequaranta/Desktop/Introduction to Econometrics/data/asset.dta", clear
sort nettfa 
gen ptile = 100*[(_n-1)/(_N-1)]

// Estimation

set seed 10101
sqreg nettfa e401k inc age agesq, quantile(0.10 0.25 0.50 0.75 0.90) reps(100)
grqreg, ci ols olsci qmin(.05) qmax(.95) qstep(.05) list seed(10101) reps(100)

