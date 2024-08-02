#!/usr/bin/env bash
# Originally from https://github.com/gvolpe/nix-config

set +x

build_ci_system() {
	export NIX_BUILD_VERSION=22.11
    echo "$1"
    if [[ $1 == "nixos-stable" ]]; then
      build_nixos_stable_system
    elif [[ $1 == "nixos-unstable" ]]; then
      build_nixos_unstable_system
    elif [[ $1 == "darwin-unstable" ]]; then
      build_darwin_unstable_system
    elif [[ $1 == "darwin-stable" ]]; then
      build_darwin_stable_system
    else
      echo "Unknown option!"
    fi
}

build_nixos_unstable_system() {
  echo "🔨 Building nixos_unstable"
  echo $NIX_PATH
  sudo nix-channel --add https://nixos.org/channels/nixos-unstable nixos
  sudo nix-channel --add https://github.com/nix-community/home-manager/archive/master.tar.gz home-manager
  sudo nix-channel --update
  ./switch
  sed -i 's/boot.kernelPackages = pkgs.linuxPackages_zen;//g' hardware-configuration.nix
  echo  "🧪 Testing system configuration…"
  NIX_PATH=/home/$USER/.nix-defexpr/channels:nixpkgs=channel:nixos-unstable nix-build '<nixpkgs/nixos>' \
        -I nixos-config=configuration.nix \
        -A system --dry-run
}

build_nixos_stable_system() {
  echo "🔨 Building nixos_stable"
  echo $NIX_PATH
  sudo nix-channel --add https://nixos.org/channels/nixos-$NIX_BUILD_VERSION nixos
  sudo nix-channel --add https://github.com/nix-community/home-manager/archive/release-$NIX_BUILD_VERSION.tar.gz home-manager
  sudo nix-channel --update
  ./switch
  sed -i 's/boot.kernelPackages = pkgs.linuxPackages_zen;//g' hardware-configuration.nix
  echo "🧪 Testing system configuration…"
  NIX_PATH=/home/$USER/.nix-defexpr/channels:nixpkgs=channel:nixos-$NIX_BUILD_VERSION nix-build '<nixpkgs/nixos>' \
        -I nixos-config=configuration.nix \
        -A system --dry-run
}

build_darwin_unstable_system() {
  echo "🔨 Building darwin_unstable"
  sudo nix-channel --add http://nixos.org/channels/nixpkgs-unstable nixpkgs
  sudo nix-channel --add https://github.com/nix-community/home-manager/archive/master.tar.gz home-manager
  sudo nix-channel --update
  ./switch
  echo "🧪 Testing system configuration…"
  source /etc/static/bashrc
  darwin-rebuild build --dry-run
  darwin-rebuild check --dry-run
}

build_darwin_stable_system() {
  echo "🔨 Building darwin_stable"
  sudo nix-channel --add http://nixos.org/channels/nixpkgs-$NIX_BUILD_VERSION-darwin nixpkgs
  sudo nix-channel --add https://github.com/nix-community/home-manager/archive/release-$NIX_BUILD_VERSION.tar.gz home-manager
  sudo nix-channel --update
  ./switch
  echo "🧪 Testing system configuration…"
  source /etc/static/bashrc
  darwin-rebuild build --dry-run
  darwin-rebuild check --dry-run
}

build_ci_system $@
