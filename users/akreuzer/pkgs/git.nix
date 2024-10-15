{ me, ... }:
{
  programs.git = {
    enable = true;
    userName = me.githubUsername;
    userEmail = me.email;
  };
}
