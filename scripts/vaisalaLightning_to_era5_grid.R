#------------------------------
#RASTER METHOD
#------------------------------
#July 26th 2024

#Script to aggregate Vaisala lightning strike data to PalEON data

# RASTER METHOD: turn the point grid into a raster and find number of lightning strikes (points) that fall into 
#each raster cell each day. 

#--- Make Raster Object from point ---
library(raster)
library(rdgal)
library(dplyr)
library(sp)
library(ggplot2)
library(patchwork)

setwd("/raid/cuden/data")

#get era5 grid 
grid <- read.csv("era5_grid.csv")[,2:3]
head(grid)
plot(grid$lon, grid$lat)

#assign index value to grid cells 
grid <- cbind(grid, index=seq(1:nrow(grid)))
head(grid)
#use paleon grid to make spatial object, then raster
r <- grid
#coordinates(r) <- ~ lon + lat 
#r <- raster(r, ncol=26, nrow=14)
r <- rasterFromXYZ(r)
#values(r) <- runif(ncell(r))
crs(r) <- CRS("+proj=longlat +datum=WGS84")

#view point grid over raster
p <- grid
coordinates(p) <- ~ lon + lat
plot(r)
points(p)

#get lightning data
data <- read.csv("vaisala_2004-2010.csv")
data <- data[,c("date", "lat", "lon")]
data$date <- as.Date(data$date)
str(data)

#function to count points that fall into each raster cell
pointcount = function(r, pts){
  # make a raster of zeroes like the input
  r2 = r
  r2[] = 0
  # get the cell index for each point and make a table:
  counts = table(cellFromXY(r,pts))
  # fill in the raster with the counts from the cell index:
  r2[as.numeric(names(counts))] = counts
  return(r2)
}

#empty dataframe to hold output
lightningStrikes <- data.frame(matrix(nrow=0, ncol=4))
colnames(lightningStrikes) <- c("x", "y", "layer", "date")

#loop through days
dates <- seq(as.Date("2004-01-01"), as.Date("2010-12-31"), by="days")
#dates <- seq(as.Date("2004-06-01"), as.Date("2004-06-25"), by="days")
#dates <- as.Date("2004-06-01")

for(day in dates){
  pts <- filter(data, date==day)
  #day=as.Date("2004-06-01")
  #pts <- filter(data, date==day)
  if (nrow(pts) > 0) {
    #convert day's data to spatial object
    coordinates(pts) <- ~ lon + lat
    crs(pts) <- CRS("+proj=longlat +datum=WGS84")
    #use point count function from above
    #r2 <- pointcount(r, pts)
    #--
    r2 = r
    r2[] = 0
    # get the cell index for each point and make a table:
    counts = table(cellFromXY(r,pts))
    # fill in the raster with the counts from the cell index:
    r2[as.numeric(names(counts))] = counts
    #--
  } else if (nrow(pts) == 0){
    #if there was no lightning that day, make a raster of 0s
    r2 <- r
    r2[] <- 0
  }
  df <- as.data.frame(r2, xy=TRUE)
  df <- cbind(df, date=rep(day, nrow(df)))
  lightningStrikes <- rbind(lightningStrikes, df)
}

#convert date column from numeric to date, rename columns 
lightningStrikes$date <- as.Date(lightningStrikes$date, origin="1970-01-01")
colnames(lightningStrikes) <- c("lon", "lat", "strikes", "date")

#----------
#check that it worked:

library(maps)
library(mapdata)
#map the points
states <- map_data("state")#turn state line map into data frame
new_england <- subset(states, region %in% c("vermont", "new hampshire", "connecticut", "maine", "rhode island", "massachusetts", "new york"))#subest ne$
map <- ggplot() + geom_polygon(data = new_england, aes(x=long, y=lat, group = group), color="white", fill="lightgray") + coord_fixed(1.3)

r <- lightningStrikes
r <- filter(r, date=="2004-06-01")
r <- r[,1:3]
#r <- rasterFromXYZ(r)
#plot(r)
raster <- map + geom_tile(data=r, aes(x=lon, y=lat, fill=strikes, alpha=0.5)) +
  scale_fill_gradient(low="#FFFFFF", high="#0033FF") +
  ggtitle("2004-06-01") +
  guides(alpha = FALSE)

p <- filter(data, date=="2004-06-01")
point <- map + geom_point(data=p, aes(x=lon, y=lat, alpha=0.1)) +
  ggtitle("2004-06-01") +
  guides(alpha = FALSE)

(point + raster)

#write to csv
write.csv(lightningStrikes, "/raid/cuden/data/2004-20010_vaisala_lightning_era5Grid.csv")



