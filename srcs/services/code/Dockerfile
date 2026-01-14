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
    fonts-noto-color-emoji \
    fonts-symbola \
    fonts-noto \
    fonts-noto-cjk \
    # Locales pour UTF-8
    locales \
    zsh

# Configuration des locales pour le support UTF-8 et emojis
RUN locale-gen en_US.UTF-8 && \
    update-locale LANG=en_US.UTF-8 LC_ALL=en_US.UTF-8

# Téléchargement et installation de VSCode
RUN wget -qO /tmp/vscode.deb 'https://code.visualstudio.com/sha/download?build=stable&os=linux-deb-x64'
RUN apt-get install -y /tmp/vscode.deb
RUN rm /tmp/vscode.deb
RUN rm -rf /var/lib/apt/lists/*
RUN mkdir -p /workspace/.vscode /workspace/projets

COPY ./conf/zshrc /root/.zshrc
COPY ./tools/entrypoint.sh /entrypoint.sh
RUN chmod +x /entrypoint.sh
# RUN chsh -s $(which zsh) root

# Créer le répertoire de travail
WORKDIR /workspace/projets

# Commande par défaut : lancer VSCode
ENTRYPOINT ["/entrypoint.sh"]
# CMD ["/home/$USER_NAME/projets"]