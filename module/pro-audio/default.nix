{ pkgs, ... }:

# Set up a pro audio environment by using Musnix
# https://github.com/musnix/musnix

## Using musnix as a channel
# 
# As an alternative to the above approach, you can instead add musnix as a channel:
# 
#   sudo -i nix-channel --add https://github.com/musnix/musnix/archive/master.tar.gz musnix
#   sudo -i nix-channel --update musnix

{
  imports =
    [ <musnix>
    ];
  
  environment.systemPackages = with pkgs; [
    ardour
    qpwgraph
    alsa-utils
    tree
    qjackctl
    guitarix
    meterbridge
    qastools
    hydrogen
  ];

  musnix = {
    enable = true;
  };
  
  sound.enable = false;
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

  users.users.asmund.extraGroups = [ "audio" "jackaudio" "pipewire" ];
}
