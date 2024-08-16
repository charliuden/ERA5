#July 23rd 2024

library(ggplot2)
library(dplyr)

#Script to merge PalEON data and lightning data

l <- read.csv("/raid/cuden/data/2004-20010_vaisala_lightning_era5Grid.csv")[,2:5]
d1 <- read.csv("/raid/cuden/data/era5_precip_cape_cxp_2005-2010_dailySummaries.csv")
d2 <- read.csv("/raid/cuden/data/era5_d2m_t2m_i10fg_msdwswrf_sp_2005-2010_dailySummaries.csv")

str(l)
str(d1)
str(d2)

l[,c("date")] <- as.Date(l[,c("date")])
d1[,c("date")] <- as.Date(d1[,c("date")])
d2[,c("date")] <- as.Date(d2[,c("date")])

l_day <- filter(l, date=="2005-06-01")
d1_day <- filter(d1, date=="2005-06-01")
d2_day <- filter(d2, date=="2005-06-01")

ggplot() + geom_point(data=l_day, aes(x=lon, y=lat, col=strikes))
ggplot() + geom_point(data=d1_day, aes(x=longitude, y=latitude, col=cxp))
ggplot() + geom_point(data=d2_day, aes(x=longitude, y=latitude, col=t2m))

#rename columns
colnames(d1) <- c("date","lat","lon","cape","mtpr","cxp")
colnames(d2) <- c("date","lat","lon","d2m","t2m","i10fg", "msdwswrf", "sp", "tmin", "tmax")

#merge by lat lon date
d <- merge(l, d1, by=c("date", "lon", "lat"))
d <- merge(d, d2, by=c("date", "lon", "lat"))
head(d)

#check that it worked:
library(maps)
library(mapdata)

#map the points
states <- map_data("state")#turn state line map into data frame
new_england <- subset(states, region %in% c("vermont", "new hampshire", "connecticut", "maine", "rhode island", "massachusetts", "new york"))#subest ne$
map <- ggplot() + geom_polygon(data = new_england, aes(x=long, y=lat, group = group), color="white", fill="lightgray") + coord_fixed(1.3)

p <- filter(d, date=="2008-06-01")
map + geom_point(data=p, aes(x=lon, y=lat, size=cape, col=strikes))

write.csv(d, "/raid/cuden/data/era5DailySummaries_vaisalaLightningDailyCounts_2005-2010.csv")

