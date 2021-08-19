
      update "postgres"."mint"."transactions_history_snapshot"
    set dbt_valid_to = DBT_INTERNAL_SOURCE.dbt_valid_to
    from "transactions_history_snapshot__dbt_tmp20210817180508701017" as DBT_INTERNAL_SOURCE
    where DBT_INTERNAL_SOURCE.dbt_scd_id::text = "postgres"."mint"."transactions_history_snapshot".dbt_scd_id::text
      and DBT_INTERNAL_SOURCE.dbt_change_type::text = 'update'::text
      and "postgres"."mint"."transactions_history_snapshot".dbt_valid_to is null;

    insert into "postgres"."mint"."transactions_history_snapshot" ("trans_date", "description", "original_description", "amount", "transaction_type", "category", "account_name", "labels", "notes", "recid", "start_date", "dbt_updated_at", "dbt_valid_from", "dbt_valid_to", "dbt_scd_id")
    select DBT_INTERNAL_SOURCE."trans_date",DBT_INTERNAL_SOURCE."description",DBT_INTERNAL_SOURCE."original_description",DBT_INTERNAL_SOURCE."amount",DBT_INTERNAL_SOURCE."transaction_type",DBT_INTERNAL_SOURCE."category",DBT_INTERNAL_SOURCE."account_name",DBT_INTERNAL_SOURCE."labels",DBT_INTERNAL_SOURCE."notes",DBT_INTERNAL_SOURCE."recid",DBT_INTERNAL_SOURCE."start_date",DBT_INTERNAL_SOURCE."dbt_updated_at",DBT_INTERNAL_SOURCE."dbt_valid_from",DBT_INTERNAL_SOURCE."dbt_valid_to",DBT_INTERNAL_SOURCE."dbt_scd_id"
    from "transactions_history_snapshot__dbt_tmp20210817180508701017" as DBT_INTERNAL_SOURCE
    where DBT_INTERNAL_SOURCE.dbt_change_type::text = 'insert'::text;

  