{
  programs.starship = {
    enable = true;
    settings = {
      "format" = "[┌────────────❯](bold green)$username$hostname$git_branch$git_status\n[│](bold green)$directory$rust$zig$python$nodejs$golang$terraform$package$nix_shell\n[│](bold green)\n[└─](bold green)$character$git_state$status ";
      "username" = {
        "disabled" = false;
        "show_always" = true;
        "style_user" = "bold yellow";
        "style_root" = "black bold";
        "format" = " [$user]($style)";
      };
      "hostname" = {
        "disabled" = false;
        "ssh_only" = false;
        "format" = "[@](bright-white)[$hostname](bold blue) ";
      };
      "character" = {
        "format" = "$symbol";
      };
      "directory" = {
        "read_only" = " ";
        "format" = "[$read_only]($read_only_style) [$path](bold cyan) ";
        "truncation_symbol" = "../";
      };
      "git_branch" = {
        "symbol" = " ";
        "style" = "bold green";
      };
      "git_status" = {
        "format" = "([\\[ $all_status$ahead_behind\\]]($style))";
        "ahead" = "\${count} ";
        "diverged" = " \${ahead_count}:\${behind_count} ";
        "behind" = "\${count} ";
        "conflicted" = "\${count}:conflicted ";
        "untracked" = "\${count}:untracked ";
        "stashed" = "\${count}:stashed ";
        "modified" = "\${count}:modified ";
        "staged" = "\${count}:staged ";
        "renamed" = "\${count}:renamed ";
        "deleted" = "\${count}:deleted ";
        "style" = "bold red";
      };
      "git_state" = {
        "cherry_pick" = " [ picking](bold red) ";
        "merge" = " [ merging](bold 105) ";
      };
      "nix_shell" = {
        "disabled" = false;
        "format" = "via [$symbol$state]($style) ";
        "symbol" = "❄️";
      };
      "status" = {
        "disabled" = false;
        "format" = "[ \\[$status\\]]($style) ";
      };
      "aws" = {
        "symbol" = "  ";
      };
      "buf" = {
        "symbol" = " ";
      };
      "c" = {
        "symbol" = " ";
      };
      "conda" = {
        "symbol" = " ";
      };
      "dart" = {
        "symbol" = " ";
      };
      "docker_context" = {
        "symbol" = " ";
      };
      "elixir" = {
        "symbol" = " ";
      };
      "elm" = {
        "symbol" = " ";
      };
      "golang" = {
        "symbol" = " ";
      };
      "haskell" = {
        "symbol" = " ";
      };
      "hg_branch" = {
        "symbol" = " ";
      };
      "java" = {
        "symbol" = " ";
      };
      "julia" = {
        "symbol" = " ";
      };
      "memory_usage" = {
        "symbol" = " ";
      };
      "nim" = {
        "symbol" = " ";
      };
      "nodejs" = {
        "symbol" = " ";
      };
      "package" = {
        "symbol" = " ";
      };
      "python" = {
        "symbol" = " ";
      };
      "spack" = {
        "symbol" = "🅢 ";
      };
      "rust" = {
        "symbol" = " ";
      };
      "zig" = {
        "symbol" = " ";
      };
    };
  };
}
