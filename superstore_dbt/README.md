# Superstore dbt Projekt

Ez a projekt a Superstore eladási adatainak feldolgozását és modellezését végzi a **dbt** (data build tool) segítségével. A cél egy jól strukturált adattárház létrehozása **staging**, **dimenzió** és **fact** szinteken, valamint az adatminőség ellenőrzése tesztekkel.

---

## 📁 Projekt felépítése

A `models/` könyvtár a következő részekre van bontva:

- `staging/`: nyers adatok tisztítása, oszlopok átnevezése (`stg_` modellek)
- `marts/`: végső dimenzió- és fact-táblák (`dim_`, `fact_` modellek)
- `sources.yml`: a `raw_superstore` forrás definiálása
- `tests`: beépített és saját tesztek az adatok ellenőrzésére

A raw_superstore adat a public sémában van tárolva, és onnan kerül feldolgozásra staging modelleken keresztül. Minden logikai átalakítás és adatminőség-ellenőrzés dbt-modellek formájában történik, SQL-ben megfogalmazva.

---

## 🛠️ Használt technológiák

- **dbt**: `1.10.x`
- **PostgreSQL**
- **pgAdmin 4** (ellenőrzéshez)
- Lokális környezet: `superstore_env` (virtualenv)

---

## 🧩 Adatmodellek

| Modell           | Típus      | Leírás |
|------------------|------------|--------|
| `raw_superstore` | Forrás     | CSV-ből betöltött nyers adat |
| `stg_orders`     | Staging    | Nyers rendelési adatok tisztítása |
| `stg_customers`  | Staging    | Ügyféladatok kiszűrése |
| `stg_products`   | Staging    | Termékadatok |
| `stg_locations`  | Staging    | Város, régió, állam, ország kombináció |
| `dim_date`       | Dimenzió   | Generált dátumtábla (2010-01-01 – 2014-12-31) |
| `dim_customer`   | Dimenzió   | Ügyfelek és szegmenseik |
| `dim_product`    | Dimenzió   | Termékek kategóriái és alkategóriái |
| `dim_location`   | Dimenzió   | Egyedi lokációk `location_id` alapján |
| `fact_orders`    | Fact       | Rendelések, kapcsolt dimenzió-azonosítókkal |

---

## ✅ Tesztelés

A dbt beépített `test` funkciója ellenőrzi:

- **Egyediség** (`unique`)
- **Hiányzó értékek** (`not_null`)
- **Külső kulcs kapcsolatok** (`relationships`)

Futtatáshoz:

```bash
dbt test

