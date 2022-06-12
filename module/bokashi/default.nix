{ pkgs, ... }:

let
  hostName = "bokashi.berge.id";
  email = "asmund@berge.id";
  dbName = "bokashi";
  dbUser = "bokashi";
in
{
  environment.systemPackages = with pkgs; [
  ];

  services.postgresql = {
    enable = true;
    ensureDatabases = [ dbName ];
    ensureUsers = [
      { name = dbUser;
        ensurePermissions."DATABASE ${dbName}" = "ALL PRIVILEGES";
      }
    ];
  };
  services.postgresqlBackup.databases = [ dbName ];
}
