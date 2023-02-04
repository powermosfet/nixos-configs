
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
# settings.title = "Berge Wiki";
        stateDir = dataDir;
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
          (import ./plugins/backlinks.nix { inherit pkgs; })
        ];
        extraConfig = ''
          $conf['title'] = 'Berge Wiki';
          $conf['superuser'] = 'dadmin';
          $conf['userewrite'] = 1;
          $conf['passcrypt'] = 'sha512';
          $conf['defer_js'] = 0;
          $conf['dmode'] = 02775;
          $conf['fmode'] = 0664;
          $conf['dformat'] = '%Y/%m/%d %H:%M (%f)';
        '';
      };

      borgbackup.jobs."${builtins.replaceStrings ["."] ["-"] hostName}" = {
        paths = dataDir;
        encryption.mode = "none";
        environment.BORG_RSH = "ssh -i /root/.ssh/id_borg-main";
        repo = "borg@gilli.local:.";
        compression = "auto,zstd";
      };

      nginx.virtualHosts."${hostName}" = {
        enableACME = true;
        forceSSL = true;
      };
    };

    networking.firewall.allowedTCPPorts = [ 443 ];
  };
}
