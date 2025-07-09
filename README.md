# Superstore Star Schema projektem leírása

Ez a projekt a Kaggle-n találtható Global Superstore dataset StarChema szerinti modellezését valósította meg PostgreSQL-ben, amihe PGADmin4-et és Pythont használtam (pandas + SQLAlchemy).

## Hogyan is néz ki a mappa struktúra?

- 'data/' - Bemeneti csv, a nyers fájl
- 'scripts/'- betöltöttem Postgresbe, pandas, os, dotenv és sqlalchemy segítségével. Kicsit mókolni kellett az oszlopneveket, mert a . elválasztás zavaró lehet lekérdezéseknél
- 'sql/' - fact és dim táblák létrehozása, star schema kialakítása

## Adatbázis táblák
- 'raw_superstore' - nyers adat
- 'fact_orders' - központi tábla
- 'dim_product' - egyedi product kódok alapján az összes termék, névvel, kategóriával és alkategóriával
- 'dim_customer' - egyedi customerek leírása, nevük és customer_id-juk
- 'dim_date' - minden egyes OrderDate, valamint különválasztva az év, hónap, nap, nap neve, és az év hanyadik hete
- 'dim_location' - minden egyes country-city-state-region kombináció, egyedi location_id-vel létrehozva

## Használt csomagok

Lásd : 'requirements.txt'

## Elindítás

1. Hozd létre az '.env' fájlt
2. Futtasd: 'python scipts/load_raw_data.py'