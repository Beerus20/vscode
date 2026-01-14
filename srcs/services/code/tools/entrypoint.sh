#! /bin/bash

set -e

PROJECT_DIR="."

if [ -n "$PROJECT_REPO" ]; then
	if [ -n "$PROJECT_NAME" ]; then
		PROJECT_DIR="$HOME/$PROJECT_NAME"
	else
		PROJECT_DIR="$HOME/$(basename $PROJECT_REPO .git)"
	fi
	echo "Cloning $PROJECT_REPO into $PROJECT_DIR"
	git clone git@github.com:$PROJECT_REPO "$PROJECT_DIR"
else
	PROJECT_DIR="$HOME/projets"
fi

if [ -f /tmp/.zshrc ]; then
  mv /tmp/.zshrc $HOME/.zshrc
fi

chsh -s $(which zsh) root
echo "Starting VSCode..."
code \
	--wait \
	--no-sandbox \
	--password-store=basic \
	--user-data-dir=$HOME/.vscode/user-data \
	--extensions-dir=$HOME/.vscode/extensions \
	$PROJECT_DIR