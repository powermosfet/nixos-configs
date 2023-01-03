{ pkgs, ... }:

{
  config = {
    services.ddclient = {
      enable = true;

      protocol = "namecheap";
      server = "dynamicdns.park-your-domain.com";
      username = "asmundberge";
    };
  };
}
