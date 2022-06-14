{ pkgs, ... }:

{
  config = {
    services.ddclient = {
      enable = true;

      protocol = "namecheap";
      server = "fqdn.of.service";
      username = "asmundberge";
    };
  };
}
