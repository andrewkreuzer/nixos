prev: final:
{
  brave = final.brave.overrideAttrs (old: rec {
    version = "1.51.118";
    src = final.fetchurl {
      url = "https://github.com/brave/brave-browser/releases/download/v${version}/brave-browser_${version}_amd64.deb";
      sha256 = "sha256-/OrnB4M6oefZ2aG2rQst8H4UZ/7vAFzyqWsn9kerb9c=";
    };
  });
}
