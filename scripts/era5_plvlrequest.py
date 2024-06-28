#!/usr/bin/env python

from ecmwfapi import ECMWFDataServer
    
server = ECMWFDataServer()
    
server.retrieve({
    'dataset'   : "era5", 
    'stream'    : "oper",
    'class'     : "ea",
    'expver'    : "1",
    'type'      : "an",
    'levtype'   : "pl",                            #Level where data is collected
    'levelist'  : "950/925/850/700/600/500/300/250",
    'param'     : "130.128/131.128/132.128/129.128/157.128/138.128/133.128/155.128/248.128/203.128/60.128/247.128/246.128/75.128/76.128/135.128",   #Parameters to be collected (in coded form)
    'date'      : "2014-07-01/to/2014-12-31",                  
    'time'      : "00:00:00/01:00:00/02:00:00/03:00:00/04:00:00/05:00:00/06:00:00/07:00:00/08:00:00/09:00:00/10:00:00/11:00:00/12:00:00/13:00:00/14:00:00/15:00:00/16:00:00/17:00:00/18:00:00/19:00:00/20:00:00/21:00:00/22:00:00/23:00:00",                          #Analysis variables are available at 06/18 UTC each day   
    'step'      : "1/to/12/by/1",                   #Forecast variables are accumulations and are hourly at the hour ending at the forecast step; Will give us hourly accumulations for a 24-hour period 
    'area'      : "50/-82.5/37.5/-65",              #N/W/S/E - extent of domain: NE US
    'grid'      : "0.3/0.3",                        #Grid spacing (degrees)
    'target'    : "era5_plvl_2014-07-01_2014-12-31.nc",
    'format'    : "netcdf"
 })
