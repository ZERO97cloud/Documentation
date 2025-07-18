# Guide des Commandes Vagrant

Ce guide présente les commandes Vagrant les plus utiles pour gérer des environnements de développement virtualisés.

## Table des matières
- [Installation et configuration](#installation-et-configuration)
- [Gestion des machines virtuelles](#gestion-des-machines-virtuelles)
- [Gestion des boxes](#gestion-des-boxes)
- [Configuration et Vagrantfile](#configuration-et-vagrantfile)
- [Réseaux et connectivité](#réseaux-et-connectivité)
- [Partage de fichiers](#partage-de-fichiers)
- [Provisioning](#provisioning)
- [Plugins](#plugins)
- [Snapshots](#snapshots)
- [Multi-machines](#multi-machines)
- [Débogage et maintenance](#débogage-et-maintenance)
- [Intégrations](#intégrations)
- [Exemples pratiques](#exemples-pratiques)

## Installation et configuration

### Installation
```bash
# Vérifier la version
vagrant version

# Vérifier l'installation
vagrant --help

# Mettre à jour Vagrant
vagrant plugin update

# Vérifier les prérequis
vagrant validate
```

### Configuration globale
```bash
# Afficher la configuration globale
vagrant global-status

# Nettoyer le cache global
vagrant global-status --prune

# Définir des variables d'environnement
export VAGRANT_DEFAULT_PROVIDER=virtualbox
export VAGRANT_CWD=/path/to/project
```

## Gestion des machines virtuelles

### Cycle de vie basique
```bash
# Initialiser un nouveau projet
vagrant init [box_name]
vagrant init ubuntu/focal64

# Démarrer une machine
vagrant up
vagrant up --provider=virtualbox
vagrant up --provision  # avec provisioning
vagrant up --no-provision  # sans provisioning

# Arrêter une machine
vagrant halt
vagrant halt --force  # arrêt forcé

# Redémarrer une machine
vagrant reload
vagrant reload --provision  # avec provisioning

# Suspendre/reprendre
vagrant suspend  # mettre en veille
vagrant resume   # reprendre

# Détruire une machine
vagrant destroy
vagrant destroy --force  # sans confirmation
```

### Gestion multi-machines
```bash
# Gérer une machine spécifique
vagrant up [machine_name]
vagrant halt [machine_name]
vagrant ssh [machine_name]
vagrant destroy [machine_name]

# Gérer toutes les machines
vagrant up --parallel  # démarrer en parallèle
vagrant halt --parallel  # arrêter en parallèle
```

### Statut et informations
```bash
# Voir le statut
vagrant status
vagrant status [machine_name]

# Statut global (toutes les machines)
vagrant global-status
vagrant global-status --prune

# Informations détaillées
vagrant ssh-config
vagrant ssh-config [machine_name]

# Port forwarding
vagrant port
vagrant port [machine_name]
```

## Gestion des boxes

### Télécharger et gérer des boxes
```bash
# Lister les boxes installées
vagrant box list

# Ajouter une box
vagrant box add [name] [url]
vagrant box add ubuntu/focal64
vagrant box add centos/7 --provider virtualbox

# Mettre à jour une box
vagrant box update
vagrant box update --box [box_name]

# Supprimer une box
vagrant box remove [box_name]
vagrant box remove ubuntu/focal64 --provider virtualbox

# Nettoyer les anciennes versions
vagrant box prune
```

### Informations sur les boxes
```bash
# Afficher les informations d'une box
vagrant box show [box_name]

# Lister les versions disponibles
vagrant box list --box-info

# Vérifier les mises à jour
vagrant box outdated
vagrant box outdated --global
```

### Créer ses propres boxes
```bash
# Packager une machine en box
vagrant package
vagrant package --output [nom_box.box]
vagrant package --base [vm_name]  # depuis VirtualBox
vagrant package --include [files]  # inclure des fichiers

# Ajouter une box locale
vagrant box add [nom_box] [fichier.box]
```

## Configuration et Vagrantfile

### Structure du Vagrantfile
```ruby
# Exemple de Vagrantfile basique
Vagrant.configure("2") do |config|
  config.vm.box = "ubuntu/focal64"
  config.vm.hostname = "myserver"
  
  # Configuration réseau
  config.vm.network "forwarded_port", guest: 80, host: 8080
  config.vm.network "private_network", ip: "192.168.56.10"
  
  # Configuration des ressources
  config.vm.provider "virtualbox" do |vb|
    vb.memory = "1024"
    vb.cpus = 2
  end
end
```

### Validation et test
```bash
# Valider le Vagrantfile
vagrant validate

# Tester la configuration SSH
vagrant ssh-config

# Afficher la configuration
vagrant config
```

## Réseaux et connectivité

### Types de réseaux
```bash
# Port forwarding
vagrant ssh -- -L 8080:localhost:80  # tunnel SSH

# Réseau privé
# Dans le Vagrantfile :
# config.vm.network "private_network", ip: "192.168.56.10"

# Réseau public (bridge)
# config.vm.network "public_network"

# Réseau interne
# config.vm.network "private_network", type: "dhcp"
```

### Connexion SSH
```bash
# Se connecter via SSH
vagrant ssh
vagrant ssh [machine_name]

# Avec des options SSH
vagrant ssh -- -A  # agent forwarding
vagrant ssh -- -X  # X11 forwarding
vagrant ssh -- -L [port]:[host]:[port]  # port forwarding

# Informations SSH
vagrant ssh-config
vagrant ssh-config > ssh_config  # sauvegarder la config
```

## Partage de fichiers

### Types de partage
```bash
# Partage par défaut (dossier du projet)
# /vagrant dans la VM

# Partage personnalisé dans le Vagrantfile
# config.vm.synced_folder ".", "/var/www"
# config.vm.synced_folder "src/", "/srv/website"

# Désactiver le partage
# config.vm.synced_folder ".", "/vagrant", disabled: true
```

### Options de partage
```ruby
# NFS (plus rapide)
config.vm.synced_folder ".", "/vagrant", type: "nfs"

# RSyncauto
config.vm.synced_folder ".", "/vagrant", type: "rsync",
  rsync__args: ["--verbose", "--archive", "--delete", "-z"]

# SMB (Windows)
config.vm.synced_folder ".", "/vagrant", type: "smb"
```

### Commandes de synchronisation
```bash
# Synchroniser avec rsync
vagrant rsync
vagrant rsync [machine_name]

# Synchronisation automatique
vagrant rsync-auto
vagrant rsync-auto [machine_name]
```

## Provisioning

### Types de provisioning
```bash
# Provisioner shell
vagrant provision
vagrant provision --provision-with shell

# Provisioner spécifique
vagrant provision --provision-with [provisioner_name]

# Reprovisioner
vagrant reload --provision
```

### Exemples de provisioning dans Vagrantfile
```ruby
# Script shell inline
config.vm.provision "shell", inline: <<-SHELL
  apt-get update
  apt-get install -y apache2
SHELL

# Script shell externe
config.vm.provision "shell", path: "bootstrap.sh"

# Ansible
config.vm.provision "ansible" do |ansible|
  ansible.playbook = "playbook.yml"
end

# Docker
config.vm.provision "docker" do |d|
  d.pull_images "ubuntu"
  d.run "web", image: "nginx"
end
```

## Plugins

### Gestion des plugins
```bash
# Lister les plugins installés
vagrant plugin list

# Installer un plugin
vagrant plugin install [plugin_name]
vagrant plugin install vagrant-vbguest

# Mettre à jour les plugins
vagrant plugin update
vagrant plugin update [plugin_name]

# Désinstaller un plugin
vagrant plugin uninstall [plugin_name]

# Réparer les plugins
vagrant plugin repair
```

### Plugins populaires
```bash
# Plugins utiles
vagrant plugin install vagrant-vbguest        # VirtualBox Guest Additions
vagrant plugin install vagrant-hostsupdater   # Mise à jour /etc/hosts
vagrant plugin install vagrant-cachier        # Cache des packages
vagrant plugin install vagrant-disksize       # Redimensionner les disques
vagrant plugin install vagrant-reload         # Redémarrage depuis le provisioning
vagrant plugin install vagrant-env            # Variables d'environnement
```

## Snapshots

### Gestion des snapshots
```bash
# Créer un snapshot
vagrant snapshot save [snapshot_name]
vagrant snapshot save "clean_install"

# Lister les snapshots
vagrant snapshot list

# Restaurer un snapshot
vagrant snapshot restore [snapshot_name]

# Supprimer un snapshot
vagrant snapshot delete [snapshot_name]

# Pousser/pop (pile de snapshots)
vagrant snapshot push
vagrant snapshot pop
```

## Multi-machines

### Configuration multi-machines
```ruby
Vagrant.configure("2") do |config|
  # Machine web
  config.vm.define "web" do |web|
    web.vm.box = "ubuntu/focal64"
    web.vm.network "private_network", ip: "192.168.56.10"
    web.vm.provision "shell", inline: "apt-get update && apt-get install -y nginx"
  end
  
  # Machine base de données
  config.vm.define "db" do |db|
    db.vm.box = "ubuntu/focal64"
    db.vm.network "private_network", ip: "192.168.56.11"
    db.vm.provision "shell", inline: "apt-get update && apt-get install -y mysql-server"
  end
end
```

### Commandes multi-machines
```bash
# Démarrer toutes les machines
vagrant up

# Démarrer une machine spécifique
vagrant up web
vagrant up db

# Statut de toutes les machines
vagrant status

# SSH vers une machine spécifique
vagrant ssh web
vagrant ssh db

# Gérer en parallèle
vagrant up --parallel
vagrant halt --parallel
```

## Débogage et maintenance

### Débogage
```bash
# Mode debug
VAGRANT_LOG=debug vagrant up
VAGRANT_LOG=info vagrant up

# Informations détaillées
vagrant --debug up 2>&1 | tee vagrant.log

# Vérifier la configuration
vagrant validate

# Diagnostics
vagrant version
vagrant plugin diagnose
```

### Maintenance
```bash
# Nettoyer le cache
vagrant global-status --prune

# Réparer les problèmes
vagrant reload --provision
vagrant destroy && vagrant up

# Vérifier l'état des machines
vagrant global-status
```

### Résolution de problèmes
```bash
# Réinitialiser complètement
vagrant destroy --force
vagrant box remove [box_name]
vagrant box add [box_name]
vagrant up

# Problèmes de réseau
vagrant reload
vagrant halt && vagrant up

# Problèmes de partage de fichiers
vagrant plugin install vagrant-vbguest
vagrant reload
```

## Intégrations

### Avec Docker
```ruby
# Provisioning Docker
config.vm.provision "docker" do |d|
  d.pull_images "ubuntu"
  d.pull_images "nginx"
  d.run "web", image: "nginx", args: "-p 80:80"
end
```

### Avec Ansible
```ruby
# Provisioning Ansible
config.vm.provision "ansible_local" do |ansible|
  ansible.playbook = "playbook.yml"
  ansible.inventory_path = "inventory"
end
```

### Avec Kubernetes
```bash
# Installer le plugin Kubernetes
vagrant plugin install vagrant-k8s

# Utiliser des boxes Kubernetes
vagrant box add generic/ubuntu2004
```

## Exemples pratiques

### Environnement de développement LAMP
```ruby
Vagrant.configure("2") do |config|
  config.vm.box = "ubuntu/focal64"
  config.vm.network "forwarded_port", guest: 80, host: 8080
  config.vm.network "private_network", ip: "192.168.56.10"
  
  config.vm.synced_folder ".", "/var/www/html"
  
  config.vm.provider "virtualbox" do |vb|
    vb.memory = "1024"
    vb.cpus = 2
  end
  
  config.vm.provision "shell", inline: <<-SHELL
    apt-get update
    apt-get install -y apache2 mysql-server php libapache2-mod-php php-mysql
    systemctl enable apache2
    systemctl start apache2
  SHELL
end
```

### Cluster multi-machines
```ruby
Vagrant.configure("2") do |config|
  # Configuration commune
  config.vm.box = "ubuntu/focal64"
  
  # Master node
  config.vm.define "master" do |master|
    master.vm.network "private_network", ip: "192.168.56.10"
    master.vm.hostname = "master"
    master.vm.provider "virtualbox" do |vb|
      vb.memory = "2048"
      vb.cpus = 2
    end
  end
  
  # Worker nodes
  (1..3).each do |i|
    config.vm.define "worker#{i}" do |worker|
      worker.vm.network "private_network", ip: "192.168.56.#{10+i}"
      worker.vm.hostname = "worker#{i}"
      worker.vm.provider "virtualbox" do |vb|
        vb.memory = "1024"
        vb.cpus = 1
      end
    end
  end
end
```

### Environnement Windows
```ruby
Vagrant.configure("2") do |config|
  config.vm.box = "gusztavvargadr/windows-10"
  config.vm.network "forwarded_port", guest: 3389, host: 3389
  
  config.vm.provider "virtualbox" do |vb|
    vb.memory = "4096"
    vb.cpus = 2
    vb.gui = true
  end
  
  config.vm.provision "shell", inline: <<-SHELL
    # Installation de chocolatey
    Set-ExecutionPolicy Bypass -Scope Process -Force
    iex ((New-Object System.Net.WebClient).DownloadString('https://chocolatey.org/install.ps1'))
    
    # Installation d'outils
    choco install -y git nodejs python
  SHELL
end
```

## Configuration avancée

### Optimisations VirtualBox
```ruby
config.vm.provider "virtualbox" do |vb|
  # Optimisations performance
  vb.memory = "2048"
  vb.cpus = 2
  vb.customize ["modifyvm", :id, "--natdnshostresolver1", "on"]
  vb.customize ["modifyvm", :id, "--natdnsproxy1", "on"]
  vb.customize ["modifyvm", :id, "--nictype1", "virtio"]
  vb.customize ["modifyvm", :id, "--audio", "none"]
end
```

### Variables d'environnement
```ruby
# Utiliser des variables d'environnement
config.vm.provision "shell", env: {
  "APP_ENV" => "development",
  "DB_HOST" => "localhost"
}, inline: <<-SHELL
  echo "Environment: $APP_ENV"
  echo "Database: $DB_HOST"
SHELL
```

### Hooks et triggers
```ruby
# Avant le démarrage
config.trigger.before :up do |trigger|
  trigger.name = "Pre-up message"
  trigger.info = "Starting the machine..."
end

# Après l'arrêt
config.trigger.after :halt do |trigger|
  trigger.name = "Post-halt cleanup"
  trigger.run = {inline: "echo 'Machine stopped'"}
end
```

## Conseils et bonnes pratiques

### Performance
1. **Utilisez des boxes légères** pour le développement
2. **Activez la virtualisation matérielle** (VT-x/AMD-V)
3. **Configurez la mémoire et CPU** selon vos besoins
4. **Utilisez NFS** pour le partage de fichiers sur Linux/macOS
5. **Désactivez les fonctionnalités inutiles** (audio, USB, etc.)

### Sécurité
1. **Changez les mots de passe par défaut**
2. **Mettez à jour régulièrement** les boxes
3. **Utilisez des clés SSH** plutôt que des mots de passe
4. **Limitez l'accès réseau** aux services nécessaires

### Maintenance
1. **Nettoyez régulièrement** avec `vagrant global-status --prune`
2. **Supprimez les boxes inutiles** avec `vagrant box remove`
3. **Utilisez des snapshots** avant les modifications importantes
4. **Versionnez vos Vagrantfiles** avec Git

## Raccourcis et aliases utiles

```bash
# Aliases pratiques
alias vup='vagrant up'
alias vhalt='vagrant halt'
alias vssh='vagrant ssh'
alias vstatus='vagrant status'
alias vreload='vagrant reload'
alias vdestroy='vagrant destroy'
alias vgs='vagrant global-status'

# Fonctions utiles
function vcd() {
  cd $(vagrant ssh-config | grep HostName | awk '{print $2}')
}

function vlog() {
  vagrant ssh -c "tail -f /var/log/syslog"
}

function vclean() {
  vagrant destroy --force
  vagrant box remove $(vagrant box list | grep -v "There are no installed boxes" | cut -d' ' -f1)
}
```

## Commandes d'urgence

```bash
# Forcer l'arrêt de toutes les VMs
vagrant global-status | grep running | awk '{print $1}' | xargs -I {} vagrant halt {}

# Nettoyer complètement
vagrant destroy --force
vagrant box remove --all
vagrant global-status --prune

# Réinitialiser VirtualBox
VBoxManage list runningvms | cut -d'"' -f2 | xargs -I {} VBoxManage controlvm {} poweroff

# Récupérer l'espace disque
vagrant box prune
docker system prune -a
```

---

*Ce guide couvre les commandes Vagrant les plus importantes. Pour plus d'informations, consultez la [documentation officielle Vagrant](https://www.vagrantup.com/docs).*