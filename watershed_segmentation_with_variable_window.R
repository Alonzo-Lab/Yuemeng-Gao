#Preamble ----
# Author:       Mike Alonzo
# Date:        2/17/2020
# Origin Date:  2/5/2020
# Purpose:      Canopy segmentation and analysis 
# R version:    3.6.2
# Input file:   a CHM
# Output files: Not yet coded
# Notes:        
#All of this code is copied from:
#https://cran.r-project.org/web/packages/ForestTools/vignettes/treetopAnalysis.html
#do not assume that this code gives good results for any given CHM.
#############################################################################################

#Canopy Segmentation ----
# Attach the 'ForestTools' and 'raster' libraries
library(ForestTools)
library(raster)

# Load sample canopy height model
#data("kootenayCHM") #example data that came with R
#chm_sub = kootenayCHM

#use your own data
mydir<-'C:\\Users\\mikea\\ENVS_RS Dropbox\\Data\\alaska\\gliht\\geotiff\\chm\\'
chm <- raster(paste(mydir, 'av_chm_20180731.tif', sep=""))

# Remove plot margins (optional)
par(mar = rep(0.5, 4))

# Plot CHM (extra optional arguments remove labels and tick marks from the plot)
plot(chm, xlab = "", ylab = "", xaxt='n', yaxt = 'n')

#subset raster by hand to to get a smaller example subset
chm_sub<-select(chm)

#determine appropriate relationship between tree height and width.
#This equation establishes a window size and plays a strong role
#in the scale of the segments
lin <- function(x){x * 0.5 + 0.6}
ttops <- vwf(CHM = chm_sub, winFun = lin, minHeight = 2)

# Plot CHM
plot(chm_sub, xlab = "", ylab = "", xaxt='n', yaxt = 'n')

# Add dominant treetops to the plot
plot(ttops, col = "blue", pch = 20, cex = 0.5, add = TRUE)

# Get the mean treetop height
mean(ttops$height)

# Create crown map
crowns <- mcws(treetops = ttops, CHM = chm_sub, minHeight = 1.5, verbose = FALSE)

# Plot crowns
plot(crowns, col = sample(rainbow(50), length(unique(crowns[])), replace = TRUE), legend = FALSE, xlab = "", ylab = "", xaxt='n', yaxt = 'n')

# Create polygon crown map
crownsPoly <- mcws(treetops = ttops, CHM = chm_sub, format = "polygons", minHeight = 1.5, verbose = FALSE)

# Plot CHM
plot(chm_sub, xlab = "", ylab = "", xaxt='n', yaxt = 'n')

# Add crown outlines to the plot
plot(crownsPoly, border = "blue", lwd = 0.5, add = TRUE)

# Compute average crown diameter
crownsPoly[["crownDiameter"]] <- sqrt(crownsPoly[["crownArea"]]/ pi) * 2

# Mean crown diameter
mean(crownsPoly$crownDiameter)