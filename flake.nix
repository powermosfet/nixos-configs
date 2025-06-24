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

      homeConfigurations =
        let
          system = "x86_64-linux";
          pkgs = nixpkgs.legacyPackages.${system};
        in
        {
          asmund = home-manager.lib.homeManagerConfiguration {
            inherit pkgs;

            modules = [
              ./user/asmund/home.nix
            ];
          };
        };
    };
}
