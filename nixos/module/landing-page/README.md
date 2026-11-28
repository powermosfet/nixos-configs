# Landing page

On mook, nginx serves `https://www.berge.id` from `/var/www/landing-page`.
Put an `index.html` and any other public static files in that directory. Files
must be readable by nginx, and parent directories must be traversable by nginx.
The module creates the directory but does not populate it.

To use a different directory:

```nix
services.landing-page.root = "/srv/www/landing-page";
```

`services.landing-page.domain` defaults to `www.berge.id`. The module registers
that domain with the existing ddclient configuration and enables an ACME
certificate with HTTP redirected to HTTPS. Configure the domain's DNS to point
at mook and forward TCP ports 80 and 443 to it if it is behind a router.

Only static files are served; missing paths return 404 and directory listings
are disabled. Changes to files in the directory do not require a rebuild.
