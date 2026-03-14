{ colors, ... }:
{
  services.mako = {
    enable = true;
    settings = {
      font = "SauceCodePro Nerd Font 10";
      background-color = colors.ayu.bg;
      text-color = colors.ayu.fg;
      anchor = "top-right";
      default-timeout = 10000;

      border-size = 2;
      border-color = colors.ayu.line;
      border-radius = 12;

      padding = "12";
      margin = "10";
      width = 300;
    };
  };
}
