{ me, self, lib, ... }:
{
  imports = [
    self.modules.nixos.security.openssh
  ];

  services.openssh.settings.PermitRootLogin = lib.mkForce "prohibit-password";
  users.users.root.openssh.authorizedKeys.keys = me.sshKeys;
}

