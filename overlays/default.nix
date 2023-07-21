final: prev:
{
  brave = prev.brave.overrideAttrs (old: rec {
    version = "1.56.9";
    src = prev.fetchurl {
      url = "https://github.com/brave/brave-browser/releases/download/v${version}/brave-browser_${version}_amd64.deb";
      sha256 = "sha256-cw41xUewYB/M6xHZhhL9nX1J9vnNGA9TFJWI/Qwdu/k=";
    };
  });

  waybar = prev.waybar.overrideAttrs (oldAttrs: {
    mesonFlags = oldAttrs.mesonFlags ++ [ "-Dexperimental=true" ];
    patches = (oldAttrs.patches or []) ++ [
      (prev.fetchpatch {
        name = "fix waybar hyprctl";
        url = "https://aur.archlinux.org/cgit/aur.git/plain/hyprctl.patch?h=waybar-hyprland-git";
        sha256 = "sha256-pY3+9Dhi61Jo2cPnBdmn3NUTSA8bAbtgsk2ooj4y7aQ=";
      })
    ];
  });
}
