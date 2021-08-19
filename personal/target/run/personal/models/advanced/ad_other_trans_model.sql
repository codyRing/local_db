
  create view "postgres"."mint"."ad_other_trans_model__dbt_tmp" as (
    with
 __dbt__CTE__stg_transactions_history_snapshot_model as (
with source_data as (
select * from "postgres"."mint"."transactions_history_snapshot"
)
select * from source_data
 where dbt_valid_to is  null
),hist as (select * from __dbt__CTE__stg_transactions_history_snapshot_model),
bf as (select * from "postgres"."mint"."inter_budget_fixed_model"),
bd as (select * from "postgres"."mint"."inter_budget_discretionary_model"),
i  as (select * from "postgres"."mint"."inter_income_model"),
fa as (select * from "postgres"."mint"."inter_fa_model")

select
row_number() over (partition by hist.category order by hist.trans_date desc),
hist.*

from hist
    left join bf
        on hist.recid = bf.recid
    left join bd
        on hist.recid = bd.recid
    left join i
        on hist.recid = i.recid
    left join fa
        on hist.recid = fa.recid
where (bf.recid is null and bd.recid is null and i.recid is null and fa.recid is null)
and hist.category not in ('Credit Card Payment')

and hist.trans_date >='1/1/2019'
  );
