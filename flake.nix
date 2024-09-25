{
	description = "Your new nix config";

	inputs = {
		# Nixpkgs
		nixpkgs.url = "github:nixos/nixpkgs/nixos-24.05";

		# Home manager
		home-manager.url = "github:nix-community/home-manager/release-24.05";
		home-manager.inputs.nixpkgs.follows = "nixpkgs";
	};

	outputs = {
		self,
		nixpkgs,
		home-manager,
		...
	} @ inputs: let
		inherit (self) outputs;
	in {
		# NixOS configuration entrypoint
		# Available through 'nixos-rebuild --flake .#your-hostname'
		nixosConfigurations = {
			# FIXME replace with your hostname
			cherry = nixpkgs.lib.nixosSystem {
				specialArgs = {inherit inputs outputs;};
				# > Our main nixos configuration file <
				modules = [./hosts/cherry/configuration.nix];
			};

			pineapple = nixpkgs.lib.nixosSystem {
				specialArgs = {inherit inputs outputs;};
				# > Our main nixos configuration file <
				modules = [./hosts/pineapple/configuration.nix];
			};
		};

		# Standalone home-manager configuration entrypoint
		# Available through 'home-manager --flake .#your-username@your-hostname'
		homeConfigurations = {
			"snuggle@cherry" = home-manager.lib.homeManagerConfiguration {
				pkgs = nixpkgs.legacyPackages.x86_64-linux; # Home-manager requires 'pkgs' instance
				extraSpecialArgs = {inherit inputs outputs;};
				# > Our main home-manager configuration file <
				modules = [
					./home-manager/home.nix
					./config/dconf/dconf.nix
					./config/dconf/cherry.nix
				];
			};
			"snuggle@pineapple" = home-manager.lib.homeManagerConfiguration {
				pkgs = nixpkgs.legacyPackages.x86_64-linux; # Home-manager requires 'pkgs' instance
				extraSpecialArgs = {inherit inputs outputs;};
				# > Our main home-manager configuration file <
				modules = [
					./home-manager/home.nix 
					./config/dconf/dconf.nix
					./config/dconf/pineapple.nix
				];
			};
		};
	};
}
