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

> _**Remarque**<p>La méthode ``requests.get()`` permet de lancer une **requête HTTP GET** pour récupérer une ressource . Elle retourne une instance représentant la réponse HTTP. On peut afficher le résultat en appelant l'attribut ``text`` donnant le contenu **HTML** récupéré.<p>Le département Réseaux et Télécommunication de l'IUT publie un site à l'URL http://webbut.chalons.univ-reims.fr/. On donne le script ``test_get.py``.</p>_


&nbsp;

*Code du script `test_get.py`*
```python
import requests

if __name__ == "__main__":
    url = "http://webbut.chalons.univ-reims.fr/"
    resp = requests.get(url)
    print(resp.text)
```

&nbsp;

---
## Cas d'une réponse au format JSON

Les API REST sont des services web qui retournent leurs réponses au format HTTP. 

La méthode `.json()` de la réponse traite les données JSON retournées. La méthode ``requests.get`` est utilisable pour récupérer les informations sur l'ensemble des ressources. On peut l'utiliser aussi bien avec une URL standard qu'avec une URL formée.


&nbsp;

---
## Envoyer des données au serveur avec HTTP GET `requests.get()`
---

Dans l'exemple précédent, on utilise la fonction `requests.get()` pour intérroger l'API en transmettant en paramètre la référence souhaitée en dernier élément (*paramètre*) de l'URL. 

L'exemple ci-dessous présente trois cas d'utilisation avec différents format d'URL 

&nbsp;

*Code du script `test_getdata.py`*

```python
import requests

if __name__ == "__main__":
    # Exemple avec une URL standard avec un argument
    url1 = "http://apibut.chalons.univ-reims.fr/api/saes?ref_sae=SAE23"
    resp1 = requests.get(url1)
    print("\n###### Exemple avec URL standard ######")
    print(resp1.json())  

    # Exemple avec passage d'arguments dans la fonction get()
    url2 = "http://apibut.chalons.univ-reims.fr/api/saes"
    resp2 = requests.get(url2, params={'ref_sae':'SAE23'})
    print("\n###### Exemple avec passage d'arguments dans la fonction get() ######")
    print(resp2.json())  

    # Exemple avec une URL formé avec argument
    url3 = "http://apibut.chalons.univ-reims.fr/api/saes/SAE23"
    resp3 = requests.get(url3)
    print("\n###### Exemple avec URL formée ######")
    print(resp3.json()) 
```

&nbsp;

---
## Envoyer des données avec HTTP POST `requests.post()`

Les formulaires web définissent le type de requête HTTP utilisé pour envoyer au serveur les valeurs renseignées dans leurs champs par leur attribut `method`. Si on utilise une requête *GET*, les données sont ajouté directement à l'URL. La taille maximale d'une URL est de 2083 caractères. Le protocole sitemap utilisé pour le référencement des sites limite même la taille d'une URL à 2048 caractères. Cette limite peut être trop contraignante pour l'envoi des données d'un formulaire. Les formulaires web utilisent préférenciellement la méthode *POST* qui transmet les données dans l'entête et non dans l'URL s'affranchissant ainsi de la contrainte de taille.

Dans un script python, la fonction `requests.post()` permet d'envoyer une requête *HTTP POST* au serveur. Pour envoyer les données, on lui fournit en premier argument l'URL de la ressource puis en second argument, on utilise l'attribut nommé `data` ou l'attribut nommé `json`, et on l'initialise avec un dictionnaire où chaque couple *clé/valeur* représente respectivement un champ formulaire et sa valeur. Dans le cas d'une API REST, les échanges utilisant le format **JSON**, on utilise la méthode POST avec l'attribut nommé `json`.

L'API Réseaux et Télécommunications présente un EndPoint pour enregistrer un utilisateur. En consultant l'API, on voit la structure des données à envoyer pour effectuer un enregistrement.


En observant le schéma des propriétés d'un utilisateur, on construit le dictionnaire des données que l'on transmet à la fonction ``requests.post()`` en second attribut nommé **json**.

&nbsp;

*Code du script test_postdata.py
```python
import requests

if __name__ == "__main__":
    url = "http://apibut.chalons.univ-reims.fr/api/users"
    new_user = {
            "login": "mmelcior",
            "firstname": "Michel",
            "lastname": "Melcior",
            "mdp": "iutchalons",
            "role": "user"
            }
    
    # Vérifier que l'utilisateur n'existe pas avant enregistrement
    resp = requests.get(url + "/" + new_user.get('login'))
    if resp.json() == {}:
        resp1 = requests.post(url, json=new_user) # Enregistrement
        print(resp1.json())
    else:
        print(resp.json())    # Affiche l'utilisateur existant
```

&nbsp;

On teste le script ci-dessus. Il vérifie si le compte utilisateur n'existe pas avant de l'enregistrer. S'il existe, il se content de l'afficher. Au premier lancement du script, on obtient une réponse JSON de confirmation de l'enregistrement. A la seconde exécution, on constate que l'utilisateur existe et on l'affiche. 


&nbsp;

---
## Utiliser les sessions HTTP `resquests.Session`

Lorsque l'on doit exécuter plusieurs requêtes vers un même site, il peut être nécessaire d'utiliser des session pour assurer la persistance d'informations de connexion. On crée. Les API étant **STATELESS** (*pas de mémorisation de données de connexion*), on n'utilise pas de session. Par contre, les sites web avec authentification nécessitent une gestion de session pour la suite de la consultation.

&nbsp;

> _**Remarque**<p>D'après http://fr.python-requests.org/en/latest/user/advanced.html :</p><p>L’objet Session vous permet de conserver des paramètres entre plusieurs requêtes. Il permet également de conserver les cookies entre toutes les requêtes de la même instance Session.</p><p>Un objet Session a toutes les méthodes de l’API Requests principale. Les Sessions peuvent aussi être utilisées pour fournir des valeurs par défaut aux requêtes.</p>_

&nbsp;

Pour utiliser une session, il faut créer une instance de session avec la classe ``resquests.Session``. Dans le contexte de la session, on lance une première requête HTTP à l'aide de sa méthode ``get()`` pour l'initialiser.

&nbsp;

*Code du script `test_session.py`
```python
import requests

if __name__ == "__main__":
    url = https://www.iut-rcc.fr/
    with requests.Session() as mysession:
        resp = mysession.get(url)
        print(resp.text)
        # On utilise les fonctions get(), post(), ... à partir de mysession
```

&nbsp;

[**_Sommaire_** :arrow_heading_up:  ](../README.md)

_[:rewind: **Session - cookie**](part7_session-cookie.md) / [**Base de données** :fast_forward:](part9_bdd.md)_
