{ inputs, ... }:
final: prev: {
  neovim = inputs.neovim-nightly-overlay.packages.${final.system}.default ?
    inputs.neovim-nightly-overlay.packages.${final.system}.default;
  # brave = prev.brave.overrideAttrs (old: rec {
  #   version = "1.66.115";
  #   src = prev.fetchurl {
  #     url = "https://github.com/brave/brave-browser/releases/download/v${version}/brave-browser_${version}_amd64.deb";
  #     sha256 = "sha256-TMQips7dyxKfYEin7QJCV0ru4NHi4j3DjLh2fmzuYeQ=";
  #   };
  # });
}
