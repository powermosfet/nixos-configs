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

  environment.systemPackages = with pkgs; [
    git
    wget
    docker
    docker-compose
  ];

  # SSH
  services.openssh.enable = true;
  security.sudo.wheelNeedsPassword = false;
  networking.firewall.allowedTCPPorts = [ 22 80 8080 ];

  networking.extraHosts = ''
    127.0.0.1   conta.test
    127.0.0.1   api.conta.test
    127.0.0.1   app.conta.test
    127.0.0.1   gjest.conta.test
    127.0.0.1   dist.conta.test
    127.0.0.1   mysql.conta.test
  '';

  virtualisation.virtualbox.guest.enable = true;
  virtualisation.docker.enable = true;
}
