# Gérer les sessions et les cookies - **Utiliser FLASK en BUT RT**

## Les session avec Flask

Flask gère les session coté client dans des cookies de session. Les cookies sont signés pour les protéger des éventuelles modifications. Comme pour la protection apportée à *WTForms*, il faut générer une clé de signature enregistrée dans la *config* de l’application déclarée dans le `module  __init__.py` (clé généralement commune à toutes les fonctionnalités activées).

```bash
# Génération de la clé secrète de signature
python -c 'import secrets; print(secrets.token_hex())'
```
> **_Exemple de clé généré_**<br/> _`5eed9b976f6d5c80fb8bb74b1bcff9f01218a864d0f2dd76143356d3cc36eda8`_

*Module `__init__.py`*
```python
from flask import Flask

app = Flask(__name__)
app.config["SECRET_KEY"] = b'5eed9b976f6d5c80fb8bb74b1bcff9f01218a864d0f2dd76143356d3cc36eda8'

from . import routes 
from . import error_handlers
```

Dans le module `routes.py`, on utilise l’objet `session` de flask. Il fonctionne comme un dictionnaire Python et conserve une trace des modifications. Dans la vue, on ajoute les clés des données dans la session `session["key"] = value`.
Pour vérifier dans un navigateur, on invoque l’URL de la vue
La réponse est affiché et un cookie de session est stocké dans le navigateur (utiliser les outils d'inspection du navigateur. Il contient les données définies dans les clés de session. Le cookie est crypté et nécessite la clé secrète pour être lu.

Exemple avec l'ajout dans la barre de menu d'entête d'un bouton `Login/Logout` qui affiche les données de la session avec un affichage conditionnelle des liens de *connexion/déconnexion*.


*template HTML `nav.html`*

```jinja
<nav><ul>
    <li><a href="{{ url_for('home') }}">Home</a></li>
    <li><a href="{{ url_for('getTeachers') }}">Teachers</a></li>
    {% if session['user'] %}
    <li><span style="font-size: small;font-style: italic;">{{ session['user']['username'] }}</span></li>
    <li><a href="{{ url_for('sign_out') }}">
      <button class="orange">Logout</button></a></li>
    {% else %}
    <li><a href="{{ url_for('sign_in') }}">
      <button class="vert">Login</button></a></li>
      {% endif %}
  </ul>
</nav>
```

On crée la vue `sign_in` pour traiter le clic que le bouton de *Login*. La vue vérifie récupère les données formuaires et les engeristre dans la session. un crée également la vue `sign_out` pour la route `/logout`. Elle supprime les données de sessionà l'aide de la fonction `session.clear()` puis redirige vers la page d'accuil du site.


*Ajout des vue dans le module `routes.py`*
```python
@app.route("/sign-in", methods=['GET', 'POST'])
def sign_in():
    if request.method == 'POST':
        session['user'] = {
            "username": request.form['login']
            }
        return redirect(url_for("index"))
    elif request.method == 'POST':
        flash("Des champs ne sont pas saisis !", 'error')
    return render_template("sign_in.html")

@app.route("/logout")
def sign_out():
    session.clear()
    return redirect(url_for("index"))
```

*template HTML `sign_in.html`*

```jinja
{% extends 'layout.html' %}
{% block content %}
<div class="login-form">
    <h2>Se connecter</h2>
    {% with messages = get_flashed_messages() %}
    {% if messages %}
        {% for message in messages %}
            <div class="flash_message">{{ message }}</div>
        {% endfor %}
    {% endif %}
    <form action="#" method="POST">
        <p><label for="login">Identifiant</label><br/>
        <input type="text" id="login" name="login" size="15" /></p>
        <p><label for="password">Mot de passe</label><br/>
        <input type="password" id="password" name="password" size="15" /></p>
        <input type="hidden" id="sessionid" name="sessionid" value="{{ session['uid'] }}" />
        <p style="text-align: center;"><button type="submit">Envoyer</button></p>
        <p><a href="{{ url_for('sign_up') }}">Créer un nouveau compte</a></p>
    </form>
    {% endwith %}
</div>
{% endblock %}
```
