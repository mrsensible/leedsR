#install.packages ("dodgr")
#library(dodgr)
devtools::install_github("ATFutures/dodgr")
library (osmdata)

bp <- getbb (place_name = "Bristol UK", format_out = "polygon")
class (bp)
length (bp)

par (mfrow = c (1, 2))
plot (bp [[1]], type = "l")
plot (bp [[2]], type = "l")

net <- osmdata::opq (bp [[1]]) %>%
  osmdata::add_osm_feature (key = "highway") %>%
  osmdata::osmdata_sf (quiet = FALSE) %>%
  osmdata::osm_poly2line () %>%
  osmdata::trim_osmdata (bp [[1]])

save (net, file = "bristol-net.rda")
format (file.size ("bristol-net.rda"), big.mark = ",") # 48.5MB
load ("bristol-net.rda")

net <- net$osm_lines
dim (net)


net2 <- dodgr_streetnet ("Bristol UK")
dim (net2)

library (dodgr)
net2 <- array (NA, dim = c (31401, 257))
dim (net2)

station <- osmdata::opq (bp [[1]]) %>%
  osmdata::add_osm_feature (key = "building") %>%
  osmdata::add_osm_feature (key = "name", value = "Temple Meads",
                            value_exact = FALSE) %>%
  osmdata::osmdata_sf ()

avonmouth <- osmdata::opq (bp [[1]]) %>%
  osmdata::add_osm_feature (key = "railway") %>%
  osmdata::add_osm_feature (key = "name", value = "Avonmouth") %>%
  osmdata::osmdata_sf ()


station <- station$osm_polygons %>%
           sf::st_coordinates ()
station  <- as.numeric (station [1, 1:2])
avonmouth <- avonmouth$osm_polygons %>%
            sf::st_coordinates ()
avonmouth <- as.numeric (avonmouth [1, 1:2])
station; avonmouth

net_walk <- weight_streetnet (net, wt_profile = "foot")
dim (net_walk)

dodgr_dists (net_walk, from = station, to = avonmouth) #Not Working

net_bike <- weight_streetnet (net, wt_profile = "bicycle")
dodgr_dists (net_bike, from = station, to = avonmouth)

p_foot <- dodgr_paths (net_walk, from = station, to = avonmouth)
class (p_foot)
length (p_foot)
head (p_foot [[1]] [[1]])

verts <- dodgr_vertices (net_walk)
head (verts)

index <- match (p_foot [[1]] [[1]], verts$id)
p_foot <- verts [index, ]

p_foot <- p_foot [, c ("x", "y")] %>%
  as.matrix () %>%
  sf::st_linestring () %>%
  sf::st_sfc ()
sf::st_crs (p_foot) <- 4326 # OSM CRS

library (mapview)
mapview (p_foot)

p_bike <- dodgr_paths (net_bike, from = station, to = avonmouth)
verts <- dodgr_vertices (net_bike)
index <- match (p_bike [[1]] [[1]], verts$id)
p_bike <- verts [index, ]
p_bike <- p_bike [, c ("x", "y")] %>%
  as.matrix () %>%
  sf::st_linestring () %>%
  sf::st_sfc ()
sf::st_crs (p_bike) <- 4326 # OSM CRS
mapview (p_foot) %>%
  addFeatures (p_bike, color = "red")




