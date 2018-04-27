library(stplanr)
data(package = "stplanr")
class(cents_sf)
plot(cents_sf)

View(flow)
l <- od2line(flow = flow, zones = cents_sf)
class(l)
plot(l[2:3])

mapview::mapview(l)

#####################
#-- 7.3 Tutorial --##
#####################
bristol_region <- osmdata::getbb("Bristol",
                                 format_out = "sf_polygon")
names(bristol_zones)

zones_attr <- group_by(bristol_od,o) %>%
              summarise_if(is.numeric,sum) %>%
              rename(geo_code = o)

summary(zones_attr$geo_code %in% bristol_zones$geo_code)

zones_joined <- left_join(bristol_zones, zones_attr)
sum(zones_joined$all)
names(zones_joined)

zones_od <- group_by(bristol_od, d) %>%
            summarise_if(is.numeric, sum) %>%
            dplyr::select(geo_code = d, all_dest = all) %>%
            inner_join(zones_joined, ., by = "geo_code")

#####################
#-- 7.4 Tutorial --##
#####################
od_top5 <- arrange(bristol_od, desc(all)) %>%
           top_n(5, wt = all)

od_intra <- filter(bristol_od, o == d)
od_inter <- filter(bristol_od, o != d)
desire_lines <- od2line(od_inter, zones_od)
plot(desire_lines$geometry, lwd = desire_lines$all / 500)
desire_lines$distance <- as.numeric(st_length(desire_lines))
desire_carshort <- dplyr::filter(desire_lines, car_driver > 300 & distance < 5000)


###############
#-- stplanr --#
###############
library(stplanr)
library(sp)
library(dplyr)
dl_stats19() # Warning: 100MB data
ac <- read_stats19_ac()
ca <- read_stats19_ca()
ve <- read_stats19_ve()

#library(dplyr)
ca_ac <- inner_join(ca, ac)
ca_cycle <- ca_ac %>%
  filter(Casualty_Severity == "Fatal" & !is.na(Latitude)) %>%
  select(Age = Age_of_Casualty, Mode = Casualty_Type, Longitude, Latitude)
ca_sp <- SpatialPointsDataFrame(coords = ca_cycle[3:4], data = ca_cycle[1:2])

data("route_network") # devtools::install_github("ropensci/splanr")version 0.1.7
proj4string(ca_sp) <- proj4string(route_network)
bb <- bb2poly(route_network)
proj4string(bb) <- proj4string(route_network)
ca_local <- ca_sp[bb,]

bb <- bb2poly(route_network)
load("reqfiles.RData")
rnet_buff_100 <- buff_geo(route_network, width = 100)
ca_buff <- ca_local[rnet_buff_100,]

plot(bb, lty = 4)
plot(rnet_buff_100, col = "grey", add = TRUE)
points(ca_local, pch = 4)
points(ca_buff, cex = 3)

data("flow", package = "stplanr")
head(flow[c(1:3, 12)])
data("cents", package = "stplanr")
as.data.frame(cents[1:3, -c(3,4)])

l <- od2line(flow = flow, zones = cents)
route_bl <- route_cyclestreet(from = "Bradford", to = "Leeds", pat = Sys.getenv("cycle"))
route_c1_c2 <- route_cyclestreet(cents[1,], cents[2,], pat = Sys.getenv("cycle"))





