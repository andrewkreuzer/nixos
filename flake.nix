{
  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-24.05";
    nixpkgs-unstable.url = "github:nixos/nixpkgs/nixos-unstable";

    nixos-hardware.url = "github:NixOS/nixos-hardware/master";

    hyprland.url = "git+https://github.com/hyprwm/Hyprland?submodules=1";
    hyprland-plugins = {
      url = "github:hyprwm/hyprland-plugins";
      inputs.hyprland.follows = "hyprland";
    };
    split-monitor-workspaces = {
      url = "github:Duckonaut/split-monitor-workspaces";
      inputs.hyprland.follows = "hyprland";
    };

    # maybe??
    # dotfiles = {
    #   flake = false;
    #   url = "git+https://gitlab.com/andrewkreuzer/dotfiles?submodules=1";
    # };

    home-manager = {
      url = "github:nix-community/home-manager/release-24.05";
      inputs.nixpkgs.follows = "nixpkgs-unstable";
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
    hyprland-plugins,
    split-monitor-workspaces,
    home-manager,
    nixos-generators,
    agenix,
    neovim-nightly-overlay,
    # dotfiles,
  }@inputs: {
    nixosConfigurations = import ./hosts {
      inherit (nixpkgs) lib;
      inherit
        self
        inputs
        nixpkgs
        nixpkgs-unstable
        ;
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
