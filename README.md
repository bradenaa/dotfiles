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
2. Clone anywhere, e.g. `git clone git@github.com:bradenaa/dotfiles.git ~/code/dotfiles`.
   Make sure that machine's `dotfiles = "..."` entry in `flake.nix` is the
   absolute clone path (`switch` refuses to run if it isn't).
3. Apply (moves any existing conflicting files to `*.backup`):

   ```sh
   cd <clone path>
   nix run home-manager/master -- switch -b backup --flake .#<name>
   ```

4. One-time setup:

   ```sh
   rustup default stable && rustup component add rust-analyzer
   ```

5. Open a new shell, then `nvim` (installs plugins on first launch).

## Day to day

```sh
# from the repo root
home-manager switch --flake .#<name>                 # apply changes
nix flake update && home-manager switch --flake .#<name>  # update everything
home-manager switch --rollback                        # undo
```

Most config files are symlinked to this checkout, so edits apply immediately.
Changes to `home/*.nix` or `tmux/tmux.conf` need a `switch`. See `CLAUDE.md` for
details.

## macOS defaults

`macos/set-defaults.sh` sets Dock, key repeat and screenshot preferences. Run it
by hand.
