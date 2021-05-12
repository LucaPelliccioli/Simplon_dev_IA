use sakila;

#1 Afficher tout les emprunts ayant été réalisés en 2006
select date_format(rental_date, "%M/%m/%Y") as mois_en_cours from rental where year(rental_date)='2006';

#2 Afficher la colonne qui donne la durée de location des films en jour
select datediff(return_date, rental_date) as durée_location, film.title from rental 
inner join inventory on rental.inventory_id = inventory.inventory_id
inner join film on film.film_id = inventory.film_id;

#3 Afficher les emprunts réalisés avant 1h du matin en 2005. Afficher la date dans un format lisible
select rental_date from rental where year(rental_date)='2005' and hour(rental_date) < '01:00';

#4 Afficher les emprunts réalisés entre le mois d’avril et le mois de mai. La liste doit être trié du plus ancien au plus récent
select rental_date from rental where month(rental_date) between 4 and 5 order by rental_date ASC;

#5 Lister les films dont le nom ne commence pas par le «Le»
select title from film where title like 'le%';

#6 Lister les films ayant la mention «PG-13» ou «NC-17». Ajouter une colonne qui affichera «oui» si «NC-17» et «non» 
select rating, 
	case 
		when rating='PG-13' 
        then 'yes' 
        else 'no'
	end
from film where rating='PG-13' or 'NC-17';

#7 Fournir la liste des catégorie qui commence par un ‘A’ ou un ‘C’. (Utiliser LEFT)
select name from category where left(name,1) in ('A','C');

#8 Lister les trois premiers caractères des noms des catégories
select left(name,3) as categories from category;

#9 Lister les premiers acteurs en remplaçant dans leur prenom les E par des A
select replace(first_name, 'E','A') from actor;


########
# Les jointures
########

#1.Lister les 10 premiers films ainsi que leur langues
select title, name from film inner join language on film.language_id = language.language_id limit 10;

#2.Afficher les film dans lesquels à joué «JENNIFER DAVIS» sortie en 2006
select title, actor.first_name, actor.last_name, release_year from film
inner join film_actor on film.film_id = film_actor.film_id 
inner join actor on film_actor.actor_id = actor.actor_id
where actor.first_name = 'JENNIFER' and actor.last_name = 'DAVIS'
and release_year = '2006';

#3.Afficher le nom des clients ayant emprunté «ALABAMA DEVIL»
select title, customer.first_name, customer.last_name, rental_date from film
inner join inventory on inventory.film_id = inventory.inventory_id
inner join rental on inventory.inventory_id = rental.inventory_id
inner join customer on rental.customer_id = customer.customer_id
where title='ALABAMA DEVIL';

#4.Afficher les films louer par des personne habitant à «Woodridge». Vérifié s’il y a des films qui n’ont jamais été emprunté
select title, city from film
inner join inventory on inventory.film_id = inventory.inventory_id
inner join rental on inventory.inventory_id = rental.inventory_id
inner join customer on rental.customer_id = customer.customer_id
inner join address on address.address_id = customer.address_id
inner join city on city.city_id = address.city_id
where city='Woodridge'

UNION

select title, city from film
inner join inventory on inventory.film_id = inventory.inventory_id
inner join rental on inventory.inventory_id = rental.inventory_id
inner join customer on rental.customer_id = customer.customer_id
inner join address on address.address_id = customer.address_id
inner join city on city.city_id = address.city_id
where rental_id is not null;

#5.Quel sont les 10 films dont la durée d’emprunt à été la plus courte ?
select title, datediff(return_date, rental_date) as durée_emprunt from film
inner join inventory on inventory.film_id = inventory.inventory_id
inner join rental on inventory.inventory_id = rental.inventory_id
order by durée_emprunt ASC limit 10;

#6.Lister les films de la catégorie «Action» ordonnés par ordre alphabétique
select title, category.name from film
inner join film_category on film.film_id = film_category.film_id
inner join category on film_category.category_id = category.category_id
where category.name='Action' order by category.name ASC;

#7.Quel sont les films dont la duré d’emprunt à été inférieur à 2 jour
select title, datediff(return_date, rental_date) as durée_emprunt from film
inner join inventory on inventory.film_id = inventory.inventory_id
inner join rental on inventory.inventory_id = rental.inventory_id
where durée_emprunt <= 2
order by title;


