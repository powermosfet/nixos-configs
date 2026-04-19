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
  # Raise RT limits for the audio group
  security.pam.loginLimits = [
    {
      domain = "@audio";
      item = "memlock";
      type = "-";
      value = "unlimited";
    }
    {
      domain = "@audio";
      item = "rtprio";
      type = "-";
      value = "99";
    }
    {
      domain = "@audio";
      item = "nice";
      type = "-";
      value = "-20";
    }
  ];
  environment.pathsToLink = [ "/share/soundfonts" ];

  security.rtkit.enable = true;

  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
    jack.enable = true;

    extraConfig = {
      pipewire."92-low-latency" = {
        "context.properties" = {
          "default.clock.rate" = 48000;
          "default.clock.quantum" = 256;
          "default.clock.min-quantum" = 64;
          "default.clock.max-quantum" = 512;
        };
      };
    };
    wireplumber.extraConfig."92-scarlett-96k" = {
      "monitor.alsa.rules" = [
        {
          matches = [
            { "device.name" = "~alsa_card.usb-Focusrite*"; }
          ];
          actions = {
            "update-props" = {
              "audio.rate" = 96000;
              "api.alsa.period-size" = 384;
              "api.alsa.period-num" = 2;
              "api.alsa.headroom" = 0;
              "session.suspend-timeout-seconds" = 0;
            };
          };
        }
        {
          matches = [
            { "node.name" = "~alsa_input.usb-Focusrite*"; }
            { "node.name" = "~alsa_output.usb-Focusrite*"; }
          ];
          actions = {
            "update-props" = {
              "audio.rate" = 96000;
              "audio.allowed-rates" = "96000";
            };
          };
        }
      ];
    };
  };
}
