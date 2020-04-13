/* 
Εμφανίστε τον κωδικό και τον τίτλο των βιβλίων για τα οποία η βιβλιοθήκη διαθέτει τουλάχιστον ένα αντίτυπο στην τοποθεσία 'OPA' ΚΑΙ τουλάχιστον ένα αντίτυπο στην τοποθεσία 'ΑΝΑ' 
Να γράψετε τουλάχιστον δύο με τρία διαφορετικά επερωτήματα σε SQL που να απαντούν στο παραπάνω ερώτημα. Ποιό επερώτημα θα επιλέγατε και γιατί;
*/


/* 1ος Τρόπος*/

DBCC DROPCLEANBUFFERS
SET STATISTICS IO ON
SET STATISTICS TIME ON

SELECT DISTINCT Bibrecs.bibno, Bibrecs.title FROM Bibrecs
	JOIN
	(SELECT Bibrecs.bibno FROM Bibrecs
		JOIN Copies
		ON Bibrecs.bibno = Copies.bibno
		WHERE copyloc = 'OPA') AS OPA
	ON Bibrecs.bibno = OPA.bibno
	JOIN
	(SELECT Bibrecs.bibno FROM Bibrecs
		JOIN Copies
		ON Bibrecs.bibno = Copies.bibno
		WHERE copyloc = 'ANA') AS ANA
	ON OPA.bibno = ANA.bibno

SET STATISTICS IO OFF
SET STATISTICS TIME OFF


/* 2ος Τρόπος*/

DBCC DROPCLEANBUFFERS
SET STATISTICS IO ON
SET STATISTICS TIME ON

SELECT DISTINCT Bibrecs.bibno, Bibrecs.title FROM Bibrecs
	JOIN
	(SELECT Bibrecs.bibno FROM Bibrecs, Copies
	WHERE Bibrecs.bibno = Copies.bibno AND copyloc = 'OPA') AS OPA
	ON Bibrecs.bibno = OPA.bibno
	JOIN
	(SELECT Bibrecs.bibno FROM Bibrecs, Copies
	WHERE Bibrecs.bibno = Copies.bibno AND copyloc = 'ANA') AS ANA
	ON OPA.bibno = ANA.bibno

SET STATISTICS IO OFF
SET STATISTICS TIME OFF


/* 3ος Τρόπος*/

DBCC DROPCLEANBUFFERS
SET STATISTICS IO ON
SET STATISTICS TIME ON

SELECT Bibrecs.bibno, Bibrecs.title FROM Bibrecs
JOIN Copies
	ON Bibrecs.bibno = Copies.bibno
	WHERE copyloc = 'OPA'
INTERSECT
SELECT Bibrecs.bibno, Bibrecs.title FROM Bibrecs
JOIN Copies
	ON Bibrecs.bibno = Copies.bibno
	WHERE copyloc = 'ANA'

SET STATISTICS IO OFF
SET STATISTICS TIME OFF



/* Δημιουργείστε κατάλληλα ευρετήρια που θα επιταχύνουν την εκτέλεση του επερωτήματος που επιλέξατε. */

CREATE INDEX Indx ON Copies(copyloc)

DROP INDEX Copies.Indx

