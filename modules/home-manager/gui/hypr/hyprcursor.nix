{ config, lib, pkgs, ... }:
let
  cfg = config.programs.hyprcursor;
  McMojave = pkgs.callPackage
    ({ stdenv, fetchFromGitHub }:
      stdenv.mkDerivation {
        pname = "McMojave-hypercursor";
        version = "unstable-2023-05-16";

        src = fetchFromGitHub {
          owner = "OtaK";
          repo = "McMojave-hyprcursor";
          rev = "7ed49d93f7c56df81d085fa8f70c4129956884b2";
          hash = "sha256-+Qo88EJC0nYDj9FDsNtoA4nttck81J9CQFgtrP4eBjk=";
        };

        installPhase = ''
          mkdir -p $out/share/icons/McMojave
          cp -r dist/* $out/share/icons/McMojave
        '';

        meta = {
          description = "McMojave cursor theme for Hyprland";
          homepage = "https://github.com/OtaK/McMojave-hyprcursor";
          license = lib.licenses.gpl3Only;
          platforms = lib.platforms.all;
        };
      })
    { };
in
{
  options = {
    programs.hyprcursor = {
      enable = lib.mkEnableOption "hyprcursor";
      package = lib.mkPackageOption pkgs "hyprcursor" { };
    };
  };

  config = lib.mkIf cfg.enable {
    home.packages = [ cfg.package McMojave ];
    home.pointerCursor = {
      package = McMojave;
      name = "McMojave";
      size = 24;
    };
  };
}
