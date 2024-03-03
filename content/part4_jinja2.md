# Utiliser les templates HTML - **Utiliser FLASK en BUT RT**

## Principe d'utilisation des *template HTML*

Dans une application *Flask*, les gabarits des réponses HTML sont stockés dans un dossier nommé `templates`, situé à la racine du paquet de l’application. Ce sont des fichiers textes qui contiennent des éléments HTML et des espaces réservés pour les données dynamiques.

Ils sont appelés dans l’instruction `return` de la fonction vue attachée à la route pour retourner la réponse HTML. l’instruction `return` invoque la fonction `render_template()` qui prend en premier argument le nom complet du *template HTML* à utiliser. Les autres paramètres sont des données dynamiques transmises par la vue au gabarit pour adapter l'affichage. Ces attributs peuvent être des attributs nommés ou des données regroupés dans le dictionnaire `context` de la fonction.

**Jinja2**  est le moteur de template utilisé par *Flask* pour traiter les *templates HTML*.

https://jinja.palletsprojects.com/en/3.0.x/templates/

Le gabarit utilise des délimiteurs spéciaux (ou balises) placées dans le code HTML aux emplacements prévues pour afficher les données transmises par la vue. 

- `{{ ... }}` → expression qui sera sortie dans le document final
https://jinja.palletsprojects.com/en/2.11.x/templates/#list-of-control-structures 

- `{% ... %}` → déclaration de bloc ou de structure de  contrôle - test conditionnel, boucle
https://jinja.palletsprojects.com/en/2.11.x/templates/#expressions

- `{# ... #}` → commentaires non inclus dans la sortie du modèle
https://jinja.palletsprojects.com/en/2.11.x/templates/#comments 

> Les espaces entre délimiteur de balise et contenu sont obligatoires

---
### Exemple d'utilisation

> Dans le dossier d'accueil du projet, créez le dossier `appli_jinja` pour en faire une application selon le modèle vue dans la présentation de Flask utilisant un paquet python. Son arborescence est donnée ci-après :_

```bash
./appli_jinja/
├── __init__.py
├── routes.py
├── static
│   ├── css
│   └── img
└── templates
    ├── index.html
    └── user.html
```

---

Code du module `__init__`

```python
from flask import Flask

app = Flask(__name__)

from appli_jinja import routes 
```

---

Code du module `route.py`

```python
from flask import render_template
from test_jinja import app

@app.route("/")
@app.route("/accueil")
def index():
    return render_template("index.html")

@app.route("/user/<string:firstname>/<string:lastname>")
def getUser(firstname, lastname):
    return render_template("user.html", 
                            firstname=firstname, 
                            lastname=lastname)
```

---

Code du template HTML `index.html`

```Jinja
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>ACD 2022</title>
</head>
<body>
    <h1>Bienvenue dans la formation Flask</h1>
</body>
</html>
```

---

Code du template HTML `user.html`

```Jinja
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>ACD 2022</title>
</head>
<body>
    <h1>Bienvenue dans la formation Flask</h1>
    <h2>Utilisateur connecté : {{ firstname }} {{ lastname }}</h2>
</body>
</html>
```
le *template*  récupère les attrbuts `firtname` et `lastname` et il les intègre au niveau du titre niveau 2 `<h2>`.

> **_Remarque_** :<br/>La route pour affiche l'utilisateur demande deux paramètres. Si il en manque, le serveur répondra par une erreur **404 NotFound**.

IL est possible d'appliquer des filtres particuliers sur les paramètres transmis avant de les utiliser. Il suffit de l'integrer dans la balise à l'aide d'un pipeline «**|**», on utilise la syntaxe `{{ parameter | filter }}`.

> **_Exemple_** :<br/>_On souhaite afficher le nom de l'utilisateur en majuscule, on utilise le filtre `upper` :_

```Jinja
<h2>Utilisateur connecté : {{ firstname }} {{ lastname | upper }}</h2>
```

La liste des filtre disponible est donnée à la suite

https://jinja.palletsprojects.com/en/3.0.x/templates/#list-of-builtin-filters

| <!-- -->    | <!-- -->    | <!-- -->    | <!-- -->    | <!-- -->    | <!-- -->    |
|-------------|-------------|-------------|-------------|-------------|-------------|
| abs() | float() | lower() | round() | tojson() | attr() |
| forceescape() | map() | safe() | trim() | batch() | format() | max() |
| select() | truncate() | capitalize() | groupby() | min() | selectattr() |
| unique() | center() | indent() | pprint() | slice() | upper() |
| default() | int() | random() | sort() | urlencode() | dictsort() |
| join() | reject() | string() | urlize() | escape() | last() |
| rejectattr() | striptags() | wordcount() | filesizeformat() | length() | replace() |
| sum() | wordwrap() | first() | list() | reverse() | title() |
| xmlattr() |  |  |  |  |  |
| <!-- -->    | <!-- -->    | <!-- -->    | <!-- -->    | <!-- -->    | <!-- -->    |

## Utiliser un patron de page

Chaque page d’une application web a la même structure HTML de base mais présente un contenu différent. Pour éviter de réécrire cette structure, on définit un gabarit de base que chaque *template* de vue utilisera en remplaçant certaines sections spécifiques. C’est l'héritage de modèles de **Jinja2**. 

Le gabarit de base contient tous les éléments du site communs à toutes les pages et définit les blocs que les gabarits enfants peuvent remplacer. On définit un bloc de code à substituer par une déclaration **Jinja2** utilisant le mot clé `block` suivi du nom du bloc et finissant par une déclaration `endblock`.


```Jinja
<!DOCTYPE HTML>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        {% if title %}
        <title>ACD 2022 - {{ title }}</title>
        {% else %}
        <title>ACD 2022</title>
        {% endif %}
        {% block head %}{% endblock %} 
    </head>
    <body>
        <header>{% block header %}{% endblock %}</header>
        <section>
            <div id="info" class="zone_info">
            {% block content %}{% endblock %} 
            </div>
        </section>
        <footer>{% block footer %}{% endblock %}</footer>
   </body>
</html>
```
*Fichier `/templates/layout.html`*

Ce *template* servira de trame de base à tous les autres. On peut observer la structure conditionnelle utiliser pour l'affichage du titre de l'onglet dans le navigateur. Si la vue transmet un paramètre `title` dans la fonction `render_template`, il sera ajouter au titre par défaut, sinon on affiche le titre par défaut.

Les branchements conditionnelles sont implémentées à l'aide des balises :

- `{% if condition %}` → clause conditionnelle à tester, suivie de l'action si `True`
- `{% elif condition %}` → nouvelle clause conditionnelle si `False`
- `{% else %}` → action si `False`
- `{% endif %}` → Fin de clause

Dans le corps du document HTML, on déclare un bloc nommé `content`. Il recevra les implémentation réaliser dans les templates enfants qui en hériteront.

```Jinja
{% block content %}{% endblock %}
```

## Héritage de modèle

Le *template HTML* enfant est celui appelé par la route. Pour s'appuyer sur le patron de base il utilise en première instruction la balise *Jinja2* d'héritage avec le nom du gabarit utilisé `{{ extends "layout.html" }}`. Il faut ensuite définir les le contenu des blocks du modèle de base en les déclarant avec le même nom.

> **_Remarque_**:<br/> _Si un bloc est omis, c'est son contenu dans le modèle de base qui sera utilisé._


Code du template HTML `index.html`

```Jinja
{% extends "layout.html" %}
{% block content %}
    <h1>Bienvenue dans la formation Flask</h1>
{% endblock%}
```

---

Code du template HTML `user.html`

```Jinja
{% extends "layout.html" %}
{% block content %}
    <h1>Bienvenue dans la formation Flask</h1>
    <h2>Utilisateur connecté : {{ firstname }} {{ lastname | upper }}</h2>
{% endblock%}
```

Code du module `routes.py`

```python
from flask import render_template
from test_jinja import app

@app.route("/")
@app.route("/accueil")
def index():
    return render_template("index.html")

@app.route("/user/<string:firstname>/<string:lastname>")
def getUser(firstname, lastname):
    return render_template("user.html", title="Test Jinja2"
                            firstname=firstname, 
                            lastname=lastname)
```

![Test Jinja](/img/20221012_10jinja.jpg)

## Boucle itérative dans un *template*

Si la vue transmet unne collection en paramètre au *template*, Jinja2 permet de mettre une boucle itérative `for ... in` pour scruter chaque élément de la collection et les afficher.

Les boucles itératives sont implémentées à l'aide des balises :

- `{% for iter in collection %}` → déclaration de la boucle 
  - `iter` est la variable d'itération
  - `collection` est la collection itérable transmise
- `{% endfor %}` → fin de la boucle

> **_Exemple_** :<br/>On va créer une vue qui contient une liste de dictionnaires des enseignants du département RT de Chalons. La liste est transmise au *template* dans le paramètre `teachers`.<br/> Le gabarit `teachers.html` étend le modèle de base `layout.html`. Il utilise une boucle sur la liste d’enseignant pour afficher les items `<li> ... </li>` de la liste `<ul>`.

---

Code du template HTML `teachers.html`

```Jinja
{% extends "layout.html" %}
{% block content %}
<h1>Bienvenue dans la formation Flask</h1>
<h2>Liste des enseignants du département RT de l'IUT</h2>
<ul>
  {% for prof in teachers %}
    <li>{{ prof['firstname'] }} {{ prof['lastname'] | upper }} -
        {{prof['domain']}}</li>
  {% endfor %}
</ul>
{% endblock %}
```

Code du module `routes.py`

```python
from flask import render_template
from test_jinja import app

@app.route("/")
@app.route("/accueil")
def index():
    return render_template("index.html")

@app.route("/user/<string:firstname>/<string:lastname>")
def getUser(firstname, lastname):
    return render_template("user.html", title="Test Jinja2"
                            firstname=firstname, 
                            lastname=lastname)

@app.route("/teachers")
def getTeachers():
    teachers = [
        {"firstname":"Bruno","lastname":"Botella","domain":"Info"},
        {"firstname":"Cheriffa","lastname":"Boucetta","domain":"Info"},
        {"firstname":"Jacky","lastname":"Etienne", "domain":"Réseaux"},
        {"firstname":"Delphine","lastname":"Gobillard","domain":"Maths"},
        {"firstname":"Vincent","lastname":"Gobillard","domain":"Télécoms"},
        {"firstname":"Céline","lastname":"Jacob-Menou","domain": "Anglais"},
        {"firstname":"Laurent","lastname":"Hussenet","domain":"Réseaux"},
        {"firstname":"Michel","lastname":"Melcior", "domain":"Réseaux"},
        {"firstname":"Séverine","lastname":"Menillet Reyrolle","domain":"Expr/Com"},   
        {"firstname":"Valeriu","lastname":"Vrabi", "domain": "Télécoms"}
    ]
    return render_template("teachers.html", title="Profs IUT RT", teachers=teachers)
```

![Test Jinja](/img/20221012_11jinja-for.jpg)

## Inclure des *templates* - fragments HTML

Une pratique courante consiste a créer un fragment de code HTML à insérer dans une page, bloc de menu, entête ou pied de site, ...

Les fragments sont des *templates* qui intégrent l'ensemble du code HTML qui les caratérise dans un seul fichier. Le fragment est inclut dans un *template HTML* à l'aide de la balise Jinja2 `{% include "fragment.html"}`.

Code du fragment `alert.html`
```Jinja
<div style="box-shadow: 2px 2px 10px #adadad; border-radius:10px;
            width:70%; margin: 0px auto; padding: 10px; 
            text-align:center">
    <p>Ce site est destiné à présenter les possibilités 
       offertes par le framework Flask et le moteur de 
       template Jinja 2</p>    
</div>
```

Code du *template* `index.html` qui charge le fragment `alert.html`
```Jinja
{% extends "layout.html" %}
{% block content %}
    <h1>Bienvenue dans la formation Flask</h1>
    {% include "alert.html" %}
{% endblock %}
```

![Test Jinja](/img/20221012_12jinja-include.jpg)



