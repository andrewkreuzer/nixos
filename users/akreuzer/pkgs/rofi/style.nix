{ colors, config, ... }:
let
  inherit (config.lib.formats.rasi) mkLiteral;
in
{
  "*" = {
    font = "SauceCodePro 12";

    background-color = mkLiteral "transparent";
    text-color = mkLiteral "@fg0";

    margin = mkLiteral "0px";
    padding = mkLiteral "0px";
    spacing = mkLiteral "0px";

    bg0 = colors.ayu.panel_bg;
    bg1 = colors.ayu.selection_bg;
    bg2 = colors.ayu.bg;
    bg3 = colors.ayu.line;
    fg0 = colors.ayu.fg;
    fg1 = mkLiteral "#FFFFFF";
    fg2 = colors.ayu.accent;
    fg3 = colors.ayu.ui;
  };


  window = {
    location = mkLiteral "center";
    width = mkLiteral "480";
    border-radius = mkLiteral "24px";

    background-color = mkLiteral "@bg0";
  };

  mainbox = {
    padding = mkLiteral "12px";
  };

  inputbar = {
    background-color = mkLiteral "@bg1";
    border-color = mkLiteral "@bg3";

    border = mkLiteral "2px";
    border-radius = mkLiteral "16px";

    padding = mkLiteral "8px 16px";
    spacing = mkLiteral "8px";
    children = [ "prompt" "entry" ];
  };

  prompt = {
    text-color = mkLiteral "@fg2";
  };

  entry = {
    placeholder = "Search";
    placeholder-color = mkLiteral "@fg3";
  };

  message = {
    margin = mkLiteral "12px 0 0";
    border-radius = mkLiteral "16px";
    border-color = mkLiteral "@bg2";
    background-color = mkLiteral "@bg2";
  };

  textbox = {
    padding = mkLiteral "8px 24px";
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
    border-radius = mkLiteral "16px";
  };

  "element normal active" = {
    text-color = mkLiteral "@bg3";
  };

  "element alternate active" = {
    text-color = mkLiteral "@bg3";
  };

  "element selected normal, element selected active" = {
    background-color = mkLiteral "@bg3";
  };

  element-icon = {
    size = mkLiteral "1em";
    vertical-align = mkLiteral "0.5px";
  };

  element-text = {
    text-color = mkLiteral "inherit";
  };
}
