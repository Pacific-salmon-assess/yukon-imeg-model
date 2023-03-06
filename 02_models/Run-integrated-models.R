###############################################################################
# Run-integrated-models.R 
#
# Fit model to data using Stan 
###############################################################################

library(rstan)
library(rstantools)
library(here)
library(beepr)

# Set Stan default controls ----
options(mc.cores = parallel::detectCores()) #Selects number of cores to use for running parallel chains in Stan
rstan_options(auto_write = TRUE) # Avoid recompiling UNCHANGED .stan script

# Set Stan sampling guidelines ----
n.iter <- 1e3
n.thin <- 2
n.chains <- 4

# Number of Stan samples?
(n.iter/n.thin)*0.5*n.chains

# Read in data and specify control files ----
dat <- readRDS(here("01_inputs/ModelInputs_UsedVariables_Censored_2022Update.RDS"))

# RR inputs 

# usesclike: control file for likelihood 
# 1: Chena tower, 2:Salcha tower, 3: Henshaw Weir, 4: Chena Aerial, 5: Salcha Aerial
# 6: Nulato tower, 7: Gisasa Weir, 8: Nulato N Aerial, 9: Nulato S Aerial
# 10: Giasa Aerial, 11: Anvik Aerial
# 12: Andreafsky Weir, 13: Andreafsky Aerail E, 14: Andreafsky Aerial W
# 15: Tozitna Weir, 16: Tozitna Aerial
usesclike <- c(1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1) 

# canesclike: control file for likelihood 
# 1: Tincup Aerial, 2:Tatian Aerial, 3:Little Salmon Aerial, 4: Nisutlin Aerial, 5: Ross Aerial
# 6: Wolf Aerial, 7: Blind Creek Weir, 8: Whitehose fishway, 9: Big Salmon Sonar, 10: Big Salmon Aerial,
# 11: Takhini Aerial
canesclike <- c(1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1)  

# canpaslike: control file for likelihood 
# 1: Eagle Sonar, 2:Radio Tel MR, 3: FW MR
canpaslike <- c(1, 1, 1) 

# uspaslike:control file for likelihood 
# 1: GMR Canada, 2: GMR Middle, 3: GMR Low, 4: GMR Total, 5: Pilot GSI 
# 6: Radio Tel MR, 7: Pilot 1983-1994, 8: Pilot 1995-2004, 9: Pilot 2005-2014
uspaslike <- c(0, 0, 0, 0, 1, 1, 1, 1, 1)

n_ch <- 1
n_sa <- 1
n_hw <- 1

nyp <- c(1995, 2002)  # splits for pilot disp parameter (sonar and mr)
nye <- c(1999, 2008) # splits for eagle fwmr disp parameter (2002 changed to 1999; V. Mather update)
ytan <- 2005

# years and number of years
years <- dat$fyear:dat$lyear
n_year <- length(years)

# SRA Inputs 

dat.h.age <- read.csv(here("01_inputs/HarAgeCompsRivSec2022Update.csv")) # Harvest age composition, by river section
H_comps_bp <- dat.h.age[dat.h.age$river_sec=="below_pilot",3:6] # Harvest age composition below pilot
H_comps_ap <- dat.h.age[dat.h.age$river_sec=="above_pilot",3:6] # Harvest age composition above pilot
H_comps_cdn <- dat.h.age[dat.h.age$river_sec=="canada",3:6] # Harvest age composition in Canada (based on Eagle TF)

S_comps <- H_comps_cdn# Border passage age composition

ess_age_comp <- c(rep(50,26),rep(100,16)) # Age comp ESS b/f 2007 and thereafter

a_min <- 4 # Minimum age at maturity
a_max <- 7 # Maximum age at maturity
A <- a_max - a_min + 1 # Age classes

nyrs <- n_year # Number of run years 
nRyrs <- nyrs + A - 1 # Number of brood years


# Specify Initial Values for Model Parameters ----

# Initialization Function
init_fn <- function(chain_id=1) {
  list( 
    # Run sizes
    "log_can_run" = runif(n_year, 10, 11), 
    "log_mid_run" = runif(n_year, 10, 11), 
    "log_low_run" = runif(n_year, 10, 11), 
    
    # Canada Escapement Slope parameters
    "log_atinc" = runif(1, 3, 6), 
    "log_ftatc" = runif(1, 3, 6), # log transformed slope for Tatchun Creek foot survey
    "log_alsal" = runif(1, 3, 6), # log transformed slope for Little Salmon Aerial
    "log_anstl" = runif(1, 3, 6), # log transformed slope for Nisutlin Aerial
    "log_aross" = runif(1, 3, 6), # log transformed slope for Ross Aerial
    "log_awolf" = runif(1, 3, 6), # log transformed slope for Wolf Aerial
    "log_wblnd" = runif(1, 3, 6), # log transformed slope for Blind Creek Weir    
    "log_dwhte" = runif(1, 3, 6), # log transformed slope for Whitehorse Fishway passage
    "log_sbsal" = runif(1, 3, 6), # log transformed slope for Big Salmon Sonar
    "log_absal" = runif(1, 3, 6), # log transformed slope for Big Salmon Aerial
    "log_atakh" = runif(1, 3, 6), # log transformed slope for Tahkini Aerial
    "log_qfwmr" = runif(1, -3, -1), # survey q Border Mark Recapture
    
    # Canada Escapement Dispersion parameters    
    "log_rcanair" = runif(1, -1, 1), # log transformed slope for Tincap Aerial
    "log_rcang" = runif(1, -1, 1),   # log transformed slope for Blind Creek Weir    
    
    # US Escapement Parameters Slope 
    "log_achen" = runif(1, 1, 3),    # log transformed slope for Chena Aerial
    "log_asalc" = runif(1, 1, 3),    # log transformed slope for Salcha Aerial
    "log_wgisa" = runif(1, 1, 3),    # log transformed slope for Gisasa Weir
    'log_aanvk' = runif(1, 1, 3),    # log transformed slope for Anvik Aerial
    "log_tnult" = runif(1, 1, 3),    # log transformed slope for Nulato Tower
    "log_anult" = runif(1, 1, 3),    # log transformed slope for Nulato Aerial
    "log_agisa" = runif(1, 1, 3),    # log transformed slope for Gisasa Aerial
    "log_wandr" = runif(1, 1, 3),    # log transformed slope for Andreafsky Weir
    "log_aandr" = runif(1, 1, 3),    # log transformed slope for Andreafsky Aerial
    "log_wtoz" = runif(1, 1, 3),     # log transformed slope for Tozitna Weir
    "log_atoz" = runif(1, 1, 3),     # log transformed slope for Tozitna Aerial
    'log_nultp' = runif(1, -1, 0),   # proportion of Nulato North
    "log_andrep" = runif(1, -1, 0),  # proportion of Andreafsky West
    "log_qplt" = runif(3, -1, 0),    # Survey q Pilot Sonar
    
    #US Escapement Parameters dispersion 
    "log_rtower" = runif(1, -2, 0),  # log transformed dispersion for Chena tower
    "log_raerial" = runif(1, -2, 0), # log transformed dispersion for Chena Aerial
    "log_rspilt" = runif(4, -2, 0),  # log transformed dispersion for Pilot Sonar 
    
    # Fishing mortality by stock   
    "log_fcu" = runif(n_year, 0, 1), # Fishing mortality upriver: Canada stock
    "log_fmu" = runif(n_year, 0, 1), # Fishing mortality upriver: Middle stock
    "log_flu" = runif(n_year, 0, 1), # Fishing mortality upriver: Lower stock
    "log_fcl" = runif(n_year, 0, 1), # Fishing mortality lower river: Canada stock
    "log_fml" = runif(n_year, 0, 1), # Fishing mortality lower river: Middle stock
    "log_fll" = runif(n_year, 0, 1), # Fishing mortality lower river: Lower stock
    "log_fcc" = runif(n_year, 0, 1), # Fishing mortality lower river: Lower stock
    "lnalpha" = abs(rnorm(1, mean=0, sd=1)), # Intrinsic productivity
    "beta" = abs(rnorm(1, mean=0, sd=0.001)) # Magnitude of density dependence
  )
}

# Initial List of Lists for Multiple Chains
init_ll <- lapply(1:n.chains, function(id) init_fn(chain_id = id))

# Run base Stan model ----

# Track time
timings <- vector(length=2)
timings[1] <- date()
  
# Model data
stan.data <- list("fyear"=dat$fyear, 
                  "lyear"=dat$lyear, 
                  "n_year"=n_year, 
                  "years"=years,
                  "nwkc"=dat$nwkc, 
                  "nwku"=dat$nwku,

                  # Canada Stock Data 
                  "s_eagle"=dat$s_eagle, 
                  "s_eagle_sd"=dat$s_eagle_sd, 
                  "r_mr"=dat$r_mr, 
                  "r_mr_sd"=dat$r_mr_sd,
                  "a_tinc"=dat$a_tinc, 
                  "a_tinc_cv" = dat$a_tinc_cv,
                  "f_tatc"=dat$f_tatc, 
                  "f_tatc_cv" = dat$f_tatc_cv,
                  "a_lsal"=dat$a_lsal, 
                  "a_lsal_cv" = dat$a_lsal_cv,
                  "a_nstl"=dat$a_nstl, 
                  "a_nstl_cv" = dat$a_nstl_cv,
                  "a_ross"=dat$a_ross, 
                  "a_ross_cv" = dat$a_ross_cv,
                  "a_wolf"=dat$a_wolf, 
                  "a_wolf_cv" = dat$a_wolf_cv,
                  "w_blnd"=dat$w_blnd, 
                  "w_blnd_cv" = dat$w_blnd_cv,
                  "d_whte"=dat$d_whte, 
                  "d_whte_cv" = dat$d_whte_cv, 
                  "s_bsal"=dat$s_bsal, 
                  "s_bsal_cv" = dat$s_bsal_cv,
                  "a_bsal"=dat$a_bsal, 
                  "a_bsal_cv" = dat$a_bsal_cv,
                  "a_takh"=dat$a_takh, 
                  "a_takh_cv" = dat$a_takh_cv,
                  "f_mr"=dat$f_mr, 
                  "f_mr_cv" = dat$f_mr_cv,

                  # US Stock Data
                  "pilot_p"=dat$pilot_p, 
                  "t_rtmr"=dat$t_rtmr, 
                  "t_rtmr_sd"=dat$t_rtmr_sd, # Lower river Radio Mark-Recap
                  "tan_rtmr"=dat$tan_rtmr, 
                  "tan_rtmr_sd"=dat$tan_rtmr_sd,
                  "s_pilot"=dat$s_pilot, 
                  "s_pilot_sd"=dat$s_pilot_sd, #Pilot Station sonar
                  "splt_exp_cv" = dat$splt_exp_cv, # CV during experimental period
                  "wrunp" = dat$wrunp, # year-spp sample size at Pilot for stock prop
                  "t_chen"=dat$t_chen, 
                  "t_chen_cv" = dat$t_chen_cv, 
                  
                  # Middle Stock Escapement Data
                  "t_salc"=dat$t_salc, 
                  "t_salc_cv" = dat$t_salc_cv,
                  "w_henw"=dat$w_henw, 
                  "w_henw_cv" = dat$w_henw_cv,
                  "a_chen"=dat$a_chen, 
                  "a_chen_cv" = dat$a_chen_cv,                    
                  "a_salc"=dat$a_salc, 
                  "a_salc_cv" = dat$a_salc_cv,
                   "a_anvk"=dat$a_anvk, 
                  "a_anvk_cv" = dat$a_anvk_cv, 
                  
                  # Lower Stock Data
                  "t_nult"=dat$t_nult, 
                  "t_nult_cv" = dat$t_nult_cv,
                  "a_nult_n"=dat$a_nult_n, 
                  "a_nult_n_cv" = dat$a_nult_n_cv,
                  "a_nult_s"=dat$a_nult_s, 
                  "a_nult_s_cv" = dat$a_nult_s_cv,
                  "w_gisa"=dat$w_gisa, 
                  "w_gisa_cv" = dat$w_gisa_cv,
                  "a_gisa"=dat$a_gisa, 
                  "a_gisa_cv" = dat$a_gisa_cv,
                  "w_andr"=dat$w_andr, 
                  "w_andr_cv" = dat$w_andr_cv,
                  "a_andr_w"=dat$a_andr_w, 
                  "a_andr_w_cv" = dat$a_andr_w_cv,
                  "a_andr_e"=dat$a_andr_e, 
                  "a_andr_e_cv" = dat$a_andr_e_cv,
                  "w_toz"=dat$w_toz, 
                  "w_toz_cv" = dat$w_toz_cv,
                  "a_toz"=dat$a_toz, 
                  "a_toz_cv" = dat$a_toz_cv,
                    
                  # Harvest by Stock
                  "h_stock_l"=dat$h_stock_l,
                  "h_stock_m"=dat$h_stock_m,
                  "h_stock_c"=dat$h_stock_c,
                    
                  # Sample Size Data
                  "p_n_up" = dat$p_n_up, # year-spp sample size of upper river harvest for stock prop
                  "p_n_low" = dat$p_n_low, # year-spp sample size of lower river harvest for stock prop
                  "hp_cv" = dat$hp_cv,
                 
                  # Control parameters
                  "nyp"=which(years %in% nyp),  #Needs to be an integer reference
                  "nye"=which(years %in% nye),
                  "ytan"=which(years %in% ytan), 
                  "usesclike"=usesclike, 
                  "canesclike"=canesclike,
                  "canpaslike"=canpaslike, 
                  "uspaslike"=uspaslike,
                  "n_ch"=n_ch, "n_sa"=n_sa, "n_hw"=n_hw,
                    
                  # SRA Data
                  "nyrs"=nyrs, 
                  "nRyrs"=nRyrs,
                  "A"=A, "a_min"=a_min, 
                  "a_max"=a_max,
                  "H_comps_bp"=H_comps_bp, 
                  "H_comps_ap"=H_comps_ap,
                  "H_comps_cdn"=H_comps_cdn, 
                  "S_comps"=S_comps,
                  "ess_age_comp"=ess_age_comp)
                    
# Fit model
stan.fit <- stan(file = here("02_models/Integrated-RR-SRA-v9.7.stan"),
                  model_name= "Integrated-RR-SRA-v9.7",
                  data = stan.data,
                  chains = n.chains, 
                  iter = n.iter, 
                  thin = n.thin,
                  cores = n.chains, 
                  verbose = FALSE,
                  seed = 101,
                  control = list(adapt_delta = 0.99, max_treedepth = 13),
                  init = init_ll)

beep(4)

# Run time
timings[2] <- date()
print(paste("START:", timings[1]))
print(paste("END:", timings[2]))

# Save fitted model object and data
saveRDS(stan.fit, here("03_outputs/base.stan.fit.2022.rds"))
saveRDS(stan.data, here("03_outputs/base.stan.data.2022.rds"))

