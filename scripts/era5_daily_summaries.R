library(dplyr)

setwd("/raid/cuden/data")
df <- read.csv("/raid/cuden/data/era5_2005-2010.csv")

#change time column from date AND time, to just date
df$date <- as.Date(df$time, origin="1900-01-01 00:00:00")
str(df)

cols <- c("date","lon","lat")

summary_cape <- df %>% 
  group_by(across(all_of(cols))) %>% 
  summarize(cape_mean = mean(cape), .groups = 'drop')

nrow(summary_cape)

summary_mtpr <- df %>% 
  group_by(across(all_of(cols))) %>% 
  summarize(mtpr_mean = mean(mtpr), .groups = 'drop')

nrow(summary_mtpr)

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


