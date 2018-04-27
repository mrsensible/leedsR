# Chapter 9

library(cartography)
data(package = "cartography")
plot(countries.spdf)
plot(world.spdf)

library(tmap)
library(spDataLarge)
m <- tm_shape(bristol_region) +
  tm_borders() +
  tm_shape(bristol_zones) +
  tm_polygons()

tmap_mode("view")
m

tmap_mode("plot")
m

