{
    description = "My CLI tools and programs";

    inputs = {
        nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";
    };

    outputs = { self, nixpkgs }:
        let
            systems = [
                "x86_64-linux"
                "aarch64-linux"
                "x86_64-darwin"
                "aarch64-darwin"
            ];

            forEachSystem = f:
                nixpkgs.lib.genAttrs systems (
                    system:
                    f {
                        inherit system;
                        pkgs = import nixpkgs {
                            inherit system;
                            config.allowUnfree = true;
                        };
                    }
                );
        in {
            packages = forEachSystem ({ pkgs, ... }: {
                default = pkgs.buildEnv {
                    name = "my-packages";
                    # PACKAGE MANAGEMENT
                    # ==================
                    # Search for package names at https://search.nixos.org/packages?channel=unstable
                    #
                    # First time setup
                    #   nix profile add .\#default
                    #
                    # After editing this file:
                    #
                    #   - Add/remove packages:
                    #     nix profile upgrade chezmoi
                    #
                    #   - Update to latest nixpkgs (newer package versions):
                    #     nix flake update
                    #     nix profile upgrade chezmoi
                    paths = with pkgs; [
                        # ripgrep
                        # fd
                        # jq
                        # fzf
                        # bat
                        # git
                        neovim
                        direnv
                        fd
                    ];
                };
            });

            devShells = forEachSystem ({ pkgs, ... }: {
                default = pkgs.mkShell {
                    # Don't use this shellHook if paired with direnv because it
                    # enters an infinite loop. direnv already drops you into
                    # a subshell of whatever you're using. If using `nix
                    # develop`, then uncomment, since develop only supports
                    # starting a bash shell.
                    # shellHook = ''
                    #     exec zsh
                    # '';
                    packages = with pkgs; [
                        lua-language-server
                        stylua
                    ];
                };
            });
        };
}
# vim: set foldlevel=10:
