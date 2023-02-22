###############################################################################
# 2022-updates-to-data.R 
#
# Update original data (which was through 2019) to include more recent years 
###############################################################################

library(tidyverse)

# Load data used to fit original model (through 2019) 
ModelInputs_UsedVariables_Censored <- readRDS("01_inputs/ModelInputs_UsedVariables_Censored_2019.RDS")

# Add more recent years (values taken manually from files in "Profiles" folder)
# East Andreafsky aerial 
ModelInputs_UsedVariables_Censored$a_andr_e[40:42] <- c(335, 0, 0)
ModelInputs_UsedVariables_Censored$a_andr_e_cv[40:42] <- c(0.25, 0.25, 0.25)

# West Andreafsky aerial
ModelInputs_UsedVariables_Censored$a_andr_w[40:42] <- c(508, 0, 0)
ModelInputs_UsedVariables_Censored$a_andr_w_cv[40:42] <- c(0.25, 0.25, 0.25)

# Anvik aerial
ModelInputs_UsedVariables_Censored$a_anvk[40:42] <- c(675, 0, 179)
ModelInputs_UsedVariables_Censored$a_anvk_cv[40:42] <- c(0.25, 0.25, 0.25)

# Big Salmon aerial
ModelInputs_UsedVariables_Censored$a_bsal[40:42] <- c(0, 0, 0)
ModelInputs_UsedVariables_Censored$a_bsal_cv[40:42] <- c(0.25, 0.25, 0.25)

# Chena aerial
ModelInputs_UsedVariables_Censored$a_chen[40:42] <- c(0, 0, 0)
ModelInputs_UsedVariables_Censored$a_chen_cv[40:42] <- c(0.25, 0.25, 0.25)

# Little salmon aerial
ModelInputs_UsedVariables_Censored$a_lsal[40:42] <- c(0, 0, 0)
ModelInputs_UsedVariables_Censored$a_lsal_cv[40:42] <- c(0.25, 0.25, 0.25)

# Gisasa aerial
ModelInputs_UsedVariables_Censored$a_gisa[40:42] <- c(419, 0, 0)
ModelInputs_UsedVariables_Censored$a_gisa_cv[40:42] <- c(0.25, 0.25,0.25)

# Nisutlin aerial
ModelInputs_UsedVariables_Censored$a_nstl[40:42] <- c(29, 23, 0)
ModelInputs_UsedVariables_Censored$a_nstl_cv[40:42] <- c(0.25, 0.25, 0.25)

# Nulato North Fork aerial
ModelInputs_UsedVariables_Censored$a_nult_n[40:42] <- c(459, 0, 31)
ModelInputs_UsedVariables_Censored$a_nult_n_cv[40:42] <- c(0.25, 0.25, 0.25)

# Nulato South Fork aerial
ModelInputs_UsedVariables_Censored$a_nult_s[40:42] <- c(403, 0, 29)
ModelInputs_UsedVariables_Censored$a_nult_s_cv[40:42] <- c(0.25, 0.25, 0.25)

# Ross aerial
ModelInputs_UsedVariables_Censored$a_ross[40:42] <- c(0, 0, 0)
ModelInputs_UsedVariables_Censored$a_ross_cv[40:42] <- c(0.25, 0.25, 0.25)

# Salcha aerial
ModelInputs_UsedVariables_Censored$a_salc[40:42] <- c(0, 0, 0)
ModelInputs_UsedVariables_Censored$a_salc_cv[40:42] <- c(0.25, 0.25, 0.25)

# Takhini aerial
ModelInputs_UsedVariables_Censored$a_takh[40:42] <- c(61, 0, 0)
ModelInputs_UsedVariables_Censored$a_takh_cv[40:42] <- c(0.25, 0.25, 0.25)

# Tincup aerial
ModelInputs_UsedVariables_Censored$a_tinc[40:42] <- c(0, 0, 0)
ModelInputs_UsedVariables_Censored$a_tinc_cv[40:42] <- c(0.25, 0.25, 0.25)

# Tozitna aerial
ModelInputs_UsedVariables_Censored$a_toz[40:42] <- c(0, 0, 0)
ModelInputs_UsedVariables_Censored$a_toz_cv[40:42] <- c(0.25, 0.25, 0.25)

# Wolf aerial
ModelInputs_UsedVariables_Censored$a_wolf[40:42] <- c(11, 10, 0)
ModelInputs_UsedVariables_Censored$a_wolf_cv[40:42] <- c(0.25, 0.25, 0.25)

# Whitehorse fishway
ModelInputs_UsedVariables_Censored$d_whte[40:42] <- c(216, 274, 165)
ModelInputs_UsedVariables_Censored$d_whte_cv[40:42] <- c(0.25, 0.25, 0.25)

# Border fishwheel mark recapture
ModelInputs_UsedVariables_Censored$f_mr[40:42] <- c(0, 0, 0)
ModelInputs_UsedVariables_Censored$f_mr_cv[40:42] <- c(0, 0, 0)

# Tachun foot survey
ModelInputs_UsedVariables_Censored$f_tatc[40:42] <- c(0, 0, 0)
ModelInputs_UsedVariables_Censored$f_tatc_cv[40:42] <- c(0, 0, 0)

# Big Salmon sonar
ModelInputs_UsedVariables_Censored$s_bsal[40:42] <- c(1635, 1958, 0)
ModelInputs_UsedVariables_Censored$s_bsal_cv[40:42] <- c(0.15, 0.15, 0.15)

# Eagle sonar
ModelInputs_UsedVariables_Censored$s_eagle[40:42] <- c(33550, 31796, 12025)
ModelInputs_UsedVariables_Censored$s_eagle_sd[40:42] <- c(219, 207, 119)

# Pilot sonar
ModelInputs_UsedVariables_Censored$s_pilot[40:42] <- c(162252, 124845, 48439)
ModelInputs_UsedVariables_Censored$s_pilot_sd[40:42] <- c(11503, 6584, 4486)

# Chena tower
ModelInputs_UsedVariables_Censored$t_chen[40:42] <- c(0, 1416, 355)
ModelInputs_UsedVariables_Censored$t_chen_cv[40:42] <- c(0.1, 0.06, 0.11)

# Goodpaster tower
ModelInputs_UsedVariables_Censored$t_goodp[40:42] <- c(0, 0, 0)
ModelInputs_UsedVariables_Censored$t_goodp_cv[40:42] <- c(0.1, 0.1, 0.1)

# Nulato tower
ModelInputs_UsedVariables_Censored$t_nult[40:42] <- c(0, 0, 0)
ModelInputs_UsedVariables_Censored$t_nult_cv[40:42] <- c(0.1, 0.1, 0.1)

# Mainstem radio Telemetry mark-recapture 
ModelInputs_UsedVariables_Censored$t_rtmr[40:42] <- c(0, 0, 0)
ModelInputs_UsedVariables_Censored$t_rtmr_sd[40:42] <- c(0, 0, 0)

# Salcha tower
ModelInputs_UsedVariables_Censored$t_salc[39:42] <- c(4863, 0, 2081, 1041)
ModelInputs_UsedVariables_Censored$t_salc_cv[39:42] <- c(0.11, 0, 0.05, 0.06)

# Andreasky weir
ModelInputs_UsedVariables_Censored$w_andr[40:42] <- c(0, 1454, 0)
ModelInputs_UsedVariables_Censored$w_andr_cv[40:42] <- c(0, 0.01, 0)

# Blind Creek weir
ModelInputs_UsedVariables_Censored$w_blnd[40:42] <- c(0, 0, 0)
ModelInputs_UsedVariables_Censored$w_blnd_cv[40:42] <- c(0.15, 0.15, 0.15)

# Gisasa weir
ModelInputs_UsedVariables_Censored$w_gisa[40:42] <- c(0, 0, 503)
ModelInputs_UsedVariables_Censored$w_gisa_cv[40:42] <- c(0.10, 0.10, 0.10)

# Henshaw weir
ModelInputs_UsedVariables_Censored$w_henw[40:42] <- c(0, 130, 0)
ModelInputs_UsedVariables_Censored$w_henw_cv[40:42] <- c(0.10, 0.10, 0.10)

# Tozitna weir
ModelInputs_UsedVariables_Censored$w_toz[40:42] <- c(0, 0, 0)
ModelInputs_UsedVariables_Censored$w_toz_cv[40:42] <- c(0.10, 0.10, 0.10)

# Last year of data
ModelInputs_UsedVariables_Censored$lyear <- 2022

# Number of years
ModelInputs_UsedVariables_Censored$nyear <- 42

# Years
ModelInputs_UsedVariables_Censored$years[40:42] <- c(2020, 2021, 2022)

# Radio mark-recapture
ModelInputs_UsedVariables_Censored$r_mr[40:42] <- c(0, 0, 0)
ModelInputs_UsedVariables_Censored$r_mr_sd[40:42] <- c(0, 0, 0)

# Pilot Genetic Stock proportion data
p_gsi_20_22 <-c(0.485, 0.179, 0.336, 0.537,0.242, 0.221, 0.447, 0.161, 0.392)
dim(p_gsi_20_22) <- c(3,3) 

ModelInputs_UsedVariables_Censored$pilot_p <- cbind(ModelInputs_UsedVariables_Censored$pilot_p, p_gsi_20_22)

# Pilot Sonar CV during experimental period
ModelInputs_UsedVariables_Censored$splt_exp_cv[40:42] <- c(0.2, 0.2, 0.2)

# Tanana Radiotelemetry T MR 
ModelInputs_UsedVariables_Censored$tan_rtmr[40:42] <- c(0, 0, 0)
ModelInputs_UsedVariables_Censored$tan_rtmr_sd[40:42] <- c(0, 0, 0)

# Harvest by stock and river section
h_stock_l <-c(3153, 2563, 489, 892, 132,
              751, 1086, 137, 333, 207,
              141, 130, 5, 0, 7,
              194, 186, 5, 5, 8)
dim(h_stock_l) <- c(5,4) 

ModelInputs_UsedVariables_Censored$h_stock_l <- cbind(ModelInputs_UsedVariables_Censored$h_stock_l[,-39], h_stock_l)

h_stock_m <-c(3110, 2978, 994, 5736, 3042, 841, 
              2112, 1546, 232, 1855, 1775, 565, 
              208, 153, 6, 2, 79, 1,
              80, 80, 2, 26, 118, 1)
dim(h_stock_m) <- c(6,4) 

ModelInputs_UsedVariables_Censored$h_stock_m <- cbind(ModelInputs_UsedVariables_Censored$h_stock_m[,-39], h_stock_m)

h_stock_c <-c(4913, 3710, 1823, 5117, 12242, 3000,
              2405, 1841, 318, 1561, 6057, 2363, 
              501, 358, 14, 2, 339, 306,
              296, 251, 7, 23, 547, 45)
dim(h_stock_c) <- c(6,4) 

ModelInputs_UsedVariables_Censored$h_stock_c <- cbind(ModelInputs_UsedVariables_Censored$h_stock_c[,-39], h_stock_c)

# Year-spp sample size at Pilot for stock prop
ModelInputs_UsedVariables_Censored$wrunp[40:42] <- c(200, 200, 200)

# Year-spp sample size of upper river harvest for stock prop
ModelInputs_UsedVariables_Censored$p_n_up[40:42] <- c(100, 100, 100)

# Year-spp sample size of lower river harvest for stock prop
ModelInputs_UsedVariables_Censored$p_n_low[40:42] <- c(100, 100, 100)

# Year-spp sample size of lower river harvest for stock prop
ModelInputs_UsedVariables_Censored$hp_cv[40:42] <- c(0.2, 0.2, 0.2)

# Save updated model inputs file 
saveRDS(ModelInputs_UsedVariables_Censored, "ModelInputs_UsedVariables_Censored_2022Update.RDS")

# Calculate CDN harvest age composition by river section

# Read in harvest by age, fate, district, year and stock from "origin" reports

origin_harvest <- read.csv("01_inputs/Profiles-2022/ProfilesHarvestData/YkCk_Harvest_byDistrTypeStockAge.csv", skip = 5)

cdn_harvest_by_ric_sec <- origin_harvest %>% 
  mutate(river_sec=case_when(District=="1"~"below_pilot",
                             District=="2"~"below_pilot",
                             District=="3"~"above_pilot",
                             District=="4"~"above_pilot",
                             District=="5"~"above_pilot",
                             District=="7"~"canada"
  ))%>%
  group_by(Year, river_sec, Stock) %>%
  summarize(four_yr=sum(Age1.1, Age1.2),
            five_yr=sum(Age1.3, Age2.2),
            six_yr=sum(Age1.4, Age2.3),
            seven_yr=sum(Age1.5, Age2.4, Age2.5),
            all_ages=sum(Age1.1, Age1.2,Age1.3, Age2.2,Age1.4, Age2.3,Age1.5, Age2.4, Age2.5)) %>%
  filter(Stock=="Upper") %>%
  summarize(prop_four_yr=four_yr/all_ages,
            prop_five_yr=five_yr/all_ages,
            prop_six_yr=six_yr/all_ages,
            prop_seven_yr=seven_yr/all_ages) %>%
  drop_na()

write.csv(cdn_harvest_by_ric_sec,"01_inputs/HarAgeCompsRivSec2022Update.csv",row.names=FALSE)
