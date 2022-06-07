{ pkgs, ... }:
{
environment.systemPackages = with pkgs; [
    # Darwin Specific
    opensc
    libu2f-host
    
    ### (Installed System Packages) ###

    # Applications
    discord
    #slack
    transmission-gtk
    vscode
    #zoom-us

    # Development, Git or Libraries
    ffmpeg
    git gnupg
    jekyll
    ruby
    yubikey-personalization
    tailscale

    # System Utilities
    tmux
    
    # Terminal Tools
    alacritty
    bat bind
    exa
    fish
    #kitty
    micro mosh
    neofetch
    optipng
    starship
    vim
    jq
    wget
    xclip
  ];
}
