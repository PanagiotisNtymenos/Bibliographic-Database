CREATE INDEX Indx ON Bibrecs(title);

SELECT Title FROM Bibrecs WHERE Title LIKE 'Οικ%'
ORDER BY Title