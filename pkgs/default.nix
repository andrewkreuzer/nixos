{ pkgs, ... }:

{
  programs = {
    zsh.enable = true;
    git.enable = true;
    tmux.enable = true;
    adb.enable = true;
    fuse.userAllowOther = true;
    ssh.startAgent = true;
  };

  fonts.packages = with pkgs; [
    (nerdfonts.override { fonts = [ "SourceCodePro" ]; })
  ];

  environment.systemPackages = builtins.attrValues {
    inherit (pkgs)
      nvd
      libsecret
      zip
      openssl
      virt-manager
      sshfs
      apfs-fuse
      pkg-config
      libinput-gestures
    ;
  } ++ [
  (import ./garmin/connectiq-sdk.nix { inherit pkgs; })
  ];
}
