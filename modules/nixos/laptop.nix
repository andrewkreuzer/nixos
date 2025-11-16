{ self, pkgs, ... }:
let
  nixModules = self.modules.nixos;
in
{
  services.fprintd.enable = true;

  imports = [
    nixModules.common
    nixModules.tui.default
    nixModules.gui.default

    nixModules.networking
    nixModules.security.security
    nixModules.security.openssh
    nixModules.security.privliage-escalation
    nixModules.tailscale.default
  ];

  hardware.bluetooth.enable = true;
  hardware.graphics.enable = true;

  hardware.graphics.extraPackages = with pkgs; [
    intel-media-driver
    intel-compute-runtime
    vpl-gpu-rt
  ];

  hardware.graphics.extraPackages32 = with pkgs; [
    driversi686Linux.intel-media-driver
  ];

  services.fstrim.enable = true;
  services.blueman.enable = true;
  services.thermald.enable = true;
  services.pulseaudio.enable = false;
  security.rtkit.enable = true;

  services.logind = {
    powerKey = "suspend"; # keep pressing this when scanning fprint
    powerKeyLongPress = "poweroff";
    lidSwitch = "suspend";
    lidSwitchExternalPower = "suspend";
    lidSwitchDocked = "suspend";
  };

  services.xserver = {
    enable = true;
    displayManager.lightdm.enable = false;
    displayManager.gdm.enable = false;
    desktopManager.gnome.enable = false;
    xkb.options = "caps:escape_shifted_capslock";
  };

  virtualisation = {
    libvirtd = {
      enable = true;
    };
    docker = {
      enable = true;

      /* rootless = { */
      /*   enable = true; */
      /*   setSocketVariable = true; */
      /* }; */
    };
  };

  services.udev = {
    packages = [
      pkgs.zsa-udev-rules
      pkgs.yubikey-personalization
    ];
    extraRules = ''
      ACTION=="add", SUBSYSTEM=="backlight", RUN+="${pkgs.coreutils}/bin/chgrp video /sys/class/backlight/%k/brightness"
      ACTION=="add", SUBSYSTEM=="backlight", RUN+="${pkgs.coreutils}/bin/chmod g+w /sys/class/backlight/%k/brightness"
      ACTION=="add", SUBSYSTEM=="leds", RUN+="${pkgs.coreutils}/bin/chgrp video /sys/class/leds/%k/brightness"
      ACTION=="add", SUBSYSTEM=="leds", RUN+="${pkgs.coreutils}/bin/chmod g+w /sys/class/leds/%k/brightness"
    '';
  };

  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
    jack.enable = true;
    configPackages = [
      (pkgs.writeTextDir "share/pipewire/pipewire.conf.d/10-raop-discover.conf" ''
        context.modules = [{
          name = libpipewire-module-raop-discover
            args = {
              #roap.discover-local = false;
              #raop.latency.ms = 1000
              stream.rules = [{
                matches = [{
                  raop.ip = "~.*"
                  #raop.port = 1000
                  #raop.name = ""
                  #raop.hostname = ""
                  #raop.domain = ""
                  #raop.device = ""
                  #raop.transport = "udp" | "tcp"
                  #raop.encryption.type = "RSA" | "auth_setup" | "none"
                  #raop.audio.codec = "PCM" | "ALAC" | "AAC" | "AAC-ELD"
                  #audio.channels = 2
                  #audio.format = "S16" | "S24" | "S32"
                  #audio.rate = 44100
                  #device.model = ""
                }]
                actions = {
                  create-stream = {
                    #raop.password = ""
                    stream.props = {
                      #target.object = ""
                      #media.class = "Audio/Sink"
                    }
                  }
                }
              }]
            }
        }]
      '')
    ];
  };
}
