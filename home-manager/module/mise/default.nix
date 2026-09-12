{ pkgsUnstable, ... }:
{
  programs.mise = {
    enable = true;
    package = pkgsUnstable.mise;
    enableZshIntegration = true;
  };
}
