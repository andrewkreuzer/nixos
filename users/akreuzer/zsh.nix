{pkgs, config}:
{
  enable = true;
  autocd = true;
  dotDir = ".config/zsh";

  enableCompletion = true;
  enableAutosuggestions = true;
  enableSyntaxHighlighting = true;

  history = {
    path = "${config.xdg.dataHome}/zsh/zsh_history";
    ignorePatterns = [];
    ignoreDups = true;
    extended = true;
    share = true;
  };

  defaultKeymap = "viins";
  sessionVariables = {};

  initExtra = ''
    zmodload zsh/complist
    bindkey -M menuselect 'h' vi-backward-char
    bindkey -M menuselect 'k' vi-up-line-or-history
    bindkey -M menuselect 'j' vi-down-line-or-history
    bindkey -M menuselect 'l' vi-forward-char
    autoload -U history-search-end
    zle -N history-beginning-search-backward-end history-search-end
    zle -N history-beginning-search-forward-end history-search-end
    bindkey "$key[Up]" history-beginning-search-backward-end
    bindkey "$key[Down]" history-beginning-search-forward-end
  '';
}
