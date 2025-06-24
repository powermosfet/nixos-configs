{
  description = "My shared NixOS configuration";

  inputs = { };

  outputs =
    { self, nixpkgs, ... }:
    {
      nixosModules = {
        thinkpad = {
          imports = [ ./machine/thinkpad ];
        };
        mook = {
          imports = [ ./machine/mook ];
        };
        gilli = {
          imports = [ ./machine/gilli ];
        };
        conta-thinkpad = {
          imports = [ ./machine/conta-thinkpad ];
        };
      };
    };
}
