#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
Created on Tue May 25 15:14:07 2021

@author: simplon
"""
from sqlalchemy import create_engine
import pandas as pd

# Interface utilisateur pour Sakila
# python_Dev_IA_10.0._Python_to_SQL.ipynb exemple d'utilisation
# conda install ou pip install PyMySQL

def connect_db(dico):
    strconnect="mysql+pymysql://"+dico["user"]+':'+dico['pwd']+'@'+dico["host"]+'/'+dico['db']
    engine = create_engine(strconnect)
    return engine

def new_customer(engine):
    customer={}
    country=input("Pays: ")
    
    qc='select country_id from country where country="%s";'
    df = pd.read_sql_query(qc %(country), engine)
    c_id=df['country_id']
    if c_id.empty: # Le pays n'existe pas
        engine.execute('insert into country (country) values ("%s");' %(country))
        customer['country_id']=int(pd.read_sql_query(qc %(country), engine)['country_id'][0])
    else: # le pays existe
        customer['country_id']=int(c_id[0])
    
    city=input("Ville: ")
    qc='select city_id from city where city="%s";'
    c_id=pd.read_sql_query(qc %(city), engine)['city_id']
    if c_id.empty:
        engine.execute('insert into city (country_id,city) values ("%s","%s");' %(customer['country_id'],city))
        customer['city_id']=int(pd.read_sql_query(qc %(city), engine)['city_id'][0])
    else:
        customer['city_id']=int(c_id[0])
    
    ad1=input("adresse 1: ")
    ad2=input("adresse 2: ")
    dist=input("district: ")
    pc=input("postal code: ")
    phone=input("phone: ")
    location="ST_GeomFromWKB(X'0101000000000000000000F03F000000000000F03F')"
    qa='select address_id from address where address="%s";'
    a_id=pd.read_sql_query(qa %(ad1), engine)['address_id']
    if a_id.empty:
        engine.execute('insert into address (address,address2,city_id, postal_code, phone, district,location) values ("%s","%s",%s,"%s","%s","%s",%s);'
                       %(ad1,ad2,customer['city_id'],pc,phone,dist,location))
        customer['address_id']=int(pd.read_sql_query(qa %(ad1), engine)['address_id'][0])
    else:
        customer['address_id']=int(a_id[0])
    
    sto=int(input("Store (1 ou 2) :"))
    fname=input("First name:")
    lname=input("Last name:")
    email=input("email:")
    qc='select first_name from customer where email="%s" and address_id="%s";'
    fnad=pd.read_sql_query(qc %(email,customer['address_id']), engine)
    if fnad.empty:
        engine.execute('INSERT INTO customer (store_id, first_name, last_name, email, address_id,active,create_date) VALUES (%s,"%s","%s","%s",%s,0,now());'
                       %(sto,fname,lname,email,customer['address_id']))
    fnad=pd.read_sql_query(qc %(email,customer['address_id']), engine)
    # print(country,city,customer,fnad)


def historique(engine):
    email=input("Entrer l'email du client : ")
    q="select * from rental where customer_id = (select customer_id from customer where email='%s');"
    hist_df = pd.read_sql_query(q %(email), engine)
    if hist_df.empty:
        print("Pas de location pour ",email)
    else:
        print(hist_df)

# nom d’utilisateur, un mot de passe, un host et le nom d’une base de données
d={'user':'remi',
   'pwd':'Simplon21!',
   'host':'localhost',
   'db':'sakila'}

e=connect_db(d)
# new_customer(e)
# historique(e) # AUSTIN.CINTRON@sakilacustomer.org

query = "select rental_date,amount,customer.customer_id from rental join payment on rental.rental_id = payment.rental_id join customer on rental.customer_id = customer.customer_id;"
data = pd.read_sql_query(query,e)

import matplotlib.pyplot as plt

plt.figure()
plt.subplot(111)
plt.plot(data['rental_date'],data['amount'], marker='o', linestyle='')
plt.xticks(rotation=90)

plt.ylabel('Coût de la location')
plt.xlabel('Date')
plt.title("Coût de location dans le temps")

plt.show()
plt.close()


plt.figure()
plt.subplot(111)
plt.boxplot(data['amount'])
plt.ylabel('Coût de la location')
plt.title("Coût de chaque location")
plt.show()
plt.close()

import numpy as np

d=data.pivot_table(index="customer_id", values='amount', aggfunc=np.sum)
plt.figure()
plt.subplot(111)
plt.boxplot(d['amount'])
plt.ylabel('Somme en $')
plt.title("Somme allouée à la location")
plt.show()
plt.close()

# Exemple de graph
# location par mois en 2005 (x: mois, y: nb locations)
# chiffre d'affaire mensuel (x: mois, y: revenus)
# par store
# total des montants alloués par cat et par pays (x: pays, y: montant, plot: cat)

# CORRECTION #############################################################
"""
from sqlalchemy import create_engine
import json
import pandas as pd
## IMPORT DU CONFIG.JSON
# assignation de la config.json à fichierConfig
fichierConfig = "config.json"
# ouverture et chargement des donnée contenu dans fichierConfig
with open(fichierConfig) as fichier:
    config = json.load(fichier)["mysql"]


def connect_db(config):
    engine = create_engine('mysql+' + config["connector"] + '://' + config["user"] + ":" + config["password"] + "@" + config["host"] + ":" + config["port"] + "/" + config["bdd"], echo=False)
    return engine


connection = connect_db(config)
pd.read_sql_query("SELECT * FROM actor",connection)
"""
"""
{
    "mysql": {
        "connector": "pymysql",
        "user": "root",
        "password": "SIMPLON",
        "host": "localhost",
        "port": "3306",
        "bdd": "sakila"
    }
    
}
"""
"""
Figures now render in the Plots pane by default. To make them also appear
inline in the Console, uncheck "Mute Inline Plotting" under the Plots pane
options menu. 
"""
"""
from sqlalchemy import create_engine
import json
import pandas as pd
## IMPORT DU CONFIG.JSON
# assignation de la config.json à fichierConfig
fichierConfig = "config.json"
# ouverture et chargement des donnée contenu dans fichierConfig
with open(fichierConfig) as fichier:
    config = json.load(fichier)["mysql"]

# fonction avec valeur par défaut
def connect_db(connector='pymysql', user='', password='', host='localhost', port='', bdd='sakila'):
    engine = create_engine('mysql+' + connector + '://' + user + ":" + password + "@" + host + ":" + port + "/" + bdd, echo=False)
    return engine


connection = connect_db(**config)
pd.read_sql_query("SELECT * FROM actor",connection)
"""
# json yanice
"""
{
    "username": "db_username",
    "password": "db_password",
    "dbname": "db_name",
    "host": "db_host"
}
"""
"""
def cherche_historique_location(engine, pNom, pPrenom):
    # prepare requete dont les paramètres sont pNom et pPrenom du client 
    # au fonction de la condition de filtrage
    # Retourne: dataframe de historiques de la location
 
    statement = "SELECT first_name, last_name, rental_date, f.film_id AS film_id, title, timediff(if(return_date is null,0, return_date),rental_date)/(24*60*60) as nb_days "
    statement += " FROM customer AS c LEFT JOIN rental AS r ON c.customer_id = r.customer_id "
    statement += " JOIN inventory AS i ON r.inventory_id = i.inventory_id "
    statement += " JOIN film AS f ON i.film_id = f.film_id "
    statement += f" WHERE first_name REGEXP '.*{pNom}.*' OR last_name REGEXP '.*{pPrenom}.*';"
    
    dfHistorique = pd.read_sql_query(statement , engine)
    
    return dfHistorique

def historique_location_client(engine):
    print("Historique de location d'un client")
    pNom = str(input('Saisir un nom de client: ')).upper()
    pPrenom = str(input('Prenom de client: ')).upper()
    df_historique = cherche_historique_location(engine, pNom, pPrenom)
    
    myCols = ['rental_date', 'film_id', 'title', 'nb_days']
    #afficher le resultat
    print("----- HISTORIQUE DE LOCATION -----")
    print("\t Nom : ", df_historique['first_name'].unique())
    print("\t Prenom :", df_historique['last_name'].unique())
    if not df_historique.empty :
        print(df_historique[myCols])
        print("\t Nombre de fois  = ", df_historique.shape[0])
        print("\t Duree moyenne de location (journee) = %.3f" %(df_historique['nb_days'].mean()))
        print("\t Duree minimum = %.3f" % (df_historique['nb_days'].min()))
        print("\t Duree maximum = %.3f" % (df_historique['nb_days'].max()))
    else :
        print("Pas d'historique de location")
"""
