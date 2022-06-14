{ pkgs, ... }:

let
  dbName = "bokashi";
  user = "bokashi";
  group = "bokashi";

  postgrest = pkgs.haskellPackages.postgrest;
  postgrestConf = pkgs.writeTextFile {
    name = "${dbName}.conf";
    text = ''
      db-uri = "postgres://${user}@/${dbName}"
      db-schemas = "public"
      db-anon-role = "${user}"
      server-port = 8008
    '';
  };
in
{
  users.groups."${group}" = {};
  users.users."${user}" = {
    isSystemUser = true;
    group = "${group}";
  };
  services.postgresql = {
    enable = true;
    ensureDatabases = [ dbName ];
    ensureUsers = [
      { name = user;
        ensurePermissions."DATABASE ${dbName}" = "ALL PRIVILEGES";
      }
    ];
  };
  services.postgresqlBackup.databases = [ dbName ];
  systemd.services.bokashi = {
    description = "Bokashi log";
    wantedBy = [ "multi-user.target" ];
    after = [ "network.target" ];
    environment = {
    };
    serviceConfig = {
      User = user;
      ExecStart = "${postgrest}/bin/postgrest ${postgrestConf}";
    };
  };
}
