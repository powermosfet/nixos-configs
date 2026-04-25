{
  pkgs,
  service,
  status,
}:

let
  sendMemoScript = import ./sendMemoScript.nix { inherit pkgs; };
  notifyScriptName = "borg-notification";
  notifyScript = pkgs.writeShellApplication {
    name = notifyScriptName;
    runtimeInputs = with pkgs; [
      curl
      jq
    ];
    text = ''
      DURATION=$(systemctl status "${service}" | grep Duration)
      SUBJECT="Backup ${status} on $HOST"
      CONTENT="${service}\\n$DURATION"
      ${sendMemoScript} "$SUBJECT" "$CONTENT"
    '';
  };
in
{
  description = "Notify ${service} ${status}";
  serviceConfig = {
    Type = "oneshot";
    ExecStart = "${notifyScript}/bin/${notifyScriptName}";
  };
}
