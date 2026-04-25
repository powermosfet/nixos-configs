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
    text = ''
      ${script} "${subject}" "${content}"
    '';
  };
in
"${app}/bin/${scriptName}"
