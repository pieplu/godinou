-- |------------------------------------------|
-- |------------------------------------------|
-- | INF3180-31 – Fichiers et Base de Donnees |
-- | Planet François - PLAF17069100           |
-- | Alexis Piéplu - PIEA07058900             |
-- |------------------------------------------|
-- |------------------------------------------|

SET ECHO ON
SPOOL TP2.out

SET SERVEROUTPUT ON format wrapped;

PROMPT Création des tables
DROP TABLE Inscription
/
DROP TABLE GroupeCours
/
DROP TABLE Préalable
/
DROP TABLE Cours
/
DROP TABLE SessionUQAM
/
DROP TABLE Etudiant
/
DROP TABLE Professeur
/
ALTER SESSION SET NLS_DATE_FORMAT = 'DD/MM/YYYY'
/
CREATE TABLE Cours
(sigle    CHAR(7)   NOT NULL,
 titre    VARCHAR(50)   NOT NULL,
 nbCredits  INTEGER   NOT NULL,
 CONSTRAINT ClePrimaireCours PRIMARY KEY  (sigle)
)
/

CREATE TABLE Préalable
(sigle    CHAR(7)   NOT NULL,
 siglePréalable CHAR(7)   NOT NULL,
 CONSTRAINT ClePrimairePréalable PRIMARY KEY  (sigle,siglePréalable),
 CONSTRAINT CEsigleRefCours FOREIGN KEY   (sigle) REFERENCES Cours,
 CONSTRAINT CEsiglePréalableRefCours FOREIGN KEY  (siglePréalable) REFERENCES Cours(sigle)
)
/
CREATE TABLE SessionUQAM
(codeSession  INTEGER   NOT NULL,
 dateDebut  DATE    NOT NULL,
 dateFin  DATE    NOT NULL,
 CONSTRAINT ClePrimaireSessionUQAM PRIMARY KEY  (codeSession)
)
/
CREATE TABLE Professeur
(codeProfesseur   CHAR(5) NOT NULL,
 nom      VARCHAR(10) NOT NULL,
 prenom   VARCHAR(10) NOT NULL,
 CONSTRAINT ClePrimaireProfesseur PRIMARY KEY   (codeProfesseur)
)
/
CREATE TABLE GroupeCours
(sigle    CHAR(7)   NOT NULL,
 noGroupe INTEGER   NOT NULL,
 codeSession  INTEGER   NOT NULL,
 maxInscriptions  INTEGER   NOT NULL,
 codeProfesseur   CHAR(5) NOT NULL,
CONSTRAINT ClePrimaireGroupeCours PRIMARY KEY   (sigle,noGroupe,codeSession),
CONSTRAINT CESigleGroupeRefCours FOREIGN KEY  (sigle) REFERENCES Cours,
CONSTRAINT CECodeSessionRefSessionUQAM FOREIGN KEY  (codeSession) REFERENCES SessionUQAM,
CONSTRAINT CEcodeProfRefProfesseur FOREIGN KEY(codeProfesseur) REFERENCES Professeur 
)
/
CREATE TABLE Etudiant
(codePermanent  CHAR(12)  NOT NULL,
 nom    VARCHAR(10) NOT NULL,
 prenom   VARCHAR(10) NOT NULL,
 codeProgramme  INTEGER,
CONSTRAINT CléPrimaireEtudiant PRIMARY KEY  (codePermanent)
)
/
CREATE TABLE Inscription
(codePermanent  CHAR(12)  NOT NULL,
 sigle    CHAR(7)   NOT NULL,
 noGroupe INTEGER   NOT NULL,
 codeSession  INTEGER   NOT NULL,
 dateInscription DATE   NOT NULL,
 dateAbandon  DATE,
 note   INTEGER,
CONSTRAINT CléPrimaireInscription PRIMARY KEY   (codePermanent,sigle,noGroupe,codeSession),
CONSTRAINT CERefGroupeCours FOREIGN KEY   (sigle,noGroupe,codeSession) REFERENCES GroupeCours,
CONSTRAINT CECodePermamentRefEtudiant FOREIGN KEY (codePermanent) REFERENCES Etudiant
)
/

PROMPT Insertion de données pour les essais

INSERT INTO Cours 
VALUES('INF3180','Fichiers et bases de données',3)
/
INSERT INTO Cours 
VALUES('INF5180','Conception et exploitation d''une base de données',3)
/
INSERT INTO Cours 
VALUES('INF1110','Programmation I',3)
/
INSERT INTO Cours 
VALUES('INF1130','Mathématiques pour informaticien',3)
/
INSERT INTO Cours 
VALUES('INF2110','Programmation II',3)
/
INSERT INTO Cours 
VALUES('INF3123','Programmation objet',3)
/
INSERT INTO Cours 
VALUES('INF2160','Paradigmes de programmation',3)
/

INSERT INTO Préalable 
VALUES('INF2110','INF1110')
/
INSERT INTO Préalable 
VALUES('INF2160','INF1130')
/
INSERT INTO Préalable 
VALUES('INF2160','INF2110')
/
INSERT INTO Préalable 
VALUES('INF3180','INF2110')
/
INSERT INTO Préalable 
VALUES('INF3123','INF2110')
/
INSERT INTO Préalable 
VALUES('INF5180','INF3180')
/

INSERT INTO SessionUQAM
VALUES(32003,'3/09/2003','17/12/2003')
/
INSERT INTO SessionUQAM
VALUES(12004,'8/01/2004','2/05/2004')
/

INSERT INTO Professeur
VALUES('TREJ4','Tremblay','Jean')
/
INSERT INTO Professeur
VALUES('DEVL2','De Vinci','Leonard')
/
INSERT INTO Professeur
VALUES('PASB1','Pascal','Blaise')
/
INSERT INTO Professeur
VALUES('GOLA1','Goldberg','Adele')
/
INSERT INTO Professeur
VALUES('KNUD1','Knuth','Donald')
/
INSERT INTO Professeur
VALUES('GALE9','Galois','Evariste')
/
INSERT INTO Professeur
VALUES('CASI0','Casse','Illa')
/
INSERT INTO Professeur
VALUES('SAUV5','Sauvé','André')
/

INSERT INTO GroupeCours
VALUES('INF1110',20,32003,100,'TREJ4')
/
INSERT INTO GroupeCours
VALUES('INF1110',30,32003,100,'PASB1')
/
INSERT INTO GroupeCours
VALUES('INF1130',10,32003,100,'PASB1')
/
INSERT INTO GroupeCours
VALUES('INF1130',30,32003,100,'GALE9')
/
INSERT INTO GroupeCours
VALUES('INF2110',10,32003,100,'TREJ4')
/
INSERT INTO GroupeCours
VALUES('INF3123',20,32003,50,'GOLA1')
/
INSERT INTO GroupeCours
VALUES('INF3123',30,32003,50,'GOLA1')
/
INSERT INTO GroupeCours
VALUES('INF3180',30,32003,50,'DEVL2')
/
INSERT INTO GroupeCours
VALUES('INF3180',40,32003,50,'DEVL2')
/
INSERT INTO GroupeCours
VALUES('INF5180',10,32003,50,'KNUD1')
/
INSERT INTO GroupeCours
VALUES('INF5180',40,32003,50,'KNUD1')
/
INSERT INTO GroupeCours
VALUES('INF1110',20,12004,100,'TREJ4')
/
INSERT INTO GroupeCours
VALUES('INF1110',30,12004,100,'TREJ4')
/
INSERT INTO GroupeCours
VALUES('INF2110',10,12004,100,'PASB1')
/
INSERT INTO GroupeCours
VALUES('INF2110',40,12004,100,'PASB1')
/
INSERT INTO GroupeCours
VALUES('INF3123',20,12004,50,'GOLA1')
/
INSERT INTO GroupeCours
VALUES('INF3123',30,12004,50,'GOLA1')
/
INSERT INTO GroupeCours
VALUES('INF3180',10,12004,50,'DEVL2')
/
INSERT INTO GroupeCours
VALUES('INF3180',30,12004,50,'DEVL2')
/
INSERT INTO GroupeCours
VALUES('INF5180',10,12004,50,'DEVL2')
/
INSERT INTO GroupeCours
VALUES('INF5180',40,12004,50,'GALE9')
/

INSERT INTO Etudiant
VALUES('TREJ18088001','Tremblay','Jean',7416)
/
INSERT INTO Etudiant
VALUES('TREL14027801','Tremblay','Lucie',7416)
/
INSERT INTO Etudiant
VALUES('DEGE10027801','Degas','Edgar',7416)
/
INSERT INTO Etudiant
VALUES('MONC05127201','Monet','Claude',7316)
/
INSERT INTO Etudiant
VALUES('VANV05127201','Van Gogh','Vincent',7316)
/
INSERT INTO Etudiant
VALUES('MARA25087501','Marshall','Amanda',null)
/
INSERT INTO Etudiant
VALUES('STEG03106901','Stephani','Gwen',7416)
/
INSERT INTO Etudiant
VALUES('EMEK10106501','Emerson','Keith',7416)
/
INSERT INTO Etudiant
VALUES('DUGR08085001','Duguay','Roger',null)
/
INSERT INTO Etudiant
VALUES('LAVP08087001','Lavoie','Paul',null)
/
INSERT INTO Etudiant
VALUES('TREY09087501','Tremblay','Yvon',7316)
/

INSERT INTO Inscription
VALUES('TREJ18088001','INF1110',20,32003,'16/08/2003',null,80)
/
INSERT INTO Inscription
VALUES('LAVP08087001','INF1110',20,32003,'16/08/2003',null,80)
/
INSERT INTO Inscription
VALUES('TREL14027801','INF1110',30,32003,'17/08/2003',null,90)
/
INSERT INTO Inscription
VALUES('MARA25087501','INF1110',20,32003,'20/08/2003',null,80)
/
INSERT INTO Inscription
VALUES('STEG03106901','INF1110',20,32003,'17/08/2003',null,70)
/
INSERT INTO Inscription
VALUES('TREJ18088001','INF1130',10,32003,'16/08/2003',null,70)
/
INSERT INTO Inscription
VALUES('TREL14027801','INF1130',30,32003,'17/08/2003',null,80)
/
INSERT INTO Inscription
VALUES('MARA25087501','INF1130',10,32003,'22/08/2003',null,90)
/
INSERT INTO Inscription
VALUES('DEGE10027801','INF3180',30,32003,'16/08/2003',null,90)
/
INSERT INTO Inscription
VALUES('MONC05127201','INF3180',30,32003,'19/08/2003',null,60)
/
INSERT INTO Inscription
VALUES('VANV05127201','INF3180',30,32003,'16/08/2003','20/09/2003',null)
/
INSERT INTO Inscription
VALUES('EMEK10106501','INF3180',40,32003,'19/08/2003',null,80)
/
INSERT INTO Inscription
VALUES('DUGR08085001','INF3180',40,32003,'19/08/2003',null,70)
/
INSERT INTO Inscription
VALUES('TREJ18088001','INF2110',10,12004,'19/12/2003',null,80)
/
INSERT INTO Inscription
VALUES('TREL14027801','INF2110',10,12004,'20/12/2003',null,90)
/
INSERT INTO Inscription
VALUES('MARA25087501','INF2110',40,12004,'19/12/2003',null,90)
/
INSERT INTO Inscription
VALUES('STEG03106901','INF2110',40,12004, '10/12/2003',null,70)
/
INSERT INTO Inscription
VALUES('VANV05127201','INF3180',10,12004, '18/12/2003',null,90)
/
INSERT INTO Inscription
VALUES('DEGE10027801','INF5180',10,12004, '15/12/2003',null,90)
/
INSERT INTO Inscription
VALUES('MONC05127201','INF5180',10,12004, '19/12/2003','22/01/2004',null)
/
INSERT INTO Inscription
VALUES('EMEK10106501','INF5180',40,12004, '19/12/2003',null,80)
/
INSERT INTO Inscription
VALUES('DUGR08085001','INF5180',10,12004, '19/12/2003',null,80)
/
COMMIT
/
PROMPT Contenu des tables
SELECT * FROM Cours
/
SELECT * FROM Préalable
/
SELECT * FROM SessionUQAM
/
SELECT * FROM Professeur
/
SELECT * FROM GroupeCours
/
SELECT * FROM Etudiant
/
SELECT * FROM Inscription
/


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

CREATE OR REPLACE 
FUNCTION fNbInscriptions
(lesigle Inscription.sigle%TYPE,
lenoGroupe Inscription.noGroupe%TYPE,
lecodeSession Inscription.codeSession%TYPE
) 
Return INTEGER
IS
nbInscrits INTEGER;
BEGIN
  SELECT COUNT(codePermanent) 
  INTO nbInscrits 
  FROM inscription 
  WHERE sigle = lesigle AND nogroupe = lenogroupe AND codesession = lecodesession  AND dateabandon IS NULL;  
  Return nbInscrits;
END;
/

SELECT fNbInscriptions('INF1110',20,32003) FROM DUAL
/

--UPDATE de la colonne nbInscriptions

DECLARE
  cursor groupe_cur 
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

SELECT * FROM GroupeCours
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
  DBMS_OUTPUT.PUT_LINE('code professeur:' || code);
  DBMS_OUTPUT.PUT_LINE('nom:' || unnom);
  DBMS_OUTPUT.PUT_LINE('prenom:' || unprenom);
  
  DBMS_OUTPUT.PUT_LINE(LPAD('sigle', 8) || LPAD('noGroupe', 10) || LPAD('session', 10));
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
  DBMS_OUTPUT.PUT_LINE('Professeur non trouvee');
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

INSERT INTO Inscription
VALUES('TREY09087501','INF5180',10,12004, '19/12/2003',null,80)
/

SELECT * FROM GroupeCours
WHERE sigle = 'INF5180' AND noGroupe = 10 AND codeSession = 12004
/

ROLLBACK
/


--------------------
--   QUESTION 6   --
--------------------

CREATE OR REPLACE VIEW MoyenneParGroupe (SIGLE, NOGROUPE, CODESESSION, MOYENNENOTE)
AS SELECT sigle, noGroupe, codeSession, AVG(note)
FROM Inscription
GROUP BY sigle, noGroupe, codeSession
/

SELECT * FROM MoyenneParGroupe
/

CREATE OR REPLACE 
TRIGGER InsteadUpdateMoyenneParGroupe
INSTEAD OF UPDATE ON MoyenneParGroupe
FOR EACH ROW
DECLARE
	nbNotes Inscription.note%TYPE;
	vieuTotal MoyenneParGroupe.moyenneNote%TYPE;
	nouvTotal MoyenneParGroupe.moyenneNote%TYPE;
	dif NUMBER;

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

SPOOL OFF