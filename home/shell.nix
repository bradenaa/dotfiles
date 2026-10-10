# zsh, prompt, terminal and other small configs. zsh itself is the system one
# (it's the login shell); only its config is managed here.
{
  config,
  pkgs,
  dotfiles,
  ...
}:
let
  link = path: config.lib.file.mkOutOfStoreSymlink "${dotfiles}/${path}";
in
{
  home.packages = [ pkgs.starship ];

  home.file.".zshenv".source = link "zsh/zshenv";
  xdg.configFile."zsh/.zshrc".source = link "zsh/zshrc";
  xdg.configFile."starship.toml".source = link "starship/starship.toml";
  xdg.configFile."ghostty/config".source = link "ghostty/config";
  home.file.".prettierrc".source = link "prettier/prettierrc.json";

  # Keys are added to the agent on first use (one passphrase prompt per
  # session). The agent itself is per-OS: see linux.nix / darwin.nix.
  programs.ssh = {
    enable = true;
    enableDefaultConfig = false;
    settings."*".AddKeysToAgent = "yes";
  };
}
