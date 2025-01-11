{ pkgs, ... }:

{
  imports =
    [
    ];

  options = {
  };

  config = {
    services.oauth2-proxy = {
      enable = true;

      provider = "gitlab";
      domain = "oauth.berge.id";
      nginx.virtualHosts."oauth.berge.id" = { };
    };
  };
}
