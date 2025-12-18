{
  pkgs ? import <nixpkgs> { },
}:

let
  python = pkgs.python3.withPackages (
    ps: with ps; [
      requests
      pyelftools
    ]
  );
in

pkgs.mkShell {
  buildInputs = with pkgs; [
    python
    git
    cmake
    ninja
    pkg-config
    capstone_4
    fmt
    openssl
    icu72
  ];
  shellHook = ''
    export LD_LIBRARY_PATH="$LD_LIBRARY_PATH:${pkgs.capstone_4}/lib:${pkgs.icu72}/lib:${pkgs.openssl.dev}/lib"
  '';
}
