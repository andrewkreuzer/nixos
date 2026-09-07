{ inputs, pkgs, pkgs-unstable, ... }:
{
  programs.neovim = {
    enable = true;
    package = pkgs-unstable.neovim-unwrapped;

    # extraLuaPackages = luaPkgs: [
    #   (import ../../.dotfiles/nvim/.config/nvim/default.nix {inherit luaPkgs;})
    # ];

    sideloadInitLua = true;
    withRuby = true;
    withPython3 = true;

    plugins = with pkgs-unstable.vimPlugins; [
      nvim-treesitter.withAllGrammars
      nvim-treesitter-parsers.qmljs
    ];

    extraPackages = with pkgs; [
      nodejs
      gopls
      lua5_1
      luarocks
      lua-language-server
      pyright
      nixd
      jdt-language-server
      rust-analyzer
      ocamlPackages.ocaml-lsp
      ocamlPackages.ocamlformat
      yaml-language-server
      typescript-language-server
      svelte-language-server
    ] ++ [
      inputs.zls.packages.${pkgs.stdenv.hostPlatform.system}.default
    ];
  };
}
