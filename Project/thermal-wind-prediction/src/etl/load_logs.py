# ============================================================
# LOAD_LOGS.PY
# ------------------------------------------------------------
# ETL para cargar logs históricos de viento de Badalona
# Proyecto: Thermal Wind Prediction
# ============================================================

# =========================
# IMPORTACIONES
# =========================

from pathlib import Path
import pandas as pd


# =========================
# CONFIGURACIÓN DE RUTAS
# =========================

# Ruta raíz del proyecto
PROJECT_ROOT = Path(
    "/Users/rogerdefez/Documents/Cursos i Llibres/BootCamp IT Academy/03_Especialitzacio/Project/thermal-wind-prediction"
)

# Carpeta donde están los datos RAW
RAW_DATA_PATH = PROJECT_ROOT / "data" / "raw"

# Carpeta salida datos procesados
PROCESSED_DATA_PATH = PROJECT_ROOT / "data" / "processed"

# Crear carpeta processed si no existe
PROCESSED_DATA_PATH.mkdir(parents=True, exist_ok=True)


# =========================
# LISTA PARA ACUMULAR DFS
# =========================

all_dataframes = []


# =========================
# BUSCAR CARPETAS BDLONA
# =========================

# Busca todas las carpetas que empiecen por BDLONA_
bdlona_folders = sorted(RAW_DATA_PATH.glob("BDLONA_*_log"))


print("\n================================================")
print("CARGA HISTÓRICA LOGS BADALONA")
print("================================================")

print(f"\nCarpetas encontradas: {len(bdlona_folders)}")


# =========================
# RECORRER CARPETAS
# =========================

for folder in bdlona_folders:

    print(f"\nProcesando carpeta: {folder.name}")

    # Buscar todos los archivos .log
    log_files = sorted(folder.glob("*.log"))

    print(f"Archivos encontrados: {len(log_files)}")

    # =========================
    # RECORRER ARCHIVOS
    # =========================

    for file_path in log_files:

        try:

            # =========================
            # EXTRAER FECHA DEL NOMBRE
            # =========================

            # Ejemplo:
            # 210101.log --> 2021-01-01

            file_stem = file_path.stem

            year = int("20" + file_stem[:2])
            month = int(file_stem[2:4])
            day = int(file_stem[4:6])

            file_date = pd.Timestamp(year, month, day)

            # =========================
            # LEER ARCHIVO
            # =========================

            df = pd.read_csv(
                file_path,
                sep=r"\s+",
                header=None,
                engine="python"
            )

            # =========================
            # VALIDAR COLUMNAS
            # =========================

            if df.shape[1] != 7:

                print(f"[WARNING] Columnas incorrectas: {file_path.name}")
                continue

            # =========================
            # RENOMBRAR COLUMNAS
            # =========================

            df.columns = [
                "time",
                "temperature",
                "wind_direction_deg",
                "wind_avg",
                "wind_min",
                "wind_max",
                "unknown"
            ]

            # =========================
            # CREAR DATETIME
            # =========================

            df["datetime"] = pd.to_datetime(
                file_date.strftime("%Y-%m-%d") + " " + df["time"]
            )

            # =========================
            # AÑADIR METADATOS
            # =========================

            df["spot"] = "BDLONA"

            df["source_file"] = file_path.name

            # =========================
            # REORDENAR COLUMNAS
            # =========================

            df = df[
                [
                    "datetime",
                    "spot",
                    "temperature",
                    "wind_direction_deg",
                    "wind_avg",
                    "wind_min",
                    "wind_max",
                    "unknown",
                    "source_file"
                ]
            ]

            # =========================
            # ACUMULAR DATAFRAME
            # =========================

            all_dataframes.append(df)

        except Exception as e:

            print(f"[ERROR] {file_path.name} --> {e}")


# =========================
# CONCATENAR TODO
# =========================

print("\n================================================")
print("CONCATENANDO DATAFRAMES")
print("================================================")

final_df = pd.concat(all_dataframes, ignore_index=True)

print(f"\nTotal registros: {len(final_df):,}")


# =========================
# ORDENAR POR DATETIME
# =========================

final_df = final_df.sort_values("datetime")


# =========================
# RESET INDEX
# =========================

final_df = final_df.reset_index(drop=True)


# =========================
# INFORMACIÓN GENERAL
# =========================

print("\n================================================")
print("INFO DATAFRAME FINAL")
print("================================================")

print(final_df.info())

print("\nPrimeras filas:\n")
print(final_df.head())


# =========================
# EXPORTAR PARQUET
# =========================

output_path = PROCESSED_DATA_PATH / "bdlona_logs.parquet"

final_df.to_parquet(output_path, index=False)

print("\n================================================")
print("EXPORTACIÓN COMPLETADA")
print("================================================")

print(f"\nArchivo guardado en:\n{output_path}")