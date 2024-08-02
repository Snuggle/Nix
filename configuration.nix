# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).
# pkgs.lib.mkForce

{ config, lib, pkgs, ... }:

{

imports = [ # Include the results of the hardware scan.
    ./setup/cachix/cachix.nix
    ./linux/hardware-configuration.nix
    ./linux/packages.nix
];

/* #imports = pkgs.lib.mkIf pkgs.stdenv.isDarwin [./platforms/darwin.nix];
imports = pkgs.lib.mkIf pkgs.stdenv.isLinux  ([	<home-manager/nixos>
./setup/cachix/cachix.nix
./linux/hardware-configuration.nix
./linux/packages.nix
./users/snuggle.nix
<nixpkgs/nixos/modules/services/hardware/sane_extra_backends/brscan4.nix>]);
 */

nixpkgs.config.packageOverrides = pkgs: {
	nur = import (builtins.fetchTarball "https://github.com/nix-community/NUR/archive/master.tar.gz") {
		inherit pkgs;
	};
};

virtualisation.libvirtd.enable = true;
nix.settings.auto-optimise-store = true;
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

hardware = {
  sane = {
    enable = true;
    brscan4 = {
      enable = true;
      netDevices = {
        home = { model = "DCP-1610W"; ip = "10.0.1.196"; };
      };
    };
  };
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
nixpkgs.overlays = let
    overlays = map (name: import (./packages/overlays + "/${name}"))
		(builtins.attrNames (builtins.readDir ./packages/overlays));
	in overlays;


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

		refind-theme = {
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
		};
	};

	user.services = {
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
	};
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

	wireguard = {
		enable = false; # Poor performance, disabling for now.
		interfaces = {
			wg0 = {
				ips = [ "10.100.0.2/32" ];
				listenPort = 50;
				privateKeyFile = "${config.users.users.snuggle.home}/.wireguard/private";

				peers = [
					# For a client configuration, one peer entry for the server will suffice.

					{
						# Public key of the server (not a file path).
						publicKey = "2Y/T27X+ND1xUT3lfXQ0YpCjTocvMxn2c1Yv9eHG8kQ=";

						# Forward all the traffic via VPN.
						allowedIPs = [ "0.0.0.0/0" ];
						# Or forward only particular subnets
						#allowedIPs = [ "10.100.0.1" "91.108.12.0/22" ];

						# Set this to the server IP and port.
						endpoint = "10.0.1.1:50"; # ToDo: route to endpoint not automatically configured https://wiki.archlinux.org/index.php/WireGuard#Loop_routing https://discourse.nixos.org/t/solved-minimal-firewall-setup-for-wireguard-client/7577

						# Send keepalives every 25 seconds. Important to keep NAT tables alive.
						persistentKeepalive = 25;

						# Update DNS of endpoint
						dynamicEndpointRefreshSeconds = 30;
					}
				];
			};
		};
	};
};

nixpkgs.config = { 
	allowUnfree = true;
	
	permittedInsecurePackages = [
			"electron-13.6.9"
			"electron-12.2.3"
			"electron-14.2.9"
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

	xserver.displayManager.sddm.enable = false;
	xserver.desktopManager.plasma5.enable = false;

		# List services that you want to enable:
		
	# Enable the OpenSSH daemon.
	openssh.enable = true;
#	openssh.settings.PasswordAuthentication = "no";
#	openssh.settings.PermitRootLogin = "yes";
#	openssh.extraConfig = ''
#		PubkeyAcceptedAlgorithms +ssh-rsa
#		HostkeyAlgorithms +ssh-rsa
#	'';

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

# Define a user account. Don't forget to set a password with ‘passwd’.
users.users.snuggle = {
	isNormalUser = true;
	description = "Evie Snuggle";
	createHome = true;
	shell = pkgs.fish;
	extraGroups = [ "wheel" "libvirtd" "scanner" "lp" "adbusers" "docker" "networkmanager" ]; # Enable ‘sudo’ for the user.

	openssh.authorizedKeys.keyFiles = [ (builtins.fetchurl { 
		url = "https://github.com/${config.users.users.snuggle.name}.keys"; 
		sha256 = "07fc06a9b436021592933be6c597ef56765f733b755720e72fa9190da35a26b4"; 
	}) ];
};

fonts = import ./linux/fonts.nix pkgs;


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
		shellInit = builtins.readFile ./config/fish/colours.fish;
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

# Open ports in the firewall.
# networking.firewall.allowedTCPPorts = [ ... ];
# networking.firewall.allowedUDPPorts = [ ... ];
# Or disable the firewall altogether.
# networking.firewall.enable = false;


# This value determines the NixOS release from which the default
# settings for stateful data, like file locations and database versions
# on your system were taken. It‘s perfectly fine and recommended to leave
# this value at the release version of the first install of this system.
# Before changing this value read the documentation for this option
# (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
system.stateVersion = "20.09"; # Did you read the comment?
}
