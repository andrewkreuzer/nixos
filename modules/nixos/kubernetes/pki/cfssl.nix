{ pkgs, ... }:
let
  address = "127.0.0.1";
  port = 8888;
  cfsslCert = null;
  cfsslKey = null;

  multirootcaAddress = "127.0.0.1";
  multirootcaPort = 8889;
  multirootcaAPITokenPath = pkgs.writeText "multirootca-token"
    "0123456789ABCDEF0123456789ABCDEF";
in
{
  services.cfssl = {
    enable = true;
    address = address;
    port = port;
    tlsCert = cfsslCert;
    tlsKey = cfsslKey;
    configFile = toString (
      pkgs.writeText "cfssl-config.json" (
        builtins.toJSON {
          signing = {
            profiles = {
              multirootca = {
                auth_remote = {
                  auth_key = "ca-auth";
                  remote = "multirootca";
                };
              };
            };
          };
          auth_keys = {
            ca-auth = {
              type = "standard";
              key = "file:${multirootcaAPITokenPath}";
            };
          };
          remotes = {
            multirootca = "http://${multirootcaAddress}:${toString multirootcaPort}";
          };
        }
      )
    );
  };
}
