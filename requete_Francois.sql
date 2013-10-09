SQL> -- 1.   Les numéros des clients (sans répétition) qui ont placé au moins une commande
SQL> 
SQL> 
 
SELECT DISTINCT noClient 
FROM Client NATURAL JOIN Commande;

SELECT Distinct noClient from Commande;


SQL> -- 2.   Le numéro et la description des articles dont le numéro est entre 20 et 80 (inclusivement) et le prix est 10.99 ou 25.99
SQL> 
SQL>
 
SELECT noArticle, description 
from Article 
where noArticle between 20 and 80 and ( prixUnitaire = 10.99 OR prixUnitaire=25.99);


SQL> -- 3.   Le numéro et la description des articles dont la description débute par la lettre C ou contient la chaîne 'bl'
SQL> 
SQL> 

SELECT noArticle, description 
from Article 
where (description like 'C%') OR (description like '%bl%');


SQL> -- 4.   Le numéro et le nom des clients qui ont placé une commande le 9 juillet 2000
SQL> 
SQL>
 
select noClient, nomClient 
from Client natural join Commande 
where dateCommande='09/07/2000';


SQL> -- 5.   Les noms des clients, numéros de commande, date de commande et noArticle pour 
-- les articles livrés le 4 juin 2000 dont la quantité livrée est supérieure à 1
SQL> 
SQL>



SELECT distinct nomClient, noCommande, dateCommande, noArticle
FROM Client 
natural join Commande 
natural join LigneCommande 
natural join DetailLivraison
natural join Livraison
WHERE dateLivraison = '04/06/2000' AND quantiteLivree >1;

--OU BIEN

SELECT distinct nomClient, Commande.noCommande, dateCommande, DetailLivraison.noArticle
FROM Client 
join Commande ON Client.noClient = Commande.noClient
join LigneCommande ON Commande.noCommande = LigneCommande.noCommande
join DetailLivraison ON DetailLivraison.noCommande = LigneCommande.noCommande
join Livraison ON Livraison.noLivraison = DetailLivraison.noLivraison
WHERE dateLivraison = '04/06/2000' AND quantiteLivree >1;






SQL> -- 6.   La liste des dates du mois de juin 2000 pour lesquelles il y a au moins une livraison ou une commande. 
--Les résultats sont produits en une colonne nommée DateÉvénement.
SQL> 
SQL>  

SELECT * 
FROM (
	(select dateLivraison DATEEVENEMENT
	FROM Livraison
	WHERE dateLivraison LIKE '%06%')
	union
	(select dateCommande DATEEVENEMENT
	FROM Commande
	Where dateCommande LIKE '%06%')
	);

                                                                 

SQL> 
SQL> -- 7.   Les noArticle et la quantité totale livrée de l’article incluant les articles 
--dont la quantité totale livrée est égale à 0.
SQL> 
SQL> 

SELECT noArticle, 
CASE 
WHEN SUM(quantiteLivree) IS NULL THEN 0
ELSE SUM(quantiteLivree) 
END as QuantiteLivree
FROM 
(select Article.noArticle, quantiteLivree
from Article LEFT OUTER JOIN DetailLivraison 
on Article.noArticle=DetailLivraison.noArticle)
GROUP BY noArticle
ORDER BY noArticle;





SQL> -- 8.   Les noArticle et la quantité totale livrée de l’article pour les articles dont le 
--prix est inférieur à $20 et dont la quantité totale livrée est inférieure à 5
SQL> 
SQL> 

SELECT noArticle, QuantiteLivree
FROM
( 
SELECT noArticle, 
CASE 
WHEN SUM(quantiteLivree) IS NULL THEN 0
ELSE SUM(quantiteLivree) 
END as QuantiteLivree
FROM 
(select Article.noArticle, quantiteLivree
from Article LEFT OUTER JOIN DetailLivraison 
on Article.noArticle=DetailLivraison.noArticle
WHERE prixUnitaire < 20)
GROUP BY noArticle
ORDER BY noArticle
)
Where QuantiteLivree <5;

--OU BIEN

SELECT noArticle, QuantiteLivree
FROM
( 
SELECT noArticle, 
NVL(SUM(quantiteLivree),0) as QuantiteLivree
FROM 
(select Article.noArticle, quantiteLivree
from Article LEFT OUTER JOIN DetailLivraison 
on Article.noArticle=DetailLivraison.noArticle
WHERE prixUnitaire < 20)
GROUP BY noArticle
ORDER BY noArticle
)
Where QuantiteLivree <5;





		
SQL> -- 9.   Le noLivraison, noCommande, noArticle, la date de la commande, la quantité commandée, 
--la date de la livraison, la quantitée livrée et le nombre de jours écoulés entre la commande et la 
--livraison dans le cas où ce nombre a dépassé 2 jours et le nombre de jours écoulés depuis la commande 
--jusqu’à aujourh’hui est supérieur à 100
SQL> 
SQL> 

SELECT Distinct DL.noLivraison, LC.noCommande, LC.noArticle, C.dateCommande, LC.quantite, L.dateLivraison, DL.quantiteLivree, (L.dateLivraison-C.dateCommande) as NBJOURSECOULES
FROM DetailLivraison DL,Commande C, LigneCommande LC,Livraison L
WHERE C.noCommande=LC.noCommande 
AND LC.noCommande=DL.noCommande 
AND DL.noLivraison=L.noLivraison 
AND (L.dateLivraison-C.dateCommande > 2) 
AND (((SELECT SYSDATE FROM dual)-C.dateCommande)>100);



SELECT Distinct noLivraison, noCommande, noArticle, dateCommande, quantite, dateLivraison, quantiteLivree, (dateLivraison-dateCommande) as NBJOURSECOULES
FROM Commande
natural join LigneCommande 
natural join DetailLivraison
natural join Livraison
WHERE (dateLivraison-dateCommande > 2) 
AND (((SELECT SYSDATE FROM dual)-dateCommande)>100);








																			
SQL> -- 10.  La liste des Articles triée en ordre décroissant de prix et pour chacun des prix en 
--ordre croissant de numéro
SQL> 
SQL> 


SELECT noArticle,description,prixUnitaire ,quantiteEnStock
From Article
ORDER BY prixUnitaire DESC, noArticle ASC;








SQL> 
SQL> -- 11.  Le nombre d’articles dont le prix est supérieur à 25 et le nombre d'articles 
--dont le prix est inférieur à 15 (en deux colonnes)
SQL> 
SQL> 


 SELECT *
 FROM
 (SELECT 
 COUNT(prixUnitaire) as NOMBREPLUSCHERQUE25
 FROM Article
 Where prixUnitaire>25),
 (SELECT 
 COUNT(prixUnitaire) as NOMBREMOINSCHERQUE15
 FROM Article
 Where prixUnitaire<15);
 

 

 
SQL> 
SQL> -- 12.  Les noCommande des commandes qui n'ont aucune livraison correspondante
SQL> 


SELECT Commande.noCommande
FROM Commande LEFT JOIN DetailLivraison
ON Commande.noCommande = DetailLivraison.noCommande
WHERE DetailLivraison.noLivraison IS NULL;



                                                                     



SQL> 
SQL> -- 13.  En deux colonnes, les paires de numéros de commandes (différentes) qui sont faites à la même date ainsi que la date de commande. Il faut éviter de répéter deux fois la même paire.
SQL> 
SQL>

SELECT DISTINCT c1.noCommande as NOCOMMANDE, c2.noCommande as NOCOMMANDE, c2.dateCommande
FROM Commande c1 , Commande c2 
WHERE c1.dateCommande = c2.dateCommande AND c1.noCommande != c2.noCommande AND c1.noCommande < c2.noCommande;





SQL> 
SQL> -- 14.  Le montant total commandé pour chaque paire (dateCommande, noArticle) dans les cas où le montant total dépasse 50$.
SQL> 



select t1.datecommande, t1.noArticle, SUM(t1.MONTANTOTALCOMMANDE) as MONTANTOTALCOMMANDE
FROM
(SELECT 
dateCommande, 
noArticle, 
(quantite * prixUnitaire) as MONTANTOTALCOMMANDE
FROM Commande
natural join LigneCommande
natural join Article
where (quantite*prixUnitaire)>50) t1
group by t1.noArticle, t1.datecommande;




select distinct datecommande, noarticle, (sum(quantite*prixunitaire) as MONTANTOTALCOMMANDE
FROM Commande
natural join LigneCommande
natural join Article;









DATECOMMAN  NOARTICLE MONTANT TOTAL COMMANDÉ                                    
---------- ---------- ----------------------                                    
09/07/2000         10                  109,9                                    
01/06/2000         70                  54,95                                    
02/06/2000         40                  51,98                                    
01/06/2000         10                  109,9                                    
09/07/2000         20                  64,95                                    




SQL> 
SQL> -- 15.  Les noArticle des articles commandés dans toutes et chacune des commandes du client 20
SQL> 
SQL> 

SELECT distinct noArticle
FROM
(SELECT Distinct noCommande, noArticle
from Commande natural join LigneCommande
where noclient=20) 
natural join
(SELECT Distinct noCommande, noArticle
from Commande natural join LigneCommande
where noclient=20);


diapo chap4


SELECT noArticle
FROM Article
WHERE NOT EXISTS
    	(SELECT noCommande
      FROM Commande
 	 WHERE noClient = 20 AND NOT EXISTS
     		(SELECT *
      	 FROM LigneCommande
      	 WHERE noArticle = Article.noArticle AND
				noCommande = Commande.noCommande));






 NOARTICLE                                                                      
----------                                                                      
        40                                                                      
                        

