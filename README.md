# pmb

Dockerfile pour installer [PMB](http://www.sigb.net/)


# Lancement

Il suffit de lancer, par exemple, la commande :
`docker run --name pmb -v pmb_data:/var/lib/mysql -v pmb_cfg:/etc/pmb -p 8080:80 -d jperon/pmb`

Pointez alors votre navigateur à l'adresse suivante :
http://localhost:8080/pmb/tables/install.php

Suivez alors les instructions ; pour la base de données mysql, les identifiants sont :
- nom d'utilisateur : `admin` ;
- mot de passe : `admin`.

Pour le reste, référez-vous à la documentation de PMB.


# Mise-à-jour

Lorsqu'une nouvelle version est disponible, vous pouvez effectuer la mise-à-jour comme suit :

```
docker stop pmb ; docker rm pmb
docker pull jperon/pmb
docker run --name pmb -v pmb_data:/var/lib/mysql -v pmb_cfg:/etc/pmb -p 8080:80 -d jperon/pmb
```

Vos données et vos paramètres seront conservés (dans la mesure, évidemment, de leur compatibilité
avec la nouvelle version !).
