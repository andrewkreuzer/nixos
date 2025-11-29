{ inputs, ... }:
final: prev: {
  neovim = inputs.neovim-nightly-overlay.packages.${final.stdenv.hostPlatform.system}.default ?
    inputs.neovim-nightly-overlay.packages.${final.stdenv.hostPlatform.system}.default;
  # go = prev.go.overrideAttrs (old: rec {
  #   version = "1.25.4";
  #   src = prev.fetchurl {
  #     url = "https://go.dev/dl/go${version}.linux-amd64.tar.gz";
  #     sha256 = "sha256-+VZ4P6Y5f0m3jZ5x5k7j3Yh6v5Y5Z5Y5Z5Y5Z5Y5Z5Y=";
  #   };
  # });
  # brave = prev.brave.overrideAttrs (old: rec {
  #   version = "1.66.115";
  #   src = prev.fetchurl {
  #     url = "https://github.com/brave/brave-browser/releases/download/v${version}/brave-browser_${version}_amd64.deb";
  #     sha256 = "sha256-TMQips7dyxKfYEin7QJCV0ru4NHi4j3DjLh2fmzuYeQ=";
  #   };
  # });
}
