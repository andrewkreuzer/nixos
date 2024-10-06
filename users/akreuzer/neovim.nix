{pkgs, pkgs-unstable}:
{
  enable = true;
  package = pkgs-unstable.neovim;
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
    rust-analyzer
    nil
    pyright
    jdt-language-server
    ocamlPackages.ocaml-lsp
    ocamlPackages.ocamlformat
    nodePackages.yaml-language-server
    nodePackages.typescript-language-server
  ];
}
