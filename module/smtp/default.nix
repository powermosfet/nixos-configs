{ pkgs, lib, ... }:

let
in
{
  imports = [
  ];

  config = {
    services.opensmtpd = {
      enable = true;

      serverConfiguration = ''
        listen on lo

        action send relay

        match for any action send
      '';
    };
  };
}
