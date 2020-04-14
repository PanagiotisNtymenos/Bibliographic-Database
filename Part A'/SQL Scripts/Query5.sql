/* Εμφάνισε τον κωδικό και τον τίτλο των βιβλιογραφικών εγγραφών που περιέχουν στον τίτλο την λέξη "οικονομία" στην σειρά την λέξη "ελληνική" και στον συγγραφέα την λέξη "Οικονόμου. */

DROP TABLE Bibwords
DROP TABLE Words
DROP TABLE Entity_type

CREATE TABLE entity_type
( typeid INT PRIMARY KEY,
  typename VARCHAR (10)
);


CREATE TABLE words
( wid INT PRIMARY KEY, 
  word VARCHAR(50),
  typeid INT FOREIGN KEY REFERENCES entity_type(typeid)
);


CREATE TABLE bibwords
( wid INT FOREIGN KEY REFERENCES words(wid), 
  bibno INT FOREIGN KEY REFERENCES bibrecs(bibno),
  PRIMARY KEY(wid)
);


SELECT Bibrecs.bibno, Bibrecs.title FROM Bibrecs
	JOIN 
	(SELECT Bibwords.bibno FROM Bibwords
		JOIN Words
		ON Bibwords.wid = Words.wid
		JOIN Entity_type
		ON Words.typeid = Entity_type.typeid
		WHERE Words.typeid = 1 AND Words.word = 'Οικονομία') AS TITL
	ON Bibrecs.bibno = TITL.bibno
	JOIN 
	(SELECT Bibwords.bibno FROM Bibwords
		JOIN Words
		ON Bibwords.wid = Words.wid
		JOIN Entity_type
		ON Words.typeid = Entity_type.typeid
		WHERE Words.typeid = 2 AND Words.word = 'Ελληνική') AS SER
	ON TITL.bibno = SER.bibno
	JOIN 
	(SELECT Bibwords.bibno FROM Bibwords
		JOIN Words
		ON Bibwords.wid = Words.wid
		JOIN Entity_type
		ON Words.typeid = Entity_type.typeid
		WHERE Words.typeid = 4 AND Words.word = 'Οικονόμου') AS AUTH
	ON SER.bibno = AUTH.bibno
ORDER BY Bibrecs.bibno


