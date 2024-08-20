#Charlotte Uden
#August 7 2024

#clip era5 and lightning data to the Northeast

library(ggplot2)
library(dplyr)

df <- read.csv("/raid/cuden/data/era5DailySummaries_vaisalaLightningDailyCounts_2005-2010.csv")#[,2:7]
df <- df[,2:16]
grid <- read.csv("/raid/cuden/data/era5_grid_NE_clip.csv")[,2:3]

plot(grid$lon, grid$lat)

df_clip <- left_join(grid, df, by=c("lat", "lon"))

str(df_clip)

#check that it worked:
library(maps)
library(mapdata)

#map the points
states <- map_data("state")#turn state line map into data frame
new_england <- subset(states, region %in% c("vermont", "new hampshire", "connecticut", "maine", "rhode island", "massachusetts", "new york"))#subest ne$
map <- ggplot() + geom_polygon(data = new_england, aes(x=long, y=lat, group = group), color="white", fill="lightgray") + coord_fixed(1.3)

points <- filter(df_clip, date=="2008-06-01")
#map + geom_point(data=points, aes(x=lon, y=lat, size=tmin, col=tmax))
map + geom_point(data=points, aes(x=lon, y=lat, size=cxp, col=strikes))

write.csv(df_clip, "/raid/cuden/data/era5DailySummaries_vaisalaLightningDailyCounts_2005-2010_NEclip.csv")


