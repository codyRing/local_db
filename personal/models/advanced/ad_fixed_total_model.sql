with
d as (select * from {{ref('stg_d_date_model')}}),
bf as (select * from {{ref('inter_budget_fixed_model')}}),
t_one as(
		select
		d.first_day_of_month
		,sum(bf.amount)::decimal(18,2) as budget_fixed
		from d
			join bf
				on d.date_actual = bf.trans_date
		group by d.first_day_of_month
		)
select
first_day_of_month
,budget_fixed
,AVG(budget_fixed)
    OVER(order BY first_day_of_month ROWS BETWEEN 36 PRECEDING AND CURRENT ROW) ::decimal(18,2) as moving_avg
from t_one
order by first_day_of_month desc