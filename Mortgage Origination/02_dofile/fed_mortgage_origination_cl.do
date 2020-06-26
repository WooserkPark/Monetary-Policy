********************************************************************************
****   Project: FRBNY Quarterly Mortgage Origination Data Summary (Latest Update: 06/25/2020)
****   Producer: Wooserk Park
****   Steps: 1. FRBNY Mortgage Origination Data Cleaning
****		  2. Producing Graph
****   		  
****
****   Note1: Data from: https://www.newyorkfed.org/microeconomics/databank.html 
********************************************************************************

global master = "C:\Users\User\Documents\GitHub\Monetary-Policy\Mortgage Origination"
global datainput = "C:\Users\User\Documents\GitHub\Monetary-Policy\Mortgage Origination\01_data"
global dataoutput = "C:\Users\User\Documents\GitHub\Monetary-Policy\Mortgage Origination\03_figure"

********************************************************************************
** 1. FRBNY Mortgage Origination Data Cleaning                                **
********************************************************************************

** Cleaning **
import excel "$datainput\HHD_C_Report_2020Q1.xlsx", sheet("Page 6 Data") cellrange(A5:I81) clear
	drop G I 
	drop if A == ""
	rename (A B C D E F H) (qtr cs_less620 cs_620to659 cs_660to719 cs_720to759 cs_high760 total_amt)
	** qtr = Quarter and Year; cs = Credit Score; total_amt = total amount of mortgage origination **

	gen pct_cs_less620 = cs_less620 / total_amt * 100
	gen pct_cs_620to659 = cs_620to659 / total_amt * 100
	gen pct_cs_660to719 = cs_660to719 / total_amt * 100
	gen pct_cs_720to759 = cs_720to759 / total_amt * 100
	gen pct_cs_high760 = cs_high760 / total_amt * 100
	gen sum = pct_cs_less620 + pct_cs_620to659 + pct_cs_660to719 + pct_cs_720to759 + pct_cs_high760
	tab sum, m
	** all observations look fine **

********************************************************************************
** 2. Producing Graph                                					      **
********************************************************************************

** Producing Graph **
	gen grp_cs_less620 = pct_cs_less620
	gen grp_cs_620to659 = pct_cs_less620 + pct_cs_620to659
	gen grp_cs_660to719 = pct_cs_less620 + pct_cs_620to659 + pct_cs_660to719
	gen grp_cs_720to759 = pct_cs_less620 + pct_cs_620to659 + pct_cs_660to719 + pct_cs_720to759
	gen grp_cs_high760 = pct_cs_less620 + pct_cs_620to659 + pct_cs_660to719 + pct_cs_720to759 + pct_cs_high760
	keep  qtr grp_cs_less620 grp_cs_620to659 grp_cs_660to719 grp_cs_720to759 grp_cs_high760 total_amt
	** created these variables in order to show a percent distribution graph using Stata
	
	label variable grp_cs_less620 "<620"
	label variable grp_cs_620to659 "620-659"
	label variable grp_cs_660to719 "660-719"
	label variable grp_cs_720to759 "720-759"
	label variable grp_cs_high760 "760+"
	
	encode qtr, gen(qtr1)
	twoway (area grp_cs_high760 qtr1, fcolor(%85)) (area grp_cs_720to759 qtr1, fcolor(%85)) (area grp_cs_660to719 qtr1, fcolor(%85)) (area grp_cs_620to659 qtr1, fcolor(%85)) (area grp_cs_less620 qtr1, fcolor(%85)) (line total_amt qtr1, yaxis(2) lcolor(white) lwidth(thick) lpattern(dash)), ytitle("Share (%)") ytitle(, size(small) margin(medsmall)) ylabel(, labsize(small) angle(horizontal) tposition(crossing)) ytitle("Mortgage Origination Volume (Billions of $)", axis(2)) ytitle(, size(small) axis(2)) ylabel(1000 "1,000" 800 "800" 600 "600" 400 "400" 200 "200" 0 "0", labsize(small) angle(horizontal) tposition(crossing) axis(2)) xtitle("") xlabel(1 "03:Q1" 9 "05:Q1" 17 "07:Q1" 25 "09:Q1" 33 "11:Q1" 41 "13:Q1" 49 "15:Q1" 57 "17:Q1" 65 "19:Q1", labsize(small) tposition(crossing)) title(Mortgage Origination Share by Riskscore, size(medsmall) margin(medsmall)) note(Source: Federal Reserve Bank of New York, size(vsmall) color(gs9)) legend(order(1 "760+" 2 "720-759" 3 "660-719" 4 "620-659" 5 "<620") rows(1) size(small) region(fcolor(none) lcolor(none)) position(12))
	graph export "$dataoutput\FRBNY_mortgage_origination.pdf", as(pdf) replace


************
**   END  **
************
