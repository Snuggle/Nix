{ pkgs, ... }:
{
	environment.systemPackages = with pkgs; [
		### (Installed System Packages) ###

		# Applications
		_1password-gui
		# davinci-resolve # https://github.com/NixOS/nixpkgs/issues/94032
		discord
		firefox-wayland
		gparted
		inkscape
		kdenlive krita
		libreoffice
		nextcloud-client
		obs-studio obsidian
		spotify
		slack
		tdesktop teams transmission-gtk transmission-remote-gtk
		vivaldi vivaldi-ffmpeg-codecs vscode
		zoom-us

		# Development, Git or Libraries
		docker
		ffmpeg
		git gnupg
		jekyll
		ruby
		yubikey-personalization
		tailscale

		# GNOME Extensions
		gnomeExtensions.appindicator
		gnomeExtensions.burn-my-windows
		gnomeExtensions.compiz-windows-effect
		gnomeExtensions.gsconnect
		gnomeExtensions.mpris-indicator-button
		gnomeExtensions.night-theme-switcher

		# System Utilities
		brlaser
		dconf dconf2nix
		etcher
		glances gnome.dconf-editor gnome.gnome-software gnome.gucharmap
		linuxKernel.kernels.linux_zen libglvnd
		ntfs3g nv-codec-headers
		obinskit
		pavucontrol
		refind
		tmux
		virt-manager vlc
		wireguard-tools
		
		# Terminal Tools
		#alacritty
		bat bind
		exa
		fish
		kitty
		micro mosh
		neofetch
		optipng
		starship
		vim
		wget
		xclip

		# Theming
		arc-theme
		breeze-gtk
		gnome3.gnome-tweaks
		papirus-icon-theme
		yaru-theme

		# Un-GNU Coreutils, Replace GNU Coreutils with Busybox/Toybox
		(pkgs.hiPrio unixtools.fsck)
		# Required for NixOS with busybox otherwise "systemd-fsck[4070]: fsck.vfat: invalid option -- 'M'" error.
		# This ensures that `ls -l $(which fsck)` is pointing to the 'util-linux/bin/fsck' rather than 'busybox/bin/fsck'.
		# Failing to do this causes systemd to fail booting, dropping into emergency mode, on FAT32 /boot EFI partitions.
		busybox
		(pkgs.hiPrio toybox)
		(pkgs.lowPrio coreutils)
		(coreutils.override { minimal = true; })
	];
}
