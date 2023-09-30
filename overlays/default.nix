final: prev:
{
  brave = prev.brave.overrideAttrs (old: rec {
    version = "1.58.131";
    src = prev.fetchurl {
      url = "https://github.com/brave/brave-browser/releases/download/v${version}/brave-browser_${version}_amd64.deb";
      sha256 = "sha256-JzoimwjBOZlygdK0GLst8lyxUDo25HIwKlMA7DHfcRs=";
    };
  });
}
