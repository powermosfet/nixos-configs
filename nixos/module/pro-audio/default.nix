{ pkgs, pkgsUnstable, ... }:

{
  environment.systemPackages = with pkgs; [
    pkgsUnstable.ardour
    qpwgraph
    alsa-utils
    tree
    qjackctl
    guitarix
    meterbridge
    qastools
    hydrogen
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
    neural-amp-modeler-lv2
    alsa-scarlett-gui
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

    extraConfig.pipewire."context.properties" = {
      "default.clock.rate" = 48000;

      # Hard constraints
      "default.clock.quantum" = 64;
      "default.clock.min-quantum" = 64;
      "default.clock.max-quantum" = 64;
    };
  };
}
