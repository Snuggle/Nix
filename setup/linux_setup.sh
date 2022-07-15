#!/usr/bin/env bash
echo "❄️ Installing Nix…"
sh <(curl -L https://nixos.org/nix/install) --daemon
echo "❄️ Nix is installed!"
