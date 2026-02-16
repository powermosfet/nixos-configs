{
  description = "My shared NixOS configuration";

  inputs = {
  };

  outputs =
    {
      self,
      nixpkgs,
      ...
    }:

    {
      nixosModules = {
        thinkpad-t440 = ./nixos/machine/thinkpad-t440;
        thinkpad-p14s = ./nixos/machine/thinkpad-p14s;
        mook = ./nixos/machine/mook;
        zook = ./nixos/machine/zook;
        gilli = ./nixos/machine/gilli;
        agent25 = ./nixos/machine/agent25;
      };

      homeConfigurations = {
        asmund = {
          laptop = ./home-manager/user/asmund/laptop;
          remote = ./home-manager/user/asmund/remote;
          mook = ./home-manager/user/asmund/mook;
        };
      };
    };
}
