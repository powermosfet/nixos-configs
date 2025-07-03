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
        thinkpad = ./nixos/machine/thinkpad;
        mook = ./nixos/machine/mook;
        gilli = ./nixos/machine/gilli;
        conta-thinkpad = ./nixos/machine/conta-thinkpad;
      };

      homeConfigurations = {
        asmund = {
          laptop = ./home-manager/user/asmund/laptop;
          remote = ./home-manager/user/asmund/remote;
        };
      };
    };
}
