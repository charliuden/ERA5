library(ncdf4)
library(dplyr)
library(ggplot2)
library(eurocordexr)

setwd("/raid/cuden/data")

#get variable
file <- 'era5_precip_CAPE_2005.nc'
var <- 'mtpr'

nc <- nc_open(file)

var <- ncvar_get(nc, var)
lat <- ncvar_get(nc, 'latitude')
lon <- ncvar_get(nc, 'longitude')
time <- ncvar_get(nc, 'time')

time <- as.POSIXct("1900-01-01 00:00:00") + as.difftime(time, units="hours")
#date <- as.Date(time[1:5], origin="1900-01-01 00:00:00.0")

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

precip2005 <- get_nc_data(file_path='era5_precip_CAPE_2005.nc', var_name='mtpr')
cape_2005 <- get_nc_data(file_path = 'era5_precip_CAPE_2005.nc', var_name = 'cape')
#to avoid using merge() (whcih takes a long time) use identical() function to 
#check that dataframe columsnare the same
df2005 <- cbind(precip2005, cape=cape_2005[['cape']])
head(df2005)

precip2006 <- get_nc_data(file_path='era5_precip_CAPE_2006.nc', var_name='mtpr')
cape_2006 <- get_nc_data(file_path = 'era5_precip_CAPE_2006.nc', var_name = 'cape')
df2006 <- cbind(precip2006, cape=cape_2006[['cape']])
head(df2006)

df <- rbind(df2005, df2006)

precip2007 <- get_nc_data(file_path='era5_precip_CAPE_2007.nc', var_name='mtpr')
cape_2007 <- get_nc_data(file_path = 'era5_precip_CAPE_2007.nc', var_name = 'cape')
df2007 <- cbind(precip2007, cape=cape_2007[['cape']])
head(df2007)

df <- rbind(df, df2007)

precip2008 <- get_nc_data(file_path='era5_precip_CAPE_2008.nc', var_name='mtpr')
cape_2008 <- get_nc_data(file_path = 'era5_precip_CAPE_2008.nc', var_name = 'cape')
df2008 <- cbind(precip2008, cape=cape_2008[['cape']])
head(df2008)

df <- rbind(df, df2008)

precip2009 <- get_nc_data(file_path='era5_precip_CAPE_2009.nc', var_name='mtpr')
cape_2009 <- get_nc_data(file_path = 'era5_precip_CAPE_2009.nc', var_name = 'cape')
df2009 <- cbind(precip2009, cape=cape_2009[['cape']])
head(df2009)

df <- rbind(df, df2009)

precip2010 <- get_nc_data(file_path='era5_precip_CAPE_2010.nc', var_name='mtpr')
cape_2010 <- get_nc_data(file_path = 'era5_precip_CAPE_2010.nc', var_name = 'cape')
df2010 <- cbind(precip2010, cape=cape_2010[['cape']])
head(df2010)

df <- rbind(df, df2010)
head(df)

#write.csv(df, "/raid/cuden/data/era5_2005-2010.csv")
min(df$time)
max(df$time)
