{
  description = "My shared NixOS configuration";

  inputs = {
    nixpkgs = {
      url = "github:NixOS/nixpkgs/nixos-25.05";
    };
  };

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
