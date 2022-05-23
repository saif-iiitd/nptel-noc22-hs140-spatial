#### Example R Code: Spatial Statistics and Spatial Econometrics, NPTEL
#### R Session 4: Experimental Variograms - Part I
#### Author: Saif Ali, saifa@iiitd.ac.in
#### Date: May 2022

# load the gstat and sp libraries
library(gstat)
library(sp)

# A function to make a spatial dataset 
make_spatial_data_meuse <- function()
{
  # load the "meuse" data set (available in sp library)
  # documentation: https://cran.r-project.org/web/packages/gstat/vignettes/gstat.pdf
  ####
  # The meuse data set provided by package sp is a data set comprising of four
  # heavy metals measured in the top soil in a flood plain along the river Meuse,
  # along with a handful of covariates. The data set was introduced by Burrough
  # and McDonnell, 1998.
  data(meuse)
  
  # make a copy of meuse
  meuse.sp <- meuse
  
  
  # convert meuse to a spatial data format
  
  ####
  #the function coordinates, when assigned (i.e. on the left-hand side of an
  # = or <- sign), promotes the data.frame meuse into a SpatialPointsDataFrame, 
  # which knows about its spatial coordinates; coordinates may
  #be specified by a formula, a character vector, or a numeric matrix or data
  #frame with the actual coordinates
  coordinates(meuse.sp) <- (~x+y)
  
  return (meuse.sp)
}



# Spatial Data -> Input to variogram estimation 
sp.data.in <- make_spatial_data_meuse()

# Plot spatial data 
# make a spatial plot of zinc concentrations 
# Note: You can't do this with ordinary data frames! 
bubble(sp.data.in, "zinc",
       col=c("#00ff0088", "#00ff0088"), 
       main = "zinc concentrations (ppm)")


# experimental variogram cloud - without removing trend 
lzn.vgm.cloud = variogram(log(zinc)~1, sp.data.in, cloud = TRUE)

# plot and identify point pairs 
plot(plot(lzn.vgm.cloud, identify=TRUE), sp.data.in)

# experimental variogram - without removing trend
lzn.vgm = variogram(log(zinc)~1, sp.data.in)

# plot the experimental variogram
plot(lzn.vgm, 
     cex = 1.5, # size of marker
     pch = 19,  # type of marker (filled circle)
     xlab = "Spatial Lag (h)", 
     ylab = "Gamma(h) (Semi-variance)") 

# experimental variogram - modeling trend by coordinates x and y
lzn.vgm.detrend = variogram(log(zinc)~x+y, sp.data.in)

# plot the experimental variogram - modeling trend
plot(lzn.vgm.detrend, 
     cex = 1.5, # size of marker
     pch = 19,  # type of marker (filled circle)
     xlab = "Spatial Lag (h)", 
     ylab = "Gamma(h) (Semi-variance)") 

# plot the two variograms together
# use the plotly library
library(plotly)
plotly::plot_ly(,type = "scatter", mode = "markers") %>% 
  add_trace(data = lzn.vgm, 
            x = ~dist,
            y = ~gamma,
            name = "Variogram") %>%
add_trace(data = lzn.vgm.detrend, 
          x = ~dist,
          y = ~gamma,
          name = "Variogram - Detrended") %>%
  layout(xaxis = list(title = "Spatial Lag (h)"),
         yaxis = list(title = "Semivariance, gamma(h)"))
