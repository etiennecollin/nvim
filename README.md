# Requirements

## Instructions

Start by installing the main packages, then install the other packages.

## Packages

- Arch Linux: `yay -Syu ripgrep sioyek imagemagick luarocks`
- macOS: `brew install ripgrep sioyek pngpaste imagemagick luarocks gnu-sed`
- [`typstfmt`](https://github.com/astrale-sharp/typstfmt) is required by
  `typst-lsp` to format code. See repo for intall instructions.

> - `ripgrep` is required by `telescope` for word finding.
> - `sioyek` is required by `vimtex` and `typst.vim` for file preview.
> - `pngpaste` is optionally required by `img-clip`.
> - `imagemagick luarocks` are required by `image.nvim` used by `molten-nvim`.
> - `gnu-sed` is required by `nvim-spectre`.

## Other

- `luarocks --local --lua-version=5.1 install magick`
- `pip install neovim pynvim jupyter_client cairosvg pnglatex plotly kaleido pyperclip nbformat`

> - `magick` is required by `image.nvim` for `molten-nvim`
> - `pynvim jupyter_client cairosvg pnglatex plotly kaleido pyperclip nbformat` are required by `molten-nvim`
