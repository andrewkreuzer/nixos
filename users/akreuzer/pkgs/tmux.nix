{ pkgs, colors, ... }:
let ayu = colors.ayu; in
{
  programs.tmux = {
    enable = true;
    keyMode = "vi";
    shortcut = "a";
    terminal = "screen-256color";

    plugins = with pkgs; [
      tmuxPlugins.cpu
      tmuxPlugins.yank
      {
        plugin = tmuxPlugins.resurrect;
        extraConfig = ''
          set -g @resurrect-strategy-nvim 'session'
          set -g @resurrect-capture-pane-contents 'on'
          set -g @resurrect-dir '~/.cache/tmux/resurrect'
        '';
      }
      {
        plugin = tmuxPlugins.continuum;
        extraConfig = ''
          set -g @continuum-restore 'on'
          set -g @continuum-save-interval '1' # minutes
        '';
      }
    ];

    escapeTime = 10;
    extraConfig = ''
      set -ga terminal-overrides ",*xterm-256color*:Tc"

      # split panes with | and -
      bind | split-window -h
      bind _ split-window -v
      unbind '"'
      unbind %

      bind j split-window -b -l 70 -h -c "#{pane_current_path}" \
        "[[ -e TODO.md ]] \
        && nvim -c 'set textwidth=60' TODO.md \
        || nvim -c 'set textwidth=60' ~/Documents/notes/todo.md"


      set -g status-position top
      set -g status-justify left
      set -g status-interval 1
      set -g status-right-length 10

      setw -g mode-style bg=blue,fg=white
      set -g message-style bg='#272E33',fg=white

      set -g status-style bg=terminal
      setw -g window-status-style bg=terminal
      setw -g window-status-separator ""

      setw -g window-status-format "#[bg=${ayu.fg},fg=${ayu.bg}] #[bg=${ayu.fg},fg=${ayu.bg}] #W #[bg=${ayu.fg},fg=${ayu.bg}]"
      setw -g window-status-current-format "#[bg=green,fg=${ayu.bg}] #[bg=green,fg=${ayu.bg},bold] #W #[bg=green,fg=${ayu.bg}]"
      set -g status-right '#(${pkgs.tmuxPlugins.continuum}/share/tmux-plugins/continuum/scripts/continuum_save.sh)#{continuum_status}#[bg=${ayu.bg},fg=terminal]#{?client_prefix,  •  ,}'
      set-option -g status-left ' '

      # Automatically renumber windows when some closes
      set -g renumber-windows on

      # Pane-border-tweaking
      # PWD at the top
      set-window-option -g pane-border-status top
      set-window-option -g pane-border-format "#[align=absolute-centre]#[fg=dim]─ #{s|$HOME|~|:pane_current_path} ─"
      # Pane-border colors
      set -g pane-active-border-style fg=terminal,bold
      set -g pane-border-style fg=terminal,dim,overline
    '';
  };
}
