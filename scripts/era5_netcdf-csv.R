library(ncdf4)
library(dplyr)
library(ggplot2)
library(eurocordexr)

#July 26th 2024
#Script to extract netcdf data a write it to a csv file. 
#expand.grid() function could not handle the size of the data
#ended up using a python library. see era5-netcdf-csv.py

setwd("/raid/cuden/data")

#get variable
file <- 'era5_d2m_t2m_i10fg_msdwswrf_sp_2005.nc'
var <- 'msdwswrf'

nc <- nc_open(file)

var <- ncvar_get(nc, var)
lat <- ncvar_get(nc, 'latitude')
lon <- ncvar_get(nc, 'longitude')
time <- ncvar_get(nc, 'time')
time <- as.POSIXct("1900-01-01 00:00:00") + as.difftime(time, units="hours")
#date <- as.Date(time[1:5], origin="1900-01-01 00:00:00.0")
coords <- as.matrix(expand.grid(lon, lat, var, time))

#get grid
grid <- expand.grid(lon=lon, lat=lat)
plot(grid)
#write.csv(grid, "/raid/cuden/data/era5_grid.csv")


get_nc_data <- function(file_path=x, var_name=y) {
  #file_path="file_path"
  #var_name"="climate_variable"
  nc <- nc_open(file_path)
  variable <- ncvar_get(nc, var_name)
  time <- ncvar_get(nc, 'time')
  lon <- ncvar_get(nc, 'longitude')
  lat <- ncvar_get(nc, 'latitude')
  
  dat <- as.data.frame(cbind(time, lon, lat, variable))
  dat$time <- as.POSIXct("1900-01-01 00:00:00") + as.difftime(dat$time, units="hours")
  #dat$date <- as.Date(dat$time[1:5], origin="1900-01-01 00:00:00.0")

  colnames(dat) <- c('time', 'lon', 'lat', var_name)
  return(dat)
}

#2005
d2m <- get_nc_data(file_path='era5_d2m_t2m_i10fg_msdwswrf_sp_2005.nc', var_name='d2m')
t2m <- get_nc_data(file_path='era5_d2m_t2m_i10fg_msdwswrf_sp_2005.nc', var_name='t2m')
i10fg <- get_nc_data(file_path='era5_d2m_t2m_i10fg_msdwswrf_sp_2005.nc', var_name='i10fg')
msdwswrf <- get_nc_data(file_path='era5_d2m_t2m_i10fg_msdwswrf_sp_2005.nc', var_name='msdwswrf')
sp <- get_nc_data(file_path='era5_d2m_t2m_i10fg_msdwswrf_sp_2005.nc', var_name='sp')
#to avoid using merge() (which takes a long time) use identical() function to 
#check that data frame columns are the same
df2005 <- cbind(d2m, 
                t2m=t2m[['t2m']], 
                i10fg=i10fg[['i10fg']], 
                msdwswrf=msdwswrf[['msdwswrf']],
                sp=sp[['sp']])
head(df2005)

#2006
d2m <- get_nc_data(file_path='era5_d2m_t2m_i10fg_msdwswrf_sp_2006.nc', var_name='d2m')
t2m <- get_nc_data(file_path='era5_d2m_t2m_i10fg_msdwswrf_sp_2006.nc', var_name='t2m')
i10fg <- get_nc_data(file_path='era5_d2m_t2m_i10fg_msdwswrf_sp_2006.nc', var_name='i10fg')
msdwswrf <- get_nc_data(file_path='era5_d2m_t2m_i10fg_msdwswrf_sp_2006.nc', var_name='msdwswrf')
sp <- get_nc_data(file_path='era5_d2m_t2m_i10fg_msdwswrf_sp_2006.nc', var_name='sp')

df2006 <- cbind(d2m, 
                t2m=t2m[['t2m']], 
                i10fg=i10fg[['i10fg']], 
                msdwswrf=msdwswrf[['msdwswrf']],
                sp=sp[['sp']])
head(df2006)

df <- rbind(df2005, df2006)

#2007
d2m <- get_nc_data(file_path='era5_d2m_t2m_i10fg_msdwswrf_sp_2007.nc', var_name='d2m')
t2m <- get_nc_data(file_path='era5_d2m_t2m_i10fg_msdwswrf_sp_2007.nc', var_name='t2m')
i10fg <- get_nc_data(file_path='era5_d2m_t2m_i10fg_msdwswrf_sp_2007.nc', var_name='i10fg')
msdwswrf <- get_nc_data(file_path='era5_d2m_t2m_i10fg_msdwswrf_sp_2007.nc', var_name='msdwswrf')
sp <- get_nc_data(file_path='era5_d2m_t2m_i10fg_msdwswrf_sp_2007.nc', var_name='sp')

df2007 <- cbind(d2m, 
                t2m=t2m[['t2m']], 
                i10fg=i10fg[['i10fg']], 
                msdwswrf=msdwswrf[['msdwswrf']],
                sp=sp[['sp']])
head(df2007)

df <- rbind(df, df2007)

#2008
d2m <- get_nc_data(file_path='era5_d2m_t2m_i10fg_msdwswrf_sp_2008.nc', var_name='d2m')
t2m <- get_nc_data(file_path='era5_d2m_t2m_i10fg_msdwswrf_sp_2008.nc', var_name='t2m')
i10fg <- get_nc_data(file_path='era5_d2m_t2m_i10fg_msdwswrf_sp_2008.nc', var_name='i10fg')
msdwswrf <- get_nc_data(file_path='era5_d2m_t2m_i10fg_msdwswrf_sp_2008.nc', var_name='msdwswrf')
sp <- get_nc_data(file_path='era5_d2m_t2m_i10fg_msdwswrf_sp_2008.nc', var_name='sp')

df2008 <- cbind(d2m, 
                t2m=t2m[['t2m']], 
                i10fg=i10fg[['i10fg']], 
                msdwswrf=msdwswrf[['msdwswrf']],
                sp=sp[['sp']])
head(df2008)

df <- rbind(df, df2008)

#2009
d2m <- get_nc_data(file_path='era5_d2m_t2m_i10fg_msdwswrf_sp_2009.nc', var_name='d2m')
t2m <- get_nc_data(file_path='era5_d2m_t2m_i10fg_msdwswrf_sp_2009.nc', var_name='t2m')
i10fg <- get_nc_data(file_path='era5_d2m_t2m_i10fg_msdwswrf_sp_2009.nc', var_name='i10fg')
msdwswrf <- get_nc_data(file_path='era5_d2m_t2m_i10fg_msdwswrf_sp_2009.nc', var_name='msdwswrf')
sp <- get_nc_data(file_path='era5_d2m_t2m_i10fg_msdwswrf_sp_2009.nc', var_name='sp')

df2009 <- cbind(d2m, 
                t2m=t2m[['t2m']], 
                i10fg=i10fg[['i10fg']], 
                msdwswrf=msdwswrf[['msdwswrf']],
                sp=sp[['sp']])
head(df2009)

df <- rbind(df, df2009)

#2010
d2m <- get_nc_data(file_path='era5_d2m_t2m_i10fg_msdwswrf_sp_2010.nc', var_name='d2m')
t2m <- get_nc_data(file_path='era5_d2m_t2m_i10fg_msdwswrf_sp_2010.nc', var_name='t2m')
i10fg <- get_nc_data(file_path='era5_d2m_t2m_i10fg_msdwswrf_sp_2010.nc', var_name='i10fg')
msdwswrf <- get_nc_data(file_path='era5_d2m_t2m_i10fg_msdwswrf_sp_2010.nc', var_name='msdwswrf')
sp <- get_nc_data(file_path='era5_d2m_t2m_i10fg_msdwswrf_sp_2010.nc', var_name='sp')

df2010 <- cbind(d2m, 
                t2m=t2m[['t2m']], 
                i10fg=i10fg[['i10fg']], 
                msdwswrf=msdwswrf[['msdwswrf']],
                sp=sp[['sp']])
head(df2010)

df <- rbind(df, df2010)
head(df)

#write.csv(df, "/raid/cuden/data/era5_hourly_d2m_t2m_i10fg_msdwswrf_sp_2005-2010.csv")
min(df$time)
max(df$time)



#Map cliamte data to check it makes sense:
library(maps)
library(mapdata)

precip2005 <- get_nc_data(file_path='era5_precip_CAPE_2005.nc', var_name='mtpr')
head(precip2005)
str(precip2005)

#map the points
states <- map_data("state")#turn state line map into data frame
new_england <- subset(states, region %in% c("vermont", "new hampshire", "connecticut", "maine", "rhode island", "massachusetts", "new york"))#subest ne$
map <- ggplot() + geom_polygon(data = new_england, aes(x=long, y=lat, group = group), color="white", fill="lightgray") + coord_fixed(1.3)

p <- filter(precip2005, time==as.POSIXct("2005-01-16 01:00:00"))
str(p)
map + geom_point(data=p, aes(x=lon, y=lat)) 



summary_loop <- data.frame(matrix(nrow=0, ncol=5))
colnames(summary_loop) <- c("lon", "lat", "date", "cape_mean", "mtpr_mean")

#loop through days
dates <- seq(as.Date("2005-01-01"), as.Date("2010-12-31"), by="days")
longitudes <- unique(df$lon)
latitudes <- unique(df$lat)

for(i in seq(1:length(dates))){
  i=1
  date_i <- dates[i]
  dat <- filter(precip2005, date == as.Date(date_i))
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

