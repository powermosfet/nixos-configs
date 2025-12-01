{ pkgs, ... }:

let
  common = import ../common.nix;
  public-key = "ssh-ed25519 AAAA...your-backup-node-public-key";
in
{
  users.users.tunnel = {
    isSystemUser = true;
    group = "tunnel";
    home = "/var/lib/tunnel";
    createHome = true;
    shell = pkgs.shadow;
    openssh.authorizedKeys.keys = [
      ''command="echo 'Tunnel only'",restrict,permitopen="localhost:${builtins.toString common.port}" ${public-key}''
    ];
  };
  users.groups = {
    tunnel = { };
  };
}
