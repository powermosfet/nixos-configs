{ config, pkgs, ... }:

let
  port = 8002;
  clientId = "029cc178-e604-4d7f-a17c-a41f92c3182c";
  listId = "AQMkADAwATNiZmYAZC0xZjgwLTE2YzUtMDACLTAwCgAuAAADQGkXSjdFSkyRkPd2Ueax6wEA-3jtJitJ3EmtwtXWE62J7QAByGcE3wAAAA==";
in
{
  imports =
    [ ./service.nix
    ];

  services.als = {
    enable = true;
    port = port;
    clientId = clientId;
    listId = listId;
  };

  networking.firewall.allowedTCPPorts = [ port ];
}

