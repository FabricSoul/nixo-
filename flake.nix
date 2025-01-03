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
    };
    
    nixvim = {
      url = "github:nix-community/nixvim/nixos-24.11";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };
  
  outputs = { self, nixpkgs, nixpkgs-unstable, home-manager, nixvim, hyprpanel, ... }: 
    let
      # System types to support
      supportedSystems = [ "x86_64-linux" "aarch64-linux" ];
      
      # Common nixpkgs config
      nixpkgsConfig = {
        config = {
          allowUnfree = true;
        };
      };

      # Helper to create system-specific pkgs
      pkgsFor = system: import nixpkgs {
        inherit system;
        config = nixpkgsConfig.config;
      };

      pkgsUnstableFor = system: import nixpkgs-unstable {
        inherit system;
        config = nixpkgsConfig.config;
      };
    in {
      nixosConfigurations = {
        # x86_64 system
        Tatara = nixpkgs.lib.nixosSystem {
          system = "x86_64-linux";
          specialArgs = {
            pkgs-unstable = pkgsUnstableFor "x86_64-linux";
          };
          modules = [ 
            { nixpkgs = nixpkgsConfig; }
            ./hosts/Tatara/default.nix
            home-manager.nixosModules.home-manager
            {
              home-manager.useGlobalPkgs = true;
              home-manager.useUserPackages = true;
              home-manager.extraSpecialArgs = {
                inherit nixvim hyprpanel;
                pkgs = pkgsFor "x86_64-linux";
              };
              home-manager.users.fabric = {
                imports = [
                  ./home.nix
                  nixvim.homeManagerModules.nixvim
                  hyprpanel.homeManagerModules.hyprpanel
                ];
              };
            }
          ];
        };
        
        # aarch64 system
        Nixilla = nixpkgs.lib.nixosSystem {
          system = "aarch64-linux";
          specialArgs = {
            pkgs-unstable = pkgsUnstableFor "aarch64-linux";
          };
          modules = [ 
            { nixpkgs = nixpkgsConfig; }
            ./hosts/Nixilla/default.nix
            home-manager.nixosModules.home-manager
            {
              home-manager.useGlobalPkgs = true;
              home-manager.useUserPackages = true;
              home-manager.extraSpecialArgs = {
                inherit nixvim hyprpanel;
                pkgs = pkgsFor "aarch64-linux";
              };
              home-manager.users.fabric = {
                imports = [
                  ./home.nix
                  nixvim.homeManagerModules.nixvim
                  hyprpanel.homeManagerModules.hyprpanel
                ];
              };
            }
          ];
        };
      };
      
      # For standalone home-manager usage (if needed)
      homeConfigurations = builtins.listToAttrs (map (system: {
        name = "fabric@${system}";
        value = home-manager.lib.homeManagerConfiguration {
          pkgs = pkgsFor system;
          extraSpecialArgs = {
            inherit nixvim hyprpanel;
          };
          modules = [
            ./home.nix
            nixvim.homeManagerModules.nixvim
            hyprpanel.homeManagerModules.hyprpanel
          ];
        };
      }) supportedSystems);
    };
}
