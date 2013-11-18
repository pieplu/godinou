INSERT INTO Professeur
   VALUES('ULLJT','Ullman','Jeffrey')
/





UPDATE Inscription
SET note=150
WHERE codePermanent ='TREJ18088001' AND sigle = 'INF1110' AND noGroupe =
20 AND codeSession = 32003
/






UPDATE Inscription
   SET dateAbandon = '15/08/2003'
   WHERE codePermanent ='VANV05127201' AND sigle = 'INF3180' AND noGroupe =
30 AND codeSession = 32003
/






UPDATE Inscription
   SET dateAbandon = '17/08/2003'
   WHERE codePermanent ='TREJ18088001' AND sigle = 'INF1110' AND noGroupe =
20 AND codeSession = 32003
/






SELECT * FROM Inscription
 WHERE sigle ='INF5180' AND noGroupe = 40 AND codeSession = 12004 
 /
DELETE FROM GroupeCours

DELETE FROM GroupeCours
WHERE sigle ='INF5180' AND noGroupe = 40 AND codeSession = 12004 
/

SELECT * FROM Inscription
 WHERE sigle ='INF5180' AND noGroupe = 40 AND codeSession = 12004 
/

ROLLBACK 
/





UPDATE GroupeCours
 SET maxInscriptions = maxInscriptions-20
 WHERE sigle = 'INF1110' AND noGroupe = 20 AND codeSession = 32003 
 /

