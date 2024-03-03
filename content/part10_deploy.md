# Déployer une application web Flask 

## Présentation

&nbsp;

### **Préparer la structure de fichiers de l'application et l'initialiser**

Pour développer l'application vous devez :

1. Créer un dossier d'accueil spécifique pour projet web, `prj_acd`.

1. Créer à la racine de ce dossier un environnement virtuel python puis l'activer

1. Mettre à jour la base des dépôts des paquets python de `pip`

1. A l'aide de la commande `pip`, installer l'application python `gunicorn` dans l'environnement virtuel (utilisée uniquement lors du déploiement pour la mise en production) et les paquets nécessaires au projet (`flask`, `flask-wtf`, `flask-sqlalchemy`, `requests`)

1. Créer dans le dossier d'accueil du projet le dossier spécifique qui correspondra au paquet python de l'application web, `site_web`. 

1. Créer à l'intérieur le module python `__init__.py`. l'Editer et déclarer l'instance `Flask` qui représente l'application ainsi que l'instance `SQLAlchemy` de connexion à la base de données, puis les initialiser en ajoutant les données de configuration.

&nbsp;

*Code du module `__init__.py`*

```python
from flask import Flask
from flask_sqlalchemy import SQLAlchemy
from sqlalchemy import MetaData

app = Flask(__name__)

app.config['SQLALCHEMY_DATABASE_URI'] = 'postgresql://acd2022:acd2022@10.59.80.90:2022/collectivities'

app.config["SECRET_KEY"] = b'5eed9b976f6d5c80fb8bb74b1bcff9f01218a864d0f2dd76143356d3cc36eda8'
db = SQLAlchemy()
db.init_app(app)


metadata = MetaData(bind=db)

from site_web import routes
```

&nbsp;

### **Implémenter le code des modules et des fichiers de l'application**

1. Créer et éditez le module `site_web/forms.py` ; implémenter le code des classes formulaires

1. Créer et éditez le module `site_web/routes.py` ; implémenter le code des vues de l'application

1. Créer le dossier `site_web/templates` et implémenter les templates HTML de l'application

1. Créer les dossier `site_web/static`, `site_web/static/css` et ``site_web/static/img``.

1. Copier dans le dossier `site_web/static/img` les images utilisées par les templates HTML

1. Copier dans le dossier `site_web/static/css` les pages de styles CSS utilisées par les templates HTML

&nbsp;

---
## Déployer l'application en production sous Ubuntu

&nbsp;

### **Créer le service système de lancement de l'application web**

Pour servir l'application web, il faut utiliser un démon qui lance un serveur WSGI. Il faut créer le script de lancement du service système correspondant.

Dans une distribution Ubuntu, ces scripts se trouvent dans le dossier `/etc/systemd/system/`.

&nbsp;

*Fichier `/etc/systemd/system/site_web.service`*

```bash
[Unit]
Description=Gunicorn instance to serve MyApp
After=network.target

[Service]
User=bruno
Group=www-data
WorkingDirectory=/home/iut/prj_acd/
Environment="PATH=/home/iut/prj_acd/webenv/bin"
ExecStart=/home/iut/prj_acd/site_web/bin/gunicorn --workers 3 --bind unix:/home/iut/prj_acd/siteweb.sock -m 007 wsgi_web:app

[Install]
WantedBy=multi-user.target
```

&nbsp;

> _**Important** :<p>_La section `[Unit]` déclare les métadonnées du service, la propriété `After` déclare que le service est démarré après l'activation réseau par le système d'initialisation.</p><p>La section `[Service]` déclare l'utilisateur (`User`) et le groupe (`Group`) propriétaire du service - le groupe `www-data` choisi est celui du service **Nginx** utilisé comme serveur web proxy de l'**application WSGI**. Dans cette section, on déclare également le répertoire d'accueil de l'application (`WorkingDirectory`) et la variable d'environnement d'accès à l'interpréteur python de l'application (`Environment`). Elle détermine enfin dans la propriété `ExecStart` le processus lancé au démarrage. Il s'agit de l'application **Gunicorn** installer dans l'environnement virtuel python. L'argument `--bind` déclare le fichier `/home/iut/prj_acd/siteweb.sock` du **socket Unix** utilisé pour recevoir les requêtes et y répondre. Le **umask** définit par l'argument `-m 007` déclare un accès complet au propriétaire et au groupe et rien aux autres. L'option `--workers 3` déclare le nombre de processus de travail lancés. Le dernier argument `wsgi_web:app` correspond au module python initialisant l'instance de l'application `Flask`. On donne son code ci-après.</p><p>La section ``[Install]`` déclare à ``systemd`` que le service est actif au niveau de démarrage **multi-utilisateurs réseau**.</p>_

&nbsp;

*Code du module `prj_acd/wsgi_web.py`*

```python
from site_web import app
```

&nbsp;

Créer le fichier `/etc/systemd/system/site_web.service` avec le code ci-dessus. Lancez le service puis configurer son démarrage automatique au *boot* de la machine

```bash
sudo systemctl start site_web.service
sudo systemctl enable site_web.service
```

&nbsp;

### **Créer le virtual server Nginx de l'application web** 

Le serveur **Nginx** est utilisé comme **proxy** pour reccueillir les requêtes HTTP et les transmettre à **Gunicorn** via son socket Unix. On utilise les ports pour discriminer les différents serveurs actifs. Le fichier de configuration du serveur virtuel est définit dans le dossier `/etc/nginx/sites-available`.

&nbsp;

*Fichier de configuration du serveur virtuel `/etc/nginx/sites-available/site_web`*

```bash

server {
    listen 80;
    server_name 10.59.68.129;
    location / {
            include proxy_params;
            proxy_pass http://unix:/home/iut/prj_acd/siteweb.sock;
    }
}
```

&nbsp;

Créer le fichier `/etc/nginx/sites-available/webcelcat` avec le code ci-dessus. 

Créer un lien symbolique vers ce fichier dans le dossier `/etc/nginx/sites-enabled/` pour l'activer.  

Relancer le service **Nginx**

```bash
sudo ln -s /etc/nginx/sites-available/webcelcat /etc/nginx/sites-enabled/
sudo systemctl restart webcelcat
```

&nbsp;

[**_Sommaire_** :arrow_heading_up:  ](../README.md)

_[:rewind: **Base de données**](part9_bdd.md)_
