#!/usr/bin/env python

from ecmwfapi import ECMWFDataServer
    
server = ECMWFDataServer()
    
server.retrieve({
    'dataset'   : "era5", 
    'stream'    : "oper",
    'class'     : "ea",
    'expver'    : "1",
    'type'      : "fc",
    'levtype'   : "sfc",                            #Level where data is collected
    'param'     : "1.228/3.228/8.128/9.128/21.228/22.228/23.228/24.228/34.128/44.128/45.128/49.128/50.128/59.128/66.128/67.128/129.228/130.228/134.128/136.128/137.128/142.128/143.128/144.128/146.128/147.128/164.128/165.128/166.128/167.128/168.128/169.128/175.128/176.128/177.128/178.128/179.128/180.128/181.128/182.128/186.128/187.128/188.128/195.128/196.128/197.128/201.128/202.128/205.128/208.128/209.128/210.128/211.128/212.128/213.128/218.228/219.228/220.228/221.228/226.228/227.228/228.128/238.128/239.128/240.128/243.128/244.128/245.128/251.228/260015",   #Parameters to be collected (in coded form)
    'date'      : "2016-07-01/to/2016-12-31",                  
    'time'      : "06:00:00",                          #Forecast variables are available at 06/18 UTC each day   
    'step'      : "0/1/2/3/4/5/6/7/8/9/10/11/12/13/14/15/16/17/18",                   #Forecast variables are accumulations and are hourly at the hour ending at the forecast step; Will give us hourly accumulations for a 24-hour period 
    'area'      : "50/-82.5/37.5/-65",              #N/W/S/E - extent of domain: NE US
    'grid'      : "0.3/0.3",                        #Grid spacing (degrees)
    'target'    : "era5_06zfcst_sfc_2016-07-01_2016-12-31.nc",
    'format'    : "netcdf"
 })
