{
  config,
  ...
}:

let
  cfg = config.services.cryptpad;
  unsafeOrigin = "https://cp.berge.id";
  safeOrigin = "https://cp-sb.berge.id";
in
{
  services.cryptpad = {
    enable = true;

    configureNginx = true;
    settings = {
      httpSafeOrigin = safeOrigin;
      httpUnsafeOrigin = unsafeOrigin;
    };
  };
}
