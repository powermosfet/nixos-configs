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
      package = pkgs.workout-tracker.overrideAttrs {                
        version = workout-tracker-version;                               
        src = pkgs.fetchFromGitHub {                                     
          owner = "jovandeginste";                                       
          repo = "workout-tracker";                                      
          rev = "refs/tags/v${workout-tracker-version}";                 
          hash = "sha256-DJOYjKujb6mmqJcYhzPLv1uYgAIWW4hdH/gILlqkJXQ=";  
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
