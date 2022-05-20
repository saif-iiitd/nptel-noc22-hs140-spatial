#### Example R Code: Spatial Statistics and Spatial Econometrics, NPTEL
#### R Session 2: Working with Tabular Data
#### Author: Saif Ali, saifa@iiitd.ac.in
#### Date: May 2022

# install packages
# install.packages("gstat")
# install.packages("sp")

# load the gstat and sp libraries
library(gstat)
library(sp)

# open the help manual for the gstat package (Note: ? operator)
?gstat


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

# examine the first few rows of the data
head(meuse)

# examine the column names of the data
colnames(meuse)

# how many rows and columns in meuse data frame
dim(meuse)

# examine individual values (Note: [] operator)
meuse[1,1]

# examine values from a specific column
meuse[1,"zinc"]

# examine a specific column (Note: $ operator)
meuse$zinc
head(meuse$zinc)

# export the data to a .csv file
write.csv(meuse, ".\\data\\meuse.csv")

# compute summary statistics for zinc concentration (ppm)
summary(meuse$zinc)

# compute variance and sd of the zinc concentration (ppm)
var(meuse$zinc)
sd(meuse$zinc)

# plot a histogram of zinc concentrations
hist(meuse$zinc)
