# Interroger une Base De Données - **Utiliser FLASK en BUT RT**

## Présentation

Par défaut, Flask n’utilise pas de *Model* pour l’accès aux bases de données. *SQLAchemy* permet de lui ajouter un **ORM** – *Object Relational Mapper* – pour assurer cette fonctionnalité. Il existe un paquet spécialement conçu pour les application *Flask*, l’extension python `flask-sqlachemy`.

https://flask-sqlalchemy.palletsprojects.com/en/3.0.x/

SQLAlchemy permet d’associer des classes Python aux tables d’une base de données relationnelles et convertir automatiquement les appels de fonction en instructions SQL. Il permet de dialoguer avec des bases de données *PostgreSQL*, *MySQL*, *Oracle*, *Microsoft SQL Serveur*, *SQLite*, *Firebird* ou *Sybase*. 

> On peut dialoguer avec la base en implémentant des requêtes SQL à partir du paquet `flask-sqlalchemy-core` ou utiliser directement l'**ORM** (*Object Relational Mapper*)  disponible dans flask-sqlalchemy qui mappe directement les éléments de la base de données en objets python. C'est cette option que nous allons étudier.

 Nous allons construire une application web permettant de consulter la base de données des collectivités françaises. Pour cela, nous allons créer le paquet d'un nouveau projet dans le dossier `app_coll`, on donne son arborescence à la suite.

 ```bash
./app_coll/
├── __init__.py
├── models.py
├── routes.py
├── static
│   ├── css
│   │   └── mescss.css
│   └── img
│       └── logo-rt.png
└── templates
    ├── accueil.html
    ├── dept.html
    ├── index.html
    ├── layout.html
    ├── list_depts.html
    ├── list_regions.html
    ├── region.html
    ├── sign_in.html
    ├── sign_up.html
    └── ville.html

```
On met à disposition la page de style [`style.css`](/resources/mescss.css) utilisées pour le design du site  le fichier CSS mi 

## Connexion à une base postgresql

> Vous disposez dans le cadre de la formation d'un serveur de bases de données PostgreSQL activé sur le port `2022` de la machine `10.59.80.90`. Vous trouverez à l'intérieur la base de données `collectivities`que vous pouvez consulter avec le compte PostgreSQL `acd2022` (mot de passe également `acd2022`).

Pour dialoguer avec un serveur *PostgreSQL*, il faut installer dans l'environnement virtuel python les paquets `flask-sqlalchemy` et `psycopg2-binary`.

```bash
pip install psycopg2-binary
pip install flask-sqlalchemy
```

Pour communiquer avec une base de données *PostgreSQL* , l'application *Flask* doit instancier la classe `SQLAlchemy` qu'il faut préalablement importer à partir du paquet `flask_sqlachemy`. On initialise la variable de configuration `SQLALCHEMY_DATABASE_URI` de l’application *Flask* avec l’URI de connexion à la base de données en indiquant le protocole, le nom d’utilisateur, le mot de passe, l’hôte et la base de données dans le module `__init__.py`.

```python
from flask import Flask
from flask_sqlalchemy import SQLAlchemy
from sqlalchemy import MetaData

app = Flask(__name__)
app.config['SQLALCHEMY_DATABASE_URI'] = 'postgresql://acd2022:acd2022@10.59.80.90:2022/collectivities'

db = SQLAlchemy()
db.init_app(app)
metadata = MetaData(bind=db)

from app_coll import routes
```

## Concevoir les **Model** associés aux tables

L’instance `db` de *SQLAlchemy* créée à l’initialisation du paquet dispose des outils *SQL* pour dialoguer avec la base de données mais également de l’*ORM* de `sqlalchemy`. Elle possède la classe déclarative `db.Model` qui peut être étendue par héritage pour déclarer les classes représentant les tables de la base de données. 

Les attributs correspondent aux champs de la table associée dans la base de données. Ils sont des instances de la classe `db.Column`. Le premier argument transmis au constructeur est le type de la donnée, les arguments suivants permettent de définir des propriétés particulières du champ – *Primary_key*, *ForeignKey*, *nullable*, …

> Les types de données les plus courants sont `Integer`, `String(size)`, `Text`, `DateTime`, `Float`, `Boolean`, `PickleType`, `LargeBinary`.

Les classes associées aux tables de la base de données sont définies conformément à l’*ORM* fourni par l’extension `flask-sqlalchemy`. On les qualifie de *Model* et elles sont enregistrées dans le module *models.py* à la racine du paquet de l’application.

Il faut donc implémenter un Model par table de notre base de données `collectivities`.

> **_Remarque_** :<br/>La première déclaration à l'intérieur d'une classe *Model* est la variable spéciale `__timetable__`qui est initialisée avec le nom de la table dans la base de données. On déclare ensuite les champs en respectant leur nom dans la table.

*Module models.py*

```python
from app_coll import db, metadata

class Region(db.Model):
    __tablename__ = "region"
    region_id = db.Column(db.Integer, primary_key=True)
    region_ref = db.Column(db.String, nullable=False)
    region_name = db.Column(db.String, nullable=False)
    dept_in_region = db.relationship("Department")
    

class Department(db.Model):
    __tablename__ = "department"
    dept_id = db.Column(db.String, primary_key=True)
    region_id = db.Column(db.Integer, db.ForeignKey("region.region_id"), nullable=False)
    dept_ref = db.Column(db.String, nullable=False)
    dept_name = db.Column(db.String, nullable=False)
    ville_in_dept = db.relationship("Municipality")


class Municipality(db.Model):
    __tablename__ = "municipality"
    mun_id = db.Column(db.Integer, primary_key=True)
    dept_id = db.Column(db.String, db.ForeignKey("department.dept_id"), nullable=False)
    mun_name = db.Column(db.String, nullable=False)
    mun_code = db.Column(db.String, nullable=False)
    insee_code = db.Column(db.String, nullable=True)
    gps_lat = db.Column(db.Float, nullable=True)
    gps_lng = db.Column(db.Float, nullable=True)
```

## Consulter les données

L’objet `db` de connexion à la base de données est instancié dans le module `__init__.py`. Le module `models.py` l’importe et implémente les classes *Model* qui mappent les tables. Chacun d'elle possède un attribut `query` qui permet interroger les enregistrements à l’aide des méthodes qu’il propose (Voir l’API de SQLAlchemy 
https://docs.sqlalchemy.org/en/13/orm/query.html#sqlalchemy.orm.query.Query.


- `all()` → retourner dans une liste la totalité des enregistrements 
- `first()` → retourne une instance représentant le premier enregistrement
- `get(ident)` → retourne une instance de l’enregistrement correspondant à l’argument `ident`
- `filter_by(critere1=’val1’, critere2=’val2’, …)` → filtre les enregistrements avant de déclencher la sélection avec `all()` ou `first()`.

Pour visualiser les enregistrements d’une classe, il faut importer la classe puis l’utiliser dans la fonction pour exécuter une requête et récupérer les enregistrements dans une liste d’objets ou un objet unique.

> **_Exemple_** :<br/>On traite le cas des région et on se contente de les lister en utilisant le *Model* `Region` déclaré dans `models.py`.

```python
from flask import render_template, request
from app_coll import app, db
from app_coll.models import Region, Department, Municipality

@app.route("/", methods=['GET'])
def index():
    return render_template('index.html')

@app.route("/region", methods=['GET'])
def list_regions():
    regions = Region.query.all()
    return render_template('list_regions.html', regions=regions)
```

L'ORM simplifie le code, on se contente dutiliser la classe `Region` qui mappe la table `region` et d'utiliser la méthode `all()` de l'attribut `query` et on transmet la liste obtenu au *template HTML* `list_regions.html` pour qu'il l'affiche.

```jinja
{% extends 'layout.html' %}
{% block content %}
<div id="info" class="zone_info">
    <h1>Formulaire de consultation<br/>des régions française</h1>
    <div id="affiche">
        <table class="contact">
            <tr><th class="col1">identifiant</th><th>Nom</th></tr>
            {% for region in regions %}
            <tr><td><a href="/region/{{ region.region_id }}">{{ region.region_id }}</a></td><td><a href="/region/{{ region.region_id }}">{{ region.region_name }}</a></td></tr>
            {% endfor %}
        </table>
    </div>
    <p>&nbsp;</p>
</div>
{% endblock content %}
```

*Pour rappel : `layout.html`*

```jinja
<!DOCTYPE HTML>
<html>
   <head>
      <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
      {% if title %}
      <title>Collectivites - {{ title }}</title>
      {% else %}
      <title>Collectivites</title>
      {% endif %}
      <link rel="stylesheet" type="text/css" href="{{ url_for('static', filename='css/mescss.css') }}"/>
   </head>
   <body>
      <div id="info" class="zone_info">
         {% block content %}{% endblock %} 
      </div>
   </body>
</html>
```

On peut lister de la même manière les départements et les municipalités.

Pour les département on reprend le code du templates des regions que l'on adapte pour créer le template des départements `list_dept.html`

On ajoute la vue dans `routes.py` et le tour est joué même si on devra *scroller* un peu sur la page pour voir les dernières.

Pour les municipalités, cela ce complique du fait de leur nombre, <kbd>35853</kbd> communes dans la base de données. On ne peut pas afficher tout dans une seule page, même en se limitant à leur nom et en utilisant 3 colonnes.

C'est là que l'ORM prend toute sa place car l'attribut `query` dispose d'une méthode paginate() qui permet d'assurer la pagination pour les affichages volumineux en lien avec la vue et le *template HTML*.

En fait, la vue renvoie la première page, au *template HTML* qui dispose en pied de page des boutons de navigation entre les pages. A chaque clic dessus, il redemande à la vue la page à afficher.

Dans la vue, vous récupérer le numéro de page dans l'attribut `args` de l'objet `request` de l'application *Flask*. C'est un Multidict python donc la méthode sat méthode `get()` permet de récupérer la valeur de la clé transmise, on positionne à la valeur par défaut **1** pour le premier affichage (page 1) en précisant qu'il s'agit d'une donnée entière. 

Vous lancez la requête normalement en utilisant la méthode `paginate()` à la place d'une des méthodes `all()` ou `first()`. Le premier argumet est le numéro de page récupérée, le second le nombre de donnée par page.

*Template `list_mun.html`*

```jinja
{% extends 'layout.html' %}
{% block content %}
<div id="info" class="zone_info">
    <h1>Liste des communes de France</h1>
    <div id="affiche">
        <p> {{ muns.total }} communes composent le département</p>
        <p class="colonne3">
        {% for muni in muns.items %}
        {{ muni.mun_name }}<br/>
        {% endfor %}
        </p>
    </div>
    <p>&nbsp;</p>
</div>
<p class="pagination">
{% for page_num in muns.iter_pages() %}
    {% if page_num %}
        {% if muns.page==page_num %}
            <a class="btn_current" href="{{ url_for('list_muns', page=page_num) }}">{{ page_num }}</a>
        {% else %}
            <a class="btn" href="{{ url_for('list_muns', page=page_num) }}">{{ page_num }}</a>
        {% endif %}
    {% else %}
        ...
    {% endif %}
{% endfor %}
</p>
{% endblock content %}
```

*Implémentation de la vue dans `routes.py`*

```python
@app.route("/mun", methods=['GET'])
def list_muns():
    page = request.args.get('page', 1, type=int)
    results = Municipality.query.paginate(page=page, per_page=45)
    return render_template('list_mun.html', muns=results)
```

## Trier les données

Il est possible d'ordonner les données récupérer avant de les afficher avec la méthode `order_by()` en lui passant en argument le champ de tri

```python
@app.route("/mun", methods=['GET'])
def list_muns():
    page = request.args.get('page', 1, type=int)
    results = Municipality.query.order_by(Municipality.mun_name.asc()).paginate(page=page, per_page=45)
    return render_template('list_mun.html', muns=results)
```

## Faire des requêtes multitables

En déclarant les *Models* qui mappent les tables de la base de données, on a défini les clés étrangères qui associent les données entre les tables conformément aux règles définies par l'ORM de *SQLAlchemy*.

https://docs.sqlalchemy.org/en/14/orm/basic_relationships.html



## Effectuer des requêtes de sélection


