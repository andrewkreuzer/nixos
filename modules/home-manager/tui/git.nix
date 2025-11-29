{ me, ... }:
{
  programs.git.settings = {
    enable = true;
    user.name = me.githubUsername;
    user.email = me.email;
  };
}
