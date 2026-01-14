#! /bin/bash

sudo chown -R ballain:ballain /workspace
code --wait --no-sandbox --password-store=basic --user-data-dir=/workspace/.vscode/user-data --extensions-dir=/workspace/.vscode/extensions .