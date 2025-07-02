{
  description = "My shared NixOS configuration";

  inputs = { };

  outputs =
    {
      self,
      nixpkgs,
      home-manager,
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

      homeConfigurations =
        let
          system = "x86_64-linux";
          pkgs = nixpkgs.legacyPackages.${system};
        in
        {
          asmund = {
            laptop = home-manager.lib.homeManagerConfiguration {
              inherit pkgs;

              modules = [
                ./home-manager/user/asmund/laptop
              ];
            };
            remote = home-manager.lib.homeManagerConfiguration {
              inherit pkgs;

              modules = [
                ./home-manager/user/asmund/remote
              ];
            };
          };
        };
    };
}
