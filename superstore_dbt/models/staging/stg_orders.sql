-- models/staging/stg_orders.sql

SELECT
    "RowID"        AS order_row_id,
    "OrderID"      AS order_id,
    "OrderDate"    AS order_date,
    "ShipDate"     AS ship_date,
    "ProductID"     AS product_id,
    "CustomerID"    AS customer_id,
    "Quantity"      AS quantity,
    "Discount"      AS discount,
    "Profit"        AS profit,
    "Sales"         AS sales,
    "ShippingCost" AS shipping_cost,
    "City"         AS city,
    "State"        AS state,
    'Region'       AS region,
    'Country'      AS country
FROM {{ source('raw_superstore', 'raw_superstore') }}
