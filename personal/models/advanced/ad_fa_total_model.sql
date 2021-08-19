with
d as (select * from {{ref('stg_d_date_model')}}),
i as (select * from {{ref('inter_fa_model')}}),
t_one as(
		select
		d.first_day_of_month
		,sum(i.amount)::decimal(18,2) as invest
		from d
			join i
				on d.date_actual = i.trans_date
		group by d.first_day_of_month
		)
select
first_day_of_month
,invest
,AVG(invest)
    OVER(order BY first_day_of_month ROWS BETWEEN 36 PRECEDING AND CURRENT ROW) ::decimal(18,2) as moving_avg
from t_one
order by first_day_of_month desc