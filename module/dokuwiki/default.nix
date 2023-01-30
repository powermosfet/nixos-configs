
{ config, pkgs, lib, ... }:

  with lib;

let
  hostName = "dokuwiki.berge.id";
in
{
  imports =
    [ ../../user/backup
    ];

  config = {
    services.dokuwiki.sites."${hostName}" = {
      enable = true;
      # settings.title = "Berge Wiki";
      disableActions = "register";
      acl = """
        *               @ALL               0
        *               @users            16
      """;
    };

    networking.firewall.allowedTCPPorts = [ 443 ];
  };
}
