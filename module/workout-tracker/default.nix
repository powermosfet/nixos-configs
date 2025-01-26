{ pkgs, config, ... }:

let
  workout-tracker-version = "2.0.3";
in
{
  imports =
    [
    ];

  config = {
    services.workout-tracker = {
      enable = true;
      package = pkgs.workout-tracker.override {                
        version = workout-tracker-version;                               
        src = pkgs.fetchFromGitHub {                                     
          owner = "jovandeginste";                                       
          repo = "workout-tracker";                                      
          rev = "refs/tags/v${workout-tracker-version}";                 
          hash = "sha256-A5HmAKRiHwo7aPrhQWHjPZUT29zaxCN6z4SR8jR9jOg=";  
        };
      };
      
      settings = {
        WT_REGISTRATION_DISABLED = "true";
      };
    };

    services.nginx.virtualHosts."trening.berge.id" = {
      enableACME = true;
      forceSSL = true;
      locations = {
        "/" = {
          proxyPass = "http://127.0.0.1:${builtins.toString(config.services.workout-tracker.port)}";
          proxyWebsockets = true;
        };
      };
    };
  };
}
