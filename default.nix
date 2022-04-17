{ }:  

{
  machine = {
    contadev = {
      imports = [ ./machine/contadev.nix ];
    };
    mook = {
      imports = [ ./machine/mook.nix ];
    };
    gilli = {
      imports = [ ./machine/gilli.nix ];
    };
  };
}
