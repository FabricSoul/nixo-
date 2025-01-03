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
      
      # Helper function to generate system-specific attributes
      forAllSystems = nixpkgs.lib.genAttrs supportedSystems;
      
      # Common nixpkgs config
      nixpkgsConfig = {
        config = {
          allowUnfree = true;
        };
      };
    in {
      nixosConfigurations = {
        # x86_64 system
        Tatara = nixpkgs.lib.nixosSystem {
          system = "x86_64-linux";
          specialArgs = { inherit nixpkgs-unstable; };
          modules = [ 
            # Apply nixpkgs configuration
            { nixpkgs = nixpkgsConfig; }
            ./hosts/Tatara/default.nix
            home-manager.nixosModules.home-manager
            {
              home-manager.useGlobalPkgs = true;
              home-manager.useUserPackages = true;
              home-manager.extraSpecialArgs = {
                inherit nixvim hyprpanel;
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
          specialArgs = { inherit nixpkgs-unstable; };
          modules = [ 
            # Apply nixpkgs configuration
            { nixpkgs = nixpkgsConfig; }
            ./hosts/Nixilla/default.nix
            home-manager.nixosModules.home-manager
            {
              home-manager.useGlobalPkgs = true;
              home-manager.useUserPackages = true;
              home-manager.extraSpecialArgs = {
                inherit nixvim hyprpanel;
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
      homeConfigurations = forAllSystems (system: {
        "fabric" = home-manager.lib.homeManagerConfiguration {
          pkgs = import nixpkgs (nixpkgsConfig // { inherit system; });
          extraSpecialArgs = {
            inherit nixvim hyprpanel;
          };
          modules = [
            ./home.nix
            nixvim.homeManagerModules.nixvim
            hyprpanel.homeManagerModules.hyprpanel
          ];
        };
      });
    };
}
