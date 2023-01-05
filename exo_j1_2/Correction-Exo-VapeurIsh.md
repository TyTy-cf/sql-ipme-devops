
### 1/ Faire une requête permettant d'afficher tout le contenu de la librarie d'un compte, les données seront affichées sous cette forme

```sql
SELECT
	account.nickname AS 'Joueur',
    game.name AS 'Jeu',
    IF(library.installed, 'O', 'N') AS 'Installé',
    SEC_TO_TIME(library.game_time) AS 'Temps passé',
    library.last_used_at AS 'Dernière utilisation'
    
FROM library

JOIN account ON account.id = library.account_id
JOIN game ON game.id = library.game_id

ORDER BY account.name, library.installed DESC;
```


### 2/ Afficher les jeux (table : games) avec leur différents genres respectifs, cependant je veux une ligne par jeux et les différents genres en une seule colonne, que vous renommerez "Genre(s)".
### (PS : utiliser GROUP_CONCAT pour l'affichage en une seule colonne)

```sql
SELECT 	game.name,
		GROUP_CONCAT(genre.name SEPARATOR ' | ') AS 'Genre(s)'
        
FROM	game

JOIN game_genre ON game_genre.game_id = game.id
JOIN genre ON genre.id = game_genre.genre_id

GROUP BY game.name;
```


### 3/ En reprenant la requête de la question 2, afficher le jeu le plus cher

#### Solution pour en récupérer UN seul

```sql
SELECT 	game.name,
		game.price,
		GROUP_CONCAT(genre.name SEPARATOR ' | ') AS 'Genre(s)'
        
FROM	game

JOIN game_genre ON game_genre.game_id = game.id
JOIN genre ON genre.id = game_genre.genre_id

GROUP BY game.name

ORDER BY game.price DESC

LIMIT 1;
```

#### Solution pour récupérer TOUS les jeux ayant le prix le plus cher

```sql
SELECT 	game.name,
		game.price,
		GROUP_CONCAT(genre.name SEPARATOR ' | ') AS 'Genre(s)'
        
FROM	game

JOIN game_genre ON game_genre.game_id = game.id
JOIN genre ON genre.id = game_genre.genre_id

WHERE 	game.price = (
    SELECT MAX(game.price)
	FROM game
)

GROUP BY game.name;
```


### 4/ En reprenant la requête de la question 2, afficher uniquement les jeux ayant au moins le style FPS


```sql
SELECT 	game.name,
        game.price,
		GROUP_CONCAT(genre.name SEPARATOR ' | ') AS "Genre(s)"
        
FROM genre

JOIN game_genre ON game_genre.genre_id = genre.id
JOIN game ON game_genre.game_id = game.id

GROUP BY game.name

HAVING `Genre(s)` LIKE '%FPS%'
```

### 5/ Affichez le temps de jeu total par nom de compte

#### Solution simple

```sql
SELECT
	account.name,
    SUM(library.game_time) AS 'Temps jeu total'
    
FROM account

JOIN library ON library.account_id = account.id

GROUP BY account.name;
```

#### Solution propre mais... pas évidente

```sql
SELECT
	account.name,
    CONCAT(
        ROUND(
            SUM(library.game_time)/3600, 0
        ),
        ':',
        IF(
            ROUND((SUM(library.game_time)%3600)/60) < 10,
            CONCAT('0', ROUND((SUM(library.game_time)%3600)/60)),
			ROUND((SUM(library.game_time)%3600)/60)
         ),
         ':',
         IF(
             (SUM(library.game_time)%3600)%60 < 10,
             CONCAT('0', (SUM(library.game_time)%3600)%60),
			 (SUM(library.game_time)%3600)%60
         )
    ) AS 'Temps jeu total'
    
FROM account

JOIN library ON library.account_id = account.id

GROUP BY account.name

ORDER BY SUM(library.game_time) DESC;
```


### 6/ Reprendre la question 1, et n'afficher cette fois que les jeux installés

```sql
SELECT
	account.nickname AS 'Joueur',
    game.name AS 'Jeu',
    IF(library.installed, 'O', 'N') AS 'Installé',
    SEC_TO_TIME(library.game_time) AS 'Temps passé',
    library.last_used_at AS 'Dernière utilisation'
    
FROM library

JOIN account ON account.id = library.account_id
JOIN game ON game.id = library.game_id

WHERE library.installed

ORDER BY account.name, library.installed DESC;
```


### 7/ Afficher la valeur (somme du prix des jeux) de la bibliothèque (librarie) d'un compte (account)

```sql
SELECT	account.nickname,
		CONCAT(SUM(game.price), '€') AS 'Valeur bibli'

FROM	account

JOIN	library
ON	library.account_id = account.id

JOIN	game
ON	game.id = library.game_id

GROUP BY account.name

ORDER BY SUM(game.price) DESC;
```


### 8/ Afficher les nicknames utilisés plusieurs fois

```sql
SELECT  account.nickname,
		COUNT(*) AS 'Nb nickname'

FROM	account

GROUP BY account.nickname

HAVING	COUNT(*) > 1;
```


### 11/ Afficher par jeux, le nombre de fois où il a été acheté

```sql
SELECT	game.name,
		COUNT(*) AS 'Nb achat'
        
FROM	library

JOIN game ON game.id = library.game_id

GROUP BY library.game_id

ORDER BY COUNT(*) DESC;
```


### 10/ Afficher par jeux, son revenu total à son éditeur

```sql
SELECT	game.name,
		publisher.name,
        CONCAT(game.price * COUNT(library.game_id), '€') AS Revenus
        
FROM	game

JOIN	library ON library.game_id = game.id
JOIN	publisher ON publisher.id = game.publisher_id

GROUP BY 	game.name

ORDER BY game.price * COUNT(library.game_id) DESC;
```


### 11/ Afficher par genre, son nombre de fois où il a été vendu

```sql
SELECT
	genre.name,
    COUNT(*) AS 'Nb ventes'
    
FROM
	genre

JOIN	game_genre ON game_genre.genre_id = genre.id
JOIN	game ON game.id = game_genre.game_id
JOIN	library ON library.game_id = game.id

GROUP BY genre.name

ORDER BY COUNT(*)  DESC;
```


### 12/ Afficher le top 3 des jeux les plus vendu

```sql
SELECT 	game.*,
		COUNT(library.game_id) AS NbVentes

FROM
	game
    
JOIN library ON library.game_id = game.id

GROUP BY game.name

ORDER BY NbVentes DESC

LIMIT 3;
```


### 13/ Afficher le top 3 des jeux les plus joués

#### Solution simple

```sql
SELECT 	game.name,
		SUM(library.game_time) AS TempsJeux

FROM
	game
    
JOIN library ON library.game_id = game.id

GROUP BY game.name

ORDER BY TempsJeux DESC

LIMIT 3;
```

#### Solution "oui"

```sql
SELECT 	game.*,			
		CONCAT(
			ROUND(
				SUM(library.game_time)/3600, 0
			),
			':',
			IF(
				ROUND((SUM(library.game_time)%3600)/60) < 10,
				CONCAT('0', ROUND((SUM(library.game_time)%3600)/60)),
				ROUND((SUM(library.game_time)%3600)/60)
			 ),
			 ':',
			 IF(
				 (SUM(library.game_time)%3600)%60 < 10,
				 CONCAT('0', (SUM(library.game_time)%3600)%60),
				 (SUM(library.game_time)%3600)%60
			 )
		) AS TempsJeux

FROM
	game
    
JOIN library ON library.game_id = game.id

GROUP BY game.name

ORDER BY SUM(library.game_time) DESC

LIMIT 3;
```


### 14/ Afficher les différents jeux par année, sous une même colonne

```sql
SELECT	GROUP_CONCAT(game.name SEPARATOR ' | ') AS 'Jeux',
		YEAR(game.published_at) AS 'Année sortie'
        
FROM	game

GROUP BY `Année sortie`

ORDER BY  `Année sortie` DESC;
```


### 15/ Le jeu le plus ancien

```sql
SELECT 	game.name,
		YEAR(game.published_at)

FROM game

ORDER BY game.published_at

LIMIT 1;
```


### 16/ Afficher les jeux avec leur note moyenne (table comment, colonne rank)

```sql
SELECT 	IF(
			AVG(comment.rank) IS NULL,
			'Non noté',
			ROUND(AVG(comment.rank), 2)
		) 'Moyenne note',
		game.name
        
FROM game

LEFT JOIN comment ON comment.game_id = game.id

GROUP BY game.name

ORDER BY `Moyenne note` DESC;
```


### 17/ Afficher le jeu ayant le plus de commentaire négatif (colonne down_votes)

```sql
SELECT	game.name,
		SUM(comment.down_votes) AS 'Nb votes négatif'
        
FROM	game

JOIN comment ON comment.game_id = game.id

GROUP BY game.name

ORDER BY `Nb votes négatif` DESC

LIMIT 1;
```


### 18/ Afficher les jeux dont la moyenne des commentaires (rank) est supérieur à la moyenne totale

```sql
SELECT	game.name,
		ROUND(AVG(comment.rank), 2) AS 'Moyenne Rank'
        
FROM 	game

JOIN comment ON comment.game_id = game.id

GROUP BY game.name

HAVING AVG(comment.rank) >= (
	SELECT AVG(comment.rank)
	FROM comment
);
```


### 19/ Afficher les account n’ayant jamais acheter de jeu

#### Solution avec left join

```sql
SELECT	account.name,
		library.game_id

FROM account

LEFT JOIN library ON library.account_id = account.id

WHERE library.game_id IS NULL;
```

#### Solution avec sous requête

```sql
SELECT	account.name

FROM account

WHERE account.id NOT IN (
	SELECT library.account_id
    FROM library
);
```


### 20/ Afficher le genre le plus acheté

```sql
SELECT  genre.name,
		COUNT(library.id) AS 'Nb achat'

FROM genre

JOIN game_genre ON game_genre.genre_id = genre.id
JOIN game ON game_genre.game_id = game.id
JOIN library ON library.game_id = game.id

GROUP BY genre.id

ORDER BY `Nb achat` DESC

LIMIT 5;
```


### 21/ Les joueurs ayant un acheté un jeu qui n'est pas dans leur langue natale

```sql
SELECT 	account.nickname,
		account.country_id,
		account.id,
        GROUP_CONCAT(DISTINCT game_country.country_id)

FROM account

JOIN library 
ON library.account_id = account.id

JOIN game
ON game.id = library.game_id
            
JOIN game_country
ON game_country.game_id = game.id

WHERE account.country_id NOT IN (
    SELECT country.id
    
    FROM game
    
    JOIN game_country
    ON game_country.game_id = game.id
    
    JOIN country
    ON country.id = game_country.country_id
    
  	WHERE library.game_id = game.id
)

GROUP BY account.id;
```


### 22/ Afficher le ratio de présence des accounts par pays dans l'application

```sql
SELECT	  country.name,
          COUNT(*),
          CONCAT(ROUND((COUNT(*) / (SELECT COUNT(*) FROM account)) * 100, 2), '€')

FROM country

JOIN account ON account.country_id = country.id

GROUP BY country.name;
```


### 24/ Faire une requête pour afficher les utilisateurs qui ont mis des commentaires à des jeux non présents dans leur bibliothèque

```sql
SELECT 	account.name,
        GROUP_CONCAT(DISTINCT comment.game_id) AS 'Id comments',
        (
            SELECT GROUP_CONCAT(DISTINCT library.game_id)
            FROM library
            WHERE library.account_id = account.id
            GROUP BY account.id
        ) AS 'Id games'

FROM account

LEFT JOIN comment ON comment.account_id = account.id

WHERE comment.game_id NOT IN (
    SELECT DISTINCT library.game_id
    FROM library
    WHERE library.account_id = account.id
)

GROUP BY account.id;
```


### 25/ Afficher les jeux dont leur total de downvote supérieur au total d'upvotes, MAIS un rank supérieur à la moyenne globale des rank de tous les commentaires.

```sql
SELECT
game.name,
AVG(rank)

FROM game

JOIN comment ON comment.game_id = game.id

GROUP BY game.name

HAVING SUM(comment.down_votes) > SUM(comment.up_votes)
AND AVG(rank) > (SELECT AVG(rank) FROM comment);
```