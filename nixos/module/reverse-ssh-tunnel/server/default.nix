{ pkgs, ... }:

let
  common = import ../common.nix;
  public-key = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIPTfiLf2X+5tUzFSAn4C+2xQhB5RsRxNeqiqNGFvwG5i tunnel-client@agent25";
in
{
  users.users."${common.user}" = {
    isSystemUser = true;
    group = "${common.user}";
    home = "/var/lib/${common.user}";
    createHome = true;
    shell = pkgs.shadow;
    openssh.authorizedKeys.keys = [
      ''command="echo 'Tunnel only'",permitlisten="localhost:${builtins.toString common.port}" ${public-key}''
    ];
  };
  users.groups = {
    "${common.user}" = { };
  };
}
