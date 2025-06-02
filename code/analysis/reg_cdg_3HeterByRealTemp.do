

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
/*  SECTION 1: title  			
    Notes: */
/**********************************************************************/


use treated_hosp_weathter_full_cdg0_HeterByRealized, clear




	global abs "date_yrmonth date_weekday city_month groups_month ctrl_nq_* bin_r_TempHigh_L*  "	
	global cntrls ""
	global cls "city_id" 

	local main_dep   
	local weighted "[aweight=pop_cyg]"
	local main_indep bin_dif1_TempMean
	
	cap erase "$tables/AppendixTable/AppendixTableA9.xls"
	cap erase "$tables/AppendixTable/AppendixTableA9.txt"
	
	foreach w in visit {
	foreach prefix in "l_" {
		*- weighted
		foreach suffix in   `w'_pop  {
			foreach sample in "1"   {
				
				reghdfejl `prefix'`suffix'  CUM_elow_CB*  CUM_ehigh_CB* L*_elow_CB* L*_ehigh_CB* is_high_L* ///
					${cntrls} `weighted' if `sample' , absorb(${abs}) cluster(${cls})
				est store  m_`w'
					est store dd_`w'_1
					est store dd_`w'_2

		set scheme s1color			
		event_plot 	dd_`w'_1 dd_`w'_2, 	///
		stub_lag( CUM_elow_CB# CUM_ehigh_CB# ) 		///		stub_lead(F_#	)		///
			together perturb(-0.1 0.1) trimlead(0) trimlag(13) noautolegend 									///
			plottype(scatter) ciplottype(rcap)  alpha(0.10)													///
				lag_opt1(msymbol(O) msize(1.3) mlwidth(0.5) color("248 118 109 *1.1")) lag_ci_opt1(color("248 118 109 *1.1") lw(0.5)) 	///
				lag_opt2(msymbol(D) msize(1.3) mlwidth(0.5) color("112 160 255 *1.1")) lag_ci_opt2(color("112 160 255 *1.1") lw(0.5)) 	///
						graph_opt(	                                   ///
								xtitle("Realized Temperature Deciles")     ///
								ytitle("Healthcare Visits") xlabel(1 "1st" 2 "2nd" 3 "3rd" 4 "4th" 5 "5th" 6 "6th" 7 "7th" 8 "8th" 9 "9th" 10 "10th" , tposition(inside)) ///
								ylabel(,tposition(inside)) ///
								yline(   0, lc(gs8) lp(dash)) ///
								legend(order(1 "Lower than Actual Temp." 3 "Higher than Actual Temp." ) ring(1) pos(6) row(1) region(style(none))) 	///
								graphregion(fcolor(white)) ///
								) 
					graph export "$tables/RC1_HeterByTemp_Para_`sample'_`prefix'`suffix'_wei.png", replace 
					graph save "$tables/RC1_HeterByTemp_Para_`sample'_`prefix'`suffix'_wei.gph", replace 
					outreg2 using "$tables/AppendixTable/AppendixTableA9.xls" ,append dec(3) keep(CUM_elow_CB*)
					outreg2 using "$tables/AppendixTable/AppendixTableA9.xls" ,append dec(3) keep(CUM_ehigh_CB*)					
					
                   }
				}
			}
		}
		
		
	foreach w in Expense_total {
	foreach prefix in "l_" {
		*- weighted
		foreach suffix in   `w'_pop  {
			foreach sample in "1"   {
				
				reghdfejl `prefix'`suffix'  CUM_elow_CB*  CUM_ehigh_CB* L*_elow_CB* L*_ehigh_CB* is_high_L* ///
					${cntrls} `weighted' if `sample' , absorb(${abs}) cluster(${cls})
				est store  m_`w'
					est store dd_`w'_1
					est store dd_`w'_2
		
		set scheme s1color			
		event_plot 	dd_`w'_1 dd_`w'_2, 	///
		stub_lag( CUM_elow_CB# CUM_ehigh_CB# ) 		///		stub_lead(F_#	)		///
			together perturb(-0.1 0.1) trimlead(0) trimlag(13) noautolegend 									///
			plottype(scatter) ciplottype(rcap)  alpha(0.10)													///
				lag_opt1(msymbol(O) msize(1.3) mlwidth(0.5) color("248 118 109 *1.1")) lag_ci_opt1(color("248 118 109 *1.1") lw(0.5)) 	///
				lag_opt2(msymbol(D) msize(1.3) mlwidth(0.5) color("112 160 255 *1.1")) lag_ci_opt2(color("112 160 255 *1.1") lw(0.5)) 	///
						graph_opt(	                                   ///
								xtitle("Realized Temperature Deciles")     ///
								ytitle("Medical Expenses") xlabel(1 "1st" 2 "2nd" 3 "3rd" 4 "4th" 5 "5th" 6 "6th" 7 "7th" 8 "8th" 9 "9th" 10 "10th" , tposition(inside)) ///
								ylabel(,tposition(inside)) ///
								yline(   0, lc(gs8) lp(dash)) ///
								legend(order(1 "Lower than Actual Temp." 3 "Higher than Actual Temp." ) ring(1) pos(6) row(1) region(style(none))) 	///
								graphregion(fcolor(white)) ///
								) 
					graph export "$tables/RC1_HeterByTemp_Para_`sample'_`prefix'`suffix'_wei.png", replace 
					graph save "$tables/RC1_HeterByTemp_Para_`sample'_`prefix'`suffix'_wei.gph", replace 
					outreg2 using "$tables/AppendixTable/AppendixTableA9.xls" ,append dec(3) keep(CUM_elow_CB*)
					outreg2 using "$tables/AppendixTable/AppendixTableA9.xls" ,append dec(3) keep(CUM_ehigh_CB*)					
					
                   }
				}
			}
		}
		