{
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";
    utils.url = "github:numtide/flake-utils";
  };

  outputs =
    { nixpkgs, utils, ... }:
    utils.lib.eachDefaultSystem (
      system:
      let pkgs = nixpkgs.legacyPackages.${system};
      in {
        packages.default = pkgs.python3Packages.buildPythonApplication {
          name = "scribe";
          src = ./.;

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
