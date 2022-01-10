{ config, pkgs, ... }:

let
	  alsSecrets = import /run/keys/als-secrets.nix;

	in
{
  imports =
    [ ../service/als.nix
      ../software/mediawiki.nix
      ../software/avahi.nix
      ../software/neovim.nix
    ];

  environment.systemPackages = with pkgs; [
    git
    neovim 
  ];

  services.openssh.enable = true;
  

  services.als = {
    enable = true;
    port = 8002;
    clientId = "029cc178-e604-4d7f-a17c-a41f92c3182c";
    accessToken = alsSecrets.accessToken;
    refreshToken = alsSecrets.refreshToken;
    listId = "AQMkADAwATNiZmYAZC0xZjgwLTE2YzUtMDACLTAwCgAuAAADQGkXSjdFSkyRkPd2Ueax6wEA-3jtJitJ3EmtwtXWE62J7QAByGcE3wAAAA==";
  };

  networking.firewall.allowedTCPPorts = [ 22 80 443 ];
}

