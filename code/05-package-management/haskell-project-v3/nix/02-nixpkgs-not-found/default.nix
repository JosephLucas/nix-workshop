let
  sources = import ../sources.nix {};
  nixpkgs = import sources.nixpkgs {};

  hsLib = nixpkgs.haskell.lib;
  hsPkgs-original = nixpkgs.haskell.packages.ghc8102;

  hsPkgs = hsPkgs-original.override {
    overrides = hsPkgs-old: hsPkgs-new: {
      QuickCheck = hsPkgs-new.callHackage "QuickCheck" "2.14.2" {};
    };
  };

  src = builtins.path {
    name = "haskell-project-src";
    path = ../../haskell;
    filter = path: type:
      let
        basePath = builtins.baseNameOf path;
      in
      basePath != "dist-newstyle"
    ;
  };

  project = hsPkgs.callCabal2nix "haskell-project" src;
in
hsPkgs.callPackage project {}
