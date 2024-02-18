{pkgs}:
{
  enable = true;
  extraPackages = with pkgs; [
    lua-language-server
    rust-analyzer
    ocamlPackages.ocaml-lsp
    nil
    pyright
  ];
}
