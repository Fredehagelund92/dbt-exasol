{% macro default__snapshot_merge_sql(target, source, insert_cols) -%}
    {%- set insert_cols_csv = insert_cols | join(', ') -%}

    merge into {{ target | upper }} as DBT_INTERNAL_DEST
    using {{ source |upper }} as DBT_INTERNAL_SOURCE
    on DBT_INTERNAL_SOURCE.dbt_scd_id = DBT_INTERNAL_DEST.dbt_scd_id

    when matched
     --and DBT_INTERNAL_DEST.dbt_valid_to is null
     --and DBT_INTERNAL_SOURCE.dbt_change_type = 'update'
        then update
        set dbt_valid_to = DBT_INTERNAL_SOURCE.dbt_valid_to

    when not matched
     --and DBT_INTERNAL_SOURCE.dbt_change_type = 'insert'
        then insert ({{ insert_cols_csv |upper }})
        values ({{ insert_cols_csv | upper}})
    ;
{% endmacro %}