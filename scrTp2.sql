PROMPT Cr�ation des tables
SET ECHO ON
DROP TABLE Inscription
/
DROP TABLE GroupeCours
/
DROP TABLE Pr�alable
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
(sigle 		CHAR(7) 	NOT NULL,
 titre 		VARCHAR(50) 	NOT NULL,
 nbCredits 	INTEGER 	NOT NULL,
 CONSTRAINT ClePrimaireCours PRIMARY KEY 	(sigle)
)
/

CREATE TABLE Pr�alable
(sigle 		CHAR(7) 	NOT NULL,
 siglePr�alable CHAR(7) 	NOT NULL,
 CONSTRAINT ClePrimairePr�alable PRIMARY KEY 	(sigle,siglePr�alable),
 CONSTRAINT CEsigleRefCours FOREIGN KEY 	(sigle) REFERENCES Cours,
 CONSTRAINT CEsiglePr�alableRefCours FOREIGN KEY 	(siglePr�alable) REFERENCES Cours(sigle)
)
/
CREATE TABLE SessionUQAM
(codeSession 	INTEGER		NOT NULL,
 dateDebut 	DATE		NOT NULL,
 dateFin 	DATE		NOT NULL,
 CONSTRAINT ClePrimaireSessionUQAM PRIMARY KEY 	(codeSession)
)
/
CREATE TABLE Professeur
(codeProfesseur		CHAR(5)	NOT NULL,
 nom			VARCHAR(10)	NOT NULL,
 prenom		VARCHAR(10)	NOT NULL,
 CONSTRAINT ClePrimaireProfesseur PRIMARY KEY 	(codeProfesseur)
)
/
CREATE TABLE GroupeCours
(sigle 		CHAR(7) 	NOT NULL,
 noGroupe	INTEGER		NOT NULL,
 codeSession	INTEGER		NOT NULL,
 maxInscriptions	INTEGER		NOT NULL,
 codeProfesseur		CHAR(5)	NOT NULL,
CONSTRAINT ClePrimaireGroupeCours PRIMARY KEY 	(sigle,noGroupe,codeSession),
CONSTRAINT CESigleGroupeRefCours FOREIGN KEY 	(sigle) REFERENCES Cours,
CONSTRAINT CECodeSessionRefSessionUQAM FOREIGN KEY 	(codeSession) REFERENCES SessionUQAM,
CONSTRAINT CEcodeProfRefProfesseur FOREIGN KEY(codeProfesseur) REFERENCES Professeur 
)
/
CREATE TABLE Etudiant
(codePermanent 	CHAR(12) 	NOT NULL,
 nom		VARCHAR(10)	NOT NULL,
 prenom		VARCHAR(10)	NOT NULL,
 codeProgramme	INTEGER,
CONSTRAINT Cl�PrimaireEtudiant PRIMARY KEY 	(codePermanent)
)
/
CREATE TABLE Inscription
(codePermanent 	CHAR(12) 	NOT NULL,
 sigle 		CHAR(7) 	NOT NULL,
 noGroupe	INTEGER		NOT NULL,
 codeSession	INTEGER		NOT NULL,
 dateInscription DATE		NOT NULL,
 dateAbandon	DATE,
 note		INTEGER,
CONSTRAINT Cl�PrimaireInscription PRIMARY KEY 	(codePermanent,sigle,noGroupe,codeSession),
CONSTRAINT CERefGroupeCours FOREIGN KEY 	(sigle,noGroupe,codeSession) REFERENCES GroupeCours,
CONSTRAINT CECodePermamentRefEtudiant FOREIGN KEY (codePermanent) REFERENCES Etudiant
)
/

PROMPT Insertion de donn�es pour les essais

INSERT INTO Cours 
VALUES('INF3180','Fichiers et bases de donn�es',3)
/
INSERT INTO Cours 
VALUES('INF5180','Conception et exploitation d''une base de donn�es',3)
/
INSERT INTO Cours 
VALUES('INF1110','Programmation I',3)
/
INSERT INTO Cours 
VALUES('INF1130','Math�matiques pour informaticien',3)
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

INSERT INTO Pr�alable 
VALUES('INF2110','INF1110')
/
INSERT INTO Pr�alable 
VALUES('INF2160','INF1130')
/
INSERT INTO Pr�alable 
VALUES('INF2160','INF2110')
/
INSERT INTO Pr�alable 
VALUES('INF3180','INF2110')
/
INSERT INTO Pr�alable 
VALUES('INF3123','INF2110')
/
INSERT INTO Pr�alable 
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
VALUES('SAUV5','Sauv�','Andr�')
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
SELECT * FROM Pr�alable
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
