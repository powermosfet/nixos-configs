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
    qjackctl
  ];

  musnix = {
    enable = true;

    kernel = {
      optimize = true;
      realtime = true;
    };
  };

  users.users.asmund.extraGroups = [ "audio" ];
}
