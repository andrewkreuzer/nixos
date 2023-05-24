let
  akreuzer = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIBXr/Ury9+pJR7sFtONDp89pWAGejCv8KTo/Cy9P2BEO";
  users = [ akreuzer ];

  carnahan = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIC71Hbqlv1V+9M/aywgfga8F80TsmADFrwJwL8hutZIt";
  croft = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIELzGrsWvM2X/J80cO4q7c9K1ySXJK5skQk+l+IM4wiF";

  systems = [ carnahan croft ];
in
{
  "ssh-ed25519.age".publicKeys = users ++ systems;
  "ssh-rsa.age".publicKeys = users ++ systems;
  "boot.age".publicKeys = users ++ [ croft ];
}
