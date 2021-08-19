
  create view "postgres"."mint"."stg_transactions_model__dbt_tmp" as (
    with source_data as (
select * from "postgres"."mint"."transactions"
)
select * from source_data
  );
