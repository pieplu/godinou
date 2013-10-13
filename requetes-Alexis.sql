-- 1.   Les numéros des clients (sans répétition) qui ont placé au moins une commande         
SELECT DISTINCT noClient FROM Commande;

-- 2.   Le numéro et la description des articles dont le numéro est entre 20 et 80 (inclusivement) et le prix est 10.99 ou 25.99
SELECT noArticle, description FROM article WHERE noArticle BETWEEN 20 AND 80 AND (prixUnitaire = 10.99 OR prixUnitaire = 25.99);

-- 3.   Le numéro et la description des articles dont la description débute par la lettre C ou contient la chaîne 'bl'
SELECT noArticle, Description FROM Article WHERE (description LIKE '%bl%') OR (description LIKE 'C%'); 

-- 4.   Le numéro et le nom des clients qui ont placé une commande le 9 juillet 2000
SELECT noClient, nomclient FROM Client NATURAL JOIN Commande WHERE datecommande = '9/07/2000'; 



-- 5.   Les noms des clients, numéros de commande, date de commande et noArticle pour les articles livrés le 4 juin 2000 dont la quantité livrée est supérieure à 1

SELECT nomClient, nocommande, datecommande, noArticle 
FROM Client NATURAL JOIN commande NATURAL JOIN lignecommande NATURAL JOIN DetailLivraison NATURAL JOIN Livraison 
WHERE dateLivraison='04/06/2000' AND quantiteLivree > 1;                      


-- 6.   La liste des dates du mois de juin 2000 pour lesquelles il y a au moins une livraison ou une commande. Les résultats sont produits en une colonne nommée DateÉvénement.

SELECT DISTINCT *
FROM
	(SELECT datecommande AS DateEvenement
	FROM Commande
	WHERE datecommande LIKE '%06/2000%')
	union
	(SELECT datelivraison AS DateEvenement
	FROM Livraison
	WHERE datelivraison LIKE '%06/2000%');                                                                  


-- 7.   Les noArticle et la quantité totale livrée de l’article incluant les articles dont la quantité totale livrée est égale à 0.

SELECT noArticle, SUM(COALESCE(quantiteLivree,0)) AS "QUANTITE LIVREE"
FROM DetailLivraison NATURAL RIGHT OUTER JOIN Article
GROUP BY noArticle;


-- 8.   Les noArticle et la quantité totale livrée de l’article pour les articles dont le prix est inférieur à $20 et dont la quantité totale livrée est inférieure à 5

SELECT noArticle, QUANTITELIVREE AS "QUANTITE LIVREE"
FROM (SELECT noArticle, QUANTITELIVREE
FROM (SELECT noArticle, SUM(COALESCE(quantiteLivree,0)) AS QUANTITELIVREE
FROM DetailLivraison NATURAL RIGHT OUTER JOIN Article
GROUP BY noArticle)
WHERE QUANTITELIVREE<5) NATURAL JOIN Article
WHERE prixUnitaire<20
ORDER BY noArticle;

                                                    
-- 9.   Le noLivraison, noCommande, noArticle, la date de la commande, la quantité commandée, la date de la livraison, la quantitée livrée et le nombre de jours écoulés entre la commande et la livraison dans le cas où ce nombre a dépassé 2 jours et le nombre de jours écoulés depuis la commande jusqu’à aujourh’hui est supérieur à 100


SELECT noLivraison, nocommande, noArticle, datecommande, quantite, datelivraison, quantiteLivree, (datelivraison-dateCommande) AS "NOMBRE JOURS ECOULES"
FROM Livraison NATURAL JOIN DetailLivraison NATURAL JOIN lignecommande NATURAL JOIN Commande
WHERE (datelivraison-dateCommande > 2) AND (SYSDATE-datecommande>100);

-- 10.  La liste des Articles triée en ordre décroissant de prix et pour chacun des prix en ordre croissant de numéro

SELECT noArticle, description, prixUnitaire, QuantiteEnStock
FROM article
ORDER BY prixUnitaire DESC, noArticle ASC;


-- 11.  Le nombre d’articles dont le prix est supérieur à 25 et le nombre d'articles dont le prix est inférieur à 15 (en deux colonnes)

SELECT *
FROM (SELECT Count(prixUnitaire) AS "NOMBREPLUSCHERQUE25"
    FROM Article
    WHERE prixUnitaire>25 
    ),( SELECT Count(prixUnitaire) AS "NOMBREMOINSCHERQUE15"
    FROM Article
    WHERE prixUnitaire<15 );
                                    


-- 12.  Les noCommande des commandes qui n'ont aucune livraison correspondante
Requête SQL …

NOCOMMANDE                                                                      
----------                                                                      
         8                                                                      
         6                                                                      
         7                                                                      


-- 13.  En deux colonnes, les paires de numéros de commandes (différentes) qui sont faites à la même date ainsi que la date de commande. Il faut éviter de répéter deux fois la même paire.

Requête SQL …

NOCOMMANDE NOCOMMANDE DATECOMMAN                                                
---------- ---------- ----------                                                
         2          3 02/06/2000                                                
         5          6 09/07/2000                                                
         7          8 15/07/2000                                                







-- 14.  Le montant total commandé pour chaque paire (dateCommande, noArticle) dans les cas où le montant total dépasse 50$.
Requête SQL …

DATECOMMAN  NOARTICLE MONTANT TOTAL COMMANDÉ                                    
---------- ---------- ----------------------                                    
09/07/2000         10                  109,9                                    
01/06/2000         70                  54,95                                    
02/06/2000         40                  51,98                                    
01/06/2000         10                  109,9                                    
09/07/2000         20                  64,95                                    


-- 15.  Les noArticle des articles commandés dans toutes et chacune des commandes du client 20

Requête SQL …

 NOARTICLE                                                                      
----------                                                                      
        40                                                                      



NB Pour la dernière requête, le même article soit être commandé dans toutes les commandes du client 20.
