{config, lib, pkgs, ...}:
  with lib;
  let
    cfg = config.programs.hyprpaper;
  in {
    options = {
      programs.hyprpaper = {
        enable = mkEnableOption "hyprpaper";
        package = lib.mkPackageOption pkgs "hyprpaper" { };
        extraConfig = lib.mkOption {
          type = lib.types.lines;
          default = "";
          example = ''
            preload = /home/akreuzer/Pictures/Wallpapers/wallpaper.jpg
            wallpaper = eDP-1,/home/akreuzer/Pictures/Wallpapers/wallpaper.jpg
            ipc = off
            '';
          description = ''
            Extra configuration lines to add to `~/.config/hypr/hyprpaper.conf`.
            '';
        };
      };
    };

    config = mkIf cfg.enable {
      home.packages = [ cfg.package ];
      xdg.configFile."hypr/hyprpaper.conf".text = cfg.extraConfig;
    };
}
