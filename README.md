# ERA5
Scripts for downloading and processing ERA5 data

1. era5_5vars_netcdf.py OR era5_capeXprecip_netcdf.py - download ERA5 data to netcdf format
2. nc_to_csv.py - converts netcdf files to csv format
3. era5_daily_summaries.py - hourly to daily summaries
4. vaisalaLightning_to_era5_grid.R - calculate daily strike counts for each ERA5 grid cell
4. lightning_era5_merge.R - merge daily lightning counts with era5 data
5. era5_lightning_NEclip.R - clip data to the Northeast US
6. era5_monthly_summaries.R - daily to monthly summaries

### Varaibles
ERA5 hourly data are downloaded from: https://cds.climate.copernicus.eu/cdsapp#!/dataset/reanalysis-era5-single-levels?tab=form
The data area on a 0.25 degree by 0.25 degree rectangular grid (48, -80, 40, -66) from 2005-01-01 to 2010-12-31. 
Variables include:
- d2m: 2 metre dewpoint temperature in K
- t2m: 2 metre temperature in K
- i10fg: Instantaneous 10 metre wind gust in m s**-1
- msdwswrf: Mean surface downward short-wave radiation flux in W m**-2
- sp: Surface pressure in Pa
- cape: Convective available potential energy in J kg**-1
- mtpr: Mean total precipitation rate inkg m**-2 s**-1




