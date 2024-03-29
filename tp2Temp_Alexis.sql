
--------------------
--   QUESTION 1   --
--------------------

--C1
ALTER TABLE professeur
ADD CONSTRAINT checkCodeProf CHECK(REGEXP_LIKE(codeProfesseur, '[A-Z]{4}[0-9]')) 
/
--C2
ALTER TABLE inscription
ADD CONSTRAINT checkNote CHECK(note >= 0 AND note <= 100) 
/
--C3
ALTER TABLE inscription
ADD CONSTRAINT checkDateAb CHECK(dateAbandon >= dateInscription OR dateAbandon IS NULL)
/
--C4
ALTER TABLE inscription
ADD CONSTRAINT checkAbandonNote CHECK((dateAbandon IS NOT NULL AND note IS NULL) OR (dateAbandon IS NULL))
/
--C5
ALTER TABLE INSCRIPTION
DROP CONSTRAINT CEREFGROUPECOURS
/
ALTER TABLE INSCRIPTION
ADD CONSTRAINT CEREFGROUPECOURS FOREIGN KEY (sigle,noGroupe,codeSession) REFERENCES GroupeCours
ON DELETE CASCADE
/

--C6
CREATE OR REPLACE TRIGGER limiteDiminutionMaxInscription
BEFORE UPDATE OF maxinscriptions ON GROUPECOURS
FOR EACH ROW
WHEN (NEW.MAXINSCRIPTIONs < OLD.MAXINSCRIPTIONs*0.9)
BEGIN
  raise_application_error(-20102, 'Diminution de plus de 10% de maxInscriptions est interdite');
END;
/

--------------------
--   QUESTION 2   --
--------------------

PROMPT Test de violation de la contrainte C1
INSERT INTO Professeur
VALUES('ULLJT','Ullman','Jeffrey')
/

ROLLBACK 
/

PROMPT Test de violation de la contrainte C2
UPDATE Inscription
SET note=150
WHERE codePermanent ='TREJ18088001' AND sigle = 'INF1110' AND noGroupe = 20
AND codeSession = 32003
/

ROLLBACK 
/

PROMPT Test de violation de la contrainte C3
UPDATE Inscription
SET dateAbandon = '15/08/2003'
WHERE codePermanent ='VANV05127201' AND sigle = 'INF3180' AND noGroupe =30 
AND codeSession = 32003
/

ROLLBACK 
/

PROMPT Test de violation de la contrainte C4
UPDATE Inscription
SET dateAbandon = '17/08/2003'
WHERE codePermanent ='TREJ18088001' AND sigle = 'INF1110' AND noGroupe =20
AND codeSession = 32003
/

ROLLBACK 
/

PROMPT Test de la contrainte C5
SELECT * FROM Inscription
WHERE sigle ='INF5180' AND noGroupe = 40 AND codeSession = 12004 
/
DELETE FROM GroupeCours
WHERE sigle ='INF5180' AND noGroupe = 40 AND codeSession = 12004 
/
SELECT * FROM Inscription
WHERE sigle ='INF5180' AND noGroupe = 40 AND codeSession = 12004 
/

ROLLBACK 
/

PROMPT Test de violation de la contrainte C6
UPDATE GroupeCours
SET maxInscriptions = maxInscriptions-20
WHERE sigle = 'INF1110' AND noGroupe = 20 AND codeSession = 32003 
/

ROLLBACK 
/


--------------------
--   QUESTION 3   --
--------------------

ALTER TABLE GroupeCours ADD nbInscriptions NUMBER DEFAULT 0 NOT NULL
/
--C7
ALTER TABLE GroupeCours 
ADD CONSTRAINT nbInsNonNeg CHECK(nbInscriptions >= 0)
/

--Fonction fNbInscriptions
CREATE OR REPLACE 
FUNCTION fNbInscriptions
(lesigle Inscription.sigle%TYPE,
lenoGroupe Inscription.noGroupe%TYPE,
lecodeSession Inscription.codeSession%TYPE
) 
Return INTEGER
IS
nbInscrits integer;
BEGIN
	SELECT COUNT(codePermanent) 
	INTO nbInscrits 
	FROM inscription 
	WHERE sigle= lesigle and nogroupe = lenogroupe and codesession = lecodesession and dateabandon is NULL;  
	Return nbInscrits;
END;
/

--UPDATE de la colonne nbInscriptions
DECLARE
  CURSOR groupe_cur 
  IS
  SELECT sigle, noGroupe, codeSession
  FROM groupeCours;

  groupe_rec groupe_cur%rowtype;

BEGIN
	OPEN groupe_cur;
	LOOP
		FETCH groupe_cur INTO groupe_rec;
		EXIT WHEN groupe_cur%NOTFOUND;
		
		UPDATE groupecours
			SET nbinscriptions = fnbinscriptions(groupe_rec.sigle, groupe_rec.nogroupe, groupe_rec.codesession)
			WHERE sigle = groupe_rec.sigle and nogroupe = groupe_rec.nogroupe and codesession = groupe_rec.codesession;
	END LOOP;
	CLOSE groupe_cur;
END;
/

--------------------
--   QUESTION 5   --
--------------------

CREATE OR REPLACE TRIGGER MAJnbInscription
AFTER INSERT ON INSCRIPTION
FOR EACH ROW
BEGIN
	UPDATE GroupeCours
	SET nbInscriptions = nbInscriptions + 1
	WHERE sigle = :NEW.sigle AND noGroupe = :NEW.noGroupe AND codeSession = :NEW.codeSession;
END;
/

--------------------
--   QUESTION 6   --
--------------------

CREATE VIEW MoyenneParGroupe (SIGLE, NOGROUPE, CODESESSION, MOYENNENOTE)
AS SELECT sigle, noGroupe, codeSession, AVG(note)
FROM Inscription
GROUP BY sigle, noGroupe, codeSession
/



create or replace 
trigger InsteadUpdateMoyenneParGroupe
INSTEAD OF UPDATE ON MoyenneParGroupe
FOR EACH ROW
DECLARE
	nbNotes Inscription.note%TYPE;
	vieuTotal MoyenneParGroupe.moyenneNote%TYPE;
	nouvTotal MoyenneParGroupe.moyenneNote%TYPE;
	dif number;

BEGIN
	SELECT COUNT(note) INTO nbNotes FROM inscription WHERE :OLD.sigle = :NEW.sigle AND :OLD.noGroupe = :NEW.noGroupe AND :OLD.codeSession = :NEW.codeSession;
	vieuTotal := :OLD.moyenneNote * nbNotes;
	nouvTotal := :NEW.moyenneNote * nbNotes;
	dif := (nouvTotal - vieuTotal)/nbNotes;
	UPDATE Inscription
	SET note = note + dif
	WHERE :OLD.sigle = :NEW.sigle AND :OLD.noGroupe = :NEW.noGroupe AND :OLD.codeSession = :NEW.codeSession;

END;
/

UPDATE MoyenneParGroupe
SET moyenneNote = 70
WHERE sigle = 'INF1130'AND noGroupe = 10 AND codeSession = 32003
/

SELECT * FROM MoyenneParGroupe
WHERE sigle = 'INF1130'AND noGroupe = 10 AND codeSession = 32003
/

SELECT * FROM Inscription
WHERE sigle = 'INF1130'AND noGroupe = 10 AND codeSession = 32003
/
