final: prev:

let
  #  git log -1 --format=%H
  rev = "cc4824b88dd4cf163ede74f7407b63d357350098";
  #  git log -1 --format=%ad --date=raw -- *.xml
  timestamp = "1764957575";
  newerLensfunDatabase = final.fetchFromGitHub {
    owner = "lensfun";
    repo = "lensfun";
    rev = rev;
    hash = "sha256-Khpjw5WC6gR0oAIhA9DCiXdcDCxsPHDozH829bPTfsg=";
  };
  generateDbPy = final.writeText "convert_lensfun_db.py" ''
    import argparse
    import glob
    import os
    import subprocess
    import sys

    sys.path.append('${newerLensfunDatabase}/tools/update_database')

    import xml_converter

    # Generates files needed for updating lensfun data with "lensfun-update-data".

    if __name__ == "__main__":
        parser = argparse.ArgumentParser(description="Generate files for the Lensfun database updates "
                                                     "(tar balls for all Lensfun versions).")
        parser.add_argument("-i", "--input", default="data/db/", help="input folder containing XML files")
        parser.add_argument("-o", "--output", default="db/", help="output folder for generated db")
        args = parser.parse_args()

        xml_filenames = glob.glob(os.path.join(args.input, "*.xml"))
        xml_files = set(xml_converter.XMLFile(filename) for filename in xml_filenames)

        xml_converter.generate_database_tarballs(xml_files, ${timestamp}, args.output)
  '';
in
{
  lensfun = prev.lensfun.overrideAttrs (oldAttrs: {
    nativeBuildInputs = (oldAttrs.nativeBuildInputs or [ ]) ++ [
      final.python3Packages.lxml
    ];

    prePatch = ''
      rm -R data/db
      python3 ${generateDbPy} -i ${newerLensfunDatabase}/data/db -o $TMPDIR/db
      mkdir -p data/db
      tar xvf $TMPDIR/db/version_1.tar.bz2 -C data/db
      date +%s > data/db/timestamp.txt
        
      substituteInPlace CMakeLists.txt \
        --replace-fail \
          'CMAKE_MINIMUM_REQUIRED(VERSION 2.8.12 FATAL_ERROR )' \
          'CMAKE_MINIMUM_REQUIRED(VERSION 3.12 FATAL_ERROR)'
    '';
  });
}
