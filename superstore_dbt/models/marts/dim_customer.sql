-- models/marts/dim_customer.sql

{{ config(materialized='table') }}

SELECT
    customer_id,
    customer_name,
    segment
FROM {{ ref('stg_customers') }}