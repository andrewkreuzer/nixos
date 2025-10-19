{ pkgs, ... }: with pkgs;
stdenv.mkDerivation {
  name = "connectiq-sdk-manager";

  src = fetchzip {
    url = "https://developer.garmin.com/downloads/connect-iq/sdk-manager/connectiq-sdk-manager-linux.zip";
    sha256 = "sha256-mAFVvS8MN00s06fI1lQH3gz3QsfwUyKnlv9ziTQ90m4=";
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
    libsoup_2_4
    glib-networking
    jdk21
  ] ++ [
    (libjpeg.override { enableJpeg8 = true; })
  ];

  shellHook = ''
    export GIO_MODULE_DIR=${pkgs.glib-networking}/lib/gio/modules/
  '';

  installPhase = ''
    mkdir -p "$out/bin"
    cp bin/sdkmanager "$out/bin"
    cp -r share "$out"
  '';
}

