final: prev: {
  lensfun = prev.lensfun.overrideAttrs (
    oldAttrs:
    let
      lensfunDatabase = final.fetchFromGitHub {
        owner = "lensfun";
        repo = "lensfun";
        rev = "c1ce461e8f61cdc65dff7a636469467992964873";
        hash = "sha256-4bUmyh6zKL/bOe7GX/3HPe82NRmcUlelFWi2E1M2AjI=";
      };
    in
    {
      nativeBuildInputs = (oldAttrs.nativeBuildInputs or [ ]) ++ [ final.git ];

      prePatch = ''
        rm -R data/db
        mkdir -p data/db
        cp -R ${lensfunDatabase}/data/db data/db
        date +%s > data/db/timestamp.txt
      '';
    }
  );
}
