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
  claude-code = prev.claude-code.overrideAttrs (old: rec {
    version = "2.1.91";
    src = prev.fetchzip {
      url = "https://registry.npmjs.org/@anthropic-ai/claude-code/-/claude-code-${version}.tgz";
      hash = "sha256-u7jdM6hTYN05ZLPz630Yj7gI0PeCSArg4O6ItQRAMy4=";
    };
    postPatch = ''
      cp ${./package-lock.json} package-lock.json
    '';
    npmDepsHash = "sha256-0ppKP+XMgTzVVZtL7GDsOjgvSPUDrUa7SoG048RLaNg=";
    npmDeps = final.fetchNpmDeps {
      src = ./.;
      hash = npmDepsHash;
    };
  });
}
