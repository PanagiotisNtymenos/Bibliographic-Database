/* Να γράψετε τις κατάλληλες εντολές SQL για την δημιουργία των πινάκων words και bibwords. Να ορίσετε τα κλειδιά του κάθε πίνακα (πρωτεύοντα και ξένα κλειδιά). */

CREATE TABLE words
( wid INT PRIMARY KEY, 
  word VARCHAR(50)
);


CREATE TABLE bibwords
( wid INT FOREIGN KEY REFERENCES words(wid), 
  bibno INT FOREIGN KEY REFERENCES bibrecs(bibno),
  PRIMARY KEY(wid)
);


/* Να δημιουργήσετε κατάλληλα ευρετήρια που να επιταχύνουν την εκτέλεση των ερωτημάτων της παραπάνω μορφής. */

CREATE INDEX IndxB ON Bibrecs(title, series)

CREATE INDEX IndxP ON Publishers(pubname)

CREATE INDEX IndxA ON Authors(author)

CREATE INDEX IndxS ON Sterms(term)

CREATE INDEX IndxW ON Words(word)

DROP INDEX Bibrecs.IndxB

DROP INDEX Publishers.IndxP

DROP INDEX Authors.IndxA

DROP INDEX Sterms.IndxS

DROP INDEX Words.IndxW