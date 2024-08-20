import pandas as pd
#import math
import numpy as np

#-- get mean values --

#df = pd.read_csv('/raid/cuden/data/era5_precip_cape_2005-2010.csv')
df = pd.read_csv('/raid/cuden/data/era5_hourly_d2m_t2m_i10fg_msdwswrf_sp_2005-2010.csv')
#print(df)

df['time'] = pd.to_datetime(df['time'])

# function to extract date
def extract_date(dt):
    return dt.date()

# Apply function to 'datetime' column
df['date'] = df['time'].apply(extract_date)

#-- cape and precip -- 

#calclulate CAPE * Precip term
#df["cxp"] = (
#    df["cape"] * df["mtpr"]
#)
#print(df.info)

#caluclate daily mean for each variable by date, lat, lon
#df_summary = df.groupby(['date', 'latitude','longitude'])[['cape', 'mtpr', 'cxp']].mean()
#print(df_summary)

#-- other 5 climate varaibels are in a separate csv file --
#convert kelvin to celcius
df["d2m"] = (
    df.d2m - 273.15
)

df["t2m"] = (
    df.t2m - 273.15
)

#calculate relative humidity
beta =  17.625
gamma = 243.04 #degrees Celsius

df["rh"] = (
    100*(np.exp((beta * df.d2m) / (gamma + df.d2m)) / np.exp((beta * df.t2m) / (gamma + df.t2m)))
)

#𝑅𝐻≈100−5(𝑇−𝑇𝐷)

df["rh_2"] = (
    100 - 5*(df.t2m - df.d2m)
)

df["rh_3"] = (
    100 * np.exp((gamma * beta * (df.d2m - df.t2m))/((gamma + df.t2m) * (gamma + df.d2m)))
)

#caluclate daily mean for each variable by date, lat, lon
df_summary = df.groupby(['date', 'latitude','longitude'])[['d2m', 't2m', 'i10fg', 'msdwswrf', 'sp', 'rh', 'rh_2', 'rh_3']].mean()
#print(df_summary)

#calculate daily min and max temperature
df_summary_tmin = df.groupby(['date', 'latitude','longitude'])[['t2m']].min()
df_summary_tmin = df_summary_tmin.rename(columns={"t2m": "tmin"})
#print(df_summary_tmin)

df_summary_tmax = df.groupby(['date', 'latitude','longitude'])[['t2m']].max()
df_summary_tmax = df_summary_tmax.rename(columns={"t2m": "tmax"})
#print(df_summary_tmax)

df_summary = df_summary.merge(df_summary_tmin, on=['date', 'latitude','longitude'])
df_summary = df_summary.merge(df_summary_tmax, on=['date', 'latitude','longitude'])

print(df_summary)

df_summary.describe().transpose()

#df_summary.to_csv('/raid/cuden/data/era5_precip_cape_cxp_2005-2010_dailySummaries.csv')
df_summary.to_csv('/raid/cuden/data/era5_d2m_t2m_i10fg_msdwswrf_sp_rh_2005-2010_dailySummaries.csv')
