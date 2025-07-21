import os
import pandas as pd
from sqlalchemy import create_engine
from dotenv import load_dotenv

load_dotenv()

#Környezeti változók beolvasása
DB_HOST = os.getenv("DB_HOST")
DB_PORT = os.getenv("DB_PORT")
DB_NAME = os.getenv("DB_NAME")
DB_USER = os.getenv("DB_USER")
DB_PASSWORD = os.getenv("DB_PASSWORD")

DB_URL = f"postgresql://{DB_USER}:{DB_PASSWORD}@{DB_HOST}:{DB_PORT}/{DB_NAME}"
engine = create_engine(DB_URL)

#Lekérdezés

query = """
WITH profits_per_segment AS (
    SELECT 
        EXTRACT(YEAR FROM fo.order_date) AS year,
        dl.country AS country,
        dl.region AS region,
        dc.segment AS segment,
        SUM(fo.profit) AS total_profit,
        RANK () OVER (
            PARTITION BY EXTRACT(YEAR FROM fo.order_date), dl.country
            ORDER BY SUM(fo.profit) DESC
        ) AS segment_rank
    FROM fact_orders fo
    JOIN dim_customer dc ON fo.customer_id = dc.customer_id
    JOIN dim_location dl ON fo.location_id = dl.location_id
    GROUP BY year, country, region, segment
)

SELECT * 
FROM profits_per_segment
WHERE segment_rank = 1
ORDER BY year, country;
"""

df = pd.read_sql_query(query, engine)

print(df)
