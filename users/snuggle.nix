{ pkgs, config, ... }:
{
#imports = [	<home-manager/nixos> ];

home-manager.users.snuggle = { 
	home.stateVersion = "20.09";
	home.file.".ssh/authorized_keys" = {
    source = builtins.fetchurl { 
			url = "https://github.com/${config.users.users.snuggle.name}.keys"; 
			sha256 = "1d16baihs6d95zkj0mvm7drmyxjnxybwbrivjf91a0innjlhdz07"; 
		};
	};
	imports = [ ../config/dconf/dconf.nix ];

	#xdg.configFile."Nextcloud/nextcloud.cfg".source = config/Nextcloud/nextcloud.cfg;
	xdg.configFile."Yubico/u2f_keys".source = ../config/Yubico/u2f_keys;
	xdg.configFile."Nextcloud/sync-exclude.lst".source = ../config/Nextcloud/sync-exclude.lst;

	gtk = {
		enable = true;
		iconTheme.name = "Papirus";
		iconTheme.package = pkgs.papirus-icon-theme;
		theme.name = "Yaru-dark";
		theme.package = pkgs.yaru-theme;
		cursorTheme.package = pkgs.breeze-gtk;
		cursorTheme.name = "Breeze_Snow";
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

		package = pkgs.firefox-wayland;

		profiles.default = {
			id = 0;
			name = "Default";
			isDefault = true;
			settings = {
			"browser.startup.homepage" = "https://storage.snugg.ie";
			"services.sync.username" = "^-^@snugg.ie";
			"services.sync.engine.passwords" = false;
			"font.name-list.emoji" = "Blobmoji";
			"font.default.x-western" = "sans-serif";
			"font.name.serif.x-western" = "Source Serif 4";
			"font.name.sans-serif.x-western" = "Source Sans 3";
			"font.name.monospace.x-western" = "Fantasque Sans Mono";
			};
			# PLEASE RE-ENABLE AFTER NEW NIXOS STABLE RELEASE
			#extensions = 
			#		with pkgs.nur.repos.rycee.firefox-addons; [
			#			ublock-origin
			#			onepassword-password-manager
			#			firefox-color
			#			refined-github
			#		]; 
		};
		
		};

		exa = {
		enableAliases = true;
		};

		git = {
		enable = true;
		userName  = "Snuggle";
		userEmail = "^-^@snugg.ie";
		signing.signByDefault = true;
		signing.key = "2D3825B49C6BCBE1AC337723877300954D1493E6";
		extraConfig = {
			merge.conflictstyle = "diff3";
		};
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
			source = [ (builtins.fetchurl { url = "https://github.com/${config.users.users.snuggle.name}.gpg"; sha256 = "06ncqgs3fn5bp6w8qdzd33a22ckym9ndpz7q7hqxf4wg2rjri77r"; }) ];
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

		kitty = {
		enable = true;
		#theme = "fairyfloss";
		font = {
			name = "Fantasque Sans Mono";
			package = pkgs.fantasque-sans-mono;
			size = 14;
		};
		settings = {
			linux_display_server = "wayland";
			cursor_shape = "beam";
			background = "#5a5475";
			foreground = "#f8f8f0";
			cursor = "#ffb8d1";
			selection_foreground = "#ad5877";
			selection_background = "#ffb8d1";
			# Black
			color0 = "#464258";
			color8 = "#c19fd8";
			# Red
			color1 = "#ff857f";
			color9 = "#f44747";
			# Green
			color2 = "#ad5877";
			color10 = "#ffb8d1";
			# Yellow
			color3 = "#e6c000";
			color11 = "#ffea00";
			# Blue
			color4 = "#6c71c4";
			color12 = "#6796e6";
			# Magenta
			color5 = "#b267e6";
			color13 = "#c5a3ff";
			# Cyan
			color6 = "#afecad";
			color14 = "#b2ffdd";
			# White
			color7 = "#cccccc";
			color15 = "#f8f8f0";
		};
		};

		alacritty = {
		enable = true;
		settings = {
			cursor.style = {
			shape = "beam";
			blinking = "on";
			};
			font = {
			size = 14;
			normal = {
				family = "Fantasque Sans Mono Nerd Font";
			};
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
}
