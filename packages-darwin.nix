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
    pinentry-curses
    #zoom-us
    iterm2

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
    glances
    exa
    fish
    #kitty
    micro mosh
    neofetch
    nodePackages.gitmoji-cli
    optipng
    starship
    youtube-dl
    vim
    jq
    wget
    xclip
  ];
}
