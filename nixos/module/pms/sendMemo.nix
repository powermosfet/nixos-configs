{
  pkgs,
  subject,
  content,
}:

let
  scriptName = "pms-send-memo";
  script = import ./sendMemoScript.nix { inherit pkgs; };
  app = pkgs.writeShellApplication {
    name = scriptName;
    runtimeInputs = with pkgs; [
      coreutils
    ];
    text = ''
      echo "${content}" | ${script} "${subject}"
    '';
  };
in
"${app}/bin/${scriptName}"
