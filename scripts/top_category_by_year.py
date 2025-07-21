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

query = """
SELECT EXTRACT(YEAR FROM fo.order_date) AS year, dp.category, SUM(fo.profit) AS total_profit
FROM fact_orders fo
JOIN dim_product dp ON fo.product_id = dp.product_id
GROUP BY year, dp.category
ORDER BY year, total_profit DESC;
"""

df = pd.read_sql_query(query, engine)

#Legnagyobb profitú kategória kiválasztása évente
top_by_year = df.sort_values(['year', 'total_profit'], ascending=[True, False]).drop_duplicates(subset='year')

print(top_by_year)