#! /bin/bash

sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" "" --unattended
cp /root/.zshrc $HOME/.zshrc
chsh -s $(which zsh) root
code --wait --no-sandbox --password-store=basic --user-data-dir=/workspace/.vscode/user-data --extensions-dir=/workspace/.vscode/extensions .