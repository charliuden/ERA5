#!/usr/bin/env python

from cdsapi import Client
from calendar import monthrange
    
def retrieveMonth(server, month, year):

  days = [format(x,'02d') for x in range(1, monthrange(year, month)[1]+1)]

  server.retrieve(
    'reanalysis-era5-single-levels',
    {
      'product_type' : 'reanalysis',
      'format'       : 'netcdf',
      'variable'     : ['2m_temperature', 'total_precipitation'],
      #'param'       : "1.228/3.228/7.228/8.128/8.228/9.128/9.228/10.228/11.228/12.228/13.228/14.228/21.228/22.228/23.228/24.228/26.128/32.128/33.128/39.128/40.128/41.128/42.128/44.128/45.128/49.128/50.128/59.128/66.128/67.128/129.128/129.228/130.228/134.128/136.128/137.128/139.128/141.128/142.128/143.128/144.128/146.128/147.128/151.128/164.128/165.128/166.128/167.128/168.128/169.128/170.128/172.128/175.128/176.128/177.128/178.128/179.128/180.128/181.128/182.128/183.128/186.128/187.128/188.128/195.128/196.128/197.128/198.128/201.128/202.128/205.128/208.128/209.128/210.128/211.128/212.128/213.128/218.228/219.228/220.228/221.228/226.228/227.228/228.128/235.128/236.128/238.128/239.128/240.128/243.128/244.128/245.128/246.228/247.228/251.228/260015",
      'year'         : str(year),
      'month'        : str(month),
      'day'          : days,
      #'date'         : '2016-07-01/to/2016-07-31',
      # When downloading data from the CDS, step does not need to be specified because data is selected according to the valid time, assuming steps from 1 to 12 hours.
      'time'        : ['00:00', '01:00', '02:00', '03:00', '04:00', '05:00', '06:00', '07:00', '08:00', '09:00', '10:00', '11:00',
                       '12:00', '13:00', '14:00', '15:00', '16:00', '17:00', '18:00', '19:00', '20:00', '21:00', '22:00', '23:00'],
      # For ECMWF, forecast variables are available at 06/18 UTC each day
      #'time'         : "06:00",
      # For ECMWF, forecast variables are accumulations and are hourly at the hour ending at the forecast step; Will give us hourly accumulations for a 24-hour period
      #'step'         : "0/1/2/3/4/5/6/7/8/9/10/11/12/13/14/15/16/17/18", 
      # N/W/S/E - extent of domain: NE US
      'area'         : [50, -82.5, 37.5, -65],
      # Grid spacing (degrees)
      'grid'         : [0.25, 0.25]
    }, 'era5_06zfcst_sfc_'+str(year)+'-'+'{:02d}'.format(month)+'.nc')

server = Client()
for month in range(7,8):
  retrieveMonth(server, month=month, year=2016)