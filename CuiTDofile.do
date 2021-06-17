*Summarize the data
sum pm25 gdp construction pop coal factory viheclepop
*Run the Initial linear model
reg pm25 gdp construction pop coal factory viheclepop
*Test for multicollinearity using VIF
estat vif
*Test for heteroskedasticity using BP test
predict e,resid
gen esqr = e^2
reg esqr gdp construction pop coal factory viheclepop
*The BP test suggests no hetero, use alternative white test to double check
predict yhat
gen yhatsq = yhat^2
reg esqr yhat yhatsq
*Create time fixed effect and entity fixed effect
tab city, gen(c)
gen yr14=0
replace yr14=1 if Year==2014
gen yr15=0
replace yr15=1 if Year==2015
gen yr16=0
replace yr16=1 if Year==2016
*regress fixed effect model
areg pm25 gdp construction pop coal factory viheclepop yr15 yr16,absorb(city)
*Test for multicollinearity
reg pm25 gdp construction pop coal factory viheclepop yr15 yr16 c2-c40
estat vif
corr pm25 gdp construction pop coal factory viheclepop yr15 yr16 c2-c40
*Test for Heteroskedasticity using graph
predict efix,resid
predict yhatfix
twoway scatter efix yhatfix
*Test for heteroskedasticity using BP TEST
gen efixsqr=efix^2
reg efixsqr gdp construction pop coal factory viheclepop yr15 yr16 c2-c40
areg efixsqr gdp construction pop coal factory viheclepop yr15 yr16,absorb(city)
*Test for heteroskedasticity using White Test
reg efixsqr gdp construction pop coal factory viheclepop yr15 yr16 c2-c40
imtest,p white
*I cannot use white test because the observation is so small
*Robust standard error to correct heteroskedasticity
reg pm25 gdp construction pop coal factory viheclepop yr15 yr16 c2-c40,robust
*Model 3, Cross sectional model
reg pm25 gdp construction pop coal factory viheclepop if Year==2014
estat vif
*Check for hetero
predict ecross,resid
gen ecross2=ecross^2
reg ecross2 gdp construction pop coal factory viheclepop if Year==2014
