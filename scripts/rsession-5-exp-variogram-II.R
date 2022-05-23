#### Example R Code: Spatial Statistics and Spatial Econometrics, NPTEL
#### R Session 5: Experimental Variograms - Part II
#### Author: Saif Ali, saifa@iiitd.ac.in
#### Date: May 2022

# load the gstat and sp libraries
library(gstat)
library(sp)

# make our spatial data
sp.data.in <- make_spatial_data_meuse()

# experimental anisotropic (directional) variogram - without removing trend
## Note:
## log(zinc)~1 means that we assume a constant trend for
## the variable log(zinc) - gstat tutorial, page 7
## https://cran.r-project.org/web/packages/gstat/vignettes/gstat.pdf
lzn.vgm.dir = variogram(log(zinc)~1, sp.data.in, alpha = c(0,45,90,135))

# plot the experimental variogram
plot(lzn.vgm.dir, 
     cex = 1.5, # size of marker
     pch = 19,  # type of marker (filled circle)
     xlab = "Spatial Lag (h)", 
     ylab = "Gamma(h) (Semi-variance)")

# specify cutoff and width
# cutoff - max distance within which we want to consider point pairs
# width - the bin width for h - not exact
lzn.vgm.dir = variogram(log(zinc)~1, sp.data.in, alpha = c(0,45,90,135),
                        cutoff = 1000, width = 100)
# plot the experimental variogram
plot(lzn.vgm.dir, 
     cex = 1, # size of marker
     pch = 19,  # type of marker (filled circle)
     xlab = "Spatial Lag (h)", 
     ylab = "Gamma(h) (Semi-variance)")


# Try a width of 50
lzn.vgm.dir = variogram(log(zinc)~1, sp.data.in, alpha = c(0,45,90,135),
                         cutoff = 1000, width = 50)
lzn.vgm.dir[2,"dist"] - lzn.vgm.dir[1,"dist"] 

# Try a width of 200
lzn.vgm.dir = variogram(log(zinc)~1, sp.data.in, alpha = c(0,45,90,135),
                         cutoff = 1000, width = 200)
lzn.vgm.dir[2,"dist"] - lzn.vgm.dir[1,"dist"] 
lzn.vgm.dir[3,"dist"] - lzn.vgm.dir[2,"dist"] 
lzn.vgm.dir[5,"dist"] - lzn.vgm.dir[4,"dist"] 

plot(lzn.vgm.dir, 
     cex = 1, # size of marker
     pch = 19,  # type of marker (filled circle)
     xlab = "Spatial Lag (h)", 
     ylab = "Gamma(h) (Semi-variance)")