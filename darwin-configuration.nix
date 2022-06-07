{ config, pkgs, ... }:

{
  imports = [ <home-manager/nix-darwin> ];

  nixpkgs.config.allowUnfree = true;
  # List packages installed in system profile. To search by name, run:
  # $ nix-env -qaP | grep wget
  environment.systemPackages =
    [ pkgs.vim
      pkgs.gnupg
      pkgs.micro
      pkgs.opensc
      pkgs.libu2f-host
      pkgs.yubikey-personalization
      pkgs.discord
      pkgs.vscode
      
    ];
  users.users.snuggle = {
    name = "Evie Snuggle";
    home = "/Users/snuggle";
  };

  system.activationScripts.applications.text = pkgs.lib.mkForce (''
      find /Users/snuggle/Applications/ -maxdepth 1  -type l | while read file; do
      	base="$(basename "$file")"
      	echo "$base"
      	foop="$(readlink -f "/Users/snuggle/Applications/$base")"
      	rm -vf "/Applications/$base"
      	echo "tell app \"Finder\" to make alias file at POSIX file \"/Applications/\" to POSIX file \"$foop\" with properties {name: \"$base\"}"
        osascript -e "tell app \"Finder\" to make alias file at POSIX file \"/Applications/\" to POSIX file \"$foop\" with properties {name: \"$base\"}";
    done
  '');

  home-manager.users.snuggle = { pkgs, ... }: {
    programs.git = {
      enable = true;
      userName  = "Snuggle";
      userEmail = "^-^@snugg.ie";
    };
  };
  # Use a custom configuration.nix location.
  # $ darwin-rebuild switch -I darwin-config=$HOME/.config/nixpkgs/darwin/configuration.nix
  # environment.darwinConfig = "$HOME/.config/nixpkgs/darwin/configuration.nix";

  # Auto upgrade nix package and the daemon service.
  services.nix-daemon.enable = true;
  # nix.package = pkgs.nix;
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

