select mint.insert_new_tran()
select mint.insert_category();
select mint.insert_description();
select mint.insert_orig_description();
select mint.insert_notes();

 Truncate table mint.transactions;
 Truncate table mint.transactions_history;
 Truncate table mint.transactions_history_snapshot;

 dbt seed -s transactions
 select mint.insert_new_tran();

dbt snapshot -s transactions_history_snapshot





select * from mint.transactions_history_snapshot
where dbt_valid_to is not null
order by trans_date desc

--"date","description","original_description","amount","transaction_type","category","account_name","labels","notes"


Select
row_number() over (partition by category order by date_trunc('month',trans_date)desc ) as indx,
date_trunc('month',trans_date),category,sum(amount)::decimal(18,2)
from mint.inter_budget_discretionary_model
		where trans_date >= date_trunc('day', NOW() - interval '6 month')
group by date_trunc('month',trans_date),category




;with base as  (
	select
i.trans_date
,d.day_name
,i.amount
,case
	when lower(original_description) like '%tek%'
		then 'TEK'
	when lower(original_description) like '%vimo%'
		then 'VIMO'
end as srce
,i.recid
from mint.inter_income_model i
	join mint.d_date d
		on i.trans_date = d.date_actual
where category like 'Paycheck'
and trans_date >= '1/1/2021'
-- order by trans_date asc
	)
select srce, sum(amount),sum(amount)*100 /sum(sum(amount)) over ()::decimal(18,2) as income_pct

from base
group by srce