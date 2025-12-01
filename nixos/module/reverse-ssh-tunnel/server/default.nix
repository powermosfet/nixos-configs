{ pkgs, ... }:

let
  common = import ../common.nix;
  public-key = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIPTfiLf2X+5tUzFSAn4C+2xQhB5RsRxNeqiqNGFvwG5i tunnel-client@agent25";
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
