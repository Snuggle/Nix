# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).
# pkgs.lib.mkForce

{ config, lib, pkgs, ... }:

{
  imports =
    [ # Include the results of the hardware scan.
      ./hardware-configuration.nix
      (import "${builtins.fetchTarball https://github.com/rycee/home-manager/archive/master.tar.gz}/nixos")
    ];

  nixpkgs.config.packageOverrides = pkgs: {
    nur = import (builtins.fetchTarball "https://github.com/nix-community/NUR/archive/master.tar.gz") {
      inherit pkgs;
    };
  };

  # Use the systemd-boot EFI boot loader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  boot.extraModulePackages = [
    config.boot.kernelPackages.v4l2loopback
  ];

  # Register a v4l2loopback device at boot
  boot.kernelModules = [
    "v4l2loopback"
  ];

  networking.hostName = "plum"; # Define your hostname.
  # networking.wireless.enable = true;  # Enables wireless support via wpa_supplicant.

  system.autoUpgrade.enable = true;
  
  # Set your time zone.
  time.timeZone = "Europe/London";

  # The global useDHCP flag is deprecated, therefore explicitly set to false here.
  # Per-interface useDHCP will be mandatory in the future, so this generated config
  # replicates the default behaviour.
  networking.useDHCP = false;
  networking.interfaces.enp38s0.useDHCP = true;
  networking.interfaces.wlp37s0.useDHCP = true;
	
  networking.extraHosts =
  ''
    10.0.1.6 hug
  '';
  # Configure network proxy if necessary
  # networking.proxy.default = "http://user:password@proxy:port/";
  # networking.proxy.noProxy = "127.0.0.1,localhost,internal.domain";

  networking.firewall.allowedTCPPorts = [ 7777 ];

  nixpkgs.config.permittedInsecurePackages = [
      "electron-13.6.9"
  ];

  # Select internationalisation properties.
  # i18n.defaultLocale = "en_US.UTF-8";
  # console = {
  #   font = "Lat2-Terminus16";
  #   keyMap = "us";
  # };

  # Enable the X11 windowing system.
  services.xserver.enable = true;


  # Enable the GNOME 3 Desktop Environment.
  services.xserver.displayManager.gdm.enable = true;
  services.xserver.desktopManager.gnome.enable = true;

  #services.dbus.packages = with pkgs; [ gnome3.dconf ];
  

  # Configure keymap in X11
  # services.xserver.layout = "us";
  # services.xserver.xkbOptions = "eurosign:e";

  # Enable CUPS to print documents.
  services.printing.enable = true;

  # Enable sound.
  hardware.pulseaudio.enable = false;
  
  security.rtkit.enable = true;
  services.pipewire = {
  enable = true;
  alsa.enable = true;
  alsa.support32Bit = true;
  pulse.enable = true;
  # If you want to use JACK applications, uncomment this
  #jack.enable = true;

  # use the example session manager (no others are packaged yet so this is enabled by default,
  # no need to redefine it in your config for now)
  #media-session.enable = true;
  };


  # Enable touchpad support (enabled default in most desktopManager).
  # services.xserver.libinput.enable = true;

  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.snuggle = {
    isNormalUser = true;
    shell = pkgs.fish;
    extraGroups = [ "wheel" "libvirtd" "scanner" "lp" ]; # Enable ‘sudo’ for the user.

    openssh.authorizedKeys.keyFiles = [ (builtins.fetchurl { 
      url = "https://github.com/snuggle.keys"; 
      sha256 = "07fc06a9b436021592933be6c597ef56765f733b755720e72fa9190da35a26b4"; 
    }) ];
  };

  
  nixpkgs.config.allowUnfree = true;

  services.xserver.videoDrivers = [ "nvidia" ];
  services.pcscd.enable = true;
  services.udev.packages = with pkgs; [ pkgs.yubikey-personalization ];

  #virtualisation.libvirtd.enable = true;

  # List packages installed in system profile. To search, run:
  # $ nix search wget
  environment.systemPackages = with pkgs; [
    # Terminal Tools
    wget
    vim
    fish
    micro
    bat
    exa
    xclip
    neofetch
    alacritty
    starship
    #virt-manager
    bind
    optipng
    mosh

    # Development or Libraries
    jekyll
    ruby
    docker

    # Git, GnuPG & Signing
    gnupg
    git
    yubikey-personalization
    
    # System Utilities
    glances
    ffmpeg
    nv-codec-headers
    ntfs3g
    refind
    vlc
    dconf
    gnome.dconf-editor
    dconf2nix

    # Applications
    firefox
    discord
    vscode
    nextcloud-client
    tdesktop
    spotify
    obs-studio
    krita
    obsidian
    gparted
    _1password-gui
    inkscape
    transmission-gtk
    vivaldi

    # Theming
    yaru-theme
    breeze-gtk
    gnome3.gnome-tweaks
    papirus-icon-theme
    arc-theme

    # Fonts
    fontforge
    source-sans-pro
    source-code-pro
    nerdfonts

    # GNOME Extensions
    gnomeExtensions.appindicator
  ];

  environment.sessionVariables.TERMINAL = [ "alacritty" ];
  environment.sessionVariables.EDITOR = [ "micro" ];

  environment.shellInit = ''
    export GPG_TTY="$(tty)"
    gpg-connect-agent /bye
    export SSH_AUTH_SOCK="$(gpgconf --list-dirs agent-ssh-socket)"
  '';

  # My own public GPG key must be imported otherwise you'll get the below error when trying to sign a git commit:
  # error: gpg failed to sign the data fatal: failed to write commit object
   systemd.user.services.gpg-import-keys = {
    enable = true;
    description = "Automatically import my public GPG keys";
    unitConfig = {
      After = [ "gpg-agent.socket" ];
    };
    serviceConfig = {
      Type = "oneshot";
      ExecStart = "${pkgs.bash}/bin/bash -c '${pkgs.gnupg}/bin/gpg --import ${
        builtins.fetchurl { 
          url = "https://github.com/snuggle.gpg"; 
          sha256 = "06ncqgs3fn5bp6w8qdzd33a22ckym9ndpz7q7hqxf4wg2rjri77r"; 
        }}'";
    };

    wantedBy = [ "default.target" ];
  };

  # Some programs need SUID wrappers, can be configured further or are
  # started in user sessions.
  # programs.mtr.enable = true;
  programs = {
    steam.enable = true;
    fish = {
      enable = true;
      promptInit = "starship init fish | source";
      shellInit = builtins.readFile ./config/fish/colours.fish;
      shellAbbrs = {
        cat = "bat";
        ls = "exa";
        nano = "micro";
        ssh = "mosh";
      };
    };

    ssh.startAgent = false;
    gnupg.agent = {
      enable = true;
      enableSSHSupport = true;
    };
  };


  # List services that you want to enable:

  # Enable the OpenSSH daemon.
  services.openssh.enable = true;
  services.openssh.passwordAuthentication = false;
  services.openssh.permitRootLogin = "yes";
  services.openssh.kbdInteractiveAuthentication = false;

  # Open ports in the firewall.
  # networking.firewall.allowedTCPPorts = [ ... ];
  # networking.firewall.allowedUDPPorts = [ ... ];
  # Or disable the firewall altogether.
  # networking.firewall.enable = false;

  home-manager.users.snuggle = { 
    xsession.pointerCursor.package = pkgs.breeze-gtk;
    xsession.pointerCursor.name = "Breeze_Snow";

    
    imports = [ ./dconf.nix ];

    gtk = {
      enable = true;
      iconTheme.name = "Papirus";
      iconTheme.package = pkgs.papirus-icon-theme;
      theme.name = "Yaru-dark";
      theme.package = pkgs.yaru-theme;
    };

    services = {
      nextcloud-client = {
      	enable = true;
      	startInBackground = true;
      };
    };

    programs = {
      firefox = {
        enable = true;

        profiles.default = {
          id = 0;
          name = "Default";
          isDefault = true;
          settings = {
            "browser.startup.homepage" = "https://snugg.ie";
            "services.sync.username" = "^-^@snugg.ie";
            "services.sync.engine.passwords" = false;
          };
        };

       extensions = 
        with pkgs.nur.repos.rycee.firefox-addons; [
          ublock-origin
          onepassword-password-manager
          firefox-color
          netflix-1080p
          refined-github
        ]; 
      };

      exa = {
        enableAliases = true;
      };

      git = {
        enable = true;
        userName  = "Snuggle";
        userEmail = "^-^@snugg.ie";
      };

      starship = {
          enable = true;
          enableFishIntegration = true;
          # Configuration written to ~/.config/starship.toml
          settings = {
            # add_newline = false;
      
            # package.disabled = true;
          };
      };

      gpg = {
        publicKeys = {
          snuggle = {
            source = [ (builtins.fetchurl { url = "https://github.com/snuggle.gpg"; sha256 = "06ncqgs3fn5bp6w8qdzd33a22ckym9ndpz7q7hqxf4wg2rjri77r"; }) ];
            # Doesn't seem to work, so I am using systemd instead.
          };
        };
      };

      bat = {
        enable = true;
        config.theme = "fairyfloss";
        themes = {
          fairyfloss = builtins.readFile (
            pkgs.fetchFromGitHub
                {
                owner = "sailorhg";
                repo = "fairyfloss";
                rev = "982e64a9e36160350125c0a82a7981dca6200150";
                sha256 = "1gpbkmy8axj8il0s85ifn2adm987nla0dbk2slwc5zyp6m9ak3qq";
                } + "/fairyfloss.tmTheme"
          );
        };
      };

      alacritty = {
        enable = true;
        settings = {
          cursor.style = {
            shape = "beam";
            blinking = "on";
          };
          colors = {
            # Theme based upon: Fairyfloss (FairyShell for Terminal)
            # https://gist.github.com/crazy4pi314/c0874aef9a34e35f6ad07cc163662e51

            # Default colors
            primary = {
              background = "0x5a5475";
              foreground = "0xf8f8f0";
            };

            # Normal colors
            normal = {
              black = "0x464258";
              red = "0xff857f";
              green = "0xad5877";
              yellow = "0xe6c000";
              blue = "0x6c71c4";
              magenta = "0xb267e6";
              cyan = "0xafecad";
              white = "0xcccccc";
            };

            # Bright colors
            bright = {
              black = "0xc19fd8";
              red = "0xf44747";
              green = "0xffb8d1";
              yellow = "0xffea00";
              blue = "0x6796e6";
              magenta = "0xc5a3ff";
              cyan = "0xb2ffdd";
              white = "0xf8f8f0";
            };
          };
        };
      };
    };
  };


  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "20.09"; # Did you read the comment?

}
