{
  config,
  lib,
  pkgs,
  ...
}:

let
  cfg = config.services.wallabag;
  php = cfg.phpPackage.buildEnv {
    extraConfig = ''
      display_errors = Off
      log_errors = On
      error_reporting = E_ALL & ~E_DEPRECATED & ~E_STRICT
    '';
    extensions =
      { enabled, all }:
      enabled
      ++ [
        all.tidy
        all.pdo_sqlite
        all.intl
        all.gd
        all.bcmath
      ];
  };
  console = pkgs.writeShellScriptBin "wallabag-console" ''
    set -eu
    cd ${lib.escapeShellArg cfg.dataDir}
    export WALLABAG_DATA=${lib.escapeShellArg cfg.dataDir}
    exec ${php}/bin/php ${cfg.package}/bin/console --env=prod --no-debug "$@"
  '';
  parameters = pkgs.writeText "wallabag-parameters.json" (
    builtins.toJSON {
      database_driver = "pdo_sqlite";
      database_path = "${cfg.dataDir}/data/db/wallabag.sqlite";
      database_charset = "utf8";
      domain_name = "https://${cfg.hostName}";
      server_name = "Les";
      fosuser_registration = false;
      fosuser_confirmation = false;
      mailer_dsn = "null://null";
    }
  );
  configure = pkgs.writeText "wallabag-configure.php" ''
    <?php
    require '${cfg.package}/vendor/autoload.php';
    use Symfony\Component\Yaml\Yaml;
    $path = getenv('WALLABAG_DATA');
    $secretPath = $path . '/data/secret';
    if (!file_exists($secretPath)) {
        file_put_contents($secretPath, bin2hex(random_bytes(32)) . "\n");
    }
    $settings = Yaml::parseFile('${cfg.package}/app/config/parameters.yml.dist');
    $settings['parameters'] = array_replace(
        $settings['parameters'],
        json_decode(file_get_contents('${parameters}'), true),
        ['secret' => trim(file_get_contents($secretPath))]
    );
    file_put_contents($path . '/app/config/parameters.yml', Yaml::dump($settings, 4));
  '';
  bootstrap = pkgs.writeText "wallabag-bootstrap.php" ''
    <?php
    require '${cfg.package}/vendor/autoload.php';
    use Symfony\Bundle\FrameworkBundle\Console\Application;
    use Symfony\Component\Console\Input\ArrayInput;
    use Symfony\Component\Console\Output\ConsoleOutput;
    $password = bin2hex(random_bytes(24));
    file_put_contents(getenv('WALLABAG_DATA') . '/data/initial-admin-password', $password . "\n");
    $application = new Application(new AppKernel('prod', false));
    $application->setAutoExit(false);
    $output = new ConsoleOutput();
    // PHP-FPM stays stopped until both commands succeed. The default password
    // is replaced in memory, without putting the new password in process argv.
    foreach ([
        ['command' => 'wallabag:install', '--no-interaction' => true],
        ['command' => 'fos:user:change-password', 'username' => 'wallabag', 'password' => $password],
    ] as $arguments) {
        $input = new ArrayInput($arguments);
        $input->setInteractive(false);
        $status = $application->run($input, $output);
        if ($status !== 0) { exit($status); }
    }
  '';
  prepare = pkgs.writeShellScript "wallabag-prepare" ''
    set -euo pipefail
    umask 0077
    export WALLABAG_DATA=${lib.escapeShellArg cfg.dataDir}
    cd "$WALLABAG_DATA"
    mkdir -p data/db var/logs var/sessions/prod web/assets/images web/uploads/import
    chmod 0711 . web web/assets
    chmod 0755 web/assets/images
    if [ -e .package ] && [ "$(cat .package)" != '${cfg.package}' ]; then
      previous=$(cat .version)
      if [ "$previous" != '${cfg.package.version}' ] && \
         [ "$(printf '%s\n' "$previous" '${cfg.package.version}' | sort -V | head -n1)" != "$previous" ]; then
        echo 'Wallabag downgrade refused: restore the matching database backup first.' >&2
        exit 1
      fi
      snapshot=${lib.escapeShellArg cfg.backupDir}/pre-upgrade-$(date -u +%Y%m%dT%H%M%S)-$$.tar
      tar -cf "$snapshot" app data web .package .version .initialized
    fi
    # Refresh packaged configuration on every start; never overwrite data or secrets.
    rm -rf app var/cache
    cp -R --no-preserve=mode ${cfg.package}/app app
    chmod -R u+w app
    for item in src vendor translations; do
      ln -sfn ${cfg.package}/"$item" "$item"
    done
    for item in ${cfg.package}/web/*; do
      name=$(basename "$item")
      case "$name" in assets|uploads) continue ;; esac
      ln -sfn "$item" "web/$name"
    done
    ${php}/bin/php ${configure}
    if [ ! -e .initialized ]; then
      if [ -e data/db/wallabag.sqlite ]; then
        echo 'Uninitialized Wallabag database exists; refusing to reset it. See the Wallabag README.' >&2
        exit 1
      fi
      ${php}/bin/php ${bootstrap}
      touch .initialized
    else
      ${console}/bin/wallabag-console doctrine:migrations:migrate --no-interaction
    fi
    ${console}/bin/wallabag-console cache:warmup
    printf '%s\n' '${cfg.package}' > .package
    printf '%s\n' '${cfg.package.version}' > .version
    # Downloaded images must be readable by nginx, including nested hash directories.
    chmod -R a+rX web/assets/images
  '';
in
{
  options.services.wallabag = {
    enable = lib.mkEnableOption "Wallabag read-it-later service";
    package = lib.mkPackageOption pkgs "wallabag" { };
    phpPackage = lib.mkOption {
      type = lib.types.package;
      default = pkgs.php83;
      defaultText = lib.literalExpression "pkgs.php83";
      description = "PHP runtime used by both the console and PHP-FPM.";
    };
    hostName = lib.mkOption {
      type = lib.types.str;
      description = "Canonical HTTPS hostname.";
    };
    listenAddress = lib.mkOption {
      type = lib.types.str;
      description = "Local Tailscale IPv4 address for HTTPS.";
    };
    dataDir = lib.mkOption {
      type = lib.types.str;
      default = "/var/lib/wallabag";
      description = "Persistent application state.";
    };
    backupDir = lib.mkOption {
      type = lib.types.str;
      default = "/var/lib/wallabag-backups";
      description = "Snapshots taken before package upgrades.";
    };
  };

  config = lib.mkIf cfg.enable {
    users.groups.wallabag = { };
    users.users.wallabag = {
      isSystemUser = true;
      group = "wallabag";
      home = cfg.dataDir;
    };
    environment.systemPackages = [ console ];
    services.phpfpm.pools.wallabag = {
      user = "wallabag";
      phpPackage = php;
      phpEnv.WALLABAG_DATA = cfg.dataDir;
      phpOptions = ''
        date.timezone = Europe/Oslo
        memory_limit = 256M
        upload_max_filesize = 100M
        post_max_size = 100M
      '';
      settings = {
        "listen.owner" = config.services.nginx.user;
        "listen.mode" = "0600";
        "pm" = "ondemand";
        "pm.max_children" = 3;
        "pm.process_idle_timeout" = "30s";
        "pm.max_requests" = 500;
      };
    };
    systemd.services.phpfpm-wallabag = {
      restartTriggers = [ prepare ];
      path = [
        pkgs.coreutils
        pkgs.gnutar
      ];
      preStart = ''
        install -d -m 0711 -o wallabag -g wallabag ${lib.escapeShellArg cfg.dataDir}
        install -d -m 0700 -o wallabag -g wallabag ${lib.escapeShellArg cfg.backupDir}
        ${pkgs.util-linux}/bin/runuser -u wallabag -- ${prepare}
      '';
      serviceConfig.UMask = "0022";
      serviceConfig.TimeoutStartSec = "10min";
    };

    services.nginx = {
      enable = true;
      virtualHosts.${cfg.hostName} = {
        onlySSL = true;
        enableACME = true;
        # Explicit listeners keep this vhost out of nginx's wildcard listeners.
        listen = [
          {
            addr = cfg.listenAddress;
            port = 443;
            ssl = true;
          }
        ];
        root = "${cfg.package}/web";
        extraConfig = ''
          client_max_body_size 100M;
          allow 100.64.0.0/10;
          deny all;
        '';
        locations."/".tryFiles = "$uri /app.php$is_args$args";
        locations."~ ^/app\\.php(/|$)" = {
          priority = 100;
          extraConfig = ''
            internal;
            fastcgi_pass unix:${config.services.phpfpm.pools.wallabag.socket};
            include ${config.services.nginx.package}/conf/fastcgi_params;
            fastcgi_param SCRIPT_FILENAME ${cfg.package}/web/app.php;
            fastcgi_param DOCUMENT_ROOT ${cfg.package}/web;
            fastcgi_param HTTP_AUTHORIZATION $http_authorization;
            fastcgi_param HTTPS on;
            fastcgi_read_timeout 300s;
          '';
        };
        locations."^~ /assets/images/" = {
          alias = "${cfg.dataDir}/web/assets/images/";
          extraConfig = "add_header X-Content-Type-Options nosniff;";
        };
        locations."^~ /uploads/".extraConfig = "deny all;";
        locations."~ (\\.php$|/\\.)".extraConfig = "deny all;";
      };
    };
  };
}
