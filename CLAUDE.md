# Dotfiles

Personal dotfiles for three machines, managed with Nix + home-manager:

| Name (`#<name>`) | Machine            | System           | nixpkgs                     |
| ---------------- | ------------------ | ---------------- | --------------------------- |
| `arch`           | Arch Linux desktop | `x86_64-linux`   | unstable                    |
| `work-mac`       | Apple Silicon Mac  | `aarch64-darwin` | unstable                    |
| `personal-mac`   | Intel Mac          | `x86_64-darwin`  | 26.05 (frozen; see below)   |

The repo is expected to be cloned at `~/code/dotfiles` on every machine.

## Layout

- `flake.nix`: inputs and one `homeConfigurations.<name>` per machine via `mkHome`.
- `home/common.nix`: packages and config links shared by all machines. Most changes go here.
- `home/linux.nix`, `home/darwin.nix`: OS-specific additions.
- `nvim/`: Neovim config (see below). Linked to `~/.config/nvim`.
- `tmux/`, `zsh/`, `git/`, `vim/`, `vscode/`, `macos/`: older configs. Not yet managed by home-manager.
- `setup.sh`, `setup.d/`, `Makefile`: legacy apt/brew installer. Being replaced by home-manager; don't extend it.

## Applying changes

```sh
home-manager switch --flake ~/code/dotfiles#<name>   # apply
nix flake update                                      # bump all pinned versions
home-manager switch --rollback                        # undo last switch
```

- Configs are linked with `mkOutOfStoreSymlink` (the `link` helper in `home/common.nix`), pointing at the repo checkout. Edits to linked files apply immediately; only package or link changes need a `switch`.
- New files must be `git add`ed before Nix can see them (flakes only read tracked files).
- The Intel Mac uses `nixpkgs-26.05-darwin` because nixpkgs dropped x86_64-darwin after 26.05. Packages added to `common.nix` must also exist there.
- `terraform` is unfree and allowed by name in `flake.nix`. Add other unfree packages there too.

## Neovim (`nvim/`)

Requires Neovim 0.12+. No plugin-manager framework.

- **Plugins** use the built-in `vim.pack`. Each `lua/plugins/*.lua` calls `vim.pack.add{...}` and then configures the plugin directly. `init.lua` requires them in dependency order.
- **Lockfile:** `nvim/nvim-pack-lock.json` is committed. Update plugins with `:lua vim.pack.update()`, review, then commit the lockfile.
- **Build steps** (e.g. telescope-fzf-native `make`) are `PackChanged` hooks in `lua/config/pack.lua`. They must be registered before any `vim.pack.add`.
- **External tools** (LSPs, formatters, `tree-sitter`, `rg`, `fd`) come from Nix in `home/common.nix`. There is no Mason. Adding a language means:
  1. add the server/formatter package to `home/common.nix`
  2. add the server name to `vim.lsp.enable{}` in `lua/plugins/lsp.lua` and/or the formatter to `lua/plugins/format.lua`
  3. add the parser to the `install{}` list in `lua/plugins/treesitter.lua`
- **LSP:** uses `vim.lsp.config`/`vim.lsp.enable`. nvim-lspconfig only supplies default server configs. Per-server overrides go in `nvim/lsp/<server>.lua` (returns a `vim.lsp.Config` table). Never use `require('lspconfig').X.setup()`.
- **Treesitter:** nvim-treesitter `main` branch. It only installs parsers. Highlighting/indent are started in a `FileType` autocmd, which also installs missing parsers.
- **Keymaps:** prefer nvim's built-in LSP defaults (`grn`, `gra`, `grr`, `gri`, `grt`, `gO`; see `:help lsp-defaults`) over custom maps. Telescope overrides some of them in `lua/plugins/lsp.lua`.

### Conventions

- Lua is formatted with `stylua` using `nvim/.stylua.toml` (2 spaces, single quotes, no call parens).
- Use `vim.o` for options (`vim.opt` only for list/map options like `listchars`).
- Keep comments short: explain why, not what. This is not a tutorial config.

### Testing nvim changes

Run a copy of the config in isolation without touching the live one:

```sh
ln -sfn ~/code/dotfiles/nvim ~/.config/nvim-next
NVIM_APPNAME=nvim-next nvim --headless +qa        # should print nothing
NVIM_APPNAME=nvim-next nvim +'checkhealth vim.pack vim.lsp'
```
