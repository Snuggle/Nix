# This is a hacky workaround for the Discord desktop app tray icons being
# blurry. It adds a script to the top of the app's wrapper script that unpacks
# `core.asar` (the archive containing the icons), replaces the 24x24 icons with
# 128x128 ones from the Papirus icon theme, and repacks everything. The sha256
# of the patched `core.asar` is saved in `core.asar.sha256` and checked when the
# script is run again to avoid repeated work.
#
# Comparison: https://i.imgur.com/SBGJlzX.png
#
# It should work with discord, discord-ptb, and discord-canary.
#
# Because of the way Discord works, every once in a while there will be an
# update and the desktop app will re-download `core.asar`. This means that the
# tray icons will be blurry until the app is restarted, but this is a rare
# enough occurrence and the fix is simple enough that it did not seem worth the
# trouble to find a solution.
#
#  Author: InternetUnexplorer
# License: CC0

{ config, pkgs, lib, ... }:

let
  tray-icons = pkgs.runCommandNoCC "discord-tray-icons" { } ''
    ICON_THEME="${pkgs.papirus-icon-theme}/share/icons/Papirus-Dark"
    ICON_SVG_SIZE=16
    ICON_PNG_SIZE=128

    ICONS=("tray"
           "tray-connected"
           "tray-deafened"
           "tray-muted"
           "tray-speaking"
           "tray-unread")

    mkdir -p $out

    icon_dir="$ICON_THEME/''${ICON_SVG_SIZE}x''${ICON_SVG_SIZE}/panel"
    for icon in "''${ICONS[@]}"; do
      ${pkgs.librsvg}/bin/rsvg-convert \
        -w $ICON_PNG_SIZE              \
        -h $ICON_PNG_SIZE              \
        -f png                         \
        "$icon_dir/discord-$icon.svg"  \
        > "$out/$icon.png"
    done
  '';

  fix-tray-icons = pkgs.writers.writeBash "fix-discord-tray-icons" ''
    set -euo pipefail
    shopt -s nullglob

    patch_asar_file() {
      unpacked="$(mktemp -d)"
      ${pkgs.nodePackages.asar}/bin/asar extract "$1" "$unpacked"
      cp ${tray-icons}/* "$unpacked/app/images/systemtray/linux/"
      ${pkgs.nodePackages.asar}/bin/asar pack "$unpacked" "$1"
      rm -r "$unpacked"
    }

    config_dir="''${XDG_CONFIG_HOME:-$HOME/.config}"/''${1//-/}

    [ -d "$config_dir" ] || exit 0

    for module_dir in "$config_dir"/*/modules/discord_desktop_core; do
      cd "$module_dir"

      ! sha256sum --status --check core.asar.sha256 2> /dev/null || continue

      echo "(fix-tray-icons) Patching tray icons in '$module_dir/core.asar'..."
      patch_asar_file core.asar
      sha256sum core.asar > core.asar.sha256
    done
  '';

  inject-tray-icon-fix = pkg:
    pkgs.symlinkJoin {
      inherit (pkg) name;
      paths = [ pkg ];
      postBuild = ''
        sed -i '2i ${fix-tray-icons} ${pkg.pname}' $out/opt/Discord/Discord
      '';
    };

in { environment.systemPackages = [ (inject-tray-icon-fix pkgs.discord) ]; }
