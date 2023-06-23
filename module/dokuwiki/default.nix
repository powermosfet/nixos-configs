{ config, pkgs, lib, ... }:

  with lib;

let
  hostName = "dokuwiki.berge.id";
  dataDir = "/var/lib/dokuwiki/${hostName}/data";
in
{
  config = {
    services = {
      dokuwiki.sites."${hostName}" = {
        enable = true;
        stateDir = dataDir;
        acl = [
          {
            page = "*";
            actor = "@ALL";
            level = 0;
          }
          {
            page = "*";
            actor = "@user";
            level = 16;
          }
        ];
        plugins = [ 
          (import ./plugins/mermaid.nix { inherit pkgs; })
          (import ./plugins/indexmenu.nix { inherit pkgs; })
          (import ./plugins/tag.nix { inherit pkgs; })
          (import ./plugins/pagelist.nix { inherit pkgs; })
          (import ./plugins/imgpaste.nix { inherit pkgs; })
          (import ./plugins/backlinks.nix { inherit pkgs; })
          (import ./plugins/tagfilter.nix { inherit pkgs; })
          (import ./plugins/move.nix { inherit pkgs; })
          (import ./plugins/sqlite.nix { inherit pkgs; })
          (import ./plugins/struct.nix { inherit pkgs; })
        ];
        settings = {
          title = "Berge Wiki";
          superuser = "dadmin";
          userewrite = 1;
          passcrypt = "sha512";
          useacl = true;
          defer_js = 0;
          dformat = "%Y-%m-%d %H:%M (%f)";
          disableActions = "register,index";
        };
      };

      nginx.virtualHosts."${hostName}" = {
        enableACME = true;
        forceSSL = true;
      };
      ddclient.domains = [ hostName ];
    };

    backup.paths = [ dataDir ];

    networking.firewall.allowedTCPPorts = [ 443 ];
  };
}
