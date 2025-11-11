{ pkgs, config, ... }:

let
  tunnel-port = 9101;
  prometheus-port = 9100;
  local-opts = config.local.prometheus;
in
{
}
