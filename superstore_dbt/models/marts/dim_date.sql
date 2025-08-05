-- models/marts/dim_date.sql

{{ config(materialized='table') }}

WITH date_range AS (
    SELECT
        *
    FROM
        UNNEST(GENERATE_DATE_ARRAY(DATE('2010-01-01'), DATE('2014-12-31'), INTERVAL 1 DAY)) AS date_day
)

SELECT
    date_day,
    EXTRACT(YEAR FROM date_day) AS year,
    EXTRACT(MONTH FROM date_day) AS month,
    EXTRACT(DAY FROM date_day) AS day,
    FORMAT_DATE('%A', date_day) AS weekday_name,
    EXTRACT(DAYOFWEEK FROM date_day) AS weekday_number,
    FORMAT_DATE('%Y-%m', date_day) AS year_month,
    FORMAT_DATE('%Y-%m-%d', date_day) AS date_text
FROM date_range
