{ config, pkgs, ... }:

let
  unstable = import <nixos-unstable> { };
in
{
  imports =
    [ 
    ];
     
  users.users.nure = {
    isNormalUser = true;
  };
}

