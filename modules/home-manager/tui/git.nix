{ me, ... }:
{
  programs.git = {
    enable = true;
    settings = {
      user.name = me.githubUsername;
      user.email = me.email;
    };
  };
}
