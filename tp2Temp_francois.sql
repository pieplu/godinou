alter table professeur
add constraint checkCodeProf check(REGEXP_LIKE(codeProfesseur, '[A-Z]{4}[0-9]'));