{
  imports = [
    ./location.nix
    ./networking.nix
    ./nix-settings.nix
    ./openssh.nix
    ./pipewire.nix
    ./security.nix
    ./tlp.nix
    ./udev.nix
    ./virtualisation.nix
    ./wireguard.nix
    ./xserver.nix
  ];

  environment.variables = {
    EDITOR = "nvim";
    TERMINAL = "alacritty";
    BROWSER = "brave-browser";
    TERM = "xterm-256color";
  };
}
