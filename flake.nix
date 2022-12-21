{
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";
    utils.url = "github:numtide/flake-utils";
  };

  outputs =
    { nixpkgs, utils, ... }:
    utils.lib.eachDefaultSystem (
      system:
      let
        pkgs = nixpkgs.legacyPackages.${system};

        modelVersion = "aa6ac1e23bb9a499be2b7400079cd2a7b8a1309a";
        model = pkgs.linkFarmFromDrvs "opt-1.3b" [
          (pkgs.fetchurl {
            url = "https://huggingface.co/facebook/opt-1.3b/resolve/${modelVersion}/merges.txt";
            sha256 = "HOFmR3PFDz4MyIQmGak+3EYkUltyixiKngvjO3cmrcU=";
          })
          (pkgs.fetchurl {
            url = "https://huggingface.co/facebook/opt-1.3b/resolve/${modelVersion}/config.json";
            sha256 = "8arO77fTTTRumwQA2V/bSXBWe8vh1KuhBoxUAgmbZE8=";
          })
          (pkgs.fetchurl {
            url = "https://huggingface.co/facebook/opt-1.3b/resolve/${modelVersion}/pytorch_model.bin";
            sha256 = "z31clw1t29OwMAmzl8BCLhR+3VyAINR6jS+sCxGjsI0=";
          })
          (pkgs.fetchurl {
            url = "https://huggingface.co/facebook/opt-1.3b/resolve/${modelVersion}/tokenizer_config.json";
            sha256 = "0eQYW0OgoGQhq3IY1cGndTUL0TAkUHs0++0l3PbBTGs=";
          })
          (pkgs.fetchurl {
            url = "https://huggingface.co/facebook/opt-1.3b/resolve/${modelVersion}/vocab.json";
            sha256 = "BrTUbI51LUECE9lUjrJ6VNtw/aAxm2Jx+41Z3q1eHKs=";
          })
        ];

      in {
        packages.default = pkgs.python3Packages.buildPythonApplication {
          name = "scribe";
          src = ./.;

          postPatch = ''
            substituteInPlace scribe/__main__.py \
              --replace facebook/opt-1.3b ${model}
          '';

          nativeBuildInputs = with pkgs; [ gobject-introspection wrapGAppsHook ];
          buildInputs = with pkgs; [ gtk4 libadwaita ];
          propagatedBuildInputs = with pkgs.python3Packages; [ pygobject3 torch transformers ];

          postInstall = ''
            mkdir -p $out/share/applications
            cp ${./me.danth.Scribe.desktop} $out/share/applications/me.danth.Scribe.desktop
            substituteInPlace $out/share/applications/me.danth.Scribe.desktop \
              --replace /usr/bin/scribe $out/bin/scribe
          '';

          doCheck = false;
        };
      }
    );
}
