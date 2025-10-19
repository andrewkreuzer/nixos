{ pkgs, ... }:
{
  services.greetd = {
    enable = true;
    vt = 3;
    settings = {
      default_session = {
        command = "${pkgs.greetd.tuigreet}/bin/tuigreet --remember --time --cmd Hyprland";
        user = "greeter";
      };
    };
  };
}
