library(ncdf4)

nc <- nc_open('era5_06zfcst_sfc_2016-07.nc')
data <- ncvar_get(nc, varid='t2m')
print(sum(data))
