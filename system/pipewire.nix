{ pkgs, ... }:
{
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
    jack.enable = true;
    configPackages = [
      (pkgs.writeTextDir "share/pipewire/pipewire.conf.d/10-raop-discover.conf" ''
        context.modules = [{
          name = libpipewire-module-raop-discover
            args = {
              #roap.discover-local = false;
              #raop.latency.ms = 1000
              stream.rules = [{
                matches = [{
                  raop.ip = "~.*"
                  #raop.port = 1000
                  #raop.name = ""
                  #raop.hostname = ""
                  #raop.domain = ""
                  #raop.device = ""
                  #raop.transport = "udp" | "tcp"
                  #raop.encryption.type = "RSA" | "auth_setup" | "none"
                  #raop.audio.codec = "PCM" | "ALAC" | "AAC" | "AAC-ELD"
                  #audio.channels = 2
                  #audio.format = "S16" | "S24" | "S32"
                  #audio.rate = 44100
                  #device.model = ""
                }]
                actions = {
                  create-stream = {
                    #raop.password = ""
                    stream.props = {
                      #target.object = ""
                      #media.class = "Audio/Sink"
                    }
                  }
                }
              }]
            }
        }]
      '')
    ];
  };
}
