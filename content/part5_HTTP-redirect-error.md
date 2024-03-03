# Gérer les requêtes HTTP - Pages d'erreur et redirection - 

## Génération d'URL

Les URL d'accès aux ressources et aux pages sont au coeur du fonctionnement d'un site web. 

Flask mappe une URL en route d'accès vers une vue (décorateur `app.route()`). A l’inverse, la fonction `url_for()` du module `flask` permet de générer une URL à partir d’une fonction vue.

- 1er argument → nom de la fonction vue (et pas le *template HTML*)
- arguments suivants → paramètres nommés de la fonction

Pour les URL vers les ressources statiques placées dans le dossier `/static` – CSS, scripts, images, …

- 1er argument → dossier `static`
- 2ème argument → attribut nommé `filename` contenant le chemin relatif vers le fichier

La fonction `url_for()` est utilisée dans les *templates HTML* pour accéder aux resources de la page, CSS, images, scripts, ... Elle est intégrée comme valeur à l'attribut de l'élément HTML qui fait référence à la ressoure à l'aide d'une *balise d'expression Jinja* .


- Ajout d'une page CSS → `<link rel="stylesheet" type="text/css" href="{{ url_for('static', filename='css/styles.css') }}"/>`
- Ajout d'une image → `<img src="{{ url_for('static’, filename='img/logo.png’) }}" alt="">`
- lien hypertexte vers une vue →`<a href="{{ url_for('index') }}>Home</a>`

> **_Exemple_** :<br/>_On peut améliorer le design du site **appli_jinja** en intégrant une entête de page dans un fragment HTML chargée de  l'affichage. L'entête proposera un menu de navigation vers la page d'accueil du site, la page de l'utilisateur et la page des enseignants. Dans l'entête  HTML du Gabarit de base `layout.html`, ajoutez le chargement de la page CSS `css/styles.css`_

---

## Gestion des requêtes HTTP

Une requête HTTP est composée par une entête (*un verbe HTTP, une URI – Uniform Resource Identifier, une version HTTP*) suivie d'une ligne de séparation et d'un corps de requête optionnel → balise <body>...</body>.

Les méthodes des requêtes HTTP implémentées dans *FLASK* sont les suivantes :

- GET → demander la ressource spécifiée
- HEAD → comme GET sans le corps de la réponse (on a uniquement l'en-tête)
- POST → envoyer des données vers la ressource indiquée
- PUT → remplacer les représentations de la ressource visée
- DELETE → Supprimer la ressource indiquée
- PATCH → appliquer des modifications partielles à une ressource

Une réponse HTTP est composée par une entête (*un verbe HTTP, un code état de la réponse, une explication du code état*) suivie d'une ligne de séparation et d'un corps de requête optionnel.

Les principaux codes de réponses HTTP sont les suivants

- Série 100 → information de réponse provisoire
- Série 200 → code de succès
  - code 200 OK
  - code 204 pas de contenu
- Série 300 → redirection
  - code 301 déplacé de manière permanente 
  - code 304 non modifié
- Série 400 → erreur client
  - code 401 échec d’authentification
  - code 403 accès interdit
  - code 404 introuvable
- Série 500 → erreur serveur
  - code 503 server indisponible (surcharge, maintenance, …)

L'application peut conditionner le déclenchement d'une vue en précisant comme second argument du décorateur de route la liste des méthodes HTTP autorisées sur une URL 
```python
@app.route("/slug_url/", methods=['GET', 'POST'])
```
< **_Remarque_**> :<br/>_Si l'argument `method` est omis, la seule méthode acceptée par défaut est la méthode GET._

Pour gérer les différentes méthodes HTTP pouvant être reçues, le paquet flask dispose de l'objet `request`, instance de la classe `Request`

https://tedboy.github.io/flask/generated/generated/flask.Request.html 

### Traitement des requêtes GET

Il est possible d'envoyer des données au serveur en utilisant la méthode GET à à trvers l'URL. L’utilisateur peut envoyer des paramètres à l'application dans une requête GET

- soit en utilisant une  URL *meanningful* paramétrée
  ```
  http://127.0.0.1:5000/slug_url/val1/val2
  ```
  Le décorateur de route prévoit alors les paramètres et la vue associée possède les arguments pour les réceptionner. Elle les traite directement et les transmet au *template HTML* retourné.

  ```python
  @app.route("/test-get/<param1>/<param2>", methods=['GET'])
  def testGet(param1, param2):
    params = {"param1":param1, "param2":param2}
    return render_template("testGET.html", params=params)
  ```

- soit en joignant les paramètres à l’URL
  ```
  http://127.0.0.1:5000/slug_url?param1=val1&param2=val2
  ```
  Les paramètres ne sont pas des arguments de la route mais ils sont joins à l'URL au moment de l'envoi. Il faut utiliser l’objet `request` de `flask`, préalablement importé, dans la vue. Les paramètres sont collectés dans son attribut  `args` (dictionnaire). La vue traite les données transmises et les transmet au *template HTML* retourné.

  ```python
  @app.route("/test-get/")
  def testGet():
      return  render_template('testGET.html', params=request.args)
  ```

```jinja
{% extends "layout.html" %}
{% block content %}
<h2>Requête GET<br/>Récupération des paramètres</h2>
{% if params %}
<ul>
    {% for key in params %}
    <li>{{ key }} : {{ params.get(key) }}</li>
    {% endfor %}
</ul>
{% endif %}
{% endblock %}
```

Les limites d'utilisation de la méthode GET pour transmettre des données au serveur vienne de la limite de taille d'une URL qui est de l'ordre de 2000 caractères.

---

### Traitement des requête POST

La méthode *HTTP POST* permet d'envoyer une grande quantité de données au serveur. Elles sont transmises non pas dans l'URL mais dans le corps de la requête. La vue les récupère grâce à l'objet `request`.

Il existe deux méthode de traitement selon l'origine des données :

- Les données proviennent d’une page formulaire (dialogue avec le visiteur du site)

  Une première vue permet de renvoyer le formulaire à afficher. Il utilise une méthode GET. Une seconde vue s'occupe du traitement. Elle n'accepte que les requêtes POST. La vue utilise l’objet l'attribut `form` (dictionnaire des données du formulaire) de l'objet `request`

  *Modification du module `routes.py`*
  ```python
  @app.route("/test-form/")
  def formPOST():
      return render_template("form_POST.html")

  @app.route("/testFormPOST/", methods=["POST"])
  def testFormPOST():
      return render_template("test_form_POST.html", datas=request.form)
  ```

  *Template HTML form_POST.html*
  ```jinja
  {% extends "layout.html" %}
  {% block content %}
  <h1>Requête POST<br/>Formulaire d'envoi des données</h1>
  <form action="http://127.0.0.1:5000/testFormPOST/" method='POST'>
      <p>Data1 : <input type="text" size="10" name="param1"></p>
      <p>Data2 : <input type="text" size="10" name="param2"></p>
      <p>Data3 : <input type="checkbox" name="param3"></p>
      <p><input type="radio" name="param4" value="True" >Vrai<br/>
      <input type="radio" name="param4" value="False">Faux</p>
      <p><input type="submit" value="Envoyer"></p>
  </form>
  {% endblock %}
  ```

  *Template HTML test_form_POST*
  ```jinja
  {% extends "layout.html" %}
  {% block content %}
  <h1>Requête POST<br/>Récupération des données d'un formulaire</h1>
  <ul>
      {% for key in datas %}
      <li>{{ key }} : {{ datas[key] }}</li>
      {% endfor %}    
  </ul>
  {% endblock %}
  ```

- Les données sont un objet JSON transmis hors formulaire (dialogue entre services)
  
  Les données sont envoyées par un client REST (curl, Postman, navigateur avec l'extension <RESTED>, ...). L'entête de requête doit préciser qu'il s'agit d'une application `json` 
  
  ```html
  Content-Type = "application/json"
  ```
  
  La vue utilise  la méthode `get_json()` de l’instance `request`.

  > **_Remarque_** :<br/>_L’objet `request` possède également l’attribut `request.json` qui collecte les données JSON. La méthode `request.get_json()` demeure préférable pour des raisons d’interfaçage avec d’autres extensions **Flask**_.

  ```python
  @app.route("/testJSON/", methods=["POST"])
  def testJsonPost():
      return render_template("test_json_POST.html", datas=request.get_json())
  ```

---
## Les pages d’erreurs

Les erreurs sont inhérentes aux applications web

- Interruption d’une requête provoquée par l’utilisateur
- Envoi de données erronées par l’utilisateur
- Requête inconnue ou incomplète de l’utilisateur
- Saturation suite à un grand nombre de requêtes simultanées
- Rupture de communication avec un serveur ressource
- …

Flask gère les erreurs HTTP et affiche une page d’erreur minimaliste par défaut dépendante du *HTTP status code* de l’erreur. L'erreur est enregistrée dans le fichier *logger* de l’application.

Si on lance notre application et qu'on la teste avec un  navigateur  sur l'URL `http://127.0.0.1:5000/testerror`, on obtient la page ci-dessous

![Erreur 404 default](/img/20221012_13jinja-erreur.jpg)

IL est possible de personnaliser la gestion des erreurs pour le site en implémentant le module `error_handlers.py` à la racine du paquet de l'application. Il faut importer l’application et les fonctionnalités de  flask nécessaires au fonctionnement.

Il faut déclarer la fonction de traitement de l'erreur avec le décorateur `@app.errorhandler(status_code)` pour capturer l’erreur ayant le même `status_code`. Elle définie le traitement à effectuer et retourne le template HTML associé

Il faut importer le module dans le module d’initialisation `__init__.py`.

Module `error_handlers.py`

```python
from flask import render_template
from appli_jinja import app

@app.errorhandler(400)
def bad_request(error):
    return render_template("error_400.html", title="400_Error")

@app.errorhandler(401)
def unauthorized(error):
    return render_template("error_401.html", title="401_Error")

@app.errorhandler(403)
def forbidden(error):
    return render_template("error_403.html", title="403_Error")

@app.errorhandler(404)
def not_found(error):
    return render_template("error_404.html", title="404_Error")
```

Module `__init__.py`

```python
from flask import Flask

app = Flask(__name__)

from appli_jinja import routes 
from appli_jinja import error_handlers
```

Page `404.html`

```jinja
{% extends "layout.html" %}
{% block content %}
    <h1>Bienvenue dans la formation Flask</h1>
    <h2>Erreur 404 - La ressource que vous demandez n'est pas disponible</h2>
{% endblock %}
```

> **_Remarque_** :<br/>_Il est possible de déclencher volontairement une erreur dans une vue à l'aide de la fonction `abort()` du module `flask`._

---
## Les redirections

Lorsque qu'une vue est activée, il est possible de déléguer le traitement de la réponse à une autre vue en lui redirigeant la requête. Pour effectuer une redirection, il faut utiliser la fonction `redirect` du module `flask` dans l'instruction `return` de la vue. On lui passe en argunment l'URL complète de la vue destinataire construite avec `url_for()`.

> **_Exemple_** :<br/>_On crée deux vues, `index()` et `home()`. Lorsque la  vue `home()` est activée par la route `/home`, on redirige le traitement vers la vue `index()`. En testant, avec un navigateur et en inspectant le trafic réseau._

```python
from flask import render_template, redirect, url_for
from appli_jinja import app

@app.route("/")
@app.route("/accueil")
def index():
    return render_template("index.html")

@app.route("/home/")
def home():
    return redirect(url_for("home"))
```

![Redirection](/img/20221012_14jinja-redirect.jpg)

_[ [**<<< Activité 2](part4_jinja2.md)] / [ [**>>> Activité 4](part6_forms.md) ]_
