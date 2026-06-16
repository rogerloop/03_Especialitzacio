# Guía personal — Gráficos, metodología y resultados del modelo

**Para:** Roger  
**Proyecto:** GO / NO GO — Intelligent Sea Breeze Prediction System  
**Notebook:** `08_Daily_Thermal_Wind_Model.ipynb`  
**Objetivo de esta guía:** explicarte qué significa cada gráfico y cada pieza del modelo, en lenguaje claro, para que puedas defender la presentación con confianza.

---

## 1. Qué pregunta responde el proyecto

> **¿Habrá viento de dirección Sur / Suroeste con media ≥ 10 nudos en Badalona (BDLONA) ese día?**

- **GO (1):** Sí, en algún momento del día (con observación válida del sensor) hubo viento ≥ 10 kt entre 135° y 225°.
- **NO GO (0):** No hubo ese viento.

Es una pregunta **diaria**, no horaria. Piensa en ello como: *«¿Merece la pena ir a navegar hoy por viento térmico S/SO?»*

---

## 2. Metodología (lo que NO hace falta explicar en detalle en la presentación)

### 2.1 Datos

| Fuente | Qué es | Periodo | Granularidad |
|---|---|---|---|
| **Buscaviento BDLONA** | Sensor en la playa de Badalona | 2010–2025 | ~15 min (solo de día) |
| **XEMA Museu Badalona** | Estación meteorológica en tierra | 2010–2025 | 1 hora (24 h) |
| **Boya Barcelona** (Puertos del Estado) | Temperatura del mar (SST) y oleaje | 2010–2025 | 1 hora |

Se unieron las tres fuentes en un dataset **horario** y luego se agregó a **nivel diario** para el modelo.

### 2.2 Variables calculadas (las importantes)

| Variable | Qué mide | Por qué importa |
|---|---|---|
| **Night_Day_Gradient** | Máxima − mínima de temperatura del aire en el día (24 h) | Días con mucho calentamiento diurno favorecen la brisa de mar |
| **Air_See_Gradient_max** | Máximo diario de `(temperatura_aire − SST)` | Cuanto más caliente está la tierra respecto al mar, más probable es el térmico |
| **Irradiancia_solar_max** | Máxima irradiancia solar del día | Sin sol, no hay calentamiento fuerte de la costa |
| **pressure_mean** | Presión media diaria | Sistemas sinópticos pueden reforzar o bloquear el térmico |
| **precip_total** | Precipitación acumulada del día | Días nublados / húmedos suelen ir peor |
| **sst_mean** | Temperatura media del mar | Contexto térmico de la base marina |
| **month / day_of_year / season** | Calendario | El térmico es estacional (primavera–verano) |

**Corrección clave respecto al trabajo anterior:**  
`Air_See_Gradient` diario se calcula con el **máximo** del gradiente horario, no con la media. El pico de contraste aire–mar es más relevante que la media.

### 2.3 Modelo

- **Algoritmo:** Random Forest (500 árboles, profundidad máx. 12, `class_weight='balanced'`).
- **Por qué Random Forest:** interpretable, funciona bien con relaciones no lineales, da importancia de variables, es estándar en bootcamp.
- **Split temporal (sin mezclar futuro con pasado):**
  - **Train:** hasta 31-dic-2021
  - **Validación:** 2022–2023
  - **Test:** 2024–2025

### 2.4 Limitación honesta (menciónala si te preguntan)

Las features usan observaciones del **mismo día** (p. ej. irradiancia máxima). Eso sirve para **analizar patrones históricos** y clasificar días retrospectivamente.  
Para una **previsión real a las 07:00** habría que usar solo datos disponibles por la mañana + modelos meteorológicos (GFS, Open-Meteo). Es el siguiente paso natural del proyecto.

---

## 3. Gráficos EDA — Qué ves y qué significa

### 3.1 `01_monthly_frequency.png` — Frecuencia mensual

**Qué es:** Barras con el % de días con viento S/SO ≥ 10 kt por mes (todos los años juntos).

**Qué aporta:**
- Confirma que el evento es **muy estacional**.
- Verás picos en **mayo–agosto** y casi nada en invierno.
- **Mensaje para la audiencia:** *«No es un problema de todo el año; es un fenómeno de calor y verano.»*

---

### 3.2 `02_annual_frequency.png` — Frecuencia anual

**Qué es:** % de días positivos por año.

**Qué aporta:**
- Muestra si hay **variabilidad interanual** (un verano más térmico que otro).
- Ayuda a demostrar que tienes **16 años de datos** y no un sample pequeño.
- **Mensaje:** *«Hay suficiente historia para entrenar un modelo.»*

---

### 3.3 `03_gradient_probability.png` — Probabilidad vs gradiente aire-mar

**Qué es:** A mayor `Air_See_Gradient_max` (bins), ¿qué % de días hubo viento S/SO ≥ 10 kt?

**Qué aporta:**
- Valida la **hipótesis física**: más contraste tierra–mar → más probabilidad de térmico.
- Si la curva sube hacia la derecha, tu intuición de windsurfista se confirma con datos.
- **Mensaje:** *«La física del térmico se ve en los datos, no es solo corazonada.»*

---

### 3.4 `04_night_day_boxplot.png` — Night_Day_Gradient vs evento

**Qué es:** Caja comparando el gradiente día–noche en días GO vs NO GO.

**Qué aporta:**
- Si la caja de GO está más alta, los días con térmico tienen **más amplitud térmica diaria**.
- Es evidencia descriptiva antes del ML.
- **Mensaje:** *«Los días con térmico suelen ser días con más contraste térmico entre noche y día.»*

---

### 3.5 `05_season_month_heatmap.png` — Estación × Mes

**Qué es:** Mapa de calor con % de días positivos por estación meteorológica y mes.

**Qué aporta:**
- Vista **visual muy potente** para la presentación.
- Combina calendario + estación de forma intuitiva.
- **Mensaje:** *«El patrón es claro: primavera–verano, horas cálidas, costa catalana.»*

---

### 3.6 `09_data_pipeline.png` — Pipeline de datos

**Qué es:** Esquema de las 3 fuentes → merge → ML → GO/NO GO.

**Qué aporta:**
- Resume la arquitectura en 5 segundos.
- Ideal para la diapositiva de «De dónde vienen los datos».

---

## 4. Gráficos del Random Forest — Lo que más te costará (explicado simple)

### 4.1 `10_metrics_summary.png` — Resumen numérico

| Métrica | Valor test | Qué significa en una frase |
|---|---:|---|
| **F1** | 0.52 | Equilibrio entre acertar GO y no fallar demasiado |
| **AUC** | 0.71 | El modelo separa GO de NO GO mejor que el azar (0.50) |
| **Precisión (GO)** | 0.45 | Cuando dice GO, acierta ~45% de las veces |
| **Recall (GO)** | 0.62 | Detecta ~62% de los días que realmente hubo viento |
| **Días positivos** | 29.4% | Casi 1 de cada 3 días históricos hubo evento |

**Cómo contarlo en voz alta:**  
*«No es perfecto, pero supera claramente el azar y captura más de la mitad de los días buenos, con un equilibrio razonable para un primer modelo de bootcamp.»*

---

### 4.2 `06_confusion_matrix.png` — Matriz de confusión ⭐

La matriz compara **lo que predijo el modelo** vs **lo que realmente pasó** en el test (2024–2025).

```
                    Predicho NO GO    Predicho GO
Real NO GO              TN               FP
Real GO                 FN               TP
```

En tu test (731 días):

|  | Predicho NO GO | Predicho GO |
|---|---:|---:|
| **Real NO GO** | 336 (TN) | 171 (FP) |
| **Real GO** | 86 (FN) | 138 (TP) |

**Lee cada cuadrante:**

| Celda | Nombre | Qué pasó | Analogía windsurf |
|---|---|---|---|
| **TN = 336** | Verdaderos negativos | Dijo NO GO y no hubo viento | *No fuiste y bien hecho* |
| **TP = 138** | Verdaderos positivos | Dijo GO y sí hubo viento | *Fuiste y acertaste* |
| **FP = 171** | Falsos positivos | Dijo GO pero no hubo viento | *Fuiste y perdiste el viaje* ← el error más molesto |
| **FN = 86** | Falsos negativos | Dijo NO GO pero sí hubo viento | *Te quedaste en casa y sí entró* |

**Precisión (GO) = TP / (TP+FP) = 138/309 ≈ 45%**  
De cada 100 veces que el modelo dice GO, ~45 son aciertos.

**Recall (GO) = TP / (TP+FN) = 138/224 ≈ 62%**  
De cada 100 días buenos reales, el modelo detecta ~62.

**Trade-off:**  
- Si quieres **menos viajes fallidos** (menos FP) → sube el umbral de probabilidad (más conservador).  
- Si quieres **no perderte días buenos** (menos FN) → baja el umbral (más agresivo).

Para windsurf, **FP duele más** (gasolina + tiempo). En la presentación puedes decir que el siguiente paso sería calibrar el umbral hacia más precisión.

---

### 4.3 `07_roc_curve.png` — Curva ROC ⭐

**Qué es:** Gráfico que muestra qué tan bien el modelo **separa** días GO de días NO GO en todos los umbrales posibles.

**Ejes:**
- **X:** Tasa de falsos positivos (FP / todos los NO GO reales)
- **Y:** Tasa de verdaderos positivos = Recall (TP / todos los GO reales)

**Línea diagonal gris:** Rendimiento del azar (AUC = 0.50).

**Tu curva turquesa:** Por encima de la diagonal → el modelo **sí aprende**.

**AUC = 0.71:** Probabilidad de que, tomando un día GO al azar y un día NO GO al azar, el modelo asigne mayor puntuación al día GO.  
- 0.50 = azar  
- 0.70–0.80 = **útil pero mejorable** (típico en primer modelo meteorológico)

**Frase para la presentación:**  
*«Con AUC 0.71 el modelo distingue días buenos de malos mejor que tirar una moneda, aunque aún no es un pronóstico operativo perfecto.»*

---

### 4.4 `08_feature_importance.png` — Importancia de variables ⭐

**Qué es:** Cuánto contribuye cada variable a las decisiones del Random Forest (promedio de todos los árboles).

**Tu ranking (test entrenado):**

| Variable | Importancia | Interpretación |
|---|---:|---|
| **Irradiancia_solar_max** | 23.1% | Sin sol fuerte, poco térmico |
| **Air_See_Gradient_max** | 16.5% | Contraste tierra–mar = motor del fenómeno |
| **Night_Day_Gradient** | 15.0% | Amplitud térmica diaria |
| **day_of_year** | 13.6% | Estacionalidad fina (calendario) |
| **pressure_mean** | 12.0% | Contexto sinóptico |
| **sst_mean** | 11.7% | Estado del mar |
| **month** | 3.6% | Estación |
| **precip_total** | 3.3% | Menos relevante pero presente |
| **season_code** | 1.3% | Casi redundante con month/day_of_year |

**Cómo interpretarlo (sin tecnicismos):**
- El Random Forest no «inventa» — prioriza variables que **coinciden con la meteorología del térmico**.
- **Irradiancia + gradientes térmicos** dominan → coherente físicamente.
- **No confundir con causalidad:** importancia alta ≠ «provoca» el viento; significa «ayuda a discriminar días GO vs NO GO».

**Frase para la presentación:**  
*«El modelo aprende lo mismo que ya sospechábamos como navegantes: sol, calor en tierra y contraste con el mar.»*

---

## 5. Qué decir si te preguntan en la defensa

| Pregunta probable | Respuesta corta |
|---|---|
| ¿Por qué Random Forest? | Interpretable, robusto, estándar en bootcamp, da importancia de variables |
| ¿Por qué solo Badalona? | Es tu spot, tienes sensor propio y datos reales verificables |
| ¿Es operativo ya? | Es un prototipo analítico; falta previsión con datos de la mañana |
| ¿Por qué F1 solo 0.52? | Fenómeno local complejo; primer modelo con 9 variables; hay margen de mejora |
| ¿Mejor que la app Buscaviento? | Aún no comparado formalmente con su forecast GFS/ECMWF — posible extensión |
| ¿Qué mejorarías? | Umbral GO/NO GO, features de las 07:00, comparar con forecast comercial |

---

## 6. Glosario mínimo

| Término | Significado |
|---|---|
| **SST** | Sea Surface Temperature — temperatura superficial del mar |
| **Térmico / Sea breeze** | Viento local tierra → mar por diferencia de temperatura |
| **F1** | Media armónica de precisión y recall |
| **AUC** | Área bajo curva ROC — calidad global del clasificador |
| **Recall** | Sensibilidad — % de GO reales detectados |
| **Precisión** | % de GO predichos que son correctos |
| **Feature leakage** | Usar información del futuro para predecir el pasado (evitar en producción) |

---

*Documento generado para uso personal. Si quieres, en la siguiente sesión preparamos respuestas simuladas a preguntas del tribunal del bootcamp.*
