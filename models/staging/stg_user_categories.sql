{%- set yaml_metadata -%}
source_model:
  sample_dataset: user_categories
derived_columns:
  RECORD_SOURCE: '!user_categories'
hashed_columns:
  USER_CATEGORY_HASHDIFF:
    is_hashdiff: true
    columns:
      - 'SLOT'
      - 'CREATED_AT'
      - 'UPDATED_AT'
  USER_CATEGORY_HK:
    - 'USER_ID'
    - 'CATEGORY_ID'
  USER_HK:
    - 'USER_ID'
  CATEGORY_HK:
    - 'CATEGORY_ID'
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
