
global root= "E:\Project\气温差异和医疗\原始医保数据"
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

global per="6" 

use treated_hosp_weathter_full_cdg0, clear
	

	merge m:1 城市 时间 using rolling_rmse.dta
	sum rmse,detail
	
	gen rmse_multi=rmse>1.54422 
	gen CUM_elow_CB0_RMSE=CUM_elow_CB0*rmse_multi
	gen CUM_ehigh_CB0_RMSE=CUM_ehigh_CB0*rmse_multi
	
	
	gen L1_elow_CB0_RMSE=L1_elow_CB0*rmse_multi
	gen L2_elow_CB0_RMSE=L2_elow_CB0*rmse_multi
	gen L3_elow_CB0_RMSE=L3_elow_CB0*rmse_multi
	gen L4_elow_CB0_RMSE=L4_elow_CB0*rmse_multi
	gen L5_elow_CB0_RMSE=L5_elow_CB0*rmse_multi
	gen L6_elow_CB0_RMSE=L6_elow_CB0*rmse_multi
	gen L1_ehigh_CB0_RMSE=L1_ehigh_CB0*rmse_multi
	gen L2_ehigh_CB0_RMSE=L2_ehigh_CB0*rmse_multi
	gen L3_ehigh_CB0_RMSE=L3_ehigh_CB0*rmse_multi
	gen L4_ehigh_CB0_RMSE=L4_ehigh_CB0*rmse_multi
	gen L5_ehigh_CB0_RMSE=L5_ehigh_CB0*rmse_multi
	gen L6_ehigh_CB0_RMSE=L6_ehigh_CB0*rmse_multi
	


	global abs "date_yrmonth date_weekday city_month groups_month ctrl_nq_* bin_r_TempHigh_L*  "	
	global cntrls "rmse_multi"
	global cls "city_id" 

	local main_dep Expense_total visit 
	local weighted "[aweight=pop_cyg]"
	
	cap erase "$tables/AppendixTable/AppendixTableA9.xls"
	cap erase "$tables/AppendixTable/AppendixTableA9.txt"
	
	foreach w in `main_dep' {
	foreach prefix in "l_" {
		foreach suffix in   `w'_pop  {
			foreach sample in "1"  { 
				
				reghdfejl `prefix'`suffix'  CUM_elow_CB*  CUM_ehigh_CB* L*_elow_CB* L*_ehigh_CB* is_high_L* ///
					${cntrls} `weighted' if `sample' , absorb(${abs}) cluster(${cls})
				outreg2 using "$tables/AppendixTable/AppendixTableA9.xls" ,append dec(3) keep(CUM_elow_CB* CUM_ehigh_CB*)
                   }
				}
			}
		}

		
		
