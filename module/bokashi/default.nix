{ pkgs, ... }:

let
  dbName = "bokashi";
  user = "bokashi";
  group = "bokashi";
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
}
