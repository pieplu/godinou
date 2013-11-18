ALTER SESSION SET NLS_DATE_FORMAT = 'DD/MM/YYYY';
SET SERVEROUTPUT ON;
SET FEEDBACK ON;
SPOOL 'TP2.out';
SET ECHO ON;
-- ==========================================
--  INF3180-30 – Fichiers et Base de Donnees
--  Philippe Boyd - BOYP18029207
--  Marcel Lejour - LEJM28068108
--  Version : 13 novembre 2013
-- ==========================================

-- RESET pour inserer des nouvelles donnees lors chaque execution du script
DROP TABLE groupeCours;
DROP TABLE sessions;
DROP TABLE cours;
DROP TABLE professeur;
DROP TABLE departement;

-- *********************************************
-- 1. Le schema de la base de donnees
-- *********************************************
-- Creation des tables
CREATE TABLE departement
  (
    codeDept VARCHAR(5) NOT NULL,
    nomDept  VARCHAR(20) NOT NULL,
    PRIMARY KEY (codeDept)
  )
/
CREATE TABLE professeur
  (
    codeProf   VARCHAR(5) NOT NULL,
    nomProf    VARCHAR(20) NOT NULL,
    prenomProf VARCHAR(20) NOT NULL,
    codeDept   VARCHAR(5) NOT NULL,
    PRIMARY KEY (codeProf),
    FOREIGN KEY (codeDept) REFERENCES departement
  )
/
CREATE TABLE cours
  (
    codeCours VARCHAR(7) NOT NULL,
    libelle   VARCHAR(100) NOT NULL,
    codeDept  VARCHAR(5) NOT NULL,
    PRIMARY KEY (codeCours),
    FOREIGN KEY (codeDept) REFERENCES departement
  )
/
CREATE TABLE sessions
  (
    codeSess  VARCHAR(5) NOT NULL,
    dateDebut DATE NOT NULL,
    dateFin   DATE NOT NULL,
    libelle   VARCHAR(30) NOT NULL,
    PRIMARY KEY (codeSess)
  )
/
CREATE TABLE groupeCours
  (
    codeCours VARCHAR(7) NOT NULL,
    codeGrp   INTEGER NOT NULL,
    codeSess  VARCHAR(5) NOT NULL,
    codeProf  VARCHAR(5) NOT NULL,
    libelle   VARCHAR(100) NOT NULL,
    PRIMARY KEY (codeCours,codeGrp,codeSess),
    FOREIGN KEY (codeCours) REFERENCES cours,
    FOREIGN KEY (codeSess) REFERENCES sessions,
    FOREIGN KEY (codeProf) REFERENCES professeur
  )
/

-- Insertion des donnees
INSERT ALL
INTO departement VALUES ('INFO', 'Informatique')
INTO departement VALUES ('MATH', 'Mathematique')
INTO departement VALUES ('BIO', 'Biologie')
SELECT * FROM dual;	

INSERT ALL
INTO professeur VALUES ('GODR0', 'Godin', 'Robert', 'INFO')
INTO professeur VALUES ('SADF0', 'Sadat', 'Fatiha', 'INFO')
INTO professeur VALUES ('LABL0', 'Labelle', 'Laura', 'MATH')
INTO professeur VALUES ('LABL1', 'Labelle', 'Laurent', 'BIO')
INTO professeur VALUES ('AJIW0', 'Ajib', 'Wessam', 'INFO')
INTO professeur VALUES ('BEAE0', 'Beaudry', 'Eric', 'INFO')
INTO professeur VALUES ('BEGG0', 'Begin', 'Guy', 'INFO')
INTO professeur VALUES ('BERA0', 'Bergeron', 'Anne', 'INFO')
INTO professeur VALUES ('BLAY0', 'Blaquiere', 'Yves', 'INFO')
INTO professeur VALUES ('BORE0', 'Boridy', 'Elie', 'INFO')
INTO professeur VALUES ('BOUM0', 'Bouguessa', 'Mohamed', 'INFO')
INTO professeur VALUES ('BOUM1', 'Boukadoum', 'Mounir', 'INFO')
INTO professeur VALUES ('BRLS0', 'Brlek', 'Srecko', 'INFO')
INTO professeur VALUES ('CHEO0', 'Cherkaoui', 'Omar', 'INFO')
INTO professeur VALUES ('DESD0', 'Deslandes', 'Dominic', 'INFO')
INTO professeur VALUES ('DIAA0', 'Diallo', 'Abdoulaye', 'INFO')
INTO professeur VALUES ('DUPR0', 'Dupuis', 'Robert', 'INFO')
INTO professeur VALUES ('ELBH0', 'Elbiaze', 'Halima', 'INFO')
INTO professeur VALUES ('FAYC0', 'Fayomi', 'Christian', 'INFO')
INTO professeur VALUES ('GAGE0', 'Gagnon', 'Etienne', 'INFO')
INTO professeur VALUES ('IZQR0', 'Izquierdo', 'Ricardo', 'INFO')
INTO professeur VALUES ('KERB0', 'Kerherve', 'Brigitte', 'INFO')
INTO professeur VALUES ('LAFL0', 'Laforest', 'Louise', 'INFO')
INTO professeur VALUES ('NKAR0', 'Nkambou', 'Roger', 'INFO')
INTO professeur VALUES ('OBAA0', 'Obaid', 'Abdel', 'INFO')
INTO professeur VALUES ('PRIJ0', 'Privat', 'Jean', 'INFO') 
INTO professeur VALUES ('SALA0', 'Salah', 'Aziz', 'INFO')
INTO professeur VALUES ('SEGN0', 'Seguin', 'Normand', 'INFO')
INTO professeur VALUES ('TREG0', 'Tremblay', 'Guy', 'INFO')
INTO professeur VALUES ('TRUS0', 'Trudel', 'Sylvie', 'INFO')
INTO professeur VALUES ('VALP0', 'Valtchev', 'Petko', 'INFO')
INTO professeur VALUES ('VILR0', 'Villemaire', 'Roger', 'INFO')
SELECT * FROM dual;

INSERT ALL
INTO cours VALUES ('INF3180', 'Bases de donnee relationnelles', 'INFO')
INTO cours VALUES ('INF5180', 'Bases de donnees avancees', 'INFO')
INTO cours VALUES ('DIC9320', 'Traitement automatique du langage naturel', 'INFO')
INTO cours VALUES ('MAT1120', 'Principe essentiels de la logique', 'MATH')
INTO cours VALUES ('INF7210', 'Nouvelles perspectives en base de donnees', 'INFO')
SELECT * FROM dual;


INSERT ALL
INTO sessions VALUES ('00112', '03/09/2013', '16/12/2013', 'Session automne 2013')
INTO sessions VALUES ('00543', '05/01/2014', '30/04/2014', 'Session hiver 2014')
INTO sessions VALUES ('01234', '01/05/2014', '31/07/2014', 'Session ete 2014')
SELECT * FROM dual;


INSERT ALL
INTO groupeCours VALUES ('INF3180', 10, '00112', 'SADF0', 'Groupe 10 du cours INF3180 de la session de l''automne 2013')
INTO groupeCours VALUES ('INF3180', 30, '00112', 'GODR0', 'Groupe 30 du cours INF3180 de la session de l''automne 2013')
INTO groupeCours VALUES ('INF5180', 30, '00112', 'GODR0', 'Groupe 30 du cours INF5180 de la session de l''automne 2013')
SELECT * FROM dual;

-- *********************************************
-- 2. Les contraintes d\'integrite
-- *********************************************
-- C1 : Un departement ne peut contenir plus de 30 professeurs.
CREATE OR REPLACE TRIGGER verif_nb_profs_max_depart BEFORE
  INSERT ON professeur FOR EACH row DECLARE nbProfInfo NUMBER;
  BEGIN
    SELECT COUNT(codeDept)
    INTO nbProfInfo
    FROM professeur
    WHERE codeDept = :NEW.codeDept;
        IF nbProfInfo = 30 THEN
      raise_application_error(-20001,'Un departement ne peut contenir plus de 30 professeurs.');
    END IF;
  END;
  /

-- C2 : Un professeur ne peut enseigner plus de trois cours pendant la meme session. En meme temps, un professeur peut ne rien enseigner pendant une session.
CREATE OR REPLACE TRIGGER verif_max_cours_session BEFORE
  INSERT ON groupeCours FOR EACH ROW DECLARE nbCoursDonne NUMBER;
  BEGIN
    SELECT COUNT(codeCours)
    INTO nbCoursDonne
    FROM groupeCours
    WHERE codeProf = :NEW.codeProf;
        IF nbCoursDonne = 3 THEN
      raise_application_error(-20002,'Un professeur ne peut enseigner plus de trois cours pendant la meme session.');
    END IF;
  END;
  /

-- C3 : Un professeur ne peut donner le meme cours (codecours) plus d\'une fois pendant la meme session. Ex. le professeur dont le code est SADF0, donne le cours INF3180 une fois (ou rien) pendant la session d'automne 2013.
CREATE OR REPLACE TRIGGER verif_meme_cours_session BEFORE
  INSERT ON groupeCours FOR EACH ROW DECLARE nbCoursDonne NUMBER;
  BEGIN
    SELECT COUNT(codeCours)
    INTO nbCoursDonne
    FROM groupeCours
    WHERE codeProf = :NEW.codeProf
    AND codeCours  = :NEW.codeCours
    AND codeSess   = :NEW.codeSess;
        IF nbCoursDonne = 1 THEN
      raise_application_error(-20003,'Un professeur ne peut donner le meme cours (codecours) plus d''une fois pendant la meme session.');
    END IF;
  END;
  /

-- C4 : Il est interdit de supprimer les donnees d'un professeur de la table professeur.
CREATE OR REPLACE TRIGGER interdiction_suppr_prof BEFORE
  DELETE ON professeur DECLARE operationInterdite EXCEPTION;
  BEGIN
    raise_application_error(-20004,'Il est interdit de supprimer les donnees d''un professeur de la table professeur.');
  END;
  /
  
-- C5 : Ecrire un trigger nomme 'trigg_MAJ' qui à chaque insertion dans la table Professeur, transforme le champ nomprof en majuscule.
CREATE OR REPLACE TRIGGER trigg_MAJ BEFORE
  INSERT ON professeur FOR EACH ROW BEGIN :NEW.nomProf := UPPER(:NEW.nomProf);
END;
/

-- *********************************************
-- 3. Tests des contraintes d'integrite
-- *********************************************
-- a) TEST : C1
INSERT INTO professeur VALUES ('LARE0', 'Larochelle', 'Etienne', 'INFO');

-- b) TEST : C2
INSERT INTO groupeCours VALUES ('DIC9320', 20, '00112', 'GODR0', 'Groupe 20 du cours DIC9320 de la session de l''automne 2013');
INSERT INTO groupeCours VALUES ('INF7210', 40, '00112', 'GODR0', 'Groupe 40 du cours INF7210 de la session de l''automne 2013');

-- c) TEST : C3
INSERT INTO groupeCours	VALUES ('INF3180', 20, '00112', 'SADF0', 'Groupe 20 du cours INF3180 de la session de l''automne 2013');

-- d) TEST : C4
DELETE FROM professeur WHERE codeProf = 'LABL1';

-- e) TEST : C5
INSERT INTO professeur VALUES ('BOYP0', 'Boyd', 'Philippe', 'MATH');
SELECT * FROM professeur;

-- *********************************************
-- 4. Procedure PL/SQL
-- *********************************************
CREATE OR REPLACE PROCEDURE TacheEnseignement(
    code professeur.codeProf%TYPE)
IS
  nom professeur.nomProf%TYPE;
  prenom professeur.prenomProf%TYPE;
  dept departement.nomDept%TYPE;
    CURSOR infoCours
  IS
    SELECT codeCours,
      codeGrp,
      dateDebut,
      dateFin
    FROM groupecours
    LEFT JOIN sessions
    ON groupeCours.codeSess = sessions.codeSess
    WHERE codeProf          = code;
  TYPE MyRec
IS
  RECORD
  (
    codeCours groupeCours.codeCours%TYPE,
    codeGrp groupeCours.codeGrp%TYPE,
    dateDebut sessions.dateDebut%TYPE,
    dateFin sessions.dateFin%TYPE);
  rec MyRec;
BEGIN
  SELECT nomProf,
    prenomProf,
    nomDept
  INTO nom,
    prenom,
    dept
  FROM professeur NATURAL
  JOIN departement
  WHERE codeProf = code;
  DBMS_OUTPUT.PUT_LINE('Code professeur : ' || code);
  DBMS_OUTPUT.PUT_LINE('Nom : ' || nom);
  DBMS_OUTPUT.PUT_LINE('Prenom : ' || prenom);
  DBMS_OUTPUT.PUT_LINE('Departement : ' || dept);
  DBMS_OUTPUT.PUT_LINE(RPAD('codecours', 15) || RPAD('codeGrp', 10) || RPAD('date_debut_session', 20) || RPAD('date_fin_session', 20));
  DBMS_OUTPUT.PUT_LINE(RPAD('---------', 15) || RPAD('-------', 10) || RPAD('------------------', 20) || RPAD('----------------', 20));
    OPEN infoCours;
  LOOP
    FETCH infoCours INTO rec;
    EXIT
  WHEN infoCours%NOTFOUND;
    DBMS_OUTPUT.PUT_LINE(RPAD(rec.codeCours, 15) || RPAD(rec.codeGrp, 10) || RPAD(rec.dateDebut, 20) || RPAD(rec.dateFin, 20));
  END LOOP;
  CLOSE infoCours;
EXCEPTION
WHEN NO_DATA_FOUND THEN
  DBMS_OUTPUT.PUT_LINE('Professeur inexistant');
END;
/

EXECUTE TacheEnseignement('GODR0');
EXECUTE TacheEnseignement('BLAB0');


-- *********************************************
-- 5. Procedure/Fonction PL/SQL
-- *********************************************
-- À FAIRE PAR MARCEL
select count(codeCours) from groupecours where codeProf = 'GODR0' and codeSess = '00113';

SPOOL OFF;