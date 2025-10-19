let
  akreuzer = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIBXr/Ury9+pJR7sFtONDp89pWAGejCv8KTo/Cy9P2BEO";
  users = [ akreuzer ];

  carnahan = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIC71Hbqlv1V+9M/aywgfga8F80TsmADFrwJwL8hutZIt";
  croft = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIELzGrsWvM2X/J80cO4q7c9K1ySXJK5skQk+l+IM4wiF";
  day = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIIzyo5+RFGJvfcs3LE/RF8lZbxeuNomF6gy2x58BEo3k";
  goode = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIPN/TlYyzbGCp2mYAzvwzCSpNcg76wT0xcw7So4zPLsj";
  montgomery = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIBwo4ktN6gu7oGEWSNnEdLC/AL0WA5gxOGhfxH5mxWlN";

  systems = [ carnahan croft day goode montgomery];
in
{
  "akreuzer.age".publicKeys = users ++ systems;
  "ssh-ed25519.age".publicKeys = users ++ systems;
  "ssh-rsa.age".publicKeys = users ++ systems;
  "boot.age".publicKeys = users ++ [ croft ];
}
