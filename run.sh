#!/bin/bash
# Fichier: run-vscode-sdl.sh (VERSION AMÉLIORÉE)

echo "🚀 Lancement du container VSCode + SDL..."
echo ""

# Créer le dossier projets s'il n'existe pas
mkdir -p $HOME/projets

# Autoriser Docker à se connecter à X11
echo "🔓 Autorisation X11..."
xhost +local:docker > /dev/null 2>&1

echo "📦 Démarrage du container..."
echo ""
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo "  Commandes utiles dans le container :"
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo "  📝 Lancer VSCode:  code --no-sandbox ."
echo "  🎮 Compiler SDL:   gcc main.c -o jeu -lSDL2"
echo "  📂 Aller projets:  cd /workspace"
echo "  🚪 Quitter:        exit"
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo ""

# Lancer le container avec bash interactif
docker run -it \
    --name one \
    -e DISPLAY=$DISPLAY \
    -v /tmp/.X11-unix:/tmp/.X11-unix \
    -v /home/ballain/Documents/AllInOne:/workspace \
    --device /dev/snd \
    --device /dev/dri \
    --group-add audio \
    --group-add video \
    one:1.0

# Après fermeture
echo ""
echo "🔒 Révocation de l'autorisation X11..."
xhost -local:docker > /dev/null 2>&1
echo "✅ Container fermé proprement !"
echo ""