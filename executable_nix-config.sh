#!/bin/sh

cp -r /etc/nixos/ /tmp/
$EDITOR /tmp/nixos/configuration.nix
if ! command -v nixfmt &> /dev/null
then
    echo "nixfmt could not be found. Install nixfmt to format your config."
else
  nixfmt /tmp/nixos/configuration.nix &>/dev/null \
    || ( nixfmt /tmp/nixos/configuration.nix; echo "Reformatting failed!" && exit 1)
fi

if cmp -s /etc/nixos/configuration.nix /tmp/nixos/configuration.nix; then
  echo "No changes. Exiting..."
else
  echo "Changes detected."
  diff --color=auto -U0 /etc/nixos/configuration.nix /tmp/nixos/configuration.nix
  cp /etc/nixos/configuration.nix /tmp/nixos/configuration.$(date +%s).nix
  echo "Writing to /etc/nixos/configuration.nix..."
  sudo cp /tmp/nixos/configuration.nix /etc/nixos/configuration.nix && echo "New config written to /etc/nixos/configuration.nix" \
  && read -p "Run nixos-rebuild? (Y/n): " confirm \
  && if [[ $confirm == "" || $confirm == [yY] ]]; then
    sudo nixos-rebuild switch
  fi
fi
