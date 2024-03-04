# Interroger une Base De Données - 

## Présentation

Par défaut, **_Flask_** n’utilise pas de **_Model_** pour l’accès aux bases de données. **_SQLAchemy_** permet de lui ajouter un **_ORM_** – **_Object Relational Mapper_** – pour assurer cette fonctionnalité. Il existe un paquet spécialement conçu pour les applications **_Flask_**, l’extension python `flask-sqlachemy`.

https://flask-sqlalchemy.palletsprojects.com/en/3.0.x/

SQLAlchemy permet d’associer des classes Python aux tables d’une base de données relationnelle et convertit automatiquement les appels de fonction en instructions SQL. Il permet de dialoguer avec des bases de données **_PostgreSQL_**, **_MySQL_**, **_Oracle_**, **_Microsoft SQL Serveur_**, **_SQLite_**, **_Firebird_** ou **_Sybase_**. 

&nbsp;

> _**Remarque**<p>On peut dialoguer avec la base en implémentant des requêtes SQL à partir du paquet `flask-sqlalchemy-core` ou utiliser directement l'**ORM** (*Object Relational Mapper*)  disponible dans `flask-sqlalchemy` qui mappe directement les éléments de la base de données en objets python. C'est cette option que nous allons étudier.</p>_

&nbsp;

Nous allons construire une application web permettant de consulter la base de données des collectivités françaises. Pour cela, nous allons créer le paquet `app_coll` d'un nouveau projet dans le dossier de même nom, on donne son arborescence à la suite.

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

&nbsp;

On met à disposition la page de style [`mescss.css`](/resources/mescss.css) utilisée pour le design du site. 

&nbsp;

*Code du template HTML `layout.html`*

```jinja
<!DOCTYPE HTML>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        {% if title %}
        <title>ACD 2022 - {{ title }}</title>
        {% else %}
        <title>ACD 2022</title>
        {% endif %}
        <link rel="stylesheet" type="text/css" href="{{ url_for('static', filename='css/mescss.css') }}"/>
        {% block head %}{% endblock %} 
    </head>
    <body>
        <header>
            {% include "nav.html" %}
            {% block header %}{% endblock %}
        </header>
        <section id="info" class="zone_info">
        {% block content %}{% endblock %} 
        </section>
        <footer>{% block footer %}{% endblock %}</footer>
   </body>
</html>
```

&nbsp;

*Code du fragment HTML `nav.html`*

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

&nbsp;

*Code du template HTML `index.html`*

```jinja
{% extends 'layout.html' %}
{% block content %}
<div id="info" class="zone_info">
    <h1>Site de consultation<br/>des régions françaises</h1>
    <ul>
        <li><a href="/region">Lister les régions</a></li>
        <li><a href="/dept">Lister les départements</a></li>
        <li><a href="/mun">Lister les communes</a></li>
    </ul>
    <p>&nbsp;</p>
</div>
{% endblock content %}
```
&nbsp;

---
## Connexion à une base postgresql

> _Pour pouvoir tester le code et mettre en place l'application, il faut installer postgresql (version 12 si vous êtes sous windows) et créer la base de données des collectivités _ les fichiers sql pour les régions, les departements et les communues sont donnés en annexe (dans ressources).

Pour dialoguer avec un serveur **_PostgreSQL_**, il faut installer dans l'environnement virtuel python les paquets `flask-sqlalchemy` et `psycopg2-binary`.

```bash
pip install psycopg2-binary
pip install flask-sqlalchemy
```

&nbsp;

Pour communiquer avec une base de données **_PostgreSQL_** , l'application `Flask` doit instancier la classe `SQLAlchemy`. Il faut préalablement importer à partir du paquet `flask_sqlachemy`. Dans le module `__init__.py`, on initialise la variable de configuration `SQLALCHEMY_DATABASE_URI` de l’application avec l’URI de connexion à la base de données en indiquant le protocole, le nom d’utilisateur, le mot de passe, l’hôte et la base de données.

&nbsp;

*Code du module `__init__.py`*
```python
from flask import Flask
from flask_sqlalchemy import SQLAlchemy
from sqlalchemy import MetaData

app = Flask(__name__)

app.config["SECRET_KEY"] = b'5eed9b976f6d5c80fb8bb74b1bcff9f01218a864d0f2dd76143356d3cc36eda8'

app.config['SQLALCHEMY_DATABASE_URI'] = 'postgresql://nom_utilisateur:password@localhost:5432/collectivites' #URL de la base de donnéescollectivities (postgresql://postgres:iut@localhost:5432/collectivites)

db = SQLAlchemy()
db.init_app(app)
metadata = MetaData(bind=db)

from app_coll import routes
```

&nbsp;

---
## Concevoir les **Models** associés aux tables

L’instance `db` de **_SQLAlchemy_** créée à l’initialisation du paquet dispose des outils **_SQL_** pour dialoguer avec la base de données et l’**_ORM_** de `sqlalchemy`. Elle possède la classe déclarative `db.Model` qui peut être étendue par héritage pour déclarer les classes représentant les tables de la base de données. 

Les attributs correspondent aux champs de la table associée dans la base de données. Ce sont des instances de la classe `db.Column`. Le premier argument transmis au constructeur est le type de la donnée, les arguments suivants permettent de définir des propriétés particulières du champ, **_Primary_key_**, **_ForeignKey_**, **_nullable_**, …

&nbsp;

> _Les types de données les plus courants sont `Integer`, `String(size)`, `Text`, `DateTime`, `Float`, `Boolean`, `PickleType`, `LargeBinary`._

&nbsp;

Les classes associées aux tables de la base de données sont définies conformément à l’**_ORM_** fourni par l’extension `flask-sqlalchemy`. On les qualifie de **_Model_** et elles sont enregistrées dans le module `models.py` à la racine du paquet de l’application.

Il faut donc implémenter un Model par table de notre base de données `collectivities`.




&nbsp;

> _**Remarque** :<p>La première déclaration à l'intérieur d'une classe *Model* est la variable spéciale `__timetable__`qui est initialisée avec le nom de la table dans la base de données. On déclare ensuite les champs en respectant leur nom dans la table._</p>

&nbsp;

### **Maintenir les relations un-à-plusieurs ou plusieurs-à-un**

**_Flask_** utilise deux concepts, la clé étrangère qui indique à SQL le lien construit, la relation qui l’indique à l’application. L’ORM  effectue ainsi des jointures comme en SQL.

- La classe **_ModelFille_** déclare dans l’attribut `Column` une instance de la classe `ForeignKey` qui fait référence à la relation avec la classe *ModelMere_** et son champ clé primaire.
- La classe **_ModelFille_** déclare un champ supplémentaire représentant la `relationship()` , prenant en argument la classe **_ModelMere_** pour signifier la relation entre les deux **_Models_**.
- La classe **_ModelMere_** déclare un champ supplémentaire représentant la `relationship()` , prenant en argument la classe **_ModelFille_** pour signifier la relation entre les deux **_Models_**.

Lors de la création des relations, nous passons un second attribut nommé `back_populates` dont la valeur est le champ de relation de l'autre Model. Cela rend la relation bidirectionnelle et permet de récupérer les informations de l’objet de la classe **_ModelMere_** à partir de la classe **_ModelFille_**.

&nbsp;

### **Maintenir les relations plusieurs-à-plusieurs**

**_SQLAlchemy_** établit des relations plusieurs à plusieurs via des tables d'association. Il est fortement recommandé de ne pas utiliser un modèle mais une table réelle. Cette table associe les deux tables relationnelles. Dès lors, il est possible d’interroger directement cette table  pour obtenir des enregistrements relations associées.
La dernière étape de la mise en œuvre d'une table d'association consiste à définir une relation sur le modèle de données.

&nbsp;

### **Implémenter les modèles**

&nbsp;

*Code du module models.py*

```python
from app_coll import db, metadata

class Region(db.Model):
    __tablename__ = "region"
    region_id = db.Column(db.Integer, primary_key=True)
    region_ref = db.Column(db.String, nullable=False)
    region_name = db.Column(db.String, nullable=False)
    thedepts = db.relationship("Department", back_populates="theregion")
    

class Department(db.Model):
    __tablename__ = "department"
    dept_id = db.Column(db.String, primary_key=True)
    region_id = db.Column(db.Integer, db.ForeignKey("region.region_id"), nullable=False)
    dept_ref = db.Column(db.String, nullable=False)
    dept_name = db.Column(db.String, nullable=False)
    theregion = db.relationship("Region",back_populates="thedepts")
    themunis = db.relationship("Municipality", back_populates="thedept")


class Municipality(db.Model):
    __tablename__ = "municipality"
    mun_id = db.Column(db.Integer, primary_key=True)
    dept_id = db.Column(db.String, db.ForeignKey("department.dept_id"), nullable=False)
    mun_name = db.Column(db.String, nullable=False)
    mun_code = db.Column(db.String, nullable=False)
    insee_code = db.Column(db.String, nullable=True)
    gps_lat = db.Column(db.Float, nullable=True)
    gps_lng = db.Column(db.Float, nullable=True)
    thedept = db.relationship("Department",back_populates="themunis")

```

&nbsp;

---
## Consulter les données

L’objet `db` de connexion à la base de données est instancié dans le module `__init__.py`. Le module `models.py` l’importe et implémente les classes *Model* qui mappent les tables. Chacune d'elles possède un attribut `query` qui permet d'interroger les enregistrements à l’aide des méthodes qu’il propose - Voir l’API de SQLAlchemy 
https://docs.sqlalchemy.org/en/13/orm/query.html#sqlalchemy.orm.query.Query.


- `all()` → retourner dans une liste la totalité des enregistrements 
- `first()` → retourne une instance représentant le premier enregistrement
- `get(ident)` → retourne une instance de l’enregistrement correspondant à l’argument `ident`
- `filter_by(critere1=’val1’, critere2=’val2’, …)` → filtre les enregistrements avant de déclencher la sélection avec `all()` ou `first()`.

Pour visualiser les enregistrements d’une classe, il faut importer la class. On l'utilise dans la fonction pour exécuter une requête et récupérer les enregistrements dans une liste d’objets ou un objet unique.

&nbsp;

> _**Exemple**<p>On traite le cas des région et on se contente de les lister en utilisant le *Model* `Region` déclaré dans `models.py`.</p>_

&nbsp;

L'ORM simplifie le code, on utilise la classe `Region` qui mappe la table `region` pour utiliser la méthode `all()` de son attribut `query`. On transmet la liste obtenu au *template HTML* `list_regions.html` pour qu'il l'affiche.

&nbsp;

*Code du module `routes.py`*
```python
from flask import render_template, request, url_for, redirect, session, flash
from app_coll import app, db
from app_coll.models import Region, Department, Municipality, Member
from app_coll.forms import MemberForm

@app.route("/", methods=['GET'])
def index():
    return render_template('index.html', title="Collectivités françaises")

@app.route("/region", methods=['GET'])
def list_regions():
    regions = Region.query.all()
    return render_template('list_regions.html', title="Collectivités françaises", regions=regions)
```

&nbsp;

*fig.1 - Page d'accueil*

![Accueil collectivité](../img/20221012_113appli11_accueil.jpg)

&nbsp;

*Code du template HTML `list_regions.html`*

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

&nbsp;

*fig.2 - Consultation de la liste des régions françaises*

![Liste régions](../img/20221012_114appli11_regions.jpg)

&nbsp;

On peut lister de la même manière les départements et les municipalités.

Pour les département on reprend le code du templates des regions que l'on adapte pour créer le template des départements `list_dept.html`

*Code du template HTML `list_depts.html`*

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

&nbsp;

On ajoute la vue dans le module `routes.py` et le tour est joué, même si on devra *scroller* un peu sur la page pour voir tous les départements.

&nbsp;

*Code du module `routes.py`*
```python
@app.route("/dept", methods=['GET'])
def list_depts():
    results = Department.query.all()
    return render_template('list_depts.html', title="Collectivités françaises", depts=results)
```

&nbsp;

*fig.3 - Consultation de la liste des régions françaises*

![Liste départements](../img/20221012_115appli11_depts.jpg)

&nbsp;

Pour les municipalités, cela ce complique du fait de leur nombre, <kbd>35853</kbd> communes dans la base de données. On ne peut pas les afficher toutes dans la même page, même en se limitant à leur nom et en utilisant 3 colonnes. 

C'est là que l'ORM prend toute sa place car l'attribut `query` dispose d'une méthode particulière, `paginate()`, qui permet d'assurer la pagination pour les affichages volumineux, en lien avec la vue et le *template HTML*. En fait, la vue renvoie la première page, au *template HTML* qui dispose en pied de page des boutons de navigation entre les pages. A chaque clic sur un bouton, on demande à la vue la page correspondante à afficher.

Dans la vue, on récupére le numéro de page dans l'attribut `args` de l'objet `request` de l'application *Flask*. C'est un *Multidict* python. Sa méthode méthode `get()` permet de récupérer la valeur de la clé transmise, on positionne à la valeur par défaut **1** pour le premier affichage (`page=1`) en précisant qu'il s'agit d'une donnée entière. 

On lance la requête normalement en utilisant la méthode `paginate()` à la place d'une des méthodes `all()` ou `first()`. Le premier argument est le numéro de la page à récupérer, le second le nombre de données par page.

&nbsp;

*Implémentation de la vue `list_muns()` dans `routes.py`*

```python
@app.route("/mun", methods=['GET'])
def list_muns():
    page = request.args.get('page', 1, type=int)
    results = Municipality.query.paginate(page=page, per_page=45)
    return render_template('list_mun.html', muns=results)
```

&nbsp;

*Code du template `list_mun.html`*

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

&nbsp;

*fig.4 - Consultation de la liste des régions françaises*

![liste communes](../img/20221012_116appli11_communes.jpg)

&nbsp;

---
## Trier les données

Il est possible d'ordonner les données récupérer avant de les afficher avec la méthode `order_by()` en lui passant en argument le champ de tri

```python
@app.route("/mun", methods=['GET'])
def list_muns():
    page = request.args.get('page', 1, type=int)
    results = Municipality.query.order_by(Municipality.mun_name.asc()).paginate(page=page, per_page=45)
    return render_template('list_mun.html', muns=results)
```

&nbsp;

---
## Faire des requêtes multitables

En déclarant les *Models* qui mappent les tables de la base de données, on a défini les clés étrangères qui associent les données entre les tables conformément aux règles définies par l'ORM de *SQLAlchemy*.

https://docs.sqlalchemy.org/en/14/orm/basic_relationships.html

L'ORM permet donc de définir une instance de mise en relation entre les deux tables. On bénéficie ainsi dans les objets les champs de l'enregistrement lié.

Si on souhaite voir les départements d'une région, on utilise un filtre sur l'identifiant de la région dans la classe `Department`.

&nbsp;

*Code du template `region.html`*

```jinja
{% extends 'layout.html' %}
{% block content %}
<div id="info" class="zone_info">
    <h1>Consultation du/des département(s) de la région<br />{{ depts[0].theregion.region_name }}</h1>
    <div id="affiche">
        <table class="contact">
            <tr>
                <th>Region</th>
                <th>Départements</th>
            </tr>
            <tr>
                <td rowspan={{ depts|count }}>{{ depts[0].theregion.region_name }}</td>
                <td><a href="/dept/{{ depts[0].dept_id }}">{{ depts[0].theregion.dept_name }}</a></td>
            </tr>
            {% for dept in depts[1:] %}
            <tr>
                <td><a href="/dept/{{ dept.dept_id }}">{{ dept.dept_name }}</a></td>
            </tr>
            {% endfor %}
        </table>
    </div>
    <p>Cliquez sur le département que vous souhaitez consulter pour afficher ses communes.</p>
    <p>&nbsp;</p>
</div>
{% endblock content %}
```

&nbsp;

*Implémentation de la vue `getRegion(region_id)` dans `routes.py`*

```python
@app.route("/region/<int:region_id>", methods=['GET'])
def getRegion(region_id):
    results = Department.query.filter(Department.region_id == region_id).all()
    print(len(results))
    return render_template('region.html', depts=results)
```

&nbsp;

*fig.5 - Consultation de la liste des départements d'une région particulière*

![liste communes](../img/20221012_117appli11_reg-depts.jpg)

&nbsp;

On pratique de la même façon pour lister les communes d'un département. Le *template HTML* devra procéder comme pour lister les communes avec une pagination et un affichage sur trois colonnes.

*Code du template `dept.html`*

```jinja
{% extends 'layout.html' %}
{% block content %}
<div id="info" class="zone_info">
    <h1>Consultation des communes du département<br /> {{ dept.dept_name }}</h1>
    <div id="affiche">
        <h2> {{ municipalities.total }} communes composent le département</h2>
        <p class="colonne4">
            {% for ville in municipalities.items %}
            <a href="/mun/{{ ville.mun_id }}">{{ ville.mun_name }}</a><br />
            {% endfor %}
        </p>
    </div>
    <p>&nbsp;</p>
</div>
<p class="pagination">
{% for page_num in municipalities.iter_pages() %}
    {% if page_num %}
        {% if municipalities.page==page_num %}
            <a class="btn_current" href="{{ url_for('getDept', dept_id=dept.dept_id, page=page_num) }}">{{ page_num }}</a>
        {% else %}
            <a class="btn" href="{{ url_for('getDept', dept_id=dept.dept_id, page=page_num) }}">{{ page_num }}</a>
        {% endif %}
    {% else %}
        ...
    {% endif %}
{% endfor %}
</p>

{% endblock content %}
```

&nbsp;

*Implémentation de la vue dans `routes.py`*

```python
@app.route("/dept/<string:dept_id>", methods=['GET'])
def getDept(dept_id):
    page = request.args.get('page', 1, type=int)
    dept = Department.query.filter(Department.dept_id == dept_id).first()
    results = Municipality.query.filter(Municipality.dept_id == dept_id).paginate(page=page, per_page=45)
    return render_template('dept.html', dept=dept, municipalities=results)

```

&nbsp;

*fig.6 - Consultation de la liste des communes d'un département particulier*

![liste communes](../img/20221012_118appli11_dept-muns.jpg)

&nbsp;

---
## Effectuer des requêtes de sélection

On souhaite voir la fiche d'une commune en particulier, on doit donc effectuer une sélection sur la commune en précisant son identifiant.

&nbsp;

*Code du template `ville.html`*

```jinja
{% extends 'layout.html' %}
{% block content %}
<div id="info" class="zone_info">
    <h1>Fiche de la commune de<br/>{{ municipality.nom_ville }}</h1>
    <div id="affiche">
        <h2>Données administratives</h2>
        <ul>
            <li>nom de commune : {{ municipality.nom_ville }}</li>
            <li>Identifiant INSEE  : {{ municipality.insee_code }}</li>
            <li>Code postal  : {{ municipality.cp }}</li>
            <li>Département  : {{ municipality.nom_dept }}</li>
            <li>Région  : {{ municipality.nom_region }}</li>
        </ul>
        <h2>Coordonnées géographiques GPS</h2>
        <ul>
            <li>Longitude : {{ municipality.gps_lng }}</li>
            <li>Lattitude : {{ municipality.gps_lat }}</li>
        </ul>
    </div>
    <p>&nbsp;</p>
</div>
{% endblock content %}
```

&nbsp;

*Implémentation de la vue `getMunicipality(mun_id)` dans `routes.py`*

```python
@app.route("/mun/<string:mun_id>", methods=['GET'])
def getMunicipality(mun_id):
    result = Municipality.query.filter(Municipality.mun_id == mun_id).first()
    return render_template('municipality.html', municipality=result)
```

&nbsp;

*fig.7 - Consultation des caractéristiques d'une commune*

![liste communes](../img/20221012_119appli11_mun-detail.jpg)

&nbsp;

---
## Insérer des données

Les opérations d'insertion sont réalisées dans le cadre de tansactions au cours desquelles il faut :

- Créer l'objet python représentant l'enregistrement
- Ajouter l'objet à la session de la transaction 
- Valider la session

La base de données *collectivities* dispose d'une quatrième table, `member` pour enregistrer les comptes utilisateurs autorisés à utiliser le site.

### Classe *Model* pour la table `member` 

L’authentification s’appuie sur la table `member` dans la base de données. La classe `User` qui mappe cette table est créée, l’ORM de dialogue est en place. Il faut ajouter les fonctions qui doivent permettre d’authentifier un utilisateur, de créer un nouvel utilisateur, de modifier le mot de passe d’un utilisateur,  de supprimer un utilisateur.

&nbsp;

*Ajout de la classe `Member` dans le module `models.py`*

```python
class Member(db.Model):
    __tablename__ = 'member'
    id_member = db.Column(db.Integer, autoincrement=True, primary_key=True)
    username = db.Column(db.String, nullable=False)
    password = db.Column(db.String, nullable=False)
    
    def hash_password(self, password):
        self.mdp = generate_password_hash(password)

    def verify_password(self, password):
        return check_password_hash(self.mdp, password)
```

&nbsp;

Il faut créer la vue pour traiter le formulaire de création d'un nouveau membre. On utilise *flask-WTF* pour bénéficier des validateurs et de la protection CSRF.

&nbsp;

*Implémentation de la vue `sign_up()` dans `routes.py` pour la saisie d'un membre*

```python
@app.route("/sign-up/", methods=['GET', 'POST'])
def sign_up():
    memberForm = MemberForm()
    if request.method == 'POST':
        member = Member(username = memberForm.username.data,
                        password = memberForm.password.data)
        member.hash_password(memberForm.password.data)
        db.session.add(member)
        db.session.commit()
        return redirect(url_for("index"))            
    return render_template('sign_up.html', form=memberForm)
```

&nbsp;

*Code du template HTML `sign_up.html`*

```jinja
{% extends 'layout.html' %}
{% block content %}
<div  class="login-form"><h1>Saisie d'un nouveau membre</h1>
<form method="POST">{{ form.csrf_token }}
    <p><label for="username">Username : </label><br/>
        {{ form.username }}</p>
    <p><label for="password">Mot de passe : </label><br/>
        {{ form.password }}</p>
    <p><label for="confirm">Confirmer le mot de passe : </label><br/>
        {{ form.confirm }}</p>
<p>Pour enregistrer, cliquez sur le bouton  {{ form.submit }}</p>
</form></div>
{% endblock content %}
```

&nbsp;

[**_Sommaire_** :arrow_heading_up:  ](../README.md)

_[:rewind: **Interroger une API**](part8_req-api.md) / [**Déploiment** :fast_forward:](part10_deploy.md)_

