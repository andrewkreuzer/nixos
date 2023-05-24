{
  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-22.11";
    nixpkgs-unstable.url = "github:nixos/nixpkgs/nixos-unstable";

    hyprland.url = "github:hyprwm/Hyprland";
    hyprpaper.url = "github:hyprwm/hyprpaper";

    home-manager = {
      url = "github:nix-community/home-manager/release-22.11";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    nixos-generators = {
      url = "github:nix-community/nixos-generators";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    agenix = {
      url = "github:ryantm/agenix";
      inputs.nixpkgs.follows = "nixpkgs";
      inputs.darwin.follows = "";
    };
  };

  outputs = {
    self,
    nixpkgs,
    nixpkgs-unstable,
    hyprland,
    hyprpaper,
    home-manager,
    nixos-generators,
    agenix,
  }:
    let
    lib = nixpkgs.lib;
    mk = import ./lib { inherit lib nixos-generators nixpkgs nixpkgs-unstable; };
  in {
    nixosConfigurations =
      with mk;
      {
        carnahan = mkSystem {
          inherit lib;
          name = "carnahan";
          system = "x86_64-linux";
          extraOverlays = [
            hyprland.overlays.default
            /* hyprpaper.overlays.default */
          ];
          extraMods = [
            agenix.nixosModules.default
            hyprland.nixosModules.default
            home-manager.nixosModules.home-manager
          ];
        };
        croft = mkSystem {
          inherit lib;
          name = "croft";
          system = "x86_64-linux";
          extraOverlays = [ ];
          extraMods = [
            agenix.nixosModules.default
            home-manager.nixosModules.home-manager
          ];
        };
      };

    packages.x86_64-linux =
      with mk;
      {
        lisbon = mkGenerator {
          inherit lib;
          name = "lisbon";
          format = "virtualbox";
          system = "x86_64-linux";
          extraOverlays = [];
          extraMods = [
            home-manager.nixosModules.home-manager
          ];
        };

        jones = mkGenerator {
          inherit lib;
          name = "jones";
          format = "qcow";
          system = "x86_64-linux";
          extraOverlays = [];
          extraMods = [
            home-manager.nixosModules.home-manager
          ];
        };

        iso = mkGenerator {
          inherit lib;
          name = "iso";
          format = "install-iso";
          system = "x86_64-linux";
          extraOverlays = [];
          extraMods = [
            home-manager.nixosModules.home-manager
          ];
        };
      };
    };
}
