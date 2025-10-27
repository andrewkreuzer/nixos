{ config, lib, pkgs, ... }:
let
  hosts = [ "192.168.2.11" "localhost" "127.0.0.1" ];
  address = ":8888";
  port = 8888;
  defaultLabel = null;
  logLevel = 1;

  dataDir = "/var/lib/multirootca";
  certPathPrefix = "multirootca";
  tlsCertFile = dataDir + "/${certPathPrefix}.pem";
  tlsKeyFile = dataDir + "/${certPathPrefix}-key.pem";

  kubernetesCaPathPrefix = "kubernetes-ca";
  kubernetesCaCertFile = dataDir + "/${kubernetesCaPathPrefix}.pem";
  kubernetesCaKeyFile = dataDir + "/${kubernetesCaPathPrefix}-key.pem";

  etcdCaPathPrefix = "etcd-ca";
  etcdCaCertFile = dataDir + "/${etcdCaPathPrefix}.pem";
  etcdCaKeyFile = dataDir + "/${etcdCaPathPrefix}-key.pem";

  frontProxyCaPathPrefix = "front-proxy-ca";
  frontProxyCaCertFile = dataDir + "/${frontProxyCaPathPrefix}.pem";
  frontProxyCaKeyFile = dataDir + "/${frontProxyCaPathPrefix}-key.pem";

  cfsslConfig = pkgs.writeText "cfssl-config.json" (
    builtins.toJSON {
      signing = {
        profiles = {
          server = {
            expiry = "8760h";
            usages = [
              "digital signature"
              "key encipherment"
              "server auth"
            ];
            auth_key = "ca-auth";
          };
          client = {
            expiry = "8760h";
            usages = [
              "digital signature"
              "key encipherment"
              "client auth"
            ];
            auth_key = "ca-auth";
          };
          service_account = {
            expiry = "8760h";
            usages = [ "signing" ];
            auth_key = "ca-auth";
          };
          server_client = {
            expiry = "8760h";
            usages = [
              "digital signature"
              "key encipherment"
              "client auth"
              "server auth"
            ];
            auth_key = "ca-auth";
          };
          intermediate = {
            expiry = "8760h";
            usages = [ "cert sign" ];
            auth_key = "ca-auth";
            ca_constraint = {
              is_ca = true;
              max_path_len = 0;
              max_path_len_zero = true;
            };
          };
        };
      };
      auth_keys = {
        ca-auth = {
          type = "standard";
          key = "file:${config.age.secrets.multirootca-auth-key.path}";
        };
      };
    }
  );

  roots = {
    kubernetes_ca = {
      private = "file://${kubernetesCaKeyFile}";
      certificate = "${kubernetesCaCertFile}";
      config = toString cfsslConfig;
    };
    etcd_ca = {
      private = "file://${etcdCaKeyFile}";
      certificate = "${etcdCaCertFile}";
      config = toString cfsslConfig;
    };
    front_proxy_ca = {
      private = "file://${frontProxyCaKeyFile}";
      certificate = "${frontProxyCaCertFile}";
      config = toString cfsslConfig;
    };
  };

  rootsFile = pkgs.writeText "multirootca-config.ini" (
    lib.generators.toINI { } roots
  );

  multirootcaTlsCsr = pkgs.writeText "multirootca-csr.json" (
    builtins.toJSON {
      inherit hosts;
      CN = "multirootca";
      key = {
        algo = "ecdsa";
        size = 256;
      };
    }
  );

  genCsr = cn: pkgs.writeText "k8s-csr.json" (
    builtins.toJSON {
      CN = cn;
      key = {
        algo = "ecdsa";
        size = 256;
      };
    }
  );

  certs = {
    multiroot-tls = {
      certFile = tlsCertFile;
      profile = "server";
      csr = multirootcaTlsCsr;
      path = certPathPrefix;
    };
    kubernetes-ca = {
      certFile = kubernetesCaCertFile;
      profile = "intermediate";
      csr = genCsr "kubernetes-ca";
      path = kubernetesCaPathPrefix;
    };
    etcd-ca = {
      certFile = etcdCaCertFile;
      profile = "intermediate";
      csr = genCsr "etcd-ca";
      path = etcdCaPathPrefix;
    };
    front-proxy-ca = {
      certFile = frontProxyCaCertFile;
      profile = "intermediate";
      csr = genCsr "front-proxy-ca";
      path = frontProxyCaPathPrefix;
    };
  };
in
{
  config = {
    users.groups.multirootca = {
      gid = 298;
    };

    users.users.multirootca = {
      description = "multirootca user";
      home = dataDir;
      group = "multirootca";
      uid = 298;
    };

    systemd.services.multirootca.preStart = lib.concatStrings
      (lib.mapAttrsToList
        (name: values: ''
          if [ ! -f "${values.certFile}" ]; then
            ${pkgs.cfssl}/bin/cfssl gencert \
              -config ${cfsslConfig} \
              -profile ${values.profile} \
              -ca ${config.age.secrets.k8s-ca.path} \
              -ca-key ${config.age.secrets.k8s-ca-key.path} \
              ${values.csr} \
              | ${pkgs.cfssl}/bin/cfssljson -bare ${values.path}
          fi
        '')
        certs);

    systemd.services.multirootca = {
      description = "multirootca CA API server";
      wantedBy = [ "multi-user.target" ];
      after = [ "network.target" ];

      serviceConfig = {
        WorkingDirectory = dataDir;
        Restart = "always";
        User = "multirootca";
        Group = "multirootca";

        ExecStart =
          let
            opt = n: v: lib.optionalString (v != null) ''-${n}="${v}"'';
          in
          lib.concatStringsSep " \\\n" [
            "${pkgs.cfssl}/bin/multirootca"
            (opt "a" address)
            (opt "l" defaultLabel)
            (opt "loglevel" (toString logLevel))
            (opt "roots" (toString rootsFile))
            (opt "tls-cert" tlsCertFile)
            (opt "tls-key" tlsKeyFile)
          ];
        StateDirectory = baseNameOf dataDir;
        StateDirectoryMode = 700;
      };
    };

    networking.firewall.allowedTCPPorts = [ port ];
  };
}
