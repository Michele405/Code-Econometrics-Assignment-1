// Exercise 1 

cd "/Users/michelequaranta/Documents"
use "/Users/michelequaranta/Desktop/Introduction to Econometrics/data/highschoolgrades_HW.dta", clear

// OLS estimation with test scores

reg GPA math_test lit_test gender i.class  
est store OLStestscores

// OLS estimation with average

reg GPA average gender i.class
est store OLSaverage 

// OLS standardized average 

sum average
gen z1average = (average - 73.57625) / 4.679469
reg GPA z1average gender i.class
est store OLSstandardaverage

// OLS with logGPA and logaverage

gen ln_GPA = log(GPA)
gen ln_average = log(average)
reg ln_GPA ln_average gender i.class
est store OLSlogGPA

// OLS with interaction term

reg GPA math_test lit_test c.math_test#c.lit_test gender i.class
est store OLSinteractionterm
margins, dydx(math_test) at(gender =1 class =3 lit_test =100)

esttab OLStestscores OLSaverage OLSstandardaverage OLSlogGPA OLSinteractionterm, se r2 star(* 0.1 ** 0.05 *** 0.01)

// Exercise 2

cd "/Users/michelequaranta/Documents"
use "/Users/michelequaranta/Desktop/Introduction to Econometrics/data/wage.dta", clear 

// OLS etimation 

reg log_wage educ exp black north south married 
est store olsroe
// IV regression 

ivregress 2sls log_wage (educ = uni_near) exp black north south married, robust
est store ivroe 
// Instrument relevance 

reg educ uni_near exp black north south married 
test uni_near

// Endogeneity tests 

reg educ uni_near exp black north south married 
predict res, residuals 
reg log_wage educ exp black north south married res, r 
est store olsres
ivregress 2sls log_wage (educ = uni_near) exp black north south married, robust 
estat endog

esttab olsroe ivroe olsres, se r2 star(* 0.1 ** 0.05 *** 0.01)
// Exercise 3 

use "/Users/michelequaranta/Desktop/Introduction to Econometrics/data/ts.dta", clear 

// Time settings 
replace date = "2000:01" in 173
replace date = "2000:02" in 174
replace date = "2000:03" in 175
replace date = "2000:04" in 176
replace date = "2001:01" in 177
replace date = "2001:02" in 178
replace date = "2001:03" in 179
replace date = "2001:04" in 180
replace date = "2002:01" in 181
replace date = "2002:02" in 182
replace date = "2002:03" in 183
replace date = "2002:04" in 184
replace date = "2003:01" in 185
replace date = "2003:02" in 186
replace date = "2003:03" in 187
replace date = "2003:04" in 188
replace date = "2004:01" in 189
replace date = "2004:02" in 190
replace date = "2004:03" in 191
replace date = "2004:04" in 192
replace date = "2005:01" in 193
gen qdate = quarterly(date, "YQ")
format qdate %tq
tsset qdate 

// AR and lag selection 

quietly reg gdp L(1/1).gdp if tin(1960q1,2005q1), robust
gen BIC_1 = ln(e(rss)/e(N))+e(rank)*(ln(e(N))/e(N)) if tin(1960q1,2005q1)
quietly reg gdp L(1/2).gdp if tin(1960q1,2005q1), robust
gen BIC_2 = ln(e(rss)/e(N))+e(rank)*(ln(e(N))/e(N)) if tin(1960q1,2005q1)
quietly reg gdp L(1/3).gdp if tin(1960q1,2005q1), robust
gen BIC_3 = ln(e(rss)/e(N))+e(rank)*(ln(e(N))/e(N)) if tin(1960q1,2005q1)
quietly reg gdp L(1/4).gdp if tin(1960q1,2005q1), robust
gen BIC_4 = ln(e(rss)/e(N))+e(rank)*(ln(e(N))/e(N)) if tin(1960q1,2005q1)
quietly reg gdp L(1/5).gdp if tin(1960q1,2005q1), robust
gen BIC_5 = ln(e(rss)/e(N))+e(rank)*(ln(e(N))/e(N)) if tin(1960q1,2005q1)
quietly reg gdp L(1/6).gdp if tin(1960q1,2005q1), robust
gen BIC_6 = ln(e(rss)/e(N))+e(rank)*(ln(e(N))/e(N)) if tin(1960q1,2005q1)
quietly reg gdp L(1/7).gdp if tin(1960q1,2005q1), robust
gen BIC_7 = ln(e(rss)/e(N))+e(rank)*(ln(e(N))/e(N)) if tin(1960q1,2005q1)
quietly reg gdp L(1/8).gdp if tin(1960q1,2005q1), robust
gen BIC_8 = ln(e(rss)/e(N))+e(rank)*(ln(e(N))/e(N)) if tin(1960q1,2005q1)
quietly reg gdp L(1/9).gdp if tin(1960q1,2005q1), robust
gen BIC_9 = ln(e(rss)/e(N))+e(rank)*(ln(e(N))/e(N)) if tin(1960q1,2005q1)
quietly reg gdp L(1/10).gdp if tin(1960q1,2005q1), robust
gen BIC_10 = ln(e(rss)/e(N))+e(rank)*(ln(e(N))/e(N)) if tin(1960q1,2005q1)
quietly reg gdp L(1/11).gdp if tin(1960q1,2005q1), robust
gen BIC_11 = ln(e(rss)/e(N))+e(rank)*(ln(e(N))/e(N)) if tin(1960q1,2005q1)
quietly reg gdp L(1/12).gdp if tin(1960q1,2005q1), robust
gen BIC_12 = ln(e(rss)/e(N))+e(rank)*(ln(e(N))/e(N)) if tin(1960q1,2005q1)
sum BIC*
dfuller gdp if tin(1960q1,2005q1), lags(3)

// OLS 

reg gdp L(1/3).gdp if tin(1960q1,1989q4), robust
predict gdp_predict if tin(1990q1,2005q1)
label variable gdp "Actual GDP growth"
label variable gdp_predict "Predicted GDP growth"
tsline gdp gdp_predict if tin(1990q1, 2005q1)
gen MSFE = (gdp_predict-gdp)^2
sum MSFE


// Exercise 4

use "/Users/michelequaranta/Desktop/Introduction to Econometrics/data/gun_state.dta", clear 

// Declare data to be panel 

xtset state year

// OLS and fixed effect

reg log_crime carry density pop avginc
est store olscr
xtreg log_crime carry density pop avginc, fe
est store fecr
xtreg log_crime carry density pop avginc i.state, fe vce(cluster state)
xtreg log_crime carry density pop avginc, re
xttest0
est store recr
esttab olscr fecr recr, se r2 star(* 0.1 ** 0.05 *** 0.01)
 
