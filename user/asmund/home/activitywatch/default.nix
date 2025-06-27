{ pkgs, ... }:

{
  services.activitywatch = {
    enable = true;

    watchers = {
      aw-watcher-afk = {
        package = pkgs.activitywatch;
        settings = {
          timeout = 300;
          poll_time = 2;
        };
      };
    };
  };
}
