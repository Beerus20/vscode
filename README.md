# 🐳 Docker VSCode Development Environment

Un environnement de développement containerisé complet et isolé avec VSCode, support graphique X11, audio/vidéo, et configuration automatique optimisée pour le développement C/C++ avec SDL2. Ce projet permet de créer rapidement un environnement de développement reproductible et portable.

## 📋 Fonctionnalités

### Environnement de développement
- **VSCode préinstallé** directement dans le container avec interface graphique complète
- **Shell Zsh + Oh My Zsh** préconfiguré avec le thème Bira
- **Support UTF-8 complet** avec emojis et caractères spéciaux
- **Compilateurs C/C++** (GCC/G++) et outils de build (Make)

### Intégration système
- **Support X11** pour l'affichage graphique natif des applications
- **Support audio** via `/dev/snd` pour les applications multimédia
- **Accélération graphique** via `/dev/dri` (GPU passthrough)
- **Mode réseau host** pour une connectivité réseau transparente

### Gestion de projets
- **Clonage automatique** de projets GitHub au démarrage
- **Configuration Git et SSH** montée depuis l'hôte (lecture seule)
- **Persistance des données** VSCode (extensions, paramètres utilisateur, workspace)
- **Montage bidirectionnel** des projets entre hôte et container

### Personnalisation
- **Gestion des packages externalisée** via `packages.txt` pour faciliter la maintenance
- **Variables d'environnement** centralisées dans `.env`
- **Architecture modulaire** permettant l'ajout facile de nouveaux services

## 🚀 Démarrage rapide

### Prérequis

#### Logiciels requis
- **Docker** (version 20.10+) et **Docker Compose** (version 2.0+)
- **Serveur X11** pour l'affichage graphique :
  - Linux : Déjà installé (X.org ou Wayland avec XWayland)
  - macOS : XQuartz
  - Windows : VcXsrv ou Xming

#### Configuration système
- **Accès SSH configuré** pour GitHub (optionnel, pour le clonage automatique)
  - Clés SSH générées : `ssh-keygen -t ed25519 -C "votre@email.com"`
  - Clé publique ajoutée à GitHub : `cat ~/.ssh/id_ed25519.pub`
- **Fichier .gitconfig** configuré dans votre répertoire home
- **Groupe audio/video** : votre utilisateur doit avoir accès (généralement automatique)

#### Espace disque
- ~2 GB pour l'image Docker de base
- ~500 MB pour les extensions VSCode
- Variable selon vos projets

### Configuration initiale

#### 1. Configurer les variables d'environnement

Éditez le fichier `srcs/.env` selon votre environnement :

```bash
# ═══════════════════════════════════════════════════════════
# Docker image and container names
# ═══════════════════════════════════════════════════════════
IMAGE_NAME=one:1.0              # Nom de l'image Docker à créer
CONTAINER_NAME=one              # Nom du container en cours d'exécution

# ═══════════════════════════════════════════════════════════
# X11 settings - Configuration de l'affichage graphique
# ═══════════════════════════════════════════════════════════
DISPLAY=:0                      # Display X11 (généralement :0 sur Linux)

# ═══════════════════════════════════════════════════════════
# User settings - Chemins utilisateur
# ═══════════════════════════════════════════════════════════
HOME=/home/votre_utilisateur    # Votre répertoire home (IMPORTANT: à modifier)

# ═══════════════════════════════════════════════════════════
# Project settings - Clonage automatique (OPTIONNEL)
# ═══════════════════════════════════════════════════════════
PROJECT_NAME=test               # Nom du dossier du projet (optionnel)
PROJECT_REPO=username/repo.git  # Format: username/repository.git
                                # Si vide, VSCode ouvrira dans ~/projets

# ═══════════════════════════════════════════════════════════
# Directories - Montage des volumes
# ═══════════════════════════════════════════════════════════
HOST_DIR=Documents/code         # Répertoire projets sur l'hôte (relatif à $HOME)
VSCODE_PATH=goinfre/vscode      # Répertoire VSCode sur l'hôte (relatif à $HOME)
                                # Stocke extensions et paramètres

# ═══════════════════════════════════════════════════════════
# Configuration files - Fichiers de configuration
# ═══════════════════════════════════════════════════════════
GIT_CONFIG_FILE=.gitconfig      # Fichier de config Git (relatif à $HOME)
GIT_CONFIG_DIR=.config/git      # Répertoire de config Git supplémentaire
SSH_DIR=.ssh                    # Répertoire des clés SSH (relatif à $HOME)
SSH_AUTH_SOCK=/run/user/1000/keyring/ssh  # Socket SSH Agent (ajustez UID si différent)
```

**⚠️ Important** : Ajustez `SSH_AUTH_SOCK` avec votre UID :
```bash
# Trouver votre UID
id -u
# Si le résultat est 1000, utilisez: /run/user/1000/keyring/ssh
# Si le résultat est 1001, utilisez: /run/user/1001/keyring/ssh
```

#### 2. Ajouter des packages supplémentaires (optionnel)

Le fichier `srcs/services/code/tools/packages.txt` permet de gérer les packages apt à installer. Un package par ligne.

**Packages par défaut** :
```txt
libsdl2-dev          # Bibliothèque SDL2 principale
libsdl2-image-dev    # Support images (PNG, JPG)
libsdl2-ttf-dev      # Support polices TrueType
libsdl2-mixer-dev    # Support audio/musique
vim                  # Éditeur de texte
```

**Exemples d'ajouts utiles** :
```txt
# Outils de développement
neovim              # Éditeur moderne
tmux                # Multiplexeur de terminal
htop                # Moniteur système
tree                # Visualisation arborescence
gdb                 # Débogueur

# Bibliothèques supplémentaires
libglew-dev         # OpenGL
libglfw3-dev        # Framework OpenGL
libcurl4-openssl-dev # Client HTTP

# Analyse et qualité de code
valgrind            # Détection fuites mémoire
clang-format        # Formatage code
cppcheck            # Analyse statique
```

#### 3. Créer les répertoires nécessaires

```bash
# Créer le répertoire VSCode (si pas déjà existant)
mkdir -p ~/goinfre/vscode/{user-data,extensions}

# Créer le répertoire de projets
mkdir -p ~/Documents/code
```

### Lancement

#### Première utilisation

```bash
# 1. Se placer dans le répertoire du projet
cd /chemin/vers/le/projet

# 2. Construire l'image (peut prendre 5-10 minutes)
make build

# 3. Démarrer le container
make up
```

#### Utilisation quotidienne

```bash
# Tout en une seule commande
make

# Ou utiliser docker compose directement
docker compose -f srcs/docker-compose.yml up
```

#### Avec clonage automatique

Si vous avez configuré `PROJECT_REPO` dans `.env`, le container :
1. Clone automatiquement le dépôt depuis GitHub
2. Ouvre VSCode dans le dossier du projet cloné
3. Configure Git avec vos identifiants

```bash
# Dans .env, configurez :
PROJECT_NAME=mon_super_projet
PROJECT_REPO=Beerus20/CPP.git

# Au lancement :
make
# → Clone dans ~/mon_super_projet
# → Ouvre VSCode dans ce dossier
```

### Premier lancement - Ce qui se passe

1. **Autorisation X11** : `xhost +local:docker` autorise le container à afficher des fenêtres
2. **Build Docker** : Construction de l'image avec tous les packages
3. **Installation Oh My Zsh** : Configuration du shell Zsh
4. **Copie des configurations** : `.zshrc` est copié
5. **Clonage du projet** (si configuré) : Récupération du code depuis GitHub
6. **Démarrage VSCode** : Lancement de l'éditeur avec les bons paramètres
7. **Montage des volumes** : Projets, configurations, et données VSCode disponibles

**Durée estimée** : 5-15 minutes selon votre connexion internet.

## 🛠️ Commandes disponibles

### Makefile

Le Makefile fournit des commandes simplifiées pour gérer le cycle de vie du container :

| Commande        | Description détaillée                                                                 | Utilisation                |
|-----------------|--------------------------------------------------------------------------------------|----------------------------|
| `make`          | Équivalent à `make all` : construit l'image et démarre le container                  | Usage quotidien            |
| `make all`      | Exécute séquentiellement `make build` puis `make up`                                 | Démarrage complet          |
| `make build`    | Construit l'image Docker à partir du Dockerfile. Durée : 5-15 min selon la connexion | Après modif Dockerfile     |
| `make up`       | Démarre le container avec docker compose. Active X11 puis lance les services         | Démarrage rapide           |
| `make down`     | Arrête et supprime le container. Révoque l'accès X11. Données persistées             | Arrêt propre               |
| `make fclean`   | Nettoage complet : arrêt + suppression de toutes les images Docker                   | Nettoyage disque           |
| `make re`       | Reconstruction complète : `fclean` + `all`. Force un rebuild from scratch            | Après gros changements     |

### Commandes Docker Compose directes

Pour plus de contrôle, vous pouvez utiliser docker compose directement :

```bash
# Construire l'image
docker compose -f srcs/docker-compose.yml build

# Démarrer en premier plan (voir les logs)
docker compose -f srcs/docker-compose.yml up

# Démarrer en arrière-plan
docker compose -f srcs/docker-compose.yml up -d

# Voir les logs
docker compose -f srcs/docker-compose.yml logs -f

# Arrêter
docker compose -f srcs/docker-compose.yml down

# Reconstruire avec --no-cache
docker compose -f srcs/docker-compose.yml build --no-cache
```

### Gestion du container

```bash
# Voir les containers en cours d'exécution
docker ps

# Entrer dans le container en cours
docker exec -it one zsh

# Voir les logs du container
docker logs -f one

# Arrêter le container
docker stop one

# Redémarrer le container
docker restart one

# Supprimer le container
docker rm -f one
```

### Gestion des images

```bash
# Lister les images
docker images

# Supprimer une image spécifique
docker rmi one:1.0

# Supprimer toutes les images non utilisées
docker image prune -a

# Voir l'espace utilisé
docker system df
```

## 📁 Structure du projet

```
.
├── makefile                          # Commandes de gestion Docker
├── run.sh                            # Script alternatif de lancement
├── README.md                         # Cette documentation
└── srcs/
    ├── .env                          # Variables d'environnement
    ├── docker-compose.yml            # Configuration des services
    └── services/
        └── code/
            ├── Dockerfile            # Image de développement
            ├── conf/
            │   └── zshrc             # Configuration Zsh
            └── tools/
                ├── entrypoint.sh     # Script de démarrage
                └── packages.txt      # Liste des packages apt
```

## ⚙️ Configuration détaillée

### Architecture du système

```
┌─────────────────────────────────────────────────────────────┐
│                         HÔTE (Linux)                        │
│                                                             │
│  ┌──────────────┐  ┌──────────────┐  ┌─────────────────┐  │
│  │   X11 Server │  │  SSH Agent   │  │  ~/.gitconfig   │  │
│  └──────┬───────┘  └──────┬───────┘  └────────┬────────┘  │
│         │                  │                    │           │
│         │ Socket           │ Socket             │ Mount     │
│         │ (Display)        │ (Auth)             │ (RO)      │
└─────────┼──────────────────┼────────────────────┼───────────┘
          │                  │                    │
          ▼                  ▼                    ▼
┌─────────────────────────────────────────────────────────────┐
│               CONTAINER (Ubuntu 22.04)                      │
│                                                             │
│  ┌──────────────────────────────────────────────────────┐  │
│  │                     VSCode                           │  │
│  │  - Éditeur graphique via X11                         │  │
│  │  - Extensions persistées                             │  │
│  │  - Settings synchronisés                             │  │
│  └──────────────────────────────────────────────────────┘  │
│                                                             │
│  ┌──────────────┐  ┌──────────────┐  ┌─────────────────┐  │
│  │   Zsh + OMZ  │  │   GCC/G++    │  │   Git + SSH     │  │
│  └──────────────┘  └──────────────┘  └─────────────────┘  │
│                                                             │
│  Volumes montés:                                           │
│  • ~/projets      ← Bidirectionnel                         │
│  • ~/.vscode      ← Bidirectionnel                         │
│  • ~/.gitconfig   ← Lecture seule                          │
│  • ~/.ssh         ← Lecture seule                          │
└─────────────────────────────────────────────────────────────┘
```

### Variables d'environnement (fichier .env)

#### Docker Configuration

```bash
IMAGE_NAME=one:1.0           # Nom complet de l'image Docker
                             # Format: nom:version
                             # Utilisé pour: docker build, docker run

CONTAINER_NAME=one           # Nom du container en exécution
                             # Utilisé pour: docker ps, docker exec
                             # Doit être unique sur le système
```

#### X11 Display

```bash
DISPLAY=:0                   # Identifiant du serveur X11
                             # :0 = premier écran
                             # :1 = second écran, etc.
                             # Nécessaire pour afficher VSCode
```

#### User Settings

```bash
HOME=/home/ballain           # Répertoire home de l'utilisateur HOST
                             # Utilisé comme base pour tous les chemins relatifs
                             # DOIT correspondre à votre vrai $HOME
```

#### Project Settings

```bash
PROJECT_NAME=test            # Nom du dossier où cloner le projet
                             # Si vide, utilise le nom du repo
                             # Le projet sera dans: $HOME/$PROJECT_NAME

PROJECT_REPO=Beerus20/CPP.git # Repository GitHub à cloner
                             # Format: username/repository.git
                             # Si vide, pas de clonage automatique
                             # Nécessite l'accès SSH configuré
```

#### Directory Mappings

```bash
HOST_DIR=Documents/code      # Dossier de travail sur l'hôte (relatif à $HOME)
                             # Monté dans: ${HOME}/projets (dans le container)
                             # Exemple complet: /home/ballain/Documents/code

VSCODE_PATH=goinfre/vscode   # Dossier VSCode sur l'hôte (relatif à $HOME)
                             # Structure:
                             # ├── user-data/    (paramètres utilisateur)
                             # └── extensions/   (extensions installées)
```

#### Configuration Files

```bash
GIT_CONFIG_FILE=.gitconfig   # Fichier de config Git principal
                             # Contient: user.name, user.email, aliases
                             # Monté en lecture seule

GIT_CONFIG_DIR=.config/git   # Dossier de config Git additionnel
                             # Peut contenir: ignore, attributes, etc.

SSH_DIR=.ssh                 # Dossier des clés SSH
                             # Contient: id_rsa, id_ed25519, known_hosts
                             # Monté en lecture seule pour sécurité

SSH_AUTH_SOCK=/run/user/1000/keyring/ssh
                             # Socket de l'agent SSH
                             # Permet l'auth sans copier les clés
                             # Ajuster 1000 avec votre UID (id -u)
```

### Dockerfile - Explication détaillée

#### Image de base

```dockerfile
FROM ubuntu:22.04            # Ubuntu LTS (support jusqu'en 2027)
                             # Choix : stabilité + packages récents
```

#### Build Arguments

```dockerfile
ARG HOME=/home/user          # Argument de build flexible
                             # Passé via docker-compose
                             # Permet de personnaliser le home directory
```

#### Couches d'installation

**1. Configuration de base**
```dockerfile
ENV DEBIAN_FRONTEND=noninteractive
# Évite les prompts interactifs pendant apt-get install
# Nécessaire pour l'automatisation
```

**2. Bibliothèques X11**
```dockerfile
# Bibliothèques pour l'affichage graphique
libx11-6, libxext6, libxrender1  # Core X11
libxtst6, libxi6, libxrandr2     # Extensions (input, multi-écran)
libxcursor1, libxdamage1         # Curseur et composition
```

**3. Outils système**
```dockerfile
wget, curl      # Téléchargement de fichiers
ca-certificates # Certificats SSL/TLS
git             # Gestion de version
```

**4. Packages personnalisés**
```dockerfile
$(cat /tmp/packages.txt | xargs)
# Lecture du fichier packages.txt
# xargs : convertit les lignes en arguments
# Permet la personnalisation sans modifier le Dockerfile
```

**5. Compilateurs**
```dockerfile
gcc, g++, make  # Toolchain C/C++ complète
                # gcc/g++ version 11.x sur Ubuntu 22.04
```

**6. Polices et locales**
```dockerfile
# Support des caractères internationaux et emojis
fonts-liberation       # Polices de base
fonts-noto-color-emoji # Emojis colorés
fonts-noto-cjk        # Caractères asiatiques

locale-gen en_US.UTF-8 # Génération des locales UTF-8
```

**7. Shell Zsh**
```dockerfile
zsh                    # Shell moderne et puissant
# Oh My Zsh installé via curl dans RUN layer suivant
```

#### Optimisations Docker

```dockerfile
# ✅ Bon : Une seule layer RUN avec &&
RUN apt-get update && apt-get install -y \
    package1 \
    package2 \
    && rm -rf /var/lib/apt/lists/*

# ❌ Mauvais : Plusieurs RUN créent plusieurs layers
RUN apt-get update
RUN apt-get install -y package1
RUN apt-get install -y package2
# → Image plus volumineuse et build plus lent
```

### docker-compose.yml - Configuration des services

#### Build Context

```yaml
build:
  context: ./services/code    # Dossier contenant le Dockerfile
  args:
    HOME: ${HOME}             # Passage du $HOME depuis .env
                              # Permet la personnalisation du home directory
```

#### Devices

```yaml
devices:
  - /dev/dri:/dev/dri        # GPU pour accélération graphique
                              # Nécessaire pour: rendu OpenGL, vidéo
  - /dev/snd:/dev/snd        # Carte son pour audio
                              # Nécessaire pour: SDL_mixer, applications multimédia
```

#### Volumes - Détails techniques

```yaml
volumes:
  # X11 Socket - Affichage graphique
  - "/tmp/.X11-unix:/tmp/.X11-unix"
    # Socket Unix pour communication X11
    # Permet au container d'afficher des fenêtres
    
  # Projets - Bidirectionnel
  - "${HOME}/${HOST_DIR}:${HOME}/projets"
    # Modifications visibles immédiatement des 2 côtés
    # Pas de copie, pointage direct (bind mount)
    
  # VSCode Data - Bidirectionnel
  - "${HOME}/${VSCODE_PATH}:${HOME}/.vscode"
    # Extensions et settings persistés sur l'hôte
    # Survit à la destruction du container
    
  # Git Config - Lecture seule (:ro)
  - "${HOME}/${GIT_CONFIG_FILE}:/root/.gitconfig:ro"
    # :ro = read-only, sécurité
    # Container ne peut pas modifier votre config Git
    
  # SSH Keys - Lecture seule (:ro)
  - "${HOME}/${SSH_DIR}:/root/${SSH_DIR}:ro"
    # Clés privées jamais copiées dans l'image
    # Protection contre extraction malveillante
    
  # Git Config Directory
  - "${HOME}/.config/git:/root/.config/git:ro"
    # Config Git additionnelle (ignore, attributes)
    
  # SSH Agent Socket
  - "${SSH_AUTH_SOCK}:/run/user/0/keyring/ssh"
    # Forwarding de l'agent SSH
    # Permet l'auth sans exposer les clés privées
    
  # Fonts - Lecture seule
  - "~/.fonts:${HOME}/.fonts:ro"
    # Polices personnalisées de l'hôte
    # Améliore le rendu dans VSCode
```

#### Groups

```yaml
group_add:
  - audio                     # Accès aux périphériques audio
  - video                     # Accès aux périphériques vidéo/GPU
# Nécessaire pour que l'utilisateur root du container
# puisse accéder à /dev/snd et /dev/dri
```

#### Network Mode

```yaml
network_mode: "host"          # Utilise la stack réseau de l'hôte
                              # Avantages:
                              # - Pas de NAT
                              # - Performances maximales
                              # - Accès direct à tous les ports
                              # Inconvénient:
                              # - Moins d'isolation réseau
```

### entrypoint.sh - Logique de démarrage

Le script d'entrypoint orchestre le démarrage du container :

```bash
set -e                        # Arrêt immédiat si erreur
                              # Évite l'exécution en état incohérent
```

#### 1. Détermination du répertoire de projet

```bash
PROJECT_DIR="."               # Valeur par défaut

if [ -n "$PROJECT_REPO" ]; then
    # Si PROJECT_REPO est défini (non vide)
    
    if [ -n "$PROJECT_NAME" ]; then
        PROJECT_DIR="$HOME/$PROJECT_NAME"
        # Utilise le nom personnalisé
    else
        PROJECT_DIR="$HOME/$(basename $PROJECT_REPO .git)"
        # Extrait le nom du repo
        # Exemple: "Beerus20/CPP.git" → "CPP"
    fi
    
    echo "Cloning $PROJECT_REPO into $PROJECT_DIR"
    git clone git@github.com:$PROJECT_REPO "$PROJECT_DIR"
    # Clone via SSH (nécessite auth configurée)
    
else
    PROJECT_DIR="$HOME/projets"
    # Pas de clonage, ouvre le dossier projets monté
fi
```

#### 2. Configuration du shell

```bash
if [ -f /tmp/.zshrc ]; then
  mv /tmp/.zshrc $HOME/.zshrc
  # Déplace la config Zsh copiée durant le build
  # mv plutôt que cp pour économiser l'espace
fi

chsh -s $(which zsh) root
# Change le shell par défaut pour l'utilisateur root
# $(which zsh) trouve le chemin complet de zsh
```

#### 3. Lancement de VSCode

```bash
code \
    --wait \                  # Attend la fermeture de VSCode avant de continuer
    --no-sandbox \            # Désactive le sandbox (nécessaire pour root)
    --password-store=basic \  # Utilise un keyring simple (pas de gnome-keyring)
    --user-data-dir=$HOME/.vscode/user-data \
                              # Où stocker les settings
    --extensions-dir=$HOME/.vscode/extensions \
                              # Où stocker les extensions
    $PROJECT_DIR              # Dossier à ouvrir
```

### packages.txt - Gestion modulaire

**Principe** : Un package apt par ligne

**Avantages** :
- Modification sans rebuild du Dockerfile
- Versioning Git facile
- Partage entre projets
- Documentation des dépendances

**Format** :
```txt
# Commentaires supportés
package-name         # Un package par ligne
another-package      # Pas de version spécifiée = latest
```

**Installation dans le Dockerfile** :
```dockerfile
RUN apt-get install -y $(cat /tmp/packages.txt | xargs)
# cat : lit le fichier
# xargs : convertit les lignes en arguments
# Équivaut à: apt-get install -y pkg1 pkg2 pkg3 ...
```

## 🎯 Cas d'usage et exemples

### 1. Développement C/C++ avec SDL2

#### Packages inclus par défaut

Le container vient avec une stack complète pour le développement SDL2 :

```bash
# Compilateurs
gcc (v11.4)          # Compilateur C
g++ (v11.4)          # Compilateur C++
make                 # Outil de build

# Bibliothèques SDL2
libsdl2-dev          # Core SDL2 (fenêtrage, événements, rendu)
libsdl2-image-dev    # Support images: PNG, JPG, BMP, GIF, etc.
libsdl2-ttf-dev      # Rendu de texte avec polices TrueType
libsdl2-mixer-dev    # Audio: WAV, MP3, OGG, FLAC, etc.
```

#### Exemple de projet SDL2

**Structure du projet** :
```
~/projets/mon_jeu/
├── src/
│   ├── main.c
│   ├── game.c
│   └── game.h
├── assets/
│   ├── images/
│   │   └── sprite.png
│   ├── fonts/
│   │   └── arial.ttf
│   └── sounds/
│       └── music.mp3
├── Makefile
└── README.md
```

**Exemple main.c** :
```c
#include <SDL2/SDL.h>
#include <SDL2/SDL_image.h>
#include <SDL2/SDL_ttf.h>
#include <stdio.h>

int main(int argc, char* argv[]) {
    // Initialisation SDL
    if (SDL_Init(SDL_INIT_VIDEO | SDL_INIT_AUDIO) < 0) {
        printf("SDL Error: %s\n", SDL_GetError());
        return 1;
    }

    // Création de la fenêtre
    SDL_Window* window = SDL_CreateWindow(
        "Mon Jeu SDL2",
        SDL_WINDOWPOS_CENTERED,
        SDL_WINDOWPOS_CENTERED,
        800, 600,
        SDL_WINDOW_SHOWN
    );

    // Création du renderer
    SDL_Renderer* renderer = SDL_CreateRenderer(window, -1, 
        SDL_RENDERER_ACCELERATED | SDL_RENDERER_PRESENTVSYNC);

    // Boucle principale
    SDL_Event event;
    int running = 1;
    while (running) {
        while (SDL_PollEvent(&event)) {
            if (event.type == SDL_QUIT) {
                running = 0;
            }
        }

        // Rendu
        SDL_SetRenderDrawColor(renderer, 0, 0, 0, 255);
        SDL_RenderClear(renderer);
        SDL_RenderPresent(renderer);
    }

    // Nettoyage
    SDL_DestroyRenderer(renderer);
    SDL_DestroyWindow(window);
    SDL_Quit();
    return 0;
}
```

**Makefile** :
```makefile
NAME = mon_jeu
CC = gcc
CFLAGS = -Wall -Wextra -Werror -g
LDFLAGS = -lSDL2 -lSDL2_image -lSDL2_ttf -lSDL2_mixer

SRC = src/main.c src/game.c
OBJ = $(SRC:.c=.o)

all: $(NAME)

$(NAME): $(OBJ)
	$(CC) $(OBJ) $(LDFLAGS) -o $(NAME)

%.o: %.c
	$(CC) $(CFLAGS) -c $< -o $@

clean:
	rm -f $(OBJ)

fclean: clean
	rm -f $(NAME)

re: fclean all

.PHONY: all clean fclean re
```

**Compilation et exécution** :
```bash
# Dans le terminal du container
cd ~/projets/mon_jeu
make
./mon_jeu
```

#### Débogage avec GDB

```bash
# Compiler avec symboles de débogage
gcc -g main.c -o mon_jeu -lSDL2

# Lancer GDB
gdb ./mon_jeu

# Commandes GDB utiles
(gdb) break main          # Point d'arrêt sur main
(gdb) run                 # Exécuter le programme
(gdb) next                # Ligne suivante
(gdb) print variable      # Afficher une variable
(gdb) backtrace           # Stack trace
(gdb) quit                # Quitter
```

### 2. Développement avec Git et GitHub

#### Configuration Git héritée de l'hôte

Le container utilise votre configuration Git existante :

```bash
# Ces fichiers sont montés depuis l'hôte :
~/.gitconfig              # Configuration principale
~/.ssh/                   # Clés SSH pour authentification
~/.config/git/            # Configuration additionnelle

# Vérifier la config dans le container
git config --list

# Exemple de sortie
user.name=Votre Nom
user.email=votre@email.com
core.editor=vim
alias.st=status
alias.co=checkout
```

#### Workflow Git complet

```bash
# 1. Clonage automatique au démarrage (si configuré dans .env)
# Le container clone automatiquement votre projet

# 2. Ou clonage manuel
cd ~/projets
git clone git@github.com:username/repository.git
cd repository

# 3. Créer une branche
git checkout -b feature/nouvelle-fonctionnalite

# 4. Développer dans VSCode
# Les fichiers sont synchronisés avec l'hôte en temps réel

# 5. Commits
git add .
git commit -m "feat: ajout de la nouvelle fonctionnalité"

# 6. Push vers GitHub
git push origin feature/nouvelle-fonctionnalite
# L'authentification SSH fonctionne via le SSH Agent forwarding

# 7. Les commits sont aussi visibles sur l'hôte
```

#### Cas particulier : Sous-modules Git

```bash
# Cloner avec sous-modules
git clone --recursive git@github.com:user/repo.git

# Mettre à jour les sous-modules
git submodule update --init --recursive

# Mettre à jour vers la dernière version
git submodule update --remote
```

### 3. Extensions VSCode

#### Installation d'extensions

Les extensions sont persistées dans `${VSCODE_PATH}/extensions` :

**Méthode 1 : Via l'interface VSCode**
1. Ouvrir VSCode dans le container
2. Cliquer sur l'icône Extensions (Ctrl+Shift+X)
3. Rechercher et installer

**Méthode 2 : Via la ligne de commande**
```bash
# Dans le container
code --install-extension ms-vscode.cpptools
code --install-extension ms-python.python
code --install-extension eamodio.gitlens
```

#### Extensions recommandées pour C/C++

```bash
# C/C++ IntelliSense
code --install-extension ms-vscode.cpptools

# CMake support
code --install-extension twxs.cmake
code --install-extension ms-vscode.cmake-tools

# Git integration avancée
code --install-extension eamodio.gitlens

# Formatage de code
code --install-extension xaver.clang-format

# Visualisation Git
code --install-extension mhutchie.git-graph

# Thème (exemple)
code --install-extension PKief.material-icon-theme
code --install-extension zhuangtongfa.material-theme
```

#### Configuration VSCode personnalisée

Les settings sont dans `${VSCODE_PATH}/user-data/User/settings.json` :

```json
{
    // Éditeur
    "editor.fontSize": 14,
    "editor.tabSize": 4,
    "editor.insertSpaces": false,
    "editor.rulers": [80, 120],
    
    // C/C++
    "C_Cpp.clang_format_style": "{ BasedOnStyle: Google, IndentWidth: 4, TabWidth: 4 }",
    "C_Cpp.default.cppStandard": "c++17",
    "C_Cpp.default.cStandard": "c11",
    
    // Terminal
    "terminal.integrated.shell.linux": "/bin/zsh",
    "terminal.integrated.fontSize": 13,
    
    // Git
    "git.enableSmartCommit": true,
    "git.confirmSync": false,
    
    // Formatage auto
    "editor.formatOnSave": true,
    
    // Thème
    "workbench.colorTheme": "Material Theme Darker",
    "workbench.iconTheme": "material-icon-theme"
}
```

### 4. Compilation de projets complexes

#### Projet avec Makefile

```bash
cd ~/projets/mon_projet
make                    # Build
make clean              # Nettoyage objets
make fclean             # Nettoyage complet
make re                 # Rebuild
```

#### Projet avec CMake

**Installation de CMake** (ajouter dans packages.txt) :
```txt
cmake
ninja-build
```

**Workflow CMake** :
```bash
# Créer un build directory
mkdir build && cd build

# Configuration
cmake .. -G Ninja

# Ou avec options
cmake .. -DCMAKE_BUILD_TYPE=Debug -DCMAKE_C_COMPILER=gcc

# Compilation
cmake --build .

# Ou avec Ninja directement
ninja

# Installation (si prévu)
sudo cmake --install .
```

#### Projet avec plusieurs fichiers

**Structure** :
```
projet/
├── include/
│   ├── game.h
│   └── player.h
├── src/
│   ├── main.c
│   ├── game.c
│   └── player.c
└── Makefile
```

**Makefile avancé** :
```makefile
NAME = game
CC = gcc
CFLAGS = -Wall -Wextra -Werror -g -I./include
LDFLAGS = -lSDL2 -lSDL2_image -lm

SRC_DIR = src
INC_DIR = include
OBJ_DIR = obj

SRC = $(wildcard $(SRC_DIR)/*.c)
OBJ = $(SRC:$(SRC_DIR)/%.c=$(OBJ_DIR)/%.o)
DEP = $(OBJ:.o=.d)

all: $(NAME)

$(NAME): $(OBJ)
	$(CC) $(OBJ) $(LDFLAGS) -o $@
	@echo "✅ Build completed: $(NAME)"

$(OBJ_DIR)/%.o: $(SRC_DIR)/%.c | $(OBJ_DIR)
	$(CC) $(CFLAGS) -MMD -c $< -o $@

$(OBJ_DIR):
	mkdir -p $(OBJ_DIR)

clean:
	rm -rf $(OBJ_DIR)

fclean: clean
	rm -f $(NAME)

re: fclean all

-include $(DEP)

.PHONY: all clean fclean re
```

### 5. Cas d'usage avancés

#### Développement multi-projets

```bash
# Structure avec plusieurs projets
~/projets/
├── projet_A/
├── projet_B/
└── projet_C/

# Dans le container, vous pouvez travailler sur tous
code ~/projets/projet_A  # Ouvre projet A
code ~/projets/projet_B  # Ouvre projet B en nouvelle fenêtre
```

#### Workflow avec branches Git multiples

```bash
# Créer plusieurs worktrees
cd ~/projets/mon_projet
git worktree add ../mon_projet-feature feature/nouvelle-fonctionnalite
git worktree add ../mon_projet-bugfix bugfix/correction-bug

# Chaque worktree peut être ouvert dans VSCode séparément
code ~/projets/mon_projet           # main branch
code ~/projets/mon_projet-feature   # feature branch
```

#### Tests et validation

```bash
# Exemple avec un Makefile de test
make test               # Lance les tests
make valgrind          # Détection de fuites mémoire
make coverage          # Couverture de code

# Exemple de règle Makefile pour tests
test: $(NAME)
	./$(NAME) tests/test1.txt
	./$(NAME) tests/test2.txt
	@echo "✅ All tests passed"

valgrind: $(NAME)
	valgrind --leak-check=full --show-leak-kinds=all ./$(NAME)
```

## 🐛 Dépannage et résolution de problèmes

### Problèmes d'affichage X11

#### VSCode ne s'affiche pas / Erreur "Cannot open display"

**Cause** : Docker n'a pas l'autorisation d'accéder au serveur X11

**Solution 1 : Autorisation temporaire** (réinitialise au redémarrage)
```bash
# Sur l'hôte
xhost +local:docker

# Pour vérifier les autorisations actuelles
xhost

# Sortie attendue :
# access control enabled, only authorized clients can connect
# LOCAL:docker
```

**Solution 2 : Autorisation permanente** (ajouter au .bashrc/.zshrc)
```bash
# Dans ~/.bashrc ou ~/.zshrc
if command -v xhost &> /dev/null; then
    xhost +local:docker > /dev/null 2>&1
fi
```

**Solution 3 : Vérifier DISPLAY**
```bash
# Sur l'hôte, vérifier DISPLAY
echo $DISPLAY
# Généralement : :0 ou :1

# Mettre à jour dans srcs/.env si différent
DISPLAY=:0
```

**Solution 4 : Wayland**
Si vous utilisez Wayland au lieu de X11 :
```bash
# Vérifier votre session
echo $XDG_SESSION_TYPE
# Si "wayland", assurez-vous que XWayland est actif

# Option 1: Forcer X11
# Au login, choisir "GNOME sur X11" ou équivalent

# Option 2: Variables pour Wayland
export DISPLAY=:0
export WAYLAND_DISPLAY=wayland-0
```

#### Fenêtre VSCode affichée mais freeze/lag

**Cause** : Problème d'accélération graphique

**Solution** :
```bash
# Vérifier que /dev/dri est accessible
ls -la /dev/dri/
# Doit montrer card0, card1, renderD128, etc.

# Vérifier les groupes dans le container
docker exec -it one groups
# Doit inclure: video

# Si le problème persiste, essayer sans accélération
# Dans docker-compose.yml, commenter temporairement :
# devices:
#   - /dev/dri:/dev/dri
```

### Problèmes de permissions

#### Git : "Permission denied (publickey)"

**Cause** : Clés SSH non accessibles ou SSH Agent non fonctionnel

**Diagnostic** :
```bash
# Sur l'hôte, vérifier SSH Agent
echo $SSH_AUTH_SOCK
# Doit afficher un chemin : /run/user/1000/keyring/ssh

# Vérifier que l'agent a les clés
ssh-add -l
# Doit lister vos clés SSH

# Tester la connexion GitHub
ssh -T git@github.com
# Doit afficher : Hi username! You've successfully authenticated...
```

**Solutions** :

**1. Démarrer SSH Agent** :
```bash
# Démarrer l'agent
eval "$(ssh-agent -s)"

# Ajouter votre clé
ssh-add ~/.ssh/id_ed25519
# ou
ssh-add ~/.ssh/id_rsa

# Vérifier
ssh-add -l
```

**2. Mettre à jour SSH_AUTH_SOCK dans .env** :
```bash
# Trouver votre UID
id -u
# Exemple : 1000

# Dans srcs/.env, ajuster :
SSH_AUTH_SOCK=/run/user/1000/keyring/ssh
#                      ^^^^ votre UID
```

**3. Vérifier les permissions des clés** :
```bash
# Les clés privées doivent être 600
chmod 600 ~/.ssh/id_ed25519
chmod 600 ~/.ssh/id_rsa

# Le répertoire .ssh doit être 700
chmod 700 ~/.ssh

# Les clés publiques peuvent être 644
chmod 644 ~/.ssh/*.pub
```

**4. Alternative : HTTPS au lieu de SSH** :
```bash
# Dans .env, utilisez HTTPS
PROJECT_REPO=https://github.com/username/repo.git

# Vous devrez entrer vos identifiants ou utiliser un token
```

#### "Permission denied" sur les fichiers du projet

**Cause** : Décalage d'UID/GID entre hôte et container

**Solution** :
```bash
# Sur l'hôte, vérifier votre UID/GID
id
# uid=1000(username) gid=1000(username)

# Le container tourne en root (uid=0)
# Deux approches :

# Approche 1 : Changer les permissions sur l'hôte (temporaire)
sudo chown -R $(id -u):$(id -g) ~/Documents/code

# Approche 2 : Modifier le Dockerfile pour utiliser votre UID
# Ajouter dans le Dockerfile :
ARG USER_ID=1000
ARG GROUP_ID=1000
RUN groupadd -g ${GROUP_ID} devuser && \
    useradd -u ${USER_ID} -g ${GROUP_ID} -m devuser
USER devuser
```

### Problèmes de build Docker

#### "docker: command not found"

**Solution** :
```bash
# Installer Docker
# Ubuntu/Debian
sudo apt-get update
sudo apt-get install docker.io docker-compose-plugin

# Arch Linux
sudo pacman -S docker docker-compose

# Ajouter votre utilisateur au groupe docker
sudo usermod -aG docker $USER

# IMPORTANT : Se déconnecter et reconnecter pour appliquer
# Ou exécuter :
newgrp docker

# Démarrer le service Docker
sudo systemctl start docker
sudo systemctl enable docker
```

#### Build échoue sur "E: Unable to locate package"

**Cause** : Package non disponible dans Ubuntu 22.04

**Solution** :
```bash
# Vérifier la disponibilité du package
docker run --rm ubuntu:22.04 apt-cache search nom_package

# Si le package n'existe pas, alternatives :
# 1. Trouver le nom correct
# 2. Utiliser un PPA
# 3. Compiler depuis les sources
# 4. Retirer le package de packages.txt
```

#### "no space left on device"

**Cause** : Docker manque d'espace disque

**Solution** :
```bash
# Vérifier l'espace utilisé par Docker
docker system df

# Nettoyer les images non utilisées
docker image prune -a

# Nettoyer tout (ATTENTION : supprime tout!)
docker system prune -a --volumes

# Libérer de l'espace sur l'hôte si nécessaire
du -sh ~/Documents/code
du -sh ~/goinfre/vscode
```

#### Build très lent

**Causes et solutions** :

**1. Connexion internet lente**
```bash
# Utiliser un miroir APT plus rapide
# Ajouter dans le Dockerfile avant apt-get update :
RUN sed -i 's/archive.ubuntu.com/fr.archive.ubuntu.com/g' /etc/apt/sources.list
```

**2. Cache Docker non utilisé**
```bash
# S'assurer que le Dockerfile est bien structuré
# Les layers qui changent rarement doivent être au début
# Les layers qui changent souvent à la fin

# Bon ordre :
FROM ubuntu:22.04
RUN apt-get update && apt-get install -y ...
COPY packages.txt /tmp/
RUN apt-get install -y $(cat /tmp/packages.txt | xargs)
COPY entrypoint.sh /

# Mauvais ordre :
FROM ubuntu:22.04
COPY entrypoint.sh /                    # Change souvent
RUN apt-get update && apt-get install   # Rebuild à chaque fois
```

### Problèmes au runtime

#### Container s'arrête immédiatement

**Diagnostic** :
```bash
# Voir les logs
docker logs one

# Ou avec docker-compose
docker compose -f srcs/docker-compose.yml logs
```

**Causes fréquentes** :

**1. Erreur dans entrypoint.sh**
```bash
# Vérifier la syntaxe
bash -n srcs/services/code/tools/entrypoint.sh

# Ajouter du debug dans entrypoint.sh
set -x  # Active le mode verbose
echo "DEBUG: Starting entrypoint"
```

**2. VSCode ne se lance pas**
```bash
# Tester VSCode manuellement dans le container
docker exec -it one bash
code --version
code --help
```

#### Audio ne fonctionne pas

**Diagnostic** :
```bash
# Vérifier /dev/snd dans le container
docker exec -it one ls -la /dev/snd/

# Vérifier PulseAudio sur l'hôte
pactl info
```

**Solution** :
```bash
# Monter le socket PulseAudio
# Ajouter dans docker-compose.yml :
volumes:
  - /run/user/1000/pulse:/run/user/0/pulse
environment:
  - PULSE_SERVER=unix:/run/user/0/pulse/native
```

#### "Text file busy" lors de la modification de scripts

**Cause** : Fichier en cours d'exécution

**Solution** :
```bash
# Arrêter le container avant de modifier
make down

# Modifier les fichiers

# Redémarrer
make up
```

### Problèmes de performance

#### VSCode très lent

**Causes possibles** :

**1. Trop d'extensions**
```bash
# Lister les extensions installées
code --list-extensions

# Désactiver les extensions non utilisées
code --disable-extension <extension-id>
```

**2. Workspace trop gros**
```bash
# Exclure les gros dossiers de la recherche
# Dans settings.json :
{
    "files.exclude": {
        "**/node_modules": true,
        "**/.git": true,
        "**/build": true
    },
    "search.exclude": {
        "**/node_modules": true,
        "**/build": true
    }
}
```

**3. Pas assez de ressources**
```bash
# Limiter les ressources Docker
# Dans /etc/docker/daemon.json :
{
    "default-runtime": "runc",
    "default-ulimits": {
        "nofile": {
            "Name": "nofile",
            "Hard": 64000,
            "Soft": 64000
        }
    }
}
```

### Problèmes réseaux

#### Impossible de cloner depuis GitHub

**Diagnostic** :
```bash
# Dans le container
ping github.com
# Doit répondre

curl -I https://github.com
# Doit retourner 200 OK

ssh -T git@github.com
# Doit s'authentifier
```

**Solutions** :

**1. Problème DNS**
```bash
# Ajouter dans docker-compose.yml :
dns:
  - 8.8.8.8
  - 8.8.4.4
```

**2. Pare-feu**
```bash
# Vérifier les règles iptables
sudo iptables -L

# Autoriser Docker
sudo ufw allow from 172.17.0.0/16
```

### Débogage avancé

#### Entrer dans le container pour déboguer

```bash
# Avec un shell
docker exec -it one zsh

# Ou bash si zsh pose problème
docker exec -it one bash

# En tant que root même si le container tourne avec un autre user
docker exec -it -u root one bash
```

#### Inspecter la configuration

```bash
# Voir toute la config du container
docker inspect one

# Voir uniquement les volumes montés
docker inspect one | jq '.[0].Mounts'

# Voir les variables d'environnement
docker inspect one | jq '.[0].Config.Env'
```

#### Tester sans entrypoint

```bash
# Lancer le container avec bash au lieu de l'entrypoint
docker compose -f srcs/docker-compose.yml run --entrypoint /bin/bash one

# Exécuter manuellement les commandes de l'entrypoint
```

#### Logs détaillés

```bash
# Voir tous les logs depuis le début
docker logs one --since 2024-01-01

# Suivre les logs en temps réel
docker logs -f one

# Avec timestamps
docker logs -t one
```

### Réinitialisation complète

Si tout échoue, réinitialisation complète :

```bash
# 1. Arrêter et supprimer tout
make fclean

# 2. Supprimer les volumes Docker
docker volume prune -f

# 3. Nettoyer le système Docker
docker system prune -a --volumes

# 4. Sauvegarder puis supprimer les données VSCode
mv ~/goinfre/vscode ~/goinfre/vscode.bak
mkdir -p ~/goinfre/vscode

# 5. Rebuild complet
make re

# 6. Si ça fonctionne, supprimer la sauvegarde
# rm -rf ~/goinfre/vscode.bak
```

### Obtenir de l'aide

**Informations utiles à fournir** :
```bash
# Version Docker
docker --version
docker compose version

# Système d'exploitation
uname -a
cat /etc/os-release

# Logs du container
docker logs one > container_logs.txt

# Configuration
cat srcs/.env
cat srcs/docker-compose.yml

# Erreurs spécifiques
# Copier-coller le message d'erreur complet
```

## 📝 Notes et bonnes pratiques

### Architecture du container

#### Pourquoi root dans le container ?

Le container tourne avec l'utilisateur root pour plusieurs raisons :
- **Simplicité** : Pas de problème de permissions avec /dev/dri et /dev/snd
- **Compatibilité** : VSCode fonctionne mieux avec --no-sandbox en root
- **Isolation** : Le container est isolé, root dans le container ≠ root sur l'hôte

**Sécurité** : Les volumes sensibles (.ssh, .gitconfig) sont montés en lecture seule (:ro)

#### Choix de Ubuntu 22.04 LTS

- **Support long terme** : Maintenance jusqu'en avril 2027
- **Stabilité** : Testé et éprouvé
- **Packages récents** : GCC 11, Python 3.10, etc.
- **Large écosystème** : Beaucoup de documentation et de packages disponibles

#### Mode réseau "host"

```yaml
network_mode: "host"
```

**Avantages** :
- Pas de traduction d'adresses (NAT)
- Performances réseau maximales
- Accès direct aux services sur localhost
- Simplifie le debugging réseau

**Inconvénients** :
- Moins d'isolation réseau
- Les ports utilisés dans le container sont sur l'hôte
- Pas adapté pour plusieurs containers similaires

**Alternative** : Si vous avez besoin d'isolation réseau :
```yaml
# Remplacer network_mode: "host" par :
ports:
  - "8080:8080"  # Mapper les ports nécessaires
```

### Shell Zsh et Oh My Zsh

#### Configuration par défaut

Le container utilise :
- **Zsh** : Shell puissant avec autocomplétion avancée
- **Oh My Zsh** : Framework de configuration pour Zsh
- **Thème Bira** : Affichage élégant avec infos Git

#### Personnalisation

**Le fichier zshrc** est dans `srcs/services/code/conf/zshrc` :

```bash
# Changer le thème
ZSH_THEME="robbyrussell"  # ou agnoster, avit, etc.

# Activer des plugins
plugins=(
    git
    docker
    sudo          # ESC ESC pour préfixer avec sudo
    z             # Navigation rapide
    colored-man-pages
)

# Ajouter des alias
alias ll='ls -lah'
alias gs='git status'
alias gp='git push'
alias gc='git commit'
```

**Appliquer les changements** :
```bash
# Après modification du zshrc
make down
make build  # Nécessaire car zshrc est copié au build
make up
```

#### Plugins Oh My Zsh utiles

```bash
# Dans zshrc, section plugins
plugins=(
    git              # Alias Git
    docker           # Alias Docker
    sudo             # ESC ESC pour sudo
    command-not-found # Suggestions de packages
    z                # cd intelligent
    extract          # extract <file> pour tout décompresser
    cp               # cp avec progress bar (cpv)
    colored-man-pages # Pages man colorées
)
```

### Optimisations Docker

#### Cache des layers

Docker cache chaque instruction RUN. Pour optimiser :

**✅ Bon** :
```dockerfile
# Les choses qui changent rarement en premier
FROM ubuntu:22.04
RUN apt-get update && apt-get install -y base-packages

# Les choses qui changent souvent à la fin
COPY entrypoint.sh /
```

**❌ Mauvais** :
```dockerfile
FROM ubuntu:22.04
COPY entrypoint.sh /     # Change souvent
RUN apt-get update       # Rebuild à chaque fois
```

#### Multi-stage builds (pour aller plus loin)

Si vous voulez une image plus légère :

```dockerfile
# Stage 1: Build
FROM ubuntu:22.04 as builder
RUN apt-get update && apt-get install -y build-tools
COPY src/ /src/
RUN cd /src && make

# Stage 2: Runtime
FROM ubuntu:22.04
COPY --from=builder /src/binary /usr/local/bin/
CMD ["binary"]
```

#### Réduire la taille de l'image

```dockerfile
# Nettoyer le cache apt
RUN apt-get update && apt-get install -y packages \
    && rm -rf /var/lib/apt/lists/*

# Combiner les commandes
RUN command1 \
    && command2 \
    && command3

# Supprimer les fichiers temporaires dans la même layer
RUN download_file && extract && rm file
```

### Gestion des données

#### Volumes vs Bind Mounts

**Bind Mounts** (utilisé dans ce projet) :
```yaml
volumes:
  - "${HOME}/Documents/code:${HOME}/projets"
```
- Pointe vers un dossier existant sur l'hôte
- Modifications visibles immédiatement des deux côtés
- Bon pour le développement

**Volumes Docker** (alternative) :
```yaml
volumes:
  - vscode_data:/vscode
volumes:
  vscode_data:
```
- Géré par Docker
- Meilleure performance
- Bon pour les données qui n'ont pas besoin d'être éditées directement

#### Backup des données

**Données à sauvegarder** :
```bash
# Extensions et settings VSCode
tar -czf vscode_backup.tar.gz ~/goinfre/vscode/

# Vos projets
tar -czf projects_backup.tar.gz ~/Documents/code/

# Configuration Git (déjà versionné normalement)
cp ~/.gitconfig ~/backups/
```

**Restauration** :
```bash
# VSCode
tar -xzf vscode_backup.tar.gz -C ~/

# Projets
tar -xzf projects_backup.tar.gz -C ~/
```

### Sécurité

#### Bonnes pratiques

1. **Ne jamais commit .env dans Git**
   ```bash
   # Ajouter dans .gitignore
   srcs/.env
   *.env
   ```

2. **Utiliser .env.example pour le partage**
   ```bash
   cp srcs/.env srcs/.env.example
   # Remplacer les valeurs sensibles par des placeholders
   # Commit .env.example, pas .env
   ```

3. **Volumes en lecture seule pour les données sensibles**
   ```yaml
   volumes:
     - "${HOME}/.ssh:/root/.ssh:ro"  # :ro = read-only
   ```

4. **Ne pas exposer de ports inutiles**
   ```yaml
   # Éviter
   ports:
     - "0.0.0.0:8080:8080"  # Accessible depuis l'extérieur
   
   # Préférer
   ports:
     - "127.0.0.1:8080:8080"  # Seulement localhost
   ```

5. **Mettre à jour régulièrement l'image**
   ```bash
   # Rebuild avec dernières mises à jour
   docker compose -f srcs/docker-compose.yml build --no-cache
   ```

#### Scan de sécurité

```bash
# Scanner l'image pour des vulnérabilités (avec trivy)
docker run --rm -v /var/run/docker.sock:/var/run/docker.sock \
    aquasec/trivy image one:1.0
```

### Performance

#### Optimiser les builds

```bash
# Utiliser BuildKit (plus rapide)
export DOCKER_BUILDKIT=1
docker compose build

# Build en parallèle
docker compose build --parallel

# Utiliser un cache externe
docker buildx build --cache-to type=local,dest=/tmp/cache \
                    --cache-from type=local,src=/tmp/cache
```

#### Monitorer les ressources

```bash
# Stats en temps réel
docker stats one

# Limiter les ressources
# Dans docker-compose.yml :
services:
  one:
    deploy:
      resources:
        limits:
          cpus: '2.0'
          memory: 4G
        reservations:
          cpus: '1.0'
          memory: 2G
```

### Développement collaboratif

#### Partager le projet

**Structure Git recommandée** :
```
.
├── .gitignore           # Ignorer .env, binaires, etc.
├── .env.example         # Template des variables
├── README.md
├── makefile
└── srcs/
    ├── .env            # Git ignoré, personnel
    └── ...
```

**.gitignore** :
```gitignore
# Environment
.env
*.env

# Builds
*.o
*.out
*.exe

# VSCode local
.vscode/
!.vscode/settings.json  # Partager les settings projet

# OS
.DS_Store
Thumbs.db
```

#### Convention de commit

```bash
# Format recommandé : type(scope): message

# Types courants :
feat: nouvelle fonctionnalité
fix: correction de bug
docs: documentation
style: formatage (pas de changement de code)
refactor: refactorisation
test: ajout de tests
chore: maintenance (dépendances, config)

# Exemples :
git commit -m "feat(docker): add SDL2 mixer support"
git commit -m "fix(entrypoint): correct project cloning logic"
git commit -m "docs(readme): add troubleshooting section"
git commit -m "chore(deps): update to Ubuntu 24.04"
```

### Évolutions futures possibles

#### Ajouter d'autres langages

```dockerfile
# Python
RUN apt-get install -y python3 python3-pip

# Node.js
RUN curl -fsSL https://deb.nodesource.com/setup_20.x | bash -
RUN apt-get install -y nodejs

# Rust
RUN curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh -s -- -y
```

#### Ajouter des services supplémentaires

```yaml
# Dans docker-compose.yml
services:
  one:
    # ... configuration existante
  
  database:
    image: postgres:15
    environment:
      POSTGRES_PASSWORD: password
    volumes:
      - db_data:/var/lib/postgresql/data
  
  redis:
    image: redis:7-alpine
```

#### Déploiement distant

```bash
# Avec Docker Context
docker context create remote --docker "host=ssh://user@server"
docker context use remote
docker compose up -d

# Ou avec Docker Machine
docker-machine create --driver generic --generic-ip-address=X.X.X.X remote
eval $(docker-machine env remote)
docker compose up -d
```

### Ressources utiles

#### Documentation officielle

- **Docker** : https://docs.docker.com/
- **Docker Compose** : https://docs.docker.com/compose/
- **VSCode** : https://code.visualstudio.com/docs
- **SDL2** : https://wiki.libsdl.org/

#### Communauté

- **Docker Forum** : https://forums.docker.com/
- **Stack Overflow** : Tag [docker], [docker-compose], [vscode]
- **Reddit** : r/docker, r/vscode

#### Tutoriels recommandés

- **Docker Best Practices** : https://docs.docker.com/develop/dev-best-practices/
- **Dockerfile Best Practices** : https://docs.docker.com/develop/develop-images/dockerfile_best-practices/
- **SDL2 Tutorials** : http://lazyfoo.net/tutorials/SDL/

---

**Note sur les polices et emojis** : Le container inclut `fonts-noto-color-emoji` pour un support complet des emojis dans le terminal et VSCode. La configuration UTF-8 est activée par défaut dans le `.zshrc`.

**Note sur les performances X11** : Pour de meilleures performances graphiques, assurez-vous que votre pilote GPU est à jour sur l'hôte et que `/dev/dri` est correctement accessible.

## 📄 Licence

Ce projet est un environnement de développement personnel et éducatif. Utilisez-le et modifiez-le selon vos besoins.

### Composants tiers

Ce projet utilise et distribue les composants open source suivants :
- **Ubuntu** : Canonical Ltd. (GPLv2)
- **Docker** : Docker Inc. (Apache 2.0)
- **VSCode** : Microsoft (MIT License)
- **SDL2** : Simple DirectMedia Layer (zlib License)
- **Zsh** : Zsh Development Group (MIT-like)
- **Oh My Zsh** : Oh My Zsh Community (MIT License)

## 🤝 Contribution

### Comment contribuer

Pour ajouter des fonctionnalités ou améliorer l'environnement :

1. **Fork** le projet
2. **Créez une branche** pour votre fonctionnalité
   ```bash
   git checkout -b feature/amazing-feature
   ```
3. **Testez** vos modifications
   ```bash
   make re
   # Vérifier que tout fonctionne
   ```
4. **Commitez** vos changements
   ```bash
   git commit -m "feat: add amazing feature"
   ```
5. **Push** vers votre fork
   ```bash
   git push origin feature/amazing-feature
   ```
6. **Ouvrez une Pull Request** avec une description détaillée

### Idées de contributions

- ✨ Ajouter le support de nouveaux langages (Python, Rust, Go)
- 📦 Créer des variants (web dev, data science, etc.)
- 🐛 Corriger des bugs ou améliorer la documentation
- 🎨 Améliorer la configuration Zsh/VSCode
- 🔧 Optimiser les performances Docker
- 📚 Ajouter des tutoriels et exemples
- 🛡️ Renforcer la sécurité

### Guidelines de contribution

- **Code** : Suivre les conventions Docker et Shell existantes
- **Commits** : Utiliser les conventional commits (feat:, fix:, docs:, etc.)
- **Documentation** : Mettre à jour le README pour les nouvelles fonctionnalités
- **Tests** : S'assurer que `make re` fonctionne sans erreur

## 📞 Support et Contact

### Problèmes et questions

- **Issues GitHub** : Ouvrez une issue pour reporter un bug ou suggérer une amélioration
- **Discussions** : Utilisez les discussions GitHub pour poser des questions

### Avant de demander de l'aide

1. Consultez la section [🐛 Dépannage](#-dépannage-et-résolution-de-problèmes)
2. Vérifiez les [issues existantes](../../issues)
3. Essayez `make fclean && make re`
4. Lisez les logs : `docker logs one`

### Format pour reporter un bug

```markdown
**Environnement :**
- OS : [Ubuntu 22.04 / Fedora 38 / etc.]
- Docker : [version]
- Docker Compose : [version]

**Description du problème :**
[Description claire et concise]

**Étapes pour reproduire :**
1. ...
2. ...
3. ...

**Comportement attendu :**
[Ce qui devrait se passer]

**Comportement actuel :**
[Ce qui se passe réellement]

**Logs :**
```
[Coller les logs pertinents]
```

**Configuration .env :**
```
[Coller votre .env sans les infos sensibles]
```
```

## 🎓 Remerciements

- **École 42** pour l'inspiration de l'architecture de développement containerisée
- **Communauté Docker** pour l'excellent écosystème d'outils
- **Microsoft** pour VSCode et son extensibilité
- **SDL Team** pour la bibliothèque multimédia cross-platform
- **Oh My Zsh community** pour le framework de configuration Zsh

## 📚 Ressources additionnelles

### Documentation complète

- 📖 **[Guide d'installation détaillé](docs/INSTALLATION.md)** (à créer)
- 🔧 **[Configuration avancée](docs/ADVANCED.md)** (à créer)
- 🎮 **[Tutoriel SDL2](docs/SDL2_TUTORIAL.md)** (à créer)
- 🐳 **[Dockerfile expliqué](docs/DOCKERFILE.md)** (à créer)

### Exemples de projets

```bash
# Cloner des exemples (à créer)
git clone https://github.com/votre-repo/docker-vscode-examples
cd docker-vscode-examples/sdl2-game
```

### Variantes du projet

- **Version Python** : Ajout de Python 3, pip, virtualenv
- **Version Web** : Ajout de Node.js, npm, frameworks web
- **Version Data Science** : Jupyter, numpy, pandas, matplotlib
- **Version minimaliste** : Sans SDL2, optimisée pour taille minimale

---

## 📊 Statistiques du projet

**Image Docker** :
- Taille : ~2 GB (avec VSCode et SDL2)
- Temps de build initial : 5-15 minutes
- Langages supportés : C, C++, Shell
- Packages installés : ~150+

**Composants principaux** :
- Ubuntu 22.04 LTS
- VSCode (latest stable)
- GCC/G++ 11.x
- SDL2 2.x
- Zsh + Oh My Zsh

---

<div align="center">

**Bon développement ! 🚀**

Si ce projet vous a été utile, n'hésitez pas à lui donner une ⭐

</div>
