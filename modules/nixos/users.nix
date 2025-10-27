{ me, self, config, pkgs, ... }:
let
  relativeToRoot = self.lib.relativeToRoot;
in
{
  age.secrets.${me.username}.file = relativeToRoot "secrets/${me.username}.age";
  users.users = {
    root = { };

    ${me.username} = {
      shell = pkgs.zsh;
      isNormalUser = true;
      openssh.authorizedKeys.keys = me.sshKeys;
      hashedPasswordFile = config.age.secrets.${me.username}.path;
      extraGroups = [ "adbusers" "audio" "docker" "keys" "networkmanager" "plugdev" "video" "wheel" "input" "nixos" "libvirtd" ];
    };
  };

  home-manager.users.${me.username} =
    relativeToRoot "home/${me.username}/home.nix";

  systemd.user.services =
    self.lib.scanDirWithFn
      (relativeToRoot "home/${me.username}/systemd")
      (fn: import fn { inherit pkgs; });
}

