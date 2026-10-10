# dotfiles

Neovim, zsh, tmux, git and dev tooling for my machines, managed with
[Nix](https://nixos.org) and [home-manager](https://github.com/nix-community/home-manager).

| Machine | Config name |
|---|---|
| Arch Linux desktop | `arch` |
| Apple Silicon work Mac | `work-mac` |
| Intel personal Mac | `personal-mac` |

## New machine

1. Install Nix: `curl -fsSL https://install.determinate.systems/nix | sh -s -- install`
2. Clone: `git clone git@github.com:bradenaa/dotfiles.git ~/code/dotfiles`
3. Apply (moves any existing conflicting files to `*.backup`):

   ```sh
   nix run home-manager/master -- switch -b backup --flake ~/code/dotfiles#<name>
   ```

4. One-time setup:

   ```sh
   rustup default stable && rustup component add rust-analyzer
   ```

5. Open a new shell, then `nvim` (installs plugins on first launch).

## Day to day

```sh
home-manager switch --flake ~/code/dotfiles#<name>   # apply changes
nix flake update && home-manager switch --flake ...  # update everything
home-manager switch --rollback                        # undo
```

Most config files are symlinked to this checkout, so edits apply immediately.
Changes to `home/*.nix` or `tmux/tmux.conf` need a `switch`. See `CLAUDE.md` for
details.

## macOS defaults

`macos/set-defaults.sh` sets Dock, key repeat and screenshot preferences. Run it
by hand.
