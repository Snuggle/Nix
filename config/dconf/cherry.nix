# Generated via dconf2nix: https://github.com/gvolpe/dconf2nix
{ lib, ... }:

with lib.hm.gvariant;

{
  dconf.settings = {
    "org/gnome/desktop/background" = {
      picture-options = "zoom";
      picture-uri = builtins.toString ../../hosts + "/cherry/cherry.png";
      picture-uri-dark = builtins.toString ../../hosts + "/cherry/cherry.png";
      primary-color = "#fe9393";
      secondary-color = "#fe9393";
    };
  };
}
