{ pkgs }:
{
  enable = true;
  description = "tmux session for user %u";
  unitConfig = {
    After = "graphical-session.target";
  };

  serviceConfig = {
    Type = "forking";
    ExecStart = "${pkgs.tmux}/bin/tmux new-session -s %u -d";
    ExecStop = "${pkgs.tmux}/bin/tmux kill-session -t %u";
  };

  wantedBy = [ "graphical-session.target" ];
}
