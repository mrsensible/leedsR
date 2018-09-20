library(sf)
library(stplanr)
library(tidyverse)

# OD Seoul
od.seoul <- read.csv("seoul/OD_seoul_2014_long.csv", stringsAsFactors = F)
od.seoul <- od.seoul[,-1]
od.seoul$ODfrac <- round(od.seoul$ODfrac,3)
od.seoul[] <- lapply(od.seoul, gsub, pattern="T", replacement="",
                     function(x) as.numeric(as.character(x))
                     )




# OD Gangnam
od.gn <- od.seoul %>% filter(origin.code.14 == 1101053)#< 2000000 & destin.2014 < 2000000 )


gn <- read_sf("seoul/gn_centroid.shp")
print(gn, n = 3)
plot(st_geometry(gn))

flow_single_line <- od.seoul[1,]
desire_line_single = od2line(flow = flow_single_line, zones = gn)
