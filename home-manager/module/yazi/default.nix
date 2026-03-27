{ pkgs, ... }:

{
  programs.yazi = {
    enable = true;

    shellWrapperName = "y";
    plugins = with pkgs.yaziPlugins; {
      duckdb = duckdb;
      starship = starship;
      mount = mount;
      diff = diff;
      git = git;
    };
  };
}
