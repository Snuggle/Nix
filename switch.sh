#!/usr/bin/env bash
bold=$(tput bold)
normal=$(tput sgr0)

echo "${bold}⚗️ Testing Configuratinon ${normal}"
#hyperfine --export-markdown /etc/nixos/measure.md --runs 3 "nixos-rebuild dry-activate"
nixos-rebuild dry-build
if [ $? -eq 0 ]; then
	echo "🔨 Rebuilding Configuration…"
	sudo nixos-rebuild switch --upgrade --max-jobs 16
	if [ $? -eq 0 ]; then
		echo "❄️ Done! NixOS is Now Running Generation $(sudo nix-env --list-generations --profile /nix/var/nix/profiles/system | grep current | awk '{print $1}')."
	fi
else 
	echo "🚨 Could Not Build Configuration…"
	nixos-rebuild dry-activate
fi
