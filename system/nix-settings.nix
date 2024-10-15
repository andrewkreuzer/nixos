{ me, ... }:
{
  nix = {
    settings = {
      trusted-users = [ me.username ];
      experimental-features = [ "nix-command" "flakes" ];
      substituters = [ "https://hyprland.cachix.org" "https://cuda-maintainers.cachix.org" ];
      trusted-public-keys = [ "hyprland.cachix.org-1:a7pgxzMz7+chwVL3/pzj6jIBMioiJM7ypFP8PwtkuGc=" "cuda-maintainers.cachix.org-1:0dq3bujKpuEPMCX6U4WylrUDZ9JyUG0VpVZa7CNfq5E=" ];
    };
    extraOptions = ''
      keep-outputs = true
      keep-derivations = true
    '';
    gc = {
      automatic = true;
      dates = "weekly";
      options = "--delete-older-than 7d";
    };
  };
}
