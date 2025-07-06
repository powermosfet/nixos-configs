{
  pkgs,
  lib,
  config,
  ...
}:

with lib;

let
  api-key-file = config.services.upload-forerunner.api-key-file;
  hostname = import ../../../nixos/module/workout-tracker/hostname.nix;
  basename = "${pkgs.coreutils}/bin/basename";
  curl = "${pkgs.curl}/bin/curl";
  cat = "${pkgs.coreutils}/bin/cat";
  cp = "${pkgs.coreutils}/bin/cp";
  udisksctl = "${pkgs.udisks}/bin/udisksctl";
  notify-send = "${pkgs.libnotify}/bin/notify-send";
  grep = "${pkgs.gnugrep}/bin/grep";
in
{
  options = {
    services.upload-forerunner = {
      api-key-file = mkOption {
        type = types.str;
        description = "Path to the api secret file";
        default = "~/api-key";
      };
    };
  };

  config = {
    systemd.user.services.upload-forerunner = {
      Unit = {
        Description = "Upload new .fit files to workout-tracker";
        After = [ "graphical-session.target" ];
      };
      Service = {
        Type = "oneshot";
        ExecStart = "${pkgs.writeShellScript "upload-forerunner" ''
          	#! ${pkgs.stdenv.shell}

                  ${notify-send} "Forerunner Auto-Upload" "Starting upload from forerunner..." --icon=dialog-information

                  device_path="/dev/disk/by-label/GARMIN"
                  mount_dir=$(${udisksctl} mount -b "$device_path" --no-user-interaction | ${grep} -oP 'Mounted .* at \K.*')
                  forerunner_dir=$mount_dir/GARMIN/Activity
                  nextcloud_dir=/home/asmund/Documents/Treningslogg

                  echo "device_path=$device_path"
                  echo "mount_dir=$mount_dir"
                  echo "forerunner_dir=$forerunner_dir"
                  echo "nextcloud_dir=$nextcloud_dir"
                  
                  # Loop through each file in the source directory
                  for file in "$forerunner_dir/"*; do
                    # Get the base name of the file
                    filename=$(${basename} "$file")
                    
                    # Check if the file already exists in the destination directory
                    if [ -e "$nextcloud_dir/$filename" ]; then
                        echo "Skipping $filename: already exists in $nextcloud_dir."
                    else
                      echo "Uploading $filename"
                      ${notify-send} "Forerunner Auto-Upload" "Uploading $filename" --icon=dialog-information
                      ${curl} -fsSL -o /dev/null "https://${hostname}/api/v1/import/generic?api-key=$(${cat} ${api-key-file})&name=$filename" --data-binary @"$file"
                      
                      if [ $? -eq 0 ]; then
                        ${cp} "$file" "$nextcloud_dir/"
                        echo "Copied $filename to $nextcloud_dir."
                      else
                        echo "Error occurred while uploading $filename."
                        ${notify-send} "Forerunner Auto-Upload" "Error occurred while uploading $filename." --icon=dialog-information
                      fi
                    fi
                  done

                  # Unmount the device
                  ${udisksctl} unmount -b "$device_path" --no-user-interaction

                  # Send completion notification
                  ${notify-send} "Forerunner Auto-Upload" "Upload completed and watch unmounted" --icon=dialog-information
        ''}";
      };
    };
  };
}
