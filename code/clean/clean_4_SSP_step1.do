
global root= "E:\Project\气温差异和医疗\原始医保数据"
global dofiles= "$root/Dofiles"
global logfiles= "$root/Logfiles"
global raw_data= "$root/Raw_data"
global working_data= "$root/Working_data"
global temp_data= "$root/Temp_data"
global tables= "$root/Tables2"
global figures= "$root/Figures"
cd "$working_data"
*set scheme s1color

*- 

use "Aggregatedata.dta" ,clear

	append using Aggregatedata_BCC.dta
	drop time
	
	* trans from K to °C
	gen tasmax_C=tasmax-273.15
	gen tasmin_C=tasmin-273.15
	

		* 定义一个自定义函数来分组变量
			cap program drop bin_group0
			program define bin_group0
			    args varname newvar intervals
			    cap drop `newvar'
				gen `newvar' = .
				
			    local num_intervals = wordcount("`intervals'")
			    local first_interval = word("`intervals'", 1)

			    * 处理小于第一个区间的值
			    replace `newvar' = 0 if `varname' < `first_interval'
			    
			    * 生成区间分组
					
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
		

		merge m:1 city using city-城市名list.dta,nogen

		tostring year, gen(year_s)
		tostring month, gen(month_s)
		tostring day, gen(day_s)

		replace month_s="0"+month_s if month<10
		replace day_s="0"+day_s if day<10

		gen 时间=year_s+month_s+day_s
		destring 时间, replace


		merge m:1 城市 时间 using tbmerge_city_temp_2015.dta, gen(m1)

			keep if m1==3 
			sum tasmax_C tasmin_C rp_TempHigh rp_TempLow

			gen dif_max=tasmax_C-rp_TempHigh 
			gen dif_min=tasmin_C-rp_TempLow 
			bys city from source: egen mdif_max=mean(dif_max) if m1==3
			bys city from source: egen mdif_min=mean(dif_min) if m1==3

			sum mdif_max mdif_min

			keep 城市 from source mdif_max mdif_min dif_max dif_min
			duplicates drop 城市 from source,force
			save tbmerge_temp_adj.dta ,replace

			
///////////////////////////////////////////////////////////////////////////////////////
		

use "Aggregatedata.dta" ,clear

	append using Aggregatedata_BCC.dta
	drop time

	* trans from K to °C
	gen tasmax_C=tasmax-273.15
	gen tasmin_C=tasmin-273.15

	sum tasmax_C tasmin_C

	merge m:1 city using city-城市名list.dta,nogen

		tostring year, gen(year_s)
		tostring month, gen(month_s)
		tostring day, gen(day_s)

		replace month_s="0"+month_s if month<10
		replace day_s="0"+day_s if day<10

		gen 时间=year_s+month_s+day_s
		destring 时间, replace


	merge m:1 城市 from source using tbmerge_temp_adj.dta,nogen

	replace tasmax_C=tasmax_C-mdif_max
	replace tasmin_C=tasmin_C-mdif_min

	merge m:1 城市 using tbmerge_temp_pctile.dta,nogen
	
	
	gen bin_tasmax_C=0
	
		replace bin_tasmax_C=1 if tasmax_C<=r_TempHigh_pc1
		
		forvalues j = 2 (1) 10 {
		local jm=`j'-1
		replace bin_tasmax_C=`j' if tasmax_C>r_TempHigh_pc`jm' & tasmax_C<=r_TempHigh_pc`j'
		}
		


	*- gen BinDays 

		forvalues j = 1 (1) 10 {

			gen counter_maxb`j'=(bin_tasmax_C==`j')
			bys city year from source: egen Days_maxBin`j'=sum(counter_maxb`j')
	

		}  // end of forvalues j = 1 (1) n

		duplicates drop city year from source, force
		
		tab from

		keep year 城市 from source Days_maxBin* //Days_minBin*
		save DaysOfBins_SSPs_Cities.dta, replace


		
			

		