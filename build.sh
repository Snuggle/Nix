#!/usr/bin/env bash
# Originally from https://github.com/gvolpe/nix-config

set +x

build_ci_system() {
  if [[ "$OSTYPE" == "linux-gnu"* ]]; then
    nix-channel --add https://nixos.org/channels/nixos-unstable nixos
    cmd="
      nix-build-uncached '<nixpkgs/nixos>' \
        -I nixos-config=configuration.nix \
        -A system
    "
    nix-shell -p nix-build-uncached --run "$cmd"
  elif [[ "$OSTYPE" == "darwin"* ]]; then
    build_darwin_system
  else 
    echo "Unknown system/OS?"
  fi
}

build_darwin_system() {
  nix-build https://github.com/LnL7/nix-darwin/archive/master.tar.gz -A installer
  ./result/bin/darwin-installer
  nix-channel --add https://github.com/nix-community/home-manager/archive/master.tar.gz home-manager
  nix-channel --update
  darwin-rebuild build
  darwin-rebuild check
}

build_ci_system
