
{ config, pkgs, lib, ... }:

  with lib;

let
  hostName = "dokuwiki.berge.id";
  dokuwiki-plugin-mermaid = pkgs.stdenv.mkDerivation {
    name = "mermaid";
    src = pkgs.fetchzip {
      url = "https://github.com/RobertWeinmeister/dokuwiki-mermaid/archive/refs/heads/main.zip";
      sha256 = "sha256-6t2ehpPmh8C8fYa+SFlnGav8/A4miuDtZ7fqH/eoVeM=";
    };
    sourceRoot = ".";
    installPhase = "mkdir -p $out; cp -R source/* $out/";
  };
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
      acl = ''
        *               @ALL              0
        *               @user            16
      '';
      plugins = [ dokuwiki-plugin-mermaid ];
    };
    services.nginx.virtualHosts."${hostName}" = {
      enableACME = true;
      forceSSL = true;
    };

    networking.firewall.allowedTCPPorts = [ 443 ];
  };
}
