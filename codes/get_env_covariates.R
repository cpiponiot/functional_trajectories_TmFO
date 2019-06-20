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
## rm: soil variables at 1m depth (what is the max depth in tropical forest, or xxth percentile?)
BkD = raster("C:/Users/camille.piponiot/Google Drive/maps/soilgrids/bulk density -- 100cm/BLDFIE_M_sl6_250m.tif")
Psand = raster("C:/Users/camille.piponiot/Google Drive/maps/soilgrids/Sand proportion/SNDPPT_M_sl6_250m.tif.tif")
CFr = raster("C:/Users/camille.piponiot/Google Drive/maps/soilgrids/Coarse fragments/CRFVOL_M_sl6_250m.tif")
Depth = raster("C:/Users/camille.piponiot/Google Drive/maps/soilgrids/soil absolute depth/BDTICM_M_250m_Amazonia.tif.tif")
CEC = raster("C:/Users/camille.piponiot/Google Drive/maps/soilgrids/CEC/CECSOL_M_sl6_250m.tif")


################################################################################
####                            Forest dynamics                             ####
################################################################################
smort = raster("C:/Users/camille.piponiot/Google Drive/maps/stem_mortality/stem_mort_krig_tmfo.tif")
smort_var = raster("C:/Users/camille.piponiot/Google Drive/maps/stem_mortality/stem_mort_var_tmfo.tif")
## woody productivity, rainfor sites
agbp = raster("C:/Users/camille.piponiot/Google Drive/maps/stem_mortality/AGB_prod_krig.tif")
agbp_var = raster("C:/Users/camille.piponiot/Google Drive/maps/stem_mortality/AGB_prod_var.tif")
## for tmfo sites only
load("C:/Users/camille.piponiot/Google Drive/biodiversity/newdata/mortality_in_control_plots.Rdata")
df_mort_site = df_mort[,.(smort = mean(smort), sd_smort = sd(smort)),.(site)]

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
## extract values of pixels around site (-> lower resolution)
mean_surround = function(coord, raster, res = 0.1){
  x = extent(c(coord[1] + c(-res/2,+res/2), coord[2] + c(-res/2,+res/2)))
  return(mean(values(crop(raster, x)), na.rm = TRUE))
}
site_coord$BkD = apply(site_coord[,c("Long","Lat")], 1, function(x) mean_surround(x, BkD))
site_coord$Psand = apply(site_coord[,c("Long","Lat")], 1, function(x) mean_surround(x, Psand))
site_coord$CFr = apply(site_coord[,c("Long","Lat")], 1, function(x) mean_surround(x, CFr))
site_coord$Depth = apply(site_coord[,c("Long","Lat")], 1, function(x) mean_surround(x, Depth))
site_coord$CEC = apply(site_coord[,c("Long","Lat")], 1, function(x) mean_surround(x, CEC))

## forest dynamics
site_coord$smort = raster::extract(smort, site_coord[,c("Long","Lat")])
site_coord$agbp = raster::extract(agbp, site_coord[,c("Long","Lat")])

save(site_coord, file = "C:/Users/camille.piponiot/gitR/functional_trajectories_TmFO/data/site_coord.Rdata")

## save maps for figures

# ## polygon of Amazon biome
amazonia = readOGR(dsn = "C:/Users/camille.piponiot/Google Drive/maps/amazonia", layer = "BassinAmazonien")
amazonia = spTransform(amazonia, crs(cwd))

## remove pixels outside Amazonia for stem mortality map (coarsest resolution)
sMort_map = mask(smort, amazonia)

## reduce resolution of CWD map and remove pixels outside amazonia
seas_map = aggregate(crop(seas, extent(-80,-44,-20,10)), fac = 1/res(seas)[1])

grd_cov = merge(as.data.frame(sMort_map, xy = T), 
                as.data.frame(seas_map, xy = T), 
                by = c("x","y"))
grd_cov = data.table(subset(grd_cov, !is.na(stem_mort_krig_tmfo) & !is.na(wc2.0_bio_2.5m_15)))
colnames(grd_cov) = c("long","lat","smort","seas")

save(grd_cov, file = "data/maps_rticle.Rdata")

library(ggplot2)
library(ggfortify)

amazonDF = fortify(amazonia)
ggplot() + geom_polygon(data = amazonDF, aes(long,lat), fill=NA, colour="black") + 
  coord_equal() + geom_point(data = site_coord, aes(Long, Lat, colour=CEC, size = 3))
