--C1
ALTER TABLE professeur
ADD CONSTRAINT checkCodeProf CHECK(REGEXP_LIKE(codeProfesseur, '[A-Z]{4}[0-9]')); --OK

--C2
ALTER TABLE inscription
ADD CONSTRAINT checkNote CHECK(note >= 0 AND note <= 100); --OK

--C3
ALTER TABLE inscription
ADD CONSTRAINT checkDateAb CHECK(dateAbandon >= dateInscription OR dateAbandon IS NULL); --OK

--C4
ALTER TABLE inscription
ADD CONSTRAINT checkAbandonNote CHECK((dateAbandon IS NOT NULL AND note IS NULL) OR (dateAbandon IS NULL)); --OK