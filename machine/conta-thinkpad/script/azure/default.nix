pkgs.stdenv.mkDerivation {
  name = "azure";
  propagatedBuildInputs = [
    (pkgs.python3.withPackages (
      pythonPackages: with pythonPackages; [
        requests
      ]
    ))
  ];
  dontUnpack = true;
  installPhase = "install -Dm755 ${./azure.py} $out/bin/az";
}
