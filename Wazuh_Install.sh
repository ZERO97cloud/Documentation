#!/bin/bash

# Installer les paquets nécessaires
if command -v apt-get &> /dev/null; then
    sudo apt-get update
    sudo apt-get install -y curl git docker-compose
elif command -v yum &> /dev/null; then
    sudo yum install -y curl git docker-compose
else
    echo "Gestionnaire de paquets non supporté. Veuillez installer curl, git et docker-compose manuellement."
    exit 1
fi

# URL de la page des releases GitHub
RELEASES_URL="https://github.com/wazuh/wazuh-docker/releases"

# Extraction de la dernière version stable (non alpha, non beta, non rc)
latest_version=$(curl -sL "$RELEASES_URL" | \
    grep -oP 'href="/wazuh/wazuh-docker/releases/tag/v[0-9]+\.[0-9]+\.[0-9]+"' | \
    sed -e 's/href="\/wazuh\/wazuh-docker\/releases\/tag\///' -e 's/"//' | \
    grep -v -e 'alpha' -e 'beta' -e 'rc' | \
    sort -V | tail -n 1)

echo "Dernière version stable wazuh-docker : $latest_version"

# Cloner le dépôt git avec la bonne version
git clone https://github.com/wazuh/wazuh-docker.git -b "$latest_version"
cd wazuh-docker/single-node || { echo "Dossier introuvable"; exit 1; }

# Lancer la commande docker-compose pour generate-indexer-certs.yml
docker-compose -f generate-indexer-certs.yml up

# Une fois terminé, lancer la commande docker-compose classique
docker-compose -f docker-compose.yml up
