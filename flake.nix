{
  description = "My shared NixOS configuration";

  inputs = { };

  outputs =
    {
      self,
      nixpkgs,
      ...
    }:

    {
      nixosModules = {
        thinkpad = {
          imports = [ ./nixos/machine/thinkpad ];
        };
        mook = {
          imports = [ ./nixos/machine/mook ];
        };
        gilli = {
          imports = [ ./nixos/machine/gilli ];
        };
        conta-thinkpad = {
          imports = [ ./nixos/machine/conta-thinkpad ];
        };
      };

      homeConfigurations = {
        asmund = {
          laptop = ./home-manager/user/asmund/laptop;
          remote = ./home-manager/user/asmund/remote;
        };
      };
    };
}
