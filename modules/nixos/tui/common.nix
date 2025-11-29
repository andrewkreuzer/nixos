{
  programs = {
    zsh.enable = true;
    git.enable = true;
    tmux.enable = true;
    adb.enable = true;
    ssh.startAgent = true;
  };

  services.fwupd.enable = true;
  services.hardware.bolt.enable = true;
  services.gnome.gnome-keyring.enable = true;
  services.gnome.gcr-ssh-agent.enable = false;
}
