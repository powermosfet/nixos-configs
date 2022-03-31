{ pkgs, ... }:

{
  imports =
    [ ../user/asmund.nix
      ../software/tmux.nix 
      ../software/neovim.nix
    ];
     
  time.timeZone = "Europe/Oslo";

  networking.hostName = "contadev"; 

  users.users.asmund.extraGroups = [ "docker" ]; 
  security.sudo.wheelNeedsPassword = false;

  environment.systemPackages = with pkgs; [
    git
    wget
    docker
    docker-compose
  ];

  # Enable the OpenSSH daemon.
  services.openssh.enable = true;

  # Open ports in the firewall.
  networking.firewall.allowedTCPPorts = [ 22 ];

  virtualisation.virtualbox.guest.enable = true;
  virtualisation.docker.enable = true;
}

