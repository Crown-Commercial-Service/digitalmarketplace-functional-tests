{
  pkgs ? import <nixpkgs> {}
}:
{
  digitalMarketplaceFunctionalTestsEnv = (pkgs.bundlerEnv {
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
  });
}
