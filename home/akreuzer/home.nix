{ self, inputs, pkgs, ... }:
let
  scripts = import ./scripts.nix { inherit pkgs; };
  pkgsUnstable = import inputs.nixpkgs-unstable {
    system = pkgs.stdenv.hostPlatform.system;
    config = {
      allowUnfree = true;
      android_sdk.accept_license = true;
    };
    overlays = [ self.overlays.default ];
  };
in
{
  _module.args.colors = import ./colors.nix;
  _module.args.scripts = scripts;
  _module.args.pkgs-unstable = pkgsUnstable;

  imports = [ ];

  xdg.enable = true;
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
