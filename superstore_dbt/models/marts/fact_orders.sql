--models/marts/fact_orders.sql


{{ config(materialized='table') }}

SELECT
    o.order_row_id,
    o.order_id,
    o.order_date,
    o.ship_date,
    o.quantity,
    o.sales,
    o.profit,
    o.discount,
    o.shipping_cost,

    -- dim_customer
    c.customer_id,

    -- dim_product
    p.product_id,

    -- dim_location
    l.location_id


FROM {{ ref('stg_orders') }} o
LEFT JOIN {{ ref('dim_customer') }} c ON o.customer_id = c.customer_id
LEFT JOIN {{ ref('dim_product') }} p ON o.product_id = p.product_id
LEFT JOIN {{ ref('dim_location') }} l ON o.city = l.city AND o.state = l.state AND o.region = l.region AND o.country = l.country