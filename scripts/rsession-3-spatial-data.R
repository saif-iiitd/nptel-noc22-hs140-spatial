#### Example R Code: Spatial Statistics and Spatial Econometrics, NPTEL
#### R Session 3: Working with Spatial Data
#### Author: Saif Ali, saifa@iiitd.ac.in
#### Date: May 2022

# load the gstat and sp libraries
library(gstat)
library(sp)

# load the "meuse" data set (available in sp library)
# documentation: https://cran.r-project.org/web/packages/gstat/vignettes/gstat.pdf
####
# The meuse data set provided by package sp is a data set comprising of four
# heavy metals measured in the top soil in a flood plain along the river Meuse,
# along with a handful of covariates. The data set was introduced by Burrough
# and McDonnell, 1998.
data(meuse)

# examine the type of the "meuse" variable 
class(meuse)

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

# Note: R forumla operator ~

# examine the type of meuse.sp variable
class(meuse.sp)

# examine the column names of the data within the spatial dataframe
colnames(meuse.sp@data)

# Note: you can do almost everything with spatial dataframes
# that you can do with ordinary data frames

# how many rows and columns in meuse data frame
dim(meuse)

# examine individual values (Note: [] operator)
meuse.sp[1,1]

# examine values from a specific column
meuse.sp[1,"zinc"]

# examine a specific column (Note: $ operator)
meuse.sp$zinc
head(meuse.sp$zinc)

# compute summary statistics for zinc concentration (ppm)
summary(meuse.sp$zinc)

# compute variance and sd of the zinc concentration (ppm)
var(meuse.sp$zinc)
sd(meuse.sp$zinc)

# plot a histogram of zinc concentrations
hist(meuse.sp$zinc)

# make a spatial plot of zinc concentrations 
# Note: You can't do this with ordinary data frames! 
bubble(meuse.sp, "zinc",
        col=c("#00ff0088", "#00ff0088"), 
        main = "zinc concentrations (ppm)")
