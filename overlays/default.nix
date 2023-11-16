final: prev:
{
  brave = prev.brave.overrideAttrs (old: rec {
    version = "1.60.114";
    src = prev.fetchurl {
      url = "https://github.com/brave/brave-browser/releases/download/v${version}/brave-browser_${version}_amd64.deb";
      sha256 = "sha256-SOnQBFIL+v5NdAWZ+mufj6XXBMIjqqCFKgO0oeveOBk=";
    };
  });
  alacritty = prev.alacritty.overrideAttrs (old: rec {
    version = "0.12.3";
    src = prev.fetchFromGitHub {
      owner = "alacritty";
      repo = "alacritty";
      rev = "refs/tags/v${version}";
      sha256 = "sha256-SUEI7DTgs6NYT4oiqaMBNCQ8gP1XoZjPFIKhob7tfsk=";
    };

    cargoDeps = old.cargoDeps.overrideAttrs (prev.lib.const {
      name = "alacritty-vendor.tar.gz";
      inherit src;
      outputHash = "sha256-4GiFLw4MTG4/3JiJgotBGK7x6YS4vlJsqNA0IRYf954=";
    });
  });
}
