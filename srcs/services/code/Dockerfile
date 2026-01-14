# Image de base Ubuntu
FROM ubuntu:22.04

# Éviter les questions interactives pendant l'installation
ENV DEBIAN_FRONTEND=noninteractive

# Mise à jour et installation des dépendances
RUN apt-get update && apt-get install -y \
    # Bibliothèques X11 pour l'affichage
    libx11-6 \
    libxext6 \
    libxrender1 \
    libxtst6 \
    libxi6 \
    libxrandr2 \
    libxcursor1 \
    libxdamage1 \
    libxfixes3 \
    libxcomposite1 \
    # Outils système
    wget \
    curl \
    ca-certificates \
    git \
    # SDL2 et ses extensions
    libsdl2-dev \
    libsdl2-image-dev \
    libsdl2-ttf-dev \
    libsdl2-mixer-dev \
    # Compilateurs
    gcc \
    g++ \
    make \
    # Polices
    fonts-liberation \
    && rm -rf /var/lib/apt/lists/*

# Téléchargement et installation de VSCode
RUN wget -qO /tmp/vscode.deb 'https://code.visualstudio.com/sha/download?build=stable&os=linux-deb-x64'
RUN apt-get update
RUN apt-get install -y /tmp/vscode.deb
RUN rm /tmp/vscode.deb
RUN rm -rf /var/lib/apt/lists/*

# Créer le répertoire de travail
WORKDIR /workspace

# Commande par défaut : lancer VSCode
ENTRYPOINT ["code", "--wait", "--no-sandbox", "--user-data-dir=/workspace/.vscode-data", "--verbose"]