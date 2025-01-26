{ pkgs, config, ... }:

let
  pname = "workout-tracker";
  version = "2.0.3";
  src = pkgs.fetchFromGitHub {
    owner = "jovandeginste";
    repo = "workout-tracker";
    rev = "refs/tags/v${version}";
    hash = "sha256-DJOYjKujb6mmqJcYhzPLv1uYgAIWW4hdH/gILlqkJXQ=";
  };
  assets = buildNpmPackage {
    pname = "${pname}-assets";
    inherit version src;
    npmDepsHash = "sha256-jHpCCMgjGvaAOfbslaIKfIRiPafScpn3WLnYamm+lbs=";
    dontNpmBuild = true;
    postPatch = ''
      rm Makefile
      '';
    installPhase = ''
      runHook preInstall
      cp -r . "$out"
      runHook postInstall
      '';
  };
in
{
  imports =
    [
    ];

  config = {
    services.workout-tracker = {
      enable = true;
      package = pkgs.workout-tracker.overrideAttrs {
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
