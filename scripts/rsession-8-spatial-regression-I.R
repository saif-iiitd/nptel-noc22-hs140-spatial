#### Example R Code: Spatial Statistics and Spatial Econometrics, NPTEL
#### R Session 8: Model  Variograms - Part I
#### Author: Saif Ali, saifa@iiitd.ac.in
#### Date: May 2022

# load the gstat and sp libraries
library(gstat)
library(sp)
library(rgdal)
library(tmap)
library(plotly)
library(raster)
library(spdep) # NEW!
library(spatialreg) # NEW!
library(rgeos) # NEW!

### 1. PREPARE SPATIAL DATA 

# Load tabular data
spreg <- read.csv(".//data//spatial-regression.csv")

# Let us examine it
head(spreg)

# Convert it to spatial data
coordinates(spreg) <- ~LONGITUDE+LATITUDE

# Load sub-district (level 3) spatial boundaries (Uttar Pradesh)
upstate <- readOGR(".//data//IND_adm3.shp")

# Subset only to up
upstate <- upstate[upstate$NAME_1 == "Uttar Pradesh",]

# Set projection
proj4string(spreg) <- proj4string(upstate)

# Spatially aggregate data to these boundaries
upL3.sp <- aggregate(spreg,upstate,FUN=mean, na.rm = TRUE)

# Convert crop proportion to percentage
upL3.sp$PCTCROPAREA_LY <- upL3.sp$PCTCROPAREA_LY * 100

# Quick plot to see how the aggregation went
tm_shape(upL3.sp) + tm_polygons(col="POSTMONSOON")
tm_shape(upL3.sp) + tm_polygons(col="RFL_TY")
tm_shape(upL3.sp) + tm_polygons(col="TEMP_TY")
tm_shape(upL3.sp) + tm_polygons(col="PCTCROPAREA_LY")

# Remove the unit with missing data
upL3.sp.1 <- upL3.sp[!is.na(upL3.sp$POSTMONSOON),]


### 2. BUILD WEIGHTS MATRIX (SPATIAL NEIGHBORHOODS)

# Polygon to neighborhoods - from the spdep package
W.nb <- poly2nb(upL3.sp.1)

# Extract centroid coordinates from the polygon boundaries
centroid.coords <- coordinates(upL3.sp.1)

# Visualize queen neighborhoods
plot(upL3.sp.1)
plot(W.nb, centroid.coords, col="red", add = TRUE)

# Convert format to a list type
W.listw <- nb2listw(W.nb)


