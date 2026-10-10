# Shared by every machine.
{
  config,
  pkgs,
  dotfiles,
  ...
}:
let
  # Symlink to the live repo checkout instead of a read-only store copy, so
  # edits apply immediately and nvim can write nvim-pack-lock.json.
  link = path: config.lib.file.mkOutOfStoreSymlink "${dotfiles}/${path}";
in
{
  # Version of home-manager defaults to stay compatible with. Don't bump this
  # just because home-manager updates; read the release notes first.
  home.stateVersion = "26.05";

  programs.home-manager.enable = true;

  home.packages = with pkgs; [
    # Editor
    neovim
    tree-sitter # nvim-treesitter compiles parsers with this
    gnumake # telescope-fzf-native build

    # Search
    ripgrep
    fd
    fzf

    # Language servers (enabled in nvim/lua/plugins/lsp.lua)
    clang-tools # clangd
    emmet-language-server
    gopls
    lua-language-server
    marksman
    pyright
    rust-analyzer
    terraform-ls
    typescript-language-server
    vscode-langservers-extracted # html

    # Formatters and linters (used in nvim/lua/plugins/format.lua)
    black
    gofumpt
    gotools # goimports
    isort
    markdownlint-cli2
    prettier
    rustfmt
    stylua
    terraform
    tflint
  ];

  xdg.configFile."nvim".source = link "nvim";
}
