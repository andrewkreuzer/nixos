{ colors, ... }:
{
  services.mako = {
    enable = true;
    settings = {
      font = "SauceCodePro Nerd Font 10";
      background-color = colors.ayu.bg;
      text-color = colors.ayu.fg;
      anchor = "top-left";
      default-timeout = 10000;

      border-size = 1;
      border-color = colors.ayu.line;
      border-radius = 5;
    };
  };
}
