-- 1.   Les numéros des clients (sans répétition) qui ont placé au moins une commande         
SELECT DISTINCT noClient FROM Commande;

-- 2.   Le numéro et la description des articles dont le numéro est entre 20 et 80 (inclusivement) et le prix est 10.99 ou 25.99
SELECT noArticle, description FROM article WHERE noArticle BETWEEN 20 AND 80 AND (prixUnitaire = 10.99 OR prixUnitaire = 25.99);

-- 3.   Le numéro et la description des articles dont la description débute par la lettre C ou contient la chaîne 'bl'
SELECT noArticle, Description FROM Article WHERE (description LIKE '%bl%') OR (description LIKE 'C%'); 

-- 4.   Le numéro et le nom des clients qui ont placé une commande le 9 juillet 2000
SELECT noClient, nomclient FROM Client NATURAL JOIN Commande WHERE datecommande = '9/07/2000'; 


--pas fait
SELECT nomClient, nocommande, datecommande, noArticle FROM Client, commande, lignecommande, DetailLivraison, Livraison WHERE dateLi


--13
SELECT Distinct commande.nocommande as nocommande1, copy.nocommande as nocommande2, copy.datecommande FROM commande, commande copy WHERE commande.datecommande = copy.datecommande AND commande.nocommande != copy.nocommande;