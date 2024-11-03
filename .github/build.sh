#!/usr/bin/env bash
# Originally from https://github.com/gvolpe/nix-config

set +x

build_ci_system() {
	export NIX_BUILD_VERSION=22.11
    echo "$1"
    if [[ $1 == "cherry" ]]; then
      build_cherry_system
    elif [[ $1 == "pineapple" ]]; then
      build_pineapple_system
    elif [[ $1 == "snuggle@pineapple" ]]; then
      build_pineapple_home
    elif [[ $1 == "snuggle@cherry" ]]; then
      build_cherry_home
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
  nix build --dry-run --impure --experimental-features 'nix-command flakes' '.#nixosConfigurations.cherry.config.system.build.toplevel'
}

build_pineapple_system() {
  echo "🔨 Building pineapple"
  echo $NIX_PATH
  sudo nix-channel --add https://nixos.org/channels/nixos-unstable nixos
  sudo nix-channel --add https://github.com/nix-community/home-manager/archive/master.tar.gz home-manager
  sudo nix-channel --update

  echo  "🧪 Testing system configuration…"
  #NIX_PATH=/home/$USER/.nix-defexpr/channels:nixpkgs=channel:nixos-unstable nix-build '<nixpkgs/nixos>' \
  #      -I nixos-config=configuration.nix \
  #      -A system --dry-run
  nix build --dry-run --impure --experimental-features 'nix-command flakes' '.#nixosConfigurations.pineapple.config.system.build.toplevel'
}

build_pineapple_home() {
  echo "🔨 Building snuggle@pineapple home-manager"
  echo $NIX_PATH
  sudo nix-channel --add https://nixos.org/channels/nixos-unstable nixos
  sudo nix-channel --add https://github.com/nix-community/home-manager/archive/master.tar.gz home-manager
  sudo nix-channel --update

  echo  "🧪 Testing system configuration…"
  #NIX_PATH=/home/$USER/.nix-defexpr/channels:nixpkgs=channel:nixos-unstable nix-build '<nixpkgs/nixos>' \
  #      -I nixos-config=configuration.nix \
  #      -A system --dry-run
  nix-shell -p home-manager --command "home-manager --experimental-features 'nix-command flakes' --impure build --flake .#snuggle@pineapple"
}

build_cherry_home() {
  echo "🔨 Building snuggle@cherry home-manager"
  echo $NIX_PATH
  sudo nix-channel --add https://nixos.org/channels/nixos-unstable nixos
  sudo nix-channel --add https://github.com/nix-community/home-manager/archive/master.tar.gz home-manager
  sudo nix-channel --update

  echo  "🧪 Testing system configuration…"
  #NIX_PATH=/home/$USER/.nix-defexpr/channels:nixpkgs=channel:nixos-unstable nix-build '<nixpkgs/nixos>' \
  #      -I nixos-config=configuration.nix \
  #      -A system --dry-run
  nix-shell -p home-manager --command "home-manager --experimental-features 'nix-command flakes' build --impure --flake .#snuggle@cherry"
}

build_ci_system $@
