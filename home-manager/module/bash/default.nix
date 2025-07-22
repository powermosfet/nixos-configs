{ ... }:

{
  programs.bash = {
    enable = true;
  };

  programs.atuin = {
    enable = true;
    enableBashIntegration = true;
    settings = {
      filter_mode_shell_up_key_binding = "session";
    };
  };
}
