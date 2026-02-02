{ pkgs, lib, ... }:
let
  mkLiteral = value: {
    _type = "literal";
    inherit value;
  };
in
{
  enable = true;
  package = pkgs.rofi;
  terminal = "kitty";
  theme = {
    "*" = {
      background = mkLiteral "rgba(30, 30, 46, 0.95)";
      background-alt = mkLiteral "rgba(49, 50, 68, 0.95)";
      foreground = mkLiteral "#cdd6f4";
      selected = mkLiteral "#89b4fa";
      active = mkLiteral "#a6e3a1";
      urgent = mkLiteral "#f38ba8";
      border-color = mkLiteral "rgba(137, 180, 250, 0.5)";
    };

    window = {
      transparency = "real";
      location = mkLiteral "center";
      anchor = mkLiteral "center";
      fullscreen = false;
      width = mkLiteral "600px";
      border = mkLiteral "2px";
      border-color = mkLiteral "@border-color";
      border-radius = mkLiteral "12px";
      cursor = "default";
      background-color = mkLiteral "@background";
    };

    mainbox = {
      enabled = true;
      spacing = mkLiteral "10px";
      padding = mkLiteral "20px";
      background-color = mkLiteral "transparent";
      children = map mkLiteral [ "inputbar" "listview" ];
    };

    inputbar = {
      enabled = true;
      spacing = mkLiteral "10px";
      padding = mkLiteral "12px";
      border-radius = mkLiteral "10px";
      background-color = mkLiteral "@background-alt";
      text-color = mkLiteral "@foreground";
      children = map mkLiteral [ "prompt" "entry" ];
    };

    prompt = {
      enabled = true;
      background-color = mkLiteral "transparent";
      text-color = mkLiteral "inherit";
    };

    entry = {
      enabled = true;
      background-color = mkLiteral "transparent";
      text-color = mkLiteral "inherit";
      cursor = mkLiteral "text";
      placeholder = "Search...";
      placeholder-color = mkLiteral "inherit";
    };

    listview = {
      enabled = true;
      columns = 1;
      lines = 8;
      cycle = true;
      dynamic = true;
      scrollbar = false;
      layout = mkLiteral "vertical";
      reverse = false;
      fixed-height = true;
      fixed-columns = true;
      spacing = mkLiteral "5px";
      background-color = mkLiteral "transparent";
      text-color = mkLiteral "@foreground";
      cursor = "default";
    };

    element = {
      enabled = true;
      spacing = mkLiteral "10px";
      padding = mkLiteral "10px";
      border-radius = mkLiteral "10px";
      background-color = mkLiteral "transparent";
      text-color = mkLiteral "@foreground";
      cursor = mkLiteral "pointer";
    };

    "element normal.normal" = {
      background-color = mkLiteral "transparent";
      text-color = mkLiteral "@foreground";
    };

    "element selected.normal" = {
      background-color = mkLiteral "@selected";
      text-color = mkLiteral "@background";
    };

    "element-icon" = {
      background-color = mkLiteral "transparent";
      text-color = mkLiteral "inherit";
      size = mkLiteral "32px";
      cursor = mkLiteral "inherit";
    };

    "element-text" = {
      background-color = mkLiteral "transparent";
      text-color = mkLiteral "inherit";
      highlight = mkLiteral "inherit";
      cursor = mkLiteral "inherit";
      vertical-align = mkLiteral "0.5";
      horizontal-align = mkLiteral "0.0";
    };
  };

  extraConfig = {
    modi = "drun,run,window,filebrowser";
    show-icons = true;
    display-drun = " ";
    display-run = " ";
    display-filebrowser = " ";
    display-window = " ";
    drun-display-format = "{name}";
    hover-select = false;
    me-select-entry = "";
    me-accept-entry = "MousePrimary";
  };
}
