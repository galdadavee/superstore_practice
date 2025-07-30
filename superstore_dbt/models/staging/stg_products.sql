-- models/staging/stg_products.sql

WITH ranked_products AS (
  SELECT
    "ProductID"     AS product_id,
    "ProductName"   AS product_name,
    "SubCategory"   AS sub_category,
    "Category"      AS category,
    ROW_NUMBER() OVER (PARTITION BY "ProductID" ORDER BY "ProductName") AS rn
  FROM {{ source('raw_superstore', 'raw_superstore') }}
)

SELECT
  product_id,
  product_name,
  sub_category,
  category
FROM ranked_products
WHERE rn = 1