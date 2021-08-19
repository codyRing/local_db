with source_data as (
select * from {{source('mint','budget')}}
)
select * from source_data