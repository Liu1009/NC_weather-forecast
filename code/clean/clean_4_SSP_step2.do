
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


global per="6" //set window size

use hosp_weathter_full_cdg0s, clear

	
	*- Generate core explanatory variables
		
		    gen dif_TempHigh= p_TempHigh-r_TempHigh 

	*- Generate fixed effects
	
			*- group indicator
			egen groups =group(group_age group_gender)

			*- year of month
			gen date_yrmonth=substr(str_时间,1,6)
				destring date_yrmonth,replace
			
			gen date_weekday=dow(date_ymd)
				destring date_weekday,replace
				
			cap egen city_month=group(city_id month)
			cap egen groups_month=group(groups month)

			destring year ,replace
			destring month ,replace
			
	*- Define user-defined functions
	
		* a. Define a custom function to group variables: bin_group0
			cap program drop bin_group0
			program define bin_group0
			    args varname newvar intervals
			    cap drop `newvar'
				gen `newvar' = .
				
			    local num_intervals = wordcount("`intervals'")
			    local first_interval = word("`intervals'", 1)

			    * Handle values ​​less than the first interval
			    replace `newvar' = 0 if `varname' < `first_interval'
			    
			    * Generate intervals
					
			    local i = 1
			    foreach low in `intervals' {
			        local high = word("`intervals'", `i' + 1)
			        if "`high'" != "" {
			            replace `newvar' = `i' if `varname' >= `low' & `varname' < `high'
			        }
			        else {
			            replace `newvar' = `i' if `varname' >= `low' & `varname'<.
			        }

					
			        local ++i
			    }

			    tab `newvar' 
				
			end

			
		*- b. Compared with bin_group0, bin_group also processes lagged periods
			cap program drop bin_group 
			program define bin_group
			    args varname newvar intervals
			    cap drop `newvar'
				gen `newvar' = .
				
			    local num_intervals = wordcount("`intervals'")
			    local first_interval = word("`intervals'", 1)

			    * Handle values ​​less than the first interval
			    replace `newvar' = 0 if `varname' < `first_interval'
			    
			    * Generate intervals
			    local i = 1
			    foreach low in `intervals' {
			        local high = word("`intervals'", `i' + 1)
			        if "`high'" != "" {
			            replace `newvar' = `i' if `varname' >= `low' & `varname' < `high'
			        }
			        else {
			            replace `newvar' = `i' if `varname' >= `low' & `varname'<.
			        }

					
			        local ++i
			    }

			    tab `newvar' 
				
				
				//////////////////////////////////////////////////
				

				
				local periods $per
				sort city_id date_ymd		
							
				cap drop  L*_`varname'_B*

				*-  Generate Bins
				forval bins=0(1)`num_intervals' { 
					
					forval j=0(1)`periods' {
					
					cap gen L`j'_`varname'_B`bins'=0

					}
				}	
				
				disp "step1"
				
				*- for Bin_i=0
				
				replace L0_`varname'_B0=1 if `varname' < `first_interval'
				
				forval j=1(1)`periods' {
					
					bys city_id groups (date_ymd): replace L`j'_`varname'_B0=1 if `varname'[_n-`j'] < `first_interval'

				}
				


				*- for Bin_i>0
				
			    local i = 1
			    foreach low in `intervals' {
			        local high = word("`intervals'", `i' + 1)
					
			        if "`high'" != "" {
						
						forval j=0(1)`periods' {
							
							bys city_id groups (date_ymd): replace L`j'_`varname'_B`i'=1 if  `varname'[_n-`j'] >= `low' & `varname'[_n-`j'] < `high'
							
						}
		
						
			        }
					
			        else {
						
						forval j=0(1)`periods' {
							
						bys city_id groups (date_ymd): replace L`j'_`varname'_B`i'=1 if `varname'[_n-`j'] >= `low' & !mi(`varname'[_n-`j'])
							
						}
			        }

					//disp "step3:" `i' "/" `low' "/" `high'
					//disp `k'
			        local ++i
					
			    }
				
							
				*- Check if it is correct
				disp "Check if it is correct"
				
				forval j=0(1)`periods' {
					
					cap drop check_`varname'_L`j'
					gen check_`varname'_L`j'=0
					
					forval bins=0(1)`num_intervals' { 
					
						replace  check_`varname'_L`j'= check_`varname'_L`j'+L`j'_`varname'_B`bins'

					}
					
					tab check_`varname'_L`j'
					
				}
				
				
				*- translate to average cummulative effects
			
				forval bins=0(1)`num_intervals' { 
					
					forval j=0(1)`periods' {
					
						cap drop L`j'_`varname'_CB`bins'
						gen L`j'_`varname'_CB`bins'=. //L`j'_`varname'_B_`bins
					}
					
					replace  L0_`varname'_CB`bins'=L0_`varname'_B`bins'
					
					forval j=1(1)`periods' {
						
						replace  L`j'_`varname'_CB`bins'= L`j'_`varname'_B`bins'-L0_`varname'_B`bins'
						
					}

					replace  L0_`varname'_CB`bins'=L0_`varname'_B`bins'*`periods' 
					rename  L0_`varname'_CB`bins' CUM_`varname'_CB`bins'
					
				}
				

			end
		
	*- Generate bins of forecast errors for non-parametric estimation

			bin_group dif_TempHigh bin_dif_TempHigh " -2.5 -1.5 -.5 .5 1.5 2.5 "
			
			local periods $per
			forval j=0(1)`periods' {
				
				cap drop r_TempHigh_L`j'
				gen r_TempHigh_L`j'=. 
				bys city_id groups (date_ymd): replace  r_TempHigh_L`j'= r_TempHigh[_n-`j']
				bin_group0 r_TempHigh_L`j' bin_r_TempHigh_L`j'  "-5 0 5 10 15 20 25 30"

			}
			
					
			*Set reference group
			cap replace  CUM_dif_TempHigh_CB3=0
			local periods $per
				forval j=0(1)`periods' {
					cap replace L`j'_dif_TempHigh_CB3=0
				}
			
	*- Generate weather & pollution bins

			foreach var in r_WindAvg r_PM25 r_RainVol r_HumiAvg { //r_PresAvg 

				local periods $per
				forval j=0(1)`periods' {
					
					cap drop `var'_L`j'
					gen `var'_L`j'=. 
					bys city_id groups (date_ymd): replace  `var'_L`j'= `var'[_n-`j']
					xtile ctrl_nq_`var'_L`j'=`var'_L`j', nq(10)

				}
				
			}
			

		/* 生成城市层面十分位分界值数据集 */


		// 计算各城市温度分位数
		forvalues p = 10(10)90 {
			local q = `p'/10  // 将百分位转换为十分位编号
			bysort 城市: egen r_TempHigh_pc`q' = pctile(r_TempHigh), p(`p')
		}
		
		bysort 城市: egen r_TempHigh_pc10 = max(r_TempHigh)

		// 保留每个城市的第一条观测（已包含计算好的分位数）
		bysort 城市: keep if _n == 1

		// 选择需要保留的变量
		keep 城市 r_TempHigh_pc1-r_TempHigh_pc10

		// 保存新数据集
		save "tbmerge_temp_pctile.dta", replace

////////////////////////////////////////////////////////////////////////////////////

		
	 import excel using "by temp coefficients.xlsx", firstrow clear
		
		save coef.dta, replace
	 
	 use tbmerge_2020popnum, clear
		collapse (sum) y20_pop,by(城市)
		save weight_city_pop2020, replace
 
