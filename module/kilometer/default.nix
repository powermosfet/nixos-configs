{ pkgs, ... }:

let
  dbName = "kilometer";
  user = "kilometer";
  group = "kilometer";
in
{
  users.groups."${group}" = { };
  users.users."${user}" = {
    isSystemUser = true;
    group = "${group}";
  };
  services.postgresql = {
    enable = true;
    ensureDatabases = [ dbName ];
    ensureUsers = [
      {
        name = user;
        ensureDBOwnership = true;
      }
    ];
  };
  services.postgresqlBackup.databases = [ dbName ];
}
