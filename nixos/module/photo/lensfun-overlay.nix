final: prev: {
  lensfun = prev.lensfun.overrideAttrs (
    oldAttrs:
    let
      newerLensfunDatabase = final.fetchFromGitHub {
        owner = "lensfun";
        repo = "lensfun";
        rev = "cc4824b88dd4cf163ede74f7407b63d357350098";
        hash = "sha256-Khpjw5WC6gR0oAIhA9DCiXdcDCxsPHDozH829bPTfsg=";
      };
    in
    {
      nativeBuildInputs = (oldAttrs.nativeBuildInputs or [ ]) ++ [ final.git ];

      prePatch = ''
        rm -R data/db
        mkdir -p data/db
        cp -r ${newerLensfunDatabase}/data/db data/db
        date +%s > data/db/timestamp.txt
          
        substituteInPlace CMakeLists.txt \
          --replace-fail \
            'CMAKE_MINIMUM_REQUIRED(VERSION 2.8.12 FATAL_ERROR )' \
            'CMAKE_MINIMUM_REQUIRED(VERSION 3.12 FATAL_ERROR)'
      '';
    }
  );
}
