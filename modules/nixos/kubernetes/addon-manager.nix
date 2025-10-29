{
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.kubernetes.addonManager;

  dataDir = "/var/lib/kubernetes";
  addons = pkgs.runCommand "kubernetes-addons" { } ''
    mkdir -p $out
    # since we are mounting the addons to the addon manager, they need to be copied
    ${lib.concatMapStringsSep ";" (a: "cp -v ${a}/* $out/") (
      lib.mapAttrsToList (name: addon: pkgs.writeTextDir "${name}.json" (builtins.toJSON addon)) (
        cfg.addons
      )
    )}
  '';

  caFile = "/var/lib/pki/kubernetes-ca.pem";
  certFile = "/var/lib/pki/kube-addon-manager.pem";
  keyFile = "/var/lib/pki/kube-addon-manager-key.pem";

  kubeMasterAddress = "192.168.2.9";
  kubeMasterAPIServerPort = 443;
  apiserverAddress = "https://${kubeMasterAddress}:${toString kubeMasterAPIServerPort}";
  kubeconfig = pkgs.writeText "addon-manager" (
    builtins.toJSON {
      apiVersion = "v1";
      kind = "Config";
      clusters = [
        {
          name = "local";
          cluster.certificate-authority = caFile;
          cluster.server = apiserverAddress;
        }
      ];
      users = [
        {
          name = "kube-addon-manager";
          user = {
            client-certificate = certFile;
            client-key = keyFile;
          };
        }
      ];
      contexts = [
        {
          context = {
            cluster = "local";
            user = "kube-addon-manager";
          };
          name = "local";
        }
      ];
      current-context = "local";
    }
  );

in
{
  options.kubernetes.addonManager = with lib.types; {

    bootstrapAddons = lib.mkOption {
      description = ''
        Bootstrap addons are like regular addons, but they are applied with cluster-admin rights.
        They are applied at addon-manager startup only.
      '';
      default = { };
      type = attrsOf attrs;
      example = lib.literalExpression ''
        {
          "my-service" = {
            "apiVersion" = "v1";
            "kind" = "Service";
            "metadata" = {
              "name" = "my-service";
              "namespace" = "default";
            };
            "spec" = { ... };
          };
        }
      '';
    };

    addons = lib.mkOption {
      description = "Kubernetes addons (any kind of Kubernetes resource can be an addon).";
      default = { };
      type = attrsOf (either attrs (listOf attrs));
      example = lib.literalExpression ''
        {
          "my-service" = {
            "apiVersion" = "v1";
            "kind" = "Service";
            "metadata" = {
              "name" = "my-service";
              "namespace" = "default";
            };
            "spec" = { ... };
          };
        }
        // import <nixpkgs/nixos/modules/services/cluster/kubernetes/dns.nix> { cfg = config.services.kubernetes; };
      '';
    };
  };

  config = {
    environment.etc."kubernetes/addons".source = "${addons}/";

    systemd.services.kube-addon-manager = {
      description = "Kubernetes addon manager";
      wantedBy = [ "kubernetes.target" ];
      after = [ "kube-apiserver.service" ];
      environment.ADDON_PATH = "/etc/kubernetes/addons/";
      environment.KUBECONFIG = kubeconfig;
      path = [ pkgs.gawk ];
      serviceConfig = {
        Slice = "kubernetes.slice";
        ExecStart = "${pkgs.kubernetes}/bin/kube-addons";
        WorkingDirectory = dataDir;
        User = "kubernetes";
        Group = "kubernetes";
        Restart = "on-failure";
        RestartSec = 10;
        PermissionsStartOnly = true;
      };
      preStart =
        with pkgs;
      let
        files = lib.mapAttrsToList (
            n: v: writeText "${n}.json" (builtins.toJSON v)
            ) cfg.bootstrapAddons;
      in
        ''
        export KUBECONFIG=/etc/kubernetes/cluster-admin.kubeconfig
      ${kubernetes}/bin/kubectl apply -f ${lib.concatStringsSep " \\\n -f " files}
      '';
      unitConfig.StartLimitIntervalSec = 0;
    };

    kubernetes.addonManager.bootstrapAddons = (
      let
        name = "system:kube-addon-manager";
        namespace = "kube-system";
      in
      {

        kube-addon-manager-r = {
          apiVersion = "rbac.authorization.k8s.io/v1";
          kind = "Role";
          metadata = {
            inherit name namespace;
          };
          rules = [
            {
              apiGroups = [ "*" ];
              resources = [ "*" ];
              verbs = [ "*" ];
            }
          ];
        };

        kube-addon-manager-rb = {
          apiVersion = "rbac.authorization.k8s.io/v1";
          kind = "RoleBinding";
          metadata = {
            inherit name namespace;
          };
          roleRef = {
            apiGroup = "rbac.authorization.k8s.io";
            kind = "Role";
            inherit name;
          };
          subjects = [
            {
              apiGroup = "rbac.authorization.k8s.io";
              kind = "User";
              inherit name;
            }
          ];
        };

        kube-addon-manager-cluster-lister-cr = {
          apiVersion = "rbac.authorization.k8s.io/v1";
          kind = "ClusterRole";
          metadata = {
            name = "${name}:cluster-lister";
          };
          rules = [
            {
              apiGroups = [ "*" ];
              resources = [ "*" ];
              verbs = [ "list" ];
            }
          ];
        };

        kube-addon-manager-cluster-lister-crb = {
          apiVersion = "rbac.authorization.k8s.io/v1";
          kind = "ClusterRoleBinding";
          metadata = {
            name = "${name}:cluster-lister";
          };
          roleRef = {
            apiGroup = "rbac.authorization.k8s.io";
            kind = "ClusterRole";
            name = "${name}:cluster-lister";
          };
          subjects = [
            {
              kind = "User";
              inherit name;
            }
          ];
        };

        apiserver-kubelet-api-admin-crb = {
          apiVersion = "rbac.authorization.k8s.io/v1";
          kind = "ClusterRoleBinding";
          metadata = {
            name = "system:kube-apiserver:kubelet-api-admin";
          };
          roleRef = {
            apiGroup = "rbac.authorization.k8s.io";
            kind = "ClusterRole";
            name = "system:kubelet-api-admin";
          };
          subjects = [
            {
              kind = "User";
              name = "system:kube-apiserver";
            }
          ];
        };
      }
    );
  };
}
