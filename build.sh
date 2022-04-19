# Originally from https://github.com/gvolpe/nix-config

build_ci_system() {
  cmd="
    nix-build-uncached '<nixpkgs/nixos>' \
      -I nixos-config=system/configuration.nix \
      -A system
  "
  nix-shell -p nix-build-uncached --run "$cmd"
}

build_ci_system
