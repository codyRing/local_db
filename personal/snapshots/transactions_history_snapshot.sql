{% snapshot transactions_history_snapshot %}

{{
    config(
      target_database='postgres',
      target_schema='mint',
      unique_key='recid',

      strategy='timestamp',
      updated_at='start_date',
    )
}}

select * from {{ source('mint', 'transactions_history') }}

{% endsnapshot %}