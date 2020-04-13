CREATE INDEX Indx ON Bibrecs(title);

SELECT Title FROM Bibrecs WHERE Title like 'Οικ%'
ORDER BY Title