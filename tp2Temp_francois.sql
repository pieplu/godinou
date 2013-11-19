@ http://www.labunix.uqam.ca/~godin_r/INF3180/Aut2013/ScriptDossierEtudiantUQAMPourTP2.sql;

SET SERVEROUTPUT ON format wrapped;
--SET FEEDBACK ON;

-- ==========================================
--  INF3180-30 – Fichiers et Base de Donnees
--  Planet Francois - PLAF17069100
--  Alexis Piéplu - PIEA07058900
-- ==========================================


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
WHERE codePermanent ='TREJ18088001' AND sigle = 'INF1110' AND noGroupe = 30
AND codeSession = 32003
/

ROLLBACK 
/

PROMPT Test de violation de la contrainte C3
UPDATE Inscription
SET dateAbandon = '15/08/2003'
WHERE codePermanent ='VANV05127201' AND sigle = 'INF3180' AND noGroupe = 30 AND codeSession = 32003
/

ROLLBACK 
/

PROMPT Test de violation de la contrainte C4
UPDATE Inscription
SET dateAbandon = '17/08/2003'
WHERE codePermanent ='TREJ18088001' AND sigle = 'INF1110' AND noGroupe =20 AND codeSession = 32003
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

create or replace 
FUNCTION fNbInscriptions
(lesigle Inscription.sigle%TYPE,
lenoGroupe Inscription.noGroupe%TYPE,
lecodeSession Inscription.codeSession%TYPE
) 
Return INTEGER

IS

nbInscrits integer;
BEGIN

select count(codePermanent) 
into nbInscrits 
from inscription 
where sigle= lesigle and nogroupe = lenogroupe and codesession = lecodesession  and dateabandon is null;  
Return nbInscrits;
END;
/




--UPDATE de la colonne nbInscriptions

DECLARE
  
  cursor groupe_cur 
  IS
  SELECT sigle, noGroupe, codeSession
  from groupeCours;

  groupe_rec groupe_cur%rowtype;



BEGIN
  
	OPEN groupe_cur;

	LOOP
		FETCH groupe_cur INTO groupe_rec;
		EXIT WHEN groupe_cur%NOTFOUND;
		
		update groupecours
			set nbinscriptions = fnbinscriptions(groupe_rec.sigle, groupe_rec.nogroupe, groupe_rec.codesession)
			where sigle = groupe_rec.sigle and nogroupe = groupe_rec.nogroupe and codesession = groupe_rec.codesession;
			
	END LOOP;

	CLOSE groupe_cur;


END;
/





--------------------
--   QUESTION 4   --
--------------------


CREATE OR REPLACE PROCEDURE pTacheEnseignement(
    code professeur.codeProfesseur%TYPE)
IS
  unnom professeur.nom%TYPE;
  unprenom professeur.prenom%TYPE;
  uncode professeur.codeprofesseur%TYPE;
    CURSOR infoCours
  IS
    SELECT sigle,
      nogroupe,
      codesession
    FROM groupecours
    natural JOIN professeur
    WHERE codeProfesseur = code;
  TYPE prof_cur
IS
  record
  (
    lesigle groupeCours.sigle%TYPE,
    lenogroupe groupeCours.nogroupe%TYPE,
    lasession groupecours.codesession%TYPE);
  prof_rec prof_cur;

BEGIN
  SELECT nom,
    prenom
  INTO unnom,
    unprenom
  FROM professeur
  WHERE codeProfesseur = code;
  DBMS_OUTPUT.PUT_LINE('Code professeur : ' || code);
  DBMS_OUTPUT.PUT_LINE('Nom : ' || unnom);
  DBMS_OUTPUT.PUT_LINE('Prenom : ' || unprenom);
  
  DBMS_OUTPUT.PUT_LINE(RPAD('sigle', 15) || RPAD('noGroupe', 10) || RPAD('session', 20));
  DBMS_OUTPUT.PUT_LINE(RPAD('---------', 15) || RPAD('-------', 10) || RPAD('------------------', 20));
    OPEN infoCours;
  LOOP
    FETCH infoCours INTO prof_rec;
    EXIT
  WHEN infoCours%NOTFOUND;
    DBMS_OUTPUT.PUT_LINE(RPAD(prof_rec.lesigle, 15) || RPAD(prof_rec.lenogroupe, 10) || RPAD(prof_rec.lasession, 20));
  END LOOP;
  CLOSE infoCours;
EXCEPTION
WHEN NO_DATA_FOUND THEN
  DBMS_OUTPUT.PUT_LINE('Professeur inexistant');
END;

/
EXECUTE pTacheEnseignement('TREJ4');
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
WHERE sigle = 'INF1130'AND noGroupe = 10 AND codeSession = 32003;
/

SELECT * FROM MoyenneParGroupe
WHERE sigle = 'INF1130'AND noGroupe = 10 AND codeSession = 32003;
/

SELECT * FROM Inscription
WHERE sigle = 'INF1130'AND noGroupe = 10 AND codeSession = 32003;
/