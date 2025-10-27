{ me, inputs, pkgs, ... }: {
  location.provider = "geoclue2";
  time.timeZone = "America/Toronto";

  services.thermald.enable = true;

  fonts.packages = with pkgs; [
    nerd-fonts.sauce-code-pro
  ];

  imports = [
    inputs.agenix.nixosModules.default
  ];

  environment.systemPackages = builtins.attrValues {
    inherit (pkgs)
      libsecret
      zip
      openssl;
  };

  environment.variables = {
    EDITOR = "nvim";
    TERMINAL = "ghostty";
    BROWSER = "brave-browser";
    TERM = "xterm-256color";
  };

  nix.gc.automatic = true;
  nix.gc.dates = "weekly";
  nix.gc.options = "--delete-older-than 7d";
  nix.extraOptions = ''
    keep-outputs = true
    keep-derivations = true
  '';
  nix.settings = {
    trusted-users = [ me.username ];
    experimental-features = [ "nix-command" "flakes" ];
    substituters = [
      "https://hyprland.cachix.org"
      "https://nix-community.cachix.org"
    ];
    trusted-public-keys = [
      "hyprland.cachix.org-1:a7pgxzMz7+chwVL3/pzj6jIBMioiJM7ypFP8PwtkuGc="
      "nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs="
    ];
  };
}
