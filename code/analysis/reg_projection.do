
global root= "E:\Project"
global dofiles= "$root/Dofiles"
global logfiles= "$root/Logfiles"
global raw_data= "$root/Raw_data"
global working_data= "$root/Working_data"
global temp_data= "$root/Temp_data"
global tables= "$root/Tables2"
global figures= "$root/Figures"
cd "$working_data"
set scheme s1color


/**********************************************************************/
/*  SECTION 3: Merge	
    Notes: */
/**********************************************************************/

 use DaysOfBins_SSPs_Cities.dta, clear
 
	tab from

	duplicates report year 城市
	merge m:1 城市 using Error_num_bins.dta // generated from calculae_damage_step1.do
	gen coef_name="Coefficient"
	
	cap drop _merge
	merge m:1 城市 using weight_city_pop2020.dta, nogen
	
	merge m:1 coef_name using coef.dta, nogen
			

	gen wrong_freq_high=(num_bin1+num_bin2+num_bin3)/365*1.64
	gen wrong_freq_low=(num_bin5+num_bin6+num_bin7)/365*1.29
		
	forval i=1(1)10 {
		
		gen demage_bin`i'=(wrong_freq_high*CUM_ehigh_CB`i'+wrong_freq_low*CUM_elow_CB`i')/365/7
		replace  demage_bin`i'=Days_maxBin`i'*demage_bin`i'
		
	}
	
	gen demage_sum=demage_bin1
 
 	forval i=2(1)10 {
		
		replace demage_sum=demage_sum+demage_bin`i'
	}

		
	collapse (mean) demage_sum [aw=y20_pop], by(year source ) 
	tab source

	preserve
		keep if source=="ssp126" 
		set scheme s1color
		twoway scatter demage_sum year,mcolor("112 160 255 %60") msymbol(Oh) || lfitci demage_sum year,ciplot(rline) clcolor("248 118 109 *1.8" ) acolor("248 118 109 *1.8" ) level(99) legend(off) title("SSP1-2.6") xtitle("") alpattern(dash) ylabel(,tposition(inside)) xlabel(,tposition(inside))
		graph save daily_ssp_126.gph, replace
	restore
	
	preserve
		keep if source=="ssp245"
		set scheme s1color
		twoway scatter demage_sum year,mcolor("112 160 255 %60") msymbol(Oh) ||  lfitci demage_sum year,ciplot(rline) clcolor("248 118 109 *1.8" ) acolor("248 118 109 *1.8" ) level(99) legend(off) title("SSP2-4.5") xtitle("") alpattern(dash) ylabel(,tposition(inside)) xlabel(,tposition(inside))
		graph save daily_ssp_245.gph, replace
	restore
	
	preserve
		keep if source=="ssp370" 
		set scheme s1color
		twoway scatter demage_sum year,mcolor("112 160 255 %60") msymbol(Oh) ||  lfitci demage_sum year,ciplot(rline) clcolor("248 118 109 *1.8" ) acolor("248 118 109 *1.8" ) level(99) legend(off) title("SSP3-7.0") xtitle("")  alpattern(dash) ylabel(,tposition(inside)) xlabel(,tposition(inside))
		graph save daily_ssp_370.gph, replace
	restore
	
	preserve
		keep if source=="ssp585" 
		set scheme s1color
		twoway scatter demage_sum year,mcolor("112 160 255 %60") msymbol(Oh) ||  lfitci demage_sum year,ciplot(rline) clcolor("248 118 109 *1.8" ) acolor("248 118 109 *1.8" ) level(99) legend(off) title("SSP5-8.5") xtitle("") alpattern(dash) ylabel(,tposition(inside)) xlabel(,tposition(inside))
		graph save daily_ssp_585.gph, replace
	restore
	
	 gr combine "daily_ssp_585" "daily_ssp_370" "daily_ssp_245" "daily_ssp_126"  , col(2) ycommon
	 gr export $tables/SSPs.png,replace
	 gr save $tables/SSPs.gph,replace
	 
	 
	 
		
		
