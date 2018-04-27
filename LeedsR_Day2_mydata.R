library (osmdata)
library(dodgr)
# https://github.com/ATFutures/dodgr
od.seoul <- read.csv("OD_seoul_2014_long.csv", stringsAsFactors = F)
od.seoul <- od.seoul[,-1]
od.seoul$ODfrac <- round(od.seoul$ODfrac,3)
class(od.seoul)
str(od.seoul)

od.seoul[] <- lapply(od.seoul, gsub, pattern="T", replacement="")
od.seoul[] <- lapply(od.seoul, function(x) as.character(x))
head(od.seoul)

dodgr_dists(graph = od.seoul, from = origin.code.14, to = destin.2014)


