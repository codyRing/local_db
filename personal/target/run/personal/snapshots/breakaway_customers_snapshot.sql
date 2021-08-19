
      update "postgres"."breakaway"."breakaway_customers_snapshot"
    set dbt_valid_to = DBT_INTERNAL_SOURCE.dbt_valid_to
    from "breakaway_customers_snapshot__dbt_tmp20210512184823963269" as DBT_INTERNAL_SOURCE
    where DBT_INTERNAL_SOURCE.dbt_scd_id::text = "postgres"."breakaway"."breakaway_customers_snapshot".dbt_scd_id::text
      and DBT_INTERNAL_SOURCE.dbt_change_type::text = 'update'::text
      and "postgres"."breakaway"."breakaway_customers_snapshot".dbt_valid_to is null;

    insert into "postgres"."breakaway"."breakaway_customers_snapshot" ("External ID", "constituent_id", "First Name", "Last Name", "Spouse First Name", "Spouse Last Name", "Address Line 1", "City", "State", "Postal Code", "Personal Email", "Personal Phone", "Custom Field - Contact", "Custom Field - Company Name", "custom_original_name", "modified", "dbt_updated_at", "dbt_valid_from", "dbt_valid_to", "dbt_scd_id")
    select DBT_INTERNAL_SOURCE."External ID",DBT_INTERNAL_SOURCE."constituent_id",DBT_INTERNAL_SOURCE."First Name",DBT_INTERNAL_SOURCE."Last Name",DBT_INTERNAL_SOURCE."Spouse First Name",DBT_INTERNAL_SOURCE."Spouse Last Name",DBT_INTERNAL_SOURCE."Address Line 1",DBT_INTERNAL_SOURCE."City",DBT_INTERNAL_SOURCE."State",DBT_INTERNAL_SOURCE."Postal Code",DBT_INTERNAL_SOURCE."Personal Email",DBT_INTERNAL_SOURCE."Personal Phone",DBT_INTERNAL_SOURCE."Custom Field - Contact",DBT_INTERNAL_SOURCE."Custom Field - Company Name",DBT_INTERNAL_SOURCE."custom_original_name",DBT_INTERNAL_SOURCE."modified",DBT_INTERNAL_SOURCE."dbt_updated_at",DBT_INTERNAL_SOURCE."dbt_valid_from",DBT_INTERNAL_SOURCE."dbt_valid_to",DBT_INTERNAL_SOURCE."dbt_scd_id"
    from "breakaway_customers_snapshot__dbt_tmp20210512184823963269" as DBT_INTERNAL_SOURCE
    where DBT_INTERNAL_SOURCE.dbt_change_type::text = 'insert'::text;

  