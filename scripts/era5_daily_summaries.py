import pandas as pd

#-- get mean values --

#df = pd.read_csv('/raid/cuden/data/era5_precip_cape_2005-2010.csv')
df = pd.read_csv('/raid/cuden/data/era5_hourly_d2m_t2m_i10fg_msdwswrf_sp_2005-2010.csv')
#print(df)

df['time'] = pd.to_datetime(df['time'])
print(df.info)
#print(df['time'])

# function to extract date
def extract_date(dt):
    return dt.date()

# Apply function to 'datetime' column
df['date'] = df['time'].apply(extract_date)
#print(df.info)

#caluclate daily mean for each variable by date, lat, lon
df_summary = df.groupby(['date', 'latitude','longitude'])[['d2m', 't2m', 'i10fg', 'msdwswrf', 'sp']].mean()
print(df_summary)

#calculate daily min and max temperature
df_summary_tmin = df.groupby(['date', 'latitude','longitude'])[['t2m']].min()
df_summary_tmin = df_summary_tmin.rename(columns={"t2m": "tmin"})
print(df_summary_tmin)

df_summary_tmax = df.groupby(['date', 'latitude','longitude'])[['t2m']].max()
df_summary_tmax = df_summary_tmax.rename(columns={"t2m": "tmax"})
print(df_summary_tmax)

df_summary = df_summary.merge(df_summary_tmin, on=['date', 'latitude','longitude'])
df_summary = df_summary.merge(df_summary_tmax, on=['date', 'latitude','longitude'])

print(df_summary)

#df_summary.to_csv('/raid/cuden/data/era5_cape_precip_2005-2010_dailyMeans.csv')
df_summary.to_csv('/raid/cuden/data/era5_d2m_t2m_i10fg_msdwswrf_sp_2005-2010_dailySummaries.csv')
