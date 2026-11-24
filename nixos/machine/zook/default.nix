{ config, pkgs, ... }:

{
  imports = [
    ../../user/asmund
    ../../module/borg/jobs/zook/gilli
    ../../module/borg/jobs/zook/agent25
    ../../module/tailscale
    ../../module/minecraft
    ../../module/silverbullet
    ../../module/wallabag
    ../../module/kavita
    ../../module/dnsmasq
    ../../module/home-assistant
  ];

  # Share Wallabag's explicit listener so SNI can also select SilverBullet.
  services.nginx.virtualHosts."sb.berge.id".listenAddresses =
    config.services.nginx.defaultListenAddresses ++ [ config.services.wallabag.listenAddress ];

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
