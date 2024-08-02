{ pkgs, ... }:
{
environment.systemPackages = with pkgs; [
    # Darwin Specific
    opensc
    libu2f-host
    pinentry_mac

    ### (Installed System Packages) ###

    # Applications
    discord
    #slack
    transmission-gtk
    vscode
    pinentry-curses
    #zoom-us
    iterm2
   # vivaldi

    # Development, Git or Libraries
    ffmpeg
    git gnupg
    jekyll
    ruby
    #yubikey-personalization
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
    imagemagick
    nodePackages.gitmoji-cli
    optipng
    starship
    youtube-dl
    vim
    jq
    wget

    ##### Homebrew Packages Only #####
    # LinearMouse
    # brew install --cask linearmouse
    ##### Homebrew Packages Only #####
  ];
}
