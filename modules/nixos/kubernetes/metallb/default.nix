let
  namespace = "metallb-system";
  labels = {
    "addonmanager.kubernetes.io/mode" = "Reconcile";
  };
in
{
  kubernetes.addonManager.addons."metallb.yaml" = ./metallb.yaml;

  kubernetes.addonManager.addons = {
    loadbalancer-ips = {
      apiVersion = "metallb.io/v1beta1";
      kind = "IPAddressPool";
      metadata = {
        inherit namespace labels;
        name = "ip-pool";
      };
      spec = {
        addresses = [ "192.168.2.50/32" ];
      };
    };

    loadbalancer-l2-advertisement = {
      apiVersion = "metallb.io/v1beta1";
      kind = "L2Advertisement";
      metadata = {
        inherit namespace labels;
        name = "ip-advertisement";
      };
    };
  };
}
