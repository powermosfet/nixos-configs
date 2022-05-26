{ pkgs, lib, ... }:

let
  hydroxide = pkgs.buildGoModule rec {
    pname = "hydroxide";
    version = "0.2.23";

    src = pkgs.fetchFromGitHub {
      owner = "emersion";
      repo = pname;
      rev = "v${version}";
      sha256 = "sha256-fF+pQnqAWBktc4NdQFTHeB/sEg5bPTxXtdL1x5JuXU8=";
    };

    vendorSha256 = "sha256-M5QlhF2Cj1jn5NNiKj1Roh9+sNCWxQEb4vbtsDfapWY=";

    doCheck = false;

    subPackages = [ "cmd/hydroxide" ];

    meta = with lib; {
      description = "A third-party, open-source ProtonMail bridge";
      homepage = "https://github.com/emersion/hydroxide";
      license = licenses.mit;
      maintainers = with maintainers; [ Br1ght0ne ];
      platforms = platforms.unix;
    };
  };
in
{
  imports =
    [
    ];

  config = {
    systemd.services.hydroxide = {
      description = "Hydroxide - Headless proton mail bridge";
      wantedBy = [ "multi-user.target" ];
      after = [ "network.target" ];
      environment = {
        HOME = "/root";
      };
      serviceConfig = {
        ExecStart = "${hydroxide}/bin/hydroxide smtp";
      };
    };
 };
}
