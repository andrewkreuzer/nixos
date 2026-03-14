{ colors, config, ... }:
let
  inherit (config.lib.formats.rasi) mkLiteral;
in
{
  "*" = {
    font = "SauceCodePro Nerd Font 12";

    text-color = mkLiteral "@fg0";

    margin = mkLiteral "0px";
    padding = mkLiteral "0px";
    spacing = mkLiteral "0px";

    bg0 = mkLiteral "#11111b";
    bg1 = mkLiteral "#1e1e2e";
    bg2 = mkLiteral "#313244";
    bg3 = mkLiteral "#45475a";
    fg0 = mkLiteral "#cdd6f4";
    fg1 = mkLiteral "#bac2de";
    fg2 = mkLiteral "#f5c2e7";
    fg3 = mkLiteral "#a6adc8";
  };


  window = {
    location = mkLiteral "center";
    width = mkLiteral "480";
    border-radius = mkLiteral "21px";

    background-color = mkLiteral "@bg0";
  };

  mainbox = {
    padding = mkLiteral "12px";
    background-color = mkLiteral "transparent";
  };

  inputbar = {
    background-color = mkLiteral "@bg1";
    border-color = mkLiteral "@bg3";

    border = mkLiteral "2px";
    border-radius = mkLiteral "9px";

    padding = mkLiteral "8px 16px";
    spacing = mkLiteral "8px";
    children = [ "entry" ];
  };

  entry = {
    placeholder = "Search";
    placeholder-color = mkLiteral "@fg3";
    background-color = mkLiteral "transparent";
  };

  message = {
    margin = mkLiteral "12px 0 0";
    border-radius = mkLiteral "9px";
    border-color = mkLiteral "@bg2";
    background-color = mkLiteral "@bg2";
  };

  textbox = {
    padding = mkLiteral "8px 24px";
    background-color = mkLiteral "transparent";
  };

  listview = {
    background-color = mkLiteral "transparent";

    margin = mkLiteral "12px 0 0";
    lines = 8;
    columns = 1;

    fixed-height = false;
  };

  element = {
    padding = mkLiteral "8px 16px";
    spacing = mkLiteral "8px";
    border-radius = mkLiteral "9px";
    background-color = mkLiteral "transparent";
  };

  "element normal normal" = {
    background-color = mkLiteral "transparent";
    text-color = mkLiteral "@fg0";
  };

  "element alternate normal" = {
    background-color = mkLiteral "transparent";
    text-color = mkLiteral "@fg0";
  };

  "element normal active" = {
    background-color = mkLiteral "transparent";
    text-color = mkLiteral "@fg3";
  };

  "element alternate active" = {
    background-color = mkLiteral "transparent";
    text-color = mkLiteral "@fg3";
  };

  "element selected normal" = {
    background-color = mkLiteral "@fg2";
    text-color = mkLiteral "@bg0";
  };

  "element selected active" = {
    background-color = mkLiteral "@fg2";
    text-color = mkLiteral "@bg0";
  };

  element-icon = {
    size = mkLiteral "1em";
    vertical-align = mkLiteral "0.5em";
    background-color = mkLiteral "transparent";
  };

  element-text = {
    text-color = mkLiteral "inherit";
    background-color = mkLiteral "transparent";
  };
}
