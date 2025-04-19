USE sakila;

-- 1. Selecciona todos los nombres de las películas sin que aparezcan duplicados.

SELECT DISTINCT
title
FROM film;

-- 2. Muestra los nombres de todas las películas que tengan una clasificación de "PG-13".

SELECT DISTINCT
title
FROM film
WHERE rating = "PG-13";

-- 3. Encuentra el título y la descripción de todas las películas que contengan la palabra "amazing" en su descripción.

SELECT DISTINCT
title,
description
FROM film
WHERE description LIKE "%amazing%";

-- 4. Encuentra el título de todas las películas que tengan una duración mayor a 120 minutos.

SELECT DISTINCT
title,
length
FROM film
WHERE length > 120;

-- 5. Recupera los nombres de todos los actores.
SELECT DISTINCT
first_name,
last_name
FROM actor;

-- 6. Encuentra el nombre y apellido de los actores que tengan "Gibson" en su apellido.

SELECT DISTINCT
first_name,
last_name
FROM actor
WHERE last_name LIKE "%Gibson%";

-- 7. Encuentra los nombres de los actores que tengan un actor_id entre 10 y 20.

SELECT DISTINCT
actor_id,
first_name,
last_name
FROM actor
WHERE actor_id BETWEEN 10 AND 20;

-- 8. Encuentra el título de las películas en la tabla film que no sean ni "R" ni "PG-13" en cuanto a su clasificación.

SELECT DISTINCT
title,
rating
FROM film
WHERE rating NOT LIKE "PG-13" AND rating NOT LIKE "R";

-- 9. Encuentra la cantidad total de películas en cada clasificación de la tabla film y muestra la clasificación junto con el recuento

SELECT
rating AS Clasificación,
COUNT(film_id) AS Total
FROM film
GROUP BY rating;

-- 10. Encuentra la cantidad total de películas alquiladas por cada cliente y muestra el ID del cliente, su nombre y apellido junto con la cantidad de películas alquiladas

SELECT
customer.customer_id AS "ID Cliente",
customer.first_name AS "Nombre Cliente",
customer.last_name AS "Apellido Cliente",
COUNT(rental.rental_id) AS "Total Películas Alquiladas"
FROM customer
INNER JOIN rental -- usamos INNER porque solo nos piden los clientes que han alquilado películas, no todos los clientes hayan comprado o no
ON customer.customer_id = rental.customer_id
GROUP BY rental.customer_id;


-- customer (customer_id) - rental (customer_id) usaremos cuantas veces se repite el customer id en la tabla rental teniendo en cuenta que inventory id y rental id son datos únicos 

-- 11. Encuentra la cantidad total de películas alquiladas por categoría y muestra el nombre de la categoría junto con el recuento de alquileres
-- category(category_id) - film_category (category_id, film_id) - inventory (film_id, inventory_id) - rental (inventory_id)
SELECT
category.category_id AS ID_categoría,
category.name AS Nombre_Categoría,
COUNT(rental.rental_id) AS Total_Alquiladas
FROM category
INNER JOIN film_category
ON category.category_id = film_category.category_id
INNER JOIN film
ON  film_category.film_id = film.film_id
INNER JOIN inventory
ON film.film_id = inventory.film_id
INNER JOIN rental
ON rental.inventory_id = inventory.inventory_id 
GROUP BY category.category_id, category.name;

-- primero relacionamos todas las tablas que vamos a necesitar (las principales y las puente) y después contamos cuantos rental_id hay por cada categoría gracias a que las hemos agrupado con GROUP BY

        
        
-- 12. Encuentra el promedio de duración de las películas para cada clasificación de la tabla film y muestra la clasificación junto con el promedio de duración.         

SELECT 
category.category_id AS ID_Categoría,
category.name AS Nombre_Categoría,
AVG(film.length) AS "Media Longitud"
FROM category
INNER JOIN film_category
ON category.category_id = film_category.category_id
INNER JOIN film
ON film.film_id = film_category.film_id
GROUP BY ID_Categoría, Nombre_Categoría;

-- 13. Encuentra el nombre y apellido de los actores que aparecen en la película con title "Indian Love".

SELECT DISTINCT 
  actor.first_name AS Nombre,
  actor.last_name AS Apellido,
  film.title AS Título
FROM actor
INNER JOIN film_actor ON actor.actor_id = film_actor.actor_id
INNER JOIN film ON film_actor.film_id = film.film_id
WHERE film.title = "Indian Love";
    
    
SELECT DISTINCT 
actor.first_name AS Nombre,
actor.last_name AS Apellido
FROM actor
WHERE actor_id IN (
SELECT actor_id
FROM film_actor
WHERE film_id = (
	SELECT film_id
	FROM film
	WHERE title = "Indian Love"));
    
-- 14. Muestra el título de todas las películas que contengan la palabra "dog" o "cat" en su descripción.

SELECT DISTINCT 
title,
description
FROM film_text
WHERE description LIKE "%dog%" OR description LIKE "%cat%";

-- 15. Encuentra el título de todas las películas que fueron lanzadas entre el año 2005 y 2010.

SELECT DISTINCT 
title,
release_year
FROM film
WHERE release_year BETWEEN 2005 AND 2010;

-- 16. Encuentra el título de todas las películas que son de la misma categoría que "Family".

SELECT DISTINCT 
title
FROM film
INNER JOIN film_category
ON film.film_id = film_category.film_id
WHERE film_category.category_id = (
	SELECT category_id
	FROM category
	WHERE name = "Family");

-- COMPROBACIÓN:
    
SELECT DISTINCT 
film.title AS Título,
film_category.category_id AS ID_Categoría,
category.name AS Categoría
FROM film
INNER JOIN film_category
ON film.film_id = film_category.film_id
INNER JOIN category
ON film_category.category_id = category.category_id
WHERE name = "Family";


-- 17. Encuentra el título de todas las películas que son "R" y tienen una duración mayor a 2 horas en la tabla film.

SELECT DISTINCT 
title AS "Título",
length AS "Duración película",
rating AS "Clasificación"
FROM film
WHERE rating = "R" AND length > 120;

-- BONUS

-- 18. Muestra el nombre y apellido de los actores que aparecen en más de 10 películas.

SELECT
actor.first_name AS "Nombre Actor",
actor.last_name AS "Apelldio Actor",
COUNT(film_actor.film_id) AS "Total Películas"
FROM actor
INNER JOIN film_actor
ON actor.actor_id = film_actor.actor_id 
GROUP BY film_actor.actor_id 
HAVING COUNT(film_actor.film_id) > 10
ORDER BY COUNT(film_actor.film_id) ASC;

-- 19. Hay algún actor o actriz que no apareca en ninguna película en la tabla film_actor.

SELECT
first_name AS "Nombre Actor",
last_name AS "Apelldio Actor",
actor_id AS "ID Actor",
CASE
	WHEN actor.actor_id IN (SELECT actor_id FROM film_actor) THEN "Aparece en al menos 1 película"
    ELSE "No aparece en ninguna película"
    END AS "Películas"
FROM actor;  

-- OPCIÓN 2

SELECT
  first_name,
  last_name
FROM actor
LEFT JOIN film_actor 
ON actor.actor_id = film_actor.actor_id
WHERE film_actor.actor_id IS NULL;


-- 20. Encuentra las categorías de películas que tienen un promedio de duración superior a 120 minutos y muestra el nombre de la categoría junto con el promedio de duración.


SELECT 
category.name AS Nombre_Categoría,
AVG(film.length) AS "Media Longitud"
FROM category
INNER JOIN film_category
ON category.category_id = film_category.category_id
INNER JOIN film
ON film.film_id = film_category.film_id
GROUP BY Nombre_Categoría
HAVING AVG(film.length) > 120;

-- 21. Encuentra los actores que han actuado en al menos 5 películas y muestra el nombre del actor junto con la cantidad de películas en las que han actuado.

SELECT
actor.first_name AS "Nombre Actor",
actor.last_name AS "Apellido Actor",
COUNT(film_actor.film_id) AS "Total Películas"
FROM actor
INNER JOIN film_actor
ON actor.actor_id = film_actor.actor_id 
GROUP BY film_actor.actor_id 
HAVING COUNT(film_actor.film_id) >= 5
ORDER BY COUNT(film_actor.film_id) ASC;

-- 22. Encuentra el título de todas las películas que fueron alquiladas por más de 5 días. Utiliza una subconsulta para encontrar los rental_ids con una duración superior a 5 días y luego selecciona las películas correspondientes.

SELECT DISTINCT
film.title
FROM film
INNER JOIN inventory
ON film.film_id = inventory.film_id 
WHERE inventory.inventory_id IN (
	SELECT inventory_id
	FROM rental
	WHERE (return_date - rental_date) > 5);
    
SELECT DISTINCT
film.title
FROM film
INNER JOIN inventory
ON film.film_id = inventory.film_id 
WHERE inventory.inventory_id IN (
	SELECT inventory_id
	FROM rental
	WHERE TIMESTAMPDIFF(DAY, rental_date, return_date) > 5);    

-- 23. Encuentra el nombre y apellido de los actores que no han actuado en ninguna película de la categoría "Horror". Utiliza una subconsulta para encontrar los actores que han actuado en películas de la categoría "Horror" y luego exclúyelos de la lista de actores.

SELECT
first_name,
last_name
FROM actor
WHERE actor_id NOT IN(
	SELECT
	film_actor.actor_id
	FROM film_actor
	INNER JOIN film_category 
	ON film_actor.film_id = film_category.film_id
	INNER JOIN category
	ON film_category.category_id = category.category_id
	WHERE category.name = "Horror");


-- 24. Encuentra el título de las películas que son comedias y tienen una duración mayor a 180 minutos en la tabla film.

SELECT
film.title AS "Título",
film.length AS "Longitud"
FROM film
WHERE film.film_id IN (
	SELECT film_id
	FROM film_category
	WHERE category_id IN(
		SELECT category_id
		FROM category
		WHERE category.name = "Comedy" AND film.length > 180));

-- COMPROBACIÓN

SELECT
film.title AS "Título",
film.length AS "Longitud",
category.name AS "Categoría"
FROM film
INNER JOIN film_category
ON film.film_id = film_category.film_id
INNER JOIN category
ON film_category.category_id = category.category_id
WHERE category.name = "Comedy" AND film.length > 180;

-- 25. Encuentra todos los actores que han actuado juntos en al menos una película. La consulta debe mostrar el nombre y apellido de los actores y el número de películas en las que han actuado juntos

SELECT
a1.first_name AS "Nombre actor 1",
a1.last_name AS "Apellido actor 1",
a2.first_name AS "Nombre actor 2",
a2.last_name AS "Apellido actor 2",
COUNT(*) AS "Películas Juntos"
FROM film_actor AS fa1 -- dividimos la tabla de las películas en 2 para hayar las pelis que ha hecho cada actor
INNER JOIN film_actor AS fa2 -- unimos la tabla consigomisma para poder comparar los id de las películas
ON fa1.film_id = fa2.film_id AND fa1.actor_id < fa2.actor_id
-- Cogemos solo los actores con las películas con el mismo id / usamos < para que no se dupliquen los resultados pero con los nombres en la columna contraria
INNER JOIN actor AS a1 -- dividimos tambien la tabla actor en 2
ON a1.actor_id = fa1.actor_id -- la unimos con la tabla film_actor
INNER JOIN actor AS a2 
ON a2.actor_id = fa2.actor_id
GROUP BY a1.actor_id, a2.actor_id; -- agrupamos por el id del actor

-- actor1(first_name, last_name) + actor2(first_name, last_name) + COUNT(* si el id de la película coincide) 
-- actor 1 y 2 (actor_id) , film_actor (actor_id, film_id) 
-- Necesitamos tener una columna con el actor 1, luego otra con las pelis del actor 1, 
-- luego una con las pelis del actor 2. Después agruparemos por las que sean iguales
