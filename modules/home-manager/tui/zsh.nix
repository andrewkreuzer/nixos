{ config, ... }:
{
  programs.zsh = {
    enable = true;
    autocd = true;
    dotDir = config.xdg.configHome + "/zsh";

    enableCompletion = true;
    autosuggestion.enable = true;
    syntaxHighlighting = {
      enable = true;
    };

    history = {
      path = "${config.xdg.dataHome}/zsh/zsh_history";
      ignorePatterns = [ ];
      ignoreDups = true;
      extended = true;
      share = true;
    };

    defaultKeymap = "viins";
    sessionVariables = { };

    shellAliases = {
      ls = "ls --color=auto";
      ll = "ls -alF";
      la = "ls -A";
      l = "ls -CF";
      cp = "cp -i";
      mv = "mv -i";
      rm = "rm -i";
      mkdir = "mkdir -p";
      gitcnt = "git ls-files | xargs wc -l";
    };

    initContent = ''
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
  };
}
