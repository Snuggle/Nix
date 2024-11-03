{ config, pkgs, ... }:

{
	imports = [ 
		<home-manager/nix-darwin>
		./macos/packages-darwin.nix
	];

	nixpkgs.config.allowUnfree = true;

	fonts = import ./macos/fonts-darwin.nix pkgs;

	users.users.snuggle = {
		name = "snuggle";
		description = "Evie Snuggle";
		home = "/Users/snuggle";
		shell = pkgs.fish;
	};

	system.activationScripts.applications.text = pkgs.lib.mkForce (''
			echo "📦ℹ️ Wrapping application packages…"
			find /Users/snuggle/Applications/ -maxdepth 1  -type l | while read file; do
				base="$(basename "$file")"
				foop="$(readlink -f "/Users/snuggle/Applications/$base")"
				rm -vf "/Applications/$base"
				echo "tell app \"Finder\" to make alias file at POSIX file \"/Applications/\" to POSIX file \"$foop\" with properties {name: \"$base\"}"
				osascript -e "tell app \"Finder\" to make alias file at POSIX file \"/Applications/\" to POSIX file \"$foop\" with properties {name: \"$base\"}";
			done
			sudo cp -fv ${./config/Nextcloud/sync-exclude.lst} /Applications/Nextcloud.app/Contents/Resources/sync-exclude.lst
			echo "📦✅ Finished wrapping applications!"
			echo "⛓  Importing GPG public keys…"
			curl https://github.com/Snuggle.gpg | gpg --import
			gpgconf --reload gpg-agent
	'');

	home-manager.users.snuggle = { pkgs, ... }: {
		programs = {
			fish = {
				enable = true;
				interactiveShellInit = "starship init fish | source";
				shellInit = builtins.readFile ./config/fish/init.fish;
				shellAbbrs = {
					cat = "bat";
					ls = "exa --icons";
					nano = "micro";
					ssh = "mosh";
				};
			};

			ssh = {
				extraConfig = ''
					PubkeyAcceptedAlgorithms +ssh-rsa
					HostkeyAlgorithms +ssh-rsa
				'';
			};
			git = {
				enable = true;
				userName  = "Snuggle";
				userEmail = "^-^@snugg.ie";
				signing.signByDefault = true;
				signing.key = "877300954D1493E6";
				
			};

			gpg = {
			# Required on MacOS for GPG to recognise YubiKey.
			# https://github.com/NixOS/nixpkgs/issues/155629
			scdaemonSettings = pkgs.lib.mkIf pkgs.stdenv.isDarwin {
				disable-ccid = true;
				};
			};
		};

		home.file.".ssh/authorized_keys" = {
			source = builtins.fetchurl { 
				url = "https://github.com/${config.users.users.snuggle.name}.keys"; 
			};
		};

		xdg.configFile."Yubico/u2f_keys".source = config/Yubico/u2f_keys;
		home.file.".gnupg/gpg-agent.conf".source = config/gnupg/gpg-agent.conf;
		home.file.".gnupg/scdaemon.conf".source = config/gnupg/scdaemon.conf;
		home.stateVersion = "20.09";
	};
	# Use a custom configuration.nix location.
	# $ darwin-rebuild switch -I darwin-config=$HOME/.config/nixpkgs/darwin/configuration.nix
	# environment.darwinConfig = "$HOME/.config/nixpkgs/darwin/configuration.nix";

	# Auto upgrade nix package and the daemon service.
	services.nix-daemon.enable = true;
	# nix.package = nix;
	#programs.gpg.scdaemonSettings = { disable-ccid = true; };  
	# Create /etc/bashrc that loads the nix-darwin environment.
	programs.zsh.enable = true;  # default shell on catalina
	programs.fish.enable = true;
	#services.pcscd.enable = true;
	#hardware.gpgSmartcards.enable = true;
	# Used for backwards compatibility, please read the changelog before changing.
	# $ darwin-rebuild changelog
	system.stateVersion = 4;
}

