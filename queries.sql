SELECT w.* 
FROM Workshops w 
JOIN Festivals f ON w.FestivalID = f.FestivalId
WHERE w.Level = 'advanced'
	AND f.StartDate >= '2025-01-01'
	AND f.EndDate <= '2025-12-31';


SELECT a.Name AS Artist,
	   f.Name AS Festival,
	   s.Name AS Stage,
	   p.StartTime,
	   p.ExpectedVisitors
FROM Performances p
JOIN Artists a ON p.ArtistId = a.ArtistId
JOIN Festivals f ON p.FestivalId = f.FestivalId
JOIN Stages s ON p.StageId = s.StageId 
WHERE p.ExpectedVisitors > 10000;


SELECT *
FROM Festivals
WHERE StartDate >= '2025-01-01'
  AND EndDate <= '2025-12-31';


SELECT *
FROM Workshops
WHERE Level = 'advanced';


SELECT *
FROM Workshops
WHERE DurationHours >= 4;


SELECT *
FROM Workshops
WHERE RequiresKnowledge = TRUE;


SELECT *
FROM Mentors
WHERE YearExperience >= 10;


SELECT *
FROM Mentors
WHERE BirthYear < 1985;


SELECT *
FROM Visitors
WHERE City = 'Split';


SELECT *
FROM Visitors
WHERE Email LIKE '%@gmail.com';


SELECT *
FROM Visitors
WHERE BirthDate > (CURRENT_DATE - INTERVAL '25 years');


SELECT *
FROM Tickets
WHERE Price > 120;


SELECT *
FROM Tickets
WHERE Type = 'VIP';


SELECT *
FROM Tickets
WHERE Type = 'festival'
  AND Validity = 'festival';


SELECT *
FROM Staff
WHERE HasSecurityTraining = TRUE;




