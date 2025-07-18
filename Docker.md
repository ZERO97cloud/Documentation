# Guide des Commandes Docker

Ce guide présente les commandes Docker les plus utiles organisées par catégorie.

## Table des matières
- [Gestion des images](#gestion-des-images)
- [Gestion des conteneurs](#gestion-des-conteneurs)
- [Interaction avec les conteneurs](#interaction-avec-les-conteneurs)
- [Docker Compose](#docker-compose)
- [Gestion des volumes](#gestion-des-volumes)
- [Gestion des réseaux](#gestion-des-réseaux)
- [Maintenance et nettoyage](#maintenance-et-nettoyage)
- [Commandes d'inspection](#commandes-dinspection)
- [Registres Docker](#registres-docker)
- [Sauvegarde et restauration](#sauvegarde-et-restauration)
- [Sécurité](#sécurité)
- [Surveillance et monitoring](#surveillance-et-monitoring)

## Gestion des images

### Télécharger une image
```bash
docker pull [image_name]:[tag]
docker pull ubuntu:20.04
docker pull nginx:latest
```

### Lister les images
```bash
docker images
docker image ls
docker images --filter "dangling=true"  # images orphelines
docker images --format "table {{.Repository}}\t{{.Tag}}\t{{.Size}}"
```

### Construire une image
```bash
docker build -t [nom_image] .
docker build -t [nom_image] -f [Dockerfile] .
docker build --no-cache -t [nom_image] .  # sans cache
docker build --build-arg [ARG=value] -t [nom_image] .
```

### Supprimer une image
```bash
docker rmi [image_id]
docker image rm [image_name]
docker rmi $(docker images -q)  # supprimer toutes les images
docker rmi $(docker images -f "dangling=true" -q)  # supprimer les images orphelines
```

### Historique et informations d'une image
```bash
docker history [image_name]
docker image inspect [image_name]
```

## Gestion des conteneurs

### Lancer un conteneur
```bash
docker run [options] [image]
docker run -d [image]  # en arrière-plan (detached)
docker run -it [image]  # interactif avec terminal
docker run -p [port_host]:[port_container] [image]  # mapping de port
docker run --name [nom_conteneur] [image]  # nommer le conteneur
docker run -v [volume_host]:[volume_container] [image]  # monter un volume
docker run --rm [image]  # supprimer automatiquement après arrêt
docker run -e [VARIABLE=valeur] [image]  # définir une variable d'environnement
docker run --memory=[limite] [image]  # limiter la mémoire
docker run --cpus=[nombre] [image]  # limiter les CPUs
docker run --restart=always [image]  # redémarrage automatique
```

### Lister les conteneurs
```bash
docker ps  # conteneurs actifs
docker ps -a  # tous les conteneurs
docker ps -l  # dernier conteneur créé
docker ps --filter "status=exited"  # conteneurs arrêtés
docker ps --format "table {{.Names}}\t{{.Status}}\t{{.Ports}}"
```

### Contrôler les conteneurs
```bash
docker stop [container_id]
docker start [container_id]
docker restart [container_id]
docker pause [container_id]  # mettre en pause
docker unpause [container_id]  # reprendre
docker kill [container_id]  # arrêt forcé
```

### Supprimer un conteneur
```bash
docker rm [container_id]
docker rm -f [container_id]  # forcer la suppression
docker rm $(docker ps -a -q)  # supprimer tous les conteneurs
docker container prune  # supprimer les conteneurs arrêtés
```

## Interaction avec les conteneurs

### Exécuter des commandes
```bash
docker exec -it [container_id] bash
docker exec -it [container_id] sh
docker exec -it [container_id] /bin/bash
docker exec -d [container_id] [commande]  # exécuter en arrière-plan
docker exec --user [user] -it [container_id] bash
```

### Attacher/Détacher
```bash
docker attach [container_id]  # s'attacher au conteneur
# Ctrl+P puis Ctrl+Q pour se détacher sans arrêter
```

### Voir les logs
```bash
docker logs [container_id]
docker logs -f [container_id]  # suivre les logs en temps réel
docker logs --tail [nombre] [container_id]  # dernières lignes
docker logs --since [timestamp] [container_id]
docker logs --until [timestamp] [container_id]
```

### Copier des fichiers
```bash
docker cp [container_id]:[path] [local_path]
docker cp [local_path] [container_id]:[path]
docker cp [container_id]:[path] - | tar -tv  # lister le contenu
```

## Docker Compose

### Gestion des services
```bash
docker-compose up
docker-compose up -d  # en arrière-plan
docker-compose up --build  # reconstruire les images
docker-compose up --scale [service=nombre]  # scaler un service
docker-compose down  # arrêter et supprimer
docker-compose stop  # arrêter les services
docker-compose start  # démarrer les services
docker-compose restart  # redémarrer les services
```

### Informations sur les services
```bash
docker-compose ps
docker-compose logs
docker-compose logs -f [service]
docker-compose exec [service] bash
docker-compose run [service] [commande]
```

### Gestion avancée
```bash
docker-compose pull  # télécharger les images
docker-compose build  # construire les images
docker-compose config  # valider la configuration
docker-compose top  # voir les processus
```

## Gestion des volumes

### Créer et gérer des volumes
```bash
docker volume create [nom_volume]
docker volume create --driver [driver] [nom_volume]
docker volume ls
docker volume inspect [nom_volume]
docker volume rm [nom_volume]
docker volume prune  # supprimer les volumes inutilisés
```

### Utiliser des volumes
```bash
docker run -v [nom_volume]:[path_container] [image]
docker run -v [path_host]:[path_container] [image]  # bind mount
docker run --mount source=[volume],target=[path] [image]
```

## Gestion des réseaux

### Créer et gérer des réseaux
```bash
docker network create [nom_reseau]
docker network create --driver [driver] [nom_reseau]
docker network ls
docker network inspect [nom_reseau]
docker network rm [nom_reseau]
docker network prune  # supprimer les réseaux inutilisés
```

### Connecter des conteneurs
```bash
docker network connect [reseau] [conteneur]
docker network disconnect [reseau] [conteneur]
docker run --network [reseau] [image]
```

## Maintenance et nettoyage

### Nettoyage général
```bash
docker system prune  # nettoyer tout (conteneurs, réseaux, images)
docker system prune -a  # nettoyer tout incluant les images utilisées
docker system prune --volumes  # inclure les volumes
docker container prune  # nettoyer les conteneurs arrêtés
docker image prune  # nettoyer les images non utilisées
docker image prune -a  # nettoyer toutes les images non utilisées
docker volume prune  # nettoyer les volumes
docker network prune  # nettoyer les réseaux
```

### Informations sur l'utilisation
```bash
docker system df  # utilisation de l'espace disque
docker system df -v  # version détaillée
docker system info  # informations système
docker version  # version Docker
```

## Commandes d'inspection

### Inspection détaillée
```bash
docker inspect [container_id/image_id]
docker inspect --format='{{.NetworkSettings.IPAddress}}' [container_id]
docker inspect --format='{{.State.Status}}' [container_id]
```

### Surveillance en temps réel
```bash
docker stats  # statistiques de tous les conteneurs
docker stats [container_id]  # statistiques d'un conteneur
docker stats --no-stream  # statistiques instantanées
docker top [container_id]  # processus dans le conteneur
docker port [container_id]  # ports mappés
```

### Événements
```bash
docker events  # événements en temps réel
docker events --since [timestamp]
docker events --filter container=[container_id]
```

## Registres Docker

### Authentification
```bash
docker login  # se connecter au Docker Hub
docker login [registry_url]  # se connecter à un registre privé
docker logout  # se déconnecter
```

### Gestion des images dans les registres
```bash
docker push [image_name]:[tag]  # pousser une image
docker pull [image_name]:[tag]  # télécharger une image
docker search [term]  # rechercher des images
docker tag [image_id] [new_name]:[tag]  # taguer une image
```

## Sauvegarde et restauration

### Export/Import de conteneurs
```bash
docker export [container_id] > [fichier.tar]  # exporter un conteneur
docker import [fichier.tar] [nom_image]  # importer un conteneur
```

### Save/Load d'images
```bash
docker save [image_name] > [fichier.tar]  # sauvegarder une image
docker load < [fichier.tar]  # charger une image
docker save [image_name] | gzip > [fichier.tar.gz]  # compresser
```

### Commit de conteneurs
```bash
docker commit [container_id] [nom_image]:[tag]  # créer une image depuis un conteneur
docker commit -m "message" [container_id] [nom_image]:[tag]
```

## Sécurité

### Scan de sécurité
```bash
docker scan [image_name]  # scanner les vulnérabilités
docker trust inspect [image_name]  # vérifier la signature
```

### Gestion des secrets (Docker Swarm)
```bash
docker secret create [nom_secret] [fichier]
docker secret ls
docker secret inspect [nom_secret]
docker secret rm [nom_secret]
```

## Surveillance et monitoring

### Monitoring avancé
```bash
docker diff [container_id]  # changements dans le système de fichiers
docker wait [container_id]  # attendre qu'un conteneur se termine
docker update --memory [limite] [container_id]  # mettre à jour les limites
```

### Santé des conteneurs
```bash
docker run --health-cmd="[commande]" [image]  # définir un health check
docker run --health-interval=30s [image]  # intervalle de vérification
```

## Exemples pratiques

### Exemple complet avec WordPress
```bash
# Créer un réseau
docker network create wordpress-net

# Lancer MySQL
docker run -d --name mysql-wp \
  --network wordpress-net \
  -e MYSQL_ROOT_PASSWORD=rootpass \
  -e MYSQL_DATABASE=wordpress \
  -e MYSQL_USER=wpuser \
  -e MYSQL_PASSWORD=wppass \
  mysql:5.7

# Lancer WordPress
docker run -d --name wordpress \
  --network wordpress-net \
  -p 8080:80 \
  -e WORDPRESS_DB_HOST=mysql-wp \
  -e WORDPRESS_DB_NAME=wordpress \
  -e WORDPRESS_DB_USER=wpuser \
  -e WORDPRESS_DB_PASSWORD=wppass \
  wordpress:latest
```

### Exemple avec Docker Compose
```yaml
version: '3.8'
services:
  web:
    image: nginx:alpine
    ports:
      - "80:80"
    volumes:
      - ./html:/usr/share/nginx/html
    depends_on:
      - app
  
  app:
    image: node:alpine
    working_dir: /app
    volumes:
      - ./app:/app
    command: npm start
```

## Conseils et bonnes pratiques

1. **Utilisez des tags spécifiques** plutôt que `latest` en production
2. **Nettoyez régulièrement** avec `docker system prune`
3. **Utilisez des fichiers .dockerignore** pour optimiser le build
4. **Limitez les ressources** avec `--memory` et `--cpus`
5. **Utilisez des volumes** pour la persistance des données
6. **Sécurisez vos images** avec `docker scan`
7. **Utilisez des utilisateurs non-root** dans vos conteneurs
8. **Optimisez vos Dockerfile** avec des layers cachés

## Raccourcis utiles

```bash
# Supprimer tous les conteneurs arrêtés
docker rm $(docker ps -a -q --filter "status=exited")

# Supprimer toutes les images orphelines
docker rmi $(docker images -q --filter "dangling=true")

# Arrêter tous les conteneurs
docker stop $(docker ps -q)

# Obtenir l'IP d'un conteneur
docker inspect -f '{{range .NetworkSettings.Networks}}{{.IPAddress}}{{end}}' [container_id]

# Suivre les logs de tous les conteneurs
docker-compose logs -f

# Entrer dans un conteneur en cours d'exécution
docker exec -it $(docker ps -q --filter "name=myapp") bash
```

---

*Ce guide couvre les commandes Docker les plus courantes. Pour plus d'informations, consultez la [documentation officielle Docker](https://docs.docker.com/).*