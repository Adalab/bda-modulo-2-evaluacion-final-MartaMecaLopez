USE sakila;

-- duración media de las peliculas para cada catefgoria 
SELECT
rating,
AVG(length),
COUNT(film_id) AS total_peliculas
FROM film
GROUP BY rating
HAVING total_peliculas > 200;


SELECT
title,
description
FROM film
WHERE description LIKE "%amazing%";
