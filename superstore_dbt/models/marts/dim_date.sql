-- models/marts/dim_date.sql

{{ config(materialized='table') }}

WITH date_range AS (
    SELECT generate_series(
        '2010-01-01'::date,
        '2014-12-31'::date,
        interval '1 day'
    ) AS date_day
)

SELECT
    date_day,
    EXTRACT(YEAR FROM date_day)      AS year,
    EXTRACT(MONTH FROM date_day)     AS month,
    EXTRACT(DAY FROM date_day)       AS day,
    TO_CHAR(date_day, 'Day')         AS weekday_name,
    EXTRACT(ISODOW FROM date_day)    AS weekday_number,
    TO_CHAR(date_day, 'YYYY-MM')     AS year_month,
    TO_CHAR(date_day, 'YYYY-MM-DD')  AS date_text
FROM date_range