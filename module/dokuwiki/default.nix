
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
  dokuwiki-plugin-indexmenu = pkgs.stdenv.mkDerivation {
    name = "indexmenu";
    src = pkgs.fetchzip {
      url = "https://github.com/samuelet/indexmenu/archive/refs/heads/master.zip";
      sha256 = "sha256-ayUnYhpx8jOQULs2lsR7+TeXRUHK8110vhfw0BcQX2I=";
    };
    sourceRoot = ".";
    installPhase = "mkdir -p $out; cp -R source/* $out/";
  };
  dokuwiki-plugin-tag = pkgs.stdenv.mkDerivation {
    name = "tag";
    src = pkgs.fetchzip {
      url = "https://github.com/dokufreaks/plugin-tag/archive/refs/heads/master.zip";
      sha256 = "sha256-0ru90nDvePqdcdwVFmeXKatbmXVORx3gtpTRsrdRRMA=";
    };
    sourceRoot = ".";
    installPhase = "mkdir -p $out; cp -R source/* $out/";
  };
  dokuwiki-plugin-tagging = pkgs.stdenv.mkDerivation {
    name = "tag";
    src = pkgs.fetchzip {
      url = "https://github.com/cosmocode/tagging/archive/refs/heads/master.zip";
      sha256 = "sha256-SahmPJOkS41RTkPBgmFhaycsUjCbiSS7+/N4prUAGDE=";
    };
    sourceRoot = ".";
    installPhase = "mkdir -p $out; cp -R source/* $out/";
  };
  dokuwiki-plugin-pagelist = pkgs.stdenv.mkDerivation {
    name = "pagelist";
    src = pkgs.fetchzip {
      url = "https://github.com/dokufreaks/plugin-pagelist/archive/refs/heads/master.zip";
      sha256 = "sha256-ATk/qjsFrAOZpfu79Pp+YWtCYnkEJ7fSaTHanOS5wMg=";
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
      disableActions = "register,index";
      acl = ''
        *               @ALL              0
        *               @user            16
      '';
      plugins = [ 
        dokuwiki-plugin-mermaid
        dokuwiki-plugin-indexmenu
        dokuwiki-plugin-tag
        dokuwiki-plugin-pagelist
        dokuwiki-plugin-tagging
      ];
      extraConfig = ''
          $conf['title'] = 'Berge Wiki';
          $conf['userewrite'] = 1;
          $conf['passcrypt'] = 'sha512';
          $conf['defer_js'] = 0;
      '';
    };
    services.nginx.virtualHosts."${hostName}" = {
      enableACME = true;
      forceSSL = true;
    };

    networking.firewall.allowedTCPPorts = [ 443 ];
  };
}
