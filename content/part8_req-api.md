# Interroger un API REST - 

## Envoyer des requête HTTP avec le module python `requests`

Le *package python* ``requests`` permet d'envoyer des requêtes HTTP à un serveur et recevoir ses réponses. Il permet de transmettre du contenu comme des entêtes **header**, des données de formulaires et même des fichiers. Il est utilisable directement en mode CLI (*Command Line Interface*) et peut être intégré dans des *scripts* d'automatisation à l'aide d'une clause `import`. Pour l'installer dans l'environnement python, utilisez le gestionnaire de packet python ``pip``

```bash
pip install requests
```

&nbsp;

---
## Les fonctions de requêtes HTTP

Pour envoyer une requête HTTP, il suffit d'importer le module `request` puis utiliser la fonction adaptée à la méthode HTTP concernée.

- Méthode **HTTP GET** → fonction `requests.get(url)` (*consultation*)
- Méthode **HTTP POST** → fonction `requests.post(url)` (*insertion donnée*)
- Méthode **HTTP PUT** → fonction `requests.put(url)` (*modification donnée*)
- Méthode **HTTP DELETE** → fonction `requests.delete(url)` (*suppression donnée*)
- Méthode **HTTP HEAD** → fonction `requests.head(url)` (*consultation sans le contenu*)

&nbsp;

Ces méthodes utilisent toutes une **URL** (*Uniform Resource Locator*) représentant le serveur ou le service web. Elles retournent un objet réponse du type `requests.models.Response`  (*classe définie dans le package*)

&nbsp;

---
## Traiter les éléments de la réponse HTTP

Pour traiter la réponse HTTP du serveur, on utilise les attributs et les méthodes définis dans la classe associée.

- Attribut `.text` → contenu de la réponse
- Méthode `.json()` → données au format json de la réponse
- Attribut `.headers` → dictionnaire des entêtes HTTP de la réponse
- Attribut `.status_code` → Affiche le code statut HTTP de la réponse (200, 401, 404, ... )

&nbsp;

> _**Remarque**<p>La méthode ``requests.get()`` permet de lancer une **requête HTTP GET** pour récupérer une ressource . Elle retourne une instance représentant la réponse HTTP. On peut afficher le résultat en appelant l'attribut ``text`` donnant le contenu **HTML** récupéré.


&nbsp;

[**_Sommaire_** :arrow_heading_up:  ](../README.md)

_[:rewind: **Session - cookie**](part7_session-cookie.md) / [**Base de données** :fast_forward:](part9_bdd.md)_
