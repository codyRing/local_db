with
dte as (select distinct first_day_of_month from {{ source('mint', 'd_date') }} where year_actual between 2015 and 2021),
f as (select * from {{ref('ad_fixed_total_model')}}),
d as (select * from {{ref('ad_discretionary_total_model')}}),
i as (select * from {{ref('ad_income_total_model')}}),
fa as (select * from {{ref('ad_fa_total_model')}})

select
dte.first_day_of_month
,i.income
,i.moving_avg as income_moving
,d.budget_discretionary
,d.moving_avg as discretionary_moving
,f.budget_fixed
,f.moving_avg as fixed_moving
,(i.income-d.budget_discretionary-f.budget_fixed) as bottom_line
,(i.moving_avg-d.moving_avg-f.moving_avg) as bottom_line_avg
,fa.invest
,f.moving_avg as invest_moving

from dte
	left join i
		on i.first_day_of_month =dte.first_day_of_month

	left join  d
		on d.first_day_of_month = dte.first_day_of_month

	left join  f
		on f.first_day_of_month = dte.first_day_of_month

	left join  fa
		on fa.first_day_of_month = dte.first_day_of_month

order by dte.first_day_of_month desc