# GO / NO GO — Guion de presentación Keynote (15–20 min)

**Título:** Intelligent Sea Breeze Prediction System for Water Sports Using Machine Learning  
**Estilo:** Fondo oscuro · Texto blanco · Acento turquesa `#2DD4BF` · Pocas palabras · Mucho gráfico  
**Gráficos:** carpeta `reports/presentation/`  
**Duración objetivo:** ~16 minutos (14 diapositivas + 2 min preguntas)

---

## Diapositiva 1 — Portada (1 min)

**Visual:** Foto fullscreen mar / windsurf Badalona (opacidad 40%, overlay oscuro)

**Texto en pantalla:**
```
GO / NO GO

Intelligent Sea Breeze Prediction System
for Water Sports Using Machine Learning

Roger Defez · Bootcamp Data Analyst · Badalona 2010–2025
```

**Notas orador:**  
*«Hoy no os voy a hablar de otro dashboard genérico. Os presento una pregunta que todo windsurfista se hace: ¿merece la pena ir hoy al spot?»*

---

## Diapositiva 2 — El problema (1 min)

**Visual:** Fondo oscuro, icono windsurf minimalista

**Texto:**
```
El problema

Desplazarte al spot…
y que el viento térmico no entre.

Tiempo. Gasolina. Frustración.
```

**Notas orador:**  
*«En Catalunya el viento térmico es muy local. Los modelos globales a veces fallan. Yo vivo esto cada verano.»*

---

## Diapositiva 3 — La pregunta del proyecto (1 min)

**Visual:** GO / NO GO en tipografía grande (verde turquesa / gris)

**Texto:**
```
¿Habrá viento Sur / Suroeste
≥ 10 nudos hoy en Badalona?

GO  →  Sí, navegable
NO GO  →  No
```

**Notas orador:**  
*«Esta es la pregunta exacta. Dirección 135°–225°, media mínima 10 nudos, datos reales del sensor de la playa.»*

---

## Diapositiva 4 — Origen de los datos (1.5 min)

**Visual:** `09_data_pipeline.png` a pantalla casi completa

**Texto mínimo (esquina):**
```
3 fuentes · 16 años · 1 decisión diaria
```

**Notas orador:**  
*«Tres datasets reales: sensor Buscaviento en BDLONA, estación XEMA en el Museu de Badalona, y boya de Barcelona para temperatura del mar. Los integramos hora a hora y agregamos a día.»*

---

## Diapositiva 5 — Los datasets (1.5 min)

**Visual:** Tres columnas, fondo oscuro

| Buscaviento | XEMA | Boya |
|---|---|---|
| Viento spot | Aire, sol, presión | SST + oleaje |
| ~15 min, diurno | 1 h, 24 h | 1 h |
| 2010–2025 | Museu Badalona | Barcelona |

**Notas orador:**  
*«Buscaviento es la verdad del spot — ahí medimos si acertamos. XEMA aporta calor, sol y presión de tierra. La boya aporta el mar.»*

---

## Diapositiva 6 — Hipótesis (1.5 min)

**Visual:** 3 bloques turquesa

**Texto:**
```
Hipótesis

1. Más sol → más térmico
2. Más contraste tierra–mar → más térmico
3. Más amplitud día–noche → más térmico
```

**Variables clave:**
- Irradiancia solar máxima  
- Air_See_Gradient_max  
- Night_Day_Gradient  

**Notas orador:**  
*«Partimos de física conocida. No dejamos que el ML invente — le damos variables con sentido meteorológico.»*

---

## Diapositiva 7 — Patrón estacional (1 min)

**Visual:** `01_monthly_frequency.png` fullscreen

**Texto:** `El térmico no es un fenómeno de invierno`

**Notas orador:**  
*«Antes del modelo, miramos los datos. El pico está claro: mayo a agosto. Un tercio de los días históricos tienen viento S/SO ≥ 10 kt.»*

---

## Diapositiva 8 — Validación de la hipótesis (1.5 min)

**Visual:** Split: `03_gradient_probability.png` (izq) + `04_night_day_boxplot.png` (der)

**Texto:** `Los datos confirman la intuición`

**Notas orador:**  
*«A mayor gradiente aire-mar, sube la probabilidad. Los días GO tienen más contraste térmico día-noche. La hipótesis aguanta.»*

---

## Diapositiva 9 — Mapa estacional (45 s)

**Visual:** `05_season_month_heatmap.png`

**Texto:** *(sin texto extra — dejar respirar el gráfico)*

**Notas orador:**  
*«Vista rápida: verano + calor = zona roja. Esto justifica un modelo estacional, no un único umbral para todo el año.»*

---

## Diapositiva 10 — El modelo (1 min)

**Visual:** Fondo oscuro, esquema simple

**Texto:**
```
Random Forest
9 variables · 5.806 días

Train → 2010–2021
Test  → 2024–2025
```

**Notas orador:**  
*«Random Forest: ensemble de árboles, interpretable, estándar en ML. Split temporal — no mezclamos el futuro con el pasado. Solo 9 variables, nada de 61.»*

*(No entres en detalle de hiperparámetros — está en la guía personal.)*

---

## Diapositiva 11 — Resultados (1.5 min)

**Visual:** `10_metrics_summary.png`

**Notas orador:**  
*«En test 2024–2025: AUC 0.71 — mejor que el azar. F1 0.52 — primer modelo, mejorable. Detectamos el 62% de los días buenos. Cuando dice GO, acierta el 45%. No es perfecto, pero es una base sólida.»*

---

## Diapositiva 12 — Matriz de confusión (1.5 min)

**Visual:** `06_confusion_matrix.png`

**Texto pequeño:**
```
138 días acertados · 171 falsos GO · 86 días perdidos
```

**Notas orador:**  
*«De 731 días de test: 138 veces dijimos GO y acertamos. 171 veces fuimos optimistas de más — el error que más duele al windsurfista. 86 días buenos que no detectamos. El trade-off es calibrable.»*

---

## Diapositiva 13 — Qué aprendió el modelo (1 min)

**Visual:** `08_feature_importance.png`

**Texto:** `Sol + gradientes térmicos = motor del térmico`

**Notas orador:**  
*«El modelo prioriza irradiancia solar y gradientes térmicos — exactamente lo que esperábamos. No ha aprendido ruido: ha aprendido meteorología.»*

---

## Diapositiva 14 — Conclusiones (1.5 min)

**Visual:** Foto mar + overlay

**Texto:**
```
Conclusiones

✓ Datos reales · 16 años · Badalona
✓ Hipótesis física confirmada
✓ ML supera el azar (AUC 0.71)

Próximo paso
Previsión operativa a las 07:00
```

**Notas orador:**  
*«Esto es un prototipo inteligente GO/NO GO, no la app final. El siguiente paso es predecir por la mañana con datos disponibles entonces y comparar con GFS. Gracias.»*

---

## Diapositiva 15 (opcional backup) — Curva ROC

**Visual:** `07_roc_curve.png`  
**Usar solo si preguntan por calidad del modelo.**

---

## Checklist montaje Keynote

1. Tema oscuro (Black / Gradient oscuro de Apple)
2. Fuente: **SF Pro Display** (títulos) + **SF Pro Text** (cuerpo)
3. Color acento: `#2DD4BF`
4. Insertar PNGs desde `reports/presentation/`
5. Fotos mar: Unsplash / tus propias (Badalona, Platja dels Pescadors)
6. Activar **Rehearsal** en Keynote → objetivo 16 min

---

## Archivos de apoyo

| Archivo | Uso |
|---|---|
| `GUIA_PERSONAL_GRAFICOS_Y_MODELO.md` | Estudio privado — gráficos y metodología |
| `KEYNOTE_SPEAKER_NOTES.md` | Este guion |
| `*.png` | Gráficos listos para insertar |
| `model_metrics.csv` | Cifras exactas |
