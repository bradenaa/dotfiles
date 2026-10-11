# Linux-only settings. pacman still owns the base system, desktop and GUI apps;
# Nix owns dev tools.
{ pkgs, ... }:
{
  # Make home-manager play nicely with a non-NixOS distro (XDG_DATA_DIRS etc.).
  targets.genericLinux.enable = true;
  # Only CLI tools come from Nix; GPU apps stay on pacman, so skip the
  # Mesa/driver shim (it also needs a one-time sudo setup script).
  targets.genericLinux.gpu.enable = false;

  # Native Wayland clipboard for nvim (clipboard=unnamedplus) and tmux-yank,
  # instead of going through xclip/Xwayland.
  home.packages = [ pkgs.wl-clipboard ];

  # One systemd-managed agent per login. zsh/zshenv points SSH_AUTH_SOCK at it.
  services.ssh-agent.enable = true;
}
