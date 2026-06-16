-- Genera presentación Keynote GO / NO GO
-- Ejecutar: osascript build_keynote.applescript

set projectRoot to "/Users/rogerdefez/Documents/Cursos i Llibres/BootCamp IT Academy/03_Especialitzacio/Project/thermal-wind-prediction/reports/presentation"

tell application "Keynote"
	activate
	set docRef to make new document
	
	tell docRef
		-- Slide 1 Title
		set s1 to make new slide
		tell s1
			set object text of default title item to "GO / NO GO"
			set object text of default body item to "Intelligent Sea Breeze Prediction System" & return & "for Water Sports Using Machine Learning" & return & return & "Roger Defez · Bootcamp Data Analyst"
		end tell
		
		-- Slide 2 Problem
		set s2 to make new slide
		tell s2
			set object text of default title item to "El problema"
			set object text of default body item to "Desplazarte al spot… y que el viento térmico no entre." & return & return & "Tiempo. Gasolina. Frustración."
		end tell
		
		-- Slide 3 Question
		set s3 to make new slide
		tell s3
			set object text of default title item to "La pregunta"
			set object text of default body item to "¿Habrá viento Sur / Suroeste ≥ 10 nudos hoy en Badalona?" & return & return & "GO → Sí, navegable" & return & "NO GO → No"
		end tell
		
		-- Slide 4 Pipeline image
		set s4 to make new slide
		tell s4
			set object text of default title item to "Origen de los datos"
			make new image with properties {file:(POSIX file (projectRoot & "/09_data_pipeline.png")), width:900, height:280, position:{60, 140}}
		end tell
		
		-- Slide 5 Datasets
		set s5 to make new slide
		tell s5
			set object text of default title item to "Los datasets"
			set object text of default body item to "Buscaviento BDLONA · viento spot · 2010-2025" & return & "XEMA Museu Badalona · meteo tierra · 24h" & return & "Boya Barcelona · SST + oleaje · 1h"
		end tell
		
		-- Slide 6 Hypothesis
		set s6 to make new slide
		tell s6
			set object text of default title item to "Hipótesis"
			set object text of default body item to "1. Más sol → más térmico" & return & "2. Más contraste tierra-mar → más térmico" & return & "3. Más amplitud día-noche → más térmico"
		end tell
		
		-- Slide 7 Monthly
		set s7 to make new slide
		tell s7
			set object text of default title item to "Patrón estacional"
			make new image with properties {file:(POSIX file (projectRoot & "/01_monthly_frequency.png")), width:900, height:380, position:{60, 120}}
		end tell
		
		-- Slide 8 Gradient
		set s8 to make new slide
		tell s8
			set object text of default title item to "Validación de la hipótesis"
			make new image with properties {file:(POSIX file (projectRoot & "/03_gradient_probability.png")), width:900, height:380, position:{60, 120}}
		end tell
		
		-- Slide 9 Heatmap
		set s9 to make new slide
		tell s9
			set object text of default title item to "Estación × Mes"
			make new image with properties {file:(POSIX file (projectRoot & "/05_season_month_heatmap.png")), width:900, height:380, position:{60, 120}}
		end tell
		
		-- Slide 10 Model
		set s10 to make new slide
		tell s10
			set object text of default title item to "Random Forest"
			set object text of default body item to "9 variables · 5.806 días" & return & return & "Train → 2010-2021" & return & "Test → 2024-2025"
		end tell
		
		-- Slide 11 Metrics
		set s11 to make new slide
		tell s11
			set object text of default title item to "Resultados"
			make new image with properties {file:(POSIX file (projectRoot & "/10_metrics_summary.png")), width:780, height:360, position:{110, 130}}
		end tell
		
		-- Slide 12 Confusion matrix
		set s12 to make new slide
		tell s12
			set object text of default title item to "Matriz de confusión"
			make new image with properties {file:(POSIX file (projectRoot & "/06_confusion_matrix.png")), width:520, height:420, position:{250, 110}}
		end tell
		
		-- Slide 13 Feature importance
		set s13 to make new slide
		tell s13
			set object text of default title item to "Qué aprendió el modelo"
			make new image with properties {file:(POSIX file (projectRoot & "/08_feature_importance.png")), width:900, height:420, position:{60, 110}}
		end tell
		
		-- Slide 14 Conclusions
		set s14 to make new slide
		tell s14
			set object text of default title item to "Conclusiones"
			set object text of default body item to "✓ Datos reales · 16 años · Badalona" & return & "✓ Hipótesis física confirmada" & return & "✓ ML supera el azar (AUC 0.71)" & return & return & "Próximo paso: previsión operativa a las 07:00"
		end tell
		
		-- Slide 15 ROC backup
		set s15 to make new slide
		tell s15
			set object text of default title item to "Curva ROC (backup)"
			make new image with properties {file:(POSIX file (projectRoot & "/07_roc_curve.png")), width:620, height:520, position:{200, 90}}
		end tell
		
		-- Remove default empty first slide
		try
			delete slide 1
		end try
		
		set outPath to projectRoot & "/GO_NO_GO_Sea_Breeze_Presentation.key"
		save docRef in (POSIX file outPath)
	end tell
end tell
