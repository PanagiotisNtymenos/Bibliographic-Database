/* Εμφανίστε τον τίτλο και την γλώσσα των τεκμηρίων πού έχει εκδώσει ο 'Κλειδάριθμος'. */

DBCC DROPCLEANBUFFERS
SET STATISTICS IO ON
SET STATISTICS TIME ON

SELECT title, lang FROM Bibrecs 
JOIN Publishers 
ON Publishers.pubid = Bibrecs.pubid
WHERE Publishers.pubname = 'Κλειδάριθμος'
ORDER BY title

SET STATISTICS IO OFF
SET STATISTICS TIME OFF


/* Εμφανίστε έναν κατάλογο με το όνομα κάθε τμήματος και τον συνολικό αριθμό των δανεισμών που έγιναν από τα μέλη του το έτος 2000. */

DBCC DROPCLEANBUFFERS
SET STATISTICS IO ON
SET STATISTICS TIME ON

SELECT depname, COUNT(Loanstats.lid) AS loans FROM Departments 
LEFT JOIN Borrowers 
ON Departments.depcode = Borrowers.depcode
JOIN Loanstats 
ON Borrowers.bid = Loanstats.bid
WHERE Loanstats.loandate LIKE '2000%'
GROUP BY depname

SET STATISTICS IO OFF
SET STATISTICS TIME OFF


/* Εμφανίστε έναν κατάλογο με τον τίτλο, την γλώσσα και το όνομα του συγγραφέα (ή των συγγραφέων) των τεκμηρίων στα οποία έχει αποδοθεί ο θεματικός όρος "Databases". */

DBCC DROPCLEANBUFFERS
SET STATISTICS IO ON
SET STATISTICS TIME ON

SELECT title, lang, author FROM Bibrecs 
JOIN Bibauthors 
ON Bibrecs.bibno = Bibauthors.bibno
JOIN Authors 
ON Bibauthors.aid = Authors.aid
JOIN Bibterms 
ON Bibrecs.bibno = Bibterms.bibno
JOIN Sterms 
ON Bibterms.tid = Sterms.tid
WHERE term = 'Databases'
ORDER BY title

SET STATISTICS IO OFF
SET STATISTICS TIME OFF


/* 
Να δημιουργήσετε κατάλληλα ευρετήρια που θα επιταχύνουν την εκτέλεση των παραπάνω ερωτημάτων. 
Να παραθέσετε τις εντολές δημιουργίας των ευρετηρίων, καθώς επίσης και στοιχεία που να αποδεικνύουν ότι, 
τα ευρετήρια που δημιουργήσατε επιταχύνουν την εκτέλεση των ερωτημάτων. 
*/

/* A */

CREATE INDEX IndxA ON Publishers(pubname)

DROP INDEX Publishers.IndxA;


/* B */

CREATE INDEX IndxB ON Loanstats(lid, loandate)

DROP INDEX Loanstats.IndxB;


/* C */

CREATE INDEX IndxC ON Sterms(term)

DROP INDEX Sterms.IndxC;
