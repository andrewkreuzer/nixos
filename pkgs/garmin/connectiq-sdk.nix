{pkgs}:
let
  inherit (pkgs) stdenv fetchzip autoPatchelfHook gtk3 curl libsecret xorg webkitgtk libsoup glib-networking wrapGAppsHook jdk19;
in
stdenv.mkDerivation {
  name = "connectiq-sdk-manager";

  src = fetchzip {
    url = "https://developer.garmin.com/downloads/connect-iq/sdk-manager/connectiq-sdk-manager-linux.zip";
    sha256 = "sha256-rFF9HyHsXovsi8W2FNqQmNGLijRw52jzc8IDHelzMbk=";
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
    (pkgs.libjpeg.override { enableJpeg8 = true; })
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
