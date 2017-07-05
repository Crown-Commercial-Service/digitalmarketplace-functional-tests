argsOuter@{...}:
let
  # specifying args defaults in this slightly non-standard way to allow us to include the default values in `args`
  args = rec {
    pkgs = import <nixpkgs> {};
    localOverridesPath = ./local.nix;
  } // argsOuter;
in (with args; {
  digitalMarketplaceFunctionalTestsEnv = (
    (pkgs.bundlerEnv {
      name = "digitalmarketplace-functional-tests-bundler-env";

      ruby = pkgs.ruby;
      gemfile = ./Gemfile;
      lockfile = ./Gemfile.lock;
      gemset = ./gemset.nix;
    }).env.overrideAttrs (oldAttrs: oldAttrs // {
      name = "digitalmarketplace-functional-tests-env";
      buildInputs = [
        pkgs.bundler
        pkgs.bundix
        pkgs.libxml2
        pkgs.phantomjs
      ];

      # if we don't have this, we get unicode troubles in a --pure nix-shell
      LANG="en_GB.UTF-8";
    })
  ).overrideAttrs (if builtins.pathExists localOverridesPath then (import localOverridesPath args) else (x: x));
})
