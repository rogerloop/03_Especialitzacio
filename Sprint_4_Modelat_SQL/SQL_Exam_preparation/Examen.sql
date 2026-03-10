# P.1 Mostra la quantitat d'esdeveniments que té cada esport #

SELECT COUNT(Event.Event_name), Sport.Sport_name
FROM EVENT
JOIN Sport ON Sport.Id=Event.Sport_Id
GROUP BY Sport.Sport_name;


# P.2 Mostra el nom de la ciutat i la quantitat de joc olímpics que han organitzat, de les ciutats que han organitzat més d'un joc olímpic#

SELECT City.City_name, COUNT(Games_city.City_id)
FROM City
JOIN Games_city ON City.Id=Games_city.City_id
GROUP BY City.City_name
HAVING COUNT(Games_city.City_id) > 1;

# P.3 Mostra el nom de totes les esportistes (gènere femení) espanyoles que van participar en els jocs de Barcelona 92 i que es diuen Cristina#

SELECT Person.Full_name, Person.Id, Games_competitor.Games_id, Person_region.Region_id, Noc_region.Region_name
FROM Person

JOIN Games_competitor ON Games_competitor.Person_id=Person.Id
JOIN Person_region ON Person_region.Person_id=Person.Id
JOIN Noc_region ON Noc_region.Id=Person_region.Region_id

WHERE Person.Gender = "F" AND Person.Full_name  like "Cristina%" AND Games_id = 1 AND Noc_region.Region_name = "Spain"

GROUP BY Person.Full_name, Person.Id, Person_region.Region_id, Noc_region.Region_name;


# P.4 Mostra el nom de la persona esportista que va guanyar més medalles a Rio de Janeiro#

   SELECT Person.Full_name, Person.Id
   FROM Person
   JOIN Games_competitor ON Games_competitor.Person_id=Person.Id
   JOIN Competitor_event ON Games_competitor.Id=Competitor_event.Competitor_id
   WHERE Games_competitor.Games_id = 21
   AND (Competitor_event.Medal_id = 1 OR Competitor_event.Medal_id = 2 OR Competitor_event.Medal_id = 3)
   GROUP BY Person.Full_name, Person.Id
   HAVING COUNT(Competitor_event.Competitor_id) = (SELECT MAX(Ganadoresmedallas)
                                                  FROM (SELECT  Games_competitor.Person_id, COUNT(Competitor_event.Competitor_id) AS Ganadoresmedallas
														FROM Competitor_event
														JOIN Games_competitor ON Games_competitor.Id=Competitor_event.Competitor_id
	                                                    WHERE Games_competitor.Games_id = 21 AND (Competitor_event.Medal_id = 1 OR Competitor_event.Medal_id = 2 OR Competitor_event.Medal_id = 3)
	                                                    GROUP BY Games_competitor.Person_id) AS TablaA ) 
   ORDER BY Person.Full_name, Person.Id;         
  

  (SELECT MAX(Ganadoresmedallas)
   FROM (SELECT  Games_competitor.Person_id, COUNT(Competitor_event.Competitor_id) AS Ganadoresmedallas
		 FROM Competitor_event
		 JOIN Games_competitor ON Games_competitor.Id=Competitor_event.Competitor_id
		 WHERE Games_competitor.Games_id = 21 AND (Competitor_event.Medal_id = 1 OR Competitor_event.Medal_id = 2 OR Competitor_event.Medal_id = 3)
		 GROUP BY Games_competitor.Person_id) AS TablaA ) AS TablaB
 




# Tabla en la que baso la pregunta

     (SELECT  Games_competitor.Person_id, COUNT(Competitor_event.Competitor_id) AS Ganadoresmedallas
     FROM Competitor_event
	 JOIN Games_competitor ON Games_competitor.Id=Competitor_event.Competitor_id
	 WHERE Games_competitor.Games_id = 21 AND (Competitor_event.Medal_id = 1 OR Competitor_event.Medal_id = 2 OR Competitor_event.Medal_id = 3)
	 GROUP BY Games_competitor.Person_id) AS TABLAA
           
           
	
  
  


# P.5 Qui va guanyar més medalles d'or en atletisme masculí en els jocs de Barcelona 92, Espanya o USA?#


SELECT COUNT(Competitor_event.Competitor_id) AS cantidadmedallas, Noc_region.Region_name
FROM Competitor_event
JOIN Games_competitor ON Games_competitor.Id=Competitor_event.Competitor_id
JOIN Person_region ON Person_region.Person_id=Games_competitor.Person_id
JOIN Noc_region ON Person_region.Region_id=Noc_region.Id
JOIN Event ON Event.Id=Competitor_event.Event_id
WHERE Games_competitor.Games_id = 1 
AND Competitor_event.Medal_id = 1 
AND Noc_region.Region_name IN ("USA","Spain") 
AND Event.Sport_id = 6 AND Event.Event_name like "%Athletics Men%"
GROUP BY Noc_region.Region_name
ORDER BY COUNT(Competitor_event.Competitor_id) DESC


# Comprobación evento atletismo masculino#

SELECT Event.Event_name
FROM Event
WHERE Event.Sport_id = 6 AND Event.Event_name like "%Athletics Men%"



# P.6 Mostra el nom de la persona esportista que té el major pes d’entre tots i totes#

SELECT Person.Full_name, Person.Weight
FROM Person

JOIN (SELECT MAX(Person.Weight) AS Pesomaximo
      FROM Person ) AS PesoMaximoAtletas
      
ON Person.Weight=PesoMaximoAtletas.Pesomaximo
GROUP BY Person.Full_name, Person.Weight;



# P.7 Mostra el nom de la persona esportista que ha guanyat més medalles d’or de cada país, tenint en compte tots els jocs olímpics#

        SELECT TablaA.Full_name, TablaA.Region_name, TablaA.Totalmedallasoro
        
		FROM ( SELECT Noc_region.Region_name, Person.Full_name, COUNT(Competitor_event.Competitor_id) AS Totalmedallasoro
              FROM Competitor_event
              JOIN Games_competitor ON Games_competitor.Id=Competitor_event.Competitor_id
              JOIN Person ON Person.Id=Games_competitor.Person_id
			  JOIN Person_region ON Person_region.Person_id=Person.Id
			  JOIN Noc_region ON Person_region.Region_id=Noc_region.Id
              WHERE Medal_id = 1 
              GROUP BY Person.Full_name, Noc_region.Region_name
              HAVING COUNT(Competitor_event.Competitor_id) >= 2 ) AS TablaA
         
	  JOIN  (SELECT MAX(Totalmedallasoro) AS Medallasmaximas, TablaA.Region_name
			 FROM (SELECT Noc_region.Region_name, Person.Full_name, COUNT(Competitor_event.Competitor_id) AS Totalmedallasoro
                   FROM Competitor_event
                   JOIN Games_competitor ON Games_competitor.Id=Competitor_event.Competitor_id
				   JOIN Person ON Person.Id=Games_competitor.Person_id
			       JOIN Person_region ON Person_region.Person_id=Person.Id
				   JOIN Noc_region ON Person_region.Region_id=Noc_region.Id
                   WHERE Medal_id = 1 
                   GROUP BY Person.Full_name, Noc_region.Region_name
                   HAVING COUNT(Competitor_event.Competitor_id) >= 2 ) AS TablaA
                   
				GROUP BY TablaA.Region_name ) AS TablaB
                   
		 ON TablaA.Region_name=TablaB.Region_name
         AND TablaA.Totalmedallasoro=TablaB.Medallasmaximas
         
         ORDER BY TablaA.Totalmedallasoro DESC; 
         
         # TABLAA PRIMERA TABLA SOBRE LA QUE PLANTEO EL EJERCICIO #
      
	 (SELECT Noc_region.Region_name, Person.Full_name, COUNT(Competitor_event.Competitor_id) AS Totalmedallasoro
     
	 FROM Competitor_event
     
	 JOIN Games_competitor ON Games_competitor.Id=Competitor_event.Competitor_id
	 JOIN Person ON Person.Id=Games_competitor.Person_id
     JOIN Person_region ON Person_region.Person_id=Person.Id
	 JOIN Noc_region ON Person_region.Region_id=Noc_region.Id
     
	 WHERE Medal_id = 1 
     
	 GROUP BY Person.Full_name, Noc_region.Region_name
     
	 HAVING COUNT(Competitor_event.Competitor_id) >= 2 ) AS TablaA
		   
           


# P.8 Mostra els noms dels països que compleixin la següent situació: l’alçada mínima de qualsevol dels seus esportistes masculins és major a l’alçada mitja de tots els esportistes masculin


SELECT Noc_region.Region_name
FROM Noc_region
JOIN Person_region ON Noc_region.Id=Person_region.Region_id
JOIN Person ON Person_region.Person_id=Person.Id
WHERE Gender = "M" AND Person.Height != 0 AND Person.Height IS NOT NULL
GROUP BY Noc_region.Region_name
HAVING MIN(Person.Height) > (SELECT AVG(Person.Height)
                            FROM Person
                            WHERE Gender = "M"AND Person.Height != 0);

# Comprobaciones pregunta 8 #

SELECT AVG(Person.Height)
FROM Person
WHERE Gender = "M"AND Person.Height != 0;

SELECT MIN(Person.height), Noc_region.Region_name
FROM Person
JOIN Person_region ON Person.Id=Person_region.Person_id
JOIN Noc_region ON Person_region.Region_id=Noc_region.Id
WHERE Gender = "M" AND Person.Height != 0 
GROUP BY Noc_region.Region_name;
      





      



