{ me, pkgs-unstable, ... }:
{
  programs.jujutsu = {
    enable = true;
    package = pkgs-unstable.jujutsu;
    settings = {
      user = {
        name = me.githubUsername;
        email = me.email;
      };
    };
  };
}

