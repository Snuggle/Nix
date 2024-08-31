{ pkgs, ... }:
{
environment.systemPackages = with pkgs; [
	### (Installed System Packages) ###

	# Applications
	_1password-gui
	discord-ptb
	espanso
	firefox-wayland
	gparted
	inkscape
	kdenlive krita
	libreoffice
	nextcloud-client
	obs-studio obsidian
	spotify
	jellyfin-media-player
	thunderbolt bolt
	slack
	signal-desktop
	tdesktop
	transmission-gtk transmission-remote-gtk
	vscode
    #(vivaldi.override {
    #  proprietaryCodecs = true;
    #  enableWidevine = false;
    #})
    #vivaldi-ffmpeg-codecs
	#widevine-cdm
	obsidian
	yubikey-manager
    yubioath-flutter
    #whatsapp-for-linux
	#xkeysnail
	zoom-us

	#displaylink

	# Development, Git, or Libraries
	docker
	sane-airscan
	sane-backends
	ffmpeg-full
	openiscsi
	git gnupg
	rustc
	rustup
	cargo
	jekyll
	ruby
	#yubikey-personalization
	tailscale

	#ibus-engines.libpinyin

	# GNOME Extensions
	gnomeExtensions.appindicator
	gnomeExtensions.burn-my-windows
	gnomeExtensions.compiz-windows-effect
	gnomeExtensions.hide-top-bar
	gnomeExtensions.gsconnect
	#gnomeExtensions.mpris-indicator-button
	gnomeExtensions.night-theme-switcher
	gnomeExtensions.mpris-label
	gnomeExtensions.pop-shell

	libevdev
	python310Packages.evdev
	
	# System Utilities
	brlaser
	cachix
	dconf dconf2nix
	#etcher
	glances gnome.dconf-editor gnome.gnome-software gnome.gucharmap
	linuxKernel.kernels.linux_zen libglvnd
	ntfs3g nv-codec-headers
	#obinskit
	imagemagick
	nfs-utils
	pavucontrol
	refind
	smartmontools
	tmux
	virt-manager vlc libvirt
	xdg-desktop-portal
	xorg.xkill
	ox
	rust-petname
	wireguard-tools
	
	# Terminal Tools
	alacritty
	bat bind
	eza
	fish
	kitty
	micro mosh
	neofetch
	nodePackages.gitmoji-cli
	optipng
	starship
	vim
	rust-motd
	hyperfine
	jq
	wget
	lychee
	python3

	# Theming
	arc-theme
	breeze-gtk
	gnome3.gnome-tweaks
	papirus-icon-theme
	yaru-theme

	haskellPackages.gtk-sni-tray
	taffybar

	#coreutils
	# Un-GNU Coreutils, Replace GNU Coreutils with Busybox/Toybox
	#(pkgs.hiPrio unixtools.fsck)
	#(pkgs.hiPrio ripgrep)
	# Required for NixOS with busybox otherwise "systemd-fsck[4070]: fsck.vfat: invalid option -- 'M'" error.
	# This ensures that `ls -l $(which fsck)` is pointing to the 'util-linux/bin/fsck' rather than 'busybox/bin/fsck'.
	# Failing to do this causes systemd to fail booting, dropping into emergency mode, on FAT32 /boot EFI partitions.
	#busybox
	#(pkgs.hiPrio toybox)
	#(pkgs.lowPrio coreutils)
	#(coreutils.override { minimal = true; })
];
}
