# Generated via dconf2nix: https://github.com/gvolpe/dconf2nix
{ lib, osConfig, ... }:

with lib.hm.gvariant;

{
  dconf.settings = {

    #"org/gnome/desktop/input-sources" = {
    #  sources = [ (mkTuple [ "xkb" "us" ]) ];
    #  xkb-options = [ "ctrl:swap_lwin_lctl" "ctrl:swap_rwin_rctl" "compose:caps" "caps:none" ];
    #};

    "org/gnome/desktop/interface" = {
      cursor-theme = "Breeze_Snow";
      document-font-name = "Source Sans 3 11";
      font-name = "Source Sans 3 Light 11";
      gtk-theme = "Yaru-dark";
      icon-theme = "Papirus";
      monospace-font-name = "Fantasque Sans Mono 10";
    };

    "org/gnome/shell/extensions/user-theme" = {
      name = "Yaru-magenta-dark";
    };

    "org/gnome/desktop/background" = {
      picture-options = "zoom";
      picture-uri = builtins.toString ../../hosts + "/$hostname/$hostname.png";
      picture-uri-dark = builtins.toString ../../hosts + "/$hostname/$hostname.png";
      primary-color = "#ffffff";
      secondary-color = "#000000";
    };

    "org/gnome/shell" = {
      disabled-extensions = [ "window-list@gnome-shell-extensions.gcampax.github.com" "screenshot-window-sizer@gnome-shell-extensions.gcampax.github.com" "drive-menu@gnome-shell-extensions.gcampax.github.com" "places-menu@gnome-shell-extensions.gcampax.github.com" "native-window-placement@gnome-shell-extensions.gcampax.github.com" "apps-menu@gnome-shell-extensions.gcampax.github.com" "workspace-indicator@gnome-shell-extensions.gcampax.github.com" ];
      enabled-extensions = [ "appindicatorsupport@rgcjonas.gmail.com" "windowsNavigator@gnome-shell-extensions.gcampax.github.com" "user-theme@gnome-shell-extensions.gcampax.github.com" "launch-new-instance@gnome-shell-extensions.gcampax.github.com" "burn-my-windows@schneegans.github.com" "compiz-windows-effect@hermes83.github.com" "pop-shell@system76.com" "mprisindicatorbutton@JasonLG1979.github.io" ];
      favorite-apps = [ "firefox.desktop" "org.gnome.Calendar.desktop" "org.gnome.Music.desktop" "org.gnome.Photos.desktop" "org.gnome.Nautilus.desktop" "code.desktop" "discord.desktop" "steam.desktop" "obsidian.desktop" "com.obsproject.Studio.desktop" "1password.desktop" ];
      welcome-dialog-last-shown-version = "41.1";
      disable-user-extensions = false;
    };

    "system/locale" = {
      region = "en_GB.UTF-8";
    };
        "org/gnome/settings-daemon/plugins/power" = {
      power-button-action = "suspend";
      sleep-inactive-ac-type = "nothing";
    };

    "org/gnome/desktop/privacy" = {
      old-files-age = mkUint32 30;
      recent-files-max-age = -1;
      remove-old-temp-files = true;
      remove-old-trash-files = true;
    };

    "org/gnome/desktop/datetime" = {
      automatic-timezone = true;
    };

    "org/gnome/desktop/peripherals/touchpad" = {
    	tap-to-click = true;
    	disable-while-typing = false;
    };

    "org/gnome/desktop/peripherals/mouse" = {
      accel-profile = "flat";
      natural-scroll = true;
    };

    "org/gnome/mutter" = {
      workspaces-only-on-primary = false;
    };

    "org/gnome/desktop/sound" = {
      allow-volume-above-100-percent = true;
      theme-name = "Yaru";
    };

    "org/gnome/desktop/wm/preferences" = {
      button-layout = "appmenu:minimize,maximize,close";
      resize-with-right-button = true;
      titlebar-font = "Source Sans 3 11";
    };

    "org/gnome/shell/weather" = {
      automatic-location = true;
    };

    "org/gnome/shell/extensions/burn-my-windows" = {
    	energize-b-close-effect = true;
        energize-b-open-effect = true;
    };

    "org/gnome/shell/extensions/com/github/hermes83/compiz-windows-effect" = {
    	speedup-factor-divider = 2.6;
    	resize-effect = true;
    };

    "org/gnome/shell/extensions/pop-shell" = {
     	tile-by-default = true;
     	show-skip-taskbar = true;
     	show-title = false;
     	smart-gaps = false;
     	snap-to-grid = false;
     	active-hint = false;
     	hint-color-rgba = "rgba(100, 0, 50, 1)";
     	log-level = 0;
     	gap-inner = 2;
     	gap-outer = 2;
     	toggle-stacking-global = "<Shift>s";
     };
  };
}
