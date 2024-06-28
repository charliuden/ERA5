import netCDF4 as nc
import os
import pandas as pd
import numpy


def loadERA5VariableDataFrameByMonth(variables, month, year):
	src_path = "/epscorfs/data/ERA5/plevel_data/Qtr_deg/full_plevel"
	ds = nc.MFDataset([
		os.path.join(src_path, "era5_06zfcst_plevel_{}-{:02d}.nc".format(str(year), month)),
		os.path.join(src_path, "era5_11dayno11hr_plevel_{}-{:02d}.nc".format(str(year), month)),
		os.path.join(src_path, "era5_11hr_plevel_{}-{:02d}.nc".format(str(year), month))],
		aggdim='time')
	
	time = ds.variables['time']
	dates = nc.num2date(time[:], time.units, time.calendar)
	
	df = pd.DataFrame(dates, columns=['date'])
	
	for var in variables:
		df[var] = [x for x in ds.variables[var][:][:][:][:]]
		
	ds.close()	
	
	return df


def loadERA5VariablesByMonth(variables, month, year):
	src_path = "/epscorfs/data/ERA5/plevel_data/Qtr_deg/full_plevel"
	ds = nc.MFDataset([
		os.path.join(src_path, "era5_06zfcst_plevel_{}-{:02d}.nc".format(str(year), month)),
		os.path.join(src_path, "era5_11dayno11hr_plevel_{}-{:02d}.nc".format(str(year), month)),
		os.path.join(src_path, "era5_11hr_plevel_{}-{:02d}.nc".format(str(year), month))],
		aggdim='time')
	
	time = ds.variables['time']
	dates = nc.num2date(time[:], time.units, time.calendar)
	
	returnVal = dict()
	returnVal['date'] = dates
	
	for var in variables:
		print("Retrieving {} for {:02d}/{}...".format(var, month, year))
		returnVal[var] = ds.variables[var][:]
		
	ds.close()	
	
	return returnVal


def appendData(var, origDict, newDict):
	if var in origDict.keys():
		returnVal = numpy.concatenate([origDict[var], newDict[var]])
	else:
		returnVal = newDict[var]
	return returnVal

	
def loadERA5VariablesByYears(variables, years):
	returnVal = dict()
	for year in years:
		for month in range(1,13):
			monthData = loadERA5VariablesByMonth(variables, month, year)
			for var in monthData.keys():
				returnVal[var] = appendData(var, returnVal, monthData)
				
	return returnVal
