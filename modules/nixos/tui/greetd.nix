{ pkgs, ... }:
{
  services.greetd = {
    enable = true;
    settings = {
      default_session = {
        command = "${pkgs.tuigreet}/bin/tuigreet --remember --time --cmd Hyprland";
        user = "greeter";
      };
    };
  };
}
