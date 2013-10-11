
SQL> SELECT * FROM Client                                                       
  2  /                                                                          

  NOCLIENT NOMCLIENT            NOTELEPHONE
---------- -------------------- ---------------
        10 Luc Sansom           (999)999-9999
        20 Dollard Tremblay     (888)888-8888
        30 Lin B?               (777)777-7777
        40 Jean Leconte         (666)666-6666
        50 Hafed Alaoui         (555)555-5555
        60 Marie Leconte        (666)666-6666
        70 Simon Lecoq          (444)444-4419
        80 Dollard Tremblay     (333)333-3333

8 rows selected.

SQL> SELECT * FROM Commande                                                     
  2  /                                                                          

NOCOMMANDE DATECOMM   NOCLIENT
---------- -------- ----------
         1 00-06-01         10
         2 00-06-02         20
         3 00-06-02         10
         4 00-07-05         10
         5 00-07-09         30
         6 00-07-09         20
         7 00-07-15         40
         8 00-07-15         40

8 rows selected.

SQL> SELECT * FROM lignecommande                                                
  2  /                                                                          

NOCOMMANDE  NOARTICLE   QUANTITE
---------- ---------- ----------
         1         10         10
         1         70          5
         1         90          1
         2         40          2
         2         95          3
         3         20          1
         4         40          1
         4         50          1
         5         70          3
         5         10          5
         5         20          5

NOCOMMANDE  NOARTICLE   QUANTITE
---------- ---------- ----------
         6         10          5
         6         40          1
         7         50          1
         8         20          3

15 rows selected.




SQL> SELECT * FROM Article;                                                     

 NOARTICLE DESCRIPTION          PRIXUNITAIRE QUANTITEENSTOCK
---------- -------------------- ------------ ---------------
        10 C?dre en boule              10,99              10
        20 Sapin                       12,99              10
        40 epinette bleue              25,99              10
        50 Chene                       22,99              10
        60 erable argente              15,99              10
        70 Herbe ? puce                10,99              10
        80 Poirier                     26,99              10
        81 Catalpa                     25,99              10
        90 Pommier                     25,99              10
        95 Genevrier                   15,99              10

10 rows selected.



SQL> SELECT * FROM detailLivraison;                                             

NOLIVRAISON NOCOMMANDE  NOARTICLE QUANTITELIVREE
----------- ---------- ---------- --------------
        100          1         10              7
        100          1         70              5
        101          1         10              3
        102          2         40              2
        102          2         95              1
        100          3         20              1
        103          1         90              1
        104          4         40              1
        105          5         70              2

9 rows selected.



SQL> SELECT * FROM Livraison;                                                   

NOLIVRAISON DATELIVRAI
----------- ----------
        100 03/06/2000
        101 04/06/2000
        102 04/06/2000
        103 05/06/2000
        104 07/07/2000
        105 08/07/2000

6 rows selected.
