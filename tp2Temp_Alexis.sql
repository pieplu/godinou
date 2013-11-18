
--------------------
--   QUESTION 1   --
--------------------

--C1
ALTER TABLE professeur
ADD CONSTRAINT checkCodeProf CHECK(REGEXP_LIKE(codeProfesseur, '[A-Z]{4}[0-9]')) --OK
/
--C2
ALTER TABLE inscription
ADD CONSTRAINT checkNote CHECK(note >= 0 AND note <= 100) --OK
/
--C3
ALTER TABLE inscription
ADD CONSTRAINT checkDateAb CHECK(dateAbandon >= dateInscription OR dateAbandon IS NULL) --OK
/
--C4
ALTER TABLE inscription
ADD CONSTRAINT checkAbandonNote CHECK((dateAbandon IS NOT NULL AND note IS NULL) OR (dateAbandon IS NULL)) --OK
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
WHERE codePermanent ='TREJ18088001' AND sigle = 'INF1110' AND noGroupe =
AND codeSession = 32003
/

ROLLBACK 
/

PROMPT Test de violation de la contrainte C3
UPDATE Inscription
SET dateAbandon = '15/08/2003'
WHERE codePermanent ='VANV05127201' AND sigle = 'INF3180' AND noGroupe =
30 AND codeSession = 32003
/

ROLLBACK 
/

PROMPT Test de violation de la contrainte C4
UPDATE Inscription
SET dateAbandon = '17/08/2003'
WHERE codePermanent ='TREJ18088001' AND sigle = 'INF1110' AND noGroupe =
20 AND codeSession = 32003
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

CREATE OR REPLACE FUNCTION fNbInscriptions
	(	sigle, IN Inscription.sigle%TYPE,
		noGroupe IN Inscription.noGroupe%TYPE,
		codeSession IN Inscription.codeSession%TYPE
	) Return NUMBER
IS
	nbIncri NUMBER;

	CURSOR ligneInscri
	(unSigle IN Inscription.sigle%TYPE,
	 unNoGroupe IN Inscription.noGroupe%TYPE,
	 unCodeSession IN Inscription.codeSession%TYPE)
	IS 
		SELECT codePermanent
		FROM	Inscription
		WHERE unsigle = sigle AND unNoGroupe = noGroupe AND unCodeSession = codeSession AND dateAbandon IS NOT NULL;
	
BEGIN

	OPEN ligneInscri(sigle, noGroupe, codeSession);

	LOOP
		FETCH ligneInscri INTO sigle, noGroupe, codeSession;
		EXIT WHEN ligneInscri%NOTFOUND
		nbInscri := nbIncri + 1
	END LOOP;

	CLOSE ligneInscri;

	Return nbIncri;
END;
/