SQL> START tp2Temp_Alexis.sql                                                                                                                                                      
SQL> --C1
SQL> ALTER TABLE professeur
  2  ADD CONSTRAINT checkCodeProf CHECK(REGEXP_LIKE(codeProfesseur, '[A-Z]{4}[0-9]')) --OK
  3  /

Table altered.

SQL> --C2
SQL> ALTER TABLE inscription
  2  ADD CONSTRAINT checkNote CHECK(note >= 0 AND note <= 100) --OK
  3  /

Table altered.

SQL> --C3
SQL> ALTER TABLE inscription
  2  ADD CONSTRAINT checkDateAb CHECK(dateAbandon >= dateInscription OR dateAbandon IS NULL) --OK
  3  /

Table altered.

SQL> --C4
SQL> ALTER TABLE inscription
  2  ADD CONSTRAINT checkAbandonNote CHECK((dateAbandon IS NOT NULL AND note IS NULL) OR (dateAbandon IS NULL)) --OK
  3  /

Table altered.

SQL> --C5
SQL> ALTER TABLE INSCRIPTION
  2  DROP CONSTRAINT CEREFGROUPECOURS
  3  /

Table altered.

SQL> ALTER TABLE INSCRIPTION
  2  ADD CONSTRAINT CEREFGROUPECOURS FOREIGN KEY        (sigle,noGroupe,codeSession) REFERENCES GroupeCours
  3  ON DELETE CASCADE
  4  /

Table altered.

SQL> 
SQL> --C6
SQL> CREATE OR REPLACE trigger limiteDiminutionMaxInscription
  2  before update of maxinscriptions on GROUPECOURS
  3  REFERENCING
  4  OLD AS LIGNEAVANT
  5  NEW AS LIGNEAPRES
  6  FOR EACH ROW
  7  WHEN (LIGNEAPRES.MAXINSCRIPTIONs < LIGNEAVANT.MAXINSCRIPTIONs*0.9)
  8  BEGIN
  9  
 10    :LIGNEAPRES.MAXINSCRIPTIONS := :LIGNEAVANT.MAXINSCRIPTIONS * 0.9;
 11  
 12  END;
 13  /

Trigger created.

SQL> 
SQL> 
SQL> 
SQL> 
SQL> START testExo2.sql                                                                                                                                                            
SQL> PROMPT Test de violation de la contrainte C1
Test de violation de la contrainte C1
SQL> INSERT INTO Professeur
  2  VALUES('ULLJT','Ullman','Jeffrey')
  3  /
INSERT INTO Professeur
*
ERROR at line 1:
ORA-02290: violation de contraintes (HJ991118.CHECKCODEPROF) de verification


SQL> 
SQL> 
SQL> PROMPT Test de violation de la contrainte C2
Test de violation de la contrainte C2
SQL> UPDATE Inscription
  2  SET note=150
  3  WHERE codePermanent ='TREJ18088001' AND sigle = 'INF1110' AND noGroupe =
  4  AND codeSession = 32003
  5  /
AND codeSession = 32003
*
ERROR at line 4:
ORA-00936: expression absente


SQL> 
SQL> 
SQL> PROMPT Test de violation de la contrainte C3
Test de violation de la contrainte C3
SQL> UPDATE Inscription
  2  SET dateAbandon = '15/08/2003'
  3  WHERE codePermanent ='VANV05127201' AND sigle = 'INF3180' AND noGroupe =
  4  30 AND codeSession = 32003
  5  /
UPDATE Inscription
*
ERROR at line 1:
ORA-02290: violation de contraintes (HJ991118.CHECKDATEAB) de verification


SQL> 
SQL> 
SQL> PROMPT Test de violation de la contrainte C4
Test de violation de la contrainte C4
SQL> UPDATE Inscription
  2  SET dateAbandon = '17/08/2003'
  3  WHERE codePermanent ='TREJ18088001' AND sigle = 'INF1110' AND noGroupe =
  4  20 AND codeSession = 32003
  5  /
UPDATE Inscription
*
ERROR at line 1:
ORA-02290: violation de contraintes (HJ991118.CHECKABANDONNOTE) de verification


SQL> 
SQL> 
SQL> PROMPT Test de la contrainte C5
Test de la contrainte C5
SQL> SELECT * FROM Inscription
  2  WHERE sigle ='INF5180' AND noGroupe = 40 AND codeSession = 12004
  3  /

CODEPERMANEN SIGLE     NOGROUPE CODESESSION DATEINSCRI DATEABANDO       NOTE
------------ ------- ---------- ----------- ---------- ---------- ----------
EMEK10106501 INF5180         40       12004 19/12/2003                    80

SQL> 
SQL> 
SQL> 
SQL> DELETE FROM GroupeCours
  2  WHERE sigle ='INF5180' AND noGroupe = 40 AND codeSession = 12004
  3  /

1 row deleted.

SQL> 
SQL> SELECT * FROM Inscription
  2  WHERE sigle ='INF5180' AND noGroupe = 40 AND codeSession = 12004
  3  /

no rows selected

SQL> 
SQL> 
SQL> ROLLBACK
  2  /

Rollback complete.

SQL> 
SQL> 
SQL> PROMPT Test de violation de la contrainte C6
Test de violation de la contrainte C6
SQL> UPDATE GroupeCours
  2  SET maxInscriptions = maxInscriptions-20
  3  WHERE sigle = 'INF1110' AND noGroupe = 20 AND codeSession = 32003
  4  /

1 row updated.

SQL> 