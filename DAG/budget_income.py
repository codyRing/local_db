from resources import db_connect
import pandas as pd
import numpy as np
from datetime import datetime, timedelta
import seaborn as sns
import matplotlib.pyplot as plt
from dateutil.relativedelta import relativedelta
from scipy import stats
from functools import reduce

main = db_connect('main')
MthOrder = ['Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun', 'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec']

Transactions_D = pd.read_sql('select * from mint.inter_income_model'
                             , con=main.conn
                             , parse_dates=['trans_date']
                             , index_col='trans_date')


Monthly = pd.DataFrame(Transactions_D.resample('M')['amount'].sum())

Mu = Monthly.amount.mean()
Sigma = np.std(Monthly['amount'])

# how many standard Deviations away is each value
# (x-Mean)/Standard Deviation
# Monthly['Z_ScoreTest']=((Monthly['amount']-Mu)/Sigma)

Monthly['Z_Score'] = stats.zscore(Monthly['amount'])
Monthly['Target'] = Monthly['Z_Score'] < 0

print('Income Total Mean: {}\nIncome Total StandardDev:{}'.format(Mu, Sigma))
print(Monthly['Target'].value_counts())

fig, ax1 = plt.subplots(nrows=1, ncols=1, figsize=[14, 6])

sns.scatterplot(x=Monthly.index, y='Z_Score', data=Monthly, ax=ax1, hue='Target')
# sns.lineplot(x=Monthly.index, y=0, data=Monthly, ax=ax1, alpha=.5, color='Green')

ax1.set_xlim(Monthly.index.min(), Monthly.index.max())
ax1.set_title('Income Z Scores')
plt.savefig('./Images/Monthly_Income_Z_{}.png'.format(datetime.now().strftime("%Y%m%d")), dpi=300)

# Pare down transactions to next month - 1 year

d = datetime.today() + pd.offsets.MonthBegin(1)
d = d - relativedelta(years=1)

Discretionary = Transactions_D.loc[Transactions_D.index >= d]

new_datetime_range = pd.date_range(start=Discretionary.index.min(), end=datetime.today(), freq="D")

Discretionary_Matrix = Discretionary.resample('D').sum().reindex(new_datetime_range, fill_value=0)
Discretionary_Matrix = pd.pivot_table(Discretionary_Matrix
                                      , index=Discretionary_Matrix.index.day
                                      , columns=Discretionary_Matrix.index.strftime('%b')
                                      , values="amount"
                                      )

Discretionary_Matrix = Discretionary_Matrix.cumsum()
Discretionary_Matrix.sort_index(level=0, ascending=False, inplace=True)
Discretionary_Matrix = Discretionary_Matrix.reindex(columns=MthOrder)

fig, ax = plt.subplots(nrows=1, ncols=1, figsize=[14, 7])
sns.heatmap(Discretionary_Matrix,
            annot=True,
            annot_kws={"size": 7},
            vmin=500,
            vmax=3000,
            fmt="g",
            linewidths=.5,
            cbar=False,
            cmap="Blues",
            ax=ax)
plt.title('Income')
ax.set_xlabel('Month')
ax.set_ylabel('Day')
plt.savefig('./Images/Daily_Income_Heat_{}.png'.format(datetime.now().strftime("%Y%m%d")), dpi=300)

Discretionary_Matrix_z = Discretionary_Matrix.apply(lambda x: (x - Mu) / Sigma)

fig, ax = plt.subplots(nrows=1, ncols=1, figsize=[14, 7])
sns.heatmap(Discretionary_Matrix_z,
            annot=True,
            annot_kws={"size": 7},
            vmin=-3,
            vmax=-.1,
            fmt="g",
            linewidths=.5,
            cbar=False,
            cmap="Blues",
            ax=ax)
plt.title('Income')
ax.set_xlabel('Month')
ax.set_ylabel('Day')
plt.savefig('./Images/Daily_Income_Heat_Z_{}.png'.format(datetime.now().strftime("%Y%m%d")), dpi=300)
