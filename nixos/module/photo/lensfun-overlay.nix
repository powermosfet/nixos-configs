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

      oldLensfunDatabase = final.fetchFromGitHub {
        owner = "lensfun";
        repo = "lensfun";
        rev = "a1510e6f33ce9bc8b5056a823c6d5bc6b8cba033";
        sha256 = "sha256-qdONyKk873Tq11M33JmznhJMAGd4dqp5KdXdVhfy/Ak=";
      };
    in
    {
      nativeBuildInputs = (oldAttrs.nativeBuildInputs or [ ]) ++ [ final.git ];

      prePatch = ''
        rm -R data/db
        python3 ${oldLensfunDatabase}/tools/lensfun_convert_db_v2_to_v1.py $TMPDIR ${lensfunDatabase}/data/db
        mkdir -p data/db
        tar xvf $TMPDIR/db/version_1.tar -C data/db
        date +%s > data/db/timestamp.txt
      '';
    }
  );
}
