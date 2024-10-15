{ self, inputs, lib, pkgs, ... }:
let
  scripts = import ./scripts.nix { inherit pkgs; };
in
{
  _module.args.colors = import ./colors.nix;
  _module.args.scripts = scripts;
  _module.args.pkgs-unstable = import inputs.nixpkgs-unstable {
    inherit (pkgs) system;
    config = { allowUnfree = true; };
    overlays = [ self.overlays.default ];
  };

  imports = lib.attrValues
    (self.utils.files.forAllNixFiles ./pkgs
      (fn: import fn));

  programs = {
    zoxide.enable = true;
    java.enable = true;
    direnv.enable = true;
    direnv.nix-direnv.enable = true;
  };

  home.stateVersion = "24.05";
  home.packages = [
    scripts.screenshot
    scripts.brightness
    scripts.hypr-powersave
    scripts.work
    scripts.whatitdo
    scripts.mkcd
  ];
}
