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
      nginx.virtualHosts."oauth.berge.id".allowed_email_domains = [ "berge.id" ];
      email.domains = [ "berge.id" ];
    };
  };
}
