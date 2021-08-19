
  create view "postgres"."mint"."ad_discretionary_total_model__dbt_tmp" as (
    with
 __dbt__CTE__stg_d_date_model as (
with source_data as (
select * from "postgres"."mint"."d_date"
)
select * from source_data
),d as (select * from __dbt__CTE__stg_d_date_model),
bd as (select * from "postgres"."mint"."inter_budget_discretionary_model"),
t_one as(
		select
		d.first_day_of_month
		,sum(bd.amount)::decimal(18,2) as budget_discretionary
		from d
			join bd
				on d.date_actual = bd.trans_date
		group by d.first_day_of_month
		)
select
first_day_of_month
,budget_discretionary
,AVG(budget_discretionary)
    OVER(order BY first_day_of_month ROWS BETWEEN 36 PRECEDING AND CURRENT ROW) ::decimal(18,2) as moving_avg
from t_one
order by first_day_of_month desc
  );
