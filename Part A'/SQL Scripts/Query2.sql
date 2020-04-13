/* Εμφανίστε τον τίτλο και την γλώσσα των τεκμηρίων πού έχει εκδώσει ο 'Κλειδάριθμος'. */

SELECT title, lang FROM Bibrecs 
JOIN Publishers 
ON Publishers.pubid = Bibrecs.pubid
WHERE Publishers.pubname = 'Κλειδάριθμος'
ORDER BY title


/* Εμφανίστε έναν κατάλογο με το όνομα κάθε τμήματος και τον συνολικό αριθμό των δανεισμών που έγιναν από τα μέλη του το έτος 2000. */

SELECT depname, COUNT(Loanstats.lid) AS loans FROM Departments 
LEFT JOIN Borrowers 
ON Departments.depcode = Borrowers.depcode
JOIN Loanstats 
ON Borrowers.bid = Loanstats.bid
WHERE Loanstats.loandate LIKE '2000%'
GROUP BY depname


/* Εμφανίστε έναν κατάλογο με τον τίτλο, την γλώσσα και το όνομα του συγγραφέα (ή των συγγραφέων) των τεκμηρίων στα οποία έχει αποδοθεί ο θεματικός όρος "Databases". */

SELECT title, lang, author AS loans FROM Bibrecs 
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

