{ config, lib, ... }:

let
  cfg = config.services.endurain;
  hostname = "svette.berge.id";
  containerUnit = "${config.virtualisation.oci-containers.backend}-endurain";
in
{
  imports = [ ../../service/endurain ../postgresql ../postgresql/backup ../nginx ];

  services.endurain = {
    enable = true;
    host = "https://${hostname}";
    volumes = [ "/run/postgresql:/run/postgresql" ];
    environment = {
      DB_HOST = "/run/postgresql";
      DB_PORT = toString config.services.postgresql.settings.port;
      DB_USER = "endurain";
      DB_DATABASE = "endurain";
      TZ = config.time.timeZone;
      BEHIND_PROXY = "true";
      # Docker resolves this to the host-side bridge address used by nginx.
      TRUSTED_PROXIES = "host.docker.internal";
      RATE_LIMIT_STORAGE_URI = "memory://";
    };
  };
  virtualisation.oci-containers.containers.endurain.extraOptions = [
    "--add-host=host.docker.internal:host-gateway"
  ];

  services.postgresql = {
    ensureDatabases = [ "endurain" ];
    ensureUsers = [{ name = "endurain"; ensureDBOwnership = true; }];
    authentication = lib.mkBefore ''
      local endurain endurain scram-sha-256
    '';
  };
  systemd.services.endurain-database = {
    description = "Configure Endurain PostgreSQL credentials";
    requires = [ "postgresql.service" "endurain-init.service" ];
    after = [ "postgresql.service" "endurain-init.service" ];
    before = [ "${containerUnit}.service" ];
    serviceConfig = {
      Type = "oneshot";
      RemainAfterExit = true;
      User = "postgres";
      EnvironmentFile = "${cfg.dataDir}/secrets.env";
    };
    script = ''
      ${config.services.postgresql.package}/bin/psql -p ${toString config.services.postgresql.settings.port} -d postgres -v ON_ERROR_STOP=1 <<'SQL'
      \getenv db_password DB_PASSWORD
      -- ensureUsers/ensureDatabases run only when PostgreSQL starts. Provision
      -- here as well when enabling Endurain against an already running server.
      SELECT 'CREATE ROLE endurain LOGIN'
      WHERE NOT EXISTS (SELECT FROM pg_roles WHERE rolname = 'endurain')
      \gexec
      SELECT 'CREATE DATABASE endurain OWNER endurain'
      WHERE NOT EXISTS (SELECT FROM pg_database WHERE datname = 'endurain')
      \gexec
      ALTER DATABASE endurain OWNER TO endurain;
      SET password_encryption = 'scram-sha-256';
      ALTER ROLE endurain WITH PASSWORD :'db_password';
      SQL
    '';
  };
  systemd.services.${containerUnit} = {
    requires = [ "endurain-database.service" ];
    after = [ "endurain-database.service" ];
  };

  services.nginx.virtualHosts.${hostname} = {
    enableACME = true;
    forceSSL = true;
    locations."/" = {
      proxyPass = "http://127.0.0.1:${toString cfg.port}";
      proxyWebsockets = true;
      extraConfig = ''
        client_max_body_size 100m;
        proxy_read_timeout 300s;
      '';
    };
  };
  services.ddclient.domains = [ hostname ];
  services.postgresqlBackup.databases = [ "endurain" ];
  backup.paths = [ cfg.dataDir ];
}
