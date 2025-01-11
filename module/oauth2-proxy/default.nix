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
      nginx.domain = "oauth.berge.id";
    };
  };
}
