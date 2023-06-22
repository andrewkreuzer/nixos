{ pkgs, ... }:

{
  programs = {
    zsh.enable = true;
    git.enable = true;
    neovim.enable = true;
    tmux.enable = true;
    adb.enable = true;
  };

  fonts.fonts = with pkgs; [
    (nerdfonts.override { fonts = [ "SourceCodePro" ]; })
  ];

  environment.systemPackages = builtins.attrValues {
    inherit (pkgs)
      nvd
      libsecret
      zip
      openssl
      virt-manager
    ;
  } ++ [
#    (import ./garmin/connectiq-sdk.nix { inherit pkgs; })
  ];
}
