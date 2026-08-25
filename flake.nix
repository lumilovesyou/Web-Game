# flake.nix
{
  description = "Web Game's Flake";
  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
  };
  outputs =
    { self, nixpkgs }:
    let
      system = "x86_64-linux";
      pkgs = nixpkgs.legacyPackages.${system};
      runtimeLibs = [
        pkgs.raylib
        pkgs.libGL
        pkgs.libX11
        pkgs.libXcursor
        pkgs.libXrandr
        pkgs.libXi
        pkgs.libXinerama
        pkgs.wayland
        pkgs.libxkbcommon
      ];
    in
    {
      devShells.${system}.default = pkgs.mkShell {
        name = "python-dev-shell";
        packages = [
          pkgs.python3
          pkgs.ruff
        ]
        ++ runtimeLibs;
        shellHook = ''
          if [ ! -d ".venv" ]; then
            python -m venv .venv
            echo "Created .venv"
          fi
          source .venv/bin/activate
          export LD_LIBRARY_PATH="${pkgs.lib.makeLibraryPath runtimeLibs}:$LD_LIBRARY_PATH"
        '';
      };
    };
}
