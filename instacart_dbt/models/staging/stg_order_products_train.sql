with source as (

    select * 
    FROM {{ source('instacart_raw', 'order_products_train') }}

),

renamed as (

    select
        order_id,
        product_id,
        add_to_cart_order,
        cast(reordered as boolean) as was_reordered
    from source

)

select * from renamed
