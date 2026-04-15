{ pkgs, ... }:

{
  imports = [
    ../../../module/zsh
    ../../../module/neovim
    ../../../module/yazi
    ../../../module/direnv
  ];

  nixpkgs.config.allowUnfree = true;

  home.packages = with pkgs; [
    entr
    logseq
    octave
    pnpm
    caddy
  ];

  programs.keepassxc.enable = true;
  programs.claude-code.enable = true;
  programs.docker-cli.enable = true;
  programs.gh.enable = true;
  programs.ghostty = {
    enable = true;
    package = pkgs.ghostty-bin;
  };
  programs.lazygit.enable = true;
  programs.visidata.enable = true;
  programs.zellij.enable = true;
}
