{ config, pkgs, ... }:

{
  imports = [ 
    <home-manager/nix-darwin>
    ./packages-darwin.nix
  ];

  nixpkgs.config.allowUnfree = true;

  fonts = import ./fonts-darwin.nix pkgs;

  users.users.snuggle = {
    name = "snuggle";
    description = "Evie Snuggle";
    home = "/Users/snuggle";
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
      echo "📦✅ Finished wrapping applications!"
  '');

  home-manager.users.snuggle = { pkgs, ... }: {
    programs = {
      fish = {
        enable = true;
        interactiveShellInit = "starship init fish | source";
        shellInit = builtins.readFile ./config/fish/colours.fish;
        shellAbbrs = {
          cat = "bat";
          ls = "exa --icons";
          "exa --icons -l" = "exa --icons -lah";
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
      };
    };

    home.file.".ssh/authorized_keys" = {
      source = builtins.fetchurl { 
        url = "https://github.com/${config.users.users.snuggle.name}.keys"; 
        sha256 = "1d16baihs6d95zkj0mvm7drmyxjnxybwbrivjf91a0innjlhdz07"; 
      };
    };

    #xdg.configFile."Nextcloud/nextcloud.cfg".source = config/Nextcloud/nextcloud.cfg;
    xdg.configFile."Yubico/u2f_keys".source = config/Yubico/u2f_keys;
    xdg.configFile."Nextcloud/sync-exclude.lst".source = config/Nextcloud/sync-exclude.lst;
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

