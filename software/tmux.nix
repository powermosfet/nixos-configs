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

    escapeTime = 0;
    clock24 = true;
    newSession = true;
    keyMode = "vi";
    terminal = "screen-256color";
    shortcut = "a";
    extraConfig = ''
      bind C-a send-keys C-a
    '';
  };
}
