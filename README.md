# pmb

Dockerfile pour installer [PMB](http://www.sigb.net/)


# Lancement

Il suffit de lancer, par exemple, la commande :
`docker run --name pmb -d -p 8080:80 jperon/pmb`

Pointez alors votre navigateur à l'adresse suivante :
http://localhost:8080/pmb/tables/install.php

Suivez alors les instructions ; pour la base de données mysql, les identifiants sont :
- nom d'utilisateur : `admin` ;
- mot de passe : `admin`.

Pour le reste, référez-vous à la documentation de PMB.
