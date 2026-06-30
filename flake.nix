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
                    # First-time installation:
                    #   nix profile add .\#default
                    #
                    # After changing this file (add/remove packages):
                    #   nix profile upgrade chezmoi
                    #
                    # Update package versions:
                    #   nix flake update
                    #   nix profile upgrade chezmoi
                    #
                    # Revert package versions:
                    #   git restore flake.lock
                    #   nix profile upgrade chezmoi
                    #
                    paths = with pkgs; [
                        # Automatic loading and unloading for env variables
                        # depending on current directory. Paired with nix-direnv
                        # implementation which is significantly faster by caching.
                        # https://direnv.net/
                        # https://github.com/nix-community/nix-direnv
                        direnv
                        nix-direnv

                        # These are not included in Arch by default
                        # man
                        # man-pages

                        neovim   # my beloved
                        chezmoi  # dotfiles management
                        zk       # Notes
                        ripgrep  # grep but respects .gitignore
                        fzf      # fuzzy finder
                        bat      # better cat
                        fd       # faster and more intuitive find
                        sd       # easier sed
                        jq       # json processor
                        tmux     # terminal multiplexer.
                        tealdeer # tldr for man pages
                        gron     # Make JSON greppable
                        btop     # monitor resources
                        age      # encryption tool
                        ouch     # compressing and decompressing various formats
                        tinyxxd  # Hex dump

                        # Git stuff
                        git
                        lazygit
                        jujutsu
                        delta # Syntax-highlighting pager for git

                        # Used for backups and some other scripts
                        rsync      # Fast incremental file transfer utility
                        restic     # Fast, secure, efficient backup program
                        borgbackup # Deduplicating archiver with compression and encryption
                        # rclone     # sync files and directories to and from major cloud storage

                        # Download media from internet
                        yt-dlp
                        gallery-dl

                        # containers
                        podman
                        distrobox

                        nodejs-slim

                        # Stuff I sometimes need.
                        # `nix shell nixpkgs\#whatineed`
                        # tokei - Count lines of code
                        # single-file-cli - Save a webpage in a single HTML file
                        # mediainfo -  Information about media files
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
