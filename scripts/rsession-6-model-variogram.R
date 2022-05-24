#### Example R Code: Spatial Statistics and Spatial Econometrics, NPTEL
#### R Session 6: Model  Variograms - Part I
#### Author: Saif Ali, saifa@iiitd.ac.in
#### Date: May 2022

# load the gstat and sp libraries
library(gstat)
library(sp)

# load Groundwater Level Data for Western Uttar Pradesh from a CSV file
# Source: CGWB, See India WRIS portal
up.gwl <- read.csv(".//data//up_state_gwl_v6.csv")


# select data only for the year 2015
up.gwl.2015 <- subset(up.gwl,Year==2015)

# select data only Western UP
westup.gwl.2015 <- subset(up.gwl.2015,District %in% c("MUZAFFARNAGAR", "GHAZIABAD", 
                                                      "BAGHPAT","MEERUT", 
                                                      "HAPUR"))

# remove observations with missing values
westup.gwl.2015 <- na.omit(westup.gwl.2015)

# convert to spatial points dataframe
coordinates(westup.gwl.2015) <- (~Lon+Lat)

# read shapefile
library(rgdal)
up <- readOGR(".//data//IND_adm2.shp")
up <- up[up$NAME_2 %in% 
  c("Meerut", "Ghaziabad", "Baghpat", "Hapur"),
         ]

# Plot spatial data 
# make a spatial plot of post-monsoon groundwater levels
# Note: You can't do this with ordinary data frames! 
library(tmap)
westup.map <- tm_shape(up) +
  tm_fill(col = "#F3E2B1", alpha = 0.75) + 
  tm_borders(col = "white", lwd = 2.0) + 
  tm_text("NAME_2", size = 1, ymod = -0.3, xmod = 0.2,
          remove.overlap = FALSE) +
  tm_shape(westup.gwl.2015) +
  tm_dots(col = "blue", size = "PostMonsoon", scale = 1.2,
          shape = 21, 
          popup.vars=c("Well Code"="WlCode"), 
          palette = "-RdYlBu") + 
  tm_compass(north = 0, type = "rose", position=c("right", "top"), size = 2) + 
  tm_grid(labels.inside.frame = FALSE, 
          n.x = 4,n.y = 4,
          lwd = 0, alpha = 0.1,
          projection = "+proj=longlat",
          labels.format = list(fun=function(x) {paste0(x,intToUtf8(176))} ) ) +
  tm_layout(legend.outside = TRUE, 
            legend.title.size = 0.7, 
            title = "Percent Missing/Incomplete Obs.")

# Estimate a variogram for post monsoon, constant mean 
# experimental variogram - without removing trend
lzn.vgm = variogram(PostMonsoon~1, westup.gwl.2015)

# plot the experimental variogram
plot(lzn.vgm, 
     cex = 1.5, # size of marker
     pch = 19,  # type of marker (filled circle)
     xlab = "Spatial Lag (h)", 
     ylab = "Gamma(h) (Semi-variance)") 

# fit a model variogram 
# model/theoretical variogram
# Free to choose! - This is art!
# The default fitting method if weighted least squares. If you want to use 
# other methods like unweighted OLS or restricted max likelihood, look at the gstat manual
# Hint: Use fit.method argument 
lzn.fit.sp = fit.variogram(lzn.vgm, model = vgm(40, "Sph", 0.4, 5))
lzn.fit.ex = fit.variogram(lzn.vgm, model = vgm(40, "Exp", 0.4, 5))

# plot both the fitted and experimental variograms together
plot(lzn.vgm, lzn.fit.sp,
     cex = 1.5, # size of marker
     pch = 19,  # type of marker (filled circle)
     lwd = 2,
     xlab = "Spatial Lag (h)", 
     ylab = "Gamma(h) (Semi-variance)")

# Goodness of fit, sum of squared errors
attr(lzn.fit.sp, "SSErr")
attr(lzn.fit.ex, "SSErr")
