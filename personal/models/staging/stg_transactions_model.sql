

with source_data as (
select * from {{source('mint','transactions')}}
)
select * from source_data