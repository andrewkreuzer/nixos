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
}
