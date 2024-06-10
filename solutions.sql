USE sakila;

-- 1. ¿Cuántas copias de la película El Jorobado Imposible existen en el sistema de inventario?

SELECT COUNT(*) AS number_of_copies
FROM inventory
WHERE film_id = (
SELECT film_id
    FROM film
    WHERE LOWER(title) LIKE '%hunchback impossible%'
);


-- 2. List all films whose length is longer than the average of all the films.

SELECT title, length
FROM film
WHERE length > (
SELECT AVG(length)
FROM film)
LIMIT 10;

-- Use subqueries to display all actors who appear in the film Alone Trip.


SELECT a.actor_id, a.first_name, a.last_name
FROM actor a
JOIN film_actor fa ON a.actor_id = fa.actor_id
WHERE fa.film_id = (
    SELECT f.film_id
    FROM film f
    WHERE f.title = 'Alone Trip'
);

-- 4. Sales have been lagging among young families, and you wish to target all family movies for a promotion. Identify all movies categorized as family films.

SELECT title
FROM film
WHERE film_id in (
Select film_id FROM film_category
WHERE category_id = (
SELECT category_id
from category
WHERE name = 'Family'
)
);


-- 5. Get name and email from customers from Canada using subqueries. 
-- Do the same with joins. Note that to create a join, you will have to identify the correct tables with their primary keys and foreign keys,
-- that will help you get the relevant information.

SELECT c.first_name, c.last_name, c.email
FROM customer c
WHERE address_id in (
SELECT address_id
FROM address
WHERE city_id in (
select city_id FROM
city where country_ID in(
select country_id
FROM country
WHERE country = 'Canada'
)
)
);

-- 6. Which are films starred by the most prolific actor? Most prolific actor is defined as the actor that has acted in the most number of films. 
-- First you will have to find the most prolific actor and then use that actor_id to find the different films that he/she starred.

SELECT 
    title
FROM
    film
WHERE
    film_id IN (SELECT 
            film_id
        FROM
            film_actor AS fa
                INNER JOIN
            (SELECT 
                actor_id, COUNT(film_id) AS film_total
            FROM
                film_actor
            GROUP BY actor_id
            ORDER BY film_total DESC
            LIMIT 1) AS sub ON sub.actor_id = fa.actor_id)
;

-- 7. Films rented by most profitable customer. 
-- You can use the customer table and payment table to find the most profitable customer ie the customer that has made the largest sum of payments.

SELECT 
    film.title
FROM
    film
        JOIN
    inventory ON film.film_id = inventory.film_id
        JOIN
    rental ON inventory.inventory_id = rental.inventory_id
WHERE
    rental.customer_id = (SELECT 
            customer_id
        FROM
            payment
        GROUP BY customer_id
        ORDER BY SUM(amount) DESC
        LIMIT 1);
        
-- 8. Get the client_id and the total_amount_spent of those clients who spent more than the average of the total_amount spent by each client.

select customer_id, SUM(amount) as total_amount_spent
FROM payment
GROUP BY customer_id
HAVING SUM(amount) > (
SELECT AVG(total_amount)
FROM (
SELECT customer_id, SUM(amount) AS total_amount
from payment
GROUP BY customer_id)
AS avg_amount
) 
limit 10;
;