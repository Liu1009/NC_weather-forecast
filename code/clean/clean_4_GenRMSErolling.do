
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
/*  SECTION 1:   			
    Notes: part0. Basic Pattern on Forecast
	*/
/**********************************************************************/

global per="6" 

use treated_hosp_weathter_full_cdg0, clear

		

			keep if groups==1
			//keep if 城市=="北京" 
			
			egen city_id_n=group(city_id)
			
			tab dif_TempHigh
			
			gen date_n = date(str_时间, "YMD")  
			//format date_n %td
			compress date_n 


			tsset city_id date_n

			* Calculate the 
			gen error = dif_TempHigh
			replace error=0 if mi(error)

			* Calculate the square of the error
			gen sq_error = error^2


			
			rangestat (mean) sq_error (count) sq_error, ///
					  interval(date_n -90 0) by(city_id) //casewise
			tab sq_error_count
						
			
			* Calculate RMSE and display the result
			gen rmse = sqrt(sq_error_mean)
			
	keep 城市 时间 rmse
	
	save rolling_rmse.dta, replace
			

			