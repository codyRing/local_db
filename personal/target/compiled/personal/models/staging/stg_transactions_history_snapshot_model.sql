with source_data as (
select * from "postgres"."mint"."transactions_history_snapshot"
)
select * from source_data
 where dbt_valid_to is  null