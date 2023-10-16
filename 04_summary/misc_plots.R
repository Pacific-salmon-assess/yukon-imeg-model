library(tidyverse)
library(dplyr)
library(ggthemes)
library(rstan)
library(rstantools)
library(here)
library(ggpubr)


# Read in Model Data and Output Files for each of the three models (base/body count, total eggs and total egg mass versions)
stan.fit.bodies <- readRDS(here("03_outputs","base.stan.fit.2022.rds"))
stan.data.bodies <- readRDS(here("03_outputs","base.stan.data.2022.rds"))
model_bodies_pars <- rstan::extract(stan.fit.bodies)
sr_years <- stan.data.bodies$years
nyrs <- length(sr_years)

# summarize run estimates
canrun <- model_bodies_pars$can_run
canrun.quant <- t(apply(canrun, 2, quantile, probs=c(0.025,0.5,0.975)))/1000
midrun <- model_bodies_pars$mid_run
midrun.quant <- t(apply(midrun, 2, quantile, probs=c(0.025,0.5,0.975)))/1000
lowrun <- model_bodies_pars$low_run
lowrun.quant <- t(apply(lowrun, 2, quantile, probs=c(0.025,0.5,0.975)))/1000
totrun <- canrun + midrun + lowrun
totrun.quant <- t(apply(totrun, 2, quantile, probs=c(0.025,0.5,0.975)))/1000

#summarize esc estimates
canesc <- model_bodies_pars$canesc
canesc.quant <- t(apply(canesc, 2, quantile, probs=c(0.025,0.5,0.975)))/1000
midesc <- model_bodies_pars$midesc
midesc.quant <-t(apply(midesc, 2, quantile, probs=c(0.025,0.5,0.975)))/1000
lowesc <- model_bodies_pars$lowesc
lowesc.quant <- t(apply(lowesc, 2, quantile, probs=c(0.025,0.5,0.975)))/1000
totesc <- canesc + midesc + lowesc
totesc.quant <- t(apply(totesc, 2, quantile, probs=c(0.025,0.5,0.975)))/1000

#rm(canrun, midrun, lowrun, totrun, canesc, midesc, lowesc, totesc)

#median(totrun); median(canrun);median(midrun); median(lowrun)
#max(totrun.quant[,2]); min(totrun.quant[,2])
#run_cor <- cor(cbind(canrun.quant[,2],midrun.quant[,2],lowrun.quant[,2]))
#median(run_cor[row(run_cor)!=col(run_cor)])

#dataframe
counts.sum <- rbind(canrun.quant, midrun.quant, lowrun.quant, totrun.quant, canesc.quant,
                    midesc.quant, lowesc.quant, totesc.quant)
colnames(counts.sum) <- c("low95", "med50", "hi95")
counts.fig <- data.frame(year = rep(sr_years,8), 
                         stock = rep(c("Canada", "Middle", "Lower", "Total"), 
                                     each = nyrs), 
                         count = rep(c("Run", "Escapement"), 
                                     each = nyrs*4), 
                         counts.sum, stringsAsFactors = TRUE)

#summarize harvest estimates
canhar <- model_bodies_pars$can_run - model_bodies_pars$canesc
canhar.quant <- t(apply(canhar, 2, quantile, probs=c(0.025,0.5,0.975)))
midhar <- model_bodies_pars$mid_run - model_bodies_pars$midesc
midhar.quant <-t(apply(midhar, 2, quantile, probs=c(0.025,0.5,0.975)))
lowhar <- model_bodies_pars$low_run - model_bodies_pars$lowesc
lowhar.quant <- t(apply(lowhar, 2, quantile, probs=c(0.025,0.5,0.975)))
tothar <- canhar + midhar + lowhar
tothar.quant <- t(apply(tothar, 2, quantile, probs=c(0.025,0.5,0.975)))

#summarize harvest rate estimates
canharrate <- ((model_bodies_pars$can_run - model_bodies_pars$canesc)/model_bodies_pars$can_run)*100
canharrate.quant <- t(apply(canharrate, 2, quantile, probs=c(0.025,0.5,0.975)))
midharrate <- ((model_bodies_pars$mid_run - model_bodies_pars$midesc)/model_bodies_pars$mid_run)*100
midharrate.quant <-t(apply(midharrate, 2, quantile, probs=c(0.025,0.5,0.975)))
lowharrate <- ((model_bodies_pars$low_run - model_bodies_pars$lowesc)/model_bodies_pars$low_run)*100
lowharrate.quant <- t(apply(lowharrate, 2, quantile, probs=c(0.025,0.5,0.975)))
totharrate <- ((canhar + midhar + lowhar)/(canrun + midrun + lowrun))*100
totharrate.quant <- t(apply(totharrate, 2, quantile, probs=c(0.025,0.5,0.975)))

#rm(canhar, midhar, lowhar, tothar, canharrate, midharrate, lowharrate, totharrate)

#max(canharrate.quant[,2]); min(canharrate.quant[,2]); median(canharrate.quant[,2])
#max(midharrate.quant[,2]); min(midharrate.quant[,2]); median(midharrate.quant[,2])
#max(lowharrate.quant[,2]); min(lowharrate.quant[,2]); median(lowharrate.quant[,2])

#dataframe
counts.sum <- rbind(canhar.quant, midhar.quant, lowhar.quant, tothar.quant, canharrate.quant,
                    midharrate.quant, lowharrate.quant, totharrate.quant)
colnames(counts.sum) <- c("low95", "med50", "hi95")
harvest.fig <- data.frame(year = rep(sr_years,8), 
                          stock = rep(c("Canada", "Middle", "Lower", "Total"), 
                                      each = nyrs), 
                          count = rep(c("Harvest", "Harvest rate"), 
                                      each = nyrs*4), 
                          counts.sum, stringsAsFactors = TRUE)


harvest.fig$stock <- factor(harvest.fig$stock, levels = c("Canada", "Middle", "Lower", "Total"))


b <- ggplot(harvest.fig %>% filter(count=="Harvest rate", stock=="Canada")) + 
  geom_ribbon(aes(x = year, ymin = low95, ymax = hi95, col = count, fill = count), alpha=0.5) +
  geom_line(aes(x = year, y = med50, col = count), size = 1) + 
  ylab("Harvest rate (%)") +
  xlab("Year") +
  scale_color_manual(values=c('#999999'))+
  scale_fill_manual(values=c('#999999')) +
  scale_y_continuous(position = "right") +
  theme_bw() +
  theme(legend.position = "none",
        plot.margin = margin(40,20,0.5,0.5)) 

counts.fig$stock <- factor(counts.fig$stock, levels = c("Canada", "Middle", "Lower", "Total"))

a <- ggplot(counts.fig %>% filter(stock=="Canada")) + 
  geom_ribbon(aes(x = year, ymin = low95, ymax = hi95, col = count, fill = count), alpha=0.5) +
  geom_line(aes(x = year, y = med50, col = count), size = 1) + 
  ylab("Fish (000s)") +
  xlab("Year") +
  scale_color_manual(values=c('#999999','#E69F00')) +
  scale_fill_manual(values=c('#999999', '#E69F00')) +
  theme_bw() +
  theme(legend.position = "top",
        legend.title = element_blank(),
        plot.margin = margin(0.5,20,0.5,0.5)) 

g <- ggarrange(a,b, 
               ncol = 2, 
               labels = c("", ""),
               widths = c(1, 1),
               label.y = c(0.935,0.935),
               label.x = c(0,-0.08))

print(g)

ggsave("cdn-chinook-trends.jpeg", width = 8.5, height = 3.5, units = "in")


earlystats <- counts.fig %>%
  filter(year<1996) %>%
  group_by(stock) %>%
  summarise(run.early = mean(med50))

latestats <- counts.fig %>%
  filter(year>2010) %>%
  group_by(stock) %>%
  summarise(run.late = mean(med50))

stats <- cbind(earlystats, latestats[,2]) %>%
  group_by(stock) %>%
  mutate(run.per = ((run.late/run.early)*100)-100)

mean(stats$run.per, na.rm=TRUE)

# productivity plot
spwn <- exp(model_bodies_pars$lnS)
spwn.quant <- apply(spwn, 2, quantile, probs=c(0.05,0.5,0.95))[,1:(length(sr_years)-4)]

rec <-exp(model_bodies_pars$lnR)
rec.quant <- apply(rec, 2, quantile, probs=c(0.05,0.5,0.95))[,8:dim(model_bodies_pars$R)[2]]

rps <- rec[,8:dim(model_bodies_pars$R)[2]]/spwn[,1:(length(sr_years)-4)]
rps.quant <- apply(rps, 2, quantile, probs=c(0.025,0.5,0.975))

brood_t <- as.data.frame(cbind(sr_years[1:(length(sr_years)-4)],t(spwn.quant), t(rec.quant), t(rps.quant)))
colnames(brood_t) <- c("BroodYear","S_lwr","S_med","S_upr","R_lwr","R_med","R_upr","RpS_lwr","RpS_med","RpS_upr")

lnRS<- log(brood_t$R_med/brood_t$S_med)
brood_t_lnRS  <- cbind(brood_t,lnRS); colnames(brood_t_lnRS)[3] <- "S"; colnames(brood_t_lnRS)[1] <- "BY" # add log(R/S) to brood table and change spawners column name to S for Kalman filter function

source(here("02_models/Kalman_code.R"))

kalman_fit <- run.kalman.Ricker(brood_t_lnRS[1:35,]) # only estimate time varying productivity for complete brood years

ggplot(kalman_fit$df, aes(x=BY, y = exp(a.smooth) ), show.legend = F) +
  geom_line(show.legend = F, color = rgb(1,0,0, alpha=0.2), lwd = 1.5) + 
  geom_ribbon(aes(ymin = exp(a.smooth-(a.smooth.var*6)), ymax = exp(a.smooth+(a.smooth.var*6))), show.legend = F, fill = rgb(1,0,0, alpha=0.2)) +
  xlab("Brood year") +
  ylab("Intrinsic productivity") +
  theme(legend.position = "none") +
  geom_abline(intercept = 1, slope = 0 ,col="dark grey", lty=2) +
  theme_bw()+
  coord_cartesian(ylim=c(0,10)) 
ggsave("cdn-chinook-productivity.jpeg", width = 6, height = 3.75, units = "in")



