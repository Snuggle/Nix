#!/usr/bin/env bash
echo "❄️ Installing Nix…"
sh <(curl -L https://nixos.org/nix/install)
echo "❄️ Nix is installed! Press ENTER to install nix-darwin."
echo "🍎 Installing nix-darwin…"
source /etc/profile
nix-build https://github.com/LnL7/nix-darwin/archive/master.tar.gz -A installer
./result/bin/darwin-installer
echo "🍎 nix-darwin is installed! Press ENTER to install home-manager."
echo "🏚 Installing home-manager…"
nix-channel --add https://github.com/nix-community/home-manager/archive/master.tar.gz home-manager
nix-channel --update
source /etc/static/bashrc
echo "🏠 home-manager is installed!"
echo "⬇️ Cloning system config into ~/.nixpkgs…"
rm -rv ~/.nixpkgs
git clone https://github.com/Snuggle/NixOS ~/.nixpkgs
echo "☃️ Nix on macOS install complete!"
