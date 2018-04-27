library(stplanr)
data(package = "stplanr")
class(cents_sf)
plot(cents_sf)

View(flow)
l <- od2line(flow = flow, zones = cents_sf)
class(l)
plot(l)

mapview::mapview(l)

######################
#-- 7.3 Tutorial --##
######################
bristol_region <- osmdata::getbb("Bristol",
                                 format_out = "sf_polygon")
names(bristol_zones)
