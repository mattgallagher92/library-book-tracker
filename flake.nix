{
  description = "Development environment for Library Book Tracker";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-24.11";
  };

  outputs = { self , nixpkgs ,... }: let
    system = "x86_64-linux";
  in {
    devShells."${system}".default = let
      pkgs = import nixpkgs {
        inherit system;
      };
    in pkgs.mkShell {
      packages = with pkgs; [
        go
        go-migrate
        docker
        gnumake
        cassandra
        protobuf
        protoc-gen-go
        protoc-gen-go-grpc
      ];

      shellHook = ''
        make --version | head -n 1
        go version
        docker --version
        cqlsh --version
        protoc --version
        protoc-gen-go --version
        protoc-gen-go-grpc --version
      '';
    };
  };
}
