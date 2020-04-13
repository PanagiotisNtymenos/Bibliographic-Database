/* Να δημιουργήσετε κατάλληλο ευρετήριο που να επιταχύνει την εκτέλεση του παρακάτω ερωτήματος. */

CREATE INDEX Indx ON Bibrecs(title);

DROP INDEX Bibrecs.Indx;


SELECT title FROM Bibrecs WHERE title LIKE 'Οικ%'
ORDER BY title




/* Εμφάνισε τον τίτλο των τεκμηρίων που περιέχουν στον τίτλο την λέξη πληροφορική. */

DBCC DROPCLEANBUFFERS
SET STATISTICS IO ON
SET STATISTICS TIME ON

SELECT title FROM Bibrecs WHERE title LIKE '%Πληροφορική%'
ORDER BY title

SET STATISTICS IO OFF
SET STATISTICS TIME OFF


/* Εμφάνισε τον τίτλο, και το είδος των τεκμηρίων με τίτλο "Economics". */

DBCC DROPCLEANBUFFERS
SET STATISTICS IO ON
SET STATISTICS TIME ON

SELECT title, material FROM Bibrecs WHERE title = 'Economics'
ORDER BY title

SET STATISTICS TIME OFF
SET STATISTICS IO OFF


/* Εμφάνισε τον τίτλο και το είδος των τεκμηρίων των οποίων ο τίτλος ξεκινάει με την λέξη "Economics". */

DBCC DROPCLEANBUFFERS
SET STATISTICS IO ON
SET STATISTICS TIME ON

SELECT title, material FROM Bibrecs WHERE title LIKE 'Economics%'
ORDER BY title

SET STATISTICS TIME OFF
SET STATISTICS IO OFF


