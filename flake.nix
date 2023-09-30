{
  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-23.05";
    nixpkgs-unstable.url = "github:nixos/nixpkgs/nixos-unstable";

    nixos-hardware.url = "github:NixOS/nixos-hardware/master";

    hyprland.url = "github:hyprwm/Hyprland";

    home-manager = {
      url = "github:nix-community/home-manager/release-23.05";
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

    neovim-nightly-overlay.url = "github:nix-community/neovim-nightly-overlay";
  };

  outputs = {
    self,
    nixpkgs,
    nixpkgs-unstable,
    nixos-hardware,
    hyprland,
    home-manager,
    nixos-generators,
    agenix,
    neovim-nightly-overlay,
  }@inputs: {
    nixosConfigurations = import ./hosts {
      inherit (nixpkgs) lib;
      inherit
        self
        inputs
        nixpkgs
        nixpkgs-unstable
        nixos-hardware
        hyprland
        home-manager
        nixos-generators
        agenix
        neovim-nightly-overlay;
    };

    packages.x86_64-linux = import ./hosts/generators.nix {
      inherit (nixpkgs) lib;
      inherit
        nixpkgs
        nixpkgs-unstable
        home-manager
        nixos-generators
        agenix;
    };
  };
}
