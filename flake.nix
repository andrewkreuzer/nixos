{
  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-24.05";
    nixpkgs-unstable.url = "github:nixos/nixpkgs/nixos-unstable";
    nixos-hardware.url = "github:NixOS/nixos-hardware/master";
    flake-parts.url = "github:hercules-ci/flake-parts";
    agenix.url = "github:ryantm/agenix";
    agenix.inputs.nixpkgs.follows = "nixpkgs";

    hyprland.url = "git+https://github.com/hyprwm/Hyprland?submodules=1";
    hyprland-plugins.url = "github:hyprwm/hyprland-plugins";
    split-monitor-workspaces.url = "github:Duckonaut/split-monitor-workspaces";
    split-monitor-workspaces.inputs.hyprland.follows = "hyprland";

    home-manager.url = "github:nix-community/home-manager/release-24.05";
    home-manager.inputs.nixpkgs.follows = "nixpkgs-unstable";
    neovim-nightly-overlay.url = "github:nix-community/neovim-nightly-overlay";
    treefmt-nix.url = "github:numtide/treefmt-nix";

    dev-cli.url = "github:andrewkreuzer/dev-cli";
  };

  outputs = { ... }@inputs:
    inputs.flake-parts.lib.mkFlake { inherit inputs; } {
      systems = [ "x86_64-linux" ];
      imports = map (fn: ./nix/${fn})
        (builtins.attrNames (builtins.readDir ./nix));
    };
}
