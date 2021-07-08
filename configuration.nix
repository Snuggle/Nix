# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ config, pkgs, ... }:

{
  imports =
    [ # Include the results of the hardware scan.
      ./hardware-configuration.nix
      (import "${builtins.fetchTarball https://github.com/rycee/home-manager/archive/master.tar.gz}/nixos")
    ];

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
    10.0.1.7 storage.snugg.ie
  '';
  # Configure network proxy if necessary
  # networking.proxy.default = "http://user:password@proxy:port/";
  # networking.proxy.noProxy = "127.0.0.1,localhost,internal.domain";

  networking.firewall.allowedTCPPorts = [ 7777 ];

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

  services.dbus.packages = with pkgs; [ gnome3.dconf ];
  

  # Configure keymap in X11
  # services.xserver.layout = "us";
  # services.xserver.xkbOptions = "eurosign:e";

  # Enable CUPS to print documents.
  services.printing.enable = true;

  # Enable sound.
  sound.enable = true;
  hardware.pulseaudio.enable = true;
  hardware.sane.enable = true;
  hardware.sane.extraBackends = [ pkgs.hplipWithPlugin ];

  # Enable touchpad support (enabled default in most desktopManager).
  # services.xserver.libinput.enable = true;

  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.snuggle = {
    isNormalUser = true;
    shell = pkgs.fish;
    extraGroups = [ "wheel" "libvirtd" "scanner" "lp" ]; # Enable ‘sudo’ for the user.
  };

  
  nixpkgs.config.allowUnfree = true;

  services.xserver.videoDrivers = [ "nvidia" ];
  services.pcscd.enable = true;
  services.udev.packages = [ pkgs.yubikey-personalization ];

  virtualisation.libvirtd.enable = true;

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
    virt-manager
    bind
    optipng
    mosh

    # Development or Libraries
    jekyll
    ruby
    docker

    # Git, GnuPG & Signing
    gnupg
    gnupg1compat
    git
    yubikey-personalization
    
    # System Utilities
    glances
    ffmpeg
    nv-codec-headers
    ntfs3g
    refind

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
  ];

  environment.sessionVariables.TERMINAL = [ "alacritty" ];
  environment.sessionVariables.EDITOR = [ "micro" ];

  environment.shellInit = ''
    export GPG_TTY="$(tty)"
    gpg-connect-agent /bye
    export SSH_AUTH_SOCK="/run/user/$UID/gnupg/S.gpg-agent.ssh"
  '';

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
  users.users.snuggle.openssh.authorizedKeys.keyFiles = [ "/home/snuggle/.ssh/snuggle.pub" ];
  services.openssh.passwordAuthentication = false;
  services.openssh.permitRootLogin = "yes";
  services.openssh.challengeResponseAuthentication = false;

  # Open ports in the firewall.
  # networking.firewall.allowedTCPPorts = [ ... ];
  # networking.firewall.allowedUDPPorts = [ ... ];
  # Or disable the firewall altogether.
  # networking.firewall.enable = false;

  home-manager.users.snuggle = { 
    xsession.pointerCursor.package = pkgs.breeze-gtk;
    xsession.pointerCursor.name = "Breeze_Snow";

    gtk = {
      enable = true;
      iconTheme.name = "Yaru";
      iconTheme.package = pkgs.yaru-theme;
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
