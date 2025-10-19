{ self, inputs, config, ... }:
let
  inherit (inputs.nixpkgs) lib;
in
{
  flake.lib = {
    mkSystem = import ./mkSystem.nix { inherit self inputs config; };
    mkColmenaSystem = import ./mkColmenaSystem.nix { inherit inputs; };
    mkHome = import ./mkHome.nix { inherit self inputs config; };

    relativeToRoot = lib.path.append ../../.;

    # Scans a directory and builds a list of full paths
    #
    # imports = self.lib.scanDir ./pkgs;
    scanDir = dir: builtins.map (f: (dir + "/${f}")) (
      builtins.attrNames (
        lib.attrsets.filterAttrs (
          path: _type:
          (_type == "directory")
          || ((path != "default.nix")
            && (lib.strings.hasSuffix ".nix" path))
        ) (builtins.readDir dir)
      )
    );

    # Scans multiple directories
    # imports = self.lib.scanDirs [ ./modules ./hosts ];
    scanDirs = dirs: lib.flatten (
      map self.lib.scanDir dirs
    );

    # Scans a directory and applies a function to each file found
    #
    # overlays = self.lib.scanDirWithFn ../overlays
    #   (fn: import fn { inherit inputs; });
    scanDirWithFn = dir: func: lib.mapAttrs'
    (file: v: lib.nameValuePair (lib.removeSuffix ".nix" file) v)
      (lib.genAttrs (builtins.attrNames (
        lib.attrsets.filterAttrs (
          path: _type:
          (_type == "directory")
          || (lib.strings.hasSuffix ".nix" path)
          ) (builtins.readDir dir)
        )
    ) (file: func (dir + "/${file}")));

    # Helpers for defining disk mounts and swap
    # DEPRECATED: should use disko instead
    disks = {
      mkZfsMount = dataset: {
        device = "${dataset}";
        fsType = "zfs";
        options = [ "X-mount.mkdir" "noatime" ];
        neededForBoot = true;
      };

      mkBootMount = device: {
        device = "/dev/disk/by-id/${device}";
        fsType = "vfat";
        options = [
          "x-systemd.idle-timeout=1min"
          "x-systemd.automount"
          "noauto"
          "nofail"
          "noatime"
          "X-mount.mkdir"
        ];
      };

      mkTmpfsMount = size: {
        device = "none";
        fsType = "tmpfs";
        options = [ "size=${size}" "mode=777" ];
      };

      mkSwap = partitions: map
        (swap: {
          device = "/dev/disk/by-id/${swap}";
          discardPolicy = lib.mkDefault "both";
          randomEncryption = {
            enable = true;
            allowDiscards = lib.mkDefault true;
          };
        })
        partitions;
    };
  };
}
