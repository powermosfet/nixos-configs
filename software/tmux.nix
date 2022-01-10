{ config, pkgs, ... }:

{
  imports =
    [
    ];

  environment.systemPackages = with pkgs; [
    tmuxp
  ];


  programs.tmux = {
    enable = true;

    clock24 = true;
    newSession = true;
    shortcut = "a";
    terminal = "screen-256color";
  };
}
