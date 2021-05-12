use sakila;

#1- Afficher les 10 locations les plus longues (nom/prenom client, film, video club, durée)
select rental_duration, customer.first_name, customer.last_name, film.title, store.store_id
from film
inner join inventory on film.film_id = inventory.film_id
inner join rental on inventory.inventory_id = rental.inventory_id
inner join store on inventory.store_id = store.store_id
inner join customer on store.store_id = customer.store_id
order by rental_duration desc limit 10;


#2- Afficher les 10 meilleurs clients actifs par montant dépensé (nom/prénom client, montant dépensé)
select customer.first_name, customer.last_name, amount from customer
inner join rental on customer.customer_id = rental.customer_id
inner join payment on rental.rental_id = payment.rental_id
order by amount desc;

#3- Afficher la durée moyenne de location par film triée de manière descendante
select avg(timestampdiff(rental_duration)) as moyenne_location, title from film
inner join inventory on film.film_id = inventory.film_id
inner join rental on inventory.inventory_id = rental.inventory_id
group by title desc;

#4- Afficher tous les films n'ayant jamais été empruntés
select title, rental_date from film
inner join inventory on film.film_id = inventory.film_id
inner join rental on inventory.inventory_id = rental.inventory_id
where rental_date is null;

#5- Afficher le nombre d'employés (staff) par video club
select staff.first_name, staff.last_name, store.store_id from staff
inner join store on staff.store_id = store.store_id
order by store_id;

#6- Afficher les 10 villes avec le plus de video clubs
select city.name, store from

#7- Afficher le film le plus long dans lequel joue Johnny Lollobrigida
select title, length, actor.first_name, actor.last_name from actor
inner join film_actor on actor.actor_id = film_actor.actor_id
inner join film on film_actor.film_id = film.film_id
where actor.first_name = "JOHNNY" and actor.last_name = "LOLLOBRIGIDA"
order by length desc limit 1;

#8- Afficher le temps moyen de location du film 'Academy dinosaur'
select title, avg(rental_duration) as temps_moyen_location from film
where title = "Academy dinosaur"
group by title;

#9- Afficher les films avec plus de deux exemplaires en inventaire (store id, titre du film, nombre d'exemplaires)

#10- Lister les films contenant 'din' dans le titre
select title from film where title like "%din%";

#11- Lister les 5 films les plus empruntés

#12- Lister les films sortis en 2003, 2005 et 2006
select title, release_year from film where year(release_year) = ("2005", "2006", "2007");

#13- Afficher les films ayant été empruntés mais n'ayant pas encore été restitués, triés par date d'emprunt. Afficher seulement les 10 premiers

#14- Afficher les films d'action durant plus de 2h
select title, category.name, length from film
inner join film_category on film.film_id = film_category.film_id
inner join category on film_category.category_id = category.category_id
where length >= 2 and category.name = "Action"
order by length asc;

#15- Afficher tous les utilisateurs ayant emprunté des films avec la mention NC-17
select customer.first_name, customer.last_name, rating from film
inner join inventory on inventory.film_id = inventory.inventory_id
inner join rental on inventory.inventory_id = rental.inventory_id
inner join customer on rental.customer_id = customer.customer_id
where rating = "NC-17";

#16- Afficher les films d'animation dont la langue originale est l'anglais
select title, category.name, language.name from film
inner join language on film.original_language_id = language.language_id
inner join film_category on film.film_id = film_category.film_id
inner join category on film_category.category_id = category.category_id
where category.name = "Animation" and language.name = "English";

#17- Afficher les films dans lesquels une actrice nommée Jennifer a joué (bonus: en même temps qu'un acteur nommé Johnny)
#18- Quelles sont les 3 catégories les plus empruntées?
select category.name, rental
#19- Quelles sont les 10 villes où on a fait le plus de locations?

#20- Lister les acteurs ayant joué dans au moins 1 film
select actor.first_name, actor.last_name, title from actor
inner join film_actor on actor.actor_id = film_actor.actor_id
inner join film on film_actor.film_id = film.film_id
where title <= 1;


####################################################################################################################################
### Mise en pratique 
####################################################################################################################################

# 1.Afficher le nombre de films dans lesquels à joué l'acteur «JOHNNY LOLLOBRIGIDA», regroupé par catégorie
select count(film.title) as nbre_film, actor.first_name, actor.last_name, category.name from actor
inner join film_actor on actor.actor_id = film_actor.actor_id
inner join film on film_actor.film_id = film.film_id
inner join film_category on film.film_id = film_category.film_id
inner join category on film_category.category_id = category.category_id
where lower(actor.first_name) = "johnny" and lower(actor.last_name) = "lollobrigida"
group by category.name, actor.first_name, actor.last_name;

# 2.Ecrire la requête qui affiche les catégories dans lesquels «JOHNNY LOLLOBRIGIDA» totalise plus de 3 films
select count(film.title) as nbre_film, actor.first_name, actor.last_name, category.name from actor
inner join film_actor on actor.actor_id = film_actor.actor_id
inner join film on film_actor.film_id = film.film_id
inner join film_category on film.film_id = film_category.film_id
inner join category on film_category.category_id = category.category_id
where lower(actor.first_name) = "johnny" and lower(actor.last_name) = "lollobrigida"
group by category.name, actor.first_name, actor.last_name
having nbre_film > 3;

# 3.Afficher la durée moyenne d'emprunt des films par acteurs
select avg(timestampdiff(hour, rental_date, return_date)) as durée_moyenne, actor.first_name, actor.last_name, actor.actor_id from actor
inner join film_actor on actor.actor_id = film_actor.actor_id
inner join film on film.film_id = film_actor.film_id
inner join inventory on film.film_id = inventory.film_id
inner join rental on rental.inventory_id = inventory.inventory_id
group by actor.actor_id, actor.first_name, actor.last_name;

# 4.L'argent total dépensé au vidéos club par chaque clients, classé par ordre décroissant
select sum(payment.amount) as somme, customer.first_name, customer.last_name from customer
join rental on rental.customer_id = customer.customer_id
join payment on rental.rental_id = payment.rental_id
group by customer.customer_id
order by somme desc;
