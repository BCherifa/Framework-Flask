# Infrastructure pédagogique pour la formation - **Utiliser FLASK en BUT RT**

> <p>Les travaux réalisés au cours de cette formation peuvent être effectués sur plateformes Linux, Windows ou MacOS, ayant un accès réseau. Vous pouvez choisir de travailler sur vos propres systèmes (attention néanmoins aux limitations d'accès aux ressources à mettre en œuvre dans la formation), ou utiliser l'infrastructure que nous mettons à votre disposition (option recommandée). Nous proposons ici de travailler dans un environnement complet pour vous affranchir des tâches de configuration liées à l'utilisation d'applications communicantes. L'infrastructure proposée est celle utilisée par les étudiants du département RT de l'IUT Reims Châlons Charleville.</p><p>Un **Grand Merci** à Michel MELCIOR, Laurent HUSSENET, Faustin DAILLE et Jean DELABARRE pour le développement et le maintien opérationnel de cet outil placé au coeur de notre pédagogie.</p>

---

## Accès aux postes de travail

Le poste de travail pour cette formation est hébergé dans le datacenter universitaire de l'IUT Reims Châlons Charleville.

Vous disposez chacun d'un compte sur le domaine *CHALONS* du département RT de l'IUT. Il vous permet d'accéder à ce poste de travail. Il a été créé à partir des informations communiquées lors de l'inscription à la formation (prénom, nom et adresse mail).

Le login est composé de la première lettre de votre prénom suivi de votre nom, sans accent, espace ou caractères spéciaux, l'ensemble en minuscule. 

Vous avez tous du même mot de passe : `acD=2022`

Vous accédez au poste de travail à l'aide d'un navigateur en utilisant l'URL https://view.chalons.univ-reims.fr/.

> Les certificats sont des certificats générés par le département, vous devrez les accepter si vous souhaitez poursuivre vers le poste de travail.

![Sign in view](/img/20221012_01sign_view.jpg)

Une fois connecté au département, vous avez plusieurs machines à votre disposition. Seules les machines **Windows** sont utilisables. Vous utiliserez la VM **Windows 10 - DeMETeRE** avec vos identifiants.  

![poste de travai](/img/20221012_02poste.jpg)

---

## Accès au datacenter pédagogique

Dans un navigateur sur le poste de travail Windows 10, accéder au datacenter pédagique du département à partir de l'URL  https://vcsa.chalons.univ-reims.fr/. Cliquez sur le bouton *LANCER VSPHERE CLIENT (HTLM5)*.

![Accès VCSA](/img/20221012_03vcsa.jpg)

Saisir vos identifiants dans le formulaire de connexion puis valider avec le bouton *CONNEXION*.

![Authentification vSphere](/img/20221012_04sign_vsphere.jpg)

Dans la barre d'icônes en haut du menu latéral, sélectionnez le second item *VM et modèles* puis déroulez les dossiers jusqu'à atteindre *formations_externes*. Ce dossier contient les machines virtuelles Ubuntu préparées spécifiquement pour la formation. Sélectionnez la VM qui vous a été allouée puis avec un clic droit   démarrez-là en utilisant le menu contextuel *Alimentation>Mettre sous tension*. Lorsqu'elle démarre, un triangle vert est affiché sur la VM. L'onglet *Résumé* affiche les caractéristiques de la machine. Vous pouvez observer  l'évolution de la phase de démarrage. En fin de procédure de démarrage, la machine obtient une adresse IP qui s'affiche dans la section *Adresse IP*.

Pour accéder à la VM, utilisez le lien *Lancer Remote Console* puis acceptez d'ouvrir le système dans *VMwareRemote Console*, l'outils est installé dans le poste de travail.

![Console](/img/20221012_05vsphere.jpg)

La console affiche la fenêtre d'ouverture de session Ubuntu pour le compte **iut**, mot de passe *iutchalons*. Il s'agit d'un compte *sudoer* utilisé dans les formations qui vous permet d'obtenir si nécessaire des droits d'administration.

![Console](/img/20221012_06ubuntu_session.jpg)
