{
  services.spotifyd = {
    enable = true;
    settings = {
      global = {
        cache_path = "/tmp/spotifyd";
        device_name = "carnahan";
        volume_controller = "alsa";
        volume_normalisation = true;
        bitrate = 320;
        backend = "pulseaudio";
        mixer = "Master";
        zeroconf_port = 5216;
      };
    };
  };
}
