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
      in
      {
        packages = {
          default = pkgs.rustPlatform.buildRustPackage {
            pname = "diskonaut";
            version = "0.11.0";

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
