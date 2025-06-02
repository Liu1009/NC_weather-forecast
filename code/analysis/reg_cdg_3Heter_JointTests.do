
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

use treated_hosp_weathter_full_cdg0.dta, clear

	global abs "date_yrmonth date_weekday city_month groups_month ctrl_nq_* bin_r_TempHigh_L*  "	
	global cntrls ""
	global cls "city_id" 

	local main_dep Expense_total visit 
	local weighted "[aweight=pop_cyg]"

	foreach w in `main_dep' {
		

		foreach prefix in "l_" {
		*- weighted
			foreach suffix in   `w'_pop  {
				
				foreach sample in "1"  {
				
				reghdfejl `prefix'`suffix'  c.CUM_elow_CB*#i.group_age  c.CUM_ehigh_CB*#i.group_age L*_elow_CB* L*_ehigh_CB* is_high_L* ///
					${cntrls} `weighted' if `sample', absorb(${abs}) cluster(${cls}) level(90)
				
			test c.CUM_elow_CB0#1.group_age=c.CUM_elow_CB0#2.group_age=c.CUM_elow_CB0#3.group_age=c.CUM_elow_CB0#4.group_age=c.CUM_elow_CB0#5.group_age=c.CUM_elow_CB0#6.group_age
			test c.CUM_ehigh_CB0#1.group_age=c.CUM_ehigh_CB0#2.group_age=c.CUM_ehigh_CB0#3.group_age=c.CUM_ehigh_CB0#4.group_age=c.CUM_ehigh_CB0#5.group_age=c.CUM_ehigh_CB0#6.group_age
					
                   }
				}
			}
		}			
		

	
//////////////////////////////////////////////////////////

	local main_dep Expense_total visit 
	local weighted "[aweight=pop_cyg]"

	
	foreach w in `main_dep' {
		
	
		foreach prefix in "l_" {
		*- weighted
			foreach suffix in   `w'_pop  {
				
				foreach sample in "1"  {
				
				reghdfejl `prefix'`suffix'  c.CUM_elow_CB*#i.group_gender c.CUM_ehigh_CB*#i.group_gender L*_elow_CB* L*_ehigh_CB* is_high_L* ///
					${cntrls} `weighted' if `sample' , absorb(${abs}) cluster(${cls}) level(90)
					
				test c.CUM_elow_CB0#0.group_gender=c.CUM_elow_CB0#1.group_gender
				test c.CUM_ehigh_CB#0.group_gender=c.CUM_ehigh_CB#1.group_gender
                   }
				}
			}
		}			
		

	
//////////////////////////////////////////////////////////
		
use treated_hosp_weathter_full_cdg_Hospitals.dta, clear

	
	global abs "date_yrmonth date_weekday city_month groups_month ctrl_nq_* bin_r_TempHigh_L*  "	
	global cntrls ""
	global cls "city_id" 

	local main_dep Expense_total visit 
	local weighted "[aweight=pop_cyg]"

	foreach w in `main_dep' {
		
	
		foreach prefix in "l_" {
		*- weighted
			foreach suffix in   `w'_pop  {
				
				foreach sample in "1"  {
				
				reghdfejl `prefix'`suffix'  c.CUM_elow_CB*#i.type_hospital  c.CUM_ehigh_CB*#i.type_hospital L*_elow_CB* L*_ehigh_CB* is_high_L* ///
					${cntrls} `weighted' if `sample', absorb(${abs}) cluster(${cls}) level(90)
					
				test c.CUM_elow_CB0#1.type_hospital=c.CUM_elow_CB0#2.type_hospital=c.CUM_elow_CB0#3.type_hospital=c.CUM_elow_CB0#4.type_hospital=c.CUM_elow_CB0#5.type_hospital
				test c.CUM_ehigh_CB0#1.type_hospital=c.CUM_ehigh_CB0#2.type_hospital=c.CUM_ehigh_CB0#3.type_hospital=c.CUM_ehigh_CB0#4.type_hospital=c.CUM_ehigh_CB0#5.type_hospital				
                   }
				}
			}
			
		
	}
		

	
//////////////////////////////////////////////////////////	
		
use treated_hosp_weathter_full_cdg_IsOutpatient.dta, clear

	
	global abs "date_yrmonth date_weekday city_month groups_month ctrl_nq_* bin_r_TempHigh_L*  "	
	global cntrls ""
	global cls "city_id" 

	local main_dep Expense_total visit 
	local weighted "[aweight=pop_cyg]"

	foreach w in `main_dep' {
		
	
		foreach prefix in "l_" {
			foreach suffix in   `w'_pop  {
				
				foreach sample in "1"  {
				
				reghdfejl `prefix'`suffix'  c.CUM_elow_CB*#i.type_IsOutpatient  c.CUM_ehigh_CB*#i.type_IsOutpatient L*_elow_CB* L*_ehigh_CB* is_high_L* ///
					${cntrls} `weighted' if `sample' , absorb(${abs}) cluster(${cls}) level(90)
				
				test c.CUM_elow_CB0#0.type_IsOutpatient=c.CUM_elow_CB0#1.type_IsOutpatient
				test c.CUM_ehigh_CB0#0.type_IsOutpatient=c.CUM_ehigh_CB0#1.type_IsOutpatient
					
                   }
				}
			}
		}			
		

	
//////////////////////////////////////////////////////////		

use treated_hosp_weathter_full_cdg_Disease.dta, clear

	
	global abs "date_yrmonth date_weekday city_month groups_month ctrl_nq_* bin_r_TempHigh_L*  "	
	global cntrls ""
	global cls "city_id" 

	local main_dep Expense_total visit 
	local weighted "[aweight=pop_cyg]"

	foreach w in `main_dep' {
		
		foreach prefix in "l_" {
			foreach suffix in   `w'_pop  {
				
				foreach sample in "1"  {
				
				reghdfejl `prefix'`suffix'  c.CUM_elow_CB*#i.type_dises  c.CUM_ehigh_CB*#i.type_dises L*_elow_CB* L*_ehigh_CB* is_high_L* ///
					${cntrls} `weighted' if `sample' , absorb(${abs}) cluster(${cls}) level(90)
				
				test c.CUM_elow_CB0#0.type_dises=c.CUM_elow_CB0#1.type_dises=c.CUM_elow_CB0#2.type_dises
				test c.CUM_ehigh_CB0#0.type_dises=c.CUM_ehigh_CB0#1.type_dises=c.CUM_ehigh_CB0#2.type_dises
					
                   }
				}
			}
		}			
		

	
