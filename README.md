# Dependencies

- `curl git gzip luarocks node npm pkg-config python tar unzip wget`
- `sudo apt install python-neovim python3-neovim`
- `sudo pacman -S python-pynvim`

## Treesitter

- `tree-sitter-cli tar curl`

## Grug-Far

- `ast-grep ripgrep`

## Snacks

- `Snacks.dashboard` **optionally** requires `chafa` to display images
- `Snacks.image` requires `imagemagick` for images and **optionally** `mmdc` for mermaid diagrams
- `Snacks.lazygit` requires `lazygit`
- `Snacks.picker` requires `ripgrep fd`

## Rustaceanvim

- `rust-analyzer` with `rustup component add rust-analyzer`

## Markdown Preview

To locally render plantuml diagrams embedded in markdown documents, a local plantuml must be running on port 8091. You may start one with:

```sh
docker run --restart "unless-stopped" -d -p 8091:8080 plantuml/plantuml-server:jetty
```
