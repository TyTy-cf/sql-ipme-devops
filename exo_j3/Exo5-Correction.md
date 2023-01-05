
Infos de la table order, sur la colonne status :
- 100 : annulée
- 200 : en attente de paiement
- 300 : payée
- 400 : livrée
- 500 : finalisée

### 1/ Afficher tous les produits (table product), le prix est en centimes, il faut le convertir en "xxx,xx€", avec leur marque

```sql
SELECT	product.label,
        CONCAT(product.price * 0.01, "€"),
        brand.label

FROM product

JOIN brand ON brand.id = product.brand_id;
```

### 2/ Afficher le nombre d'articles par commande

```sql
SELECT	product.label,
        CONCAT(product.price * 0.01, "€"),
        brand.label

FROM product

JOIN brand ON brand.id = product.brand_id;
```

### 3/ Afficher les utilisateurs ayant plus d'une adresse

```sql
SELECT user.first_name, user.last_name, COUNT(*)

FROM address
    
JOIN address_user ON address.id = address_user.address_id
JOIN user ON address_user.user_id = user.id

GROUP BY address.id

HAVING COUNT(*) > 1;
```

### 4/ Afficher le nombre d'utilisateur par ville

```sql
SELECT  city.name,
        COUNT(*) as Qte_user

FROM city

JOIN address on address.city_id = city.id
JOIN address_user on address_user.address_id = address.id

GROUP BY city.name DESC;
```

### 5/ Afficher un ratio de la présence des utilisateurs par ville

```sql
SELECT 	city.name,
      CONCAT(
          ROUND(
              (
                  COUNT(address_user.user_id)
                  /
                  (SELECT COUNT(*) FROM address_user)
              ) * 100, 2
          ),
          '%'
      ) AS 'Ratio présence'

FROM city

         JOIN address on address.city_id = city.id
         JOIN address_user on address_user.address_id = address.id

GROUP BY city.name

ORDER BY
    ROUND(
        (
            COUNT(address_user.user_id)
            /
            (SELECT COUNT(*) FROM address_user)
         * 100, 2
    )
DESC;
```

### 6/ Afficher les articles de la catégorie chien (et ses sous-catégories)

```sql
SELECT 	product.label,
		category.label

FROM product

JOIN category_product ON category_product.product_id = product.id
JOIN category ON category.id = category_product.category_id

WHERE category.label = 'Chien'
OR category.category_parent_id = (
    SELECT id
    FROM category
    WHERE category.label = 'Chien'
);
```


### 7/ Afficher pour chaque article, sa note maximale reçue (colonne note dans review)

```sql
SELECT 	product.label,
		IF(MAX(review.note) IS NULL, 'Non noté', MAX(review.note))

FROM product

LEFT JOIN review ON review.product_id = product.id

GROUP BY product.id;
```


### 8/ Afficher la moyenne des articles de chaque catégorie (colonne note dans review)


```sql
SELECT	category.label,
		ROUND(AVG(review.note),2)

FROM category

JOIN category_product ON category.id = category_product.category_id
JOIN product ON category_product.product_id = product.id  
JOIN review ON product.id = review.product_id

GROUP BY category.label;
```

### 9/ Afficher les produits (table product) ayant du stock et n'étant plus en vente (is_active = 0)

```sql
SELECT product.label AS "produit ayant du stock et n'étant plus en vente"
FROM product
WHERE (
    product.is_active IS FALSE
    AND
    product.stock > 0
);
```


### 10/ Afficher les commandes finalisées (status = 500) par date, avec leur prix, leur numéro de commande et le nom du client

```sql
SELECT  command.created_at AS "Date",
        product.label AS "Nom du Produit",
        product.price * 0.01 AS "Prix",
        command.num_command AS "Numéro de commande", 
        user.first_name AS "Nom d'utilisateur"

FROM product
    
JOIN command_product ON product.id = command_product.product_id
JOIN command ON command_product.command_id = command.id
JOIN user ON command.user_id = user.id

WHERE command.status = 500

GROUP BY command.created_at;
```

### 11/ Afficher les commandes ayant un "total_price" différent de la valeur total de leurs articles

```sql
SELECT command.num_command,
       (command.total_price * 0.01) AS "Total Price",
       (SUM(product.price) * 0.01) AS "Production SUM Price"

FROM command

JOIN command_product ON command.id = command_product.command_id
JOIN product ON command_product.product_id = product.id

WHERE (command.total_price * 0.01) != (SELECT SUM(product.price) * 0.01 FROM product)

GROUP BY command.id
```

### 12/ Afficher le taux de conversion de commande en commande finalisée (total commande status 500 sur total commande)

```sql
SELECT ROUND(COUNT(command.status)/(SELECT COUNT(*) FROM command)*100,2)
FROM command
WHERE command.status = 500;
```

### 13/ Afficher les 5 articles les plus vendus avec leur quantité vendue (soyez inventifs...)

```sql
SELECT product.label, COUNT(*) AS `Somme`
FROM product
JOIN command_product ON product.id = command_product.product_id
GROUP BY product.id
ORDER BY `Somme` DESC
LIMIT 5;
```

### 14/ Afficher la somme des ventes par année

```sql
SELECT  YEAR(command.created_at) AS `Année`,
        SUM(command.total_price) * 0.01
FROM command
GROUP BY `Année`;
```

### 15/ Afficher la valeur moyenne d'une commande, qui n'a pas été annulée

```sql
SELECT CONCAT(FORMAT(AVG(command.total_price)/100, 2, 'fr_FR'), '€') AS `Prix moyen`
FROM command
WHERE command.status != 500;
```

### 16/ Afficher le nombre de produit par marque 

```sql
SELECT 	brand.label,
		COUNT(*)

FROM brand

JOIN product ON product.brand_id = brand.id

GROUP BY brand.label

ORDER BY COUNT(*) DESC;
```

### 17/ Afficher par marque, la valeur qu'elles ont en vente

```sql
SELECT 	brand.label,
		CONCAT(SUM(product.stock * product.price) * 0.01, '€') AS 'Valeur en vente'

FROM brand

JOIN product ON product.brand_id = brand.id

GROUP BY brand.label

ORDER BY SUM(product.stock * product.price) DESC;
```

### 18/ Afficher par marque, la valeur qu'elles ont vendu réellement (commande qui n'est pas en status 100 ou 200)

```sql
SELECT      brand.label,
            CONCAT(FORMAT(SUM(product.price)/100, 2, 'fr_FR'), '€') AS `Prix Total`

FROM brand
    
JOIN product ON product.brand_id = brand.id
JOIN command_product ON command_product.product_id = product.id

WHERE command_product.command_id IN
(
    SELECT command.id
    FROM command
    WHERE command.status NOT IN (100,200)
)

GROUP BY brand.id;
```

### 19/ Afficher le nombre de client n'ayant pas passé de commande

```sql
SELECT user.email
FROM user
LEFT JOIN command ON command.user_id = user.id
WHERE command.num_command IS NULL;
```
