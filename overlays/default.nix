final: prev:
{
  postman = prev.postman.overrideAttrs (old: rec {
    version = "10.18.10";
    src = prev.fetchurl {
      url = "https://dl.pstmn.io/download/version/${version}/linux64";
      sha256 = "sha256-CAY9b2O+1vROUEfGRReZex9Sh5lb3sIC4TExVHRL6Vo=";
      name = "postman-${version}.tar.gz";
    };
  });
  brave = prev.brave.overrideAttrs (old: rec {
    version = "1.61.93";
    src = prev.fetchurl {
      url = "https://github.com/brave/brave-browser/releases/download/v${version}/brave-browser_${version}_amd64.deb";
      sha256 = "sha256-X94IE6u9VglKFCMU9GHETIC+seNzBQEUUcii/FicWdI=";
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
