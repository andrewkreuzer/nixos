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
  # brave = prev.brave.overrideAttrs (old: rec {
  #   version = "1.66.115";
  #   src = prev.fetchurl {
  #     url = "https://github.com/brave/brave-browser/releases/download/v${version}/brave-browser_${version}_amd64.deb";
  #     sha256 = "sha256-TMQips7dyxKfYEin7QJCV0ru4NHi4j3DjLh2fmzuYeQ=";
  #   };
  # });
}
