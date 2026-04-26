{
  pkgs,
  service,
  status,
}:

let
  sendMemoScript = import ../../pms/sendMemoScript.nix { inherit pkgs; };
  notifyScriptName = "borg-notification";
  notifyScript = pkgs.writeShellApplication {
    name = notifyScriptName;
    runtimeInputs = with pkgs; [
      systemd
      hostname
    ];
    text = ''
      DURATION=$(systemctl show borgbackup-job-gilli --property=ExecMainStartTimestamp --property=ExecMainExitTimestamp)
      SUBJECT="Backup ${status} on $(hostname)"
      CONTENT=$(printf '%s\n%s' "${service}" "$DURATION")
      echo "$CONTENT" | ${sendMemoScript} "$SUBJECT"
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
