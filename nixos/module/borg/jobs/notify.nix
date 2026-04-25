{
  pkgs,
  service,
  status,
}:

let
  mookPorts = import ../../../machine/mook/ports.nix;
  strPort = toString mookPorts.exposed.pms;
in
{
  description = "Notify ${service} ${status}";
  serviceConfig = {
    Type = "oneshot";
    ExecStart = ''
      DURATION=$(systemctl status "${service}" | grep Duration)
      ${pkgs.curl}/bin/curl http://localhost:${strPort}/memo --json "{\"subject\":\"Backup ${status}\",\"content\":\"${service}\\n$DURATION\"}"
    '';
  };
}
