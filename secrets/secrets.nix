let
  akreuzer = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIBXr/Ury9+pJR7sFtONDp89pWAGejCv8KTo/Cy9P2BEO";
  users = [ akreuzer ];

  carnahan = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIC71Hbqlv1V+9M/aywgfga8F80TsmADFrwJwL8hutZIt";
  croft = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIELzGrsWvM2X/J80cO4q7c9K1ySXJK5skQk+l+IM4wiF";
  day = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAICzYxIPadSDK9/GScNu4U8wIY8rxR3mkQ6230ZmPxOJe";
  goode = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIN4PdCDOFPSNotXXq9NgYAGvza5kuKH1U9zF/jUqKdyw";
  montgomery = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIPYFG4QfZYhthk79ftSts3Rtxw16qbBlLqjcJn8Zvauv";

  k8s-day = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIN/yeGnd2ZT0569BmxWybFhWTHHbSwM++n6k/JnhuOtL";
  k8s-goode = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIFfghbKjwL7Rd0PID9rPmF7GUL0newYMp5y5/9Ti+MYd";
  k8s-montgomery = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIDJw8tHzpy3PaJjvRAHcZYDDRO226TdAkug4uhhzuMOp";
  k8s = [ k8s-day k8s-montgomery k8s-goode ];

  systems = [ carnahan croft day goode montgomery ];
in
{
  "akreuzer.age".publicKeys = users ++ systems;
  "ssh-ed25519.age".publicKeys = users ++ systems;
  "ssh-rsa.age".publicKeys = users ++ systems;
  "boot.age".publicKeys = users ++ [ croft ];
  "ca.age".publicKeys = [ akreuzer ];
  "ca-key.age".publicKeys = [ akreuzer ];
  "k8s-ca.age".publicKeys = k8s ++ [ akreuzer ];
  "k8s-ca-key.age".publicKeys = k8s ++ [ akreuzer ];
  "k8s-sa.age".publicKeys = k8s ++ [ akreuzer ];
  "k8s-sa-key.age".publicKeys = k8s ++ [ akreuzer ];
  "multirootca-auth-key.age".publicKeys = k8s ++ [ akreuzer ];
  "tailscale.age".publicKeys = users ++ systems;
}
