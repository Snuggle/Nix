# This is your system's configuration file.
# Use this to configure your system environment (it replaces /etc/nixos/configuration.nix)
# Based upon: https://github.com/Misterio77/nix-starter-configs
{
  inputs,
  lib,
  config,
  pkgs,
  ...
}: {
  # You can import other NixOS modules here
  imports = [
    # If you want to use modules from other flakes (such as nixos-hardware):
    # inputs.hardware.nixosModules.common-cpu-amd
    # inputs.hardware.nixosModules.common-ssd

    # You can also split up your configuration and import pieces of it here:
    # ./users.nix

    # Import your generated (nixos-generate-config) hardware configuration
    ./packages.nix
  ];

  nixpkgs = {
    # You can add overlays here
    overlays = [
      # If you want to use overlays exported from other flakes:
      # neovim-nightly-overlay.overlays.default

      # Or define it inline, for example:
      # (final: prev: {
      #   hi = final.hello.overrideAttrs (oldAttrs: {
      #     patches = [ ./change-hello-to-hi.patch ];
      #   });
      # })
    ];
    # Configure your nixpkgs instance
    config = {
      # Disable if you don't want unfree packages
      allowUnfree = true;
    };
  };

  nix = let
    flakeInputs = lib.filterAttrs (_: lib.isType "flake") inputs;
  in {
    settings = {
      # Enable flakes and new 'nix' command
      experimental-features = "nix-command flakes";
      # Opinionated: disable global registry
      flake-registry = "";
      # Workaround for https://github.com/NixOS/nix/issues/9574
      nix-path = config.nix.nixPath;
    };
    # Opinionated: disable channels
    channel.enable = false;

    # Opinionated: make flake registry and nix path match flake inputs
    registry = lib.mapAttrs (_: flake: {inherit flake;}) flakeInputs;
    nixPath = lib.mapAttrsToList (n: _: "${n}=flake:${n}") flakeInputs;
  };

  virtualisation.libvirtd.enable = true;
  virtualisation.docker.enable = true;
  # Use the systemd-boot EFI boot loader.
  boot = {
    loader.systemd-boot.enable = true;
    loader.efi.canTouchEfiVariables = true;
    loader.grub.configurationLimit = 10;

    extraModulePackages = [
      config.boot.kernelPackages.v4l2loopback
    ];

    # Register a v4l2loopback device at boot
    kernelModules = [
      "v4l2loopback"
    ];

    kernelParams = [ "pci=assign-busses,hpbussize=0x33,realloc" ];
  };

    
  environment.gnome.excludePackages = [ pkgs.dejavu_fonts ];
  security = {
    rtkit.enable = true;
    pam = {
      u2f = {
        enable = true;
        control = "sufficient";
        cue = true;
        #cue = "🤔 Please tap your security key to confirm you are human…";
        #interactive = true;
      };
      services = {
        sudo.u2fAuth = true;
        login.u2fAuth = true;
        gbm.u2fAuth = true;
        gnome-keyring.u2fAuth = true;
        gdm.enableGnomeKeyring = true;
      };
    };
  };



  # Enable sound.
  hardware.pulseaudio.enable = false;

  # Inspired by: https://github.com/divnix/digga/blob/4ebf259d11930774b3a13b370b955a8765bfcae6/configuration.nix#L30
  #nixpkgs.overlays = let
  #    overlays = map (name: import (./packages/overlays + "/${name}"))
  #    (builtins.attrNames (builtins.readDir ./packages/overlays));
  #  in overlays;


  systemd = {
    services = {
      # Don't take ~30s to boot
      systemd-udev-settle.enable = false;
      NetworkManager-wait-online.enable = true;

      # Set Papirus Folder Colours
      #papirus-folders = {
      #	description = "papirus-folders";
      #	path = [ pkgs.bash pkgs.stdenv pkgs.gawk pkgs.getent pkgs.gtk3 ];
      #	serviceConfig = {
      #		Type = "oneshot";
      #		ExecStartPre = "/run/current-system/sw/bin/sleep 10";
      #		ExecStart = "${pkgs.fetchFromGitHub
      #				{
      #					owner = "PapirusDevelopmentTeam";
      #					repo = "papirus-folders";
      #					rev = "86c63fdd21182e5cc8444ba488042559951ca106";
      #					sha256 = "sha256-ZZMEZCWO+qW76eqa+TgxWGVz69VkSCPcttLoCrH7ppY=";
      #				} + "/papirus-folders"} -t ${pkgs.papirus-icon-theme}/share/icons/Papirus --verbose --color yaru";
      #	};
      #	wantedBy = [ "graphical.target" ];
    #	};

/*       refind-theme = {
        description = "Set rEFInd theme";
        path = [ pkgs.git pkgs.stdenv pkgs.toybox pkgs.busybox ];
        serviceConfig = {
          Type = "oneshot";
          ExecStart = "${pkgs.toybox}/bin/toybox cp -RFv ${pkgs.fetchFromGitHub
              {
                owner = "bobafetthotmail";
                repo = "refind-theme-regular";
                rev = "508ff82526b76ead3a8cbd77cb90a91d4be871b9";
                sha256 = "sha256-HDs4RWCo6bi1tjpja7k3ex0JFGJExTcqbmikvM2xjnE=";
              } + "/."} /boot/EFI/refind/themes/";
          ExecStartPost = "${pkgs.bash}/bin/bash -c '${pkgs.busybox}/bin/busybox cp -v ${config/rEFInd/theme.conf} /boot/EFI/refind/themes/theme.conf && ${pkgs.busybox}/bin/busybox cp -v ${config/rEFInd/refind.conf} /boot/EFI/refind/refind.conf'";
        };
        wantedBy = [ "default.target" ];
      }; */
    }; 

    /* user.services = {
      nextcloud-config-update = {
        enable = true;
        description = "Update Nextcloud Config";
        path = [ pkgs.bash pkgs.stdenv pkgs.toybox ];
        serviceConfig = {
          Type = "oneshot";
          ExecStart = "${pkgs.toybox}/bin/toybox cp -n ${config/Nextcloud/nextcloud.cfg} ${config.users.users.snuggle.home}/.config/Nextcloud/nextcloud.cfg";
          ExecStartPost="${pkgs.toybox}/bin/toybox chmod +w ${config.users.users.snuggle.home}/.config/Nextcloud/nextcloud.cfg";
        };
        wantedBy = [ "default.target" ];
      };

      # My own public GPG key must be imported otherwise you'll get the below error when trying to sign a git commit:
      # error: gpg failed to sign the data fatal: failed to write commit object
      gpg-import-keys = {
        enable = true;
        description = "Automatically import my public GPG keys";
        unitConfig = {
          After = [ "gpg-agent.socket" ];
        };
        serviceConfig = {
          Type = "oneshot";
          ExecStart = "${pkgs.bash}/bin/bash -c '${pkgs.gnupg}/bin/gpg --import ${
            builtins.fetchurl { 
              url = "https://github.com/${config.users.users.snuggle.name}.gpg"; 
              sha256 = "06ncqgs3fn5bp6w8qdzd33a22ckym9ndpz7q7hqxf4wg2rjri77r"; 
            }}'";
        };

        wantedBy = [ "default.target" ];
      };
    }; */
  };


  # Set your time zone.
  time.timeZone = "Europe/London";

  # The global useDHCP flag is deprecated, therefore explicitly set to false here.
  # Per-interface useDHCP will be mandatory in the future, so this generated config
  # replicates the default behaviour.

  networking = {
    hostName = "cherry"; # Define your hostname.
    networkmanager.enable = true;
    #useDHCP = true;

    extraHosts = ''
      10.0.1.6 hug
    '';
    # Configure network proxy if necessary
    # networking.proxy.default = "http://user:password@proxy:port/";
    # networking.proxy.noProxy = "127.0.0.1,localhost,internal.domain";

    firewall = {
      allowedTCPPorts = [ 7777 ];
      allowedUDPPorts = [ 50 ];
    };
  };

  nixpkgs.config = { 
    
    permittedInsecurePackages = [
        "electron-13.6.9"
        "electron-12.2.3"
        "electron-114.2.9"
        "electron-11.5.0"
        "electron-18.1.0"
        "electron-19.1.9"
        "electron-25.9.0"
        "python-2.7.18.6"
        "openssl-1.1.1u"
        "openssl-1.1.1w"
    ];
  };  

  services = {
    # Enable the X11 windowing system.
    xserver.enable = true;

    openiscsi = {
      enable = true;
      name = "10.0.1.52";
    };

    # Enable the GNOME 3 Desktop Environment.
    xserver.displayManager.gdm.enable = true;
    xserver.desktopManager.gnome.enable = true;

    displayManager.sddm.enable = false;
    xserver.desktopManager.plasma5.enable = false;

    #services.dbus.packages = with pkgs; [ gnome3.dconf ];

    gnome.gnome-keyring.enable = true;
    flatpak.enable = true;

    # Configure keymap in X11
    # services.xserver.layout = "us";
    # services.xserver.xkbOptions = "eurosign:e";

    # Enable CUPS to print documents.
    printing.enable = false;
      printing.drivers = [ pkgs.brlaser pkgs.brscan4 ];

    pipewire = {
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

    hardware.bolt.enable = true;

    pcscd.enable = true;
    udev.packages = with pkgs; [ pkgs.yubikey-personalization pkgs.libu2f-host ];
    udev.extraRules = ''
        # Always authorize thunderbolt connections when they are plugged in.
        # This is to make sure the USB hub of Thunderbolt is working.
        ACTION=="add", SUBSYSTEM=="thunderbolt", ATTR{authorized}=="0", ATTR{authorized}="1"
      '';
  };

  system = {
    autoUpgrade.enable = true;

    activationScripts.setavatar.text = ''
      accountServiceIcons="/var/lib/AccountsService/icons/snuggle"
      accountServiceUsers="/var/lib/AccountsService/users/snuggle"
      cp ${(builtins.fetchurl { 
        url = "https://github.com/snuggle.png"; 
        sha256 = "1x4ajji4ip6bw9dkwf7bykkw00avzw7wg21cn0w4kwbcv71h052c"; 
      })} "$accountServiceIcons"

      if ! grep -Fxq "Icon=$accountServiceIcons" "$accountServiceUsers"; then
        echo "Icon=$accountServiceIcons" >> "$accountServiceUsers"
      fi
    '';

    # Setup symlinks for NAS-based home directory
    /* 	userActivationScripts.linktosharedfolder.text = ''
      for location in \
        Desktop \
        Documents \
        Downloads \
        Pictures \
        Public \
        Screenshots \
        Templates \
        Temporary \
        Videos \
        Music 
      do
        if [[ -d "${config.users.users.snuggle.home}/$location" ]]; then
          find "${config.users.users.snuggle.home}/$location" -type d -empty -exec rm --dir --verbose {} \;
        fi
        if [[ -d "${config.users.users.snuggle.home}/$location" ]]; then
          continue
        fi
        if [[ ! -L "${config.users.users.snuggle.home}/$location" ]]; then
          ln --symbolic --no-target-directory --verbose "$(findmnt homesweet.server:/mnt/homesweet/users/snuggle --noheadings --first-only --output TARGET)/$location/" "${config.users.users.snuggle.home}/$location"
        fi
      done
    ''; */
  };

  # Enable touchpad support (enabled default in most desktopManager).
  # services.xserver.libinput.enable = true;

  fonts = import ./fonts.nix pkgs;


  environment.sessionVariables.TERMINAL = [ "kitty" ];
  environment.sessionVariables.VISUAL = [ "micro" ];
  environment.sessionVariables.EDITOR = [ "micro" ];
  environment.sessionVariables.NIXOS_OZONE_WL = "1"; # Apply Wayland flags to Electron apps where necessary
  environment.sessionVariables.MOZ_WAYLAND = "true";
  environment.variables.OSTYPE = [ "linux-toybox" ];

  environment.shellInit = ''
    export GPG_TTY="$(tty)"
    gpg-connect-agent /bye
    export SSH_AUTH_SOCK="$(gpgconf --list-dirs agent-ssh-socket)"
  '';

  # Some programs need SUID wrappers, can be configured further or are
  # started in user sessions.
  # programs.mtr.enable = true;
  programs = {
    steam.enable = true;
    adb.enable = true;
    fish = {
      enable = true;
      promptInit = "starship init fish | source";
     #shellInit = builtins.readFile ./config/fish/colours.fish;
      shellAbbrs = {
        cat = "bat";
        ls = "exa --icons";
        nano = "micro";
      };
    };

    ssh = {
      startAgent = false;
      extraConfig = ''
        PubkeyAcceptedAlgorithms +ssh-rsa
        HostkeyAlgorithms +ssh-rsa
      '';
    };
    gnupg.agent = {
      enable = true;
      enableSSHSupport = true;
    };
  };

  users.users = {
    snuggle = {
      # You can set an initial password for your user.
      # If you do, you can skip setting a root password by passing '--no-root-passwd' to nixos-install.
      # Be sure to change it (using passwd) after rebooting!
      # initialPassword = "correcthorsebatterystaple";
      isNormalUser = true;
      shell = pkgs.fish;
      openssh.authorizedKeys.keys = [ (builtins.fetchurl { 
        url = "https://github.com/${config.users.users.snuggle.name}.keys"; 
        sha256 = "1bvyxgb893q00nfbns7qghc25j7f5dnnnjfd0nbq0cllpjrqqfk6";
      }) ];
      extraGroups = [ "wheel" "libvirtd" "scanner" "lp" "adbusers" "docker" "networkmanager" ];
    };
  };

  # This setups a SSH server. Very important if you're setting up a headless system.
  # Feel free to remove if you don't need it.
  services.openssh = {
    enable = true;
    settings = {
      # Opinionated: forbid root login through SSH.
      PermitRootLogin = "no";
      # Opinionated: use keys only.
      # Remove if you want to SSH using passwords
      PasswordAuthentication = false;
    };
  };

  # https://nixos.wiki/wiki/FAQ/When_do_I_update_stateVersion
  system.stateVersion = "24.05";
  
}
