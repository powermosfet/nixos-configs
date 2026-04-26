{
  pkgs,
}:

let
  scriptName = "pms-send-memo";
  host = "mook.local";
  mookPorts = import ../../machine/mook/ports.nix;
  strPort = toString mookPorts.exposed.pms;
  app = pkgs.writeShellApplication {
    name = scriptName;
    runtimeInputs = with pkgs; [
      curl
      jq
      coreutils
    ];
    text = ''
      jq -n --arg subject "$1" --arg content "$(cat)" '{subject: $subject, content: $content}' | curl http://${host}:${strPort}/memo --json @-
    '';
  };
in
"${app}/bin/${scriptName}"
