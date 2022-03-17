# Generated via dconf2nix: https://github.com/gvolpe/dconf2nix
{ lib, ... }:

with lib.hm.gvariant;

{
  dconf.settings = {

    "org/gnome/desktop/input-sources" = {
      sources = [ (mkTuple [ "xkb" "us" ]) ];
      xkb-options = [ "ctrl:swap_lwin_lctl" "ctrl:swap_rwin_rctl" "compose:caps" "caps:none" ];
    };

    "org/gnome/desktop/interface" = {
      cursor-theme = "Breeze_Snow";
      font-antialiasing = "grayscale";
      font-hinting = "slight";
      gtk-im-module = "gtk-im-context-simple";
      gtk-theme = "Yaru-dark";
      icon-theme = "Papirus";
    };

    "org/gnome/shell" = {
      favorite-apps = [ "firefox.desktop" "org.gnome.Calendar.desktop" "org.gnome.Music.desktop" "org.gnome.Photos.desktop" "org.gnome.Nautilus.desktop" "code.desktop" "discord.desktop" "steam.desktop" "obsidian.desktop" "com.obsproject.Studio.desktop" "1password.desktop" ];
    };

    "system/locale" = {
      region = "en_GB.UTF-8";
    };

    "org/gnome/desktop/peripherals/mouse" = {
      accel-profile = "flat";
      natural-scroll = true;
    };

    "org/gnome/mutter" = {
      workspaces-only-on-primary = false;
    };

    "org/gnome/desktop/wm/preferences" = {
      button-layout = "appmenu:minimize,maximize,close";
      resize-with-right-button = true;
    };

    "org/gnome/shell/weather" = {
      automatic-location = true;
    };
  };
}
