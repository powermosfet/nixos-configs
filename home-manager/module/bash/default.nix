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

  programs.starship = {
    enable = true;
    enableBashIntegration = true;
    settings = {
      character = {
        success_symbol = "[𝄞](bold green) ";
        error_symbol = "[𝄞](bold yellow) ";
      };
    };
  };
}
