-- models/marts/dim_location.sql

{{ config(materialized='table') }}

SELECT DISTINCT
    {{ dbt_utils.generate_surrogate_key(['city', 'state', 'region', 'country']) }} AS location_id,
    city,
    state,
    region,
    country
FROM {{ ref('stg_locations') }}

