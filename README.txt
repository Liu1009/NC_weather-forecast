# 0.
Repository for "The Role of Weather Forecasts in Climate Adaptation and Reducing Medical Costs in China"

# 1. Structure
## 1.1 The `code/` directory contains all scripts used to analyze data, as well as construct tables and figures shown in the paper.
Subdirectories include:
	`clean/`, which contains scripts to clean raw data
	`analysis/`, which contains scripts that run all regression analyses
	`plot_code/`, which contains `.do` and `.R` which generate figures of this paper.

### 1.1.1 description of files in `clean/`

--clean_1Main.do: Generate data for baseline analysis.
--clean_2Robust_Dynamic.do: Generate data for robust analysis of dynamic effects.
--clean_2Robust_IsOutpatient.do: Generate data for robust analysis by healthcare visit types.
--clean_2Robust_Disease.do:  Generate data for robust analysis by disease types.
--clean_2Robust_AltRealized.do: Generate data for robust analysis using alternative models.
--clean_2Robust_Others.do: Generate data for robust results using different time windows, as well as using bootstraps.
--clean_2Robust_Others2.do: Generate data for robust results excluding extreme values.
--clean_2Robust_Others3_ER.do: Generate data for analysis using only emergency room visits.
--clean_3HeterByRealTemp.do: Generate data for heterogeneity analysis by realized temperature deciles.
--clean_3HeterByHospitals.do: Generate data for heterogeneity analysis by medical institution characteristics.
--clean_4_GenRMSErolling.do: Calculate rolling RMSE.
--clean_4_SSP_step1.do: Calculate number of days located in each deciles under difference climate model and SSPs.
--clean_4_SSP_step2.do: Generate data needed for projecting the impacts of forecasts.
--clean_4Rain.do: Generate data for analyzing the impact of precipitation forecasts.

### 1.1.2 description of files in `analysis/`


--reg_cdg_0BasicPattern.do: Show the basic pattern of forecast, as shown in Figure A1 
--reg_cdg_1Main_NonParametric.do: Generate baseline results using non-parametric estimation (Equation 1), as shown in Figure 1.
--reg_cdg_1Main_Parametric.do: Generate baseline results using parametric estimation (Equation 2), as shown in Figure 1.
--reg_cdg_2Robust1_AltSpecifications.do: Generate robust results using alternative models, as shown in Appendix Figure A2.
--reg_cdg_2Robust2_Dynamic.do: Generate dynamic results, as shown in Figure 2.
--reg_cdg_2Robust3_ExcludePrearranged.do: Generate robust results by visit types and disease types, as shown in Figure 3 Column 1&2.
--reg_cdg_2Robust4_AltMeasure.do: Generate robust results using alternative measure of realized weather, as shown in Appendix Figure A3.
--reg_cdg_2Robust5_OtherRobust1.do: Generate robust results using different time windows, excluding extreme values, as well as using bootstraps shown in Appendix Table A7.
--reg_cdg_2Robust5_OtherRobust2.do: Generate robust results using permutation tests, as shown in Appendix Figure A4.
--reg_cdg_3HeterByRealTemp.do: Generate heterogeneity analysis by realized temperature bins, as shown in Figure 4.
--reg_cdg_3HeterByHospitals.do: Generate heterogeneity analysis by medical institution characteristics, as shown in Figure 3 Column 3.
--reg_cdg_3HeterByAgeGender.do: Generate heterogeneity analysis by demographic characteristics, as shown in Figure 3 Columns 4&5.
--reg_cdg_4Rain.do: Generate analysis of the impact of precipitation forecasts, as shown in Appendix Figure A5.
--reg_cdg_4RMSE_Reduced.do: Generate analysis of the impact of perceived reliability of forecasts, as shown in Appendix Table A9.
--reg_projection.do: Project the impacts on medical expenses by climate scenarios, as shown in Figure 5.

### 1.1.3 description of files in `plot_code/`
--draw_figure1.do: Generate Figure 1.
--draw_figure3.R: Generate Figure 3.
--draw_figurea3.do: Gnerate Appendix Figure A3.
--draw_figurea5.do: Gnerate Appendix Figure A5.
--Note: Other figures are directly exported form do-files in `analysis/`.

##
1.2 The `results/` directory contains all analysis results. 
Subdirectories include `figures/`, which contains all graphical figures, 
`tables/`, which contains `.xls` which contains all tables in the paper,


# 2. Data availability
The forecast data are collected from the CCTV Weather Forecast, archived from CCTV's official website (https://www.cctv.com/). The medical expenditure data are confidential and were obtained with permission from the China Health Insurance Research Association (CHIRA). We cannot disclose the data to the public under the nondisclosure agreement. Researchers can request access through the National Healthcare Security Administration (https://www.nhsa.gov.cn/). The realized city-level temperature data are obtained from the National Meteorological Center (NMC, http://www.nmc.cn/). Data of meteorological monitoring stations are obtained from the National Oceanic and Atmospheric Administration (NOAA, https://www.ncei.noaa.gov/). The PM2.5 data are sourced from China High Air Pollutants Dataset (https://weijing-rs.github.io/product.html). The spatial population density data are obtained from WorldPop (https://www.worldpop.org/). The long-term projections of future daily temperatures are obtained from Coupled Model Intercomparison Project phase 6 (CMIP6, https://pcmdi.llnl.gov/CMIP6/). 
All regression outputs and codes are stored in this repository.