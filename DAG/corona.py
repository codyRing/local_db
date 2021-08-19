import pandas as pd
from resources import db_connect
main = db_connect('main')

states = pd.read_csv('https://raw.githubusercontent.com/nytimes/covid-19-data/master/us-states.csv'
                  , parse_dates=['date']
                  , index_col='date'
                  ,if_exists = 'replace')  # index_col='date'v

print(len(states))

states.to_sql(name='states', con=main.engine,schema='corona',chunksize=500)

# counties = pd.read_csv('https://raw.githubusercontent.com/nytimes/covid-19-data/master/us-counties.csv'
#                   , parse_dates=['date']
#                   , index_col='date')  # index_col='date'
#
# counties.to_sql(name='counties', con=main.engine,schema='corona')