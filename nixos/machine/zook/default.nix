{ config, pkgs, ... }:

let
  ports = import ./ports.nix;
in
{
  imports = [
    ../../user/asmund
  ];

  services.openssh = {
    enable = true;

    settings = {
      PasswordAuthentication = false;
      PermitRootLogin = "no";
      KbdInteractiveAuthentication = false;
      PermitEmptyPasswords = false;
      X11Forwarding = false;
      AllowAgentForwarding = false;
      AllowTcpForwarding = false;
      MaxAuthTries = 3;
      LoginGraceTime = 20;
      ClientAliveInterval = 300;
      ClientAliveCountMax = 2;
    };
  };

  security.sudo.wheelNeedsPassword = false;
}
