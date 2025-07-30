-- models/staging/stg_locations.sql

SELECT
  "City"    AS city,
  "State"   AS state,
  "Region"  AS region,
  "Country" AS country
FROM {{ source('raw_superstore', 'raw_superstore') }}

