

#================================================================
# Importación librerias
#================================================================

import os
import pandas as pd

from datetime import date

from sqlalchemy import create_engine, text, inspect 
from dotenv import load_dotenv  # para las variables de entorno seguras

#================================================================
# Conexión segura a DB MySQL
#================================================================

# Ruta ABSOLUTA al .env
load_dotenv(r"Z:\Sprint 11\.env")

DB_HOST = os.getenv("DB_HOST")
DB_PORT = os.getenv("DB_PORT")
DB_USER = os.getenv("DB_USER")
DB_PASSWORD = os.getenv("DB_PASSWORD")
DB_NAME = os.getenv("DB_NAME")

# crear conexión con

engine = create_engine(
    f"mysql+pymysql://{DB_USER}:{DB_PASSWORD}@{DB_HOST}:{DB_PORT}/{DB_NAME}")

#================================================================
# Cargar tablas MySQL para tener los dataframes
#================================================================

# ------------------------------------------------
# Función para añadir índice único a las tablas que cargo en Power BI
# ------------------------------------------------

def add_powerbi_index(df, index_name="pbix_id"):

    # Reinicio índice pandas
    df = df.reset_index(drop=True)

    # Inserto índice único secuencial
    df.insert(
        0,
        index_name,
        range(1, len(df) + 1)
    )

    return df

# Carga tablas
#___________________________________

df_companies = pd.read_sql(
    "SELECT * FROM companies",
    engine
)

df_companies = add_powerbi_index(df_companies)


df_credit_card_activated = pd.read_sql(
    "SELECT * FROM credit_card_activated",
    engine
)

df_credit_card_activated = add_powerbi_index(df_credit_card_activated)


df_credit_cards = pd.read_sql(
    "SELECT * FROM credit_cards",
    engine
)

# arreglar tipos para evitar errores 

df_credit_cards = (
    df_credit_cards
    .astype({
        "iban": "string",
        "pan": "string",
        "pin": "string",
        "cvv": "string"
    })
)

df_credit_cards["expiring_date"] = pd.to_datetime(
    df_credit_cards["expiring_date"],
    errors="coerce"
)

# indice powerbi

df_credit_cards = add_powerbi_index(df_credit_cards)


df_products = pd.read_sql(
    "SELECT * FROM products",
    engine
)

df_products = add_powerbi_index(df_products)


df_transaction_product = pd.read_sql(
    "SELECT * FROM transaction_product",
    engine
)

df_transaction_product = add_powerbi_index(df_transaction_product)


df_transactions = pd.read_sql(
    "SELECT * FROM transactions",
    engine
)


df_transactions = add_powerbi_index(df_transactions)


df_users = pd.read_sql(
    "SELECT * FROM users",
    engine
)

df_users = add_powerbi_index(df_users)


#================================================================
# Preparación de datos
#================================================================

# Definir función cálculo edad

def age_calc(birth_date):

    today = date.today()

    last_birthday = (
        today.month,
        today.day
    ) >= (
        birth_date.month,
        birth_date.day
    )

    return (
        today.year
        - birth_date.year
        - int(not last_birthday)
)

# Aplicación funcion cálculo edad

df_users["birth_date"] = pd.to_datetime(
    df_users["birth_date"]
)

df_users["Actual_age"] = (
    df_users["birth_date"]
    .apply(age_calc)
)

#creación columna nombre completo

df_users["full_name"] = (df_users["name"] + " " + df_users["surname"])


#================================================================
# DF 1 - Una Variable Numérica
#================================================================

numeric_products_price = (
    df_products[[
        "id",
        "product_name",
        "price"]]
)


#================================================================
# DF 2 - Dos Variables Numéricas
#================================================================

ventas_user = (
    df_transactions
    .groupby("user_id")[["amount"]]
    .sum()
    .reset_index()
)

transacciones_user = (
    df_transactions
    .groupby("user_id")[["id"]]
    .count()
    .reset_index()
)

df_numeric_relationship = (
    ventas_user
    .merge(
        transacciones_user,
        on="user_id"
    )
)


#================================================================
# DF 3 - Una Variable Categórica
#================================================================

df_company_country = (
    df_companies[[
        "company_id",
        "company_name",
        "country"]]
)


#================================================================
# DF 4 - Una Variable Categórica + Una Numérica
#================================================================

df_transaction_company = (
    df_transactions
    .groupby("company_id")
    .agg(
        num_transacciones=("id", "count")
    )
    .sort_values(
        by="num_transacciones",
        ascending=False
    )
    .head(20)
    .reset_index()
)

df_company_transactions = (
    df_transaction_company
    .merge(
        df_companies[[
            "company_id",
            "company_name"]],
        on="company_id"
    )
)


#================================================================
# DF 5 - Dos Variables Categóricas 
#================================================================

companies = (
    df_companies[[
        "company_id",
        "country"]]
)

users = (
    df_users[[
        "id",
        "country"]]
)

transacciones = (
    df_transactions[[
        "id",
        "amount",
        "user_id",
        "company_id"]]
)

df_merge_country = (
    transacciones
    .merge(
        companies,
        on="company_id"
    )
)

transacciones_country = (
    df_merge_country
    .merge(
        users,
        left_on="user_id",
        right_on="id"
    )
)

transacciones_country = (
    transacciones_country
    .rename(
        columns={
            "id_x":"id",
            "country_x":"country_company",
            "country_y":"country_user"
        }
    )
    .drop(columns=["id_y"])
)

cross_porcentaje = (
    pd.crosstab(
        transacciones_country["country_user"],
        transacciones_country["country_company"],
        normalize=True
    ) * 100
)

cross_porcentaje = (
    cross_porcentaje
    .reset_index()
)


#================================================================
# DF 6 - Tres Variables 
#================================================================

df_map = (
    df_transactions[
        [
            "lat",
            "longitude",
            "amount"
        ]
    ]
)

df_map["lat"] = (
    df_map["lat"]
    .round(0)
)

df_map["longitude"] = (
    df_map["longitude"]
    .round(0)
)

df_map_analysis = (
    df_map
    .groupby(
        [
            "lat",
            "longitude"
        ]
    )["amount"]
    .sum()
    .reset_index()
)


#================================================================
# DF 7 - Crear un Pairplot
#================================================================

users_analysis = (
    df_users[
        [
            "id",
            "full_name",
            "Actual_age",
            "city",
            "country",
            "continent"
        ]
    ]
    .rename(
        columns={
            "id":"user_id",
            "country":"country_user"
        }
    )
)

companies_analysis = (
    df_companies[
        [
            "company_id",
            "company_name",
            "country"
        ]
    ]
    .rename(
        columns={
            "country":"country_company"
        }
    )
)

df_merge_analysis = (
    df_transactions[
        [
            "id",
            "timestamp",
            "declined",
            "amount",
            "user_id",
            "company_id",
            "lat",
            "longitude"
        ]
    ]
    .merge(
        companies_analysis,
        on="company_id"
    )
    .merge(
        users_analysis,
        on="user_id"
    )
)

df_transaction_product = (
    df_transaction_product
    .rename(
        columns={
            "transaction_id":"id"
        }
    )
)

df_products_analysis = (
    df_products
    .rename(
        columns={
            "id":"product_id"
        }
    )
    .drop(
        columns="warehouse_id",
        errors="ignore"
    )
)

df_transacciones_analysis = (
    df_transaction_product[
        [
            "id",
            "product_id"
        ]
    ]
    .merge(
        df_merge_analysis,
        on="id",
        how="left"
    )
    .merge(
        df_products_analysis,
        on="product_id"
    )
)

aov_analysis = (
    df_transacciones_analysis
    .groupby(["full_name"])
    .agg(
        total_amount=("price", "sum"),
        total_trans=("id", "nunique"),
        price_mean=("price", "mean"),
        Actual_age=("Actual_age", "first"),
        country=("country_user", "first"),
        continent=("continent", "first")
    )
    .reset_index()
)

aov_analysis["AOV"] = (
    aov_analysis["total_amount"]
    / aov_analysis["total_trans"]
)


#================================================================
# Cerrar la conexión
#================================================================

engine.dispose()