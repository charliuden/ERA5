# ERA5
Scripts for downloading and processing ERA5 data

1. era5_5vars_netcdf.py OR era5_capeXprecip_netcdf.py - download ERA5 data to netcdf format
2. nc_to_csv.py - converts netcdf files to csv format
3. era5_daily_summaries.py - hourly to daily summaries
4. vaisalaLightning_to_era5_grid.R - calculate daily strike counts for each ERA5 grid cell
4. lightning_era5_merge.R - merge daily lightning counts with era5 data
5. era5_lightning_NEclip.R - clip data to the Northeast US
6. era5_monthly_summaries.R - daily to monthly summaries