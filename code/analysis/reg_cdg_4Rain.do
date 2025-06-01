
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



global per="6" 

use treated_hosp_weathter_full_cdg0_Rain, clear

	global abs "date_yrmonth date_weekday city_month groups_month ctrl_nq_* bin_r_TempHigh_L* rp_Status_rain_L* "	
	global cntrls ""
	global cls "city_id" 

	local weighted "[aweight=pop_cyg]"
	
	*- Reg: 
	
	local main_dep Expense_total  
	foreach w in `main_dep' {
	foreach prefix in "l_" {

		foreach suffix in   `w'_pop  {
			foreach sample in "1" { 
		
				reghdfejl `prefix'`suffix' CUM_dif_rain_level_CB* L*_dif_rain_level_CB*  ///
					CUM_dif_TempHigh_CB* L*_dif_TempHigh_CB* ///
					${cntrls} `weighted' if `sample' , absorb(${abs}) cluster(${cls})
				
				coefplot, omitted vertical keep( CUM_dif_rain_level_CB*) base recast(con) ///
					levels(90) ciopts(color(%10) lcolor(navy) recast(rarea)) ///
					ylabel(, grid tposition(inside))  ytit("")  yline(0, lc(navy)) ///
					xtit("Forecast Error (Rain Level)") xline() xlabel(,tposition(inside)) ///
					rename(CUM_dif_rain_level_CB0="≤-3" CUM_dif_rain_level_CB1="-2" ///
					CUM_dif_rain_level_CB2="-1" CUM_dif_rain_level_CB3="0" ///
					CUM_dif_rain_level_CB4="1" CUM_dif_rain_level_CB5="2" ///
					CUM_dif_rain_level_CB6="≥3" ///
					)
				

				graph export "$tables/RB4_Rain_Para_`sample'_`prefix'`suffix'_wei.png", replace 
				graph save "$figures/Baseline/Figure5_`sample'_`prefix'`suffix'_wei.gph",replace
					
                   }
				}
			}
		}

	local main_dep visit 
	local weighted "[aweight=pop_cyg]"

	foreach w in `main_dep' {
	foreach prefix in "l_" {
		foreach suffix in   `w'_pop  {
			foreach sample in "1" { 
				
				reghdfejl `prefix'`suffix' CUM_dif_rain_level_CB* L*_dif_rain_level_CB*  ///
					CUM_dif_TempHigh_CB* L*_dif_TempHigh_CB* ///
					${cntrls} `weighted' if `sample' , absorb(${abs}) cluster(${cls})
				
				coefplot, omitted vertical keep( CUM_dif_rain_level_CB*) base recast(con) ///
					levels(90) ciopts(color(%10) lcolor(navy) recast(rarea)) ///
					ylabel(, grid tposition(inside))  ytit("")  yline(0, lc(navy)) ///
					xtit("Forecast Error (Rain Level)") xline() xlabel(,tposition(inside)) ///
					rename(CUM_dif_rain_level_CB0="≤-3" CUM_dif_rain_level_CB1="-2" ///
					CUM_dif_rain_level_CB2="-1" CUM_dif_rain_level_CB3="0" ///
					CUM_dif_rain_level_CB4="1" CUM_dif_rain_level_CB5="2" ///
					CUM_dif_rain_level_CB6="≥3" ///
					)
				

				graph export "$tables/RB4_Rain_Para_`sample'_`prefix'`suffix'_wei.png", replace 
				graph save "$figures/Baseline/Figure5_`sample'_`prefix'`suffix'_wei.gph",replace
					
                   }
				}
			}
		}