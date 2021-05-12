use sakila;
SELECT rental_date FROM rental WHERE year(rental_date)=2006;

SELECT film.title, datediff(return_date, rental_date) as durée, 
customer.first_name as cfn, customer.last_name as cln, staff.first_name as sfn, staff.last_name as sln, payment.amount, store.address_id, city.city
FROM film 
INNER JOIN inventory ON film.film_id = inventory.film_id 
INNER JOIN rental ON inventory.inventory_id = rental.inventory_id 
LEFT JOIN payment ON rental.rental_id = payment.rental_id 
INNER JOIN staff ON payment.staff_id = staff.staff_id 
INNER JOIN store ON staff.store_id = store.store_id 
INNER JOIN customer ON store.store_id = customer.store_id 
INNER JOIN address ON address.address_id = customer.address_id 
INNER JOIN city ON city.city_id = address.city_id
WHERE year(rental_date)=2006;