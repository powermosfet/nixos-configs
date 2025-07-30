{ pkgs, config }:

let
  device-path = "/dev/disk/by-label/GARMIN";
  cfg = config.services.upload-forerunner;
  api-key-file = cfg.api-key-file;
  backup-dir = cfg.backup-dir;
  workout-tracker-hostname = import ../../../nixos/module/workout-tracker/hostname.nix;
  basename = "${pkgs.coreutils}/bin/basename";
  curl = "${pkgs.curl}/bin/curl";
  cat = "${pkgs.coreutils}/bin/cat";
  cp = "${pkgs.coreutils}/bin/cp";
  udisksctl = "${pkgs.udisks}/bin/udisksctl";
  notify-send = "${pkgs.libnotify}/bin/notify-send";
  grep = "${pkgs.gnugrep}/bin/grep";
in
''
  #! ${pkgs.stdenv.shell}

  ${notify-send} "Forerunner Auto-Upload" "Starting upload from forerunner..." --icon=dialog-information

  mount_dir=/run/media/asmund/GARMIN
  forerunner_dir=$mount_dir/GARMIN/Activity

  # Loop through each file in the source directory
  for file in "$forerunner_dir/"*; do
    # Get the base name of the file
    filename=$(${basename} "$file")
                
    # Check if the file already exists in the destination directory
    if [ -e "${backup-dir}/$filename" ]; then
      echo "Skipping $filename: already exists in ${backup-dir}."
    else
      echo "Uploading $filename"
      ${notify-send} "Forerunner Auto-Upload" "Uploading $filename" --icon=dialog-information
      ${curl} -fsSL -o /dev/null "https://${workout-tracker-hostname}/api/v1/import/generic?api-key=$(${cat} ${api-key-file})&name=$filename" --data-binary @"$file"

      if [ $? -eq 0 ]; then
        ${cp} "$file" "${backup-dir}/"
        echo "Copied $filename to ${backup-dir}."
      else
        echo "Error occurred while uploading $filename."
        ${notify-send} "Forerunner Auto-Upload" "Error occurred while uploading $filename." --icon=dialog-information
      fi
    fi
  done

  # Send completion notification
  ${notify-send} "Forerunner Auto-Upload" "Upload completed" --icon=dialog-information
''
