library(dplyr)
library(maps)
library(mapdata)
library(raster)
library(sp)
library(patchwork)

#July 26th 2024
#script to get hourly era5 data to daily timestep. 
#ended up making a python scrip - see era5_daily_summaries.py

setwd("/raid/cuden/data")
df <- read.csv("/raid/cuden/data/era5_2005-2010.csv")

#change time column from date AND time, to just date
df$time_test <- as.POSIXct(df$time, format="%Y-%m-%d %H:%M:%S")
df$date <- as.Date(df$time, origin="1900-01-01 00:00:00")
str(df)

#base map for testing that the data make sense: 
states <- map_data("state")#turn state line map into data frame
new_england <- subset(states, region %in% c("vermont", "new hampshire", "connecticut", "maine", "rhode island", "massachusetts", "new york"))#subest ne$
map <- ggplot() + geom_polygon(data = new_england, aes(x=long, y=lat, group = group), color="white", fill="lightgray") + coord_fixed(1.3)

#get era5 grid to get an idea of granularity 
grid <- read.csv("era5_grid.csv")[,2:3]
head(grid)
map + geom_point(data=grid, aes(x=lon, y=lat, alpha=0.01)) 

#compare grid to data:
r <- filter(df, time_test=="2005-01-01 02:00:00")
str(r)
r <- r[,3:5]
r <- rasterFromXYZ(r)
plot(r)
raster <- map + geom_tile(data=r, aes(x=lon, y=lat, fill=cape_mean, alpha=0.5)) +
  scale_fill_gradient(low="#FFFFFF", high="#0033FF") +
  guides(alpha = FALSE)

#columns to group by:
cols <- c("date","lon","lat")

#---caculate mean cape: ---
summary_cape <- df %>% 
  group_by(across(all_of(cols))) %>% 
  summarize(cape_mean = mean(cape), .groups = 'drop')

#using a for loop:
#empty dataframe to hold output
summary_loop <- data.frame(matrix(nrow=0, ncol=5))
colnames(summary_loop) <- c("lon", "lat", "date", "cape_mean", "mtpr_mean")

#loop through days
dates <- seq(as.Date("2005-01-01"), as.Date("2010-12-31"), by="days")
longitudes <- unique(df$lon)
latitudes <- unique(df$lat)

for(i in seq(1:length(dates))){
  i=1
  date_i <- dates[i]
  dat <- filter(df, date == as.Date(date_i))
  for(j in seq(1:length(longitudes))){
    j=1
    lon_j <- longitudes[j]
    dat <- filter(dat, lon == lon_j)
    for(k in seq(1:length(latitudes))){
      k=1
      lat_k <- latitudes[k]
      dat <- filter(dat, lat == lat_k)
      cape <- mean(dat$cape)
      mtpr <- mean(dat$mtpr)
      summary_loop <- rbind(summary_loop, c(i, j, k, cape, mtpr))
    }
  }
}

str(summary_loop)

#check the data make sense
str(summary_cape)
r <- filter(summary_cape, date==as.Date("2005-01-01"))
str(r)
r <- r[,2:4]
r <- rasterFromXYZ(r)
plot(r)
raster <- map + geom_tile(data=r, aes(x=lon, y=lat, fill=cape_mean, alpha=0.5)) +
  scale_fill_gradient(low="#FFFFFF", high="#0033FF") +
  guides(alpha = FALSE)

#---caculate mean precipitation: ---
summary_mtpr <- df %>% 
  group_by(across(all_of(cols))) %>% 
  summarize(mtpr_mean = mean(mtpr), .groups = 'drop')

nrow(summary_mtpr)

#check the data make sense
r <- filter(summary_mtpr, date=="2005-06-01")
str(r)
r <- r[,2:4]
r <- rasterFromXYZ(r)
plot(r)
raster <- map + geom_tile(data=r, aes(x=lon, y=lat, fill=cape_mean, alpha=0.5)) +
  scale_fill_gradient(low="#FFFFFF", high="#0033FF") +
  guides(alpha = FALSE)

#use identical() funciton to make sure lat, lon and date are the same (rather than using merge())
identical(summary_mtpr[['lon']],summary_cape[['lon']])
identical(summary_mtpr[['lat']],summary_cape[['lat']])
identical(summary_mtpr[['date']],summary_cape[['date']])

df_means <- cbind(summary_cape, mtpr_mean=summary_mtpr[['mtpr_mean']])

#check that summaries are correct
mean(filter(df, date=='2005-01-01' & lon==-80.00 & lat==48.00)$cape)
filter(df_means, date=='2005-01-01' & lon==-80.00 & lat==48.00)$cape

mean(filter(df, date=='2007-01-01' & lon==-80.00 & lat==48.00)$mtpr)
filter(df_means, date=='2007-01-01' & lon==-80.00 & lat==48.00)$mtpr

#write.csv(df_means, "/raid/cuden/data/era5_2005-2010_cape_mtpr_dailyMeans.csv")




#Map the data to check that it worked:

library(raster)
library(sp)
library(patchwork)
library(ggplot2)

#base map for testing that the data make sense: 
states <- map_data("state")#turn state line map into data frame
new_england <- subset(states, region %in% c("vermont", "new hampshire", "connecticut", "maine", "rhode island", "massachusetts", "new york"))#subest ne$
map <- ggplot() + geom_polygon(data = new_england, aes(x=long, y=lat, group = group), color="white", fill="lightgray") + coord_fixed(1.3)


df <- read.csv("/raid/cuden/data/era5_cape_precip_2005-2010_dailyMeans.csv")
df$date <- as.Date(df$date)
df_day <- filter(df, date=="2005-06-01")

#map as raster
r <- df_day
r <- r[,1:3]
r <- rasterFromXYZ(r)
#plot(r)
map + geom_tile(data=r, aes(x=longitude, y=latitude, fill=cape, alpha=0.5)) +
  scale_fill_gradient(low="#FFFFFF", high="#0033FF") +
  guides(alpha = FALSE)

#map the points
ggplot() + geom_point(data=df_day, aes(x=longitude, y=latitude, col=cape)) 

