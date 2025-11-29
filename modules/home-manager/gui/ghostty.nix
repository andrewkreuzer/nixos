{ inputs, pkgs, ... }:
{
  home.file.".config/ghostty/config".text = ''
    term=xterm-256color
    window-decoration=none
    window-padding-balance=true

    background=#0A0E14
    foreground=#B3B1AD
    font-family=SauceCodePro NFM
    font-size=8
    cursor-style=block
    shell-integration-features=no-cursor
    mouse-hide-while-typing=true
    mouse-scroll-multiplier=1
    # keybind=ctrl+a>c=new_tab
    # keybind=ctrl+a>n=new_window
    shell-integration=zsh
  '';
  programs.ghostty = {
    enable = true;
    package = inputs.ghostty.packages.${pkgs.stdenv.hostPlatform.system}.ghostty;
  };
}
