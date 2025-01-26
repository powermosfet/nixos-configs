{ pkgs, config, ... }:

let
  pname = "workout-tracker";
  version = "2.0.2";
  src = pkgs.fetchFromGitHub {
    owner = "jovandeginste";
    repo = "workout-tracker";
    rev = "refs/tags/v${version}";
    hash = "sha256-m0f6iyexRRPXNGt56uaQrUmQiOuyb0ieze6CpY/QZfQ=";
  };
  assets = pkgs.buildNpmPackage {
    pname = "${pname}-assets";
    inherit version src;
    npmDepsHash = "sha256-ntOQeTyTkYx1WILE+CV/BPCgT1T6zkBynCOeQWvhFr4=";
    dontNpmBuild = true;
    postPatch = ''
      rm Makefile
      '';
    installPhase = ''
      runHook preInstall
      cp -r . "$out"
      runHook postInstall
      '';
    makeCacheWritable = true;
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
        inherit version src assets;
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
