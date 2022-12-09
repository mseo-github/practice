{%- set yaml_metadata -%}
source_model:
  sample_dataset: orders
derived_columns:
  RECORD_SOURCE: '!orders'
hashed_columns:
  ORDER_HASHDIFF:
    is_hashdiff: true
    columns:
      - 'ID'
      - 'TOTAL'
      - 'QUANTITY'
      - 'CREATED_AT'
      - 'UPDATED_AT'
  ORDER_HK:
    - 'ID'
  USER_HK:
    - 'USER_ID'
  PRODUCT_HK:
    - 'PRODUCT_ID'
  ORDER_USER_HK:
    - 'ID'
    - 'USER_ID'
  ORDER_PRODUCT_HK:
    - 'ID'
    - 'PRODUCT_ID'
{%- endset -%}

{% set metadata_dict = fromyaml(yaml_metadata) %}

{% set source_model = metadata_dict['source_model'] %}

{% set derived_columns = metadata_dict['derived_columns'] %}

{% set hashed_columns = metadata_dict['hashed_columns'] %}

WITH staging AS (
{{ dbtvault.stage(include_source_columns=true,
                  source_model=source_model,
                  derived_columns=derived_columns,
                  hashed_columns=hashed_columns,
                  ranked_columns=none) }}
)

SELECT *,
       TO_DATE('{{ var('load_date') }}') AS LOAD_DATETIME
FROM staging
