use sakila;

# Affichez les titres des films ayant pour catégorie 'action' sauf ceux présent en inventaire

SELECT *
FROM film
INNER JOIN film_category fc USING(film_id)
INNER JOIN category c USING(category_id)
WHERE c.name = 'Action' AND film_id NOT IN (SELECT film_id FROM inventory);

#1. Avec une requête imbriquée sélectionner tout les acteurs ayant joués dans les films ou a joué «MCCONAUGHEY CARY».
select distinct actor.first_name, actor.last_name
from film
join film_actor on film.film_id = film_actor.film_id
join actor on actor.actor_id = film_actor.actor_id
where film.title in 
    (select film.title 
    from film
    join film_actor on film.film_id = film_actor.film_id
    join actor on actor.actor_id = film_actor.actor_id
	where concat(actor.last_name, ' ', actor.first_name) = 'MCCONAUGHEY CARY')
and concat(actor.last_name, ' ', actor.first_name) <> 'MCCONAUGHEY CARY';


#2. Afficher tout les acteurs n’ayant pas joués dans les films ou a joué «MCCONAUGHEY CARY».
SELECT DISTINCT actor.first_name, actor.last_name
FROM actor
WHERE (concat(actor.first_name," ", actor.last_name) != "CARY MCCONAUGHEY")
AND actor.actor_id NOT IN 

	(SELECT DISTINCT actor.actor_id
    FROM actor
    JOIN film_actor ON actor.actor_id = film_actor.actor_id
    JOIN film ON film_actor.film_id = film.film_id
    WHERE (concat(actor.first_name," ", actor.last_name) != "CARY MCCONAUGHEY")
    AND film.title IN 
    
		(SELECT film.title
        FROM film
        JOIN film_actor on film.film_id = film_actor.film_id
        JOIN actor on film_actor.actor_id = actor.actor_id
        WHERE (concat(actor.first_name," ", actor.last_name) = "CARY MCCONAUGHEY")
	)
);

#3. Afficher Uniquement le nom du film qui contient le plus d'acteur et le nombre d'acteurs associé sans utiliser LIMIT (2 niveaux de sous requêtes).
select count(a.actor_id) as actors_number, f.title
FROM actor as a
INNER JOIN film_actor as fa on a.actor_id = fa.actor_id
INNER JOIN film as f ON f.film_id = fa.film_id
group by f.title
having count(a.actor_id) = (SELECT max(AN2.actors_number)
                            from (    select count(a2.actor_id) as actors_number, f2.title
                                    FROM actor as a2
                                    INNER JOIN film_actor as fa2 on a2.actor_id = fa2.actor_id
                                    INNER JOIN film as f2 ON f2.film_id = fa2.film_id
                                    group by f2.title) AS AN2)
;

#4. Afficher les acteurs ayant joué uniquement dans des films d’actions (Utiliser EXISTS)	
select *
from actor as a2
where not exists (
    select distinct actor.actor_id
    from actor
    inner join film_actor on actor.actor_id = film_actor.actor_id
    inner join film  on film.film_id = film_actor.film_id
    inner join film_category on film.film_id = film_category.film_id
    inner join category on category.category_id = film_category.category_id
    where category.name <> 'Action'
    and a2.actor_id = actor.actor_id )
;
