# Dotfiles

Personal dotfiles for three machines, managed with Nix + home-manager:

| Name (`#<name>`) | Machine            | System           | nixpkgs                     |
| ---------------- | ------------------ | ---------------- | --------------------------- |
| `arch`           | Arch Linux desktop | `x86_64-linux`   | unstable                    |
| `work-mac`       | Apple Silicon Mac  | `aarch64-darwin` | unstable                    |
| `personal-mac`   | Intel Mac          | `x86_64-darwin`  | 26.05 (frozen; see below)   |

The clone location can differ per machine. Each `mkHome` entry sets `dotfiles` to its absolute checkout path; linked configs point there, and an activation check in `home/common.nix` aborts `switch` if that path has no `flake.nix`. Don't hardcode `~/code/dotfiles` anywhere else.

## Layout

- `flake.nix`: inputs and one `homeConfigurations.<name>` per machine via `mkHome`.
- `home/common.nix`: packages (toolchains, LSPs, formatters) and the nvim link. Imports the modules below.
- `home/shell.nix`: zsh, starship, ghostty, prettier links; ssh client config.
- `home/git.nix`: git config, global ignores and attributes (`programs.git`).
- `home/tmux.nix`: tmux options and plugins (`programs.tmux`).
- `home/linux.nix`, `home/darwin.nix`: OS-specific additions (ssh-agent, GNU coreutils on macOS, etc.).
- Config files, one directory per tool: `nvim/`, `zsh/` (`zshenv`, `zshrc`), `tmux/tmux.conf`, `starship/`, `ghostty/`, `prettier/`.
- `macos/set-defaults.sh`: macOS `defaults write` script, run by hand. `adv360/`: keyboard layout notes. `vscode/`: unmanaged.
- `claude/`: local Claude Code plugin marketplace (`ty-lsp`, which Claude uses for Python). Not applied by `switch`; set up once per machine with `claude plugin marketplace add <checkout>/claude && claude plugin install ty-lsp@dotfiles`. The other LSP plugins come from `claude-plugins-official` and use the Nix-installed servers.

### Which files are live vs. built

| File | How it's applied | Edit takes effect |
|---|---|---|
| `nvim/`, `zsh/*`, `starship/`, `ghostty/`, `prettier/` | symlinked to the checkout | immediately (new shell / reload) |
| `tmux/tmux.conf` | read into the generated `~/.config/tmux/tmux.conf` | after `switch`, then `tmux source ~/.config/tmux/tmux.conf` |
| git, ssh config | generated from `home/*.nix` | after `switch` |

### Machine-specific settings

- Shell: `~/.config/zsh/local.zsh` (untracked, sourced last by `zshrc`), e.g. project SDK paths or tools installed outside Nix.
- Git: `~/.gitconfig.local` (untracked, included by the generated config), or a module in the machine's `mkHome` entry for things worth committing (e.g. work email via `programs.git.settings.user.email`).

## Applying changes

```sh
# from the repo root
home-manager switch --flake .#<name>   # apply
nix flake update                       # bump all pinned versions
home-manager switch --rollback         # undo last switch
```

- Configs are linked with `mkOutOfStoreSymlink` (the `link` helper in `home/common.nix` / `home/shell.nix`), pointing at the repo checkout. Edits to linked files apply immediately; package, link and `home/*.nix` changes need a `switch`.
- If a `switch` reports that an existing file would be clobbered, rerun with `-b backup` to move it aside.
- tmux plugins are loaded by `home/tmux.nix` *after* `tmux/tmux.conf` (not via home-manager's `plugins` option, which loads them first). prefix-highlight and continuum rewrite `status-right`, so it must be set before they run.
- zsh is the system zsh (login shell); only its config is managed. `zsh/zshenv` sources the Nix profile and `hm-session-vars.sh` so non-interactive shells see Nix tools too. It is linked at both `~/.zshenv` and `~/.config/zsh/.zshenv`, because it sets `ZDOTDIR` and child shells (tmux panes, scripts) inherit that.
- Rust comes from `rustup` (run `rustup default stable && rustup component add rust-analyzer` once per machine). Don't add `rustfmt`/`rust-analyzer` packages; they collide with rustup's proxies.
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
ln -sfn "$PWD/nvim" ~/.config/nvim-next   # from the repo root
NVIM_APPNAME=nvim-next nvim --headless +qa        # should print nothing
NVIM_APPNAME=nvim-next nvim +'checkhealth vim.pack vim.lsp'
```
