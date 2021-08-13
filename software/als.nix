{ config, pkgs, ... }:

let
  secrets = import /run/keys/als-secrets.nix;
  port = 8002;

in
{
  imports =
    [
    ];

  services.als = {
    enable = true;
    port = port;
    clientId = "029cc178-e604-4d7f-a17c-a41f92c3182c";
    accessToken = alsSecrets.accessToken;
    refreshToken = alsSecrets.refreshToken;
    listId = "AQMkADAwATNiZmYAZC0xZjgwLTE2YzUtMDACLTAwCgAuAAADQGkXSjdFSkyRkPd2Ueax6wEA-3jtJitJ3EmtwtXWE62J7QAByGcE3wAAAA==";
  };

  networking.firewall.allowedTCPPorts = [ port ];
}

