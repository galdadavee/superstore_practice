-- models/staging/stg_customers.sql

SELECT
    DISTINCT
    "CustomerID"   AS customer_id,
    "CustomerName" AS customer_name,
    "Segment"      AS segment
FROM {{ source('raw_superstore', 'raw_superstore') }}