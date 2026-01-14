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
    zsh

# RUN sh -c "$(curl -yfsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"

# Téléchargement et installation de VSCode
RUN wget -qO /tmp/vscode.deb 'https://code.visualstudio.com/sha/download?build=stable&os=linux-deb-x64'
RUN apt-get install -y /tmp/vscode.deb
RUN rm /tmp/vscode.deb
RUN rm -rf /var/lib/apt/lists/*
RUN mkdir -p /workspace/.vscode /workspace/projets

# Créer le répertoire de travail
WORKDIR /workspace/projets

# Commande par défaut : lancer VSCode
ENTRYPOINT ["code", "--wait", "--no-sandbox", "--password-store=basic", "--user-data-dir=/workspace/.vscode/user-data", "--extensions-dir=/workspace/.vscode/extensions", "."]
# CMD ["/home/$USER_NAME/projets"]