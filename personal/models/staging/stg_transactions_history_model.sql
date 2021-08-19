with source_data as (
select * from {{source('mint','transactions_history')}}
)
select * from source_data