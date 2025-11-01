{
  description = "Terminal disk space navigator";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    flake-utils.url = "github:numtide/flake-utils";
  };

  outputs = { self, nixpkgs, flake-utils }:
    flake-utils.lib.eachDefaultSystem (system:
      let
        pkgs = nixpkgs.legacyPackages.${system};
        cargoToml = builtins.fromTOML (builtins.readFile ./Cargo.toml);
      in
      {
        packages = {
          default = pkgs.rustPlatform.buildRustPackage {
            pname = cargoToml.package.name;
            version = cargoToml.package.version;

            src = ./.;

            cargoHash = "sha256-gDuvFFPBadeXvtOwOxHGMI3WlSZHcuLrQ5COAPKF9z4=";

            # 1 passed; 44 failed on Darwin
            doCheck = !pkgs.stdenv.hostPlatform.isDarwin;

            meta = with pkgs.lib; {
              description = "Terminal disk space navigator";
              #homepage = "https://github.com/imsnif/diskonaut";
              license = licenses.mit;
              # maintainers = with maintainers; [
              #   evanjs
              #   figsoda
              # ];
              mainProgram = "diskonaut";
            };
          };
        };

        # Development shell
        devShells.default = pkgs.mkShell {
          buildInputs = with pkgs; [
            cargo
            rustc
            rust-analyzer
            clippy
            rustfmt
          ];
        };
      }
    );
}
