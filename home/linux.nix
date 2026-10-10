# Linux-only settings. pacman still owns the base system, desktop and GUI apps;
# Nix owns dev tools.
{ ... }:
{
  # Make home-manager play nicely with a non-NixOS distro (XDG_DATA_DIRS etc.).
  targets.genericLinux.enable = true;
  # Only CLI tools come from Nix; GPU apps stay on pacman, so skip the
  # Mesa/driver shim (it also needs a one-time sudo setup script).
  targets.genericLinux.gpu.enable = false;
}
