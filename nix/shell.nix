{ inputs, ... }:
{
  imports = [
    inputs.treefmt-nix.flakeModule
  ];
  perSystem = { config, pkgs, ... }: {
    devShells.default = pkgs.mkShell {
      name = "nix shell";
      inputsFrom = [ config.treefmt.build.devShell ];
      packages = with pkgs; [
        nixd
        nvd
      ] ++ [
        inputs.colmena.packages.${system}.colmena
        inputs.dev-cli.packages.${system}.default
      ];
    };

    treefmt.config = {
      projectRootFile = "flake.nix";
      programs.nixpkgs-fmt.enable = true;
    };
  };
}
