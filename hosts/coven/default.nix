{ ... }:
{
  imports = [
    ./day
    ./goode
    ./montgomery
  ];

  # config.coven.clusterIps = {
  #   k8s-day = "192.168.2.11";
  #   k8s-goode = "192.168.2.21";
  #   k8s-montgomery = "192.168.2.31";
  # };
}
