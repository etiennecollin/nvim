--------------------------------------------------------------------------------
-- Set terminal windows title
--------------------------------------------------------------------------------
vim.opt.title = true
vim.opt.titlestring = "nvim: %t"

--------------------------------------------------------------------------------
-- Set termguicolors to enable highlight groups
--------------------------------------------------------------------------------
vim.g.have_nerd_font = true
vim.opt.termguicolors = true
vim.opt.background = require("etiennecollin.config").background_style

--------------------------------------------------------------------------------
-- Set floating window border
--------------------------------------------------------------------------------
vim.opt.winborder = "rounded"
vim.opt.pumborder = "rounded"

--------------------------------------------------------------------------------
-- Vim ui2
--------------------------------------------------------------------------------
require("vim._core.ui2").enable({
  enable = true,

  msg = {
    targets = {
      empty = "cmd", -- Empty message (`:echo ""`), with empty `content`. Should clear messages sharing the 'cmdheight' area if it is the only message in a batch.
      bufwrite = "cmd", -- |:write| message
      confirm = "dialog", -- Message preceding a prompt (|:confirm|, |confirm()|, |inputlist()|, |z=|, …)
      emsg = "msg", -- Error (|errors|, internal error, |:throw|, …)
      echo = "msg", -- |:echo| message
      echomsg = "msg", -- |:echomsg| message
      echoerr = "msg", -- |:echoerr| message
      completion = "cmd", -- |ins-completion-menu| message
      list_cmd = "pager", -- List output for various commands (|:ls|, |:set|, …)
      lua_error = "pager", -- Error in |:lua| code
      lua_print = "msg", -- |print()| from |:lua| code
      progress = "msg", -- Progress message emitted by |nvim_echo()|
      rpc_error = "pager", -- Error response from |rpcrequest()|
      quickfix = "cmd", -- Quickfix navigation message
      search_cmd = "cmd", -- Entered search command
      search_count = "cmd", -- Search count message ("S" flag of 'shortmess')
      shell_cmd = "cmd", -- |:!cmd| executed command
      shell_err = "pager", -- |:!cmd| shell stderr output
      shell_out = "pager", -- |:!cmd| shell stdout output
      shell_ret = "msg", -- |:!cmd| shell return code
      undo = "cmd", -- |:undo| and |:redo| message
      verbose = "cmd", -- 'verbose' message
      wildlist = "cmd", -- 'wildmode' "list" message
      wmsg = "msg", -- Warning ("search hit BOTTOM", |W10|, …)
    },
    cmd = {
      height = 0.5,
    },
    dialog = {
      height = 0.5,
    },
    msg = {
      height = 0.5,
      timeout = 2000,
    },
    pager = {
      height = 1,
    },
  },
})

--------------------------------------------------------------------------------
-- Set diagnostics
--------------------------------------------------------------------------------
vim.opt.signcolumn = "yes:1"

-- Set the signs for diagnostics
local s = vim.diagnostic.severity
vim.diagnostic.config({
  virtual_text = {
    severity = { min = vim.diagnostic.severity.WARN },
    spacing = 4,
    source = "if_many",
    prefix = "●",
  },

  -- virtual_lines = { current_line = true },
  update_in_insert = true,
  underline = true,
  severity_sort = true,
  float = {
    focusable = false,
    style = "minimal",
    border = "rounded",
    source = "if_many",
    header = "",
    prefix = "",
  },
  signs = {
    text = {
      [s.ERROR] = " ",
      [s.WARN] = " ",
      [s.INFO] = " ",
      [s.HINT] = "󰌵 ",
    },
    linehl = {
      [s.ERROR] = "DiagnosticSignError",
      [s.WARN] = "DiagnosticSignWarn",
      [s.INFO] = "DiagnosticSignInfo",
      [s.HINT] = "DiagnosticSignHint",
    },
    numhl = {
      [s.ERROR] = "",
      [s.WARN] = "",
      [s.INFO] = "",
      [s.HINT] = "",
    },
  },
})

--------------------------------------------------------------------------------
-- Set symbols for whitespace characters
--------------------------------------------------------------------------------
vim.opt.list = true
vim.opt.listchars = {
  nbsp = "␣", -- Show zero-width space
  tab = "  ", -- Make sure tab doesn't show as I
  trail = "·", -- Show trailing whitespace
}

-- Set fillchars for both vertical and horizontal split separators
vim.opt.fillchars = {
  vert = "│",
  horiz = "─",
  horizup = "┴",
  horizdown = "┬",
  verthoriz = "┼",
}

--------------------------------------------------------------------------------
-- Set global statusine
--------------------------------------------------------------------------------
vim.opt.laststatus = 3

--------------------------------------------------------------------------------
-- Set cursor options and line highlighting
--------------------------------------------------------------------------------
vim.opt.guicursor = "n-v-c-sm:block,i-ci-ve:ver25,r-cr-o:hor20"
vim.opt.cursorline = true
-- Only highlight the line number in the cursor line
vim.opt.cursorlineopt = "both"
vim.opt.colorcolumn = { "80", "120" }

--------------------------------------------------------------------------------
-- Enable incrementing hex, octal and bin numbers, and letters
--------------------------------------------------------------------------------
vim.opt.nrformats = { "alpha", "bin", "blank", "hex", "octal" }

--------------------------------------------------------------------------------
-- Enable numbers and relative numbers
--------------------------------------------------------------------------------
vim.opt.number = true
vim.opt.numberwidth = 3
vim.opt.relativenumber = false

--------------------------------------------------------------------------------
-- Set indentation
--------------------------------------------------------------------------------
vim.opt.tabstop = 4
vim.opt.softtabstop = 0 -- Set to 0 to match tabstop
vim.opt.shiftwidth = 0 -- Set to 0 to match tabstop
vim.opt.expandtab = true -- Use spaces instead of tabs

vim.g.markdown_recommended_style = 0 -- Use our own config instead of the recommended one

vim.opt.autoindent = true
vim.opt.smartindent = true

-- << and >> shift to the nearest tabstop
vim.opt.shiftround = true

vim.opt.virtualedit = "block"

--------------------------------------------------------------------------------
-- Set search options
--------------------------------------------------------------------------------
vim.opt.ignorecase = true
vim.opt.smartcase = true

vim.opt.hlsearch = true
vim.opt.incsearch = true

--------------------------------------------------------------------------------
-- Substitution
--------------------------------------------------------------------------------
vim.opt.inccommand = "nosplit"

--------------------------------------------------------------------------------
-- Set how splits open
--------------------------------------------------------------------------------
vim.opt.splitbelow = true
vim.opt.splitright = true

--------------------------------------------------------------------------------
-- Enable line wrapping and conceallevel
--------------------------------------------------------------------------------
vim.opt.wrap = true
vim.opt.linebreak = true
vim.opt.breakindent = true
vim.opt.showbreak = "↪"
vim.opt.conceallevel = 0

--------------------------------------------------------------------------------
-- Enable hidden buffers
--------------------------------------------------------------------------------
vim.opt.hidden = true

--------------------------------------------------------------------------------
-- Backup and undo settings
--------------------------------------------------------------------------------
vim.opt.backup = false
vim.opt.undofile = true
vim.opt.undolevels = 10000
-- vim.opt.swapfile = false
-- vim.opt.undodir = os.getenv("HOME") .. "/.vim/undodir"

--------------------------------------------------------------------------------
-- Setup folds
--------------------------------------------------------------------------------
vim.opt.foldtext = ""
vim.opt.foldcolumn = "0"
vim.opt.foldenable = false
vim.opt.foldlevel = 99
vim.opt.foldmethod = "indent"

--------------------------------------------------------------------------------
-- Scrolloff settings
--------------------------------------------------------------------------------
vim.opt.scrolloff = 10
vim.opt.sidescrolloff = 5

--------------------------------------------------------------------------------
-- Saving
--------------------------------------------------------------------------------
vim.opt.autoread = true
vim.opt.autowrite = true

--------------------------------------------------------------------------------
-- Command timeout (used for WhichKey)
--------------------------------------------------------------------------------
vim.opt.timeout = true
vim.opt.timeoutlen = 500
vim.opt.ttimeout = true
vim.opt.ttimeoutlen = 0

--------------------------------------------------------------------------------
-- Other settings
--------------------------------------------------------------------------------
vim.opt.isfname:append("@-@")
vim.opt.updatetime = 500
vim.opt.redrawtime = 1000
vim.opt.showcmd = false
vim.opt.cmdheight = 0
vim.opt.confirm = true
vim.opt.completeopt = "menu,menuone,noselect,popup"
vim.opt.shortmess = "atToOCF"

--------------------------------------------------------------------------------
-- Neovide
--------------------------------------------------------------------------------
if vim.g.neovide then
  vim.opt.guifont = "Maple Mono NF:h14"
  vim.g.neovide_scale_factor = 1.0
  vim.g.neovide_hide_mouse_when_typing = false
  vim.g.neovide_fullscreen = false
  vim.g.neovide_remember_window_size = true
  vim.g.neovide_input_macos_option_key_is_meta = "only_left"

  local change_scale_factor = function(delta)
    vim.g.neovide_scale_factor = vim.g.neovide_scale_factor * delta
  end
  vim.keymap.set("n", "<C-=>", function()
    change_scale_factor(1.25)
  end)
  vim.keymap.set("n", "<C-->", function()
    change_scale_factor(1 / 1.25)
  end)
  vim.keymap.set({ "n", "v" }, "<c-s-c>", '"+y', {
    desc = "Yank selection to system clipboard",
  })
  vim.keymap.set({ "n", "v" }, "<c-r>", '"+p', {
    desc = "Paste from system clipboard",
  })
  vim.keymap.set("i", "<c-s-v>", "<c-r>+", {
    desc = "Paste from system clipboard",
  })
end
