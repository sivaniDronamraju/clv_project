{{ config(
    materialized='view',
    tags=['staging']
) }}

-- STEP 1: Read from the raw source
with source as (
    select *
    from {{ source('instacart_raw', 'order_products_prior') }}
),

-- STEP 2: Clean and rename
renamed as (
    select
        order_id,
        product_id,
        add_to_cart_order,
        CAST(reordered AS BOOLEAN) as was_reordered

    from source
)

select * from renamed
