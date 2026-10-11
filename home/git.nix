# Writes ~/.config/git/{config,ignore,attributes}. Per-machine overrides (e.g. a
# work email) go in the machine's module in flake.nix, or ~/.gitconfig.local
# for anything that shouldn't be committed.
{ lib, ... }:
{
  programs.git = {
    enable = true;

    settings = {
      user = {
        name = "Braden Altstatt";
        email = lib.mkDefault "bradenaltstatt@gmail.com";
      };
      init.defaultBranch = "main";
      pull.rebase = true;
      core = {
        editor = "nvim";
        pager = "less -X -F";
      };
      alias = {
        l = "log --graph --oneline --decorate";
        ll = "log --stat --decorate --source -p";
      };
      include.path = "~/.gitconfig.local";
    };

    ignores = [
      ".DS_Store"
      ".Trashes"
      ".idea/"
      "node_modules/"
      ".env"
      "*.dll"
      "*.exe"
      "**/.claude/settings.local.json"
    ];

    # Language-aware hunk headers in diffs.
    attributes = [
      "*.c     diff=cpp"
      "*.c++   diff=cpp"
      "*.cpp   diff=cpp"
      "*.go    diff=golang"
      "*.py    diff=python"
      "*.md    diff=markdown"
      "*.rs    diff=rust"
    ];
  };
}
