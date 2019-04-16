######################################################################################
######################################################################################
##############                    GETTING MAPS                      ##################
######################################################################################
######################################################################################

library(data.table)
library(raster) 
library(rgdal)
library(ncdf4)
library(gdalUtils)

e = extent( -80, -44, -20, 10)

################################################################################
####                          Climate - Worldclim                           ####
################################################################################

prec = raster("C:/Users/camille.piponiot/Google Drive/maps/wc2.0/wc2.0_bio_2.5m_12.tif")
seas = raster("C:/Users/camille.piponiot/Google Drive/maps/wc2.0/wc2.0_bio_2.5m_15.tif")
dry = raster("C:/Users/camille.piponiot/Google Drive/maps/wc2.0/wc2.0_bio_2.5m_17.tif")
cwd = raster("C:/Users/camille.piponiot/Google Drive/maps/CWD.tif")

### Solar radiation (worldClim) ###
files_rad = list.files("C:/Users/camille.piponiot/Google Drive/maps/wc2.0/solar radiation", full.names = T)
ls_rad =lapply(files_rad, raster)
ls_rad = crop(stack(ls_rad),e)
rad = calc(ls_rad, mean)

################################################################################
####                       Soils -- 100 cm - Soilgrids                      ####
################################################################################
# bulk density
BkD = raster("C:/Users/camille.piponiot/Google Drive/maps/soilgrids/bulk density -- 100cm/BLDFIE_M_sl6_250m.tif")
Psand = raster("C:/Users/camille.piponiot/Google Drive/maps/soilgrids/Sand proportion/SNDPPT_M_sl6_250m.tif.tif")
CFr = raster("C:/Users/camille.piponiot/Google Drive/maps/soilgrids/Coarse fragments/CRFVOL_M_sl6_250m.tif")
Depth = raster("C:/Users/camille.piponiot/Google Drive/maps/soilgrids/soil absolute depth/BDTICM_M_250m_Amazonia.tif.tif")
CEC = raster("C:/Users/camille.piponiot/Google Drive/maps/soilgrids/CEC/CECSOL_M_sl6_250m.tif")

################################################################################
####                            Forest dynamics                             ####
################################################################################
smort = raster("C:/Users/camille.piponiot/Google Drive/maps/stem_mortality/stem_mort_krig.tif")

################################################################################
####                             Extract values                             ####
################################################################################

site_coord = read.csv2("C:/Users/camille.piponiot/Google Drive/Data TmFO cleaned/data/sites_clim_soil.csv")

## clim
site_coord$prec = raster::extract(prec, site_coord[,c("Long","Lat")])
site_coord$seas = raster::extract(seas, site_coord[,c("Long","Lat")])
site_coord$dry = raster::extract(dry, site_coord[,c("Long","Lat")])
site_coord$rad = raster::extract(rad, site_coord[,c("Long","Lat")])
site_coord$cwd = raster::extract(cwd, site_coord[,c("Long","Lat")])

## soil 
site_coord$BkD = raster::extract(BkD, site_coord[,c("Long","Lat")])
site_coord$Psand = raster::extract(Psand, site_coord[,c("Long","Lat")])
site_coord$CFr = raster::extract(CFr, site_coord[,c("Long","Lat")])
site_coord$Depth = raster::extract(Depth, site_coord[,c("Long","Lat")])
site_coord$CEC = raster::extract(CEC, site_coord[,c("Long","Lat")])

## forest dynamics
site_coord$smort = raster::extract(smort, site_coord[,c("Long","Lat")])

save(site_coord, file = "data/site_coord.Rdata")

