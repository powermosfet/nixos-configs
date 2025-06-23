{ pkgs, musnix, ... }:

let
  unstable = import <nixos-unstable> { };
in
{
  imports = [
    musnix.nixosModules.musnix
  ];

  environment.systemPackages = with pkgs; [
    unstable.ardour
    qpwgraph
    alsa-utils
    tree
    qjackctl
    guitarix
    meterbridge
    qastools
    hydrogen
    neothesia
    odin2
    calf
    zam-plugins
    xsynth_dssi
    soundfont-ydp-grand
    soundfont-fluid
    soundfont-arachno
    soundfont-generaluser
    lsp-plugins
    carla
  ];

  musnix = {
    enable = true;
  };

  users.users.asmund.extraGroups = [
    "audio"
    "jackaudio"
    "pipewire"
  ];
  environment.pathsToLink = [ "/share/soundfonts" ];

  security.rtkit.enable = true;

  services.pipewire = {
    enable = true;

    alsa = {
      enable = true;
      support32Bit = true;
    };
    jack.enable = true;
    pulse.enable = true;
  };
}
