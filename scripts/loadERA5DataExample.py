from loadERA5Data import *

test = loadERA5VariablesByYears(['t','v'], [1982])
# Multiple years (Last year is NOT included)
# data = loadERA5VariablesByYears(['t','v'], range(1982, 1984))
t_data = test['t']

print(test['date'])
print(test['t'][1:5])
print(t_data[1:5])   # Same as previous line
print(test.keys())
print(test['t'].shape)

'''
test = loadERA5VariablesByMonth(['t','v'], 1, 1980)
print(test.keys())
print(test['date'][1:10])
print(test['t'][1:5])
print(test['t'].shape)
'''