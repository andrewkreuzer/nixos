{ colors, ... }:
{
  services.mako = {
    enable = true;
    font = "SauceCodePro Nerd Font 10";
    backgroundColor = colors.ayu.bg;
    textColor = colors.ayu.fg;
    anchor = "top-left";
    defaultTimeout = 10000;

    borderSize = 1;
    borderColor = colors.ayu.line;
    borderRadius = 5;
  };
}
