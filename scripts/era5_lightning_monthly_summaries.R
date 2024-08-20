#Charlotte Uden
#August 12 2024

#1. calculate lightning flash rate (HOURLY) (km-2 hour-1) from gridcell area and number of strikes per day per gridcell
#2. calculate lightning flash rate (MONTHLY) (km-2 month-1) from gridcell area and number of strikes per day per gridcell



df <- read.csv("/raid/cuden/data/era5DailySummaries_vaisalaLightningDailyCounts_2005-2010_NEclip.csv")
head(df)
df <- df[,2:16]

library(ggplot2)
library(dplyr)
library(terra)

#-----1. calculate lightning strike rate (km-2 hr-1) from daily strike count-----

#convert points to raster and set crs

#get grid
points <- filter(df, date=="2008-06-01")
map + geom_point(data=points, aes(x=lon, y=lat, size=cape, col=strikes))

#add unique id to each point
points$id <- seq(1:nrow(points))
#concert to raster 
r <- rast(points[,c("lon", "lat", "cape")])
plot(r)
crs(r) <- "+init=epsg:4326"
#now make a raster that includes the id column
r <- rast(points[,c("lon", "lat", "id")])
plot(r)
crs(r) <- "+init=epsg:4326"
#convert to polygons
p = as.polygons(r, aggregate=FALSE) #if aggregate=false, each raster cell is a polygon 
plot(p)    
#get area of each polygon
area <- expanse(p, unit="km", transform=T) #	If transform=TRUE, planar CRS are transformed to lon/lat for accuracy. can also use "m" instead of "km"
p$area <- area

plot(p, "area")
plot(p, "id")

d <- data.frame(values(p))
head(d)

#merge grid and area values by id
d <- merge(points[,c("lat", "lon", "id")], d, by="id")

#merge area values with data by lat lon
df <- left_join(df, d, by=c("lat", "lon"))

#map to check it worked
points <- filter(df, date=="2008-06-01")
map + geom_point(data=points, aes(x=lon, y=lat, size=cape, col=strikes))
map + geom_point(data=points, aes(x=lon, y=lat, col=as.factor(area)))

#calculate lightning strike rate (km-2 hr-1)
df <- mutate(df, strike_rate_hourly = strikes/area/24)

ggplot() + geom_point(data=df, aes(x=cxp, y=strike_rate_hourly, alpha=0.1)) + 
  xlab(expression(CAPE~x~Precip~(W~m^-2))) +
  ylab(expression(Lightning~flash~rate~(number~per~km^2~per~hour))) + 
  ggtitle("2005-2010 n=1,185,331") +
  guides(alpha="none")

hist(df$strike_rate)
hist(df$cxp)

#just summer months
df$date <- as.Date(df$date)
df$month <- as.numeric(format(df$date,'%m'))
df$year <- as.numeric(format(df$date,'%Y'))

summer_months = c(5, 6, 7, 8)
df_summer <- df %>% 
  filter((month %in% summer_months))

ggplot() + geom_point(data=df_summer, aes(x=cxp, y=strike_rate_hourly, alpha=0.1)) + 
  xlab(expression(CAPE~x~Precip~(W~m^-2))) +
  ylab(expression(Lightning~flash~rate~(number~per~km^2~per~hour))) + 
  ggtitle("May-August 2005-2010 n=399,258") +
  guides(alpha="none")

hist(df_summer$strike_rate)
hist(df_summer$cxp)

#write.csv(df_strike_rate, "/raid/cuden/data/era5_grid_NE_clip_flash_rate.csv")

#-----2. calculate monthly lightning strike rate (km-2 month-1) from daily strike count-----
#and monthly cape and precip - each row is a month of data

#From Fig 1. plot a. Chen 2021: Different statistical models derived from the spatial 
#relationship between the present-day lightning flash rate and the product of CAPE 
#and Precip during boreal summer (averaged over May–August of 1996–1999). Each dot 
#represents the mean flash rate detected by the OTD and CAPE × Precip derived from 
#the ERA5 reanalysis over a 1° × 1° grid cell.

head(df)
head(df_summer)

cols <- c("lon", "lat", "year", "month", "area")

#sum strike count for each summer month 
summary_strike <- df_summer %>% 
  group_by(across(all_of(cols))) %>% 
  summarize(strikes_monthly_sum = sum(strikes), .groups = 'drop')

#calculate strike rate for each month (km-2 month-1)
summary_strike <- mutate(summary_strike, strike_rate = strikes_monthly_sum/area)

cols <- c("lon", "lat", "year")

#calculate mean strike rate across all summer months
summary_strike <- summary_strike %>% 
  group_by(across(all_of(cols))) %>% 
  summarize(mean_strike_rate = mean(strike_rate), .groups = 'drop')

#calculate mean CAPE across all summer months
summary_cape <- df_summer %>% 
  group_by(across(all_of(cols))) %>% 
  summarize(cape_monthly_mean = mean(cape), .groups = 'drop')

#calculate mean precipitation across all summer months
summary_mtpr <- df_summer %>% 
  group_by(across(all_of(cols))) %>% 
  summarize(mtpr_monthly_mean = mean(mtpr), .groups = 'drop')

#calculate mean cape*precip (cxp) across all summer months
summary_cxp <- df_summer %>% 
  group_by(across(all_of(cols))) %>% 
  summarize(cxp_monthly_mean = mean(cxp), .groups = 'drop')

#d2m
summary_d2m <- df_summer %>% 
  group_by(across(all_of(cols))) %>% 
  summarize(d2m_monthly_mean = mean(d2m), .groups = 'drop')

#t2m
summary_t2m<- df_summer %>% 
  group_by(across(all_of(cols))) %>% 
  summarize(t2m_monthly_mean = mean(t2m), .groups = 'drop')

#i10fg
summary_i10fg <- df_summer %>% 
  group_by(across(all_of(cols))) %>% 
  summarize(i10fg_monthly_mean = mean(i10fg), .groups = 'drop')

#msdwswrf
summary_msdwswrf <- df_summer %>% 
  group_by(across(all_of(cols))) %>% 
  summarize(msdwswrf_monthly_mean = mean(msdwswrf), .groups = 'drop')

#sp
summary_sp <- df_summer %>% 
  group_by(across(all_of(cols))) %>% 
  summarize(sp_monthly_mean = mean(sp), .groups = 'drop')

#rh
summary_rh <- df_summer %>% 
  group_by(across(all_of(cols))) %>% 
  summarize(rh_monthly_mean = mean(rh), .groups = 'drop')

#tmin
summary_tmin <- df_summer %>% 
  group_by(across(all_of(cols))) %>% 
  summarize(tmin_monthly_mean = mean(tmin), .groups = 'drop')

#tmax
summary_tmax <- df_summer %>% 
  group_by(across(all_of(cols))) %>% 
  summarize(tmax_monthly_mean = mean(tmax), .groups = 'drop')


#merge summaries
summary_df <- merge(summary_strike, summary_cape, by=cols)
summary_df <- merge(summary_df, summary_mtpr, by=cols)
summary_df <- merge(summary_df, summary_cxp, by=cols)
summary_df <- merge(summary_df, summary_d2m, by=cols)
summary_df <- merge(summary_df, summary_t2m, by=cols)
summary_df <- merge(summary_df, summary_i10fg, by=cols)
summary_df <- merge(summary_df, summary_msdwswrf, by=cols)
summary_df <- merge(summary_df, summary_sp, by=cols)
summary_df <- merge(summary_df, summary_rh, by=cols)
summary_df <- merge(summary_df, summary_tmin, by=cols)
summary_df <- merge(summary_df, summary_tmax, by=cols)
head(summary_df)


#Lightning flash rate positively correlates with the product of CAPE and precipitation
ggplot() + geom_point(data=summary_df, aes(x=cxp_monthly_mean, y=mean_strike_rate, alpha=0.1)) + 
  xlab(expression(CAPE~x~Precip~(W~m^-2))) +
  ylab(expression(Lightning~flash~rate~(number~per~km^2~per~month))) + 
  ggtitle("May-August 2005-2010 n=3246") +
  guides(alpha="none")

hist(summary_df$mean_strike_rate)
hist(summary_df$cxp_monthly_mean)
hist(summary_df$rh_monthly_mean)

write.csv(summary_df, "/raid/cuden/data/era5_vaisalaLightning_monthlySummaries_2005-2010_NEclip.csv")

