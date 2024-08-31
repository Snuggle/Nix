#!/usr/bin/env bash
# Originally from https://github.com/gvolpe/nix-config

set +x

build_ci_system() {
	export NIX_BUILD_VERSION=22.11
    echo "$1"
    if [[ $1 == "cherry" ]]; then
      build_cherry_system
    else
      echo "Unknown option!"
    fi
}

build_cherry_system() {
  echo "🔨 Building cherry"
  echo $NIX_PATH
  sudo nix-channel --add https://nixos.org/channels/nixos-unstable nixos
  sudo nix-channel --add https://github.com/nix-community/home-manager/archive/master.tar.gz home-manager
  sudo nix-channel --update

  echo  "🧪 Testing system configuration…"
  #NIX_PATH=/home/$USER/.nix-defexpr/channels:nixpkgs=channel:nixos-unstable nix-build '<nixpkgs/nixos>' \
  #      -I nixos-config=configuration.nix \
  #      -A system --dry-run
  nix build --dry-run --experimental-features 'nix-command flakes' '.#nixosConfigurations.cherry.config.system.build.toplevel'
}

build_ci_system $@