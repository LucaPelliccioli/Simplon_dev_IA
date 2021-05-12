use sakila;

INSERT INTO city (city,country_id)
VALUES ('Antibes', (SELECT max(country_id) FROM country where country = 'France'));

INSERT INTO address(address, address2, district, city_id, postal_code, phone, location)
VALUES('Rue du Paradis','','06', (SELECT max(city_id) FROM city), '06100','00000000', ST_GeomFromWKB(X'0101000000000000000000F03F000000000000F03F'));

INSERT INTO customer (store_id,first_name,last_name,email,address_id, active,create_date)
VALUES(1,'PELLICCIOLI','LUCA','luca.pelliccioli@simplon.co',(SELECT max(address_id) from address) ,1,now());

#############################

insert into actor(first_name, last_name,last_update)
values("PACINO","AL",now());

insert into film_actor(actor_id,film_id,last_update)
values((SELECT max(actor_id) FROM actor),(SELECT max(film_id) FROM film), now());

insert into film(title, description, release_year,language_id,original_language_id,rental_duration,rental_rate,length,replacement_cost,rating,special_features,last_update)
values("Carlito's Way", "Al Pacino's best film",1993,(SELECT max(language_id) FROM language),NULL,21,4.99,300,21.21,"PG","Trailers",now());

#############################

insert into actor(first_name, last_name,last_update)
values("STEWART","JAMES",now());

insert into film_actor(actor_id,film_id,last_update)
values((SELECT max(actor_id) FROM actor),(SELECT max(film_id) FROM film), now());

insert into film(title, description, release_year,language_id,original_language_id,rental_duration,rental_rate,length,replacement_cost,rating,special_features,last_update)
values("Rear Window", "Alfred Hitchcock's best film",1955,(SELECT max(language_id) FROM language),NULL,22,4.98,200,19.19,"G","Trailers",now());