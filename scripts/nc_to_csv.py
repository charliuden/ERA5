import xarray as xr
import numpy as np
import datetime as dt
import pandas as pd

#file_path = "/raid/cuden/data/era5_precip_CAPE_2005.nc"
#ds = xr.open_dataset(file_path)
#print(ds)

#df = ds[['cape','mtpr']].to_dataframe() #if you want to pick specific variables 
#df = ds.to_dataframe()
#print(df)

#df.to_csv('/raid/cuden/data/era5_2005.csv')

def loadEra5Data(file_path):
    ds = xr.open_dataset(file_path)
    df = ds.to_dataframe()
    return df 

df2005 = loadEra5Data("/raid/cuden/data/era5_precip_CAPE_2005.nc")
df2006 = loadEra5Data("/raid/cuden/data/era5_precip_CAPE_2006.nc")
df2007 = loadEra5Data("/raid/cuden/data/era5_precip_CAPE_2007.nc")
df2008 = loadEra5Data("/raid/cuden/data/era5_precip_CAPE_2008.nc")
df2009 = loadEra5Data("/raid/cuden/data/era5_precip_CAPE_2009.nc")
df2010 = loadEra5Data("/raid/cuden/data/era5_precip_CAPE_2010.nc")

df = pd.concat([df2005, df2006, df2007, df2008, df2009, df2010])

print(df)

df.to_csv('/raid/cuden/data/era5_precip_cape_2005-2010.csv')






