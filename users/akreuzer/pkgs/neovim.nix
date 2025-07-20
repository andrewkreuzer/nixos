{ pkgs, pkgs-unstable, ... }:
{
  programs.neovim = {
    enable = true;
    package = pkgs-unstable.neovim-unwrapped;

    # extraLuaPackages = luaPkgs: [
    #   (import ../../.dotfiles/nvim/.config/nvim/default.nix {inherit luaPkgs;})
    # ];

    plugins = with pkgs-unstable.vimPlugins; [
      nvim-treesitter.withAllGrammars
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
      nodePackages.yaml-language-server
      nodePackages.typescript-language-server
      nodePackages.svelte-language-server
    ] ++ (with pkgs-unstable; [
      zls
    ]);
  };
}
