#!/usr/bin/env bash
echo "❄️ Installing Nix…"
source /etc/lsb-release
if [ "$DISTRIBID" == "nixos" ]; then
	rm -rfv /etc/nixos/
	git clone https://github.com/Snuggle/NixOS /etc/nixos
	cd /etc/nixos
	git remote remove origin
	git remote add origin git@github.com:Snuggle/nixos
else
	rm -rfv ~/.nixpkgs
	git clone https://github.com/Snuggle/NixOS ~/.nixpkgs
	cd ~/.nixpkgs
	git remote remove origin
	git remote add origin git@github.com:Snuggle/nixos
	sh <(curl -L https://nixos.org/nix/install) --daemon
fi
sh <(curl -L https://nixos.org/nix/install) --daemon
echo "❄️ Nix is installed!"
echo "🏚 Installing home-manager…"
nix-channel --add https://github.com/nix-community/home-manager/archive/master.tar.gz home-manager
sudo nix-channel --add https://github.com/nix-community/home-manager/archive/master.tar.gz home-manager
nix-channel --update
source /etc/static/bashrc
echo "🏠 home-manager is installed!"
