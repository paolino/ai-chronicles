# Justfile for ai-chronicles

# Serve docs locally
serve:
    nix develop -c mkdocs serve

# Build docs
build:
    nix build .#docs

# Enter dev shell
dev:
    nix develop
