let
  ciliumVxlan = 8472;
  ciliumHealthCheck = 4240;
  ciliumHubble = 4244;
  ciliumHubbleRelay = 4245;
  ciliumMutualAuth = 4250;
  ciliumAgentPrometheus = 9962;
  ciliumOperatorPrometheus = 9963;
  ciliumEnvoyPrometheus = 9964;
  ciliumWireguard = 51871;
in
{
  kubernetes.addonManager.addons."cilium.yaml" = ./cilium.yaml;

  networking.firewall.allowedUDPPorts = [
    ciliumVxlan
    ciliumWireguard
  ];
  networking.firewall.allowedTCPPorts = [
    ciliumHealthCheck
    ciliumHubble
    ciliumHubbleRelay
    ciliumMutualAuth
    ciliumAgentPrometheus
    ciliumOperatorPrometheus
    ciliumEnvoyPrometheus
  ];
}
