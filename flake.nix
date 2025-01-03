{
  description = "Fabric's flake";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs?ref=nixos-24.11";
    nixpkgs-unstable.url = "github:NixOS/nixpkgs/nixpkgs-unstable";
    
    home-manager = {
      url = "github:nix-community/home-manager/release-24.11";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    
    hyprpanel = {
      url = "github:jas-singhfsu/hyprpanel";
      inputs.nixpkgs.follows = "nixpkgs";
      # inputs.home-manager.follows = "home-manager"; # Add this line
    };

    nixvim = {
      url = "github:nix-community/nixvim/nixos-24.11";
      # If using a stable channel you can use `url = "github:nix-community/nixvim/nixos-<version>"`
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = { self, nixpkgs, nixpkgs-unstable, home-manager, nixvim, hyprpanel,...}: 
    let
      lib = nixpkgs.lib;
      systems = [ "x86_64-linux" "aarch64-linux" ];
      forAllSystems = nixpkgs.lib.genAttrs systems;
      pkgsFor = system: import nixpkgs {
        inherit system;
        config.allowUnfree = true;  # if you need unfree packages
      };
    in {
      nixosConfigurations = {
        Tatara = lib.nixosSystem {
          system = "x86_64-linux";
          modules = [ 
            ./hosts/Tatara/default.nix
          ];
        };
        Nixilla = lib.nixosSystem {
          system = "aarch_64-linux";
          modules = [ 
            ./hosts/Nixilla/default.nix
          ];
        };
      };

      homeConfigurations.fabric = home-manager.lib.homeManagerConfiguration {
        inherit pkgs;
        extraSpecialArgs = {
          inherit nixvim hyprpanel;
        };
        modules = [
	  ./home.nix
	 nixvim.homeManagerModules.nixvim
	 hyprpanel.homeManagerModules.hyprpanel
	];
     };
   };
}	
