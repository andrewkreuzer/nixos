{ pkgs, ... }:
{
  imports = [
    ./greetd.nix
    ./hyprland.nix
    ./logind.nix
    ./openssh.nix
    ./1password.nix
  ];

  programs = {
    zsh.enable = true;
    git.enable = true;
    tmux.enable = true;
    adb.enable = true;
    ssh.startAgent = true;
  };

  services.fwupd.enable = true;
  services.blueman.enable = true;
  services.hardware.bolt.enable = true;
  services.gnome.gnome-keyring.enable = true;

  fonts.packages = with pkgs; [
    nerd-fonts.sauce-code-pro
  ];

  environment.systemPackages = builtins.attrValues
    { inherit (pkgs) libsecret zip openssl; } ++ [
    (import ./garmin/connectiq-sdk.nix { inherit pkgs; })
  ];
}
