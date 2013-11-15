-- c1
INSERT INTO Professeur
VALUES('TR4J5','Tremblay','Jean');

INSERT INTO Professeur
VALUES('TREJ6','Tremblay','Jean');

INSERT INTO Professeur
VALUES('TREJF','Tremblay','Jean');

-- c2
UPDATE Inscription
SET note = null 
WHERE codePermanent = 'DUGR08085001'; 

UPDATE Inscription
SET note = 101 
WHERE codePermanent = 'DUGR08085001'; 

UPDATE Inscription
SET note = 100 
WHERE codePermanent = 'DUGR08085001'; 

-- c3
UPDATE Inscription
SET dateAbandon = NULL 
WHERE codePermanent = 'DUGR08085001'; 

UPDATE Inscription
SET dateAbandon = '07/05/1989' 
WHERE codePermanent = 'DUGR08085001'; 

-- c4
UPDATE Inscription
SET dateAbandon = NULL, note = 100
WHERE codePermanent = 'DUGR08085001'; 

UPDATE Inscription
SET dateAbandon = '07/05/2010' , note = 80
WHERE codePermanent = 'DUGR08085001'; 

UPDATE Inscription
SET dateAbandon = '07/05/2010' , note = NULL
WHERE codePermanent = 'DUGR08085001'; 


--c5
DELETE FROM GROUPECOURS
WHERE NOGROUPE=20;

--c6
UPDATE GroupeCours
SET maxinscriptions = 80
WHERE NOGROUPE = 20 and SIGLE = 'INF1110'; 
