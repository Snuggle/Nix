{ pkgs, ... }:
{
enableDefaultPackages = false;

packages = with pkgs; [
	# Serif Fonts
	roboto-slab

	# Sans-serif Fonts
	fontforge
	source-sans # Previously 'source-sans-pro'
	source-serif # Previously 'source-serif-pro'
	noto-fonts
	ubuntu_font_family

	# Mono Fonts
	source-code-pro
	fantasque-sans-mono

	# Emoji Fonts
	noto-fonts-emoji-blob-bin

	# Non-English Fonts
	noto-fonts-cjk
	noto-fonts-cjk-sans

	(nerdfonts.override { fonts = [ "FantasqueSansMono" "SourceCodePro" ]; })
];

fontconfig = {
	defaultFonts = {
		serif = [ "Source Serif 4" "Roboto Slab" "Ubuntu" "Noto Sans CJK HK" ];
		sansSerif = [ "Source Sans 3" "Ubuntu" ];
		monospace = [ "Fantasque Sans Mono" "Source Code Pro" "Ubuntu Mono" ];
		emoji = [ "Blobmoji" ];
		};
	};
}
