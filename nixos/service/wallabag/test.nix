# Run with: nix-build nixos/service/wallabag/test.nix --no-out-link
{
  pkgs ? import <nixpkgs> { },
}:

let
  system = import (pkgs.path + "/nixos/lib/eval-config.nix") {
    inherit pkgs;
    modules = [
      ./default.nix
      ({ lib, ... }: {
        system.stateVersion = "25.11";
        services.wallabag = {
          enable = true;
          hostName = "les.example.test";
          listenAddress = "100.64.0.1";
          dataDir = "/build/wallabag";
          backupDir = "/build/wallabag-backups";
        };
        services.nginx.enableReload = true;
        services.nginx.virtualHosts = {
          "les.example.test" = {
            enableACME = lib.mkForce false;
            sslCertificate = "/build/test-cert.pem";
            sslCertificateKey = "/build/test-key.pem";
          };
          "other.example.test" = {
            onlySSL = true;
            listen = [
              {
                addr = "0.0.0.0";
                port = 18443;
                ssl = true;
              }
            ];
            sslCertificate = "/build/test-cert.pem";
            sslCertificateKey = "/build/test-key.pem";
            locations."/".return = "418";
          };
        };
      })
    ];
  };
  cfg = system.config;
  prepare = builtins.head cfg.systemd.services.phpfpm-wallabag.restartTriggers;
  php = cfg.services.phpfpm.pools.wallabag.phpPackage;
in
pkgs.runCommand "wallabag-integration-test"
  {
    nativeBuildInputs = [
      php
      pkgs.python3
      pkgs.gnutar
      pkgs.openssl
    ];
  }
  ''
    mkdir -p /build/wallabag /build/wallabag-backups
    export WALLABAG_DATA=/build/wallabag
    ${prepare} > install.log 2>&1 || { cat install.log; exit 1; }
    php <<'PHP'
    <?php
    require '${cfg.services.wallabag.package}/vendor/autoload.php';
    $db = new PDO('sqlite:/build/wallabag/data/db/wallabag.sqlite');
    $user = $db->query("SELECT password, salt FROM wallabag_user WHERE username = 'wallabag'")->fetch(PDO::FETCH_ASSOC);
    $password = trim(file_get_contents('/build/wallabag/data/initial-admin-password'));
    $encoder = new Symfony\Component\Security\Core\Encoder\MessageDigestPasswordEncoder();
    if (!$encoder->isPasswordValid($user['password'], $password, $user['salt']) ||
        $encoder->isPasswordValid($user['password'], 'wallabag', $user['salt'])) {
        throw new RuntimeException('Initial password was not randomized');
    }
    $kernel = new AppKernel('prod', false);
    $request = Symfony\Component\HttpFoundation\Request::create('https://les.example.test/login');
    $response = $kernel->handle($request);
    if ($response->getStatusCode() !== 200 || !str_contains($response->getContent(), '_csrf_token')) {
        throw new RuntimeException('Login page did not render');
    }
    $kernel->terminate($request, $response);
    PHP
    openssl req -x509 -newkey rsa:2048 -nodes -days 1 -subj /CN=les.example.test \
      -keyout /build/test-key.pem -out /build/test-cert.pem 2>/dev/null
    cat > /build/php-fpm.conf <<'FPM'
    [global]
    daemonize = no
    error_log = /build/fpm.log
    [wallabag]
    listen = /build/wallabag.sock
    pm = static
    pm.max_children = 1
    env[WALLABAG_DATA] = /build/wallabag
    FPM
    mkdir -p /build/nginx/logs
    python3 <<'PY'
    import http.client, pathlib, ssl, subprocess, time
    config = pathlib.Path('${cfg.environment.etc."nginx/nginx.conf".source}').read_text()
    config = config.replace('/run/nginx/nginx.pid', '/build/nginx.pid')
    config = config.replace('100.64.0.1:443', '127.0.0.2:18443')
    config = config.replace('allow 100.64.0.0/10;', 'allow 127.0.0.0/8;')
    config = config.replace('/run/phpfpm/wallabag.sock', '/build/wallabag.sock')
    config = config.replace('http {', """http {
        access_log off;
        client_body_temp_path /build/nginx/client_temp;
        proxy_temp_path /build/nginx/proxy_temp;
        fastcgi_temp_path /build/nginx/fastcgi_temp;
        uwsgi_temp_path /build/nginx/uwsgi_temp;
        scgi_temp_path /build/nginx/scgi_temp;
    """)
    pathlib.Path('/build/nginx.conf').write_text(config)
    pathlib.Path('/build/wallabag/web/assets/images/test.png').write_bytes(b'image-fixture')
    context = ssl._create_unverified_context()
    def request(address, path):
        client = http.client.HTTPSConnection(address, 18443, context=context, timeout=5)
        client.request('GET', path, headers={'Host': 'les.example.test'})
        response = client.getresponse()
        result = response.status, response.read()
        client.close()
        return result
    fpm = subprocess.Popen(['${php}/bin/php-fpm', '-y', '/build/php-fpm.conf'])
    nginx = subprocess.Popen(['${cfg.services.nginx.package}/bin/nginx', '-e', 'stderr', '-p', '/build/nginx/', '-c', '/build/nginx.conf'])
    try:
        for attempt in range(100):
            try:
                status, body = request('127.0.0.2', '/login')
                if status == 200:
                    break
            except (OSError, http.client.HTTPException):
                pass
            time.sleep(0.1)
        else:
            raise AssertionError('nginx/PHP-FPM login page unavailable')
        assert b'_csrf_token' in body
        assert request('127.0.0.2', '/assets/images/test.png') == (200, b'image-fixture')
        assert request('127.0.0.2', '/app_dev.php')[0] == 403
        assert request('127.0.0.2', '/uploads/import/private.json')[0] == 403
        # Supplying Wallabag's Host on another listener must not reach Wallabag.
        assert request('127.0.0.1', '/login')[0] == 418
    finally:
        for process in [nginx, fpm]:
            process.terminate()
            process.wait(timeout=10)
    PY
    cp /build/wallabag/data/secret before-secret
    cp /build/wallabag/data/initial-admin-password before-password
    ${prepare} > restart.log 2>&1 || { cat restart.log; exit 1; }
    cmp before-secret /build/wallabag/data/secret
    cmp before-password /build/wallabag/data/initial-admin-password
    # Simulate a new package path to exercise pre-migration snapshots.
    echo /nix/store/previous-wallabag > /build/wallabag/.package
    ${prepare} > upgrade.log 2>&1 || { cat upgrade.log; exit 1; }
    mkdir restored
    tar -xf /build/wallabag-backups/*.tar -C restored
    python3 <<'PY'
    import pathlib, sqlite3
    for root in [pathlib.Path('/build/wallabag'), pathlib.Path('restored')]:
        db = sqlite3.connect(root / 'data/db/wallabag.sqlite')
        assert db.execute('PRAGMA integrity_check').fetchone() == ('ok',)
        assert db.execute('SELECT COUNT(*) FROM wallabag_user').fetchone() == (1,)
        assert (root / 'data/secret').read_bytes() == pathlib.Path('before-secret').read_bytes()
        assert (root / '.initialized').exists()
    PY
    # Refuse downgrades without modifying the installed state.
    echo /nix/store/future-wallabag > /build/wallabag/.package
    echo 999.0 > /build/wallabag/.version
    if ${prepare} > downgrade.log 2>&1; then
      echo 'Unexpectedly allowed a downgrade' >&2
      exit 1
    fi
    grep -q 'downgrade refused' downgrade.log
    # Partial initialization must never silently reset an existing database.
    mv /build/wallabag /build/wallabag-complete
    mkdir -p /build/wallabag/data/db
    cp /build/wallabag-complete/data/db/wallabag.sqlite /build/wallabag/data/db/
    if ${prepare} > partial.log 2>&1; then
      echo 'Unexpectedly reinitialized a populated database' >&2
      exit 1
    fi
    grep -q 'refusing to reset' partial.log
    cmp /build/wallabag-complete/data/db/wallabag.sqlite /build/wallabag/data/db/wallabag.sqlite
    touch "$out"
  ''
