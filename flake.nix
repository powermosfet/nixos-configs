{
  description = "My shared NixOS configuration";

  inputs = {
    actual-sparebank1.url = "github:powermosfet/actual-sparebank1";
  };

  outputs =
    {
      self,
      nixpkgs,
      actual-sparebank1,
      ...
    }:

    {
      nixosModules = {
        thinkpad = ./nixos/machine/thinkpad;
        mook = ./nixos/machine/mook;
        gilli = ./nixos/machine/gilli;
        agent25 = ./nixos/machine/agent25;
        conta-thinkpad = ./nixos/machine/conta-thinkpad;
      };

      homeConfigurations = {
        asmund = {
          laptop = ./home-manager/user/asmund/laptop;
          remote = ./home-manager/user/asmund/remote;
          mook = ./home-manager/user/asmund/mook;
        };
        extraSpecialArgs = {
          inherit actual-sparebank1;
        };

      };
    };
}
