# Requirements

## `image.nvim`

- Install `imagemagick` and `pkg-config`

If on macOS, add the following to your shell environment

```bash
# Fix imagemagick path
export DYLD_LIBRARY_PATH="$(brew --prefix)/lib:$DYLD_LIBRARY_PATH"
```

See [this repo](https://github.com/etiennecollin/dotfiles) to install the required packages
