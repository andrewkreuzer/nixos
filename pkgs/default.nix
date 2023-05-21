{type, pkgs, lib, ...}:
let
  laptop =[ ./base.nix ];

  desktop =[ ./base.nix ];

  server = [ ./base.nix ];

  vm = [ ./base.nix ];
in {
 imports = [ ./base.nix ];
}
