# Presentation du framework FLASK - **Utiliser FLASK en BUT RT**

## 

Site officiel https://flask.palletsprojects.com/en/2.2.x/ 


Flask est un micro-framework web python (Python v3.7 et versions ultérieures)
- développement rapide et sécurisé de petits sites web
- utilisable pour des applications plus ambitieuses à l'aide d'extensions pour structurer et développer des fonctionnalités particulières.

Une application Flask est une application 100% WSGI (*Web Server Gateway Interface*). Elle possède une organisation simple où elle reçoit directement les requêtes du serveur WSGI et les traite. Selon l’URL transmise, elle déclenche le *Callable* de réponse concerné.  

La réponse peut être une simple chaîne de caractères ou correspondre à des fichiers HTML particuliers, les *templates HTML*.

Les *templates HTML* sont des gabarits qui définissent les structures HTML des pages. Un *template HTML* peut être construit à partir d'un autre par héritage. Il peut aussi intégrer d'autres *templates*. Il peut déclarer des variables pour insérer des données dynamiquement transmises par le *Callable*. Il peut exécuter des structures de contrôle comme des expressions conditionnelles, des boucles, ... . Il peut déclarer des blocs qui seront éditer par les autres *templates* qui l'intègreront. 

Le moteur de template **Jinja2** assure la gestion et le fonctionnement des *templates HTML*.

---

## Créer un projet Flask - Préparer l'environnement

Définir le dossier d'accueil du projet puis y accéder.  A l'intérieur, créer un environnement virtuel Python puis l'activer. Une fois fait, on commence par mettre à jour la base de paquets du gestionnaire `pip`.

```bash
# Création du dossier d'accueil du projet
mkdir prj_flask
cd prj_flask

# Création de l'environnement virtuel python
python3 -m venv prj_env
source prj_env/bin/activate

# Mise à jour de la base du dépôt
python -m pip install -U pip
```

Le principal paquet à installer est le paquet `flask`. Il faut l'installer dans l'environnement virtuel à l'aide du gestionnaire de paquets python `pip`._

```bash
# installer le paquet flask dans l'environnement
pip install flask
```

> **_Remarque_** :<br/>_Le paquet *flask* est installé dans le dossier `acd_env/lib/python3.10/site-packages/` de l'environnement virtuel. Des dépendances ont automatiquement été installées - **click**, **itsdangerous**, **jinja2**, **markupsafe**, **werkzeug**._

---
### Dependances installées

Le rôle respectif de chaque dépendance est décrit dans la documentation au lien [Installation](https://flask.palletsprojects.com/en/2.2.x/installation/#install-flask)

- **Werkzeug** : implémenter du serveur WSGI et gérer le routage d'URL
- **Jinja2** : moteur de template HTML
- **MarkupSafe** : sécuriser les données transmises pour se protéger de certaines attaques
- **ItsDangerous** : signer les données pour assurer leur intégrité et protéger le cookie de session

---
## Créer une première application Flask

Flask permet de créer une application web WSGI dans un seul module python qui intégrera toutes les fonctionnalités. Il suffit d'importer et d'instancier la classe `Flask` en la liant au module courant (argument `__name__`) pour créer l'application (objet `app`). Le lien avec le module facilite l'accès aux ressources utilisées, template HTML, fichiers statiques, ..., et simplifie l'usage de l'espace de nom.

On définit ensuite les fonctions qui retournent les réponses HTML. On les décore avec le décorateur python lié à l'instance de l'application `@app.route()`. Le premier argument du décorateur est l'URL (*Uniform Resource Locator*) associée pour activer la fonction.

> **_Remarque_** :<br/>_Une fonction peut disposer de plusieurs routes. Il est possible de passer des paramètres supplémentaires à la route en les plassant entre chevrons `<...>` dans l'URL et en utilisant le caractère **« / »** comme séparateur. Ils doivent correspondre aux arguments de la fonction décorée. Ces arguments peuvent être typés pour assurer la cohérence des données, en l'absence, le type par défaut est `str`._

Dans le dossier du projet `prj_acd`, créez un dossier une nommée `appli1` pour implémenter  à l'intérieur une première application de même nom. Créez le module `appli1.py` contenant le code suivant. 

```python
from flask import Flask

app = Flask(__name__)

@app.route("/")
@app.route("/accueil")
def index():
    return "<h1>Bienvenue dans la formation Flask</h1>"

@app.route("/emploi/<user>/<job>")
def emploi(user, job):
    return f"<h2>{user} occupe un poste de {job}</h2>"

@app.route("/profil/<string:user>/<int:years>")
def  profil(user, years):
    return f"<h2>{user} a une ancienneté de {years} année(s)</h2>"
```

l'instance de l'application se nomme `app`. On peut la lancer en utilisant, dans une console avec l'environnement virtuel python activé, à partir du script `flask` livré dans le paquet de même nom.

> **_Remarque_** : <br/>_il n'est pas utile de préciser le nom de l'instance s'il elle s'appelle `app` ou `application` ou si vous avez défini une fonction `create_app()` ou `make_app()` (notion de *factory*, fonction dans laquelle l'instance de l'application est créée - permet des instanciations multiples de l'application)._ 

```bash
flask --app appli1 run
```

![Flask start](/img/20221012_07flask_start.jpg)

Le serveur web WSGI est lancé sur la boucle locale et écoute par défaut sur le port 5000. Le message de démarrage du serveur s'affiche dans la console avec l'URL d'accès à utiliser. On constate également que le mode débogage n'est pas activé.


> **_Exercice_** : <br/>_Tester localement avec un navigateur les différents URL possible sur la boucle locale, avec ou sans erreur._


Pour que le serveur soit accessible depuis le réseau, il faut utiliser l'option `--host=0.0.0.0* de la commande `run` lancée avec le script `flask`. dans ce cas, il faut ouvrir le port d'écoute dans le firewall 

```bash
# configuration du firewall
sudo ufw allow 5000/tcp
sudo ufw reload

# script de lancement
flask --app appli1 run --host=0.0.0.0
```

> **_Exercice_** : <br/>_Tester dans votre poste de travail Windows avec un navigateur les différents URL possible sur la boucle locale, avec ou sans erreur._


---
## Utiliser le mode debug

Lorsque l'application est lancée, toute modification nécessitera un redémarrage pour être prise en compte. D'autre part, si une erreur de traitement est détectée, on récupère une page d'erreur serveur.

Il est possible de lancer l'application en mode *debug* pendant la phase de développement. 

```bash
flask --app appli1 --debug run
```

![Flask start debug](/img/20221012_08flask_start-debug.jpg)

Le message précise à présent que le débogage est actif et affiche le code PIN de débogage à utiliser pour authentification lors de l'accès au console python de débogage. Dans ce mode, il n'est pas utile de redémarrer le serveur à chaque modification de l'application, le rechargement est automatique. D'autre part, en cas d'erreur, une page de description de l'erreur est affichée dans le navigateur. 

---

## Structurer une application web Flask

L'organisation la plus simple est basée sur un module unique instanciant l'application avec éventuellement l'utilisation de dossiers particulier pour héberger les modèles HTML ou les fichier statiques.

```bash
./appli1/
├── appli1.py
├── static
│   ├── css
│   │   └── sytles.css
│   └── img
│       └── logo.png
└── templates
    ├── index.html
```

### Organiser  le code

La multiplication des fonctionnalités impose de structurer le code pour une plus grande lisibilité et faciliter la maintenance. La documentation propose des [modèles d'organisations](https://flask.palletsprojects.com/en/2.2.x/patterns/) plus élaborés en séparant le code dans des modules thématiques pour s'appuyer sur les paquets python plutôt que les modules.

> **_Remarque_** :<br/>_Le dossier contenant l'application doit être défini comme un paquet python en ayant à sa racine le module d'initialisation `__init__.py`._ 

On crée dans le paquet des modules spécifiques pour définir :
- `routes.py` 🠖 les vues et leurs routes (aussi nommé `views.py`)
- `models.py` 🠖 les classes et les tables pour mapper les éléments des bases de données
- `forms` 🠖 Les classes de formulaires avec leurs champs

On crée le dossier `templates` pour y stocker les fichiers HTML représentant les gabarits HTML.

On crée le dossier `static` pour y placer les fichiers statiques, eux mêmes organisés dans des sous dossiers thématiques pour les pages de styles, les images, ... .

```bash
./appli2/
├── forms.py
├── __init__.py
├── models.py
├── routes.py
├── static
│   ├── css
│   │   └── styles.css
│   └── img
│       └── logo.png
└── templates
    ├── index.html
    ├── layout.html
    ├── login.html
    └── register.html
```

### Implémentation du module `__init__.py`

C'est dans ce module que l'on instancie la classe Flask pour créer l'application et les objects liés à d'autres fonctionnalités (accès aux bases de données, système d'authentification). On y déclare également également les propriétés de configuration des différentes technologies mises en oeuvre. La dernière instruction charge le module `routes.py` pour assurer le routage d'URL à la réception d’une requête.

```python
from flask import Flask

app = Flask(__name__)

from appli2 import routes 
```

### Implémentation du module `routes.py`

C’est le fichier qui contient les vues décorées par leur(s) route(s). Il contrôle le fonctionnement de l’application. C'est l'application *Flask* qui reçoit les requêtes HTTP transférées par le serveur WSGI. Pour sélectionner la vue qui doit renvoyer la réponse HTTP à partir de l'URL de la requête, le module doit donc importer l’instance de l’application depuis son paquet pour utiliser ses décorateurs traitant les URLs reçues. 

L’instruction `return` de la fonction de vue de la route invoque la fonction `render_template()`, qui prend en premier argument le nom complet du *template HTML*, pour retourner la réponse HTML.

```python
from flask import render_template
from appli2 import app

@app.route("/")
@app.route("/accueil")
def index():
    return render_template("index.html")```
```

> **_Import circulaire_** :<br/>_Nous venons de faire un import circulaire ce qui est contraire au préconisation d'usage (appel du module `routes.py` à l'initialisation du paquet alors que l'on importe l'application `app` créer à l'initialisation dans ce même module). Le site officiel alerte sur ce point mais explique que c'est sans conséquence sur le fonctionnement._
![Circular import](/img/20221012_09falert-circular-import.jpg)<br/> https://flask.palletsprojects.com/en/2.2.x/patterns/packages/


### Implémentation du template HTML `appli2/templates/index.html`

Les templates HTML sont des fichiers contenant des données statiques HTML. Ils peuvent  également contenir des  espaces réservés pour les données dynamiques.

```html
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>Application test M2105</title>
</head>
<body>
    <h1>Bienvenue dans la formation Flask</h1>
</body>
</html>
```

L'instruction de lancement est la même que précédement.

## Alternative avec Flask Blueprints

Pour les applications les plus complexes, il est préférable de modulariser en segmentant par fonctionnalité dans des 
sous-dossiers spécifiques avec leurs propres modules, templates et fichiers statiques. 

*Flask Blueprints* permet de mettre en oeuvre ce type d'organisation en agglomérant des éléments fonctionnels modulaires. Chacun d'eux est représenté par un *Blueprint* spécifique dont la logique doit être enregistré dans un sous-dossier propre. Le module d'initialisation doit déclarer les *Blueprints*.

> Un *Blueprint* de *Flask* peut être assimilé, dans  une certaine mesure, à une *Application Django* pour construire un élément modulaire attaché à une fonctionnalité spécifique du site web. 
