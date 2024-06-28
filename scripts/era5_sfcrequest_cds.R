### Must be run on epscor-pascal - epscor-babbage doesn't have required libraries

library(ecmwfr)

wf_set_key(user="29459",
           key="d8b76712-820d-4b57-b6f4-d4b1ff3caf92",
           service= "cds")

for (i in 1979:2018){
  
  request <- list(
    product_type = "reanalysis",
    format = "netcdf",
    variable = "total_precipitation",
    year = as.character(i),
    month = c("01", "02", "03", "04", "05", "06", "07", "08", "09", "10", "11", "12"),
    day = c("01", "02", "03", "04", "05", "06", "07", "08", "09", "10", "11", "12", "13", "14", "15", "16", "17", "18", "19", "20", "21", "22", "23", "24", "25", "26", "27", "28", "29", "30", "31"),
    time = c("00:00", "01:00", "02:00", "03:00", "04:00", "05:00", "06:00", "07:00", "08:00", "09:00", "10:00", "11:00", "12:00", "13:00", "14:00", "15:00", "16:00", "17:00", "18:00", "19:00", "20:00", "21:00", "22:00", "23:00"),
    area = "45.500/-73.25/44.5/-72.00", #"45.41/-73.25/44.65/-72.20", max-lat/min-lon/min-lat/max-lon
    dataset = "reanalysis-era5-single-levels",
    target = paste0("ERA5-single-levels_", i ,"_tp.nc")
  )
  
  # -73.24583 -72.23750  44.65417  45.40417
  
  assign(paste0("ERA5-single-levels_", i ,"_tp.nc"),
         wf_request(user = "29459",
                    request = request,   
                    transfer = TRUE,  
                    path = "/raid/ERA5",
                    verbose = FALSE)
  )
}
