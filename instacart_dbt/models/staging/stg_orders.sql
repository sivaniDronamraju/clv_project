{{ config(
    materialized='view',
    tags=['staging']
) }}

-- STEP 1: Pull the raw data
with source as (
    select *
    from {{ source('instacart_raw', 'orders') }}
),

-- STEP 2: Rename + cast
renamed as (
    select
        -- Primary key and customer ID
        order_id,
        user_id as customer_id,

        -- Order sequence number
        order_number,

        -- Day of week (0=Sunday ... 6=Saturday)
        order_dow as order_day_of_week,

        -- Hour of day (0–23)
        order_hour_of_day,

        -- Nullable, number of days since last order
        CAST(days_since_prior_order AS FLOAT64) as days_since_prior_order

    from source
),

-- STEP 3: Optional derived field — create a fake timestamp
-- Based on assumption that earliest order is from "day 0"
-- You can skip this in later model if no date field exists
derived as (
    select *,
        DATETIME(
  DATE_ADD(DATE '2020-01-01', INTERVAL order_number DAY),
  TIME(order_hour_of_day, 0, 0)
) as order_ts

    from renamed
)

select * from derived
