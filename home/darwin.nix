# macOS-only settings. System defaults are still applied by
# macos/set-defaults.sh; nix-darwin could take that over later.
{ config, pkgs, ... }:
{
  home.packages = with pkgs; [
    coreutils # GNU ls etc., so zsh aliases work the same as on Linux
    ncurses # tmux-256color terminfo, which macOS doesn't ship
  ];

  home.sessionVariables.TERMINFO_DIRS = "${config.home.profileDirectory}/share/terminfo:/usr/share/terminfo";

  # macOS runs its own ssh-agent via launchd; store passphrases in Keychain.
  programs.ssh.settings."*".UseKeychain = "yes";
}
