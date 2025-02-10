{ config, pkgs, ... }:

let
  unstable = import <nixos-unstable> { };
in
{
  imports =
    [ 
    ];
     
  users.users.nure = {
    isNormalUser = true;
  };

  services.nginx.virtualHosts."nure.berge.id" = {
    addSSL = true;
    enableACME = true;
    root = "/home/nure/www";
  };
}

