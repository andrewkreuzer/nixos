{ self, ... }:
let
  inherit (self.inputs.nixpkgs) lib;
in
{
  config.flake = {
    utils = {
      files =
        let
          mapAttrsMaybe = fn: attrs:
            lib.pipe attrs [
              (lib.mapAttrsToList fn)
              (builtins.filter (x: x != null))
              builtins.listToAttrs
            ];
        in
        {
          forAllNixFiles = dir: f:
            if builtins.pathExists dir then
              lib.pipe dir [
                builtins.readDir
                (mapAttrsMaybe (fn: type:
                  if type == "regular" then
                    let name = lib.removeSuffix ".nix" fn; in
                    lib.nameValuePair name (f "${dir}/${fn}")
                  else if type == "directory" then
                    let name = fn; in
                    lib.nameValuePair name (f "${dir}/${fn}")
                  else
                    null
                ))
              ] else { };
        };

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
  };
}
