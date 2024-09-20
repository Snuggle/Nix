# Generated via dconf2nix: https://github.com/gvolpe/dconf2nix
{ lib, ... }:

with lib.hm.gvariant;

{
  dconf.settings = {
    "org/gnome/desktop/background" = {
      picture-options = "zoom";
      picture-uri = builtins.toString ../../hosts + "/pineapple/pineapple.png";
      picture-uri-dark = builtins.toString ../../hosts + "/pineapple/pineapple.png";
      primary-color = "#ffffff";
      secondary-color = "#000000";
    };
  };
}
