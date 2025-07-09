import pandas as pd
import os
from dotenv import load_dotenv
from sqlalchemy import create_engine

#Betöltöm a .env fájlt
load_dotenv()

#Környezeti változók beolvasása
DB_HOST = os.getenv("DB_HOST")
DB_PORT = os.getenv("DB_PORT")
DB_NAME = os.getenv("DB_NAME")
DB_USER = os.getenv("DB_USER")
DB_PASSWORD = os.getenv("DB_PASSWORD")

#Csatlakozom a Databasehez
DB_URL = f"postgresql://{DB_USER}:{DB_PASSWORD}@{DB_HOST}:{DB_PORT}/{DB_NAME}"

#CSV beolvasása
csv_path = os.path.join("data", "superstore.csv")
df = pd.read_csv(csv_path)

#Egységesítem az oszlopneveket a táblához amit már létrehoztam PGAdminban
df.rename(columns={
    "Order.Date": "OrderDate",
    "Ship.Date": "ShipDate",
    "Customer.ID": "CustomerID",
    "Customer.Name": "CustomerName",
    "Order.ID": "OrderID",
    "Product.ID": "ProductID",
    "Product.Name": "ProductName",
    "Shipping.Cost": "ShippingCost",
    "Sub.Category": "SubCategory",
    "Row.ID": "RowID",
    "Order.Priority": "Order_Priority",
    "Ship.Mode": "Ship_Mode"
}, inplace=True)

if "记录数" in df.columns:
    df.drop(columns=["记录数"], inplace=True)
#Dátumoszlopokat konvertálom:
df["OrderDate"] = pd.to_datetime(df["OrderDate"])
df["ShipDate"] = pd.to_datetime(df["ShipDate"])

#Adat betöltése:
engine = create_engine(DB_URL)

df.to_sql("raw_superstore", engine, if_exists="append", index=False)

print("Sikeresen lefutott a scriptem!")