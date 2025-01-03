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

    hyprland = {
        url = "github:hyprwm/Hyprland";
      };
  };
  
  outputs = { self, nixpkgs, nixpkgs-unstable, home-manager, nixvim, hyprpanel, hyprland, ... }: 
    let
      # System types to support
      systemSettings = {
        x86_64-linux = {
          system = "x86_64-linux";
          pkgs = import nixpkgs {
            system = "x86_64-linux";
            config.allowUnfree = true;
          };
          pkgs-unstable = import nixpkgs-unstable {
            system = "x86_64-linux";
            config.allowUnfree = true;
          };
        };
        aarch64-linux = {
          system = "aarch64-linux";
          pkgs = import nixpkgs {
            system = "aarch64-linux";
            config.allowUnfree = true;
          };
          pkgs-unstable = import nixpkgs-unstable {
            system = "aarch64-linux";
            config.allowUnfree = true;
          };
        };
      };
    in {
      nixosConfigurations = {
        # x86_64 system with hyprpanel
        Tatara = nixpkgs.lib.nixosSystem {
          system = systemSettings.x86_64-linux.system;
          specialArgs = {
            inherit nixvim hyprpanel hyprland;
            pkgs-unstable = systemSettings.x86_64-linux.pkgs-unstable;
          };
          modules = [ 
            ./hosts/Tatara/default.nix
            home-manager.nixosModules.home-manager
            {
              nixpkgs.config.allowUnfree = true;
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
        
        # aarch64 system without hyprpanel
        Nixilla = nixpkgs.lib.nixosSystem {
          system = systemSettings.aarch64-linux.system;
          specialArgs = {
            inherit nixvim hyprland;  # removed hyprpanel
            pkgs-unstable = systemSettings.aarch64-linux.pkgs-unstable;
          };
          modules = [ 
            ./hosts/Nixilla/default.nix
            home-manager.nixosModules.home-manager
            {
              nixpkgs.config.allowUnfree = true;
              home-manager.useGlobalPkgs = true;
              home-manager.useUserPackages = true;
              home-manager.extraSpecialArgs = {
                inherit nixvim hyprland;
              };
              home-manager.users.fabric = {
                imports = [
                  ./home.nix
                  nixvim.homeManagerModules.nixvim
                ];
              };
            }
          ];
        };
      };


      homeConfigurations = {
      "fabric@Nixilla" = home-manager.lib.homeManagerConfiguration {
        pkgs = systemSettings.aarch64-linux.pkgs;
        extraSpecialArgs = {
          inherit nixvim hyprland;
        };
        modules = [
          ./home.nix
          nixvim.homeManagerModules.nixvim
        ];
      };
    };
    };
}
