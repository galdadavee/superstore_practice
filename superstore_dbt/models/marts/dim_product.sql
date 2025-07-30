-- models/marts/dim_product.sql

{{ config(materialized='table') }}

SELECT
    product_id,
    product_name,
    sub_category,
    category
FROM {{ ref('stg_products') }}