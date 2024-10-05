{ config, pkgs, pkgs-unstable, inputs, lib, specialArgs, options, modulesPath }:
{
  age.secrets.akreuzer.file = ../secrets/akreuzer.age;

  users.users = {
    root = {};

    akreuzer = {
      shell = pkgs.zsh;
      extraGroups = [
        "adbusers"
        "audio"
        "docker"
        "keys"
        "networkmanager"
        "plugdev"
        "video"
        "wheel"
        "input"
        "nixos"
        "libvirtd"
      ];
      isNormalUser = true;
      hashedPasswordFile = config.age.secrets.akreuzer.path;
      openssh.authorizedKeys.keys = [
        "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABgQDRHr5gkVr4ETv5vR/LJtPaytBwY7DL0CN/e5K1aMwKngofePVRQtUbm75nrBY/EWR+X7GWt/i1yDMHbpVMydDjrhgN6z72n9QEY+FxnNZN+SMR5m7n4IhAAU1SUXVz3aMURMR8j8dr+0Xng6CNQO1MJpB2slUT2TgnEHrq6CiIfhWGr4V1hJT6ZP8CeeA01ux3eiutNSgMtvECj7ttqA0XsQ8SJdP1bcmhFA4S9hY6wB3ANWZU2RdevQANODHS53jIlMzAJGUjQlGKP0HivSx3s+DRzR+BZQO1+ACxWydYF9mzhm5ibNxEpljn7Ehp0iwzYwCJ1FMf/+w7TPCGNYn89SfpwgsdHKx8NfDXeKVAX1moAogWVtjaSqImBHpnBGMWrrQlnhQtGx1DxnquL1rRnbpyD4vQz2TXI8dwnwVsls4hQNF8x4GEoCfw0qfv9kkmyng2uaYxwJCa1U2zKs9QCRGSAWEjIGSyL+6/5YHciksdTZI8Sx/2tAN/FWHZFmE= akreuzer@Adler.local"
        "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIBXr/Ury9+pJR7sFtONDp89pWAGejCv8KTo/Cy9P2BEO akreuzer@carnahan"
      ];
    };
  };

  home-manager = {
    useGlobalPkgs = true;
    useUserPackages = true;
    backupFileExtension = "bak";
    users.akreuzer = ./akreuzer/home.nix;
    extraSpecialArgs = specialArgs;
  };

  systemd.user.services.tmux = {
    enable = true;
    description = "tmux session for user %u";
    unitConfig = {
      After = "graphical-session.target";
    };

    serviceConfig = {
      Type = "forking";
      ExecStart = "${pkgs.tmux}/bin/tmux new-session -s %u -d";
      ExecStop="${pkgs.tmux}/bin/tmux kill-session -t %u";
    };

    wantedBy = [ "graphical-session.target" ];
  };
}
