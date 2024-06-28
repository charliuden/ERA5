import cdsapi

c = cdsapi.Client()

c.retrieve(
    'reanalysis-era5-single-levels',
    {
        'product_type': 'reanalysis',
        'format': 'netcdf',
        'variable': [
            '2m_dewpoint_temperature', '2m_temperature', 'convective_available_potential_energy',
            'instantaneous_10m_wind_gust', 'mean_surface_downward_short_wave_radiation_flux', 'mean_total_precipitation_rate',
            'surface_pressure',
        ],
        'year': '2005',
        'month': [
            '01', '02', '03',
            '04', '05', '06',
            '07', '08', '09',
            '10', '11', '12',
        ],
        'day': [
            '01', '02', '03',
            '04', '05', '06',
            '07', '08', '09',
            '10', '11', '12',
            '13', '14', '15',
            '16', '17', '18',
            '19', '20', '21',
            '22', '23', '24',
            '25', '26', '27',
            '28', '29', '30',
            '31',
        ],
        'area': [
            48, -80, 40,
            -66,
        ],
        'time': [
            '00:00', '12:00',
        ],
    },
    'download.nc')