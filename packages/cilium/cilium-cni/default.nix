{
  lib,
  buildGo125Module,
  fetchFromGitHub,
  testers,
}:

let self = buildGo125Module rec {
  pname = "cilium-cni";
  version = "1.18.3";

  src = fetchFromGitHub {
    owner = "cilium";
    repo = "cilium";
    tag = "v${version}";
    hash = "sha256-A73b9aOOYoB0hsdrvVPH1I8/LsZiCZ+NoJc2D3Mdh2g=";
  };

  subPackages = [ "plugins/cilium-cni" ];

  vendorHash = null;

  CGO_ENABLED=0;

  ldflags = [
    "-X='github.com/cilium/cilium/pkg/version.ciliumVersion=${version}'"
    "-s"
    "-w"
    "-X='github.com/cilium/cilium/pkg/envoy.requiredEnvoyVersionSHA=cb5737105ff9a4ca5d080c0c8f3ea1bfdc08de83'"
  ];

  passthru.tests.version = testers.testVersion {
    package = self;
    command = "cilium-cni --version";
    version = "${version}";
  };

  meta = {
    description = "CNI plugin to manage Cilium networking in Kubernetes clusters";
    homepage = "https://www.cilium.io/";
    changelog = "https://github.com/cilium/cilium/releases/tag/v${version}";
    license = lib.licenses.asl20;
    mainProgram = "cilium-cni";
  };
};
in self
