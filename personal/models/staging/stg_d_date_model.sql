

with source_data as (
select * from {{source('mint','d_date')}}
)
select * from source_data