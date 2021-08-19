with
 __dbt__CTE__stg_transactions_history_snapshot_model as (
with source_data as (
select * from "postgres"."mint"."transactions_history_snapshot"
)
select * from source_data
 where dbt_valid_to is  null
),  __dbt__CTE__stg_budget_model as (
with source_data as (
select * from "postgres"."mint"."budget"
)
select * from source_data
),trans as (select * from __dbt__CTE__stg_transactions_history_snapshot_model),
budget as (select * from __dbt__CTE__stg_budget_model)

select
row_number() over (partition by
				  (date_part('year',t.trans_date))
				   ,(date_part('month',t.trans_date))
				   ,t.category
				   order by
				  (date_part('year',t.trans_date)) desc
				   ,(date_part('month',t.trans_date)) desc
				   ,t.trans_date desc
				  ),
        t.trans_date,
        t.description,
        t.original_description,
        t.amount,
        t.transaction_type,
        t.category,
        t.account_name,
        t.labels,
        t.notes,
        t.recid
from trans t
    join budget b
        on t.category = b.category
        where b.invest = 1