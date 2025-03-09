{ pkgs, config, lib, ... }:

  with lib;

let
  upload-forerunner-script = pkgs.writeScript "upload-forerunner.sh" ''
    #! ${pkgs.stdenv.shell}

    mount_dir=/mnt/GARMIN
    forerunner_dir=$mount_dir/GARMIN/Activity
    nextcloud_dir=/home/asmund/Documents/Treningslogg

    mount /dev/disk/by-id/usb-Garmin_FR55_Flash-0:0 $mount_dir
    
    cd $forerunner_dir
    
    for filename in *; 
    do if [ -f $nextcloud_dir/$filename ]; then
       echo "Skipping $filename"
    else
       ${pkgs.coreutils-full}/bin/cp $filename nextcloud_dir/$filename
       ${pkgs.curl}/bin/curl -sSL -H "Authorization: bearer $(${pkgs.coreutils-full}/bin/cat ${config.services.workout-tracker.api-key-file})"  https://trening.berge.id/api/v1/import/generic --data @$filename
       echo "Uploading $filename"
    fi
    done

    cd /
    umount $mount_dir
    
    echo "I am running as $USER"
    '';
in
{
  imports =
    [
    ];

  options = {
    services.workout-tracker = {
      api-key-file = mkOption {
        description = "API key";
        type = types.str;
      };
    };
  };

  config = {
    services.udev.extraRules = ''
        SUBSYSTEM=="usb", ACTION=="add", ENV{ID_VENDOR_ID}=="091e", ENV{ID_MODEL_ID}=="0f1d", RUN+="${upload-forerunner-script}"
    '';
  };
}
