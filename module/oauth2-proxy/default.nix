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

      provider = "github";
      nginx.domain = "oauth.berge.id";
      email.domains = [ "berge.id" ];
    };
  };
}
