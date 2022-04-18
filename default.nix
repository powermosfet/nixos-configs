{ }:  

{
  machine = {
    contadev = {
      imports = [ ./machine/contadev.nix ];
    };
    mook = {
      imports = [ ./machine/mook ];
    };
    gilli = {
      imports = [ ./machine/gilli.nix ];
    };
  };
}
