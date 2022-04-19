{ config, pkgs, ... }:

let
  powerline = pkgs.python39Packages.powerline;
in
{
  environment.systemPackages = with pkgs; [
    tmuxp
    powerline
    python39Full
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

      source ${powerline}/lib/python3.9/site-packages/powerline/bindings/tmux/powerline.conf
    '';
  };
}
