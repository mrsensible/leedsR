library (osmdata)
library(dodgr)
library(rgdal)
library(tidyverse)

# https://github.com/ATFutures/dodgr
od.seoul <- read.csv("seoul/OD_seoul_2014_long.csv", stringsAsFactors = F)
od.seoul <- od.seoul[,-1]
od.seoul$ODfrac <- round(od.seoul$ODfrac,3)
class(od.seoul)
str(od.seoul)

od.seoul[] <- lapply(od.seoul, gsub, pattern="T", replacement="")
od.seoul[] <- lapply(od.seoul, function(x) as.character(x))
head(od.seoul)

s <- readOGR("seoul/seoul_centroid.shp") 
s@data <- s@data %>% select(-c(base_year,adm_dr_nm))

s@data <- merge(s@data, od.seoul, by.x = "DONG_CODE", by.y = "origin.code.14")

dodgr_dists(graph = od.seoul, from = origin.code.14, to = destin.2014)
str(od.seoul)

