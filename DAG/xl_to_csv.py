import pandas as pd
import csv
import datetime
xl = pd.read_excel('C:/Users/User/Source/local_db/personal/data/breakaway/breakaway_customers_excel.XLSX')
xl = xl.replace(r'\n',' ', regex=True)

xl['modified'] = datetime.datetime.now(datetime.timezone.utc)
xl = xl.rename(columns={'Constituent ID': 'constituent_id',
                        'Custom Field - Original Name':'custom_original_name'})

print(xl.columns)

xl.to_csv('C:/Users/User/Source/local_db/personal/data/breakaway/breakaway_customers.csv'
          , quoting=csv.QUOTE_ALL
          ,index=False
          )