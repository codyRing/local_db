with source_data as (
select * from "postgres"."mint"."transactions_history"
)
select * from source_data