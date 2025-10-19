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
      colmena = mkOption {
        type = types.attrsOf types.anything;
        default = { };
        description = ''
          colmena host configurations.
        '';
      };
    };
  };
}
