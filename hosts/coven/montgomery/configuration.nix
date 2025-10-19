{ me, lib, pkgs, ... }:
{
  users.users = {
    root.openssh.authorizedKeys.keys = me.sshKeys;

    ${me.username} = {
      isNormalUser = true;
      openssh.authorizedKeys.keys = me.sshKeys;
      extraGroups = [ "adbusers" "docker" "keys" "wheel" "input" "nixos" "libvirtd"];
    };
  };

  services.openssh = {
    enable = lib.mkDefault true;
    settings = {
      PasswordAuthentication = lib.mkDefault false;
    };
  };

  # security.doas = {
  #   enable = true;
  #   extraRules = [
  #   {
  #     users = [ me.username ];
  #     keepEnv = true;
  #     persist = true;
  #   }
  #   ];
  # };
  # security.sudo.enable = lib.mkForce false;

  environment.systemPackages = map lib.lowPrio [
    pkgs.curl
    pkgs.gitMinimal
  ];

  virtualisation.libvirtd.enable = true;
  virtualisation.docker.enable = true;

  boot.zfs.devNodes = "/dev/disk/by-id/";
  boot.loader.systemd-boot.enable = true;
  boot.loader.systemd-boot.editor = false;
  boot.loader.systemd-boot.configurationLimit = 5;
  boot.loader.efi.canTouchEfiVariables = true;
}
