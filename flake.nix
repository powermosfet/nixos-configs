{
  description = "My shared NixOS configuration";

  inputs = {
    pms = {
      url = "github:powermosfet/pms";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs =
    {
      self,
      nixpkgs,
      pms,
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
        pmsArgs = (
          { pkgs, ... }:
          {
            _module.args.pmsFlake = pms;
          }
        );
      };

      homeConfigurations = {
        asmund = {
          laptop = ./home-manager/user/asmund/laptop;
          remote = ./home-manager/user/asmund/remote;
          mook = ./home-manager/user/asmund/mook;
          iteramac = ./home-manager/user/asmund/iteramac;
        };
      };
    };
}
