#!/usr/bin/env python

from cdsapi import Client
from calendar import monthrange
from multiprocessing import Pool


def retrieveYear(serv_year_tup):

  year = serv_year_tup[1]
  serv_year_tup[0].retrieve(
    'reanalysis-era5-single-levels',
    {
      'product_type' : 'reanalysis',
      'format'       : 'netcdf',
      'variable'     : [
        '2m_temperature',
        'total_precipitation',
        'snowfall',
        '10m_u_component_of_wind',
        '10m_v_component_of_wind',
        # No relative_humidity variable
        '2m_dewpoint_temperature',
	'surface_pressure',
        #'mean_surface_downward_short_wave_radiation_flux',
        'surface_solar_radiation_downwards',
        'total_cloud_cover',
        'surface_thermal_radiation_downwards',
        'surface_net_thermal_radiation',
        #'mean_surface_downward_long_wave_radiation_flux',
        #'mean_surface_net_long_wave_radiation_flux',
        'evaporation',
        ],
      'year'         : str(year),
      'month'        : [f'{month:02d}' for month in range(1,13)],
      'day'          : [f'{day:02d}' for day in range(1,32)],
      #'date'         : '2016-07-01/to/2016-07-31',
      # When downloading data from the CDS, step does not need to be specified because data is selected according to the valid time, assuming steps from 1 to 12 hours.
      'time'        : [f'{hour:02d}:00' for hour in range(24)],
      # For ECMWF, forecast variables are available at 06/18 UTC each day
      #'time'         : "06:00",
      # N/W/S/E - extent of domain: NE US
      'area'         : [50, -82.5, 37.5, -65],
      # Grid spacing (degrees)
      # [0.25, 0.25] is default?
      #'grid'         : [0.25, 0.25]
    }, f'/epscorfs/data/ERA5/iam_climate/era5_iam_climate_{year}.nc')

def main():
  server = Client()
  years = list(range(1999,2001))
  arg = [(server, year) for year in years]
  # change to 3 parallel???
  with Pool(4) as pool:
    pool.map(retrieveYear, arg)
  # for year in range(2002, 2004):
  #   retrieveYear(server, year=year)

if __name__ == '__main__':
  main()
