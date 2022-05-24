#### Example R Code: Spatial Statistics and Spatial Econometrics, NPTEL
#### R Session 6: Model  Variograms - Part I
#### Author: Saif Ali, saifa@iiitd.ac.in
#### Date: May 2022

# load the gstat and sp libraries
library(gstat)
library(sp)
library(rgdal)
library(tmap)
library(plotly)
library(raster)

map_predicted_gwl <- function(df)
{
  r   <- raster(df, layer="var1.pred")
  r.m <- mask(r, up)
  
  tm_shape(r.m) + 
    tm_raster(n=10, palette="-RdBu", auto.palette.mapping=FALSE,
              title="Prediction map \n(in meters)") +
    tm_shape(up) + tm_polygons(alpha = 0, lwd = 2) +
    tm_text("NAME_2", size = 0.75, ymod = -0.3, xmod = 0.2,  
            remove.overlap = FALSE) +
    tm_legend(legend.outside=TRUE)
}


map_variance_gwl <- function(df)
{
  r   <- raster(df, layer="var1.var")
  r.m <- mask(r, up)
  
  tm_shape(r.m) + 
    tm_raster(n=7, palette ="Reds",
              title="Variance map \n(in squared meters)") +
    tm_shape(up) + tm_polygons(alpha = 0, lwd = 2) +
    tm_text("NAME_2", size = 0.75, ymod = -0.3, xmod = 0.2,  
            remove.overlap = FALSE) +
    tm_legend(legend.outside=TRUE)
}

# kriging
# we need a grid 
# Create an empty grid where n is the total number of cells
grd              <- as.data.frame(spsample(westup.gwl.2015, "regular", n=200000))
names(grd)       <- c("X", "Y")
coordinates(grd) <- c("X", "Y")
gridded(grd)     <- TRUE  # Create SpatialPixel object
fullgrid(grd)    <- TRUE  # Create SpatialGrid object



# kriging
proj4string(grd) <- proj4string(westup.gwl.2015)
krg <- krige(PostMonsoon~1, subset(westup.gwl.2015,
                                !is.na(westup.gwl.2015)), grd, lzn.fit.sp)


# cross validation
lzn.cv <- krige.cv(PostMonsoon~1,westup.gwl.2015,lzn.fit.sp,nmax = 10)

# regress predicted values on observed values
plot(lzn.cv@data$observed, lzn.cv@data$var1.pred)
abline(lm(lzn.cv@data$var1.pred~lzn.cv@data$observed), col = "blue")
summary(lm(lzn.cv@data$var1.pred~lzn.cv@data$observed))

# Correlation Coefficient between predicted and observed values
cor.test(lzn.cv@data$var1.pred, lzn.cv@data$observed, na.rm=TRUE, method = "pearson")