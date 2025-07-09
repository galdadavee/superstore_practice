CREATE TABLE fact_orders (
    order_row_id INTEGER PRIMARY KEY,
    order_id TEXT,
    order_date DATE,
    ship_date DATE,
    product_id TEXT,
    customer_id TEXT,
    quantity INTEGER,
    discount NUMERIC,
    profit NUMERIC,
    sales INTEGER,
    shipping_cost NUMERIC
);

INSERT INTO fact_orders (
    order_row_id,
    order_id,
    order_date,
    ship_date,
    product_id,
    customer_id,
    quantity,
    discount,
    profit,
    sales,
    shipping_cost
)
SELECT
    "RowID",
    "OrderID",
    "OrderDate",
    "ShipDate",
    "ProductID",
    "CustomerID",
    "Quantity",
    "Discount",
    "Profit",
    "Sales",
    "ShippingCost"
FROM raw_superstore;

SELECT COUNT(*) FROM fact_orders;

CREATE TABLE dim_product (
	product_id TEXT PRIMARY KEY,
	product_name TEXT,
	sub_category TEXT,
	category TEXT
); 

SELECT "ProductID", "ProductName", "SubCategory", "Category"
FROM raw_superstore
WHERE "ProductID" = 'TEC-MA-10000161';

WITH ranked_products AS (
  SELECT
    "ProductID",
    "ProductName",
    "SubCategory",
    "Category",
    ROW_NUMBER() OVER (PARTITION BY "ProductID" ORDER BY "ProductName") AS rn
  FROM raw_superstore
)
INSERT INTO dim_product (product_id, product_name, sub_category, category)
SELECT
  "ProductID", "ProductName", "SubCategory", "Category"
FROM ranked_products
WHERE rn = 1;

ALTER TABLE fact_orders
ADD CONSTRAINT fk_dim_product
FOREIGN KEY (product_id)
REFERENCES dim_product (product_id);

CREATE TABLE dim_customer (
	customer_id TEXT PRIMARY KEY,
	customer_name TEXT,
	segment TEXT
);

INSERT INTO dim_customer (
	customer_id,
	customer_name,
	segment
)
SELECT DISTINCT
	"CustomerID",
	"CustomerName",
	"Segment"
FROM raw_superstore;

CREATE TABLE dim_date (
	date DATE PRIMARY KEY,
	year INTEGER,
	month INTEGER,
	day INTEGER,
	weekday TEXT,
	week_number INTEGER
);

INSERT INTO dim_date (
	date,
	year, 
	month,
	day,
	weekday,
	week_number
)
SELECT DISTINCT
	"OrderDate"::date AS date,
	EXTRACT(YEAR FROM "OrderDate") AS year,
	EXTRACT(MONTH FROM "OrderDate") AS month,
	EXTRACT(DAY FROM "OrderDate") AS day,
	TO_CHAR("OrderDate", 'Day') AS weekday,
	EXTRACT(WEEK FROM "OrderDate") AS week_number
FROM raw_superstore;

ALTER TABLE fact_orders
ADD CONSTRAINT fk_dim_customer
FOREIGN KEY (customer_id)
REFERENCES dim_customer (customer_id);

ALTER TABLE fact_orders
ADD CONSTRAINT fk_dim_date
FOREIGN KEY (order_date)
REFERENCES dim_date (date);

CREATE TABLE dim_location (
	location_id SERIAL PRIMARY KEY,
	country TEXT,
	state TEXT,
	city TEXT,
	region TEXT
);

WITH distinct_locations AS (
  SELECT DISTINCT
    "Country",
    "State",
    "City",
    "Region"
  FROM raw_superstore
)
INSERT INTO dim_location (country, state, city, region)
SELECT
    "Country",
    "State",
    "City",
    "Region"
FROM distinct_locations;

ALTER TABLE fact_orders
ADD COLUMN location_id INTEGER;

ALTER TABLE fact_orders
DROP COLUMN location_id;

ALTER TABLE fact_orders
ADD COLUMN country TEXT,
ADD COLUMN state TEXT,
ADD COLUMN city TEXT,
ADD COLUMN region TEXT;

UPDATE fact_orders f
SET
    country = r."Country",
    state = r."State",
    city = r."City",
    region = r."Region"
FROM raw_superstore r
WHERE f.order_row_id = r."RowID";

ALTER TABLE fact_orders
ADD COLUMN location_id INTEGER;

UPDATE fact_orders f
SET location_id = dl.location_id
FROM dim_location dl
WHERE
    f.country = dl.country AND
    f.state = dl.state AND
    f.city = dl.city AND
    f.region = dl.region;

ALTER TABLE fact_orders
DROP COLUMN country,
DROP COLUMN state,
DROP COLUMN city,
DROP COLUMN region;

ALTER TABLE fact_orders
ADD CONSTRAINT fk_dim_location
FOREIGN KEY (location_id)
REFERENCES dim_location (location_id);