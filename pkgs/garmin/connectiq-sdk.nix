{pkgs}:
let

  libjpeg_turbo = pkgs.libjpeg_turbo.overrideAttrs (oldAttrs: rec {
    enableJpeg8 = true;
  });

  inherit (pkgs) stdenv fetchzip autoPatchelfHook gtk3 curl libsecret xorg webkitgtk libsoup  glib-networking wrapGAppsHook jdk19;
in
stdenv.mkDerivation {
  name = "connectiq-sdk-manager";

  src = fetchzip {
    url = https://developer.garmin.com/downloads/connect-iq/sdk-manager/connectiq-sdk-manager-linux.zip;
    sha256 = "sha256-g43pyQCYC12nkPrRdMz/K036X78n/NVrN/4OlVP8qkw=";
    stripRoot = false;
  };

  nativeBuildInputs = [
    autoPatchelfHook
    wrapGAppsHook
  ];

  buildInputs = [
    gtk3
    curl
    libsecret
    xorg.libXxf86vm
    webkitgtk
    libsoup
    libjpeg_turbo
    glib-networking
    jdk19
  ];

  shellHook = ''
    export GIO_MODULE_DIR=${glib-networking}/lib/gio/modules/
    '';

  installPhase = ''
    mkdir -p "$out/bin"
    cp bin/sdkmanager "$out/bin"
    cp -r share "$out"
    '';
}
