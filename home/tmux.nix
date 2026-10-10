{ pkgs, ... }:
let
  # Loaded after tmux/tmux.conf, like tpm's `run` line: prefix-highlight and
  # continuum hook into status-right, so it must already be set when they run.
  # (home-manager's own `plugins` option loads them before extraConfig.)
  plugins = with pkgs.tmuxPlugins; [
    sensible
    vim-tmux-navigator
    prefix-highlight
    yank
    resurrect
    continuum
  ];
in
{
  programs.tmux = {
    enable = true;
    prefix = "C-Space";
    baseIndex = 1; # windows and panes
    keyMode = "vi";
    mouse = true;
    clock24 = true;
    terminal = "tmux-256color";
    # home-manager's defaults (500ms, 2000 lines) would override tmux-sensible.
    escapeTime = 10;
    historyLimit = 50000;
    focusEvents = true;

    extraConfig = ''
      ${builtins.readFile ../tmux/tmux.conf}
      # Plugins (pinned by flake.lock)
      ${builtins.concatStringsSep "\n" (map (p: "run-shell ${p.rtp}") plugins)}
    '';
  };
}
