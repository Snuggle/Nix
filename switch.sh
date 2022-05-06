#!/usr/bin/env bash
bold=$(tput bold)
normal=$(tput sgr0)

echo "${bold}⚗️ Testing Configuratinon ${normal}"
#hyperfine --export-markdown /etc/nixos/measure.md --runs 3 "nixos-rebuild dry-activate"
case "$OSTYPE" in
  darwin*)  darwin-rebuild --dry-run build ;; 
  linux*)   nixos-rebuild dry-build ;;
  *)        echo "unknown: $OSTYPE" ;;
esac
>>>>>>> 9f187dc (💚 Remove sha256 which keeps breaking CI build)
if [ $? -eq 0 ]; then
	echo "🔨 Rebuilding Configuration…"
	case "$OSTYPE" in
	  darwin*)  darwin-rebuild switch --max-jobs 4 ;; 
	  linux*)   sudo nixos-rebuild switch --upgrade --max-jobs 16 ;;
	  *)        echo "unknown: $OSTYPE" ;;
	esac
	if [ $? -eq 0 ]; then
		echo "❄️ Done! NixOS is Now Running Generation $(sudo nix-env --list-generations --profile /nix/var/nix/profiles/system | grep current | awk '{print $1}')."
	fi
else 
	echo "🚨 Could Not Build Configuration…"
fi
