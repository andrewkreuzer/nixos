{ inputs, pkgs, ... }:
{
  home.file.".config/ghostty/config".text = ''
term=xterm-256color
window-decoration=none

background=#0A0E14
foreground=#B3B1AD
font-family=SauceCodePro NFM
font-size=8
cursor-style=block
shell-integration-features=no-cursor
selection-invert-fg-bg=true
mouse-hide-while-typing=true
keybind=ctrl+a>c=new_tab
keybind=ctrl+a>n=new_window
shell-integration=zsh
adw-toolbar-style=flat
gtk-custom-css=~/.config/ghostty/gtk.css
  '';
  programs.ghostty = {
    enable = true;
    package = inputs.ghostty.packages.${pkgs.system}.ghostty;
  };
}
