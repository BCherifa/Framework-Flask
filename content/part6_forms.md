# Utiliser les formulaires - 

## Présentation de *WTForms* 

https://wtforms.readthedocs.io/en/3.0.x/

*WTForms* est une bibliothèque de validation et de rendu de formulaire qui permet de valider que les données saisies soient conformes. Elle permet également de protéger le site contre les attaques CRSF.
Pour l'utiliser, il faut installer l’extension `flask-wtf` dans l'environnement virtuel python. 

Pour créer un formulaire, on crée la vue chargée d'afficher le formulaire dans le module `routes.py`. 

On crée un module `forms.py` et on déclare les classes des formulaires à afficher. 

- Importer la classe de base `FlaskForm` de `flask_wtf`
- Importer les classes de type de champs de saisie de `wtforms`
- Importer les validateurs de `wtforms.validate`
- Créer les classes des formulaires de l’application

La classe doit hériter de la classe de base `FlaskForm`. Ses attributs sont des instances des classes de champs de saisie de `wtforms`. Pour chaque champ, le premier argument correspon à son label, le second, optionnel, à une liste de validateurs qui correspondent aux restrictions à respecter pour valider l'entrée de l'utilisateur et optionnellement un message d'erreur personnalisé.

> Les classes de champ sont accessibles depuis le dossier de l’extension `acd_env/lib/wtforms/fields/`. Elles sont déclarées dans les modules `core.py`, `html5.py` et `simple.py` 

## Exemple de création d'un formulaire d'adhésion

Les champs du formulaire de saisie 
- Prénom du nouveau membre
- Nom du nouveau membre
- Un mot de passe
- Une confirmation de mot de passe
- Une adresse e-mail valide
- un bouton de soumission du formulaire

La classe `MemberForm`est créer dans le module `forms.py`

```python
from flask_wtf import FlaskForm
from wtforms import StringField, PasswordField,
from wtforms import EmailField, SubmitField
from wtforms.validators import InputRequired, Email, EqualTo

class MemberForm(FlaskForm):
    firstname = StringField('Prénom', [InputRequired()])
    lastname = StringField('Nom', [InputRequired()])
    mail = EmailField('Adresse mail', [InputRequired(), Email()])
    password = PasswordField('Mot de passe', [InputRequired()])
    confirm = PasswordField('Confirmer ', [EqualTo('password')])
    submit = SubmitField('Envoyer')
```

On édite le module `routes.py` pour créer la vue `sign_up()` avec sa route. Une pratique courante consiste à utiliser la même vue pour afficher le formulaire et le traiter. Cela signifie que la route devra accepter les requêtes *HTTP GET* et les requêtes *HTTP POST*. Elle commence par instancier la classe de formulaire pour récupérer les champs saisies. On teste le type de requête *HTTP* reçue à l'aide de l'attribut `method` de l'objet `request` du module `flask`. 

- S'il s'agit une requête *HTTP POST*, on est dans le cas de la réception des données formulaires. On les traite puis on redirige vers la page suivante.
- S'il s'agit d'une requête *HTTP GET* on est dans une demande d'affichage du formulaire, on revoit la page de formulaire pour l'afficher.

```python
@app.route("/sign-up/", methods=['GET', 'POST'])
def sign_up():
    memberForm = MemberForm()
    if request.method == 'POST':
        with open("member.json", 'a+') as fic:
            fic.write(
                {"firstname":memberForm.firstname.data,
                 "lastname":memberForm.lastname.data,
                 "mail":memberForm.mail.data,
                 "password":memberForm.password.data}
            )
        return redirect('index')            
    return render_template('sign_up.html', form=memberForm)
```

```jinja
{% extends 'layout.html' %}
{% block content %}
<div id="info" class="zone_info"><h1>Saisie d'un nouveau membre</h1>
<div id="affiche"><form method="POST">{{ form.csrf_token }}
<table><tr><td><label for="firstname">Prénom : </label></td>
           <td>{{ form.firstname }}</td></tr>
       <tr><td><label for="lastname">Nom : </label></td>
           <td>{{ form.lastname }}</td></tr>
       <tr><td><label for="mail">Adresse mail : </label></td>
           <td>{{ form.mail }}</td></tr>
       <tr><td><label for="password">Mot de passe : </label></td>
           <td>{{ form.password }}</td></tr>
       <tr><td><label for="confirm">Confirmer : </label></td>
           <td>{{ form.confirm }}</td></tr></table>
<p>Pour enregistrer, cliquez sur le bouton  {{ form.submit }}</p>
</form></div>
{% endblock content %}
```

> **_Remarque_** :<br/>_La protection CSRF liée aux formulaires WTForms impose de créer un variable de configuration `SECRET_KEY` dans l'application pour enregistre la clé de signature._

```bash
# Génération de la clé secrète de signature
python -c 'import secrets; print(secrets.token_hex())'
```
> **_Exemple de clé généré_**<br/> _`5eed9b976f6d5c80fb8bb74b1bcff9f01218a864d0f2dd76143356d3cc36eda8`_

```python
from flask import Flask

app = Flask(__name__)
app.config["SECRET_KEY"] = b'5eed9b976f6d5c80fb8bb74b1bcff9f01218a864d0f2dd76143356d3cc36eda8'

from . import routes 
from . import error_handlers
```

_[ [**<<< Activité 3](part5_HTTP-redirect-error.md)] / [ [**>>> Activité 5](part7_context.md) ]_
