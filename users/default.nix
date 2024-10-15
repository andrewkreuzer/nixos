{ self, config, pkgs, me, ... }:
{
  age.secrets.${me.username}.file = ../secrets/${me.username}.age;
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

  home-manager = {
    users.${me.username} = ./${me.username}/home.nix;
  };

  systemd.user.services = self.utils.files.forAllNixFiles ./${me.username}/systemd
    (fn: import fn { inherit pkgs; });
}
