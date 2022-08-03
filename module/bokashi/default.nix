{ pkgs, ... }:

let
  pkgs2111 = import (fetchTarball "https://github.com/NixOS/nixpkgs/archive/21.11.tar.gz") { };

  dbName = "bokashi";
  user = "bokashi";
  group = "bokashi";
  port = 8008;

  postgrest = pkgs2111.haskellPackages.postgrest;
  postgrestConf = pkgs.writeTextFile {
    name = "${dbName}.conf";
    text = ''
      db-uri = "postgres://${user}@/${dbName}"
      db-schema = "public"
      db-anon-role = "${user}"
      server-port = ${port}
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

  networking.firewall.allowedTCPPorts = [ port ];
}
