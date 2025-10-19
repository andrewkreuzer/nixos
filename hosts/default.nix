{
  lib,
  flake-parts-lib,
  ...
}:
let
  inherit (lib)
    mkOption
    types
    ;
in
{
  imports = [
    ./carnahan
    ./coven
  ];

  options = {
    flake = flake-parts-lib.mkSubmoduleOptions {
      colmenaConfigurations = mkOption {
        type = types.attrsOf types.anything;
        default = { };
        description = ''
          colmena host configurations.
        '';
      };
    };
  };
}
