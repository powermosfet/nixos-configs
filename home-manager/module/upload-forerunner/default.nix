{ pkgs, ... }:

let
  api-key-file = "$HOME/.secrets/workout-tracker/api-key";
  hostname = import ../../../nixos/module/workout-tracker/hostname.nix;
  basename = "${pkgs.coreutils}/bin/basename";
  curl = "${pkgs.curl}/bin/curl";
  cat = "${pkgs.coreutils}/bin/cat";
  cp = "${pkgs.coreutils}/bin/cp";
in
{
  systemd.user.services.upload-forerunner = {
    Unit = {
      Description = "Upload new .fit files to workout-tracker";
    };
    Install = {
      WantedBy = [ "default.target" ];
    };
    Service = {
      Type = "oneshot";
      ExecStart = "${pkgs.writeShellScript "upload-forerunner" ''
        	#! ${pkgs.stdenv.shell}

                mount_dir=/run/media/asmund/GARMIN
                forerunner_dir=$mount_dir/GARMIN/Activity
                nextcloud_dir=/home/asmund/Documents/Treningslogg
                
                # Loop through each file in the source directory
                for file in "$forerunner_dir/"*; do
                  # Get the base name of the file
                  filename=$(${basename} "$file")
                  
                  # Check if the file already exists in the destination directory
                  if [ -e "$nextcloud_dir/$filename" ]; then
                      echo "Skipping $filename: already exists in $nextcloud_dir."
                  else
                    echo "Uploading $filename"
                    ${curl} -fsSL -o /dev/null "https://${hostname}/api/v1/import/generic?api-key=$(${cat} ${api-key-file})&name=$filename" --data-binary @"$file"
                    
                    if [ $? -eq 0 ]; then
                      ${cp} "$file" "$nextcloud_dir/"
                      echo "Copied $filename to $nextcloud_dir."
                    else
                      echo "Error occurred while uploading $filename."
                    fi
                  fi
                done
      ''}";
    };
  };
}
