{ config, lib, pkgs, ... }:

let
  cfg = config.services.endurain;
in
{
  options.services.endurain = {
    enable = lib.mkEnableOption "Endurain fitness tracking";
    image = lib.mkOption {
      type = lib.types.str;
      default = "ghcr.io/endurain-project/endurain:latest";
      description = "Endurain container image; may include a version tag or digest.";
    };
    host = lib.mkOption {
      type = lib.types.str;
      description = "Public URL of Endurain, including the scheme.";
    };
    listenAddress = lib.mkOption {
      type = lib.types.str;
      default = "127.0.0.1";
      description = "Address on which to publish the HTTP port.";
    };
    port = lib.mkOption {
      type = lib.types.port;
      default = 8080;
      description = "Published HTTP port.";
    };
    dataDir = lib.mkOption {
      type = lib.types.str;
      default = "/var/lib/endurain";
      description = "Persistent data, logs, and generated secrets directory.";
    };
    uid = lib.mkOption {
      type = lib.types.ints.unsigned;
      default = 1000;
      description = "Container user ID and owner of data and log directories.";
    };
    gid = lib.mkOption {
      type = lib.types.ints.unsigned;
      default = 1000;
      description = "Container group ID and group of data and log directories.";
    };
    environment = lib.mkOption {
      type = lib.types.attrsOf lib.types.str;
      default = { };
      description = "Additional Endurain environment variables, including database and proxy settings.";
    };
    environmentFiles = lib.mkOption {
      type = lib.types.listOf lib.types.str;
      default = [ ];
      description = "Runtime environment files for secrets and additional configuration.";
    };
    generateSecrets = lib.mkOption {
      type = lib.types.bool;
      default = true;
      description = "Generate persistent DB_PASSWORD, SECRET_KEY, and FERNET_KEY in secrets.env on first start.";
    };
    volumes = lib.mkOption {
      type = lib.types.listOf lib.types.str;
      default = [ ];
      description = "Additional container bind mounts, for example a PostgreSQL socket directory.";
    };
  };

  config = lib.mkIf cfg.enable {
    virtualisation.oci-containers.backend = lib.mkDefault "docker";
    virtualisation.oci-containers.containers.endurain = {
      inherit (cfg) image;
      user = "${toString cfg.uid}:${toString cfg.gid}";
      ports = [ "${cfg.listenAddress}:${toString cfg.port}:8080" ];
      environment = { ENDURAIN_HOST = cfg.host; } // cfg.environment;
      environmentFiles = lib.optional cfg.generateSecrets "${cfg.dataDir}/secrets.env" ++ cfg.environmentFiles;
      volumes = [
        "${cfg.dataDir}/data:/app/backend/data"
        "${cfg.dataDir}/logs:/app/backend/logs"
      ] ++ cfg.volumes;
    };

    systemd.services.endurain-init = {
      description = "Initialize Endurain storage and secrets";
      before = [ "${config.virtualisation.oci-containers.backend}-endurain.service" ];
      serviceConfig = {
        Type = "oneshot";
        RemainAfterExit = true;
        UMask = "0077";
      };
      script = ''
        install -d -m 0700 ${lib.escapeShellArg cfg.dataDir}
        install -d -m 0750 -o ${toString cfg.uid} -g ${toString cfg.gid} \
          ${lib.escapeShellArg "${cfg.dataDir}/data"} ${lib.escapeShellArg "${cfg.dataDir}/logs"}
        ${lib.optionalString cfg.generateSecrets ''
          if [ ! -e ${lib.escapeShellArg "${cfg.dataDir}/secrets.env"} ]; then
            secrets=$(mktemp ${lib.escapeShellArg "${cfg.dataDir}/secrets.env.XXXXXX"})
            {
              echo "DB_PASSWORD=$(${pkgs.openssl}/bin/openssl rand -hex 32)"
              echo "SECRET_KEY=$(${pkgs.openssl}/bin/openssl rand -hex 32)"
              echo "FERNET_KEY=$(${pkgs.openssl}/bin/openssl rand -base64 32 | tr '+/' '-_')"
            } > "$secrets"
            mv "$secrets" ${lib.escapeShellArg "${cfg.dataDir}/secrets.env"}
          fi
        ''}
      '';
    };
    systemd.services."${config.virtualisation.oci-containers.backend}-endurain" = {
      requires = [ "endurain-init.service" ];
      after = [ "endurain-init.service" ];
    };
  };
}
