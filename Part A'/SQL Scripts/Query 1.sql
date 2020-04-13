CREATE INDEX Indx ON Bibrecs(title);

SELECT title FROM Bibrecs WHERE title LIKE 'Οικ%'
ORDER BY title