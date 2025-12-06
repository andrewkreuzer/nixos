{ inputs, ... }:
{
  imports = [
    inputs.treefmt-nix.flakeModule
  ];
  perSystem = { inputs', config, pkgs, ... }: {
    devShells.default = pkgs.mkShell {
      name = "nix shell";
      inputsFrom = [ config.treefmt.build.devShell ];
      packages = with pkgs; [
        nixd
        nvd

        age
        cfssl
      ] ++ [
        inputs'.agenix.packages.default
        inputs'.colmena.packages.colmena
        inputs'.dev-cli.packages.default
      ];
    };

    treefmt.config = {
      projectRootFile = "flake.nix";
      programs.nixpkgs-fmt.enable = true;
    };
  };
}
