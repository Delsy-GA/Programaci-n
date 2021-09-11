library(sf)
library(tmap)
library(rcartocolor)
library(raster)
library(dplyr)
library(RColorBrewer)
library(tidyverse)
library(rgdal)
library(maptools)

install.packages("maptools")
getwd()
setwd("D:/TRABAJO FINAL DE BIO")

prov <-st_read('D:/TRABAJO FINAL DE BIO/DEPARTAMENTOS', quiet = TRUE)
CUSCO <- prov[prov$PROVINCIA == "CUSCO",]
st_write(CUSCO,"CUSCO CORTADO.shp",delete_layer = TRUE)
view(CUSCO)
CUSCO1 <- prov[prov$DEPARTAMEN == "CUSCO",]
view(CUSCO1)

tmax1 <- raster("TEMPERATURA MAXIMA/wc2.1_2.5m_tmax_2014-01.tif")
tmax2 <- raster("TEMPERATURA MAXIMA/wc2.1_2.5m_tmax_2014-02.tif")
tmax3 <- raster("TEMPERATURA MAXIMA/wc2.1_2.5m_tmax_2014-03.tif")
tmax4 <- raster("TEMPERATURA MAXIMA/wc2.1_2.5m_tmax_2014-04.tif")
tmax5 <- raster("TEMPERATURA MAXIMA/wc2.1_2.5m_tmax_2014-05.tif")
tmax6 <- raster("TEMPERATURA MAXIMA/wc2.1_2.5m_tmax_2014-06.tif")
tmax7 <- raster("TEMPERATURA MAXIMA/wc2.1_2.5m_tmax_2014-07.tif")
tmax8 <- raster("TEMPERATURA MAXIMA/wc2.1_2.5m_tmax_2014-08.tif")
tmax9 <- raster("TEMPERATURA MAXIMA/wc2.1_2.5m_tmax_2014-09.tif")
tmax10 <- raster("TEMPERATURA MAXIMA/wc2.1_2.5m_tmax_2014-10.tif")
tmax11 <- raster("TEMPERATURA MAXIMA/wc2.1_2.5m_tmax_2014-11.tif")
tmax12 <- raster("TEMPERATURA MAXIMA/wc2.1_2.5m_tmax_2014-12.tif")
tmax2014 <- (tmax1+tmax2+tmax3+tmax4+tmax5+tmax6+tmax7+tmax8+tmax9+tmax10+tmax11+tmax12)/12
tmaxnew2014 <- tmax2014 %>% crop(CUSCO1, snap = 'out')


tmin1 <- raster("TEMPERATURA MINIMA/wc2.1_2.5m_tmin_2014-01.tif")
tmin2 <- raster("TEMPERATURA MINIMA/wc2.1_2.5m_tmin_2014-02.tif")
tmin3 <- raster("TEMPERATURA MINIMA/wc2.1_2.5m_tmin_2014-03.tif")
tmin4 <- raster("TEMPERATURA MINIMA/wc2.1_2.5m_tmin_2014-04.tif")
tmin5 <- raster("TEMPERATURA MINIMA/wc2.1_2.5m_tmin_2014-05.tif")
tmin6 <- raster("TEMPERATURA MINIMA/wc2.1_2.5m_tmin_2014-06.tif")
tmin7 <- raster("TEMPERATURA MINIMA/wc2.1_2.5m_tmin_2014-07.tif")
tmin8 <- raster("TEMPERATURA MINIMA/wc2.1_2.5m_tmin_201-08.tif")
tmin9 <- raster("TEMPERATURA MINIMA/wc2.1_2.5m_tmin_2014-09.tif")
tmin10 <- raster("TEMPERATURA MINIMA/wc2.1_2.5m_tmin_2014-10.tif")
tmin11 <- raster("TEMPERATURA MINIMA/wc2.1_2.5m_tmin_2014-11.tif")
tmin12 <- raster("TEMPERATURA MINIMA/wc2.1_2.5m_tmin_2014-12.tif")
tmin2014 <- (tmin1+tmin2+tmin3+tmin4+tmin5+tmin6+tmin7+tmin8+tmin9+tmin10+tmin11+tmin12)/12
tminnew2014 <- tmin2018 %>% crop(CUSCO1, snap = 'out')

amplitudterm <- tmax2014-tmin2014 
icdayet<- ((1.7*amplitudterm)/(sin(13+10+9*3.39))) + 14

writeRaster(ICDAYET2014, filename = "ICDAYET 2014", format="GTiff",overwrite=TRUE)
plot(icdayet)