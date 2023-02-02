
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
      disableActions = "register,index";
      acl = ''
        *               @ALL              0
        *               @user            16
      '';
      plugins = [ 
        (import ./plugins/mermaid.nix { inherit pkgs; })
        (import ./plugins/indexmenu.nix { inherit pkgs; })
        (import ./plugins/tag.nix { inherit pkgs; })
        (import ./plugins/pagelist.nix { inherit pkgs; })
        (import ./plugins/cloud.nix { inherit pkgs; })
        (import ./plugins/imgpaste.nix { inherit pkgs; })
      ];
      extraConfig = ''
          $conf['title'] = 'Berge Wiki';
          $conf['superuser'] = 'dadmin';
          $conf['userewrite'] = 1;
          $conf['passcrypt'] = 'sha512';
          $conf['defer_js'] = 0;
          $conf['dmode'] = 02775;
          $conf['fmode'] = 0664;
      '';
    };
    services.nginx.virtualHosts."${hostName}" = {
      enableACME = true;
      forceSSL = true;
    };

    networking.firewall.allowedTCPPorts = [ 443 ];
  };
}
