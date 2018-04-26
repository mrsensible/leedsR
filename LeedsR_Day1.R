#system.file({x_big = (1:1e7)^2})

###############
##-- Day 1 --##
###############
x <- 1:9
y <- x^2
plot(x,y)

# Shortcuts: alt + shift + k
# Command + Up Arrow
x <- 3
class(x)
typeof(x)

a <- TRUE
b <- 1:5
c <- pi
d <- "Hello Cambridge"

class(b)
class(d)


# List can have different types
l <- list(a = 2, b = "c")

##############
## -- SF -- ##
##############
library(sf)
library(spData)
library(devtools)
#install_github("Nowosad/spDataLarge")
library(spDataLarge)

#Three packages in one uniformed package sf
plot(world)
dim(world)

crs_data <- rgdal::make_EPSG()
vector_filepath <- system.file("vector/zion.gpkg", package = "spDataLarge")
new_vector <- st_read(vector_filepath)
new_vector <- st_set_crs(new_vector, 26912)

library(sp)
world_sp <- as(world, Class = "Spatial")
world_sp <- st_as_sf(world_sp, "sf")

plot(world[3:4])
plot(world["pop"])

asia <- world[world$continent == "Asia",]
asia <- st_union(asia)

plot(world["pop"], reset = F)#, key.pos = 4)
plot(asia, add = T, col = "red")
#vignette("sf5") For documents

world_centroids <- st_centroid(world)
sel_asia <- st_intersects(world_centroids, asia, sparse = F)
summary(sel_asia)

plot(world["continent"], reset = F)
cex <- sqrt(world$pop) / 10000
plot(st_geometry(world_centroids), add = T, cex = cex)

# MULTIPOINT
multipoint_matrix <- rbind(c(5,2), c(1,3), c(3,4), c(3,2))
st_multipoint(multipoint_matrix)

# LINESTRING
linestring_matrix <- rbind(c(1,5), c(4,4), c(4,1), c(2,2), c(3,2))
st_linestring(linestring_matrix)

# POLYGON
polygon_list <- list(rbind(c(1,5), c(2,2), c(4,1), c(4,4), c(1,5)))
st_polygon(polygon_list)

# POLYGON with a hole
polygon_border <- rbind(c(1,5), c(2,2), c(4,1), c(4,4), c(1,5))
polygon_hole   <- rbind(c(2,4), c(3,4), c(3,3), c(2,3), c(2,4))
polygon_with_hole_list <- list(polygon_border, polygon_hole)
st_polygon(polygon_with_hole_list)

