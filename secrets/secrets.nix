let
  akreuzer = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIBXr/Ury9+pJR7sFtONDp89pWAGejCv8KTo/Cy9P2BEO";
  users = [ akreuzer ];

  carnahan = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIC71Hbqlv1V+9M/aywgfga8F80TsmADFrwJwL8hutZIt";
  croft = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIELzGrsWvM2X/J80cO4q7c9K1ySXJK5skQk+l+IM4wiF";
  day = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIIt3eBHBdr5a4BY4wSuke/SiB9uxHjgo91gSEzA4W4gN";
  goode = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIPN/TlYyzbGCp2mYAzvwzCSpNcg76wT0xcw7So4zPLsj";
  montgomery = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIBwo4ktN6gu7oGEWSNnEdLC/AL0WA5gxOGhfxH5mxWlN";

  k8s-day = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAID3jPYT9fIVwQpavx0yFCn0oYKmHcHgs4vb1Das2+pUu";
  k8s-goode = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIPn4DPOZtYjZCb1kgTRH19lqe/zW82v8+sKheR9cljyt";
  k8s-montgomery = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIGeCrVKjHCxWOpWqW8kjLKIrR6sRO0cS2ifwDU39vPDX";
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
