#!/usr/bin/env bash
# Originally from https://github.com/gvolpe/nix-config

set +x

build_ci_system() {
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
  nix-channel --add https://nixos.org/channels/nixos-unstable nixos
  cmd="
    nix-build-uncached '<nixpkgs/nixos>' \
      -I nixos-config=configuration.nix \
      -A system --dry-run
  "
  
  sed -i 's/"nvidia"//g' hardware-configuration.nix
  sed -i 's/boot.kernelPackages = pkgs.linuxPackages_zen;//g' hardware-configuration.nix
  echo  "🧪 Testing system configuration…"
  nix-shell -p nix-build --run "$cmd" --dry-run
}

build_nixos_stable_system() {
  echo "🔨 Building nixos_stable"
  nix-channel --add https://nixos.org/channels/nixos-22.05 nixos
  cmd="
    nix-build '<nixpkgs/nixos>' \
      -I nixos-config=configuration.nix \
      -A system --dry-run
  "
  
  sed -i 's/"nvidia"//g' hardware-configuration.nix
  sed -i 's/boot.kernelPackages = pkgs.linuxPackages_zen;//g' hardware-configuration.nix
  echo "🧪 Testing system configuration…"
  nix-shell -p nix-build --run "$cmd" --dry-run
}

build_darwin_unstable_system() {
  echo "🔨 Building darwin_unstable"
  nix-channel --add http://nixos.org/channels/nixpkgs-unstable nixpkgs
  nix-channel --update
  ./macos_setup.sh
  echo "🧪 Testing system configuration…"
  source /etc/static/bashrc
  darwin-rebuild build --dry-run
  darwin-rebuild check --dry-run
}

build_darwin_stable_system() {
  echo "🔨 Building darwin_stable"
  nix-channel --add http://nixos.org/channels/nixpkgs-22.05-darwin nixpkgs
  nix-channel --update
  ./macos_setup.sh
  echo "🧪 Testing system configuration…"
  source /etc/static/bashrc
  darwin-rebuild build --dry-run
  darwin-rebuild check --dry-run
}

build_ci_system $@
