{{ config(
    materialized="view",
    tags=["staging"]
) }}

-- STEP 1: Pull the raw data
with source as (
    select
        product_id,
        product_name,
        aisle_id,
        department_id
    from {{ source('instacart_raw', 'products') }}
),

-- STEP 2: Clean product name casing/spacing
cleaned as (
    select
        product_id,
        lower(trim(product_name)) as product_name,
        aisle_id,
        department_id
    from source
)

select * from cleaned

