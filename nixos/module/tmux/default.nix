{ config, pkgs, ... }:

let
  powerline = pkgs.python311Packages.powerline;
in
{
  environment.systemPackages = [
    pkgs.tmuxp
    powerline
    pkgs.python311Full
  ];

  programs.tmux = {
    enable = true;

    escapeTime = 0;
    baseIndex = 1;
    clock24 = true;
    newSession = true;
    keyMode = "vi";
    terminal = "screen-256color";
    shortcut = "a";
    extraConfig = ''
      bind C-a send-keys C-a

      source ${powerline}/lib/python3.11/site-packages/powerline/bindings/tmux/powerline.conf
    '';
  };
}
