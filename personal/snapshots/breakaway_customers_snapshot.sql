{% snapshot breakaway_customers_snapshot %}

{{
    config(
      target_database='postgres',
      target_schema='breakaway',
      unique_key='constituent_id',

      strategy='timestamp',
      updated_at='modified',
    )
}}

select * from {{ source('breakaway', 'breakaway_customers') }}

{% endsnapshot %}