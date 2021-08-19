import pandas as pd
from datetime import datetime
import pytz
from resources import db_connect
import sqlalchemy

main = db_connect('main')


def insert_balance(balance,acct):
    dtypes = {"trans_date": sqlalchemy.Date()
              }

    u = datetime.utcnow()
    u = u.replace(tzinfo=pytz.utc)

    my_dict = {'balance': balance,
               'date': [u],
               'account':acct
               }

    balance = pd.DataFrame.from_dict(my_dict)

    balance.to_sql(name='balance',
                   con=main.engine
                   , schema='mint'
                   , if_exists='append'
                   , dtype=dtypes
                   , index=False)
    return balance


insert_balance(40160,'mint_combined')
insert_balance(19850,'business_checking')
insert_balance(20293 ,'personal_checking')
insert_balance(127282 ,'nwm_ira')
insert_balance(13468 ,'nwm_roth_ira')
insert_balance(15268 ,'nwm_individual')
insert_balance(890,'robinhood')
insert_balance(2737 ,'principal_roth_ira')
insert_balance(2563 ,'coinbase')



