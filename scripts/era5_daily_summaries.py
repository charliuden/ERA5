import pandas as pd

#-- get mean values --

df = pd.read_csv('/raid/cuden/data/era5_precip_cape_2005-2010.csv')
#print(df)

df['time'] = pd.to_datetime(df['time'])
#print(df.info)
#print(df['time'])

# Define a custom function to extract date
def extract_date(dt):
    return dt.date()

# Apply the custom function to the 'datetime' column
df['date'] = df['time'].apply(extract_date)
#print(df.info)

#caluclate mean cape and precip by date, lat, lon
df_summary = df.groupby(['date', 'latitude','longitude'])[['cape', 'mtpr']].mean()
print(df_summary)

df_summary.to_csv('/raid/cuden/data/era5_cape_precip_2005-2010_dailyMeans.csv')


