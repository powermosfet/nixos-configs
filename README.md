NixOS configs
=============

Config files for NixOS.

You can use this repo as a channel:

    # nix-channel --add https://github.com/powermosfet/nixos-configs/archive/main.tar.gz sharedconfig
    # nix-channel --update

Now you can import it like this:

    # configuration.nix
    { config, pkgs, ... }:

    let
      sharedConfig = import <sharedconfig> {};
    in
    {
      imports =
        [ ./hardware-configuration.nix
	  sharedConfig.machine.mook
	];
    
    ...
