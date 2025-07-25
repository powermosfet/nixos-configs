{ pkgs, ... }:

{
  programs.yazi = {
    enable = true;

    plugins = with pkgs.yaziPlugins; {
      duckdb = duckdb;
      starship = starship;
      mount = mount;
      diff = diff;
      git = git;
    };
  };
}
