import os
import pandas as pd
from sqlalchemy import create_engine
from dotenv import load_dotenv
import matplotlib.pyplot as plt

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
WITH city_sales AS (
    SELECT
        EXTRACT(YEAR FROM fo.order_date) AS year,
        dl.city,
        SUM(fo.sales) AS total_sales,
        RANK() OVER (
            PARTITION BY EXTRACT(YEAR FROM fo.order_date)
            ORDER BY SUM(fo.sales) DESC
        ) AS city_rank
    FROM fact_orders fo
    JOIN dim_location dl ON fo.location_id = dl.location_id
    GROUP BY year, dl.city
)

SELECT *
FROM city_sales
WHERE city_rank <= 5
ORDER BY year, city_rank;
"""

df = pd.read_sql_query(query, engine)
print(df)

# Diagram generálása
plt.figure(figsize=(10, 6))
for year in df["year"].unique():
    top_cities = df[df["year"] == year]
    plt.bar(top_cities["city"] + f" ({int(year)})", top_cities["total_sales"])

plt.title("Top 5 város eladás szerint évente")
plt.ylabel("Összes eladás (USD)")
plt.xticks(rotation=45, ha="right")
plt.tight_layout()

# Kép mentése
output_dir = "img"
os.makedirs(output_dir, exist_ok=True)
plt.savefig(os.path.join(output_dir, "top_5_cities_by_sales.png"))

print("Kép sikeresen generálva!")