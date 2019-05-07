library(BIOMASS)
library(data.table)

## TmFO data
load("C:/Users/camille.piponiot/Google Drive/Data TmFO cleaned/new_data/dataDBH.Rdata")
load("C:/Users/camille.piponiot/Google Drive/Data TmFO cleaned/new_data/tree_data.Rdata")
load("C:/Users/camille.piponiot/Google Drive/radam/site_info.Rdata")
load("C:/Users/camille.piponiot/Google Drive/Data TmFO cleaned/new_data/plot_data.Rdata")

data = merge(data, tree_data, by = c("site", "plot", "idtree"))
data = merge(data, site_info[, c("site", "long", "lat")], by = "site", all.x = TRUE)


## remove celos (no pre-logging census)
data$plot = as.numeric(as.character(data$plot))
## remove small plots in Paracou
data = subset(data, site != "prc" | plot < 13)
## remove celos (no pre-logging census)
data = subset(data, site != "cel")

# no is.na(minDBH) (which appear when a missing measurement has been added)
tree_minDBH <-
  data[, .(minDBH = unique(minDBH[!is.na(minDBH)])), .(idtree)]
data = merge(data[, -"minDBH"], tree_minDBH, by = "idtree")

# # change 'prg' dbh min/problem with subplots
data$subplot[data$site == "prg"] <-
  floor(as.numeric(as.character(data$subplot[data$site == "prg"])))
data$minDBH[data$site == "prg" & is.na(data$subplot)] <- 25
data$minDBH[data$site == "prg" & !is.na(data$subplot)] <- 10

# keep only trees above 10cm in plots where they were measured
data = subset(data, minDBH <= 10 & !is.na(dbh_c) & dbh_c >= 10)
  plot_data = subset(plot_data, ((site %in% c("lch", "inp")) &
                                 plot.size ==4) | !(site %in% c("lch", "inp")))
data = merge(data, unique(plot_data[, -"subplot"]), by = c("site", "plot"))
data$plot = as.character(data$plot)

data$genusCorrected <-
  unlist(lapply(data$genusCorrected, function(x) {
    if (length(x) == 0) {
      return(NA)
    } else
      return(x)
  }))
# repeated measurements for lachonta... ?
setkey(data)
data = unique(data)

## identification level per site
ident_level <-
  data[, .(
    pspecies = sum(!is.na(speciesCorrected) &
                     nameModified %in% c("TRUE", "FALSE")) / length(speciesCorrected),
    pgenus = sum(
      !is.na(genusCorrected) &
        nameModified %in% c("TRUE", "FALSE", "SpNotFound")
    ) / length(genusCorrected)
  ),
  .(site, year)]

### Get traits
source('C:/Users/camille.piponiot/Google Drive/biodiversity/codes/getTrait.R')
WD = getTrait(
  genus = data$genusCorrected,
  species = data$speciesCorrected,
  stand = data$idplot,
  trait="wd"
)
data$medianWD = WD$medianwd
data$sdWD = WD$sdwd
data$levelWD = WD$levelwd
seedMass = getTrait(
  genus = data$genusCorrected,
  stand = data$idplot,
  species = data$speciesCorrected,
  trait = "seed_m"
)
data$medianSeedMass = seedMass$medianseed_m
data$sdSeedMass = seedMass$sdseed_m
data$levelseed = seedMass$levelseed_m
SLA = getTrait(
  genus = data$genusCorrected,
  stand = data$idplot,
  species = data$speciesCorrected,
  trait = "SLA"
)
data$medianSLA = SLA$medianSLA
data$sdSLA = SLA$sdSLA
data$levelSLA = SLA$levelSLA
treeH = getTrait(
  genus = data$genusCorrected,
  stand = data$idplot,
  species = data$speciesCorrected,
  trait = "tree_h"
)
data$medianH = treeH$mediantree_h
data$sdH = treeH$sdtree_h
data$levelH = treeH$leveltree_h
dbh95 = getTrait(
  genus = data$genusCorrected,
  stand = data$idplot,
  species = data$speciesCorrected,
  trait = "dbh95"
)
data$medianD = dbh95$mediandbh95
data$sdD = dbh95$sddbh95
data$levelD = dbh95$leveldbh95
level_inden_trait <- rbind(data[,.(level="sp", H = sum(levelH=="species")/length(levelH), 
                                   SLA = sum(levelSLA=="species")/length(levelSLA),
                                   seed = sum(levelseed=="species")/length(levelseed),
                                   D = sum(levelD=="species")/length(levelD),
                                   WD = sum(levelWD=="species")/length(levelWD)),.(site)],
                           data[,.(level="gen", H = sum(levelH=="genus")/length(levelH), 
                                   SLA = sum(levelSLA=="genus")/length(levelSLA),
                                   seed = sum(levelseed=="genus")/length(levelseed),
                                   D = sum(levelD=="genus")/length(levelD),
                                   WD = sum(levelWD=="genus")/length(levelWD)),.(site)])
level_inden_trait = melt(level_inden_trait,id.vars = c("site","level"), variable.name="trait", value.name = "prop")
prop_unident = data.table(level_inden_trait)[,.(level="none",prop=1-sum(prop)),.(site,trait)]
subset(prop_unident, prop>0.3)

### calculate AGB and differenciate survivors ###
data$agb = computeAGB(
  D = data$dbh_c,
  WD = data$medianWD,
  coord = cbind(data$long, data$lat),
  Dlim = 10
)


#### calculate ACS fluxes ####
load("C:/Users/camille.piponiot/Google Drive/biodiversity/newdata/data_with_traits.Rdata")

data$acs = data$agb / 2  ## acs relative to plot size
data$ba <- (data$dbh_c / 2) ^ 2 * pi 
data = subset(data, dbh_c >= 10) # & treat != "ctrl" & treat != "0")

# remove problematic plots 
data <- subset(data, !(site=="eco" & plot=="X5") & !(site=="ita" & plot== "B4") & !(site=="tpj" & treat %in% c("silv","silv+")))
# ## pb with measurement in 2005 in Paragominas
# data = subset(data, site!="prg"|year!=2005)

# group small plots 
data$idplot <- paste(data$site, data$plot)
data$idplot[ data$plot.size<5 & !(data$site %in% c("ita","bsl")) ] <- paste(data$site[data$plot.size<5 & data$site != "ita"], data$treat[data$plot.size<5 & data$site != "ita"])
data$idplot[data$site == "ita"] <- substring(data$idplot[data$site == "ita"], 1,5)

new_plot_size = unique(data[,c("site","plot","idplot","plot.size")])[,.(idplot.size=sum(plot.size)),.(idplot)]
data = merge(data, new_plot_size, by="idplot") 

## define cohorts with tmin ##
# time of logging
tlog = data[, .(tlog = sort(unique(year))[1]), .(site, idplot)]
tlog$tlog[tlog$site == "prc"] = 1986
tlog$tlog[tlog$site == "tor"] = 2006
tlog$tlog[tlog$site == "cum"] = 2004
data = merge(data, tlog, by = c("site", "idplot"))
#
# year of minimum AGB
metadata = data[, .(acstot = sum(acs)), .(idplot, site, year, tlog)]
tmin = subset(metadata, year <= tlog + 4 &
                year > tlog)[, .(tmin = year[which.min(acstot)]), .(site, idplot)]
tmin_abs = metadata[, .(tmin_abs = year[which.min(acstot)]), .(site, idplot)]
comp_tmin = merge(tmin, tmin_abs)
data = merge(data, tmin, by = c("site", "idplot"))

## year of recruitment & last measurement ##
recru_mort = data[, .(trecr = min(year), tlast = max(year)), .(site, idplot, idtree)]

# if last year = last census of plot: tree is not necessarily dead
last_year_plot = data[, .(last_year_plot = max(year)), .(site, idplot)]
recru_mort = merge(recru_mort, last_year_plot, by = c("site", "idplot"))
recru_mort$tlast[recru_mort$tlast == recru_mort$last_year_plot] = 0
recru_mort$last_year_plot = NULL
data = merge(data, recru_mort, by = c("site", "idplot", "idtree"))

# year of recruitment determines survivors cohort
data$surv = (data$trecr <= data$tlog)
data$acs = data$acs/data$idplot.size
acs_surv = data[year==tmin,.(acs_t1 = as.numeric(surv)*acs), .(idtree)]
data = merge(data,acs_surv,by="idtree",all=TRUE)
data$acs_t1[is.na(data$acs_t1)] <- 0

## growth ##
data = data[order(idtree, year), ]
dG = data[, .(dG = c(0, diff(acs[order(year)])), year = sort(year)), .(idtree)]  # in MgC/ha
data = merge(data,dG,by=c("idtree","year"))

## functional diversity, per trait and for all traits together
library(entropart)
FD_T = function(Mtr,Nsp){
  M = unique(cbind(Nsp,scale(Mtr))[order(Nsp),])[,-1]
  DistanceMatrix = as.matrix(dist(M))
  # Similarity = 1 - Normailized dissimilarity
  Z = 1 - DistanceMatrix/max(DistanceMatrix)
  div = Dqz(as.vector(table(Nsp)), 1, Z)
  return(div)
}

#### log-transform seed mass
data$medianSeedMass = log(data$medianSeedMass)

#### Basic metadata ####
data$wei = data$acs
data$Nsp = as.numeric(as.factor(paste(data$genusCorrected,data$speciesCorrected)))

# change idplot in jenaro herrera plots
data$idplot[data$site=="bsl" & data$plot %in% c(1,8)] <- "bsl b CL"
data$idplot[data$site=="bsl" & data$plot %in% c(2:3)] <- "bsl v CL"
data$idplot[data$site=="bsl" & data$plot %in% c(5:6)] <- "bsl l CL"
data$idplot[data$site=="bsl" & data$plot==9] <- "bsl b cntrl"
data$idplot[data$site=="bsl" & data$plot==4] <- "bsl v cntrl"
data$idplot[data$site=="bsl" & data$plot==7] <- "bsl l cntrl"
data$treat[data$site=="bsl" & data$plot %in% c(4,7,9)] <- "ctrl"
data$idplot.size[data$site=="bsl"] <- 1
data$idplot.size[data$site=="bsl" & data$treat == "CL"] <- 2

# year of minimum AGB
metadata = data[, .(acstot = sum(acs)), .(idplot, site, year, tlog)]
tmin = subset(metadata, year <= tlog + 4 &
                year > tlog)[, .(tmin = year[which.min(acstot)]), .(site, idplot)]
tmin_abs = metadata[, .(tmin_abs = year[which.min(acstot)]), .(site, idplot)]
comp_tmin = merge(tmin, tmin_abs)
data = merge(data, tmin, by = c("site", "idplot"))

## year of recruitment & last measurement ##
recru_mort = data[, .(trecr = min(year), tlast = max(year)), .(site, idplot, idtree)]

# if last year = last census of plot: tree is not necessarily dead
last_year_plot = data[, .(last_year_plot = max(year)), .(site, idplot)]
recru_mort = merge(recru_mort, last_year_plot, by = c("site", "idplot"))
recru_mort$tlast[recru_mort$tlast == recru_mort$last_year_plot] = 0
recru_mort$last_year_plot = NULL
data = merge(data, recru_mort, by = c("site", "idplot", "idtree"))

# year of recruitment determines survivors cohort
data$surv = (data$trecr <= data$tlog)
data$acs = data$acs/data$idplot.size
acs_surv = data[year==tmin,.(acs_t1 = as.numeric(surv)*acs), .(idtree)]
data = merge(data,acs_surv,by="idtree",all=TRUE)
data$acs_t1[is.na(data$acs_t1)] <- 0

## growth ##
data = data[order(idtree, year), ]
dG = data[, .(dG = c(0, diff(acs[order(year)])), year = sort(year)), .(idtree)]  # in MgC/ha
data = merge(data,dG,by=c("idtree","year"))


## functional diversity, per trait and for all traits together
library(entropart)
FD_T = function(Mtr,Nsp){
  M = unique(cbind(Nsp,Mtr)[order(Nsp),])[,-1]
  DistanceMatrix = as.matrix(dist(M))
  # Similarity = 1 - Normailized dissimilarity
  Z = 1 - DistanceMatrix/max(DistanceMatrix)
  div = Dqz(as.vector(table(Nsp)), 1, Z)
  return(div)
}

#### log-transform seed mass
data$medianSeedMass = log(data$medianSeedMass)

#### Basic metadata ####
data$wei = data$acs
data$Nsp = as.numeric(as.factor(paste(data$genusCorrected,data$speciesCorrected)))

metadata = data[, .(
  acstot = sum(acs),       # total acs
  ba = sum((dbh_c/2)^2*pi/idplot.size),
  qmd = sqrt(sum(dbh_c^2)/length(dbh_c)),
  N = length(acs)/unique(idplot.size),
  acsS = sum(acs[surv]),   # acs from survivors
  acsR = sum(acs[!surv]),  # acs from recruits
  acs_t1 = sum(acs_t1),    # post-logging biomass stock (that is progressively lost)
  dSg = sum(dG[surv]),     # change in acs from surv. growth
  dSm = sum(acs[year == tlast & surv]),  # change in acs from surv. mortality
  dRr = sum(acs[!surv & trecr == year]),
  dRg = sum(dG[!surv]),
  dRm = sum(acs[year == tlast & !surv]),
  WD = weighted.mean(medianWD, wei),
  WDS = weighted.mean(medianWD[surv], wei[surv]),
  WDR = weighted.mean(medianWD[!surv], wei[!surv]),
  SLA = weighted.mean(medianSLA, wei),
  SLAS = weighted.mean(medianSLA[surv], wei[surv]),
  SLAR = weighted.mean(medianSLA[!surv], wei[!surv]),
  seed = weighted.mean(medianSeedMass, wei),
  seedS = weighted.mean(medianSeedMass[surv], wei[surv]),
  seedR = weighted.mean(medianSeedMass[!surv], wei[!surv]),
  D = weighted.mean(medianD, wei),
  DS = weighted.mean(medianD[surv], wei[surv]),
  DR = weighted.mean(medianD[!surv], wei[!surv])  #,
  # FDWD = FD_T(medianWD,Nsp), FDseed = FD_T(medianSeedMass,Nsp),     ## weight with biomass?
  # FDSLA = FD_T(medianSLA,Nsp), FDD=FD_T(medianD,Nsp), 
  # FDtot = FD_T(cbind(medianWD,medianSeedMass,medianSLA,medianD),Nsp)
), 
.(site, idplot, year, treat, tmin, idplot.size,tlog)]
metadata = metadata[order(site, idplot, year), ]
metadata = merge(metadata[,-c("dSm","dRm")], 
                 metadata[,.(year = year, 
                             dRm = c(0, dRm[-length(dRm)]),
                             dSm = c(0, dSm[-length(dSm)]),
                             dacs=c(0,diff(acstot)),
                             dacsS=c(0,diff(acsS)),
                             dacsR=c(0,diff(acsR))), 
                          .(idplot)], by=c("idplot","year"))

## initial value of small trees ##
md_0_small = subset(data, dbh_c<=20 & year <= tlog)[, .(
  WD = weighted.mean(medianWD, wei),
  SLA = weighted.mean(medianSLA, wei),
  seed = weighted.mean(medianSeedMass, wei),
  D = weighted.mean(medianD, wei)), .(site, idplot, year, treat, tmin, idplot.size,tlog, plot, plot.size)]

save(metadata, md_0_small, file = "newdata/metadata_paracou.Rdata")

data = data[,c("idtree","year","idplot","dbh","dbh_c","genus","species","logged","vern","genusCorrected","speciesCorrected",
               "treat","idplot.size", "medianWD", "sdWD", "levelWD", "medianSeedMass", "sdSeedMass","levelseed","medianSLA","sdSLA",
               "levelSLA", "medianD", "sdD", "levelD", "agb", "surv", "dG", "tlast", "trecr")]


## for the github repository
load("C:/Users/camille.piponiot/Google Drive/biodiversity/newdata/data_traits_paracou.Rdata")
data$cohort = "surv"
data$cohort[!(data$surv)] = "recr"

genusData = data[,.(SLA = weighted.mean(medianSLA, agb), 
                    logSeedMass = weighted.mean(medianSeedMass, agb),
                    woodDensity = weighted.mean(medianWD, agb),
                    DBH95 = weighted.mean(medianD, agb),
                    agb = sum(agb/idplot.size)),.(idplot, year, genus, cohort)]
save(genusData, file="C:/Users/camille.piponiot/gitR/functional_trajectories_paracou/data/genusData.Rdata")

plotInfo = unique(data[,c("idplot","idplot.size","treat")])
save(plotInfo, file="C:/Users/camille.piponiot/gitR/functional_trajectories_paracou/data/plotInfo.Rdata")


## trees logged and devitalised

paracou_raw_data = data.table(read.csv2("C:/Users/camille.piponiot/Google Drive/Data TmFO cleaned/data/paracou.csv"))

mortData = unique(subset(paracou_raw_data, code_vivant==0)[,c("n_parcelle", "n_carre", "i_arbre", "code_mesure", "campagne")])
mortData$idtree = paste("prc", mortData$n_parcelle, mortData$n_carre, mortData$i_arbre, sep = "_")
mortData$year = mortData$campagne
mortData = merge(mortData, data[,c("idtree","agb","medianSLA","medianWD","medianSeedMass","idplot","treat","idplot.size"), with=F], by="idtree")

code_corresp = data.table(code_mesure = c(1, 4, 5, 9), eventMort = c(rep("damage",2),"logged","devitalized"))
mortLogging = merge(subset(mortData, treat != "ctrl"), code_corresp, by="code_mesure")     
mortLogging$subplot = mortLogging$n_carre

mortLogging = mortLogging[,.(agb = sum(agb/idplot.size), 
                             SLA = weighted.mean(medianSLA, agb),
                             woodDensity = weighted.mean(medianWD, agb),
                             logSeedMass = weighted.mean(medianSeedMass, agb)), .(eventMort, idplot, subplot,treat)]
mortLogging = melt(mortLogging, id.vars = c("eventMort","idplot","agb", "subplot","treat"), variable.name = "trait", value.name = "WMT")

## add subplots' initial trait value
data$subplot = as.numeric(tstrsplit(data$idtree, "_")[[3]])
md_0_subplot = data[year < 1987,.(SLA = weighted.mean(medianSLA, agb), 
                                  logSeedMass = weighted.mean(medianSeedMass, agb),
                                  woodDensity = weighted.mean(medianWD, agb),
                                  DBH95 = weighted.mean(medianD, agb)),.(idplot,subplot)]
md_0_subplot = melt(md_0_subplot, id.vars = c("idplot","subplot"), 
                    variable.name = "trait", value.name = "WMT0")

mortLogging = merge(mortLogging, md_0_subplot, by = c("idplot", "subplot", "trait"))
mortLogging = merge(mortLogging, data.table(treat = c("ctrl","CL","silv","silv+"), treatment = paste("T",0:3,sep="")), by="treat")

mortLogging$treat = NULL

save(mortLogging, file = "c:/Users/camille.piponiot/gitR/functional_trajectories_paracou/data/mortLogging.Rdata")


### acs fluxes and traits 

dataMelt = melt(data, id.vars = c("agb","dG","trecr","tlast","idplot","treat","idplot.size","cohort","year"), 
                measure.vars = grep("median", colnames(data)), 
                variable.name = "trait", variable.factor = TRUE)
levels(dataMelt$trait) = c("woodDensity", "logSeedMass", "SLA", "DBH95")

dynData = dataMelt[,.(agb = sum(agb/idplot.size), 
                      WMT = weighted.mean(value, agb), 
                      WTV = sqrt(sum(agb * (value - weighted.mean(value, agb))^2)),   ## weighted trait variability
                      WMTGrowth = sum(value*dG)/sum(dG), 
                      WMTMort = sum((value*agb)[year == tlast])/sum(agb[year == tlast])), 
                   .(idplot, year, cohort, trait, treat)]

dynData = dynData[order(idplot, year, trait),]
dynData = merge(dynData[,-c("WMTMort")], 
                dynData[,.(year = year, 
                           WMTMort = c(NA,WMTMort[-length(WMTMort)])), 
                        .(idplot, cohort, trait)], by=c("idplot","year","cohort","trait"))
dynData = merge(dynData, 
                data.table(treat = c("ctrl","CL","silv","silv+"), 
                           treatment = paste("T",0:3, sep="")), by = "treat")  
dynData$treat = NULL

save(dynData, file = "c:/Users/camille.piponiot/gitR/functional_trajectories_paracou/data/dynData.Rdata")

