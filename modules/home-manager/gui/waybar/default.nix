{ pkgs-unstable, pkgs, ... }:
let
  # Icon lists
  backlightIcons = [ "" "" "" "" "" "" "" "" "" ];
  batteryIcons = [ "󰂎" "󰁺" "󰁻" "󰁼" "󰁽" "󰁾" "󰁿" "󰂀" "󰂁" "󰂂" "󰁹" ];

  # Custom modules
  customPower = {
    format = "{}";
    rotate = 0;
    exec = "echo ; echo  logout";
    on-click = "waybar-power 1";
    on-click-right = "waybar-power 2";
    interval = 86400;
    tooltip = true;
  };

  customWallchange = {
    format = "{}";
    rotate = 0;
    exec = "echo ; echo 󰆊 switch wallpaper";
    on-click = "swwwallpaper.sh -n";
    on-click-right = "swwwallpaper.sh -p";
    on-click-middle = "sleep 0.1 && swwwallselect.sh";
    interval = 86400;
    tooltip = true;
  };

  customSpotify = {
    format = "{}";
    return-type = "json";
    exec = "waybar-spotify";
    on-click = "playerctl play-pause --player spotify";
    on-click-right = "playerctl next --player spotify";
    on-click-middle = "playerctl previous --player spotify";
    on-scroll-up = "volumecontrol.sh -p spotify i";
    on-scroll-down = "volumecontrol.sh -p spotify d";
    max-length = 45;
    escape = true;
    tooltip = true;
  };

  customLEnd = { format = " "; interval = "once"; tooltip = false; };
  customREnd = { format = " "; interval = "once"; tooltip = false; };
  customSlEnd = { format = " "; interval = "once"; tooltip = false; };
  customSrEnd = { format = " "; interval = "once"; tooltip = false; };
  customRlEnd = { format = " "; interval = "once"; tooltip = false; };
  customRrEnd = { format = " "; interval = "once"; tooltip = false; };
  customPadd = { format = "  "; interval = "once"; tooltip = false; };

  # Standard modules
  hyprlandWorkspaces = {
    format = "{icon}";
    active-only = false;
    persistent-workspaces = {
      "eDP-1" = [ 1 2 3 ];
      "DP-7" = [ 11 12 13 ];
      "DP-9" = [ 21 22 23 ];
    };
  };

  wlrTaskbar = {
    format = "{icon}";
    rotate = 0;
    icon-size = 18;
    icon-theme = "Tela-circle-dark";
    spacing = 0;
    tooltip-format = "{title}";
    on-click = "activate";
    on-click-middle = "close";
  };

  idleInhibitor = {
    format = "{icon}";
    rotate = 0;
    format-icons = {
      activated = "󰥔";
      deactivated = "";
    };
  };

  clockModule = {
    format = "{:%I:%M %p}";
    rotate = 0;
    format-alt = "{:%R 󰃭 %d·%m·%y}";
    tooltip-format = "<span>{calendar}</span>";
    calendar = {
      mode = "month";
      mode-mon-col = 3;
      on-scroll = 1;
      on-click-right = "mode";
      format = {
        months = "<span color='#ffead3'><b>{}</b></span>";
        weekdays = "<span color='#ffcc66'><b>{}</b></span>";
        today = "<span color='#ff6699'><b>{}</b></span>";
      };
    };
    actions = {
      on-click-right = "mode";
      on-click-forward = "tz_up";
      on-click-backward = "tz_down";
      on-scroll-up = "shift_up";
      on-scroll-down = "shift_down";
    };
  };

  privacyModule = {
    icon-spacing = 4;
    icon-size = 18;
    transition-duration = 250;
    modules = [
      { type = "screenshare"; tooltip = true; tooltip-icon-size = 12; }
      { type = "audio-out"; tooltip = true; tooltip-icon-size = 12; }
      { type = "audio-in"; tooltip = true; tooltip-icon-size = 12; }
    ];
  };

  trayModule = { icon-size = 18; rotate = 0; spacing = 5; };

  batteryModule = {
    states = { good = 95; warning = 30; critical = 20; };
    format = "{icon} {capacity}%";
    rotate = 0;
    format-charging = " {capacity}%";
    format-plugged = " {capacity}%";
    format-alt = "{time} {icon}";
    format-icons = batteryIcons;
  };

  backlightModule = {
    device = "intel_backlight";
    rotate = 0;
    format = "{icon} {percent}%";
    format-icons = backlightIcons;
    on-scroll-up = "brightnessctl set 1%+";
    on-scroll-down = "brightnessctl set 1%-";
    min-length = 6;
  };

  networkModule = {
    tooltip = true;
    format-wifi = " ";
    rotate = 0;
    format-ethernet = "<span foreground='#99ffdd'> {bandwidthDownBytes}</span> <span foreground='#ffcc66'> {bandwidthUpBytes}</span>";
    tooltip-format = "Network: <big><b>{essid}</b></big>\nSignal strength: <b>{signaldBm}dBm ({signalStrength}%)</b>\nFrequency: <b>{frequency}MHz</b>\nInterface: <b>{ifname}</b>\nIP: <b>{ipaddr}/{cidr}</b>\nGateway: <b>{gwaddr}</b>\nNetmask: <b>{cidr}</b>";
    format-linked = "󰈀 {ifname} (No IP)";
    format-disconnected = "󰖪 ";
    tooltip-format-disconnected = "Disconnected";
    interval = 2;
  };

  pulseaudioModule = {
    format = "{icon}  {volume}%";
    rotate = 0;
    format-bluetooth = " {volume}%";
    format-bluetooth-muted = "  {volume}%";
    format-muted = " {volume}%";
    on-click = "pavucontrol -t 3";
    on-click-middle = "volumecontrol.sh -o m";
    on-scroll-up = "volumecontrol.sh -o i";
    on-scroll-down = "volumecontrol.sh -o d";
    tooltip-format = "{icon} {desc} // {volume}%";
    scroll-step = 5;
    format-icons = {
      headphone = "";
      hands-free = "";
      headset = "";
      phone = "";
      portable = "";
      car = "";
      default = [ "" "" "" ];
    };
  };

  pulseaudioMicrophone = {
    format = "{format_source}";
    rotate = 0;
    format-source = " {volume}% ";
    format-source-muted = "  ";
    on-click = "pavucontrol -t 4";
    on-click-middle = "volumecontrol.sh -i m";
    on-scroll-up = "volumecontrol.sh -i i";
    on-scroll-down = "volumecontrol.sh -i d";
    tooltip-format = "{format_source} {source_desc} // {source_volume}%";
    scroll-step = 5;
  };

  temperatureModule = {
    format = "{temperatureC}°C ";
    format-critical = "{temperatureC}°C ";
    critical-threshold = 100;
    hwmon-path = "/sys/class/hwmon/hwmon6/temp1_input";
  };

  # Module layout lists
  modulesLeft = [
    "custom/padd"
    "custom/l_end"
    "custom/power"
    "privacy"
    "custom/r_end"
    "custom/l_end"
    "hyprland/workspaces"
    "custom/r_end"
    "custom/l_end"
    "wlr/taskbar"
    "custom/r_end"
    ""
    "custom/padd"
  ];

  modulesCenter = [
    "custom/padd"
    "custom/l_end"
    "idle_inhibitor"
    "clock"
    "privacy"
    "custom/r_end"
    "custom/padd"
  ];

  modulesCenterWithSpotify = [
    "custom/padd"
    "custom/l_end"
    "idle_inhibitor"
    "clock"
    "custom/spotify"
    "custom/r_end"
    "custom/padd"
  ];

  modulesRight = [
    "custom/padd"
    "custom/l_end"
    "tray"
    "network"
    "custom/r_end"
    "custom/l_end"
    "backlight"
    "battery"
    "pulseaudio"
    "pulseaudio#microphone"
    "temperature"
    "custom/r_end"
    "custom/padd"
  ];

  # Shared module definitions for all bars
  sharedModules = {
    "custom/power" = customPower;
    "custom/wallchange" = customWallchange;
    "hyprland/workspaces" = hyprlandWorkspaces;
    "wlr/taskbar" = wlrTaskbar;
    idle_inhibitor = idleInhibitor;
    clock = clockModule;
    privacy = privacyModule;
    tray = trayModule;
    battery = batteryModule;
    backlight = backlightModule;
    network = networkModule;
    pulseaudio = pulseaudioModule;
    "pulseaudio#microphone" = pulseaudioMicrophone;
    temperature = temperatureModule;
    "custom/l_end" = customLEnd;
    "custom/r_end" = customREnd;
    "custom/sl_end" = customSlEnd;
    "custom/sr_end" = customSrEnd;
    "custom/rl_end" = customRlEnd;
    "custom/rr_end" = customRrEnd;
    "custom/padd" = customPadd;
  };
in
{
  home.packages = builtins.attrValues {
    inherit (pkgs)
      playerctl
      ;
  };
  programs.waybar = {
    enable = true;
    package = pkgs-unstable.waybar;
    systemd = { enable = true; };
    settings = [
      # eDP-1 bar (laptop screen, top)
      (sharedModules // {
        layer = "top";
        output = "eDP-1";
        position = "top";
        mode = "dock";
        height = 21;
        exclusive = true;
        passthrough = false;
        gtk-layer-shell = true;
        reload_style_on_change = true;
        modules-left = modulesLeft;
        modules-center = modulesCenter;
        modules-right = modulesRight;
      })
      # DP-7 bar (external monitor, top, with spotify)
      (sharedModules // {
        layer = "top";
        output = "DP-7";
        position = "top";
        mode = "dock";
        height = 21;
        exclusive = true;
        passthrough = false;
        gtk-layer-shell = true;
        reload_style_on_change = true;
        modules-left = modulesLeft;
        modules-center = modulesCenterWithSpotify;
        modules-right = modulesRight;
        "custom/spotify" = customSpotify;
      })
      # DP-9 bar (external monitor, bottom)
      (sharedModules // {
        layer = "top";
        output = "DP-9";
        position = "bottom";
        mode = "dock";
        height = 31;
        exclusive = true;
        passthrough = false;
        gtk-layer-shell = true;
        reload_style_on_change = true;
        modules-left = modulesLeft;
        modules-center = modulesCenter;
        modules-right = modulesRight;
        "wlr/taskbar" = wlrTaskbar // {
          app_ids-mapping = {
            brave = "brave-desktop";
          };
        };
      })
    ];
    style = ./style.css;
  };
}
